local ability = {
    spellkey = Menu.AddKeyOption({"ability"}, "ability autocast key", Enum.ButtonCode.KEY_SPACE),
    particle = {},
    status = {},
    defender = {},
    sleeptime = {},
    calling = {},
    tracking = {},
    spellinfo = {},
    casttime = {},
    cooldown = {},
    cast_pos = {},
    printing = {},
    imageoption = {}
}

function ability.OnGameStart()
    Engine.ExecuteCommand("fog_enable 0")
end

function ability.OnGameEnd()
    ability.particle = {}
    ability.status = {}
    ability.defender = {}
    ability.sleeptime = {}
    ability.calling = {}
    ability.tracking = {}
    ability.spellinfo = {}
    ability.casttime = {}
    ability.cooldown = {}
    ability.cast_pos = {}
    ability.printing = {}
    ability.refresh_image()
end

ability.ignorespell = {
    "ancient_apparition_chilling_touch",
    "axe_berserkers_call",
    "axe_culling_blade",
    "bane_nightmare",
    "batrider_sticky_napalm",
    "bloodseeker_bloodrage",
    "bounty_hunter_wind_walk",
    "beastmaster_call_of_the_wild",
    "beastmaster_call_of_the_wild_boar",
    "beastmaster_call_of_the_wild_hawk",
    "broodmother_spin_web",
    "centaur_double_edge",
    "centaur_return",
    "chaos_knight_reality_rift",
    "chen_holy_persuasion",
    "clinkz_wind_walk",
    "dazzle_shallow_grave",
    "doom_bringer_devour",
    "doom_bringer_infernal_blade",
    "drow_ranger_trueshot",
    "earth_spirit_boulder_smash",
    "earth_spirit_rolling_boulder",
    "earth_spirit_geomagnetic_grip",
    "enigma_demonic_conversion",
    "faceless_void_time_walk",
    "faceless_void_time_dilation",
    "faceless_void_chronosphere",
    "furion_sprout",
    "furion_teleportation",
    "furion_force_of_nature",
    "huskar_life_break",
    "invoker_ghost_walk",
    "invoker_invoke",
    "jakiro_liquid_fire",
    "kunkka_tidebringer",
    "kunkka_x_marks_the_spot",
    "legion_commander_duel",
    "lich_sinister_gaze",
    "lion_mana_drain",
    "lone_druid_spirit_bear",
    "lone_druid_spirit_link",
    "lone_druid_savage_roar",
    "lone_druid_true_form_battle_cry",
    "medusa_mana_shield",
    "meepo_poof",
    "magnataur_empower",
    "magnataur_skewer",
    "morphling_adaptive_strike_str",
    "morphling_morph_agi",
    "morphling_morph_str",
    "monkey_king_tree_dance",
    "pudge_rot",
    "phantom_assassin_stifling_dagger",
    "phantom_assassin_phantom_strike",
    "phantom_assassin_blur",
    "phantom_lancer_doppelwalk",
    "queenofpain_blink",
    "rattletrap_battery_assault",
    "rattletrap_power_cogs",
    "riki_blink_strike",
    "rubick_telekinesis",
    "rubick_fade_bolt",
    "sandking_sand_storm",
    "shredder_chakram_2",
    "sniper_take_aim",
    "spirit_breaker_charge_of_darkness",
    "spirit_breaker_empowering_haste",
    "spirit_breaker_nether_strike",
    "techies_stasis_trap",
    "techies_suicide",
    "terrorblade_conjure_image",
    "tiny_toss",
    "tiny_craggy_exterior",
    "tiny_toss_tree",
    "treant_natures_guise",
    "troll_warlord_berserkers_rage",
    "troll_warlord_whirling_axes_ranged",
    "tusk_walrus_kick",
    "ursa_earthshock",
    "ursa_overpower",
    "weaver_shukuchi",
    "wisp_tether",
    "wisp_tether_break",
    "wisp_relocate",
    "wisp_spirits_in",
    "wisp_spirits_out",
    "witch_doctor_voodoo_restoration",
    "bristleback_viscous_nasal_goo",
    "bristleback_quill_spray",
    "storm_spirit_ball_lightning",
    "mars_arena_of_blood",
    "faceless_void_time_dilation",
    "vengefulspirit_nether_swap",
    "invoker_invoke",
    "naga_siren_song_of_the_siren",
    "naga_siren_song_of_the_siren_cancel",
    "puck_phase_shift",
    "alchemist_unstable_concoction",
    "alchemist_unstable_concoction_throw",
    "ancient_apparition_ice_blast_release",
    "venomancer_plague_ward",
    "clinkz_searing_arrows",
    "life_stealer_rage",
    "life_stealer_open_wounds",
    "life_stealer_infest",
    "tusk_tag_team",
    "tusk_walrus_kick",
    "phoenix_icarus_dive",
    "phoenix_fire_spirits",
    "phoenix_launch_fire_spirit",
    "antimage_blink",
    "abaddon_borrowed_time",
    "hoodwink_scurry",
    "templar_assassin_meld",
    "mars_bulwark",
    "skeleton_king_vampiric_aura",
    "zuus_static_field",
    "phantom_lancer_phantom_edge",
    "disruptor_glimpse",
    "dark_seer_surge",
    "shadow_demon_disruption",
    "shadow_demon_shadow_poison",
    "slardar_sprint",
    "templar_assassin_psionic_trap",
    "templar_assassin_trap",
    "weaver_geminate_attack",
    "dawnbreaker_fire_wreath",
    "dawnbreaker_celestial_hammer",
    "enchantress_natures_attendants",
    "warlock_shadow_word",
    "warlock_upheaval",
    "elder_titan_echo_stomp",
    "pudge_flesh_heap",
    "abaddon_death_coil",
    "abaddon_aphotic_shield",
    "oracle_purifying_flames",
    "tinker_keen_teleport"
    --"obsidian_destroyer_astral_imprisonment"
}

function ability.mutedspell(name)
    for _, v in pairs(ability.ignorespell) do
        if v and name and v == name then return true end
    end
    return false
end

function ability.refresh_image()
    for k, v in pairs(ability.imageoption) do
        if k and ability.imageoption[k].opt then
            Menu.RemoveOption(ability.imageoption[k].opt)
            ability.imageoption[k] = nil
        end
    end
end

function ability.OnUpdate()
    for npcs = 1, NPCs.Count() do
        local me = NPCs.Get(npcs)
        if Heroes.GetLocal() and me and Entity.IsSameTeam(Heroes.GetLocal(), me) and Entity.IsAlive(me) and (NPC.IsHero(me) or NPC.IsCreep(me) and NPC.GetUnitName(me) ~= "npc_dota_wraith_king_skeleton_warrior" or NPC.GetUnitName(me) == "npc_dota_lone_druid_bear1" or NPC.GetUnitName(me) == "npc_dota_lone_druid_bear2" or NPC.GetUnitName(me) == "npc_dota_lone_druid_bear3" or NPC.GetUnitName(me) == "npc_dota_lone_druid_bear4") and (Entity.GetOwner(Heroes.GetLocal()) == Entity.GetOwner(me) or Entity.OwnedBy(me, Heroes.GetLocal())) and not NPC.HasModifier(me, "modifier_antimage_blink_illusion") and not NPC.HasModifier(me, "modifier_monkey_king_fur_army_soldier_hidden") and not NPC.HasModifier(me, "modifier_monkey_king_fur_army_soldier") and not NPC.HasModifier(me, "modifier_hoodwink_decoy_illusion") then
            if not ability.status[me] then ability.status[me] = {selected = false, health = nil, farmed = false} end
            local target, selecthero, movehero, telekinesis_throw, auto_cast = ability.findtarget(me), false, false, false, false
            local ability0, ability1, ability2, ability3, ability4, ability5 = NPC.GetAbilityByIndex(me, 0), NPC.GetAbilityByIndex(me, 1), NPC.GetAbilityByIndex(me, 2), NPC.GetAbilityByIndex(me, 3), NPC.GetAbilityByIndex(me, 4), NPC.GetAbilityByIndex(me, 5)
            local blink, ethereal_blade = NPC.GetItem(me, "item_blink", true) or NPC.GetItem(me, "item_overwhelming_blink", true) or NPC.GetItem(me, "item_swift_blink", true) or NPC.GetItem(me, "item_arcane_blink", true), NPC.GetItem(me, "item_ethereal_blade", true)
            if not ability.imageoption["orbwalk"] then
                ability.imageoption["orbwalk"] = {}
                if not ability.imageoption["orbwalk"].opt then
                    ability.imageoption["orbwalk"].opt = Menu.AddImageOption({"ability"}, "{{orbwalk-opt-}}", "", Renderer.LoadImage("panorama/images/spellicons/action_attackhero_png.vtex_c"))
                end
            end
            if not ability.imageoption["defender"] then
                ability.imageoption["defender"] = {}
                if not ability.imageoption["defender"].opt then
                    ability.imageoption["defender"].opt = Menu.AddImageOption({"ability"}, "{{defender-opt-}}", "", Renderer.LoadImage("panorama/images/spellicons/action_stop_png.vtex_c"))
                end
            end
            for num = 0, 16 do
                local spell = NPC.GetAbilityByIndex(me, num)
                if spell and (not ability.sleeptime["autocast"] or ability.sleeptime["autocast"] < GameRules.GetGameTime()) and (NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed")) and Ability.GetName(spell) == "sven_storm_bolt" and Ability.IsStolen(spell) and not Ability.GetAutoCastState(spell) then
                    Engine.ExecuteCommand("dota_ability_autocast " .. num .. "")
                    ability.sleeptime["autocast"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                elseif spell and (not ability.sleeptime["autocast"] or ability.sleeptime["autocast"] < GameRules.GetGameTime()) and NPC.HasModifier(me, "modifier_item_aghanims_shard") and Ability.GetName(spell) == "monkey_king_boundless_strike" and Ability.GetCooldown(spell) == 0 and not Ability.IsStolen(spell) and target and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > 900 and not Ability.GetAutoCastState(spell) then
                    Engine.ExecuteCommand("dota_ability_autocast " .. num .. "")
                    ability.sleeptime["autocast"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                elseif spell and (not ability.sleeptime["autocast"] or ability.sleeptime["autocast"] < GameRules.GetGameTime()) and NPC.HasModifier(me, "modifier_item_aghanims_shard") and Ability.GetName(spell) == "monkey_king_boundless_strike" and Ability.GetCooldown(spell) > 0 and Ability.GetAutoCastState(spell) then
                    Engine.ExecuteCommand("dota_ability_autocast " .. num .. "")
                    ability.sleeptime["autocast"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                end
                if not NPC.HasModifier(me, "modifier_illusion") and spell and Entity.IsAbility(spell) and (Ability.IsBasic(spell) or Ability.IsUltimate(spell)) and (not Ability.IsPassive(spell) or Ability.GetName(spell) == "rubick_empty1" or Ability.GetName(spell) == "rubick_empty2") and not Ability.IsAttributes(spell) and Ability.GetName(spell) ~= "generic_hidden" and Ability.GetName(spell) ~= "plus_guild_banner" and Ability.GetName(spell) ~= "ability_capture" and Ability.GetName(spell) ~= "abyssal_underlord_portal_warp" and Ability.GetName(spell) ~= "special_bonus_attributes" and Ability.GetName(spell) ~= "plus_high_five" and Ability.GetName(spell) ~= "batrider_sticky_napalm_application_damage" and Ability.GetName(spell) ~= "monkey_king_primal_spring_early" and Ability.GetName(spell) ~= "rubick_hidden1" and Ability.GetName(spell) ~= "rubick_hidden2" and Ability.GetName(spell) ~= "rubick_hidden3" and Ability.GetName(spell) ~= "morphling_morph" and not ability.imageoption[spell] then
                    ability.imageoption[spell] = {}
                    ability.imageoption[spell].handle = me
                    if not ability.imageoption[spell].opt then
                        ability.imageoption[spell].opt = Menu.AddImageOption({"ability"}, "{{spells-opt-" .. Ability.GetName(spell) .. "}}", "", Renderer.LoadImage("panorama/images/spellicons/" .. Ability.GetName(spell) .. "_png.vtex_c"))
                    end
                end
            end
            for num = 0, 16 do
                local item = NPC.GetItemByIndex(me, num)
                if not NPC.HasModifier(me, "modifier_illusion") and item and Entity.IsAbility(item) and Ability.IsItem(item) and (NPC.GetItem(me, Ability.GetName(item), true) or NPC.GetItemByIndex(me, 16) == item) and Ability.GetName(item) ~= "item_tpscroll" and Ability.GetName(item) ~= "item_ward_observer" and Ability.GetName(item) ~= "item_ward_sentry" and Ability.GetName(item) ~= "item_ward_dispenser" and Ability.GetName(item) ~= "item_tome_of_knowledge" and ((Ability.GetBehavior(item) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 or (Ability.GetBehavior(item) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_POINT) ~= 0 or (Ability.GetBehavior(item) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_NO_TARGET) ~= 0) and not ability.imageoption[item] then
                    ability.imageoption[item] = {}
                    ability.imageoption[item].handle = me
                    if not ability.imageoption[item].opt then
                        ability.imageoption[item].opt = Menu.AddImageOption({"ability"}, "{{items-opt-" .. Ability.GetName(item):gsub("item_", "") .. "}}", "", Renderer.LoadImage("panorama/images/items/" .. Ability.GetName(item):gsub("item_", "") .. "_png.vtex_c"))
                    end
                end
            end
            for k, v in pairs(ability.imageoption) do
                if k and type(k) == "userdata" and (Entity.IsAbility(k) and Ability.IsItem(k) and not Item.IsNeutralDrop(k) and not NPC.GetItem(ability.imageoption[k].handle, Ability.GetName(k), true) or not Entity.IsAbility(k) or Entity.GetOwner(k) ~= ability.imageoption[k].handle or not Entity.IsAlive(ability.imageoption[k].handle)) then
                    ability.refresh_image()
                end
            end

            if ability.imageoption["orbwalk"] and Menu.IsEnabled(ability.imageoption["orbwalk"].opt) then
                if target then
                    if not ability.particle["targeting"] then ability.particle["targeting"] = Particle.Create("particles/ui_mouseactions/range_finder_tower_aoe.vpcf", Enum.ParticleAttachment.PATTACH_INVALID, target) end
                    if ability.particle["targeting"] then
                        Particle.SetControlPoint(ability.particle["targeting"], 2, Entity.GetOrigin(Heroes.GetLocal()))
                        Particle.SetControlPoint(ability.particle["targeting"], 6, Vector(1, 0, 0))
                        Particle.SetControlPoint(ability.particle["targeting"], 7, Entity.GetOrigin(target))
                    end
                    if (not ability.sleeptime["channelling"] or ability.sleeptime["channelling"] < GameRules.GetGameTime()) and not NPC.IsChannellingAbility(me) and (not ability.sleeptime["rearming"] or ability.sleeptime["rearming"] < GameRules.GetGameTime()) and not NPC.HasModifier(me, "modifier_hoodwink_sharpshooter_windup") and not NPC.HasModifier(me, "modifier_spirit_breaker_charge_of_darkness") and not NPC.HasModifier(me, "modifier_monkey_king_bounce_leap") and not NPC.HasModifier(me, "modifier_snapfire_mortimer_kisses") and not NPC.HasModifier(me, "modifier_primal_beast_onslaught_windup") and not NPC.HasModifier(me, "modifier_primal_beast_onslaught_windup") and not NPC.HasModifier(me, "modifier_void_spirit_dissimilate_phase") and not NPC.HasModifier(me, "modifier_phoenix_sun_ray") and not NPC.IsStunned(me) then
                        if not ability.sleeptime["orbwalking"] then
                            if (NPC.IsRanged(me) and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 90 or not NPC.IsRanged(me) and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 350) or NPC.HasModifier(target, "modifier_ghost_state") or NPC.HasModifier(target, "modifier_item_ethereal_blade_ethereal") or NPC.HasModifier(me, "modifier_windrunner_focusfire") or NPC.HasModifier(me, "modifier_prevent_taunts") or NPC.HasModifier(me, "modifier_shredder_chakram_disarm") or NPC.HasModifier(me, "modifier_weaver_shukuchi") or NPC.HasModifier(me, "modifier_pangolier_gyroshell") or not ability.safe_cast(me, target) then
                                movehero = true
                            else
                                if not auto_cast and (not ability.sleeptime["attacking"] or ability.sleeptime["attacking"] < GameRules.GetGameTime()) then
                                    Player.PrepareUnitOrders(Players.GetLocal(), 4, target, Vector(0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_SELECTED_UNITS, me, false, false)
                                    ability.sleeptime["attacking"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + NPC.GetAttackTime(me)
                                end
                            end
                        else
                            if ability.sleeptime["orbwalking"] and ability.sleeptime["orbwalking"] + NPC.GetAttackTime(Heroes.GetLocal()) / 3 < GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) and not NPC.HasModifier(me, "modifier_templar_assassin_meld") and not NPC.HasModifier(me, "modifier_faceless_void_chronosphere_speed") and not NPC.HasModifier(target, "modifier_bashed") and (not NPC.GetItem(me, "item_echo_sabre") or NPC.GetItem(me, "item_echo_sabre") and Ability.SecondsSinceLastUse(NPC.GetItem(me, "item_echo_sabre")) > NPC.GetAttackTime(Heroes.GetLocal())) then
                                if (Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 25 or not ability.calling["last_clickpos"] or Input.GetWorldCursorPos():Distance(ability.calling["last_clickpos"]):Length2D() > 150) and (not ability.sleeptime["walking"] or ability.sleeptime["walking"] < GameRules.GetGameTime()) then
                                    Player.PrepareUnitOrders(Players.GetLocal(), 1, nil, Input.GetWorldCursorPos(), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_SELECTED_UNITS, me, false, true)
                                    ability.calling["last_clickpos"], ability.sleeptime["walking"] = Input.GetWorldCursorPos(), GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 6) / 10)
                                end
                            end
                        end
                    end
                    if (NPC.HasModifier(me, "modifier_hoodwink_sharpshooter_windup") or NPC.HasModifier(me, "modifier_primal_beast_onslaught_windup") or NPC.HasModifier(me, "modifier_phoenix_sun_ray") or NPC.HasModifier(me, "modifier_snapfire_mortimer_kisses") or NPC.HasModifier(me, "modifier_void_spirit_dissimilate_phase")) and (not ability.sleeptime["walking"] or ability.sleeptime["walking"] < GameRules.GetGameTime()) then
                        Player.PrepareUnitOrders(Players.GetLocal(), 1, nil, ability.skillshotXYZ(me, target, 1000), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY, me, false, true)
                        ability.sleeptime["walking"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 6) / 10)
                    end
                    selecthero = true
                else
                    if Menu.IsKeyDown(ability.spellkey) and not Input.IsInputCaptured() then
                        selecthero, movehero = true, true
                    end
                    if ability.particle["targeting"] then
                        Particle.Destroy(ability.particle["targeting"])
                        ability.particle["targeting"] = nil
                    end
                end
            end
            if ability.sleeptime["orbwalking"] and ability.sleeptime["orbwalking"] + NPC.GetAttackTime(me) < GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) then
                ability.sleeptime["orbwalking"] = nil
            end
            for i = 1, #Player.GetSelectedUnits(Players.GetLocal()) do
                if Player.GetSelectedUnits(Players.GetLocal())[i] and Player.GetSelectedUnits(Players.GetLocal())[i] == me and ability.status[me] then ability.status[me].selected = true end
                if Player.GetSelectedUnits(Players.GetLocal())[i] and selecthero and not ability.status[me].selected and Player.GetSelectedUnits(Players.GetLocal())[i] ~= me and not string.find(NPC.GetUnitName(me), "npc_dota_furion_treant") and not string.find(NPC.GetUnitName(me), "npc_dota_beastmaster_hawk") then
                    Player.AddSelectedUnit(Players.GetLocal(), me)
                    if ability.status[me] then ability.status[me].selected = true end
                end
            end
            if movehero and (not ability.sleeptime["channelling"] or ability.sleeptime["channelling"] < GameRules.GetGameTime()) and not NPC.IsChannellingAbility(me) and (not ability.sleeptime["rearming"] or ability.sleeptime["rearming"] < GameRules.GetGameTime()) and not NPC.HasModifier(me, "modifier_monkey_king_bounce_perch") and (target and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 25 or not ability.calling["last_clickpos"] or Input.GetWorldCursorPos():Distance(ability.calling["last_clickpos"]):Length2D() > 150) and (not ability.sleeptime["walking"] or ability.sleeptime["walking"] < GameRules.GetGameTime()) then
                Player.PrepareUnitOrders(Players.GetLocal(), 1, nil, Input.GetWorldCursorPos(), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_SELECTED_UNITS, me, false, true)
                ability.calling["last_clickpos"], ability.sleeptime["walking"] = Input.GetWorldCursorPos(), GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 6) / 10)
            end
            if not Menu.IsKeyDown(ability.spellkey) and not Input.IsInputCaptured() then ability.status[me].selected, ability.sleeptime["disableing"], planted, invoke = false, 0, false, nil end
            
            for name, date in pairs(ability.cast_pos) do if date.time and date.time < GameRules.GetGameTime() then ability.cast_pos[name] = nil end end
            for name, date in pairs(ability.calling) do if date.time and date.time < GameRules.GetGameTime() then ability.calling[name] = nil end end
            for spell, date in pairs(ability.imageoption) do
                if date.opt and Menu.IsEnabled(date.opt) and spell and Entity.IsAbility(spell) and Ability.GetLevel(spell) > 0 and not Ability.IsHidden(spell) and (not ability.sleeptime["channelling"] or ability.sleeptime["channelling"] < GameRules.GetGameTime()) and ((Ability.GetBehavior(spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_NO_TARGET) ~= 0 or (not ability.sleeptime["orbwalking"] or ability.sleeptime["orbwalking"] and ability.sleeptime["orbwalking"] + NPC.GetAttackTime(Heroes.GetLocal()) / 3 < GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)))) then
                    local distance = ability.get_distance(spell, me)
                    if (Ability.GetName(spell) == "clinkz_searing_arrows" or Ability.GetName(spell) == "drow_ranger_frost_arrows" or Ability.GetName(spell) == "kunkka_tidebringer" or Ability.GetName(spell) == "viper_poison_attack" or Ability.GetName(spell) == "enchantress_impetus" or Ability.GetName(spell) == "enchantress_impetus" or Ability.GetName(spell) == "huskar_burning_spear" or Ability.GetName(spell) == "bounty_hunter_jinada" or Ability.GetName(spell) == "jakiro_liquid_fire" or Ability.GetName(spell) == "jakiro_liquid_ice" or Ability.GetName(spell) == "doom_bringer_infernal_blade" or Ability.GetName(spell) == "ancient_apparition_chilling_touch" or Ability.GetName(spell) == "silencer_glaives_of_wisdom" or Ability.GetName(spell) == "obsidian_destroyer_arcane_orb" or Ability.GetName(spell) == "tusk_walrus_punch") and Ability.GetCooldown(spell) == 0 then
                        if NPC.IsRanged(me) then distance, auto_cast = distance + 90, true elseif not NPC.IsRanged(me) then distance, auto_cast = distance + 350, true end
                        if NPC.IsRanged(me) and (NPC.GetItem(me, "item_dragon_lance", true) or NPC.GetItem(me, "item_dragon_lance", true)) then distance = distance + 150 end
                    end
                    if Ability.GetName(spell) == "legion_commander_press_the_attack" and not (blink or blink and Ability.GetCooldown(blink) > 0) then distance = NPC.GetAttackRange(me) end  
                    --if spell and not ability.printing[Ability.GetName(spell)] then Console.Print("name " .. Ability.GetName(spell) .. " distance " .. distance) ability.printing[Ability.GetName(spell)] = spell end

                    if NPC.GetAbility(me, "special_bonus_unique_rubick") and Ability.GetLevel(NPC.GetAbility(me, "special_bonus_unique_rubick")) > 0 then throw_range = 837.5 else throw_range = 537.5 end
                    if NPC.GetAbility(me, "special_bonus_unique_shadow_demon_4") and Ability.GetLevel(NPC.GetAbility(me, "special_bonus_unique_shadow_demon_4")) > 0 then stack_damage = Ability.GetLevelSpecialValueFor(spell, "stack_damage") * 1.2 else stack_damage = Ability.GetLevelSpecialValueFor(spell, "stack_damage") end
                    if target and ability.calling[NPC.GetUnitName(target)] and ability.calling[NPC.GetUnitName(target)].name == "damaged" and not NPC.HasModifier(me, "modifier_weaver_shukuchi") then ability.calling[NPC.GetUnitName(target)] = nil end
                    if Ability.GetName(spell) == "phoenix_sun_ray_toggle_move" and not Ability.IsActivated(spell) then toggle_move = false end
                    if NPC.GetAbility(me, "special_bonus_unique_marci_lunge_range") and Ability.GetLevel(NPC.GetAbility(me, "special_bonus_unique_marci_lunge_range")) > 0 then rebound_range, landing_radius = 925, 925 else rebound_range, landing_radius =  800, 800 end
                    if NPC.GetActivity(me) == 1723 and ability.cast_pos["monkey_king_primal_spring"] and target and Entity.GetAbsOrigin(target):Distance(ability.cast_pos["monkey_king_primal_spring"].pos):Length2D() > 60 then
                        Player.PrepareUnitOrders(Players.GetLocal(), 21, nil, Vector(), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY, me)
                        ability.cast_pos["monkey_king_primal_spring"] = nil
                    end

                    for caster, date in pairs(ability.defender) do
                        if ability.imageoption["defender"] and Menu.IsEnabled(ability.imageoption["defender"].opt) and Ability.IsReady(spell) and date.spell and NPC.GetActivity(date.unit) ~= 1500 and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(caster)):Length2D() < distance then
                            if (Ability.GetBehavior(date.spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 and not NPC.IsLinkensProtected(me) and NPC.GetTimeToFace(caster, me) < 0.02 then
                                if not NPC.HasModifier(caster, "modifier_antimage_counterspell") and not NPC.HasModifier(caster, "modifier_item_lotus_orb_active") and not NPC.HasState(caster, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and ((Ability.GetBehavior(spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 and Ability.GetDispellableType(spell) == 1 and Ability.GetCastPoint(spell) == 0 or Ability.GetName(spell) == "item_orchid" or Ability.GetName(spell) == "item_bloodthorn") then
                                    Ability.CastTarget(spell, caster)
                                    ability.defender[caster] = nil
                                elseif (Ability.GetName(spell) == "antimage_counterspell" or Ability.GetName(spell) == "hoodwink_decoy" or Ability.GetName(spell) == "clinkz_wind_walk" or Ability.GetName(spell) == "weaver_shukuchi" or Ability.GetName(spell) == "nyx_assassin_spiked_carapace" or Ability.GetName(spell) == "life_stealer_rage") and date.time + date.castpoint - 0.15 < GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) then
                                    Ability.CastNoTarget(spell)
                                    ability.defender[caster] = nil
                                elseif Ability.GetName(spell) == "item_black_king_bar" and (Ability.GetDispellableType(date.spell) == 1 or Ability.GetDamageType(date.spell) == 2 and Ability.GetType(date.spell) == 1) and date.time + date.castpoint - 0.03 < GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) then
                                    Ability.CastNoTarget(spell)
                                    ability.defender[caster] = nil
                                elseif Ability.GetName(spell) == "juggernaut_blade_fury" and date.time + date.castpoint - 0.03 < GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) then
                                    Ability.CastNoTarget(spell)
                                    ability.defender[caster] = nil
                                elseif Ability.GetName(date.spell) ~= "legion_commander_duel" and Ability.GetName(spell) == "item_lotus_orb" and date.time + date.castpoint - 0.15 < GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) then
                                    Ability.CastTarget(spell, me)
                                    ability.defender[caster] = nil
                                elseif (Ability.GetName(spell) == "item_cyclone" or Ability.GetName(spell) == "item_wind_waker") and date.time + date.castpoint < GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) then
                                    Ability.CastTarget(spell, me)
                                    ability.defender[caster] = nil
                                elseif (Ability.GetName(spell) == "puck_phase_shift" or Ability.GetName(spell) == "item_stormcrafter") and date.time + date.castpoint < GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) then
                                    Ability.CastNoTarget(spell)
                                    ability.defender[caster] = nil
                                elseif Ability.GetName(spell) == "dawnbreaker_fire_wreath" and NPC.HasModifier(me, "modifier_item_aghanims_shard") and date.time + date.castpoint - 0.35 < GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) then
                                    Ability.CastPosition(spell, ability.skillshotXYZ(me, caster, 950))
                                    ability.defender[caster] = nil
                                end
                            elseif (Ability.GetBehavior(date.spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_POINT) ~= 0 and NPC.GetTimeToFace(caster, me) < 0.02 or (Ability.GetBehavior(date.spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_NO_TARGET) ~= 0 then
                                if (Ability.GetName(spell) == "item_manta" and Ability.GetDamageType(date.spell) ~= 4 and ((Ability.GetBehavior(date.spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_AOE) == 0 or (Ability.GetBehavior(date.spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_NO_TARGET) == 0) or Ability.GetName(spell) == "nyx_assassin_spiked_carapace" or Ability.GetName(spell) == "life_stealer_rage" or Ability.GetName(spell) == "item_stormcrafter" or Ability.GetName(spell) == "juggernaut_blade_fury" or Ability.GetName(spell) == "puck_phase_shift" or Ability.GetName(spell) == "item_black_king_bar" and Ability.GetDispellableType(date.spell) == 1) and date.time + date.castpoint - 0.15 < GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) then
                                    Ability.CastNoTarget(spell)
                                    ability.defender[caster] = nil
                                elseif Ability.GetName(spell) == "juggernaut_blade_fury" and date.time + date.castpoint - 0.03 < GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) then
                                    Ability.CastNoTarget(spell)
                                    ability.defender[caster] = nil
                                elseif not NPC.HasModifier(caster, "modifier_antimage_counterspell") and not NPC.HasModifier(caster, "modifier_item_lotus_orb_active") and not NPC.HasState(caster, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and (Ability.GetBehavior(spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 and Ability.GetDispellableType(spell) == 1 and Ability.GetCastPoint(spell) == 0 or Ability.GetName(spell) == "item_orchid" or Ability.GetName(spell) == "item_bloodthorn" then
                                    Ability.CastTarget(spell, caster)
                                    ability.defender[caster] = nil
                                elseif (Ability.GetName(spell) == "item_cyclone" or Ability.GetName(spell) == "item_wind_waker") and date.time + date.castpoint - 0.15 < GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) then
                                    Ability.CastTarget(spell, me)
                                    ability.defender[caster] = nil
                                elseif Ability.GetName(spell) == "dawnbreaker_fire_wreath" and NPC.HasModifier(me, "modifier_item_aghanims_shard") and date.time + date.castpoint - 0.35 < GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) then
                                    Ability.CastPosition(spell, ability.skillshotXYZ(me, caster, 950))
                                    ability.defender[caster] = nil
                                end
                            end
                        end
                        if NPC.GetActivity(date.unit) == 1500 or date.time + date.castpoint * 3 < GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) then
                            ability.defender[caster] = nil
                        end
                    end
                    
                    if me == Heroes.GetLocal() and Ability.GetName(spell) == "invoker_invoke" and Ability.IsReady(spell) and not NPC.IsStunned(me) and not NPC.IsSilenced(me) and (not ability.sleeptime["invoker_invoke"] or GameRules.GetGameTime() > ability.sleeptime["invoker_invoke"]) then
                        local quas, wex, exort, cold_snap, ghost_walk, tornado, emp, alacrity, chaos_meteor, sun_strike, forge_spirit, ice_wall, deafening_blast = 0, 0, 0, NPC.GetAbility(me, "invoker_cold_snap"), NPC.GetAbility(me, "invoker_ghost_walk"), NPC.GetAbility(me, "invoker_tornado"), NPC.GetAbility(me, "invoker_emp"), NPC.GetAbility(me, "invoker_alacrity"), NPC.GetAbility(me, "invoker_chaos_meteor"), NPC.GetAbility(me, "invoker_sun_strike"), NPC.GetAbility(me, "invoker_forge_spirit"), NPC.GetAbility(me, "invoker_ice_wall"), NPC.GetAbility(me, "invoker_deafening_blast")
                        for _, mod in ipairs(NPC.GetModifiers(me)) do
                            if Modifier.GetName(mod) == "modifier_invoker_quas_instance" then
                                quas = quas + 1
                            elseif Modifier.GetName(mod) == "modifier_invoker_wex_instance" then
                                wex = wex + 1
                            elseif Modifier.GetName(mod) == "modifier_invoker_exort_instance" then
                                exort = exort + 1
                            end
                        end
                        if (not invoke or invoke == "tornado") and tornado and Ability.IsHidden(tornado) and Ability.GetCooldown(tornado) == 0 and Ability.GetLevel(ability1) > 2 and target and not NPC.HasModifier(target, "modifier_invoker_cold_snap") and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > 600 then
                            if quas == 1 and wex == 2 then
                                Ability.CastNoTarget(spell)
                                invoke, ability.sleeptime["invoker_invoke"] = nil, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            elseif quas ~= 1 and (not ability.sleeptime["quas"] or GameRules.GetGameTime() > ability.sleeptime["quas"]) then
                                Ability.CastNoTarget(ability0)
                                invoke, ability.sleeptime["quas"] = "tornado", GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 5) / 10)
                            elseif wex ~= 2 and (not ability.sleeptime["wex"] or GameRules.GetGameTime() > ability.sleeptime["wex"]) then
                                Ability.CastNoTarget(ability1)
                                invoke, ability.sleeptime["wex"] = "tornado", GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 5) / 10)
                            end
                        elseif (not invoke or invoke == "sun_strike") and sun_strike and Ability.IsHidden(sun_strike) and Ability.GetCooldown(sun_strike) == 0 and Ability.GetCooldown(chaos_meteor) > 0 and Ability.GetLevel(ability0) > 5 and Ability.GetName(ability3) == "invoker_tornado" then
                            if exort == 3 then
                                Ability.CastNoTarget(spell)
                                invoke, ability.sleeptime["invoker_invoke"] = nil, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            elseif exort ~= 3 and (not ability.sleeptime["exort"] or GameRules.GetGameTime() > ability.sleeptime["exort"]) then
                                Ability.CastNoTarget(ability2)
                                invoke, ability.sleeptime["exort"] = "sun_strike", GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 5) / 10)
                            end
                        elseif (not invoke or invoke == "chaos_meteor") and chaos_meteor and Ability.IsHidden(chaos_meteor) and Ability.GetCooldown(chaos_meteor) == 0 and (Ability.GetCooldown(ability3) > 0 or Ability.GetName(ability3) == "invoker_tornado" or Ability.GetName(ability4) == "invoker_chaos_meteor" and Ability.GetCooldown(ability3) > 0) then
                            if wex == 1 and exort == 2 then
                                Ability.CastNoTarget(spell)
                                invoke, ability.sleeptime["invoker_invoke"] = nil, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            elseif wex ~= 1 and (not ability.sleeptime["wex"] or GameRules.GetGameTime() > ability.sleeptime["wex"]) then
                                Ability.CastNoTarget(ability1)
                                invoke, ability.sleeptime["wex"] = "chaos_meteor", GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 5) / 10)
                            elseif exort ~= 2 and (not ability.sleeptime["exort"] or GameRules.GetGameTime() > ability.sleeptime["exort"]) then
                                Ability.CastNoTarget(ability2)
                                invoke, ability.sleeptime["exort"] = "chaos_meteor", GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 5) / 10)
                            end
                        elseif (not invoke or invoke == "emp") and emp and Ability.IsHidden(emp) and Ability.GetCooldown(emp) == 0 and Ability.GetCooldown(ability3) > 0 and Ability.GetLevel(ability1) > 2 and NPC.GetMana(me) / NPC.GetMaxMana(me) < 0.5 then
                            if wex == 3 then
                                Ability.CastNoTarget(spell)
                                invoke, ability.sleeptime["invoker_invoke"] = nil, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            elseif quas ~= 3 and (not ability.sleeptime["wex"] or GameRules.GetGameTime() > ability.sleeptime["wex"]) then
                                Ability.CastNoTarget(ability1)
                                invoke, ability.sleeptime["wex"] = "emp", GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 5) / 10)
                            end
                        elseif (not invoke or invoke == "deafening_blast") and deafening_blast and Ability.IsHidden(deafening_blast) and Ability.GetCooldown(deafening_blast) == 0 and NPC.GetMaxMana(me) / 3 > Ability.GetManaCost(deafening_blast) and (Ability.GetCooldown(ability3) > 0 or Ability.GetName(ability3) == "invoker_chaos_meteor" and Ability.GetCooldown(ability4) > 0) then
                            if quas == 1 and wex == 1 and exort == 1 then
                                Ability.CastNoTarget(spell)
                                invoke, ability.sleeptime["invoker_invoke"] = nil, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            elseif quas ~= 1 and (not ability.sleeptime["quas"] or GameRules.GetGameTime() > ability.sleeptime["quas"]) then
                                Ability.CastNoTarget(ability0)
                                invoke, ability.sleeptime["quas"] = "deafening_blast", GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 5) / 10)
                            elseif wex ~= 1 and (not ability.sleeptime["wex"] or GameRules.GetGameTime() > ability.sleeptime["wex"]) then
                                Ability.CastNoTarget(ability1)
                                invoke, ability.sleeptime["wex"] = "deafening_blast", GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 5) / 10)
                            elseif exort ~= 2 and (not ability.sleeptime["exort"] or GameRules.GetGameTime() > ability.sleeptime["exort"]) then
                                Ability.CastNoTarget(ability2)
                                invoke, ability.sleeptime["exort"] = "deafening_blast", GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 5) / 10)
                            end
                        elseif (not invoke or invoke == "cold_snap") and cold_snap and Ability.IsHidden(cold_snap) and Ability.GetCooldown(cold_snap) == 0 and (Ability.GetCooldown(ability3) > 0 or Ability.GetName(ability3) == "invoker_empty1") and target and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < NPC.GetAttackRange(me) + 25 then
                            if quas == 3 then
                                Ability.CastNoTarget(spell)
                                invoke, ability.sleeptime["invoker_invoke"] = nil, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            elseif quas ~= 3 and (not ability.sleeptime["quas"] or GameRules.GetGameTime() > ability.sleeptime["quas"]) then
                                Ability.CastNoTarget(ability0)
                                invoke, ability.sleeptime["quas"] = "cold_snap", GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 5) / 10)
                            end
                        elseif (not invoke or invoke == "alacrity") and alacrity and Ability.IsHidden(alacrity) and Ability.GetCooldown(alacrity) == 0 and Ability.GetName(ability3) == "invoker_cold_snap" and Ability.GetCooldown(ability4) > 0 then
                            if wex == 2 and exort == 1 then
                                Ability.CastNoTarget(spell)
                                invoke, ability.sleeptime["invoker_invoke"] = nil, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            elseif wex ~= 2 and (not ability.sleeptime["wex"] or GameRules.GetGameTime() > ability.sleeptime["wex"]) then
                                Ability.CastNoTarget(ability1)
                                invoke, ability.sleeptime["wex"] = "alacrity", GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 5) / 10)
                            elseif exort ~= 1 and (not ability.sleeptime["exort"] or GameRules.GetGameTime() > ability.sleeptime["exort"]) then
                                Ability.CastNoTarget(ability2)
                                invoke, ability.sleeptime["exort"] = "alacrity", GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 5) / 10)
                            end
                        elseif (not invoke or invoke == "ice_wall") and ice_wall and Ability.IsHidden(ice_wall) and Ability.GetCooldown(ice_wall) == 0 and Ability.GetCooldown(ability3) > 0 and target and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < 300 then
                            if quas == 2 and exort == 1 then
                                Ability.CastNoTarget(spell)
                                invoke, ability.sleeptime["invoker_invoke"] = nil, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            elseif quas ~= 2 and (not ability.sleeptime["quas"] or GameRules.GetGameTime() > ability.sleeptime["quas"]) then
                                Ability.CastNoTarget(ability0)
                                invoke, ability.sleeptime["quas"] = "ice_wall", GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 5) / 10)
                            elseif exort ~= 1 and (not ability.sleeptime["exort"] or GameRules.GetGameTime() > ability.sleeptime["exort"]) then
                                Ability.CastNoTarget(ability2)
                                invoke, ability.sleeptime["exort"] = "ice_wall", GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 5) / 10)
                            end
                        elseif not invoke and Entity.GetHealth(me) / Entity.GetMaxHealth(me) < 0.5 and quas ~= 3 and (not ability.sleeptime["quas"] or GameRules.GetGameTime() > ability.sleeptime["quas"]) then
                            Ability.CastNoTarget(ability0)
                            ability.sleeptime["quas"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 5) / 10)
                        elseif not invoke and target and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 25 and Entity.GetHealth(me) / Entity.GetMaxHealth(me) > 0.5 and wex ~= 3 and (not ability.sleeptime["wex"] or GameRules.GetGameTime() > ability.sleeptime["wex"]) then
                            Ability.CastNoTarget(ability1)
                            ability.sleeptime["wex"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 5) / 10)
                        elseif not invoke and NPC.IsAttacking(me) and exort ~= 3 and (not ability.sleeptime["exort"] or GameRules.GetGameTime() > ability.sleeptime["exort"]) then
                            Ability.CastNoTarget(ability2)
                            ability.sleeptime["exort"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + (math.random(3, 5) / 10)
                        end
                    end

                    if Ability.IsStolen(spell) then
                        if Ability.GetName(spell) == "wisp_spirits_in" or Ability.GetName(spell) == "shredder_return_chakram" or Ability.GetName(spell) == "pangolier_gyroshell_stop" or Ability.GetCooldown(spell) > 0 or ((Ability.GetName(spell) == "slark_pounce" or Ability.GetName(spell) == "ember_spirit_fire_remnant" or Ability.GetName(spell) == "sniper_shrapnel" or Ability.GetName(spell) == "void_spirit_resonant_pulse" or Ability.GetName(spell) == "void_spirit_astral_step" or Ability.GetName(spell) == "hoodwink_scurry" or Ability.GetName(spell) == "techies_land_mines") and Ability.GetCurrentCharges(spell) == 0) then
                            if Ability.GetName(spell) == "void_spirit_resonant_pulse" then
                                if NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") then ability.cooldown[Ability.GetName(spell)] = 32 else ability.cooldown[Ability.GetName(spell)] = 16 end
                            elseif Ability.GetName(spell) == "void_spirit_astral_step" then
                                if Ability.GetLevel(spell) == 1 then
                                    ability.cooldown[Ability.GetName(spell)] = 60
                                elseif Ability.GetLevel(spell) == 2 then
                                    ability.cooldown[Ability.GetName(spell)] = 50
                                elseif Ability.GetLevel(spell) == 3 then
                                    ability.cooldown[Ability.GetName(spell)] = 40
                                end
                            elseif Ability.GetName(spell) == "ember_spirit_fire_remnant" then
                                if NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") then
                                    ability.cooldown[Ability.GetName(spell)] = 190
                                else
                                    ability.cooldown[Ability.GetName(spell)] = 114
                                end
                            elseif Ability.GetName(spell) == "sniper_shrapnel" then
                                ability.cooldown[Ability.GetName(spell)] = 175
                            elseif Ability.GetName(spell) == "wisp_spirits_in" then
                                ability.cooldown[Ability.GetName(spell)] = 20
                            elseif Ability.GetName(spell) == "pangolier_gyroshell_stop" then
                                ability.cooldown[Ability.GetName(spell)] = 70
                            elseif Ability.GetName(spell) == "shredder_return_chakram" then
                                ability.cooldown["shredder_chakram"] = 8
                            elseif Ability.GetName(spell) == "hoodwink_scurry" then
                                ability.cooldown[Ability.GetName(spell)] = 30
                            elseif Ability.GetName(spell) == "techies_land_mines" then
                                ability.cooldown[Ability.GetName(spell)] = 40
                            end
                        end
                        if Ability.GetCooldownLength(spell) > 0 then
                            ability.cooldown[Ability.GetName(spell)], ability.casttime[Ability.GetName(spell)] = Ability.GetCooldownLength(spell), GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1))
                        end
                    end

                    if Ability.GetName(spell) == "rubick_spell_steal" then
                        for heroes = 1, Heroes.Count() do
                            local enemy = Heroes.Get(heroes)
                            if enemy and not Entity.IsSameTeam(me, enemy) then
                                for a = 0, 24 do
                                    local enemyspell = NPC.GetAbilityByIndex(enemy, a)
                                    if enemyspell and not Ability.IsAttributes(enemyspell) and (not Ability.IsPassive(enemyspell) or Ability.IsPassive(enemyspell) and Ability.IsActivated(enemyspell) and Ability.GetManaCost(enemyspell) > 0) and Entity.IsAbility(enemyspell) then
                                        if Ability.SecondsSinceLastUse(enemyspell) > 0 and Ability.SecondsSinceLastUse(enemyspell) < 0.1 or Ability.GetToggleState(enemyspell) or ability.calling[NPC.GetUnitName(enemy)] and ability.calling[NPC.GetUnitName(enemy)] ~= Ability.GetName(ability3) and ability.calling[NPC.GetUnitName(enemy)] == Ability.GetName(enemyspell) or Ability.GetName(enemyspell) == "ancient_apparition_ice_blast" and Ability.IsInAbilityPhase(enemyspell) then
                                            ability.spellinfo[enemy] = {unit = enemy, spell = enemyspell, radius = ability.get_distance(enemyspell, enemy), time = ability.cooldown[Ability.GetName(enemyspell)], start_time = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)), type = Ability.GetType(enemyspell)}
                                        end
                                    end
                                end
                            end
                        end
                        
                        for enemy, value in pairs(ability.spellinfo) do
                            if value then
                                if value.unit and not Entity.IsDormant(value.unit) and Entity.IsAlive(value.unit) and not ability.mutedspell(Ability.GetName(value.spell)) then
                                    if Entity.IsAlive(me) and not NPC.IsChannellingAbility(me) and not NPC.IsStunned(me) and not NPC.IsSilenced(me) and Ability.IsReady(spell) and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(value.unit)):Length2D() < Ability.GetCastRange(spell) and Ability.GetName(ability3) ~= Ability.GetName(value.spell) and Ability.GetName(ability4) ~= Ability.GetName(value.spell) and not NPC.HasModifier(me, "modifier_phoenix_sun_ray") and not NPC.HasModifier(me, "modifier_ember_spirit_fire_remnant_timer") then
                                        if not ability.casttime[Ability.GetName(value.spell)] or ability.casttime[Ability.GetName(value.spell)] and value.time and ((GameRules.GetGameTime() - ability.casttime[Ability.GetName(value.spell)])) > value.time then
                                            if Ability.IsUltimate(value.spell) or value.radius > 530 or value.radius > 0 and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(value.unit)):Length2D() < value.radius then
                                                if (NPC.GetAbility(me, "rubick_empty2") or Ability.GetCooldown(ability4) > 0 or ((Ability.GetName(ability4) == "shadow_demon_demonic_purge" or Ability.GetName(ability4) == "obsidian_destroyer_astral_imprisonment" or Ability.GetName(ability4) == "windrunner_windrun" or Ability.GetName(ability4) == "slark_pounce" or Ability.GetName(ability4) == "ember_spirit_fire_remnant" or Ability.GetName(ability4) == "sniper_shrapnel" or Ability.GetName(ability4) == "brewmaster_primal_split" or Ability.GetName(ability4) == "void_spirit_resonant_pulse" or Ability.GetName(ability4) == "void_spirit_astral_step" or Ability.GetName(ability4) == "hoodwink_scurry" or Ability.GetName(ability4) == "dark_seer_ion_shell" or Ability.GetName(ability4) == "techies_land_mines") and Ability.GetCurrentCharges(ability4) == 0)) and (NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed")) or NPC.GetAbility(me, "rubick_empty1") or Ability.GetCooldown(ability3) > 0 and (not NPC.GetItem(me, "item_ultimate_scepter") and not NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") or (NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed")) and Ability.GetCooldown(ability4) > 0) or ((Ability.GetName(ability3) == "shadow_demon_demonic_purge" or Ability.GetName(ability3) == "obsidian_destroyer_astral_imprisonment" or Ability.GetName(ability3) == "windrunner_windrun" or Ability.GetName(ability3) == "slark_pounce" or Ability.GetName(ability3) == "ember_spirit_fire_remnant" or Ability.GetName(ability3) == "sniper_shrapnel" or Ability.GetName(ability3) == "brewmaster_primal_split" or Ability.GetName(ability3) == "void_spirit_resonant_pulse" or Ability.GetName(ability3) == "void_spirit_astral_step" or Ability.GetName(ability3) == "hoodwink_scurry" or Ability.GetName(ability3) == "dark_seer_ion_shell" or Ability.GetName(ability3) == "techies_land_mines") and Ability.GetCurrentCharges(ability3) == 0) then
                                                    if (Ability.GetName(ability3) ~= "snapfire_mortimer_kisses" or Ability.GetName(ability3) == "snapfire_mortimer_kisses" and Ability.SecondsSinceLastUse(ability3) > 1 or Ability.GetName(ability4) ~= "snapfire_mortimer_kisses" or Ability.GetName(ability4) == "snapfire_mortimer_kisses" and Ability.SecondsSinceLastUse(ability4) > 1) and not NPC.HasModifier(me, "modifier_snapfire_mortimer_kisses") then
                                                        if (Ability.GetName(ability3) ~= "luna_eclipse" or Ability.GetName(ability3) == "luna_eclipse" and Ability.SecondsSinceLastUse(ability3) > 1 or Ability.GetName(ability4) ~= "luna_eclipse" or Ability.GetName(ability4) == "luna_eclipse" and Ability.SecondsSinceLastUse(ability4) > 1) and not NPC.HasModifier(me, "modifier_luna_eclipse") then
                                                            if not NPC.HasState(value.unit, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) and not NPC.HasModifier(value.unit, "modifier_dark_willow_shadow_realm_buff") and (not ability.sleeptime["rubick_spell_steal"] or GameRules.GetGameTime() > ability.sleeptime["rubick_spell_steal"]) then
                                                                if ((Ability.GetName(value.spell) == "phoenix_supernova" or Ability.GetName(value.spell) == "tinker_defense_matrix" or Ability.GetName(value.spell) == "tinker_warp_grenade" or Ability.GetName(value.spell) == "phoenix_supernova" or Ability.GetName(value.spell) == "oracle_false_promise" or Ability.GetName(value.spell) == "ursa_enrage" or Ability.GetName(value.spell) == "terrorblade_sunder" or Ability.GetName(value.spell) == "troll_warlord_battle_trance" or Ability.GetName(value.spell) == "weaver_time_lapse") and Entity.GetHealth(me) / Entity.GetMaxHealth(me) < 0.3 or 
                                                                    (value.type == 1 and Ability.GetName(value.spell) ~= "phoenix_supernova" and Ability.GetName(value.spell) ~= "terrorblade_sunder" and Ability.GetName(value.spell) ~= "phoenix_supernova" and Ability.GetName(value.spell) ~= "ursa_enrage" and Ability.GetName(value.spell) ~= "oracle_false_promise" and Ability.GetName(value.spell) ~= "troll_warlord_battle_trance" and Ability.GetName(value.spell) ~= "weaver_time_lapse" and Ability.GetName(value.spell) ~= "tinker_rearm" and Ability.GetName(value.spell) ~= "nevermore_requiem" or 
                                                                    ((Ability.GetName(value.spell) == "nevermore_requiem" and NPC.GetModifier(value.unit, "modifier_nevermore_necromastery") and Modifier.GetStackCount(NPC.GetModifier(value.unit, "modifier_nevermore_necromastery")) > 15))) or 
                                                                    (value.type == 0 and (Ability.GetDispellableType(value.spell) == 1 and Ability.GetLevel(value.spell) > 1 or 
                                                                    (Menu.IsKeyDown(ability.spellkey) and 
                                                                    (Ability.GetName(value.spell) == "invoker_sun_strike" and Ability.GetLevel(ability0) > 2 or 
                                                                    (Ability.GetDamageType(value.spell) == 2 or Ability.GetDamageType(value.spell) == 4) and Ability.GetName(value.spell) ~= "tinker_warp_grenade" and Ability.GetName(value.spell) ~= "tinker_defense_matrix" and Ability.GetLevel(value.spell) > 2 or 
                                                                    Ability.GetName(value.spell) == "windrunner_gale_force" or 
                                                                    Ability.GetName(value.spell) == "grimstroke_scepter" or 
                                                                    Ability.GetName(value.spell) == "zuus_cloud" or 
                                                                    Ability.GetName(value.spell) == "invoker_tornado" or 
                                                                    Ability.GetName(value.spell) == "invoker_emp" or 
                                                                    Ability.GetName(value.spell) == "invoker_chaos_meteor" or 
                                                                    Ability.GetName(value.spell) == "invoker_deafening_blast" or 
                                                                    Ability.GetName(value.spell) == "snapfire_gobble_up" or 
                                                                    Ability.GetName(value.spell) == "terrorblade_terror_wave" or 
                                                                    Ability.GetName(value.spell) == "kunkka_torrent_storm" or 
                                                                    Ability.GetName(value.spell) == "sniper_shrapnel" and Ability.GetLevel(value.spell) > 1)))))
                                                                then
                                                                    local fake_pos = Entity.GetAbsOrigin(me) + ((Entity.GetAbsOrigin(value.unit) - Entity.GetAbsOrigin(me)):Normalized():Scaled(Entity.GetAbsOrigin(value.unit):Distance(Entity.GetAbsOrigin(me)):Length2D() + math.random(300, 900)))
                                                                    if not Humanizer.IsWithinCameraArea(fake_pos) then
                                                                        Humanizer.MoveCursorTo(fake_pos)
                                                                    else
                                                                        Ability.CastTarget(spell, value.unit)
                                                                        ability.sleeptime["rubick_spell_steal"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                else
                                    if ability.calling[NPC.GetUnitName(value.unit)] then
                                        ability.calling[NPC.GetUnitName(value.unit)] = nil
                                    end
                                    ability.spellinfo[value.unit] = nil
                                end
                            end
                        end
                    end

                    if not ability.sleeptime[Ability.GetName(spell)] or GameRules.GetGameTime() > ability.sleeptime[Ability.GetName(spell)] then
                        if Ability.GetName(spell) == "disruptor_glimpse" then
                            for i = 1, Heroes.Count() do
                                local enemy = Heroes.Get(i)
                                if enemy and not Entity.IsSameTeam(me, enemy) and Entity.IsAlive(enemy) and not Entity.IsDormant(enemy) then
                                    if not ability.tracking[GameRules.GetGameTime() .. i] then
                                        ability.tracking[GameRules.GetGameTime() .. i] = {target = enemy, pos = Entity.GetAbsOrigin(enemy)}
                                    end
                                    for time, table in pairs(ability.tracking) do
                                        if table.target then
                                            local popitem = NPC.GetItem(table.target, "item_black_king_bar") or NPC.GetItem(table.target, "item_manta")
                                            if Ability.IsReady(spell) and table.target == target and ability.findspell("disruptor_kinetic_field", "ready") and (not popitem or popitem and Ability.GetCooldown(popitem) > 0) and time + 4 > GameRules.GetGameTime() and time + 3.5 < GameRules.GetGameTime() and not ability.cast_pos["disruptor_glimpse"] and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > 800 and table.pos:Distance(Entity.GetAbsOrigin(me)):Length2D() < 800 then
                                                Ability.CastTarget(spell, table.target)
                                                ability.cast_pos["disruptor_glimpse"], ability.sleeptime[Ability.GetName(spell)] = {pos = table.pos, time = GameRules.GetGameTime() + 4}, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        end
                                        if time + 4 < GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) then
                                            ability.tracking[time] = nil
                                        end
                                    end
                                    if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(enemy)):Length2D() < distance and ability.calling[enemy] and (ability.calling[enemy].name == "teleport_start" or ability.calling[enemy].name == "teleport_end") then
                                        Ability.CastTarget(spell, enemy)
                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                    end
                                end
                            end
                        elseif Ability.GetName(spell) == "weaver_time_lapse" or Ability.GetName(spell) == "phoenix_supernova" then
                            if not ability.tracking[GameRules.GetGameTime()] then
                                ability.tracking[GameRules.GetGameTime()] = Entity.GetHealth(me) / Entity.GetMaxHealth(me)
                            end
                            for time, hp in pairs(ability.tracking) do
                                if time + 5 > GameRules.GetGameTime() and Entity.GetHealth(me) / Entity.GetMaxHealth(me) < hp - 0.5 then
                                    if Ability.IsReady(spell) and not NPC.IsStunned(me) and not NPC.IsSilenced(me) then
                                        if NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") then
                                            Ability.CastTarget(spell, me)
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        else
                                            Ability.CastNoTarget(spell)
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        end
                                    end
                                end
                                if time + 5 < GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) then
                                    ability.tracking[time] = nil
                                end
                            end
                        elseif Ability.GetName(spell) == "bounty_hunter_track" then
                            local npc = ability.findnpc(me, "c_hero", 0, distance)
                            if npc and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < distance then
                                Ability.CastTarget(spell, npc)
                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            end
                        end
                    end

                    if Ability.IsReady(spell) and (not ability.sleeptime[Ability.GetName(spell)] or GameRules.GetGameTime() > ability.sleeptime[Ability.GetName(spell)]) and not NPC.IsStunned(me) and (not NPC.IsSilenced(me) or Ability.IsItem(spell)) and (not NPC.HasState(me, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) or NPC.HasModifier(me, "modifier_phantom_assassin_blur") or Ability.GetName(spell) == "clinkz_searing_arrows" or Ability.GetName(spell) == "bounty_hunter_jinada" or Ability.GetName(spell) == "clinkz_death_pact" or Ability.GetName(spell) == "riki_blink_strike" or target and ability.calling[NPC.GetUnitName(target)] and ability.calling[NPC.GetUnitName(target)].name == "damaged" or Ability.GetName(spell) == "bounty_hunter_track") and not NPC.HasModifier(me, "modifier_meepo_petrify") then
                        if Ability.GetName(spell) == "item_phase_boots" or Ability.GetName(spell) == "item_spider_legs" then
                            if Entity.GetAbsOrigin(me):Distance(Input.GetWorldCursorPos()):Length2D() > 600 and Input.IsKeyDown(Enum.ButtonCode.MOUSE_RIGHT) then
                                Ability.CastNoTarget(spell)
                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            end
                        elseif Ability.GetName(spell) == "item_hand_of_midas" then
                            local npc = ability.findnpc(me, "h_lvl_creep", 0, 1000)
                            if npc and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < Ability.GetCastRange(spell) then
                                Ability.CastTarget(spell, npc)
                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            end
                        elseif Ability.GetName(spell) == "item_bottle" then
                            if NPC.GetModifier(me, "modifier_fountain_aura_buff") then
                                local npc = ability.findnpc(me, "c_hero", 2, 350)
                                if npc and (Entity.GetHealth(npc) ~= Entity.GetMaxHealth(npc) or NPC.GetMana(npc) ~= NPC.GetMaxMana(npc)) and (not NPC.GetModifier(npc, "modifier_bottle_regeneration") or NPC.GetModifier(npc, "modifier_bottle_regeneration") and Modifier.GetDieTime(NPC.GetModifier(npc, "modifier_bottle_regeneration")) > 0 and Modifier.GetDieTime(NPC.GetModifier(npc, "modifier_bottle_regeneration")) - GameRules.GetGameTime() < math.random(3, 9) / 10) then
                                    Ability.CastTarget(spell, npc)
                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                elseif Entity.GetHealth(me) ~= Entity.GetMaxHealth(me) or NPC.GetMana(me) ~= NPC.GetMaxMana(me) and (not NPC.GetModifier(me, "modifier_bottle_regeneration") or NPC.GetModifier(me, "modifier_bottle_regeneration") and Modifier.GetDieTime(NPC.GetModifier(me, "modifier_bottle_regeneration")) > 0 and Modifier.GetDieTime(NPC.GetModifier(me, "modifier_bottle_regeneration")) - GameRules.GetGameTime() < math.random(3, 9) / 10) then
                                    Ability.CastTarget(spell, me)
                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                end
                            end
                        elseif Ability.GetName(spell) == "morphling_morph_agi" then
                            if not NPC.HasModifier(me, "modifier_morphling_morph_str") then
                                if (Entity.GetHealth(me) / Entity.GetMaxHealth(me) > 0.6 or NPC.HasModifier(me, "modifier_fountain_aura_buff") or NPC.HasModifier(me, "modifier_item_satanic_unholy") and Entity.GetHealth(me) / Entity.GetMaxHealth(me) > 0.3 or NPC.HasModifier(me, "modifier_flask_healing")) and Hero.GetStrength(me) > 1 then
                                    if not Ability.GetToggleState(spell) then
                                        Ability.Toggle(spell)
                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                    end
                                else
                                    if Ability.GetToggleState(spell) then
                                        Ability.Toggle(spell)
                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                    end
                                end
                            end
                        elseif Ability.GetName(spell) == "morphling_morph_str" then
                            if not NPC.HasModifier(me, "modifier_morphling_morph_agi") then
                                if Entity.GetHealth(me) / Entity.GetMaxHealth(me) < 0.4 and not NPC.HasModifier(me, "modifier_fountain_aura_buff") and not NPC.HasModifier(me, "modifier_flask_healing") and Hero.GetAgility(me) > 1 then
                                    if not Ability.GetToggleState(spell) then
                                        Ability.Toggle(spell)
                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                    end
                                else
                                    if Ability.GetToggleState(spell) then
                                        Ability.Toggle(spell)
                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                    end
                                end
                            end
                        elseif Ability.GetName(spell) == "shredder_return_chakram" or Ability.GetName(spell) == "shredder_return_chakram_2" then
                            if not target and NPC.HasModifier(me, "modifier_shredder_chakram_disarm") then
                                Ability.CastNoTarget(spell)
                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            end
                        elseif Ability.GetName(spell) == "pudge_rot" or Ability.GetName(spell) == "leshrac_pulse_nova" or Ability.GetName(spell) == "bloodseeker_blood_mist" then
                            if not target and Ability.GetToggleState(spell) then
                                Ability.Toggle(spell)
                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            end
                        elseif Ability.GetName(spell) == "broodmother_spawn_spiderlings" then
                            local npc = ability.findnpc(me, "l_health_creep", 0, distance)
                            if not Menu.IsKeyDown(ability.spellkey) and npc and Entity.GetHealth(npc) + NPC.GetHealthRegen(npc) < Ability.GetLevelSpecialValueFor(spell, "damage") * NPC.GetMagicalArmorDamageMultiplier(npc) then
                                Ability.CastTarget(spell, npc)
                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            end
                        elseif Ability.GetName(spell) == "tinker_defense_matrix" or Ability.GetName(spell) == "item_book_of_shadows" then
                            local npc = ability.findnpc(me, "c_hero", 0, distance)
                            if npc and Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(me)):Length2D() < NPC.GetAttackRange(npc) + 90 and NPC.GetTimeToFace(npc, me) < 0.03 and not NPC.HasModifier(me, "modifier_tinker_defense_matrix") then
                                Ability.CastTarget(spell, me)
                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            end
                        elseif Ability.GetName(spell) == "clinkz_death_pact" then
                            local npc = ability.findnpc(me, "h_health_creep", 3, distance)
                            if npc and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < distance then
                                Ability.CastTarget(spell, npc)
                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            end
                        elseif Ability.GetName(spell) == "ancient_apparition_ice_blast_release" then
                            Ability.CastNoTarget(spell)
                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                        elseif Ability.GetName(spell) == "tinker_rearm" then
                            local npc, channeltime = ability.findnpc(me, "c_all", 2, 600), {4, 3, 2}
                            if npc and NPC.GetUnitName(npc) == "dota_fountain" and NPC.HasModifier(me, "modifier_fountain_aura_buff") and ability.findspell("tinker_keen_teleport", "cooldown") or Menu.IsKeyDown(ability.spellkey) and not Input.IsInputCaptured() and not target and blink and ability.imageoption[blink] and Menu.IsEnabled(ability.imageoption[blink].opt) and Ability.GetCooldown(blink) > 0 and ability.findspell("item_soul_ring", "cooldown") then
                                Ability.CastNoTarget(spell)
                                ability.sleeptime["rearming"], ability.sleeptime["item_bottle"], ability.sleeptime["channelling"], ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + channeltime[Ability.GetLevel(spell)], GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + channeltime[Ability.GetLevel(spell)], GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            end
                        elseif Ability.GetName(spell) == "item_soul_ring" then
                            if NPC.GetUnitName(me) == "npc_dota_hero_tinker" and Menu.IsKeyDown(ability.spellkey) and not Input.IsInputCaptured() and not target and blink and ability.imageoption[blink] and Menu.IsEnabled(ability.imageoption[blink].opt) and Ability.GetCooldown(blink) > 0 then
                                Ability.CastNoTarget(spell)
                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            end
                        elseif Ability.GetName(spell) == "item_heavy_blade" then
                            if NPC.HasModifier(me, "modifier_invoker_cold_snap") or NPC.HasModifier(me, "modifier_dark_willow_cursed_crown") or NPC.HasModifier(me, "modifier_slardar_amplify_damage") or NPC.HasModifier(me, "modifier_meepo_earthbind_chain_duration") or NPC.HasModifier(me, "modifier_bounty_hunter_track") or NPC.IsSilenced(me) or NPC.IsRooted(me) then
                                Ability.CastTarget(spell, me)
                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                            end
                        end

                        if blink and Ability.IsReady(blink) and ability.imageoption[blink] and Menu.IsEnabled(ability.imageoption[blink].opt) and (not ability.sleeptime[Ability.GetName(blink)] or GameRules.GetGameTime() > ability.sleeptime[Ability.GetName(blink)]) then
                            if Ability.GetName(spell) == "tinker_rearm" then
                                if target and NPC.IsHero(target) and Input.GetWorldCursorPos():Distance(Entity.GetAbsOrigin(target)):Length2D() < 600 and Entity.GetAbsOrigin(me):Distance(Input.GetWorldCursorPos()):Length2D() < Ability.GetCastRange(blink) + 600 then
                                    Ability.CastPosition(blink, ability.skillshotXYZ(me, target, 1300) + ((Input.GetWorldCursorPos() - ability.skillshotXYZ(me, target, 1300)):Normalized():Scaled(600))) 
                                    ability.sleeptime["tinker_rearm"], ability.sleeptime[Ability.GetName(blink)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                elseif Menu.IsKeyDown(ability.spellkey) and not Input.IsInputCaptured() and Entity.GetAbsOrigin(me):Distance(Input.GetWorldCursorPos()):Length2D() < Ability.GetCastRange(blink) then
                                    Ability.CastPosition(blink, Input.GetWorldCursorPos())
                                    ability.sleeptime["tinker_rearm"], ability.sleeptime[Ability.GetName(blink)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                elseif Menu.IsKeyDown(ability.spellkey) and not Input.IsInputCaptured() and Entity.GetAbsOrigin(me):Distance(Input.GetWorldCursorPos()):Length2D() > Ability.GetCastRange(blink) then
                                    Ability.CastPosition(blink, Entity.GetAbsOrigin(me) + ((Input.GetWorldCursorPos() - Entity.GetAbsOrigin(me)):Normalized():Scaled(Ability.GetCastRange(blink))))
                                    ability.sleeptime["tinker_rearm"], ability.sleeptime[Ability.GetName(blink)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                end
                            elseif target and ability.findspell("ogre_magi_bloodlust", "cooldown") and ability.findspell("legion_commander_press_the_attack", "cooldown") and (ability.findspell("pudge_meat_hook", "lastuse3") or ability.checkspellblocked(me, Entity.GetAbsOrigin(me), ability.skillshotXYZ(me, target, 2100), target, spell)) and ((Ability.GetDispellableType(spell) == 1 and not Ability.IsItem(spell) or NPC.GetAttackRange(me) < 300 or Ability.GetName(spell) == "enigma_black_hole" or Ability.GetName(spell) == "nevermore_requiem" or Ability.GetName(spell) == "templar_assassin_meld" or Ability.GetName(spell) == "arc_warden_flux" or Ability.GetName(spell) == "dark_willow_shadow_realm")) then
                                if Ability.GetName(spell) == "enigma_black_hole" or Ability.GetName(spell) == "nevermore_requiem" or Ability.GetName(spell) == "templar_assassin_meld" or Ability.GetName(spell) == "leshrac_pulse_nova" then
                                    if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < Ability.GetCastRange(blink) then
                                        Ability.CastPosition(blink, ability.skillshotXYZ(me, target, 950))
                                        ability.sleeptime[Ability.GetName(blink)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                    end
                                else
                                    if distance > 0 and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < Ability.GetCastRange(blink) + NPC.GetAttackRange(me) and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 300 then
                                        Ability.CastPosition(blink, Entity.GetAbsOrigin(me) + ((ability.skillshotXYZ(me, target, 1300) - Entity.GetAbsOrigin(me)):Normalized():Scaled(ability.skillshotXYZ(me, target, 1300):Distance(Entity.GetAbsOrigin(me)):Length2D() - NPC.GetAttackRange(me))))
                                        ability.sleeptime[Ability.GetName(blink)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                    end
                                end
                            end
                        end

                        if target and Ability.GetName(spell) ~= "rubick_spell_steal" and Ability.GetName(spell) ~= "invoker_invoke" and Ability.IsReady(spell) and Ability.IsCastable(spell, NPC.GetMana(me)) and (not NPC.IsChannellingAbility(me) or Ability.GetName(spell) == "pudge_rot") then
                            if Ability.GetName(spell) == "puck_illusory_orb" then ability.sleeptime["puck_ethereal_jaunt"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + Entity.GetAbsOrigin(me):Distance(ability.skillshotXYZ(me, target, 300)):Length2D() / 600 end
                            if (ability.safe_cast(me, target, spell) or Ability.GetName(spell) == "obsidian_destroyer_sanity_eclipse" and NPC.HasModifier(target, "modifier_obsidian_destroyer_astral_imprisonment_prison")) and not NPC.HasModifier(me, "modifier_snapfire_mortimer_kisses") and not NPC.IsChannellingAbility(me) and (not NPC.IsStunned(me) or Ability.GetName(spell) == "ursa_enrage" and (NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed"))) then
                                if distance > 0 and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < distance and ability.disable_manager(spell, target) and (target and NPC.IsCreep(target) or not ethereal_blade or ability.imageoption[ethereal_blade] and not Menu.IsEnabled(ability.imageoption[ethereal_blade].opt) or Ability.GetDamageType(spell) ~= 2 and Ability.GetDamageType(spell) ~= 4 or ethereal_blade and (Ability.GetDamageType(spell) == 2 or Ability.GetDamageType(spell) == 4) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and Ability.SecondsSinceLastUse(ethereal_blade) > Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() / 1300 and Ability.SecondsSinceLastUse(ethereal_blade) < 4 or Ability.SecondsSinceLastUse(ethereal_blade) > 4 and Ability.GetCooldown(ethereal_blade) > 0 or Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > Ability.GetCastRange(ethereal_blade)) and (not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) or Ability.GetDamageType(spell) == 1 or Ability.GetDamageType(spell) == 0) then
                                    if ((Ability.GetBehavior(spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_NO_TARGET) ~= 0 or (Ability.GetBehavior(spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_TOGGLE) ~= 0) and distance < 600 and NPC.GetTimeToFace(target, me) > 0.03 then distance = distance - (distance / 3) end
                                    if (Ability.GetBehavior(spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_NO_TARGET) ~= 0 then
                                        --items
                                        if Ability.GetName(spell) == "item_manta" then
                                            if NPC.IsSilenced(me) then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "item_soul_ring" then
                                            if Entity.GetHealth(me) / Entity.GetMaxHealth(me) > 0.3 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "item_revenants_brooch" then
                                            if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < NPC.GetAttackRange(me) then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 15
                                            end
                                        elseif Ability.GetName(spell) == "item_bottle" then
                                            if (Bottle.GetRuneType(spell) == 6 or Bottle.GetRuneType(spell) == 2 or Bottle.GetRuneType(spell) == 0) and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < NPC.GetAttackRange(me) + 300 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "item_phase_boots" then
                                            if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 300 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "item_ogre_seal_totem" then
                                            if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > 550 and NPC.GetTimeToFace(me, target) < 0.03 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "item_satanic" or Ability.GetName(spell) == "item_magic_wand" or Ability.GetName(spell) == "item_magic_stick" or Ability.GetName(spell) == "item_faerie_fire" or Ability.GetName(spell) == "item_essence_ring" then
                                            if Entity.GetHealth(me) / Entity.GetMaxHealth(me) < 0.35 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "item_bloodstone" then
                                            Ability.CastNoTarget(spell)
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "item_enchanted_mango" then
                                            if NPC.GetMana(me) / NPC.GetMaxMana(me) < 0.3 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "item_guardian_greaves" then
                                            if NPC.GetMana(me) / NPC.GetMaxMana(me) < 0.5 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "item_mask_of_madness" then
                                            if ability.findspell("ultimate", "cooldown") and ability.findspell("faceless_void_chronosphere", "cooldown") and ability.findspell("juggernaut_omni_slash", "cooldown") and ability.findspell("sven_storm_bolt", "cooldown") and ability.findspell("sven_gods_strength", "cooldown") then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "item_refresher_shard" or Ability.GetName(spell) == "item_refresher" or Ability.GetName(spell) == "item_trickster_cloak" then
                                            if ability.findspell("ultimate", "cooldown") and ability.findspell("item_arcane_blink", "cooldown") and ability.findspell("item_ethereal_blade", "cooldown") and ability.findspell("item_dagon_2", "cooldown") and ability.findspell("item_dagon_3", "cooldown") and ability.findspell("item_dagon_4", "cooldown") and ability.findspell("item_dagon_5", "cooldown") and ability.findspell("item_abyssal_blade", "cooldown") and ability.findspell("item_bloodthorn", "cooldown") and ability.findspell("item_sheepstick", "cooldown") and ability.findspell("mars_spear", "cooldown") and ability.findspell("clinkz_strafe", "cooldown") then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "item_ex_machina" then
                                            if ability.findspell("item_refresher_shard", "cooldown") and ability.findspell("item_refresher", "cooldown") and ability.findspell("item_abyssal_blade", "cooldown") and ability.findspell("item_bloodthorn", "cooldown") and ability.findspell("item_sheepstick", "cooldown") and ability.findspell("item_ethereal_blade", "cooldown") and ability.findspell("item_dagon_2", "cooldown") and ability.findspell("item_dagon_3", "cooldown") and ability.findspell("item_dagon_4", "cooldown") and ability.findspell("item_dagon_5", "cooldown") then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "item_blade_mail" then
                                            if ability.findspell("axe_berserkers_call", "cooldown") then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "item_smoke_of_deceit" then
                                        elseif Ability.GetName(spell) == "item_ghost" then
                                        elseif Ability.GetName(spell) == "item_stormcrafter" then
                                        elseif Ability.GetName(spell) == "item_black_king_bar" then
                                        elseif Ability.GetName(spell) == "item_radiance" then
                                        elseif Ability.GetName(spell) == "item_armlet" then
                                        elseif Ability.GetName(spell) == "item_power_treads" then
                                        elseif Ability.GetName(spell) == "item_pogo_stick" then
                                        elseif Ability.GetName(spell) == "item_ring_of_aquila" then
                                        elseif Ability.GetName(spell) == "item_vambrace" then
                                        elseif Ability.GetName(spell) == "item_dust" or Ability.GetName(spell) == "item_ward_observer" or Ability.GetName(spell) == "item_ward_dispenser" then
                                        elseif Ability.GetName(spell) == "item_silver_edge" or Ability.GetName(spell) == "item_invis_sword" then
                                        --abilities
                                        elseif Ability.GetName(spell) == "void_spirit_resonant_pulse" and (NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed")) then
                                            if Ability.GetCurrentCharges(spell) > 0 and not NPC.HasModifier(me, "modifier_void_spirit_resonant_pulse_physical_buff") then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "slark_pounce" or Ability.GetName(spell) == "nevermore_shadowraze1" or Ability.GetName(spell) == "nevermore_shadowraze2" or Ability.GetName(spell) == "nevermore_shadowraze3" then
                                            if (Ability.GetName(spell) == "slark_pounce" and not NPC.HasModifier(target, "modifier_slark_pounce_leash") or Ability.GetName(spell) == "nevermore_shadowraze1" or Ability.GetName(spell) == "nevermore_shadowraze2" and Entity.GetAbsOrigin(me):Distance(ability.skillshotXYZ(me, target, 900)):Length2D() > 250 or Ability.GetName(spell) == "nevermore_shadowraze3" and Entity.GetAbsOrigin(me):Distance(ability.skillshotXYZ(me, target, 900)):Length2D() > 450) and Entity.GetAbsOrigin(me):Distance(ability.skillshotXYZ(me, target, 900)):Length2D() < distance and NPC.GetTimeToFace(me, target) < 0.01 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime["slark_pounce"], ability.sleeptime["nevermore_shadowraze1"], ability.sleeptime["nevermore_shadowraze2"], ability.sleeptime["nevermore_shadowraze3"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "tinker_rearm" then
                                            local channeltime = {4, 3, 2}
                                            if ability.findspell("item_blink", "cooldown") and ability.findspell("item_overwhelming_blink", "cooldown") and (ability.findspell("tinker_laser", "cooldown") or blink and ability.imageoption[blink] and Menu.IsEnabled(ability.imageoption[blink].opt) and ability.findspell("tinker_laser", "outrange")) and (ability.findspell("tinker_heat_seeking_missile", "cooldown") or ability.findspell("tinker_heat_seeking_missile", "outrange")) and ability.findspell("item_soul_ring", "cooldown") and (ability.findspell("item_shivas_guard", "cooldown") or ability.findspell("item_shivas_guard", "outrange")) and (ability.findspell("item_sheepstick", "cooldown") or ability.findspell("item_sheepstick", "outrange")) and (ability.findspell("item_ethereal_blade", "cooldown") or ability.findspell("item_ethereal_blade", "outrange")) and (ability.findspell("item_dagon", "cooldown") or ability.findspell("item_dagon", "outrange")) and (ability.findspell("item_dagon_2", "cooldown") or ability.findspell("item_dagon_2", "outrange")) and (ability.findspell("item_dagon_3", "cooldown") or ability.findspell("item_dagon_3", "outrange")) and (ability.findspell("item_dagon_4", "cooldown") or ability.findspell("item_dagon_4", "outrange")) and (ability.findspell("item_dagon_5", "cooldown") or ability.findspell("item_dagon_5", "outrange")) or NPC.IsCreep(target) and (ability.findspell("tinker_laser", "cooldown") or blink and ability.imageoption[blink] and Menu.IsEnabled(ability.imageoption[blink].opt) and ability.findspell("tinker_laser", "outrange")) and ability.findspell("item_soul_ring", "cooldown") and (ability.findspell("item_shivas_guard", "cooldown") or ability.findspell("item_shivas_guard", "outrange")) then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime["rearming"], ability.sleeptime["channelling"], ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + channeltime[Ability.GetLevel(spell)], GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "leshrac_pulse_nova" then
                                            if NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") then radius = 750 else radius = 450 end
                                            if not Ability.GetToggleState(spell) and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < radius then
                                                Ability.Toggle(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            elseif Ability.GetToggleState(spell) and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > radius then
                                                Ability.Toggle(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "shredder_return_chakram" then
                                            if not NPC.HasModifier(target, "modifier_shredder_chakram_debuff") then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "shredder_return_chakram_2" then
                                            if not NPC.HasModifier(target, "modifier_shredder_chakram_debuff") then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "terrorblade_terror_wave" or Ability.GetName(spell) == "kunkka_torrent_storm" or Ability.GetName(spell) == "magnataur_reverse_polarity" or Ability.GetName(spell) == "tidehunter_ravage" or Ability.GetName(spell) == "treant_overgrowth" or Ability.GetName(spell) == "medusa_stone_gaze" then
                                            if #Heroes.InRadius(Entity.GetAbsOrigin(me), distance, Entity.GetTeamNum(me), 0) > 1 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "earthshaker_echo_slam" then
                                            if #Heroes.InRadius(Entity.GetAbsOrigin(me), distance, Entity.GetTeamNum(me), 0) > 2 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "alchemist_unstable_concoction" then
                                            Ability.CastNoTarget(spell)
                                            ability.sleeptime["alchemist_unstable_concoction_throw"], ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 4, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "alchemist_chemical_rage" or Ability.GetName(spell) == "sniper_take_aim" then
                                            if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < NPC.GetAttackRange(me) + 200 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "visage_summon_familiars_stone_form" then
                                            Ability.CastNoTarget(spell)
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 1.5
                                        elseif Ability.GetName(spell) == "void_spirit_dissimilate" then
                                            if NPC.HasModifier(me, "modifier_item_aghanims_shard") then radius = 1120 else radius = 620 end
                                            if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < radius and (NPC.IsStunned(target) or NPC.IsRooted(target) or NPC.HasModifier(target, "modifier_void_spirit_aether_remnant_pull")) then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "phantom_lancer_phantom_edge" then
                                            if NPC.GetAbility(me, "special_bonus_unique_phantom_lancer") and Ability.GetLevel(NPC.GetAbility(me, "special_bonus_unique_phantom_lancer")) > 0 then max_distance = {900, 975, 1050, 1125} else max_distance = {600, 675, 750, 825} end
                                            if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < max_distance[Ability.GetLevel(spell)] then
                                                Player.AttackTarget(Players.GetLocal(), me, target)
                                                ability.sleeptime["channelling"], ability.sleeptime[Ability.GetName(spell)], ability.sleeptime["phantom_lancer_spirit_lance"], ability.sleeptime["phantom_lancer_doppelwalk"], ability.sleeptime["phantom_lancer_juxtapose"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() / 600, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() / 600, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() / 600, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() / 600
                                            end
                                        elseif Ability.GetName(spell) == "pudge_rot" then
                                            if NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") then rot_radius = 475 else rot_radius = 250 end
                                            if not Ability.GetToggleState(spell) and (Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < rot_radius or NPC.HasModifier(me, "modifier_pudge_swallow")) then
                                                Ability.Toggle(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            elseif Ability.GetToggleState(spell) and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > rot_radius then
                                                Ability.Toggle(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "bloodseeker_blood_mist" then
                                            if not Ability.GetToggleState(spell) and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < 450 then
                                                Ability.Toggle(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            elseif Ability.GetToggleState(spell) and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > 450 then
                                                Ability.Toggle(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "phoenix_sun_ray_toggle_move" then
                                            if not toggle_move and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > 900 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)], toggle_move = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, true
                                            elseif toggle_move and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < 900 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)], toggle_move = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, false
                                            end
                                        elseif Ability.GetName(spell) == "magnataur_horn_toss" then
                                            local npc = ability.findnpc(me, "c_all", 2, 2000)
                                            if npc and ability.findspell("magnataur_skewer", "ready") and (ability.skillshotXYZ(me, target, 950):GetX() - Entity.GetAbsOrigin(me):GetX()) / (Entity.GetAbsOrigin(npc):GetX() - Entity.GetAbsOrigin(me):GetX()) < 0 and (ability.skillshotXYZ(me, target, 950):GetY() - Entity.GetAbsOrigin(me):GetY()) / (Entity.GetAbsOrigin(npc):GetY() - Entity.GetAbsOrigin(me):GetY()) < 0 and math.abs((ability.skillshotXYZ(me, target, 950):GetX() - Entity.GetAbsOrigin(me):GetX()) / (Entity.GetAbsOrigin(npc):GetX() - Entity.GetAbsOrigin(me):GetX()) - (ability.skillshotXYZ(me, target, 950):GetY() - Entity.GetAbsOrigin(me):GetY()) / (Entity.GetAbsOrigin(npc):GetY() - Entity.GetAbsOrigin(me):GetY())) < 0.3 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime["magnataur_reverse_polarity"], ability.sleeptime["magnataur_shockwave"], ability.sleeptime["magnataur_greater_shockwave"], ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, GameRules.GetGameTime() + 0.6, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end                                            
                                        elseif Ability.GetName(spell) == "visage_gravekeepers_cloak" or Ability.GetName(spell) == "meepo_petrify" or Ability.GetName(spell) == "huskar_inner_fire" or Ability.GetName(spell) == "troll_warlord_battle_trance" then
                                            if Entity.GetHealth(me) / Entity.GetMaxHealth(me) < 0.3 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "elder_titan_echo_stomp" then
                                            local npc = ability.findnpc(me, "as", 2, distance)
                                            if npc and Entity.GetAbsOrigin(npc):Distance(ability.skillshotXYZ(me, target, 950)):Length2D() < 500 or Entity.GetAbsOrigin(me):Distance(ability.skillshotXYZ(me, target, 950)):Length2D() < 500 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "keeper_of_the_light_recall" then
                                            local npc = ability.findnpc(me, "h_phys_hero", 2, distance)
                                            if npc and Entity.GetHealth(npc) / Entity.GetMaxHealth(npc) > 0.6 then
                                                Ability.CastTarget(spell, npc)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "troll_warlord_berserkers_rage" then
                                            if Ability.GetToggleState(spell) and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 100 then
                                                Ability.Toggle(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() / 500
                                            elseif not Ability.GetToggleState(spell) and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < NPC.GetAttackRange(me) + 100 then
                                                Ability.Toggle(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() / 500
                                            end
                                        elseif Ability.GetName(spell) == "winter_wyvern_arctic_burn" then
                                            if not NPC.HasModifier(me, "modifier_winter_wyvern_arctic_burn_flight") then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "skeleton_king_vampiric_aura" then
                                            if NPC.GetModifier(me, "modifier_skeleton_king_vampiric_aura") and Modifier.GetStackCount(NPC.GetModifier(me, "modifier_skeleton_king_vampiric_aura")) > 6 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "shadow_demon_shadow_poison_release" then
                                            if NPC.GetModifier(target, "modifier_shadow_demon_shadow_poison") and Entity.GetHealth(target) + NPC.GetHealthRegen(target) < (stack_damage + 50) * Modifier.GetStackCount(NPC.GetModifier(target, "modifier_shadow_demon_shadow_poison")) * NPC.GetMagicalArmorDamageMultiplier(target) then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "brewmaster_drunken_brawler" then
                                            if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 150 and ability.calling[NPC.GetUnitName(me)] ~= "stance_storm" then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.15
                                            elseif Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < NPC.GetAttackRange(me) + 50 and ability.calling[NPC.GetUnitName(me)] ~= "stance_fire" then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.15
                                            elseif Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < NPC.GetAttackRange(me) + 50 and NPC.HasModifier(me, "modifier_item_aghanims_shard") and not NPC.GetModifier(target, "modifier_brewmaster_void_brawler_slow") and ability.calling[NPC.GetUnitName(me)] ~= "stance_void" then
                                                --Ability.CastNoTarget(spell)
                                                --ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.15 
                                            end
                                        elseif not Ability.IsStolen(spell) and Ability.GetName(spell) == "zuus_thundergods_wrath" then
                                            if Entity.GetHealth(target) + NPC.GetHealthRegen(target) < Ability.GetLevelSpecialValueFor(spell, "damage") * NPC.GetMagicalArmorDamageMultiplier(target) then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif not Ability.IsStolen(spell) and Ability.GetName(spell) == "nevermore_requiem" then
                                            if NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") then max_souls = 20 else max_souls = 15 end
                                            if NPC.GetModifier(me, "modifier_nevermore_necromastery") and Modifier.GetStackCount(NPC.GetModifier(me, "modifier_nevermore_necromastery")) > max_souls then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "hoodwink_scurry" then
                                            if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < NPC.GetAttackRange(target) + 100 and NPC.GetTimeToFace(target, me) < 0.03 and NPC.IsAttacking(target) then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.6
                                            end
                                        elseif (Ability.GetName(spell) == "storm_spirit_static_remnant" or Ability.GetName(spell) == "storm_spirit_electric_vortex") and not Ability.IsStolen(spell) then
                                            if not NPC.HasModifier(me, "modifier_storm_spirit_overload") then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "storm_spirit_overload" then
                                            local npc = ability.findnpc(target, "c_hero", 2, distance)
                                            if npc and Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(target)):Length2D() < 300 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "weaver_shukuchi" then
                                            if not NPC.HasModifier(me, "modifier_weaver_shukuchi") and (NPC.GetTimeToFace(target, me) < 0.03 and NPC.IsAttacking(target) or Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 110) then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime["weaver_geminate_attack"], ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "morphling_morph_replicate" then
                                            -- rework
                                        elseif Ability.GetName(spell) == "primal_beast_uproar" then
                                            if not NPC.HasModifier(me, "modifier_primal_beast_onslaught_windup") and not NPC.HasModifier(me, "modifier_primal_beast_trample") and NPC.GetModifier(me, "modifier_primal_beast_uproar") and Modifier.GetStackCount(NPC.GetModifier(me, "modifier_primal_beast_uproar")) == 5 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "primal_beast_trample" then
                                            if ability.findspell("primal_beast_pulverize", "cooldown") then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "templar_assassin_trap" then
                                            local trap = ability.findnpc(me, "trap", 2, distance)
                                            if trap and Entity.GetAbsOrigin(trap):Distance(ability.skillshotXYZ(me, target, 950)):Length2D() < 400 then
                                                Ability.CastNoTarget(NPC.GetAbility(trap, "templar_assassin_self_trap"))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "slardar_sprint" then
                                            if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 300 then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "ursa_enrage" then
                                            if (NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed")) and NPC.IsStunned(me) or Entity.GetHealth(me) / Entity.GetMaxHealth(me) < 0.35 and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < NPC.GetAttackRange(me) then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "brewmaster_primal_companion" then
                                            if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < NPC.GetAttackRange(me) + 50 and ability.calling[NPC.GetUnitName(me)] == "stance_fire" or Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 150 and ability.calling[NPC.GetUnitName(me)] == "stance_earth" then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "dawnbreaker_converge" then
                                            if ability.calling[NPC.GetUnitName(me)] and ability.calling[NPC.GetUnitName(me)].name == "hammer_grounded" then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "tinker_heat_seeking_missile" then
                                            if NPC.IsHero(target) then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "ember_spirit_searing_chains" then
                                            if ability.calling[target] or not NPC.HasModifier(me, "modifier_ember_spirit_sleight_of_fist_caster") then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "techies_reactive_tazer" then
                                            local npc = ability.findnpc(me, "c_hero", 0, distance)
                                            if npc and Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(me)):Length2D() < NPC.GetAttackRange(npc) + 90 and NPC.GetTimeToFace(npc, me) < 0.03 and not NPC.HasModifier(me, "modifier_tinker_defense_matrix") then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "hoodwink_decoy" then
                                            if NPC.HasModifier(me, "modifier_hoodwink_sharpshooter_windup") then
                                                Ability.CastNoTarget(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "clinkz_wind_walk" then
                                        elseif Ability.GetName(spell) == "phoenix_icarus_dive_stop" then
                                        elseif Ability.GetName(spell) == "hoodwink_sharpshooter_release" then
                                        elseif Ability.GetName(spell) == "pangolier_gyroshell_stop" then
                                        elseif Ability.GetName(spell) == "tinker_keen_teleport" then
                                        elseif Ability.GetName(spell) == "nyx_assassin_vendetta" then
                                        elseif Ability.GetName(spell) == "spectre_haunt" and not Ability.IsStolen(spell) then
                                        elseif not Ability.IsStolen(spell) and 
                                            (Ability.GetName(spell) == "mars_bulwark" or 
                                            Ability.GetName(spell) == "chen_hand_of_god" or 
                                            Ability.GetName(spell) == "enchantress_natures_attendants" or 
                                            Ability.GetName(spell) == "omniknight_guardian_angel" or 
                                            Ability.GetName(spell) == "nyx_assassin_vendetta" or
                                            Ability.GetName(spell) == "phantom_assassin_blur" or 
                                            Ability.GetName(spell) == "monkey_king_mischief" or 
                                            Ability.GetName(spell) == "puck_phase_shift" or 
                                            Ability.GetName(spell) == "life_stealer_rage" or 
                                            Ability.GetName(spell) == "nyx_assassin_spiked_carapace" or 
                                            Ability.GetName(spell) == "antimage_counterspell" or 
                                            Ability.GetName(spell) == "chaos_knight_phantasm" or 
                                            Ability.GetName(spell) == "phoenix_supernova" or 
                                            Ability.GetName(spell) == "windrunner_windrun" or 
                                            Ability.GetName(spell) == "silencer_global_silence" or 
                                            Ability.GetName(spell) == "weaver_time_lapse" or 
                                            Ability.GetName(spell) == "slark_shadow_dance" or 
                                            Ability.GetName(spell) == "brewmaster_primal_split" or 
                                            Ability.GetName(spell) == "naga_siren_song_of_the_siren" or 
                                            Ability.GetName(spell) == "visage_summon_familiars" or 
                                            Ability.GetName(spell) == "mirana_invis" or 
                                            Ability.GetName(spell) == "troll_warlord_rampage" or 
                                            Ability.GetName(spell) == "pangolier_gyroshell" or 
                                            Ability.GetName(spell) == "juggernaut_blade_fury" or 
                                            Ability.GetName(spell) == "lone_druid_savage_roar" or 
                                            Ability.GetName(spell) == "bounty_hunter_wind_walk" or 
                                            Ability.GetName(spell) == "centaur_stampede" or 
                                            Ability.GetName(spell) == "faceless_void_time_walk_reverse") then
                                        else
                                            Ability.CastNoTarget(spell)
                                            if Ability.GetName(spell) == "puck_phase_shift" or Ability.GetName(spell) == "meepo_petrify" or Ability.GetName(spell) == "elder_titan_echo_stomp" then ability.sleeptime["channelling"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 1 end
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        end
                                    elseif (Ability.GetBehavior(spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 then
                                        if (Ability.GetTargetTeam(spell) & Enum.TargetTeam.DOTA_UNIT_TARGET_TEAM_FRIENDLY) ~= 0 then
                                            if Ability.GetName(spell) == "snapfire_firesnap_cookie" then
                                                local npc = ability.findnpc(me, "c_hero", 2, distance) or ability.findnpc(me, "c_creep", 2, distance)
                                                if npc and ability.skillshotXYZ(me, target, 950):Distance(Entity.GetAbsOrigin(npc) + Entity.GetRotation(npc):GetForward():Normalized():Scaled(425)):Length2D() < 150 then
                                                    Ability.CastTarget(spell, npc)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "dark_seer_ion_shell" then
                                                local npc = ability.findnpc(target, "c_hero", 0, distance)
                                                if npc and Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(target)):Length2D() < 275 then
                                                    Ability.CastTarget(spell, npc)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "marci_guardian" then
                                                if NPC.HasModifier(me, "modifier_marci_unleash") then
                                                    Ability.CastTarget(spell, me)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "obsidian_destroyer_astral_imprisonment" then
                                                local npc = ability.findnpc(me, "h_mana_hero", 0, 3000)
                                                if npc and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < distance then
                                                    Ability.CastTarget(spell, npc)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "lycan_wolf_bite" then
                                                local npc = ability.findnpc(me, "h_phys_hero", 2, 3000)
                                                if npc and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < distance then
                                                    Ability.CastTarget(spell, npc)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "ogre_magi_bloodlust" then
                                                local npc = ability.findnpc(target, "h_phys_hero", 0, 2000)
                                                if npc and (Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < Ability.GetCastRange(spell) or npc == Heroes.GetLocal() and ability.findspell("item_blink", "ready") and ability.findspell("item_overwhelming_blink", "ready") and ability.findspell("item_arcane_blink", "ready")) then
                                                    Ability.CastTarget(spell, npc)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "ogre_magi_smash" then
                                                local npc = ability.findnpc(target, "c_hero", 0, 1000)
                                                if npc and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < Ability.GetCastRange(spell) then
                                                    Ability.CastTarget(spell, npc)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "luna_eclipse" then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 1000))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            elseif Ability.GetName(spell) == "marci_grapple" then
                                                Ability.CastTarget(spell, target)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            elseif Ability.GetName(spell) == "marci_companion_run" then
                                                local npc = ability.findnpc(me, "c_hero", 2, distance - rebound_range - 150) or ability.findnpc(me, "c_creep", 2, distance - rebound_range - 150)
                                                if npc and Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(me)):Length2D() < rebound_range and Entity.GetAbsOrigin(npc):Distance(ability.skillshotXYZ(me, target, 1300)):Length2D() > 450 and Entity.GetAbsOrigin(npc):Distance(ability.skillshotXYZ(me, target, 1300)):Length2D() < landing_radius then
                                                    Ability.CastTarget(spell, npc)
                                                    Player.PrepareUnitOrders(Players.GetLocal(), 30, nil, ability.skillshotXYZ(me, target, 950), spell, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY, me)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "hoodwink_hunters_boomerang" and not Ability.IsStolen(spell) then
                                                Ability.CastPosition(spell, Entity.GetAbsOrigin(me) + ((ability.skillshotXYZ(me, target, 2000) - Entity.GetAbsOrigin(me)):Normalized():Scaled(1000)))
                                                ability.sleeptime["hoodwink_bushwhack"], ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() / 700, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            elseif Ability.GetName(spell) == "kunkka_x_marks_the_spot" then
                                                if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 100 then
                                                    Ability.CastTarget(spell, target)
                                                    ability.sleeptime["kunkka_return"], ability.cast_pos[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 1.5, {pos = Entity.GetAbsOrigin(target), time = GameRules.GetGameTime() + 4}
                                                end
                                            elseif Ability.GetName(spell) == "magnataur_empower" then
                                                if not NPC.HasModifier(me, "modifier_magnataur_empower") then
                                                    Ability.CastTarget(spell, me)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "meepo_poof" then
                                                if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < 375 then ability.cast_pos[Ability.GetName(spell)] = {pos = Entity.GetAbsOrigin(target), time = GameRules.GetGameTime() + 4} end
                                                if ability.cast_pos[Ability.GetName(spell)] and ability.cast_pos[Ability.GetName(spell)].pos then
                                                    Ability.CastPosition(spell, ability.cast_pos[Ability.GetName(spell)].pos)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "earth_spirit_boulder_smash" or Ability.GetName(spell) == "earth_spirit_geomagnetic_grip" then
                                                local stone = ability.findnpc(target, "stone", 3, distance)
                                                if stone and Ability.GetName(spell) == "earth_spirit_boulder_smash" and Entity.GetAbsOrigin(stone):Distance(Entity.GetAbsOrigin(me)):Length2D() < 200 then
                                                    Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 1000))
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                elseif stone and Ability.GetName(spell) == "earth_spirit_geomagnetic_grip" and (Entity.GetAbsOrigin(stone):GetX() - ability.skillshotXYZ(me, target, 2000):GetX()) / (Entity.GetAbsOrigin(me):GetX() - ability.skillshotXYZ(me, target, 2000):GetX()) < 0 and (Entity.GetAbsOrigin(stone):GetY() - ability.skillshotXYZ(me, target, 2000):GetY()) / (Entity.GetAbsOrigin(me):GetY() - ability.skillshotXYZ(me, target, 2000):GetY()) < 0 and math.abs((Entity.GetAbsOrigin(stone):GetX() - ability.skillshotXYZ(me, target, 2000):GetX()) / (Entity.GetAbsOrigin(me):GetX() - ability.skillshotXYZ(me, target, 2000):GetX()) - (Entity.GetAbsOrigin(stone):GetY() - ability.skillshotXYZ(me, target, 2000):GetY()) / (Entity.GetAbsOrigin(me):GetY() - ability.skillshotXYZ(me, target, 2000):GetY())) < 0.3 or NPC.HasModifier(target, "modifier_earth_spirit_boulder_smash_debuff") then
                                                    Ability.CastPosition(spell, Entity.GetAbsOrigin(stone))
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "tinker_defense_matrix" or Ability.GetName(spell) == "lich_frost_shield" or Ability.GetName(spell) == "grimstroke_spirit_walk" or Ability.GetName(spell) == "wisp_tether" or Ability.GetName(spell) == "techies_reactive_tazer" then
                                                local npc = ability.findnpc(target, "c_hero", 0, distance)
                                                if npc and NPC.IsHero(target) and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < Ability.GetCastRange(spell) and (Ability.GetName(spell) == "tinker_defense_matrix" and Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(target)):Length2D() < NPC.GetAttackRange(target) + 150 and NPC.GetTimeToFace(target, npc) < 0.03 and not NPC.HasModifier(npc, "modifier_tinker_defense_matrix") and Entity.GetHealth(npc) / Entity.GetMaxHealth(npc) < 0.5 or Ability.GetName(spell) ~= "tinker_defense_matrix") then
                                                    Ability.CastTarget(spell, npc)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "oracle_fortunes_end" then
                                                if not NPC.HasModifier(target, "modifier_oracle_fates_edict") then
                                                    Ability.CastTarget(spell, target)
                                                    ability.sleeptime["channelling"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 1
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "oracle_fates_edict" then
                                                local npc = ability.findnpc(me, "h_phys_hero", 0, distance)
                                                if npc and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < distance then
                                                    Ability.CastTarget(spell, npc)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "dazzle_shadow_wave" or Ability.GetName(spell) == "treant_living_armor" or Ability.GetName(spell) == "shadow_demon_demonic_cleanse" or Ability.GetName(spell) == "omniknight_purification" or Ability.GetName(spell) == "omniknight_martyr" then 
                                                local npc = ability.findnpc(target, "c_hero", 0, distance)
                                                if npc and (Ability.GetName(spell) == "dazzle_shadow_wave" and Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(target)):Length2D() < 185 or Ability.GetName(spell) == "treant_living_armor" and Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(target)):Length2D() < 1500 or Ability.GetName(spell) == "shadow_demon_demonic_cleanse" and Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(target)):Length2D() < 600 or (Ability.GetName(spell) == "omniknight_purification" or Ability.GetName(spell) == "omniknight_martyr") and Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(target)):Length2D() < 260) then
                                                    Ability.CastTarget(spell, npc)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "keeper_of_the_light_chakra_magic" then
                                                local npc = ability.findnpc(target, "l_mana_hero", 0, distance)
                                                if npc and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < distance then
                                                    Ability.CastTarget(spell, npc)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "dazzle_good_juju" then
                                                if ability.findspell("item_ethereal_blade", "cooldown") and ability.findspell("item_sheepstick", "cooldown") and ability.findspell("item_dagon", "cooldown") and ability.findspell("item_dagon_2", "cooldown") and ability.findspell("item_dagon_3", "cooldown") and ability.findspell("item_dagon_4", "cooldown") and ability.findspell("item_dagon_5", "cooldown") then
                                                    Ability.CastTarget(spell, me)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "shadow_demon_disruption" then
                                                local npc = ability.findnpc(me, "h_phys_hero", 0, distance)
                                                if npc and not NPC.HasModifier(npc, "modifier_shadow_demon_disruption") and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < NPC.GetAttackRange(npc) + 100 and NPC.GetTimeToFace(npc, me) < 0.03 then
                                                    Ability.CastTarget(spell, npc)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "necrolyte_death_seeker" then
                                                Ability.CastTarget(spell, target)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            elseif not Ability.IsStolen(spell) and Ability.GetName(spell) == "oracle_purifying_flames" then
                                                if (Entity.GetHealth(target) + NPC.GetHealthRegen(target) < (Ability.GetLevelSpecialValueFor(spell, "damage") * NPC.GetMagicalArmorDamageMultiplier(target)) or Ability.GetLevel(spell) > 3) and not NPC.HasModifier(target, "modifier_oracle_fates_edict") then
                                                    Ability.CastTarget(spell, target)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "riki_tricks_of_the_trade" then
                                                local npc = ability.findnpc(me, "c_hero", 2, distance)
                                                if npc and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < distance then
                                                    Ability.CastTarget(spell, npc)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "legion_commander_press_the_attack" then
                                                Ability.CastTarget(spell, me)
                                                ability.sleeptime[Ability.GetName(spell)], ability.sleeptime["legion_commander_duel"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            elseif Ability.GetName(spell) == "terrorblade_sunder" then
                                                local npc = ability.findnpc(me, "h_health_hero", 0, distance)
                                                if npc and Entity.GetHealth(me) / Entity.GetMaxHealth(me) < 0.3 and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < distance then
                                                    Ability.CastTarget(spell, npc)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "abaddon_death_coil" then
                                                Ability.CastTarget(spell, target)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            elseif Ability.GetName(spell) == "abaddon_aphotic_shield" then
                                                if not NPC.HasModifier(me, "modifier_abaddon_aphotic_shield") then
                                                    Ability.CastTarget(spell, me)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "item_ethereal_blade" or Ability.GetName(spell) == "pugna_life_drain" or Ability.GetName(spell) == "furion_sprout" then
                                                if NPC.IsHero(target) and ability.findspell("pugna_decrepify", "cooldown") then
                                                    Ability.CastTarget(spell, target)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "centaur_mount" then
                                                local npc = ability.findnpc(me, "l_health_hero", 2, distance)
                                                if npc and Entity.GetHealth(npc) / Entity.GetMaxHealth(npc) < 0.35 and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < 300 then
                                                    Ability.CastTarget(spell, npc)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif Ability.GetName(spell) == "doom_bringer_doom" then
                                                if (NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed")) and not Ability.IsStolen(spell) and Entity.GetAbsOrigin(me):Distance(ability.skillshotXYZ(me, target, 900)):Length2D() < 325 and not NPC.HasModifier(target, "modifier_doom_bringer_doom") then
                                                    Ability.CastTarget(spell, me)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                elseif (Ability.IsStolen(spell) or Entity.GetAbsOrigin(me):Distance(ability.skillshotXYZ(me, target, 900)):Length2D() > 325) and not NPC.HasModifier(target, "modifier_doom_bringer_doom") then
                                                    Ability.CastTarget(spell, target)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif (Ability.GetName(spell) == "item_force_staff" or Ability.GetName(spell) == "item_hurricane_pike") then
                                            elseif Ability.GetName(spell) == "item_glimmer_cape" then
                                            elseif Ability.GetName(spell) == "dazzle_shallow_grave" or Ability.GetName(spell) == "dark_seer_surge" then
                                            elseif Ability.GetName(spell) == "bane_nightmare" then
                                            elseif Ability.GetName(spell) == "bounty_hunter_wind_walk" then
                                                -- need to fix
                                            elseif Ability.GetName(spell) == "item_flask" or Ability.GetName(spell) == "item_clarity" or Ability.GetName(spell) == "item_lotus_orb" then
                                            elseif not Ability.IsStolen(spell) and 
                                                (Ability.GetName(spell) == "oracle_false_promise" or 
                                                Ability.GetName(spell) == "weaver_time_lapse" or 
                                                Ability.GetName(spell) == "winter_wyvern_cold_embrace" or 
                                                Ability.GetName(spell) == "phoenix_supernova") then
                                            else
                                                Ability.CastTarget(spell, me)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif (Ability.GetTargetTeam(spell) & Enum.TargetTeam.DOTA_UNIT_TARGET_TEAM_FRIENDLY) == 0 then
                                            if Ability.GetName(spell) == "clinkz_searing_arrows" or Ability.GetName(spell) == "drow_ranger_frost_arrows" or Ability.GetName(spell) == "kunkka_tidebringer" or Ability.GetName(spell) == "viper_poison_attack" or Ability.GetName(spell) == "enchantress_impetus" or Ability.GetName(spell) == "enchantress_impetus" or Ability.GetName(spell) == "huskar_burning_spear" or Ability.GetName(spell) == "bounty_hunter_jinada" or Ability.GetName(spell) == "jakiro_liquid_fire" or Ability.GetName(spell) == "jakiro_liquid_ice" or Ability.GetName(spell) == "doom_bringer_infernal_blade" or Ability.GetName(spell) == "ancient_apparition_chilling_touch" or Ability.GetName(spell) == "silencer_glaives_of_wisdom" or Ability.GetName(spell) == "obsidian_destroyer_arcane_orb" or Ability.GetName(spell) == "tusk_walrus_punch" then
                                                Ability.CastTarget(spell, target)
                                                ability.sleeptime["orbwalking"], ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime(), GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + NPC.GetAttackTime(me)
                                            elseif Ability.GetName(spell) == "ancient_apparition_chilling_touch" then
                                                local bonus = {260, 320, 380, 440}
                                                if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < NPC.GetAttackRange(me) + bonus[Ability.GetLevel(spell)] then
                                                    Ability.CastTarget(spell, target)
                                                    ability.sleeptime["orbwalking"], ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime(), GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + NPC.GetAttackTime(me)
                                                end
                                            elseif Ability.GetName(spell) == "weaver_geminate_attack" then
                                                if (not NPC.HasModifier(me, "modifier_weaver_shukuchi") or ability.calling[NPC.GetUnitName(target)].name == "damaged" and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) - 90) then
                                                    Ability.CastTarget(spell, target)
                                                    ability.sleeptime["orbwalking"], ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime(), GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + NPC.GetAttackTime(me)
                                                end
                                            elseif Ability.GetName(spell) == "snapfire_gobble_up" then
                                                local npc = ability.findnpc(me, "h_health_hero", 2, 600)
                                                if npc and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < 150 then
                                                    Ability.CastTarget(spell, npc)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            elseif not NPC.HasModifier(target, "modifier_antimage_counterspell") and not NPC.HasModifier(target, "modifier_item_lotus_orb_active") then
                                                --items
                                                if Ability.GetName(spell) == "item_sheepstick" or Ability.GetName(spell) == "item_abyssal_blade" then
                                                    if NPC.IsHero(target) then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "item_bloodthorn" or Ability.GetName(spell) == "item_orchid" then
                                                    local popitem = NPC.GetItem(target, "item_black_king_bar") or NPC.GetItem(target, "item_manta")
                                                    if (not popitem or popitem and Ability.GetCooldown(popitem) > 0) and not NPC.IsSilenced(target) or Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < NPC.GetAttackRange(me) - 90 then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.35
                                                    end
                                                elseif Ability.GetName(spell) == "item_nullifier" then
                                                    if NPC.HasModifier(target, "modifier_teleporting") or NPC.HasModifier(target, "modifier_item_aeon_disk_buff") or NPC.HasModifier(target, "modifier_eul_cyclone") or NPC.HasModifier(target, "modifier_wind_waker") or NPC.HasModifier(target, "modifier_ghost_state") or NPC.HasModifier(target, "modifier_item_satanic_unholy") or (NPC.HasModifier(target, "modifier_item_armlet_unholy_strength") and Entity.GetHealth(target) < 600) or NPC.HasModifier(target, "modifier_item_ethereal_blade_ethereal") and not NPC.HasModifier(target, "modifier_item_ethereal_blade_slow") then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "item_dagon_1" or Ability.GetName(spell) == "item_dagon_2" or Ability.GetName(spell) == "item_dagon_3" or Ability.GetName(spell) == "item_dagon_4" or Ability.GetName(spell) == "item_dagon_5" then
                                                    if NPC.IsHero(target) and (not ethereal_blade or ability.imageoption[ethereal_blade] and not Menu.IsEnabled(ability.imageoption[ethereal_blade].opt) or ethereal_blade and Ability.SecondsSinceLastUse(ethereal_blade) > Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() / 1300 and Ability.SecondsSinceLastUse(ethereal_blade) < 4) then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "item_psychic_headband" then
                                                    if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < NPC.GetAttackRange(target) and NPC.GetTimeToFace(target, me) < 0.03 and NPC.IsAttacking(target) then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "item_wind_waker" or Ability.GetName(spell) == "item_cyclone" then
                                                -- need to fix
                                                --abilities
                                                elseif Ability.GetName(spell) == "windrunner_shackleshot" then
                                                    local tree, npc = ability.findtree(target, "s_tree", me, distance + 575), ability.findnpc(target, "c_hero", 2, distance + 575)
                                                    if tree or npc and Entity.GetAbsOrigin(npc):Distance(ability.skillshotXYZ(me, target, 900)):Length2D() < 575 and ability.skillshotXYZ(me, target, 900) and ability.skillshotXYZ(target, npc, 900) and (ability.skillshotXYZ(target, npc, 900):GetX() - ability.skillshotXYZ(me, target, 900):GetX()) / (Entity.GetAbsOrigin(me):GetX() - ability.skillshotXYZ(me, target, 900):GetX()) < 0 and (ability.skillshotXYZ(target, npc, 900):GetY() - ability.skillshotXYZ(me, target, 900):GetY()) / (Entity.GetAbsOrigin(me):GetY() - ability.skillshotXYZ(me, target, 900):GetY()) < 0 and math.abs((ability.skillshotXYZ(target, npc, 900):GetX() - ability.skillshotXYZ(me, target, 900):GetX()) / (Entity.GetAbsOrigin(me):GetX() - ability.skillshotXYZ(me, target, 900):GetX()) - (ability.skillshotXYZ(target, npc, 900):GetY() - ability.skillshotXYZ(me, target, 900):GetY()) / (Entity.GetAbsOrigin(me):GetY() - ability.skillshotXYZ(me, target, 900):GetY())) < 0.3 then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    elseif npc and Entity.GetAbsOrigin(npc):Distance(ability.skillshotXYZ(me, target, 900)):Length2D() < 575 and ability.skillshotXYZ(target, npc, 900) and (ability.skillshotXYZ(me, target, 900):GetX() - ability.skillshotXYZ(target, npc, 900):GetX()) / (Entity.GetAbsOrigin(me):GetX() - ability.skillshotXYZ(target, npc, 900):GetX()) < 0 and (ability.skillshotXYZ(me, target, 900):GetY() - ability.skillshotXYZ(target, npc, 900):GetY()) / (Entity.GetAbsOrigin(me):GetY() - ability.skillshotXYZ(target, npc, 900):GetY()) < 0 and math.abs((ability.skillshotXYZ(me, target, 900):GetX() - ability.skillshotXYZ(target, npc, 900):GetX()) / (Entity.GetAbsOrigin(me):GetX() - ability.skillshotXYZ(target, npc, 900):GetX()) - (ability.skillshotXYZ(me, target, 900):GetY() - ability.skillshotXYZ(target, npc, 900):GetY()) / (Entity.GetAbsOrigin(me):GetY() - ability.skillshotXYZ(target, npc, 900):GetY())) < 0.3 then
                                                        Ability.CastTarget(spell, npc)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "alchemist_unstable_concoction_throw" then
                                                    Ability.CastTarget(spell, target)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                elseif Ability.GetName(spell) == "bloodseeker_rupture" then
                                                    if not NPC.HasModifier(target, "modifier_bloodseeker_rupture") then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "antimage_mana_void" then
                                                    if Entity.GetHealth(target) + NPC.GetHealthRegen(target) < (NPC.GetMaxMana(target) - NPC.GetMana(target) + NPC.GetManaRegen(target)) * (Ability.GetLevelSpecialValueFor(spell, "mana_void_damage_per_mana") * NPC.GetMagicalArmorDamageMultiplier(target)) then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "necrolyte_reapers_scythe" then
                                                    if Entity.GetHealth(target) + NPC.GetHealthRegen(target) < (Entity.GetMaxHealth(target) - Entity.GetHealth(target) + NPC.GetHealthRegen(target)) * (1 + Ability.GetLevelSpecialValueFor(spell, "damage_per_health") * NPC.GetMagicalArmorDamageMultiplier(target)) then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "axe_culling_blade" then
                                                    if NPC.GetAbility(me, "special_bonus_unique_axe_5") and Ability.GetLevel(NPC.GetAbility(me, "special_bonus_unique_axe_5")) > 0 then damage = {400, 500, 600} else damage = {250, 350, 450} end
                                                    if Entity.GetHealth(target) + NPC.GetHealthRegen(target) < damage[Ability.GetLevel(spell)] then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "shadow_demon_demonic_purge" then
                                                    if not NPC.HasModifier(target, "modifier_shadow_demon_purge_slow") then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "rubick_telekinesis" then
                                                    if NPC.HasModifier(me, "modifier_item_aghanims_shard") then
                                                        local npc = ability.findnpc(me, "h_health_hero", 2, 3000)
                                                        if npc and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < distance and Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(npc) + 150 and Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(target)):Length2D() < throw_range and NPC.GetTimeToFace(npc, target) < 0.03 then
                                                            Ability.CastTarget(spell, npc)
                                                            ability.sleeptime[Ability.GetName(spell)], telekinesis_throw = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, true
                                                        end                                                                 
                                                    end
                                                    if not telekinesis_throw then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.39
                                                    end
                                                elseif Ability.GetName(spell) == "brewmaster_storm_cyclone" then
                                                    local npc = ability.findnpc(me, "c_hero", 0, distance)
                                                    if npc and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < distance then
                                                        Ability.CastTarget(spell, npc)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "broodmother_spawn_spiderlings" then
                                                    local npc = ability.findnpc(me, "l_health_hero", 0, distance)
                                                    if npc and Entity.GetHealth(npc) + NPC.GetHealthRegen(npc) < Ability.GetLevelSpecialValueFor(spell, "damage") * NPC.GetMagicalArmorDamageMultiplier(npc) then
                                                        Ability.CastTarget(spell, npc)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "axe_battle_hunger" then
                                                    if ability.findspell("item_blink", "cooldown") and ability.findspell("item_overwhelming_blink", "cooldown") and not NPC.HasModifier(target, "modifier_axe_battle_hunger") then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "slardar_amplify_damage" then
                                                    if not NPC.HasModifier(target, "modifier_slardar_amplify_damage") then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "nevermore_necromastery" then
                                                    if NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") then max_souls = 23 else max_souls = 18 end
                                                    if NPC.GetModifier(me, "modifier_nevermore_necromastery") and Modifier.GetStackCount(NPC.GetModifier(me, "modifier_nevermore_necromastery")) > max_souls then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "pugna_decrepify" then
                                                    Ability.CastTarget(spell, target)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                elseif Ability.GetName(spell) == "grimstroke_soul_chain" then
                                                    if #Heroes.InRadius(Entity.GetAbsOrigin(target), 600, Entity.GetTeamNum(me), 0) > 1 then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "vengefulspirit_nether_swap" then
                                                    local npc = ability.findnpc(me, "c_all", 2, distance)
                                                    if npc and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < 600 and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > 600 and Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(target)):Length2D() > 600 then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "obsidian_destroyer_arcane_orb" or Ability.GetName(spell) == "silencer_glaives_of_wisdom" then
                                                    Ability.CastTarget(spell, target)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + Ability.GetCastPoint(spell)
                                                elseif Ability.GetName(spell) == "tiny_toss_tree" then
                                                    if NPC.GetModifier(me, "modifier_tiny_tree_grab") and Modifier.GetStackCount(NPC.GetModifier(me, "modifier_tiny_tree_grab")) == 1 and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(target) + 300 then
                                                        Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 1000))
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "sniper_assassinate" then
                                                    if Ability.IsStolen(spell) or (NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed")) and Entity.GetAbsOrigin(target):Distance(Entity.GetAbsOrigin(me)):Length2D() > NPC.GetAttackRange(target) + 300 then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif not Ability.IsStolen(spell) and Ability.GetName(spell) == "lion_finger_of_death" then
                                                    if Entity.GetHealth(target) + NPC.GetHealthRegen(target) < Ability.GetLevelSpecialValueFor(spell, "damage") * NPC.GetMagicalArmorDamageMultiplier(target) then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "windrunner_focusfire" then
                                                    if Ability.IsStolen(spell) or NPC.IsStunned(target) or NPC.IsRooted(target) or NPC.HasModifier(target, "modifier_windrunner_gale_force") then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "earthshaker_enchant_totem" then
                                                    if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 100 then
                                                        Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 850))
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    else
                                                        Ability.CastTarget(spell, me)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "monkey_king_tree_dance" then
                                                    local tree = ability.findtree(target, "m_tree", me, distance)
                                                    if tree and Entity.GetAbsOrigin(me):Distance(ability.skillshotXYZ(me, target, 650)):Length2D() > NPC.GetAttackRange(me) + 300 then
                                                        Ability.CastTarget(spell, tree)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "death_prophet_spirit_siphon" then
                                                    local npc = ability.findnpc(me, "c_hero", 0, distance)
                                                    if npc and not NPC.HasModifier(npc, "modifier_death_prophet_spirit_siphon_slow") and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < distance then
                                                        Ability.CastTarget(spell, npc)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "winter_wyvern_winters_curse" then
                                                    local npc = ability.findnpc(target, "h_phys_hero", 2, distance)
                                                    if #Heroes.InRadius(ability.skillshotXYZ(me, target, 900), 525, Entity.GetTeamNum(me), 0) > 1 and npc and Entity.GetAbsOrigin(target):Distance(Entity.GetAbsOrigin(npc)):Length2D() < 525 then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "winter_wyvern_splinter_blast" then
                                                    if NPC.GetAbility(me, "special_bonus_unique_winter_wyvern_2") and Ability.GetLevel(NPC.GetAbility(me, "special_bonus_unique_winter_wyvern_2")) > 0 then search = 900 else search = 500 end 
                                                    local npc = ability.findnpc(target, "c_hero", 2, distance) or ability.findnpc(target, "c_creep", 2, distance)
                                                    if npc and Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(target)):Length2D() < search then
                                                        Ability.CastTarget(spell, npc)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "spirit_breaker_charge_of_darkness" then
                                                    Ability.CastTarget(spell, target)
                                                    ability.sleeptime["channelling"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 1
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                elseif Ability.GetName(spell) == "spirit_breaker_nether_strike" then
                                                    if not NPC.HasModifier(me, "modifier_spirit_breaker_charge_of_darkness") then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "storm_spirit_electric_vortex" and not Ability.IsStolen(spell) then
                                                    if not NPC.HasModifier(me, "modifier_storm_spirit_overload") then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "invoker_sun_strike" then
                                                    --Ability.CastTarget(spell, me)
                                                    --ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    if Ability.IsStolen(spell) or NPC.HasModifier(target, "modifier_invoker_tornado") then
                                                        Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "radius_end"), 850))
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "tusk_walrus_kick" then
                                                    local npc = ability.findnpc(me, "c_all", 2, 2000)
                                                    if npc and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < 2000 and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() > 900 and ability.findspell("tusk_walrus_punch", "cooldown") then
                                                        Ability.CastTarget(spell, target)
                                                        Player.PrepareUnitOrders(Players.GetLocal(), 30, nil, ability.skillshotXYZ(me, npc, 2000), spell, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY, me)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "riki_blink_strike" then
                                                    if Entity.GetAbsOrigin(target):Distance(Entity.GetAbsOrigin(me)):Length2D() > NPC.GetAttackRange(me) + 250 then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "abyssal_underlord_firestorm" then
                                                    Ability.CastPosition(spell, ability.skillshotAOE(me, target, Ability.GetLevelSpecialValueFor(spell, "radius"), 850))
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                elseif Ability.GetName(spell) == "juggernaut_omni_slash" and not Ability.IsStolen(spell) then
                                                    local duration, bonus_damage = {3, 3.25, 3.5}, {30, 40, 50}
                                                    if not NPC.HasModifier(me, "modifier_juggernaut_omnislash") and Entity.GetHealth(target) + NPC.GetHealthRegen(target) < (NPC.GetTrueDamage(me) + bonus_damage[Ability.GetLevel(spell)]) * NPC.GetAttacksPerSecond(me) * 2 * duration[Ability.GetLevel(spell)] * NPC.GetArmorDamageMultiplier(target) then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime["juggernaut_swift_slash"], ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + duration[Ability.GetLevel(spell)], GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "legion_commander_duel" and not Ability.IsStolen(spell) then
                                                    if Entity.GetHealth(target) + NPC.GetHealthRegen(target) < NPC.GetTrueDamage(me) * 6 * NPC.GetArmorDamageMultiplier(target) then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "tinker_warp_grenade" then
                                                    if NPC.IsHero(target) and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < NPC.GetAttackRange(target) + 75 and NPC.GetTimeToFace(target, me) < 0.03 and NPC.IsAttacking(target) then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "morphling_adaptive_strike_agi" then
                                                    if Hero.GetAgility(me) > (Hero.GetAgility(me) + Hero.GetStrength(me) - 2) / 2 then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "morphling_adaptive_strike_str" then
                                                    if Hero.GetStrength(me) > (Hero.GetAgility(me) + Hero.GetStrength(me) - 2) / 2 then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "visage_soul_assumption" then
                                                    if NPC.GetModifier(me, "modifier_visage_soul_assumption") and Modifier.GetStackCount(NPC.GetModifier(me, "modifier_visage_soul_assumption")) == 6 then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "enigma_malefice" then
                                                    if ability.findspell("enigma_black_hole", "cooldown") then
                                                        Ability.CastTarget(spell, target)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "antimage_mana_overload" then
                                                    -- need to fix
                                                elseif Ability.GetName(spell) == "warlock_upheaval" and NPC.HasModifier(me, "modifier_item_aghanims_shard") then
                                                    if ability.findspell("warlock_fatal_bonds", "cooldown") and ability.findspell("warlock_shadow_word", "cooldown") and ability.findspell("warlock_rain_of_chaos", "cooldown") then
                                                        Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 950))
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "razor_static_link" then
                                                    local npc = ability.findnpc(me, "h_phys_hero", 0, 3000)
                                                    if npc and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(npc)):Length2D() < distance then
                                                        Ability.CastTarget(spell, npc)
                                                        ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                    end
                                                elseif Ability.GetName(spell) == "hoodwink_acorn_shot" or Ability.GetName(spell) == "witch_doctor_paralyzing_cask" then
                                                    local npc = ability.findnpc(target, "c_hero", 2, distance) or ability.findnpc(target, "c_creep", 2, distance)
                                                    if npc and ability.skillshotXYZ(me, target, 900):Distance(ability.skillshotXYZ(me, npc, 900)):Length2D() < 350 then
                                                        if NPC.IsLinkensProtected(target) then
                                                            Ability.CastTarget(spell, npc)
                                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.35
                                                        else
                                                            Ability.CastTarget(spell, target)
                                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.35
                                                        end
                                                    end
                                                elseif Ability.GetName(spell) == "clinkz_death_pact" then
                                                elseif Ability.GetName(spell) == "lion_mana_drain" then
                                                elseif Ability.GetName(spell) == "bounty_hunter_track" then
                                                elseif Ability.GetName(spell) == "earth_spirit_petrify" then
                                                elseif Ability.GetName(spell) == "morphling_replicate" then
                                                elseif Ability.GetName(spell) == "life_stealer_infest" then
                                                elseif Ability.GetName(spell) == "disruptor_glimpse" then
                                                else
                                                    Ability.CastTarget(spell, target)
                                                    if Ability.GetName(spell) == "bane_fiends_grip" or Ability.GetName(spell) == "lion_mana_drain" or Ability.GetName(spell) == "pudge_dismember" or Ability.GetName(spell) == "shadow_shaman_shackles" or Ability.GetName(spell) == "lich_sinister_gaze" or Ability.GetName(spell) == "pugna_life_drain" or Ability.GetName(spell) == "primal_beast_pulverize" then ability.sleeptime["channelling"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 1 end
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            end
                                        end
                                    elseif (Ability.GetBehavior(spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_TOGGLE) ~= 0 then
                                        local spirit = ability.findnpc(me, "spirit", 2, distance)
                                        if Ability.GetName(spell) == "wisp_spirits_in" then                    
                                            if spirit and not Ability.GetToggleState(spell) and Entity.GetAbsOrigin(spirit):Distance(Entity.GetAbsOrigin(me)):Length2D() < 650 and Entity.GetAbsOrigin(spirit):Distance(ability.skillshotXYZ(me, target, 950)):Length2D() > 60 and Entity.GetAbsOrigin(me):Distance(ability.skillshotXYZ(me, target, 950)):Length2D() < 325 then
                                                Ability.Toggle(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 1
                                            end
                                        elseif Ability.GetName(spell) == "wisp_spirits_out" then
                                            if spirit and not Ability.GetToggleState(spell) and Entity.GetAbsOrigin(spirit):Distance(Entity.GetAbsOrigin(me)):Length2D() < 325 and Entity.GetAbsOrigin(spirit):Distance(ability.skillshotXYZ(me, target, 950)):Length2D() > 60 and Entity.GetAbsOrigin(me):Distance(ability.skillshotXYZ(me, target, 950)):Length2D() > 325 then
                                                Ability.Toggle(spell)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 1
                                            end
                                        end
                                    elseif (Ability.GetBehavior(spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_POINT) ~= 0 then
                                        if Ability.GetName(spell) == "pugna_nether_ward" then
                                            Ability.CastPosition(spell, Entity.GetAbsOrigin(me))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "windrunner_gale_force" then
                                            if ability.findspell("windrunner_shackleshot", "cooldown") and Entity.GetAbsOrigin(target):Distance(Entity.GetAbsOrigin(me)):Length2D() > NPC.GetAttackRange(me) + 250 then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 950))
                                                Player.PrepareUnitOrders(Players.GetLocal(), 30, nil, Entity.GetAbsOrigin(me), spell, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY, me)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "shredder_timber_chain" then
                                            if NPC.GetAbility(me, "special_bonus_unique_timbersaw_3") and Ability.GetLevel(NPC.GetAbility(me, "special_bonus_unique_timbersaw_3")) > 0 then chain_range = Ability.GetLevelSpecialValueFor(spell, "range") + 1125 else chain_range = Ability.GetLevelSpecialValueFor(spell, "range") end
                                            local tree = ability.findtree(target, "t_tree", me, chain_range)
                                            if tree and not NPC.HasModifier(me, "modifier_shredder_flamethrower") then
                                                Ability.CastPosition(spell, Entity.GetAbsOrigin(tree))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "juggernaut_healing_ward" then
                                            -- need to fix
                                        elseif Ability.GetName(spell) == "void_spirit_aether_remnant" or Ability.GetName(spell) == "pangolier_swashbuckle" or Ability.GetName(spell) == "clinkz_burning_army" or Ability.GetName(spell) == "gyrocopter_call_down" and NPC.GetAbility(me, "special_bonus_unique_gyrocopter_5") and Ability.GetLevel(NPC.GetAbility(me, "special_bonus_unique_gyrocopter_5")) > 0 then
                                            if not NPC.HasModifier(me, "modifier_pangolier_gyroshell") then
                                                if not NPC.IsRunning(target) then
                                                    Player.PrepareUnitOrders(Players.GetLocal(), 30, nil, Entity.GetAbsOrigin(target), spell, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY, me)
                                                    Ability.CastPosition(spell, Entity.GetAbsOrigin(me) + ((Entity.GetAbsOrigin(target) - Entity.GetAbsOrigin(me)):Normalized():Scaled(Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() - 300)))
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                else
                                                    Player.PrepareUnitOrders(Players.GetLocal(), 30, nil, ability.skillshotXYZ(me, target, 800), spell, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY, me)
                                                    Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 900))
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            end
                                        elseif Ability.GetName(spell) == "broodmother_sticky_snare" then
                                            if Ability.GetCurrentCharges(spell) > 0 and (NPC.HasModifier(target, "modifier_broodmother_silken_bola") or NPC.IsStunned(target) or NPC.IsRooted(target)) then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 800))
                                                Player.PrepareUnitOrders(Players.GetLocal(), 30, nil, ability.skillshotXYZ(me, target, 2000) + Entity.GetRotation(target):GetForward():Normalized():Scaled(distance):Rotated(Angle(0,45,0)), spell, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY, me)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 4
                                            end
                                        elseif Ability.GetName(spell) == "phoenix_launch_fire_spirit" then
                                            Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 800))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 3.5
                                        elseif Ability.GetName(spell) == "phoenix_sun_ray" then
                                            if ability.skillshotXYZ(me, target, 900):Distance(Entity.GetAbsOrigin(me)):Length2D() > NPC.GetAttackRange(target) + 300 then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 900))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "sniper_shrapnel" then
                                            if Ability.GetCurrentCharges(spell) > 0 and not NPC.HasModifier(target, "modifier_sniper_shrapnel_slow") and (not ability.cast_pos["sniper_shrapnel"] or ability.cast_pos["sniper_shrapnel"] and ability.cast_pos["sniper_shrapnel"].pos:Distance(Entity.GetAbsOrigin(target)):Length2D() > 450) then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 650))
                                                ability.cast_pos["sniper_shrapnel"], ability.sleeptime[Ability.GetName(spell)] = {pos = ability.skillshotXYZ(me, target, 900), time = GameRules.GetGameTime() + 10}, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "void_spirit_astral_step" then
                                            if Ability.IsStolen(spell) or ability.skillshotXYZ(me, target, 950):Distance(Entity.GetAbsOrigin(me)):Length2D() > NPC.GetAttackRange(me) + 300 and Ability.GetCurrentCharges(spell) > 0 then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 1600) + (ability.skillshotXYZ(me, target, 1600) - Entity.GetAbsOrigin(me)):Normalized():Scaled(300))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.3
                                            end
                                        elseif Ability.GetName(spell) == "primal_beast_rock_throw" then
                                            if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > 550 then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 800))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "primal_beast_onslaught" then
                                            if ability.findspell("primal_beast_rock_throw", "cooldown") then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 1000))
                                                ability.sleeptime["primal_beast_onslaught_release"], ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() / 600, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "antimage_blink" or Ability.GetName(spell) == "queenofpain_blink" or Ability.GetName(spell) == "faceless_void_time_walk" or Ability.GetName(spell) == "windrunner_powershot" and not Ability.IsStolen(spell) then
                                            if ability.skillshotXYZ(me, target, 950):Distance(Entity.GetAbsOrigin(me)):Length2D() > NPC.GetAttackRange(me) + 300 or Ability.GetName(spell) == "faceless_void_time_walk" and (NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed")) then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 1000))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "magnataur_skewer" then
                                            local npc = ability.findnpc(me, "c_all", 2, 2000)
                                            if npc and (Entity.GetAbsOrigin(me):GetX() - ability.skillshotXYZ(me, target, 950):GetX()) / (Entity.GetAbsOrigin(npc):GetX() - ability.skillshotXYZ(me, target, 950):GetX()) < 0 and (Entity.GetAbsOrigin(me):GetY() - ability.skillshotXYZ(me, target, 950):GetY()) / (Entity.GetAbsOrigin(npc):GetY() - ability.skillshotXYZ(me, target, 950):GetY()) < 0 and math.abs((Entity.GetAbsOrigin(me):GetX() - ability.skillshotXYZ(me, target, 950):GetX()) / (Entity.GetAbsOrigin(npc):GetX() - ability.skillshotXYZ(me, target, 950):GetX()) - (Entity.GetAbsOrigin(me):GetY() - ability.skillshotXYZ(me, target, 950):GetY()) / (Entity.GetAbsOrigin(npc):GetY() - ability.skillshotXYZ(me, target, 950):GetY())) < 0.3 then
                                                Ability.CastPosition(spell, Entity.GetAbsOrigin(npc))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "hoodwink_bushwhack" then
                                            if NPC.GetAbility(me, "special_bonus_unique_hoodwink_bushwhack_radius") and Ability.GetLevel(NPC.GetAbility(me, "special_bonus_unique_hoodwink_bushwhack_radius")) > 0 then hoodwink_bushwhack_radius = 400 else hoodwink_bushwhack_radius = 265 end
                                            local tree = ability.findtree(target, "h_tree", me, distance + hoodwink_bushwhack_radius)
                                            if tree and Entity.GetAbsOrigin(tree):Distance(ability.skillshotXYZ(me, target, 900)):Length2D() < hoodwink_bushwhack_radius then
                                                Ability.CastPosition(spell, Entity.GetAbsOrigin(tree) + ((ability.skillshotXYZ(me, target, 900) - Entity.GetAbsOrigin(tree)):Normalized():Scaled(hoodwink_bushwhack_radius - math.random(3, 60))))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "morphling_waveform" then
                                            if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 100 then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 750) + (ability.skillshotXYZ(me, target, 750) - Entity.GetAbsOrigin(me)):Normalized():Scaled(300))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() / 900
                                            end
                                        elseif Ability.GetName(spell) == "hoodwink_sharpshooter" then
                                            if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 300 and Entity.GetHealth(target) + NPC.GetHealthRegen(target) < Ability.GetLevelSpecialValueFor(spell, "max_damage") * NPC.GetMagicalArmorDamageMultiplier(target) then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 950))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "tusk_ice_shards" then
                                            if NPC.GetTimeToFace(target, me) > 0.06 then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 750) + (ability.skillshotXYZ(me, target, 750) - Entity.GetAbsOrigin(me)):Normalized():Scaled(300))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "sandking_burrowstrike" then
                                            Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 750) + (ability.skillshotXYZ(me, target, 750) - Entity.GetAbsOrigin(me)):Normalized():Scaled(300))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        -- aoe cast
                                        elseif Ability.GetName(spell) == "terrorblade_reflection" then
                                            Ability.CastPosition(spell, ability.skillshotAOE(me, target, 900, 900))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "puck_dream_coil" then
                                            if #Heroes.InRadius(ability.skillshotXYZ(me, target, 900), 562, Entity.GetTeamNum(me), 0) > 1 then
                                                Ability.CastPosition(spell, ability.skillshotAOE(me, target, 562, 900))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "warlock_rain_of_chaos" then
                                            Ability.CastPosition(spell, ability.skillshotAOE(me, target, 900, 900))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "kunkka_ghostship" then
                                            if NPC.HasModifier(target, "modifier_kunkka_x_marks_the_spot") or NPC.IsStunned(target) or NPC.IsRooted(target) then
                                                if ability.cast_pos["kunkka_x_marks_the_spot"] then
                                                    Ability.CastPosition(spell, ability.cast_pos["kunkka_x_marks_the_spot"].pos)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                else
                                                    Ability.CastPosition(spell, ability.skillshotAOE(me, target, 637.5, 850))
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            end
                                        elseif Ability.GetName(spell) == "invoker_emp" then
                                            Ability.CastPosition(spell, ability.skillshotAOE(me, target, 1425, 850))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "silencer_last_word" then
                                            Ability.CastPosition(spell, ability.skillshotAOE(me, target, 750, 900))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "dark_willow_terrorize" then
                                            if #Heroes.InRadius(ability.skillshotXYZ(me, target, 600), 600, Entity.GetTeamNum(me), 0) > 1 then
                                                Ability.CastPosition(spell, ability.skillshotAOE(me, target, 600, 850))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "keeper_of_the_light_will_o_wisp" or Ability.GetName(spell) == "brewmaster_cinder_brew" or Ability.GetName(spell) == "dark_seer_vacuum" or Ability.GetName(spell) == "crystal_maiden_crystal_nova" or Ability.GetName(spell) == "tiny_avalanche" or Ability.GetName(spell) == "silencer_curse_of_the_silent" or Ability.GetName(spell) == "enigma_midnight_pulse" or Ability.GetName(spell) == "alchemist_acid_spray" or Ability.GetName(spell) == "ember_spirit_sleight_of_fist" or Ability.GetName(spell) == "death_prophet_silence" or Ability.GetName(spell) == "pugna_nether_blast" or Ability.GetName(spell) == "gyrocopter_call_down" or Ability.GetName(spell) == "abyssal_underlord_firestorm" or Ability.GetName(spell) == "abyssal_underlord_pit_of_malice" or Ability.GetName(spell) == "undying_decay" or Ability.GetName(spell) == "riki_smoke_screen" then
                                            if ability.findspell("ember_spirit_searing_chains", "ready") then
                                                if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < Ability.GetCastRange(spell) then
                                                    Ability.CastPosition(spell, ability.skillshotAOE(me, target, Ability.GetLevelSpecialValueFor(spell, "radius"), 900))
                                                    ability.sleeptime[Ability.GetName(spell)], ability.sleeptime["ember_spirit_flame_guard"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 2
                                                else
                                                    Ability.CastPosition(spell, Entity.GetAbsOrigin(me) + ((ability.skillshotXYZ(me, target, 900) - Entity.GetAbsOrigin(me)):Normalized():Scaled(Ability.GetCastRange(spell))))
                                                    ability.sleeptime[Ability.GetName(spell)], ability.sleeptime["ember_spirit_flame_guard"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 2
                                                end
                                            end
                                        elseif Ability.GetName(spell) == "enigma_black_hole" then
                                            if Ability.IsStolen(spell) or ability.findspell("enigma_midnight_pulse", "cooldown") then
                                                if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < Ability.GetCastRange(spell) then
                                                    Ability.CastPosition(spell, ability.skillshotAOE(me, target, Ability.GetLevelSpecialValueFor(spell, "radius"), 900))
                                                    ability.sleeptime["channelling"], ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 1, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                else
                                                    Ability.CastPosition(spell, Entity.GetAbsOrigin(me) + ((ability.skillshotXYZ(me, target, 900) - Entity.GetAbsOrigin(me)):Normalized():Scaled(Ability.GetCastRange(spell))))
                                                    if Ability.GetName(spell) == "enigma_black_hole" then ability.sleeptime["channelling"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 1 end
                                                    ability.sleeptime["channelling"], ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 1, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            end
                                        elseif Ability.GetName(spell) == "obsidian_destroyer_sanity_eclipse" then
                                            if Ability.IsStolen(spell) or ability1 and Ability.GetName(ability1) == "obsidian_destroyer_astral_imprisonment" and (Ability.GetCooldown(ability1) > 0 or (NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed")) and Ability.GetCurrentCharges(ability1) == 0) and NPC.GetModifier(me, "modifier_obsidian_destroyer_equilibrium_buff_counter") and Modifier.GetStackCount(NPC.GetModifier(me, "modifier_obsidian_destroyer_equilibrium_buff_counter")) > 1000 then
                                                Ability.CastPosition(spell, ability.skillshotAOE(me, target, Ability.GetLevelSpecialValueFor(spell, "radius"), 900))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5 
                                            end
                                        elseif Ability.GetName(spell) == "monkey_king_wukongs_command" then
                                            if NPC.GetAbility(me, "special_bonus_unique_monkey_king_4") and Ability.GetLevel(NPC.GetAbility(me, "special_bonus_unique_monkey_king_4")) > 0 then wukongs_radius = 1130 else wukongs_radius = 750 end
                                            if #Heroes.InRadius(ability.skillshotXYZ(me, target, 900), wukongs_radius, Entity.GetTeamNum(me), 0) > 1 and not NPC.HasModifier(me, "modifier_monkey_king_bounce_leap") then
                                                Ability.CastPosition(spell, ability.skillshotAOE(me, target, wukongs_radius * 1.5, 900))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "dark_willow_bramble_maze" then
                                            Ability.CastPosition(spell, ability.skillshotAOE(me, target, 500, 850))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "faceless_void_chronosphere" then
                                            if NPC.GetAbility(me, "special_bonus_unique_faceless_void_2") and Ability.GetLevel(NPC.GetAbility(me, "special_bonus_unique_faceless_void_2")) > 0 then search_radius = Ability.GetLevelSpecialValueFor(spell, "radius") + 140 else search_radius = Ability.GetLevelSpecialValueFor(spell, "radius") end
                                            if #Heroes.InRadius(ability.skillshotXYZ(me, target, search_radius), search_radius, Entity.GetTeamNum(me), 0) > 1 then
                                                Ability.CastPosition(spell, ability.skillshotAOE(me, target, search_radius, 900))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "earth_spirit_rolling_boulder" then
                                            if ability.findspell("earth_spirit_geomagnetic_grip", "cooldown") then
                                                Ability.CastPosition(spell, ability.skillshotFront(me, target, 1800, 900))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "earth_spirit_stone_caller" then
                                            if NPC.GetModifier(target, "modifier_earth_spirit_magnetize") and Modifier.GetDieTime(NPC.GetModifier(target, "modifier_earth_spirit_magnetize")) > 0 and Modifier.GetDieTime(NPC.GetModifier(target, "modifier_earth_spirit_magnetize")) - GameRules.GetGameTime() < 0.7 then
                                                Ability.CastPosition(spell, ability.skillshotAOE(me, target, 675, 900))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 4
                                            end
                                            if ability.findspell("earth_spirit_boulder_smash", "ready") and ability.findspell("earth_spirit_geomagnetic_grip", "ready") and Entity.GetAbsOrigin(me):Distance(ability.skillshotXYZ(me, target, 950)):Length2D() > NPC.GetAttackRange(me) + 100 then
                                                Ability.CastPosition(spell, Entity.GetAbsOrigin(me) + ((ability.skillshotXYZ(me, target, 950) - Entity.GetAbsOrigin(me)):Normalized():Scaled(200)))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 4
                                            end
                                        elseif Ability.GetName(spell) == "lich_sinister_gaze" and (NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed")) then
                                            Ability.CastPosition(spell, ability.skillshotAOE(me, target, 400, 900))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "lina_light_strike_array" or Ability.GetName(spell) == "leshrac_split_earth" then
                                            if ability.findspell("leshrac_lightning_storm", "cooldown") then
                                                Ability.CastPosition(spell, ability.skillshotAOE(me, target, Ability.GetLevelSpecialValueFor(spell, "light_strike_array_aoe"), 700))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        -- aoe cast2
                                        elseif Ability.GetName(spell) == "earthshaker_fissure" then
                                            Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "fissure_radius"), 800))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "drow_ranger_wave_of_silence" then
                                            if Entity.GetAbsOrigin(me):Distance(ability.skillshotXYZ(me, target, 950)):Length2D() < NPC.GetAttackRange(target) + 100 and NPC.GetTimeToFace(target, me) < 0.03 then
                                                Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "wave_width"), 900))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "queenofpain_sonic_wave" then
                                            Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "final_aoe"), 850))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "drow_ranger_multishot" then
                                            Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "arrow_width") * 4, 850))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "vengefulspirit_wave_of_terror" then
                                            Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "wave_width"), 850))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "lina_dragon_slave" then
                                            Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "dragon_slave_width_initial"), 850))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "death_prophet_carrion_swarm" or Ability.GetName(spell) == "dragon_knight_breathe_fire" then
                                            Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "end_radius"), 850))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "weaver_the_swarm" then
                                            if ability.findspell("weaver_shukuchi", "ready") and not NPC.HasModifier(me, "modifier_weaver_shukuchi") then
                                                Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "spawn_radius"), 850))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "invoker_tornado" then
                                            Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "area_of_effect"), 850))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "invoker_deafening_blast" or Ability.GetName(spell) == "invoker_chaos_meteor" then
                                            if Ability.IsStolen(spell) or NPC.HasModifier(target, "modifier_invoker_tornado") or ability.findspell("invoker_tornado", "lastuse3") or NPC.GetAbility(me, "invoker_tornado") and Ability.IsHidden(NPC.GetAbility(me, "invoker_tornado")) then
                                                Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "radius_end"), 850))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "invoker_sun_strike" then
                                            if Ability.IsStolen(spell) or NPC.HasModifier(target, "modifier_invoker_tornado") then
                                                Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "radius_end"), 850))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "monkey_king_boundless_strike" and not Ability.IsStolen(spell) then
                                            if NPC.HasModifier(me, "modifier_monkey_king_quadruple_tap_bonuses") or Ability.GetAutoCastState(spell) then
                                                Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "strike_crit_mult"), 850))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "lion_impale" then
                                            Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "width"), 850))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "treant_natures_grasp" then
                                            Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "vine_spawn_interval"), 850))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "jakiro_dual_breath" then
                                            Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "end_radius"), 850))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "jakiro_ice_path" then
                                            Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "path_radius"), 850))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "nyx_assassin_impale" then
                                            Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "width"), 900))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "elder_titan_earth_splitter" then
                                            if NPC.HasModifier(target, "modifier_elder_titan_echo_stomp") then
                                                Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "crack_width"), 800))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "magnataur_shockwave" then
                                            if NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") then
                                                Ability.CastPosition(spell, ability.skillshotFront(me, target, 1800, 900))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            else
                                                Ability.CastPosition(spell, ability.skillshotFront(me, target, Ability.GetLevelSpecialValueFor(spell, "shock_width"), 900))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "rubick_telekinesis_land" then
                                            local npc = ability.findnpc(me, "c_hero", 0, distance + throw_range)
                                            if npc and Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(target)):Length2D() < throw_range and not Ability.IsHidden(spell) then
                                                if not ability.cast_pos["rubick_telekinesis"] or ability.cast_pos["rubick_telekinesis"] and ability.cast_pos["rubick_telekinesis"].pos and Entity.GetAbsOrigin(npc):Distance(ability.cast_pos["rubick_telekinesis"].pos):Length2D() > 150 then
                                                    Ability.CastPosition(spell, ability.skillshotXYZ(me, npc, 1800))
                                                    ability.cast_pos["rubick_telekinesis"], ability.sleeptime[Ability.GetName(spell)] = {pos = Entity.GetAbsOrigin(npc), time = GameRules.GetGameTime() + 1.2}, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            end
                                        elseif Ability.GetName(spell) == "shredder_chakram" then
                                            Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 700))
                                            ability.sleeptime["shredder_return_chakram"], ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() / 350, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "shredder_chakram_2" then
                                            Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 700))
                                            ability.sleeptime["shredder_return_chakram_2"], ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() / 350, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "ancient_apparition_ice_blast" then
                                            Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 1000))
                                            ability.sleeptime["ancient_apparition_ice_blast_release"], ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() / 1300, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "kunkka_torrent" then
                                            if NPC.HasModifier(target, "modifier_kunkka_x_marks_the_spot") or NPC.IsStunned(target) or NPC.IsRooted(target) then
                                                if ability.cast_pos["kunkka_x_marks_the_spot"] then
                                                    Ability.CastPosition(spell, ability.cast_pos["kunkka_x_marks_the_spot"].pos)
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                else
                                                    Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 1000))
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            end
                                        elseif Ability.GetName(spell) == "broodmother_spin_web" then
                                            if not NPC.HasModifier(me, "modifier_broodmother_spin_web") then
                                                local web = NPCs.InRadius(Entity.GetAbsOrigin(me) + Entity.GetRotation(me):GetForward():Normalized():Scaled(500), 3000, Entity.GetTeamNum(me), 2)
                                                if web[1] and NPC.GetUnitName(web[1]) == "npc_dota_broodmother_web" and Entity.GetAbsOrigin(web[1]):Distance(Entity.GetAbsOrigin(me) + Entity.GetRotation(me):GetForward():Normalized():Scaled(500)):Length2D() > 900 then
                                                    Ability.CastPosition(spell, Entity.GetAbsOrigin(me) + Entity.GetRotation(me):GetForward():Normalized():Scaled(500))
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 1
                                                else
                                                    Ability.CastPosition(spell, Entity.GetAbsOrigin(me) + Entity.GetRotation(me):GetForward():Normalized():Scaled(500))
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 1
                                                end
                                            end
                                        elseif Ability.GetName(spell) == "storm_spirit_ball_lightning" then
                                            if not NPC.HasModifier(me, "modifier_storm_spirit_ball_lightning") and (Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 110 or NPC.GetMana(me) / NPC.GetMaxMana(me) > 0.5 and not NPC.HasModifier(me, "modifier_storm_spirit_overload")) and ability.findspell("item_blink", "cooldown") and ability.findspell("item_arcane_blink", "cooldown") then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 1500))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "meepo_earthbind" then
                                            Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 800))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 2
                                        elseif Ability.GetName(spell) == "snapfire_mortimer_kisses" then
                                            if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 350 then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 950))
                                                ability.sleeptime["channelling"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 1
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "mars_spear" then
                                            local ent = ability.findnpc(target, "s_mars", 0, distance - 600) or ability.findtree(target, "t_tree", me, distance - 600)
                                            if ent and ability.findspell("mars_arena_of_blood", "cooldown") then
                                                Ability.CastPosition(spell, Entity.GetAbsOrigin(ent))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            elseif ability5 and Ability.SecondsSinceLastUse(ability5) > 0 and Ability.SecondsSinceLastUse(ability5) < 2 then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 2000))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "mars_arena_of_blood" then
                                            Ability.CastPosition(spell, Entity.GetAbsOrigin(me) + ((ability.skillshotXYZ(me, target, 900) - Entity.GetAbsOrigin(me)):Normalized():Scaled(Ability.GetCastRange(spell))))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "lion_voodoo" then
                                            Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 2000))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "ember_spirit_fire_remnant" then
                                            if Ability.IsStolen(spell) or NPC.HasModifier(me, "modifier_ember_spirit_sleight_of_fist_caster") and ability.findspell("ember_spirit_searing_chains", "cooldown") then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 900))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "ember_spirit_activate_fire_remnant" then
                                            local remnant = ability.findnpc(target, "remnant", 0, distance)
                                            if remnant and Entity.GetAbsOrigin(target):Distance(Entity.GetAbsOrigin(remnant)):Length2D() < 450 and (not Ability.IsStolen(spell)) or Ability.IsStolen(spell) and ability.findspell("ember_spirit_fire_remnant", "nocharge") then
                                                Ability.CastPosition(spell, Entity.GetAbsOrigin(remnant))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "sniper_concussive_grenade" or Ability.GetName(spell) == "phantom_lancer_doppelwalk" or Ability.GetName(spell) == "keeper_of_the_light_blinding_light" then
                                            if Entity.GetAbsOrigin(me):Distance(ability.skillshotXYZ(me, target, 950)):Length2D() < NPC.GetAttackRange(target) + 100 and NPC.GetTimeToFace(target, me) < 0.03 then
                                                Ability.CastPosition(spell, Entity.GetAbsOrigin(me) + ((ability.skillshotXYZ(me, target, 950) - Entity.GetAbsOrigin(me)):Normalized():Scaled(Entity.GetAbsOrigin(me):Distance(ability.skillshotXYZ(me, target, 950)):Length2D() / 2)))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "spectre_reality" then
                                            -- need to fix
                                        elseif Ability.GetName(spell) == "kunkka_tidal_wave" then
                                            -- need to fix
                                        elseif Ability.GetName(spell) == "techies_sticky_bomb" then
                                            Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 1100))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "techies_suicide" then
                                            if NPC.GetModifier(target, "modifier_techies_sticky_bomb_slow") or NPC.GetModifier(me, "modifier_techies_reactive_tazer") and Modifier.GetDieTime(NPC.GetModifier(me, "modifier_techies_reactive_tazer")) > 0 and Modifier.GetDieTime(NPC.GetModifier(me, "modifier_techies_reactive_tazer")) - GameRules.GetGameTime() < 2 then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 900))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "techies_land_mines" then
                                            if not NPC.IsRunning(target) then angle = {90, 270} else angle = {40, 320} end
                                            local mine = ability.findnpc(target, "mine", 0, distance)
                                            if not planted and (not mine or Entity.GetAbsOrigin(mine):Distance(ability.skillshotXYZ(me, target, 900) + Entity.GetRotation(target):GetForward():Normalized():Scaled(255):Rotated(Angle(0, angle[1], 0))):Length2D() > 255) then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 900) + Entity.GetRotation(target):GetForward():Normalized():Scaled(255):Rotated(Angle(0, angle[1], 0)))
                                                ability.sleeptime[Ability.GetName(spell)], planted = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, true
                                            elseif planted and (not mine or Entity.GetAbsOrigin(mine):Distance(ability.skillshotXYZ(me, target, 900) + Entity.GetRotation(target):GetForward():Normalized():Scaled(255):Rotated(Angle(0, angle[2], 0))):Length2D() > 255) then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 900) + Entity.GetRotation(target):GetForward():Normalized():Scaled(255):Rotated(Angle(0, angle[2], 0)))
                                                ability.sleeptime[Ability.GetName(spell)], planted = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5, false
                                            end
                                        elseif Ability.GetName(spell) == "arc_warden_magnetic_field" then
                                            if not NPC.HasModifier(me, "modifier_arc_warden_magnetic_field_evasion") then
                                                Ability.CastPosition(spell, Entity.GetAbsOrigin(me))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + Ability.GetLevelSpecialValueFor(spell, "duration")
                                            end
                                        elseif Ability.GetName(spell) == "arc_warden_spark_wraith" then
                                            Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 600))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "tiny_tree_channel" then
                                            if #Trees.InRadius(Entity.GetAbsOrigin(me), 525, true) > 2 then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 950))
                                            end
                                        elseif Ability.GetName(spell) == "pudge_meat_hook" or Ability.GetName(spell) == "rattletrap_hookshot" or Ability.GetName(spell) == "mirana_arrow" then
                                            if not ability.checkspellblocked(me, Entity.GetAbsOrigin(me), ability.skillshotXYZ(me, target, 2100), target, spell) and (Ability.GetName(spell) == "pudge_meat_hook" or Ability.GetName(spell) == "rattletrap_hookshot" or Ability.GetName(spell) == "mirana_arrow") then
                                                if Ability.GetName(spell) == "rattletrap_hookshot" then
                                                    Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 2100))
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                elseif Ability.GetName(spell) == "mirana_arrow" then
                                                    Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 650))
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                else
                                                    Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 950))
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            end
                                        elseif Ability.GetName(spell) == "monkey_king_primal_spring" then
                                            if Ability.IsActivated(spell) and NPC.HasModifier(me, "modifier_monkey_king_bounce_leap") then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 650))
                                                ability.cast_pos[Ability.GetName(spell)], ability.sleeptime["channelling"], ability.sleeptime[Ability.GetName(spell)] = {pos = ability.skillshotXYZ(me, target, 600), time = GameRules.GetGameTime() + 3}, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 1.6, GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "templar_assassin_psionic_trap" then
                                            if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(me) + 100 then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 900))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "ancient_apparition_ice_vortex" then
                                            if not NPC.HasModifier(target, "modifier_ice_vortex") then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 900))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "disruptor_kinetic_field" then
                                            if not ability.cast_pos["disruptor_glimpse"] then
                                                if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < distance then
                                                    Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 800))
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            else
                                                Ability.CastPosition(spell, ability.cast_pos["disruptor_glimpse"].pos)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "disruptor_static_storm" then
                                            if not ability.cast_pos["disruptor_glimpse"] then
                                                if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < distance then
                                                    Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 800))
                                                    ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                                end
                                            else
                                                Ability.CastPosition(spell, ability.cast_pos["disruptor_glimpse"].pos)
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "legion_commander_overwhelming_odds" then
                                            if ability.findspell("item_blink", "cooldown") and ability.findspell("item_overwhelming_blink", "cooldown") then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 900))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "puck_illusory_orb" then
                                            Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 600))
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        elseif Ability.GetName(spell) == "skywrath_mage_mystic_flare" then
                                            if ability.findspell("skywrath_mage_ancient_seal", "cooldown") and ability.findspell("item_ethereal_blade", "cooldown") and ability.findspell("item_sheepstick", "cooldown") then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 1100))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "witch_doctor_death_ward" then
                                            if ability.findspell("witch_doctor_paralyzing_cask", "cooldown") then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 900))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "item_seer_stone" then
                                            if NPC.IsHero(target) and not FogOfWar.IsPointVisible(Entity.GetAbsOrigin(target) + Entity.GetRotation(target):GetForward():Normalized():Scaled(320)) then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 900))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "clinkz_strafe" then
                                            if ability.findspell("item_sheepstick", "cooldown") and ability.findspell("item_gungir", "lastuse" .. Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() / 1900 .. "") and ability.findspell("item_rod_of_atos", "lastuse" .. Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() / 1900 .. "") then
                                                Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 900))
                                                ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                            end
                                        elseif Ability.GetName(spell) == "item_blink" or Ability.GetName(spell) == "item_overwhelming_blink" or Ability.GetName(spell) == "item_swift_blink" or Ability.GetName(spell) == "item_arcane_blink" then
                                        elseif Ability.GetName(spell) == "templar_assassin_trap_teleport" then
                                        elseif Ability.GetName(spell) == "slark_depth_shroud" then
                                        elseif Ability.GetName(spell) == "tinker_keen_teleport" then
                                        else
                                            Ability.CastPosition(spell, ability.skillshotXYZ(me, target, 950))
                                            if Ability.GetName(spell) == "tiny_tree_channel" or Ability.GetName(spell) == "crystal_maiden_freezing_field" or Ability.GetName(spell) == "windrunner_powershot" or Ability.GetName(spell) == "witch_doctor_death_ward" or Ability.GetName(spell) == "riki_tricks_of_the_trade" or Ability.GetName(spell) == "warlock_upheaval" or Ability.GetName(spell) == "keeper_of_the_light_illuminate" or Ability.GetName(spell) == "monkey_king_primal_spring" or Ability.GetName(spell) == "dawnbreaker_solar_guardian" or Ability.GetName(spell) == "templar_assassin_trap_teleport" then ability.sleeptime["channelling"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 1 end
                                            ability.sleeptime[Ability.GetName(spell)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 0.5
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function ability.findtarget(npc)
    for _, unit in ipairs(Entity.GetUnitsInRadius(npc, 99999, 0, true)) do
        if unit and NPC.IsHero(unit) and Entity.IsAlive(unit) and not Entity.IsDormant(unit) and not NPC.IsIllusion(unit) and Input.GetWorldCursorPos():Distance(Entity.GetAbsOrigin(unit)):Length2D() < 900 then ability.calling["targeted"] = {ent = unit, time = GameRules.GetGameTime() + 0.5} end
        if unit and (NPC.IsHero(unit) and not NPC.IsIllusion(unit) or NPC.GetUnitName(npc) == "npc_dota_hero_tinker" and NPC.IsCreep(unit) and NPC.GetUnitName(unit) ~= "npc_dota_neutral_caster" and not ability.calling["targeted"] or (NPC.HasModifier(unit, "modifier_arc_warden_tempest_double")) or NPC.GetUnitName(unit) == "npc_dota_lone_druid_bear1" or NPC.GetUnitName(unit) == "npc_dota_lone_druid_bear2" or NPC.GetUnitName(unit) == "npc_dota_lone_druid_bear3" or NPC.GetUnitName(unit) == "npc_dota_lone_druid_bear4") and Entity.IsAlive(unit) and not Entity.IsDormant(unit) and Input.GetWorldCursorPos():Distance(Entity.GetAbsOrigin(unit)):Length2D() < 300 and not ability.calling["target"] then
            ability.calling["target"] = {ent = unit, time = nil}
        end
    end
    if ability.calling["target"] and ability.calling["target"].ent then
        if Menu.IsKeyDown(ability.spellkey) and not Input.IsInputCaptured() and Entity.IsAlive(ability.calling["target"].ent) and not Entity.IsDormant(ability.calling["target"].ent) then
            return ability.calling["target"].ent else ability.calling["target"] = nil
        end
    end
end

function ability.findnpc(npc, is, team, distance)
    local result, number = nil, 0
    for _, unit in ipairs(Entity.GetUnitsInRadius(npc, distance, team)) do
        if unit and Entity.IsAlive(unit) and not Entity.IsDormant(unit) and not NPC.HasModifier(unit, "modifier_rubick_telekinesis") and not NPC.HasModifier(unit, "modifier_bounty_hunter_track") and not NPC.HasModifier(unit, "modifier_dark_seer_ion_shell") and not NPC.HasModifier(unit, "modifier_obsidian_destroyer_astral_imprisonment_prison") then
            if (is == "c_hero" and NPC.IsHero(unit) or is == "c_creep" and NPC.IsCreep(unit) or is == "c_all" and (NPC.IsTower(unit) or NPC.IsHero(unit) or NPC.GetUnitName(unit) == "dota_fountain")) and (not result or Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(result)):Length2D() > number) then
                result, number = unit, Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(unit)):Length2D()
            elseif (is == "h_lvl_hero" and NPC.IsHero(unit) or is == "h_lvl_creep" and NPC.IsCreep(unit)) and (not result or NPC.GetCurrentLevel(unit) > number) then
                result, number = unit, NPC.GetCurrentLevel(unit)
            elseif (is == "h_health_hero" and NPC.IsHero(unit) or is == "h_health_creep" and NPC.IsCreep(unit)) and (not result or Entity.GetHealth(unit) > number) then
                result, number = unit, Entity.GetHealth(unit)
            elseif (is == "l_health_hero" and NPC.IsHero(unit) or is == "l_health_creep" and NPC.IsCreep(unit)) and (not result or Entity.GetHealth(unit) < number) then
                result, number = unit, Entity.GetHealth(unit)
            elseif is == "h_phys_hero" and NPC.IsHero(unit) and (not result or NPC.GetTrueDamage(unit) > number) then
                result, number = unit, NPC.GetTrueDamage(unit)
            elseif is == "h_mana_hero" and NPC.IsHero(unit) and (not result or NPC.GetMana(unit) > number) then
                result, number = unit, NPC.GetMana(unit)
            elseif is == "l_mana_hero" and NPC.IsHero(unit) and (not result or NPC.GetMana(unit) < number) then
                result, number = unit, NPC.GetMana(unit)
            elseif (is == "remnant" and NPC.GetUnitName(unit) == "npc_dota_ember_spirit_remnant" or is == "mine" and NPC.GetUnitName(unit) == "npc_dota_techies_land_mine" or is == "stone" and NPC.GetUnitName(unit) == "npc_dota_earth_spirit_stone" or is == "spirit" and NPC.GetUnitName(unit) == "npc_dota_wisp_spirit" or is == "as" and NPC.GetUnitName(unit) == "npc_dota_elder_titan_ancestral_spirit" or is == "trap" and NPC.GetUnitName(unit) == "npc_dota_templar_assassin_psionic_trap") and (not result or Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(result)):Length2D() > number) then
                result, number = unit, Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(unit)):Length2D()
            elseif is == "s_mars" and NPC.IsStructure(unit) and (Entity.GetAbsOrigin(unit):GetX() - ability.skillshotXYZ(Heroes.GetLocal(), npc, 900):GetX()) / (Entity.GetAbsOrigin(Heroes.GetLocal()):GetX() - ability.skillshotXYZ(Heroes.GetLocal(), npc, 900):GetX()) < 0 and (Entity.GetAbsOrigin(unit):GetY() - ability.skillshotXYZ(Heroes.GetLocal(), npc, 900):GetY()) / (Entity.GetAbsOrigin(Heroes.GetLocal()):GetY() - ability.skillshotXYZ(Heroes.GetLocal(), npc, 900):GetY()) < 0 and math.abs((Entity.GetAbsOrigin(unit):GetX() - ability.skillshotXYZ(Heroes.GetLocal(), npc, 900):GetX()) / (Entity.GetAbsOrigin(Heroes.GetLocal()):GetX() - ability.skillshotXYZ(Heroes.GetLocal(), npc, 900):GetX()) - (Entity.GetAbsOrigin(unit):GetY() - ability.skillshotXYZ(Heroes.GetLocal(), npc, 900):GetY()) / (Entity.GetAbsOrigin(Heroes.GetLocal()):GetY() - ability.skillshotXYZ(Heroes.GetLocal(), npc, 900):GetY())) < 0.6 then
                result = unit
            end
        end
    end
    return result
end

function ability.findtree(npc, is, npc2, distance)
    local result, number = nil, 0
    for _, tree in ipairs(Entity.GetTreesInRadius(npc, distance)) do
        if tree and is == "s_tree" and ability.skillshotXYZ(npc2, npc, 1000):Distance(Entity.GetAbsOrigin(tree)):Length2D() < 575 and (Entity.GetAbsOrigin(tree):GetX() - ability.skillshotXYZ(npc2, npc, 1000):GetX()) / (Entity.GetAbsOrigin(npc2):GetX() - ability.skillshotXYZ(npc2, npc, 1000):GetX()) < 0 and (Entity.GetAbsOrigin(tree):GetY() - ability.skillshotXYZ(npc2, npc, 1000):GetY()) / (Entity.GetAbsOrigin(npc2):GetY() - ability.skillshotXYZ(npc2, npc, 1000):GetY()) < 0 and math.abs((Entity.GetAbsOrigin(tree):GetX() - ability.skillshotXYZ(npc2, npc, 1000):GetX()) / (Entity.GetAbsOrigin(npc2):GetX() - ability.skillshotXYZ(npc2, npc, 1000):GetX()) - (Entity.GetAbsOrigin(tree):GetY() - ability.skillshotXYZ(npc2, npc, 1000):GetY()) / (Entity.GetAbsOrigin(npc2):GetY() - ability.skillshotXYZ(npc2, npc, 1000):GetY())) < 0.3 then
            result = tree
        elseif tree and is == "t_tree" and (Entity.GetAbsOrigin(tree):GetX() - ability.skillshotXYZ(npc2, npc, 1000):GetX()) / (Entity.GetAbsOrigin(npc2):GetX() - ability.skillshotXYZ(npc2, npc, 1000):GetX()) < 0 and (Entity.GetAbsOrigin(tree):GetY() - ability.skillshotXYZ(npc2, npc, 1000):GetY()) / (Entity.GetAbsOrigin(npc2):GetY() - ability.skillshotXYZ(npc2, npc, 1000):GetY()) < 0 and math.abs((Entity.GetAbsOrigin(tree):GetX() - ability.skillshotXYZ(npc2, npc, 1000):GetX()) / (Entity.GetAbsOrigin(npc2):GetX() - ability.skillshotXYZ(npc2, npc, 1000):GetX()) - (Entity.GetAbsOrigin(tree):GetY() - ability.skillshotXYZ(npc2, npc, 1000):GetY()) / (Entity.GetAbsOrigin(npc2):GetY() - ability.skillshotXYZ(npc2, npc, 1000):GetY())) < 0.3 then
            result, number = tree, ability.skillshotXYZ(npc2, npc, 1000):Distance(Entity.GetAbsOrigin(tree)):Length2D()
        elseif tree and (is == "m_tree" and ability.skillshotXYZ(npc2, npc, 1000):Distance(Entity.GetAbsOrigin(tree)):Length2D() > 350 or is == "h_tree") and (not result or ability.skillshotXYZ(npc2, npc, 1000):Distance(Entity.GetAbsOrigin(result)):Length2D() > number) then
            result, number = tree, ability.skillshotXYZ(npc2, npc, 1000):Distance(Entity.GetAbsOrigin(tree)):Length2D()
        end
    end
    return result
end

function ability.findspell(name, status)
    for spell, date in pairs(ability.imageoption) do
        if date.opt and Menu.IsEnabled(date.opt) and spell and Entity.IsAbility(spell) and Ability.GetLevel(spell) > 0 and not Ability.IsHidden(spell) then
            if status:find("lastuse") then last_use = status:gsub("lastuse", "") + 0 end
            if status == "ready" and Ability.GetName(spell) == name and Ability.GetCooldown(spell) == 0 then
                return true
            elseif status == "cooldown" and Ability.GetName(spell) == name and Ability.GetCooldown(spell) > 0 then
                return true
            elseif status:find("lastuse") and Ability.GetName(spell) == name and Ability.GetCooldown(spell) > 0 and Ability.SecondsSinceLastUse(spell) > last_use then
                return true
            elseif status == "ready" and name == "ultimate" and Ability.GetName(spell) ~= "rubick_spell_steal" and Ability.IsUltimate(spell) and Ability.GetCooldown(spell) == 0 then
                return true
            elseif status == "cooldown" and name == "ultimate" and Ability.GetName(spell) ~= "rubick_spell_steal" and Ability.IsUltimate(spell) and Ability.GetCooldown(spell) > 0 then
                return true
            elseif status == "nocharge" and Ability.GetName(spell) == name and Ability.GetCooldown(spell) > 0 and Ability.GetCurrentCharges(spell) == 0 then
                return true
            elseif status == "outrange" and Ability.GetName(spell) == name and ability.calling["target"] and ability.calling["target"].ent and ability.get_distance(spell, Heroes.GetLocal()) > 0 and Entity.GetAbsOrigin(Heroes.GetLocal()):Distance(Entity.GetAbsOrigin(ability.calling["target"].ent)):Length2D() > ability.get_distance(spell, Heroes.GetLocal()) then
                return true
            end
        end
    end
    local spell = NPC.GetItem(Heroes.GetLocal(), name, true) or NPC.GetAbility(Heroes.GetLocal(), name)
    if name ~= "ultimate" and (not spell or Ability.GetLevel(spell) == 0) or ability.imageoption[spell] and not Menu.IsEnabled(ability.imageoption[spell].opt) then
        return true
    end
    return false
end

function ability.OnPrepareUnitOrders(orders)
    if orders.npc and orders.ability and Entity.IsAbility(orders.ability) and Ability.GetLevel(orders.ability) > 0 then
        if Ability.GetName(orders.ability) == "pudge_rot" or Ability.GetName(orders.ability) == "leshrac_pulse_nova" or Ability.GetName(orders.ability) == "bloodseeker_blood_mist" then
            if not Ability.GetToggleState(orders.ability) then
                ability.sleeptime[Ability.GetName(orders.ability)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 99
            else
                ability.sleeptime[Ability.GetName(orders.ability)] = 0
            end
        elseif Ability.GetName(orders.ability) == "morphling_morph_agi" then
            if not Ability.GetToggleState(orders.ability) then
                ability.sleeptime[Ability.GetName(orders.ability)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 99
            else
                ability.sleeptime[Ability.GetName(orders.ability)] = 0
            end
        elseif Ability.GetName(orders.ability) == "morphling_morph_str" then
            if not Ability.GetToggleState(orders.ability) then
                ability.sleeptime[Ability.GetName(orders.ability)] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 99
            else
                ability.sleeptime[Ability.GetName(orders.ability)] = 0
            end
        elseif Ability.GetName(orders.ability) == "shredder_chakram" then
            ability.sleeptime["shredder_return_chakram"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 99
        elseif Ability.GetName(orders.ability) == "shredder_chakram_2" then
            ability.sleeptime["shredder_return_chakram_2"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + 99
        elseif Ability.GetName(orders.ability) == "shredder_return_chakram" then
            ability.sleeptime["shredder_return_chakram"] = 0
        elseif Ability.GetName(orders.ability) == "shredder_return_chakram_2" then
            ability.sleeptime["shredder_return_chakram_2"] = 0
        elseif Ability.GetName(orders.ability) == "tinker_keen_teleport" then
            local channeltime = {5, 4.5, 4}
            ability.sleeptime["tinker_rearm"] = GameRules.GetGameTime() + (NetChannel.GetAvgLatency(0) + NetChannel.GetAvgLatency(1)) + channeltime[Ability.GetLevel(orders.ability)]
        end
    end
end

function ability.OnUnitAnimation(animation)
    --if animation.unit and not ability.printing[animation.sequenceName] then Console.Print(animation.sequenceName) ability.printing[animation.sequenceName] = animation.unit end
    if Heroes.GetLocal() and animation.unit == Heroes.GetLocal() and Entity.IsSameTeam(Heroes.GetLocal(), animation.unit) and Entity.IsAlive(animation.unit) and (NPC.IsHero(animation.unit) or NPC.IsCreep(animation.unit) or NPC.GetUnitName(animation.unit) == "npc_dota_lone_druid_bear1" or NPC.GetUnitName(animation.unit) == "npc_dota_lone_druid_bear2" or NPC.GetUnitName(animation.unit) == "npc_dota_lone_druid_bear3" or NPC.GetUnitName(animation.unit) == "npc_dota_lone_druid_bear4") and (Entity.GetOwner(Heroes.GetLocal()) == Entity.GetOwner(animation.unit) or Entity.OwnedBy(animation.unit, Heroes.GetLocal())) and not NPC.HasModifier(animation.unit, "modifier_antimage_blink_illusion") and not NPC.HasModifier(animation.unit, "modifier_monkey_king_fur_army_soldier_hidden") and not NPC.HasModifier(animation.unit, "modifier_monkey_king_fur_army_soldier") and not NPC.HasModifier(animation.unit, "modifier_hoodwink_decoy_illusion") and animation.activity == 1503 then
        if not ability.sleeptime["orbwalking"] then
            ability.sleeptime["orbwalking"] = GameRules.GetGameTime()
        end
    end
    if Heroes.GetLocal() and not ability.defender[animation.unit] and NPC.IsHero(animation.unit) and not Entity.IsSameTeam(Heroes.GetLocal(), animation.unit) then
        for _, list in pairs(
            {
                {name = "abil2_anim", spellname = "medusa_mystic_snake"},
                {name = "ability1_cast_anim", spellname = "shadow_demon_disruption"},
                {name = "amp_anim", spellname = "slardar_amplify_damage"},
                {name = "attack_omni_cast", spellname = "juggernaut_omni_slash"},
                {name = "blink_anim", spellname = "antimage_blink"},
                {name = "broodmother_cast1_spawn_spiderlings_anim", spellname = "broodmother_spawn_spiderlings"},
                {name = "cast04_winters_curse_flying_low_anim", spellname = "winter_wyvern_winters_curse"},
                {name = "cast1_fireblast_anim", spellname = "ogre_magi_fireblast"},
                {name = "cast1_fireblast_withUltiSceptre_anim", spellname = "ogre_magi_unrefined_fireblast"},
                {name = "cast1_hellfire_blast", spellname = "skeleton_king_hellfire_blast"},
                {name = "cast1_malefice_anim", spellname = "enigma_malefice"},
                {name = "cast2_blink_strike_anim", spellname = "riki_blink_strike"},
                {name = "cast2_ignite_anim", spellname = "ogre_magi_ignite"},
                {name = "cast2_rift_anim", spellname = "puck_waning_rift"},
                {name = "cast4_False_Promise_anim", spellname = "oracle_false_promise"},
                {name = "cast4_black_hole_anim", spellname = "enigma_black_hole"},
                {name = "cast4_primal_roar_anim", spellname = "beastmaster_primal_roar"},
                {name = "cast4_rupture_anim", spellname = "bloodseeker_rupture"},
                {name = "cast5_Overgrowth_anim", spellname = "treant_overgrowth"},
                {name = "cast5_coil_anim", spellname = "puck_dream_coil"},
                {name = "cast_4_poison_nova_anim", spellname = "venomancer_poison_nova"},
                {name = "cast_GS_anim", spellname = "silencer_global_silence"},
                {name = "cast_LW_anim", spellname = "silencer_last_word"},
                {name = "cast_channel_shackles_anim", spellname = "shadow_shaman_shackles"},
                {name = "cast_dagger_ani", spellname = "spectre_spectral_dagger"},
                {name = "cast_doom_anim", spellname = "doom_bringer_doom"},
                {name = "cast_hoofstomp_anim", spellname = "centaur_hoof_stomp"},
                {name = "cast_mana_void", spellname = "antimage_mana_void"},
                {name = "cast_mana_void", spellname = "arc_warden_tempest_double"},
                {name = "cast_tracker_anim", spellname = "bounty_hunter_track"},
                {name = "cast_ult_anim", spellname = "necrolyte_reapers_scythe"},
                {name = "cast_ulti_anim", spellname = 'obsidian_destroyer_sanity_eclipse'},
                {name = "cast_voodoo_anim", spellname = "shadow_shaman_voodoo"},
                {name = "castb_anim", spellname = "obsidian_destroyer_astral_imprisonment"},
                {name = "chain_frost_anim", spellname = "lich_chain_frost"},
                {name = "chaosbolt_anim", spellname = "chaos_knight_chaos_bolt"},
                {name = "chronosphere_anim", spellname = "faceless_void_chronosphere"},
                {name = "crush_anim", spellname = "slardar_slithereen_crush"},
                {name = "dragon_bash", spellname = "dragon_knight_dragon_tail"},
                {name = "echo_slam_anim", spellname = "earthshaker_echo_slam"},
                {name = "enchant_anim", spellname = "enchantress_enchant"},
                {name = "enfeeble_anim", spellname = "bane_enfeeble"},
                {name = "fiends_grip_cast_anim", spellname = "bane_fiends_grip"},
                {name = "finger_anim", spellname = "lion_finger_of_death"},
                {name = "fissure_anim", spellname = "earthshaker_fissure"},
                {name = "frostbite_anim", spellname = "crystal_maiden_frostbite"},
                {name = "impale_anim", spellname = "lion_impale"},
                {name = "impale_anim", spellname = "nyx_assassin_impale"},
                {name = "laguna_blade_anim", spellname = "lina_laguna_blade"},
                {name = "lasso_start_anim", spellname = "batrider_flaming_lasso"},
                {name = "legion_commander_duel_anim", spellname = "legion_commander_duel"},
                {name = "life drain_anim", spellname = "pugna_life_drain"},
                {name = "light_strike_array_lhand_anim", spellname = "lina_light_strike_array"},
                {name = "light_strike_array_rhand_anim", spellname = "lina_light_strike_array"},
                {name = "luna_cast_anim", spellname = "luna_lucent_beam"},
                {name = "magic_missile_anim", spellname = "vengefulspirit_magic_missile"},
                {name = "mana_burn_anim", spellname = "nyx_assassin_mana_burn"},
                {name = "marci_cast_grapple_alt", spellname = "marci_grapple"},
                {name = "marci_cast_unleash", spellname = "marci_unleash"},
                {name = "pb_cast_pummel_v3", spellname = "primal_beast_pulverize"},
                {name = "phantom_assassin_phantomstrike_anim", spellname = "phantom_assassin_phantom_strike"},
                {name = "polarity_anim", spellname = "magnataur_reverse_polarity"},
                {name = "pudge_dismember_start", spellname = "pudge_dismember"},
                {name = "queen_sonicwave_anim", spellname = "queenofpain_sonic_wave"},
                {name = "queenofpain_blink_start_anim", spellname = "queenofpain_blink"},
                {name = "ravage_anim", spellname = "tidehunter_ravage"},
                {name = "rubick_cast_fadebolt_anim", spellname = "rubick_fade_bolt"},
                {name = "rubick_cast_telekinesis_anim", spellname = "rubick_telekinesis"},
                {name = "sand_king_epicast_anim", spellname = "sandking_epicenter"},
                {name = "searing_chains_anim", spellname = "ember_spirit_searing_chains"},
                {name = "shackleshot_anim", spellname = "windrunner_shackleshot"},
                {name = "skywrath_mage_mystic_flare_cast_anim", spellname = "skywrath_mage_mystic_flare"},
                {name = "skywrath_mage_seal_cast_anim", spellname = "skywrath_mage_ancient_seal"},
                {name = "snapfire_blobs_cast", spellname = "snapfire_mortimer_kisses"},
                {name = "sniper_assassinate_cast4_aggressive_anim", spellname = "sniper_assassinate"},
                {name = "sniper_assassinate_cast4_aggressive_ulti_scepter", spellname = "sniper_assassinate"},
                {name = "split_earth_anim", spellname = "leshrac_split_earth"},
                {name = "storm_bolt_anim", spellname = "sven_storm_bolt"},
                {name = "sunder", spellname = "terrorblade_sunder"},
                {name = "timewalk_anim", spellname = "faceless_void_time_walk"},
                {name = "ultimate_anim", spellname = "shadow_demon_demonic_purge"},
                {name = "ultimate_anim", spellname = "spirit_breaker_nether_strike"},
                {name = "viper_strike_anim", spellname = "viper_viper_strike"},
                {name = "vortex_anim", spellname = "storm_spirit_electric_vortex"},
                --{name = "zeus_cast1_arc_lightning", spellname = "zuus_arc_lightning"},
                {name = "zeus_cast2_lightning_bolt", spellname = "zuus_lightning_bolt"},
                {name = "cast_anim", spellname = "morphling_adaptive_strike_agi"},
                {name = "cast_anim", spellname = "ember_spirit_fire_remnant"},
                {name = "shieldbash_anim", spellname = "dragon_knight_dragon_tail"},
                {name = "shadowstrike_anim", spellname = "queenofpain_shadow_strike"},
                {name = "polarity_anim", spellname = "magnataur_reverse_polarity"}
            }
        ) do
            if list and animation.sequenceName == list.name then
                for i = 0, 24 do
                    local enemyspell = NPC.GetAbilityByIndex(animation.unit, i)
                    if enemyspell and Ability.GetName(enemyspell) == list.spellname then
                        local distance = ability.get_distance(enemyspell, animation.unit)
                        if distance > 0 and Entity.GetAbsOrigin(Heroes.GetLocal()):Distance(Entity.GetAbsOrigin(animation.unit)):Length2D() < distance + 90 then
                            ability.defender[animation.unit] = {spell = enemyspell, unit = animation.unit, time = GameRules.GetGameTime(), castpoint = animation.castpoint}
                        end
                    end
                end
            end
        end
    end
end

function ability.safe_cast(npc, npc2, spell)
    if spell and (Ability.GetName(spell) == "invoker_tornado" or Ability.GetName(spell) == "invoker_chaos_meteor" or Ability.GetName(spell) == "invoker_deafening_blast" or Ability.GetName(spell) == "invoker_sun_strike" or Ability.GetName(spell) == "nevermore_requiem" or Ability.GetName(spell) == "jakiro_ice_path" or Ability.GetName(spell) == "lina_light_strike_array") and not Ability.IsHidden(spell) then
        for _, bufflist in pairs(
            {
                "modifier_invoker_tornado",
                "modifier_eul_cyclone",
                "modifier_wind_waker",
                "modifier_phantomlancer_dopplewalk_phase",
                "modifier_obsidian_destroyer_astral_imprisonment_prison",
                "modifier_axe_berserkers_call"
            }
        ) do
            local buff = NPC.GetModifier(npc2, bufflist)
            if buff and Modifier.GetDieTime(buff) > 0 and (Ability.GetName(spell) == "invoker_chaos_meteor" and Modifier.GetDieTime(buff) - GameRules.GetGameTime() < 1.3 or Ability.GetName(spell) == "invoker_deafening_blast" and Modifier.GetDieTime(buff) - GameRules.GetGameTime() < 0.35 or Ability.GetName(spell) == "invoker_sun_strike" and Modifier.GetDieTime(buff) - GameRules.GetGameTime() < 1.7) then
                return true
            end
        end
        if ability.findspell("invoker_tornado", "lastuse0.1") and not ability.findspell("invoker_tornado", "lastuse3") then
            return false
        end
    end
    if spell and Ability.GetName(spell) == "invoker_tornado" and not Ability.IsHidden(spell) and NPC.HasModifier(npc2, "modifier_axe_berserkers_call") or NPC.HasModifier(npc, "modifier_eul_cyclone") or NPC.HasModifier(npc, "modifier_wind_waker") or NPC.HasModifier(npc2, "modifier_invulnerable") or NPC.HasModifier(npc2, "modifier_phantomlancer_dopplewalk_phase") or NPC.HasModifier(npc2, "modifier_eul_cyclone") or NPC.HasModifier(npc2, "modifier_wind_waker") or NPC.HasModifier(npc2, "modifier_ursa_enrage") or NPC.HasModifier(npc2, "modifier_obsidian_destroyer_astral_imprisonment_prison") or NPC.HasModifier(npc2, "modifier_troll_warlord_battle_trance") or NPC.HasModifier(npc2, "modifier_invoker_tornado") or NPC.HasModifier(npc2, "modifier_abaddon_borrowed_time") or NPC.GetAbility(npc2, "phantom_lancer_doppelwalk") and Ability.IsInAbilityPhase(NPC.GetAbility(npc2, "phantom_lancer_doppelwalk")) then
        return false
    end
    return true
end

function ability.skillshotXYZ(npc, npc2, speed)
    if not ability.cast_pos["rubick_telekinesis"] and NPC.IsRunning(npc2) and not NPC.IsStunned(npc2) and not NPC.IsRooted(npc2) and not NPC.HasModifier(npc2, "modifier_nevermore_necromastery_fear") then
        return Entity.GetAbsOrigin(npc2) + Entity.GetRotation(npc2):GetForward():Normalized():Scaled(Entity.GetAbsOrigin(npc):Distance(Entity.GetAbsOrigin(npc2)):Length2D() * NPC.GetMoveSpeed(npc2) / speed)
    elseif ability.cast_pos["rubick_telekinesis"] and ability.cast_pos["rubick_telekinesis"].pos then
        return ability.cast_pos["rubick_telekinesis"].pos
    end
    return Entity.GetAbsOrigin(npc2)
end

function ability.skillshotAOE(npc, npc2, radius, XYZS)
    local enemies = Heroes.InRadius(ability.skillshotXYZ(npc, npc2, 1200), radius, Entity.GetTeamNum(npc), 0)
    if #enemies > 1 then
        local pos = {}
        for _, unit in ipairs(enemies) do
            if unit then
                table.insert(pos, {x = Entity.GetAbsOrigin(unit):GetX(), y = Entity.GetAbsOrigin(unit):GetY()})
            end
        end
        local x, y, c = 0, 0, #pos
        for i = 1, c do
            x, y = x + pos[i].x, y + pos[i].y
        end
        return Vector(x/c, y/c, 0)
    end
    return ability.skillshotXYZ(npc, npc2, XYZS)
end

function ability.skillshotFront(npc, npc2, radius, XYZS)
    local smart_cast = false
    for i = 1, math.floor((Entity.GetAbsOrigin(npc) - ability.skillshotXYZ(npc, npc2, 1200)):Length2D()) do
        for _, unit in ipairs(Heroes.InRadius(Entity.GetAbsOrigin(npc) + (ability.skillshotXYZ(npc, npc2, 1200) - Entity.GetAbsOrigin(npc)):Normalized():Scaled(i * radius), radius, Entity.GetTeamNum(npc), 0)) do
            if unit and unit ~= npc2 and Entity.IsAlive(unit) and not Entity.IsDormant(unit) then
                smart_cast = true
                return Entity.GetAbsOrigin(unit) + (ability.skillshotXYZ(npc, npc2, 1200) - Entity.GetAbsOrigin(unit)):Normalized():Scaled(Entity.GetAbsOrigin(unit):Distance(ability.skillshotXYZ(npc, npc2, 1200)):Length2D() / 2)
            end
        end
    end
    if not smart_cast then
        return ability.skillshotXYZ(npc, npc2, XYZS)
    end
end

function ability.checkspellblocked(npc, pos, pos2, npc2, spell)
    for i = 1, math.floor((pos - pos2):Length2D() / 125) do
        for _, unit in ipairs(NPCs.InRadius(pos + (pos2 - pos):Normalized():Scaled(i * 125), 125, Entity.GetTeamNum(npc), 3)) do
            if unit and Entity.IsAlive(unit) and unit ~= npc and unit ~= npc2 and (NPC.IsCreep(unit) or NPC.IsHero(unit)) and (Ability.GetName(spell) == "mirana_arrow" and not Entity.IsSameTeam(npc, unit) or Ability.GetName(spell) ~= "mirana_arrow") then
                return true
            end
        end
    end
    return false
end

function ability.disable_manager(spell, npc)
    local bufftime = 0
    for _, bufflist in pairs(
        {
            "modifier_bashed",
            "modifier_sheepstick_debuff",
            "modifier_stunned",
            "modifier_alchemist_unstable_concoction",
            "modifier_ancientapparition_coldfeet_freeze",
            "modifier_axe_berserkers_call",
            "modifier_bane_fiends_grip",
            "modifier_earthshaker_fissure_stun",
            "modifier_earth_spirit_boulder_smash",
            "modifier_enigma_black_hole_pull",
            "modifier_faceless_void_chronosphere_freeze",
            "modifier_jakiro_ice_path_stun",
            "modifier_keeper_of_the_light_mana_leak_stun",
            "modifier_kunkka_torrent",
            "modifier_legion_commander_duel",
            "modifier_lion_impale",
            "modifier_lion_voodoo",
            "modifier_magnataur_reverse_polarity",
            "modifier_medusa_stone_gaze_stone",
            "modifier_nyx_assassin_impale",
            "modifier_pudge_dismember",
            "modifier_rattletrap_hookshot",
            "modifier_rubick_telekinesis",
            "modifier_sandking_impale",
            "modifier_shadow_shaman_voodoo",
            "modifier_shadow_shaman_shackles",
            "modifier_techies_stasis_trap_stunned",
            "modifier_tidehunter_ravage",
            "modifier_windrunner_shackle_shot",
            "modifier_lone_druid_spirit_bear_entangle_effect",
            "modifier_storm_spirit_electric_vortex_pull",
            "modifier_visage_summon_familiars_stone_form_buff",
            "modifier_void_spirit_aether_remnant_pull",
            "modifier_hoodwink_bushwhack_trap",
            "modifier_terrorblade_fear"
        }
    ) do
        local buff = NPC.GetModifier(npc, bufflist)
        if buff then bufftime = Modifier.GetDieTime(buff) end
    end
    if Ability.GetDispellableType(spell) == 1 and Ability.GetName(spell) ~= "earth_spirit_boulder_smash" or Ability.GetName(spell) == "marci_grapple" then
        if bufftime > 0 and bufftime - GameRules.GetGameTime() > 0.35 then
            return false
        else
            if not ability.calling["disableing"] then
                ability.calling["disableing"] = {unit = spell, time = GameRules.GetGameTime() + 2.2}
            end
            if ability.calling["disableing"] and ability.calling["disableing"].unit == spell then
                return true
            end
        end
    else
        return true
    end
end

function ability.get_distance(spell, npc)
    for _, lib in pairs(
        {
            {name = "ancient_apparition_ice_blast", radius = 99999},
            {name = "ancient_apparition_ice_blast_release", radius = 99999},
            {name = "antimage_counterspell", radius = 1000},
            {name = "arc_warden_tempest_double", radius = 900},
            {name = "alchemist_chemical_rage", radius = 1000},
            {name = "batrider_firefly", radius = 550},
            {name = "brewmaster_thunder_clap", radius = 400},
            {name = "brewmaster_drunken_brawler", radius = 99999},
            {name = "brewmaster_primal_split", radius = 550},
            {name = "bristleback_quill_spray", radius = 650},
            {name = "bloodseeker_bloodrage", radius = 99999},
            {name = "broodmother_insatiable_hunger", radius = 550},
            {name = "centaur_hoof_stomp", radius = 315},
            {name = "centaur_stampede", radius = 99999},
            {name = "chaos_knight_phantasm", radius = 2000},
            {name = "chen_hand_of_god", radius = 99999},
            {name = "clinkz_wind_walk", radius = 2000},
            {name = "crystal_maiden_freezing_field", radius = 600},
            {name = "dark_willow_shadow_realm", radius = 1150},
            {name = "dark_willow_bedlam", radius = 300},
            {name = "death_prophet_exorcism", radius = 700},
            {name = "doom_bringer_scorched_earth", radius = 600},
            {name = "dragon_knight_elder_dragon_form", radius = 550},
            {name = "dragon_knight_fireball", radius = 600},
            {name = "drow_ranger_trueshot", radius = 99999},
            {name = "drow_ranger_multishot", radius = 1000},
            {name = "ember_spirit_searing_chains", radius = 400},
            {name = "ember_spirit_flame_guard", radius = 400},
            {name = "earthshaker_enchant_totem", radius = 950},
            {name = "earthshaker_echo_slam", radius = 600},
            {name = "enchantress_natures_attendants", radius = 1000},
            {name = "furion_wrath_of_nature", radius = 99999},
            {name = "gyrocopter_rocket_barrage", radius = 400},
            {name = "gyrocopter_flak_cannon", radius = 1250},
            {name = "huskar_inner_fire", radius = 500},
            {name = "invoker_forge_spirit", radius = 1200},
            {name = "invoker_ice_wall", radius = 300},
            {name = "invoker_sun_strike", radius = 99999},
            {name = "juggernaut_blade_fury", radius = 1200},
            {name = "juggernaut_healing_ward", radius = 99999},
            {name = "leshrac_diabolic_edict", radius = 500},
            {name = "leshrac_pulse_nova", radius = 99999},
            {name = "life_stealer_rage", radius = 1000},
            {name = "lone_druid_spirit_bear", radius = 99999},
            {name = "lone_druid_spirit_link", radius = 550},
            {name = "lone_druid_savage_roar", radius = 325},
            {name = "lone_druid_true_form", radius = 550},
            {name = "lycan_summon_wolves", radius = 1000},
            {name = "lycan_howl", radius = 3000},
            {name = "lycan_shapeshift", radius = 550},
            {name = "magnataur_empower", radius = 99999},
            {name = "magnataur_reverse_polarity", radius = 410},
            {name = "magnataur_horn_toss", radius = 325},
            {name = "mars_spear", radius = 1000},
            {name = "mars_gods_rebuke", radius = 500},
            {name = "meepo_poof", radius = 99999},
            {name = "mirana_starfall", radius = 650},
            {name = "mirana_invis", radius = 99999},
            {name = "monkey_king_primal_spring", radius = 1000},
            {name = "monkey_king_mischief", radius = 1000},
            {name = "naga_siren_mirror_image", radius = 1000},
            {name = "nevermore_shadowraze1", radius = 450},
            {name = "nevermore_shadowraze2", radius = 700},
            {name = "nevermore_shadowraze3", radius = 950},
            {name = "nevermore_requiem", radius = 150},
            {name = "naga_siren_song_of_the_siren", radius = 1000},
            {name = "necrolyte_death_pulse", radius = 500},
            {name = "night_stalker_crippling_fear", radius = 375},
            {name = "nyx_assassin_spiked_carapace", radius = 550},
            {name = "nyx_assassin_vendetta", radius = 99999},
            {name = "obsidian_destroyer_equilibrium", radius = 550},
            {name = "omniknight_guardian_angel", radius = 1200},
            {name = "pangolier_swashbuckle", radius = 2000},
            {name = "pangolier_shield_crash", radius = 500},
            {name = "pangolier_gyroshell", radius = 660},
            {name = "pangolier_gyroshell_stop", radius = 99999},
            {name = "phoenix_supernova", radius = 1300},
            {name = "pugna_nether_ward", radius = 1600},
            {name = "pudge_rot", radius = 1200},
            {name = "puck_waning_rift", radius = 600},
            {name = "puck_phase_shift", radius = 900},
            {name = "queenofpain_scream_of_pain", radius = 550},
            {name = "rattletrap_battery_assault", radius = 275},
            {name = "rattletrap_power_cogs", radius = 215},
            {name = "rattletrap_rocket_flare", radius = 99999},
            {name = "razor_plasma_field", radius = 700},
            {name = "razor_eye_of_the_storm", radius = 550},
            {name = "riki_tricks_of_the_trade", radius = 450},
            {name = "sandking_sand_storm", radius = 650},
            {name = "sandking_epicenter", radius = 550},
            {name = "shredder_whirling_death", radius = 325},
            {name = "shredder_return_chakram", radius = 99999},
            {name = "shredder_return_chakram_2", radius = 99999},
            {name = "silencer_global_silence", radius = 99999},
            {name = "slardar_slithereen_crush", radius = 350},
            {name = "slardar_sprint", radius = 1600},
            {name = "slark_dark_pact", radius = 325},
            {name = "slark_shadow_dance", radius = 550},
            {name = "sniper_take_aim", radius = 99999},
            {name = "spectre_haunt", radius = 99999},
            {name = "spirit_breaker_bulldoze", radius = 3000},
            {name = "storm_spirit_static_remnant", radius = 260},
            {name = "storm_spirit_electric_vortex", radius = 475},
            {name = "sven_warcry", radius = 550},
            {name = "sven_gods_strength", radius = 550},
            {name = "templar_assassin_refraction", radius = 550},
            {name = "terrorblade_reflection", radius = 900},
            {name = "terrorblade_conjure_image", radius = 550},
            --{name = "terrorblade_metamorphosis", radius = 550},
            {name = "terrorblade_terror_wave", radius = 600},
            {name = "tidehunter_anchor_smash", radius = 375},
            {name = "tidehunter_ravage", radius = 550},
            {name = "tinker_heat_seeking_missile", radius = 2500},
            {name = "tinker_defense_matrix", radius = 1300},
            {name = "tinker_keen_teleport", radius = 99999},
            {name = "tinker_rearm", radius = 99999},
            {name = "treant_living_armor", radius = 99999},
            {name = "treant_overgrowth", radius = 800},
            {name = "troll_warlord_whirling_axes_melee", radius = 450},
            {name = "tusk_tag_team", radius = 350},
            {name = "tusk_walrus_punch", radius = 550},
            {name = "undying_flesh_golem", radius = 700},
            {name = "ursa_earthshock", radius = 385},
            {name = "ursa_overpower", radius = 1000},
            {name = "ursa_enrage", radius = 1000},
            {name = "venomancer_poison_nova", radius = 830},
            {name = "visage_summon_familiars", radius = 99999},
            {name = "morphling_morph_replicate", radius = 99999},
            {name = "weaver_time_lapse", radius = 1200},
            {name = "windrunner_windrun", radius = 1000},
            {name = "weaver_shukuchi", radius = 2000},
            {name = "wisp_spirits", radius = 700},
            {name = "wisp_overcharge", radius = 550},
            {name = "zuus_cloud", radius = 99999},
            {name = "zuus_thundergods_wrath", radius = 99999},
            {name = "void_spirit_aether_remnant", radius = 1450},
            {name = "void_spirit_resonant_pulse", radius = 485},
            {name = "void_spirit_dissimilate", radius = 1040},
            {name = "void_spirit_astral_step", radius = 1100},
            {name = "snapfire_firesnap_cookie", radius = 1300},
            {name = "snapfire_mortimer_kisses", radius = 3000},
            {name = "snapfire_gobble_up", radius = 3000},
            {name = "hoodwink_decoy", radius = 2000},
            {name = "elder_titan_echo_stomp", radius = 2000},
            {name = "windrunner_gale_force", radius = 2000},
            {name = "rubick_telekinesis", radius = 2000},
            {name = "rubick_telekinesis_land", radius = 2000},
            {name = "wisp_spirits_in", radius = 2000},
            {name = "wisp_spirits_out", radius = 2000},
            {name = "kunkka_return", radius = 2000},
            {name = "kunkka_torrent_storm", radius = 2000},
            {name = "phoenix_icarus_dive_stop", radius = 99999},
            {name = "phoenix_sun_ray_toggle_move", radius = 99999},
            {name = "storm_spirit_overload", radius = 1000},
            {name = "storm_spirit_ball_lightning", radius = 3000},
            {name = "meepo_petrify", radius = 2000},
            {name = "meepo_divided_we_stand", radius = 900},
            {name = "leshrac_greater_lightning_storm", radius = 450},
            {name = "snapfire_spit_creep", radius = 3000},
            {name = "spirit_breaker_charge_of_darkness", radius = 99999},
            {name = "earth_spirit_boulder_smash", radius = 2000},
            {name = "earth_spirit_geomagnetic_grip", radius = 2000},
            {name = "earth_spirit_stone_caller", radius = 2000},
            {name = "mars_arena_of_blood", radius = 700},
            {name = "grimstroke_spirit_walk", radius = 2000},
            {name = "puck_ethereal_jaunt", radius = 2000},
            {name = "keeper_of_the_light_recall", radius = 99999},
            {name = "troll_warlord_berserkers_rage", radius = 1000},
            {name = "troll_warlord_rampage", radius = 2000},
            {name = "faceless_void_time_dilation", radius = 775},
            {name = "monkey_king_wukongs_command", radius = 550},
            {name = "spectre_reality", radius = 99999},
            {name = "antimage_mana_overload", radius = 1400},
            {name = "beastmaster_call_of_the_wild_boar", radius = 550},
            {name = "zuus_static_field", radius = 2000},
            {name = "dawnbreaker_fire_wreath", radius = 360},
            {name = "dawnbreaker_converge", radius = 2400},
            {name = "spectre_haunt_single", radius = 99999},
            --{name = "dawnbreaker_solar_guardian", radius = 99999},
            {name = "phantom_assassin_fan_of_knives", radius = 550},
            {name = "primal_beast_onslaught", radius = 2000},
            {name = "primal_beast_trample", radius = 230},
            {name = "techies_reactive_tazer", radius = 900},
            {name = "dazzle_good_juju", radius = 900},
            {name = "skeleton_king_vampiric_aura", radius = 300},
            {name = "medusa_stone_gaze", radius = 600},
            {name = "visage_summon_familiars_stone_form", radius = 350},
            {name = "shadow_demon_shadow_poison_release", radius = 99999},
            {name = "tusk_launch_snowball", radius = 99999},
            {name = "hoodwink_scurry", radius = 2000},
            {name = "bloodseeker_blood_mist", radius = 1200},
            {name = "visage_gravekeepers_cloak", radius = 1200},
            {name = "phantom_lancer_phantom_edge", radius = 1125},
            {name = "templar_assassin_trap", radius = 99999},
            {name = "templar_assassin_trap_teleport", radius = 99999},
            {name = "ancient_apparition_chilling_touch", radius = 1265},
            {name = "disruptor_kinetic_field", radius = 2000},
            {name = "disruptor_static_storm", radius = 2000},
            {name = "lina_flame_cloak", radius = 1075},
            {name = "brewmaster_primal_companion", radius = 1200},
            {name = "beastmaster_drums_of_slom", radius = 600},
            {name = "witch_doctor_voodoo_switcheroo", radius = 500},
            {name = "centaur_mount", radius = 2000},
            {name = "ogre_magi_bloodlust", radius = 2000},
            {name = "ogre_magi_smash", radius = 2000},
            {name = "shredder_flamethrower", radius = NPC.GetAttackRange(npc)},
            {name = "templar_assassin_meld", radius = NPC.GetAttackRange(npc)},
            {name = "primal_beast_uproar", radius = NPC.GetAttackRange(npc)},
            {name = "legion_commander_press_the_attack", radius = 1200},
            {name = "weaver_geminate_attack", radius = NPC.GetAttackRange(npc)},
            {name = "terrorblade_demon_zeal", radius = NPC.GetAttackRange(npc)},
            {name = "phantom_lancer_juxtapose", radius = NPC.GetAttackRange(npc)},
            {name = "marci_unleash", radius = NPC.GetAttackRange(npc)},
            {name = "arc_warden_magnetic_field", radius = NPC.GetAttackRange(npc)},
            {name = "hoodwink_acorn_shot", radius = Ability.GetCastRange(spell) + NPC.GetAttackRange(npc)},
            {name = "magnataur_skewer", radius = Ability.GetLevelSpecialValueFor(spell, "range")},
            {name = "antimage_blink", radius = Ability.GetLevelSpecialValueFor(spell, "blink_range")},
            {name = "queenofpain_blink", radius = Ability.GetLevelSpecialValueFor(spell, "blink_range")},
            {name = "ember_spirit_sleight_of_fist", radius = Ability.GetCastRange(spell) + (Ability.GetLevelSpecialValueFor(spell, "radius") / 1.25)},
            {name = "enigma_black_hole", radius = Ability.GetCastRange(spell) + (Ability.GetLevelSpecialValueFor(spell, "radius") / 1.25)},
            {name = "winter_wyvern_arctic_burn", radius = NPC.GetAttackRange(npc) + Ability.GetLevelSpecialValueFor(spell, "attack_range_bonus")},
            --scepter
            {name = "night_stalker_void", new_radius = 900, upgrade = "scepter"},
            {name = "tidehunter_gush", new_radius = 2200, upgrade = "scepter"},
            {name = "ember_spirit_fire_remnant", new_radius = 3000, upgrade = "scepter"},
            {name = "sandking_burrowstrike", new_radius = 1300, upgrade = "scepter"},
            {name = "slark_pounce", radius = 700, new_radius = 1200, upgrade = "scepter"},
            {name = "luna_eclipse", radius = 675, new_radius = 2500, upgrade = "scepter"},
            {name = "huskar_life_break", new_radius = Ability.GetCastRange(spell) + 250, upgrade = "scepter"},
            {name = "sven_storm_bolt", new_radius = Ability.GetCastRange(spell) + 350, upgrade = "scepter"},
            {name = "tinker_laser", new_radius = Ability.GetCastRange(spell) + 250, upgrade = "scepter"},
            --shard
            {name = "vengefulspirit_magic_missile", new_radius = Ability.GetCastRange(spell) + 100, upgrade = "shard"},
            {name = "faceless_void_time_walk", radius = Ability.GetLevelSpecialValueFor(spell, "range"), new_radius = Ability.GetLevelSpecialValueFor(spell, "range") + 400, upgrade = "shard"},
            --talen
            {name = "axe_berserkers_call", radius = 300, new_radius = 400, talent_name = "special_bonus_unique_axe_2"},
            {name = "marci_companion_run", radius = 1900, new_radius = 2150, talent_name = "special_bonus_unique_marci_lunge_range"},
            {name = "lion_impale", new_radius = Ability.GetCastRange(spell) + 800, talent_name = "special_bonus_unique_lion_2"},
            {name = "lion_voodoo", new_radius = Ability.GetCastRange(spell) + 150, talent_name = "special_bonus_unique_lion_4"},
            {name = "puck_illusory_orb", radius = 1950, new_radius = 2250, talent_name = "special_bonus_unique_puck"},
            {name = "puck_waning_rift", radius = 700, new_radius = 1200, talent_name = "special_bonus_unique_puck_6"},
            {name = "arc_warden_flux", radius = Ability.GetLevelSpecialValueFor(spell, "abilitycastrange"), new_radius = Ability.GetLevelSpecialValueFor(spell, "abilitycastrange") + 175, talent_name = "special_bonus_unique_arc_warden_5"},
            {name = "phoenix_icarus_dive", radius = Ability.GetLevelSpecialValueFor(spell, "dash_length"), new_radius = Ability.GetLevelSpecialValueFor(spell, "dash_length") + 1000, talent_name = "special_bonus_unique_phoenix_4"},
            {name = "dawnbreaker_celestial_hammer", radius = Ability.GetLevelSpecialValueFor(spell, "range"), new_radius = Ability.GetLevelSpecialValueFor(spell, "range") + 1000, talent_name = "special_bonus_unique_dawnbreaker_celestial_hammer_cast_range"},
            --items
            {name = "item_ogre_seal_totem", radius = NPC.GetAttackRange(npc) + 550},
            {name = "item_dagger_of_ristul", radius = NPC.GetAttackRange(npc)},
            {name = "item_phase_boots", radius = 2000},
            {name = "item_refresher", radius = 2000},
            {name = "item_refresher_shard", radius = 2000},
            {name = "item_magic_wand", radius = 2000},
            {name = "item_magic_stick", radius = 2000},
            {name = "item_smoke_of_deceit", radius = 1200},
            {name = "item_dust", radius = 1050},
            {name = "item_faerie_fire", radius = 1000},
            {name = "item_enchanted_mango", radius = 1000},
            {name = "item_bottle", radius = 2000},
            {name = "item_manta", radius = 1000},
            {name = "item_ghost", radius = 1000},
            {name = "item_stormcrafter", radius = 1000},
            {name = "item_essence_ring", radius = 1000},
            {name = "item_trickster_cloak", radius = 1000},
            {name = "item_black_king_bar", radius = 1000},
            {name = "item_radiance", radius = 1000},
            {name = "item_armlet", radius = 1000},
            {name = "item_blade_mail", radius = 1000},
            {name = "item_power_treads", radius = 1000},
            {name = "item_soul_ring", radius = 99999},
            {name = "item_mask_of_madness", radius = 2000},
            {name = "item_silver_edge", radius = 2000},
            {name = "item_invis_sword", radius = 2000},
            {name = "item_demonicon", radius = 1000},
            {name = "item_spider_legs", radius = 1000},
            {name = "item_mjollnir", radius = 1000},
            {name = "item_shivas_guard", radius = 900},
            {name = "item_ex_machina", radius = 1000},
            {name = "item_force_field", radius = 1000},
            {name = "item_revenants_brooch", radius = 1000},
            {name = "item_guardian_greaves", radius = 1000},
            {name = "item_boots_of_bearing", radius = 1000},
            {name = "item_glimmer_cape", radius = 1000},
            {name = "item_trickster_cloak", radius = 1000},
            {name = "item_satanic", radius = 1000},
            {name = "item_heavy_blade", radius = 99999},
            {name = "item_seer_stone", radius = 99999},
            {name = "item_bloodstone", radius = 650},
            --neutrals
            {name = "centaur_khan_war_stomp", radius = 250},
            {name = "polar_furbolg_ursa_warrior_thunder_clap", radius = 300}
        }
    ) do
        if lib then
            if Entity.IsAbility(spell) and Ability.GetName(spell) == lib.name then
                if lib.upgrade == "scepter" and (NPC.GetItem(npc, "item_ultimate_scepter") or NPC.HasModifier(npc, "modifier_item_ultimate_scepter_consumed")) then
                    return lib.new_radius
                elseif lib.upgrade == "shard" and NPC.HasModifier(npc, "modifier_item_aghanims_shard") then
                    return lib.new_radius
                elseif lib.talent_name ~= nil and NPC.GetAbility(npc, lib.talent_name) and Ability.GetLevel(NPC.GetAbility(npc, lib.talent_name)) > 0 then
                    return lib.new_radius
                elseif lib.radius ~= nil then
                    return lib.radius
                end
            end
        end
    end
    if Ability.GetName(spell) == "invoker_tornado" and NPC.GetAbility(npc, "invoker_wex") then
        local travel_distance = {800, 1200, 1600, 2000, 2400, 2800, 3200, 3600}
        return travel_distance[Ability.GetLevel(NPC.GetAbility(npc, "invoker_wex"))]
    elseif NPC.HasModifier(npc, "modifier_dragon_knight_dragon_form") and Ability.GetName(spell) == "dragon_knight_dragon_tail" then
        return Ability.GetCastRange(spell) + 250
    elseif Ability.GetName(spell) == "clinkz_strafe" then
        local range = {750, 800, 850, 900}
        return range[Ability.GetLevel(spell)]
    end
    return Ability.GetCastRange(spell)
end

function ability.OnStartSound(sound)
    if sound.source and sound.source ~= Heroes.GetLocal() then
        if sound.name == "Hero_EmberSpirit.FireRemnant.Cast" then
            ability.calling["npc_dota_hero_ember_spirit"]  = "ember_spirit_fire_remnant"
        elseif sound.name == "Hero_VoidSpirit.AetherRemnant.Cast" then
            ability.calling["npc_dota_hero_void_spirit"] = "void_spirit_aether_remnant"
        elseif sound.name == "Hero_VoidSpirit.Pulse.Cast" then
            ability.calling["npc_dota_hero_void_spirit"] = "void_spirit_resonant_pulse"
        elseif sound.name == "Hero_VoidSpirit.AstralStep.Start" then
            ability.calling["npc_dota_hero_void_spirit"] = "void_spirit_astral_step"
        elseif sound.name == "Hero_Tinker.Rearm" then
            ability.calling["npc_dota_hero_tinker"] = "tinker_rearm"
        elseif sound.name == "Hero_Phoenix.SuperNova.Explode" then
            ability.calling["npc_dota_hero_phoenix"] = "phoenix_supernova"
        elseif sound.name == "Hero_Sniper.ShrapnelShatter" then
            ability.calling["npc_dota_hero_sniper"] = "sniper_shrapnel"
        elseif sound.name == "Hero_NyxAssassin.Vendetta" then
            ability.calling["npc_dota_hero_nyx_assassin"] = "nyx_assassin_vendetta"
        elseif sound.name == "Hero_Ancient_Apparition.IceBlast.Target" then
            ability.calling["npc_dota_hero_ancient_apparition"] = "ancient_apparition_ice_blast"
        elseif sound.name == "Hero_StormSpirit.BallLightning" then
            ability.calling["npc_dota_hero_storm_spirit"] = "storm_spirit_ball_lightning"
        elseif sound.name == "Hero_Wisp.Spirits.Cast" then
            ability.calling["npc_dota_hero_wisp"] = "wisp_spirits_in"
        elseif sound.name == "Hero_Brewmaster.PrimalSplit.Spawn" then
            ability.calling["npc_dota_hero_brewmaster"] = "brewmaster_primal_split"
        elseif sound.name == "Hero_Morphling.Waveform" then
            ability.calling["npc_dota_hero_morphling"] = "morphling_waveform"
        elseif sound.name == "Hero_Hoodwink.AcornShot.Cast" then
            ability.calling["npc_dota_hero_hoodwink"] = "hoodwink_acorn_shot"
        elseif sound.name == "Hero_Hoodwink.Scurry.Cast" then
            ability.calling["npc_dota_hero_hoodwink"] = "hoodwink_scurry"
        elseif sound.name == "Hero_Phoenix.FireSpirits.Launch" then
            ability.calling["npc_dota_hero_phoenix"] = "phoenix_launch_fire_spirit"
        elseif sound.name == "Hero_EmberSpirit.SleightOfFist.Damage" and ability.calling["target"] and ability.calling["target"].ent == sound.source then
            ability.calling[sound.source] = {name = sound.name, time = GameRules.GetGameTime() + 0.5}        
        end
    end
end

function ability.OnParticleCreate(particle)
    if particle.entity and particle.entity == Heroes.GetLocal() and particle.name == "brewmaster_drunken_stance_earth" then
        ability.calling[NPC.GetUnitName(particle.entity)] = "stance_earth"
    elseif particle.entity and particle.entity == Heroes.GetLocal() and particle.name == "brewmaster_drunken_stance_fire" then
        ability.calling[NPC.GetUnitName(particle.entity)] = "stance_fire"
    elseif particle.entity and particle.entity == Heroes.GetLocal() and particle.name == "brewmaster_drunken_stance_storm" then
        ability.calling[NPC.GetUnitName(particle.entity)] = "stance_storm"
    elseif particle.entity and particle.entity == Heroes.GetLocal() and particle.name == "brewmaster_drunken_stance_void" then
        ability.calling[NPC.GetUnitName(particle.entity)] = "stance_void"
    elseif particle.entityForModifiers and particle.entityForModifiers == Heroes.GetLocal() and particle.name == "dawnbreaker_celestial_hammer_grounded" then
        ability.calling[NPC.GetUnitName(particle.entityForModifiers)] = {name = "hammer_grounded", time = GameRules.GetGameTime() + 2.5}
    elseif particle.entity and Heroes.GetLocal() and not Entity.IsSameTeam(Heroes.GetLocal(), particle.entity) and particle.name == "weaver_shukuchi_damage" then
        ability.calling[NPC.GetUnitName(particle.entity)] = {name = "damaged", time = GameRules.GetGameTime() + 4}
    elseif particle.entityForModifiers and Heroes.GetLocal() and not Entity.IsSameTeam(Heroes.GetLocal(), particle.entityForModifiers) and (particle.name == "teleport_start" or particle.name == "teleport_end") then
        ability.calling[particle.entityForModifiers] = {name = particle.name, time = GameRules.GetGameTime() + 4}
    end
end

return ability
