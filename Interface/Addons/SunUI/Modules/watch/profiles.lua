local S, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local

local FG = S:NewModule("Filger", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

----------------------------------------------------------------------------------------
--	ShestakUI_Filger personal configuration file
--	BACKUP THIS FILE BEFORE UPDATING!
--	ATTENTION: When saving changes to a file encoded file should be in UTF8
--  作为玩家单独添加的法术保存的文件 请记得保存编码为UTF-8
----------------------------------------------------------------------------------------
--	Configuration example:
--  这是一个例子
----------------------------------------------------------------------------------------
-- if S.myclass == "MegaChar" then
--		FG["filger_position"].player_buff_icon = {"BOTTOMRIGHT", "oUF_Player", "TOPRIGHT", 2, 173}
--		add("T_DEBUFF_ICON", {spellID = 115767, unitID = "target", caster = "player", filter = "DEBUFF"})
-- end

--意思是给MegaChar职业的T_DEBUFF_ICON 分组 添加 法术ID为115767的技能
----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
--	Function for insert spell
----------------------------------------------------------------------------------------
local add = function(place, spell)
	for class, _ in pairs(FG["filger_spells"]) do
		if class == S.myclass then
			for i = 1, #FG["filger_spells"][class], 1 do
				if FG["filger_spells"][class][i]["Name"] == place then
					table.insert(FG["filger_spells"][class][i], spell)
				end
			end
		end
	end
end

----------------------------------------------------------------------------------------
--	Per Class Config (overwrite general)
--	Class need to be UPPERCASE
-- 下面的是职业分组
----------------------------------------------------------------------------------------
if S.myclass == "DRUID" then

end

----------------------------------------------------------------------------------------
--	Per Character Name Config (overwrite general and class)
--	Name need to be case sensitive
--  特定角色名分组
----------------------------------------------------------------------------------------
if S.myname == "CharacterName" then

end

----------------------------------------------------------------------------------------
--	Per Max Character Level Config (overwrite general, class and name)
--  不同等级分组
--  UnitLevel("player") 为你当前等级 MAX_PLAYER_LEVEL为你需要匹配的等级
--  ~=为匹配方式 可以改为 > 大于 >= 大于等于 < 小于 <= 小于等于  == 等于 ~= 不等于
----------------------------------------------------------------------------------------
if UnitLevel("player") ~= MAX_PLAYER_LEVEL then

end