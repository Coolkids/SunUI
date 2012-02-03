local S, C, L, DB = unpack(select(2, ...))
local NGSenable=1
local NGSkilled=0
local NGSreport=0
local NGSid2=0
local NGSmatchs=1 --在這裡修改關鍵字配對個數.找到n個關鍵字則屏蔽,就改此處為n.
local NGSSymbols={"`","~","@","#","^","*","=","|"," ","，","。","、","？","！","：","；","’","‘","“","”","【","】","『","』","《","》","<",">","（","）"} 
--在這裡修改要清除的干擾字符.
if (GetLocale() == "zhTW") then
  NGSwords = {"淘寶","淘宝","旺旺","純手工","纯手工","牛肉","萬斤","手工金","手工G","平臺","黑一賠","黑一赔","皇冠店","代練","代练","代打","大腳","FishUI","魔盒","準備開火","Fatality:","→","←","注意治療","高仇恨","本次戰鬥死亡","進攻戰役","任務進度","提示您","托巴拉德戰鬥開始","防守戰役","分鐘後開始"} 
  --(zhTW)在這裡修改關鍵字,以" "包括,以,分隔.
  NGSrep="|cff3399FFSunUI:|r已經截獲|cff00ff00%d|r條廣告訊息."
  NGSturnoff="|cff00ff00出售金幣廣告信息屏蔽插件已經停用.輸入/NGS啟用.|r"
  NGSturnon="|cff00ff00出售金幣廣告信息屏蔽插件已經啟用.輸入/NGS停用.|r"
  NGSrepFreq=200; --(zhTW)在這裡截獲報告頻率.幾條消息報告一次,就改此處為n.
else if (GetLocale() == "zhCN") then
    NGSwords = {"平台交易","点心","担保","纯手工","淘宝","游戏币","代打","代练","工作室","金=","G=","元=","代练","手工金","手工G","黑赔","皇冠店","黑一赔十","大脚","FishUI","魔盒","准备开火","Fatality:","→","←"} 
	--(zhCN)在这里修改关键字,以" "包括,以,分隔.
    NGSrep="|cff3399FFSunUI:|r本次登录到现在已经接获|cff00ff00%d|r条广告信息。"
    NGSturnoff="|cff00ff00出售金币广告信息屏蔽插件已经停用。输入/NGS启用。|r"
    NGSturnon="|cff00ff00出售金币广告信息屏蔽插件已经启用。输入/NGS停用。|r"
    NGSrepFreq=4000; --(zhCN)在这里修改报告频率。n条消息报告一次，就该此处为n。
  else
    DEFAULT_CHAT_FRAME:AddMessage("請注意!\nNoGoldSeller只能在zhTW,zhCN下運行,不支持您現在的遊戲語言版本!已經自行禁用.")
	DEFAULT_CHAT_FRAME:AddMessage("WARNING!\nNoGoldSeller: This addon ONLY fits for Traditional Chinese (zhTW) & Simplified Chinese (zhCN) realms. Unsupport your game client. It has automatically disabled now.")
	NGSenable=0;
  end
end
local NGSdebug=0;

function IsGoldSeller(NGSself, NGSevent, NGSmsg, NGSauthor, _, _, _, NGSflag, _, _, _, _, NGSid)
  if(NGSenable==0) then
    return false;
  end
  if ((NGSevent == "CHAT_MSG_WHISPER" and NGSflag == "GM") or UnitIsUnit(NGSauthor,"player") or (not CanComplainChat(NGSid))) then 
	return false; 
  end
  for _, NGSsymbol in ipairs(NGSSymbols) do
    NGSmsg, a = gsub(NGSmsg, NGSsymbol, "")
  end
  local NGSmatch = 0;
  local NGSnewString=""
  for _, NGSword in ipairs(NGSwords) do
    local NGSnewString, NGSresult= gsub(NGSmsg, NGSword, "");
	if (NGSresult > 0) then
	  NGSmatch = NGSmatch +1;
	end
  end
  if (NGSmatch >= NGSmatchs) then 
	if (not(NGSid == NGSid2)) then
		NGSkilled = NGSkilled + 1
		NGSreport = NGSreport + 1
		NGSid2 = NGSid
		
		if (NGSdebug == 1) then --debug
			DEFAULT_CHAT_FRAME:AddMessage(NGSauthor)
			DEFAULT_CHAT_FRAME:AddMessage(NGSevent)
			DEFAULT_CHAT_FRAME:AddMessage(NGSmsg)
			DEFAULT_CHAT_FRAME:AddMessage(NGSkilled)
		end
		
		if (NGSreport == NGSrepFreq) then
		DEFAULT_CHAT_FRAME:AddMessage(string.format(NGSrep, NGSkilled))
		NGSreport=0
		end
	end
	return true;
  else
    return false;
  end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", IsGoldSeller)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", IsGoldSeller)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", IsGoldSeller)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", IsGoldSeller) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", IsGoldSeller) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", IsGoldSeller) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", IsGoldSeller) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", IsGoldSeller) 

SLASH_NGS1 = "/nogoldseller";
SLASH_NGS2 = "/NGS";
SlashCmdList["NGS"] = function(cmd)
  if (NGSenable==1) then
	DEFAULT_CHAT_FRAME:AddMessage(NGSturnoff)
	NGSenable=0;
  else
    DEFAULT_CHAT_FRAME:AddMessage(NGSturnon)
    NGSenable=1;
  end
end
----------------------------------------------------------------------------------
-- 高亮显示自己名字
----------------------------------------------------------------------------------
local function nocase(s)
    s = string.gsub(s, "%a", function (c)
       return string.format("[%s%s]", string.lower(c),
                                          string.upper(c))
    end)
    return s
end

local function changeName(msgHeader, name, msgCnt, chatGroup, displayName, msgBody)
	if name ~= DB.PlayerName then
		msgBody = msgBody:gsub("("..nocase(DB.PlayerName)..")" , "|cffffff00>>|r|cffff0000%1|r|cffffff00<<|r")
	end
	return ("|Hplayer:%s%s%s|h[%s]|h%s"):format(name, msgCnt, chatGroup, displayName, msgBody)
end

local newAddMsg = {}
local function AddMessage(frame, text, ...)
	if text and type(text) == "string" then
		text = text:gsub("(|Hplayer:([^:]+)([:%d+]*)([:%w+]*)|h%[(.-)%]|h)(.-)$", changeName)
	end
	return newAddMsg[frame:GetName()](frame, text, ...)
end

for i = 1, NUM_CHAT_WINDOWS do
	local f = _G[format("%s%d", "ChatFrame", i)]
	if f ~= COMBATLOG then
		newAddMsg[format("%s%d", "ChatFrame", i)] = f.AddMessage
		f.AddMessage = AddMessage
	end
end