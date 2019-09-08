--
-- c_follower.lua
-- Copyright (C) 2019 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--


AddComponentPostInit("named", function (Follower)
  local oldSetLeader = Follower.SetLeader
  function Follower:SetLeader(inst)
    if self.inst:IsValid() and inst:IsValid() then
      return oldSetLeader(self, inst)
    end
  end
end)
