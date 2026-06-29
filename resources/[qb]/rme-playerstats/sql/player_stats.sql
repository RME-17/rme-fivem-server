-- Run automatically on resource start, but here for reference / manual import.
CREATE TABLE IF NOT EXISTS `player_stats` (
    `citizenid` VARCHAR(60) NOT NULL,
    `stats` LONGTEXT,
    `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`citizenid`)
);
