--
-- p_sorapacker.lua
-- Copyright (C) 2021 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--
-- 禁用穹妹打包


AddComponentPostInit("sorapacker", function (sorapacker)
  function  sorapacker:CanPack()
    return false
  end
end)
