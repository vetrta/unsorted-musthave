-- =========================================================================
-- _Gds-Tables/Usablestable.lua - bag items (potions, food)
--
-- Loaded before _Gds.lua (see _Gds.toc). Populates _G.GDS_UsablesTable.
-- Same sys/id/name/icon format as the other two tables.
--
-- Items are the one category where TEXT("Sys"..sys.."_name") is directly
-- confirmed working in the material I looked at (Moodon, _Gds - Original,
-- and RM.lua all used it this exact way for items specifically), so the
-- sys field is worth prioritizing filling in here over the other tables.
-- =========================================================================

_G.GDS_UsablesTable = {
    Usables = {
        -- Currently referenced (disabled) in the DPS rotation's low-energy check
    { name="Potion: Unbridled Enthusiasm",				id="207200" },
	{ name="Clear Thought",								id="207202" },
	{ name="Scarlet Love",								id="207206" },	 
	{ name="Vegetable Sandwich",						id="207652" },
	{ name="Steamed Fish Steak",						id="207612" },
	{ name="Bread with a Pygmierum Aroma",				id="207643" },
	{ name="Hero Potion",								id="200277" },
	{ name="Honey Ribs",								id="207661" },
	{ name="Caviar Sandwich",							id="207211" },
	{ name="Elegant Cuisine Delicacy",					id="241965" },	 
	{ name="Vanilla Strawberry Dessert",				id="241959" },		 
	{ name="Blessing of the Flower God",				id="203024" },	 
	{ name="Strong Stimulant",							id="200173" },
	{ name="Grassland Mix",								id="206874" },
	{ name="Truffle Chocolate",							id="207603" },
	{ name="Touch of the Unicorn",						id="200199" },		
	{ name="Extinction Potion",							id="240534" },	
	{ name="Tranquility Powder",						id="200427" },	
	{ name="Loar Forest Tart",							id="200149" },
	{ name="Little Magic Biscuit",						id="201533" },
	{ name="Strength of Battle",						id="203507" },
	{ name="Universal Potion",							id="202153" },	
	{ name="Serenstum",									id="200150" },	
	{ name="Blessing Potion",							id="240375" },
	{ name="Extinguish Potion",							id="240535" },
	{ name="Moti Blended Sausage",						id="200115" },
	{ name="Rainbow Crystal Candy",						id="200138" },
	{ name="Ancient Spirit Water",						id="200192" },
	{ name="Caviar Sandwich",							id="200098" },
	{ name="Spellweaver Potion",						id="200159" },
	{ name="Red Bean Rice Dumplings",					id="202239" },	
    }
}
