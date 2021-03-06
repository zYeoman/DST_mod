--
-- c_name.lua
-- Copyright (C) 2019 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--
-- 名称修改

AddComponentPostInit("named", function (Named)
  Named.namelist = {}
  local function DoSetName(self)
    local name = self.nameformat ~= nil and string.format(self.nameformat, self.name) or self.name or STRINGS.NAMES[string.upper(self.inst.prefab)] or ""
    for k, v in pairs(self.namelist) do
      name = name .. '\n' .. v
    end
    self.inst.name = name
    self.inst.replica.named:SetName(self.inst.name or "")
  end
  function Named:PickNewName()
    if self.possiblenames ~= nil and #self.possiblenames > 0 then
      self.name = self.possiblenames[math.random(#self.possiblenames)]
      DoSetName(self)
    end
  end

  function Named:SetName(name, key)
    if name == nil then
      if self.name == nil then
        self.name = STRINGS.NAMES[string.upper(self.inst.prefab)]
        self.inst.name = STRINGS.NAMES[string.upper(self.inst.prefab)]
        self.inst.replica.named:SetName(self.inst.name or "")
      end
    else
      if key~=nil then
        self.namelist[key] = name
      else
        self.name = name
      end
      if self.name == nil then
        self.name = STRINGS.NAMES[string.upper(self.inst.prefab)]
      end
      DoSetName(self)
    end
  end
  function Named:OnSave()
    return
    self.name ~= nil
    and {
      name = self.name,
      nameformat = self.nameformat,
      namelist = self.namelist
    }
    or nil
  end

  function Named:OnLoad(data)
    if data ~= nil and data.name ~= nil then
      self.nameformat = data.nameformat
      self.name = data.name
      self.namelist = data.namelist or {}
      DoSetName(self)
    end
  end

end)

