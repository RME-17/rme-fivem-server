-- Table required by npwd_qb_banking invoices/bill feature (originally from qb-phone)
CREATE TABLE IF NOT EXISTS `phone_invoices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `society` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `sendercitizenid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
);
