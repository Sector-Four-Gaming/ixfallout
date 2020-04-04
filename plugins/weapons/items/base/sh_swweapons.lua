ITEM.name = "Weapon"
ITEM.description = "A Weapon."
ITEM.category = "Weapons"
ITEM.model = "models/weapons/w_pistol.mdl"
ITEM.class = "weapon_pistol"
ITEM.width = 2
ITEM.height = 2
ITEM.isWeapon = true
ITEM.isGrenade = false
ITEM.busflag = {"dev"}
ITEM.weaponCategory = "sidearm"
ITEM.equipIcon = Material("materials/vgui/ui/stalker/misc/equip.png")
ITEM.longdesc = "No longer description available."
ITEM.Range = 0
ITEM.RoF = ""
ITEM.Dmg = ""
ITEM.Pen = 0
ITEM.Mag = 0
ITEM.Rld = ""
ITEM.Special = ""


-- Attachment translator
local attachments = {}
attachments["swrp_dh17_scope"] = {name = "DH-17 Scope", slot = 1, uID = "dh17scope"}

-- Inventory drawing
if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		//Equipsquare
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 255)
			--surface.DrawRect(w - 14, h - 14, 8, 8)
		else
			surface.SetDrawColor(255, 110, 110, 255)
		end

		surface.SetMaterial(item.equipIcon)
		surface.DrawTexturedRect(w-23,h-23,19,19)

		//Attachment Icons
		local iterator = 1
		if item:GetData("attachments") then
			for k, v in pairs(item:GetData("attachments")) do
				surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
				if ix.item.list[v[1]].upgradeIcon then
					surface.SetMaterial(ix.item.list[v[1]].upgradeIcon)
				end
				surface.DrawTexturedRect(w-2-(22*iterator),4,19,19)
				iterator = iterator + 1
			end
		end
	end

	function ITEM:PopulateTooltip(tooltip)
		if (self:GetData("equip")) then
			local name = tooltip:GetRow("name")
			name:SetBackgroundColor(derma.GetColor("Success", tooltip))
		end
	end
end

function ITEM:GetDescription()
	local str = self.description.." \n\n"..self.longdesc

	local customData = self:GetData("custom", {})
	if(customData.desc) then
		str = customData.desc
	end

	if (!self.entity) then
		local client = self:GetOwner()
		
		if client == nil then
			return self.description
		end
		
		local weapon = client:GetActiveWeapon()
		local SWEP = weapons.Get(self.class)
		local atts = SWEP.Attachments
		local activeAtts = self:GetData("attachments",{})
		
		str = str.."\n\nAttachments Available: \n"
		
		for atcat, data in pairs(atts) do
			if data.atts then
				for k, name in pairs(data.atts) do
					if attachments[name] then
						local attName = attachments[name]["name"]
						str = str..attName
						for x,y in pairs(activeAtts) do
							local attTable = ix.item.list[y[1]]
							local niceName = attTable:GetName()
							if attName == niceName then
								str = str.." ✓"
							end
						end
						str = str.."\n"
					end
				end
			end
        end
	end
end

ITEM:Hook("drop", function(item)
	local inventory = ix.item.inventories[item.invID]

	if (!inventory) then
		return
	end

	-- the item could have been dropped by someone else (i.e someone searching this player), so we find the real owner
	local owner

	for client, character in ix.util.GetCharacters() do
		if (character:GetID() == inventory.owner) then
			owner = client
			break
		end
	end

	if (!IsValid(owner)) then
		return
	end

	if (item:GetData("equip")) then
		item:SetData("equip", nil)

		owner.carryWeapons = owner.carryWeapons or {}

		local weapon = owner.carryWeapons[item.weaponCategory]

		if (!IsValid(weapon)) then
			weapon = owner:GetWeapon(item.class)
		end

		if (IsValid(weapon)) then
			owner:StripWeapon(item.class)
			owner.carryWeapons[item.weaponCategory] = nil
		end
	end
end)

-- On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/cross.png",
	OnRun = function(item)
		item:Unequip(item.player, true)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

-- On player eqipped the item, Gives a weapon to player and load the ammo data from the item.
ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/tick.png",
	OnRun = function(item)
		item:Equip(item.player)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and
			hook.Run("CanPlayerEquipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

function ITEM:Equip(client)
	local items = client:GetCharacter():GetInventory():GetItems()

	client.carryWeapons = client.carryWeapons or {}

	for _, v in pairs(items) do
		if (v.id != self.id) then
			local itemTable = ix.item.instances[v.id]

			if (!itemTable) then
				client:NotifyLocalized("tellAdmin", "wid!xt")

				return false
			else
				if (itemTable.isWeapon and client.carryWeapons[self.weaponCategory] and itemTable:GetData("equip")) then
					client:NotifyLocalized("weaponSlotFilled", self.weaponCategory)

					return false
				end
			end
		end
	end

	if (client:HasWeapon(self.class)) then
		client:StripWeapon(self.class)
	end

	local weapon = client:Give(self.class, !self.isGrenade)

	if (IsValid(weapon)) then
		local ammoType = weapon:GetPrimaryAmmoType()

		client.carryWeapons[self.weaponCategory] = weapon
		client:SelectWeapon(weapon:GetClass())

		if (weapon:GetMaxClip1() == -1 and weapon:GetMaxClip2() == -1 and client:GetAmmoCount(ammoType) == 0) then
			client:SetAmmo(1, ammoType)
		end
		
		self:SetData("equip", true)

		if (self.isGrenade) then
			weapon:SetClip1(1)
			client:SetAmmo(0, ammoType)
		end

		weapon.ixItem = self

		if (self.OnEquipWeapon) then
			self:OnEquipWeapon(client, weapon)
		end
	else
		print(Format("[Helix] Cannot equip weapon - %s does not exist!", self.class))
	end
end

function ITEM:OnEquipWeapon(client, weapon)
    local attList = {}   
	local atts = self:GetData("attachments")
	local ammotype = self:GetData("ammoType", "Normal")
	
    if (atts) then
        for k, v in pairs(atts) do
            table.insert(attList, v[2])
        end
    end
	
    timer.Simple(0.1, function()
		if (IsValid(weapon)) then
    		for _, b in ipairs(attList) do
    			weapon:Attach(b)
    		end
    	end
    end)
end

function ITEM:OnInstanced(invID, x, y)
end

function ITEM:Unequip(client, bPlaySound, bRemoveItem)
	client.carryWeapons = client.carryWeapons or {}

	local weapon = client.carryWeapons[self.weaponCategory]

	if (!IsValid(weapon)) then
		weapon = client:GetWeapon(self.class)
	end

	if (IsValid(weapon)) then
		weapon.ixItem = nil
		client:StripWeapon(self.class)
	else
		print(Format("[Helix] Cannot unequip weapon - %s does not exist!", self.class))
	end

	client.carryWeapons[self.weaponCategory] = nil
	self:SetData("equip", nil)

	if (self.OnUnequipWeapon) then
		self:OnUnequipWeapon(client, weapon)
	end

	if (bRemoveItem) then
		self:Remove()
	end
end

function ITEM:CanTransfer(oldInventory, newInventory)
	if (newInventory and self:GetData("equip")) then
		local owner = self:GetOwner()

		if (IsValid(owner)) then
			owner:NotifyLocalized("equippedWeapon")
		end

		return false
	end

	return true
end

function ITEM:OnLoadout()
	if (self:GetData("equip")) then
		local client = self.player
		client.carryWeapons = client.carryWeapons or {}

		local weapon = client:Give(self.class)

		if (IsValid(weapon)) then
			client:RemoveAmmo(weapon:Clip1(), weapon:GetPrimaryAmmoType())
			client.carryWeapons[self.weaponCategory] = weapon

			local attList = {}
			local attachments = self:GetData("attachments")

			if (attachments) then
				for k, v in pairs(attachments) do
					table.insert(attList, v[2])
				end
			end

			timer.Simple(0.1, function()
				if (IsValid(weapon)) then
					for _, b in ipairs(attList) do
						weapon:Attach(b)
					end
				end
			end)

			weapon.ixItem = self
		else
			print(Format("[Helix] Cannot give weapon - %s does not exist!", self.class))
		end
	end
end

function ITEM:OnRemoved()
	local inventory = ix.item.inventories[self.invID]
	local owner = inventory.GetOwner and inventory:GetOwner()

	if (IsValid(owner) and owner:IsPlayer()) then
		local weapon = owner:GetWeapon(self.class)

		if (IsValid(weapon)) then
			weapon:Remove()
		end
	end
end

ITEM.functions.Detach = {
	name = "Detach",
	tip = "Detach",
	icon = "icon16/wrench.png",
    isMulti = true,
    multiOptions = function(item, client)
	
	local targets = {}

	for k, v in pairs(item:GetData("attachments", {})) do
		local attTable = ix.item.list[v[1]]
		local niceName = attTable:GetName()
		table.insert(targets, {
			name = niceName,
			data = {k},
		})
    end
    return targets
end,
	OnCanRun = function(item)
		if (table.Count(item:GetData("attachments", {})) <= 0) then
			return false
		end
				
		return (!IsValid(item.entity))
	end,
	OnRun = function(item, data)
		local client = item.player
		if (data) then
			local char = client:GetChar()

			if (char) then
				local inv = char:GetInv()

				if (inv) then
					local mods = item:GetData("attachments", {})
					local attData = mods[data[1]]
					if (attData) then
					    
						inv:Add(attData[1])

				        local wepon = client:GetActiveWeapon()
				        
						if (IsValid(wepon) and wepon:GetClass() == item.class) then
						    for category, data in pairs(wepon.Attachments) do
						        for key, attachment in ipairs(data.atts) do
						            if attachment == attData[2] then
						                wepon:Detach(attData[2])
						                break
						            end
					            end
				            end
						end
						mods[data[1]] = nil
						item:SetData("attachments", mods)
						
						curPrice = item:GetData("RealPrice")
                	    if !curPrice then
                		    curPrice = item.price
                		end
                        item:SetData("RealPrice", (curPrice - ix.item.list[attData[1]].price))
                        
                        local itemweight = item:GetData("weight",0)
                        local targetweight = ix.item.list[attData[1]].weight
                        local totweight = itemweight - targetweight
                        item:SetData("weight", totweight)
					else
						client:NotifyLocalized("notAttachment")
					end
				end
			end
		else
			client:NotifyLocalized("detTarget")
		end
	return false
end,
}

hook.Add("PlayerDeath", "ixStripClip", function(client)
	client.carryWeapons = {}

	for _, v in pairs(client:GetCharacter():GetInventory():GetItems()) do
		if (v.isWeapon and v:GetData("equip")) then
			v:SetData("equip", nil)
		end
	end
end)