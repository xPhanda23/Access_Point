/*
  =====================================================================
   AccessPoint - Firmware ESP32 (leitor RFID + fechadura solenoide)
  =====================================================================

  Versão da montagem nova: ESP32 + RC522 + MOSFET (IRLB3034) acionando uma
  fechadura solenoide de 12 V. Não tem LCD, LEDs, buzzer nem servo - o
  feedback é todo pelo Monitor Serial (115200).

  A comunicação com o sistema (PHP + MySQL no XAMPP) é a mesma do firmware
  com LCD (AccessPoint_ESP32): o ESP32 se identifica pelo MAC, avisa que
  está online (api/heartbeat.php), verifica cartões (api/verify_card.php),
  cadastra tags pelo painel (api/enroll_card.php) e grava UID em cartão
  mágico (api/write_ack.php). Só o atuador mudou: em vez do servo, o
  GPIO 25 dá um pulso no gate do MOSFET e a fechadura libera o pino.

  O que ele faz:
    1) Conecta no Wi-Fi;
    2) A cada poucos segundos, avisa o servidor que está online e recebe de
       volta se deve entrar em "modo de cadastro" ou "modo de gravação";
    3) Fica lendo o leitor RFID RC522;
    4) Em operação normal, envia o UID para api/verify_card.php e, se o
       servidor liberar (success + open_door), dá o pulso na fechadura;
    5) Sem Wi-Fi ou com erro no servidor o acesso é NEGADO (a fechadura
       nunca abre "por padrão").

  Comando de bancada pelo Monitor Serial:  t  = pulso de teste na fechadura.

  ---------------------------------------------------------------------
  BIBLIOTECAS NECESSÁRIAS (Arduino IDE > Ferramentas > Gerenciar Bibliotecas)
  ---------------------------------------------------------------------
    - "MFRC522" (autor: GithubCommunity / miguelbalboa)
    - "ArduinoJson" (autor: Benoit Blanchon) - versão 6.x recomendada
  (LiquidCrystal I2C e ESP32Servo NÃO são necessárias nesta versão.)

  Placa (Ferramentas > Placa): "ESP32 Dev Module"

  ---------------------------------------------------------------------
  ESQUEMA DE LIGAÇÃO
  ---------------------------------------------------------------------
    RFID RC522    SDA/SS . GPIO 5
    RFID RC522    RST .... GPIO 22
    RFID RC522    SCK .... GPIO 18
    RFID RC522    MISO ... GPIO 19
    RFID RC522    MOSI ... GPIO 23
    RFID RC522 alimentado em 3V3 do ESP32 / GND comum (nunca em 5 V)

    GPIO 25 -> resistor 620R -> Gate do IRLB3034
    Gate -> resistor 10k -> GND (pull-down: mantém a fechadura desligada
                                  enquanto o ESP32 reinicia)
    Source -> GND comum
    Drain -> negativo da fechadura
    Positivo da fechadura -> + da bateria (com fusível)
    Diodo 1N5408 em paralelo com a bobina: faixa (cátodo) no + da fechadura,
    outro lado no negativo da fechadura (lado do Drain).

  ---------------------------------------------------------------------
  FORMATO DO UID DO CARTÃO
  ---------------------------------------------------------------------
  O UID é enviado em hexadecimal maiúsculo, sem separadores (ex: "C70514A2").
  =====================================================================
*/

#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <SPI.h>
#include <MFRC522.h>

// ============== CONFIGURAÇÕES (EDITE AQUI) ==============
const char* WIFI_SSID     = "Valdeci";
const char* WIFI_PASSWORD = "valdeci518481";

// IP local do computador rodando o XAMPP (descubra com "ipconfig" no
// Windows, procure por "Endereço IPv4"). O ESP32 e o PC precisam estar
// na mesma rede Wi-Fi.
const char* SERVER_HOST   = "192.168.2.101";
const int   SERVER_PORT   = 80;
// ==========================================================

// ---------------- Pinos ----------------
#define RFID_SS_PIN    5
#define RFID_RST_PIN   22
#define RFID_SCK_PIN   18
#define RFID_MISO_PIN  19
#define RFID_MOSI_PIN  23

#define PIN_TRAVA      25   // gate do MOSFET (HIGH = fechadura energizada/liberada)

// ---------------- Parâmetros de funcionamento ----------------
#define TEMPO_PULSO_TRAVA_MS          700   // tempo que a bobina fica energizada
#define INTERVALO_MIN_ACIONAMENTO_MS  2500  // pausa mínima entre pulsos (protege a bobina)
#define INTERVALO_HEARTBEAT           3000  // avisa "estou online" a cada 3s (também detecta modo de cadastro)
#define COOLDOWN_LEITURA_MS           2500  // evita ler o mesmo cartão várias vezes seguidas

MFRC522 rfid(RFID_SS_PIN, RFID_RST_PIN);

String urlVerify;
String urlHeartbeat;
String urlEnrollCard;
String urlWriteAck;

String deviceMac = "";
int    deviceId = 0;
String deviceName = "AccessPoint";

bool enrollModeAtivo = false;

// Modo de gravação de UID em cartão mágico (Gen1A/Gen2/CUID) - o operador
// define o UID no painel e aproxima um cartão regravável do leitor.
bool writeModeAtivo = false;
String writeTargetUid = "";

unsigned long ultimoHeartbeat = 0;
unsigned long ultimaLeituraMs = 0;
String ultimoUidLido = "";

unsigned long ultimoAcionamentoMs = 0;
bool jaAcionou = false;

// ---------------------------------------------------------------------
void setup() {
  // Primeira coisa: garantir a fechadura desligada. O pull-down de 10k
  // cobre o intervalo antes deste ponto (o pino fica flutuando no boot).
  pinMode(PIN_TRAVA, OUTPUT);
  digitalWrite(PIN_TRAVA, LOW);

  Serial.begin(115200);
  delay(500);
  Serial.println();
  Serial.println("========================================");
  Serial.println("[BOOT] AccessPoint ESP32 (fechadura solenoide) - iniciando...");
  Serial.println("[BOOT] GPIO25 configurado para controlar o MOSFET.");

  SPI.begin(RFID_SCK_PIN, RFID_MISO_PIN, RFID_MOSI_PIN, RFID_SS_PIN);
  rfid.PCD_Init();
  verificarLeitorRFID();

  // O MAC já pode ser lido assim que o rádio Wi-Fi é inicializado, mesmo
  // antes de conectar - é ele que identifica este ESP32 no sistema.
  WiFi.mode(WIFI_STA);
  deviceMac = WiFi.macAddress();
  Serial.println("[BOOT] MAC deste ESP32: " + deviceMac);

  urlVerify      = "http://" + String(SERVER_HOST) + ":" + String(SERVER_PORT) + "/access_point/api/verify_card.php";
  urlHeartbeat   = "http://" + String(SERVER_HOST) + ":" + String(SERVER_PORT) + "/access_point/api/heartbeat.php";
  urlEnrollCard  = "http://" + String(SERVER_HOST) + ":" + String(SERVER_PORT) + "/access_point/api/enroll_card.php";
  urlWriteAck    = "http://" + String(SERVER_HOST) + ":" + String(SERVER_PORT) + "/access_point/api/write_ack.php";
  Serial.println("[BOOT] URL do heartbeat: " + urlHeartbeat);

  conectarWiFi();
  enviarHeartbeat();

  Serial.println("[BOOT] Setup concluido. Aproxime o cartao. Digite t para testar a fechadura.");
  Serial.println("========================================");
}

// ---------------------------------------------------------------------
void loop() {
  if (WiFi.status() != WL_CONNECTED) {
    conectarWiFi();
  }

  if (millis() - ultimoHeartbeat > INTERVALO_HEARTBEAT) {
    enviarHeartbeat();
  }

  anunciarMudancaDeModo();
  tratarComandoSerial();

  if (!rfid.PICC_IsNewCardPresent() || !rfid.PICC_ReadCardSerial()) {
    return;
  }

  String uid = lerUID();

  // Evita processar o mesmo cartão várias vezes seguidas (ex: cartão
  // parado sobre o leitor)
  if (uid == ultimoUidLido && (millis() - ultimaLeituraMs) < COOLDOWN_LEITURA_MS) {
    rfid.PICC_HaltA();
    rfid.PCD_StopCrypto1();
    return;
  }
  ultimoUidLido = uid;
  ultimaLeituraMs = millis();

  // Gravação tem prioridade sobre cadastro (o servidor já garante que os
  // dois nunca ficam ativos ao mesmo tempo, isso aqui é só defensivo)
  if (writeModeAtivo) {
    Serial.println("Cartao detectado em modo gravacao (UID atual: " + uid + ")");
    processarGravacao();
    writeModeAtivo = false; // sai do modo localmente, não espera o próximo heartbeat confirmar
  } else if (enrollModeAtivo) {
    Serial.println("Tag lida em modo cadastro: " + uid);
    processarCadastro(uid);
    enrollModeAtivo = false; // sai do modo localmente, não espera o próximo heartbeat confirmar
  } else {
    Serial.println("Cartao detectado: " + uid);
    processarCartao(uid);
  }

  rfid.PICC_HaltA();
  rfid.PCD_StopCrypto1();
}

// ---------------------------------------------------------------------
// Fechadura
// ---------------------------------------------------------------------
// Dá um pulso na fechadura. É bloqueante de propósito (700 ms): nada mais
// roda enquanto a bobina está energizada, então não existe caminho em que
// uma requisição HTTP demorada deixe o MOSFET ligado por mais tempo.
// Retorna false se foi ignorado por causa do intervalo mínimo.
bool abrirTrava() {
  if (jaAcionou && (millis() - ultimoAcionamentoMs) < INTERVALO_MIN_ACIONAMENTO_MS) {
    Serial.println("[TRAVA] Acionamento ignorado: aguarde entre acionamentos.");
    return false;
  }

  digitalWrite(PIN_TRAVA, HIGH);
  Serial.println("[TRAVA] MOSFET LIGADO - a fechadura deve liberar o pino.");
  delay(TEMPO_PULSO_TRAVA_MS);
  digitalWrite(PIN_TRAVA, LOW);
  Serial.println("[TRAVA] MOSFET DESLIGADO.");

  ultimoAcionamentoMs = millis();
  jaAcionou = true;
  return true;
}

// Comando de bancada pelo Monitor Serial: 't' = pulso de teste.
void tratarComandoSerial() {
  while (Serial.available()) {
    char comando = Serial.read();
    if (comando == 't' || comando == 'T') {
      Serial.println("[TRAVA] Teste manual solicitado.");
      abrirTrava();
    }
  }
}

// ---------------------------------------------------------------------
// Avisa no Serial quando o painel liga/desliga os modos de cadastro e gravação.
// ---------------------------------------------------------------------
void anunciarMudancaDeModo() {
  static bool estavaGravando = false;
  static bool estavaCadastrando = false;

  bool cadastrando = enrollModeAtivo && !writeModeAtivo;

  if (writeModeAtivo != estavaGravando) {
    estavaGravando = writeModeAtivo;
    Serial.println(writeModeAtivo
      ? "[MODO] Gravacao de UID ativada - aproxime o cartao magico."
      : "[MODO] Gravacao de UID encerrada.");
  }

  if (cadastrando != estavaCadastrando) {
    estavaCadastrando = cadastrando;
    Serial.println(cadastrando
      ? "[MODO] Cadastro de tag ativado - aproxime a tag."
      : "[MODO] Cadastro de tag encerrado.");
  }
}

// ---------------------------------------------------------------------
// Confere se o RC522 está respondendo no SPI. 0x00 ou 0xFF = fiação errada
// (ou módulo sem alimentação).
// ---------------------------------------------------------------------
void verificarLeitorRFID() {
  byte versao = rfid.PCD_ReadRegister(MFRC522::VersionReg);
  Serial.print("[BOOT] RC522 VersionReg = 0x");
  Serial.println(versao, HEX);

  if (versao == 0x00 || versao == 0xFF) {
    Serial.println("[BOOT] ATENCAO: RC522 sem resposta! Confira a fiacao (SS=5, RST=22, SCK=18, MISO=19, MOSI=23) e a alimentacao em 3V3.");
  } else {
    Serial.println("[BOOT] RFID RC522 inicializado.");
  }
}

// ---------------------------------------------------------------------
String lerUID() {
  String uid = "";
  for (byte i = 0; i < rfid.uid.size; i++) {
    if (rfid.uid.uidByte[i] < 0x10) uid += "0";
    uid += String(rfid.uid.uidByte[i], HEX);
  }
  uid.toUpperCase();
  return uid;
}

// ---------------------------------------------------------------------
// Operação normal: verificar cartão no servidor e liberar/negar acesso
// ---------------------------------------------------------------------
void processarCartao(String uid) {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("[ACESSO] NEGADO - sem WiFi, nao foi possivel verificar o cartao.");
    return;
  }

  HTTPClient http;
  http.begin(urlVerify);
  http.addHeader("Content-Type", "application/json");
  http.setTimeout(5000);

  StaticJsonDocument<192> reqDoc;
  reqDoc["card_uid"] = uid;
  reqDoc["mac_address"] = deviceMac;
  String corpo;
  serializeJson(reqDoc, corpo);

  int httpCode = http.POST(corpo);

  if (httpCode != 200) {
    Serial.println("[ACESSO] NEGADO - erro HTTP " + String(httpCode));
    http.end();
    return;
  }

  String resposta = http.getString();
  http.end();

  StaticJsonDocument<256> resDoc;
  DeserializationError erro = deserializeJson(resDoc, resposta);
  if (erro) {
    Serial.println("[ACESSO] NEGADO - resposta invalida do servidor: " + String(erro.c_str()));
    return;
  }

  bool sucesso    = resDoc["success"]   | false;
  bool abrePorta  = resDoc["open_door"] | false;
  String mensagem = resDoc["message"]   | "";

  if (sucesso && abrePorta) {
    Serial.println("[ACESSO] LIBERADO - " + mensagem);
    abrirTrava();
  } else {
    Serial.println("[ACESSO] NEGADO - " + mensagem);
  }
}

// ---------------------------------------------------------------------
// Cadastro de tag pelo leitor (ativado pelo painel)
// ---------------------------------------------------------------------
void processarCadastro(String uid) {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("[CADASTRO] Sem WiFi - tag nao enviada.");
    return;
  }

  HTTPClient http;
  http.begin(urlEnrollCard);
  http.addHeader("Content-Type", "application/json");
  http.setTimeout(5000);

  StaticJsonDocument<192> reqDoc;
  reqDoc["mac_address"] = deviceMac;
  reqDoc["uid"] = uid;
  String corpo;
  serializeJson(reqDoc, corpo);

  int httpCode = http.POST(corpo);
  http.end();

  if (httpCode != 200) {
    Serial.println("[CADASTRO] Erro HTTP no cadastro: " + String(httpCode));
    return;
  }

  Serial.println("[CADASTRO] Tag cadastrada: " + uid);
}

// ---------------------------------------------------------------------
// Modo de gravação: regrava o UID de um cartão MÁGICO (Gen1A/Gen2/CUID)
// com o valor definido no painel. Cartões comuns têm UID travado de
// fábrica e vão falhar nos dois métodos abaixo - isso é esperado.
// ---------------------------------------------------------------------
void processarGravacao() {
  Serial.println("[GRAVACAO] Gravando UID " + writeTargetUid + "...");

  byte novoUid[4];
  if (!hexParaBytes4(writeTargetUid, novoUid)) {
    Serial.println("[GRAVACAO] UID invalido recebido do servidor: " + writeTargetUid);
    enviarResultadoGravacao(false, "UID invalido");
    return;
  }

  String erro = "";
  String metodo = "";
  bool ok = regravarUidGen1A(novoUid, erro);

  if (ok) {
    metodo = "Gen1A";
  } else {
    Serial.println("[GRAVACAO] Gen1A falhou (" + erro + "), tentando Gen2/CUID...");
    // Precisa re-selecionar o cartão do zero antes de tentar o outro método
    rfid.PICC_HaltA();
    rfid.PCD_StopCrypto1();
    delay(150);
    if (!rfid.PICC_IsNewCardPresent() || !rfid.PICC_ReadCardSerial()) {
      erro = "Cartao removido do leitor";
    } else {
      String erroGen2 = "";
      ok = regravarUidGen2(novoUid, erroGen2);
      metodo = "Gen2/CUID";
      if (!ok) erro = erroGen2;
    }
  }

  rfid.PICC_HaltA();
  rfid.PCD_StopCrypto1();

  if (!ok) {
    Serial.println("[GRAVACAO] Falhou nos dois metodos: " + erro);
    enviarResultadoGravacao(false, "Cartao nao suporta gravacao (" + erro + ")");
    return;
  }

  Serial.println("[GRAVACAO] Sucesso via " + metodo);
  enviarResultadoGravacao(true, "Gravado com sucesso (" + metodo + ")");
}

// Tenta o "backdoor" de cartões mágicos Gen1A: dois comandos crus (0x40 de
// 7 bits, depois 0x43 de 8 bits) liberam a escrita do bloco 0 sem precisar
// de autenticação normal. Técnica bem documentada para esse tipo de cartão.
bool regravarUidGen1A(byte* novoUid, String &erro) {
  byte resposta[1];
  byte respLen;
  byte validBits;
  MFRC522::StatusCode status;

  byte cmd40 = 0x40;
  validBits = 7;
  respLen = sizeof(resposta);
  status = rfid.PCD_TransceiveData(&cmd40, 1, resposta, &respLen, &validBits, 0, false);
  if (status != MFRC522::STATUS_OK || respLen != 1 || resposta[0] != 0x0A) {
    erro = "sem resposta ao comando 0x40";
    Serial.println("[GRAVACAO][Gen1A] " + erro + " (status=" + String(MFRC522::GetStatusCodeName(status)) + ")");
    return false;
  }

  byte cmd43 = 0x43;
  validBits = 8;
  respLen = sizeof(resposta);
  status = rfid.PCD_TransceiveData(&cmd43, 1, resposta, &respLen, &validBits, 0, false);
  if (status != MFRC522::STATUS_OK || respLen != 1 || resposta[0] != 0x0A) {
    erro = "sem resposta ao comando 0x43";
    Serial.println("[GRAVACAO][Gen1A] " + erro + " (status=" + String(MFRC522::GetStatusCodeName(status)) + ")");
    return false;
  }

  byte buffer[18];
  byte tamanho = sizeof(buffer);
  status = rfid.MIFARE_Read(0, buffer, &tamanho);
  if (status != MFRC522::STATUS_OK) {
    erro = "falha ao ler bloco 0";
    Serial.println("[GRAVACAO][Gen1A] " + erro + " (status=" + String(MFRC522::GetStatusCodeName(status)) + ")");
    return false;
  }

  byte novoBloco0[16];
  memcpy(novoBloco0, buffer, 16);
  novoBloco0[0] = novoUid[0];
  novoBloco0[1] = novoUid[1];
  novoBloco0[2] = novoUid[2];
  novoBloco0[3] = novoUid[3];
  novoBloco0[4] = novoUid[0] ^ novoUid[1] ^ novoUid[2] ^ novoUid[3]; // BCC

  status = rfid.MIFARE_Write(0, novoBloco0, 16);
  if (status != MFRC522::STATUS_OK) {
    erro = "falha ao gravar bloco 0";
    Serial.println("[GRAVACAO][Gen1A] " + erro + " (status=" + String(MFRC522::GetStatusCodeName(status)) + ")");
    return false;
  }

  return true;
}

// Tenta o método Gen2/CUID: autenticação normal com a chave padrão de
// fábrica (FFFFFFFFFFFF) e escrita comum no bloco 0 - funciona em cartões
// mágicos "regraváveis por autenticação", sem precisar de backdoor.
bool regravarUidGen2(byte* novoUid, String &erro) {
  MFRC522::MIFARE_Key key;
  for (byte i = 0; i < 6; i++) key.keyByte[i] = 0xFF;

  MFRC522::StatusCode status = rfid.PCD_Authenticate(MFRC522::PICC_CMD_MF_AUTH_KEY_A, 0, &key, &(rfid.uid));
  if (status != MFRC522::STATUS_OK) {
    erro = "autenticacao falhou";
    Serial.println("[GRAVACAO][Gen2] " + erro + " (status=" + String(MFRC522::GetStatusCodeName(status)) + ")");
    rfid.PCD_StopCrypto1();
    return false;
  }

  byte buffer[18];
  byte tamanho = sizeof(buffer);
  status = rfid.MIFARE_Read(0, buffer, &tamanho);
  if (status != MFRC522::STATUS_OK) {
    erro = "falha ao ler bloco 0";
    Serial.println("[GRAVACAO][Gen2] " + erro + " (status=" + String(MFRC522::GetStatusCodeName(status)) + ")");
    rfid.PCD_StopCrypto1();
    return false;
  }

  byte novoBloco0[16];
  memcpy(novoBloco0, buffer, 16);
  novoBloco0[0] = novoUid[0];
  novoBloco0[1] = novoUid[1];
  novoBloco0[2] = novoUid[2];
  novoBloco0[3] = novoUid[3];
  novoBloco0[4] = novoUid[0] ^ novoUid[1] ^ novoUid[2] ^ novoUid[3]; // BCC

  status = rfid.MIFARE_Write(0, novoBloco0, 16);
  rfid.PCD_StopCrypto1();

  if (status != MFRC522::STATUS_OK) {
    erro = "cartao rejeitou a gravacao (provavelmente nao e regravavel)";
    Serial.println("[GRAVACAO][Gen2] " + erro + " (status=" + String(MFRC522::GetStatusCodeName(status)) + ")");
    return false;
  }

  return true;
}

// Converte "A1B2C3D4" (8 caracteres hex) em 4 bytes. Retorna false se o
// texto não tiver exatamente esse formato.
bool hexParaBytes4(String hex, byte* out) {
  if (hex.length() != 8) return false;
  for (int i = 0; i < 4; i++) {
    String par = hex.substring(i * 2, i * 2 + 2);
    char* fimValido;
    long valor = strtol(par.c_str(), &fimValido, 16);
    if (*fimValido != '\0') return false;
    out[i] = (byte)valor;
  }
  return true;
}

// Avisa o servidor o resultado da tentativa de gravação (sucesso ou não),
// pra o painel mostrar pro operador.
void enviarResultadoGravacao(bool sucesso, String mensagem) {
  if (WiFi.status() != WL_CONNECTED) return;

  HTTPClient http;
  http.begin(urlWriteAck);
  http.addHeader("Content-Type", "application/json");
  http.setTimeout(4000);

  StaticJsonDocument<256> doc;
  doc["mac_address"] = deviceMac;
  doc["success"] = sucesso;
  doc["message"] = mensagem;
  String corpo;
  serializeJson(doc, corpo);

  int httpCode = http.POST(corpo);
  Serial.println("[GRAVACAO] write_ack -> HTTP " + String(httpCode));
  http.end();
}

// ---------------------------------------------------------------------
void conectarWiFi() {
  if (WiFi.status() == WL_CONNECTED) return;

  Serial.print("[WIFI] Conectando em " + String(WIFI_SSID));

  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  int tentativas = 0;
  while (WiFi.status() != WL_CONNECTED && tentativas < 40) {
    delay(250);
    Serial.print(".");
    tentativas++;
  }
  Serial.println();

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("[WIFI] Conectado! IP: " + WiFi.localIP().toString());
  } else {
    Serial.println("[WIFI] Falha ao conectar. Tentando de novo...");
  }
}

// ---------------------------------------------------------------------
// Heartbeat: avisa que está online, se registra automaticamente pelo MAC
// na primeira vez, e descobre se deve entrar em modo de cadastro/gravação.
// ---------------------------------------------------------------------
void enviarHeartbeat() {
  ultimoHeartbeat = millis();
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("[HEARTBEAT] Pulado - sem WiFi.");
    return;
  }

  HTTPClient http;
  http.begin(urlHeartbeat);
  http.addHeader("Content-Type", "application/json");
  http.setTimeout(4000);

  StaticJsonDocument<128> doc;
  doc["mac_address"] = deviceMac;
  String corpo;
  serializeJson(doc, corpo);

  int httpCode = http.POST(corpo);

  if (httpCode == 200) {
    String resposta = http.getString();
    StaticJsonDocument<256> resDoc;
    if (!deserializeJson(resDoc, resposta)) {
      deviceId       = resDoc["device_id"]   | deviceId;
      const char* nm = resDoc["device_name"] | "";
      if (strlen(nm) > 0) deviceName = String(nm);
      enrollModeAtivo = resDoc["enroll_mode"] | false;
      writeModeAtivo  = resDoc["write_mode"]  | false;
      const char* wtu = resDoc["write_target_uid"] | "";
      writeTargetUid  = String(wtu);
    }
  } else if (httpCode > 0) {
    // Chegou ao servidor, mas ele respondeu um erro HTTP (ex: 404 = URL
    // errada, 500 = erro no PHP). Confira o caminho/porta em SERVER_HOST.
    Serial.println("[HEARTBEAT] Servidor respondeu HTTP " + String(httpCode) + " (chegou no servidor, mas algo esta errado na URL/PHP).");
  } else {
    // Código negativo = não conseguiu nem abrir a conexão TCP. Confira:
    // SERVER_HOST (IP certo do PC?), se o Apache/XAMPP está ligado, e se
    // ESP32 e PC estão na mesma rede/sub-rede Wi-Fi (sem isolamento de
    // dispositivos no roteador).
    Serial.println("[HEARTBEAT] Falha de conexao (" + String(httpCode) + ") = " + http.errorToString(httpCode) + " -> nao conseguiu alcancar " + urlHeartbeat);
  }

  http.end();
}
