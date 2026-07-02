-- Redline Motorsport unpaid vehicle invoices.
-- Keyed by citizenid + plate so a customer cannot escape a bill by relogging:
-- on next login the invoice is re-sent and the matching car is immobilized again.
-- The server also auto-creates this table on resource start; this file is a
-- manual fallback for setups where the DB user lacks CREATE TABLE at runtime.

CREATE TABLE IF NOT EXISTS `redline_invoices` (
  `citizenid` VARCHAR(50) NOT NULL,
  `plate` VARCHAR(12) NOT NULL,
  `amount` INT NOT NULL DEFAULT 0,
  `society` VARCHAR(50) DEFAULT NULL,
  `shoplabel` VARCHAR(100) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`citizenid`, `plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
