local S, C, L, DB, _ = unpack(select(2, ...))
local ChatFrame_OnHyperlinkShow_Saved;

function init(self) 
	ChatFrame_OnHyperlinkShow_Saved = ChatFrame_OnHyperlinkShow;
	ChatFrame_OnHyperlinkShow =  AchieveCompare_ChatFrame_OnHyperlinkShow;
end 

function AchieveCompare_ChatFrame_OnHyperlinkShow(self, link, text, button)
	if (strsub(link, 1, 11) ~= "achievement")
		then 
			ChatFrame_OnHyperlinkShow_Saved(self, link, text, button); 
			return;
		end;

	local type,id = strsplit(":",link);	


	local achievementLink = GetAchievementLink(id);
	

	ShowUIPanel(AchieveCompareTooltip);
	if ( not AchieveCompareTooltip:IsShown() ) then
		AchieveCompareTooltip:StripTextures()
		S.ReskinClose(AchieveCompareCloseButton)
		S.CreateBD(AchieveCompareTooltip)
		AchieveCompareTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
	end


	AchieveCompareTooltip:SetHyperlink(achievementLink);

	ChatFrame_OnHyperlinkShow_Saved(self, link, text, button);
end

	
function AchieveFrameShow()
	message("Hello World!"); 
end