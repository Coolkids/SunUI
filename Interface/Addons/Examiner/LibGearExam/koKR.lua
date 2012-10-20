-- Korean localization by omosiro(자매 of KR-Norgannon), 09.02.20
-- Modified by chkid(주시자의눈 of KR-Ellune) for WotLK, 09.05.11

if (GetLocale() ~= "koKR") then
	return;
end

LibGearExam.Patterns = {
	--  기본 능력치  --
	{ p = "힘 %+(%d+)", s = "STR" },
	{ p = "민첩성 %+(%d+)", s = "AGI" },
	{ p = "체력 %+(%d+)", s = "STA" },
	{ p = "지능 %+(%d+)", s = "INT" },
	{ p = "정신력 %+(%d+)", s = "SPI" },
	{ p = "방어도 (%d+)", s = "ARMOR" }, -- 모든 방어구에서 확인해야 함: 기본 방어도, 방어 마법부여, 방어구 키트

	--  저항력 (Exclude the Resist-"ance" then it picks up armor patches as well)  --
	{ p = "비전 저항력 %+(%d+)", s = "ARCANERESIST" },
	{ p = "화염 저항력 %+(%d+)", s = "FIRERESIST" },
	{ p = "자연 저항력 %+(%d+)", s = "NATURERESIST" },
	{ p = "냉기 저항력 %+(%d+)", s = "FROSTRESIST" },
	{ p = "암흑 저항력 %+(%d+)", s = "SHADOWRESIST" },
	{ p = "모든 저항력 %+(%d+)", s = { "ARCANERESIST", "FIRERESIST", "NATURERESIST", "FROSTRESIST", "SHADOWRESIST" } }, -- 공허의 구슬

	--  장비: 기타  --
	{ p = ": 탄력도가 (%d+)만큼 증가합니다.", s = "RESILIENCE" },

	{ p = ": 방어 숙련도가 (%d+)만큼 증가합니다.", s = "DEFENSE" },
	{ p = ": 회피 숙련도가 (%d+)만큼 증가합니다.", s = "DODGE" },
	{ p = ": 무기 막기 숙련도가 (%d+)만큼 증가합니다.", s = "PARRY" },
	{ p = ": 방패 막기 숙련도가 (%d+)만큼 증가합니다.", s = "BLOCK" }, -- 고전과 신규 형태 둘다 확인해야 함

	{ p = ": 방패의 피해 방어량이 (%d+)만큼 증가합니다.", s = "BLOCKVALUE" },
	{ p = "^(%d+)의 피해 방어$", s = "BLOCKVALUE" }, -- 방패에서 기본 피해 방어량만 확인해야 됨

	--  장비: 근접 & 원거리  --
	{ p = "^전투력이 (%d+)만큼 증가합니다.", s = "AP" }, -- koKR only
	{ p = ": 전투력이 (%d+)만큼 증가합니다.", s = "AP" },
	{ p = "원거리 전투력이 (%d+)만큼 증가합니다.", s = "RAP" },

	{ p = ": 숙련도가 (%d+)만큼 증가합니다.", s = "EXPERTISE" }, -- New 2.3 Stat
	{ p = "공격 시 적의 방어도를 (%d+)만큼 무시합니다.", s = "ARMORPENETRATION" }, -- Armor Penetration in 3.0
	{ p = "방어구 관통력이 (%d+)만큼 증가합니다.", s = "ARMORPENETRATION" }, -- koKR only

	--  장비: 주문력  --
	{ p = "주문 관통력이 (%d+)만큼 증가합니다.", s = "SPELLPENETRATION" },

	{ p = ": 주문력이 (%d+)만큼 증가합니다.", s = { "HEAL", "SPELLDMG" } },
	{ p = ": 주문력이 약간 증가합니다.", s = { "HEAL", "SPELLDMG" }, v = 6 }, -- 마력의 청동 고리

	{ p = "암흑 및 냉기 주문력 %+(%d+)", s = { "SHADOWDMG", "FROSTDMG" } },	-- 구 "냉기의 영혼" 마법부여
	{ p = "비전 및 화염 주문력 %+(%d+)", s = { "ARCANEDMG", "FIREDMG" } },	-- 구 "태양의 불꽃" 마법부여

	{ p = ": 비전 계열의 주문력이 (%d+)만큼 증가합니다.", s = "ARCANEDMG" },
	{ p = ": 화염 계열의 주문력이 (%d+)만큼 증가합니다.", s = "FIREDMG" },
	{ p = ": 자연 계열의 주문력이 (%d+)만큼 증가합니다.", s = "NATUREDMG" },
	{ p = ": 냉기 계열의 주문력이 (%d+)만큼 증가합니다.", s = "FROSTDMG" },
	{ p = ": 암흑 계열의 주문력이 (%d+)만큼 증가합니다.", s = "SHADOWDMG" },
	{ p = ": 신성 계열의 주문력이 (%d+)만큼 증가합니다.", s = "HOLYDMG" },

	--  장비: 근접 및 주문 모두 향상된 능력치  --
	{ p = ": 치명타 적중도가 (%d+)만큼 증가합니다.", s = { "CRIT", "SPELLCRIT" } },
	{ p = ": 치명타 및 주문 극대화 적중도가 (%d+)만큼 증가합니다.", s = { "CRIT", "SPELLCRIT" } },
	{ p = ": 적중도가 (%d+)만큼 증가합니다.", s = { "HIT", "SPELLHIT" } },

	{ p = ": 가속도가 (%d+)만큼 증가합니다.", s = { "HASTE", "SPELLHASTE" } },

	--  5초당 생명력 및 마나  --
	{ p = "매 5초마다 (%d+)의 생명력이 회복됩니다%.", s = "HP5" },
	{ p = "매 5초마다 (%d+)의 생명력 회복%.", s = "HP5" },
	{ p = "5초당 생명력 회복량 %+(%d+)", s = "HP5" }, -- koKR only
	{ p = "5초당 (%d+)의 생명력 회복.", s = "HP5" }, -- koKR only

	{ p = "^마나 회복량 %+(%d+)", s = "MP5" }, -- 점술가 어깨보호구 마법부여
	{ p = "^마나 회복 %+(%d+)", s = "MP5" }, -- 사제 줄구룹 마법부여
	{ p = "/ 마나 회복량 %+(%d+)$", s = "MP5" }, -- koKR only
	{ p = "매 5초마다 (%d+)의 마나 회복", s = "MP5" }, -- 마법학자의 방어구 키트
	{ p = "매 5초마다 (%d+)의 마나가 회복됩니다%.", s = "MP5" }, -- koKR only

	{ p = "5초당 마나 회복량 %+(%d+)", s = "MP5" }, -- 보석: 호화로운 암흑 드레나이트 / 기막힌 치유의 영석(고룡쉼터 사원 용군단)
	{ p = "5초당 (%d+)의 마나 회복%.", s = "MP5" }, -- 손목보호구 마법부여

  --  마법부여 / 보석 / 소켓 보너스 / 혼합 / 기타  --
	{ p = "^생명력 %+(%d+)$", s = "HP" },
	{ p = "^마나 %+(%d+)$", s = "MP" },

-- 아래의 모든 마법부여된 아이템의 툴팁 문구가 변경됨
--	{ p = "^활력$", s = { "MP5", "HP5" }, v = 4 },
--	{ p = "^상급 활력$", s = { "MP5", "HP5" }, v = 6 },
--	{ p = "^전투력$", s = "AP", v = 70 },
--	{ p = "^냉기의 영혼$", s = { "FROSTDMG", "SHADOWDMG" }, v = 54 },
--	{ p = "^태양의 불꽃$", s = { "ARCANEDMG", "FIREDMG" }, v = 50 },
--	{ p = "^침착함$", s = { "CRIT", "HIT", "SPELLCRIT", "SPELLHIT" }, v = 10 }, -- 장화
--	{ p = "^극지방랑자$", s = { "CRIT", "HIT", "SPELLCRIT", "SPELLHIT" }, v = 12 }, -- 장화
--	{ p = "^적중$", s = { "CRIT", "HIT", "SPELLCRIT", "SPELLHIT" }, v = 25 }, -- 무기

	{ p = "^돌가죽 가고일의 룬$", s = "DEFENSE", v = 25 }, -- 죽음의 기사 마법부여, 또한 2% 체력 추가

	-- Az: these 3 was added 09.01.05 and has not been checked out in game yet, please confirm they are correct.
	{ p = "^티타늄 무기사슬$", s = { "HIT", "SPELLHIT" }, v = 28 },
	{ p = "^티타늄 도금$", s = "BLOCKVALUE", v = 40 }, -- koKR only [Titanium Plating(44936)]
--	{ p = "^투스카르의 활력$", s = "STA", v = 15 },
--	{ p = "^지혜$", s = "SPI", v = 10 },

	{ p = "모든 능력치 %+(%d+)", s = { "STR", "AGI", "STA", "INT", "SPI" } }, -- 가슴보호구 + 손목보호구 마법부여

	{ p = "비전 주문력 %+(%d+)", s = "ARCANEDMG" },
	{ p = "화염 주문력 %+(%d+)", s = "FIREDMG" },
	{ p = "자연 주문력 %+(%d+)", s = "NATUREDMG" },
	{ p = "냉기 주문력 %+(%d+)", s = "FROSTDMG" },
	{ p = "암흑 주문력 %+(%d+)", s = "SHADOWDMG" },
	{ p = "신성 주문력 %+(%d+)", s = "HOLYDMG" },

	{ p = "방어 숙련도 %+(%d+)", s = "DEFENSE" }, -- 이것은 성기사 줄구룹 마법부여에서 확인된 패턴으로 "Rating" 제외함
	{ p = "회피 숙련도 %+(%d+)", s = "DODGE" },
	{ p = "무기 막기 숙련도 %+(%d+)", s = "PARRY" }, -- Az: 확인을 위해 더 이상 플러스 표시가 필요치 않음
	{ p = "방패 막기 숙련도 %+(%d+)", s = "BLOCK" }, -- 통합된 패턴: 사례 [방패 마법부여] [소켓 보너스]

	{ p = "방패 피해 방어량 %+(%d+)", s = "BLOCKVALUE" },

	{ p = "^전투력 %+(%d+)", s = "AP" },
	{ p = "[:/] 전투력 %+(%d+)", s = "AP" },
	{ p = "원거리 전투력 %+(%d+)", s = "RAP" },
	{ p = "^적중도 %+(%d+)", s = { "HIT", "SPELLHIT" } }, -- koKR only
	{ p = "[:/] 적중도 %+(%d+)", s = { "HIT", "SPELLHIT" } },
	{ p = "^치명타 및 주문 극대화 적중도 %+(%d+)", s = { "CRIT", "SPELLCRIT" } },
	{ p = "[:/] 치명타 및 주문 극대화 적중도 %+(%d+)", s = { "CRIT", "SPELLCRIT" } }, -- koKR only
	{ p = "탄력도 %+(%d+)", s = "RESILIENCE" },
	{ p = "^가속도 %+(%d+)", s = { "HASTE", "SPELLHASTE" } },
	{ p = ": 가속도 %+(%d+)", s = { "HASTE", "SPELLHASTE" } }, -- koKR only
	{ p = "^숙련도 %+(%d+)", s = "EXPERTISE" },
	{ p = "^숙련 %+(%d+)", s = "EXPERTISE" }, -- koKR only
	{ p = ": 숙련도 %+(%d+)", s = "EXPERTISE" }, -- koKR only
	{ p = ": 숙련 %+(%d+)", s = "EXPERTISE" }, -- koKR only

	{ p = "^주문력 %+(%d+)", s = { "SPELLDMG", "HEAL" } }, -- 몇몇 아이템/보석은 리치왕의 분노 이전에도 사용됨, 하지만 지금은 영구적인 주문 패턴임.
	{ p = "[:/] 주문력 %+(%d+)", s = { "SPELLDMG", "HEAL" } }, -- koKR only
	{ p = "주문 적중률 %+(%d+)", s = "SPELLHIT" }, -- 이것은 마법사 줄구룹 마법부여에서 확인된 패턴으로 "Rating" 제외함
	{ p = "^주문 극대화 적중도 %+(%d+)", s = "SPELLCRIT" },
	{ p = "주문 가속도 %+(%d+)", s = "SPELLHASTE" }, -- 보석에서 확인
	{ p = "주문 관통력 %+(%d+)", s = "SPELLPENETRATION" },
	{ p = "치유 및 주문력 %+(%d+)", s = { "SPELLDMG", "HEAL" } }, -- koKR only
	{ p = "주문력 및 치유량 %+(%d+)", s = { "SPELLDMG", "HEAL" } }, -- koKR only

	{ p = "무기 공격력 %+(%d+)", s = "WPNDMG" }, -- Added optional space as I found a "+1  Weapon Damage" enchant on someone
	{ p = "^조준경 %(공격력 %+(%d+)%)$", s = "RANGEDDMG" },

	-- 악마의 피 (퀘스트: 악마 라크리크와의 대결 - 저주받은 땅)
	{ p = "방어 숙련도가 5만큼, 암흑 마법 저항력이 10만큼 증가하고 평상시 생명력 회복 속도가 3만큼 향상됩니다.", s = { "DEFENSE", "SHADOWRESIST", "HP5" }, v = { 5, 10, 3 } },

	-- 공허의 별 부적 (흑마법사 T5 직업 장신구)
	{ p = "소환수의 저항력이 130만큼 증가하고 주문력이 48만큼 증가합니다.", s = "SPELLDMG", v = 48 },

	-- 기타 마법부여들 (Disabled as they are not part of "gear" stats)
	--{ p = "최하급 마나 오일", s = "MP5", v = 4 },
	--{ p = "하급 마나 오일", s = "MP5", v = 8 },
	--{ p = "최고급 마나 오일", s = "MP5", v = 14 },
	--{ p = "반짝이는 마나 오일", s = { "MP5", "HEAL" }, v = { 12, 25 } },

	--{ p = "최하급 마술사 오일", s = "SPELLDMG", v = 8 },
	--{ p = "하급 마술사 오일", s = "SPELLDMG", v = 16 },
	--{ p = "마술사 오일", s = "SPELLDMG", v = 24 },
	--{ p = "최고급 마술사 오일", s = "SPELLDMG", v = 42 },
	--{ p = "반짝이는 마술사 오일", s = { "SPELLDMG", "SPELLCRIT" }, v = { 36, 14 } },

	-- 미래의 패턴 (사용안됨)
	--{ p = "가격 당했을 때 공격자에게 (%d+) .+ 피해를 입힙니다.", s = "DMGSHIELD" }, -- 서슬 건틀릿(칼날바람 알진 - 혈투의 전장)
};