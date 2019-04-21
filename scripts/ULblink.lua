local statist = require("ULmathstatist")

local _blink = {}

function _blink.run(inst)
    local currentposition_x = { 0, 0, 0, 0, 0 }
    local currentposition_z = { 0, 0, 0, 0, 0 }
    local indexnow = 1
    local spawn_fx = {
        "spawn_fx_medium",
        "spawn_fx_small",
        "spawn_fx_small_high",
        "spawn_fx_tiny",
    }

    local function doBlink(inst, target)
        if statist.varp(currentposition_x) < 1 and statist.varp(currentposition_z) < 1 then

            local x, y, z = inst.Transform:GetWorldPosition()
            local fxindex = math.random(1, #spawn_fx)
            local fx = SpawnPrefab(spawn_fx[fxindex])
            if fx ~= nil then
                fx.Transform:SetPosition(x, y, z)
                fx.Transform:SetScale(3, 3, 3)
            end

            local pt = target:GetPosition()
            fxindex = math.random(1, #spawn_fx)
            fx = SpawnPrefab(spawn_fx[fxindex])
            if fx ~= nil then
                pt.x = pt.x + math.random(-3, 3)
                pt.z = pt.z + math.random(-3, 3)
                fx.Transform:SetPosition(pt.x, pt.y, pt.z)
                fx.Transform:SetScale(3, 3, 3)
                inst.Transform:SetPosition(pt.x, pt.y, pt.z)
            end

        end

    end

    local function onPeriodicTaskBlink(inst)

        local target = inst.components.combat.target
        --print("function working")
        if (target ~= nil and
                target:HasTag("player") and
                target:IsNear(inst, 15 + inst:GetPhysicsRadius(0) + target:GetPhysicsRadius(0))) and not
        target:IsNear(inst, 5 + inst:GetPhysicsRadius(0) + target:GetPhysicsRadius(0)) then


            local x, y, z = inst.Transform:GetWorldPosition()
            currentposition_x[indexnow] = x
            currentposition_z[indexnow] = z
            indexnow = indexnow + 1
            if indexnow > 5 then
                indexnow = 1
                doBlink(inst, target)
            end

        end
    end

    inst:DoPeriodicTask(3, onPeriodicTaskBlink)
end

return _blink