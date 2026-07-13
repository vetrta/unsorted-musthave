lastUrgentHeal = 0;
HealCaptureDynFrame = CreateUIComponent("Frame", "HealCaptureDyn_Frame", "UIParent");

HealCaptureDynFrame:SetSize(0,0);
HealCaptureDynFrame:ClearAllAnchors();
HealCaptureDynFrame:SetAnchor("TOP", "TOP", "UIParent", 0, 0);
HealCaptureDynFrame:SetScripts("OnLoad",  [=[ HealCaptureDyn_Frame:RegisterEvent("COMBATMETER_HEAL") ]=] );
HealCaptureDynFrame:SetScripts("OnEvent", [=[ if (event=="COMBATMETER_HEAL") and (_skill=="Urgent Heal") then lastUrgentHeal=_heal; end; ]=] );

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- Gds -- Beta --
--
-- written by Moo, Vernberg,
--
-- additional classes will be added
--
--
--UnitManaType("player")==4 UnitMana("player")>25 
---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Memory Table for futher class making
---------------------------------------------------------------------------------------------------------------------------------------------------------
-- MANA 1 Mage, Priest, Knight, Warden
-- RAGE 2 Warrior, Champion
-- FOCUS 3 Scout,Warlock
-- ENERGY 4 Rogue

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- UnitSkillType("player")==1       = Mana
-- UnitManaType("player")==2         = Rage
-- UnitSkillType("player")==3       = Focus
-- UnitManaType("player")==4        = Energy

-- UnitSkill("player")>70           = Amount Mana or Focus needed
-- UnitMana("player")>25            = Amount Rage or Energy needed 
-- -- -- -- -- -- -- -- -- 
-- Uses Skill from game
-- CSBN = Cast Skill by name
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Uses the build in skill table
-- GABN = Get Action by name
-- UABS = Use Action by slot or skill name in GABN
---------------------------------------------------------------------------------------------------------------------------------------------------------

-- Function to use item by id:
function UIBI(id)
 if (id) then
-- UseItemByName(TEXT('Sys'..id..'_name'));
  for bagIndex = 1, 180, 1 do
   local inventoryIndex, icon, name, itemCount, locked, quality = GetBagItemInfo(bagIndex); 
   if name == TEXT('Sys'..id..'_name') then
	Sol.io.Print(TEXT('Sys'..id..'_name').." | "..inventoryIndex.." | "..bagIndex);
   end;
  end
 end
end


-- Common funtions:
function UIBN(name)
 UseItemByName(name)
end


-- Function to check Actionicons:
function CheckActionIcons()
 for i=1,80,1 do icon_path = GetActionInfo(i); if (icon_path) then Sol.io.Print(i.." : "..icon_path); end; end
end;



-- Skill Table and item Table:
function GABN(actionName,errordisplay)
local skilltable={
--Normal Attack
{ name="Attack", iconpath="skill_att" },
--Potions & Foods
{ name="Housekeeper Special Caviar Sandwich", iconpath="item_food_030_006" },
{ name="Strong Stimulant", iconpath="item_potion_020_005" },
{ name="Extinction Potion", iconpath="item_potion_010_003" },
{ name="Tranquility Powder", iconpath="item_potion_040_010" },
{ name="Touch of the Unicorn", iconpath="item_potion_050_003" },
{ name="Serenstum", iconpath="item_sweets_070_004" },
{ name="Deadly Potion", iconpath="item_potion_050_003" },
--Warden General Skills
{ name="Charged Chop", iconpath="skill_ward1-1" },
{ name="Briar Shield", iconpath="skill_ward4-1" },
{ name="Power of the Wood Spirit", iconpath="skill_ward8-1" },
{ name="Elven Amulet", iconpath="skill_ward16-1" },
{ name="Savage Power", iconpath="skill_ward20-1" },
--Warden Specific Skills
{ name="Energy Absorb", iconpath="skill_ward1-4" },
{ name="Recall Pet", iconpath="skill_run3-2" },
{ name="Summon Spirit of the Oak", iconpath="skill_ward1-2" },
{ name="Thorny Vines", iconpath="skill_ward2-1" },
{ name="Elven Prayer", iconpath="skill_ward6-1" },
{ name="Movement Restriction", iconpath="skill_ward10-1" },
{ name="Summon Nature Crystal", iconpath="skill_ward14-1" },
{ name="Damage Transfer", iconpath="skill_ward22-1" },
{ name="Heart of the Oak", iconpath="skill_ward24-1" },
{ name="Frantic Briar", iconpath="skill_ward26-1" },
{ name="Summon Oak Walker", iconpath="skill_ward30-1" },
{ name="Protection of Nature", iconpath="skill_ward32-2" },
{ name="Banish", iconpath="skill_ward36-1" },
{ name="Power of the Oak", iconpath="skill_ward42-1" },
{ name="Explosion of Power", iconpath="skill_ward44-1" },
{ name="Elven Guidance", iconpath="skill_ward48-1" },
{ name="Cross Chop", iconpath="skill_ward50-1" },
--Warden Item Set Skills
{ name="Dance of Confusion", iconpath="sp_ward_004" },
--Warden/Warrior
{ name="Double Chop", iconpath="skill_ward_new15-1" },
{ name="Beast Chop", iconpath="skill_ward_new20-4" },
{ name="Ire", iconpath="skill_war_new24-1" },
{ name="Immortal Power", iconpath="skill_war_new30-1" },
{ name="Pulse Mastery", iconpath="skill_war_new35-1" },
{ name="Coat of Arms", iconpath="skill_war_new50-1" },
{ name="Feral Leader", iconpath="skill_ward_war70" },
--Warden/Scout
{ name="Untamable", iconpath="skill_ward_new25-2" },
--Warrior General Skills
{ name="Slash", iconpath="skill_war1-1" },
{ name="Enraged", iconpath="skill_war_aggregation" },
{ name="Whirlwind", iconpath="skill_war15-2" },
{ name="Berserk", iconpath="skill_war12-1" },
{ name="Defensive Formation", iconpath="skill_war24-2" },
--Warrior Primary Skills
{ name="Frenzy", iconpath="skill_war_berserk" },
{ name="Open Flank", iconpath="skill_war3-2" },
{ name="Probing Attack", iconpath="skill_thi3-1" },
{ name="Tactical Attack", iconpath="skill_war9-1" },
{ name="Thunder", iconpath="skill_war15-1" },
{ name="Feint", iconpath="skill_war6-1" },
{ name="Surprise Attack", iconpath="skill_war6-2" },
{ name="Taunt", iconpath="skill_war9-2" },
{ name="Moon Cleave", iconpath="skill_war18-1" },
{ name="Shout", iconpath="skill_war18-2" },
{ name="Terror", iconpath="skill_war27-2" },
{ name="Aggresiveness", iconpath="skill_war39-1" },
{ name="Survival Instinct", iconpath="skill_war36-1" },
{ name="Group Taunt", iconpath="skill_war39-2" },
{ name="Blasting Cyclone", iconpath="skill_war72-1" },
-- Warrior Item Set Skills
{ name="Energy Restore", iconpath="sp_goods_003" },
{ name="Punishment ISS", iconpath="sp_war_004" },
{ name="Sword of Imprisonment", iconpath="sp_war_005" },
{ name="Guardian of the Pass", iconpath="sp_war_011" },
-- Warrior/Rogue skills
{ name="Blood Dance", iconpath="skill_war_new20-2" },
{ name="Keen Attack", iconpath="skill_war_new35-2" },
{ name="Splitting Chop", iconpath="skill_war_new40-2" },
-- Rogue General Skills
{ name="Shadowstab", iconpath="skill_thi1-1" },
{ name="Shadow Step", iconpath="skill_thi27-2" },
{ name="Wound Attack", iconpath="skill_thi6-1" },
{ name="Low Blow", iconpath="skill_thi12-1" },
{ name="Throw", iconpath="skill_thi1-2" },
{ name="Premeditation", iconpath="skill_thi18-2" },
{ name="Quickness Aura", iconpath="skill_thi_new15-2" },
{ name="Poison", iconpath="skill_thi15-1" },
{ name="Enchanted Throw", iconpath="skill_thi_mag15" },
{ name="Lion's Protection", iconpath="skill_thi_new50-2" },
{ name="Holy Light Protection", iconpath="skill_thi_new15-5" },
{ name="Searing Light", iconpath="skill_thi_new45-10" },
{ name="Fervent Attack", iconpath="skill_thi8-1" },
{ name="Informer", iconpath="skill_thi48-2" },
{ name="Assassins Rage", iconpath="skill_thi_absolutestrike" },
{ name="Illusion Blade Dance", iconpath="skill_thi_mag70" },
{ name="Create Opportunity", iconpath="skill_thi_new45-8" },
{ name="Yawaka's Blessing", iconpath="sp_thi_008" },
--{ name="Blind Spot", iconpath="skill_thi3-1" },
-- Warrior/Mage skills
{ name="Electrical Rage", iconpath="skill_war_new15-3" },
{ name="Lightning's Touch", iconpath="skill_war_new20-4" },
{ name="Sense of Danger", iconpath="skill_war_new50-1" },
{ name="Lightning Burn Weapon", iconpath="skill_war_mag60" },
-- Warrior/Scout skills
{ name="Aim for the Wound", iconpath="skill_war_new15-1"},
{ name="Sword Breath", iconpath="skill_war_new35-1"},
{ name="Skull Breaker", iconpath="skill_war_new45-1"},
{ name="The Final Battle", iconpath="skill_war_new50-3"},
-- Warrior/Knight skills
{ name="Blocking Stance", iconpath="skill_war_new15-4"},
{ name="Ignore Pain", iconpath="skill_war_new50-2"},
{ name="Throw Shield", iconpath="skill_war_new45-5"},
{ name="Shield Bash", iconpath="skill_war_new20-5"},
-- Warrior/Champion skills
{ name="Bloody Slash", iconpath="skill_war_psy25-1"},
{ name="Stifling Attack", iconpath="skill_war_psy45-1"},
{ name="Vendetta Blow", iconpath="skill_war_psy50-1"},
-- Warrior/Priest skills
{ name="Defender's Roar", iconpath="skill_war_new60-3"},
{ name="Interrupting Strike", iconpath="skill_war_new45-3"},
{ name="Magic Barrier", iconpath="skill_aug69-1"},
-- Priest General Skills
{ name="Rising Tide", iconpath="skill_aug1-1" },
{ name="Urgent Heal", iconpath="skill_aug42-3" },
{ name="Regenerate", iconpath="skill_aug3-1" },
{ name="Holy Aura", iconpath="skill_aug54-1" },
{ name="Magic Barrier", iconpath="skill_aug69-1" },
{ name="Blessed Spring Water", iconpath="skill_aug42-1" },
--Scout General Skills
{ name="Shot", iconpath="skill_ran1-2" },
{ name="Vampire Arrows", iconpath="skill_ran6-3" },
{ name="Joint Blow", iconpath="skill_ran1-1" },
{ name="Blood Arrow", iconpath="skill_ran9-1" },
{ name="Throat Attack", iconpath="skill_ran6-1" },
{ name="Wrist Attack", iconpath="skill_ran18-2" },
{ name="Piercing Arrow", iconpath="skill_ran21-1" },
{ name="Reflected Shot", iconpath="skill_ran27-1" },
{ name="Autoshot", iconpath="skill_ran_new35-7" },
{ name="Combo Shot", iconpath="skill_ran3-1" },
--Scout/Rogue Skills
{ name="Deadly Poison Bite", iconpath="skill_ran_new35-6" },
{ name="Sapping Arrow", iconpath="skill_ran_new25-2" },
-- Priest Primary Skills
{ name="Soul Source", iconpath="skill_aug18-1" },
{ name="Wave Armor", iconpath="skill_aug3-2" },
{ name="Heal", iconpath="skill_aug1-2" },
{ name="Bone Chill", iconpath="skill_aug12-4" },
{ name="Ice Fog", iconpath="skill_aug6-1" },
--Resurrection
{ name="Soul Bond", iconpath="skill_aug36-1" },
{ name="Grace of Life", iconpath="skill_aug21-2" },
{ name="Group Heal", iconpath="skill_aug12-2" },
{ name="Chain of Light", iconpath="skill_aug12-3" },
{ name="Cleanse", iconpath="skill_aug_new35-1" },
--Advanced Resurrection
{ name="Amplified Attack", iconpath="skill_mag_powerup" },
{ name="Healing Salve", iconpath="skill_aug30-2" },
{ name="Blessing of Humility", iconpath="skill_aug51-2" },
--Supreme Resurrection
--Holy Candle
-- Priest/Scout Elite Skills
{ name="Embrace of the Water Spirit", iconpath="skill_aug_new15-3" },
{ name="Curing Shot", iconpath="skill_aug_new35-9" },
{ name="Ice Blades", iconpath="skill_aug_new40-2" },
-- Priest Item Set Skills
{ name="Holy Candle Shield", iconpath="sp_aug_002" },
{ name="Cleanse ISS", iconpath="sp_aug_004" },
{ name="Frost Death", iconpath="sp_aug_z20_001" },
{ name="Altar of Shadoj", iconpath="sp_aug_005" },
--druid/scout skills
{ name="Summon Sandstorm", iconpath="skill_dru46-1" },
{ name="Earth Arrow", iconpath="skill_dru1-2" },
{ name="Recover", iconpath="skill_dru1-1" },
{ name="Blossoming Life", iconpath="skill_dru10-1" },
{ name="Mother Earth's Protection", iconpath="skill_dru20-1" },
{ name="Earth Pulse", iconpath="skill_dru12-1" },
{ name="Mother Nature's Wrath", iconpath="skill_dru44-1" },
{ name="Rockslide", iconpath="skill_dru18-1" },
{ name="Purify", iconpath="skill_dru2-2" },
{ name="Spirit Guidance", iconpath="skill_dru32-1" },
{ name="Body Vitalization", iconpath="skill_dru34-1" },
{ name="Curing Seed", iconpath="skill_dru24-1" },
{ name="Concentration Prayer", iconpath="skill_dru26-1" },
{ name="Savage Blessing", iconpath="skill_dru8-1" },
{ name="Warm Spring", iconpath="skill_ran_new_35-2" },
{ name="Mother Earth's Fountain", iconpath="skill_dru36-1" },
{ name="Healing Arrows", iconpath="skill_dru_new20-1" },
{ name="Camellia Flower", iconpath="skill_dru_new15-1" },
{ name="Unity with Mother Earth", iconpath="skill_dru10-2" },
{ name="Antidote", iconpath="skill_dru4-1" },
{ name="Advanced Rebirth", iconpath="skill_dru12-2" },
{ name="Restore Life", iconpath="skill_dru6-1" },
{ name="Group Exorcism", iconpath="skill_ran_new30-3" },
{ name="Rock Protection", iconpath="skill_dru30-1" },
{ name="Vampire Arrows", iconpath="skill_ran6-3" },
{ name="Wrist Attack", iconpath="skill_ran18-2" },
{ name="Joint Blow", iconpath="skill_ran1-1" },
{ name="Throat Attack", iconpath="skill_ran6-1" },
{ name="Binding Silence", iconpath="skill_dru22-1" },
{ name="Earth Arrow", iconpath="skill_dru1-2" },
{ name="Withering Seed", iconpath="skill_dru42-1" },
{ name="Weakening Seed", iconpath="skill_dru14-1" },
{ name="Briar Entwinement", iconpath="skill_dru2-1" },
--Mage General Skills:
{ name="Fireball", iconpath="skill_mag1-1" },
{ name="Lightning", iconpath="skill_mag3-1" },
{ name="Intensification", iconpath="skill_mag12-2" },
{ name="Silence", iconpath="skill_aug39-2" },
{ name="Fire Ward", iconpath="skill_mag42-2" },
--Mage Primary Skills:
{ name="Elemental Catalysis", iconpath="skill_mag18-1" },
{ name="Flame", iconpath="skill_mag6-2" },
{ name="Electrostatic Charge", iconpath="skill_mag15-1" },
{ name="Plasma Arrow", iconpath="skill_mag_new50-6" },
{ name="Discharge", iconpath="skill_mag_24-1" },
{ name="Electric Bolt", iconpath="skill_mag_new50-5" },
{ name="Meteor Shower", iconpath="skill_mag_54-1" },
{ name="Electric Explosion", iconpath="skill_mag_new50-7" },
{ name="Phoenix", iconpath="skill_mag_21-2" },
{ name="Electric Compression", iconpath="skill_mag_new50-8" },
{ name="Static Field", iconpath="skill_mag_new50-9" },
{ name="Purgatory Fire", iconpath="skill_mag72-1" },
{ name="Energy Influx", iconpath="skill_mag6-1" },
{ name="Energy Well", iconpath="skill_mag48-2" },
{ name="Elemental Weakness", iconpath="skill_mag30-2" },
{ name="Thunderstorm", iconpath="skill_mag27-2" },
--Mage/Warlock
{ name="Static Resonance", iconpath="skill_mag_har_15-1" },
{ name="Breath Erase", iconpath="skill_mag_har_30-1" },
{ name="Soul Stepping", iconpath="skill_mag_har_40-1" },
{ name="Deep Inspiration", iconpath="skill_mag_har_45-1" },
{ name="Fire Lightning Burst", iconpath="skill_mag_har_50-1" },
--Warlock General Skills:
{ name="Psychic Arrows", iconpath="skill_har1-1" },
{ name="Weakening Weave Curse", iconpath="skill_har4-1" },
{ name="Warp Charge", iconpath="skill_har1-2" },
{ name="Soul Pain", iconpath="skill_har12-1" },
{ name="Surge of Malice", iconpath="skill_har16-1" },
{ name="Saces' Scorn", iconpath="skill_har20-1" },
--Warlock/Mage
{ name="Heart Collection Strike", iconpath="skill_har22-1" },
{ name="Flaming Heart Strike", iconpath="skill_har_mag20-1" },
{ name="Puzzlement", iconpath="skill_har32-1" },
{ name="Soul Trauma", iconpath="skill_boss_skill_123" },
{ name="Beast's Roar", iconpath="skill_har26-1" },
{ name="Shield of Solid Mind", iconpath="skill_har14-1" },
{ name="Defense Net", iconpath="skill_har28-1" },
{ name="Saces' Embrace", iconpath="skill_har38-1" },
{ name="Perplexed", iconpath="skill_aug_new50-13" },
{ name="Soul Pain", iconpath="skill_har12-1" },
{ name="Perception Extraction", iconpath="skill_har6-1" },
{ name="Psychic Arrows", iconpath="skill_har1-1" },
{ name="Surge of Awareness", iconpath="skill_har36-1" },
{ name="Willpower Construct", iconpath="skill_har_0-2" },
{ name="Locked Heart", iconpath="skill_boss_skill_100" },
{ name="Life Weave", iconpath="skill_boss_skill_132" },
{ name="Otherworldy Whisper", iconpath="skill_har30-2" },
{ name="Mind Barrier", iconpath="skill_har20-2" },
{ name="Willpower Blade", iconpath="skill_har_0-1" },
{ name="Ruthless Judgement", iconpath="skill_har20-3" },
{ name="Severed Consciousness", iconpath="skill_har10-1" },
{ name="Knowledge Acquisition", iconpath="skill_har30-3" },
{ name="Soul Brand Sting", iconpath="skill_har_mag45-1" },
{ name="Sublimation Weave Curse", iconpath="skill_boss_skill_153" },


--Knight General Skills:
{ name="Holy Strike", iconpath="skill_kni5-1" },
{ name="Punishment", iconpath="skill_kni1-2" },
{ name="Disarmament", iconpath="skill_kni12-1" },
{ name="Strike of Punishment", iconpath="skill_war54-1" },
{ name="Enhanced Armor", iconpath="skill_kni3-1" },
{ name="Shield of Discipline", iconpath="skill_kni48-1" },
--Knight Primary Skills:
{ name="Holy Shield", iconpath="skill_kni_godshield" },
{ name="Holy Power Explosion", iconpath="skill_kni12-2" },
{ name="Holy Seal", iconpath="skill_kni10-1" },
{ name="Whirlwind Shield", iconpath="skill_kni20-1" },
{ name="Shackles of Light", iconpath="skill_kni15-2" },
{ name="Resolution", iconpath="skill_kni36-1" },
{ name="Charge", iconpath="skill_kni21-2" },
{ name="Threaten", iconpath="skill_kni16-1" },
{ name="Shield of Valor", iconpath="skill_kni115-1" },
{ name="Truth Shield Bash", iconpath="skill_kni27-2" },
{ name="Shock", iconpath="skill_kni9-1" },
{ name="Holy Strength", iconpath="skill_kni12-3" },
{ name="Hall of Dead Heroes", iconpath="skill_kni72-1" },
--Knight/priest
{ name="Holy Protection", iconpath="skill_kni_new45-3" },
--Knight/Mage Elites
{ name="Holy Light Domain", iconpath="skill_kni_new20-3" },
{ name="Light Energy Weapon", iconpath="skill_kni24-2" },
{ name="Mana Shield", iconpath="skill_kni_new60-5" },
{ name="War Prayer", iconpath="skill_kni_new50-9" },
--Champion General Skills
{ name="Electrocution", iconpath="skill_psy1-2" },
{ name="Heavy Bash", iconpath="skill_psy1-1" },
{ name="Energy Influx Strike", iconpath="skill_psy6-1" },
{ name="Shock Strike", iconpath="skill_psy20-1" },
--Champion Primary Skills
{ name="Forge", iconpath="skill_psy2-1" },
{ name="Rune Draw", iconpath="skill_psy4-1" },
{ name="Rune Pulse", iconpath="skill_psy10-1" },
{ name="Fearless Blow", iconpath="skill_psy14-1" },
{ name="Shield Form", iconpath="skill_psy16-2" },
{ name="Rune Energy Influx", iconpath="skill_psy18-2" },
{ name="Rune Growth", iconpath="skill_psy24-1" },
{ name="Agitated Whirlpool", iconpath="skill_psy26-1" },
{ name="Vacuum Wave", iconpath="skill_psy28-1" },
{ name="Imprisonment Pulse", iconpath="skill_psy32-1" },
{ name="Kinetic Burn", iconpath="skill_psy34-1" },
{ name="Feedback Defense", iconpath="skill_psy36-1" },
{ name="Overrule", iconpath="skill_psy36-2" },
{ name="Remodeled Body", iconpath="skill_psy38-1" },
{ name="Rune Overload", iconpath="skill_psy40-1" },
{ name="Key Rescue", iconpath="skill_mag_new30-1" },
--Champion Item Set Skills
{ name="Disassembly Mode", iconpath="sp_har_003" },
{ name="Battle Defense Transfer", iconpath="sp_har_005" },
{ name="Organic Deconstruction", iconpath="sp_har_011" },
--Champion/Mage Elite Skills
{ name="Backlash Armor", iconpath="skill_mag_new15-1" },
{ name="Suppression Offensive", iconpath="skill_mag_new20-1" },
{ name="Bloody Experience", iconpath="skill_mag_new35-1" },
{ name="Rapid Spread", iconpath="skill_mag_new50-1" },
{ name="Elemental Rampage", iconpath="skill_psy_mag60-1" },
{ name="High-Energy Barrier", iconpath="skill_mag_new45-1" },
--Champion/Rogue Elite Skills
{ name="Shadow Pulse", iconpath="skill_psy_thi20-1" },
{ name="Waiting Game", iconpath="skill_psy_thi30-1" },
{ name="Death Arrives", iconpath="skill_psy_thi50-1" },
{ name="Smoke Diffusion", iconpath="skill_psy_thi60-1" },
{ name="Shadow Explosion", iconpath="skill_psy_thi70-1" },
--Champion/Priest Elite Skills
{ name="Divine Vengeance", iconpath="skill_psy_pri15-1" },
{ name="Rune Energy Consecration", iconpath="skill_psy_pri20-1" },
{ name="Salvation Engraving", iconpath="skill_psy_pri25-1" },
{ name="Light Pulse", iconpath="skill_psy_pri35-1" },
{ name="Suicide Advance", iconpath="skill_psy_pri40-1" },
{ name="Holy Attack", iconpath="skill_psy_pri45-1" },
--Champion/Warlock Elite Skills
{ name="Endless Pulse", iconpath="skill_har_new15-1" },
{ name="Rune Siphon", iconpath="skill_har_new20-1" },
{ name="Dark Energy Strike", iconpath="skill_har_new30-1" },
{ name="Indomitable Spirit", iconpath="skill_har_new35-1" },
{ name="Heart Collection Rune", iconpath="skill_har_new40-1" },
{ name="Soul Forge Mystery", iconpath="skill_har_new45-1" },
{ name="Dark Energy Punishment", iconpath="skill_har_new50-1" },
{ name="Psychic Rampage", iconpath="skill_psy_har70-1" },
--Champion/Warrior Elite Skills
{ name="Arc Strike", iconpath="skill_war_new15-1" },
{ name="Determination Rune", iconpath="skill_war_new30-1" },
{ name="Deadland Protection", iconpath="skill_psy_war70-1" },
}
--Sol.io.Print("Looking for: "..actionName); --
 for _, actioncheck in pairs(skilltable) do
  if string.match(actioncheck.name,"^"..actionName.."$") then
--   Sol.io.Print("Found skill : "..actioncheck.name.." with icon"..actioncheck.iconpath); --
   for i=1,81,1 do
	if i==81 then 
	 if (errordisplay) then Sol.io.Print("Please place skill named "..actionName.." on Action Bar"); return false;
	 else return false; end;
	end
	aicon_path = GetActionInfo(i);
	if (aicon_path) then
	 checka, _ = string.gsub(aicon_path,"interface/*.*/","")
	 checkb, _ = string.gsub(checka,".dds","");
	 check, _ = string.gsub(checkb,"\\*.*\\","")
--	 if string.match(actioncheck.iconpath,aicon_path) then
	  if check == actioncheck.iconpath then
--	  Sol.io.Print("Found skill at actionbar: "..i); --
      if GetActionUsable(i) then return i else return false end;
	 end
	end;
   end
  end
 end
end

function repairItems()
 for i=0,22,1 do dV,dM,iN,dVf,dMf = GetInventoryItemDurable("player",i);
  if (iN) then
   if ((dMf>10100 and 10100>dVf) or (7000>dVf)) then UseItemByName(TEXT("Sys201967_name")); PickupEquipmentItem(i); Sol.io.Print(iN..": Repaired"); return
   else
   -- Sol.io.Print(iN..": Good enough");
   end;
  end;
 end;
end;

function IsSkillUsable(SkillName, ShouldUse)
 -- checks if skill is usable (uses skill panel to determine usability. useage is flawed with ranged skills)
 for x=1,4,1 do totalCount = GetNumSkill(x)
  if (totalCount) then
   for y=1,totalCount,1 do
    local name, _, _, _, _, _, _, _, usable = GetSkillDetail(x,y)
    if string.lower(name) == string.lower(SkillName) and usable == true then totalCD, remainingCD = GetSkillCooldown(x, y);
     if (remainingCD <1) then
      if ShouldUse then UseSkill(x,y);
	  end;
      return true
     end
    end
   end
  end
 end
 return false
end

function CheckDebuff(debuffName)
-- checks if target has a specified debuff
 for i=1,50 do
 local currentbuff,_,_,id=UnitDebuff("target",i)
 if currentbuff then
   if string.lower(currentbuff) == string.lower(debuffName) then return true end
 else return false end
end
end

function CheckBuff(buffName,unit)
 if not (unit) then unit="player"; end;
-- checks if player has a specified buff
 for i=1,50 do
 local currentbuff,_,_,id=UnitBuff(unit,i)
 if currentbuff then
  if string.lower(currentbuff) == string.lower(buffName) then return true end
  else return false end
 end
end


function CheckBuffCount(buffName,target)
if not target then target="player"; end;
-- checks if player has a specified buff and returns it's count
 for i=1,50 do
 local currentbuff,_,currentcount,id=UnitBuff(target,i)
 if currentbuff then
  if string.lower(currentbuff) == string.lower(buffName) then return currentcount end
  else return false end
 end
end

function CheckBuffTime(unitName,buffName)
-- checks if player has a specified buff and returns it's remaining time
 for i=1,50 do
 local currentbuff,_,_,id=UnitBuff("player",i)
 if currentbuff then
   if string.lower(currentbuff) == string.lower(buffName) then return UnitBuffLeftTime(unitName,i) end
 else return false end
end
end

-- the functions above remain for backwards compatibility
function BuffCheck(buffname, unit)
if not (buffname) then Sol.io.Print("BuffCheck function usage: BuffCheck(buffname, unit);"); return false; end;
if not (unit) then unit ="player"; end;
for i=1,50 do
 local currentbuffname, _, currentbuffcount, currentbuffid = UnitBuff(unit, i);
  if currentbuffname then
	if string.lower(currentbuffname) == string.lower(buffname) then
		return true, currentbuffcount, UnitBuffLeftTime(unit,i); end;
  else return false, 0, 0; end
 end
end

function DebuffCheck(debuffname, unit)
if not (debuffname) then Sol.io.Print("DebuffCheck function usage: DebuffCheck(buffname, unit);"); return false; end;
if not (unit) then unit ="target"; end;
for i=1,50 do
 local currentdebuffname, _, currentdebuffcount, currentdebuffid = UnitDebuff(unit, i);
  if currentdebuffname then
	if string.lower(currentdebuffname) == string.lower(debuffname) then
		return true, currentdebuffcount, UnitDebuffLeftTime(unit,i); end;
  else return false end
 end
end

function CSBN(skill)
-- shorter function for CastSpellByName()
 CastSpellByName(skill)
-- DEFAULT_CHAT_FRAME:AddMessage("Used "..skill,1,1,1);
end

function UABS(slot) --"slot" or "skill name in GABN"
-- shorter function for UseAction()
 if tonumber(slot) == nil then slot = GABN(slot); end;
 UseAction(slot)
-- DEFAULT_CHAT_FRAME:AddMessage("Used "..skill,1,1,1);
end


function IsTargetCasting()
-- checks if target is casting something (checks API UnitCastingTime. flawed)
 if UnitExists("target") then
  SpellName, maxCastTime, currentCastTime = UnitCastingTime("target")
  if maxCastTime>currentCastTime then return SpellName
  else return false end
 end
end

function ShouldInterrupt()
local SkillCheck = IsTargetCasting();
if SkillCheck then
end;

interruptList = {
['Recover']	= true,
['Restore Life'] = true,
['Heal'] = true,
['Curing Shot']	= true,
['Urgent Heal']	= true,
['Annihilation'] = true,		
['King Bug Shock'] = true,
['Mana Rift'] = true,
['Dream of Gold'] = true,
['Leaves of Fire'] = true,
['Heavy Shelling'] = true,
['Dark Healing'] = true,
--Skills
['Snipe'] = true,
['Severed Consciousness'] = true,
['Psychic Arrows'] = true, 
['Warp Charge']	= true,
['Weakening Weave Curse'] = true,
['Beasts Roar']	= true,
['Flame'] = true,
['Flame Spell']	= true,
['Wave Bomb'] = true,
--Herald
['Summoning: Tornado'] = true,
['Thunder Force'] = true,
['Raise Morale'] = true,
['Fearless'] = true,
['Ironblood Army Spirit'] = true,
['Honor Guard'] = true,
}
end

interruptList = {
['Recover']	= true,
['Restore Life'] = true,
['Heal'] = true,
['Curing Shot']	= true,
['Urgent Heal']	= true,
['Annihilation'] = true,		
['King Bug Shock'] = true,
['Mana Rift'] = true,
['Dream of Gold'] = true,
['Leaves of Fire'] = true,
['Heavy Shelling'] = true,
['Dark Healing'] = true,
--Skills
['Snipe'] = true,
['Severed Consciousness'] = true,
['Blasting Cyclone'] = true,
['Psychic Arrows'] = true, 
['Warp Charge']	= true,
['Weakening Weave Curse'] = true,
['Beasts Roar']	= true,
['Flame'] = true,
['Flame Spell']	= true,
['Wave Bomb'] = true,
--Herald
['Summoning: Tornado'] = true,
['Thunder Force'] = true,
['Raise Morale'] = true,
['Fearless'] = true,
['Ironblood Army Spirit'] = true,
['Honor Guard'] = true,
}



function mootarget()
	for i=1,10,1 do 
		TargetNearestEnemy()
		if UnitIsPlayer("target") and not UnitIsDeadOrGhost("target") then break
		else TargetUnit("")
		end
	end
end

-- Classtokens:
--WARRIOR->Warrior == class id = 1
--RANGER->Scout    == class id = 2
--THIEF->Rogue     == class id = 3
--MAGE->Mage       == class id = 4
--AUGUR->Priest    == class id = 5
--KNIGHT->Knight   == class id = 6
--WARDEN->Warden   == class id = 7
--DRUID->Druid     == class id = 8
--HARPSYN->Warlock == class id = 9
--PSYRON->Champion == class id = 10

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Functions for Classes
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
--Knight
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function KP()
local mainClass, subClass = UnitClassToken("player")

if mainClass=="KNIGHT" then
	if subClass=="AUGUR" then

		local eabn, _, eabr = BuffCheck("Enhanced Armor","player");
		local mben, _, mber = BuffCheck("Magic Barrier","player");
		local hptn, _, hptr = BuffCheck("Holy Protection","player");
		
		
		if not eabn and GABN("Enhanced Armor") then UABS("Enhanced Armor");
		elseif eabr and 30>eabr and GABN("Enhanced Armor") then UABS("Enhanced Armor");
		elseif not mben and GABN("Magic Barrier") then UABS("Magic Barrier");
		elseif mber and 30>mber and GABN("Magic Barrier") then UABS("Magic Barrier");
		elseif not hptn and GABN("Holy Protection") then UABS("Holy Protection");
		elseif hptr and 30>hptr and GABN("Holy Protection") then UABS("Holy Protection");
        elseif not CheckBuff("Holy Protection") and IsSkillUsable("Holy Protection") then CSBN("Holy Protection");		

	
		elseif 0.9>UnitHealth("player")/UnitMaxHealth("player") and GABN("Holy Illumination") then UABS("Holy Illumination");	
		elseif 0.8>UnitHealth("player")/UnitMaxHealth("player") and GABN("Hall of Dead Heroes") then UABS("Hall of Dead Heroes");			
		elseif 0.7>UnitHealth("player")/UnitMaxHealth("player") and GABN("Shield of Discipline") then UABS("Shield of Discipline");
		elseif 0.6>UnitHealth("player")/UnitMaxHealth("player") and GABN("Holy Shield") then UABS("Holy Shield");
		elseif 0.4>UnitHealth("player")/UnitMaxHealth("player") and GABN("Shield of Valor") then UABS("Shield of Valor");		
		elseif 0.2>UnitHealth("player")/UnitMaxHealth("player") and GABN("Holy Power Explosion") then UABS("Holy Power Explosion")
		elseif 0.2>UnitHealth("player")/UnitMaxHealth("player") and GABN("Holy Aura") then UABS("Holy Aura")
		end
		end
		end
		end

function KM()
local mainClass, subClass = UnitClassToken("player")			
if mainClass=="KNIGHT" then		
    if subClass=="MAGE" then
		UseSkill(1,1);	
		local hldn, _, hldr = BuffCheck("Holy Light Domain","player");
		local lewn, _, lewr = BuffCheck("Light Energy Weapon","player");
		local eabn, _, eabr = BuffCheck("Enhanced Armor","player");
		if not lewn and GABN("Light Energy Weapon") then UABS("Light Energy Weapon");
		elseif lewr and 30>lewr and GABN("Light Energy Weapon") then UABS("Light Energy Weapon");
		elseif not eabn and GABN("Enhanced Armor") then UABS("Enhanced Armor");
		elseif eabr and 30>eabr and GABN("Enhanced Armor") then UABS("Enhanced Armor");
--		elseif 0.7>UnitHealth("player")/UnitMaxHealth("player") and GABN("Shield of Discipline") then UABS("Shield of Discipline");
--		elseif 0.5>UnitHealth("player")/UnitMaxHealth("player") and GABN("Shield of Valor") then UABS("Shield of Valor");
		elseif 0.5>UnitHealth("player")/UnitMaxHealth("player") and GABN("Mana Shield") then UABS("Mana Shield")
		elseif UnitCanAttack("player","target") then
        if IsSkillUsable("Holy Light Domain") and not hldn then CSBN("Holy Light Domain");	
        end
        end	
		else 
		local hldn, _, hldr = BuffCheck("Holy Light Domain","player");
		if not hldn and GABN("Holy Light Domain") then UABS("Holy Light Domain") end;
		end
		end	 
	 end

function Knight()
local mainClass, subClass = UnitClassToken("player")

if mainClass=="KNIGHT" then		
    if subClass=="MAGE" then
	
		local lewn, _, lewr = BuffCheck("Light Energy Weapon","player");
		local eabn, _, eabr = BuffCheck("Enhanced Armor","player");
		local nSpell,tTotal,tRemaining = UnitCastingTime("target")
		local interruptSkill = GABN("Lightning") or GABN("Silence");		
		
		if not lewn and GABN("Light Energy Weapon") then UABS("Light Energy Weapon");
		elseif lewr and 30>lewr and GABN("Light Energy Weapon") then UABS("Light Energy Weapon");
		elseif not eabn and GABN("Enhanced Armor") then UABS("Enhanced Armor");
		elseif eabr and 30>eabr and GABN("Enhanced Armor") then UABS("Enhanced Armor");
--		elseif 0.7>UnitHealth("player")/UnitMaxHealth("player") and GABN("Shield of Discipline") then UABS("Shield of Discipline");
--		elseif 0.5>UnitHealth("player")/UnitMaxHealth("player") and GABN("Shield of Valor") then UABS("Shield of Valor");
		elseif 0.8>UnitHealth("player")/UnitMaxHealth("player") and GABN("Mana Shield") then UABS("Mana Shield")
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then
		if IsTargetCasting() and interruptSkill and interruptList[nSpell] and ((tTotal - tRemaining) > 0.1) then UABS(interruptSkill); end;
		UseSkill(1,1);
		if UnitCanAttack("player","target") then
        local hldn, _, hldr = BuffCheck("Holy Light Domain","player");	
		if not hldn and GABN("Holy Light Domain") then UABS("Holy Light Domain");	
		end
		end
		end
		end
		end
		end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------  
 --Rogue
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function Rm()
local mainClass, subClass = UnitClassToken("player")
if mainClass=="THIEF" then
	if subClass=="MAGE" then
	if not  CheckBuff("Enchanted Throw") and IsSkillUsable("Enchanted Throw") then CSBN("Enchanted Throw");			
	elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then		
	UseSkill(1,1);
    if UnitCanAttack("player","target") then
	local bleed, _, _ = DebuffCheck("Bleed","target");
    local gswd, _, _ = DebuffCheck("Grievous Wound","target");
    if bleed and gswd and UnitManaType("player")==4 and UnitMana("player")>20 and GABN("Wound Attack") then UABS("Wound Attack")	
	elseif bleed and UnitManaType("player")==4 and UnitMana("player")>30 and GABN("Low Blow") then UABS("Low Blow")	
    elseif not bleed and UnitManaType("player")==4 and UnitMana("player")>80 and GABN("Shadowstab") then UABS("Shadowstab")		
end
end
end
end
end
end


function Rbuff()
local mainClass, subClass = UnitClassToken("player")
if mainClass=="THIEF" then
	if subClass=="MAGE" then
	if not CheckBuff("Informer") and IsSkillUsable("Informer") then CSBN("Informer");                               	      --60sec      	
    elseif not CheckBuff("Fervent Attack") and IsSkillUsable("Fervent Attack") then CSBN("Fervent Attack");	                  --30sec	
    elseif not CheckBuff("Illusion Blade Dance") and IsSkillUsable("Illusion Blade Dance") then CSBN("Illusion Blade Dance"); --30sec		
    elseif not CheckBuff("Evasion") and IsSkillUsable("Evasion") then CSBN("Evasion");	                                      --20sec
    elseif not CheckBuff("Create Opportunity") and IsSkillUsable("Create Opportunity") then CSBN("Create Opportunity");       --15sec		
    elseif not CheckBuff("Assassins Rage") and IsSkillUsable("Assassins Rage") then CSBN("Assassins Rage");	                  --15sec	
	
end	
elseif subClass=="KNIGHT" then
	if not CheckBuff("Evasion") and IsSkillUsable("Evasion") then CSBN("Evasion");		
    elseif not CheckBuff("Fervent Attack") and IsSkillUsable("Fervent Attack") then CSBN("Fervent Attack");	
    elseif not CheckBuff("Informer") and IsSkillUsable("Informer") then CSBN("Informer");	
    elseif not CheckBuff("Assassins Rage") and IsSkillUsable("Assassins Rage") then CSBN("Assassins Rage");	
end	
elseif subClass=="DRUID" then
	if not CheckBuff("Evasion") and IsSkillUsable("Evasion") then CSBN("Evasion");		
    elseif not CheckBuff("Fervent Attack") and IsSkillUsable("Fervent Attack") then CSBN("Fervent Attack");	
    elseif not CheckBuff("Informer") and IsSkillUsable("Informer") then CSBN("Informer");	
    elseif not CheckBuff("Assassins Rage") and IsSkillUsable("Assassins Rage") then CSBN("Assassins Rage");	
end	
elseif subClass=="WARDEN" then
	if not CheckBuff("Evasion") and IsSkillUsable("Evasion") then CSBN("Evasion");		
    elseif not CheckBuff("Fervent Attack") and IsSkillUsable("Fervent Attack") then CSBN("Fervent Attack");	
    elseif not CheckBuff("Informer") and IsSkillUsable("Informer") then CSBN("Informer");	
    elseif not CheckBuff("Assassins Rage") and IsSkillUsable("Assassins Rage") then CSBN("Assassins Rage");	
end	
elseif subClass=="WARRIOR" then
	if not CheckBuff("Evasion") and IsSkillUsable("Evasion") then CSBN("Evasion");		
    elseif not CheckBuff("Fervent Attack") and IsSkillUsable("Fervent Attack") then CSBN("Fervent Attack");	
    elseif not CheckBuff("Informer") and IsSkillUsable("Informer") then CSBN("Informer");	
    elseif not CheckBuff("Assassins Rage") and IsSkillUsable("Assassins Rage") then CSBN("Assassins Rage");	
		
		
end
end
end
end




function Rouge()
local mainClass, subClass = UnitClassToken("player")

if mainClass=="THIEF" then
	if subClass=="MAGE" then
	local nSpell,tTotal,tRemaining = UnitCastingTime("target")
	local interruptSkill = GABN("Lightning") or GABN("Silence");	
    if not CheckBuff("Enchanted Throw") and GABN("Enchanted Throw") then UABS(GABN("Enchanted Throw"));	
	elseif not CheckBuff("Yawaka's Blessing") and GABN("Yawaka's Blessing") then UABS(GABN("Yawaka's Blessing"));
	elseif 0.6>UnitHealth("player")/UnitMaxHealth("player") and GABN("Evasion") then UABS("Evasion");		
	elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then
	if IsTargetCasting() and interruptSkill and interruptList[nSpell] and ((tTotal - tRemaining) > 0.1) then UABS(interruptSkill); end;
	UseSkill(1,1);
    if UnitCanAttack("player","target") then
	local bleed, _, _ = DebuffCheck("Bleed","target");	
    local gswd, _, _ = DebuffCheck("Grievous Wound","target");
	if bleed and gswd and UnitManaType("player")==4 and UnitMana("player")>20 and GABN("Wound Attack") then UABS("Wound Attack")		
	elseif bleed and UnitManaType("player")==4 and UnitMana("player")>30 and GABN("Low Blow") then UABS("Low Blow")
    elseif not bleed and UnitManaType("player")==4 and UnitMana("player")>20 and GABN("Shadowstab") then UABS("Shadowstab")	
end
end
end

elseif subClass=="KNIGHT" then	
	local eabn, _, eabr = BuffCheck("Enhanced Armor","player");	
	local lpbn, _, lpbr = BuffCheck("Lion's Protection","player");	
	local slbn, _, slbr = BuffCheck("Searing Light","player");
	local psdn, _, _ = DebuffCheck("Punishment Stun","target");	
    if not CheckBuff("Enhanced Armor") and GABN("Enhanced Armor") then UABS(GABN("Enhanced Armor"));
	elseif not CheckBuff("Lion's Protection") and GABN("Lion's Protection") then UABS(GABN("Lion's Protection"));
	elseif not CheckBuff("Searing Light") and GABN("Searing Light") then UABS(GABN("Searing Light"));	
	elseif not CheckBuff("Yawaka's Blessing") and GABN("Yawaka's Blessing") then UABS(GABN("Yawaka's Blessing"));	
	elseif 0.6>UnitHealth("player")/UnitMaxHealth("player") and GABN("Evasion") then UABS("Evasion");		
	elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then			
	UseSkill(1,1);
    if UnitCanAttack("player","target") then
	local bleed, _, _ = DebuffCheck("Bleed","target");	
    local gswd, _, _ = DebuffCheck("Grievous Wound","target");
	if bleed and gswd and UnitManaType("player")==4 and UnitMana("player")>20 and GABN("Wound Attack") then UABS("Wound Attack")
	elseif not psdn and UnitSkillType("player")==1 and UnitSkill("player")>100 and GABN("Strike of Punishment") then UABS("Strike of Punishment");		
	elseif bleed and UnitManaType("player")==4 and UnitMana("player")>30 and GABN("Low Blow") then UABS("Low Blow")
    elseif not bleed and UnitManaType("player")==4 and UnitMana("player")>20 and GABN("Shadowstab") then UABS("Shadowstab")					
end
end
end

elseif subClass=="DRUID" then
	if not  CheckBuff("Poisonous") and IsSkillUsable("Poison") then CSBN("Poison");
	elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then		
	UseSkill(1,1);
    if UnitCanAttack("player","target") then
	local bleed, _, _ = DebuffCheck("Bleed","target");
    local gswd, _, _ = DebuffCheck("Grievous Wound","target");
    if bleed and gswd and UnitManaType("player")==4 and UnitMana("player")>20 and GABN("Wound Attack") then UABS("Wound Attack")	
	elseif bleed and UnitManaType("player")==4 and UnitMana("player")>30 and GABN("Low Blow") then UABS("Low Blow")	
    elseif not bleed and UnitManaType("player")==4 and UnitMana("player")>80 and GABN("Shadowstab") then UABS("Shadowstab")		
end
end
end
end
end
end


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------  
--Warrior
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
function Warrior()
local mainClass, subClass = UnitClassToken("player")

if mainClass=="WARRIOR" then
	if subClass=="MAGE" then
		if not CheckBuff("Lightning Burn Weapon") and GABN("Lightning Burn Weapon") then UABS(GABN("Lightning Burn Weapon"));
		elseif 0.3>UnitHealth("player")/UnitMaxHealth("player") and GABN("Sense of Danger") then UABS(GABN("Sense of Danger"));
		elseif 0.5>UnitHealth("player")/UnitMaxHealth("player") and GABN("Survival Instinct") then UABS(GABN("Survival Instinct"));
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then						
		UseSkill(1,1);
		if UnitCanAttack("player","target") then
		local elrn, elrc, elrr = BuffCheck("High Voltage"); 
    if GABN("Electrical Rage") and elrc==3 and 4>elrr and UnitMana("player")>20 and UnitSkill("player")>400 then UABS("Electrical Rage");
    elseif GABN("Electrical Rage") and elrc==2 and UnitMana("player")>20 and UnitSkill("player")>400 then UABS("Electrical Rage");
    elseif GABN("Electrical Rage") and elrc==1 and UnitMana("player")>20 and UnitSkill("player")>400 then UABS("Electrical Rage");
    elseif GABN("Electrical Rage") and not elrn and UnitMana("player")>20 and UnitSkill("player")>400 then UABS("Electrical Rage");

end
end
end

elseif subClass=="PSYRON" then
		local wild, _, _ = BuffCheck("Wild Slash","player");
		local stif, _, _ = DebuffCheck("Stifling Attack","target");
		local gotn, _, gotr = BuffCheck("Guardian of the Pass","player");
 		if not gotn and GABN("Guardian of the Pass") then UABS("Guardian of the Pass");
		elseif gotr and 30>gotr and GABN("Guardian of the Pass") then UABS("Guardian of the Pass");	
		elseif 0.5>UnitHealth("player")/UnitMaxHealth("player") and GABN("Survival Instinct") then UABS(GABN("Survival Instinct"));
		elseif 0.3>UnitHealth("player")/UnitMaxHealth("player") and GABN("Defensive Formation") then UABS(GABN("Defensive Formation"));
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then
		if UnitCanAttack("player","target") then
    if wild and GABN("Stifling Attack") then UABS("Stifling Attack");
    elseif wild and GABN("Bloody Slash") then UABS("Bloody Slash") ;
    elseif wild and GABN("Vendetta Blow") then UABS("Vendetta Blow") ;
    elseif GABN("Slash") then UABS("Slash");
end
end
end


-- elseif subClass=="THIEF" then
-- 		local bleed, _, _ = DebuffCheck("Bleed","target");
-- 		local vulnerable, _, _ = DebuffCheck("Vulnerable","target");
-- 		local Weakened, _, _ = DebuffCheck("Weakened","target");	
-- 		UseSkill(1,1);
-- 		if UnitCanAttack("player","target") then		
 --    if UnitSkillType("player")==4 and UnitSkill("player")>40 and UnitMana("player")<50 and GABN("Shadowstab") then UABS("Shadowstab") 
 --    elseif vulnerable and UnitManaType("player")==2 and UnitMana("player")>10 and GABN("Open Flank") then UABS("Open Flank");
 --    elseif bleed and UnitManaType("player")==2 and UnitMana("player")>15 and GABN("Tactical Attack") then UABS("Tactical Attack");
 --    elseif UnitManaType("player")==2 and UnitMana("player")>20 and GABN("Probing Attack") then UABS("Probing Attack")
 --    elseif UnitManaType("player")==2 and UnitMana("player")>25 and GABN("Slash") then UABS("Slash")	
 -- 		
-- end
-- end		
-- 	
-- elseif subClass=="RANGER" then	
-- 	local bleed, _, _ = DebuffCheck("Bleed","target");
-- 	local vulnerable, _, _ = DebuffCheck("Vulnerable","target");
-- 	local Weakened, _, _ = DebuffCheck("Weakened","target");		
-- 	UseSkill(1,1);		
--     if UnitCanAttack("player","target") then
-- 	if 0.30>UnitHealth("target")/UnitMaxHealth("target") and UnitManaType("player")==2 and IsSkillUsable("The Final Battle") then CSBN("The Final Battle");	
-- 	elseif IsSkillUsable("Vampire Arrows") then CSBN("Vampire Arrows");
 --   	elseif not bleed and UnitManaType("player")==2 and UnitMana("player")>20 and GABN("Probing Attack") then UABS("Probing Attack")	
 --    elseif not vulnerable and UnitManaType("player")==2 and UnitMana("player")>25 and GABN("Slash") then UABS("Slash")		     	
--     elseif vulnerable and UnitManaType("player")==2 and UnitMana("player")>10 and GABN("Open Flank") then UABS("Open Flank");
--  	elseif bleed and UnitManaType("player")==2 and UnitMana("player")>15 and GABN("Tactical Attack") then UABS("Tactical Attack");
--    elseif UnitSkillType("player")==3 and UnitSkill("player")>30 and UnitMana("player")<30 and GABN("Skull Breaker") then UABS("Skull Breaker") 	
	
-- end
-- end	

-- elseif  subClass=="AUGUR" then
-- 		local drn, _, drr = BuffCheck("Defender's Roar","player");
--  		local mbn, _, mbr = BuffCheck("Enhanced Magic Barrier","player");			
-- 		local bckdn, _, _ = DebuffCheck("Blasting Cyclone Knockdown","target");
-- 		local gotn, _, gotr = BuffCheck("Guardian of the Pass","player");
-- 		local frn, _, _ = DebuffCheck("Fear","target");
-- 		local nSpell,tTotal,tRemaining = UnitCastingTime("target")
-- 		local interruptSkill = GABN("Interrupting Strike") ;
-- if not mbn and GABN("Magic Barrier") then UABS("Magic Barrier");
-- 		elseif mbr and 30>mbr and GABN("Magic Barrier") then UABS("Magic Barrier");						
-- 		elseif not drn and GABN("Defender's Roar") then UABS("Defender's Roar");
--		elseif drr and 30>drr and GABN("Defender's Roar") then UABS("Defender's Roar");
-- 		elseif not gotn and GABN("Guardian of the Pass") then UABS("Guardian of the Pass");
-- 		elseif gotr and 30>gotr and GABN("Guardian of the Pass") then UABS("Guardian of the Pass");	
--     elseif 0.8>UnitHealth("player")/UnitMaxHealth("player") and GABN("Defensive Formation") then UABS("Defensive Formation");		
--     elseif 0.5>UnitHealth("player")/UnitMaxHealth("player") and GABN("Survival Instinct") then UABS("Survival Instinct");
--     elseif 0.4>UnitHealth("player")/UnitMaxHealth("player") and GABN("Terror") then UABS("Terror");	
--     elseif 0.2>UnitHealth("player")/UnitMaxHealth("player") and GABN("Holy Aura") then UABS("Holy Aura");	
-- 		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then
-- 		if IsTargetCasting() and interruptSkill and interruptList[nSpell] and ((tTotal - tRemaining) > 0.1) then UABS(interruptSkill); end;
-- 		UseSkill(1,1);
-- 		if UnitCanAttack("player","target") then
--		if not bckdn and UnitManaType("player")==2 and UnitMana("player")>35 and GABN("Blasting Cyclone") then UABS("Blasting Cyclone")				
 --    if UnitManaType("player")==2 and UnitMana("player")>25 and GABN("Slash") then UABS("Slash")	
 --    elseif frn and UnitManaType("player")==2 and UnitMana("player")>20 and GABN("Probing Attack") then UABS("Probing Attack")	
 -- 		elseif GABN("Attack") then UABS("Attack")	
-- end
-- end
-- end
		
elseif  subClass=="KNIGHT" then	
		local bleed, _, _ = DebuffCheck("Bleed","target");
	    local rsadn, _, _ = DebuffCheck("Restrained","target");
		local hs2n, _, _ = DebuffCheck("Holy Seal 2","target");
		local hs1n, _, _ = DebuffCheck("Holy Seal 1","target");
		local dmt3n, _, _ = DebuffCheck("Disarmament III","target");
		local dmt2n, _, _ = DebuffCheck("Disarmament II","target");
		local dmt1n, _, _ = DebuffCheck("Disarmament I","target");
		local sdwsn, _, _ = DebuffCheck("Shield Weakness","target");		
		local bckdn, _, _ = DebuffCheck("Blasting Cyclone Knockdown","target");
		local bulen, _, _ = DebuffCheck("Bullseye","target");
    if not CheckBuff("Enhanced Armor") and IsSkillUsable("Enhanced Armor") then CSBN("Enhanced Armor");
    elseif not  CheckBuff("Blocking Stance") and IsSkillUsable("Blocking Stance") then CSBN("Blocking Stance");		
	elseif 0.9>UnitHealth("player")/UnitMaxHealth("player") and GABN("Shield of Discipline") then UABS("Shield of Discipline");
    elseif 0.7>UnitHealth("player")/UnitMaxHealth("player") and GABN("Defensive Formation") then UABS("Defensive Formation");		
    elseif 0.4>UnitHealth("player")/UnitMaxHealth("player") and GABN("Survival Instinct") then UABS("Survival Instinct");
    elseif 0.3>UnitHealth("player")/UnitMaxHealth("player") and GABN("Terror") then UABS("Terror");	
	elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then						
	UseSkill(1,1);
	if UnitCanAttack("player","target") then
	if not bulen and UnitSkillType("player")==1 and UnitSkill("player")>480 and GABN("Throw Shield") then UABS("Throw Shield");
	elseif bulen and not sdwsn and UnitSkillType("player")==1 and UnitSkill("player")>360 and GABN("Shield Bash") then UABS("Shield Bash");
	elseif sdwsn and not rsadn and UnitSkillType("player")==1 and UnitSkill("player")>100 and GABN("Strike of Punishment") then UABS("Strike of Punishment");
	elseif not bckdn and UnitManaType("player")==2 and UnitMana("player")>35 and GABN("Blasting Cyclone") then UABS("Blasting Cyclone")	
    elseif not bleed and UnitManaType("player")==2 and UnitMana("player")>25 and GABN("Slash") then UABS("Slash")	
	elseif not dmt3n and UnitSkillType("player")==1 and UnitSkill("player")>161 and GABN("Disarmament") then UABS("Disarmament");			
	--elseif not hs4n and UnitSkillType("player")==1 and UnitSkill("player")>210 and GABN("Holy Strike") then UABS("Holy Strike");		
    --elseif hs4n and UnitSkillType("player")==1 and UnitSkill("player")>280 and GABN("Punishment") then UABS("Punishment");			
end
end
end
end
end	
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
--Champion
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
function Champion()
local mainClass, subClass = UnitClassToken("player")

if mainClass=="PSYRON" then
	if subClass=="THIEF" then
-- Standard Buff check Champion
 		local sfmn, _, sfmr = BuffCheck("Shield Form","player");
		local fren, _, frer = BuffCheck("Forge","player");
		local bdtn, _, bdtr = BuffCheck("Battle Defense Transfer","player");
    local argbn, _, argbr = BuffCheck("Attack Rune Growth","player");
		local rein, _, reir = BuffCheck("Rune Energy Influx");
		local seon, _, seor = BuffCheck("Shadow Explosion","player");
 	if not sfmn and GABN("Shield Form") then UABS("Shield Form");
	elseif sfmr and 30>sfmr and GABN("Shield Form") then UABS("Shield Form");			
	elseif not bdtn and GABN("Battle Defense Transfer") then UABS("Battle Defense Transfer");
	elseif bdtr and 30>bdtr and GABN("Battle Defense Transfer") then UABS("Battle Defense Transfer");		
    elseif not CheckBuff("Shadow Explosion") and IsSkillUsable("Shadow Explosion") then CSBN("Shadow Explosion");
    elseif not CheckBuff("Forge") and IsSkillUsable("Forge") then CSBN("Forge");		
    elseif not CheckBuff("Rune Growth") and IsSkillUsable("Rune Growth") then CSBN("Rune Growth");							
	elseif 0.9>UnitHealth("player")/UnitMaxHealth("player") and GABN("Feedback Defense") then UABS("Feedback Defense");	
	elseif 0.4>UnitHealth("player")/UnitMaxHealth("player") and GABN("Remodeled Body") then UABS("Remodeled Body")
	elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then						
		UseSkill(1,1);
		if UnitCanAttack("player","target") then
    local cdbn, _, _ = BuffCheck("Chain Drive","player");	
		if cdbn and GABN("Rune Pulse") then UABS("Rune Pulse");	
		elseif not cdbn and UnitSkillType("player")==4 and UnitSkill("player")>19 and  GABN("Shadowstab") then UABS("Shadowstab");

end
end
end

elseif subClass=="AUGUR" then
 		local sfmn, _, sfmr = BuffCheck("Shield Form","player");
		local fren, _, frer = BuffCheck("Forge","player");
		local bdtn, _, bdtr = BuffCheck("Battle Defense Transfer","player");
 		local argbn, _, argbr = BuffCheck("Attack Rune Growth","player");	
 		if not sfmn and GABN("Shield Form") then UABS("Shield Form");
		elseif sfmr and 30>sfmr and GABN("Shield Form") then UABS("Shield Form");						
		elseif not bdtn and GABN("Battle Defense Transfer") then UABS("Battle Defense Transfer");
		elseif bdtr and 30>bdtr and GABN("Battle Defense Transfer") then UABS("Battle Defense Transfer");	
 		elseif not CheckBuff("Forge") and IsSkillUsable("Forge") then CSBN("Forge");		
 		elseif not CheckBuff("Rune Growth") and IsSkillUsable("Rune Growth") then CSBN("Rune Growth");	
		elseif 0.7>UnitHealth("player")/UnitMaxHealth("player") and GABN("Feedback Defense") then UABS("Feedback Defense");	
		elseif 0.4>UnitHealth("player")/UnitMaxHealth("player") and GABN("Holy Aura") then UABS("Holy Aura")		
		elseif 0.3>UnitHealth("player")/UnitMaxHealth("player") and GABN("Remodeled Body") then UABS("Remodeled Body")	
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then	
		UseSkill(1,1);
		if UnitCanAttack("player","target") then
 		local cdbn, _, _ = BuffCheck("Chain Drive","player");		
 		if cdbn and GABN("Rune Pulse") then UABS("Rune Pulse");	
		elseif UnitSkillType("player")==1 and UnitSkill("player")>300 and GABN("Light Pulse") then UABS("Light Pulse");		
		elseif UnitManaType("player")==2 and UnitMana("player")>25 and GABN("Shock Strike") then UABS("Shock Strike");
		elseif UnitManaType("player")==2 and UnitMana("player")>15 and GABN("Divine Vengeance") then UABS("Divine Vengeance");		
 		elseif not cdbn and GABN("Attack") then UABS("Attack");	

end
end
end

elseif subClass=="WARRIOR" then	
		local seon, _, seor = BuffCheck("Deadland Protection","player");
 		local sfmn, _, sfmr = BuffCheck("Shield Form","player");
		local fren, _, frer = BuffCheck("Forge","player");
		local bdtn, _, bdtr = BuffCheck("Battle Defense Transfer","player");
    local argbn, _, argbr = BuffCheck("Attack Rune Growth","player");
 		if not sfmn and GABN("Shield Form") then UABS("Shield Form");
		elseif sfmr and 30>sfmr and GABN("Shield Form") then UABS("Shield Form");						
		elseif not bdtn and GABN("Battle Defense Transfer") then UABS("Battle Defense Transfer");
		elseif bdtr and 30>bdtr and GABN("Battle Defense Transfer") then UABS("Battle Defense Transfer");			
 		elseif not CheckBuff("Deadland Protection") and IsSkillUsable("Deadland Protection") then CSBN("Deadland Protection");
 		elseif not CheckBuff("Forge") and IsSkillUsable("Forge") then CSBN("Forge");		
 		elseif not CheckBuff("Rune Growth") and IsSkillUsable("Rune Growth") then CSBN("Rune Growth");						
		elseif 0.8>UnitHealth("player")/UnitMaxHealth("player") and GABN("Feedback Defense") then UABS("Feedback Defense");
		elseif 0.6>UnitHealth("player")/UnitMaxHealth("player") and GABN("Determination Rune") then UABS("Determination Rune");	
		elseif 0.2>UnitHealth("player")/UnitMaxHealth("player") and GABN("Remodeled Body") then UABS("Remodeled Body")
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then	
		UseSkill(1,1);
		if UnitCanAttack("player","target") then	
		local cdbn, _, _ = BuffCheck("Chain Drive","player");
 		if cdbn and GABN("Rune Pulse") then UABS("Rune Pulse");		
 		elseif UnitMana("player")>25 and GABN("Slash") then UABS("Slash") 

end
end
end
	
elseif subClass=="HARPSYN" then
		local pren, _, prer = BuffCheck("Psychic Rampage","player");
 		local sfmn, _, sfmr = BuffCheck("Shield Form","player");
		local fren, _, frer = BuffCheck("Forge","player");
		local bdtn, _, bdtr = BuffCheck("Battle Defense Transfer","player");
    local argbn, _, argbr = BuffCheck("Attack Rune Growth","player");	

 		if not sfmn and GABN("Shield Form") then UABS("Shield Form");
		elseif sfmr and 30>sfmr and GABN("Shield Form") then UABS("Shield Form");						
		elseif not bdtn and GABN("Battle Defense Transfer") then UABS("Battle Defense Transfer");
		elseif bdtr and 30>bdtr and GABN("Battle Defense Transfer") then UABS("Battle Defense Transfer");
 	  elseif not CheckBuff("Psychic Rampage") and IsSkillUsable("Psychic Rampage") then CSBN("Psychic Rampage");	
 		elseif not CheckBuff("Soul Forge Mystery") and IsSkillUsable("Soul Forge Mystery") then CSBN("Soul Forge Mystery");		
 		elseif not CheckBuff("Forge") and IsSkillUsable("Forge") then CSBN("Forge");		
 		elseif not CheckBuff("Rune Growth") and IsSkillUsable("Rune Growth") then CSBN("Rune Growth");	
 		elseif not CheckBuff("Heart Collection Rune") and IsSkillUsable("Heart Collection Rune") then CSBN("Heart Collection Rune");		
 		elseif 0.6>UnitHealth("player")/UnitMaxHealth("player") and GABN("Indomitable Spirit") then UABS("Indomitable Spirit");	
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then	
		UseSkill(1,1);	
		if UnitCanAttack("player","target") then
    local cdbn, _, _ = BuffCheck("Chain Drive","player");	
    local hcrn, _, hcrr = BuffCheck("Heart Collection Rune","player");
		if cdbn and GABN("Rune Pulse") then UABS("Rune Pulse");
 		elseif hcrn and GABN("Rune Siphon") then UABS("Rune Siphon");	
 		elseif UnitManaType("player")==2 and UnitMana("player")>20 and GABN("Dark Energy Strike") then UABS("Dark Energy Strike") 		
 		elseif UnitManaType("player")==2 and UnitMana("player")>10 and UnitSkillType("player")==3 and UnitSkill("player")>20 and GABN("Rune Siphon") then UABS("Rune Siphon");	

end
end
end

elseif subClass=="MAGE" then
 		local sfmn, _, sfmr = BuffCheck("Shield Form","player");
		local fren, _, frer = BuffCheck("Forge","player");
		local bdtn, _, bdtr = BuffCheck("Battle Defense Transfer","player");
    local argbn, _, argbr = BuffCheck("Attack Rune Growth","player");
		local nSpell,tTotal,tRemaining = UnitCastingTime("target")
		local interruptSkill = GABN("Lightning") or GABN("Silence");
	 	if not sfmn and GABN("Shield Form") then UABS("Shield Form");
		elseif sfmr and 30>sfmr and GABN("Shield Form") then UABS("Shield Form");						
		elseif not bdtn and GABN("Battle Defense Transfer") then UABS("Battle Defense Transfer");
		elseif bdtr and 30>bdtr and GABN("Battle Defense Transfer") then UABS("Battle Defense Transfer");			
    elseif not CheckBuff("Elemental Defense") and IsSkillUsable("Elemental Defense") then CSBN("Elemental Defense");
    elseif not CheckBuff("Forge") and IsSkillUsable("Forge") then CSBN("Forge");		
    elseif not CheckBuff("Rune Growth") and IsSkillUsable("Rune Growth") then CSBN("Rune Growth");				
    elseif not CheckBuff("High-Energy Barrier") and IsSkillUsable("High-Energy Barrier") then CSBN("High-Energy Barrier");			
		elseif 0.9>UnitHealth("player")/UnitMaxHealth("player") and GABN("Feedback Defense") then UABS("Feedback Defense");	
		elseif 0.4>UnitHealth("player")/UnitMaxHealth("player") and GABN("Remodeled Body") then UABS("Remodeled Body")
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then
		if IsTargetCasting() and interruptSkill and interruptList[nSpell] and ((tTotal - tRemaining) > 0.1) then UABS(interruptSkill); end;
		UseSkill(1,1);
		if UnitCanAttack("player","target") then	
    local cdbn, _, _ = BuffCheck("Chain Drive","player");	
		if cdbn and GABN("Rune Pulse") then UABS("Rune Pulse");		
		elseif UnitSkill("player")>576 and GABN("Rapid Spread") then UABS("Rapid Spread");
		elseif UnitMana("player")>39 and GABN("Vacuum Wave") then UABS("Vacuum Wave");	
		elseif UnitMana("player")>24 and GABN("Shock Strike") then UABS("Shock Strike");
end
end
end
end
end
end


function ChampionDps()
local mainClass, subClass = UnitClassToken("player")

if mainClass=="PSYRON" then
	if subClass=="THIEF" then
 		local dmbn, _, dmbr = BuffCheck("Disassembly Mode","player");	
		local fren, _, frer = BuffCheck("Forge","player");
    local argbn, _, argbr = BuffCheck("Attack Rune Growth","player");
		local seon, _, seor = BuffCheck("Shadow Explosion","player");
 		if not dmbn and GABN("Disassembly Mode") then UABS("Disassembly Mode");
		elseif dmbr and 30>dmbr and GABN("Disassembly Mode") then UABS("Disassembly Mode");			
    elseif not CheckBuff("Shadow Explosion") and IsSkillUsable("Shadow Explosion") then CSBN("Shadow Explosion");
    elseif not CheckBuff("Forge") and IsSkillUsable("Forge") then CSBN("Forge");		
    elseif not CheckBuff("Rune Growth") and IsSkillUsable("Rune Growth") then CSBN("Rune Growth");							
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then						
		UseSkill(1,1);
		if UnitCanAttack("player","target") then
    local cdbn, _, _ = BuffCheck("Chain Drive","player");	
		if cdbn and GABN("Rune Pulse") then UABS("Rune Pulse");	
		elseif not cdbn and UnitSkillType("player")==4 and UnitSkill("player")>19 and  GABN("Shadowstab") then UABS("Shadowstab");

end
end
end

elseif subClass=="WARRIOR" then	
		local seon, _, seor = BuffCheck("Deadland Protection","player");
 		local dmbn, _, dmbr = BuffCheck("Disassembly Mode","player");	
		local fren, _, frer = BuffCheck("Forge","player");
    local argbn, _, argbr = BuffCheck("Attack Rune Growth","player");
 		if not dmbn and GABN("Disassembly Mode") then UABS("Disassembly Mode");
		elseif dmbr and 30>dmbr and GABN("Disassembly Mode") then UABS("Disassembly Mode");							
 		elseif not CheckBuff("Deadland Protection") and IsSkillUsable("Deadland Protection") then CSBN("Deadland Protection");
 		elseif not CheckBuff("Forge") and IsSkillUsable("Forge") then CSBN("Forge");		
 		elseif not CheckBuff("Rune Growth") and IsSkillUsable("Rune Growth") then CSBN("Rune Growth");						
		elseif 0.6>UnitHealth("player")/UnitMaxHealth("player") and GABN("Determination Rune") then UABS("Determination Rune");	
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then	
		UseSkill(1,1);
		if UnitCanAttack("player","target") then	
		local cdbn, _, _ = BuffCheck("Chain Drive","player");
		local Electrocution, _, _ = DebuffCheck("Electrocution","target");	
 		if cdbn and GABN("Rune Pulse") then UABS("Rune Pulse");	
 		elseif Electrocution and UnitManaType("player")==2 and UnitMana("player")>25 and GABN("Energy Influx Strike") then UABS("Energy Influx Strike");		
 		elseif Electrocution and UnitManaType("player")==2 and UnitMana("player")>5 and GABN("Arc Strike") then UABS("Arc Strike");	
 		elseif not Electrocution and UnitManaType("player")==2 and UnitMana("player")>25 and GABN("Slash") then UABS("Slash") 

end
end
end
	
elseif subClass=="HARPSYN" then
		local pren, _, prer = BuffCheck("Psychic Rampage","player");
		local cdbn, _, _ = BuffCheck("Chain Drive","player");
 		local dmbn, _, dmbr = BuffCheck("Disassembly Mode","player");	
		local fren, _, frer = BuffCheck("Forge","player");
    local argbn, _, argbr = BuffCheck("Attack Rune Growth","player");	
  		if not dmbn and GABN("Disassembly Mode") then UABS("Disassembly Mode");
		elseif dmbr and 30>dmbr and GABN("Disassembly Mode") then UABS("Disassembly Mode");						
 	  elseif not CheckBuff("Psychic Rampage") and IsSkillUsable("Psychic Rampage") then CSBN("Psychic Rampage");	
 		elseif not CheckBuff("Soul Forge Mystery") and IsSkillUsable("Soul Forge Mystery") then CSBN("Soul Forge Mystery");		
 		elseif not CheckBuff("Forge") and IsSkillUsable("Forge") then CSBN("Forge");		
 		elseif not CheckBuff("Rune Growth") and IsSkillUsable("Rune Growth") then CSBN("Rune Growth");	
 		elseif not CheckBuff("Heart Collection Rune") and IsSkillUsable("Heart Collection Rune") then CSBN("Heart Collection Rune");		
 		elseif 0.6>UnitHealth("player")/UnitMaxHealth("player") and GABN("Indomitable Spirit") then UABS("Indomitable Spirit");	
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then	
		UseSkill(1,1);
		if UnitCanAttack("player","target") then	
		local wcen, _, _ = BuffCheck("Warp Charge","player");	
 		if cdbn and GABN("Rune Pulse") then UABS("Rune Pulse");
 		elseif UnitManaType("player")==2 and UnitMana("player")>20 and GABN("Dark Energy Strike") then UABS("Dark Energy Strike") 		
 		elseif UnitManaType("player")==2 and UnitMana("player")>10 and UnitSkillType("player")==3 and UnitSkill("player")>20 and GABN("Rune Siphon") then UABS("Rune Siphon");	
end
end
end
end
end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
--Scout
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function SrCSBN()
local mainClass, subClass = UnitClassToken("player")
 if mainClass=="RANGER" then
	if subClass=="THIEF" then
        local vmpa, _, _ = DebuffCheck("Vampire Arrows","target");
        local exps, _, _ = DebuffCheck("Exploiting Shot","target");
        local a1,a2,a3,a4,a5,ason = GetActionInfo(1);
        if UnitCanAttack("player","target") then
        if IsSkillUsable("Shot") and not exps then CSBN("Shot");
		elseif IsSkillUsable("Vampire Arrows") and not vmpa then CSBN("Vampire Arrows");
        elseif IsSkillUsable("Deadly Poison Bite") and vmpa then CSBN("Deadly Poison Bite");
		else CSBN("Shot");
		end
	    elseif UnitCanAttack("player","target") then	
		if IsSkillUsable("Vampire Arrows") and vmpa then CSBN("Vampire Arrows");
        elseif IsSkillUsable("Deadly Poison Bite") and vmpa then CSBN("Deadly Poison Bite");
		elseif IsSkillUsable("Shot") and exps then CSBN("Shot");
	 end
  end
  end
  end
  end
--elseif subClass=="DRUID" then
--elseif subClass=="WARRIOR" then
--elseif subClass=="RANGER" then
--elseif subClass=="THIEF" then
--elseif subClass=="-MAGE" then
--elseif subClass=="DRUID" then

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
--Warden
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function Warden()
local mainClass, subClass = UnitClassToken("player")
 if mainClass=="WARDEN" then
	if subClass=="RANGER" then
    local brsh, _, brshr = BuffCheck("Briar Shield","player");
	 	if not brsh and GABN("Briar Shield") then UABS("Briar Shield");
		elseif brshr and 30>brshr and GABN("Briar Shield") then UABS("Briar Shield");		
		elseif UnitExists("target") and UnitHealth("target")>0 and UnitCanAttack("player", "target") then	
		UseSkill(1,1);
		if UnitCanAttack("player","target") then
    if UnitSkill("player")>39 and GABN("Untamable") then UABS("Untamable");
    elseif UnitMana("player")>350  and GABN("Cross Chop") then UABS("Cross Chop");
  	elseif UnitMana("player")>250 and GABN("Frantic Briar") then UABS("Frantic Briar");
  	elseif UnitMana("player")>230 and GABN("Charged Chop") then UABS("Charged Chop");
end
end
end
end
end
end
--elseif subClass=="DRUID" then
--elseif subClass=="WARRIOR" then
--elseif subClass=="RANGER" then
--elseif subClass=="THIEF" then
--elseif subClass=="-MAGE" then
--elseif subClass=="DRUID" then
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
--Warlock
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function Warlock()
local mainClass, subClass = UnitClassToken("player")
if mainClass=="HARPSYN" then
	if subClass=="MAGE" then
		if UnitCanAttack("player","target") then				
      local wcbn, _, _ = BuffCheck("Warp Charge","player");		
	    local atdn, _, _ = DebuffCheck("Authoritative Deterrence","target");		
	    local pedn, _, _ = DebuffCheck("Perception Extraction","target");	
      local sbdn, sbdc, sbdr = DebuffCheck("Soul Brand","target");
		if atdn and UnitSkill("player")>300 and GABN("Silence") then UABS("Silence");	
		elseif not wcbn and UnitMana("player")>30 and GABN("Warp Charge") then UABS("Warp Charge");
    elseif GABN("Perception Extraction") and sbdc==4 and 4>sbdr and UnitMana("player")>15 then UABS("Perception Extraction");
		elseif GABN("Perception Extraction") and sbdc==3 and UnitMana("player")>15 then UABS("Perception Extraction");
		elseif GABN("Perception Extraction") and sbdc==2 and UnitMana("player")>15 then UABS("Perception Extraction");
		elseif GABN("Perception Extraction") and sbdc==1 and UnitMana("player")>15 then UABS("Perception Extraction");
		elseif GABN("Perception Extraction") and not sbdn and UnitMana("player")>15 then UABS("Perception Extraction");
end
end
end
end
end
		
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
--HEAL
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------


--macro for buffing
function moobuff(skillname)
	if skillname==nil or skillname=="" then Sol.io.Print("Provide a skill name when running moobuff('skillname')"); return end;
	local buffname; local buffname2;
	if (skillname==TEXT("Sys490269_name")) then buffname = TEXT("Sys500469_name") -- regnerate
	elseif (skillname==TEXT("Sys491651_name")) then buffname = TEXT("Sys500517_name"); buffname2 = TEXT("Sys502033_name") -- grace of life
	elseif (skillname==TEXT("Sys490491_name")) then buffname = TEXT("Sys500940_name"); buffname2 = TEXT("Sys505157_name") -- amplified attack
	end
	if buffname==nil then buffname=skillname; end
	if buffname2==nil then buffname2=buffname; end

	if (GetNumRaidMembers()>0) then
		local numUnits = GetNumRaidMembers()
		for i=1,numUnits,1 do
			target="raid"..i;
			if not (CheckBuff(buffname,target) or CheckBuff(buffname2,target)) and GABN(skillname) then TargetUnit(target); UABS(skillname) return end
		end
	elseif (GetNumPartyMembers()>0) then
		local numUnits = GetNumPartyMembers()
		for i=1,numUnits,1 do
			target="party"..i;
			if not (CheckBuff(buffname,target) or CheckBuff(buffname2,target)) and GABN(skillname) then TargetUnit(target); UABS(skillname) return end
		end
	elseif (GetNumRaidMembers()==0 and GetNumPartyMembers()==0) then
		if GABN(skillname) then UABS(skillname) end
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
function moourgent(cleanse_use)
if cleanse_use then cleanse_use=true; else cleanse_use=nil; end;
	if (GetNumRaidMembers()>0) then
			mooplayertable={};	local numUnits = GetNumRaidMembers(); local totalplayers = 1;
		for i=1,numUnits,1 do
	-- Classtokens: AUGUR Priest ; DRUID Druid ; MAGE Mage ; KNIGHT Knight ; RANGER Scout ;THIEF  Rogue ;;WARDEN Warden
	-- WARRIOR Warrior ; HARPSYN Warlock ; PSYRON Champion
		memberName, online = GetRaidMember(i or -1);
			for ii=1,100,1 do ObjName = GetMinimapIconText( ii );
				if ObjName and ObjName==memberName and online==true and UnitHealth("raid"..i)>0 then
					mainClass, subClass = UnitClassToken("raid"..i)
					if _target==UnitName("raid"..i) and _heal>0 and _source==UnitName("player") then
					local healthcalc=(UnitHealth("raid"..i)+_heal)/UnitMaxHealth("raid"..i)
					if healthcalc>1 then healthcalc=1; end;
					mooplayertable[totalplayers]={target="raid"..i; name=UnitName("raid"..i),health=healthcalc,main=mainClass,sub=subClass}
					totalplayers = totalplayers + 1;
					else
					local healthcalc=(UnitHealth("raid"..i))/UnitMaxHealth("raid"..i)
					mooplayertable[totalplayers]={target="raid"..i; name=UnitName("raid"..i),health=healthcalc,main=mainClass,sub=subClass}
					totalplayers = totalplayers + 1;
					end
				end
			end
		end
		mainClass, subClass = UnitClassToken("player")
		mooplayertable[totalplayers]={target="player", name=UnitName("player"),health=UnitHealth("player")/UnitMaxHealth("player"),main = mainClass,sub = subClass,}
		for i=1,totalplayers,1 do
			if (mooplayertable[i].health==0) then mooplayertable[i].priority = 0;
			elseif (mooplayertable[i].main=="AUGUR") and (mooplayertable[i].sub=="KNIGHT") and (mooplayertable[i].name == UnitName("player")) then mooplayertable[i].priority = 0;
			elseif (mooplayertable[i].main=="KNIGHT") or (mooplayertable[i].main=="PSYRON") or (mooplayertable[i].main=="WARDEN" and mooplayertable[i].sub=="WARRIOR") then mooplayertable[i].priority = 7*(1-mooplayertable[i].health)
			elseif (mooplayertable[i].sub=="KNIGHT") or (mooplayertable[i].sub=="WARDEN") then mooplayertable[i].priority = 4*(1-mooplayertable[i].health)
			else mooplayertable[i].priority = 5*(1-mooplayertable[i].health) end;
		end
		-- debug line
		-- for i=1,#mooplayertable,1 do Sol.io.Print("Mooheal priority: "..mooplayertable[i].priority.." on "..mooplayertable[i].name) end
		moosortTable = {}
		for i=1,#mooplayertable,1 do table.insert(moosortTable,mooplayertable[i].priority) end
		table.sort(moosortTable,function(a,b) return a>b end);
		if moosortTable[1]>0 then
			for i=1,#mooplayertable,1 do
				if mooplayertable[i].priority == moosortTable[1] then TargetUnit(mooplayertable[i].target); if (cleanse_use) and GABN("Cleanse ISS") then UABS("Cleanse ISS") elseif GABN("Urgent Heal") then UABS("Urgent Heal"); end; end
			end;
		else UABS("Urgent Heal"); end;
	elseif (GetNumPartyMembers()>0) then
		mooplayertable={};	local numUnits = GetNumPartyMembers(); local totalplayers = 1;
		for i=1,numUnits,1 do
	-- Classtokens: AUGUR Priest ; DRUID Druid ; MAGE Mage ; KNIGHT Knight ; RANGER Scout ;THIEF  Rogue ;;WARDEN Warden
	-- WARRIOR Warrior ; HARPSYN Warlock ; PSYRON Champion
		memberName, online = GetPartyMember(i or -1);
			for ii=1,100,1 do ObjName = GetMinimapIconText( ii );
				if ObjName and ObjName==memberName and online==true and UnitHealth("party"..i)>0 then
					mainClass, subClass = UnitClassToken("party"..i)
					if _target==UnitName("party"..i) and _heal>0 and _source==UnitName("player") then
					local healthcalc=(UnitHealth("party"..i)+_heal)/UnitMaxHealth("party"..i)
					if healthcalc>1 then healthcalc=1; end;
					mooplayertable[totalplayers]={target="party"..i; name=UnitName("party"..i),health=healthcalc,main=mainClass,sub=subClass}
					totalplayers = totalplayers + 1;
					else
					local healthcalc=(UnitHealth("party"..i))/UnitMaxHealth("party"..i)
					mooplayertable[totalplayers]={target="party"..i; name=UnitName("party"..i),health=healthcalc,main=mainClass,sub=subClass}
					totalplayers = totalplayers + 1;
					end
				end
			end
		end
		mainClass, subClass = UnitClassToken("player")
		--if not (mainClass=="AUGUR" and subClass=="KNIGHT") or totalplayers==1 then 
			mooplayertable[totalplayers]={target="player", name=UnitName("player"),health=UnitHealth("player")/UnitMaxHealth("player"),main = mainClass,sub = subClass,}
		--end;
		for i=1,totalplayers,1 do
			if (mooplayertable[i].health==0) then mooplayertable[i].priority = 0;
			elseif (mooplayertable[i].main=="AUGUR") and (mooplayertable[i].sub=="KNIGHT") and (mooplayertable[i].name == UnitName("player")) then mooplayertable[i].priority = 0;
			elseif (mooplayertable[i].main=="KNIGHT") or (mooplayertable[i].main=="PSYRON") or (mooplayertable[i].main=="WARDEN" and mooplayertable[i].sub=="WARRIOR") then mooplayertable[i].priority = 7*(1-mooplayertable[i].health)
			elseif (mooplayertable[i].sub=="KNIGHT") or (mooplayertable[i].sub=="WARDEN") then mooplayertable[i].priority = 4*(1-mooplayertable[i].health)
			else mooplayertable[i].priority = 5*(1-mooplayertable[i].health) end;
		end
		-- debug line
		-- for i=1,#mooplayertable,1 do Sol.io.Print("Mooheal priority: "..mooplayertable[i].priority.." on "..mooplayertable[i].name) end
		moosortTable = {}
		for i=1,#mooplayertable,1 do table.insert(moosortTable,mooplayertable[i].priority) end
		table.sort(moosortTable,function(a,b) return a>b end);
		if moosortTable[1]>0 then
			for i=1,#mooplayertable,1 do
				if mooplayertable[i].priority == moosortTable[1] then TargetUnit(mooplayertable[i].target); if (cleanse_use) and GABN("Cleanse ISS") then UABS("Cleanse ISS") elseif GABN("Urgent Heal") then UABS("Urgent Heal"); end; end
--				if (actionslot) and GetActionUsable(actionslot) then UABS(actionslot); else CSBN("Urgent Heal") end
			end;
		else UABS("Urgent Heal"); end;
	elseif (GetNumRaidMembers()==0 and GetNumPartyMembers()==0) then UABS("Urgent Heal") end
end

--Druid/Scout Healing
function moodruidscoutheal()
	if (GetNumRaidMembers()>0) then
			mooplayertable={};	local numUnits = GetNumRaidMembers(); local totalplayers = 1;
		for i=1,numUnits,1 do
	-- Classtokens: AUGUR Priest ; DRUID Druid ; MAGE Mage ; KNIGHT Knight ; RANGER Scout ;THIEF  Rogue ;;WARDEN Warden
	-- WARRIOR Warrior ; HARPSYN Warlock ; PSYRON Champion
		memberName, online = GetRaidMember(i or -1);
			for ii=1,100,1 do ObjName = GetMinimapIconText( ii );
				if ObjName and ObjName==memberName and online==true and UnitHealth("raid"..i)>0 then
					mainClass, subClass = UnitClassToken("raid"..i)
					mooplayertable[totalplayers]={target="raid"..i; name=UnitName("raid"..i),health=UnitHealth("raid"..i)/UnitMaxHealth("raid"..i),main=mainClass,sub=subClass}
					totalplayers = totalplayers + 1;
				end
			end
		end
		mainClass, subClass = UnitClassToken("player")
		--if not (mainClass=="AUGUR" and subClass=="KNIGHT") or totalplayers==1 then 
			mooplayertable[totalplayers]={target="player", name=UnitName("player"),health=UnitHealth("player")/UnitMaxHealth("player"),main = mainClass,sub = subClass,}
		--end;
		for i=1,totalplayers,1 do
			if (mooplayertable[i].health==0) then mooplayertable[i].priority = 0;
			elseif (mooplayertable[i].main=="KNIGHT") or (mooplayertable[i].main=="PSYRON") or (mooplayertable[i].main=="WARDEN" and mooplayertable[i].sub=="WARRIOR") then mooplayertable[i].priority = 7*(1-mooplayertable[i].health)
			elseif (mooplayertable[i].sub=="KNIGHT") or (mooplayertable[i].sub=="WARDEN") then mooplayertable[i].priority = 4*(1-mooplayertable[i].health)
			else mooplayertable[i].priority = 5*(1-mooplayertable[i].health) end;
		end
		-- debug line
		-- for i=1,#mooplayertable,1 do Sol.io.Print("Mooheal priority: "..mooplayertable[i].priority.." on "..mooplayertable[i].name) end
		moosortTable = {}
		for i=1,#mooplayertable,1 do table.insert(moosortTable,mooplayertable[i].priority) end
		table.sort(moosortTable,function(a,b) return a>b end);
		if moosortTable[1]>0 then
			for i=1,#mooplayertable,1 do
				if mooplayertable[i].priority == moosortTable[1] then TargetUnit(mooplayertable[i].target); if GABN("Mother Earth's Fountain") then UABS("Mother Earth's Fountain") elseif GABN("Restore Life") then UABS("Restore Life"); end; end
--				if (actionslot) and GetActionUsable(actionslot) then UABS(actionslot); else CSBN("Urgent Heal") end
			end;
		else UABS(GABN("Restore Life")); end;
	elseif (GetNumPartyMembers()>0) then
		mooplayertable={};	local numUnits = GetNumPartyMembers(); local totalplayers = 1;
		for i=1,numUnits,1 do
	-- Classtokens: AUGUR Priest ; DRUID Druid ; MAGE Mage ; KNIGHT Knight ; RANGER Scout ;THIEF  Rogue ;;WARDEN Warden
	-- WARRIOR Warrior ; HARPSYN Warlock ; PSYRON Champion
		memberName, online = GetPartyMember(i or -1);
			for ii=1,100,1 do ObjName = GetMinimapIconText( ii );
				if ObjName and ObjName==memberName and online==true and UnitHealth("party"..i)>0 then
					mainClass, subClass = UnitClassToken("party"..i)
					mooplayertable[totalplayers]={target="party"..i; name=UnitName("party"..i),health=UnitHealth("party"..i)/UnitMaxHealth("party"..i),main=mainClass,sub=subClass}
					totalplayers = totalplayers + 1;
				end
			end
		end
		mainClass, subClass = UnitClassToken("player")
		--if not (mainClass=="AUGUR" and subClass=="KNIGHT") or totalplayers==1 then 
			mooplayertable[totalplayers]={target="player", name=UnitName("player"),health=UnitHealth("player")/UnitMaxHealth("player"),main = mainClass,sub = subClass,}
		--end;
		for i=1,totalplayers,1 do
			if (mooplayertable[i].health==0) then mooplayertable[i].priority = 0;
			elseif (mooplayertable[i].main=="KNIGHT") or (mooplayertable[i].main=="PSYRON") or (mooplayertable[i].main=="WARDEN" and mooplayertable[i].sub=="WARRIOR") then mooplayertable[i].priority = 7*(1-mooplayertable[i].health)
			elseif (mooplayertable[i].sub=="KNIGHT") or (mooplayertable[i].sub=="WARDEN") then mooplayertable[i].priority = 4*(1-mooplayertable[i].health)
			else mooplayertable[i].priority = 5*(1-mooplayertable[i].health) end;
		end
		-- debug line
		-- for i=1,#mooplayertable,1 do Sol.io.Print("Mooheal priority: "..mooplayertable[i].priority.." on "..mooplayertable[i].name) end
		moosortTable = {}
		for i=1,#mooplayertable,1 do table.insert(moosortTable,mooplayertable[i].priority) end
		table.sort(moosortTable,function(a,b) return a>b end);
		if moosortTable[1]>0 then
			for i=1,#mooplayertable,1 do
				if mooplayertable[i].priority == moosortTable[1] then TargetUnit(mooplayertable[i].target); if GABN("Mother Earth's Fountain") then UABS(GABN("Mother Earth's Fountain")) elseif GABN("Restore Life") then UABS(GABN("Restore Life")); end; end
--				if (actionslot) and GetActionUsable(actionslot) then UABS(actionslot); else CSBN("Urgent Heal") end
			end;
		else UABS(GABN("Restore Life")); end;
	elseif (GetNumRaidMembers()==0 and GetNumPartyMembers()==0) then if GABN("Mother Earth's Fountain") then UABS("Mother Earth's Fountain") elseif GABN("Restore Life") then UABS("Restore Life"); end; end
end

--macro for druid/scout regen
function moodruidscoutregen()
	if (GetNumRaidMembers()>0) then
		local numUnits = GetNumRaidMembers()
		for i=1,numUnits,1 do
			if i==numUnits then target="player" else target="raid"..i; end
			Camellia=CheckBuffCount("Camellia Flower",target) or 0;
			if not CheckBuff("Blossoming Life",target) and GABN("Blossoming Life") then TargetUnit(target); UABS("Blossoming Life") return
			elseif not CheckBuff("Recover",target) and GABN("Recover") then TargetUnit(target); UABS("Recover") return
			elseif (3>Camellia) and GABN("Camellia Flower") then TargetUnit(target); UABS("Camellia Flower") return
			end
		end
	elseif (GetNumPartyMembers()>0) then
		local numUnits = GetNumPartyMembers()
		for i=1,numUnits,1 do
			if i==numUnits then target="player" else target="party"..i; end
			Camellia=CheckBuffCount("Camellia Flower",target) or 0;
			if not CheckBuff("Blossoming Life",target) and GABN("Blossoming Life") then TargetUnit(target); UABS("Blossoming Life") return
			elseif not CheckBuff("Recover",target) and GABN("Recover") then TargetUnit(target); UABS("Recover") return
			elseif (3>Camellia) and GABN("Camellia Flower") then TargetUnit(target); UABS("Camellia Flower") return
			end
		end
	elseif (GetNumRaidMembers()==0 and GetNumPartyMembers()==0) then
		target="player";
			Camellia=CheckBuffCount("Camellia Flower",target) or 0;
			if not CheckBuff("Blossoming Life",target) and GABN("Blossoming Life") then TargetUnit(target); UABS("Blossoming Life") return
			elseif not CheckBuff("Recover",target) and GABN("Recover") then TargetUnit(target); UABS("Recover") return
			elseif (3>Camellia) and GABN("Camellia Flower") then TargetUnit(target); UABS("Camellia Flower") return
			end
	end
end