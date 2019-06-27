#! /usr/bin/env lua
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
        weapon.components.weapon:SetDamage(chengzhang*0.9, 'chengzhang')
      end
    end
  end)
end)
