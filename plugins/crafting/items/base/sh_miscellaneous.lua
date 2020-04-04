ITEM.name = "misc item"
ITEM.description = "An item"
ITEM.category = "Misc"
ITEM.model = ("models/rgd.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.basequantity = 1
ITEM.maxQuantity = 5
ITEM.loadSize = {1,5,15, ITEM.maxQuantity}

function ITEM:GetDescription()
	local quant = self:GetData("quantity", self.basequantity)
	local itemdesc = self.description
	local str = ""
	
	if self.longdesc then
		str = (self.longdesc or "")
	end

	local customData = self:GetData("custom", {})
	if(customData.desc) then
		str = customData.desc
	end

	if (self.entity) then
		return (itemdesc)
	else
        return (str.."\n\nQuantity: "..quant)
	end
end

ITEM.functions.Clone = {
	name = "Clone",
	tip = "Clone this item",
	icon = "icon16/wrench.png",
	OnRun = function(item)
		local client = item.player	
	
		client:requestQuery("Are you sure you want to clone this item?", "Clone", function(text)
			if text then
				local inventory = client:GetCharacter():GetInventory()
				
				if(!inventory:Add(item.uniqueID, 1, item.data)) then
					client:Notify("Inventory is full")
				end
			end
		end)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player
		return client:GetCharacter():HasFlags("N") and !IsValid(item.entity)
	end
}

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
    	ix.util.DrawText(item:GetData("quantity",item.basequantity), 8, 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, "ixChatFont")
		
		if item.color then
			surface.SetDrawColor(item.color)
			surface.DrawRect(w - 16, 10, 8, 8)
		end
    end
end

ITEM.functions.Custom = {
	name = "Customize",
	tip = "Customize this item",
	icon = "icon16/wrench.png",
	OnRun = function(item)		
		ix.plugin.list["customization"]:startCustom(item.player, item)
		
		return false
	end,
	
	OnCanRun = function(item)
		local client = item.player
		return client:GetCharacter():HasFlags("N") and !IsValid(item.entity)
	end
}

ITEM.functions.split = {
    name = "Split",
    tip = "useTip",
    icon = "icon16/stalker/split.png",
    isMulti = true,
    multiOptions = function(item, client)
		local targets = {}
        local quantity = item:GetData("quantity", item.ammoAmount)
		
        for i=1,#item.loadSize-1 do
			if quantity > item.loadSize[i] then
				table.insert(targets, {
					name = item.loadSize[i],
					data = {item.loadSize[i]},
				})
			end
		end
        return targets
	end,
	OnCanRun = function(item)				
		return (!IsValid(item.entity))
	end,
    OnRun = function(item, data)
		if data[1] then
			local quantity = item:GetData("quantity", item.ammoAmount)
			local client = item.player
			
			if quantity < data[1] then
				return false
			end
			
			client:GetCharacter():GetInventory():Add(item.uniqueID, 1, {["quantity"] = data[1]})
			
			quantity = quantity - data[1]

			item.player:EmitSound("stalkersound/inv_properties.mp3", 110)
			
			item:SetData("quantity", quantity)
			
		end
		return false
	end,
}

ITEM.functions.combine = {
	OnCanRun = function(item, data)
		if !data then
			return false
		end
		
		if !data[1] then
			return false
		end
		
		local targetItem = ix.item.instances[data[1]]

		if targetItem.uniqueID == item.uniqueID then
			return true
		else
			return false
		end
	end,
	OnRun = function(item, data)
		local targetItem = ix.item.instances[data[1]]
		local localQuant = item:GetData("quantity", item.ammoAmount)
		local targetQuant = targetItem:GetData("quantity", targetItem.ammoAmount)
		local combinedQuant = (localQuant + targetQuant)

		item.player:EmitSound("stalkersound/inv_properties.mp3", 110)

		if combinedQuant <= item.maxQuantity then
			targetItem:SetData("quantity", combinedQuant)
			return true
		elseif localQuant >= targetQuant then
			targetItem:SetData("quantity",item.maxQuantity)
			item:SetData("quantity",(localQuant - (item.maxQuantity - targetQuant)))
			return false
		else
			targetItem:SetData("quantity",(targetQuant - (item.maxQuantity - localQuant)))
			item:SetData("quantity",item.maxQuantity)
			return false
		end
	end,
}

function ITEM:OnInstanced()
	timer.Simple(0.5,function()
		if self:GetData("quantity",0) == 0 then
			self:SetData("quantity",self.basequantity)
		end
	end)
end

ITEM.functions.Sell = {
	name = "Sell",
	icon = "icon16/stalker/sell.png",
	sound = "physics/metal/chain_impact_soft2.wav",
	OnRun = function(item)
		local client = item.player
		client:Notify( "Sold for "..(math.Round((item.price/2)*(item:GetData("quantity",1)/item.basequantity))).." rubles." )
		client:GetCharacter():GiveMoney(math.Round((item.price/2)*(item:GetData("quantity",1)/item.basequantity)))
	end,
	OnCanRun = function(item)
		return !IsValid(item.entity) and item:GetOwner():GetCharacter():HasFlags("1")
	end
}

ITEM.functions.Value = {
	name = "Value",
	icon = "icon16/help.png",
	sound = "physics/metal/chain_impact_soft2.wav",
	OnRun = function(item)
		local client = item.player
		client:Notify( "Item is sellable for "..(math.Round((item.price/2)*(item:GetData("quantity",1)/item.basequantity))).." rubles." )
		return false
	end,
	OnCanRun = function(item)
		return !IsValid(item.entity) and item:GetOwner():GetCharacter():HasFlags("1")
	end
}