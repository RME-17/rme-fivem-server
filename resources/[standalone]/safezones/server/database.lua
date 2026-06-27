AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    if not Config.Database or Config.Database.AutoCreateTable == false then
        print('^3[koja-carmarket]^7 AutoCreateTable disabled — skipping table creation.')
        return
    end

    local resName = GetCurrentResourceName()

    local function ensureTable(name, createSql, nextFn)
        exports.oxmysql:fetch('SHOW TABLES LIKE ?', { name }, function(result)
            if result and result[1] then
                KOJA.Shared.KojaCarmarketDebug('^2[' .. resName .. ']^7 Table ^3`' .. name .. '`^7 already exists — skipping.')
                if nextFn then nextFn() else TriggerEvent('koja_carmarket:databaseReady') end
            else
                KOJA.Shared.KojaCarmarketDebug('^6[' .. resName .. ']^7 Creating table ^3' .. name .. '^7...')
                exports.oxmysql:execute(createSql, {}, function()
                    KOJA.Shared.KojaCarmarketDebug('^2[' .. resName .. ']^7 Table ^3' .. name .. '^7 created.')
                    if nextFn then 
                        nextFn() 
                    else 
                        TriggerEvent('koja_carmarket:databaseReady') 
                    end
                end)
            end
        end)
    end

    KOJA.Shared.KojaCarmarketDebug('^6[' .. resName .. ']^7 Checking database tables...')

    ensureTable('koja_carmarket', [[
        CREATE TABLE IF NOT EXISTS koja_carmarket (
            id INT AUTO_INCREMENT PRIMARY KEY,
            zone_id VARCHAR(50) NOT NULL,
            slot_id VARCHAR(64) DEFAULT NULL,
            owner VARCHAR(50) NOT NULL,
            vehicle JSON NOT NULL,
            plate VARCHAR(8) NOT NULL,
            coords JSON NOT NULL,
            heading FLOAT NOT NULL
        )
    ]], function()
        ensureTable('koja_carmarket_listings', [[
            CREATE TABLE IF NOT EXISTS koja_carmarket_listings (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                respname VARCHAR(100) NOT NULL,
                owner VARCHAR(50) NOT NULL,
                car_type VARCHAR(50) NOT NULL DEFAULT 'sedan',
                drive_type VARCHAR(50) NOT NULL DEFAULT '2x4',
                fuel_type VARCHAR(50) NOT NULL DEFAULT 'gasoline',
                offert_type VARCHAR(50) NOT NULL DEFAULT 'buy',
                tags JSON DEFAULT ('[]'),
                price INT NOT NULL DEFAULT 0,
                mileage INT NOT NULL DEFAULT 0,
                description TEXT,
                plate VARCHAR(20),
                vehicle_data JSON,
                owned_vehicle_id INT DEFAULT NULL,
                seller_name VARCHAR(100) DEFAULT NULL,
                zone_id VARCHAR(50) DEFAULT NULL,
                auction_starts_at TIMESTAMP NULL DEFAULT NULL,
                auction_ends_at TIMESTAMP NULL DEFAULT NULL,
                listing_fee_paid_until TIMESTAMP NULL DEFAULT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ]], function()
            local function nextStep()
                ensureTable('koja_carmarket_history', [[
                CREATE TABLE IF NOT EXISTS koja_carmarket_history (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    listing_id INT NOT NULL,
                    type VARCHAR(20) NOT NULL,
                    price INT NOT NULL DEFAULT 0,
                    seller_identifier VARCHAR(64) DEFAULT NULL,
                    seller_name VARCHAR(100) DEFAULT NULL,
                    buyer_identifier VARCHAR(64) DEFAULT NULL,
                    buyer_name VARCHAR(100) DEFAULT NULL,
                    vehicle_info JSON DEFAULT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            ]], function()
                    ensureTable('koja_carmarket_garage_slots', [[
                CREATE TABLE IF NOT EXISTS koja_carmarket_garage_slots (
                    owner VARCHAR(50) NOT NULL,
                    garage_id VARCHAR(50) NOT NULL,
                    slot INT NOT NULL,
                    vehicle_id INT NOT NULL,
                    PRIMARY KEY (owner, garage_id, slot)
                )
            ]], function()
                        ensureTable('koja_carmarket_parkings', [[
                CREATE TABLE IF NOT EXISTS koja_carmarket_parkings (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    owner_identifier VARCHAR(64) NOT NULL,
                    name VARCHAR(100) NOT NULL,
                    zone_id VARCHAR(50) NOT NULL,
                    weekly_fee INT NOT NULL DEFAULT 5000,
                    next_payment_at TIMESTAMP NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            ]], function()
                            ensureTable('koja_carmarket_parking_slots', [[
                CREATE TABLE IF NOT EXISTS koja_carmarket_parking_slots (
                    parking_id INT NOT NULL,
                    slot_index INT NOT NULL,
                    coords JSON NOT NULL,
                    heading FLOAT NOT NULL DEFAULT 0,
                    PRIMARY KEY (parking_id, slot_index),
                    FOREIGN KEY (parking_id) REFERENCES koja_carmarket_parkings(id) ON DELETE CASCADE
                )
            ]], function()
                                ensureTable('koja_carmarket_exchange', [[
                CREATE TABLE IF NOT EXISTS koja_carmarket_exchange (
                    zone_id VARCHAR(50) PRIMARY KEY,
                    owner_identifier VARCHAR(64) DEFAULT NULL,
                    listing_fee_per_week INT NOT NULL DEFAULT 500,
                    max_listings INT NOT NULL DEFAULT 50,
                    commission_percent INT NOT NULL DEFAULT 5,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            ]], function()
                                    ensureTable('koja_carmarket_offers', [[
                CREATE TABLE IF NOT EXISTS koja_carmarket_offers (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    listing_id INT NOT NULL,
                    buyer_identifier VARCHAR(64) NOT NULL,
                    buyer_name VARCHAR(100) DEFAULT NULL,
                    amount INT NOT NULL,
                    status VARCHAR(20) NOT NULL DEFAULT 'pending',
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            ]], function()
                                        ensureTable('koja_carmarket_slot_owners', [[
                CREATE TABLE IF NOT EXISTS koja_carmarket_slot_owners (
                    slot_id VARCHAR(64) NOT NULL PRIMARY KEY,
                    zone_id VARCHAR(50) NOT NULL,
                    owner_identifier VARCHAR(64) NOT NULL,
                    weekly_fee INT NOT NULL DEFAULT 2000,
                    next_payment_at TIMESTAMP NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            ]], function() TriggerEvent('koja_carmarket:databaseReady') end)
                                    end)
                                end)
                            end)
                        end)
                end)
            end)
            end
            local function afterSellerName()
                exports.oxmysql:fetch("SELECT COUNT(*) as c FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'koja_carmarket_listings' AND COLUMN_NAME = 'transmission'", {}, function(hasTransmission)
                    if hasTransmission and hasTransmission[1] and (hasTransmission[1].c or 0) > 0 then
                        exports.oxmysql:execute('ALTER TABLE koja_carmarket_listings DROP COLUMN transmission', {}, function()
                            KOJA.Shared.KojaCarmarketDebug('^2[' .. resName .. ']^7 Dropped column transmission from koja_carmarket_listings.')
                            nextStep()
                        end)
                    else
                        nextStep()
                    end
                end)
            end

            exports.oxmysql:fetch("SELECT COUNT(*) as c FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'koja_carmarket_listings' AND COLUMN_NAME = 'seller_name'", {}, function(hasSellerName)
                if hasSellerName and hasSellerName[1] and (hasSellerName[1].c or 0) == 0 then
                    exports.oxmysql:execute('ALTER TABLE koja_carmarket_listings ADD COLUMN seller_name VARCHAR(100) DEFAULT NULL', {}, function()
                        KOJA.Shared.KojaCarmarketDebug('^2[' .. resName .. ']^7 Added column seller_name to koja_carmarket_listings.')
                        afterSellerName()
                    end)
                else
                    afterSellerName()
                end
            end)
        end)
    end)
end)
