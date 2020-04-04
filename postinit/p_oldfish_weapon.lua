--
-- p_oldfish_weapon.lua
-- Copyright (C) 2019 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--
-- 修改诸神黄昏mod武器性能
--
--
require "vector3"
local oldfishs = {
  "two_oldfish",
  "tz_icesword",
  "tz_spear",
  "oldfish_girl",
  "eight_oldfish",
  "fifteen_oldfish",
  "oldfish_axe",
  "seventeen_oldfish",
  "nineteen_oldfish",
  "four_oldfish",
  "oldfish_ex",
  "five_oldfish",
  "six_oldfish",
  "seven_oldfish",
  "sixteen_oldfish",
  "eleven_oldfish",
  "oldfish_demon",
  "one_oldfish",
  "oldfish_rose",
  "eighteen_oldfish"
}
local onequips = {}
local onunequips = {}
local onattacks = {}
local says = {}
says["two_oldfish"] = "所有人都会原谅我，这就是绿色的力量！"
says["tz_icesword"] = "拔刀术，就是原地待得越久越强..."
says["tz_spear"] = "死肥宅当然不怕死"
says["oldfish_girl"] = "我也是女武神了！"
says["eight_oldfish"] = "它可以陪你到永远~就是不能陪你升级"
says["fifteen_oldfish"] = "不要打我，不要打我~"
says["oldfish_axe"] = "次数够多，总会打死的"
says["seventeen_oldfish"] = "远离尘世的理想乡"
says["nineteen_oldfish"] = "越来越快~"
says["four_oldfish"] = "我也会催眠粉了！"
says["oldfish_ex"] = "对城宝具"
says["five_oldfish"] = "电疗！"
says["six_oldfish"] = "乾坤大挪移~"
says["seven_oldfish"] = "不会丢的神器"
says["sixteen_oldfish"] = "冷热酸甜，想吃就吃~"
says["eleven_oldfish"] = "飞一般的感觉~"
says["oldfish_demon"] = "越来越远"
says["one_oldfish"] = "无视防御"
says["oldfish_rose"] = "温柔点~"
-- says["eighteen_oldfish"] = "黑夜给了我黑色的眼睛，我却用它寻找光明"

onattacks["oldfish_rose"] = function (inst, attacker, target)
  target._one = target._one and target._one + 1 or 1
  if target.components.combat then
    target.components.combat.externaldamagemultipliers:SetModifier("oldfish_rose", math.max(0,1-target._one * 0.01))
    target.components.combat.externaldamagetakenmultipliers:SetModifier("oldfish_rose", 1+target._one * 0.03)
  end
end

onequips["oldfish_demon"] = function(inst, owner)
  local range = math.max((inst.levelcount or 1) * 3, 8)
  inst.components.weapon:SetRange(range, range+2)
end

onattacks["one_oldfish"] = function (inst, attacker, target)
  if not target.components.health:IsDead()
    and not string.find(target.prefab, "wall_") then
    local value = inst.components.weapon.damage
    if target and target:IsValid() and target.components.health and target.components.health.currenthealth > 0 then
      target.components.combat:GetAttacked(attacker, value/(1-target.components.health.absorb+0.001)/(target.components.combat.externaldamagetakenmultipliers:Get()+0.001), inst)
    end
  end
end

onattacks["oldfish_girl"] = function (inst, attacker, target)
  if not target.components.health:IsDead()
    and not string.find(target.prefab, "wall_") then
    local damage = inst.components.weapon.damage
    local delta = damage * 0.01

    attacker.battleborn = attacker.battleborn + delta

    if attacker.battleborn > 1 then
      attacker.components.health:DoDelta(attacker.battleborn, false, "battleborn")
      attacker.components.sanity:DoDelta(attacker.battleborn)
      attacker.battleborn = 0
    end

  end
end

onequips["oldfish_girl"] = function(inst, owner)
  owner.battleborn = 0
  owner.battlaborn_time = 0
  owner.components.combat.externaldamagetakenmultipliers:SetModifier("oldfish_girl", 0.75)
  owner.components.combat.externaldamagemultipliers:SetModifier("oldfish_girl", 1.25)

end
onunequips["oldfish_girl"] = function(inst, owner)
  owner.components.combat.externaldamagetakenmultipliers:RemoveModifier("oldfish_girl")
  owner.components.combat.externaldamagemultipliers:RemoveModifier("oldfish_girl")
end
onequips["tree_oldfish"] = function (inst, owner)
  inst.exp = inst.exp and inst.exp or 0
end
onattacks["tree_oldfish"] = function (inst, attacker, target)
  if target.components.health and target.components.health:IsDead() then
    inst.exp = inst.exp + target.components.health.maxhealth
    while inst.exp > 10000 do
      inst.exp = inst.exp - 10000
      inst.components.trader.onaccept(inst, attacker, inst)
    end
  end
end
onequips["tz_spear"] = function (inst, owner)
  inst.level = inst.levelcount
  inst.components.equippable.walkspeedmult = 0.8 - inst.level * 0.1
  if inst.level > 0 then
    owner._tz_spear = owner:DoPeriodicTask(6/inst.level, function()
      if owner.components.hunger and owner.components.health then
        local dis = owner.components.hunger.max*0.1
        if owner.components.hunger.current > dis and owner.components.health.currenthealth + dis < owner.components.health.maxhealth then
          owner.components.hunger:DoDelta(-dis)
          owner.components.health:DoDelta(dis/6*inst.level)
        end
      end
    end)
  end
end
onunequips["tz_spear"] = function (inst, owner)
  if owner._tz_spear then
    owner._tz_spear:Cancel()
    owner._tz_spear = nil
  end
end
onequips["eleven_oldfish"] = function (inst, owner)
  inst.components.equippable.walkspeedmult = 2.25
end
local function unfreeze(inst, data)
  inst.components.freezable:Unfreeze()
end
onequips["sixteen_oldfish"] = function (inst, owner)
  if inst.levelcount < 6 then return end
  -- 免疫火、电、冰
  -- 防电
  inst.components.equippable.insulated = true
  -- 防水
  if inst.components.waterproofer == nil then
    inst:AddComponent("waterproofer")
  end
  -- 防火
  owner._sixteen_oldfish = owner.components.health.fire_damage_scale
  owner.components.health.fire_damage_scale = 0
  -- 防冰冻
  owner:ListenForEvent("freeze", unfreeze)
end
onunequips["sixteen_oldfish"] = function (inst, owner)
  if inst.levelcount < 6 then return end
  owner.components.health.fire_damage_scale = owner._sixteen_oldfish or 1
  owner:RemoveEventCallback("freeze", unfreeze)
end
onequips["seven_oldfish"] = function (inst, owner)
  if inst.levelcount < 6 then return end
  owner._seven_oldfish = function(owner, data)
    owner:RemoveEventCallback("dropitem", owner._seven_oldfish)
    if data.item.prefab == "seven_oldfish"  then
      owner.components.inventory:Equip(inst)
    end
  end
  owner:ListenForEvent("dropitem", owner._seven_oldfish)
end

onequips["six_oldfish"] = function (inst, owner)
  local level = inst.levelcount or 0
  owner.components.combat.redirectdamagefn = function(inst, attacker, damage, weapon, stimuli)
    if math.random(1,6000)<owner.oldfish_level:value()*level then
      local dmg = damage * (1-owner.components.health.absorb) * owner.components.combat.externaldamagetakenmultipliers:Get()
      local percent = dmg/(owner.components.health.currenthealth or 100)
      if attacker.components.combat and attacker.components.health then
        attacker.components.combat:GetAttacked(owner, percent*attacker.components.health.currenthealth, weapon)
      end
      return attacker
    end
    return nil
  end
end
onunequips["six_oldfish"] = function (inst, owner)
  owner.components.combat.redirectdamagefn = nil
end
onequips["five_oldfish"] = function (inst, owner)
  if inst.levelcount < 6 then return end
  if owner.components.builder then
    owner.components.builder.science_bonus = 2
    owner.components.builder.magic_bonus = 2
    owner.components.builder.ancient_bonus = 2
    owner.components.builder.shadow_bonus = 2
  end
  if inst.components.weapon.overridestimulifn == nil then
    inst.components.weapon:SetOverrideStimuliFn(function(weapon, inst, target)
      return "electric"
    end)
  end
end
onunequips["five_oldfish"] = function (inst, owner)
  if owner.components.builder then
    owner.components.builder.science_bonus = 0
    owner.components.builder.magic_bonus = 0
    owner.components.builder.ancient_bonus = 0
    owner.components.builder.shadow_bonus = 0
  end
end
onattacks["oldfish_ex"] = function (inst, attacker, target)
  if inst.levelcount < 6 then return end
  local x,y,z = target.Transform:GetWorldPosition()
  local range = 4
  local ents = TheSim:FindEntities(x, y, z, range, { "_combat" })
  local combat = attacker.components.combat
  for i, ent in ipairs(ents) do
    if ent ~= target and
      ent ~= attacker and
      combat:IsValidTarget(ent) then
      ent.components.combat:GetAttacked(attacker, combat:CalcDamage(ent, inst),inst)
    end
  end
end
onequips["four_oldfish"] = function(inst, owner)
  if owner._four_oldfish == nil then
    owner._four_oldfish = 0.7
    -- cuimianfen(owner)
  end
  owner._four_oldfish = 1-owner.oldfish_level:value()/1000
end
onunequips["four_oldfish"] = function(inst, owner)
  owner._four_oldfish = 1
end
onequips["seventeen_oldfish"] = function(inst, owner)
  if inst.levelcount < 6 then return end
  if owner and owner.components.health then
    owner._oldfish_task = owner:DoPeriodicTask(0.1, function(inst)
      local health = inst.components.health
      local percent = health:GetPercent()
      if percent < 0.1 then
        inst.components.health:DoDelta(health.maxhealth*0.01)
      end
      inst.components.combat.externaldamagetakenmultipliers:SetModifier("seventeen_oldfish", percent)
      inst.components.combat.externaldamagemultipliers:SetModifier("seventeen_oldfish", 1+percent)
    end)
  end
end
onunequips["seventeen_oldfish"] = function(inst, owner)
  if inst.levelcount < 6 then return end
  owner.components.combat.externaldamagemultipliers:RemoveModifier("seventeen_oldfish")
  owner.components.combat.externaldamagetakenmultipliers:RemoveModifier("seventeen_oldfish")
  if owner._oldfish_task then
    owner._oldfish_task:Cancel()
    owner._oldfish_task = nil
  end
end
onattacks["nineteen_oldfish"] = function (inst, attacker, target, skipsanity)
  if attacker and attacker.components.combat then
    local period = attacker.components.combat.min_attack_period
    attacker.components.combat:SetAttackPeriod(period*0.9)
  end
end
onequips["nineteen_oldfish"] = function(inst, owner)
  owner._default_period = owner.components.combat.min_attack_period
end
onunequips["nineteen_oldfish"] = function(inst, owner)
  owner.components.combat:SetAttackPeriod(owner._default_period)
  owner._default_period = nil
end

onattacks["oldfish_axe"] = function (inst, attacker, target, skipsanity)
  if inst.levelcount < 6 then return end
  if target
    and target.components.health
    and not string.find(target.prefab, "wall_")
    then
    target.components.health:DeltaPenalty(0.005)
  end
  if attacker and attacker.components.health then
    attacker.components.health:DeltaPenalty(0.002)
  end
end
onattacks["two_oldfish"] = function (inst, attacker, target, skipsanity)
  if inst.levelcount < 6 then return end
  if target._forgive==nil then
    target._forgive = attacker
    if target.components.combat then
      local oldCanHitTarget = target.components.combat.CanHitTarget
      target.components.combat.CanHitTarget = function (self, target, weapon)
        if self.inst._forgive and target and target == self.inst._forgive and target:HasTag("oldforgiver") then
          if self.inst.components.talker then
            self.inst.components.talker:Say("我原谅你了")
          end
          self.inst._forgive = self.inst
          self:GiveUp()
          return false
        end
        return oldCanHitTarget()
      end
    end
  end
  target._forgive = attacker
end
onequips["two_oldfish"] = function(inst, owner)
  if inst.levelcount < 6 then return end
  owner:AddTag("oldforgiver")
end
onunequips["two_oldfish"] = function(inst, owner)
  if inst.levelcount < 6 then return end
  if owner:HasTag("oldforgiver") then
    owner:RemoveTag("oldforgiver")
  end
end
onequips["fifteen_oldfish"] = function(inst, owner)
  if inst.levelcount < 6 then return end
  owner:AddTag("notarget")
end
onunequips["fifteen_oldfish"] = function(inst, owner)
  if inst.levelcount < 6 then return end
  if owner:HasTag("notarget") then
    owner:RemoveTag("notarget")
  end
end
onattacks["eight_oldfish"] = function (inst, attacker, target, skipsanity)
  if inst.levelcount < 6 then return end
  local dmg = target.components.health and target.components.health.currenthealth*0.1 or 1
  local absorb = (1-target.components.health.absorb)*target.components.combat.externaldamagetakenmultipliers:Get()
  local damage = 2*attacker.components.combat:CalcDamage(target, inst)
  target.components.combat:GetAttacked(attacker, dmg/(absorb+0.1), inst)
  if attacker.components.oldfish then
    attacker.components.oldfish:DoDelta_exp(-damage)
  end
end
onequips["eight_oldfish"] = function(inst, owner)
  local damage = owner.oldfish_level:value()*((inst.levelcount-2)/2)^2
  inst.components.weapon:SetDamage(damage)
  if inst.components.finiteuses then
    inst:RemoveComponent("finiteuses")
  end
end

onequips["tz_icesword"] = function(inst, owner)
  if inst.levelcount < 6 then return end
  local pt = Vector3(inst.Transform:GetWorldPosition())
  inst._stronger = inst:DoPeriodicTask(1, function(inst)
    local tpt = Vector3(inst.Transform:GetWorldPosition())
    local damage = inst.components.weapon.damage
    if tpt:DistSq(pt) < 2 then
      inst.components.weapon:SetDamage(damage*1.01)
    else
      inst.components.weapon:SetDamage(damage/1.1)
    end
  end)
end
onunequips["tz_icesword"] = function(inst, owner)
  if inst.levelcount < 6 then return end
  if inst._stronger ~= nil then
    inst._stronger:Cancel()
    inst._stronger = nil
  end
end

for _, v in pairs(oldfishs) do
  AddPrefabPostInit(v, function (inst)
    inst:ListenForEvent("equipped", function(inst, data)
      if onequips[v] then
        onequips[v](inst, data.owner)
      end
      if says[v] then
        data.owner.components.talker:Say(says[v])
      end
    end)
    if onattacks[v] then
      local oldOnattack = inst.components.weapon.onattack
      inst.components.weapon:SetOnAttack(function (inst, attacker, target, skipsanity)
        oldOnattack(inst, attacker, target, skipsanity)
        onattacks[v](inst, attacker, target, skipsanity)
      end)
    end
    if onunequips[v] then
      inst:ListenForEvent("unequipped", function(inst, data)
        onunequips[v](inst, data.owner)
      end)
    end
  end)
end

