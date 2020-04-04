ITEM.name = "Radio"
ITEM.model = "models/hgn/srp/items/radio.mdl"
ITEM.desc = "A radio, for short range communications."
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Communication"
ITEM.uniqueID = "radio"
ITEM.price = 275
ITEM.flag = "a"
ITEM.quantity = 1
ITEM.weight = 0.2

local function getText(togga)
	if (togga) then
		return "<color=39, 174, 96>" .. L"on" .. "</color>"
	else
		return "<color=192, 57, 43>" .. L"off" .. "</color>"
	end
end

function ITEM:GetDesc()	
	if (!self.entity or !IsValid(self.entity)) then
		return L("A radio, for short range communications.", getText(self:GetData("power")), self:GetData("freq", "000.0"))
	else
		local data = self.entity:GetData()
		
		return L("A radio, for short range communications.", (self.entity:GetData("power") and "On" or "Off"), self.entity:GetData("freq", "000.0"))
	end
end


if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("power", false)) then
			surface.SetDrawColor(110, 255, 110, 100)
		else
			surface.SetDrawColor(255, 110, 110, 100)
		end

		surface.DrawRect(w - 14, h - 14, 8, 8)
	end

	local GLOW_MATERIAL = Material("sprites/glow04_noz.vmt")
	local COLOR_ACTIVE = Color(0, 255, 0)
	local COLOR_INACTIVE = Color(255, 0, 0)

	function ITEM:DrawEntity(entity, item)
		entity:DrawModel()
		local rt = RealTime()*100
		local position = entity:GetPos() + entity:GetForward() * 0 + entity:GetUp() * 2 + entity:GetRight() * 0

		if (entity:GetData("power", false) == true) then
			if (math.ceil(rt/14)%10 == 0) then
				render.SetMaterial(GLOW_MATERIAL)
				render.DrawSprite(position, rt % 14, rt % 14, entity:GetData("power", false) and COLOR_ACTIVE or COLOR_INACTIVE)
			end
		end
	end
end

// On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.toggle = { -- sorry, for name order.
	name = "Toggle",
	tip = "useTip",
	icon = "icon16/connect.png",
	OnRun = function(item)
		item:SetData("power", !item:GetData("power", false), nil, nil)
		item.player:EmitSound("buttons/button14.wav", 70, 150)

		return false
	end,
}

ITEM.functions.use = { -- sorry, for name order.
	name = "Freq",
	tip = "useTip",
	icon = "icon16/wrench.png",
	OnRun = function(item)
		netstream.Start(item.player, "radioAdjust", item:GetData("freq", "000,0"), item.id)

		return false
	end,
}

ITEM.functions.Sell =
{
	
	name = "Sell",
	tip = "Sells Item",
	icon = "icon16/money.png",
	
	OnRun = function(item)
		local player = item.player;
		local character = player:GetChar();
		local modifier = 3.00
		
		if (item.flag == "a" or item.flag == "C" or item.flag == "g" or item.flag == "I") then
			modifier = ix.config.Get("Tier 1 Export")
		elseif (item.flag == "A" or item.flag == "d" or item.flag == "G" or item.flag == "j") then
			modifier = ix.config.Get("Tier 2 Export")
		elseif (item.flag == "b" or item.flag == "D" or item.flag == "h" or item.flag == "J") then
			modifier = ix.config.Get("Tier 3 Export")
		else
			modifier = ix.config.Get("Tier 4 Export")
		end
		
		modifier = 1.00 - (modifier * 0.01)

		local saleprice = math.Round((item.price*modifier))
		character:GiveMoney(saleprice);
		item:Remove()
		player:NotifyLocalized("Item sold for " .. (saleprice))
		return false
	end;
	
	OnCanRun = function(item)
		local char = item.player:GetChar()
		if(
			char:HasFlags("a") or 
			char:HasFlags("A") or 
			char:HasFlags("b") or
			char:HasFlags("B") or
			char:HasFlags("c") or
			char:HasFlags("C") or
			char:HasFlags("d") or
			char:HasFlags("D") or
			char:HasFlags("f") or
			char:HasFlags("F") or
			char:HasFlags("g") or
			char:HasFlags("G") or
			char:HasFlags("h") or
			char:HasFlags("H") or
			char:HasFlags("i") or
			char:HasFlags("I") or
			char:HasFlags("j") or
			char:HasFlags("J") or
			char:HasFlags("k") or
			char:HasFlags("K") or
			char:HasFlags("n") or
			char:HasFlags("l") or
			char:HasFlags("L") or
			char:HasFlags("m") or
			char:HasFlags("M")
			) 
		then
			return (!IsValid(item.entity))
		else
			return false
		end
	end;
}

ITEM.functions.SellPriceCheck =
{
	
	name = "Check Value",
	tip = "Checks the value of the item you will receive",
	icon = "icon16/money_dollar.png",
	
	OnRun = function(item)
		local player = item.player;
		local character = player:GetChar();
		local modifier = 3.00
		
		if (item.flag == "a" or item.flag == "C" or item.flag == "g" or item.flag == "I") then
			modifier = ix.config.get("Tier 1 Export")
		elseif (item.flag == "A" or item.flag == "d" or item.flag == "G" or item.flag == "j") then
			modifier = ix.config.get("Tier 2 Export")
		elseif (item.flag == "b" or item.flag == "D" or item.flag == "h" or item.flag == "J") then
			modifier = ix.config.get("Tier 3 Export")
		else
			modifier = ix.config.get("Tier 4 Export")
		end
		
		modifier = 1.00 - (modifier * 0.01)

		local saleprice = math.Round((item.price*modifier))
		player:NotifyLocalized("Item is worth " .. saleprice .. " if sold")
		return false
	end;
	
	OnCanRun = function(item)
		local char = item.player:GetChar()
		if(
			char:HasFlags("a") or 
			char:HasFlags("A") or 
			char:HasFlags("b") or
			char:HasFlags("B") or
			char:HasFlags("c") or
			char:HasFlags("C") or
			char:HasFlags("d") or
			char:HasFlags("D") or
			char:HasFlags("f") or
			char:HasFlags("F") or
			char:HasFlags("g") or
			char:HasFlags("G") or
			char:HasFlags("h") or
			char:HasFlags("H") or
			char:HasFlags("i") or
			char:HasFlags("I") or
			char:HasFlags("j") or
			char:HasFlags("J") or
			char:HasFlags("k") or
			char:HasFlags("K") or
			char:HasFlags("n") or
			char:HasFlags("l") or
			char:HasFlags("L") or
			char:HasFlags("m") or
			char:HasFlags("M")
			) 
		then
			return (!IsValid(item.entity))
		else
			return false
		end
	end;
}