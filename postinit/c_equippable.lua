--
-- c_equippable.lua
-- Copyright (C) 2019 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--
-- 添加装备绑定要素

AddComponentPostInit("equippable", function(Equippable)
  function Equippable:OnSave()
    return
    {
      ownerid = self.inst.onlyownerid
    }
  end

  function Equippable:OnLoad(data)
    if data and data.ownerid then
      self.inst.onlyownerid = data and data.ownerid or nil
    end
  end
end)
