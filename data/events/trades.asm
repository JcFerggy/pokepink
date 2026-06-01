MACRO npctrade
; give mon, get mon, dialog id, nickname
	db \1, \2, \3
	dname \4, NAME_LENGTH
ENDM

TradeMons:
; entries correspond to TRADE_FOR_* constants
	table_width 3 + NAME_LENGTH
	; The two instances of TRADE_DIALOGSET_EVOLUTION are a leftover
	; from the Japanese Blue trades, which used species that evolve.
	; TRADE_DIALOGSET_EVOLUTION did not refer to evolution in Japanese
	; Red/Green. Japanese Blue changed _AfterTrade2Text to say your Pokémon
	; "went and evolved" and also changed the trades to match. English
	; Red/Blue uses the original JP Red/Green trades but with the JP Blue
	; post-trade text. English Yellow changed _AfterTrade2Text to
	; not mention evolution.
	npctrade DITTO, 	 	DODRIO,  	TRADE_DIALOGSET_CASUAL,    	"STOOGES" 	; Route 11
	npctrade PIKACHU,		DROWZEE,  	TRADE_DIALOGSET_CASUAL,    	"SANDMAN" 	; Route 2
	npctrade BEEDRILL,		BUTTERFREE, TRADE_DIALOGSET_HAPPY,     	"MARGE" 	; unused
	npctrade TAUROS,	    KOFFING,    TRADE_DIALOGSET_CASUAL,    	"SMOKEY"	; Pokemon Lab 3
	npctrade MEW,        	MEW,      	TRADE_DIALOGSET_HAPPY,     	"LISA"    	; unused
	npctrade RHYHORN,    	CHANSEY, 	TRADE_DIALOGSET_CASUAL,    	"CHERYL" 	; Route 18
	npctrade PIDGEOT,    	PIDGEOT,  	TRADE_DIALOGSET_EVOLUTION, 	"MCFLY"   	; unused
	npctrade KINGLER,    	SANDSHREW,  TRADE_DIALOGSET_HAPPY, 		"SCRAPPY" 	; Pokemon Lab 1
	npctrade VULPIX,		STARMIE,  	TRADE_DIALOGSET_HAPPY,     	"ORION" 	; Pokemon Lab 2
	npctrade VOLTORB,     	KADABRA,  	TRADE_DIALOGSET_EVOLUTION, 	"HOUDINI" 	; Underground Path 5-6
	assert_table_length NUM_NPC_TRADES
	
;	npctrade LICKITUNG,  DUGTRIO,  TRADE_DIALOGSET_CASUAL,    "GURIO" 	; Route 11
;	npctrade CLEFAIRY,   MR_MIME,  TRADE_DIALOGSET_CASUAL,    "MILES" 	; Route 2
;	npctrade BUTTERFREE, BEEDRILL, TRADE_DIALOGSET_HAPPY,     "STINGER" ; unused
;	npctrade KANGASKHAN, MUK,      TRADE_DIALOGSET_CASUAL,    "STICKY" 	; Pokemon Lab 3
;	npctrade MEW,        MEW,      TRADE_DIALOGSET_HAPPY,     "BART"    ; unused
;	npctrade TANGELA,    PARASECT, TRADE_DIALOGSET_CASUAL,    "SPIKE" 	; Route 18
;	npctrade PIDGEOT,    PIDGEOT,  TRADE_DIALOGSET_EVOLUTION, "MARTY"   ; unused
;	npctrade GOLDUCK,    RHYDON,   TRADE_DIALOGSET_EVOLUTION, "BUFFY" 	; Pokemon Lab 1
;	npctrade GROWLITHE,  DEWGONG,  TRADE_DIALOGSET_HAPPY,     "CEZANNE" ; Pokemon Lab 2
;	npctrade CUBONE,     MACHOKE,  TRADE_DIALOGSET_HAPPY,     "RICKY" 	; Underground Path 5-6