local mis = require("ULmiscellaneous")
local StrongHealth = mis.StrongHealth
local SpawnEndMeteors = mis.SpawnEndMeteors
local GetInstName = mis.GetInstName
local GetAttacker = mis.GetAttacker

local _antlion = {}

function _antlion.run(inst, healthrate, regenrate, abosoprate)
    local function strongantlion(inst, data)
        inst:RemoveEventCallback("attacked", strongantlion)
        if inst.persists and inst.components.combat ~= nil then
            StrongHealth(inst, healthrate, regenrate, abosoprate)
            local delaytime = math.floor((math.random() * 0.5 + 0.5) * 3 + 10)
            inst:DoTaskInTime(delaytime, function(inst)
                SpawnEndMeteors(150)
            end)
            TheNet:Announce("〖 " .. GetInstName(inst) .. " 〗受到【 " .. GetAttacker(data) .. " 】的攻击！")
            inst:DoTaskInTime(1, function(inst)
                TheNet:Announce("本地图所有玩家将在" .. (delaytime - 1) .. " 秒后遭受流星雨轰击！")
            end)
        end
    end
    local function delayfreeze(inst)
        inst:ListenForEvent("attacked", strongantlion)
    end
    inst:ListenForEvent("onacceptfighttribute", delayfreeze)
end
return _antlion
