--
-- networking_announce.lua
-- Copyright (C) 2020 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--

require 'json'
local api = 'http://127.0.0.1:9721'
local session = nil
local sessionok = 0
local function auth(fn)
  jsondata = json.encode({authKey='abcd1234'})
  TheSim:QueryServer(api.."/auth", function(result, isSuccessful, resultCode)
    if not isSuccessful then return end
    if resultCode==200 then
      print(result)
      res = json.decode(result)
      session = res.session
      verifydata = json.encode({qq=852314408,sessionKey=session})
      print(jsondata)
      TheSim:QueryServer(api.."/verify", function(result, isSuccessful, resultCode)
        if not isSuccessful then return end
        if resultCode==200 then
          print(result)
          sessionok = os.time()
          fn()
        end
        end, "POST", verifydata)
    end
    end, "POST", jsondata)
end

local function sendMessage(msg)
  local function send(msg)
    print(msg)
    jsondata = json.encode({target=645370675,sessionKey=session,messageChain={{type='Plain',text=msg}}})
    TheSim:QueryServer(api.."/sendGroupMessage", function(result, isSuccessful, resultCode)
      print(isSuccessful)
      if not isSuccessful then return end
      print(resultCode)
      if resultCode==200 then
        print(result)
        sessionok = os.time()
      end
      end, "POST", jsondata)
  end

  if os.time() - sessionok > 30*60 then
    auth(function()send(msg)end)
  else
    send(msg)
  end
end

local msgs = {}

AddPrefabPostInit("world", function(inst)
  -- inst.sendMessage = sendMessage
  -- sendMessage("[Warning] Mod need update")
  inst:DoTaskInTime(1,function()
    if GLOBAL.TheShard:GetShardId()=="10" then
      local oldNetwork_Announce = GLOBAL.Networking_Announcement(message, colour, announce_type)
      GLOBAL.Networking_Announcement = function (message, colour, announce_type)
        if announce_type=="mod" then
          if msgs[message] == nil then
            msgs[message] = true
            sendMessage(message)
          end
        end
        if oldNetwork_Announce then
          return oldNetwork_Announce(message, colour, announce_type)
        end
      end
    end
  end)
end)


