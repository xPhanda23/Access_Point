-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 29/10/2026 às 05:40
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `access_control`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `access_logs`
--

CREATE TABLE `access_logs` (
  `id` int(11) NOT NULL,
  `card_uid` varchar(50) DEFAULT NULL,
  `device_id` int(11) DEFAULT NULL,
  `device_name` varchar(100) DEFAULT NULL,
  `access_granted` tinyint(1) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `access_logs`
--

INSERT INTO `access_logs` (`id`, `card_uid`, `device_id`, `device_name`, `access_granted`, `message`, `created_at`) VALUES
(26, '123456', 6, 'Sala de Informática', 0, '0', '2026-05-06 15:29:29'),
(27, '123456', 5, 'Sala de Robótica', 1, '0', '2026-05-06 15:29:33'),
(28, '0616', 5, 'Sala de Robótica', 0, '0', '2026-05-07 10:34:00'),
(29, '123456', 5, 'Sala de Robótica', 1, '0', '2026-05-07 10:38:02'),
(30, '123456', 5, 'Sala de Robótica', 1, '0', '2026-05-07 10:38:04'),
(31, '123456', 5, 'Sala de Robótica', 1, '0', '2026-05-07 10:38:05'),
(32, '123456', 6, 'Sala de Informática', 0, '0', '2026-05-07 10:38:07'),
(33, '123456', 6, 'Sala de Informática', 0, '0', '2026-05-07 10:38:08'),
(38, 'B465F2E5', 1, 'ESP32', 0, '0', '2026-09-03 02:32:33'),
(39, 'B465F2E5', 1, 'ESP32', 1, '0', '2026-09-03 02:33:08'),
(40, 'B465F2E5', 1, 'ESP32', 1, '0', '2026-09-03 02:33:15'),
(41, 'B465F2E5', 1, 'ESP32', 1, '0', '2026-09-03 02:33:27'),
(42, 'B465F2E5', 1, 'ESP32', 1, '0', '2026-09-03 02:34:15'),
(43, 'B465F2E5', 1, 'ESP32', 1, '0', '2026-09-03 02:34:22'),
(44, 'B465F2E5', 1, 'ESP32', 1, '0', '2026-09-03 02:34:29'),
(45, '2ABEF134', 1, 'ESP32', 0, '0', '2026-09-03 02:34:39'),
(46, '2ABEF134', 1, 'ESP32', 0, '0', '2026-09-03 02:34:42'),
(47, '2ABEF134', 1, 'ESP32', 0, '0', '2026-09-03 02:34:45'),
(48, '2ABEF134', 1, 'ESP32', 0, '0', '2026-09-03 02:34:50'),
(49, 'B465F2E5', 1, 'ESP32', 1, '0', '2026-09-03 02:36:05'),
(50, 'B465F2E5', 1, 'ESP32', 1, '0', '2026-09-03 02:36:12'),
(51, 'B465F2E5', 1, 'ESP32', 1, '0', '2026-09-03 02:38:15'),
(52, 'B465F2E5', 1, 'ESP32', 1, '0', '2026-09-03 02:38:34'),
(53, 'B465F2E5', 1, 'ESP32', 1, '0', '2026-09-03 02:38:43'),
(54, 'B465F2E5', 1, 'ESP32', 1, '0', '2026-09-03 02:39:58'),
(55, 'B465F2E5', 1, 'ESP32', 1, '0', '2026-09-03 02:40:05'),
(56, 'B465F2E5', 1, 'ESP32', 1, '0', '2026-09-03 02:40:11'),
(57, 'B465F2E5', 1, 'ESP32', 1, '0', '2026-09-03 02:40:48'),
(58, 'B465F2E5', 1, 'ESP32', 1, '0', '2026-09-03 02:41:18'),
(59, 'B465F2E5', 1, 'ESP32', 1, '0', '2026-09-03 02:41:48'),
(60, 'B465F2E5', 1, 'Teste', 1, '0', '2026-09-03 02:42:08'),
(61, 'B465F2E5', 1, 'Sala de Robótica', 1, '0', '2026-09-03 02:42:30'),
(62, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 02:42:53'),
(63, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 02:43:05'),
(64, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 02:43:11'),
(65, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 02:43:41'),
(66, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 02:43:47'),
(67, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 02:44:17'),
(68, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 02:45:09'),
(69, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 02:45:14'),
(70, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 02:45:22'),
(71, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 02:45:26'),
(72, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 02:46:41'),
(73, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 02:47:43'),
(74, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 02:48:50'),
(75, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 02:49:56'),
(76, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 02:50:28'),
(77, '2ABEF134', 1, 'Sala de Robotica', 1, '0', '2026-09-03 02:50:39'),
(78, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 02:50:47'),
(79, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 02:51:07'),
(80, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 02:51:16'),
(81, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 02:53:24'),
(82, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 02:53:31'),
(83, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 02:54:50'),
(84, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 02:54:57'),
(85, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 02:55:21'),
(86, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 02:55:31'),
(87, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 02:55:40'),
(88, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 02:55:48'),
(89, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 02:56:01'),
(90, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 02:56:28'),
(91, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 03:07:23'),
(92, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 03:08:23'),
(93, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 03:09:07'),
(94, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 03:11:23'),
(95, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 03:11:28'),
(96, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 03:12:01'),
(97, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 03:12:44'),
(98, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 03:13:06'),
(99, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 03:13:14'),
(100, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 03:14:13'),
(101, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 03:15:15'),
(102, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 03:15:20'),
(103, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 03:15:26'),
(104, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 03:18:03'),
(105, 'B465F2E5', 1, 'Sala de Robotica', 0, '0', '2026-09-03 03:18:19'),
(106, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 03:18:42'),
(107, 'B465F2E5', 1, 'Sala de Robotica', 0, '0', '2026-09-03 03:18:51'),
(108, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 03:18:58'),
(109, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 03:19:13'),
(110, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 03:33:08'),
(111, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 03:35:08'),
(112, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 03:35:20'),
(113, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 03:36:28'),
(114, 'B465F2E5', 1, 'Sala de Robotica', 1, '0', '2026-09-03 03:40:51'),
(115, 'B465F2E7', 1, 'Sala de Robotica', 0, '0', '2026-09-03 03:41:01'),
(116, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 03:42:10'),
(117, '2ABEF134', 1, 'Sala de Robotica', 0, '0', '2026-09-03 03:42:19'),
(118, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 03:42:32'),
(119, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 03:42:37'),
(120, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 03:43:05'),
(121, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 03:43:08'),
(122, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 03:43:15'),
(123, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 03:43:24'),
(124, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 03:44:00'),
(125, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:18:17'),
(126, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:18:26'),
(127, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:18:39'),
(128, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:19:01'),
(129, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:19:08'),
(130, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:19:33'),
(131, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:19:44'),
(132, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:19:57'),
(133, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:20:06'),
(134, '2ABEF134', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 11:20:19'),
(135, '2ABEF134', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 11:20:23'),
(136, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 11:20:35'),
(137, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:22:08'),
(138, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:23:27'),
(139, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:23:39'),
(140, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 11:31:55'),
(141, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:31:58'),
(142, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:33:28'),
(143, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 11:37:03'),
(144, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 11:37:13'),
(145, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 11:42:48'),
(146, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:49:02'),
(147, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:51:17'),
(148, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 11:51:31'),
(149, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:51:43'),
(150, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:51:51'),
(151, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 11:52:07'),
(152, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 11:52:11'),
(153, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:52:25'),
(154, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:52:56'),
(155, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:53:06'),
(156, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:53:37'),
(157, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 11:53:44'),
(158, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:55:01'),
(159, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 11:55:09'),
(160, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:55:13'),
(161, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:55:44'),
(162, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 11:56:00'),
(163, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 11:56:09'),
(164, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 11:56:25'),
(165, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:57:50'),
(166, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 11:58:09'),
(167, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:58:21'),
(168, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 11:58:31'),
(169, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 11:59:24'),
(170, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 11:59:31'),
(171, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 12:00:02'),
(172, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 12:00:09'),
(173, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 12:00:26'),
(174, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 12:00:42'),
(175, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 12:01:21'),
(176, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 12:01:48'),
(177, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 12:02:41'),
(178, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 12:03:08'),
(179, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 12:03:28'),
(180, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 12:03:54'),
(181, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 12:04:53'),
(182, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 12:06:13'),
(183, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 12:06:35'),
(184, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 12:06:44'),
(185, '2ABEF134', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 12:06:52'),
(186, '2ABEF134', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 12:06:59'),
(187, '2ABEF134', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 12:07:07'),
(188, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 12:07:17'),
(189, '2ABEF134', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 12:07:28'),
(190, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 12:08:44'),
(191, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 12:26:02'),
(192, '2ABEF134', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 17:39:10'),
(193, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 17:39:24'),
(194, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 17:39:38'),
(195, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 17:39:50'),
(196, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 17:39:59'),
(197, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 17:40:15'),
(198, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 17:40:21'),
(199, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 17:41:00'),
(200, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 17:41:22'),
(201, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 17:41:25'),
(202, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 17:41:32'),
(203, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 17:41:39'),
(204, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 17:42:08'),
(205, '2ABEF134', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 17:42:20'),
(206, '2ABEF134', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 17:42:29'),
(207, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 17:42:54'),
(208, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 17:43:04'),
(209, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 17:43:09'),
(210, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 17:43:18'),
(211, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 17:43:29'),
(212, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 17:43:39'),
(213, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 17:43:45'),
(214, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 17:43:57'),
(215, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 17:44:05'),
(216, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 17:44:43'),
(217, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 17:44:51'),
(218, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 17:44:54'),
(219, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 17:44:58'),
(220, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 17:45:06'),
(221, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 17:45:16'),
(222, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 17:45:20'),
(223, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 17:46:13'),
(224, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 17:46:17'),
(225, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 17:46:19'),
(226, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 17:46:31'),
(227, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 17:46:36'),
(228, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 17:46:44'),
(229, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 17:46:57'),
(230, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:11:46'),
(231, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 18:11:54'),
(232, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 18:11:58'),
(233, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:12:04'),
(234, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:12:16'),
(235, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:12:26'),
(236, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 18:12:33'),
(237, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 18:12:52'),
(238, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:12:56'),
(239, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:13:21'),
(240, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:13:33'),
(241, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:13:44'),
(242, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:14:02'),
(243, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 18:14:19'),
(244, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 18:14:23'),
(245, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 18:14:26'),
(246, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:14:31'),
(247, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:14:38'),
(248, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:15:00'),
(249, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:35:08'),
(250, '123456', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 18:35:20'),
(251, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:36:57'),
(252, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:37:08'),
(253, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:37:18'),
(254, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 18:37:25'),
(255, '2ABEF134', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 18:38:07'),
(256, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:38:14'),
(257, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:39:31'),
(258, '2ABEF134', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:39:41'),
(259, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 18:39:50'),
(260, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-09-03 18:39:58'),
(261, '2ABEF134', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-09-03 18:40:13'),
(262, '4AC72635', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:40:58'),
(263, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:44:37'),
(264, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:44:47'),
(265, 'B465F2E5', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-09-03 18:45:06'),
(266, '4AC72635', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-10-26 23:37:37'),
(267, 'C70514A2', 1, 'Sala de Robotica', 0, 'Sem permissao', '2026-10-29 04:32:05'),
(268, 'C70514A2', 1, 'Sala de Robotica', 0, 'Sem permissao', '2026-10-29 04:32:12'),
(269, 'C70514A2', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-10-29 04:32:24'),
(270, 'C70514A2', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-10-29 04:32:31'),
(271, 'C70514A2', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-10-29 04:32:38'),
(272, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-10-29 04:32:53'),
(273, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-10-29 04:33:04'),
(274, '4AC72635', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-10-29 04:33:27'),
(275, '4AC72635', 1, 'Sala de Robotica', 0, 'Sem permissao', '2026-10-29 04:33:40'),
(276, 'C70514A2', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-10-29 04:33:45'),
(277, 'B465F2E5', 1, 'Sala de Robotica', 0, 'Cartão não cadastrado no sistema.', '2026-10-29 04:34:00'),
(278, 'C70514A2', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-10-29 04:34:07'),
(279, 'C70514A2', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-10-29 04:34:12'),
(280, 'C70514A2', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-10-29 04:34:16'),
(281, 'C70514A2', 1, 'Sala de Robotica', 0, 'Cartão bloqueado ou inativo.', '2026-10-29 04:34:24'),
(282, 'C70514A2', 1, 'Sala de Robotica', 1, 'Acesso liberado para Sala de Robotica', '2026-10-29 04:34:29');

-- --------------------------------------------------------

--
-- Estrutura para tabela `cards`
--

CREATE TABLE `cards` (
  `id` int(11) NOT NULL,
  `card_uid` varchar(50) NOT NULL,
  `holder_name` varchar(100) NOT NULL,
  `holder_type` enum('aluno','professor','funcionario','visitante') DEFAULT 'aluno',
  `status` enum('active','blocked') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `cards`
--

INSERT INTO `cards` (`id`, `card_uid`, `holder_name`, `holder_type`, `status`, `created_at`) VALUES
(13, 'C70514A2', 'João Gabriel da Costa Rocha', 'professor', 'active', '2026-10-29 04:32:00'),
(14, '4AC72635', 'Ighor Rodolfo Furquim', 'professor', 'active', '2026-10-29 04:33:35');

-- --------------------------------------------------------

--
-- Estrutura para tabela `card_access`
--

CREATE TABLE `card_access` (
  `card_id` int(11) NOT NULL,
  `device_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `card_access`
--

INSERT INTO `card_access` (`card_id`, `device_id`) VALUES
(13, 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `devices`
--

CREATE TABLE `devices` (
  `id` int(11) NOT NULL,
  `device_name` varchar(100) NOT NULL,
  `mac_address` varchar(17) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `status` enum('online','offline') DEFAULT 'offline',
  `last_seen` timestamp NULL DEFAULT NULL,
  `enroll_mode` tinyint(1) NOT NULL DEFAULT 0,
  `enroll_uid` varchar(50) DEFAULT NULL,
  `write_mode` tinyint(1) NOT NULL DEFAULT 0,
  `write_target_uid` varchar(8) DEFAULT NULL,
  `write_result` varchar(150) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `devices`
--

INSERT INTO `devices` (`id`, `device_name`, `mac_address`, `location`, `status`, `last_seen`, `enroll_mode`, `enroll_uid`, `write_mode`, `write_target_uid`, `write_result`, `created_at`) VALUES
(1, 'Sala de Robotica', '00:00:00:00:00:00', 'Sala de Robótica', 'online', '2026-10-29 04:34:31', 0, NULL, 0, NULL, NULL, '2026-09-03 02:31:44');

-- --------------------------------------------------------

--
-- Estrutura para tabela `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `fullname` varchar(100) NOT NULL,
  `role` enum('admin','direcao') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `fullname`, `role`, `created_at`) VALUES
(5, 'dev_lucas', '$2y$10$x9vTipRslsPxziuQHZWaMuybLs0FqgvUKkaZ5GqxzhZuwFVc48ZtG', 'Lucas Domingues Venâncio', 'admin', '2026-05-06 11:43:40'),
(6, 'dev_joaogabriel', '$2y$10$KDedeEUsSoiUIF4XJTTyOOUNhdVpzcVBW4Hwga0rC3YpP.sIa24U.', 'João Gabriel da Costa Rocha', 'admin', '2026-05-06 12:31:21'),
(7, 'dev_ighor', '$2y$10$DCZrkaB.m49OoFUDYQNuMuIdH.6bUzp.wmdqsXeYGZijZ4BAjlPHC', 'Ighor Rodolfo Furquim', 'admin', '2026-05-06 12:36:00');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `access_logs`
--
ALTER TABLE `access_logs`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `cards`
--
ALTER TABLE `cards`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `card_uid` (`card_uid`);

--
-- Índices de tabela `card_access`
--
ALTER TABLE `card_access`
  ADD PRIMARY KEY (`card_id`,`device_id`),
  ADD KEY `device_id` (`device_id`);

--
-- Índices de tabela `devices`
--
ALTER TABLE `devices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `mac_address` (`mac_address`);

--
-- Índices de tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `access_logs`
--
ALTER TABLE `access_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=283;

--
-- AUTO_INCREMENT de tabela `cards`
--
ALTER TABLE `cards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de tabela `devices`
--
ALTER TABLE `devices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `card_access`
--
ALTER TABLE `card_access`
  ADD CONSTRAINT `card_access_ibfk_1` FOREIGN KEY (`card_id`) REFERENCES `cards` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `card_access_ibfk_2` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
