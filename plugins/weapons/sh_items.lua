local WEAPONS = {}
local ATTACHMENTS = {}

WEAPONS.weapon_acrc = {
	["name"] = "ACR-C",
	["model"] = "models/weapons/w_acrc.mdl",
	["description"] = "",
	["flag"] = "1",
	["weight"] = 3.0,
	["width"] = 2,
	["height"] = 1,
	["price"] = 850,
	["class"] = "tfa_ins2_acrc",
	["weaponCategory"] = "primary"
}

-- ATTACHMENTS
-- Slots
-- 1 = Optics
-- 2 = Barrels
-- 3 = Stocks
-- 4 = Ammo Conversions
-- 5 = Foregrips
-- 6 = Magazines
-- 7 = Skins
-- 8 = Bipods


ATTACHMENTS.att_optic_eotech = {
	["name"] = "EOTech 552",
	["model"] = "models/props_junk/cardboard_box004a.mdl",
	["description"] = "",
	["flag"] = "1",
	["weight"] = 3.0,
	["width"] = 1,
	["height"] = 1,
	["price"] = 600,
	["attSearch"] = { "ins2_si_eotech", },
	["slot"] = 1
}

ATTACHMENTS.att_optic_2xrds = {
	["name"] = "Aimpoint CompM2 2X",
	["model"] = "models/props_junk/cardboard_box004a.mdl",
	["description"] = "",
	["flag"] = "1",
	["weight"] = 3.0,
	["width"] = 1,
	["height"] = 1,
	["price"] = 600,
	["attSearch"] = { "ins2_si_2xrds", },
	["slot"] = 1
}

ATTACHMENTS.att_optic_mx4 = {
	["name"] = "MX4 Scope",
	["model"] = "models/props_junk/cardboard_box004a.mdl",
	["description"] = "",
	["flag"] = "1",
	["weight"] = 3.0,
	["width"] = 1,
	["height"] = 1,
	["price"] = 600,
	["attSearch"] = { "ins2_si_mx4", },
	["slot"] = 1
}

ATTACHMENTS.att_grip_fore = {
	["name"] = "Foregrip",
	["model"] = "models/props_junk/cardboard_box004a.mdl",
	["description"] = "",
	["flag"] = "1",
	["weight"] = 3.0,
	["width"] = 1,
	["height"] = 1,
	["price"] = 600,
	["attSearch"] = { "ins2_fg_grip", },
	["slot"] = 3
}


-- DO NOT EDIT BELOW

for k, v in pairs(WEAPONS) do
	local ITEM = ix.item.Register(k, "base_swweapons", false, nil, true)
	ITEM.name = v.name
	ITEM.model = v.model or "models/props_junk/cardboard_box001a.mdl"
	ITEM.description = v.description or "Insert Description Here"
	ITEM.category = "Weapons"
	ITEM.price = v.price or 100000000
	ITEM.weight = v.weight or 100000000
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
	ITEM.class = v.class
	ITEM.weaponCategory = v.weaponCategory
	ITEM.isWeapon = true
	ITEM.isPLWeapon = true
	ITEM.isTFA = true
	ALWAYS_RAISED[v.class] = true
end

for k, v in pairs(ATTACHMENTS) do
	local ITEM = ix.item.Register(k, "base_swattachments", false, nil, true)
	ITEM.name = v.name
	ITEM.model = v.model or "models/props_junk/cardboard_box001a.mdl"
	ITEM.description = v.description or "Insert Description Here"
	ITEM.category = "Weapon Attachments"
	ITEM.price = v.price or 100000000
	ITEM.weight = v.weight or 100000000
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
	ITEM.isAttachment = true
	ITEM.slot = v.slot
	ITEM.attSearch = v.attSearch
end