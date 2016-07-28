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

function E:Print(...)
	print(E["media"].hexvaluecolor.."ElvUI-SunUIMod"..':|r', ...)
end


function E:FadeOutFrame(p, t, show)  --隐藏  show为false时候为完全隐藏
	if type(p) == "table" then 
		if p:GetAlpha()>0 then
			local fadeInfo = {}
			fadeInfo.mode = "OUT"
			fadeInfo.timeToFade = t or 1.5
			if not show then
				fadeInfo.finishedFunc = function() p:Hide() end 
			end
			fadeInfo.startAlpha = p:GetAlpha()
			fadeInfo.endAlpha = 0
			UIFrameFade(p, fadeInfo)
		end 
		return
	end
	if not _G[p] then print("SunUI:没有发现"..p.."这个框体")return end
	if _G[p]:GetAlpha()>0 then
		local fadeInfo = {}
		fadeInfo.mode = "OUT"
		fadeInfo.timeToFade = t or 1.5
		if not show then
			fadeInfo.finishedFunc = function() _G[p]:Hide() end 
		end
		fadeInfo.startAlpha = _G[p]:GetAlpha()
		fadeInfo.endAlpha = 0
		UIFrameFade(_G[p], fadeInfo)
	end 
end

function E:FormatTime(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		--return format("%dd", floor(s/day + 0.5)), s % day
		return format(COOLDOWN_DURATION_DAYS, floor(s/day + 0.5)), s % day
	elseif s >= hour then
		--return format("%dh", floor(s/hour + 0.5)), s % hour
		return format(COOLDOWN_DURATION_HOURS, floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		--return format("%dm", floor(s/minute + 0.5)), s % minute
		return format(COOLDOWN_DURATION_MIN, floor(s/minute + 0.5)), s % minute
	end
	return format("%ds", s), (s * 100 - floor(s * 100))/100
end

--[[
function E:ShortValue(v)
	if v >= 1e9 then
		return format("%.1fG", v / 1e9):gsub("%.?0+([km])$", "%1")
	elseif v >= 1e6 then
		return ("%.1fm"):format(v / 1e6):gsub("%.?0+([km])$", "%1")
	elseif v >= 1e3 or v <= -1e3 then
		return ("%.1fk"):format(v / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return v
	end
end
]]

function E:GetSpell(k)
  if GetSpellInfo(k) then
    return GetSpellInfo(k)
  else
    E:Print("法术ID无效", k)
    return ""
  end
end