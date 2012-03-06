--[[ Linkerize: adds control codes to links pasted into supported EditBoxes ]]

local version = 001 -- increment this if you change this file

local supported_editboxes = {
	"ChatFrame1EditBox", -- chat entry box
	"TinyPadEditBox", -- TinyPad main window
	"MacroFrameText", -- macro edit window
	-- add other ones here
}

	local linkerize=CreateFrame("Frame","Linkerize")

	linkerize.version_loaded = version
	linkerize.known_links = {}
	linkerize.last_change = 0
	
	linkerize:SetScript("OnEvent",function(self,event,addon)
		if event=="PLAYER_LOGIN" then
			for _,editBox in pairs(supported_editboxes) do
				if _G[editBox] then
					linkerize:Register(_G[editBox])
				end
			end
		elseif event=="ADDON_LOADED" and addon=="Blizzard_MacroUI" then
			-- special case for MacroFrameText, doesn't exist until it loads
			linkerize:Register(MacroFrameText)
		end
	end)
	linkerize:RegisterEvent("PLAYER_LOGIN")
	linkerize:RegisterEvent("ADDON_LOADED")

	function linkerize.NoteAnyLinks(self) -- store any clickable links into known_links
		local body = self:GetText()
		local link_pattern="\124c%x%x%x%x%x%x%x%x\124H.-\124h%[.-%]\124h\124r"
		local name_pattern = "\124c%x%x%x%x%x%x%x%x\124H.-\124h(%[.-%])\124h\124r"
		for link in body:gmatch(link_pattern) do
			linkerize.known_links[link:match(name_pattern)] = link
		end
	end

	function linkerize.Linkerizer(self) -- convert all unclickable links to known_links

		linkerize.NoteAnyLinks(self)
		if GetTime()-linkerize.last_change < 0.1 then return end

		local body = self:GetText()
		local unclickable_pattern = "%[%C-%]" -- "[^\124][^h](%[%C+%])[^\124][^h]"
		local unclickable_name, stub,done,change_made, first,last
		local thumb = 1
		local cursor_pos = self:GetCursorPosition()
		local original_length = body:len()
		while not done do
			first,last = body:find(unclickable_pattern,thumb)
			if first then
				thumb = last+1
				if body:sub(first-2,first-1)~="\124h" and body:sub(last+1,last+2)~="\124h" then
					unclickable_name = body:sub(first,last)
					if linkerize.known_links[unclickable_name] then
						stub = body:sub(1,first-1)..linkerize.known_links[unclickable_name]
						thumb = stub:len()+1
						stub = stub..body:sub(last+1,-1)
						body = stub
						change_made = 1
					end
				end
			else
				done = 1
			end
		end
		if change_made then
			local new_length = body:len()
			if new_length <= self:GetMaxLetters() then
				self:SetText(body)
				self:SetCursorPosition(cursor_pos + new_length-original_length)
			else
				print("|cFFFF3333Not enough room to paste a clickable link.")
			end
			linkerize.last_change = GetTime()
		end
	end
	
	function linkerize:Register(editBox)
		if not editBox.linkerized then
			editBox:HookScript("OnEditFocusGained",linkerize.NoteAnyLinks)
			editBox:HookScript("OnTextChanged",linkerize.Linkerizer)
			editBox.linkerized = 1
		end
	end

