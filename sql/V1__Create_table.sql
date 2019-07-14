-- Adminer 4.7.1 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO dd';

DROP TABLE IF EXISTS `common_iocl_log_details`;
CREATE TABLE `common_iocl_log_details` (
  `UID_Number` int(11) NOT NULL AUTO_INCREMENT,
  `service_id` int(11) NOT NULL,
  `service_request_id` varchar(100) NOT NULL,
  `trip_no` bigint(20) NOT NULL,
  `IOCL_UID_Number` varchar(100) NOT NULL,
  `return_status` enum('S','F') NOT NULL DEFAULT 'F',
  `error_message` varchar(250) NOT NULL,
  `requested_date_time` datetime NOT NULL,
  `ack_date_time` datetime NOT NULL,
  PRIMARY KEY (`UID_Number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- 2019-06-23 08:11:37