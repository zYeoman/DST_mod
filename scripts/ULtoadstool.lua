local _toadstool = {}

function _toadstool.run(inst, healthrate, regenrate, abosoprate)


    local function DoSpawnCircle(inst)

        local x0, y0, z0 = inst.Transform:GetWorldPosition()
        local radius = 3
        local numberpoint = 3
        local function onceCircle(inst)
            for i = 1, numberpoint do
                --print("for is working")
                --注意：sin的输入在(-PI,PI)，cos的输入在[-PI,PI]
                local x = x0 + radius * (math.sin(math.rad((359 / numberpoint * i) - 180)))
                local z = z0 + radius * (math.cos(math.rad((359 / numberpoint * i) - 180)))
                local y = y0
                local fx = SpawnPrefab("statue_transition_2")
                if fx ~= nil then
                    fx.Transform:SetPosition(x, y, z)
                    fx.Transform:SetScale(1, 2, 1)
                end

                fx = SpawnPrefab("statue_transition")
                if fx ~= nil then
                    fx.Transform:SetPosition(x, y, z)
                    fx.Transform:SetScale(1, 1.5, 1)
                end
            end
            local ents = _G.TheSim:FindEntities(x0, y0, z0, radius, { 'player' })
            local scale = 1
            for k, v in pairs(ents) do
                scale = _G.TUNING.WILSON_WALK_SPEED / v.components.locomotor.walkspeed
                v.Transform:SetScale(scale, scale, scale)
            end
            radius = radius + 2
            numberpoint = numberpoint + 2
        end
        for ii = 1, _G.TUNING.TOADSTOOL_DEAGGRO_DIST, 2 do
            inst:DoTaskInTime(ii * 0.05, onceCircle)
        end

    end

    local function OnPeriodicTask(inst)
        local x0, y0, z0 = inst.Transform:GetWorldPosition()
        local radius = _G.TUNING.TOADSTOOL_DEAGGRO_DIST
        local ents = _G.TheSim:FindEntities(x0, y0, z0, radius, { 'player' })
        local scale = 1
        for k, v in pairs(ents) do
            --移速越高，变得越小
            scale = _G.TUNING.WILSON_WALK_SPEED / v.components.locomotor.walkspeed
            v.Transform:SetScale(scale, scale, scale)
            local x, y, z = v.Transform:GetWorldPosition()
            local fx = SpawnPrefab("statue_transition")
            if fx ~= nil then
                fx.Transform:SetPosition(x, y, z)
                fx.Transform:SetScale(1, 1.5, 1)
            end
            v:DoTaskInTime(20, function(inst)
                v.Transform:SetScale(1, 1, 1)
            end)
            --攻击太高的人受到惩罚
            if v.components.combat.damagemultiplier*v.components.combat.externaldamagemultipliers:Get() > 5 then
                v.components.hunger:DoDelta(-50)
                v.components.combat:GetAttacked(inst, 200)
                fx = SpawnPrefab("die_fx")
                if fx ~= nil then
                    fx.Transform:SetPosition(x, y, z)
                    fx.Transform:SetScale(1, 1, 1)
                end

            end
        end
    end

    healthrate = healthrate or nil
    regenrate = regenrate or nil
    abosoprate = abosoprate or nil
    inst:DoPeriodicTask(15, OnPeriodicTask)
    inst.components.health:SetAbsorptionAmount(abosoprate)
    inst:DoTaskInTime(1, DoSpawnCircle)
    inst:DoTaskInTime(1.5, OnPeriodicTask)
end
return _toadstool
