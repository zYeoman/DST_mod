--
-- ULstrong.lua
-- Copyright (C) 2019 Yongwen Zhuang <zeoman@163.com>
--
-- Distributed under terms of the MIT license.
--

local _strong = {}
function _strong.antlion(inst)
  local function strongantlion(inst, data)
    inst:RemoveEventCallback("attacked", strongantlion)
    if inst.components.health then
      local regen = _G.TUNING.BOSS_REGEN/100*inst.components.health.maxhealth
      inst.components.health:StartRegen(regen, 10)
    end
  end
  inst:ListenForEvent("onacceptfighttribute", function()
    inst:ListenForEvent("attacked", strongantlion)
  end)
end

function _strong.stalker(inst)
  local function OnHealthDelta(inst)
    if inst.components.health:GetPercent() < 0.5 then
      inst.components.health:SetInvincible(true)
      inst.components.combat.externaldamagetakenmultipliers:SetModifier("yeo_stalker", 0)

      inst._fx = SpawnPrefab("forcefieldfx")
      inst._fx.entity:SetParent(inst.entity)
      inst._fx.Transform:SetPosition(0, 0.2, 0)
      inst._fx.Transform:SetScale(2.5, 2.5, 2.5)

      inst:DoTaskInTime(15, function(inst)
        inst.components.health:SetInvincible(false)
        inst.components.combat.externaldamagetakenmultipliers:RemoveModifier("yeo_stalker")
        if inst._fx then
          inst._fx:Remove()
        end
      end)
      inst:RemoveEventCallback("healthdelta", OnHealthDelta)
    end
  end

  inst:ListenForEvent("healthdelta", OnHealthDelta)
  inst.components.combat.externaldamagetakenmultipliers:RemoveModifier("yeo_stalker")
end

_strong.stalker_atrium = _strong.stalker
_strong.stalker_forest = _strong.stalker

function _strong.beequeen(inst)
  local function DoSpawnLavae(inst)
    local target = inst.components.combat.target
    --print("function working")
    if (target ~= nil and
        target:HasTag("player") and
        target:IsNear(inst, _G.TUNING.BEEQUEEN_AGGRO_DIST + target:GetPhysicsRadius(0))) then
      local pt = target:GetPosition()

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

  inst:DoPeriodicTask(5, OnPeriodicTask)
end

function _strong.klaus(inst)
  local change_num = 1

  local function DoSpawnCircle(inst)

    local x0, y0, z0 = inst.Transform:GetWorldPosition()
    local radius = 8 + math.random(0, 4)
    for i = 1, 8 do
      --注意：sin的输入在(-PI,PI)，cos的输入在[-PI,PI]
      local x = x0 + radius * (math.sin(math.rad((359 / 8 * i) - 180)))
      local z = z0 + radius * (math.cos(math.rad((359 / 8 * i) - 180)))
      local y = y0
      local flag = change_num % 2
      if i % 2 == flag then

        local fire_charge = SpawnPrefab("deer_fire_charge")
        fire_charge.Transform:SetPosition(x, y, z)
        fire_charge:DoTaskInTime(1, function(fire_charge)
          fire_charge:Remove()
          local fire_circle = SpawnPrefab("deer_fire_circle")
          fire_circle.Transform:SetPosition(x, 0, z)
          fire_circle:DoTaskInTime(5, function(fire_circle)
            fire_circle:Remove()
          end)
        end)

      else

        local ice_charge = SpawnPrefab("deer_ice_charge")
        ice_charge.Transform:SetPosition(x, y, z)
        ice_charge:DoTaskInTime(1, function(ice_charge)
          ice_charge:Remove()
          local ice_circle = SpawnPrefab("deer_ice_circle")
          ice_circle.Transform:SetPosition(x, 0, z)
          ice_circle:DoTaskInTime(5, function(ice_circle)
            ice_circle:Remove()
          end)
        end)
      end
    end

  end

  local function OnPeriodicTask(inst)
    inst:DoTaskInTime(1, function(inst)
      DoSpawnCircle(inst)
    end)
    change_num = change_num + 1
  end

  -- inst:DoPeriodicTask(8, OnPeriodicTask)
end

return _strong
