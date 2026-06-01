CeladonMartRoof_Script:
	call EnableAutoTextBoxDrawing
	
	ld de, CeladonMartRoof_ScriptPointers
	ld a, [wCeladonMartRoofCurScript]
	call ExecuteCurMapScriptInTable
	ld [wCeladonMartRoofCurScript], a
	ret
	
CeladonMartRoofResetScripts:
	CheckAndResetEvent EVENT_57E
	call nz, CeladonMartRoofScript_HideChief
	xor a
	ld [wJoyIgnore], a
	
CeladonMartRoofSetCurScript:
	ld [wCeladonMartRoofCurScript], a
	ld [wCurMapScript], a
	ret
	
CeladonMartRoofScript_HideChief:
	ld a, TOGGLE_CELADONMARTROOF_CHIEF
	call CeladonMartRoofScript_HideObject
	ret
	
CeladonMartRoof_ScriptPointers:
	def_script_pointers
	dw_const CeladonMartRoofDefaultScript,               SCRIPT_CELADONMARTROOF_DEFAULT
	dw_const CeladonMartRoofScript_Challenger,           SCRIPT_CELADONMARTROOF_CHALLENGER ;Most recent addition
	dw_const CeladonMartRoofApproachScript,              SCRIPT_CELADONMARTROOF_APPROACH
	dw_const CeladonMartRoofChiefStartBattleScript,      SCRIPT_CELADONMARTROOF_CHIEF_START_BATTLE
	dw_const CeladonMartRoofChiefAfterBattleScript,      SCRIPT_CELADONMARTROOF_CHIEF_AFTER_BATTLE
	dw_const CeladonMartRoofChiefExitScript,             SCRIPT_CELADONMARTROOF_CHIEF_EXIT
	
	
CeladonMartRoofDefaultScript:
	CheckEvent EVENT_BEAT_CELADONMARTROOF_CHIRF
	call z, CeladonMartRoofScript_Challenger
	ret

CeladonMartRoofScript_Challenger:
	ld hl, .ChiefEncounterCoordinates
	call ArePlayerCoordsInArray
	ret nc
	
	ld a, CELADONMARTROOF_CHIEF
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_RIGHT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	
	call StopAllMusic
	ld c, BANK(Music_YellowUnusedSong)
	ld a, MUSIC_YELLOW_UNUSED_SONG
	call PlayMusic
	
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	
	;ld a, PLAYER_DIR_UP
	;ld [wPlayerMovingDirection], a
	
	ld a, TOGGLE_CELADONMARTROOF_CHIEF
	call CeladonMartRoofScript_ShowObject
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	
	ld a, TEXT_CELADONMARTROOF_CHIEF
	ldh [hTextID], a
	call DisplayTextID
	
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	;ld a, $1
	;ld [wSimulatedJoypadStatesIndex], a
	;ld a, PAD_RIGHT
	;ld [wSimulatedJoypadStatesEnd], a
	;call StartSimulatingJoypadStates
	
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	
	ld a, SCRIPT_CELADONMARTROOF_APPROACH
	jp CeladonMartRoofSetCurScript

.ChiefEncounterCoordinates:
	dbmapcoord  13,  3
	dbmapcoord  13,  4
	dbmapcoord  13,  5
	dbmapcoord  13,  6
	dbmapcoord  13,  7
	db -1 ; end
	
CeladonMartRoofApproachScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	;ld a, [wSimulatedJoypadStatesIndex]
	;and a
	;ret nz

	call Delay3

	ld a, CELADONMARTROOF_CHIEF
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF

	ld de, .ChiefMoveDown1

	ld a, [wCoordIndex]
	ld [wSavedCoordIndex], a

	cp 1
	jr z, .movement1

	cp 2
	jr z, .movement2

	cp 3
	jr z, .movement3

	jr .startmove

.movement1
	ld de, .ChiefMoveUp2
	jr .startmove

.movement2
	ld de, .ChiefMoveUp1
	jr .startmove

.movement3
	ld de, .ChiefMovementLeft

.startmove
	ld a, CELADONMARTROOF_CHIEF
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_CELADONMARTROOF_CHIEF_START_BATTLE
	jp CeladonMartRoofSetCurScript
	
.ChiefMoveUp2:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_RIGHT
	db -1
	
.ChiefMoveUp1:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_RIGHT
	db -1

.ChiefMovementLeft:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db -1 ; end
	
.ChiefMoveDown1:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db -1
	

CeladonMartRoofChiefStartBattleScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, TEXT_CELADONMARTROOF_CHIEF_WAITED_HERE
	ldh [hTextID], a
	call DisplayTextID
	call Delay3
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, CeladonMartRoofChiefDefeatedText
	ld de, CeladonMartRoofChiefVictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_CHIEF
	ld [wCurOpponent], a
	;ld a, [wRivalStarter]
	;add 6 ;PINK adjusted pointer from adding Rival data
	ld a, 3 ; trainer number
	ld [wTrainerNo], a
	ld a, SCRIPT_CELADONMARTROOF_CHIEF_AFTER_BATTLE
	call CeladonMartRoofSetCurScript
	ret

CeladonMartRoofChiefAfterBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, CeladonMartRoofDefaultScript
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_CELADONMARTROOF_CHIRF
	ResetEventReuseHL EVENT_57E
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	ld a, CELADONMARTROOF_CHIEF
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_RIGHT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_CELADONMARTROOF_CHIEF_GOOD_LUCK_TO_YOU
	ldh [hTextID], a
	call DisplayTextID
	ld c, BANK(Music_YellowUnusedSong)
	ld a, MUSIC_YELLOW_UNUSED_SONG
	call PlayMusic

	ld de, .ChiefMoveUp3
	ld a, [wSavedCoordIndex]
	cp 1
	jr z, .movement1

	cp 2
	jr z, .movement2

	cp 3
	jr z, .movement3

	jr .startmove

.movement1
	ld de, .ChiefMoveDown1
	jr .startmove

.movement2
	ld de, .ChiefMoveUp1
	jr .startmove

.movement3
	ld de, .ChiefMoveUp2

.startmove
	ld a, CELADONMARTROOF_CHIEF
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, SCRIPT_CELADONMARTROOF_CHIEF_EXIT
	jp CeladonMartRoofSetCurScript
	
.ChiefMoveDown1:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db -1 ; end

.ChiefMoveUp1:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db -1 ; end
	
.ChiefMoveUp2:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db -1
	
.ChiefMoveUp3:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db -1

CeladonMartRoofChiefExitScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, TOGGLE_CELADONMARTROOF_CHIEF
	ld [wToggleableObjectIndex], a
	predef HideObject
	
	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_1
	ld [wToggleableObjectIndex], a
	predef HideObject

	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_2
	ld [wToggleableObjectIndex], a
	predef HideObject

	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_4
	ld [wToggleableObjectIndex], a
	predef HideObject

	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_5
	ld [wToggleableObjectIndex], a
	predef HideObject

	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_6
	ld [wToggleableObjectIndex], a
	predef HideObject

	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_7
	ld [wToggleableObjectIndex], a
	predef HideObject
	
	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_3
	ld [wToggleableObjectIndex], a
	predef ShowObject
	
	call PlayDefaultMusic
	xor a
	ld [wJoyIgnore], a
	jp CeladonMartRoofSetCurScript
	
CeladonMartRoofScript_ShowObject:
	ld [wToggleableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call Delay3
	ret

CeladonMartRoofScript_HideObject:
	ld [wToggleableObjectIndex], a
	predef HideObject
	ret

CeladonMartRoofScript_GetDrinksInBag:
; construct a list of all drinks in the player's bag
	xor a
	ld [wFilteredBagItemsCount], a
	ld de, wFilteredBagItems
	ld hl, CeladonMartRoofDrinkList
.loop
	ld a, [hli]
	and a
	jr z, .done
	push hl
	push de
	ld [wTempByteValue], a
	ld b, a
	predef GetQuantityOfItemInBag
	pop de
	pop hl
	ld a, b
	and a
	jr z, .loop
	; A drink is in the bag
	ld a, [wTempByteValue]
	ld [de], a
	inc de
	push hl
	ld hl, wFilteredBagItemsCount
	inc [hl]
	pop hl
	jr .loop
.done
	ld a, $ff
	ld [de], a
	ret

CeladonMartRoofDrinkList:
	db FRESH_WATER
	db SODA_POP
	db LEMONADE
	db 0 ; end

CeladonMartRoofScript_GiveDrinkToGirl:
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	ld hl, CeladonMartRoofLittleGirlGiveHerWhichDrinkText
	call PrintText
	xor a
	ld [wCurrentMenuItem], a
	ld a, PAD_A | PAD_B
	ld [wMenuWatchedKeys], a
	ld a, [wFilteredBagItemsCount]
	dec a
	ld [wMaxMenuItem], a
	ld a, 2
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
	ld a, [wFilteredBagItemsCount]
	dec a
	ld bc, 2
	ld hl, 3
	call AddNTimes
	dec l
	ld b, l
	ld c, 12
	hlcoord 0, 0
	call TextBoxBorder
	call UpdateSprites
	call CeladonMartRoofScript_PrintDrinksInBag
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call HandleMenuInput
	bit B_PAD_B, a
	ret nz
	ld hl, wFilteredBagItems
	ld a, [wCurrentMenuItem]
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ldh [hItemToRemoveID], a
	cp FRESH_WATER
	jr z, .gaveFreshWater
	cp SODA_POP
	jr z, .gaveSodaPop
; gave Lemonade
	CheckEvent EVENT_GOT_TM49
	jr nz, .alreadyGaveDrink
	ld hl, CeladonMartRoofLittleGirlYayLemonadeText
	call PrintText
	call RemoveItemByIDBank12
	lb bc, TM_TRI_ATTACK, 1
	call GiveItem
	jr nc, .bagFull
	ld hl, CeladonMartRoofLittleGirlReceivedTM49Text
	call PrintText
	SetEvent EVENT_GOT_TM49
	ret
.gaveSodaPop
	CheckEvent EVENT_GOT_TM48
	jr nz, .alreadyGaveDrink
	ld hl, CeladonMartRoofLittleGirlYaySodaPopText
	call PrintText
	call RemoveItemByIDBank12
	lb bc, TM_ROCK_SLIDE, 1
	call GiveItem
	jr nc, .bagFull
	ld hl, CeladonMartRoofLittleGirlReceivedTM48Text
	call PrintText
	SetEvent EVENT_GOT_TM48
	ret
.gaveFreshWater
	CheckEvent EVENT_GOT_TM13
	jr nz, .alreadyGaveDrink
	ld hl, CeladonMartRoofLittleGirlYayFreshWaterText
	call PrintText
	call RemoveItemByIDBank12
	lb bc, TM_ICE_BEAM, 1
	call GiveItem
	jr nc, .bagFull
	ld hl, CeladonMartRoofLittleGirlReceivedTM13Text
	call PrintText
	SetEvent EVENT_GOT_TM13
	ret
.bagFull
	ld hl, CeladonMartRoofLittleGirlNoRoomText
	call PrintText
	ret
.alreadyGaveDrink
	ld hl, CeladonMartRoofLittleGirlImNotThirstyText
	call PrintText
	ret

RemoveItemByIDBank12:
	farcall RemoveItemByID
	ret

CeladonMartRoofLittleGirlGiveHerWhichDrinkText:
	text_far _CeladonMartRoofLittleGirlGiveHerWhichDrinkText
	text_end

CeladonMartRoofLittleGirlYayFreshWaterText:
	text_far _CeladonMartRoofLittleGirlYayFreshWaterText
	text_waitbutton
	text_end

CeladonMartRoofLittleGirlReceivedTM13Text:
	text_far _CeladonMartRoofLittleGirlReceivedTM13Text
	sound_get_item_1
	text_far _CeladonMartRoofLittleGirlTM13ExplanationText
	text_waitbutton
	text_end

CeladonMartRoofLittleGirlYaySodaPopText:
	text_far _CeladonMartRoofLittleGirlYaySodaPopText
	text_waitbutton
	text_end

CeladonMartRoofLittleGirlReceivedTM48Text:
	text_far _CeladonMartRoofLittleGirlReceivedTM48Text
	sound_get_item_1
	text_far _CeladonMartRoofLittleGirlTM48ExplanationText
	text_waitbutton
	text_end

CeladonMartRoofLittleGirlYayLemonadeText:
	text_far _CeladonMartRoofLittleGirlYayLemonadeText
	text_waitbutton
	text_end

CeladonMartRoofLittleGirlReceivedTM49Text:
	text_far _CeladonMartRoofLittleGirlReceivedTM49Text
	sound_get_item_1
	text_far _CeladonMartRoofLittleGirlTM49ExplanationText
	text_waitbutton
	text_end

CeladonMartRoofLittleGirlNoRoomText:
	text_far _CeladonMartRoofLittleGirlNoRoomText
	text_waitbutton
	text_end

CeladonMartRoofLittleGirlImNotThirstyText:
	text_far _CeladonMartRoofLittleGirlImNotThirstyText
	text_waitbutton
	text_end

CeladonMartRoofScript_PrintDrinksInBag:
	ld hl, wFilteredBagItems
	xor a
	ldh [hItemCounter], a
.loop
	ld a, [hli]
	cp $ff
	ret z
	push hl
	ld [wNamedObjectIndex], a
	call GetItemName
	hlcoord 2, 2
	ldh a, [hItemCounter]
	ld bc, SCREEN_WIDTH * 2
	call AddNTimes
	ld de, wNameBuffer
	call PlaceString
	ld hl, hItemCounter
	inc [hl]
	pop hl
	jr .loop

CeladonMartRoof_TextPointers:
	def_text_pointers
	dw_const CeladonMartRoofChiefText,              TEXT_CELADONMARTROOF_CHIEF
	dw_const CeladonMartRoofSuperNerdText,        TEXT_CELADONMARTROOF_SUPER_NERD
	dw_const CeladonMartRoofLittleGirlText,       TEXT_CELADONMARTROOF_LITTLE_GIRL
	dw_const CeladonMartRoofVendingMachineText,   TEXT_CELADONMARTROOF_VENDING_MACHINE1
	dw_const CeladonMartRoofVendingMachineText,   TEXT_CELADONMARTROOF_VENDING_MACHINE2
	dw_const CeladonMartRoofVendingMachineText,   TEXT_CELADONMARTROOF_VENDING_MACHINE3
	dw_const CeladonMartRoofCurrentFloorSignText, TEXT_CELADONMARTROOF_CURRENT_FLOOR_SIGN
	dw_const CeladonMartRoofChiefWaitedHereText,    TEXT_CELADONMARTROOF_CHIEF_WAITED_HERE
	dw_const CeladonMartRoofChiefDefeatedText,      TEXT_CELADONMARTROOF_CHIEF_DEFEATED
	dw_const CeladonMartRoofChiefGoodLuckToYouText, TEXT_CELADONMARTROOF_CHIEF_GOOD_LUCK_TO_YOU

CeladonMartRoofChiefText:
	text_far _CeladonMartRoofChiefText
	text_asm
	ld c, 10
	call DelayFrames
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	ld a, $0
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld c, 20
	call DelayFrames
	jp TextScriptEnd

CeladonMartRoofSuperNerdText:
	text_far _CeladonMartRoofSuperNerdText
	text_end

CeladonMartRoofLittleGirlText:
	text_asm
	call CeladonMartRoofScript_GetDrinksInBag
	ld a, [wFilteredBagItemsCount]
	and a
	jr z, .noDrinksInBag
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .GiveHerADrinkText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .done
	call CeladonMartRoofScript_GiveDrinkToGirl
	jr .done
.noDrinksInBag
	ld hl, .ImThirstyText
	call PrintText
.done
	jp TextScriptEnd

.ImThirstyText:
	text_far _CeladonMartRoofLittleGirlImThirstyText
	text_end

.GiveHerADrinkText:
	text_far _CeladonMartRoofLittleGirlGiveHerADrinkText
	text_end

CeladonMartRoofVendingMachineText:
	script_vending_machine

CeladonMartRoofCurrentFloorSignText:
	text_far _CeladonMartRoofCurrentFloorSignText
	text_end
	
CeladonMartRoofChiefWaitedHereText:
	text_far _CeladonMartRoofChiefWaitedHereText
	text_end

CeladonMartRoofChiefDefeatedText:
	text_far _CeladonMartRoofChiefDefeatedText
	text_end

CeladonMartRoofChiefVictoryText:
	text_far _CeladonMartRoofChiefVictoryText
	text_end

CeladonMartRoofChiefGoodLuckToYouText:
	text_far _CeladonMartRoofChiefGoodLuckToYouText
	text_end

