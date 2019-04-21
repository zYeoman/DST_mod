local _beequeen = {}

function _beequeen.run(inst, healthrate, regenrate, abosoprate)

    local function DoSpawnLavae(inst)
        local target = inst.components.combat.target
        --print("function working")
        if (target ~= nil and
                target:HasTag("player") and
                target:IsNear(inst, _G.TUNING.BEEQUEEN_AGGRO_DIST + target:GetPhysicsRadius(0))) then
            local pt = target:GetPosition()
            --local theta = math.random() * 2 * PI
            --local radius = math.random(math.random(1, 3) + 1, 15 + math.random(1, 3) * 2)
            --local offset = _G.FindWalkableOffset(pt, theta, radius, 12, true)
            --if offset ~= nil then
            --    pt.x = pt.x + offset.x
            --    pt.z = pt.z + offset.z
            --end

            local lavae = SpawnPrefab("lavae")
            lavae.Transform:SetPosition(pt.x, 0, pt.z)

            local fx = SpawnPrefab("statue_transition_2")
            if fx ~= nil then
                fx.Transform:SetPosition(pt.x, pt.y, pt.z)
                fx.Transform:SetScale(1, 2, 1)
            end

            fx = SpawnPrefab("statue_transition")
            if fx ~= nil then
                fx.Transform:SetPosition(pt.x, pt.y, pt.z)
                fx.Transform:SetScale(1, 1.5, 1)
            end

            local radius = 3
            for i = 1, 8 do
                local x, y, z = pt.x + radius * math.cos(PI / 4 * i - 0.01 - PI), pt.y, pt.z + radius * math.sin(PI / 4 * i - 0.01 - PI)

                lavae = SpawnPrefab("lavae")
                lavae.Transform:SetPosition(x, 0, z)

                fx = SpawnPrefab("statue_transition_2")
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


        end
    end
    local function OnHealthDelta(inst)
        if inst.components.health:GetPercent() < 0.5 then
            DoSpawnLavae(inst)
        end
        inst:RemoveEventCallback("healthdelta", OnHealthDelta)
    end

    local function OnPeriodicTask(inst)
        inst:ListenForEvent("healthdelta", OnHealthDelta)
    end

    healthrate = healthrate or nil
    regenrate = regenrate or nil

    inst:DoPeriodicTask(5, OnPeriodicTask)
    inst.components.health:SetAbsorptionAmount(abosoprate)
end
return _beequeen