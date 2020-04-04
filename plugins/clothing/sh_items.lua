-- 	Default Slots
-- head
-- eyewear
-- mouthwear
-- neck
-- shoulders
-- back
-- torso
-- chestrig
-- gloves
-- legs
-- legwear
-- overlay

local CLOTHING = {}

CLOTHING.headgear_radsuit_visor = {
	["name"] = "Radiation Visor Helmet (Standard)",
	["model"] = "models/props_junk/cardboard_box004a.mdl",
	["description"] = "This does not provide sufficient protection from the Zone's harsh conditions.",
	["flag"] = "2",
	["weight"] = 2,
	["ap"] = 5,
	["width"] = 2,
	["height"] = 2,
	["price"] = 500,
	["bmSlot"] = "head",
	["bmModel"] = "models/projectpt/headwear_radsuit_visor.mdl"
}

CLOTHING.headgear_pracs = {
	["name"] = "Pracs Helmet (Standard)",
	["model"] = "models/props_junk/cardboard_box004a.mdl",
	["description"] = "A Western model of a tactical helmet that lacks camouflage. It is not known how it made its way into the Zone. Comes with multi-layered Kevlar protection and armored elements to protect electronic components.",
	["flag"] = "2",
	["weight"] = 2,
	["ap"] = 5,
	["width"] = 2,
	["height"] = 2,
	["price"] = 500,
	["bmSlot"] = "head",
	["bmModel"] = "models/projectpt/headwear_pracs.mdl"
}

CLOTHING.backpack_hiking = {
	["name"] = "Hiking Backpack (Standard)",
	["model"] = "models/props_junk/cardboard_box004a.mdl",
	["description"] = "A lightweight backpack for hiking.",
	["flag"] = "2",
	["weight"] = 2,
	["ap"] = 5,
	["width"] = 2,
	["height"] = 2,
	["price"] = 500,
	["weightInc"] = 50,
	["bmSlot"] = "backpack",
	["bmModel"] = "models/projectpt/backpack_hiking.mdl"
}

CLOTHING.backpack_rucksack = {
	["name"] = "Rucksack Backpack (Standard)",
	["model"] = "models/props_junk/cardboard_box004a.mdl",
	["description"] = "A medium-weight backpack.",
	["flag"] = "2",
	["weight"] = 2,
	["ap"] = 5,
	["width"] = 2,
	["height"] = 2,
	["price"] = 500,
	["weightInc"] = 25,
	["bmSlot"] = "backpack",
	["bmModel"] = "models/projectpt/backpack_rucksack.mdl"
}

CLOTHING.outfit_anorak = {
	["name"] = "Anorak (Standard)",
	["model"] = "models/props_junk/cardboard_box004a.mdl",
	["description"] = "This does not provide sufficient protection from the Zone's harsh conditions.",
	["flag"] = "2",
	["weight"] = 2,
	["ap"] = 5,
	["width"] = 2,
	["height"] = 2,
	["price"] = 500,
	["bmSlot"] = "torso",
	["bmModel"] = "models/projectpt/suits/male_anorak.mdl"
}

CLOTHING.outfit_berill = {
	["name"] = "Berill (Standard)",
	["model"] = "models/props_junk/cardboard_box004a.mdl",
	["description"] = "This item comprises military PS5 series body armor with beryllium sputter modified for use in the Zone. Designed for assault operations in highly radioactive areas, it is ineffective in areas of high anomalous activity. The suit makes its way to stalkers through the military, who exchange it for loot.",
	["flag"] = "2",
	["weight"] = 2,
	["ap"] = 5,
	["width"] = 2,
	["height"] = 2,
	["price"] = 500,
	["bmSlot"] = "torso",
	["bmModel"] = "models/projectpt/suits/male_berill.mdl"
}

CLOTHING.outfit_cs2 = {
	["name"] = "CS-2 body Armor (Standard)",
	["model"] = "models/props_junk/cardboard_box004a.mdl",
	["description"] = "The CS-2 consists of a military bulletproof vest with a load bearing vest over it. It is carried over a sky blue/white camouflage jacket with metal elbow pads and dark pants with metal kneepads and hiking boots.",
	["flag"] = "2",
	["weight"] = 2,
	["ap"] = 5,
	["width"] = 2,
	["height"] = 2,
	["price"] = 500,
	["bmSlot"] = "torso",
	["bmModel"] = "models/projectpt/suits/male_cs2.mdl"
}

CLOTHING.outfit_cs3 = {
	["name"] = "CS-3a body Armor (Standard)",
	["model"] = "models/props_junk/cardboard_box004a.mdl",
	["description"] = "This body armor was designed for conducting search operations in areas of low anomalous activity. Its higher quality materials result in greater durability.",
	["flag"] = "2",
	["weight"] = 2,
	["ap"] = 5,
	["width"] = 2,
	["height"] = 2,
	["price"] = 500,
	["bmSlot"] = "torso",
	["bmModel"] = "models/projectpt/suits/male_cs3.mdl"
}

CLOTHING.outfit_radsuit = {
	["name"] = "Radiation Suit (Standard)",
	["model"] = "models/props_junk/cardboard_box004a.mdl",
	["description"] = "The jumpsuit itself consists of a battle dress uniform (colour and camo pattern varies from faction to faction) reinforced with armoured plates protecting the limbs of the user. They are typically worn with armoured, heavy boots and thick gloves.",
	["flag"] = "2",
	["weight"] = 2,
	["ap"] = 5,
	["width"] = 2,
	["height"] = 2,
	["price"] = 500,
	["bmSlot"] = "torso",
	["bmModel"] = "models/projectpt/suits/male_radsuit.mdl"
}

CLOTHING.outfit_skat = {
	["name"] = "Skat-9M Military Armoured Suit (Standard)",
	["model"] = "models/props_junk/cardboard_box004a.mdl",
	["description"] = "Designed for assault operations in areas of anomalous activity. It includes a PSZ-12p heavy military bulletproof suit, an integrated compensation suit and a Sphere-12M helmet. It provides perfect protection from bullets and splinters and it doesn't decrease the soldier's mobility. It has a balanced system of anomaly protection.",
	["flag"] = "2",
	["weight"] = 2,
	["ap"] = 5,
	["width"] = 2,
	["height"] = 2,
	["price"] = 500,
	["bmSlot"] = "torso",
	["bmModel"] = "models/projectpt/suits/male_skat.mdl"
}

CLOTHING.outfit_ssp = {
	["name"] = "SSP-99 (Standard)",
	["model"] = "models/props_junk/cardboard_box004a.mdl",
	["description"] = "High quality modified SSP-99 suit. It provides increased body protection from bullet and splinter damage. It is designed for the guards working with scientific expeditions. It provides good protection from radiation and biological anomalies. It is resistant to chemically aggressive environments and other effects dangerous to the body.",
	["flag"] = "2",
	["weight"] = 2,
	["ap"] = 5,
	["width"] = 2,
	["height"] = 2,
	["price"] = 500,
	["bmSlot"] = "torso",
	["bmModel"] = "models/projectpt/suits/male_ssp.mdl"
}

CLOTHING.outfit_sunrise = {
	["name"] = "Sunrise (Standard)",
	["model"] = "models/props_junk/cardboard_box004a.mdl",
	["description"] = "This DIY stalker bodysuit is a combination of a bodysuit of twin-layered rubberized cloth with plexiglass lining and built-in body armor. Despite the fact that the body armor is incapable of protecting the wearer from even pistol bullets, the suit enjoys great popularity due to its low cost and modification potential.",
	["flag"] = "2",
	["weight"] = 2,
	["ap"] = 5,
	["width"] = 2,
	["height"] = 2,
	["price"] = 500,
	["bmSlot"] = "torso",
	["bmModel"] = "models/projectpt/suits/male_sunrise.mdl"
}

CLOTHING.outfit_trader = {
	["name"] = "Trader Suit (Standard)",
	["model"] = "models/props_junk/cardboard_box004a.mdl",
	["description"] = "This does not provide sufficient protection from the Zone's harsh conditions.",
	["flag"] = "2",
	["weight"] = 2,
	["ap"] = 5,
	["width"] = 2,
	["height"] = 2,
	["price"] = 500,
	["bmSlot"] = "torso",
	["bmModel"] = "models/projectpt/suits/male_trader.mdl"
}

CLOTHING.outfit_winter = {
	["name"] = "Winter Suit (Standard)",
	["model"] = "models/props_junk/cardboard_box004a.mdl",
	["description"] = "This does not provide sufficient protection from the Zone's harsh conditions.",
	["flag"] = "2",
	["weight"] = 2,
	["ap"] = 5,
	["width"] = 2,
	["height"] = 2,
	["price"] = 500,
	["bmSlot"] = "torso",
	["bmModel"] = "models/projectpt/suits/male_wintersuit.mdl"
}

-- Clothing Upgrade Items
local UPGRADES = {}

-- UPGRADES.attachment_headgear_armytrooper_visorup = {
-- 	["name"] = "Army Trooper Goggles (Up)",
-- 	["model"] = "models/stardust/props/container_closed.mdl",
-- 	["description"] = "",
-- 	["ap"] = 1,
-- 	["flag"] = "2",
-- 	["weight"] = 0.25,
-- 	["width"] = 1,
-- 	["height"] = 1,
-- 	["price"] = 200,
-- 	["bgnames"] = {"Visor"},
-- 	["models"] = {"models/stardust/outfits/headgear_armytrooper.mdl", "models/stardust/outfits/headgear_armytrooper_black.mdl", "models/stardust/outfits/headgear_armytrooper_green.mdl", "models/stardust/outfits/headgear_armytrooper_white.mdl"},
-- 	["slot"] = 1,
-- 	["bgy"] = 1,
-- }

-- DO NOT TOUCH BELOW IT ADDS THE ITEMS TO THE SCHEMA

for k, v in pairs(CLOTHING) do
	local ITEM = ix.item.Register(k, "base_bmclothing", false, nil, true)
	ITEM.name = v.name
	ITEM.model = v.model or "models/stardust/props/container_closed.mdl"
	ITEM.description = v.description or "Insert Description Here"
	ITEM.category = "Clothing"
	ITEM.ap = v.ap or 0
	ITEM.price = v.price or 100000000
	ITEM.weight = v.weight or 100000000
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
	ITEM.bmSlot = v.bmSlot
	ITEM.bmModel = v.bmModel
	ITEM.bmSkin = v.bmSkin or 0
	ITEM.weightInc = v.weightInc or 0
end

for k, v in pairs(UPGRADES) do
	local ITEM = ix.item.Register(k, "base_bmupgrades", false, nil, true)
	ITEM.name = v.name
	ITEM.model = v.model or "models/stardust/props/container_closed.mdl"
	ITEM.description = v.description or "Insert Description Here"
	ITEM.category = "Clothing Upgrades"
	ITEM.ap = v.ap or 0
	ITEM.price = v.price or 100000000
	ITEM.weight = v.weight or 100000000
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
	ITEM.bmSlot = v.bmSlot or nil
	ITEM.bgnames = v.bgnames or nil
	ITEM.bgy = v.bgy or 0
	ITEM.models = v.models or nil
	ITEM.slot = v.slot or 0
end