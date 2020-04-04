PLUGIN.name = "Miscellaneous"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "Cool things such as auto-grenade callouts."
PLUGIN.SaveEnts = PLUGIN.SaveEnts or {}

--[[-------------------------------------------------------------------------
	Increases bar height
---------------------------------------------------------------------------]]
BAR_HEIGHT = 12

--[[-------------------------------------------------------------------------
	move settings to tab
---------------------------------------------------------------------------]]
if CLIENT then
	hook.Add("CreateMenuButtons", "ixSettings", function(tabs)
	tabs["settings"] = {
		Create = function(info, container)
			container:SetTitle(L("settings"))

			local panel = container:Add("ixSettings")
			panel:SetSearchEnabled(true)

			for category, options in SortedPairs(ix.option.GetAllByCategories(true)) do
				category = L(category)
				panel:AddCategory(category)

				-- sort options by language phrase rather than the key
				table.sort(options, function(a, b)
					return L(a.phrase) < L(b.phrase)
				end)

				for _, data in pairs(options) do
					local key = data.key
					local row = panel:AddRow(data.type, category)
					local value = ix.util.SanitizeType(data.type, ix.option.Get(key))

					row:SetText(L(data.phrase))
					row:Populate(key, data)

					-- type-specific properties
					if (data.type == ix.type.number) then
						row:SetMin(data.min or 0)
						row:SetMax(data.max or 10)
						row:SetDecimals(data.decimals or 0)
					end

					row:SetValue(value, true)
					row:SetShowReset(value != data.default, key, data.default)
					row.OnValueChanged = function()
						local newValue = row:GetValue()

						row:SetShowReset(newValue != data.default, key, data.default)
						ix.option.Set(key, newValue)
					end

					row.OnResetClicked = function()
						row:SetShowReset(false)
						row:SetValue(data.default, true)

						ix.option.Set(key, data.default)
					end

					row:GetLabel():SetHelixTooltip(function(tooltip)
						local title = tooltip:AddRow("name")
						title:SetImportant()
						title:SetText(key)
						title:SizeToContents()
						title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

						local description = tooltip:AddRow("description")
						description:SetText(L(data.description))
						description:SizeToContents()
					end)
				end
			end

			panel:SizeToContents()
			container.panel = panel
		end,

		OnSelected = function(info, container)
			container.panel.searchEntry:RequestFocus()
		end
	}
end)

hook.Add("PopulateScoreboardPlayerMenu", "ixAdmin", function(client, menu)
	--[[-------------------------------------------------------------------------
	WAY too lazy to convert this
	---------------------------------------------------------------------------]]
	local options = {}
	options["Set Name"] = {
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			if (IsValid(client) and LocalPlayer():IsAdmin()) then
				Derma_StringRequest("Change Character Name", "What do you want to change this character's name to?", client:Name(), function(text)
					ix.command.Send("CharSetName", client:Name(), text)
				end, nil, "Change", "Cancel")
			end
		end
	}

	options["Set Health"] = {
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			if (IsValid(client) and LocalPlayer():IsAdmin()) then
				Derma_StringRequest("Change Character Health", "What do you want to change their health to?", client:Health(), function(text)
					ix.command.Send("PlySetHP", client:Name(), text, "true") --Need to put ix.type.bools in quotes????
				end, nil, "Set", "Cancel")
			end
		end
	}

	options["Set Armor"] = {
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			if (IsValid(client) and LocalPlayer():IsAdmin()) then
				Derma_StringRequest("Change Character Armor", "What do you want to change their armor to?", client:Armor(), function(text)
					ix.command.Send("PlySetArmor", client:Name(), text, "true")
				end, nil, "Set", "Cancel")
			end
		end
	}

	options["Kick Player"] = {
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			if (IsValid(client) and LocalPlayer():IsAdmin()) then
				Derma_StringRequest("Kick Player", "Why do you want to kick them?", "", function(text)
					ix.command.Send("PlyKick", client:Name(), text)
				end, nil, "Kick", "Cancel")
			end
		end
	}

	options["Ban Player"] = {
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			if (IsValid(client) and LocalPlayer():IsAdmin()) then
				Derma_StringRequest("Ban Reason", "Why do you want to ban them?", "", function(text)
					--ix.command.Send("PlyBan", client:Name(), text)
					Derma_StringRequest("Ban Length","For how long do you want to ban them? 0 is permanent.","",function(text2) ix.command.Send("PlyBan", client:Name(), text2, text) end, nil)
				end, nil, "Ban", "Cancel")
			end
		end
	}

		options["Change Model"] = {
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			if (IsValid(client) and LocalPlayer():IsAdmin()) then
				Derma_StringRequest("Change Character Model", "What do you want to change this character's model to?", client:GetModel(), function(text)
					ix.command.Send("CharSetModel", client:Name(), text)
				end, nil, "Change", "Cancel")
			end
		end
	}

	options["Change Faction"] = {
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			local menu = vgui.Create("DFrame")
			menu:SetSize(ScrW() / 6, ScrH() / 3)
			menu:MakePopup()
			menu:Center()
			menu:SetTitle("Change Player Faction")
			local header = menu:Add("DLabel")
			header:Dock(TOP)
			header:SetText("Pick a faction to change them to.")
			header:SetTextInset(3, 0)
			header:SetFont("ixMediumFont")
			header:SetTextColor(color_white)
			header:SetExpensiveShadow(1, color_black)
			header:SetTall(28)

			header.Paint = function(this, w, h)
				surface.SetDrawColor(ix.config.Get("color"))
				surface.DrawRect(0, 0, w, h)
			end

			for k, v in pairs(ix.faction.indices) do
				local button = vgui.Create("DButton", menu)
				button:Dock(TOP)
				button:SetText(L(v.name))
				function button:DoClick()
					ix.command.Send("PlyTransfer", client:Name(), v.uniqueID)
				end
			end
		end
	}

		options["Give Item"] = {
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			local menu = vgui.Create("DFrame")
			menu:SetSize(ScrW() / 6, ScrH() / 3)
			menu:MakePopup()
			menu:Center()
			menu:SetTitle("Character Item Menu")
			local panel = menu:Add("DScrollPanel")
			panel:Dock(FILL)
			local header = panel:Add("DLabel")
			header:Dock(TOP)
			header:SetText("Use the box to search for an item.")
			header:SetTextInset(3, 0)
			header:SetFont("ixMediumFont")
			header:SetTextColor(color_white)
			header:SetExpensiveShadow(1, color_black)
			header:SetTall(25)

			header.Paint = function(this, w, h)
				surface.SetDrawColor(ix.config.Get("color"))
				surface.DrawRect(0, 0, w, h)
			end
			local entry = menu:Add("DTextEntry")
			entry:Dock(TOP)
			for k, v in SortedPairs(ix.item.list) do
				local button = vgui.Create("DButton", panel)
				button:Dock(TOP)
				button:SetSize(20,30)
				button:SetText(L(v.name))
				function button:DoClick()
					ix.command.Send("CharGiveItem", client:Name(), v.uniqueID, 1)
				end
				function button.Paint()
					surface.SetDrawColor(Color(200,200,200,255))
				end
				function button:Think()
					if string.len(entry:GetText()) < 1 then self:Show() return end
					if not string.find(v.name, entry:GetText()) then
						panel:SetVerticalScrollbarEnabled(true)
						panel:ScrollToChild(self)
					else
						panel:SetVerticalScrollbarEnabled(true)
						--panel:ScrollToChild()
					end
				end
			end
		end
	}
	for k, v in pairs(options) do
		menu:AddOption(k,v[1])
	end
end)

end

function PLUGIN:PlayerDeath(client, inflictor, attacker)
		if attacker:IsPlayer() then
			ix.log.AddRaw(client:Name() .. " was killed by " .. attacker:Name() .. " using " .. attacker:GetActiveWeapon():GetClass(), nil, Color(255,50,50))
		else
			ix.log.AddRaw(client:Name() .. " was killed by an " .. attacker:GetClass(), nil, Color(255,50,50))
		end
end

function PLUGIN:PlayerHurt(client, attacker, health, damage)
if attacker:IsPlayer() then
		ix.log.AddRaw(client:Name() .. " has taken " .. damage .. " damage from " .. attacker:Name() .. " using " .. attacker:GetActiveWeapon():GetClass() .. " leaving them at " .. health .. " HP!", nil, Color(255, 200, 0))
	else
		ix.log.AddRaw(client:Name() .. " has taken " .. math.floor(damage) .. " damage from " .. attacker:GetClass() .. " leaving them at " .. math.floor(health) .. " HP!", nil, Color(255, 200, 0))
	end
end

--[[-------------------------------------------------------------------------
	BETTER ADMIN ESP
---------------------------------------------------------------------------]]
local dimDistance = -1
ix.option.Add("itemESP", ix.type.bool, true)
ix.option.Add("anomESP", ix.type.bool, true)
ix.option.Add("vendorESP", ix.type.bool, true)
ix.option.Add("propESP", ix.type.bool, false)
	function PLUGIN:HUDPaint()
		local client = LocalPlayer()

		if (client:IsAdmin() and client:GetMoveType() == MOVETYPE_NOCLIP and not client:InVehicle() and ix.option.Get("observerESP", true)) then
			local scrW, scrH = ScrW(), ScrH()

			if ix.option.Get("itemESP") then
				for k, v in pairs(ents.GetAll()) do
					if v:GetClass() == "ix_item" then
						local espcol = Color(255,255,255,255)
						local screenPosition = v:GetPos():ToScreen()
						local marginX, marginY = scrH * .1, scrH * .1
						local x2, y2 = math.Clamp(screenPosition.x, marginX, scrW - marginX), math.Clamp(screenPosition.y, marginY, scrH - marginY)
						local distance = client:GetPos():Distance(v:GetPos())
						local factor = 1 - math.Clamp(distance / dimDistance, 0, 1)
						local size2 = math.max(10, 32 * factor)
						local alpha2 = math.max(255 * factor, 80)
						local itemTable = v:GetItemTable()
						local espcols = {
							["Weapons"] = Color(255,50,50),
							["Ammunition"] = Color(155,50,50),
							["Food"] = Color(100,255,100),
							["Crafting"] = Color(150,200,50),
							["Clothes"] = Color(65,200,150),
							["Attachments"] = Color(50,255,175),
							["Survival"] = Color(50,255,175)

						}

						for k2, v2 in pairs(espcols) do
							if itemTable.category == k2 then
								espcol = v2
							end
						end
						ix.util.DrawText(itemTable.name, x2, y2 - size2, espcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha2)
						--ix.util.DrawText(itemTable.category, x2, y2 - size2 + 15, espcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha2)
					end
				end
			end

			if ix.option.Get("anomESP") then
				for k, v in pairs(ents.GetAll()) do
					local class = v:GetClass()
					if (string.find(class, "anom_")) then
						local espcol = Color(255,255,255,255)
						local screenPosition = v:GetPos():ToScreen()
						local marginX, marginY = scrH * .1, scrH * .1
						local x2, y2 = math.Clamp(screenPosition.x, marginX, scrW - marginX), math.Clamp(screenPosition.y, marginY, scrH - marginY)
						local distance = client:GetPos():Distance(v:GetPos())
						local factor = 1 - math.Clamp(distance / dimDistance, 0, 1)
						local size2 = math.max(10, 32 * factor)
						local alpha2 = math.max(255 * factor, 80)

						ix.util.DrawText(class, x2, y2 - size2, espcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha2)
					end
				end
			end

			-- if ix.option.Get("vendorESP") then
			-- 	for k, v in pairs(ents.GetAll()) do
			-- 		if v:GetClass() == "ix_vendor" then
			-- 			local espcol = Color(255,255,255,255)
			-- 			local screenPosition = v:GetPos():ToScreen()
			-- 			local marginX, marginY = scrH * .1, scrH * .1
			-- 			local x2, y2 = math.Clamp(screenPosition.x, marginX, scrW - marginX), math.Clamp(screenPosition.y, marginY, scrH - marginY)
			-- 			local distance = client:GetPos():Distance(v:GetPos())
			-- 			local factor = 1 - math.Clamp(distance / dimDistance, 0, 1)
			-- 			local size2 = math.max(10, 32 * factor)
			-- 			local alpha2 = math.max(255 * factor, 80)
			-- 			local name = "[Vendor] " .. v:GetNetVar("name")
			-- 			ix.util.DrawText(name, x2, y2 - size2, espcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha2)
			-- 		end
			-- 	end
			-- end

			if ix.option.Get("propESP") then
				for k, v in pairs(ents.GetAll()) do
					if v:GetClass() == "prop_physics" then
						local espcol = Color(255,255,255,255)
						local screenPosition = v:GetPos():ToScreen()
						local marginX, marginY = scrH * .1, scrH * .1
						local x2, y2 = math.Clamp(screenPosition.x, marginX, scrW - marginX), math.Clamp(screenPosition.y, marginY, scrH - marginY)
						local distance = client:GetPos():Distance(v:GetPos())
						local factor = 1 - math.Clamp(distance / dimDistance, 0, 1)
						local size2 = math.max(10, 32 * factor)
						local alpha2 = math.max(255 * factor, 80)
						local name = v:GetModel()
						ix.util.DrawText(name, x2, y2 - size2, espcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha2)
					end
				end
			end

			for _, v in ipairs(player.GetAll()) do
				if (v == client or not v:GetCharacter()) then continue end
				local screenPosition = v:GetPos():ToScreen()
				local marginX, marginY = scrH * .1, scrH * .1
				local x, y = math.Clamp(screenPosition.x, marginX, scrW - marginX), math.Clamp(screenPosition.y, marginY, scrH - marginY)
				local teamColor = team.GetColor(v:Team())
				local distance = client:GetPos():Distance(v:GetPos())
				local factor = 1 - math.Clamp(distance / dimDistance, 0, 1)
				local size = math.max(10, 32 * factor)
				local alpha = math.max(255 * factor, 80)
				surface.SetDrawColor(teamColor.r, teamColor.g, teamColor.b, alpha)
				surface.SetFont("ixGenericFont")
				local text = v:Name()

				--tables are for faggots.
				if not v.status then
					v.status = "user"
				elseif v:IsUserGroup("superadmin") then
					v.status = "SA"
				elseif v:IsUserGroup("admin") then
					v.status = "A"
				elseif v:IsUserGroup("operator") then
					v.status = "O"
				elseif v:IsUserGroup("user") then
					v.status = "user"
				elseif v:IsUserGroup("producer") then
					v.status = "producer"
				else
					v.status = v:GetUserGroup()
				end

				local text2 = v:SteamName() .. "[" .. v.status .. "]"
				local text3 = "H: " .. v:Health() .. " A: " .. v:Armor()
				local text4 = v:GetActiveWeapon().PrintName
				surface.SetDrawColor(teamColor.r * 1.6, teamColor.g * 1.6, teamColor.b * 1.6, alpha)
				local col = Color(255, 255, 255, 255)

				if v:IsWepRaised() then
					col = Color(255, 100, 100, 255)
				end

				ix.util.DrawText(text, x, y - size, ColorAlpha(teamColor, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
				ix.util.DrawText(text2, x, y - size + 20, Color(200, 200, 200, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
				ix.util.DrawText(text3, x, y - size + 40, Color(200, 200, 200, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
				ix.util.DrawText(text4, x, y - size + 60, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
			end
		end
	end

local playerMeta = FindMetaTable("Player")

--[[-------------------------------------------------------------------------
	playerMeta:GetItemWeapon()

	Purpose: Checks the player's currently equipped weapon and returns the item and weapon.
	Syntax: player:GetItemWeapon()
	Returns: @weapon, @item
---------------------------------------------------------------------------]]

function playerMeta:GetItemWeapon()
	local char = self:GetCharacter()
	local inv = char:GetInventory()
	local items = inv:GetItems()
	local weapon = self:GetActiveWeapon()

	for k, v in pairs(items) do
		if v.class then
			if v.class == weapon:GetClass() and v:GetData("equip", false) then
				return weapon, v
			else
				return false
			end
		end
	end
end


if SERVER then

--[[-------------------------------------------------------------------------
NAME: ADMIN CHAT
CREATOR: TACO
DESC: ADMIN CHAT
---------------------------------------------------------------------------]]
	ix.chat.Register("adminchat", {
		format = "whocares",
		--font = "nutRadioFont",
		OnGetColor = function(self, speaker, text)
			return Color(0, 196, 255)
		end,
		OnCanHear = function(self, speaker, listener)
			if listener:IsAdmin() then
				return true
			end

			return false
		end,
		OnCanSay = function(self, speaker, text)

			if not speaker:IsAdmin() then
				speaker:Notify("You aren't an admin.")
			end

			--speaker.NextAR = ix.config.Get("arequestinterval")

			return true
		end,
		OnChatAdd = function(self, speaker, text)
			local color = team.GetColor(speaker:Team())
			chat.AddText(Color(100, 255, 100), "[ADMIN] ", color, speaker:Name() .. " (" .. speaker:SteamName() .. ")", ": ", Color(255, 255, 255), text)
		end,
		prefix = "/a"
	})

	function PLUGIN:PlayerSay(client, text)
		local chatType, message = ix.chat.Parse(client, text, true)
		if (chatType == "ic") and (string.sub(text, 1, 1) == "@") and client:IsAdmin() then
			message = string.gsub(message, "@", "", 1)
			print(message)
			serverguard.command.Run(client, "a", false, message)
			return false
		end
	end
end

ix.chat.Register("adminrequest", {
	format = "whocares",
	--font = "nutRadioFont",
	OnGetColor = function(self, speaker, text)
		return Color(0, 196, 255)
	end,
	OnCanHear = function(self, speaker, listener)
		if listener:IsAdmin() or listener == speaker then
			return true
		end

		return false
	end,
	OnChatAdd = function(self, speaker, text)
		local color = team.GetColor(speaker:Team())
		local whitelist = {"STEAM_1:0:17704583", "STEAM_0:1:34297953", "STEAM_1:1:53007042"}
		if LocalPlayer():IsAdmin() or speaker == LocalPlayer() then
			chat.AddText(Color(225, 50, 50, 255), "[REPORT] ", Color(190, 90, 90), speaker:Name(), color, " (", speaker:SteamName(), "): ", Color(255, 255, 255, 255), text)
		end
		if CLIENT then
			for k, v in pairs(player.GetAll()) do
				if table.HasValue(whitelist, v:SteamID()) then
					--print("you will not receive an alert")
					--print("you will receive an alert")
					return
				else
					if not LocalPlayer().nextbellproc or LocalPlayer().nextbellproc <= CurTime() then
						surface.PlaySound("hl1/fvox/bell.wav")
						LocalPlayer().nextbellproc = CurTime() + 5
					end
				end
			end
		end
	end
})
ix.command.Add("ar", {
	syntax = "<string message>",
	description = "Send a message to the admins.",
	OnRun = function(self, client, arguments)
		local text = table.concat(arguments, " ")
		local admintable = {}

		if client:IsAdmin() then
			client:Notify("You are an admin, use admin chat instead... idiot.")

			return
		end

		--[[if client.NextAR and client.NextAR > CurTime() then
			client:Notify("You cannot use admin request yet!")

			return false
		end--]]

		--client.NextAR = ix.config.Get("arequestinterval")
		ix.chat.Send(client, "adminrequest", text)

		for k, v in pairs(player.GetAll()) do
			if v:IsAdmin() then
				table.insert(admintable, v:Name())
			end
		end

		ix.log.AddRaw(client:Name() .. " requested an admin: " .. text .. " Admins Online: " .. table.concat(admintable, ", "))

		return true
	end
})