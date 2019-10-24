--
-- p_players.lua
-- Copyright (C) 2019 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--
-- 玩家修改
--
--   受伤降低成长伤害

AddPlayerPostInit(function(inst)
  inst:ListenForEvent("attacked", function()
    if inst and inst.components.combat then
      local weapon = inst.components.combat:GetWeapon()
      if weapon ~= nil then
        local chengzhang = weapon.components.weapon.externaldamage:CalculateModifierFromSource('chengzhang')
        weapon.components.weapon:SetDamage(chengzhang*0.8, 'chengzhang')
      end
    end
  end)
  local function onkilledfn(inst, data)
      local victim = data.victim
      if inst.oldfish_lastkilled == victim.GUID then
        return
      end
      inst.oldfish_lastkilled = victim.GUID
      if victim and victim.components.health then
          local healths = victim.components.health.maxhealth
          inst.components.oldfish:DoDelta_exp(healths)
      end
      if victim and victim.components.health then
          local givemax = math.floor((victim.components.health.maxhealth / 2000))

          for i = 1, givemax do
              local itemexp = SpawnPrefab("oldfish_part_gem")
              if inst.components.inventory then
                  inst.components.inventory:GiveItem(itemexp, nil, inst:GetPosition())
              end
          end

      end
  end
  function oneatfn(inst, data)
    local food = data.food
    if food then
      if food.prefab == "daoyaun_pill" then
        if math.random() < 1/(inst.components.oldfish.xxlevel+1)^2 then
          inst.components.oldfish.xxlevel = inst.components.oldfish.xxlevel + 1
          inst.components.talker:Say('一朝顿悟，等级上升')
          inst.components.oldfish:touxian()
        end
      elseif food.prefab == "hongmeng_pill" then
        inst.components.oldfish.daoyuan = inst.components.oldfish.daoyuan + 25
      else
        local swlingli = math.floor(food.components.edible.healthvalue*0.4 + food.components.edible.hungervalue*0.1 + food.components.edible.sanityvalue*0.5)*100
        inst.components.oldfish:DoDelta_exp(swlingli)
      end
    end
  end
  inst:ListenForEvent("killed", onkilledfn)
  inst:ListenForEvent("oneat", oneatfn)
  inst:DoTaskInTime(1,function()
    if inst.components.oldfish then
      inst.components.oldfish:touxian()
    end
  end)

  local oldDoDelta  = inst.components.health.DoDelta
  inst.components.health.DoDelta = function(self,amount,...)
    if amount < 0 and self.inst.components.oldfish.xxlevel and  self.inst.components.oldfish.xxlevel >= 16 then
      amount = 0
    end
    oldDoDelta(self,amount,...)
  end

  local oldCalcDamage  = inst.components.combat.CalcDamage
  inst.components.combat.CalcDamage = function(self,target, weapon, multiplier,...)
    local old = oldCalcDamage(self,target, weapon, multiplier,...)
    return old + (self.inst.components.oldfish.daoyuan ~= nil and self.inst.components.oldfish.daoyuan  or 0)
  end
end)
