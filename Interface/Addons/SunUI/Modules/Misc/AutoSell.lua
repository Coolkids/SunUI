local S, L, DB, _, C = unpack(select(2, ...))
local AS = LibStub("AceAddon-3.0"):GetAddon("SunUI"):NewModule("AutoSell", "AceEvent-3.0")
local SunUIConfig = LibStub("AceAddon-3.0"):GetAddon("SunUI"):GetModule("SunUIConfig")

function AS:MERCHANT_SHOW()
	local c = 0
	for b=0,4 do
		for s=1,GetContainerNumSlots(b) do
			local l = GetContainerItemLink(b, s)
			if l then
				local t1 = select(11, GetItemInfo(l))
				local t2 = select(2, GetContainerItemInfo(b, s))
				if t1 then
					local p = t1*t2
					if select(3, GetItemInfo(l))==0 and p>0 then
						UseContainerItem(b, s)
						PickupMerchantItem()
						c = c+p
					end
				end
			end
		end
	end
	if c>0 then
		local g, s, c = math.floor(c/10000) or 0, math.floor((c%10000)/100) or 0, c%100
		DEFAULT_CHAT_FRAME:AddMessage("共售出："..format(GOLD_AMOUNT_TEXTURE, g, 0, 0).." "..format(SILVER_AMOUNT_TEXTURE, s, 0, 0).." "..format(COPPER_AMOUNT_TEXTURE, c, 0, 0),255,255,255)
	end
end

function AS:UpdateSet()
	if C["AutoSell"] then
		self:RegisterEvent("MERCHANT_SHOW")
	else
		self:UnregisterEvent("MERCHANT_SHOW")
	end
end
function AS:OnInitialize()
	C =  SunUIConfig.db.profile.MiniDB
	self:UpdateSet()
end