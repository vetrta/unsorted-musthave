-- =========================================================================
-- _Gds-Tables/Skilltable.lua - Champion/Rogue skill data
--
-- Loaded before _Gds.lua (see _Gds.toc). Populates _G.GDS_Skilltable.
--
-- Entry format - fill in whichever identifiers you actually have, leave
-- the rest nil. GDS_ResolveDisplayName() in _Gds.lua picks the best one
-- available at runtime, in this order:
--   1. sys   (number) - a "Sys" text ID, resolved live via TEXT("Sys"..sys.."_name")
--             so the returned name always matches your client's current
--             language. This is the one that fixes name-matching breaking
--             on non-English clients - use it when you have the ID.
--   2. name  (string) - literal name, used if there's no sys id or it fails
--             to resolve. This is what everything uses today.
--   icon     (string) - icon path, e.g. "skill_psy1-2". Not resolved through
--             TEXT(), used for direct icon comparisons where you have one.
--             Not wired into the cache lookup yet - see the note in
--             _Gds.lua's changelog about why.
--   type     (number, required) - 1 = normal skill-book skill, 2 = suit
--             skill, 3 = item. Same as before.
-- =========================================================================

_G.GDS_Skilltable = {
    Skills = {
 -- =========================================================================
-- CHAMPION
-- =========================================================================
    ["electrocution"] = {1, "skill_psy1-2"},
    ["heavy bash"] = {1, "skill_psy1-1"},
    ["energy influx strike"] = {1, "skill_psy6-1"},
    ["shock strike"] = {1, "skill_psy20-1"},
    ["forge"] = {1, "skill_psy2-1"},
    ["rune draw"] = {1, "skill_psy4-1"},
    ["rune pulse"] = {1, "skill_psy10-1"},
    ["fearless blow"] = {1, "skill_psy14-1"},
    ["fearless blows"] = {1, "skill_psy14-1"}, -- Duplicate handled
    ["shield form"] = {1, "skill_psy16-2"},
    ["rune energy influx"] = {1, "skill_psy18-2"},
    ["rune growth"] = {1, "skill_psy24-1"},
    ["agitated whirlpool"] = {1, "skill_psy26-1"},
    ["vacuum wave"] = {1, "skill_psy28-1"},
    ["imprisonment pulse"] = {1, "skill_psy32-1"},
    ["kinetic burn"] = {1, "skill_psy34-1"},
    ["feedback defense"] = {1, "skill_psy36-1"},
    ["overrule"] = {1, "skill_psy36-2"},
    ["remodeled body"] = {1, "skill_psy38-1"},
    ["rune overload"] = {1, "skill_psy40-1"},
    ["key rescue"] = {1, "skill_mag_new30-1"},
    -- Suit Skills (Type 2)
    ["disassembly mode"] = {2, "sp_har_003"},
    ["battle defense transfer"] = {2, "sp_har_005"},
    ["organic deconstruction"] = {2, "sp_har_011"},
    ["ferocious disassembly"] = {2, "sp_har_010"},
    ["punisher's disassembly"] = {2, "sp_har_009"},
    -- Champion Elite Skills (Cross-Class)
    ["backlash armor"] = {1, "skill_mag_new15-1"},
    ["suppression offensive"] = {1, "skill_mag_new20-1"},
    ["bloody experience"] = {1, "skill_mag_new35-1"},
    ["rapid spread"] = {1, "skill_mag_new50-1"},
    ["elemental rampage"] = {1, "skill_psy_mag60-1"},
    ["elemental defense"] = {1, "skill_psy_mag70-1"},
    ["high-energy barrier"] = {1, "skill_mag_new45-1"},
    ["shadow pulse"] = {1, "skill_psy_thi20-1"},
    ["waiting game"] = {1, "skill_psy_thi30-1"},
    ["death arrives"] = {1, "skill_psy_thi50-1"},
    ["smoke diffusion"] = {1, "skill_psy_thi60-1"},
    ["shadow explosion"] = {1, "skill_psy_thi70-1"},
    ["divine vengeance"] = {1, "skill_psy_pri15-1"},
    ["rune energy consecration"] = {1, "skill_psy_pri20-1"},
    ["salvation engraving"] = {1, "skill_psy_pri25-1"},
    ["light pulse"] = {1, "skill_psy_pri35-1"},
    ["suicide advance"] = {1, "skill_psy_pri40-1"},
    ["holy attack"] = {1, "skill_psy_pri45-1"},
    ["endless pulse"] = {1, "skill_har_new15-1"},
    ["rune siphon"] = {1, "skill_har_new20-1"},
    ["dark energy strike"] = {1, "skill_har_new30-1"},
    ["indomitable spirit"] = {1, "skill_har_new35-1"},
    ["heart collection rune"] = {1, "skill_har_new40-1"},
    ["soul forge mystery"] = {1, "skill_har_new45-1"},
    ["dark energy punishment"] = {1, "skill_har_new50-1"},
    ["psychic rampage"] = {1, "skill_psy_har70-1"},
    ["arc strike"] = {1, "skill_war_new15-1"},
    ["determination rune"] = {1, "skill_war_new30-1"},
    ["deadland protection"] = {1, "skill_psy_war70-1"},
-- =========================================================================
-- WARDEN
-- =========================================================================
    ["charged chop"] = {1, "skill_ward1-1"},
    ["briar shield"] = {1, "skill_ward4-1"},
    ["power of the wood spirit"] = {1, "skill_ward8-1"},
    ["elven amulet"] = {1, "skill_ward16-1"},
    ["savage power"] = {1, "skill_ward20-1"},
    ["energy absorb"] = {1, "skill_ward1-4"},
    ["recall pet"] = {1, "skill_run3-2"},
    ["summon spirit of the oak"] = {1, "skill_ward1-2"},
    ["thorny vines"] = {1, "skill_ward2-1"},
    ["elven prayer"] = {1, "skill_ward6-1"},
    ["movement restriction"] = {1, "skill_ward10-1"},
    ["summon nature crystal"] = {1, "skill_ward14-1"},
    ["damage transfer"] = {1, "skill_ward22-1"},
    ["heart of the oak"] = {1, "skill_ward24-1"},
    ["frantic briar"] = {1, "skill_ward26-1"},
    ["summon oak walker"] = {1, "skill_ward30-1"},
    ["protection of nature"] = {1, "skill_ward32-2"},
    ["banish"] = {1, "skill_ward36-1"},
    ["power of the oak"] = {1, "skill_ward42-1"},
    ["explosion of power"] = {1, "skill_ward44-1"},
    ["elven guidance"] = {1, "skill_ward48-1"},
    ["cross chop"] = {1, "skill_ward50-1"},   
    -- Warden/Warrior Elite
    ["double chop"] = {1, "skill_ward_new15-1"},
    ["beast chop"] = {1, "skill_ward_new20-4"},
    ["ire"] = {1, "skill_war_new24-1"},
    ["immortal power"] = {1, "skill_war_new30-1"},
    ["pulse mastery"] = {1, "skill_war_new35-1"},
    ["coat of arms"] = {1, "skill_war_new50-1"},
    ["feral leader"] = {1, "skill_ward_war70"},   
    -- Warden/Scout Elite
    ["untamable"] = {1, "skill_ward_new25-2"},   
    -- Suit Skills (Type 2)
    ["dance of confusion"] = {2, "sp_ward_004"},
-- =========================================================================
-- WARRIOR
-- =========================================================================
    ["slash"] = {1, "skill_war1-1"},
    ["enraged"] = {1, "skill_war_aggregation"},
    ["whirlwind"] = {1, "skill_war15-2"},
    ["berserk"] = {1, "skill_war12-1"},
    ["defensive formation"] = {1, "skill_war24-2"},
    ["frenzy"] = {1, "skill_war_berserk"},
    ["open flank"] = {1, "skill_war3-2"},
    ["probing attack"] = {1, "skill_thi3-1"},
    ["tactical attack"] = {1, "skill_war9-1"},
    ["thunder"] = {1, "skill_war15-1"},
    ["feint"] = {1, "skill_war6-1"},
    ["surprise attack"] = {1, "skill_war6-2"},
    ["taunt"] = {1, "skill_war9-2"},
    ["moon cleave"] = {1, "skill_war18-1"},
    ["shout"] = {1, "skill_war18-2"},
    ["terror"] = {1, "skill_war27-2"},
    ["aggresiveness"] = {1, "skill_war39-1"},
    ["survival instinct"] = {1, "skill_war36-1"},
    ["group taunt"] = {1, "skill_war39-2"},
    ["blasting cyclone"] = {1, "skill_war72-1"},
    -- Suit Skills (Type 2)
    ["energy restore"] = {2, "sp_goods_003"},
    ["punishment iss"] = {2, "sp_war_004"},
    ["sword of imprisonment"] = {2, "sp_war_005"},
    ["guardian of the pass"] = {2, "sp_war_011"},
    -- Warrior/Cross-Class Elites
    ["blood dance"] = {1, "skill_war_new20-2"},
    ["keen attack"] = {1, "skill_war_new35-2"},
    ["splitting chop"] = {1, "skill_war_new40-2"},
    ["electrical rage"] = {1, "skill_war_new15-3"},
    ["lightning's touch"] = {1, "skill_war_new20-4"},
    ["sense of danger"] = {1, "skill_war_new50-1"},
    ["lightning burn weapon"] = {1, "skill_war_mag60"},
    ["aim for the wound"] = {1, "skill_war_new15-1"},
    ["sword breath"] = {1, "skill_war_new35-1"},
    ["skull breaker"] = {1, "skill_war_new45-1"},
    ["the final battle"] = {1, "skill_war_new50-3"},
    ["blocking stance"] = {1, "skill_war_new15-4"},
    ["ignore pain"] = {1, "skill_war_new50-2"},
    ["throw shield"] = {1, "skill_war_new45-5"},
    ["shield bash"] = {1, "skill_war_new20-5"},
    ["bloody slash"] = {1, "skill_war_psy25-1"},
    ["stifling attack"] = {1, "skill_war_psy45-1"},
    ["vendetta blow"] = {1, "skill_war_psy50-1"},
    ["defender's roar"] = {1, "skill_war_new60-3"},
    ["opportunity"] = {1, "skill_war_new35-4"},
    ["bloodlust"] = {1, "skill_war_new60-5"},
    ["interrupting strike"] = {1, "skill_war_new45-3"},
    ["magic barrier"] = {1, "skill_aug69-1"},
-- =========================================================================
-- ROGUE
-- =========================================================================
    ["shadowstab"] = {1, "skill_thi1-1"},
    ["shadow step"] = {1, "skill_thi27-2"},
    ["wound attack"] = {1, "skill_thi6-1"},
    ["low blow"] = {1, "skill_thi12-1"},
    ["throw"] = {1, "skill_thi1-2"},
    ["premeditation"] = {1, "skill_thi18-2"},
    ["quickness aura"] = {1, "skill_thi_new15-2"},
    ["poison"] = {1, "skill_thi15-1"},
    ["enchanted throw"] = {1, "skill_thi_mag15"},
    ["lion's protection"] = {1, "skill_thi_new50-2"},
    ["holy light protection"] = {1, "skill_thi_new15-5"},
    ["searing light"] = {1, "skill_thi_new45-10"},
    ["fervent attack"] = {1, "skill_thi8-1"},
    ["informer"] = {1, "skill_thi48-2"},
    ["assassins rage"] = {1, "skill_thi_absolutestrike"},
    ["illusion blade dance"] = {1, "skill_thi_mag70"},
    ["create opportunity"] = {1, "skill_thi_new45-8"},
    ["blind spot"] = {1, "skill_thi3-1"},
    -- Suit Skills (Type 2)
    ["yawaka's blessing"] = {2, "sp_thi_008"},
    ["lion claw mark"] = {2, "sp_thi_009"},
-- =========================================================================
-- PRIEST
-- =========================================================================
    ["rising tide"] = {1, "skill_aug1-1"},
    ["urgent heal"] = {1, "skill_aug42-3"},
    ["regenerate"] = {1, "skill_aug3-1"},
    ["holy aura"] = {1, "skill_aug54-1"},
    ["magic barrier"] = {1, "skill_aug69-1"},
    ["blessed spring water"] = {1, "skill_aug42-1"},
    ["soul source"] = {1, "skill_aug18-1"},
    ["wave armor"] = {1, "skill_aug3-2"},
    ["heal"] = {1, "skill_aug1-2"},
    ["bone chill"] = {1, "skill_aug12-4"},
    ["ice fog"] = {1, "skill_aug6-1"},
    ["soul bond"] = {1, "skill_aug36-1"},
    ["grace of life"] = {1, "skill_aug21-2"},
    ["group heal"] = {1, "skill_aug12-2"},
    ["chain of light"] = {1, "skill_aug12-3"},
    ["cleanse"] = {1, "skill_aug_new35-1"},
    ["amplified attack"] = {1, "skill_mag_powerup"},
    ["healing salve"] = {1, "skill_aug30-2"},
    ["blessing of humility"] = {1, "skill_aug51-2"},   
    -- Priest Elite Skills
    ["embrace of the water spirit"] = {1, "skill_aug_new15-3"},
    ["curing shot"] = {1, "skill_aug_new35-9"},
    ["ice blades"] = {1, "skill_aug_new40-2"},   
    -- Suit Skills (Type 2)
    ["holy candle shield"] = {2, "sp_aug_002"},
    ["cleanse iss"] = {2, "sp_aug_004"},
    ["frost death"] = {2, "sp_aug_z20_001"},
    ["altar of shadoj"] = {2, "sp_aug_005"},
-- =========================================================================
-- DRUID
-- =========================================================================
    ["summon sandstorm"] = {1, "skill_dru46-1"},
    ["earth arrow"] = {1, "skill_dru1-2"},
    ["recover"] = {1, "skill_dru1-1"},
    ["blossoming life"] = {1, "skill_dru10-1"},
    ["mother earth's protection"] = {1, "skill_dru20-1"},
    ["earth pulse"] = {1, "skill_dru12-1"},
    ["mother nature's wrath"] = {1, "skill_dru44-1"},
    ["rockslide"] = {1, "skill_dru18-1"},
    ["purify"] = {1, "skill_dru2-2"},
    ["spirit guidance"] = {1, "skill_dru32-1"},
    ["body vitalization"] = {1, "skill_dru34-1"},
    ["curing seed"] = {1, "skill_dru24-1"},
    ["concentration prayer"] = {1, "skill_dru26-1"},
    ["savage blessing"] = {1, "skill_dru8-1"},
    ["warm spring"] = {1, "skill_ran_new_35-2"},
    ["mother earth's fountain"] = {1, "skill_dru36-1"},
    ["healing arrows"] = {1, "skill_dru_new20-1"},
    ["camellia flower"] = {1, "skill_dru_new15-1"},
    ["unity with mother earth"] = {1, "skill_dru10-2"},
    ["antidote"] = {1, "skill_dru4-1"},
    ["advanced rebirth"] = {1, "skill_dru12-2"},
    ["restore life"] = {1, "skill_dru6-1"},
    ["group exorcism"] = {1, "skill_ran_new30-3"},
    ["rock protection"] = {1, "skill_dru30-1"},
    ["vampire arrows"] = {1, "skill_ran6-3"},
    ["wrist attack"] = {1, "skill_ran18-2"},
    ["joint blow"] = {1, "skill_ran1-1"},
    ["throat attack"] = {1, "skill_ran6-1"},
    ["binding silence"] = {1, "skill_dru22-1"},
    ["withering seed"] = {1, "skill_dru42-1"},
    ["weakening seed"] = {1, "skill_dru14-1"},
    ["briar entwinement"] = {1, "skill_dru2-1"},
-- =========================================================================
-- MAGE
-- =========================================================================
    ["fireball"] = {1, "skill_mag1-1"},
    ["lightning"] = {1, "skill_mag3-1"},
    ["intensification"] = {1, "skill_mag12-2"},
    ["silence"] = {1, "skill_aug39-2"},
    ["fire ward"] = {1, "skill_mag42-2"},
    ["elemental catalysis"] = {1, "skill_mag18-1"},
    ["flame"] = {1, "skill_mag6-2"},
    ["electrostatic charge"] = {1, "skill_mag15-1"},
    ["plasma arrow"] = {1, "skill_mag_new50-6"},
    ["discharge"] = {1, "skill_mag_24-1"},
    ["electric bolt"] = {1, "skill_mag_new50-5"},
    ["meteor shower"] = {1, "skill_mag_54-1"},
    ["electric explosion"] = {1, "skill_mag_new50-7"},
    ["phoenix"] = {1, "skill_mag_21-2"},
    ["electric compression"] = {1, "skill_mag_new50-8"},
    ["static field"] = {1, "skill_mag_new50-9"},
    ["purgatory fire"] = {1, "skill_mag72-1"},
    ["energy influx"] = {1, "skill_mag6-1"},
    ["energy well"] = {1, "skill_mag48-2"},
    ["elemental weakness"] = {1, "skill_mag30-2"},
    ["thunderstorm"] = {1, "skill_mag27-2"},   
    -- Mage/Warlock Elites
    ["static resonance"] = {1, "skill_mag_har_15-1"},
    ["breath erase"] = {1, "skill_mag_har_30-1"},
    ["soul stepping"] = {1, "skill_mag_har_40-1"},
    ["deep inspiration"] = {1, "skill_mag_har_45-1"},
    ["fire lightning burst"] = {1, "skill_mag_har_50-1"},
-- =========================================================================
-- WARLOCK
-- =========================================================================
    ["psychic arrows"] = {1, "skill_har1-1"},
    ["weakening weave curse"] = {1, "skill_har4-1"},
    ["warp charge"] = {1, "skill_har1-2"},
    ["soul pain"] = {1, "skill_har12-1"},
    ["surge of malice"] = {1, "skill_har16-1"},
    ["saces' scorn"] = {1, "skill_har20-1"},
    ["perception extraction"] = {1, "skill_har6-1"},
    ["surge of awareness"] = {1, "skill_har36-1"},
    ["willpower construct"] = {1, "skill_har_0-2"},
    ["otherworldy whisper"] = {1, "skill_har30-2"},
    ["mind barrier"] = {1, "skill_har20-2"},
    ["willpower blade"] = {1, "skill_har_0-1"},
    ["ruthless judgement"] = {1, "skill_har20-3"},
    ["severed consciousness"] = {1, "skill_har10-1"},
    ["knowledge acquisition"] = {1, "skill_har30-3"},   
    -- Warlock/Mage & Specialty Skills
    ["heart collection strike"] = {1, "skill_har22-1"},
    ["flaming heart strike"] = {1, "skill_har_mag20-1"},
    ["puzzlement"] = {1, "skill_har32-1"},
    ["soul trauma"] = {1, "skill_boss_skill_123"},
    ["beast's roar"] = {1, "skill_har26-1"},
    ["shield of solid mind"] = {1, "skill_har14-1"},
    ["defense net"] = {1, "skill_har28-1"},
    ["saces' embrace"] = {1, "skill_har38-1"},
    ["perplexed"] = {1, "skill_aug_new50-13"},
    ["locked heart"] = {1, "skill_boss_skill_100"},
    ["life weave"] = {1, "skill_boss_skill_132"},
    ["soul brand sting"] = {1, "skill_har_mag45-1"},
    ["sublimation weave curse"] = {1, "skill_boss_skill_153"},
-- =========================================================================
-- KNIGHT
-- =========================================================================
    ["holy strike"] = {1, "skill_kni5-1"},
    ["punishment"] = {1, "skill_kni1-2"},
    ["disarmament"] = {1, "skill_kni12-1"},
    ["strike of punishment"] = {1, "skill_war54-1"},
    ["enhanced armor"] = {1, "skill_kni3-1"},
    ["shield of discipline"] = {1, "skill_kni48-1"},
    ["holy shield"] = {1, "skill_kni_godshield"},
    ["holy power explosion"] = {1, "skill_kni12-2"},
    ["holy seal"] = {1, "skill_kni10-1"},
    ["whirlwind shield"] = {1, "skill_kni20-1"},
    ["shackles of light"] = {1, "skill_kni15-2"},
    ["resolution"] = {1, "skill_kni36-1"},
    ["charge"] = {1, "skill_kni21-2"},
    ["threaten"] = {1, "skill_kni16-1"},
    ["shield of valor"] = {1, "skill_kni115-1"},
    ["truth shield bash"] = {1, "skill_kni27-2"},
    ["shock"] = {1, "skill_kni9-1"},
    ["holy strength"] = {1, "skill_kni12-3"},
    ["hall of dead heroes"] = {1, "skill_kni72-1"},  
    -- Knight Elite Skills
    ["holy protection"] = {1, "skill_kni_new45-3"},
    ["holy light domain"] = {1, "skill_kni_new20-3"},
    ["light energy weapon"] = {1, "skill_kni24-2"},
    ["mana shield"] = {1, "skill_kni_new60-5"},
    ["war prayer"] = {1, "skill_kni_new50-9"},	
-- ========================================================================= 
-- Scout
-- =========================================================================

    ["shot"] = {1, "skill_ran1-2"},
    ["vampire arrows"] = {1, "skill_ran6-3"},
    ["joint blow"] = {1, "skill_ran1-1"},
    ["blood arrow"] = {1, "skill_ran9-1"},
    ["throat attack"] = {1, "skill_ran6-1"},
    ["wrist attack"] = {1, "skill_ran18-2"},
    ["piercing arrow"] = {1, "skill_ran21-1"},
    ["reflected shot"] = {1, "skill_ran27-1"},
    ["autoshot"] = {1, "skill_ran_new35-7"},
    ["combo shot"] = {1, "skill_ran3-1"},

    -- Scout/Rogue Skills
    ["deadly poison bite"] = {1, "skill_ran_new35-6"},
    ["sapping arrow"] = {1, "skill_ran_new25-2"},


    }
}
