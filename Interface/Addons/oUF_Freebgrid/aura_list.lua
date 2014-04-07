local _, ns = ...

local foo = {""}
local spellcache = setmetatable({}, 
{__index=function(t,id) 
	local a = {GetSpellInfo(id)} 

	if GetSpellInfo(id) then
		t[id] = a
		return a
	end

	--print("Invalid spell ID: ", id)
	t[id] = foo
	return foo
end
})

local function GetSpellInfo(a)
	return unpack(spellcache[a])
end

ns.auras = {
	-- Ascending aura timer
	-- Add spells to this list to have the aura time count up from 0
	-- NOTE: This does not show the aura, it needs to be in one of the other list too.
	ascending = {
		[GetSpellInfo(92956)] = true, -- Wrack
	},

	-- Any Zone
	debuffs = {
		--[6788] = 16,
		--[GetSpellInfo(6788)] = 16, -- Weakened Soul
		[GetSpellInfo(39171)] = 9, -- Mortal Strike
		[GetSpellInfo(76622)] = 9, -- Sunder Armor
	},

	buffs = {
		--[GetSpellInfo(871)] = 15, -- Shield Wall
	},

	-- Raid Debuffs
	instances = {
		--["MapID"] = {
		--	[Name or GetSpellInfo(spellID) or SpellID] = PRIORITY,
		--},

		--[[ Siege of Orgrimmar ]]--
		[953] = {

			--Immerseus
			[GetSpellInfo(143297)] = 5, --Sha Splash
			[GetSpellInfo(143459)] = 4, --Sha Residue
			[GetSpellInfo(143524)] = 4, --Purified Residue
			[GetSpellInfo(143286)] = 4, --Seeping Sha
			[GetSpellInfo(143413)] = 3, --Swirl
			[GetSpellInfo(143411)] = 3, --Swirl
			[GetSpellInfo(143436)] = 2, --Corrosive Blast (tanks)
			[GetSpellInfo(143579)] = 3, --Sha Corruption (Heroic Only)

			--Fallen Protectors
			[GetSpellInfo(143239)] = 4, --Noxious Poison
			[GetSpellInfo(144176)] = 2, --Lingering Anguish
			[GetSpellInfo(143023)] = 3, --Corrupted Brew
			[GetSpellInfo(143301)] = 2, --Gouge
			[GetSpellInfo(143564)] = 3, --Meditative Field
			[GetSpellInfo(143010)] = 3, --Corruptive Kick
			[GetSpellInfo(143434)] = 6, --Shadow Word:Bane (Dispell)
			[GetSpellInfo(143840)] = 6, --Mark of Anguish
			[GetSpellInfo(143959)] = 4, --Defiled Ground
			[GetSpellInfo(143423)] = 6, --Sha Sear
			[GetSpellInfo(143292)] = 5, --Fixate
			[GetSpellInfo(144176)] = 5, --Shadow Weakness
			[GetSpellInfo(147383)] = 4, --Debilitation (Heroic Only)

			--Norushen
			[GetSpellInfo(146124)] = 2, --Self Doubt (tanks)
			[GetSpellInfo(146324)] = 4, --Jealousy
			[GetSpellInfo(144639)] = 6, --Corruption
			[GetSpellInfo(144850)] = 5, --Test of Reliance
			[GetSpellInfo(145861)] = 6, --Self-Absorbed (Dispell)
			[GetSpellInfo(144851)] = 2, --Test of Confiidence (tanks)
			[GetSpellInfo(146703)] = 3, --Bottomless Pit
			[GetSpellInfo(144514)] = 6, --Lingering Corruption
			[GetSpellInfo(144849)] = 4, --Test of Serenity

			--Sha of Pride
			[GetSpellInfo(144358)] = 2, --Wounded Pride (tanks)
			[GetSpellInfo(144843)] = 3, --Overcome
			[GetSpellInfo(146594)] = 4, --Gift of the Titans
			[GetSpellInfo(144351)] = 6, --Mark of Arrogance
			[GetSpellInfo(144364)] = 4, --Power of the Titans
			[GetSpellInfo(146822)] = 6, --Projection
			[GetSpellInfo(146817)] = 5, --Aura of Pride
			[GetSpellInfo(144774)] = 2, --Reaching Attacks (tanks)
			[GetSpellInfo(144636)] = 5, --Corrupted Prison
			[GetSpellInfo(144574)] = 6, --Corrupted Prison
			[GetSpellInfo(145215)] = 4, --Banishment (Heroic)
			[GetSpellInfo(147207)] = 4, --Weakened Resolve (Heroic)
			[GetSpellInfo(144574)] = 6, --Corrupted Prison
			[GetSpellInfo(144574)] = 6, --Corrupted Prison

			--Galakras
			[GetSpellInfo(146765)] = 5, --Flame Arrows
			[GetSpellInfo(147705)] = 5, --Poison Cloud
			[GetSpellInfo(146902)] = 2, --Poison Tipped blades

			--Iron Juggernaut
			[GetSpellInfo(144467)] = 2, --Ignite Armor
			[GetSpellInfo(144459)] = 5, --Laser Burn
			[GetSpellInfo(144498)] = 5, --Napalm Oil
			[GetSpellInfo(144918)] = 5, --Cutter Laser
			[GetSpellInfo(146325)] = 6, --Cutter Laser Target

			--Kor'kron Dark Shaman
			[GetSpellInfo(144089)] = 6, --Toxic Mist
			[GetSpellInfo(144215)] = 2, --Froststorm Strike (Tank only)
			[GetSpellInfo(143990)] = 2, --Foul Geyser (Tank only)
			[GetSpellInfo(144304)] = 2, --Rend
			[GetSpellInfo(144330)] = 6, --Iron Prison (Heroic)

			--General Nazgrim
			[GetSpellInfo(143638)] = 6, --Bonecracker
			[GetSpellInfo(143480)] = 5, --Assassin's Mark
			[GetSpellInfo(143431)] = 6, --Magistrike (Dispell)
			[GetSpellInfo(143494)] = 2, --Sundering Blow (Tanks)
			[GetSpellInfo(143882)] = 5, --Hunter's Mark

			--Malkorok
			[GetSpellInfo(142990)] = 2, --Fatal Strike (Tank debuff)
			[GetSpellInfo(142913)] = 6, --Displaced Energy (Dispell)
			[GetSpellInfo(143919)] = 5, --Languish (Heroic)

			--Spoils of Pandaria
			[GetSpellInfo(145685)] = 2, --Unstable Defensive System
			[GetSpellInfo(144853)] = 3, --Carnivorous Bite
			[GetSpellInfo(145987)] = 5, --Set to Blow
			[GetSpellInfo(145218)] = 4, --Harden Flesh
			[GetSpellInfo(145230)] = 1, --Forbidden Magic
			[GetSpellInfo(146217)] = 4, --Keg Toss
			[GetSpellInfo(146235)] = 4, --Breath of Fire
			[GetSpellInfo(145523)] = 4, --Animated Strike
			[GetSpellInfo(142983)] = 6, --Torment (the new Wrack)
			[GetSpellInfo(145715)] = 3, --Blazing Charge
			[GetSpellInfo(145747)] = 5, --Bubbling Amber
			[GetSpellInfo(146289)] = 4, --Mass Paralysis

			--Thok the Bloodthirsty
			[GetSpellInfo(143766)] = 2, --Panic (tanks)
			[GetSpellInfo(143773)] = 2, --Freezing Breath (tanks)
			[GetSpellInfo(143452)] = 1, --Bloodied
			[GetSpellInfo(146589)] = 5, --Skeleton Key (tanks)
			[GetSpellInfo(143445)] = 6, --Fixate
			[GetSpellInfo(143791)] = 5, --Corrosive Blood
			[GetSpellInfo(143777)] = 3, --Frozen Solid (tanks)
			[GetSpellInfo(143780)] = 4, --Acid Breath
			[GetSpellInfo(143800)] = 5, --Icy Blood
			[GetSpellInfo(143428)] = 4, --Tail Lash

			--Siegecrafter Blackfuse
			[GetSpellInfo(144236)] = 4, --Pattern Recognition
			[GetSpellInfo(144466)] = 5, --Magnetic Crush
			[GetSpellInfo(143385)] = 2, --Electrostatic Charge (tank)
			[GetSpellInfo(143856)] = 6, --Superheated

			--Paragons of the Klaxxi
			[GetSpellInfo(143617)] = 5, --Blue Bomb
			[GetSpellInfo(143701)] = 5, --Whirling (stun)
			[GetSpellInfo(143702)] = 5, --Whirling
			[GetSpellInfo(142808)] = 6, --Fiery Edge
			[GetSpellInfo(143609)] = 5, --Yellow Sword
			[GetSpellInfo(143610)] = 5, --Red Drum
			[GetSpellInfo(142931)] = 2, --Exposed Veins
			[GetSpellInfo(143619)] = 5, --Yellow Bomb
			[GetSpellInfo(143735)] = 6, --Caustic Amber
			[GetSpellInfo(146452)] = 5, --Resonating Amber
			[GetSpellInfo(142929)] = 2, --Tenderizing Strikes
			[GetSpellInfo(142797)] = 5, --Noxious Vapors
			[GetSpellInfo(143939)] = 5, --Gouge
			[GetSpellInfo(143275)] = 2, --Hewn
			[GetSpellInfo(143768)] = 2, --Sonic Projection
			[GetSpellInfo(142532)] = 6, --Toxin: Blue
			[GetSpellInfo(142534)] = 6, --Toxin: Yellow
			[GetSpellInfo(143279)] = 2, --Genetic Alteration
			[GetSpellInfo(143339)] = 6, --Injection
			[GetSpellInfo(142649)] = 4, --Devour
			[GetSpellInfo(146556)] = 6, --Pierce
			[GetSpellInfo(142671)] = 6, --Mesmerize
			[GetSpellInfo(143979)] = 2, --Vicious Assault
			[GetSpellInfo(143607)] = 5, --Blue Sword
			[GetSpellInfo(143614)] = 5, --Yellow Drum
			[GetSpellInfo(143612)] = 5, --Blue Drum
			[GetSpellInfo(142533)] = 6, --Toxin: Red
			[GetSpellInfo(143615)] = 5, --Red Bomb
			[GetSpellInfo(143974)] = 2, --Shield Bash (tanks)

			--Garrosh Hellscream
			[GetSpellInfo(144582)] = 4, --Hamstring
			[GetSpellInfo(144954)] = 4, --Realm of Y'Shaarj
			[GetSpellInfo(145183)] = 2, --Gripping Despair (tanks)
			[GetSpellInfo(144762)] = 4, --Desecrated
			[GetSpellInfo(145071)] = 5, --Touch of Y'Sharrj
			[GetSpellInfo(148718)] = 4, --Fire Pit

		},

		--[[ Throne of Thunder ]]--
		[930] = {

			--Jin'rokh the Breaker
			[GetSpellInfo(138006)] = 4, --Electrified Waters
			[GetSpellInfo(137399)] = 6, --Focused Lightning fixate
			[GetSpellInfo(138732)] = 5, --Ionization
			[GetSpellInfo(138349)] = 2, --Static Wound (tank only)
			[GetSpellInfo(137371)] = 2, --Thundering Throw (tank only)

			--Horridon
			[GetSpellInfo(136769)] = 6, --Charge
			[GetSpellInfo(136767)] = 2, --Triple Puncture (tanks only)
			[GetSpellInfo(136708)] = 6, --Stone Gaze
			[GetSpellInfo(136723)] = 5, --Sand Trap
			[GetSpellInfo(136587)] = 5, --Venom Bolt Volley (dispellable)
			[GetSpellInfo(136710)] = 5, --Deadly Plague (disease)
			[GetSpellInfo(136670)] = 4, --Mortal Strike
			[GetSpellInfo(136573)] = 5, --Frozen Bolt (Debuff used by frozen orb)
			[GetSpellInfo(136512)] = 6, --Hex of Confusion
			[GetSpellInfo(136719)] = 6, --Blazing Sunlight
			[GetSpellInfo(136654)] = 6, --Rending Charge
			[GetSpellInfo(140946)] = 4, --Dire Fixation (Heroic Only)

			--Council of Elders
			[GetSpellInfo(136922)] = 6, --Frostbite
			[GetSpellInfo(137084)] = 3, --Body Heat
			[GetSpellInfo(137641)] = 6, --Soul Fragment (Heroic only)
			[GetSpellInfo(136878)] = 5, --Ensnared
			[GetSpellInfo(136857)] = 6, --Entrapped (Dispell)
			[GetSpellInfo(137650)] = 5, --Shadowed Soul
			[GetSpellInfo(137359)] = 6, --Shadowed Loa Spirit fixate target
			[GetSpellInfo(137972)] = 6, --Twisted Fate (Heroic only)
			[GetSpellInfo(136860)] = 5, --Quicksand

			--Tortos
			[GetSpellInfo(134030)] = 6, --Kick Shell
			[GetSpellInfo(134920)] = 6, --Quake Stomp
			[GetSpellInfo(136751)] = 6, --Sonic Screech
			[GetSpellInfo(136753)] = 2, --Slashing Talons (tank only)
			[GetSpellInfo(137633)] = 5, --Crystal Shell (heroic only)

			--Megaera
			[GetSpellInfo(139822)] = 6, --Cinder (Dispell)
			[GetSpellInfo(134396)] = 6, --Consuming Flames (Dispell)
			[GetSpellInfo(137731)] = 5, --Ignite Flesh
			[GetSpellInfo(136892)] = 6, --Frozen Solid
			[GetSpellInfo(139909)] = 5, --Icy Ground
			[GetSpellInfo(137746)] = 6, --Consuming Magic
			[GetSpellInfo(139843)] = 4, --Artic Freeze
			[GetSpellInfo(139840)] = 4, --Rot Armor
			[GetSpellInfo(140179)] = 6, --Suppression (stun)

			--Ji-Kun
			[GetSpellInfo(138309)] = 4, --Slimed
			[GetSpellInfo(138319)] = 5, --Feed Pool
			[GetSpellInfo(140571)] = 3, --Feed Pool
			[GetSpellInfo(134372)] = 3, --Screech

			--Durumu the Forgotten
			[GetSpellInfo(133768)] = 2, --Arterial Cut (tank only)
			[GetSpellInfo(133767)] = 2, --Serious Wound (Tank only)
			[GetSpellInfo(136932)] = 6, --Force of Will
			[GetSpellInfo(134122)] = 5, --Blue Beam
			[GetSpellInfo(134123)] = 5, --Red Beam
			[GetSpellInfo(134124)] = 5, --Yellow Beam
			[GetSpellInfo(133795)] = 6, --Life Drain
			[GetSpellInfo(133597)] = 6, --Dark Parasite
			[GetSpellInfo(133732)] = 3, --Infrared Light (the stacking red debuff)
			[GetSpellInfo(133677)] = 3, --Blue Rays (the stacking blue debuff)
			[GetSpellInfo(133738)] = 3, --Bright Light (the stacking yellow debuff)
			[GetSpellInfo(133737)] = 4, --Bright Light (The one that says you are actually in a beam)
			[GetSpellInfo(133675)] = 4, --Blue Rays (The one that says you are actually in a beam)
			[GetSpellInfo(134626)] = 5, --Lingering Gaze

			--Primordius
			[GetSpellInfo(140546)] = 6, --Fully Mutated
			[GetSpellInfo(136180)] = 3, --Keen Eyesight (Helpful)
			[GetSpellInfo(136181)] = 4, --Impared Eyesight (Harmful)
			[GetSpellInfo(136182)] = 3, --Improved Synapses (Helpful)
			[GetSpellInfo(136183)] = 4, --Dulled Synapses (Harmful)
			[GetSpellInfo(136184)] = 3, --Thick Bones (Helpful)
			[GetSpellInfo(136185)] = 4, --Fragile Bones (Harmful)
			[GetSpellInfo(136186)] = 3, --Clear Mind (Helpful)
			[GetSpellInfo(136187)] = 4, --Clouded Mind (Harmful)
			[GetSpellInfo(136050)] = 2, --Malformed Blood(Tank Only)

			--Dark Animus
			[GetSpellInfo(138569)] = 2, --Explosive Slam (tank only)
			[GetSpellInfo(138659)] = 6, --Touch of the Animus
			[GetSpellInfo(138609)] = 6, --Matter Swap
			[GetSpellInfo(138691)] = 4, --Anima Font
			[GetSpellInfo(136962)] = 5, --Anima Ring
			[GetSpellInfo(138480)] = 6, --Crimson Wake Fixate

			--Iron Qon
			[GetSpellInfo(134647)] = 6, --Scorched
			[GetSpellInfo(136193)] = 5, --Arcing Lightning
			[GetSpellInfo(135147)] = 2, --Dead Zone
			[GetSpellInfo(134691)] = 2, --Impale (tank only)
			[GetSpellInfo(135145)] = 6, --Freeze
			[GetSpellInfo(136520)] = 5, --Frozen Blood
			[GetSpellInfo(137669)] = 3, --Storm Cloud
			[GetSpellInfo(137668)] = 5, --Burning Cinders
			[GetSpellInfo(137654)] = 5, --Rushing Winds 
			[GetSpellInfo(136577)] = 4, --Wind Storm
			[GetSpellInfo(136192)] = 4, --Lightning Storm
			[GetSpellInfo(136615)] = 6, --Electrified

			--Twin Consorts
			[GetSpellInfo(137440)] = 6, --Icy Shadows (tank only)
			[GetSpellInfo(137417)] = 6, --Flames of Passion
			[GetSpellInfo(138306)] = 5, --Serpent's Vitality
			[GetSpellInfo(137408)] = 2, --Fan of Flames (tank only)
			[GetSpellInfo(137360)] = 6, --Corrupted Healing (tanks and healers only?)
			[GetSpellInfo(137375)] = 3, --Beast of Nightmares
			[GetSpellInfo(136722)] = 6, --Slumber Spores

			--Lei Shen
			[GetSpellInfo(135695)] = 6, --Static Shock
			[GetSpellInfo(136295)] = 6, --Overcharged
			[GetSpellInfo(135000)] = 2, --Decapitate (Tank only)
			[GetSpellInfo(394514)] = 5, --Fusion Slash
			[GetSpellInfo(136543)] = 5, --Ball Lightning
			[GetSpellInfo(134821)] = 4, --Discharged Energy
			[GetSpellInfo(136326)] = 6, --Overcharge
			[GetSpellInfo(137176)] = 4, --Overloaded Circuits
			[GetSpellInfo(136853)] = 4, --Lightning Bolt
			[GetSpellInfo(135153)] = 6, --Crashing Thunder
			[GetSpellInfo(136914)] = 2, --Electrical Shock
			[GetSpellInfo(135001)] = 2, --Maim

			--Ra-Den (Heroic only)
			[GetSpellInfo(138308)] = 6, --Unstable Vita
			[GetSpellInfo(138372)] = 5, --Vita Sensitivity

		},

		--[[ Terrace of Endless Spring ]]--
		[886] = {

			--Protector Kaolan
			[GetSpellInfo(117519)] = 7, --Touch of Sha
			[GetSpellInfo(111850)] = 7, --Lightning Prison: Targeted
			[GetSpellInfo(117436)] = 7, --Lightning Prison: Stunned
			[GetSpellInfo(118191)] = 7, --Corrupted Essence
			[GetSpellInfo(117986)] = 8, --Defiled Ground: Stacks

			--Tsulong
			[GetSpellInfo(122768)] = 7, --Dread Shadows
			[GetSpellInfo(122777)] = 7, --Nightmares (dispellable)
			[GetSpellInfo(122752)] = 7, --Shadow Breath
			[GetSpellInfo(122789)] = 7, --Sunbeam
			[GetSpellInfo(123012)] = 7, --Terrorize: 5% (dispellable)
			[GetSpellInfo(123011)] = 7, --Terrorize: 10% (dispellable)
			[GetSpellInfo(123036)] = 7, --Fright (dispellable)
			[GetSpellInfo(122858)] = 6, --Bathed in Light

			--Lei Shi
			[GetSpellInfo(123121)] = 7, --Spray
			[GetSpellInfo(123705)] = 7, --Scary Fog

			--Sha of Fear
			[GetSpellInfo(119414)] = 7, --Breath of Fear
			[GetSpellInfo(129147)] = 7, --Onimous Cackle
			[GetSpellInfo(119983)] = 7, --Dread Spray
			[GetSpellInfo(120669)] = 7, --Naked and Afraid
			[GetSpellInfo(75683)] = 7, --Waterspout

			[GetSpellInfo(120629)] = 7, --Huddle in Terror
			[GetSpellInfo(120394)] = 7, --Eternal Darkness
			[GetSpellInfo(129189)] = 7, --Sha Globe
			[GetSpellInfo(119086)] = 7, --Penetrating Bolt
			[GetSpellInfo(119775)] = 7, --Reaching Attack

		},

		--[[ Heart of Fear ]]--
		[897] = {

			--Imperial Vizier Zor'lok
			[GetSpellInfo(123812)] = 7, --Pheromones of Zeal
			[GetSpellInfo(122740)] = 7, --Convert (MC)
			[GetSpellInfo(122706)] = 7, --Noise Cancelling (AMZ)

			--Blade Lord Ta'yak
			[GetSpellInfo(123474)] = 7, --Overwhelming Assault
			[GetSpellInfo(122949)] = 7, --Unseen Strike
			[GetSpellInfo(124783)] = 7, --Storm Unleashed
			[GetSpellInfo(123180)] = 8, --Wind Step

			--Garalon
			[GetSpellInfo(122835)] = 7, --Pheromones
			[GetSpellInfo(123081)] = 8, --Pungency
			[GetSpellInfo(122774)] = 7, --Crush
			[GetSpellInfo(123423)] = 8, --Weak Points

			--Wind Lord Mel'jarak
			[GetSpellInfo(121881)] = 8, --Amber Prison
			[GetSpellInfo(122055)] = 7, --Residue
			[GetSpellInfo(122064)] = 7, --Corrosive Resin

			--Amber-Shaper Un'sok
			[GetSpellInfo(121949)] = 7, --Parasitic Growth
			[GetSpellInfo(122784)] = 7, --Reshape Life

			--Grand Empress Shek'zeer
			[GetSpellInfo(123707)] = 7, --Eyes of the Empress
			[GetSpellInfo(125390)] = 7, --Fixate
			[GetSpellInfo(123788)] = 8, --Cry of Terror
			[GetSpellInfo(124097)] = 7, --Sticky Resin
			[GetSpellInfo(123184)] = 8, --Dissonance Field
			[GetSpellInfo(124777)] = 7, --Poison Bomb
			[GetSpellInfo(124821)] = 7, --Poison-Drenched Armor
			[GetSpellInfo(124827)] = 7, --Poison Fumes
			[GetSpellInfo(124849)] = 7, --Consuming Terror
			[GetSpellInfo(124863)] = 7, --Visions of Demise
			[GetSpellInfo(124862)] = 7, --Visions of Demise: Target
			[GetSpellInfo(123845)] = 7, --Heart of Fear: Chosen
			[GetSpellInfo(123846)] = 7, --Heart of Fear: Lure
			[GetSpellInfo(125283)] = 7, --Sha Corruption

		},

		--[[ Mogu'shan Vaults ]]--
		[896] = {

			--The Stone Guard
			[GetSpellInfo(130395)] = 7, --Jasper Chains
			[GetSpellInfo(130774)] = 7, --Amethyst Pool
			[GetSpellInfo(116281)] = 7, --Cobalt Mine Blast
			[GetSpellInfo(125206)] = 7, --Rend Flesh

			--Feng The Accursed
			[GetSpellInfo(131788)] = 7, --Lightning Lash
			[GetSpellInfo(116942)] = 7, --Flaming Spear
			[GetSpellInfo(131790)] = 7, --Arcane Shock
			[GetSpellInfo(131792)] = 7, --Shadowburn
			[GetSpellInfo(116784)] = 9, --Wildfire Spark
			[GetSpellInfo(116374)] = 7, --Lightning Charge
			[GetSpellInfo(116364)] = 7, --Arcane Velocity
			[GetSpellInfo(116040)] = 7, --Epicenter

			--Gara'jal the Spiritbinder
			[GetSpellInfo(122151)] = 9, --Voodoo doll
			[GetSpellInfo(117723)] = 8, --Frail Soul
			[GetSpellInfo(116260)] = 7, --Crossed Over
			[GetSpellInfo(116278)] = 7, --Soul Sever

			--The Spirit Kings
			--Meng the Demented
			[GetSpellInfo(117708)] = 7, --Maddening Shout
			--Subetai the Swift
			[GetSpellInfo(118048)] = 7, --Pillaged
			[GetSpellInfo(118047)] = 7, --Pillage: Target
			[GetSpellInfo(118135)] = 7, --Pinned Down
			[GetSpellInfo(118163)] = 7, --Robbed Blind
			--Zian of the Endless Shadow
			[GetSpellInfo(118303)] = 7, --Undying Shadow: Fixate

			--Elegon
			[GetSpellInfo(117878)] = 7, --Overcharged
			[GetSpellInfo(117949)] = 8, --Closed circuit
			[GetSpellInfo(117945)] = 7, --Arcing Energy
			-- Celestial Protector (Heroic)
			[GetSpellInfo(132222)] = 8, --Destabilizing Energies

			--Will of the Emperor
			--Jan-xi and Qin-xi
			[GetSpellInfo(116835)] = 7, --Devastating Arc
			[GetSpellInfo(132425)] = 7, --Stomp
			-- Rage
			[GetSpellInfo(116525)] = 7, --Focused Assault (Rage fixate)
			-- Courage
			[GetSpellInfo(116778)] = 7, --Focused Defense (fixate)
			[GetSpellInfo(117485)] = 7, --Impeding Thrust (slow debuff)
			-- Strength
			[GetSpellInfo(116550)] = 7, --Energizing Smash (knock down)
			-- Titan Spark (Heroic)
			[GetSpellInfo(116829)] = 7, --Focused Energy (fixate)

		},

		--[[ Dragon Soul ]]--
		[824] = {

			--Deep Corruption IDs
			[109389] = 8,
			[103628] = 8,

			--Ultraxion
			[GetSpellInfo(109075)] = 7, -- Fading Light
		},

		--[[ Firelands ]]--
		[800] = {

			--Baleroc
			[GetSpellInfo(100232)] = 9, -- Torment
		},

		--[[ Baradin Hold ]]--
		[752] = {

			[GetSpellInfo(88954)] = 6, -- Consuming Darkness
		},

		--[[ Blackwing Descent ]]--
		[754] = {

			--Magmaw
			[GetSpellInfo(78941)] = 6, -- Parasitic Infection
			[GetSpellInfo(89773)] = 7, -- Mangle

			--Omnitron Defense System
			[GetSpellInfo(79888)] = 6, -- Lightning Conductor
			[GetSpellInfo(79505)] = 8, -- Flamethrower
			[GetSpellInfo(80161)] = 7, -- Chemical Cloud
			[GetSpellInfo(79501)] = 8, -- Acquiring Target
			[GetSpellInfo(80011)] = 7, -- Soaked in Poison
			[GetSpellInfo(80094)] = 7, -- Fixate
			[GetSpellInfo(92023)] = 9, -- Encasing Shadows
			[GetSpellInfo(92048)] = 9, -- Shadow Infusion
			[GetSpellInfo(92053)] = 9, -- Shadow Conductor
			--[GetSpellInfo(91858)] = 6, -- Overcharged Power Generator

			--Maloriak
			[GetSpellInfo(92973)] = 8, -- Consuming Flames
			[GetSpellInfo(92978)] = 8, -- Flash Freeze
			[GetSpellInfo(92976)] = 7, -- Biting Chill
			[GetSpellInfo(91829)] = 7, -- Fixate
			[GetSpellInfo(92787)] = 9, -- Engulfing Darkness

			--Atramedes
			[GetSpellInfo(78092)] = 7, -- Tracking
			[GetSpellInfo(78897)] = 8, -- Noisy
			[GetSpellInfo(78023)] = 7, -- Roaring Flame

			--Chimaeron
			[GetSpellInfo(89084)] = 8, -- Low Health
			[GetSpellInfo(82881)] = 7, -- Break
			[GetSpellInfo(82890)] = 9, -- Mortality

			--Nefarian
			[GetSpellInfo(94128)] = 7, -- Tail Lash
			--[GetSpellInfo(94075)] = 8, -- Magma
			[GetSpellInfo(79339)] = 9, -- Explosive Cinders
			[GetSpellInfo(79318)] = 9, -- Dominion
		},

		--[[ The Bastion of Twilight ]]--
		[758] = {

			--Halfus
			[GetSpellInfo(39171)] = 7, -- Malevolent Strikes
			[GetSpellInfo(86169)] = 8, -- Furious Roar

			--Valiona & Theralion
			[GetSpellInfo(86788)] = 6, -- Blackout
			[GetSpellInfo(86622)] = 7, -- Engulfing Magic
			[GetSpellInfo(86202)] = 7, -- Twilight Shift

			--Council
			[GetSpellInfo(82665)] = 7, -- Heart of Ice
			[GetSpellInfo(82660)] = 7, -- Burning Blood
			[GetSpellInfo(82762)] = 7, -- Waterlogged
			[GetSpellInfo(83099)] = 7, -- Lightning Rod
			[GetSpellInfo(82285)] = 7, -- Elemental Stasis
			[GetSpellInfo(92488)] = 8, -- Gravity Crush

			--Cho'gall
			[GetSpellInfo(86028)] = 6, -- Cho's Blast
			[GetSpellInfo(86029)] = 6, -- Gall's Blast
			[GetSpellInfo(93189)] = 7, -- Corrupted Blood
			[GetSpellInfo(93133)] = 7, -- Debilitating Beam
			[GetSpellInfo(81836)] = 8, -- Corruption: Accelerated
			[GetSpellInfo(81831)] = 8, -- Corruption: Sickness
			[GetSpellInfo(82125)] = 8, -- Corruption: Malformation
			[GetSpellInfo(82170)] = 8, -- Corruption: Absolute

			--Sinestra
			[GetSpellInfo(92956)] = 9, -- Wrack
		},

		--[[ Throne of the Four Winds ]]--
		[773] = {

			--Conclave
			[GetSpellInfo(85576)] = 9, -- Withering Winds
			[GetSpellInfo(85573)] = 9, -- Deafening Winds
			[GetSpellInfo(93057)] = 7, -- Slicing Gale
			[GetSpellInfo(86481)] = 8, -- Hurricane
			[GetSpellInfo(93123)] = 7, -- Wind Chill
			[GetSpellInfo(93121)] = 8, -- Toxic Spores

			--Al'Akir
			--[GetSpellInfo(93281)] = 7, -- Acid Rain
			[GetSpellInfo(87873)] = 7, -- Static Shock
			[GetSpellInfo(88427)] = 7, -- Electrocute
			[GetSpellInfo(93294)] = 8, -- Lightning Rod
			[GetSpellInfo(93284)] = 9, -- Squall Line
		},
	},
}
