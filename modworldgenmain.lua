--
-- modworldgenmain.lua
-- Copyright (C) 2020 Yongwen Zhuang <zyeoman@163.com>
--
-- Distributed under terms of the MIT license.
--

local GROUND = GLOBAL.GROUND

AddRoom("AlchmyFur",{
    colour={r=.1,g=.8,b=.1,a=.50},
    value = GROUND.FOREST,
    contents =  {
        countstaticlayouts={
        },
        countprefabs = {
            alchmy_fur = 1,
        },
        distributepercent = 0.5,
        distributeprefabs= {
            rock1=0.004,
            rock2=0.004,
            evergreen=0.5,
            fireflies=4.5,
            blue_mushroom = .025,
            green_mushroom = .005,
            red_mushroom = .005,
        },
    },
})

local function AddSaDeerRoom(task)
    task.room_choices["AlchmyFur"] = 1
end
AddTaskPreInit("Make a pick", AddSaDeerRoom)

