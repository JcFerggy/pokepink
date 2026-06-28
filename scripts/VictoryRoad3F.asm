VictoryRoad3F_Script:
	call VictoryRoad3FCheckBoulderEventScript
	call EnableAutoTextBoxDrawing
	ld hl, VictoryRoad3TrainerHeaders
	ld de, VictoryRoad3F_ScriptPointers
	ld a, [wVictoryRoad3FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wVictoryRoad3FCurScript], a
	ret
	
VictoryRoad3FResetScripts:
	CheckAndResetEvent EVENT_VICTORYROAD3F_CHIEF_RESET
	call nz, VictoryRoad3FScript_HideChief
	xor a
	ld [wJoyIgnore], a
VictoryRoad3FSetCurScript:
	ld [wVictoryRoad3FCurScript], a
	ld [wCurMapScript], a
	ret
	
VictoryRoad3FScript_HideChief:
	ld a, TOGGLE_VICTORY_ROAD_3F_CHIEF
	call VictoryRoad3FScript_HideObject
	ret

VictoryRoad3FCheckBoulderEventScript:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	CheckEventHL EVENT_VICTORY_ROAD_3_BOULDER_ON_SWITCH1
	ret z
	ld a, $1d
	ld [wNewTileBlockID], a
	lb bc, 5, 3
	predef_jump ReplaceTileBlock

VictoryRoad3F_ScriptPointers:
	def_script_pointers
	dw_const VictoryRoad3FDefaultScript,            SCRIPT_VICTORYROAD3F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_VICTORYROAD3F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_VICTORYROAD3F_END_BATTLE
	dw_const VictoryRoad3FScript_Challenger,           SCRIPT_VICTORYROAD3F_CHALLENGER ;Most recent addition
	dw_const VictoryRoad3FApproachScript,              SCRIPT_VICTORYROAD3F_APPROACH
	dw_const VictoryRoad3FChiefStartBattleScript,      SCRIPT_VICTORYROAD3F_CHIEF_START_BATTLE
	dw_const VictoryRoad3FChiefAfterBattleScript,      SCRIPT_VICTORYROAD3F_CHIEF_AFTER_BATTLE
	dw_const VictoryRoad3FChiefExitScript,             SCRIPT_VICTORYROAD3F_CHIEF_EXIT

VictoryRoad3FDefaultScript:
	ld hl, wMiscFlags
	bit BIT_PUSHED_BOULDER, [hl]
	res BIT_PUSHED_BOULDER, [hl]
	jp z, .check_switch_hole
	ld hl, .SwitchOrHoleCoords
	call CheckBoulderCoords
	jp nc, .check_switch_hole
	ld a, [wCoordIndex]
	cp $1
	jr nz, .handle_hole
	ldh a, [hSpriteIndex]
	cp PIKACHU_SPRITE_INDEX
	jp z, .check_switch_hole
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	SetEvent EVENT_VICTORY_ROAD_3_BOULDER_ON_SWITCH1
	ret
.handle_hole
	CheckAndSetEvent EVENT_VICTORY_ROAD_3_BOULDER_ON_SWITCH2
	jr nz, .check_switch_hole
	ld a, TOGGLE_VICTORY_ROAD_3F_BOULDER
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_VICTORY_ROAD_2F_BOULDER
	ld [wToggleableObjectIndex], a
	predef_jump ShowObject

.SwitchOrHoleCoords:
	dbmapcoord  3,  5 ; switch
	dbmapcoord 23, 15 ; hole
	db -1 ; end

.check_switch_hole
	ld a, VICTORY_ROAD_2F
	ld [wDungeonWarpDestinationMap], a
	ld hl, .SwitchOrHoleCoords
	call IsPlayerOnDungeonWarp
	ld a, [wCoordIndex]
	cp $1
	jr nz, .hole
	ld hl, wStatusFlags3
	res BIT_ON_DUNGEON_WARP, [hl]
	ld hl, wStatusFlags6
	res BIT_DUNGEON_WARP, [hl]
	ret
.hole
	ld a, [wStatusFlags3]
	bit BIT_ON_DUNGEON_WARP, a
	;jp z, CheckFightingMapTrainers
	;ret
	;ret nz
	
	;CheckEvent EVENT_BEAT_VICTORY_ROAD_CHIEF
	;call z, VictoryRoad3FScript_Challenger
	;jp CheckFightingMapTrainers
	;ret
	
	
	CheckEvent EVENT_BEAT_VICTORY_ROAD_CHIEF
	jp nz, CheckFightingMapTrainers
	ld hl, .ChiefEncounterCoordinates
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	call z, VictoryRoad3FScript_Challenger
	ret
	
.ChiefEncounterCoordinates:
	dbmapcoord  25,  9
	dbmapcoord  27,  9
	dbmapcoord  28,  9
	db -1 ; end

VictoryRoad3FScript_Challenger:
;	ld hl, .ChiefEncounterCoordinates
;	call ArePlayerCoordsInArray
;	ret nc
	
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
	
	ld a, TOGGLE_VICTORY_ROAD_3F_CHIEF
	call VictoryRoad3FScript_ShowObject
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	
	ld a, TEXT_VICTORYROAD3F_CHIEF
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
	
	ld a, SCRIPT_VICTORYROAD3F_APPROACH
	jp VictoryRoad3FSetCurScript

VictoryRoad3FApproachScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz

	call Delay3

	ld a, VICTORYROAD3F_CHIEF
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF

	ld de, .ChiefMovementLeft
	
	ld a, [wCoordIndex]
	ld [wSavedCoordIndex], a

	cp 2
	jr z, .movement1

	cp 3
	jr z, .movement2

	jr .startmove

.movement1
	ld de, .ChiefMoveUp
	jr .startmove

.movement2
	ld de, .ChiefMoveRight

.startmove
	ld a, VICTORYROAD3F_CHIEF
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_VICTORYROAD3F_CHIEF_START_BATTLE
	jp VictoryRoad3FSetCurScript
	
.ChiefMovementLeft:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db -1 ; end
	
.ChiefMoveUp:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db -1
	
.ChiefMoveRight:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db -1

VictoryRoad3FChiefStartBattleScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, TEXT_VICTORYROAD3F_CHIEF_WAITED_HERE
	ldh [hTextID], a
	call DisplayTextID
	call Delay3
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, VictoryRoad3FChiefDefeatedText
	ld de, VictoryRoad3FChiefVictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_CHIEF
	ld [wCurOpponent], a
	;ld a, [wRivalStarter]
	;add 6 ;PINK adjusted pointer from adding Rival data
	ld a, 6 ; trainer number
	ld [wTrainerNo], a
	SetEvent EVENT_VICTORYROAD3F_CHIEF_RESET
	ld a, SCRIPT_VICTORYROAD3F_CHIEF_AFTER_BATTLE
	call VictoryRoad3FSetCurScript
	ret

VictoryRoad3FChiefAfterBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, VictoryRoad3FResetScripts
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_VICTORY_ROAD_CHIEF
	ResetEventReuseHL EVENT_VICTORYROAD3F_CHIEF_RESET
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, VICTORYROAD3F_CHIEF
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_VICTORYROAD3F_CHIEF_GOOD_LUCK_TO_YOU
	ldh [hTextID], a
	call DisplayTextID
	ld c, BANK(Music_YellowUnusedSong)
	ld a, MUSIC_YELLOW_UNUSED_SONG
	call PlayMusic

	ld de, .ChiefMoveRight
	ld a, [wSavedCoordIndex]
	cp 2
	jr z, .movement1

	cp 3
	jr z, .movement2

	jr .startmove

.movement1
	ld de, .ChiefMoveLeft
	jr .startmove

.movement2
	ld de, .ChiefMoveUpLeft

.startmove
	ld a, VICTORYROAD3F_CHIEF
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, SCRIPT_VICTORYROAD3F_CHIEF_EXIT
	jp VictoryRoad3FSetCurScript
	
.ChiefMoveRight:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_LEFT
	db -1 ; end

.ChiefMoveLeft:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_RIGHT
	db -1 ; end
	
.ChiefMoveUpLeft:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_LEFT
	db -1

VictoryRoad3FChiefExitScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, TOGGLE_VICTORY_ROAD_3F_CHIEF
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

	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_4
	ld [wToggleableObjectIndex], a
	predef HideObject

	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_5
	ld [wToggleableObjectIndex], a
	predef HideObject

	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_7
	ld [wToggleableObjectIndex], a
	predef HideObject
	
	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_6
	ld [wToggleableObjectIndex], a
	predef ShowObject
	
	call PlayDefaultMusic
	xor a
	ld [wJoyIgnore], a
	jp VictoryRoad3FSetCurScript
	
VictoryRoad3FScript_ShowObject:
	ld [wToggleableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call Delay3
	ret

VictoryRoad3FScript_HideObject:
	ld [wToggleableObjectIndex], a
	predef HideObject
	ret

VictoryRoad3F_TextPointers:
	def_text_pointers
	dw_const VictoryRoad3FCooltrainerM1Text, TEXT_VICTORYROAD3F_COOLTRAINER_M1
	dw_const VictoryRoad3FCooltrainerF1Text, TEXT_VICTORYROAD3F_COOLTRAINER_F1
	dw_const VictoryRoad3FCooltrainerM2Text, TEXT_VICTORYROAD3F_COOLTRAINER_M2
	dw_const VictoryRoad3FCooltrainerF2Text, TEXT_VICTORYROAD3F_COOLTRAINER_F2
	dw_const VictoryRoad3FChiefText,         TEXT_VICTORYROAD3F_CHIEF
	dw_const PickUpItemText,                 TEXT_VICTORYROAD3F_MAX_REVIVE
	dw_const PickUpItemText,                 TEXT_VICTORYROAD3F_TM_EXPLOSION
	dw_const BoulderText,                    TEXT_VICTORYROAD3F_BOULDER1
	dw_const BoulderText,                    TEXT_VICTORYROAD3F_BOULDER2
	dw_const BoulderText,                    TEXT_VICTORYROAD3F_BOULDER3
	dw_const BoulderText,                    TEXT_VICTORYROAD3F_BOULDER4
	dw_const VictoryRoad3FChiefWaitedHereText,    TEXT_VICTORYROAD3F_CHIEF_WAITED_HERE
	dw_const VictoryRoad3FChiefDefeatedText,      TEXT_VICTORYROAD3F_CHIEF_DEFEATED
	dw_const VictoryRoad3FChiefGoodLuckToYouText, TEXT_VICTORYROAD3F_CHIEF_GOOD_LUCK_TO_YOU

VictoryRoad3TrainerHeaders:
	def_trainers
VictoryRoad3TrainerHeader0:
	trainer EVENT_BEAT_VICTORY_ROAD_3_TRAINER_0, 1, VictoryRoad3FCooltrainerM1BattleText, VictoryRoad3FCooltrainerM1EndBattleText, VictoryRoad3FCooltrainerM1AfterBattleText
VictoryRoad3TrainerHeader1:
	trainer EVENT_BEAT_VICTORY_ROAD_3_TRAINER_1, 4, VictoryRoad3FCooltrainerF1BattleText, VictoryRoad3FCooltrainerF1EndBattleText, VictoryRoad3FCooltrainerF1AfterBattleText
VictoryRoad3TrainerHeader2:
	trainer EVENT_BEAT_VICTORY_ROAD_3_TRAINER_2, 4, VictoryRoad3FCooltrainerM2BattleText, VictoryRoad3FCooltrainerM2EndBattleText, VictoryRoad3FCooltrainerM2AfterBattleText
VictoryRoad3TrainerHeader3:
	trainer EVENT_BEAT_VICTORY_ROAD_3_TRAINER_3, 4, VictoryRoad3FCooltrainerF2BattleText, VictoryRoad3FCooltrainerF2EndBattleText, VictoryRoad3FCooltrainerF2AfterBattleText
	db -1 ; end
	
VictoryRoad3FChiefText:
	text_far _VictoryRoad3FChiefText
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

VictoryRoad3FCooltrainerM1Text:
	text_asm
	ld hl, VictoryRoad3TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad3FCooltrainerF1Text:
	text_asm
	ld hl, VictoryRoad3TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad3FCooltrainerM2Text:
	text_asm
	ld hl, VictoryRoad3TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad3FCooltrainerF2Text:
	text_asm
	ld hl, VictoryRoad3TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd
	
VictoryRoad3FChiefWaitedHereText:
	text_far _VictoryRoad3FChiefWaitedHereText
	text_end

VictoryRoad3FChiefDefeatedText:
	text_far _VictoryRoad3FChiefDefeatedText
	text_end

VictoryRoad3FChiefVictoryText:
	text_far _VictoryRoad3FChiefVictoryText
	text_end

VictoryRoad3FChiefGoodLuckToYouText:
	text_far _VictoryRoad3FChiefGoodLuckToYouText
	text_end

VictoryRoad3FCooltrainerM1BattleText:
	text_far _VictoryRoad3FCooltrainerM1BattleText
	text_end

VictoryRoad3FCooltrainerM1EndBattleText:
	text_far _VictoryRoad3FCooltrainerM1EndBattleText
	text_end

VictoryRoad3FCooltrainerM1AfterBattleText:
	text_far _VictoryRoad3FCooltrainerM1AfterBattleText
	text_end

VictoryRoad3FCooltrainerF1BattleText:
	text_far _VictoryRoad3FCooltrainerF1BattleText
	text_end

VictoryRoad3FCooltrainerF1EndBattleText:
	text_far _VictoryRoad3FCooltrainerF1EndBattleText
	text_end

VictoryRoad3FCooltrainerF1AfterBattleText:
	text_far _VictoryRoad3FCooltrainerF1AfterBattleText
	text_end

VictoryRoad3FCooltrainerM2BattleText:
	text_far _VictoryRoad3FCooltrainerM2BattleText
	text_end

VictoryRoad3FCooltrainerM2EndBattleText:
	text_far _VictoryRoad3FCooltrainerM2EndBattleText
	text_end

VictoryRoad3FCooltrainerM2AfterBattleText:
	text_far _VictoryRoad3FCooltrainerM2AfterBattleText
	text_end

VictoryRoad3FCooltrainerF2BattleText:
	text_far _VictoryRoad3FCooltrainerF2BattleText
	text_end

VictoryRoad3FCooltrainerF2EndBattleText:
	text_far _VictoryRoad3FCooltrainerF2EndBattleText
	text_end

VictoryRoad3FCooltrainerF2AfterBattleText:
	text_far _VictoryRoad3FCooltrainerF2AfterBattleText
	text_end
