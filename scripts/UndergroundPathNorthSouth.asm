UndergroundPathNorthSouth_Script:
	call EnableAutoTextBoxDrawing
	
	ld de, UndergroundPathNorthSouth_ScriptPointers
	ld a, [wUndergroundPathNorthSouthCurScript]
	call ExecuteCurMapScriptInTable
	ld [wUndergroundPathNorthSouthCurScript], a
	ret
	
UndergroundPathNorthSouthResetScripts:
	CheckAndResetEvent EVENT_57E
	call nz, UndergroundPathNorthSouthScript_HideChief
	xor a
	ld [wJoyIgnore], a
	
UndergroundPathNorthSouthSetCurScript:
	ld [wUndergroundPathNorthSouthCurScript], a
	ld [wCurMapScript], a
	ret
	
UndergroundPathNorthSouthScript_HideChief:
	ld a, TOGGLE_UNDERGROUND_CHIEF
	call UndergroundPathNorthSouthScript_HideObject
	ret
	
UndergroundPathNorthSouth_ScriptPointers:
	def_script_pointers
	dw_const UndergroundPathNorthSouthDefaultScript,               SCRIPT_UNDERGROUNDPATHNORTHSOUTH_DEFAULT
	dw_const UndergroundPathNorthSouthScript_Challenger,           SCRIPT_UNDERGROUNDPATHNORTHSOUTH_CHALLENGER ;Most recent addition
	dw_const UndergroundPathNorthSouthApproachScript,              SCRIPT_UNDERGROUNDPATHNORTHSOUTH_APPROACH
	dw_const UndergroundPathNorthSouthChiefStartBattleScript,      SCRIPT_UNDERGROUNDPATHNORTHSOUTH_CHIEF_START_BATTLE
	dw_const UndergroundPathNorthSouthChiefAfterBattleScript,      SCRIPT_UNDERGROUNDPATHNORTHSOUTH_CHIEF_AFTER_BATTLE
	dw_const UndergroundPathNorthSouthChiefExitScript,             SCRIPT_UNDERGROUNDPATHNORTHSOUTH_CHIEF_EXIT
	
	
UndergroundPathNorthSouthDefaultScript:
	CheckEvent EVENT_BEAT_UNDERGROUND_CHIRF
	call z, UndergroundPathNorthSouthScript_Challenger
	ret

UndergroundPathNorthSouthScript_Challenger:
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
	
	ld a, TOGGLE_UNDERGROUND_CHIEF
	call UndergroundPathNorthSouthScript_ShowObject
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	
	ld a, TEXT_UNDERGROUNDPATHNORTHSOUTH_CHIEF
	ldh [hTextID], a
	call DisplayTextID
	
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_UP
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates
	
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	
	ld a, SCRIPT_UNDERGROUNDPATHNORTHSOUTH_APPROACH
	jp UndergroundPathNorthSouthSetCurScript

.ChiefEncounterCoordinates:
	dbmapcoord  5,  30
	dbmapcoord  4,  30
	dbmapcoord  3,  30
	dbmapcoord  2,  30
	db -1 ; end

	
UndergroundPathNorthSouthApproachScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz

	call Delay3

	ld a, UNDERGROUNDPATHNORTHSOUTH_CHIEF
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF

	ld de, .ChiefMovementDown

	ld a, [wCoordIndex]
	ld [wSavedCoordIndex], a

	cp 2
	jr z, .movement1

	cp 3
	jr z, .movement2

	cp 4
	jr z, .movement3

	jr .startmove

.movement1
	ld de, .ChiefMoveRight1
	jr .startmove

.movement2
	ld de, .ChiefMoveRight2
	jr .startmove

.movement3
	ld de, .ChiefMoveRight3

.startmove
	ld a, UNDERGROUNDPATHNORTHSOUTH_CHIEF
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_UNDERGROUNDPATHNORTHSOUTH_CHIEF_START_BATTLE
	jp UndergroundPathNorthSouthSetCurScript
	
.ChiefMovementDown:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db -1 ; end
	
.ChiefMoveRight1:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1

.ChiefMoveRight2:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_DOWN
	db -1
	
.ChiefMoveRight3:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_DOWN
	db -1

UndergroundPathNorthSouthChiefStartBattleScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, TEXT_UNDERGROUNDPATHNORTHSOUTH_CHIEF_WAITED_HERE
	ldh [hTextID], a
	call DisplayTextID
	call Delay3
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, UndergroundPathNorthSouthChiefDefeatedText
	ld de, UndergroundPathNorthSouthChiefVictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_CHIEF
	ld [wCurOpponent], a
	;ld a, [wRivalStarter]
	;add 6 ;PINK adjusted pointer from adding Rival data
	ld a, 1 ; trainer number
	ld [wTrainerNo], a
	ld a, SCRIPT_UNDERGROUNDPATHNORTHSOUTH_CHIEF_AFTER_BATTLE
	call UndergroundPathNorthSouthSetCurScript
	ret

UndergroundPathNorthSouthChiefAfterBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, UndergroundPathNorthSouthDefaultScript
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_UNDERGROUND_CHIRF
	ResetEventReuseHL EVENT_57E
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, UNDERGROUNDPATHNORTHSOUTH_CHIEF
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_UNDERGROUNDPATHNORTHSOUTH_CHIEF_GOOD_LUCK_TO_YOU
	ldh [hTextID], a
	call DisplayTextID
	ld c, BANK(Music_YellowUnusedSong)
	ld a, MUSIC_YELLOW_UNUSED_SONG
	call PlayMusic


	ld de, .ChiefExitUpMovement
	ld a, UNDERGROUNDPATHNORTHSOUTH_CHIEF
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, SCRIPT_UNDERGROUNDPATHNORTHSOUTH_CHIEF_EXIT
	jp UndergroundPathNorthSouthSetCurScript

.ChiefExitUpMovement:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db -1 ; end

UndergroundPathNorthSouthChiefExitScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, TOGGLE_UNDERGROUND_CHIEF
	ld [wToggleableObjectIndex], a
	predef HideObject
	
	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_2
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
	
	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_1
	ld [wToggleableObjectIndex], a
	predef ShowObject
	
	call PlayDefaultMusic
	xor a
	ld [wJoyIgnore], a
	jp UndergroundPathNorthSouthSetCurScript
	
UndergroundPathNorthSouthScript_ShowObject:
	ld [wToggleableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call Delay3
	ret

UndergroundPathNorthSouthScript_HideObject:
	ld [wToggleableObjectIndex], a
	predef HideObject
	ret

	
UndergroundPathNorthSouth_TextPointers:
	def_text_pointers
	dw_const UndergroundPathNorthSouthChiefText,              TEXT_UNDERGROUNDPATHNORTHSOUTH_CHIEF
	dw_const UndergroundPathNorthSouthChiefWaitedHereText,    TEXT_UNDERGROUNDPATHNORTHSOUTH_CHIEF_WAITED_HERE
	dw_const UndergroundPathNorthSouthChiefDefeatedText,      TEXT_UNDERGROUNDPATHNORTHSOUTH_CHIEF_DEFEATED
	dw_const UndergroundPathNorthSouthChiefGoodLuckToYouText, TEXT_UNDERGROUNDPATHNORTHSOUTH_CHIEF_GOOD_LUCK_TO_YOU
	text_end ; unused
	
UndergroundPathNorthSouthChiefText:
	text_far _UndergroundPathNorthSouthChiefText
	text_asm
	ld c, 10
	call DelayFrames
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, $0
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld c, 20
	call DelayFrames
	jp TextScriptEnd

UndergroundPathNorthSouthChiefWaitedHereText:
	text_far _UndergroundPathNorthSouthChiefWaitedHereText
	text_end

UndergroundPathNorthSouthChiefDefeatedText:
	text_far _UndergroundPathNorthSouthChiefDefeatedText
	text_end

UndergroundPathNorthSouthChiefVictoryText:
	text_far _UndergroundPathNorthSouthChiefVictoryText
	text_end

UndergroundPathNorthSouthChiefGoodLuckToYouText:
	text_far _UndergroundPathNorthSouthChiefGoodLuckToYouText
	text_end
