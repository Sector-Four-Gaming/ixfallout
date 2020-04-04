local PLUGIN = PLUGIN

ITEM.name = "FNFixing"
ITEM.description = "A repair item. It fixes weapons."
ITEM.category = "Repair"
ITEM.model = "models/Items/BoxSRounds.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 1
ITEM.slot = 1

-- Slot Numbers Defined:

-- Sights = 1
-- Barrels = 2
-- Lasers/Lights = 3
-- Magazines = 4
-- Underbarrel = 5

-- Additional slots can be added so long as they line up with the SWEP's attachment code appropriately.

function ITEM:GetDescription()
	local description = self.description
	description = description.."\nWeight: "..self.weight.."kg"
	return description
end

local function repair(item, data)
    local client = item.player
    local char = client:GetChar()
    local inv = char:GetInv()
    local items = inv:GetItems()
    local target
    for k, invItem in pairs(items) do
        if data then
            if (invItem:GetID() == data.data) then
                target = invItem
                break
            end
        else
            if (invItem.isPLWeapon and invItem.isCW) then
                target = invItem
                break
            end
        end
    end

    if (!target) then
        client:NotifyLocalized("noWeapon")

        return false
    else
        local class = target.class
        local SWEP = weapons.Get(class)

        if (target.isCW) then
            local durability = target:GetData("wepdurability",10000)
			local repairval = item.repair * 100
			local newdura = durability + repairval
			if newdura >= 10000 then
				target:SetData("wepdurability",10000)
				return true
			else
				target:SetData("wepdurability",newdura)
				return true
			end
        end
    end

    client:NotifyLocalized("noWeapon")
    return false
end

ITEM.functions.Repair = {
    name = "Repair",
    tip = "Repair the specified weapon.",
    icon = "icon16/wrench.png",
    
    
    OnCanRun = function(item)
        return (!IsValid(item.entity))
    end,
	
    OnRun = function(item, data)
		return repair(item, data)
	end,
    
    isMulti = true,
    
    multiOptions = function(item, client)
        --local client = item.player
        local targets = {}
        local char = client:GetChar()
        if (char) then
            local inv = char:GetInv()
            if (inv) then
                local items = inv:GetItems()
                for k, v in pairs(items) do
                    if (v.isPLWeapon and v.isCW) then
                        table.insert(targets, {
                        name = L(v.name),
                        data = v:GetID(),
                    })
					else
						continue
					end
				end
			end
		end
    return targets
	end,
}