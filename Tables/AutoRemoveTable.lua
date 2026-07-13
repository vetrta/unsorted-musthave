local autoremovebuffs = {
    Classes = {
		PSYRON = { --Champion
--Priest		
			[500527] = true, --Healing salve		
			[503736] = true, --p/s fairy		
			[503742] = true, --p/k fairy
			[503738] = true, --p/r Fairy
			[503740] = true, --p/m Fairy
			[503734] = true, --p/w Fairy		
			[500940] = true, --amp
			[500536] = true, --Blessed spring water		
			[500548] = true, --Magic barrier		
			[500479] = true, --Wave Armor		
			[503196] = true, --shadow Fury
			[502026] = true, --Angels Blessing
			[502033] = true, --Enchaned Grace
			[621525] = true, --Blessed spring water				
--Mage			
			[500366] = true, --Fire ward
			[501962] = true, --Essence of Magic	
--Druid			
			[503799] = true, --Concentration Prayer
			[505157] = true, --Awakening of the Wild		
			[505165] = true, --Mysterious Grace			
--Housemaid			
			[506639] = true, --Embrace of an inspired heart	(Housemaid Crit)
			[506694] = true, --Embrace of gentle tightness 1 (Housemaid Pdeff %)
			[506693] = true, --Embrace of gentle tightness 2 (Housemaid Pdeff)
--HOE			
			[625648] = true, --Haidon arcane arts Dex %
			[625646] = true, --Haidon arcane arts int %
			[625645] = true, --Haidon arcane arts Stam %
			[625644] = true, --Haidon arcane arts Stre %
			[625647] = true, --Haidon arcane arts Wis %						
--			[625682] = true, --Haidon arcane arts Physical Attack %
			[625653] = true, --Haidon arcane arts Magical Attack% 			
			[625649] = true, --Haidon arcane arts Pdeff %
			[625654] = true, --Haidon arcane arts Mdeff %
			[625655] = true, --Haidon arcane arts HP recover %  
			[625656] = true, --Haidon arcane arts Mana Regen %
 			[625650] = true, --Haidon arcane arts Maximum HP %
			[625651] = true, --Haidon arcane arts Maximum Mana % 
--Sigils
--			[500999] = true, --Physical attack sigil
			[501000] = true, --Pdeff sigil			
			[501001] = true, --Exp sigil
			[501002] = true, --Magical attack sigil			
			[501003] = true, --Mdeff sigil
			[501004] = true, --Talent					
        },
		WARDEN = { --Warden
			[500527] = true, --Healing salve
		},
		KNIGHT = { --Knight
			[500527] = true, --Healing salve
		},
		AUGUR = { --Priest
			[500527] = true, --Healing salve
		},
		WARRIOR = { --Warrior
			[500527] = true, --Healing salve
		},		
		RANGER = { --Scout
--Priest		
			[500527] = true, --Healing salve		
			[503736] = true, --p/s fairy		
			[503742] = true, --p/k fairy
			[503738] = true, --p/r Fairy
			[503740] = true, --p/m Fairy
			[503734] = true, --p/w Fairy		
--			[500940] = true, --amp
			[500536] = true, --Blessed spring water		
			[500548] = true, --Magic barrier		
			[500479] = true, --Wave Armor		
			[503196] = true, --shadow Fury
			[502026] = true, --Angels Blessing
--Mage			
			[500366] = true, --Fire ward
			[501962] = true, --Essence of Magic	
--Druid			
			[503799] = true, --Concentration Prayer
--			[505157] = true, --Awakening of the Wild		
			[505165] = true, --Mysterious Grace			
--Housemaid			
			[506639] = true, --Embrace of an inspired heart	(Housemaid Crit)
			[506694] = true, --Embrace of gentle tightness 1 (Housemaid Pdeff %)
			[506693] = true, --Embrace of gentle tightness 2 (Housemaid Pdeff)
--HOE			
			[625648] = true, --Haidon arcane arts Dex %
			[625646] = true, --Haidon arcane arts int %
			[625645] = true, --Haidon arcane arts Stam %
			[625644] = true, --Haidon arcane arts Stre %
			[625647] = true, --Haidon arcane arts Wis %						
--			[625682] = true, --Haidon arcane arts Physical Attack %
			[625653] = true, --Haidon arcane arts Magical Attack% 			
			[625649] = true, --Haidon arcane arts Pdeff %
			[625654] = true, --Haidon arcane arts Mdeff %
			[625655] = true, --Haidon arcane arts HP recover %  
			[625656] = true, --Haidon arcane arts Mana Regen %
 			[625650] = true, --Haidon arcane arts Maximum HP %
			[625651] = true, --Haidon arcane arts Maximum Mana % 
--Sigils
--			[500999] = true, --Physical attack sigil
			[501000] = true, --Pdeff sigil			
			[501001] = true, --Exp sigil
			[501002] = true, --Magical attack sigil			
			[501003] = true, --Mdeff sigil
			[501004] = true, --Talent			
		},
		THIEF = { --Rogue
--Priest		
			[500527] = true, --Healing salve		
			[503736] = true, --p/s fairy		
			[503742] = true, --p/k fairy
			[503738] = true, --p/r Fairy
			[503740] = true, --p/m Fairy
			[503734] = true, --p/w Fairy		
--			[500940] = true, --amp
			[500536] = true, --Blessed spring water		
			[500548] = true, --Magic barrier		
			[500479] = true, --Wave Armor		
			[503196] = true, --shadow Fury
			[502026] = true, --Angels Blessing
--Mage			
			[500366] = true, --Fire ward
			[501962] = true, --Essence of Magic	
--Druid			
			[503799] = true, --Concentration Prayer
--			[505157] = true, --Awakening of the Wild		
			[505165] = true, --Mysterious Grace			
--Housemaid			
			[506639] = true, --Embrace of an inspired heart	(Housemaid Crit)
			[506694] = true, --Embrace of gentle tightness 1 (Housemaid Pdeff %)
			[506693] = true, --Embrace of gentle tightness 2 (Housemaid Pdeff)
--HOE			
			[625648] = true, --Haidon arcane arts Dex %
			[625646] = true, --Haidon arcane arts int %
			[625645] = true, --Haidon arcane arts Stam %
			[625644] = true, --Haidon arcane arts Stre %
			[625647] = true, --Haidon arcane arts Wis %						
--			[625682] = true, --Haidon arcane arts Physical Attack %
			[625653] = true, --Haidon arcane arts Magical Attack% 			
			[625649] = true, --Haidon arcane arts Pdeff %
			[625654] = true, --Haidon arcane arts Mdeff %
			[625655] = true, --Haidon arcane arts HP recover %  
			[625656] = true, --Haidon arcane arts Mana Regen %
 			[625650] = true, --Haidon arcane arts Maximum HP %
			[625651] = true, --Haidon arcane arts Maximum Mana % 
--Sigils
--			[500999] = true, --Physical attack sigil
			[501000] = true, --Pdeff sigil			
			[501001] = true, --Exp sigil
			[501002] = true, --Magical attack sigil			
			[501003] = true, --Mdeff sigil
			[501004] = true, --Talent			
		},		
		HARPSYN = { --Warlock
			[500527] = true, --Healing salve		
			[500366] = true, --Fire ward
			[505157] = true, --Awakening of the Wild
			[500940] = true, --amp
			[500536] = true, --Blessed spring water		
			[500548] = true, --Magic barrier		
			[500479] = true, --Wave Armor
			[502026] = true, --Angels Blessing
			[503799] = true, --Concentration Prayer
			[506639] = true, --Embrace of an inspired heart	(Housemaid Crit)
			[506694] = true, --Embrace of gentle tightness 1 (Housemaid Pdeff %)
			[506693] = true, --Embrace of gentle tightness 2 (Housemaid Pdeff)
			[625648] = true, --Haidon arcane arts Dex %
			[625646] = true, --Haidon arcane arts int %
			[625645] = true, --Haidon arcane arts Stam %
			[625644] = true, --Haidon arcane arts Stre %
			[625647] = true, --Haidon arcane arts Wis %						
			[625682] = true, --Haidon arcane arts Physical Attack %
--			[625653] = true, --Haidon arcane arts Magical Attack% 			
			[625649] = true, --Haidon arcane arts Pdeff %
			[625654] = true, --Haidon arcane arts Mdeff %
			[625655] = true, --Haidon arcane arts HP recover %  
			[625656] = true, --Haidon arcane arts Mana Regen %
 			[625650] = true, --Haidon arcane arts Maximum HP %
			[625651] = true, --Haidon arcane arts Maximum Mana % 			
        },
		MAGE = { --Mage
			[500527] = true, --Healing salve		
			[500366] = true, --Fire ward
			[505157] = true, --Awakening of the Wild
			[500940] = true, --amp
			[500536] = true, --Blessed spring water		
			[500548] = true, --Magic barrier		
			[500479] = true, --Wave Armor
			[502026] = true, --Angels Blessing
			[503799] = true, --Concentration Prayer
			[506639] = true, --Embrace of an inspired heart	(Housemaid Crit)
			[506694] = true, --Embrace of gentle tightness 1 (Housemaid Pdeff %)
			[506693] = true, --Embrace of gentle tightness 2 (Housemaid Pdeff)
			[625648] = true, --Haidon arcane arts Dex %
			[625646] = true, --Haidon arcane arts int %
			[625645] = true, --Haidon arcane arts Stam %
			[625644] = true, --Haidon arcane arts Stre %
			[625647] = true, --Haidon arcane arts Wis %						
			[625682] = true, --Haidon arcane arts Physical Attack %
--			[625653] = true, --Haidon arcane arts Magical Attack% 			
			[625649] = true, --Haidon arcane arts Pdeff %
			[625654] = true, --Haidon arcane arts Mdeff %
			[625655] = true, --Haidon arcane arts HP recover %  
			[625656] = true, --Haidon arcane arts Mana Regen %
 			[625650] = true, --Haidon arcane arts Maximum HP %
			[625651] = true, --Haidon arcane arts Maximum Mana % 
		}
	}	
}
