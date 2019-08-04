--
-- c_combat.lua
-- Copyright (C) 2019 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
-- 修复SetLastTarget问题


AddComponentPostInit("combat", function(Combat)
  function Combat:SetTarget(target)
    if self.inst:IsValid() then
      if target ~= self.target and (not target or self:IsValidTarget(target)) and not (target and target.sg and target.sg:HasStateTag("hiding") and target:HasTag("player")) then
        self:DropTarget(target ~= nil)
        self:EngageTarget(target)
      end
    end
  end
end)
