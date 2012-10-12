local config = PetJournalEnhanced:NewModule("Config","AceEvent-3.0")



function config:OnInitialize()
	local options = {
    name = "PetJournal Enhanced",
    handler = self,
    type = 'group',
    args = {
		petJournal = {
			name = "PetJournal",
			handler = self,
			type = 'group',
			order = 1,
			args = {
				showPetCount = {
					order = 1,
					name = PetJournalEnhanced.locStr.Showuniquepetcount,
					type = "toggle",
					set = function(info,val) 
						PetJournalEnhancedOptions.showUniquePetCount = val 
						self:SendMessage("PETJOURNAL_ENHANCED_OPTIONS_UPDATE")  
					end,
					get = function(info) return PetJournalEnhancedOptions.showUniquePetCount or false end
				},
				showMaxStat = {
					order = 2,
					name = PetJournalEnhanced.locStr.Showpetsspecialization,
					type = "toggle",
					width = "double",
					set = function(info,val) 
						PetJournalEnhancedOptions.showMaxStatIcon = val 
						self:SendMessage("PETJOURNAL_ENHANCED_OPTIONS_UPDATE")  
					end,
					get = function(info) return PetJournalEnhancedOptions.showMaxStatIcon or false end
				},
				colorBorders = {
					order = 2,
					name = PetJournalEnhanced.locStr.Colorpetborders,
					type = "toggle",
					width = "double",
					set = function(info,val) 
						PetJournalEnhancedOptions.showColoredBorders = val 
						self:SendMessage("PETJOURNAL_ENHANCED_OPTIONS_UPDATE")  
					end,
					get = function(info) return PetJournalEnhancedOptions.showColoredBorders or false end
				},
				colorName = {
					order = 2,
					name = PetJournalEnhanced.locStr.Colorpetnames,
					type = "toggle",
					width = "double",
					set = function(info,val) 
						PetJournalEnhancedOptions.showColoredNames = val 
						self:SendMessage("PETJOURNAL_ENHANCED_OPTIONS_UPDATE")  
					end,
					get = function(info) return PetJournalEnhancedOptions.showColoredNames or false end
				},
			},
		},
		
		
    },
	
}
	LibStub("AceConfig-3.0"):RegisterOptionsTable("PetJournalEnhanced", options)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("PetJournalEnhanced","PetJournal Enhanced")
end

