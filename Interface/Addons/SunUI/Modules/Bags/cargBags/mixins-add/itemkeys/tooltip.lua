--[[
LICENSE
	cargBags: An inventory framework addon for World of Warcraft

	Copyright (C) 2010  Constantin "Cargor" Schomburg <xconstruct@gmail.com>

	cargBags is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	cargBags is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with cargBags; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

DESCRIPTION:
	Item keys which require tooltip parsing to work
]]
local parent, ns = ...
local cargBags = ns.cargBags

local tipName = parent.."Tooltip"
local tooltip

local function generateTooltip()
	tooltip = CreateFrame("GameTooltip", tipName)
	tooltip:SetOwner(WorldFrame, "ANCHOR_NONE") 
	tooltip:AddFontStrings( 
		tooltip:CreateFontString("$parentTextLeft1", nil, "GameTooltipText"), 
		tooltip:CreateFontString("$parentTextRight1", nil, "GameTooltipText")
	)
end

cargBags.itemKeys["bindOn"] = function(i)
	if(not i.link) then return end

	if(not tooltip) then generateTooltip() end
	tooltip:ClearLines()
	tooltip:SetBagItem(i.bagID, i.slotID)
	local bound = _G[tipName.."TextLeft2"] and _G[tipName.."TextLeft2"]:GetText()
	if(not bound) then return end

	local bindOn
	if(bound:match(ITEM_BIND_ON_EQUIP)) then bindOn = "equip"
	elseif(bound:match(ITEM_SOULBOUND)) then bindOn = "soul"
	elseif(bound:match(ITEM_BIND_QUEST)) then bindOn = "quest"
	elseif(bound:match(ITEM_BIND_TO_ACCOUNT)) then bindOn = "account"
	elseif(bound:match(ITEM_BIND_ON_PICKUP)) then bindOn = "pickup"
	elseif(bound:match(ITEM_BIND_ON_USE)) then bindOn = "use" end

	i.bindOn = bindOn
	return bindOn
end

