#! /usr/bin/env lua
--
-- c_deployable.lua
-- Copyright (C) 2020 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--

AddComponentPostInit("deployable", function(Deployable, inst)
  local old_Deploy = Deployable.Deploy
  function Deployable:Deploy(pt, deployer,...)
    if self.inst.prefab=='alchmy_fur' then
      if deployer.components.allachivevent and deployer.components.allachivevent.dragonfly==false then
        if deployer.components.talker then
          deployer.components.talker:Say("我必须获得杀死龙蝇成就才行")
        end
        return false
      end
    end
    return old_Deploy(self, pt, deployer,...)
  end
end)
