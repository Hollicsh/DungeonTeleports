local _, addon = ...
local L = addon.L or {}

-- Backgrounds for each expansion
local mapExpansionToBackground = {}

-- NOTE: these keys are stable, locale-independent identifiers (not display text).
-- They are also what gets persisted into DungeonTeleportsDB.selectedExpansion/defaultExpansion,
-- so they must never be run through L[...] here. Anywhere these need to be shown to the
-- player, look them up via L[key] at display time instead (see UpdateExpansionButtonStyles /
-- EnsureExpansionButtons in DungeonTeleports.lua for the existing pattern).
local mapExpansionToMapID = {
    -- Season 2 Midnight
    ["Current Season"] = {905, 906, 907, 908, 909, 701, 508, 509},
    ["Wotlk"] =  {001},
    ["Cataclysm"] = {101, 102, 103},
    ["Mists of Pandaria"] = {201, 202, 203, 204, 205, 206, 207, 208, 209},
    ["Warlords of Draenor"] = {301, 302, 303, 304, 305, 306, 307, 308},
    ["Legion"] = {401, 402, 403, 404, 405, 406},
    ["Battle for Azeroth"] = {501, 502, 503, 504, 505, 506, 507, 508, 509},
    ["Shadowlands"] = {601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611, 612},
    ["Dragonflight"] = {701, 702, 703, 704, 705, 706, 707, 708, 709, 710, 711, 712},
    ["The War Within"] = {801, 802, 803, 804, 805, 806, 807, 808, 809, 810, 811, 812},
    ["Midnight"] = {901, 902, 903, 904, 905, 906, 907, 908, 909},
}

-- Map IDs to Dungeon Names
local mapIDtoDungeonName = {
    [001] = L["DUNGEON_PIT_SARON"],
    [101] = L["DUNGEON_VORTEX_PINNACLE"],
    [102] = L["DUNGEON_THRONE_OF_THE_TIDES"],
    [103] = L["DUNGEON_GRIM_BATOL"],
    [201] = L["DUNGEON_TEMPLE_OF_THE_JADE_SERPENT"],
    [202] = L["DUNGEON_SIEGE_OF_NIUZAO"],
    [203] = L["DUNGEON_SCHOLOMANCE"],
    [204] = L["DUNGEON_SCARLET_MONASTERY"],
    [205] = L["DUNGEON_SCARLET_HALLS"],
    [206] = L["DUNGEON_GATE_OF_THE_SETTING_SUN"],
    [207] = L["DUNGEON_MOGUSHAN_PALACE"],
    [208] = L["DUNGEON_SHADO_PAN_MONASTERY"],
    [209] = L["DUNGEON_STORMSTOUT_BREWERY"],
    [301] = L["DUNGEON_SHADOWMOON_BURIAL_GROUNDS"],
    [302] = L["DUNGEON_EVERBLOOM"],
    [303] = L["DUNGEON_BLOODMAUL_SLAG_MINES"],
    [304] = L["DUNGEON_AUCHINDOUN"],
    [305] = L["DUNGEON_SKYREACH"],
    [306] = L["DUNGEON_UPPER_BLACKROCK_SPIRE"],
    [307] = L["DUNGEON_GRIMRAIL_DEPOT"],
    [308] = L["DUNGEON_IRON_DOCKS"],
    [401] = L["DUNGEON_DARKHEART_THICKET"],
    [402] = L["DUNGEON_BLACK_ROOK_HOLD"],
    [403] = L["DUNGEON_HALLS_OF_VALOR"],
    [404] = L["DUNGEON_NELTHARIONS_LAIR"],
    [405] = L["DUNGEON_COURT_OF_STARS"],
    [406] = L["DUNGEON_KARAZHAN"],
    [407] = L["DUNGEON_SEAT_TRIUMVIRATE"],
    [501] = L["DUNGEON_ATALDAZAR"],
    [502] = L["DUNGEON_FREEHOLD"],
    [503] = L["DUNGEON_WAYCREST_MANOR"],
    [504] = L["DUNGEON_THE_UNDERROT"],
    [505] = L["DUNGEON_MECHAGON"],
    [506] = L["DUNGEON_SEIGE_OF_BORALUS"],
    [507] = L["DUNGEON_THE_MOTHERLODE"],
    [508] = L["DUNGEON_TEMPLE_SETHRALISS"],
    [509] = L["DUNGEON_KINGS_REST"],
    [601] = L["DUNGEON_THE_NECROTIC_WAKE"],
    [602] = L["DUNGEON_PLAGUEFALL"],
    [603] = L["DUNGEON_MISTS_OF_TIRNA_SCITHE"],
    [604] = L["DUNGEON_HALLS_OF_ATONEMENT"],
    [605] = L["DUNGEON_SPIRES_OF_ASCENSION"], 
    [606] = L["DUNGEON_THEATRE_OF_PAIN"],
    [607] = L["DUNGEON_DE_OTHER_SIDE"],
    [608] = L["DUNGEON_SANGUINE_DEPTHS"],
    [609] = L["DUNGEON_TAZAVESH_THE_VEILED_MARKET"],
    [610] = L["RAID_CASTLE_NATHRIA"],
    [611] = L["RAID_SANCTUM_OF_DOMINATION"],
    [612] = L["RAID_SEPULCHER_OF_THE_FIRST_ONES"],
    [701] = L["DUNGEON_RUBY_LIFE_POOLS"],
    [702] = L["DUNGEON_NOKHUD_OFFENSIVE"],
    [703] = L["DUNGEON_AZURE_VAULT"],
    [704] = L["DUNGEON_ALGETHAR_ACADEMY"],
    [705] = L["DUNGEON_ULDAMAN"],
    [706] = L["DUNGEON_NELTHARUS"],
    [707] = L["DUNGEON_BRACKENHIDE_HOLLOW"],
    [708] = L["DUNGEON_HALLS_OF_INFUSION"],
    [709] = L["DUNGEON_DAWN_OF_THE_INFINITE"],
    [710] = L["RAID_VAULT_OF_THE_INCARNATES"],
    [711] = L["RAID_ABBERUS_THE_SHADOWED_CRUCIBLE"],
    [712] = L["RAID_AMIRDRASSIL_THE_DREAMS_HOPE"],
    [801] = L["DUNGEON_CITY_OF_THREADS"],
    [802] = L["DUNGEON_ARA_KARA_CITY_OF_ECHOS"],
    [803] = L["DUNGEON_STONEVAULT"],
    [804] = L["DUNGEON_DAWNBREAKER"],
    [805] = L["DUNGEON_THE_ROOKERY"],
    [806] = L["DUNGEON_DARKFLAME_CLEFT"],
    [807] = L["DUNGEON_CINDERBREW_BREWERY"],
    [808] = L["DUNGEON_PRIORY_OF_THE_SACRED_FLAME"],
    [809] = L["DUNGEON_OPERATION_FLOODGATE"],
    [810] = L["RAID_LIBERATION_UNDERMINE"],
    [811] = L["DUNGEON_ECHO_DOME"],
    [812] = L["RAID_MANAFORGE_OMEGA"],
    [901] = L["DUNGEON_MAGISTERS_TERRACE"],
    [902] = L["DUNGEON_MAISARA_CAVERNS"],
    [903] = L["DUNGEON_NEXUS_POINT"],
    [904] = L["DUNGEON_WINDRUNNER_SPIRE"],
    [905] = L["DUNGEON_ALTAR_FANGS"],
    [906] = L["DUNGEON_DEN_NALORAKK"],
    [907] = L["DUNGEON_BLINDING_VALE"],
    [908] = L["DUNGEON_VOIDSCAR_ARENA"],
    [909] = L["DUNGEON_MURDER_ROW"],
}

-- Mapping Map IDs to Teleport Spells
local mapIDtoSpellID = {
    [001] = 1254555, -- Pit of Saron
    [101] = 410080, -- The Vortex Pinnacle
    [102] = 424142, -- Throne of the Tide
    [103] = 445424, -- Grim Batol
    [201] = 131204,  -- Jade Serpent
    [202] = 131228, -- Siege of Niuzao
    [203] = 131232, -- Scholomance
    [204] = 131229, -- Scarlet Monastery
    [205] = 131231, -- Scarlet Halls
    [206] = 131225, -- Gate of the Setting Sun
    [207] = 131222, -- Mogu'Shan Palance
    [208] = 131206, -- Shado-Pan Monastery
    [209] = 131205, -- Stormstout Brewery
    [301] = 159899, -- Shadowmoon Burial Grounds
    [302] = 159901, -- Everbloom
    [303] = 159895, -- Bloodmaul Slag Mines
    [304] = 159897, -- Auchindoun
    [305] = 159898, -- Skyreach
    [306] = 159902, -- Upper Blackrock Spire
    [307] = 159900, -- Grimrail Depot
    [308] = 159896, -- Iron Docks
    [401] = 424163, -- Darkheart Thicket
    [402] = 424153, -- Black Rook Hold
    [403] = 393764, -- Halls of Valor
    [404] = 410078, -- Neltharions Lair
    [405] = 393766, -- Court of Starts
    [406] = 373262, -- Karazhan
    [407] = 1254551, -- Seat of the Triumvirate
    [501] = 424187, -- Atal'Dazar
    [502] = 410071, -- Freehold
    [503] = 424167, -- Waycrest
    [504] = 410074, -- Underrot
    [505] = 373274, -- Operation: Mechagon
    [506] = 0,      -- Siege of Boralus (faction-specific, 0 is a placeholder for the real SpellID)
    [507] = 0, -- The Motherlode (Path of the Azerite Refinery)
    [508] = 1286828, -- Temple of Sethraliss
    [509] = 1286831, -- King's Rest
    [601] = 354462, -- The Necrotic Wake
    [602] = 354463, -- Plaguefall
    [603] = 354464, -- Mists of Tirna Scithe
    [604] = 354465, -- Halls of Attonement
    [605] = 354466, -- Spires of Ascension 
    [606] = 354467, -- Theatre of Pain
    [607] = 354468, -- De Other Side
    [608] = 354469, -- Sanguine Depths
    [609] = 367416, -- Tazavesh, the Veiled Market
    [610] = 373190, -- Castle Nathria
    [611] = 373191, -- Sanctum of Domination
    [612] = 373192, -- Sepulcher of the First Ones
    [701] = 393256, -- Ruby Life Pools
    [702] = 393262, -- Nokhud Offensive
    [703] = 393279, -- Azure Vault
    [704] = 393273, -- Algethar Academy
    [705] = 393222, -- Uldaman
    [706] = 393276, -- Neltharus
    [707] = 393267, -- Brackenhide Hollow
    [708] = 393283, -- Halls of Infusion
    [709] = 424197, -- Dawn of the Infinite
    [710] = 432254, -- Vault of the Incarnates
    [711] = 432257, -- Abberus, the Shadowed Crucible
    [712] = 432258, -- Amirdrassil, the Dream's Hope
    [801] = 445416, -- City of Threads
    [802] = 445417, -- Ara-Kara, City of Echoes
    [803] = 445269, -- Stonevault
    [804] = 445414, -- Dawnbreaker
    [805] = 445443, -- The Rookery
    [806] = 445441, -- Darkflame Cleft
    [807] = 445440, -- Cinderbrew Brewery
    [808] = 445444, -- Priory of the Sacred Flame
    [809] = 1216786, -- Operation: Floodgate (Path of the Circuit Breaker)
    [810] = 1226482, -- Liberation of Undermine
    [811] = 1237215, -- Eco-Dome, Al'dani 
    [812] = 1239155, -- Manaforge Omega
    [901] = 1254572, -- Magisters' Terrace
    [902] = 1254559, -- Maisara Caverns
    [903] = 1254563, -- Nexus Point Xenas
    [904] = 1254400, -- Windrunner Spire
    [905] = 1286812, -- Altar of Fangs
    [906] = 1286807, -- Den of Nalorakk
    [907] = 1286801, -- Blinding Vale
    [908] = 1286804, -- Voidscar Arena
    [909] = 1286809, -- Murder Row
}

-- Export the constants
addon.constants_12 = {
    mapIDtoDungeonName = mapIDtoDungeonName,
    mapExpansionToMapID = mapExpansionToMapID,
    mapIDtoSpellID = mapIDtoSpellID,
    mapExpansionToBackground = mapExpansionToBackground,
    orderedExpansions = {
    "Current Season",
    "Wotlk",
    "Cataclysm",
    "Mists of Pandaria",
    "Warlords of Draenor",
    "Legion",
    "Battle for Azeroth",
    "Shadowlands",
    "Dragonflight",
    "The War Within",
    "Midnight"
}

}

-- =========================================================
-- Data selection: use 12.x dataset when running 12.0.0+
-- =========================================================
do
  local _, _, _, tocVersion = GetBuildInfo()
  if tocVersion and tocVersion >= 120100 and addon.constants_12 then
    addon.constants = addon.constants_12
  else
    addon.constants = addon.constants_legacy or addon.constants_12
  end
end
