 UniquePets = PetJournalEnhanced:NewModule("UniquePets","AceEvent-3.0")
local LibPetJournal = LibStub("LibPetJournal-2.0")

function UniquePets:ScanPets()
	if UniquePets:IsEnabled() then
		local pets = {}
		local count = 0
		for i,petID in LibPetJournal:IteratePetIDs() do 
			local speciesID = C_PetJournal.GetPetInfoByPetID(petID)
			if not pets[speciesID] then
				count = count + 1
				pets[speciesID] = speciesID
			end
		end
		UniquePets.frame.uniqueCount:SetText(count)
	end
end

function UniquePets:OnInitialize()
	self:RegisterMessage("PETJOURNAL_ENHANCED_OPTIONS_UPDATE")
	self.frame = CreateFrame("frame","PJEUniquePetCount",PetJournal,"InsetFrameTemplate3")
	local frame = self.frame;
	frame:ClearAllPoints()
	frame:SetPoint("TOPLEFT",PetJournal,70,-42)
	frame:SetSize(130,18)
	frame.staticText = frame:CreateFontString(nil,"ARTWORK","GameFontNormalSmall")
	frame.uniqueCount = frame:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall")
	
	frame.staticText:ClearAllPoints()
	frame.staticText:SetPoint("LEFT",frame,10,0)
	--frame.staticText:SetPoint("RIGHT",frame.uniqueCount,"LEFT",-3,0)
	frame.staticText:SetText(PetJournalEnhanced.locStr.UniquePets)
	
	frame.uniqueCount:ClearAllPoints()
	frame.uniqueCount:SetPoint("RIGHT",frame,-10,0)
	frame.uniqueCount:SetText("0")
	
	if PetJournalEnhancedOptions.showUniquePetCount then
		self.frame:Show()
		PetJournal.PetCount:SetPoint("TopLeft",70,-22)
		PetJournal.PetCount:SetSize(130,18)
	else
		self.frame:Hide()
		PetJournal.PetCount:SetPoint("TopLeft",70,-35)
		PetJournal.PetCount:SetSize(130,20)
	end
	
	LibPetJournal:RegisterCallback("PetListUpdated", self.ScanPets)
end


function UniquePets:PETJOURNAL_ENHANCED_OPTIONS_UPDATE()
	if PetJournalEnhancedOptions.showUniquePetCount then
		self.frame:Show()
		PetJournal.PetCount:SetPoint("TopLeft",70,-22)
		PetJournal.PetCount:SetSize(130,18)
	else
		self.frame:Hide()
		PetJournal.PetCount:SetPoint("TopLeft",70,-35)
		PetJournal.PetCount:SetSize(130,20)
	end
end

