'====================================
'  DELTA CODE PRESENTS
' *****Larry The Dinosaur*****
' *****Episode 1********
'   2000 Created by Joe king
'
'>>>CONTROLS>>>
'              CTRL = SHOOT
'              ALT  = JUMP
'
'====================================
DECLARE SUB Notice ()
DECLARE SUB CheckBoss ()
DECLARE SUB BossExplode ()
DECLARE SUB Scene5 ()
DECLARE SUB BossTalk (Times%)
DECLARE SUB Continue ()
DECLARE SUB DrawBackground4 ()
DECLARE SUB Scene3 ()
DECLARE SUB DrawBackGround3 ()
DECLARE SUB Scene4 ()
DECLARE SUB DrawBackGround2 ()
DECLARE SUB Intro ()
DECLARE SUB Scene2 ()
DECLARE SUB MattTalk (Times%)
DECLARE SUB Scene1 ()
DECLARE SUB LaryTalk (Times%, WhichWay%)
DECLARE SUB GaryTalk (Times%, WhichWay%)
DECLARE SUB Center (Row%, Text$, Color1%, Clear1%)
DECLARE SUB Title ()
DECLARE SUB DrawAmmo ()
DECLARE SUB DrawBackGround ()
DECLARE SUB MoveBadGuy ()
DECLARE SUB Dead ()
DECLARE SUB LaryExplode ()
DECLARE SUB Delay (Times%)
DECLARE SUB LoadPalette ()


DIM SHARED RockGuy%(10), RockLife%(10)
DIM SHARED Blob%(10)
DIM SHARED Spike%(10)
DIM SHARED Plant%(10)
DIM SHARED Jelly%(10), JellyLife%(10)
COMMON SHARED Room%, RockN%, BlobN%, SpikeN%, PlantN%, JellyN%
COMMON SHARED RockAn%, BlobAn%, PlantAn%, JellyAn%
COMMON SHARED LaryX%, LaryY%, Ammo%, Jump%, jp%, BSpeed&
COMMON SHARED eps%, dt%, zz%, GaryX%, rs%, rt%, rts%
COMMON SHARED sc1%, sc2%, sc3%, sc4%, sc5%, Level%
COMMON SHARED Lives%, Continues%, BossLife%, Ball%, ABossLife%
COMMON SHARED Speed&
RANDOMIZE TIMER

CALL Notice

'CHDIR "c:\qb45\platform\larry"
SCREEN 13

CLS

CALL LoadPalette

' *****Load the sprites*****
FileName$ = "LARYG.PUT"
FileNo = FREEFILE
OPEN FileName$ FOR BINARY AS #FileNo
Ints = (LOF(FileNo) - 7) \ 2
CLOSE #FileNo
REDIM SHARED sprites%(1 TO Ints)
DEF SEG = VARSEG(sprites%(1))
BLOAD FileName$, 0
eps% = 130
DEF SEG


' ***** Set the variables *****
' ***** Change the speed constant if it goes too slow or too fast*****

OPEN "LARYDATA.LRY" FOR INPUT AS #1
INPUT #1, Speed&, BSpeed&
CLOSE #1

5

BossLife% = 0
Level% = 1
Lives% = 5
Continues% = 3

10
IF rts% = 1 THEN rts% = 0: cat% = 0: GOTO 5
jp% = 0
Room% = 1: Position% = 1
LaryX% = 0: LaryY% = 125
IF Level% = 1 THEN Ammo% = 5
IF Level% = 2 THEN Ammo% = Ammo% + 10
IF Level% = 3 THEN Ammo% = Ammo% + 5
IF Level% = 4 THEN Ammo% = 99
IF cat% = 0 THEN CALL Title: cat% = 1
IF Level% = 1 THEN CALL DrawBackGround
IF Level% = 2 THEN CALL DrawBackGround2
IF Level% = 3 THEN CALL DrawBackGround3
IF Level% = 4 THEN CALL DrawBackground4: Ball% = -1

' *****Start the game*****
100
IF Position% = 1 THEN LINE (LaryX% - 5, LaryY%)-(LaryX% - 1, LaryY% + 15), 162, BF
IF Position% = 2 THEN LINE (LaryX% + 16, LaryY%)-(LaryX% + 20, LaryY% + 15), 162, BF
IF Jump% = 1 OR Jump% = 3 THEN LINE (LaryX% - 5, LaryY% + 16)-(LaryX% + 20, LaryY% + 17), 162, BF
IF Jump% = 2 OR Jump% = 4 THEN LINE (LaryX% - 5, LaryY% - 1)-(LaryX% + 20, LaryY% - 2), 162, BF

IF Shoot% = 0 THEN
IF Position% = 1 THEN PUT (LaryX%, LaryY%), sprites%((eps% * An%) + 1), PSET
IF Position% = 2 THEN PUT (LaryX%, LaryY%), sprites%((eps% * (5 + An%)) + 1), PSET
ELSE
IF Position% = 1 THEN PUT (LaryX%, LaryY%), sprites%((eps% * sh%) + 1), PSET
IF Position% = 2 THEN PUT (LaryX%, LaryY%), sprites%((eps% * (4 + sh%)) + 1), PSET
END IF
IF sc5% = 0 AND Level% = 4 THEN CALL Scene5: sc5% = 1
DO
a% = INP(96)
Count% = Count% + 1
IF Count% > Speed& / 500 THEN Count% = 0: An% = 0: EXIT DO
LOOP UNTIL a% <> 170
IF sc5% = 1 THEN GOSUB MoveBall
IF sc2% = 1 THEN LaryX% = LaryX% + 2: a% = 0

MoveBadGuyX% = MoveBadGuyX% + 1
IF MoveBadGuyX% > BSpeed& / 200 THEN MoveBadGuyX% = 0: CALL MoveBadGuy

IF a% = &H4D THEN LaryX% = LaryX% + 4: Position% = 1: An% = An% + 1: Count% = 0
IF a% = &H4B THEN LaryX% = LaryX% - 4: Position% = 2: An% = An% + 1: Count% = 0
IF Jump% = 0 AND a% = &H38 THEN Jump% = 1: ct% = 0
IF Ammo% > 0 AND Shoot% = 0 AND a% = &H1D THEN nt% = 0: Shoot% = 1: sh% = 10: An% = 0: Ammo% = Ammo% - 1: CALL DrawAmmo
IF a% = 1 THEN END

IF An% > 4 THEN An% = 1
IF Jump% = 4 THEN Jump% = 0

IF sc2% = 0 AND Jump% = 0 THEN IF An% = 1 OR An% = 3 THEN SOUND 40, .5
IF Level% = 1 AND LaryX% > 304 THEN Room% = Room% + 1: LaryX% = 0: CALL DrawBackGround
IF Level% = 1 AND Room% <> 1 AND LaryX% < 0 THEN Room% = Room% - 1: LaryX% = 304: CALL DrawBackGround
IF Level% = 2 AND LaryX% > 304 THEN Room% = Room% + 1: LaryX% = 0: CALL DrawBackGround2
IF Level% = 2 AND Room% <> 1 AND LaryX% < 0 THEN Room% = Room% - 1: LaryX% = 304: CALL DrawBackGround2
IF Level% = 3 AND LaryX% > 304 THEN Room% = Room% + 1: LaryX% = 0: CALL DrawBackGround3
IF Level% = 3 AND Room% <> 1 AND LaryX% < 0 THEN Room% = Room% - 1: LaryX% = 304: CALL DrawBackGround3
IF Level% = 4 AND LaryX% > 160 THEN LaryX% = 160
IF Room% = 1 AND LaryX% < 0 THEN LaryX% = 0
IF Level% = 1 AND sc1% = 0 AND Room% = 5 AND LaryX% > 220 THEN GaryX% = 250: CALL Scene1: sc1% = 1
IF Level% = 1 AND sc2% = 0 AND Room% = 6 AND LaryX% > 190 THEN CALL Scene2: Jump% = 1: ct% = 0
IF Level% = 2 AND Ambush1% = 0 AND Room% = 6 AND LaryX% > 160 THEN
RockGuy%(1) = 10: RockLife%(1) = 2
RockGuy%(2) = 50: RockLife%(2) = 2
RockGuy%(3) = 300: RockLife%(3) = 2
RockGuy%(4) = 250: RockLife%(4) = 2
RockN% = 4
Ambush1% = 1
END IF
IF Level% = 2 AND Room% = 7 AND LaryX% > 100 AND sc3% = 0 THEN CALL Scene3: dt% = 6: CALL Dead: rs% = 1
IF Level% = 3 AND Room% = 5 AND LaryX% > 170 AND sc4% = 0 THEN CALL Scene4: CALL Dead: rs% = 1
DO
LOOP UNTIL INKEY$ = ""
Delay 1

IF Jump% <> 0 THEN GOSUB Jump
IF Shoot% = 1 THEN GOSUB Shoot1
IF rs% = 1 THEN rs% = 0: GOTO 10
IF sc2% = 2 THEN sc2% = 0
GOSUB CheckSpike

IF rt% = 1 THEN
rt% = 0: Lives% = Lives% - 1
IF Lives% = 0 THEN CALL Continue
LaryX% = 0: LaryY% = 125: Jump% = 0: ct% = 0: jp% = 0
IF Ammo% < 5 THEN Ammo% = 5
Center 1, "LIVES =" + STR$(Lives%), 15, 1
SLEEP
Center 1, "  ", 0, 1
IF Level% = 1 THEN CALL DrawBackGround
IF Level% = 2 THEN CALL DrawBackGround2
IF Level% = 3 THEN CALL DrawBackGround3
END IF

GOTO 100

' ***** For when you jump *****

Jump:
An% = 2
SELECT CASE Jump%
CASE IS = 1
jp% = jp% - 1
LaryY% = LaryY% - 2
IF jp% < -10 THEN Jump% = 3
CASE IS = 2
jp% = jp% + 1
LaryY% = LaryY% + 2
IF sc2% <> 1 AND jp% > -1 THEN Jump% = 4: An% = 0
IF sc2% = 1 AND jp% > 25 THEN Jump% = 4: An% = 0: sc2% = 2: LINE (LaryX% - 5, LaryY% - 5)-(LaryX% + 20, LaryY% + 20), 162, BF: dt% = 6: CALL Dead: rs% = 1
CASE IS = 3
ct% = ct% + 1
IF ct% > 2 THEN Jump% = 2
END SELECT
IF sc2% = 0 THEN SOUND 40 - (jp% * 5), .5
RETURN


' ***** Check if lary lands on a spike *****

CheckSpike:
FOR zz% = 1 TO SpikeN%
PUT (Spike%(zz%), 125), sprites%((eps% * 51) + 1), PSET
IF POINT(LaryX% + 15, LaryY% + 15) = 29 OR POINT(LaryX% + 15, LaryY% + 15) = 28 OR POINT(LaryX% + 7, LaryY% + 15) = 29 OR POINT(LaryX% + 7, LaryY% + 15) = 28 OR POINT(LaryX%, LaryY% + 15) = 29 OR POINT(LaryX%, LaryY% + 15) = 28 THEN
LINE (LaryX% - 4, LaryY% - 5)-(LaryX% + 19, LaryY% + 15), 162, BF
IF Spike%(zz%) - 12 < LaryX% AND Spike%(zz%) + 12 > LaryX% THEN
PUT (Spike%(zz%), 125), sprites%((eps% * 52) + 1), PSET
SOUND 60, 5
Delay 1
SOUND 60, 5
Delay 1
SOUND 40, 10
dt% = 3
IF Lives% = 0 AND Continues% = 0 THEN CALL Dead
rt% = 1
END IF
END IF
NEXT zz%
RETURN


' ***** Shoot *****

Shoot1:
gt% = 0: st% = 0
bh% = bh% + 1
IF bh% > Speed& / (Speed&) THEN bh% = 0: sh% = sh% + 1
IF sh% > 13 THEN sh% = 0: Shoot% = 0
SOUND 40, .5
IF nt% = 0 AND sh% = 11 THEN
IF Position% = 1 THEN
FOR xx% = LaryX% TO LaryX% + 320
IF POINT(xx%, LaryY% + 8) = 24 THEN
FOR cc% = 1 TO RockN%
IF RockGuy%(cc%) < xx% + 5 AND RockGuy%(cc%) > xx% - 16 THEN
PUT (RockGuy%(cc%), 125), sprites%((eps% * 28) + 1), PSET: Delay 1
RockLife%(cc%) = RockLife%(cc%) - 1
IF RockLife%(cc%) < 1 THEN PUT (RockGuy%(cc%), 125), sprites%((eps% * 29) + 1), PSET: Delay 2: LINE (RockGuy%(cc%), 125)-(RockGuy%(cc%) + 16, 140), 162, BF
gt% = 1
END IF
NEXT cc%
END IF

IF POINT(xx%, LaryY% + 8) = 195 OR POINT(xx%, LaryY% + 8) = 196 THEN
FOR cc% = 1 TO JellyN%
IF Jelly%(cc%) < xx% + 5 AND Jelly%(cc%) > xx% - 16 THEN
PUT (Jelly%(cc%), 125), sprites%((eps% * 39) + 1), PSET: Delay 1
JellyLife%(cc%) = JellyLife%(cc%) - 1
IF JellyLife%(cc%) < 1 THEN PUT (Jelly%(cc%), 125), sprites%((eps% * 40) + 1), PSET: Delay 2: LINE (Jelly%(cc%), 125)-(Jelly%(cc%) + 16, 140), 162, BF
gt% = 1
END IF
NEXT cc%
END IF


IF POINT(xx%, LaryY% + 8) = 18 THEN
BallD% = 1
gt% = 1
END IF


IF gt% = 1 THEN EXIT FOR
NEXT xx%
END IF
IF Position% = 2 THEN
FOR xx% = LaryX% TO LaryX% - 320 STEP -1

IF POINT(xx%, LaryY% + 8) = 24 THEN
FOR cc% = 1 TO RockN%
IF RockGuy%(cc%) < xx% + 5 AND RockGuy%(cc%) > xx% - 16 THEN
PUT (RockGuy%(cc%), 125), sprites%((eps% * 26) + 1), PSET: Delay 1
RockLife%(cc%) = RockLife%(cc%) - 1
IF RockLife%(cc%) < 1 THEN PUT (RockGuy%(cc%), 125), sprites%((eps% * 27) + 1), PSET: Delay 2: LINE (RockGuy%(cc%), 125)-(RockGuy%(cc%) + 16, 140), 162, BF
st% = 1
END IF
NEXT cc%
END IF

IF POINT(xx%, LaryY% + 8) = 195 OR POINT(xx%, LaryY% + 8) = 196 THEN
FOR cc% = 1 TO JellyN%
IF Jelly%(cc%) < xx% + 5 AND Jelly%(cc%) > xx% - 16 THEN
PUT (Jelly%(cc%), 125), sprites%((eps% * 39) + 1), PSET: Delay 1
JellyLife%(cc%) = JellyLife%(cc%) - 1
IF JellyLife%(cc%) < 1 THEN PUT (Jelly%(cc%), 125), sprites%((eps% * 40) + 1), PSET: Delay 2: LINE (Jelly%(cc%), 125)-(Jelly%(cc%) + 16, 140), 162, BF
st% = 1
END IF
NEXT cc%
END IF


IF st% = 1 THEN EXIT FOR
NEXT xx%
END IF
nt% = 1
END IF
RETURN

' ***** Move the balls *****

MoveBall:
IF Ball% < 0 THEN
Ball% = 164: cl% = INT(RND * (2)) + 1
IF cl% = 1 THEN cl% = 2: GOTO 120
IF cl% <> 1 THEN cl% = 1: GOTO 120
120
BallD% = -1
END IF
LINE (Ball% + 16, 125)-(Ball% + 20, 140), 162, BF
LINE (Ball% - 4, 125)-(Ball%, 140), 162, BF
IF Ball% > 0 THEN PUT (Ball%, 125), sprites%((eps% * (73 + cl%)) + 1), PSET
Ball% = Ball% + (BallD% * 4)
IF BallD% = 1 AND Ball% > 160 THEN LINE (Ball%, 125)-(Ball% + 16, 140), 162, BF: Ball% = -1: BallD% = -1: BossLife% = BossLife% + 10: CALL CheckBoss
IF Ball% < 0 THEN LINE (Ball%, 125)-(Ball% + 20, 140), 162, BF
SOUND 40, .1
RETURN

SUB BossExplode

FOR sz% = 1 TO 50
CIRCLE (220, 100), sz%, 14
SOUND (40 + sz%), .2
NEXT sz%
FOR sz% = 1 TO 50
CIRCLE (250, 130), sz%, 14
SOUND (40 + sz%), .2
NEXT sz%
FOR sz% = 1 TO 50
CIRCLE (190, 130), sz%, 14
SOUND (40 + sz%), .2
NEXT sz%
FOR sz% = 1 TO 50
CIRCLE (290, 110), sz%, 14
SOUND (40 + sz%), .2
NEXT sz%
FOR sz% = 1 TO 50
CIRCLE (250, 100), sz%, 14
SOUND (40 + sz%), .2
NEXT sz%
FOR sz% = 1 TO 50
CIRCLE (280, 135), sz%, 14
SOUND (40 + sz%), .2
NEXT sz%
FOR sz% = 1 TO 50
CIRCLE (200, 140), sz%, 14
SOUND (40 + sz%), .2
NEXT sz%
FOR sz% = 1 TO 350
CIRCLE (250, 120), sz%, 14
SOUND (40 + sz%), .2
NEXT sz%
dt% = 6
CALL Dead
END SUB

SUB BossTalk (Times%)

FOR xx% = 1 TO Times%
IF INKEY$ <> "" THEN EXIT FOR
FOR zz% = 0 TO 1
PUT (100, 125), sprites%((eps% * (71 + zz%)) + 1), PSET
Delay 2
NEXT zz%
Delay 2
NEXT xx%
PUT (100, 125), sprites%((eps% * 70) + 1), PSET

END SUB

SUB Center (Row%, Text$, Color1%, Clear1%)

DO
LOOP UNTIL INKEY$ = ""

LOCATE Row%
PRINT "                                        "

IF Clear1% = 1 THEN
LOCATE Row% + 1
PRINT "                                        "
END IF

COLOR Color1%
LOCATE Row%, (40 - LEN(Text$)) / 2
PRINT Text$

END SUB

SUB CheckBoss

' ***** Paint the spot on the boss when he gets by a ball *****

IF BossLife% = 100 THEN PAINT (300, 130), 14, 20
IF BossLife% = 200 THEN PAINT (300, 130), 6, 20
IF BossLife% = 300 THEN PAINT (300, 130), 4, 20
IF BossLife% > 300 THEN CALL BossExplode
IF BossLife% < 100 AND BossLife% > 0 THEN PAINT (185 + BossLife%, 130), 14, 22
IF BossLife% < 200 AND BossLife% > 100 THEN PAINT (185 + (BossLife% - 100), 130), 6, 22
IF BossLife% < 300 AND BossLife% > 200 THEN PAINT (185 + (BossLife% - 200), 130), 4, 22
END SUB

SUB Continue

Center 1, "CONTINUES LEFT =" + STR$(Continues%), 15, 0
IF Continues% = 0 THEN END
Center 2, "CONTINUE (Y/N)", 15, 0

110
DO
a$ = INKEY$
LOOP UNTIL a$ <> ""
IF LEFT$(UCASE$(a$), 1) = "Y" THEN Continues% = Continues% - 1: Lives% = 5: Room% = 1: EXIT SUB
IF LEFT$(UCASE$(a$), 1) = "N" THEN CALL Dead
GOTO 110

END SUB

SUB Dead

' ***** Circle in when dead *****

SELECT CASE dt%
CASE IS = 1
FOR sz% = 350 TO 0 STEP -1
CIRCLE (RockGuy%(zz%) + 8, 132), sz%, 0
CIRCLE (RockGuy%(zz%) + 9, 132), sz%, 0
NEXT sz%
CASE IS = 2
FOR sz% = 350 TO 0 STEP -1
CIRCLE (Blob%(zz%) + 8, 132), sz%, 0
CIRCLE (Blob%(zz%) + 9, 132), sz%, 0
NEXT sz%
CASE IS = 3
FOR sz% = 350 TO 0 STEP -1
CIRCLE (Spike%(zz%) + 8, 132), sz%, 0
CIRCLE (Spike%(zz%) + 9, 132), sz%, 0
NEXT sz%
CASE IS = 4
FOR sz% = 350 TO 0 STEP -1
CIRCLE (Plant%(zz%) + 8, 132), sz%, 0
CIRCLE (Plant%(zz%) + 9, 132), sz%, 0
NEXT sz%
CASE IS = 5
FOR sz% = 350 TO 0 STEP -1
CIRCLE (Jelly%(zz%) + 8, 132), sz%, 0
CIRCLE (Jelly%(zz%) + 9, 132), sz%, 0
NEXT sz%
CASE IS = 6
FOR sz% = 350 TO 0 STEP -1
CIRCLE (160, 100), sz%, 0
CIRCLE (161, 100), sz%, 0
NEXT sz%
Center 8, "LEVEL" + STR$(Level%) + " COMPLETE!", 15, 1
Level% = Level% + 1
SLEEP
Center 1, "  ", 0, 1
IF Level% = 5 THEN rts% = 1: rs% = 1
sc5% = 0
EXIT SUB
END SELECT
END

END SUB

SUB Delay (Times%)

FOR nn% = 1 TO Times%
FOR n& = 0 TO Speed&
NEXT n&
NEXT nn%

END SUB

SUB DrawAmmo

' ***** Draw the ammo count *****

IF Level% <> 3 THEN LINE (2, 180)-(100, 190), 6, BF
IF Level% = 3 OR Level% = 4 THEN LINE (2, 180)-(100, 190), 162, BF

DRAW "b M2,190 c15 u5 e2 r1 f2 d2 l4 r4 d3 br3 u7 f2 e2 d7 br3 u7 f2 e2 d7 br5 h2 u3 e2 r2 f2 d3 g2 l2 br7 bu2 r5 bu2 l5 br8 bd4"

Ammo1$ = STR$(Ammo%)

SELECT CASE MID$(Ammo1$, 2, 1)
CASE IS = "1"
DRAW "u7"
CASE IS = "2"
DRAW "r5 l5 u4 r5 u3 l5"
CASE IS = "3"
DRAW "r5 u4 l5 r5 u3 l5"
CASE IS = "4"
DRAW "br5 u7 d4 l5 u4"
CASE IS = "5"
DRAW "r5 u4 l5 u3 r5"
CASE IS = "6"
DRAW "r5 u4 l5 d4 u7 r5"
CASE IS = "7"
DRAW "br5 u7 l5"
CASE IS = "8"
DRAW "r5 u4 l5 d4 u7 r5 d3"
CASE IS = "9"
DRAW "br5 u7 l5 d4 r5"
CASE IS = "0"
DRAW "u7 r5 d7 l5"
END SELECT

DRAW "bm49,190"

SELECT CASE MID$(Ammo1$, 3, 1)
CASE IS = "1"
DRAW "u7"
CASE IS = "2"
DRAW "r5 l5 u4 r5 u3 l5"
CASE IS = "3"
DRAW "r5 u4 l5 r5 u3 l5"
CASE IS = "4"
DRAW "br5 u7 d4 l5 u4"
CASE IS = "5"
DRAW "r5 u4 l5 u3 r5"
CASE IS = "6"
DRAW "r5 u4 l5 d4 u7 r5"
CASE IS = "7"
DRAW "br5 u7 l5"
CASE IS = "8"
DRAW "r5 u4 l5 d4 u7 r5 d3"
CASE IS = "9"
DRAW "br5 u7 l5 d4 r5"
CASE IS = "0"
DRAW "u7 r5 d7 l5"

END SELECT

END SUB

SUB DrawBackGround

' ***** Draw background *****

CLS
DRAW "c162 bl160 bu10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10"
DRAW "bl320 bd50 r320"
DRAW "c164 bd10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10"
DRAW "bu9 r320"
PAINT (150, 105), 162, 162
PAINT (1, 1), 72, 162
PAINT (150, 150), 164, 164
PAINT (150, 190), 6, 164

FOR zz% = 1 TO 9
RockGuy%(zz%) = 0
Blob%(zz%) = 0
Plant%(zz%) = 0
Spike%(zz%) = 0
Jelly%(zz%) = 0
NEXT zz%

RockN% = 0
BlobN% = 0
JellyN% = 0
SpikeN% = 0
PlantN% = 0

SELECT CASE Room%

CASE IS = 1

LINE (0, 70)-(60, 10), 100
LINE (60, 10)-(20, 89), 100
DRAW "h10 g10"
PAINT (20, 55), 100, 100
PSET (58, 13), 100
LINE (61, 11)-(140, 89), 102
DRAW "h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g8"
LINE (22, 87)-(60, 11), 102
PAINT (50, 50), 102, 102
PSET (25, 83), 102

LINE (111, 60)-(220, 5), 100
LINE (220, 5)-(160, 89), 100
DRAW "h10 g10 h29"
PAINT (150, 50), 100, 100
PSET (219, 6), 100
LINE (221, 5)-(235, 5), 102
LINE (235, 5)-(319, 40), 102
LINE (319, 40)-(319, 88), 102
DRAW "h9 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g7"
LINE (165, 83)-(220, 5), 102
PAINT (300, 50), 102, 102
PSET (168, 80), 102
PSET (169, 79), 102

Spike%(1) = 250
SpikeN% = 1


CASE IS = 2

LINE (0, 30)-(90, 79), 102
DRAW "g10 h10 g10 h10 g10 h10 g10 h10 g10 u60"
PAINT (10, 50), 102, 102
LINE (91, 79)-(103, 86), 102
DRAW "g3 h10"
PAINT (95, 83), 102, 102
PSET (93, 81), 102
PSET (94, 82), 102

LINE (100, 84)-(170, 5), 100
LINE (170, 5)-(185, 2), 100
LINE (185, 2)-(151, 80), 100
DRAW "h1 g10 h10 g10 h10 g6 l2 h1 l1"
PAINT (150, 50), 100, 100
LINE (186, 2)-(260, 1), 102
LINE (260, 1)-(310, 79), 102
DRAW "g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h8"
LINE (152, 80)-(186, 2), 102
PAINT (190, 50), 102, 102

LINE (293, 51)-(319, 20), 100
LINE (293, 51)-(311, 80), 100
DRAW "f9"
PAINT (310, 50), 100, 100

'RockGuy%(1) = 200
'RockLife%(1) = 2
'RockN% = 1

CASE IS = 3

LINE (0, 20)-(8, 10), 100
LINE (9, 10)-(2, 87), 100
DRAW "g2"
PAINT (5, 50), 100, 100

LINE (10, 10)-(90, 50), 102
LINE (90, 50)-(130, 79), 102
DRAW "g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g7"
LINE (3, 85)-(10, 10), 102
PAINT (50, 50), 102, 102

LINE (100, 57)-(150, 0), 100
LINE (170, 0)-(155, 84), 100
DRAW "h5 g10 h10"
LINE (131, 79)-(101, 57), 100
PAINT (110, 50), 100, 100
LINE (270, 0)-(320, 89), 102
DRAW "h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h4"
LINE (155, 84)-(170, 0), 102
PAINT (250, 50), 102, 102
PSET (318, 86), 102

Blob%(1) = 250
Spike%(1) = 280
Spike%(2) = 296
SpikeN% = 2
BlobN% = 1

CASE IS = 4

LINE (19, 88)-(70, 10), 100
LINE (70, 10)-(50, 79), 100
DRAW "g10 h10 g10 h1"
PAINT (50, 50), 100, 100
PSET (20, 88), 100
PSET (21, 87), 100
CIRCLE (140, 25), 10, 15
PAINT (145, 30), 14, 15
LINE (71, 10)-(170, 79), 102
DRAW "g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h9"
LINE (50, 79)-(71, 10), 102
PAINT (100, 50), 102, 102

LINE (160, 71)-(250, 1), 103
LINE (250, 1)-(230, 79), 103
DRAW "g10 h10 g10 h10 g10 h10"
LINE (170, 79)-(160, 71), 103
PAINT (200, 50), 103, 103
LINE (251, 1)-(319, 75), 100
DRAW "d13 h9 g10 h10 g10 h10 g10 h10 g10 h10"
LINE (230, 79)-(251, 1), 100
PAINT (250, 50), 100, 100

Plant%(1) = 250
'RockGuy%(1) = 150
'RockLife%(1) = 2
'RockN% = 1
PlantN% = 1

CASE IS = 5


LINE (180, 141)-(300, 146), 24, BF
LINE (180, 147)-(300, 200), 72, BF
LINE (185, 150)-(185, 170), 73
LINE (190, 160)-(190, 190), 74
LINE (200, 155)-(200, 180), 73
LINE (210, 185)-(210, 200), 74
LINE (220, 165)-(220, 195), 73
LINE (230, 150)-(230, 175), 74
LINE (240, 160)-(240, 180), 73
LINE (250, 147)-(250, 155), 74
LINE (260, 180)-(260, 200), 73
LINE (270, 165)-(270, 190), 74
LINE (280, 170)-(280, 195), 73
LINE (290, 155)-(290, 170), 74

LINE (0, 70)-(9, 80), 100
DRAW "g10"
PAINT (5, 76), 100, 100

LINE (10, 79)-(200, 10), 102
LINE (200, 10)-(150, 79), 102
DRAW "g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10"
PAINT (100, 50), 102, 102
LINE (201, 10)-(319, 80), 100
DRAW "d8 h9 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10"
LINE (150, 79)-(201, 10), 100
PAINT (200, 50), 100, 100
LINE (300, 68)-(319, 50), 102
LINE (300, 68)-(319, 79), 102
PAINT (310, 70), 102, 102

IF sc1% = 0 THEN PUT (250, 125), sprites%((eps% * 64) + 1), PSET

CASE IS = 6

LINE (200, 141)-(319, 199), 162, BF


LINE (0, 60)-(70, 0), 102
LINE (70, 0)-(50, 79), 102
DRAW "g10 h10 g10 h10 g10"
PAINT (50, 60), 102, 102
LINE (71, 0)-(170, 79), 100
DRAW "g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10"
LINE (50, 79)-(71, 0), 100
PAINT (100, 50), 100, 100
LINE (148, 61)-(319, 10), 102
LINE (148, 61)-(171, 79), 102
DRAW "d1 f9 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10"
PAINT (300, 50), 102, 102

END SELECT

CALL DrawAmmo

END SUB

SUB DrawBackGround2

' ***** Draw background *****

CLS
DRAW "bm0,140 c162 r319"
DRAW "bm319,140 c164 bd10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10"
DRAW "bu9 r320"
PAINT (150, 105), 162, 162
PAINT (150, 150), 164, 164
PAINT (150, 190), 6, 164

FOR zz% = 1 TO 9
RockGuy%(zz%) = 0
Blob%(zz%) = 0
Plant%(zz%) = 0
Spike%(zz%) = 0
Jelly%(zz%) = 0
NEXT zz%

RockN% = 0
BlobN% = 0
JellyN% = 0
SpikeN% = 0
PlantN% = 0

SELECT CASE Room%

CASE IS = 1

Plant%(1) = 100
Plant%(2) = 150
Plant%(3) = 200
Spike%(1) = 250
Spike%(2) = 266
Spike%(3) = 282
Spike%(4) = 50
PlantN% = 3
SpikeN% = 4

CASE IS = 2

RockGuy%(1) = 80
RockGuy%(2) = 100
RockGuy%(3) = 250
RockLife%(1) = 3
RockLife%(2) = 3
RockLife%(3) = 3
RockN% = 3

CASE IS = 3

Spike%(1) = 50
Spike%(2) = 250
Spike%(3) = 300
RockGuy%(1) = 150
RockLife%(1) = 3
SpikeN% = 3
RockN% = 1

CASE IS = 4

Spike%(1) = 50
Spike%(2) = 66
Spike%(3) = 82
Spike%(4) = 130
Spike%(5) = 146
Spike%(6) = 178
Spike%(7) = 210
Spike%(8) = 242
Plant%(1) = 290
PlantN% = 1
SpikeN% = 8

CASE IS = 5

Plant%(1) = 150
Plant%(2) = 250
Blob%(1) = 200
PlantN% = 2
BlobN% = 1

CASE IS = 7

LINE (101, 141)-(319, 146), 7, BF

LINE (101, 147)-(319, 199), 162, BF

END SELECT

CALL DrawAmmo

END SUB

SUB DrawBackGround3

' ***** Draw background *****

CLS
PAINT (160, 100), 162, 162
LINE (0, 141)-(319, 146), 7, BF

FOR zz% = 1 TO 9
RockGuy%(zz%) = 0
Blob%(zz%) = 0
Plant%(zz%) = 0
Spike%(zz%) = 0
Jelly%(zz%) = 0
NEXT zz%

RockN% = 0
BlobN% = 0
JellyN% = 0
SpikeN% = 0
PlantN% = 0

SELECT CASE Room%

CASE IS = 1

Jelly%(1) = 250
JellyLife%(1) = 5
JellyN% = 1

CASE IS = 2

Blob%(1) = 50
Blob%(2) = 170
Blob%(3) = 280
BlobN% = 3

CASE IS = 3

Jelly%(1) = 100
JellyLife%(1) = 5
RockGuy%(1) = 300
RockLife%(1) = 3
JellyN% = 1
RockN% = 1

CASE IS = 4

Spike%(1) = 50
Spike%(2) = 90
Spike%(3) = 120
Spike%(4) = 150
Spike%(5) = 190
Spike%(6) = 220
Spike%(7) = 260
Spike%(8) = 300
SpikeN% = 8

CASE IS = 5

PUT (210, 125), sprites%((eps% * 54) + 1), PSET

END SELECT

CALL DrawAmmo

END SUB

SUB DrawBackground4

' ***** Draw background *****

CLS
DRAW "bm0,140 c162 r319"
DRAW "bm319,140 c164 bd10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10"
DRAW "bu9 r320"
PAINT (150, 105), 162, 162
PAINT (150, 150), 164, 164
PAINT (150, 190), 6, 164

LINE (0, 141)-(150, 146), 7, BF
LINE (0, 147)-(150, 199), 162, BF

FOR zz% = 1 TO 9
RockGuy%(zz%) = 0
Blob%(zz%) = 0
Plant%(zz%) = 0
Spike%(zz%) = 0
Jelly%(zz%) = 0
NEXT zz%

RockN% = 0
BlobN% = 0
JellyN% = 0
SpikeN% = 0
PlantN% = 0


LINE (220, 90)-(310, 140), 20, B
PAINT (250, 100), 22, 20
LINE (190, 120)-(280, 140), 24, BF
LINE (185, 115)-(189, 140), 22, BF
LINE (190, 120)-(200, 140), 22, B
LINE (200, 120)-(210, 140), 22, B
LINE (210, 120)-(220, 140), 22, B
LINE (220, 120)-(230, 140), 22, B
LINE (230, 120)-(240, 140), 22, B
LINE (240, 120)-(250, 140), 22, B
LINE (250, 120)-(260, 140), 22, B
LINE (260, 120)-(270, 140), 22, B
LINE (270, 120)-(280, 140), 22, B
LINE (220, 119)-(281, 119), 20
LINE (281, 119)-(281, 140), 20
LINE (281, 140)-(300, 140), 20

CALL DrawAmmo

END SUB

SUB GaryTalk (Times%, WhichWay%)

SELECT CASE WhichWay%
CASE IS = 1
FOR xx% = 1 TO Times%
IF INKEY$ <> "" THEN EXIT FOR
FOR zz% = 0 TO 1
PUT (GaryX%, 125), sprites%((eps% * (55 + zz%)) + 1), PSET
Delay 2
NEXT zz%
Delay 2
NEXT xx%
PUT (GaryX%, 125), sprites%((eps% * 55) + 1), PSET
CASE IS = 2
FOR xx% = 1 TO Times%
IF INKEY$ <> "" THEN EXIT FOR
FOR zz% = 0 TO 1
PUT (GaryX%, 125), sprites%((eps% * (58 + zz%)) + 1), PSET
Delay 2
NEXT zz%
Delay 2
NEXT xx%
PUT (GaryX%, 125), sprites%((eps% * 58) + 1), PSET
END SELECT

END SUB

SUB LaryExplode

' ***** Lary Explode

FOR sz% = 1 TO 20
CIRCLE (LaryX% + 2, LaryY% + 1), sz%, 14
SOUND (40 + sz%) * 2, .2
NEXT sz%
FOR sz% = 1 TO 20
CIRCLE (LaryX% + 9, LaryY% + 7), sz%, 14
SOUND (40 + sz%) * 2, .2
NEXT sz%
FOR sz% = 1 TO 20
CIRCLE (LaryX% + 4, LaryY% + 15), sz%, 14
SOUND (40 + sz%) * 2, .2
NEXT sz%
FOR sz% = 1 TO 20
CIRCLE (LaryX% + 16, LaryY% + 3), sz%, 14
SOUND (40 + sz%) * 2, .2
NEXT sz%
FOR sz% = 1 TO 20
CIRCLE (LaryX%, LaryY% + 6), sz%, 14
SOUND (40 + sz%) * 2, .2
NEXT sz%
FOR sz% = 1 TO 100
CIRCLE (LaryX% + 8, LaryY% + 8), sz%, 14
SOUND (40 + sz%) * 2, .2
NEXT sz%
dt% = 2
IF Lives% = 0 AND Continues% = 0 THEN CALL Dead
rt% = 1

END SUB

SUB LaryTalk (Times%, WhichWay%)

SELECT CASE WhichWay%
CASE IS = 1
FOR xx% = 1 TO Times%
IF INKEY$ <> "" THEN EXIT FOR
FOR zz% = 0 TO 1
PUT (LaryX%, 125), sprites%((eps% * (60 + zz%)) + 1), PSET
Delay 2
NEXT zz%
Delay 2
NEXT xx%
PUT (LaryX%, 125), sprites%((eps% * 60) + 1), PSET
CASE IS = 2
FOR xx% = 1 TO Times%
IF INKEY$ <> "" THEN EXIT FOR
FOR zz% = 0 TO 1
PUT (LaryX%, 125), sprites%((eps% * (62 + zz%)) + 1), PSET
Delay 2
NEXT zz%
Delay 2
NEXT xx%
PUT (LaryX%, 125), sprites%((eps% * 62) + 1), PSET
END SELECT

END SUB

SUB LoadPalette

DEFINT A-Z
REDIM PaletteArray&(0 TO 255)
FileNo = FREEFILE
OPEN "GRADIENT.PAL" FOR BINARY AS #FileNo
FOR n = 0 TO 255
GET #FileNo, , colour&
PaletteArray&(n) = colour&
NEXT n
CLOSE #FileNo
DIM RGBval(0 TO 255, 0 TO 2)
FOR n = 0 TO 255
c& = PaletteArray&(n)
b = c& \ 65536: c& = c& - b * 65536
g = c& \ 256: c& = c& - g * 256
r = c&
RGBval(n, 0) = r
RGBval(n, 1) = g
RGBval(n, 2) = b
NEXT n
WAIT &H3DA, &H8, &H8: WAIT &H3DA, &H8
FOR n = 0 TO 255
OUT &H3C8, n
OUT &H3C9, RGBval(n, 0)
OUT &H3C9, RGBval(n, 1)
OUT &H3C9, RGBval(n, 2)
NEXT n


END SUB

DEFSNG A-Z
SUB MattTalk (Times%)

FOR xx% = 1 TO Times%
IF INKEY$ <> "" THEN EXIT FOR
FOR zz% = 0 TO 1
PUT (GaryX%, 125), sprites%((eps% * (65 + zz%)) + 1), PSET
Delay 2
NEXT zz%
Delay 2
NEXT xx%
PUT (GaryX%, 125), sprites%((eps% * 65) + 1), PSET


END SUB

SUB MoveBadGuy

' ***** Move the badguy *****

RockAn% = RockAn% + 1
IF RockAn% > 3 THEN RockAn% = 0

FOR zz% = 1 TO RockN%
IF RockLife%(zz%) > 0 THEN
IF (RockGuy%(zz%) + 8) > LaryX% THEN
LINE (RockGuy%(zz%) + 13, 125)-(RockGuy%(zz%) + 16, 140), 162, BF
RockGuy%(zz%) = RockGuy%(zz%) - 3
IF RockGuy%(zz%) < 0 THEN RockGuy%(zz%) = 0
PUT (RockGuy%(zz%), 125), sprites%((eps% * (22 + RockAn%)) + 1), PSET
IF POINT(LaryX% + 15, LaryY% + 15) = 24 OR POINT(LaryX% + 6, LaryY% + 15) = 24 OR POINT(LaryX% + 15, LaryY% + 10) = 24 THEN
FOR xx% = 1 TO 10
LINE (LaryX%, LaryY%)-(LaryX% + 15, LaryY% + 15), 162, BF
en% = en% + 1
IF en% > 2 THEN en% = 1
PUT (RockGuy%(zz%), 125), sprites%(eps% * (31 + en%) + 1), PSET
sd% = INT(RND * (900)) + 40

IF en% = 1 THEN SOUND sd%, 3
IF en% = 2 THEN SOUND sd%, 3
NEXT xx%
dt% = 1
IF Lives% = 0 AND Continues% = 0 THEN CALL Dead
rt% = 1
EXIT FOR
END IF
END IF

IF rt% = 0 THEN
IF (RockGuy%(zz%) + 8) < LaryX% THEN
RockGuy%(zz%) = RockGuy%(zz%) + 3
IF RockGuy%(zz%) > 304 THEN RockGuy%(zz%) = 304
LINE (RockGuy%(zz%) - 3, 125)-(RockGuy%(zz%), 140), 162, BF
PUT (RockGuy%(zz%), 125), sprites%((eps% * (18 + RockAn%)) + 1), PSET
IF POINT(LaryX%, LaryY% + 15) = 24 OR POINT(LaryX% + 6, LaryY% + 15) = 24 OR POINT(LaryX%, LaryY% + 10) = 24 THEN
FOR xx% = 1 TO 10
LINE (LaryX%, LaryY%)-(LaryX% + 15, LaryY% + 15), 162, BF
en% = en% + 1
IF en% > 2 THEN en% = 1
PUT (RockGuy%(zz%), 125), sprites%(eps% * (29 + en%) + 1), PSET
sd% = INT(RND * (900)) + 40

IF en% = 1 THEN SOUND sd%, 3
IF en% = 2 THEN SOUND sd%, 3
NEXT xx%
dt% = 1
IF Lives% = 0 AND Continues% = 0 THEN CALL Dead
rt% = 1
EXIT FOR
END IF
END IF
END IF
END IF

NEXT zz%


' ***** Move the blob guy *****


BlobAn% = BlobAn% + 1
IF BlobAn% > 1 THEN BlobAn% = 0

FOR zz% = 1 TO BlobN%
IF Blob%(zz%) > LaryX% THEN LINE (Blob%(zz%) + 16, 125)-(Blob%(zz%) + 2, 140), 162, BF
IF Blob%(zz%) < LaryX% THEN LINE (Blob%(zz%) - 2, 125)-(Blob%(zz%) + 1, 140), 162, BF
IF Blob%(zz%) > LaryX% THEN Blob%(zz%) = Blob%(zz%) - 2
IF Blob%(zz%) < LaryX% THEN Blob%(zz%) = Blob%(zz%) + 2
IF Blob%(zz%) < 0 THEN Blob%(zz%) = 0
IF Blob%(zz%) > 304 THEN Blob%(zz%) = 304
PUT (Blob%(zz%), 125), sprites%((eps% * (34 + BlobAn%)) + 1), PSET

IF POINT(LaryX% + 15, LaryY% + 15) = 196 OR POINT(LaryX%, LaryY% + 15) = 196 OR POINT(LaryX% + 7, LaryY% + 15) = 196 THEN CALL LaryExplode

NEXT zz%


' ***** Animate the Venus Dinosaur Trap *****

PlantAn% = PlantAn% + 1
IF PlantAn% > 5 THEN PlantAn% = 1

FOR zz% = 1 TO PlantN%
PUT (Plant%(zz%), 125), sprites%((eps% * (43 + PlantAn%) + 1)), PSET
IF POINT(LaryX% + 15, LaryY% + 15) = 164 OR POINT(LaryX% + 7, LaryY% + 15) = 164 OR POINT(LaryX%, LaryY% + 15) = 164 OR POINT(LaryX% + 15, LaryY% + 7) = 161 OR POINT(LaryX%, LaryY% + 7) = 161 THEN
LINE (LaryX%, LaryY%)-(LaryX% + 15, LaryY% + 15), 162, BF
FOR xx% = 1 TO 10
IF xx% > 0 AND xx% < 10 THEN sd% = INT(RND * (900)) + 40
IF xx% > 9 AND xx% < 20 THEN sd% = INT(RND * (1300)) + 500
IF xx% > 19 AND xx% < 30 THEN sd% = INT(RND * (1800)) + 900
IF xx% > 29 THEN sd% = INT(RND * (2300)) + 1200
PUT (Plant%(zz%), 125), sprites%((eps% * (49 + ll%)) + 1), PSET
SOUND sd%, 1
ll% = ll% + 1
IF ll% > 1 THEN ll% = 0
Delay 5
NEXT xx%
dt% = 4
IF Lives% = 0 AND Continues% = 0 THEN CALL Dead
rt% = 1
EXIT FOR
END IF
NEXT zz%

' ***** Move the jelly blob thing *****

JellyAn% = JellyAn% + 1
IF JellyAn% > 2 THEN JellyAn% = 0

FOR zz% = 1 TO JellyN%
IF JellyLife%(zz%) > 0 THEN
LINE (Jelly%(zz%) - 2, 125)-(Jelly%(zz%) + 1, 140), 162, BF
LINE (Jelly%(zz%) + 14, 125)-(Jelly%(zz%) + 17, 140), 162, BF
IF Jelly%(zz%) < LaryX% THEN Jelly%(zz%) = Jelly%(zz%) + 2
IF Jelly%(zz%) > LaryX% THEN Jelly%(zz%) = Jelly%(zz%) - 2
IF Jelly%(zz%) < 0 THEN Jelly%(zz%) = 0
IF Jelly%(zz%) > 304 THEN Jelly%(zz%) = 304
PUT (Jelly%(zz%), 125), sprites%((eps% * (36 + JellyAn%)) + 1), PSET
IF POINT(LaryX% + 15, LaryY% + 15) = 195 OR POINT(LaryX% + 15, LaryY% + 15) = 196 OR POINT(LaryX% + 7, LaryY% + 15) = 195 OR POINT(LaryX% + 7, LaryY% + 15) = 196 OR POINT(LaryX%, LaryY% = 15) = 195 OR POINT(LaryX%, LaryY% + 15) = 196 THEN
LINE (LaryX%, LaryY%)-(LaryX% + 15, LaryY% + 15), 162, BF
IF Jelly%(zz%) - 4 < LaryX% AND Jelly%(zz%) + 20 > LaryX% THEN
FOR xx% = 1 TO 10
sd% = INT(RND * (200)) + 40
PUT (Jelly%(zz%), 125), sprites%((eps% * (41 + yy%)) + 1), PSET
yy% = yy% + 1
IF yy% > 2 THEN yy% = 0
SOUND sd%, 2
Delay 2
NEXT xx%
dt% = 5
IF Lives% = 0 AND Continues% = 0 THEN CALL Dead
rt% = 1
EXIT FOR
END IF
END IF
IF rt% = 0 THEN
IF POINT(LaryX% + 15, LaryY% + 7) = 195 OR POINT(LaryX% + 15, LaryY% + 7) = 196 OR POINT(LaryX%, LaryY% + 7) = 195 OR POINT(LaryX%, LaryY% + 7) = 196 OR POINT(LaryX% + 7, LaryY% + 7) = 195 OR POINT(LaryX% + 7, LaryY% + 7) = 196 THEN
IF Jelly%(zz%) - 4 < LaryX% AND Jelly%(zz%) + 20 > LaryX% THEN
LINE (LaryX%, LaryY%)-(LaryX% + 15, LaryY% + 15), 162, BF
FOR xx% = 1 TO 10
sd% = INT(RND * (200)) + 40
PUT (Jelly%(zz%), 125), sprites%((eps% * (41 + yy%)) + 1), PSET
yy% = yy% + 1
IF yy% > 2 THEN yy% = 0
SOUND sd%, 2
Delay 2
NEXT xx%
dt% = 5
IF Lives% = 0 AND Continues% = 0 THEN CALL Dead
rt% = 1
EXIT FOR
END IF
END IF
END IF
END IF
NEXT zz%

' ***** Check if your get hit by a ball *****

IF sc5% = 1 THEN
IF POINT(LaryX% + 15, LaryY% + 12) = 24 OR POINT(LaryX% + 15, LaryY% + 7) = 24 OR POINT(LaryX% + 7, LaryY% + 12) = 24 OR POINT(LaryX%, LaryY% + 12) = 24 OR POINT(LaryX%, LaryY% + 7) = 24 THEN
FOR sz% = 1 TO 20
SOUND 40, .2
CIRCLE (LaryX% + 7, LaryY% + 7), sz%, 38
NEXT sz%
IF Lives% = 0 AND Continues% = 0 THEN CALL Dead
rt% = 1
Ball% = -1
CALL DrawBackground4
PUT (255, 74), sprites%((eps% * 73) + 1), PSET
LINE (230, 89)-(250, 70), 9
LINE (250, 70)-(280, 70), 9
LINE (280, 70)-(300, 89), 9
LINE (250, 70)-(240, 89), 9
LINE (280, 70)-(290, 89), 9
ABossLife% = BossLife%
BossLife% = 0
FOR xx% = 0 TO ABossLife% STEP 10
CALL CheckBoss
BossLife% = BossLife% + 10
NEXT xx%
BossLife% = BossLife% - 10
END IF

IF POINT(LaryX% + 15, LaryY% + 12) = 20 OR POINT(LaryX% + 15, LaryY% + 7) = 20 OR POINT(LaryX% + 7, LaryY% + 12) = 20 OR POINT(LaryX%, LaryY% + 12) = 20 OR POINT(LaryX%, LaryY% + 7) = 20 THEN
FOR sz% = 1 TO 20
SOUND 40, .2
CIRCLE (LaryX% + 7, LaryY% + 7), sz%, 38
NEXT sz%
IF Lives% = 0 AND Continues% = 0 THEN CALL Dead
rt% = 1
Ball% = -1
CALL DrawBackground4
PUT (255, 74), sprites%((eps% * 73) + 1), PSET
LINE (230, 89)-(250, 70), 9
LINE (250, 70)-(280, 70), 9
LINE (280, 70)-(300, 89), 9
LINE (250, 70)-(240, 89), 9
LINE (280, 70)-(290, 89), 9
ABossLife% = BossLife%
BossLife% = 0
FOR xx% = 0 TO ABossLife% STEP 10
CALL CheckBoss
BossLife% = BossLife% + 10
NEXT xx%
BossLife% = BossLife% - 10
END IF
END IF

END SUB

SUB Notice

SCREEN 0
COLOR 15, 1
CLS
PRINT "LARRY THE DINOSAUR"
PRINT "EPISODE 1"
PRINT "=================="
PRINT "Press - to slow down the speed for Larry"
PRINT "(Sometimes it may not look like it's slowing donw, but it is)"
PRINT "Press + to speed up the speed for Larry"
PRINT
PRINT "Press 4 to slow down the speed for the badguys"
PRINT "(Sometimes it may not look like it's slowing donw, but it is)"
PRINT "Press 6 to speed up the speed for the badguys"
PRINT
PRINT "============================================================="
PRINT "Every time you adjust the speed, it will save it, so take"
PRINT "some time to adjust the speed"
PRINT "============================================================="
PRINT "CONTROLS>>>                                                  "
PRINT "            = LEFT      Every time you jump, be sure to jump"
PRINT "            = RIGHT     first, then press left or right,    "
PRINT "        CTRL = SHOOT     pressing jump and left or right at  "
PRINT "         ALT = JUMP      the same time will cause problems   "
PRINT "============================================================="
SLEEP
COLOR 0, 0
CLS
LOCATE 10, 36
COLOR 30, 0
PRINT "WARNING!"
COLOR 15
LOCATE 12, 27
PRINT "THIS GAME CONTAINS SCENES OF"
LOCATE 13, 28
PRINT "EXPLICIT VIOLENCE AND GORE"
SLEEP
END SUB

SUB Scene1

LINE (LaryX% - 4, LaryY%)-(LaryX% + 19, LaryY% + 15), 162, BF
PUT (LaryX%, 125), sprites%((eps% * 60) + 1), PSET
PUT (250, 125), sprites%((eps% * 65) + 1), PSET

LaryY% = 125
Jump% = 0
jp% = 0

Delay 10
DO
LOOP UNTIL INKEY$ = ""

Center 1, "WHO ARE YOU?", 2, 1
LaryTalk 3, 1
SLEEP
Center 1, "MATT", 7, 0
MattTalk 3
SLEEP
Center 1, "WHO ARE YOU?", 7, 0
MattTalk 3
SLEEP
Center 1, "THAT'S NONE OF YOUR CONCERN", 2, 0
LaryTalk 4, 1
SLEEP
Center 1, "YOU'VE BETTER GET OUT OF HERE", 2, 0
LaryTalk 7, 1
SLEEP
Center 1, "THIS PLACE IS CRAWLING WITH ALIENS", 2, 0
LaryTalk 9, 1
SLEEP
Center 1, "YEA, I KNOW", 7, 0
MattTalk 3
SLEEP
Center 1, "I'VE ENCOUNTERED SOME ALREADY", 7, 0
MattTalk 8
SLEEP
Center 1, "MY FRIEND AND I CAME HERE TO GO ON A", 7, 0
Center 2, "HIKING TRIP", 7, 0
MattTalk 13
SLEEP
Center 1, "BUT", 7, 1
MattTalk 1
SLEEP
Center 1, "BUT WHAT?", 2, 0
LaryTalk 2, 1
SLEEP
Center 1, "I LOST MY FRIEND A WHILE AGO", 7, 0
MattTalk 9
SLEEP
Center 1, "I THINK HE MIGHT BE DEAD", 7, 0
MattTalk 6
SLEEP
Center 1, "WHAT'S HIS NAME?", 2, 0
LaryTalk 3, 1
SLEEP
Center 1, "STEVE", 7, 0
MattTalk 4
SLEEP
Center 1, "IF I COME ACROSS HIM, I'LL TELL HIM TO", 2, 0
Center 2, "GET OUT OF HERE", 2, 0
LaryTalk 14, 1
SLEEP
Center 1, "IN THE MEAN TIME, YOU SHOULD LEAVE", 2, 1
LaryTalk 7, 1
SLEEP
Center 1, "LOOK OUT!", 2, 0
LaryTalk 2, 1

PUT (250, 125), sprites%((eps% * 67) + 1), PSET

FOR zz% = 304 TO 260 STEP -3
LINE (zz% + 16, 125)-(zz% + 20, 140), 162, BF
PUT (zz%, 125), sprites%((eps% * (22 + An%) + 1)), PSET
An% = An% + 1
IF An% > 3 THEN An% = 0
Delay 2
NEXT zz%

PUT (LaryX%, 125), sprites%((eps% * 61) + 1), PSET

LINE (250, 125)-(280, 140), 162, BF
Center 1, "  ", 0, 1

FOR zz% = 1 TO 40
sd% = INT(RND * (900)) + 40
PUT (255, 125), sprites%((eps% * (68 + An%)) + 1), PSET
SOUND sd%, 3
An% = An% + 1
IF An% > 1 THEN An% = 0
NEXT zz%

RockGuy%(1) = 255
RockLife%(1) = 3
RockN% = 1
END SUB

SUB Scene2

Delay 10
DO
LOOP UNTIL INKEY$ = ""


LINE (LaryX% - 4, LaryY%)-(LaryX% + 19, LaryY% + 15), 162, BF

LaryY% = 125
Jump% = 0
jp% = 0

Center 1, "DOWN BELOOOOW!!!", 2, 1
LaryTalk 3, 1
SLEEP
Center 1, "  ", 0, 1

sc2% = 1

END SUB

SUB Scene3

Delay 10
DO
LOOP UNTIL INKEY$ = ""


LINE (LaryX% - 4, LaryY%)-(LaryX% + 19, LaryY% + 15), 162, BF

LaryY% = 125
Jump% = 0
jp% = 0

Center 1, "THAT'S A BIG LONG BRIDGE AHEAD", 2, 1
LaryTalk 7, 1
SLEEP

sc3% = 1

END SUB

SUB Scene4

LINE (LaryX% - 4, LaryY%)-(LaryX% + 19, LaryY% + 15), 162, BF
PUT (LaryX%, 125), sprites%((eps% * 60) + 1), PSET
PUT (210, 125), sprites%((eps% * 54) + 1), PSET

LaryY% = 125
Jump% = 0
jp% = 0

Delay 10
DO
LOOP UNTIL INKEY$ = ""

GaryX% = 210

Center 1, "HEY!", 2, 1
LaryTalk 1, 1
SLEEP
Center 1, "WHAT!", 7, 0
GaryTalk 1, 1
SLEEP
Center 1, "WHO ARE YOU?", 7, 0
GaryTalk 3, 2
SLEEP
Center 1, "THAT'S NOT IMPORTANT", 2, 0
LaryTalk 5, 1
SLEEP
Center 1, "YOUR STEVE, RIGHT", 2, 0
LaryTalk 4, 1
SLEEP
Center 1, "YEA, WHY?", 7, 0
GaryTalk 2, 2
SLEEP
Center 1, "DID YOU FIND MATT?!", 7, 0
GaryTalk 4, 2
SLEEP
Center 1, "I DID, SORT OF", 2, 0
LaryTalk 4, 1
SLEEP
Center 1, "WHAT DO YOU MEAN, SORT OF?", 7, 0
GaryTalk 6, 2
SLEEP
Center 1, "HE WAS LOOKING FOR YOU", 2, 0
LaryTalk 6, 1
SLEEP
Center 1, "I RAN INTO HIM", 2, 0
LaryTalk 5, 1
SLEEP
Center 1, "I TOLD HIM TO GET OUT OF HERE", 2, 0
LaryTalk 8, 1
SLEEP
Center 1, "BUT HE WAS EATEN BY A ROCKMONSTER", 2, 0
Center 2, "BEFORE HE COULD", 2, 0
SLEEP
Center 1, "MATT...", 7, 1
GaryTalk 1, 2
SLEEP
Center 1, "NO", 7, 0
GaryTalk 1, 2
SLEEP
Center 1, "ENOUGH TALK", 2, 0
LaryTalk 3, 1
SLEEP
Center 1, "YOU GOT TO GET OUT OF HERE WHILE YOUR", 2, 0
Center 2, "STILL ALIVE", 2, 0
SLEEP
Center 1, "OKAY", 7, 1
GaryTalk 1, 2
SLEEP
Center 1, "LATER...UH", 7, 0
GaryTalk 2, 2
SLEEP
Center 1, "WHAT'S YOUR NAME???", 7, 0
GaryTalk 3, 2
SLEEP
Center 1, "JUST GO", 2, 0
LaryTalk 2, 1
SLEEP
Center 1, "ALL RIGHT", 7, 0
GaryTalk 2, 2
SLEEP
Center 1, "  ", 1, 1

dt% = 6

END SUB

SUB Scene5

Delay 10

Center 1, "HELLO LARRY", 5, 1
BossTalk 4
SLEEP
Center 1, "WHAT DO YOU WANT?", 2, 0
LaryTalk 4, 1
SLEEP
Center 1, "I WANT YOUR HEAD", 5, 0
BossTalk 4
SLEEP
Center 1, "MASTER XENOPHOBE SENT ME TO KILL YOU", 5, 0
BossTalk 8
SLEEP
Center 1, "HE'LL BE PLEASED WHEN I SHOW HIM YOUR", 5, 0
Center 2, "HEAD ON A PLATE", 5, 0
BossTalk 12
SLEEP
Center 1, "WHAT'S THAT BIG TOY OF YOURS?", 2, 1
LaryTalk 6, 1
SLEEP
Center 1, "LARRY LARRY", 5, 0
BossTalk 4
SLEEP
Center 1, "WE'RE GOING TO PLAY A GAME", 5, 0
BossTalk 5
SLEEP
Center 1, "I GET IN THIS BIG ARMORED BOX THAT'S", 5, 0
Center 2, "IMPENETRABLE TO YOUR SHOTGUN", 5, 0
BossTalk 18
SLEEP
Center 1, "AND I SHOOT GIGANTIC BALL BEARINGS AT", 5, 1
Center 2, "YOU IN HOPE THAT YOU WILL GET HIT BY", 5, 0
BossTalk 19
SLEEP
Center 1, "ONE OF THEM", 5, 1
BossTalk 3
SLEEP
Center 1, "SOUNDS LIKE FUN", 2, 0
LaryTalk 3, 1
SLEEP
Center 1, "AND I HOPE THAT YOU DO HAVE FUN", 5, 0
BossTalk 8
SLEEP

yy% = 125
FOR zz% = 100 TO 255
LINE (zz%, yy%)-(zz% + 15, yy% + 15), 162, BF
yy% = yy% - 1
IF yy% < 70 THEN yy% = 70
PUT (zz%, yy%), sprites%((eps% * 70) + 1), PSET
Delay .6
NEXT zz%


LINE (zz% - 9, yy% - 4)-(zz% + 20, yy% + 4), 162, BF
PUT (255, 74), sprites%((eps% * 73) + 1), PSET
LINE (230, 89)-(250, 70), 9
LINE (250, 70)-(280, 70), 9
LINE (280, 70)-(300, 89), 9
LINE (250, 70)-(240, 89), 9
LINE (280, 70)-(290, 89), 9

Center 1, "  ", 0, 1

LINE (0, 0)-(319, 15), 162, BF

END SUB

SUB Title

DO
LOOP UNTIL INKEY$ = ""

CLS

DRAW "bM0,80 c162 e15 f15 e15 f15 e15 f15 e15 f15 e15 f15 e15 f15 e15 f15 e15 f15 e15 f15 e15 f15 e15 f15"
PAINT (0, 100), 162, 162
PAINT (0, 0), 72, 162
LINE (0, 70)-(50, 10), 100
LINE (50, 10)-(25, 74), 100
DRAW "h10 g15"
PAINT (20, 60), 100, 100
PSET (48, 14), 100
LINE (51, 10)-(60, 11), 102
LINE (60, 11)-(155, 74), 102
DRAW "g5 h15 g15 h15 g15 h15 g15 h15 g15 h4"
LINE (25, 74)-(51, 10), 102
PAINT (100, 50), 102, 102

LINE (135, 60)-(250, 0), 100
LINE (280, 0)-(240, 79), 100
DRAW "h15 g15 h15 g15 h15 g9"
LINE (155, 73)-(135, 60), 100
PAINT (200, 50), 100, 100
LINE (281, 0)-(241, 78), 102
DRAW "e14 f15 e15 f15 e15 f15"
PAINT (300, 50), 102, 102
PSET (244, 74), 102

DRAW "bm20,150 c51 u10 e5 r50 f5 d10 g5 l50 h5 d1 c0 f5 r50 e5 d1 g5 l50 h5 d1 c51 d10 f5 r50 e5 u10 g5 l50 h5"
PAINT (30, 150), 52, 51
PAINT (30, 160), 52, 51
DRAW "bm20,140 c51 u20 e5 r50 f5 d20"
PAINT (30, 130), 52, 51

DRAW "bm23,136 c15 u8 e2 r15 d8 l15 g2"
DRAW "br54 u8 h2 l15 d8 r15 f2"
PAINT (25, 130), 15, 15
PAINT (70, 130), 15, 15

DRAW "bm30,126 c0 d8 r10 u8 l10 br40 d8 l10 u8 r10"
PAINT (35, 130), 0, 0
PAINT (65, 130), 0, 0

LINE (30, 140)-(35, 145), 0
LINE (65, 145)-(70, 140), 0

DRAW "bm35,169 c51 d5 r30 u5 d6 c70 d17 r20 u11 h8 l11 d2 l32 u2 l11 g8 d11 r20 u16 d17 r30"
PAINT (40, 170), 52, 51
PAINT (30, 180), 70, 70
PAINT (50, 180), 72, 70
PAINT (80, 180), 70, 70


DRAW "bm100,100 c24 d50 r30 u10 l20 u40 l10 bd50 br40 u40 e10 r20 f10 d40 l10 u20 l20 d20 l10 br10 bu30 u10 e3 r14 f3 d10 l20"
DRAW "bd30 br40 u50 r20 f10 d15 g10 f15 l15 h10 d10 l10 br10 bu25 u15 r5 f5 d5 g5 l5 bd25 br35 u50 r20 f10 d15 g10 f15 l15 h10 d10 l10 br10 bu25 u15 r5 f5 d5 g5 l5 bd25 br40 u15 h10 u25 r10 d25 f5 e5 u25 r10 d25 g10 d15 l10"
PAINT (105, 110), 26, 24
PAINT (145, 110), 26, 24
PAINT (210, 110), 26, 24
PAINT (260, 110), 26, 24
PAINT (300, 110), 26, 24


DRAW "bm130,170 c24 u10 l5 r10 br5 d10 u5 r5 d5 u10 br5 r5 l5 d5 r5 l5 d5 r5 br40"
DRAW "u10 r5 f2 d6 g2 l5 br10 u10 br5 d10 u10 f10 u10 br5 r5 d10 l5 u10 br10 r5 l5 d5 r5 d5 l5 br10 u10 r5 d10 u5 l5 r5 br5 u5 d10 r5 u10 br5 r5 f2 d3 g2 l5 u7 d10 u3 r5 f3"

DRAW "bm100,190 c24 r6 l3 u3 d6 br 10 bu3 r6 br10 u3 r5 l5 d3 r5 d3 l5 br10 u6 r6 d3 l6 br10 u3 r6 l6 d3 r6 l6 d3 r6 br5 r6 l6 u3 r6 l6 u3 r6 br5 d6 r6 e2 u2 h2 l6"
DRAW "bm200,190 c24 u3 d3 r6 u3 d6 br 10 bu1 u5 r6 l6 d3 r6 d3 l6 br15 bu3 u3 r5 l5 d3 r5 d3 l5 br10 u6 r6 d3 l6 br10 u3 r6 l6 d3 r6 l6 d3 r6 br5 r6 l6 u3 r6 l6 u3 r6 br5 d6 r6 e2 u2 h2 l6"

DO
PUT (180, 180), sprites%((eps% * (1 + zz%)) + 1), PSET
PUT (285, 180), sprites%((eps% * (18 + xx%) + 1)), PSET
Delay 1
a$ = INKEY$
IF a$ = "-" THEN Speed& = Speed& + 10000
IF a$ = "+" THEN Speed& = Speed& - 10000
IF a$ = "4" THEN BSpeed& = BSpeed& + 10000
IF a$ = "6" THEN BSpeed& = BSpeed& - 10000
IF a$ = CHR$(27) THEN EXIT DO
IF a$ = CHR$(13) THEN EXIT DO
a% = a% + 1
IF a% > BSpeed& / 200 THEN xx% = xx% + 1: a% = 0
IF xx% > 3 THEN xx% = 0
zz% = zz% + 1
IF zz% > 3 THEN zz% = 0
LOOP

OPEN "LARYDATA.LRY" FOR OUTPUT AS #1
WRITE #1, Speed&, BSpeed&
CLOSE #1

END SUB

