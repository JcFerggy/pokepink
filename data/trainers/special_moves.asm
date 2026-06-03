; Yellow entry format:
;	db trainerclass, trainerid
;	repeat { db partymon location, partymon move, move id }
;	db 0

SpecialTrainerMoves:
	db BUG_CATCHER, 15
	db 2, 2, POISON_STING ;Kakuna
	db 2, 3, STRING_SHOT
	db 0

	db YOUNGSTER, 14
	db 1, 4, DIG ;Growlith
	db 0
	
	db UNUSED_JUGGLER, 1 ;Yellow manga
	db 1, 1, QUICK_ATTACK ;Pikachu
	db 1, 2, SURF 
	db 2, 1, MEGA_PUNCH 
	db 3, 1, AGILITY 
	db 3, 2, FIRE_BLAST 
	db 3, 2, DIG 
	db 5, 1, REST 
	db 5, 2, TOXIC 
	db 6, 1, MEGA_DRAIN 
	db 0
	
	PSYCHIC:
	db 1, 1, PSYWAVE ;Abra
	db 1, 2, KINESIS
	db 1, 3, THUNDER_WAVE
	db 1, 4, TRI_ATTACK
	db 0
	
	db JUGGLER, 4
	db 1, 1, TOXIC ;Chansey 1
	db 1, 4, SOFTBOILED
	db 1, 1, METRONOME ;Chansey 1
	db 2, 2, MEGA_PUNCH
	db 2, 3, THUNDER_WAVE
	db 2, 4, SOFTBOILED
	db 3, 1, TOXIC
	db 3, 2, MEGA_KICK
	db 3, 3, COUNTER
	db 3, 4, SOFTBOILED
	db 4, 1, SUBSTITUTE
	db 4, 2, TRI_ATTACK
	db 4, 3, REST
	db 4, 4, SOFTBOILED
	db 5, 1, TOXIC
	db 5, 2, HYPER_BEAM
	db 5, 3, SOFTBOILED
	db 5, 4, EGG_BOMB
	db 0

	db BROCK, 1
	db 2, 3, BIND
	db 2, 4, BIDE
	db 0

	db MISTY, 1
	db 2, 3, WATER_GUN ;Jigglypuff
	db 2, 3, BUBBLEBEAM
	db 3, 3, BUBBLEBEAM ;Blastoise
	db 0

	db LT_SURGE, 1
	db 2, 4, CUT
	db 3, 3, SWIFT
	db 3, 4, THUNDERBOLT
	db 0

	db ERIKA, 1
	db 1, 3, MEGA_DRAIN ;ODDISH
	db 2, 3, MEGA_DRAIN ;Tangela
	db 2, 4, CUT ;Tangela
	db 3, 1, PETAL_DANCE ;Gloom
	db 4, 3, RAZOR_LEAF ;Venusaur
	db 4, 4, MEGA_DRAIN
	db 5, 4, MEGA_DRAIN
	db 0

	db KOGA, 1
	db 1, 1, TOXIC ;GRIMER
	db 2, 2, TOXIC ;KOFFING
	db 2, 3, SUPERSONIC
	db 3, 1, TOXIC ;MUK
	db 4, 1, FLAMETHROWER ;NINETALES
	db 4, 2, TOXIC
	db 4, 4, SWIFT
	db 5, 1, REST ;WEEZING
	db 5, 2, DOUBLE_TEAM
	db 5, 3, HYPER_BEAM
	db 5, 4, TOXIC
	db 0

	db BLAINE, 1
	db 1, 1, FLAMETHROWER ;MAGMAR
	db 2, 1, MEGA_PUNCH ;PRIMEAPE
	db 2, 3, FIRE_PUNCH
	db 3, 1, FLAMETHROWER ;RAPIDASH
	db 4, 1, FIRE_BLAST ;GOLEM
	db 4, 3, ROCK_SLIDE
	db 5, 2, FIRE_BLAST ;ARCANINE
	db 5, 3, REFLECT
	db 0

	db SABRINA, 1
	db 1, 1, KINESIS
	db 1, 4, PSYWAVE
	db 2, 4, PSYWAVE
	db 2, 4, HYPNOSIS
	db 3, 3, PSYWAVE
	db 4, 1, PSYWAVE
	db 0
	
	db CHIEF, 4; PINK
	db 1, 1, DOUBLE_TEAM
	db 1, 2, SLAM
	db 1, 3, THUNDERBOLT
	db 1, 4, AGILITY
	db 2, 3, FLY
	db 4, 3, FLY
	db 0
	
	db CHIEF, 4; PINK
	db 1, 1, SLAM
	db 1, 2, THUNDERBOLT
	db 1, 3, AGILITY
	db 1, 4, THUNDER
	db 2, 4, FLY
	db 3, 2, TOXIC
	db 4, 4, FLY
	db 5, 1, SURF
	db 0
	
	db CHIEF, 5; PINK
	db 1, 1, SLAM
	db 1, 2, SWIFT
	db 1, 3, AGILITY
	db 1, 4, THUNDER
	db 3, 2, TOXIC
	db 4, 4, FLY
	db 5, 1, SURF
	db 0
	
	db CHIEF, 6; PINK
	db 1, 1, SLAM
	db 1, 2, SWIFT
	db 1, 3, AGILITY
	db 1, 4, THUNDER
	db 3, 2, TOXIC
	db 4, 2, FLY
	db 5, 4, SURF
	db 0
	
	db CHIEF, 7; PINK
	db 1, 1, SLAM
	db 1, 2, SWIFT
	db 1, 3, AGILITY
	db 1, 4, THUNDER
	db 3, 2, TOXIC
	db 4, 2, FLY
	db 0

	db GIOVANNI, 3
	db 1, 3, FISSURE
	db 2, 1, EARTHQUAKE
	db 2, 3, THUNDER
	db 3, 1, EARTHQUAKE
	db 3, 2, LEER
	db 3, 3, THUNDER
	db 4, 1, ROCK_SLIDE
	db 4, 4, EARTHQUAKE
	db 0

	db LORELEI, 1
	db 1, 1, BUBBLEBEAM
	db 2, 3, ICE_BEAM
	db 3, 1, PSYCHIC_M
	db 3, 2, SURF
	db 4, 3, LOVELY_KISS
	db 5, 3, BLIZZARD
	db 0

	db BRUNO, 1
	db 1, 1, ROCK_SLIDE ;ONIX
	db 1, 2, SCREECH
	db 1, 4, DIG
	db 2, 3, FIRE_PUNCH ;HITMONCHAN
	db 2, 4, DOUBLE_TEAM
	db 3, 1, DOUBLE_KICK ;HITMONLEE
	db 3, 2, MEGA_KICK
	db 3, 4, DOUBLE_TEAM
	db 4, 1, SUBMISSION ;GOLEM, was ONIX
	;db 4, 2, SCREECH
	db 4, 4, ROCK_SLIDE
	db 5, 2, KARATE_CHOP ;MACHAMP
	db 5, 3, STRENGTH
	db 0

	db AGATHA, 1
	db 1, 2, SUBSTITUTE
	db 1, 3, LICK
	db 2, 1, SUPERSONIC ;LICKITUNG was GOLBAT
	db 2, 2, TOXIC
	db 2, 3, LICK
	db 2, 4, BODY_SLAM
	db 3, 2, LICK ;HAUNTER
	db 4, 1, TRI_ATTACK ;CLEFABLE was ARBOK
	db 4, 2, TOXIC
	db 5, 2, PSYCHIC_M ;GENGAR
	db 0

	db LANCE, 1
	db 1, 1, DRAGON_RAGE
	db 2, 1, THUNDER_WAVE
	db 2, 3, THUNDERBOLT
	db 3, 1, BUBBLEBEAM
	db 3, 2, WRAP
	db 3, 3, ICE_BEAM
	db 4, 1, WING_ATTACK
	db 4, 2, SWIFT
	db 4, 3, FLY
	db 5, 1, BLIZZARD
	db 5, 2, FIRE_BLAST
	db 5, 3, THUNDER
	db 0

	db RIVAL3, 1
	db 1, 1, SLUDGE
	db 1, 2, TOXIC
	
	db 2, 1, BODY_SLAM
	db 2, 2, PSYCHIC_M
	
	db 3, 2, REST
	db 3, 3, SWIFT
	db 3, 4, SKULL_BASH
	
	db 4, 1, EARTHQUAKE
	db 4, 3, ROCK_SLIDE
	
	db 4, 4, TAKE_DOWN
	db 4, 3, ICE_PUNCH
	db 4, 4, SURF
	
	db 6, 2, SEISMIC_TOSS
	db 6, 3, QUICK_ATTACK
	db 0

	db -1 ; end
