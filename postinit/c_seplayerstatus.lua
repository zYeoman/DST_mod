--
-- c_seplayerstatus.lua
-- Copyright (C) 2020 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--
--
-- 2020-07-11 - 现实每日登录工资

AddPrefabPostInit("world", function(inst)
  inst:ListenForEvent("ms_playerspawn", function(inst, player)
    if player == nil then return end
    player:DoTaskInTime(8, function(player) 
      local datetime = os.date("*t")
      local date = datetime.yday
      if player.components.seplayerstatus then
        if date ~= player.components.seplayerstatus.date then
          player.components.seplayerstatus.date = date
          player.components.seplayerstatus:DoDeltaCoin(10000)
          if player.components.talker then
            player:DoTaskInTime(1, function(player) 
              player.components.talker:Say("每日登录奖励 $10000")
            end)
          end
        end
      end
    end)
  end)
end)

AddComponentPostInit("seplayerstatus", function(seplayerstatus, inst)
function seplayerstatus:OnSave()
    local data = {
        coin = self.coin,
        exp = self.exp,
        level = self.level,
        yes = self.yes,
        precious = self.precious,
        day = self.day,
        date = self.date
    }
    return data
end

function seplayerstatus:OnLoad(data)
    self.coin = data.coin and math.max(0, data.coin) or 0
    self.exp = data.exp or 0
    self.level = data.level or 0
    self.yes = data.yes or false
    if data.precious and #data.precious ~= 0 then
      self.precious = data.precious
    else
      self:preciousbuild()
    end
    self.day = data.day or 0
    self.date = data.date or 0
end
end)

