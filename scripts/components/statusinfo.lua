--
-- statusinfo.lua
-- Copyright (C) 2020 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--
-- showme显示信息

local StatusInfo = Class(function(self, inst)
  self.inst = inst
  self.namelist = {}
end)

function StatusInfo:SetName(name, key)
  if name ~= nil then
    if key == nil then
      key = "base"
    end
    self.namelist[key] = name
  end
end


local function Init(self)
  local function GetShowItemInfo(inst)
    local name = ""
    for k, v in pairs(self.namelist) do
      if v~="" then
        name = name .. v
      end
    end
    -- 删除最后一个\n
    return name:sub(1, -2),nil,nil
  end
  self.inst.GetShowItemInfo = GetShowItemInfo
end

function StatusInfo:Init()
  Init(self)
end

function StatusInfo:OnSave()
  if next(self.namelist) ~= nil then
    return {namelist = self.namelist}
  end
  return nil
end

function StatusInfo:OnLoad(data)
  Init(self)
  if data then
    self.namelist = data.namelist or {}
  end
end

return StatusInfo
