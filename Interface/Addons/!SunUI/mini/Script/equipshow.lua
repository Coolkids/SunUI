local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Core"):NewModule("equipshow", "AceEvent-3.0")
function Module:OnInitialize()

local function ChatFrame_OnHyperlinkEnter(self, linkData, link)
   GameTooltip:SetOwner(self,"ANCHOR_TOPRIGHT");
   if strfind(linkData,"^item") or strfind(linkData,"^enchant") then
      GameTooltip:SetHyperlink(linkData);
      GameTooltip:Show();   
      local _,_,_,_,_,_,_,_,_,icon=GetItemInfo(linkData);
   elseif (strfind(linkData,"^achievement")) then
      GameTooltip:SetHyperlink(linkData);
      GameTooltip:Show();   
   elseif (strfind(linkData,"^quest")) then
      GameTooltip:SetHyperlink(linkData);
      GameTooltip:Show();   
   end      
end


local function ChatFrame_OnHyperlinkLeave()
   GameTooltip:Hide();
end


do


   for i=1, NUM_CHAT_WINDOWS do
      local frame=getglobal("ChatFrame"..i);
      frame:SetScript("OnHyperlinkEnter", ChatFrame_OnHyperlinkEnter);
      frame:SetScript("OnHyperlinkLeave", ChatFrame_OnHyperlinkLeave);
   end

end      
end