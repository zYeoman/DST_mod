--
-- p_fyjiedeng.lua
-- Copyright (C) 2019 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--
-- 添加挂机功能
local function nojiahu(inst)
  if inst.components.combat then
    inst.components.combat.externaldamagemultipliers:RemoveModifier("jiahu")
    inst.components.combat.externaldamagetakenmultipliers:RemoveModifier("jiahu")
  end
  if inst.components.talker then
    inst.components.talker:Say("灯的力量消失了")
  end
  if inst.prefix ~= nil and inst.oldfish_name ~= nil then
    inst.prefix._labei:SetText(inst.oldfish_name:value())
  end
  if inst._jiahu_flakes_ice then
    inst._jiahu_flakes_ice:Remove()
  end
  if inst._jiahu_flakes_fire then
    inst._jiahu_flakes_fire:Remove()
  end
  inst.components.health:SetMinHealth(0)
  if inst.components.oldfish then
    inst.components.oldfish.name = TUNING.OLDFISH_NAME[math.floor(inst.components.oldfish.level / 100)].name
  end
end
local function jiahu(inst)
  if inst.components.combat then
    inst.components.combat.externaldamagemultipliers:SetModifier("jiahu",0)
    inst.components.combat.externaldamagetakenmultipliers:SetModifier("jiahu",0)
  end
  if inst.components.talker then
    inst.components.talker:Say("我获得了街灯的保护！")
  end
  inst.components.health:SetMinHealth(1)
  if inst.components.oldfish then
    inst._jiahu_oldname = inst.oldfish_name:value()
    inst.components.oldfish.name = "闪耀的加护"
  end
  inst._jiahu_flakes_ice = SpawnPrefab("deer_ice_flakes")
  inst._jiahu_flakes_ice.entity:SetParent(inst.entity)
  inst._jiahu_flakes_fire = SpawnPrefab("deer_fire_flakes")
  inst._jiahu_flakes_fire.entity:SetParent(inst.entity)
end

local function onplayernear(inst, player)
  local ownerlist = inst.ownerlist or nil
  local playerid = player and player.userid or nil
  if ownerlist ~= nil and playerid ~= nil then
    if ownerlist.master == playerid then
      for k,v in pairs(GLOBAL.Ents) do
        if v.prefab == "fyjiedeng" then
          if v ~= inst and v.ownerlist and v.ownerlist.master == playerid then
            inst.ownerlist.master = nil
            player.components.talker:Say("只有第一个街灯有效~")
            return
          end
        end
      end
      if player._jiahu == nil then
        jiahu(player)
        player._jiahu = player:DoPeriodicTask(1,function()
          if not (player:IsValid() and inst:IsValid() and player:IsNear(inst, 10)) then
            nojiahu(player)
            player._jiahu:Cancel()
            player._jiahu = nil
            return
          end
          local x, y, z = inst.Transform:GetWorldPosition()
          local ents = TheSim:FindEntities(x, y, z, 5, {"monster"})
          for k,v in pairs(ents) do
            if v:HasTag("monster") and not v:HasTag("player") then
              v:Remove()
            end
          end
          player.components.health:DoDelta(5)
          player.components.sanity:DoDelta(5)
          player.components.hunger:DoDelta(5)
        end)
      end
    else
      inst.components.playerprox.isclose = false
    end
  end
end


AddPrefabPostInit("fyjiedeng", function (inst)
  if inst.components.playerprox then
    inst.components.playerprox:SetDist(2,3)
    inst.components.playerprox:SetOnPlayerNear(onplayernear)
  end
end)
