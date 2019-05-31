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

c_onattack = {}

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
  if target and target:IsValid() and target.components.health then
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
  if target and target:IsValid() and target.components.health and target.components.health:IsDead() and target.components.health.maxhealth > 1000 and math.random() < 0.1 then
    local chengzhang = self.exterlist['chengzhang'] or 0
    self:AddDamage('chengzhang', chengzhang+v)
  end
end

c_onattack.sharp = function(self, attacker, target, v)
  -- 锋锐
  -- 部分伤害破甲
  local modifier = v/(5+v)
  if math.random() < modifier and target.components.health then
    local damagetaken = (1-target.components.health.absorb or 0)*target.components.combat.externaldamagetakenmultipliers:Get()
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
  Weapon.basedamage = 0
  Weapon.exterlist = {}
  Weapon.externaldamage = SourceModifierList(Weapon.inst, 1, SourceModifierList.additive)
  function Weapon:AddDamage(key, value)
    if self.basedamage == 0 then
      self.basedamage = self.damage
    end
    if value < 0 then return end
    self.externaldamage:SetModifier(key, value)
    self.exterlist[key] = value
    self.damage = self.basedamage + self.externaldamage:Get()
  end
  function Weapon:SetDamage(dmg)
    if dmg==nil then
      return
    end
    self.basedamage = dmg
    self.damage = self.basedamage + self.externaldamage:Get()
  end
  function Weapon:OnSave()
    self.types = self.types or {}
    return
    {
      basedamage = self.basedamage or 0,
      exterlist = self.exterlist,
      types = self.types
    }
  end
  function Weapon:OnLoad(data)
    if data.exterlist ~= nil then
      self.exterlist = data.exterlist
      for k, v in pairs(data.exterlist) do
        self.externaldamage = SourceModifierList(Weapon.inst, 1, SourceModifierList.additive)
        self.externaldamage:SetModifier(k, v)
      end
      self.damage = self.basedamage + self.externaldamage:Get()
    end
    self.basedamage = data.basedamage or 0
    self.types = data.types or {}
  end
  local oldOnAttack = Weapon.OnAttack
  function Weapon:OnAttack(attacker, target, projectile)
    oldOnAttack(self, attacker, target, projectile)
    if target and target:IsValid() then
      for k,v in pairs(self.types or {}) do
        if c_onattack[k] then
          c_onattack[k](self, attacker, target, v)
        end
      end
    end
  end
end)
