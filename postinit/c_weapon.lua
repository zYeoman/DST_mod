--
-- c_weapon.lua
-- Copyright (C) 2019 Yongwen Zhuang <zeoman@163.com>
--
-- Distributed under terms of the MIT license.
--
-- 修改Weapon使之存储武器伤害、以及更多属性
-- types = {}
-- types.sometype = n
-- types: fire,
-- c_onattack.fire = function(self, attacker, target, v)
-- 点燃，降低伤害和护甲
-- c_onattack.ice = function(self, attacker, target, v)
-- 冰冻
-- c_onattack.lifesteal = function(self, attacker, target, v)
-- 吸血
-- c_onattack.shrinker = function(self, attacker, target, v)
-- 减速
-- c_onattack.crit = function(self, attacker, target, v)
-- 暴击
-- c_onattack.vorpal = function(self, attacker, target, v)
-- 秒杀
-- c_onattack.poison = function(self, attacker, target, v)
-- 剧毒
-- c_onattack.repair = function(self, attacker, target, v)
-- 再生
-- c_onattack.grow = function(self, attacker, target, v)
-- 成长
-- c_onattack.sharp = function(self, attacker, target, v)
-- 锋锐
-- c_onattack.dehealth = function(self, attacker, target, v)
-- 剧毒
-- c_onattack.thorny = function(self, attacker, target, v)
-- 带刺
-- c_onattack.slippery = function(self, attacker, target, v)
-- 湿滑
-- c_onattack.disappear = function(self, attacker, target, v)
-- 残破

local SourceModifierList = require("util/sourcemodifierlist")
local function debounce(inst, name, time, fx)
  if inst._debounce == nil then
    inst._debounce = {}
  end
  if inst._debounce[name] then
    inst._debounce[name]:Cancel()
  end
  inst._debounce[name] = inst:DoTaskInTime(time, fx)
end

local c_onattack = {}

c_onattack.fire = function(self, attacker, target, v)
  -- 点燃，降低伤害和护甲
  local modifier = v/(3+v)
  target._onignite = math.max(target._onignite or 0, modifier)
  if math.random() < modifier and target.components.combat then
    local fx = SpawnPrefab("explode_small")
    fx.Transform:SetPosition(target.Transform:GetWorldPosition())
    if target.components.burnable and not target.components.burnable:IsBurning() then
      if target.components.freezable and target.components.freezable:IsFrozen() then
        target.components.freezable:Unfreeze()
      else
        target.components.burnable:Ignite()
        target.components.burnable:SetBurnTime(10*modifier)
        target.components.combat.externaldamagemultipliers:SetModifier("onignite", 1-target._onignite)
        target.components.combat.externaldamagetakenmultipliers:SetModifier("onignite", 1+2*target._onignite)
      end
    end
    if target.components.freezable then
      target.components.freezable:AddColdness(-1)
      if target.components.freezable:IsFrozen() then
        target.components.freezable:Unfreeze()
      end
    end
  end
  debounce(target, "fire", 10*modifier, function()
    target.components.combat.externaldamagemultipliers:RemoveModifier("onignite")
    target.components.combat.externaldamagetakenmultipliers:RemoveModifier("onignite")
  end)
end

c_onattack.ice = function(self, attacker, target, v)
  -- 冰冻
  local modifier = v/(3+v)
  if math.random() < modifier then
    if target.components.freezable then
      target.components.freezable:AddColdness(4+6*modifier, modifier*10)
      target.components.freezable:SpawnShatterFX()
    end
    if target.components.burnable and target.components.burnable:IsBurning() then
      target.components.burnable:Extinguish()
    end
  end
end

c_onattack.lifesteal = function(self, attacker, target, v)
  local modifier = 0.1*v/(3+v)
  if attacker.components.health then
    attacker.components.health:DoDelta(modifier*self.damage)
  end
end

c_onattack.shrinker = function(self, attacker, target, v)
  local modifier = 3/(3+v)
  if math.random() > modifier then
    if target.components.locomotor then
      target.components.locomotor.walkspeed = modifier*target.components.locomotor.walkspeed
      target.components.locomotor.runspeed = modifier*target.components.locomotor.runspeed
      target:DoTaskInTime(3+modifier*3, function()
        target.components.locomotor.walkspeed = target.components.locomotor.walkspeed/modifier
        target.components.locomotor.runspeed = target.components.locomotor.runspeed/modifier
      end)
    end
  end
end

c_onattack.crit = function(self, attacker, target, v)
  -- 暴击
  local modifier = v/(6+v)
  if math.random() < modifier and target:IsValid() then
    target:DoTaskInTime(0.1, function ()
      if not target.components.health:IsDead() then
        target.components.combat:GetAttacked(attacker, attacker.components.combat:CalcDamage(target, self.inst)*2,self.inst)
      end
    end)
  end
end

c_onattack.vorpal = function(self, attacker, target, v)
  -- 秒杀
  local modifier = v/(10+v)
  local flag = 0
  if true then
    if target.components.health.maxhealth < 5000 and math.random() < modifier then
      flag = 1
    end
    if target.components.health.maxhealth < 20000 and math.random() < modifier*0.1 then
      flag = 1
    end
    if math.random() < modifier*0.01 then
      flag = 1
    end
    if flag == 1 then
      target.components.health:Kill()
      attacker:PushEvent("killed", { victim = target })
      if attacker.components.talker then
        attacker.components.talker:Say("秒了！")
      end
      return
    end
  end
end

c_onattack.poison = function(self, attacker, target, v)
  -- 剧毒
  local modifier = 0.1*v/(6+v)
  target.AnimState:SetMultColour(0,1,1,1)
  target.AnimState:SetAddColour(0,0,0,0)
  for i=1,3+math.floor(modifier*120),2 do
    target:DoTaskInTime(i,function()
      if not target.components.health:IsDead() then
        target.components.health:DoDelta(-target.components.health.currenthealth*modifier)
      end
    end)
  end
  debounce(target, "poison", 3+modifier*120, function()
    target.AnimState:SetMultColour(1,1,1,1)
    target.AnimState:SetAddColour(0,0,0,0)
  end)
end

c_onattack.repair = function(self, attacker, target, v)
  -- 再生
  local modifier = v/(5+v)
  if math.random() < modifier then
    if self.inst.components.finiteuses then
      self.inst.components.finiteuses:Use(-v)
    end
  end
end

c_onattack.grow = function(self, attacker, target, v)
  -- 成长
  if self.grow_from ~= target.GUID
    and target.components.health:IsDead()
    and target.components.health.maxhealth > 1000
    and math.random() < 0.1
  then
    self.grow_from = target.GUID
    local chengzhang = self.externaldamage:CalculateModifierFromSource('chengzhang')
    self:SetDamage(chengzhang+math.random(v*3)-v, 'chengzhang')
  end
end

c_onattack.sharp = function(self, attacker, target, v)
  -- 锋锐
  -- 部分伤害破甲
  local modifier = v/(5+v)
  if math.random() < modifier then
    local damagetaken = (1-target.components.health.absorb or 0)* target.components.combat.externaldamagetakenmultipliers:Get()
    target:DoTaskInTime(0.1, function ()
      if not target.components.health:IsDead() then
        target.components.combat:GetAttacked(attacker, attacker.components.combat:CalcDamage(target, self.inst)*modifier/(damagetaken+0.1),self.inst)
      end
    end)
  end
end
-- 修改颜色 https://forums.kleientertainment.com/forums/topic/69594-solved-how-to-make-character-glow-a-certain-color/

c_onattack.dehealth = function(self, attacker, target, v)
  -- 邪恶
  -- 阻止回血
  local modifier = 1-v/(5+v)
  if target.components.health.regen ~= nil then
    target.AnimState:SetMultColour(0,1,0,1)
    target.AnimState:SetAddColour(0.5,0,0,0)
    local am = target.components.health.regen.amount / (target._dehealth or 1)
    if target._dehealth and target._dehealth > modifier then
      target.components.health.regen.amount = am*modifier
      target._dehealth = modifier
    end
    debounce(target, "dehealth", 10, function()
      target.components.health.regen.amount = am
      target.AnimState:SetMultColour(1,1,1,1)
      target.AnimState:SetAddColour(0,0,0,0)
    end)
  end
end

c_onattack.thorny = function(self, attacker, target, v)
  -- 带刺
  if attacker.components.health then
    attacker.components.health:DoDelta(-v)
  end
end

c_onattack.slippery = function(self, attacker, target, v)
  -- 湿滑
  local modifier = v/(20+v)
  if math.random() < modifier then
    attacker.components.inventory:DropItem(self.inst)
    local fx = SpawnPrefab("small_puff")
    fx.Transform:SetPosition(attacker.Transform:GetWorldPosition())
  end
end

c_onattack.disappear = function(self, attacker, target, v)
  -- 残破
  local modifier = v/(100+v)
  if math.random() < modifier then
    attacker.components.inventory:DropItem(self.inst)
    self.inst:Remove()
    local fx = SpawnPrefab("small_puff")
    fx.Transform:SetPosition(attacker.Transform:GetWorldPosition())
  end
end

AddComponentPostInit("weapon", function(Weapon)
  Weapon.externaldamage = SourceModifierList(Weapon.inst, 1, SourceModifierList.additive)
  function Weapon:SetDamage(dmg, key)
    if dmg==nil then
      return
    end
    if key==nil then
      key='base'
    end
    self.externaldamage:SetModifier(key, dmg)
    self.damage = self.externaldamage:Get()
  end
  function Weapon:OnSave()
    -- TODO: 下次开服改成直接储存_modifiers
    local exterlist = {}
    for source, src_params in pairs(self.externaldamage._modifiers) do
      local m=0
      for _, v in pairs(src_params.modifiers) do
        m = m + v
      end
      exterlist[source] = m
    end
    return
    {
      exterlist = exterlist,
      types = self.types or {}
    }
  end
  function Weapon:OnLoad(data)
    -- TODO: 下次开服改成直接储存_modifiers
    if data.exterlist ~= nil then
      for k, v in pairs(data.exterlist) do
        self.externaldamage:SetModifier(k, v)
      end
    end
    self.damage = self.externaldamage:Get()
    self.types = data.types or {}
  end
  local oldOnAttack = Weapon.OnAttack
  function Weapon:OnAttack(attacker, target, projectile)
    oldOnAttack(self, attacker, target, projectile)
    if target and target:IsValid() and target.components.health and target.components.combat then
      for key,value in pairs(self.types or {}) do
        if c_onattack[key] then
          c_onattack[key](self, attacker, target, value)
        end
      end
    end
  end
end)
