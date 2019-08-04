GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
local _G = GLOBAL
local TheNet = _G.TheNet
local require = _G.require
local SpawnPrefab = _G.SpawnPrefab
local PI = _G.PI
local STRINGS = _G.STRINGS

local BOSS_PERIOD = GetModConfigData("boss_period")
local BIOLOGY_PERIOD = GetModConfigData("biology_period")
local ARMOUR_ARMOR = GetModConfigData("armour_armor")
local MORE_STRENGTHENING = GetModConfigData("more_strengthening")

--血量（BOSS）
TUNING.DRAGONFLY_HEALTH = 27500 * GetModConfigData("health_boss")                            --龙蝇
TUNING.BEARGER_HEALTH = 3000 * 2 * GetModConfigData("health_boss")                           --熊大
TUNING.DEERCLOPS_HEALTH = 2000 * 2 * GetModConfigData("health_boss")                         --巨鹿
TUNING.MOOSE_HEALTH = 3000 * 2 * GetModConfigData("health_boss")                             --鹿角鹅
TUNING.MOSSLING_HEALTH = 350 * 1.5 * GetModConfigData("health_boss")                         --小鸭子
TUNING.MINOTAUR_HEALTH = 2500 * 4 * GetModConfigData("health_boss")                          --远古守护者
TUNING.BEEQUEEN_HEALTH = 22500 * GetModConfigData("health_boss")                             --蜂后
TUNING.TOADSTOOL_HEALTH = 52500 * GetModConfigData("health_boss")                            --普通蛤蟆
TUNING.TOADSTOOL_DARK_HEALTH = 99999 * GetModConfigData("health_boss")                       --毒蛤蟆
TUNING.SPIDERQUEEN_HEALTH = 1250 * 2 * GetModConfigData("health_boss")                       --蜘蛛女皇
TUNING.LEIF_HEALTH = 2000 * 1.5 * GetModConfigData("health_boss")                            --树精
TUNING.WARG_HEALTH = 600 * 3 * GetModConfigData("health_boss")                               --座狼
TUNING.SPAT_HEALTH = 800 * GetModConfigData("health_boss")                                   --钢羊
TUNING.WALRUS_HEALTH = 150 * 2 * GetModConfigData("health_boss")                             --海象
--血量（生物）
TUNING.KOALEFANT_HEALTH = 500 * 2 * GetModConfigData("health_biology")                          --大象
TUNING.TALLBIRD_HEALTH = 400 * 2 * GetModConfigData("health_biology")                           --高脚鸟
TUNING.TENTACLE_HEALTH = 500 * GetModConfigData("health_biology")                               --触手
TUNING.MERM_HEALTH = 250 * 2 * GetModConfigData("health_biology")                               --鱼人
TUNING.WORM_HEALTH = 900 * GetModConfigData("health_biology")                                   --蠕虫
TUNING.WEREPIG_HEALTH = 350 * 1.5 * GetModConfigData("health_biology")                          --疯猪
TUNING.PIG_GUARD_HEALTH = 300 * 2 * GetModConfigData("health_biology")                          --猪人守卫
TUNING.SPIDER_HEALTH = 100 * GetModConfigData("health_biology")                                 --小蜘蛛
TUNING.SPIDER_WARRIOR_HEALTH = 200 * 2 * GetModConfigData("health_biology")                     --蜘蛛战士，白蜘蛛
TUNING.SPIDER_HIDER_HEALTH = 150 * 1.5 * GetModConfigData("health_biology")                     --洞穴蜘蛛
TUNING.SPIDER_SPITTER_HEALTH = 175 * 2 * GetModConfigData("health_biology")                     --喷吐蜘蛛
TUNING.HOUND_HEALTH = 150 * GetModConfigData("health_biology")                                  --狗
TUNING.FIREHOUND_HEALTH = 100 * GetModConfigData("health_biology")                              --火狗
TUNING.ICEHOUND_HEALTH = 100 * GetModConfigData("health_biology")                               --冰狗

--伤害（boss）
TUNING.DRAGONFLY_DAMAGE = 150 * GetModConfigData("damage_boss")                              --龙蝇
TUNING.DRAGONFLY_FIRE_DAMAGE = 300 * GetModConfigData("damage_boss")                         --暴怒龙蝇
TUNING.BEARGER_DAMAGE = 200 * GetModConfigData("damage_boss")                                --熊大
TUNING.DEERCLOPS_DAMAGE = 150 * GetModConfigData("damage_boss")                              --巨鹿
TUNING.MOOSE_DAMAGE = 150 * GetModConfigData("damage_boss")                                  --鹿角鹅
TUNING.MINOTAUR_DAMAGE = 100 * GetModConfigData("damage_boss")                               --远古守护者
TUNING.BEEQUEEN_DAMAGE = 120 * GetModConfigData("damage_boss")                               --蜂后
TUNING.SPIDERQUEEN_DAMAGE = 80 * GetModConfigData("damage_boss")                             --蜘蛛女皇
TUNING.LEIF_DAMAGE = 150 * GetModConfigData("damage_boss")                                   --树精
TUNING.WARG_DAMAGE = 50 * GetModConfigData("damage_boss")                                    --座狼
TUNING.SPAT_MELEE_DAMAGE = 60 * GetModConfigData("damage_boss")                              --钢羊
TUNING.WALRUS_DAMAGE = 33 * GetModConfigData("damage_boss")                                  --海象
--伤害（生物）
TUNING.KOALEFANT_DAMAGE = 50 * GetModConfigData("damage_biology")                               --象
TUNING.TALLBIRD_DAMAGE = 50 * GetModConfigData("damage_biology")                                --高脚鸟
TUNING.TENTACLE_DAMAGE = 34 * GetModConfigData("damage_biology")                                --触手
TUNING.MERM_DAMAGE = 30 * GetModConfigData("damage_biology")                                    --鱼人
TUNING.WORM_DAMAGE = 75 * GetModConfigData("damage_biology")                                    --蠕虫
TUNING.WEREPIG_DAMAGE = 40 * GetModConfigData("damage_biology")                                 --疯猪
TUNING.SPIDER_DAMAGE = 20 * GetModConfigData("damage_biology")                                  --小蜘蛛
TUNING.SPIDER_WARRIOR_DAMAGE = 20 * GetModConfigData("damage_biology")                          --蜘蛛战士，白蜘蛛
TUNING.SPIDER_HIDER_DAMAGE = 20 * GetModConfigData("damage_biology")                            --洞穴蜘蛛
TUNING.SPIDER_SPITTER_DAMAGE_MELEE = 20 * GetModConfigData("damage_biology")                    --喷吐蜘蛛近战伤害
TUNING.HOUND_DAMAGE = 20 * GetModConfigData("damage_biology")                                   --狗
TUNING.FIREHOUND_DAMAGE = 30 * GetModConfigData("damage_biology")                               --火狗
TUNING.ICEHOUND_DAMAGE = 30 * GetModConfigData("damage_biology")                                --冰狗

--攻击间隔
if BOSS_PERIOD then                                           --boss
  TUNING.DRAGONFLY_ATTACK_PERIOD = 1                         --龙蝇
  TUNING.DRAGONFLY_FIRE_ATTACK_PERIOD = 1                    --暴怒龙蝇
  TUNING.BEARGER_ATTACK_PERIOD = 1                           --熊大
  TUNING.DEERCLOPS_ATTACK_PERIOD = 1                         --巨鹿
  TUNING.MOOSE_ATTACK_PERIOD = 1                             --鹿角鹅
  TUNING.MINOTAUR_ATTACK_PERIOD = 1                          --远古守护者
  TUNING.BEEQUEEN_ATTACK_PERIOD = 1                          --蜂后
  TUNING.SPIDERQUEEN_ATTACKPERIOD = 1                        --蜘蛛女皇
  TUNING.LEIF_ATTACK_PERIOD = 1                              --树精
  TUNING.WARG_ATTACKPERIOD = 1                               --座狼
  TUNING.WALRUS_ATTACK_PERIOD = 1                            --海象
  TUNING.SHADOW_ROOK.ATTACK_PERIOD = { 3, 2.75, 1.25 }           --暗影战车
  TUNING.SHADOW_KNIGHT.ATTACK_PERIOD = { 1.5, 1.25, 0.5 }        --暗影骑士
  TUNING.SHADOW_BISHOP.ATTACK_PERIOD = { 7.5, 7, 3 }             --暗影主教

  TUNING.TOADSTOOL_POUND_CD = 8        --毒蕈震地

  TUNING.KLAUS_CHOMP_CD = 2              --克劳斯撕咬

  TUNING.BEEQUEEN_DODGE_SPEED = 18       --蜂后躲避速度

  TUNING.STALKER_SNARE_CD = 3            --化石束缚
end

if BIOLOGY_PERIOD then                                        --生物
  TUNING.TALLBIRD_ATTACK_PERIOD = 1                          --高脚鸟
  TUNING.MERM_ATTACK_PERIOD = 1                              --鱼人
  TUNING.WORM_ATTACK_PERIOD = 1                              --蠕虫
  TUNING.WEREPIG_ATTACK_PERIOD = 1                           --疯猪
  TUNING.SPIDER_ATTACK_PERIOD = 1                            --小蜘蛛
  TUNING.SPIDER_WARRIOR_ATTACK_PERIOD = 1                    --蜘蛛战士，白蜘蛛
  TUNING.SPIDER_HIDER_ATTACK_PERIOD = 1                      --洞穴蜘蛛
  TUNING.SPIDER_SPITTER_ATTACK_PERIOD = 1                    --喷吐蜘蛛
  TUNING.HOUND_ATTACK_PERIOD = 1                             --狗
  TUNING.FIREHOUND_ATTACK_PERIOD = 1                         --火狗
  TUNING.ICEHOUND_ATTACK_PERIOD = 1                          --冰狗
end

--护甲（BOSS）
TUNING.BOSS_ARMOR = GetModConfigData("boss_armor")
local function boss_a(inst)
  if inst.components.health then
    inst.components.health:SetAbsorptionAmount(TUNING.BOSS_ARMOR)
  end
end
AddPrefabPostInit("dragonfly", boss_a)      --龙蝇
AddPrefabPostInit("bearger", boss_a)        --熊大
AddPrefabPostInit("deerclops", boss_a)      --巨鹿
AddPrefabPostInit("moose", boss_a)          --鹿角鹅
AddPrefabPostInit("mossling", boss_a)       --小鸭子
AddPrefabPostInit("minotaur", boss_a)       --远古守护者
AddPrefabPostInit("beequeen", boss_a)       --蜂后
AddPrefabPostInit("toadstool", boss_a)      --普通蛤蟆
AddPrefabPostInit("toadstool_dark", boss_a) --毒蛤蟆
AddPrefabPostInit("spiderqueen", boss_a)    --蜘蛛女皇
AddPrefabPostInit("leif", boss_a)           --树精
AddPrefabPostInit("leif_sparse", boss_a)    --稀有树精
AddPrefabPostInit("warg", boss_a)           --座狼
AddPrefabPostInit("spat", boss_a)           --钢羊
AddPrefabPostInit("walrus", boss_a)         --海象
--护甲（生物）
TUNING.BIOLOGY_ARMOR = GetModConfigData("biology_armor")
local function biology_a(inst)
  if inst.components.health then
    inst.components.health:SetAbsorptionAmount(TUNING.BIOLOGY_ARMOR)
  end
end
AddPrefabPostInit("koalefant_winter", biology_a) --冬象
AddPrefabPostInit("koalefant_summer", biology_a) --夏象
AddPrefabPostInit("tallbird", biology_a)         --高脚鸟
AddPrefabPostInit("tentacle", biology_a)         --触手
AddPrefabPostInit("merm", biology_a)             --鱼人
AddPrefabPostInit("worm", biology_a)             --蠕虫
AddPrefabPostInit("pigman", biology_a)           --猪人
AddPrefabPostInit("spider", biology_a)           --小蜘蛛
AddPrefabPostInit("spider_warrior", biology_a)   --蜘蛛战士
AddPrefabPostInit("spider_dropper", biology_a)   --白蜘蛛
AddPrefabPostInit("spider_hider", biology_a)     --洞穴蜘蛛
AddPrefabPostInit("spider_spitter", biology_a)   --喷吐蜘蛛
AddPrefabPostInit("hound", biology_a)            --狗
AddPrefabPostInit("firehound", biology_a)        --火狗
AddPrefabPostInit("icehound", biology_a)         --冰狗

--回血（BOSS）
TUNING.BOSS_REGEN = GetModConfigData("boss_regen")
--回血（生物）
TUNING.BIOLOGY_REGEN = GetModConfigData("biology_regen")
local function biology_h(inst)
  if inst.components.health then
    inst.components.health:StartRegen(TUNING.BIOLOGY_REGEN, 1)
  end
end
AddPrefabPostInit("koalefant_winter", biology_h) --冬象
AddPrefabPostInit("koalefant_summer", biology_h) --夏象
AddPrefabPostInit("tallbird", biology_h)         --高脚鸟
AddPrefabPostInit("tentacle", biology_h)         --触手
AddPrefabPostInit("merm", biology_h)             --鱼人
AddPrefabPostInit("worm", biology_h)             --蠕虫
AddPrefabPostInit("pigman", biology_h)           --猪人
AddPrefabPostInit("spider", biology_h)           --小蜘蛛
AddPrefabPostInit("spider_warrior", biology_h)   --蜘蛛战士
AddPrefabPostInit("spider_dropper", biology_h)   --白蜘蛛
AddPrefabPostInit("spider_hider", biology_h)     --洞穴蜘蛛
AddPrefabPostInit("spider_spitter", biology_h)   --喷吐蜘蛛
AddPrefabPostInit("hound", biology_h)            --狗
AddPrefabPostInit("firehound", biology_h)        --火狗
AddPrefabPostInit("icehound", biology_h)         --冰狗

--护甲血量
TUNING.ARMORGRASS = 158*GetModConfigData("armour_health")            --草甲血量
TUNING.ARMORWOOD = 315*GetModConfigData("armour_health")             --木甲血量
TUNING.ARMORMARBLE = 735*GetModConfigData("armour_health")           --大理石甲血量
TUNING.ARMORSNURTLESHELL = 735*GetModConfigData("armour_health")     --蜗牛甲血量
TUNING.ARMORRUINS = 1260*GetModConfigData("armour_health")           --远古甲血量
TUNING.ARMOR_FOOTBALLHAT = 315*GetModConfigData("armour_health")     --猪皮帽血量
TUNING.ARMORDRAGONFLY = 945*GetModConfigData("armour_health")        --火甲血量
TUNING.ARMOR_WATHGRITHRHAT = 525*GetModConfigData("armour_health")   --战斗头盔血量
TUNING.ARMOR_RUINSHAT = 840*GetModConfigData("armour_health")        --远古头血量
TUNING.ARMOR_SLURTLEHAT = 525*GetModConfigData("armour_health")      --蜗牛帽血量
TUNING.ARMOR_BEEHAT = 1050*GetModConfigData("armour_health")         --蜂帽血量
TUNING.ARMOR_SANITY = 525*GetModConfigData("armour_health")          --影甲血量

--护甲减伤
if ARMOUR_ARMOR then
  TUNING.ARMORGRASS_ABSORPTION = .7                --草甲减伤
  TUNING.ARMORWOOD_ABSORPTION = .85                --木甲减伤
  --TUNING.ARMORMARBLE_ABSORPTION = .95            --大理石减伤
  TUNING.ARMORSNURTLESHELL_ABSORPTION = 0.7        --蜗牛甲减伤
  TUNING.ARMORRUINS_ABSORPTION = 0.95              --远古甲减伤
  TUNING.ARMOR_FOOTBALLHAT_ABSORPTION = .85        --猪皮帽减伤
  TUNING.ARMORDRAGONFLY_ABSORPTION = 0.8           --火甲减伤
  TUNING.ARMOR_WATHGRITHRHAT_ABSORPTION = .85      --战斗头盔减伤
  TUNING.ARMOR_RUINSHAT_ABSORPTION = 0.95          --远古头减伤
  --TUNING.ARMOR_SLURTLEHAT_ABSORPTION = 0.9       --蜗牛帽减伤
  TUNING.ARMOR_BEEHAT_ABSORPTION = .9              --蜂帽减伤
  --TUNING.ARMOR_SANITY_ABSORPTION = .95           --影甲减伤
end


--武器伤害
TUNING.NIGHTSWORD_DAMAGE = 34*2*GetModConfigData("arms_damage")                          --影刀
TUNING.BATBAT_DAMAGE = 34*1.25*GetModConfigData("arms_damage")                           --蝙蝠棒
TUNING.SPIKE_DAMAGE = 34*1.5*GetModConfigData("arms_damage")                             --触手尖刺
TUNING.SPEAR_DAMAGE = 34*GetModConfigData("arms_damage")                                 --长矛
TUNING.WATHGRITHR_SPEAR_DAMAGE = 34*1.25*GetModConfigData("arms_damage")                 --战斗长矛
TUNING.CANE_DAMAGE = 34*.5*GetModConfigData("arms_damage")                               --步行手杖
TUNING.RUINS_BAT_DAMAGE = 34*1.75*GetModConfigData("arms_damage")                        --远古武器
TUNING.NIGHTSTICK_DAMAGE = 34*.85*GetModConfigData("arms_damage")                        --晨星
--武器耐久
TUNING.NIGHTSWORD_USES = 100*GetModConfigData("arms_uses")                         --影刀
TUNING.BATBAT_USES = 75*GetModConfigData("arms_uses")                              --蝙蝠棒
TUNING.SPIKE_USES = 100*GetModConfigData("arms_uses")                              --触手尖刺
TUNING.SPEAR_USES = 150*GetModConfigData("arms_uses")                              --长矛
TUNING.WATHGRITHR_SPEAR_USES = 200*GetModConfigData("arms_uses")                   --战斗长矛
TUNING.RUINS_BAT_USES = 150*GetModConfigData("arms_uses")                          --远古棒

--斧镐
TUNING.MULTITOOL_AXE_PICKAXE_USES = 300000000000000000000
AddPrefabPostInit("multitool_axe_pickaxe", function(inst)
  if inst.components.equippable then
    inst.components.equippable.walkspeedmult = 1.1
  end
end)

if MORE_STRENGTHENING then
  --龙蝇
  AddPrefabPostInit("dragonfly", function(inst)
    if inst.Transform then
      inst.Transform:SetScale(1.3*1.5, 1.3*1.5, 1.3*1.5)
      GLOBAL.MakeFlyingGiantCharacterPhysics(inst, 500*1.5, 1.4*1.5)
    end
  end)

  --熊大
  AddPrefabPostInit("bearger", function(inst)
    if inst.Transform then
      inst.Transform:SetScale(1*1.5, 1*1.5, 1*1.5)
      GLOBAL.MakeGiantCharacterPhysics(inst, 1000*1.5, 1.5*1.5)
    end
  end)

  --巨鹿
  AddPrefabPostInit("deerclops", function(inst)
    if inst.Transform then
      inst.Transform:SetScale(1.65*1.5, 1.65*1.5, 1.65*1.5)
      GLOBAL.MakeGiantCharacterPhysics(inst, 1000*1.5, .5*1.5)
    end
  end)

  --鹿角鹅
  AddPrefabPostInit("moose", function(inst)
    if inst.Transform then
      inst.Transform:SetScale(1.55*1.5,1.55*1.5,1.55*1.5)
      GLOBAL.MakeGiantCharacterPhysics(inst, 5000*1.5, 1*1.5)
    end
  end)

  --远古守护者
  AddPrefabPostInit("minotaur", function(inst)
    if inst.Transform then
      inst.Transform:SetScale(1*1.5, 1*1.5, 1*1.5)
      GLOBAL.MakeCharacterPhysics(inst, 100*1.5, 2.2*1.5)
    end
  end)

  --蜂后
  AddPrefabPostInit("beequeen", function(inst)
    if inst.Transform then
      inst.Transform:SetScale(1.4*1.5, 1.4*1.5, 1.4*1.5)
      GLOBAL.MakeFlyingGiantCharacterPhysics(inst, 500*1.5, 1.4*1.5)
    end
  end)

  --蜘蛛女王
  AddPrefabPostInit("spiderqueen", function(inst)
    if inst.Transform then
      inst.Transform:SetScale(1*1.5, 1*1.5, 1*1.5)
      GLOBAL.MakeCharacterPhysics(inst, 1000*1.5, 1*1.5)
    end
  end)

  --树精
  local function leif_model(inst)
    if inst.Transform then
      inst.Transform:SetScale(1*1.5, 1*1.5, 1*1.5)
      GLOBAL.MakeCharacterPhysics(inst, 1000*1.5, .5*1.5)
    end
  end
  AddPrefabPostInit("leif", leif_model)           --树精
  AddPrefabPostInit("leif_sparse", leif_model)    --稀有树精


  --座狼
  AddPrefabPostInit("warg", function(inst)
    if inst.Transform then
      inst.Transform:SetScale(1*1.5, 1*1.5, 1*1.5)
      GLOBAL.MakeCharacterPhysics(inst, 1000*1.5, 1*1.5)
    end
  end)

  --钢羊
  AddPrefabPostInit("spat", function(inst)
    if inst.Transform then
      inst.Transform:SetScale(1*1.5, 1*1.5, 1*1.5)
    end
  end)

  --海象
  AddPrefabPostInit("walrus", function(inst)
    if inst.Transform then
      inst.Transform:SetScale(1.5*1.5, 1.5*1.5, 1.5*1.5)
      GLOBAL.MakeCharacterPhysics(inst, 50*1.5, .5*1.5)
    end
  end)


  --龙蝇
  TUNING.DRAGONFLY_ATTACK_RANGE = 7                          --攻击范围（攻击距离）
  TUNING.DRAGONFLY_SPEED = 7                                 --移动速度
  TUNING.DRAGONFLY_FIRE_HIT_RANGE = 8                        --暴怒打击范围
  TUNING.DRAGONFLY_FIRE_SPEED = 8                            --暴怒移动速度
  TUNING.DRAGONFLY_STUN = 3750                               --判定伤害（5秒内打出1250伤害）
  TUNING.DRAGONFLY_STUN_PERIOD = 5                           --判定时间（5秒内打出1250伤害）
  TUNING.DRAGONFLY_STUN_DURATION = 10                        --眩晕持续时间
  TUNING.DRAGONFLY_BREAKOFF_DAMAGE = 7500                    --掉龙鳞伤害
  TUNING.DRAGONFLY_POUND_CD = 10                             --暴怒三连CD

  --熊大
  TUNING.BEARGER_CALM_WALK_SPEED = 4                         --正常行走速度
  TUNING.BEARGER_ANGRY_WALK_SPEED = 7                        --激怒行走速度？
  TUNING.BEARGER_RUN_SPEED = 11                              --跑动速度？
  TUNING.BEARGER_MELEE_RANGE = 9                             --近战范围
  TUNING.BEARGER_ATTACK_RANGE = 9                            --攻击范围

  --巨鹿
  TUNING.DEERCLOPS_ATTACK_RANGE = 10                          --攻击范围（攻击有效范围）
  TUNING.DEERCLOPS_AOE_RANGE = 15                             --技能范围（AOE）

  --鹿角鹅
  TUNING.MOOSE_WALK_SPEED = 10                               --正常移动速度（跳跃距离）
  TUNING.MOOSE_RUN_SPEED = 14                                --攻击移动速度（跳跃距离）
  TUNING.MOOSE_ATTACK_RANGE = 8                              --攻击范围（攻击有效范围）

  --远古守护者
  TUNING.MINOTAUR_RUN_SPEED = 25                             --跑动速度

  --蜂后
  TUNING.BEEQUEEN_ATTACK_RANGE = 6                           --攻击范围
  TUNING.BEEQUEEN_HIT_RANGE = 8                              --打击范围（伤害有效范围）
  TUNING.BEEQUEEN_SPEED = 6                                  --移动
  TUNING.BEEQUEEN_MIN_GUARDS_PER_SPAWN = 6                   --小蜜蜂最小召唤数量
  TUNING.BEEQUEEN_MAX_GUARDS_PER_SPAWN = 8                   --小蜜蜂最大召唤数量
  TUNING.BEEQUEEN_TOTAL_GUARDS = 12                          --判定是否召唤小蜜蜂数量（达到8只则不召唤，低于8只则召唤）

  --蛤蟆、毒蛤蟆
  TUNING.TOADSTOOL_DEAGGRO_DIST = 12                         --丢失仇恨范围
  TUNING.TOADSTOOL_AGGRO_DIST = 8                            --仇恨范围
  TUNING.TOADSTOOL_MUSHROOMBOMB_RADIUS = 5                   --蘑菇炸弹半径
  TUNING.TOADSTOOL_SPORECLOUD_DAMAGE = 30                    --孢子云伤害
  TUNING.TOADSTOOL_SPORECLOUD_RADIUS = 4                     --孢子云半径
  TUNING.TOADSTOOL_SPORECLOUD_LIFETIME = 120                 --孢子云持续时间
  TUNING.TOADSTOOL_MUSHROOMSPROUT_CHOPS = 15                 --蘑菇树砍掉所需次数
  TUNING.TOADSTOOL_DARK_MUSHROOMSPROUT_CHOPS = 20            --毒蛤蟆蘑菇树砍掉所需次数

  --蜘蛛女王
  TUNING.SPIDERQUEEN_WALKSPEED = 3                           --移动速度
  TUNING.SPIDERQUEEN_ATTACKRANGE = 7                         --攻击范围

  --座狼
  TUNING.WARG_RUNSPEED = 7                                   --移动速度
  TUNING.WARG_ATTACKRANGE = 7                                --攻击范围

  --海象
  TUNING.WALRUS_ATTACK_DIST = 20                             --攻击距离
  TUNING.WALRUS_TARGET_DIST = 20                             --仇很范围

end

if TUNING.DRAGONFLY_HEALTH >= 27500*2 and
  TUNING.DRAGONFLY_DAMAGE >= 300 and
  TUNING.DRAGONFLY_ATTACK_PERIOD == 1 then

  local function dospawnchest(inst)                                     --生成音效
    inst.SoundEmitter:PlaySound("dontstarve/common/ghost_spawn")

    local chest =SpawnPrefab("minotaurchest")                         --生成地点
    local x, y, z = inst.Transform:GetWorldPosition()
    chest.Transform:SetPosition(x, 0, z)

    local fx = SpawnPrefab("statue_transition_2")                     --生成特效1
    if fx ~= nil then
      fx.Transform:SetPosition(x, y, z)
      fx.Transform:SetScale(1, 2, 1)
    end

    fx = SpawnPrefab("statue_transition")                             --生成特效2
    if fx ~= nil then
      fx.Transform:SetPosition(x, y, z)
      fx.Transform:SetScale(1, 1.5, 1)
    end

    chest:AddComponent("scenariorunner")                              --运行组件
    chest.components.scenariorunner:SetScript("chest_minotaur")
    chest.components.scenariorunner:Run()
  end

  local function big_box(inst)
    inst:ListenForEvent("death", death)
    inst:ListenForEvent("death", function()
      inst:DoTaskInTime(3, dospawnchest)
    end)
  end
  AddPrefabPostInit("dragonfly", big_box)      --龙蝇
  AddPrefabPostInit("bearger", big_box)        --熊大
  AddPrefabPostInit("deerclops", big_box)      --巨鹿
  AddPrefabPostInit("moose", big_box)          --鹿角鹅
  AddPrefabPostInit("beequeen", big_box)       --蜂后


  AddPrefabPostInit("minotaurchest",function(inst)
    if not TheWorld:HasTag("cave") then
      inst:DoPeriodicTask(120,function()
        inst:Remove()
      end)
    end
  end)



  --蛤蟆、毒蛤蟆
  local function toadstool_loot(inst)
    if inst.components.lootdropper then
      --   inst.components.lootdropper:AddChanceLoot('shroom_skin',1)            --前面物品，后面几率
      inst.components.lootdropper:AddChanceLoot('shroom_skin',1)            --蛤蟆皮
      inst.components.lootdropper:AddChanceLoot('shroom_skin',1)            --蛤蟆皮

      inst.components.lootdropper:AddChanceLoot('firestaff',1)              --火杖（红）
      inst.components.lootdropper:AddChanceLoot('icestaff',1)               --冰杖（蓝）
      inst.components.lootdropper:AddChanceLoot('telestaff',1)              --传送法阵（紫）
      inst.components.lootdropper:AddChanceLoot('orangestaff',1)            --瞬移法杖（橙）
      inst.components.lootdropper:AddChanceLoot('yellowstaff',1)            --唤星法杖（黄）
      inst.components.lootdropper:AddChanceLoot('greenstaff',1)             --分解法杖（绿）

      inst.components.lootdropper:AddChanceLoot('amulet',1)                 --生命护符
      inst.components.lootdropper:AddChanceLoot('blueamulet',1)             --寒冰护符
      inst.components.lootdropper:AddChanceLoot('purpleamulet',1)           --噩梦护符
      inst.components.lootdropper:AddChanceLoot('orangeamulet',1)           --懒人护符
      inst.components.lootdropper:AddChanceLoot('yellowamulet',1)           --魔力之光
      inst.components.lootdropper:AddChanceLoot('greenamulet',1)            --建造护符
    end
  end
  AddPrefabPostInit("toadstool", toadstool_loot)
  AddPrefabPostInit("toadstool_dark", toadstool_loot)

  --树精
  local function leif_loot(inst)
    if inst.components.lootdropper then
      inst.components.lootdropper:AddChanceLoot('livinglog',1)              --活木
      inst.components.lootdropper:AddChanceLoot('livinglog',1)
      inst.components.lootdropper:AddChanceLoot('livinglog',1)
      inst.components.lootdropper:AddChanceLoot('batbat',0.5)               --蝙蝠棒
      inst.components.lootdropper:AddChanceLoot('multitool_axe_pickaxe',0.25)--斧镐
      inst.components.lootdropper:AddChanceLoot('armorruins',0.25)          --铥矿甲
      inst.components.lootdropper:AddChanceLoot('ruinshat',0.25)		    --铥矿帽
    end
  end
  AddPrefabPostInit("leif", leif_loot)
  AddPrefabPostInit("leif_sparse", leif_loot)

  --蜘蛛女王
  AddPrefabPostInit("spiderqueen", function(inst)
    if inst.components.lootdropper then
      inst.components.lootdropper:AddChanceLoot('spidereggsack',1)        --蜘蛛巢
      inst.components.lootdropper:AddChanceLoot('silk',1)                 --蜘蛛丝
      inst.components.lootdropper:AddChanceLoot('silk',1)
      inst.components.lootdropper:AddChanceLoot('silk',1)
      inst.components.lootdropper:AddChanceLoot('armorruins',0.25)        --铥矿甲
      inst.components.lootdropper:AddChanceLoot('ruinshat',0.25)		    --铥矿帽
      inst.components.lootdropper:AddChanceLoot('armorwood',1)            --木甲
      inst.components.lootdropper:AddChanceLoot('footballhat',1)          --猪皮帽
    end
  end)

  --座狼
  AddPrefabPostInit("warg", function(inst)
    if inst.components.lootdropper then
      inst.components.lootdropper:AddChanceLoot('redgem',1)               --红宝石
      inst.components.lootdropper:AddChanceLoot('redgem',1)
      inst.components.lootdropper:AddChanceLoot('redgem',1)
      inst.components.lootdropper:AddChanceLoot('bluegem',1)              --蓝宝石
      inst.components.lootdropper:AddChanceLoot('bluegem',1)
      inst.components.lootdropper:AddChanceLoot('bluegem',1)
      inst.components.lootdropper:AddChanceLoot('houndstooth',1)          --狗牙
      inst.components.lootdropper:AddChanceLoot('houndstooth',1)
      inst.components.lootdropper:AddChanceLoot('houndstooth',1)
      inst.components.lootdropper:AddChanceLoot('armorruins',0.25)        --铥矿甲
      inst.components.lootdropper:AddChanceLoot('ruinshat',0.25)		    --铥矿帽
    end
  end)

  --钢羊
  AddPrefabPostInit("spat", function(inst)
    if inst.components.lootdropper then
      inst.components.lootdropper:AddChanceLoot('meat',1)
      inst.components.lootdropper:AddChanceLoot('meat',1)
      inst.components.lootdropper:AddChanceLoot('steelwool',1)            --钢丝绒
      inst.components.lootdropper:AddChanceLoot('steelwool',1)            --钢丝绒
      inst.components.lootdropper:AddChanceLoot('ruins_bat',0.5)          --远古武器
      inst.components.lootdropper:AddChanceLoot('armormarble',0.5)        --大理石甲
      inst.components.lootdropper:AddChanceLoot('footballhat',0.5)        --猪皮帽
    end
  end)

  --海象
  AddPrefabPostInit("walrus", function(inst)
    if inst.components.lootdropper then
      inst.components.lootdropper:AddChanceLoot('walrus_tusk',0.5)        --海象牙
      inst.components.lootdropper:AddChanceLoot('walrushat',0.25)         --海象帽
    end
  end)

  --克劳斯
  AddPrefabPostInit("klaus", function(inst)
    if inst.components.lootdropper then
      inst.components.lootdropper:AddChanceLoot('krampus_sack',0.25)  	    --坎普斯背包
    end
  end)

end


if TUNING.HOUND_HEALTH >= 225      and
  TUNING.HOUND_DAMAGE >= 30       and
  TUNING.HOUND_ATTACK_PERIOD == 1 then

  --冬象
  AddPrefabPostInit("koalefant_winter", function(inst)
    if inst.components.lootdropper then
      inst.components.lootdropper:AddChanceLoot('meat',1)                   --大肉
      inst.components.lootdropper:AddChanceLoot('meat',1)
      inst.components.lootdropper:AddChanceLoot('meat',1)
      inst.components.lootdropper:AddChanceLoot('armorwood',0.5)            --木甲
      inst.components.lootdropper:AddChanceLoot('trunk_winter',1)           --冬象鼻
    end
  end)

  --夏象
  AddPrefabPostInit("koalefant_summer", function(inst)
    if inst.components.lootdropper then
      inst.components.lootdropper:AddChanceLoot('meat',1)                   --大肉
      inst.components.lootdropper:AddChanceLoot('meat',1)
      inst.components.lootdropper:AddChanceLoot('meat',1)
      inst.components.lootdropper:AddChanceLoot('armorwood',0.5)            --木甲
      inst.components.lootdropper:AddChanceLoot('trunk_summer',1)           --夏象鼻
    end
  end)

  --高脚鸟
  AddPrefabPostInit("tallbird", function(inst)
    if inst.components.lootdropper then
      inst.components.lootdropper:AddChanceLoot('meat',1)                   --大肉
      inst.components.lootdropper:AddChanceLoot('meat',1)                   --大肉
      inst.components.lootdropper:AddChanceLoot('armormarble',0.5)          --大理石甲
    end
  end)

  --触手
  AddPrefabPostInit("tentacle", function(inst)
    if inst.components.lootdropper then
      inst.components.lootdropper:AddChanceLoot('tentaclespots',0.25)       --触手皮
      inst.components.lootdropper:AddChanceLoot('spear_wathgrithr',0.5)     --战斗长矛
    end
  end)

  --鱼人
  AddPrefabPostInit("merm", function(inst)
    if inst.components.lootdropper then
      inst.components.lootdropper:AddChanceLoot('wathgrithrhat',0.5)        --战斗头盔
    end
  end)

  --蠕虫
  AddPrefabPostInit("worm", function(inst)
    if inst.components.lootdropper then
      inst.components.lootdropper:AddChanceLoot('molehat',0.5)              --鼹鼠帽
      inst.components.lootdropper:AddChanceLoot('wormlight',1)              --发光浆果
      inst.components.lootdropper:AddChanceLoot('wormlight',0.5)            --发光浆果
    end
  end)

  --猪人
  AddPrefabPostInit("pigman", function(inst)
    if inst.components.lootdropper then
      inst.components.lootdropper:AddChanceLoot('pigskin',0.5)              --猪皮
      inst.components.lootdropper:AddChanceLoot('footballhat',0.25)          --猪皮帽
    end
  end)

  --蜘蛛类
  local function spider_loot(inst)
    if inst.components.lootdropper then
      inst.components.lootdropper:AddChanceLoot('silk',0.15)                --蜘蛛丝
      inst.components.lootdropper:AddChanceLoot('spidergland',0.15)         --腺体
      inst.components.lootdropper:AddChanceLoot('monstermeat',0.35)         --怪物肉
    end
  end
  AddPrefabPostInit("spider", spider_loot)
  AddPrefabPostInit("spider_warrior", spider_loot)
  AddPrefabPostInit("spider_dropper", spider_loot)
  AddPrefabPostInit("spider_hider", spider_loot)
  AddPrefabPostInit("spider_spitter", spider_loot)

  --狗
  AddPrefabPostInit("hound", function(inst)
    if inst.components.lootdropper then
      inst.components.lootdropper:AddChanceLoot('monstermeat',1)            --怪物肉
      inst.components.lootdropper:AddChanceLoot('houndstooth',1)            --狗牙
    end
  end)

  --火狗
  AddPrefabPostInit("firehound", function(inst)
    if inst.components.lootdropper then
      inst.components.lootdropper:AddChanceLoot('monstermeat',1)            --怪物肉
      inst.components.lootdropper:AddChanceLoot('houndstooth',1)            --狗牙
      inst.components.lootdropper:AddChanceLoot('redgem',0.5)               --红宝石
      inst.components.lootdropper:AddChanceLoot('firestaff',0.1)            --火杖
    end
  end)

  --冰狗
  AddPrefabPostInit("icehound", function(inst)
    if inst.components.lootdropper then
      inst.components.lootdropper:AddChanceLoot('monstermeat',1)            --怪物肉
      inst.components.lootdropper:AddChanceLoot('houndstooth',1)            --狗牙
      inst.components.lootdropper:AddChanceLoot('bluegem',0.5)              --蓝宝石
      inst.components.lootdropper:AddChanceLoot('icestaff',0.1)             --冰杖
    end
  end)

end

---- 自定义内容
if true then
  modimport "postinit/p_any.lua"
  -- 世界监控
  modimport "postinit/p_world.lua"
  -- 设置炼丹炉能炼器
  modimport "postinit/c_stewer_fur.lua"
  -- 炼丹炉显示剩余时间
  modimport "postinit/p_alchmy_fur.lua"
  -- 增加OnSave/OnLoad存储伤害以及属性
  -- 修复铥棒
  -- 火腿伤害降低问题 - 都修复了！通过修改setdamage函数
  modimport "postinit/c_weapon.lua"
  -- 修复SetLastTarget问题
  modimport "postinit/c_combat.lua"
  -- 装备绑定存储
  modimport "postinit/c_equippable.lua"
  -- 受伤降低成长伤害
  modimport "postinit/p_players.lua"
  -- 路灯
  modimport "postinit/p_fyjiedeng.lua"
  -- 命名扩展
  modimport "postinit/c_named.lua"
  -- 取消物理碰撞
  -- AddPrefabPostInit("blowdart_sleep",function(inst) inst.Physics:ClearCollisionMask() end)
  -- AddPrefabPostInit("blowdart_fire",function(inst) inst.Physics:ClearCollisionMask() end)
  -- AddPrefabPostInit("blowdart_pipe",function(inst) inst.Physics:ClearCollisionMask() end)
  -- AddPrefabPostInit("blowdart_yellow",function(inst) inst.Physics:ClearCollisionMask() end)
  -- AddPrefabPostInit("blowdart_walrus",function(inst) inst.Physics:ClearCollisionMask() end)
  local function Id2Player(id)
    local player = nil
    for k,v in pairs(GLOBAL.AllPlayers) do
      if v.userid == id then
        player = v
      end
    end
    return player
  end

  local OldNetworking_Say = GLOBAL.Networking_Say
  GLOBAL.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote)
    local inst = Id2Player(userid)
    if inst == nil then
      return OldNetworking_Say(guid, userid, name, prefab, message, colour, whisper, isemote)
    end
    local showoldsay=true
    if string.len(message)>1 and string.sub(message,1,1) == "#" then
      local commands = {}
      for command in string.gmatch(string.sub(message,2,string.len(message)), "%S+") do
        table.insert(commands, string.lower(command))
      end
      if commands[1]=="称号" or commands[1]=="ch" then
        showoldsay = false
        local chenghao = commands[2]
        if chenghao ~= nil and chenghao ~= "" then
          if inst.components.seplayerstatus and inst.components.seplayerstatus.coin >= 100000 then
            inst.components.seplayerstatus:DoDeltaCoin(-100000)
            if inst.components.oldfish then
              inst.components.oldfish.name = chenghao
            end
          end
        end
      elseif commands[1]=="升级" or commands[1]=="levelup" then
        showoldsay = false
        if inst.components.inventory then
          local gem = inst.components.inventory:FindItem(function(v) return v.prefab=="oldfish_part_gem" end)
          if gem then
            local count = gem.components.stackable:StackSize()
            print(count.." gems")
            if inst.components.oldfish then
              while count > 3 and inst.oldfish_level:value()%250 ~= 0 do
                local exp_plus = 100 * inst.oldfish_level:value() * math.exp(-1 * inst.oldfish_level:value() / 900)
                inst.components.oldfish:DoDelta_exp(exp_plus)
                count = count-4
              end
            end
            if count == 0 then
              gem:Remove()
            else
              gem.components.stackable:SetStackSize(count)
            end
          end
        end
      elseif commands[1]=="绑定" or commands[1]=="bind" then
        local function bind(equip)
          if equip then
            if equip.components.named == nil then
              equip:AddComponent("named")
              equip.components.named:SetName("")
            end
            if equip.onlyownerid == nil then
              equip.onlyownerid = userid
              equip.components.named:SetName("所有者："..name, "bind")
            else
              equip.onlyownerid = nil
              equip.components.named:SetName("", "bind")
            end
          end
        end
        -- 这里使用天涯百宝箱「天涯神杖」的权限设定。
        showoldsay = false
        if inst.components.inventory then
          for idx,val in pairs(EQUIPSLOTS) do
            local equip = inst.components.inventory:GetEquippedItem(val)
            bind(equip)
          end
        end
      end
    end
    if showoldsay then
      return OldNetworking_Say(guid, userid, name, prefab, message, colour, whisper, isemote)
    end
  end
  print("设置BOSS的重生时间")
  -- 都是10天
  TUNING.BEEQUEEN_RESPAWN_TIME = 30 * 16 * 10        --蜂后重生时间
  TUNING.TOADSTOOL_RESPAWN_TIME = 30 * 16 * 10     --蟾蜍重生时间
  TUNING.ATRIUM_GATE_COOLDOWN = 30 * 16 * 10          --中庭冷却时间
end
_G.get_stronger = {}
local itemstable = require("ULitemstable")
local CreaturesOri = itemstable.creatures
local CharactersOri = itemstable.characters
local MionrsOri = itemstable.minors

local strong = require("ULstrong")

local function GetInstName(inst)
    return inst and inst:GetDisplayName() or "*无名*"
end

local function GetAttacker(data)
    return data and data.attacker and data.attacker:GetDisplayName() or "*无名*"
end

AddPrefabPostInit("world", function(inst)
  local function gongzi()
    for k,v in ipairs(_G.AllPlayers) do
      if v.components.seplayerstatus then
        local cycles1 = TheWorld.state.cycles*10
        local cycles2 = v.components.age:GetAgeInDays()*100
        v.components.seplayerstatus:DoDeltaCoin(math.max(cycles1, cycles2))
      end
    end
  end
  inst:WatchWorldState("cycles", gongzi)
  inst.OnLoad = function(inst, data)
    if data ~= nil and data._get_stronger then
      _G.get_stronger = data._get_stronger
    end
  end
  inst.OnSave = function(inst, data)
    data._get_stronger = _G.get_stronger
  end
end)

AddPrefabPostInit("tallbirdnest", function(inst)
  if inst.components.burnable then
    inst:RemoveComponent("burnable")
  end
end)

AddPrefabPostInit("slurtlehole", function (inst)
  if inst.components.health then
    inst.components.health:SetAbsorptionAmount(1)
  end
end)

if TUNING.BOSS_REGEN > 0 then
-- BOSS加强
AddPrefabPostInit("wiona_catapult", function(inst)
  if inst.components.health then
    inst.components.health:SetInvincible(true)
  end
end)
for k, v in pairs(CreaturesOri) do
  AddPrefabPostInit(v, function(inst)

    local function siwanggonggao(inst, data)
      inst:RemoveEventCallback("attacked", siwanggonggao)
      local attacker = "【" .. GetAttacker(data) .. "】"
      local vicitim = "【".. GetInstName(inst) .."】"
      local count = math.floor(inst.components.health.maxhealth/10000/((1-(inst.components.health.absorb or 0))*inst.components.combat.externaldamagetakenmultipliers:Get()+0.01))
      if data and data.attacker and data.attacker.components and data.attacker.components.inventory then
        for i=1,math.min(99, count) or 0 do
          local vic = SpawnPrefab('oldfish_part_gem')
          if vic ~= nil then
            data.attacker.components.inventory:GiveItem(vic)
          end
        end
      end
      if v == "glommer" then
        TheNet:Announce("可恶的" .. attacker .. "杀死了可怜的" .. vicitim)
        return
      end
      if v == "klaus" then
        if inst.kaimiao and inst.kaimiao == 0 then
          TheNet:Announce(attacker.."解开了"..vicitim.."的锁链")
          return
        end
      end
      TheNet:Announce(attacker .. "给了" .. vicitim .. "最后一击")
    end

    local function ondeath(inst)
      if v == "klaus" then
        inst.kaimiao = inst.kaimiao and 1 or 0
      end
      _G.get_stronger[v] = _G.get_stronger[v] and _G.get_stronger[v] + 1 or 1
      inst:ListenForEvent("attacked", siwanggonggao)
    end
    local function onremove(inst)
      if inst.components.health and inst.components.health:IsDead() then
        return
      end
      local vicitim = "【".. GetInstName(inst) .."】"
      TheNet:Announce(vicitim.."消失了")
    end
    --此处的 maxhealth 是原始数值
    --print("default maxhealth ->"..inst.components.health.maxhealth )
    if inst.components.health and inst.components.health.maxhealth >= 600 then
        inst:ListenForEvent("onremove", onremove)
        inst:ListenForEvent("death", ondeath)
    end

    if k < 17 then
      inst:DoTaskInTime(0.1, function(inst)
        local vicitim = "【".. GetInstName(inst) .."】"
        TheNet:Announce("BOSS "..vicitim.."出现！")
      end)
    end

    if v == "glommer" then
      local vicitim = "【".. GetInstName(inst) .."】"
      TheNet:Announce(vicitim.."出现了，快去领回家！")
    end

    if strong and strong[v] then
      strong[v](inst)
    end

    local stronger = _G.get_stronger[v] or 1
    local absorb = stronger/(20+stronger)

    if GLOBAL.TheShard:GetShardId() ~= "1" then
      inst:DoTaskInTime(0.1, function()
        if inst.book_summon~=true and inst:HasTag("epic") then
          local cycles = TheWorld.state.cycles
          local rate = math.exp(cycles/800)+2
          if inst.components.health then
            inst.components.health:SetMaxHealth(inst.components.health.maxhealth * rate)
            local regen = TUNING.BOSS_REGEN/100*inst.components.health.maxhealth
            inst.components.health:StartRegen(regen, 1)
          end
          absorb = stronger/(10+stronger)
          if inst.components.combat then
            inst.components.combat.externaldamagetakenmultipliers:SetModifier("yeo_strong", 1-absorb)
          end
        else
          if inst.components.combat then
            inst.components.combat.externaldamagetakenmultipliers:SetModifier("yeo_strong", 1-absorb)
          end
          local cycles = TheWorld.state.cycles
          local rate = math.exp(cycles/1000)
          if inst.components.health then
            inst.components.health:SetMaxHealth(inst.components.health.maxhealth * rate)
            local regen = TUNING.BOSS_REGEN/5/100*inst.components.health.maxhealth
            inst.components.health:StartRegen(regen, 5)
          end
        end
      end)
    end
  end)
end

for k,v in pairs(MionrsOri) do
  AddPrefabPostInit(v, function(inst)
    if v == "balloon" then
      inst.components.combat:SetDefaultDamage(50)
    elseif v == "lighter" then
    elseif v == "spear_wathgrithr" then
      local function onattack(inst, attacker, target)
        if inst and inst:IsValid() and target and target:IsValid()
          and target.components.health and not target.components.health:IsDead()
          and target.components.combat then
          local x, y, z = target.Transform:GetWorldPosition()
          SpawnPrefab("sparks").Transform:SetPosition(x, y - .5, z)
        end
      end
      inst.components.weapon:SetOnAttack(onattack)
    elseif v == "wathgrithrhat" then
      inst.components.armor:SetAbsorption(1)
      inst.components.equippable.insulated = true
    elseif v == "shadowduelist" then
      --waxwell's shadowduelist
      local function freezetarget(inst, data)
        local target = data.target
        local freezerate = math.random()
        if target ~= nil and target:IsValid() and target.components.freezable ~= nil
          and target.components.health ~= nil and not target.components.health:IsDead() then
          if freezerate < 0.5 then
            target.components.freezable:AddColdness(10)
            target.components.freezable:SpawnShatterFX()
          end
        end
      end
      inst.components.health:SetAbsorptionAmount(_G.TUNING.ARMORRUINS_ABSORPTION)
      inst:ListenForEvent("onhitother", freezetarget)
    elseif v == "abigail" then
      --wendy's abigail
      local function reflectdamage(inst, data)
        local attacker = data.attacker
        local leader = inst.components.follower.leader
        if attacker ~= nil and attacker:IsValid() and attacker ~= leader
          and attacker.components.health ~= nil and attacker.components.combat ~= nil
          and not attacker.components.health:IsDead() then
          local reflect_damage_value = 1.5 * data.damage / (1 - (attacker.components.health.absorb or 0))
          if math.random() > 0.7 then
            attacker.components.combat:GetAttacked(leader, 10 * reflect_damage_value)
          else
            attacker.components.combat:GetAttacked(leader, reflect_damage_value)
          end

        end
      end
      inst:ListenForEvent("attacked", reflectdamage)
    end
  end)
end
end
