local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

local smoothing = {}
local function Smooth(self, value)
	if value ~= self:GetValue() or value == 0 then
		smoothing[self] = value
	else
		smoothing[self] = nil
	end
end

function E:SmoothBar(bar)
	if not bar.SetValue_ then
		bar.SetValue_ = bar.SetValue
		bar.SetValue = Smooth
	end
end

local SmoothUpdate = CreateFrame("Frame")
SmoothUpdate:SetScript("OnUpdate", function()
	local limit = 30/GetFramerate()
	local speed = 1/8

	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + math.min((value-cur)*speed, math.max(value-cur, limit))
		if new ~= new then
			new = value
		end
		bar:SetValue_(new)
		if (cur == value or math.abs(new - value) < 1) then
			bar:SetValue_(value)
			smoothing[bar] = nil
		end
	end
end)

-- Banner show/hide animations

local interval = 0.1
function E:ShowAnima(f)
	if type(f) == "string" then
		f = _G[f]
		if _G[f] == nil then
			error(f.." frame is null")
			return
		end
	else
		if type(f) ~= "table" then
			error(f.."not a frame or frame name")
			return
		end
	end
	if f:IsShown() then
		f:Hide()
	end 
	if f:GetAlpha() > 0.11 then
		f:SetAlpha(0.1)
	end
	if f:GetScale() > 0.11 then
		f:SetScale(0.1)
	end
	
	f.bannerShown = true
	f:Show()
	local scale
	f:SetScript("OnUpdate", function(self)
		scale = self:GetScale() + interval
		self:SetScale(scale)
		self:SetAlpha(scale)
		if scale >= 1 then
			self:SetScale(1)
			self:SetScript("OnUpdate", nil)
		end
	end)

end

function E:HideAnima(f)
	if type(f) == "string" then
		f = _G[f]
		if _G[f] == nil then
			error(f.." frame is null")
			return
		end
	else
		if type(f) ~= "table" then
			error(f.."not a frame or frame name")
			return
		end
	end
	local scale
	f:SetScript("OnUpdate", function(self)
		scale = self:GetScale() - interval
		if scale <= 0.1 then
			self:SetScript("OnUpdate", nil)
			self:Hide()
			f.bannerShown = false
			return
		end
		self:SetScale(scale)
		self:SetAlpha(scale)
	end)
end

function E:CheckChat(warning)
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		return "INSTANCE_CHAT"
	elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
		if warning and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant()) then
			return "RAID_WARNING"
		else
			return "RAID"
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		return "PARTY"
	end
	return "SAY"
end

function E:CreateFS(parent, fontSize, justify, fontname, fontStyle)
    local f = parent:CreateFontString(nil, "OVERLAY")
	
	if fontname == nil then
		f:FontTemplate(nil, fontSize, fontStyle)
	else
		f:FontTemplate(fontname, fontSize, fontStyle)
	end

    if justify then f:SetJustifyH(justify) end

    return f
end