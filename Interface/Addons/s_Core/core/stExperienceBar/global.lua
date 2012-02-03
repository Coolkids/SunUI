local S, C, L, DB = unpack(select(2, ...))
st = {}

st.FactionInfo = {
	[1] = {{ 170/255, 70/255,  70/255 }, L["仇恨"], "FFaa4646"},
	[2] = {{ 170/255, 70/255,  70/255 }, L["敌对"], "FFaa4646"},
	[3] = {{ 170/255, 70/255,  70/255 }, L["不友好"], "FFaa4646"},
	[4] = {{ 200/255, 180/255, 100/255 }, L["中立"], "FFc8b464"},
	[5] = {{ 75/255,  175/255, 75/255 }, L["友好"], "FF4baf4b"},
	[6] = {{ 75/255,  175/255, 75/255 }, L["尊敬"], "FF4baf4b"},
	[7] = {{ 75/255,  175/255, 75/255 }, L["崇敬"], "FF4baf4b"},
	[8] = {{ 155/255,  255/255, 155/255 }, L["崇拜"],"FF9bff9b"},
}

-- Functions -------------
--------------------------
function st.ShortValue(value)
	if value >= 1e6 then
		return ("%.2fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e3 or value <= -1e3 then
		return ("%.1fk"):format(value / 1e3):gsub("%.?+([km])$", "%1")
	else
		return value
	end
end

function st.CommaValue(amount)
	local formatted = amount
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

function st.Colorize(r)
	return st.FactionInfo[r][3]
end

function st.IsMaxLevel()
	if UnitLevel("player") == MAX_PLAYER_LEVEL then
		return true
	end
end

function st.GuildIsMaxLevel()
	if GetGuildLevel() == MAX_GUILD_LEVEL then
		return true
	end
end