local _mis = {}

function _mis.GetInstName(inst)
    return inst and inst:GetDisplayName() or "*无名*"
end

function _mis.GetAttacker(data)
    return data and data.attacker and data.attacker:GetDisplayName() or "*无名*"
end

function _mis.AddLootItems(inst)
    inst.components.lootdropper:AddChanceLoot("yellowgem", 0.3)

    inst.components.lootdropper:AddChanceLoot("greengem", 0.3)

    inst.components.lootdropper:AddChanceLoot("orangegem", 0.3)

end

function _mis.StrongHealth(inst, healthrate, regenrate, absorbrate)
    -- if inst.components.health.absorb < absorbrate then
    --     inst.components.health:SetAbsorptionAmount(absorbrate)
    -- end
    if inst.components.combat then
      inst.components.combat.externaldamagetakenmultipliers:SetModifier("bear_strong", 1-absorbrate)
    end
    local ZDhealth = inst.components.health.maxhealth
    local maxhealth = ZDhealth and math.floor(healthrate * (ZDhealth + ZDhealth * (math.random() * .5)))
    inst.components.health:SetMaxHealth(maxhealth)
    inst.components.health:SetPercent(1, true)
    local HXL = inst.components.health.maxhealth and inst.components.health.maxhealth / regenrate * (math.random() * .5 + .5) or 1

    inst.components.health:StartRegen(HXL, .5)
end

-- Character light function
function _mis.Lightbybear(inst)
    -- WatchWorldState 返回的是变化的前一个状态值
    -- 下述代码其实白天和夜晚在发光，黄昏不发光
    if TheWorld.state.isnight or TheWorld.state.isdusk then
        inst.Light:Enable(true)
        inst.Light:SetRadius(10)
        inst.Light:SetFalloff(0.75)
        inst.Light:SetIntensity(.6)
        inst.Light:SetColour(235 / 255, 12 / 255, 12 / 255)
    else
        inst.Light:Enable(false)
    end

    if TheWorld:HasTag("cave") then
        inst.Light:Enable(true)
        inst.Light:SetRadius(10)
        inst.Light:SetFalloff(0.75)
        inst.Light:SetIntensity(.6)
        inst.Light:SetColour(235 / 255, 12 / 255, 12 / 255)
    end
end

--Character health, damagemultiplier, speed amplifier
function _mis.Amplifierbybear(inst, healthrate, damagerate)
    if not inst:HasTag("playerghost") and not inst:HasTag("corpse") then

        local ZDpercent = inst.components.health:GetPercent()
        local ZDhealth = inst.components.health.maxhealth
        local maxhealth = ZDhealth * healthrate
        inst.components.health:SetMaxHealth(maxhealth)
        inst.components.health:SetPercent(ZDpercent, true)

        local ZDmultiplier = 1
        if inst.components.combat.damagemultiplier ~= nil then
            ZDmultiplier = inst.components.combat.damagemultiplier
        end
        inst.components.combat.damagemultiplier = ZDmultiplier * damagerate

    end
end

function _mis.Speedupbybear(inst, speedrate)
    if not inst:HasTag("playerghost") and not inst:HasTag("corpse") then
        local ZDwalkspeed = _G.TUNING.WILSON_WALK_SPEED
        local ZDrunspeed = _G.TUNING.WILSON_RUN_SPEED

        if inst.components.locomotor.walkspeed ~= nil then
            ZDwalkspeed = inst.components.locomotor.walkspeed
        end
        inst.components.locomotor.walkspeed = ZDwalkspeed * speedrate

        if inst.components.locomotor.runspeed ~= nil then
            ZDrunspeed = inst.components.locomotor.runspeed
        end
        inst.components.locomotor.runspeed = ZDrunspeed * speedrate
    end
end

local function DoSpawnMeteor(target)
    local pt = target:GetPosition()
    local theta = math.random() * 2 * PI
    --spread the meteors more once the player is a ghost
    --increase the radius when the play is a ghost, avoiding destroying the player's dropped items.
    local radius = target:HasTag("playerghost") and
            math.random(math.random(1, 3) + 1, 15 + math.random(1, 3) * 2) or math.random(math.random(1, 3) - 1, 5 + math.random(1, 3) * 2)
    local offset = _G.FindWalkableOffset(pt, theta, radius, 12, true)
    if offset ~= nil then
        pt.x = pt.x + offset.x
        pt.z = pt.z + offset.z
    end
    SpawnPrefab("shadowmeteor").Transform:SetPosition(pt.x, 0, pt.z)
end

function _mis.SpawnEndMeteors(maxmeteors)
    for n = 1, math.random(maxmeteors or 150) do
        for i, v in ipairs(_G.AllPlayers) do
            --v:DoTaskInTime((math.random() + .33) * n * .5, DoSpawnMeteor, n)
            if n <= 10 then
                v:DoTaskInTime((0.5 + math.random() * 0.5), DoSpawnMeteor)
            end
            v:DoTaskInTime((math.random() + .33) * n * .5, DoSpawnMeteor)
        end
    end
end

return _mis
