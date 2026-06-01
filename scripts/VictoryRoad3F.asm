VictoryRoad3F_Script:
	call VictoryRoad3FCheckBoulderEventScript
	call EnableAutoTextBoxDrawing
	ld hl, VictoryRoad3TrainerHeaders
	ld de, VictoryRoad3F_ScriptPointers
	ld a, [wVictoryRoad3FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wVictoryRoad3FCurScript], a
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
	
VictoryRoad3FSetDefaultScript:
	xor a
	ld [wJoyIgnore], a

VictoryRoad3FSetCurScript:
	ld [wVictoryRoad3FCurScript], a
	ld [wCurMapScript], a
	ret

VictoryRoad3F_ScriptPointers:
	def_script_pointers
	dw_const VictoryRoad3FDefaultScript,              SCRIPT_VICTORYROAD3F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle,   SCRIPT_VICTORYROAD3F_START_BATTLE
	dw_const EndTrainerBattle,                        SCRIPT_VICTORYROAD3F_END_BATTLE

	dw_const VictoryRoad3FChiefStartBattleScript,     SCRIPT_VICTORYROAD3F_CHIEF1_START_BATTLE
	dw_const VictoryRoad3FChiefAfterBattleScript,     SCRIPT_VICTORYROAD3F_CHIEF1_AFTER_BATTLE
	dw_const VictoryRoad3FChiefExitScript,            SCRIPT_VICTORYROAD3F_CHIEF1_EXIT

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
	jp nz, .done
	
	CheckEvent EVENT_BEAT_VICTORY_ROAD_CHIEF
	jp nz, CheckFightingMapTrainers

	ld hl, .ChiefEncounterCoords
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers

	xor a
	ldh [hJoyHeld], a

	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a

	;ld a, PLAYER_DIR_LEFT
	;ld [wPlayerMovingDirection], a
	
	call StopAllMusic
	ld c, BANK(Music_YellowUnusedSong)
	ld a, MUSIC_YELLOW_UNUSED_SONG
	call PlayMusic
	
	ld a, VICTORYROAD3F_CHIEF1
	ld [wEmotionBubbleSpriteIndex], a
	xor a ; EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble

	ld a, TEXT_VICTORYROAD3F_CHIEF1
	ldh [hTextID], a
	call DisplayTextID

	ld a, VICTORYROAD3F_CHIEF1
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF

	ld de, .ChiefMoveRight0

	ld a, [wCoordIndex]
	ld [wSavedCoordIndex], a

	cp 1
	jr z, .movement1

	cp 2
	jr z, .movement2

	ld de, .ChiefMoveRight0
	jr .start_move

.movement1
	ld de, .ChiefMoveRight2
	jr .start_move

.movement2
	ld de, .ChiefMoveRight1

.start_move
	ld a, VICTORYROAD3F_CHIEF1
	ldh [hSpriteIndex], a
	call MoveSprite

	ld a, SCRIPT_VICTORYROAD3F_CHIEF1_START_BATTLE
	jp VictoryRoad3FSetCurScript
	
.ChiefEncounterCoords:
	dbmapcoord 28, 13
	dbmapcoord 27, 13
	dbmapcoord 26, 13
	db -1
	
.ChiefMoveRight0:
	db -1

.ChiefMoveRight1:
	db NPC_MOVEMENT_RIGHT
	db -1

.ChiefMoveRight2:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db -1
	
.done
	ret

VictoryRoad3FChiefStartBattleScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz

	xor a
	ld [wJoyIgnore], a

	ld a, TEXT_VICTORYROAD3F_CHIEF1_WAITED_HERE
	ldh [hTextID], a
	call DisplayTextID
	call Delay3

	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]

	ld hl, VictoryRoad3FCheif1DefeatedText
	ld de, VictoryRoad3FCheif1VictoryText
	call SaveEndBattleTextPointers

	ld a, OPP_CHIEF
	ld [wCurOpponent], a

	ld a, 6 ; trainer number
	ld [wTrainerNo], a

	ld a, SCRIPT_VICTORYROAD3F_CHIEF1_AFTER_BATTLE
	call VictoryRoad3FSetCurScript
	ret
	
VictoryRoad3FChiefAfterBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, VictoryRoad3FSetDefaultScript

	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a

	SetEvent EVENT_BEAT_VICTORY_ROAD_CHIEF
	
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	ld a, VICTORYROAD3F_CHIEF1
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_RIGHT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_VICTORYROAD3F_CHIEF1_GOOD_LUCK_TO_YOU
	ldh [hTextID], a
	call DisplayTextID
	ld c, BANK(Music_YellowUnusedSong)
	ld a, MUSIC_YELLOW_UNUSED_SONG
	call PlayMusic

	ld de, .ExitMove0
	ld a, [wSavedCoordIndex]

	cp 1
	jr z, .exit1

	cp 2
	jr z, .exit2

	jr .start_exit

.exit1
	ld de, .ExitMove1
	jr .start_exit

.exit2
	ld de, .ExitMove2

.start_exit
	ld a, VICTORYROAD3F_CHIEF1
	ldh [hSpriteIndex], a
	call MoveSprite

	ld a, SCRIPT_VICTORYROAD3F_CHIEF1_EXIT
	jp VictoryRoad3FSetCurScript
	
.ExitMove0:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db -1

.ExitMove1:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1

.ExitMove2:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db -1
	
VictoryRoad3FChiefExitScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	
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

	ld a, TOGGLE_VICTORY_ROAD_3F_ITEM_1 ;Borrowed for Blue fight
	ld [wToggleableObjectIndex], a
	predef HideObject
	call PlayDefaultMusic
	xor a
	ld [wJoyIgnore], a

	jp VictoryRoad3FSetCurScript

VictoryRoad3F_TextPointers:
	def_text_pointers
	dw_const VictoryRoad3FCooltrainerM1Text, TEXT_VICTORYROAD3F_COOLTRAINER_M1
	dw_const VictoryRoad3FCooltrainerF1Text, TEXT_VICTORYROAD3F_COOLTRAINER_F1
	dw_const VictoryRoad3FCooltrainerM2Text, TEXT_VICTORYROAD3F_COOLTRAINER_M2
	dw_const VictoryRoad3FCooltrainerF2Text, TEXT_VICTORYROAD3F_COOLTRAINER_F2
	dw_const VictoryRoad3FCheif1Text,        TEXT_VICTORYROAD3F_CHIEF1
	dw_const PickUpItemText,                 TEXT_VICTORYROAD3F_MAX_REVIVE
	dw_const PickUpItemText,                 TEXT_VICTORYROAD3F_TM_EXPLOSION
	dw_const BoulderText,                    TEXT_VICTORYROAD3F_BOULDER1
	dw_const BoulderText,                    TEXT_VICTORYROAD3F_BOULDER2
	dw_const BoulderText,                    TEXT_VICTORYROAD3F_BOULDER3
	dw_const BoulderText,                    TEXT_VICTORYROAD3F_BOULDER4
	dw_const VictoryRoad3FCheif1WaitedHereText,    TEXT_VICTORYROAD3F_CHIEF1_WAITED_HERE
	dw_const VictoryRoad3FCheif1DefeatedText,      TEXT_VICTORYROAD3F_CHIEF1_DEFEATED
	dw_const VictoryRoad3FCheif1GoodLuckToYouText, TEXT_VICTORYROAD3F_CHIEF1_GOOD_LUCK_TO_YOU

VictoryRoad3TrainerHeaders:
	def_trainers
VictoryRoad3TrainerHeader0:
	trainer EVENT_BEAT_VICTORY_ROAD_3_TRAINER_0, 1, VictoryRoad3FCooltrainerM1BattleText, VictoryRoad3FCooltrainerM1EndBattleText, VictoryRoad3FCooltrainerM1AfterBattleText
VictoryRoad3TrainerHeader1:
	trainer EVENT_BEAT_VICTORY_ROAD_3_TRAINER_1, 4, VictoryRoad3FCooltrainerF1BattleText, VictoryRoad3FCooltrainerF1EndBattleText, VictoryRoad3FCooltrainerF1AfterBattleText
VictoryRoad3TrainerHeader2:
	trainer EVENT_BEAT_VICTORY_ROAD_3_TRAINER_2, 4, VictoryRoad3FCooltrainerM2BattleText, VictoryRoad3FCooltrainerM2EndBattleText, VictoryRoad3FCooltrainerM2AfterBattleText
VictoryRoad3TrainerHeader3:
	trainer EVENT_BEAT_VICTORY_ROAD_3_TRAINER_3, 3, VictoryRoad3FCooltrainerF2BattleText, VictoryRoad3FCooltrainerF2EndBattleText, VictoryRoad3FCooltrainerF2AfterBattleText
	db -1 ; end

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

	
VictoryRoad3FCheif1Text:
	text_far _VictoryRoad3FCheif1Text
	text_asm
	ld c, 10
	call DelayFrames
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	;ld a, $0
	;ld [wEmotionBubbleSpriteIndex], a
	;ld a, EXCLAMATION_BUBBLE
	;ld [wWhichEmotionBubble], a
	;predef EmotionBubble
	ld c, 20
	call DelayFrames
	jp TextScriptEnd

VictoryRoad3FCheif1WaitedHereText:
	text_far _VictoryRoad3FCheif1WaitedHereText
	text_end

VictoryRoad3FCheif1DefeatedText:
	text_far _VictoryRoad3FCheif1DefeatedText
	text_end

VictoryRoad3FCheif1VictoryText:
	text_far _VictoryRoad3FCheif1VictoryText
	text_end

VictoryRoad3FCheif1GoodLuckToYouText:
	text_far _VictoryRoad3FCheif1GoodLuckToYouText
	text_end