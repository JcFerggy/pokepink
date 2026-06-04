UndergroundPathWestEast_Script:
	call EnableAutoTextBoxDrawing
	
	ld de, UndergroundPathWestEast_ScriptPointers
	ld a, [wUndergroundPathWestEastCurScript]
	call ExecuteCurMapScriptInTable
	ld [wUndergroundPathWestEastCurScript], a
	ret
	
UndergroundPathWestEastResetScripts:
	CheckAndResetEvent EVENT_UNDERGROUNDPATHWESTEAST_CHIEF_RESET
	call nz, UndergroundPathWestEastScript_HideChief
	xor a
	ld [wJoyIgnore], a
UndergroundPathWestEastSetCurScript:
	ld [wUndergroundPathWestEastCurScript], a
	ld [wCurMapScript], a
	ret
	
UndergroundPathWestEastScript_HideChief:
	ld a, TOGGLE_UNDERGROUNDPATHWESTEAST_CHIEF
	call UndergroundPathWestEastScript_HideObject
	ret
	
UndergroundPathWestEast_ScriptPointers:
	def_script_pointers
	dw_const UndergroundPathWestEastDefaultScript,               SCRIPT_UNDERGROUNDPATHWESTEAST_DEFAULT
	dw_const UndergroundPathWestEastScript_Challenger,           SCRIPT_UNDERGROUNDPATHWESTEAST_CHALLENGER ;Most recent addition
	dw_const UndergroundPathWestEastApproachScript,              SCRIPT_UNDERGROUNDPATHWESTEAST_APPROACH
	dw_const UndergroundPathWestEastChiefStartBattleScript,      SCRIPT_UNDERGROUNDPATHWESTEAST_CHIEF_START_BATTLE
	dw_const UndergroundPathWestEastChiefAfterBattleScript,      SCRIPT_UNDERGROUNDPATHWESTEAST_CHIEF_AFTER_BATTLE
	dw_const UndergroundPathWestEastChiefExitScript,             SCRIPT_UNDERGROUNDPATHWESTEAST_CHIEF_EXIT
	
	
UndergroundPathWestEastDefaultScript:
	CheckEvent EVENT_BEAT_UNDERGROUND2_CHIEF
	call z, UndergroundPathWestEastScript_Challenger
	ret

UndergroundPathWestEastScript_Challenger:
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
	
	ld a, TOGGLE_UNDERGROUNDPATHWESTEAST_CHIEF
	call UndergroundPathWestEastScript_ShowObject
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	
	ld a, TEXT_UNDERGROUNDPATHWESTEAST_CHIEF
	ldh [hTextID], a
	call DisplayTextID
	
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_RIGHT
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates
	
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	
	ld a, SCRIPT_UNDERGROUNDPATHWESTEAST_APPROACH
	jp UndergroundPathWestEastSetCurScript

.ChiefEncounterCoordinates:
	dbmapcoord  20,  1
	dbmapcoord  20,  2
	dbmapcoord  20,  3
	dbmapcoord  20,  4
	dbmapcoord  20,  5
	db -1 ; end
	
UndergroundPathWestEastApproachScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz

	call Delay3

	ld a, UNDERGROUNDPATHWESTEAST_CHIEF
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF

	ld de, .ChiefMoveDown2

	ld a, [wCoordIndex]
	ld [wSavedCoordIndex], a

	cp 1
	jr z, .movement1

	cp 2
	jr z, .movement2

	cp 3
	jr z, .movement3
	
	cp 4
	jr z, .movement4

	jr .startmove

.movement1
	ld de, .ChiefMoveUp2
	jr .startmove

.movement2
	ld de, .ChiefMoveUp1
	jr .startmove

.movement3
	ld de, .ChiefMovementLeft
	jr .startmove
	
.movement4
	ld de, .ChiefMoveDown1

.startmove
	ld a, UNDERGROUNDPATHWESTEAST_CHIEF
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_UNDERGROUNDPATHWESTEAST_CHIEF_START_BATTLE
	jp UndergroundPathWestEastSetCurScript
	
.ChiefMoveUp2:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_LEFT
	db -1
	
.ChiefMoveUp1:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_LEFT
	db -1

.ChiefMovementLeft:
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
	db -1
	
.ChiefMoveDown2:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db -1

UndergroundPathWestEastChiefStartBattleScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, TEXT_UNDERGROUNDPATHWESTEAST_CHIEF_WAITED_HERE
	ldh [hTextID], a
	call DisplayTextID
	call Delay3
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, UndergroundPathWestEastChiefDefeatedText
	ld de, UndergroundPathWestEastChiefVictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_CHIEF
	ld [wCurOpponent], a
	;ld a, [wRivalStarter]
	;add 6 ;PINK adjusted pointer from adding Rival data
	ld a, 2 ; trainer number
	ld [wTrainerNo], a
	SetEvent EVENT_UNDERGROUNDPATHWESTEAST_CHIEF_RESET
	ld a, SCRIPT_UNDERGROUNDPATHWESTEAST_CHIEF_AFTER_BATTLE
	call UndergroundPathWestEastSetCurScript
	ret

UndergroundPathWestEastChiefAfterBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, UndergroundPathWestEastResetScripts
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_UNDERGROUND2_CHIEF
	ResetEventReuseHL EVENT_UNDERGROUNDPATHWESTEAST_CHIEF_RESET
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld a, UNDERGROUNDPATHWESTEAST_CHIEF
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_LEFT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_UNDERGROUNDPATHWESTEAST_CHIEF_GOOD_LUCK_TO_YOU
	ldh [hTextID], a
	call DisplayTextID
	ld c, BANK(Music_YellowUnusedSong)
	ld a, MUSIC_YELLOW_UNUSED_SONG
	call PlayMusic

	ld a, [wSavedCoordIndex]
	cp 1
	jr z, .movement1
	cp 2
	jr z, .movement1
	
	ld de, .ChiefExitUpLeftMovement
	jr .startmove
	
.movement1
	ld de, .ChiefExitDownLeftMovement

.startmove
	ld a, UNDERGROUNDPATHWESTEAST_CHIEF
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, SCRIPT_UNDERGROUNDPATHWESTEAST_CHIEF_EXIT
	jp UndergroundPathWestEastSetCurScript
	

.ChiefExitDownLeftMovement:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db -1 ; end

.ChiefExitUpLeftMovement:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db -1 ; end

UndergroundPathWestEastChiefExitScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, TOGGLE_UNDERGROUNDPATHWESTEAST_CHIEF
	ld [wToggleableObjectIndex], a
	predef HideObject
	
	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_1
	ld [wToggleableObjectIndex], a
	predef HideObject

	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_3
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
	
	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_2
	ld [wToggleableObjectIndex], a
	predef ShowObject
	
	call PlayDefaultMusic
	xor a
	ld [wJoyIgnore], a
	jp UndergroundPathWestEastSetCurScript
	
UndergroundPathWestEastScript_ShowObject:
	ld [wToggleableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call Delay3
	ret

UndergroundPathWestEastScript_HideObject:
	ld [wToggleableObjectIndex], a
	predef HideObject
	ret

	
UndergroundPathWestEast_TextPointers:
	def_text_pointers
	dw_const UndergroundPathWestEastChiefText,              TEXT_UNDERGROUNDPATHWESTEAST_CHIEF
	dw_const UndergroundPathWestEastChiefWaitedHereText,    TEXT_UNDERGROUNDPATHWESTEAST_CHIEF_WAITED_HERE
	dw_const UndergroundPathWestEastChiefDefeatedText,      TEXT_UNDERGROUNDPATHWESTEAST_CHIEF_DEFEATED
	dw_const UndergroundPathWestEastChiefGoodLuckToYouText, TEXT_UNDERGROUNDPATHWESTEAST_CHIEF_GOOD_LUCK_TO_YOU

	
UndergroundPathWestEastChiefText:
	text_far _UndergroundPathWestEastChiefText
	text_asm
	ld c, 10
	call DelayFrames
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld a, $0
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld c, 20
	call DelayFrames
	jp TextScriptEnd

UndergroundPathWestEastChiefWaitedHereText:
	text_far _UndergroundPathWestEastChiefWaitedHereText
	text_end

UndergroundPathWestEastChiefDefeatedText:
	text_far _UndergroundPathWestEastChiefDefeatedText
	text_end

UndergroundPathWestEastChiefVictoryText:
	text_far _UndergroundPathWestEastChiefVictoryText
	text_end

UndergroundPathWestEastChiefGoodLuckToYouText:
	text_far _UndergroundPathWestEastChiefGoodLuckToYouText
	text_end
