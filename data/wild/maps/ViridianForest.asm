ViridianForestWildMons:
	def_grass_wildmons 25 ; encounter rate
	db  3, WEEDLE ;Swap, was missing in Yellow, felt appropriate given Red/Blue balance.
	db  4, KAKUNA ;""
	db  4, WEEDLE ;""
	db  5, WEEDLE ;""
	db  4, ZUBAT ;Manga
	db  5, PARAS ;Manga
	db  6, CATERPIE ;Balance, didn't want too many poison this early game.
	db  6, METAPOD ;Balance
	db  6, MEOWTH ;Manga
	db  9, GASTLY ;Manga
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons

;Yellow
;	db  3, CATERPIE
;	db  4, METAPOD
;	db  4, CATERPIE
;	db  5, CATERPIE
;	db  4, PIDGEY
;	db  6, PIDGEY
;	db  6, CATERPIE
;	db  6, METAPOD
;	db  8, PIDGEY
;	db  9, PIDGEOTTO

;IF DEF(_RED)
;	db  4, WEEDLE
;	db  5, KAKUNA
;	db  3, WEEDLE
;	db  5, WEEDLE
;	db  4, KAKUNA
;	db  6, KAKUNA
;	db  4, METAPOD
;	db  3, CATERPIE
;ENDC
;IF DEF(_BLUE)
;	db  4, CATERPIE
;	db  5, METAPOD
;	db  3, CATERPIE
;	db  5, CATERPIE
;	db  4, METAPOD
;	db  6, METAPOD
;	db  4, KAKUNA
;	db  3, WEEDLE
;ENDC
;	db  3, PIKACHU
;	db  5, PIKACHU

;Blue
;	def_grass_wildmons 8 ; encounter rate
;	db  4, CATERPIE
;	db  5, METAPOD
;	db  3, CATERPIE
;	db  5, CATERPIE
;	db  4, METAPOD
;	db  6, METAPOD
;	db  4, KAKUNA
;	db  3, WEEDLE
;	db  3, PIKACHU
;	db  5, PIKACHU
;	end_grass_wildmons