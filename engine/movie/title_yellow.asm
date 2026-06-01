LoadYellowTitleScreenGFX:
	ld hl, PokemonLogoGraphics
	ld de, vChars2
	ld bc, PokemonLogoGraphicsEnd - PokemonLogoGraphics
	ld a, BANK(PokemonLogoGraphics)
	call FarCopyData
	ld hl, PokemonLogoCornerGraphics
	ld de, vChars1 tile $7d
	ld bc, PokemonLogoCornerGraphicsEnd - PokemonLogoCornerGraphics
	ld a, BANK(PokemonLogoCornerGraphics)
	call FarCopyData
	ld hl, TitlePikachuBGGraphics
	ld de, vChars1
	ld bc, TitlePikachuBGGraphicsEnd - TitlePikachuBGGraphics
	ld a, BANK(TitlePikachuBGGraphics)
	call FarCopyData
	ld hl, TitlePikachuOBGraphics
	ld de, vChars1 tile $70
	ld bc, TitlePikachuOBGraphicsEnd - TitlePikachuOBGraphics
	ld a, BANK(TitlePikachuOBGraphics)
	call FarCopyData
	ret

TitleScreen_PlacePokemonLogo:
	hlcoord 2, 1
	ld de, TitleScreenPokemonLogoTilemap
	lb bc, 7, 16
	call Bank3D_CopyBox
	ret

TitleScreen_PlacePikaSpeechBubble:
	hlcoord 6, 4
	ld de, TitleScreenPikaBubbleTilemap
	lb bc, 4, 7
	call Bank3D_CopyBox
	hlcoord 9, 8
	ld [hl], $64
	inc hl
	ld [hl], $65
	ret

TitleScreen_PlacePikachu:
	hlcoord 3, 9
	ld de, TitleScreenPikachuTilemap
	lb bc, 8, 14
	call Bank3D_CopyBox
	hlcoord 13, 16
	ld [hl], $8E
	hlcoord 14, 16
	ld [hl], $8E
	hlcoord 15, 16
	ld [hl], $BE
	;hlcoord 16, 16
	;ld [hl], $00
	ld hl, TitleScreenPikachuEyesOAMData
	ld de, wShadowOAM
	ld bc, $20
	call CopyData
	ret

TitleScreenPikachuEyesOAMData:
	db $78, $40, $f0, $00
	db $78, $48, $f1, $00
	db $80, $40, $f2, $00
	db $80, $48, $f3, $00
	db $78, $60, $f1, $20
	db $78, $68, $f0, $20
	db $80, $60, $f3, $20
	db $80, $68, $f2, $20

Bank3D_CopyBox:
; copy cxb (xy) screen area from de to hl
.row
	push bc
	push hl
.col
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ret

TitleScreenPokemonLogoTilemap: ; 16x7
	INCBIN "gfx/title/pokemon_logo.tilemap"

Pointer_f4669: ; unreferenced
	db $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $5f

TitleScreenPikaBubbleTilemap: ; 7x4
	INCBIN "gfx/title/pika_bubble.tilemap"

TitleScreenPikachuTilemap: ; 12x9
	INCBIN "gfx/title/pikachu.tilemap"

PokemonLogoGraphics: INCBIN "gfx/title/pokemon_logo.2bpp"
PokemonLogoGraphicsEnd:
PokemonLogoCornerGraphics: INCBIN "gfx/title/pokemon_logo_corner.2bpp"
PokemonLogoCornerGraphicsEnd:
TitlePikachuBGGraphics: INCBIN "gfx/title/pikachu_bg.2bpp"
TitlePikachuBGGraphicsEnd:
TitlePikachuOBGraphics: INCBIN "gfx/title/pikachu_ob.2bpp"
TitlePikachuOBGraphicsEnd:
