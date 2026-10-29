# Firmware com fechadura solenoide (ESP32 + RC522 + MOSFET)

Sketch: `AccessPoint_ESP32_Fechadura/AccessPoint_ESP32_Fechadura.ino`.

É a versão da montagem nova (sem LCD, LEDs, buzzer e servo). A comunicação com
o sistema web é a mesma do `AccessPoint_ESP32` (heartbeat, verificação de
cartão, cadastro de tag pelo leitor e gravação de UID em cartão mágico); só o
atuador mudou: o **GPIO 25** dá um pulso no gate do MOSFET e a fechadura libera
o pino. O firmware com LCD continua em `AccessPoint_ESP32/`, sem alterações.

## Pinagem

| Componente            | Pino ESP32 |
|------------------------|-----------|
| RC522 — SDA/SS         | GPIO 5 |
| RC522 — RST            | GPIO 22 |
| RC522 — SCK            | GPIO 18 |
| RC522 — MISO           | GPIO 19 |
| RC522 — MOSI           | GPIO 23 |
| MOSFET (gate, via 620 Ω) | GPIO 25 |

O RC522 fica em 3V3 (nunca 5 V). Detalhes do circuito do MOSFET, do diodo de
proteção e da alimentação estão no cabeçalho do `.ino`.

## Como usar

1. Bibliotecas: **MFRC522** e **ArduinoJson**. (LiquidCrystal I2C e ESP32Servo
   não são mais necessárias nesta versão.)
2. Edite `WIFI_SSID`, `WIFI_PASSWORD` e `SERVER_HOST` no bloco
   `CONFIGURAÇÕES (EDITE AQUI)`.
3. Placa *ESP32 Dev Module*, faça o upload e abra o Monitor Serial em 115200.
4. Não alimente o ESP32 pelo USB e pelo VIN (LM2596) ao mesmo tempo.

## Comportamento

- Cartão aprovado pelo servidor (`success` + `open_door`): MOSFET ligado por
  **700 ms** (`TEMPO_PULSO_TRAVA_MS`), depois desligado.
- Intervalo mínimo entre pulsos: **2,5 s** (`INTERVALO_MIN_ACIONAMENTO_MS`),
  para não esquentar a bobina.
- Sem Wi-Fi, erro HTTP ou resposta inválida: acesso **negado** (a fechadura
  nunca abre sem confirmação do servidor).
- O pulso é bloqueante de propósito: nada roda enquanto a bobina está
  energizada, então uma requisição lenta não prolonga o acionamento.
- Digitar `t` no Monitor Serial dá um pulso de teste (não depende de Wi-Fi nem
  de cartão).
- Todo o feedback (acesso liberado/negado, erros, modos de cadastro e
  gravação) sai pelo Monitor Serial, com prefixos `[ACESSO]`, `[TRAVA]`,
  `[CADASTRO]`, `[GRAVACAO]`, `[HEARTBEAT]`, `[WIFI]`.
- No boot, o firmware lê o registrador de versão do RC522 e avisa no Serial se
  ele não responde (leitura `0x00`/`0xFF` = fiação ou alimentação).

## Testes sugeridos (nesta ordem)

1. Boot: o Serial deve mostrar `VersionReg = 0x91` ou `0x92`.
2. `t` no Serial: a fechadura dá um pulso de ~700 ms.
3. Cadastre a tag pelo painel (*Cartões de Acesso* > Ler UID pelo leitor).
4. Aproxime a tag cadastrada: `[ACESSO] LIBERADO` e pulso na fechadura.
5. Aproxime uma tag não cadastrada: `[ACESSO] NEGADO`, sem pulso.
