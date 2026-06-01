SafariZoneWest_Script:
	call EnableAutoTextBoxDrawing
	
	ld de, SafariZoneWest_ScriptPointers
	ld a, [wSafariZoneWestCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSafariZoneWestCurScript], a
	ret
	
SafariZoneWestResetScripts:
	CheckAndResetEvent EVENT_57E
	call nz, SafariZoneWestScript_HideChief
	xor a
	ld [wJoyIgnore], a
	
SafariZoneWestSetCurScript:
	ld [wSafariZoneWestCurScript], a
	ld [wCurMapScript], a
	ret
	
SafariZoneWestScript_HideChief:
	ld a, TOGGLE_SAFARIZONEWEST_CHIEF
	call SafariZoneWestScript_HideObject
	ret

SafariZoneWest_ScriptPointers:
	def_script_pointers
	dw_const SafariZoneWestDefaultScript,               SCRIPT_SAFARIZONEWEST_DEFAULT
	dw_const SafariZoneWestScript_Challenger,           SCRIPT_SAFARIZONEWEST_CHALLENGER ;Most recent addition
	dw_const SafariZoneWestApproachScript,              SCRIPT_SAFARIZONEWEST_APPROACH
	dw_const SafariZoneWestChiefStartBattleScript,      SCRIPT_SAFARIZONEWEST_CHIEF_START_BATTLE
	dw_const SafariZoneWestChiefAfterBattleScript,      SCRIPT_SAFARIZONEWEST_CHIEF_AFTER_BATTLE
	dw_const SafariZoneWestChiefExitScript,             SCRIPT_SAFARIZONEWEST_CHIEF_EXIT
	
	
SafariZoneWestDefaultScript:
	CheckEvent EVENT_BEAT_SAFARIZONEWEST_CHIRF
	call z, SafariZoneWestScript_Challenger
	ret

SafariZoneWestScript_Challenger:
	ld hl, .ChiefEncounterCoordinates
	call ArePlayerCoordsInArray
	ret nc
	
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
	
	ld a, TOGGLE_SAFARIZONEWEST_CHIEF
	call SafariZoneWestScript_ShowObject
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	
	ld a, TEXT_SAFARIZONEWEST_CHIEF
	ldh [hTextID], a
	call DisplayTextID
	
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates
	
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	
	ld a, SCRIPT_SAFARIZONEWEST_APPROACH
	jp SafariZoneWestSetCurScript

.ChiefEncounterCoordinates:
	dbmapcoord  5,  4
	dbmapcoord  4,  4
	dbmapcoord  3,  4
	dbmapcoord  2,  4
	db -1 ; end
	
SafariZoneWestApproachScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz

	call Delay3

	ld a, SAFARIZONEWEST_CHIEF
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
	ld a, SAFARIZONEWEST_CHIEF
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_SAFARIZONEWEST_CHIEF_START_BATTLE
	jp SafariZoneWestSetCurScript
	
.ChiefMoveUp2:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db -1
	
.ChiefMoveUp1:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db -1

.ChiefMovementLeft:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db -1 ; end
	
.ChiefMoveDown1:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db -1

SafariZoneWestChiefStartBattleScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, SAFARIZONEWEST_CHIEF
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_SAFARIZONEWEST_CHIEF_WAITED_HERE
	ldh [hTextID], a
	call DisplayTextID
	call Delay3
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, SafariZoneWestChiefDefeatedText
	ld de, SafariZoneWestChiefVictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_CHIEF
	ld [wCurOpponent], a
	;ld a, [wRivalStarter]
	;add 6 ;PINK adjusted pointer from adding Rival data
	ld a, 4 ; trainer number
	ld [wTrainerNo], a
	ld a, SCRIPT_SAFARIZONEWEST_CHIEF_AFTER_BATTLE
	call SafariZoneWestSetCurScript
	ret

SafariZoneWestChiefAfterBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, SafariZoneWestDefaultScript
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_SAFARIZONEWEST_CHIRF
	ResetEventReuseHL EVENT_57E
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, SAFARIZONEWEST_CHIEF
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_SAFARIZONEWEST_CHIEF_GOOD_LUCK_TO_YOU
	ldh [hTextID], a
	call DisplayTextID
	ld c, BANK(Music_YellowUnusedSong)
	ld a, MUSIC_YELLOW_UNUSED_SONG
	call PlayMusic

	ld a, [wSavedCoordIndex]

	ld de, .ChiefExitDownLeftMovement

	ld a, SAFARIZONEWEST_CHIEF
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, SCRIPT_SAFARIZONEWEST_CHIEF_EXIT
	jp SafariZoneWestSetCurScript
	

.ChiefExitDownLeftMovement:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1 ; end

SafariZoneWestChiefExitScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, TOGGLE_SAFARIZONEWEST_CHIEF
	ld [wToggleableObjectIndex], a
	predef HideObject
	
	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_1
	ld [wToggleableObjectIndex], a
	predef HideObject

	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_2
	ld [wToggleableObjectIndex], a
	predef HideObject

	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_3
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
	
	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_4
	ld [wToggleableObjectIndex], a
	predef ShowObject
	
	call PlayDefaultMusic
	xor a
	ld [wJoyIgnore], a
	jp SafariZoneWestSetCurScript
	
SafariZoneWestScript_ShowObject:
	ld [wToggleableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call Delay3
	ret

SafariZoneWestScript_HideObject:
	ld [wToggleableObjectIndex], a
	predef HideObject
	ret

SafariZoneWest_TextPointers:
	def_text_pointers
	dw_const SafariZoneWestChiefText,              TEXT_SAFARIZONEWEST_CHIEF
	dw_const PickUpItemText,                         TEXT_SAFARIZONEWEST_MAX_POTION
	dw_const PickUpItemText,                         TEXT_SAFARIZONEWEST_TM_DOUBLE_TEAM
	dw_const PickUpItemText,                         TEXT_SAFARIZONEWEST_MAX_REVIVE
	dw_const PickUpItemText,                         TEXT_SAFARIZONEWEST_GOLD_TEETH
	dw_const SafariZoneWestRestHouseSignText,        TEXT_SAFARIZONEWEST_REST_HOUSE_SIGN
	dw_const SafariZoneWestFindWardensTeethSignText, TEXT_SAFARIZONEWEST_FIND_WARDENS_TEETH_SIGN
	dw_const SafariZoneWestTrainerTipsText,          TEXT_SAFARIZONEWEST_TRAINER_TIPS
	dw_const SafariZoneWestSignText,                 TEXT_SAFARIZONEWEST_SIGN
	dw_const SafariZoneWestChiefWaitedHereText,    TEXT_SAFARIZONEWEST_CHIEF_WAITED_HERE
	dw_const SafariZoneWestChiefDefeatedText,      TEXT_SAFARIZONEWEST_CHIEF_DEFEATED
	dw_const SafariZoneWestChiefGoodLuckToYouText, TEXT_SAFARIZONEWEST_CHIEF_GOOD_LUCK_TO_YOU

SafariZoneWestChiefText:
	text_far _SafariZoneWestChiefText
	text_asm
	ld c, 10
	call DelayFrames
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, $0
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld c, 20
	call DelayFrames
	jp TextScriptEnd

SafariZoneWestRestHouseSignText:
	text_far _SafariZoneWestRestHouseSignText
	text_end

SafariZoneWestFindWardensTeethSignText:
	text_far _SafariZoneWestFindWardensTeethSignText
	text_end

SafariZoneWestTrainerTipsText:
	text_far _SafariZoneWestTrainerTipsText
	text_end

SafariZoneWestSignText:
	text_far _SafariZoneWestSignText
	text_end
	
SafariZoneWestChiefWaitedHereText:
	text_far _SafariZoneWestChiefWaitedHereText
	text_end

SafariZoneWestChiefDefeatedText:
	text_far _SafariZoneWestChiefDefeatedText
	text_end

SafariZoneWestChiefVictoryText:
	text_far _SafariZoneWestChiefVictoryText
	text_end

SafariZoneWestChiefGoodLuckToYouText:
	text_far _SafariZoneWestChiefGoodLuckToYouText
	text_end
