local _stalker = {}

function _stalker.run(inst, healthrate, regenrate, abosoprate)
    local function OnHealthDelta(inst)
        if inst.components.health:GetPercent() < 0.5 then
            inst.components.health:SetInvincible(true)
            inst.components.health:SetAbsorptionAmount(1)

            inst._fx = SpawnPrefab("forcefieldfx")
            inst._fx.entity:SetParent(inst.entity)
            inst._fx.Transform:SetPosition(0, 0.2, 0)
            inst._fx.Transform:SetScale(2.5, 2.5, 2.5)

            inst:DoTaskInTime(15, function(inst)
                inst.components.health:SetInvincible(false)
                inst.components.health:SetAbsorptionAmount(abosoprate)
                if inst._fx then
                    inst._fx:Remove()
                end
            end)
            inst:RemoveEventCallback("healthdelta", OnHealthDelta)
        end
    end

    healthrate = healthrate or nil
    regenrate = regenrate or nil
    abosoprate = abosoprate or nil

    inst:ListenForEvent("healthdelta", OnHealthDelta)
    inst.components.health:SetAbsorptionAmount(abosoprate)
end
return _stalker