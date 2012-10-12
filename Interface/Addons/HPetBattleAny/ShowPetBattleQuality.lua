----####0.954####
local _

if GetLocale()=="zhCN" then 
	PET_BATTLE_COMBAT_LOG_AURA_APPLIED ="%1$s对%3$s %4$s 造成了%2$s效果."
	PET_BATTLE_COMBAT_LOG_PAD_AURA_APPLIED = "%1$s对%3$s 造成了%2$s效果."
end

if GetLocale()=="zhCN" then
	DEFAULT_CHAT_FRAME:AddMessage(format("宠物辨别开启,输入|cffff0000%s|r用以设置信息提示","/hpq"))
end
if GetLocale()=="zhTW" then
	DEFAULT_CHAT_FRAME:AddMessage(format("寵物辨別開啟,輸入|cffff0000%s|r用以設置信息提示","/hpq"))
end

--------------------		载入宠物手册的数据
local HasPet={}
local function LoadUserPetInfo()
	C_PetJournal.SetSearchFilter("");
	C_PetJournal.AddAllPetTypesFilter();
	C_PetJournal.AddAllPetSourcesFilter();
	C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_COLLECTED, true)
	C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_FAVORITES, false)

	for i=1,select(2,C_PetJournal.GetNumPets(true)) do

		local petID, speciesID, isOwned, customName, level, favorite, isRevoked, name, icon, petType, creatureID, sourceText,_,isWildPet= C_PetJournal.GetPetInfoByIndex(i);
		if isOwned then
			local rarity = select(5,C_PetJournal.GetPetStats(petID))
			if not HasPet[speciesID] or HasPet[speciesID][1]<rarity then
				HasPet[speciesID] ={rarity, petID}
			end
		elseif HasPet[speciesID]~=nil then
			HasPet[speciesID]=nil
		end
	end
end

--------------------		OnEvent:PET_BATTLE_OPENING_START
local frame = CreateFrame("frame");
frame:SetScript("OnEvent", function(self, event, ...)
	if event == "PET_BATTLE_OPENING_START" then
--~ 载入已有宠物的数据（用以比较）
		if HPetSaves.Contrast then LoadUserPetInfo() end
--~ 输出敌对宠物的数据
		local FindBlue=false
		petOwner=2
		for petIndex=1, C_PetBattles.GetNumPets(petOwner) do

			local qrarity=C_PetBattles.GetBreedQuality(petOwner,petIndex)
			local speciesID=C_PetBattles.GetPetSpeciesID(petOwner,petIndex)
			local Ownerrarity=HasPet[speciesID]
			if qrarity>3 then
				FindBlue=true
			end

			local level = C_PetBattles.GetLevel(petOwner, petIndex);
			local MaxHealth = C_PetBattles.GetMaxHealth(petOwner, petIndex);
			local attack = C_PetBattles.GetPower(petOwner, petIndex);
			local speed = C_PetBattles.GetSpeed(petOwner, petIndex);

			if GetLocale()=="zhTW" then 
				tmprint="第"..petIndex.."隻是" 
			else
				tmprint="第"..petIndex.."只是" 
			end
			tmprint=tmprint..ITEM_QUALITY_COLORS[qrarity-1].hex.."\124Hbattlepet:"
			tmprint=tmprint..speciesID..":"..level..":"..(qrarity-1)..":"..MaxHealth..":"..attack..":"..speed
			tmprint=tmprint.."\124h["..select(1,C_PetJournal.GetPetInfoBySpeciesID(speciesID)).."]\124h\124r"--_G["BATTLE_PET_BREED_QUALITY"..qrarity].."|r"
			if HPetSaves.Contrast then
				local tmppetlink=C_PetJournal.GetBattlePetLink(Ownerrarity and Ownerrarity[2] or 0)
				if tmppetlink then
					if Ownerrarity[1]>=qrarity then
						tmprint=tmprint..","..COLLECTED..tmppetlink.."."
					else
						tmprint=tmprint..","..COLLECTED.."|cffff0000"..(GetLocale() == "zhCN" and " 但只是" or " but only ")..tmppetlink.."|r!!!!!"
					end
				else
					HasPet[speciesID]=nil
					tmprint=tmprint..",|cffff0000"..NOT_COLLECTED.."|r!!!!!"
				end
			end
			if HPetSaves.ShowMsg then
				DEFAULT_CHAT_FRAME:AddMessage(tmprint)
			end
		end

		if HPetSaves.Sound and FindBlue and C_PetBattles.IsWildBattle() then --C_PetBattles.IsPlayerNPC(2) and select(2,C_PetBattles.IsTrapAvailable())~=7 then
--~ 		PlaySoundFile( [[Sound\Event Sounds\Event_wardrum_ogre.wav]], "Master" );
			PlaySoundFile( [[Sound\Events\scourge_horn.wav]], "Master" );
		end

	end
 end)
frame:RegisterEvent("PET_BATTLE_OPENING_START");

--------------------		鼠标提示
PetBattlePrimaryUnitTooltip:HookScript("OnHide",function(self,...) GameTooltip:Hide() end)
hooksecurefunc("PetBattleUnitTooltip_UpdateForUnit",function(self, petOwner, petIndex)
	if HPetSaves.Contrast then
--~ 一个额外的鼠标提示
		local speciesID=C_PetBattles.GetPetSpeciesID(petOwner,petIndex)
		local name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable = C_PetJournal.GetPetInfoBySpeciesID(speciesID)

		if sourceText and sourceText~="" then
			local tmp
			if HasPet[speciesID] then
				tmp=COLLECTED.."("..ITEM_QUALITY_COLORS[HasPet[speciesID][1]-1].hex.._G["BATTLE_PET_BREED_QUALITY"..HasPet[speciesID][1]].."|r) "
			else
				tmp="|cffff0000"..NOT_COLLECTED.."|r"
			end
			GameTooltip:SetOwner(self,"ANCHOR_BOTTOM");
			GameTooltip:AddDoubleLine(name,tmp, 1, 1, 1);
			GameTooltip:AddLine(sourceText, 1, 1, 1, true);
			--if ( not tradable ) then
			--	GameTooltip:AddLine(BATTLE_PET_NOT_TRADABLE, 1, 0.1, 0.1, true);
			--end

			GameTooltip:Show();
		end
	end
end)


--if not PetJournal then LoadAddOn("Blizzard_PetJournal") end

--------------------		UnitFrame上色
hooksecurefunc("PetBattleUnitFrame_UpdateDisplay",function(self)
	if self.Name and self.petOwner and self.petIndex and self.petIndex <= C_PetBattles.GetNumPets(self.petOwner) then
		self.Name:SetText(ITEM_QUALITY_COLORS[C_PetBattles.GetBreedQuality(self.petOwner,self.petIndex)-1].hex..self.Name:GetText().."|r")
	end
end)


local function Qstringfind(strm,strf)
	local strf1=strf[1]
	local strf2=strf[2]
	local strf3=strf[3]
	local str1={}	---查找词组
	local str2={}	---查找词组中排除词组 "/"
	local str3={}	---排除词组 "-"

	if strf1 then
		while strf1 and strf1~="" do
			local strt=""
			strt,strf1=strf1:match("^%s*(%S*)%s*(.-)$")
			str1[strt]=0
		end
	end

	if strf2 then
		while strf2 and strf2~="" do
			local strt=""
			strt,strf2=strf2:match("^%s*(%S*)%s*(.-)$")
			str2[strt]=0
		end
	end

	if strf3 then
		while strf3~="" do
			local strt=""
			strt,strf3=strf3:match("^%s*(%S*)%s*(.-)$")

			str3[strt]=0
		end
	end

	local result=""

	for index=1,6 do

		for i,_ in pairs(str3) do
			if strm[index] and string.find(strm[index],i)~=nil then
				return false
			end
		end

		local btmp=true
		for i,_ in pairs(str2) do
			if strm[index] and string.find(strm[index],i)~=nil then
				btmp=false
			end
		end

		if strm[index] and btmp then result=result..strm[index] end

	end

	for i,_ in pairs(str1) do
		if string.find(result,i)==nil then return false end
	end


	return true
end
--------------------		SLASH,以后直接弄个设置面板
SLASH_PETQUALITY1 = "/hpetquality";
SLASH_PETQUALITY2 = "/hpq";
SlashCmdList["PETQUALITY"] = function(msg, editbox)
	local comm, rest = msg:match("^(%S*)%s*(.-)$")
	local command = string.lower(comm)
	if command =="" then
		if GetLocale()=="zhTW" then 
			DEFAULT_CHAT_FRAME:AddMessage("[/hpq msg]或者[/hpq 信息提示]在聊天窗口輸出寵物品質信息".."\n已經|cffffff00["..(HPetSaves.ShowMsg and "開啟" or "關閉") .."]|r",0,1,1)
			DEFAULT_CHAT_FRAME:AddMessage("[/hpq con]用以開啟或關閉寵物對比(用來判斷敵對寵物是否已擁有)".."\n已經|cffffff00["..(HPetSaves.Contrast and "開啟" or "關閉").."]|r",0,1,1)
			DEFAULT_CHAT_FRAME:AddMessage("[/hpq sound]或者[/hpq 聲音]開啟或關閉出現稀有寵物的聲音提示)".."\n已經|cffffff00["..(HPetSaves.Sound and "開啟" or "關閉").."]|r",0,1,1)
			DEFAULT_CHAT_FRAME:AddMessage("[/hpq s XX]或者[/hpq 搜索XX]根據寵物來源信息(例如來源地)來搜索寵物並在聊天窗列出，未收集標誌紅色,已收集標誌鏈接形式.(直接使用[/hpq s]用於搜索當前地點)",1,1,0)
			DEFAULT_CHAT_FRAME:AddMessage("[/hpq ss XX]也是搜索功能,搜索關鍵字為技能(包括技能名字和信息)",1,1,0)
		else
			DEFAULT_CHAT_FRAME:AddMessage("[/hpq msg]或者[/hpq 信息提示]在聊天窗口输出宠物品质信息".."\n已经|cffffff00["..(HPetSaves.ShowMsg and "开启" or "关闭").."]|r",0,1,1)
			DEFAULT_CHAT_FRAME:AddMessage("[/hpq con]用以开启或关闭宠物对比(用来判断敌对宠物是否已拥有)".."\n已经|cffffff00["..(HPetSaves.Contrast and "开启" or "关闭").."]|r",0,1,1)
			DEFAULT_CHAT_FRAME:AddMessage("[/hpq sound]或者[/hpq 声音]开启或关闭出现稀有宠物的声音提示)".."\n已经|cffffff00["..(HPetSaves.Sound and "开启" or "关闭").."]|r",0,1,1)
			DEFAULT_CHAT_FRAME:AddMessage("[/hpq s XX]或者[/hpq 搜索 XX]根据宠物来源信息(例如来源地)来搜索宠物并在聊天窗列出，未收集标志红色,已收集标志链接形式.(直接使用[/hpq s]用于搜索当前地点)",1,1,0)
			DEFAULT_CHAT_FRAME:AddMessage("[/hpq ss XX]也是搜索功能,搜索关键字为技能(包括技能名字和信息)",1,1,0)
		end
	end
	if command =="msg" or command=="信息提示" then
		HPetSaves.ShowMsg=not HPetSaves.ShowMsg
		if GetLocale()=="zhTW" then
			DEFAULT_CHAT_FRAME:AddMessage("[/hpq msg]或者[/hpq 信息提示]在聊天窗口輸出寵物品質信息".."\n已經|cffffff00["..(HPetSaves.ShowMsg and "開啟" or "關閉") .."]|r",0,1,1)
		else
			DEFAULT_CHAT_FRAME:AddMessage("[/hpq msg]或者[/hpq 信息提示]在聊天窗口输出宠物品质信息".."\n已经|cffffff00["..(HPetSaves.ShowMsg and "开启" or "关闭").."]|r",0,1,1)
		end
	end
	if command =="con" then
		HPetSaves.Contrast=not HPetSaves.Contrast
		if GetLocale()=="zhTW" then
			DEFAULT_CHAT_FRAME:AddMessage("[/hpq con]用以開啟或關閉寵物對比(用來判斷敵對寵物是否已擁有)".."\n已經|cffffff00["..(HPetSaves.Contrast and "開啟" or "關閉").."]|r",0,1,1)
		else
			DEFAULT_CHAT_FRAME:AddMessage("[/hpq con]用以开启或关闭宠物对比(用来判断敌对宠物是否已拥有)".."\n已经|cffffff00["..(HPetSaves.Contrast and "开启" or "关闭").."]|r",0,1,1)
		end
	end
	if command =="sound" or string.find(command,"声音") then
		HPetSaves.Sound=not HPetSaves.Sound
		if GetLocale()=="zhTW" then
			DEFAULT_CHAT_FRAME:AddMessage("[/hpq sound]或者[/hpq 聲音]開啟或關閉出現稀有寵物的聲音提示)".."\n已經|cffffff00["..(HPetSaves.Sound and "開啟" or "關閉").."]|r",0,1,1)
		else
			DEFAULT_CHAT_FRAME:AddMessage("[/hpq sound]或者[/hpq 声音]开启或关闭出现稀有宠物的声音提示)".."\n已经|cffffff00["..(HPetSaves.Sound and "开启" or "关闭").."]|r",0,1,1)
		end
	end
--~ 	这是搜索功能
	if command =="s" or command =="搜索" or command == "ss" then
		DEFAULT_CHAT_FRAME:AddMessage(GetLocale()=="zhTW" and "這是對來源限定為寵物對戰，進行搜索的結果：" or "这是对来源限定为宠物对战，进行搜索的结果：")
		local stemp=GetZoneText()
		local tmp1=""
		local tmp2=""
		if rest ~= "" then stemp=rest end
		local serachtemp={}
		serachtemp[1],serachtemp[3]=string.split("-",stemp)
		serachtemp[1],serachtemp[2]=string.split("/",serachtemp[1])
		if serachtemp[1]~="" then
			if serachtemp[3] and serachtemp[3]~="" then
				DEFAULT_CHAT_FRAME:AddMessage("搜索关键字为:"..serachtemp[1]:match"^%s*(.-)$"..",排除关键字为:"..serachtemp[3]:match"^%s*(.-)$")
			else
				DEFAULT_CHAT_FRAME:AddMessage("搜索关键字为:"..serachtemp[1]:match"^%s*(.-)$")
			end
		end

		for i=1,C_PetJournal.GetNumPets(false) do
			local petID,speciesID,isOwned, _, _, _, _, name, _, _, _, sourceText=C_PetJournal.GetPetInfoByIndex(i)
			if command=="s" then
				if serachtemp and string.find(sourceText,serachtemp[1]) then
					if isOwned then
						tmp1=tmp1..C_PetJournal.GetBattlePetLink(petID)
					else
						tmp2=tmp2.."\124cffffff00\124Hbattlepet:"..speciesID..":0:0:0:0:0\124h["..name.."]\124h\124r"
					end
				end
			else
				local strm={}
				for j=1,6 do
					local abilityID=C_PetJournal.GetPetAbilityList(speciesID)[j]
					if not abilityID then break end
					local _,st1,_,_,st2,_,st3=C_PetBattles.GetAbilityInfoByID(abilityID)
					strm[j]=st1..st2.._G["BATTLE_PET_NAME_"..st3]
				end
				if (serachtemp and Qstringfind(strm,serachtemp)) then
					if isOwned then
						tmp1=tmp1..C_PetJournal.GetBattlePetLink(petID)
					else
						tmp2=tmp2.."\124cffffff00\124Hbattlepet:"..speciesID..":0:0:0:0:0\124h["..name.."]\124h\124r"
					end
				end
			end
		end
		DEFAULT_CHAT_FRAME:AddMessage(COLLECTED..":"..tmp1)
		DEFAULT_CHAT_FRAME:AddMessage(NOT_COLLECTED..":"..tmp2)
	end
end

--------------------		SAVE
local function HGetDefault()
	return {
		ShowMsg = true,				--在聊天窗口显示信息
		TooltipSetColor = true,		--是否改变鼠标提示信息中名字的颜色用以显示宠物品质
		Contrast=true,				--是否将敌对宠物与自己已有宠物进行对比（判断是否已有，已有的品质是否高于敌对）
		Sound=true,
	}
end

HPetSaves=HGetDefault()

------------------------我是和谐的分割线---------------------------------

--~ 宠物对战的时候，鼠标放置技能上面。tooltip固定到了右下角。但是放在被动上面却依附在鼠标附近。这应该算是个bug，所以我hook这一段，进行了一点点修改
function PetBattleAbilityButton_OnEnter(self)
	local petIndex = C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY);
	if ( self:GetEffectiveAlpha() > 0 and C_PetBattles.GetAbilityInfo(LE_BATTLE_PET_ALLY, petIndex, self:GetID()) ) then
		PetBattleAbilityTooltip_SetAbility(LE_BATTLE_PET_ALLY, petIndex, self:GetID());
		PetBattleAbilityTooltip_Show("BOTTOMLEFT", self, "TOPRIGHT", 0, 0, self.additionalText);
	elseif ( self.abilityID ) then
		PetBattleAbilityTooltip_SetAbilityByID(LE_BATTLE_PET_ALLY, petIndex, self.abilityID, format(PET_ABILITY_REQUIRES_LEVEL, self.requiredLevel));
		PetBattleAbilityTooltip_Show("BOTTOMLEFT", self, "TOPRIGHT", 0, 0);
	else
		PetBattlePrimaryAbilityTooltip:Hide();
	end
end
local Launch = CreateFrame("Frame")
Launch:RegisterEvent("ADDON_LOADED")
Launch:SetScript("OnEvent", function(self, event)
	 if   IsAddOnLoaded("Blizzard_PetJournal") then
		--~ 对没有标示品质的宠物进行标示品质
		hooksecurefunc("PetJournal_UpdatePetCard",function(self)
			if not PetJournalPetCard.CannotBattleText:IsShown() and self.QualityFrame:IsShown()==nil and PetJournalPetCard.petID then
				rarity=select(5,C_PetJournal.GetPetStats(PetJournalPetCard.petID))
				if rarity then
					self.QualityFrame.quality:SetText(_G["BATTLE_PET_BREED_QUALITY"..rarity]);
					local color = ITEM_QUALITY_COLORS[rarity-1];
					self.QualityFrame.quality:SetVertexColor(color.r, color.g, color.b);
					self.QualityFrame:Show();
				end
			end
		end)


		--~ 点击未收集的宠物链接直接链接到宠物日志
		hooksecurefunc("FloatingBattlePet_Show",function(speciesID,level)
			if level==0 then
				FloatingBattlePetTooltip:Hide()
				if (not PetJournalParent) then
					PetJournal_LoadUI();
				end
				if (not PetJournalParent:IsShown()) then
					ShowUIPanel(PetJournalParent);
				end
				PetJournalParent_SetTab(PetJournalParent, 2);
				if (speciesID and speciesID > 0) then
					PetJournal_SelectSpecies(PetJournal, speciesID);
				end
			end
		end)

		--~ 修复宠物对战中一些快捷键失效的问题
		hooksecurefunc("PetBattleFrame_ButtonUp",function(id)
			if id==4 or id== 5 then
				local button=PetBattleFrame.BottomFrame[(id==4 and "SwitchPetButton" or "CatchButton")]
				if ( button:GetButtonState() == "PUSHED" ) then
					button:SetButtonState("NORMAL");
					if ( not GetCVarBool("ActionButtonUseKeydown") ) then
						button:Click();
					end
				end
			end
		end)
	end
end)