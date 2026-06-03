PrizeDifferentMenuPtrs:
	dw PrizeMenuMon1Entries, PrizeMenuMon1Cost
	dw PrizeMenuMon2Entries, PrizeMenuMon2Cost
	dw PrizeMenuTMsEntries,  PrizeMenuTMsCost

PrizeMenuMon1Entries:
	db ABRA
	db GROWLITHE
	db SLOWPOKE
	db "@"

PrizeMenuMon1Cost:
	bcd2 200
	bcd2 1100
	bcd2 1600
	db "@"

PrizeMenuMon2Entries:
	db RAICHU
	db DRAGONAIR
	db PORYGON
	db "@"

PrizeMenuMon2Cost:
	bcd2 3200
	bcd2 5000
	bcd2 9100
	db "@"

PrizeMenuTMsEntries:
	db TM_DRAGON_RAGE
	db TM_HYPER_BEAM
	db TM_SUBSTITUTE
	db "@"

PrizeMenuTMsCost:
	bcd2 3300
	bcd2 5500
	bcd2 7700
	db "@"
