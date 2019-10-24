--
-- c_oldfish.lua
-- Copyright (C) 2019 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--
-- 修改诸神黄昏称号系统\升级系统

local support_keys = {'level','custom', 'extra'}

AddComponentPostInit("oldfish", function (oldfish)
  oldfish.namelist = {}

  local function DoSetName(self)
    local name = ''
    if self.namelist then
      for k,v in pairs(support_keys) do
        if self.namelist[v] ~= nil and self.namelist[v] ~= '' then
          name = name .. '\n' .. self.namelist[v]
        end
      end
    end
    self.name = name
  end
  local function update(self)
      if self.level > 250 then
        self.inst:AddTag("electricdamageimmune")
      end
      if self.level > 500 then
        self.inst.components.health.fire_damage_scale = 0
      end
      if self.level > 750 then
        self.inst.components.health:StartRegen(2, 1)
      end
      if self.level > 1000 then
        self.inst.components.combat.externaldamagetakenmultipliers:SetModifier("sq_level_5", 0.25)
      end
      if self.level > 1250 then
        self.inst.components.combat.areahitdamagepercent = 0.5
        self.inst.components.combat.areahitrange = 4
      end
      if self.level > 1500 then
      end
  end

  function oldfish:SetName(name, key)
    if name ~= nil then
      if key == nil then
        key = 'custom'
      end
      self.namelist[key] = name
    end
    if self.namelist['custom'] == nil then
      if TUNING.OLDFISH_NAME[math.floor(self.level / 100)] then
        self.namelist['custom'] = TUNING.OLDFISH_NAME[math.floor(self.level / 100)].name
      end
    end
    DoSetName(self)
  end
  function oldfish:DoDelta_exp(delta)
    if delta > 0 then
      self.exp = self.exp + delta*(self.level % 250 == 0 and 0 or 1)
    else
      self.exp = self.exp + delta
    end
    local up = self.level * 100
    local level_delta = 0
    while self.exp < 0 do
      level_delta = level_delta - 1
      up = up - 100
      self.exp = self.exp + up
    end
    while self.exp >= up do
      level_delta = level_delta + 1
      self.exp = self.exp - up
      up = up + 100
    end
    if level_delta ~= 0 then
      self:DoDelta_level(level_delta)
    end
  end
  function oldfish:touxian()
    self.xxlevel = self.xxlevel or 1
    self.inst.components.combat.externaldamagemultipliers:SetModifier("touxian", math.max(1,self.xxlevel))
    if self.inst.touxian == nil then
      self.inst.touxian = GLOBAL.SpawnPrefab("touxian") 
      self.inst.touxian.entity:SetParent(self.inst.entity) 
      self.inst.touxian:Stext("",3,25,1,true) 
    end 
    self.inst.touxian:Settietu(self.xxlevel)
    if self.xxlevel > 10 then
      local v = self.xxlevel*0.1
      self.inst.Transform:SetScale(v,v,v)
    end
    if self.xxlevel >= 15 then
      self.inst.Light:Enable(true) 
      self.inst.Light:SetRadius(8) 
      self.inst.Light:SetFalloff(.5) 
      self.inst.Light:SetIntensity(0.9) 
      self.inst.Light:SetColour(245/85,85/85,245/85)  
    end
    if self.xxlevel >= 16 then
      self.inst.components.temperature.maxtemp = 40 
      self.inst.components.temperature.mintemp = 10 
    end
  end
  function oldfish:DoDelta_level(delta)
    if self.level + delta <= 0 then
      return
    end
    for i=1,delta do
      self.level = self.level + 1
      if self.level % 250 == 0 then
        delta = i
        break
      end
      if self.xxlevel<16 and self.level >= 2^self.xxlevel then
        self.level = 1
        self.xxlevel = self.xxlevel + 1
        self:touxian()
      end
    end
    local m = 1
    if delta<=0 then
      m = -1
    end
    local t_hunger=0
    local t_san=0
    local t_health=0
    if self.flag == 0 then
      for i=1,math.abs(delta),1 do
        local t_chance = 0.2*(20000-math.max(self.inst.components.hunger.max, self.inst.components.sanity.max, self.inst.components.health.maxhealth))/20000
        if math.random() < t_chance then
          self.inst.components.hunger.max = self.inst.components.hunger.max + m
          t_chance = t_chance / 2
          t_hunger = t_hunger + m
        end
        if math.random() < t_chance then
          self.inst.components.sanity.max = self.inst.components.sanity.max + m
          t_chance = t_chance / 2
          t_san = t_san + m
        end
        if math.random() < t_chance then
          self.inst.components.health.maxhealth = self.inst.components.health.maxhealth + m
          t_chance = t_chance / 2
          t_health = t_health + m
        end
      end
    end
    if self.level > 100 and self.namelist ~= nil and self.namelist.custom ~= nil and self.level<1100 and self.namelist.custom == TUNING.OLDFISH_NAME[math.floor(self.level / 100)-1].name then
      local name = TUNING.OLDFISH_NAME[math.floor(self.level / 100)].name
      self:SetName(name, 'custom')
    end
    self.inst:DoTaskInTime(0.5, function()
      self.inst.components.talker:Say("升级成功！".. (t_hunger~=0 and "最大饥饿+"..t_hunger or "")..(t_san~=0 and" 最大脑残+" .. t_san or "") .. (t_health~=0 and" 最大生命+" .. t_health or ""))
      self.inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
      update(self)
    end)
  end
  function oldfish:OnSave()
    return {
      xxlevel = self.xxlevel,
      daoyuan = self.daoyuan,
      level = self.level,
      exp = self.exp,
      m_health = self.inst.components.health.maxhealth,
      m_san = self.inst.components.sanity.max,
      m_hunger = self.inst.components.hunger.max,
      namelist = self.namelist
    }
  end

  function oldfish:OnLoad(data)
    self.level = data.level or 1
    if data.exp then
      if data.exp>=0 then
        self.exp = data.exp
      else
        self.exp = 0
        self.level = self.level-1
      end
    end
    self.exp = data.exp or 0
    self.m_health = data.m_health or 0
    self.m_sanity = data.m_san or 0
    self.m_hunger = data.m_hunger or 0
    self.xxlevel = data.xxlevel or 1
    self.daoyuan = data.daoyuan or 0
    update(self)
    self:touxian()
    if self.m_health > self.inst.components.health.maxhealth then
      local percent = self.inst.components.health:GetPercent()
      self.inst.components.health.maxhealth = math.min(self.m_health,20000)
      self.inst.components.health:SetPercent(percent)
    end
    if self.m_sanity > self.inst.components.sanity.max then
      local percent = self.inst.components.sanity:GetPercent()
      self.inst.components.sanity.max = math.min(self.m_sanity,20000)
      self.inst.components.sanity:SetPercent(percent)
    end
    if self.m_hunger > self.inst.components.hunger.max then
      local percent = self.inst.components.hunger:GetPercent()
      self.inst.components.hunger.max = math.min(self.m_hunger,20000)
      self.inst.components.hunger:SetPercent(percent)
    end
    self.namelist = data.namelist or {}
    self:SetName()
  end
end)
