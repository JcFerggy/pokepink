YellowIntro_AnimatedObjectFramesData:
	dw Unkn_fa100 ; ???
	dw Unkn_fa103 ; Run 1
	dw Unkn_fa10a ; Run 2
	dw Unkn_fa111 ; Run 3?
	dw Unkn_fa118 ; ???
	dw Unkn_fa11b ; Surfing
	dw Unkn_fa11e ; Balloons
	dw Unkn_fa121 ; Pika Lightning
	dw Unkn_fa124 ; Speed Lines
	dw Unkn_fa127 ; Blinking
	dw Unkn_fa138 ; Lightning Sparks
	dw Unkn_Fingy

Unkn_fa100:
	frame $00, 32
	endanim

Unkn_fa103:
	frame $01, 8
	frame $02, 8
	frame $03, 8
	frame $02, 8
	dorestart

Unkn_fa10a:
	frame $04, 12
	frame $05, 8
	frame $06, 8
	frame $05, 8
	dorestart

Unkn_fa111:
	frame $07, 12
	frame $08, 8
	frame $09, 8
	frame $08, 8
	dorestart

Unkn_fa118:
	frame $0a, 32
	endanim

Unkn_fa11b:
	frame $0b, 32
	endanim

Unkn_fa11e:
	frame $0c, 32
	endanim

Unkn_fa121:
	frame $0d, 32
	endanim

Unkn_fa124:
	frame $0e, 32
	endanim

Unkn_fa127:
	frame $0f, 31
	frame $11, 2
	frame $0f, 2
	frame $11, 2
	frame $0f, 31
	frame $11, 2
	frame $0f, 23
	frame $10, 32
	endanim

Unkn_fa138:
	;frame $12, 4
	;frame $13, 4
	frame $12, 2
	frame $13, 2
	frame $14, 2
	frame $15, 2
	frame $16, 2
	endanim
	
Unkn_Fingy:
	frame $17, 32
	frame $17, 32
	frame $18, 10
	frame $17, 10
	frame $18, 10
	frame $17, 10
	frame $18, 10
	frame $17, 10
	frame $18, 10
	frame $17, 10
	endanim
