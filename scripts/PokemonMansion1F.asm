PokemonMansion1F_Script:
	call Mansion1CheckReplaceSwitchDoorBlocks
	call EnableAutoTextBoxDrawing
	ld hl, Mansion1TrainerHeaders
	ld de, PokemonMansion1F_ScriptPointers
	ld a, [wPokemonMansion1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonMansion1FCurScript], a
	ret

Mansion1CheckReplaceSwitchDoorBlocks:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	CheckEvent EVENT_MANSION_SWITCH_ON
	jr nz, .switchTurnedOn
	lb bc, 6, 12
	call Mansion1LoadEmptyFloorTileBlock
	lb bc, 3, 8
	call Mansion1LoadHorizontalGateBlock
	lb bc, 8, 10
	call Mansion1LoadHorizontalGateBlock
	lb bc, 13, 13
	jp Mansion1LoadHorizontalGateBlock
.switchTurnedOn
	lb bc, 6, 12
	call Mansion1LoadHorizontalGateBlock
	lb bc, 3, 8
	call Mansion1LoadEmptyFloorTileBlock
	lb bc, 8, 10
	call Mansion1LoadEmptyFloorTileBlock
	lb bc, 13, 13
	jp Mansion1LoadEmptyFloorTileBlock

Mansion1LoadHorizontalGateBlock:
	ld a, $2d
	ld [wNewTileBlockID], a
	jr Mansion1ReplaceBlock

Mansion1LoadEmptyFloorTileBlock:
	ld a, $e
	ld [wNewTileBlockID], a
Mansion1ReplaceBlock:
	predef ReplaceTileBlock
	ret

Mansion1Script_Switches::
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	xor a
	ldh [hJoyHeld], a
	ld a, TEXT_POKEMONMANSION1F_SWITCH
	ldh [hTextID], a
	jp DisplayTextID
	
PokemonMansion1FResetScripts:
	CheckAndResetEvent EVENT_57E
	call nz, PokemonMansion1FScript_HideChief
	xor a
	ld [wJoyIgnore], a
PokemonMansion1FSetCurScript:
	ld [wPokemonMansion1FCurScript], a
	ld [wCurMapScript], a
	ret
	
PokemonMansion1FScript_HideChief:
	ld a, TOGGLE_POKEMON_MANSION_CHIEF
	call PokemonMansion1FScript_HideObject
	ret

PokemonMansion1F_ScriptPointers:
	def_script_pointers
	dw_const PokemonMansion1FDefaultScript,              SCRIPT_POKEMONMANSION1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_POKEMONMANSION1F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_POKEMONMANSION1F_END_BATTLE
	dw_const PokemonMansion1FApproachScript,              SCRIPT_POKEMONMANSION1F_APPROACH
	dw_const PokemonMansion1FChiefStartBattleScript,      SCRIPT_POKEMONMANSION1F_CHIEF_START_BATTLE
	dw_const PokemonMansion1FChiefAfterBattleScript,      SCRIPT_POKEMONMANSION1F_CHIEF_AFTER_BATTLE
	dw_const PokemonMansion1FChiefExitScript,             SCRIPT_POKEMONMANSION1F_CHIEF_EXIT

PokemonMansion1FDefaultScript:
	CheckEvent EVENT_BEAT_MANSION_CHIEF
	jp nz, CheckFightingMapTrainers
	ld hl, .ChiefEncounterCoordinates
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	call z, PokemonMansion1FScript_Challenger
	ret
	
.ChiefEncounterCoordinates:
	dbmapcoord  4,  11
	dbmapcoord  5,  11
	dbmapcoord  6,  11
	dbmapcoord  7,  11
	db -1 ; end

PokemonMansion1FScript_Challenger:
	;ld hl, .ChiefEncounterCoordinates
	;call ArePlayerCoordsInArray
	;ret nc
	
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
	
	ld a, TOGGLE_POKEMON_MANSION_CHIEF
	call PokemonMansion1FScript_ShowObject
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	
	ld a, TEXT_POKEMONMANSION1F_CHIEF
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
	
	ld a, SCRIPT_POKEMONMANSION1F_APPROACH
	jp PokemonMansion1FSetCurScript



	
PokemonMansion1FApproachScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz

	call Delay3

	ld a, POKEMONMANSION1F_CHIEF
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
	ld a, POKEMONMANSION1F_CHIEF
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_POKEMONMANSION1F_CHIEF_START_BATTLE
	jp PokemonMansion1FSetCurScript
	
.ChiefMovementDown:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db -1 ; end
	
.ChiefMoveRight1:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db -1

.ChiefMoveRight2:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db -1
	
.ChiefMoveRight3:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db -1

PokemonMansion1FChiefStartBattleScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, TEXT_POKEMONMANSION1F_CHIEF_WAITED_HERE
	ldh [hTextID], a
	call DisplayTextID
	call Delay3
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, PokemonMansion1FChiefDefeatedText
	ld de, PokemonMansion1FChiefVictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_CHIEF
	ld [wCurOpponent], a
	;ld a, [wRivalStarter]
	;add 6 ;PINK adjusted pointer from adding Rival data
	ld a, 5 ; trainer number
	ld [wTrainerNo], a
	SetEvent EVENT_57E
	ld a, SCRIPT_POKEMONMANSION1F_CHIEF_AFTER_BATTLE
	call PokemonMansion1FSetCurScript
	ret

PokemonMansion1FChiefAfterBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, PokemonMansion1FResetScripts
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_MANSION_CHIEF
	ResetEventReuseHL EVENT_57E
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, POKEMONMANSION1F_CHIEF
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_POKEMONMANSION1F_CHIEF_GOOD_LUCK_TO_YOU
	ldh [hTextID], a
	call DisplayTextID
	ld c, BANK(Music_YellowUnusedSong)
	ld a, MUSIC_YELLOW_UNUSED_SONG
	call PlayMusic


	ld de, .ChiefExitUpMovement
	ld a, POKEMONMANSION1F_CHIEF
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, SCRIPT_POKEMONMANSION1F_CHIEF_EXIT
	jp PokemonMansion1FSetCurScript

.ChiefExitUpMovement:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1 ; end

PokemonMansion1FChiefExitScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, TOGGLE_POKEMON_MANSION_CHIEF
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

	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_6
	ld [wToggleableObjectIndex], a
	predef HideObject

	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_7
	ld [wToggleableObjectIndex], a
	predef HideObject
	
	ld a, TOGGLE_CERULEANTRASHEDHOUSE_CHIEF_5
	ld [wToggleableObjectIndex], a
	predef ShowObject
	
	call PlayDefaultMusic
	xor a
	ld [wJoyIgnore], a
	jp PokemonMansion1FSetCurScript
	
PokemonMansion1FScript_ShowObject:
	ld [wToggleableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call Delay3
	ret

PokemonMansion1FScript_HideObject:
	ld [wToggleableObjectIndex], a
	predef HideObject
	ret

PokemonMansion1F_TextPointers:
	def_text_pointers
	dw_const PokemonMansion1FScientistText, TEXT_POKEMONMANSION1F_SCIENTIST
	dw_const PokemonMansion1FChiefText,              TEXT_POKEMONMANSION1F_CHIEF
	dw_const PickUpItemText,                TEXT_POKEMONMANSION1F_ESCAPE_ROPE
	dw_const PickUpItemText,                TEXT_POKEMONMANSION1F_CARBOS
	dw_const PokemonMansion1FSwitchText,    TEXT_POKEMONMANSION1F_SWITCH
	dw_const PokemonMansion1FChiefWaitedHereText,    TEXT_POKEMONMANSION1F_CHIEF_WAITED_HERE
	dw_const PokemonMansion1FChiefDefeatedText,      TEXT_POKEMONMANSION1F_CHIEF_DEFEATED
	dw_const PokemonMansion1FChiefGoodLuckToYouText, TEXT_POKEMONMANSION1F_CHIEF_GOOD_LUCK_TO_YOU

Mansion1TrainerHeaders:
	def_trainers
Mansion1TrainerHeader0:
	trainer EVENT_BEAT_MANSION_1_TRAINER_0, 3, PokemonMansion1FScientistBattleText, PokemonMansion1FScientistEndBattleText, PokemonMansion1FScientistAfterBattleText
	db -1 ; end

PokemonMansion1FScientistText:
	text_asm
	ld hl, Mansion1TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PokemonMansion1FScientistBattleText:
	text_far _PokemonMansion1FScientistBattleText
	text_end
	
PokemonMansion1FChiefText:
	text_far _PokemonMansion1FChiefText
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

PokemonMansion1FScientistEndBattleText:
	text_far _PokemonMansion1FScientistEndBattleText
	text_end

PokemonMansion1FScientistAfterBattleText:
	text_far _PokemonMansion1FScientistAfterBattleText
	text_end

PokemonMansion1FSwitchText:
	text_asm
	ld hl, .Text
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .not_pressed
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	ld hl, .PressedText
	call PrintText
	ld a, SFX_GO_INSIDE
	call PlaySound
	CheckAndSetEvent EVENT_MANSION_SWITCH_ON
	jr z, .done
	ResetEventReuseHL EVENT_MANSION_SWITCH_ON
	jr .done
.not_pressed
	ld hl, .NotPressedText
	call PrintText
.done
	jp TextScriptEnd

.Text:
	text_far _PokemonMansion1FSwitchText
	text_end

.PressedText:
	text_far _PokemonMansion1FSwitchPressedText
	text_end

.NotPressedText:
	text_far _PokemonMansion1FSwitchNotPressedText
	text_end

PokemonMansion1FChiefWaitedHereText:
	text_far _PokemonMansion1FChiefWaitedHereText
	text_end

PokemonMansion1FChiefDefeatedText:
	text_far _PokemonMansion1FChiefDefeatedText
	text_end

PokemonMansion1FChiefVictoryText:
	text_far _PokemonMansion1FChiefVictoryText
	text_end

PokemonMansion1FChiefGoodLuckToYouText:
	text_far _PokemonMansion1FChiefGoodLuckToYouText
	text_end
