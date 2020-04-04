function PLUGIN:ScalePlayerDamage(entity, hitGroup, damage)
	if entity:GetData("armorAP") then
		if DMG_ACCEPT[damage:GetDamageType()] then
			local armor = (entity:GetData("armorAP") *0.01) or 1
			local scale = math.log(armor + 1)
			
			if hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
				scale = (scale * 0.5)
			elseif hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_CHEST then
				scale = (scale * 0.75)
			elseif hitgroup == HITGROUP_HEAD then
				scale = (scale * 2)
			end
			damage:ScaleDamage(1 - scale)
		end
	end
end