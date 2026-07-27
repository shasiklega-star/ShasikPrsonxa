local function tryCuffPlayer(targetPlayer)
    local success = false

    -- ============================================
    -- СПОСОБ 1: Поиск по ВСЕМ RemoteEvent
    -- ============================================
    pcall(function()
        local allEvents = {}
        local servicesToCheck = {
            game:GetService("ReplicatedStorage"),
            player.PlayerGui
        }

        -- Собираем все RemoteEvent из ReplicatedStorage и PlayerGui
        for _, service in pairs(servicesToCheck) do
            for _, obj in pairs(service:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    table.insert(allEvents, obj)
                end
            end
        end

        -- Пробуем разные варианты вызова для каждого найденного RemoteEvent
        for _, remote in pairs(allEvents) do
            pcall(function()
                -- Пробуем все возможные комбинации аргументов
                remote:FireServer(targetPlayer)
                remote:FireServer(targetPlayer, true)
                remote:FireServer(targetPlayer, false)
                remote:FireServer(targetPlayer.Name)
                remote:FireServer(targetPlayer, "cuff")
                remote:FireServer(targetPlayer, "arrest")
                remote:FireServer({targetPlayer})
                success = true
            end)
            if success then break end
        end
    end)

    -- ============================================
    -- СПОСОБ 2: Через чат-команду (если не сработало)
    -- ============================================
    if not success then
        pcall(function()
            local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            if chat and chat.OnMessageRequested then
                chat.OnMessageRequested:FireServer("/cuff " .. targetPlayer.Name)
                success = true
            end
        end)
    end

    return success
end
