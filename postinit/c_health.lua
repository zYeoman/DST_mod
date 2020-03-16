--
-- c_health.lua
-- Copyright (C) 2020 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--
-- 生命设置修改

local SourceModifierList = require("util/sourcemodifierlist")
AddComponentPostInit("health", function (Health)
  Health.externalhealth = SourceModifierList(Health.inst, 0, SourceModifierList.additive)
  local oldSetMaxHealth = Health.SetMaxHealth
  function Health:SetMaxHealth(amount, key)
    if amount==nil then
      return
    end
    if key==nil then
      key = 'base'
    end
    self.externalhealth:SetModifier(key, math.max(amount,1))
    -- self.maxhealth = self.externalhealth:Get()
    oldSetMaxHealth(self, self.externalhealth:Get())
  end
end)
AddComponentPostInit("sanity", function (Sanity)
  Sanity.externalsanity = SourceModifierList(Sanity.inst, 0, SourceModifierList.additive)
  local oldSetMaxSanity = Sanity.SetMax
  function Sanity:SetMax(amount, key)
    if amount==nil then
      return
    end
    if key==nil then
      key = 'base'
    end
    self.externalsanity:SetModifier(key, math.max(amount,1))
    -- self.max = self.externalsanity:Get()
    oldSetMaxSanity(self, self.externalsanity:Get())
  end
end)
AddComponentPostInit("hunger", function (Hunger)
  Hunger.externalhunger = SourceModifierList(Hunger.inst, 0, SourceModifierList.additive)
  local oldSetMaxHunger = Hunger.SetMax
  function Hunger:SetMax(amount, key)
    if amount==nil then
      return
    end
    if key==nil then
      key = 'base'
    end
    self.externalhunger:SetModifier(key, math.max(amount,1))
    -- self.max = self.externalhunger:Get()
    oldSetMaxHunger(self, self.externalhunger:Get())
  end
end)
