
'====================================
'  DELTA CODE PRESENTS
' *****Larry The Dinosaur*****
' *****Episode 3********
'   2000 Created by Joe king
'
'>>>CONTROLS>>>
'              CTRL = SHOOT
'              ALT  = JUMP
'
'====================================
DECLARE SUB Notice ()
DECLARE SUB Xenod (Times%, Whichway%)
DECLARE SUB XenoTalk (Times%, Whichway%)
DECLARE SUB Ambushes ()
DECLARE SUB CheckBoss ()
DECLARE SUB BossExplode ()
DECLARE SUB Scene5 ()
DECLARE SUB BossTalk (Times%)
DECLARE SUB Continue ()
DECLARE SUB DrawBackground4 ()
DECLARE SUB Scene3 ()
DECLARE SUB DrawBackground3 ()
DECLARE SUB Scene4 ()
DECLARE SUB DrawBackGround2 ()
DECLARE SUB Intro ()
DECLARE SUB Scene2 ()
DECLARE SUB MattTalk (Times%)
DECLARE SUB Scene1 ()
DECLARE SUB LaryTalk (Times%, Whichway%)
DECLARE SUB GaryTalk (Times%, Whichway%)
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
COMMON SHARED RockAn%, BlobAn%, PlantAn%, JellyAn%, BSpeed&
COMMON SHARED LaryX%, LaryY%, Ammo%, Jump%, jp%, am1%, am2%, am3%, am4%, am5%, am6%
COMMON SHARED eps%, dt%, zz%, GaryX%, rs%, rt%, rts%, Xeno%
COMMON SHARED sc1%, sc2%, sc3%, sc4%, sc5%, Level%, fr%, XenoX%
COMMON SHARED Lives%, Continues%, BossLife%, ABossLife%
COMMON SHARED Speed&
RANDOMIZE TIMER

CALL Notice

'CHDIR "c:\qb45\platform\larry"
SCREEN 13

CLS

CALL LoadPalette

' *****Load the sprites*****
FileName$ = "LARYL.PUT"
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

5

OPEN "LARYDATA.LRY" FOR INPUT AS #1
INPUT #1, Speed&, BSpeed&
CLOSE #1

BossLife% = 60
ABossLife% = 60
Level% = 1
Lives% = 5
Continues% = 5
sc1% = 1

10
IF rts% = 1 THEN rts% = 0: cat% = 0: GOTO 5
jp% = 0
Room% = 1: Position% = 1
LaryX% = 0: LaryY% = 125
IF Level% = 1 THEN Ammo% = 30
IF Level% = 2 THEN Ammo% = Ammo% + 50
IF Level% = 3 THEN Ammo% = 99
IF Level% = 4 THEN Ammo% = 99
IF cat% = 0 THEN CALL Title: cat% = 1
IF Level% = 1 THEN CALL DrawBackGround
IF Level% = 2 THEN CALL DrawBackGround2
IF Level% = 3 THEN CALL DrawBackground3
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

MoveBadGuyX% = MoveBadGuyX% + 1
IF Xeno% = 1 AND MoveBadGuyX% > Speed& / Speed& THEN GOSUB Xenophobe
IF MoveBadGuyX% > BSpeed& / 200 THEN MoveBadGuyX% = 0: CALL MoveBadGuy

IF a% = &H4D THEN LaryX% = LaryX% + 4: Position% = 1: An% = An% + 1: Count% = 0
IF a% = &H4B THEN LaryX% = LaryX% - 4: Position% = 2: An% = An% + 1: Count% = 0
IF Jump% = 0 AND a% = &H38 THEN Jump% = 1: ct% = 0
IF Ammo% > 0 AND Shoot% = 0 AND a% = &H1D THEN nt% = 0: Shoot% = 1: sh% = 10: An% = 0: Ammo% = Ammo% - 1: CALL DrawAmmo
IF a% = 1 THEN END

IF An% > 4 THEN An% = 1
IF Jump% = 4 THEN Jump% = 0

IF Jump% = 0 THEN IF An% = 1 OR An% = 3 THEN SOUND 40, .5
IF Level% = 1 AND LaryX% > 304 THEN Room% = Room% + 1: LaryX% = 0: CALL DrawBackGround
IF Level% = 1 AND Room% <> 1 AND LaryX% < 0 THEN Room% = Room% - 1: LaryX% = 304: CALL DrawBackGround
IF Level% = 2 AND LaryX% > 304 THEN Room% = Room% + 1: LaryX% = 0: CALL DrawBackGround2
IF Level% = 2 AND Room% <> 1 AND LaryX% < 0 THEN Room% = Room% - 1: LaryX% = 304: CALL DrawBackGround2
IF Level% = 3 AND LaryX% > 300 THEN LaryX% = 300
IF Room% = 1 AND LaryX% < 0 THEN LaryX% = 0
IF Level% = 1 AND Room% = 7 AND LaryX% > 50 AND sc3% = 0 THEN CALL Scene2: dt% = 6: CALL Dead: rs% = 1
IF sc1% = 1 THEN CALL Scene1: sc1% = 0
IF sc2% = 0 AND Level% = 1 AND Room% = 3 AND LaryX% > 150 THEN
Jelly%(1) = 10
Jelly%(2) = 50
Jelly%(3) = 250
Jelly%(4) = 300
JellyLife%(1) = 10
JellyLife%(2) = 10
JellyLife%(3) = 10
JellyLife%(4) = 10
JellyN% = 4
sc2% = 1
END IF
IF Level% = 2 AND LaryX% > 150 THEN CALL Ambushes
IF fr% = 1 THEN fr% = 0: dt% = 6: CALL Dead: rs% = 1
IF sc4% = 0 AND Level% = 3 THEN CALL Scene3
DO
LOOP UNTIL INKEY$ = ""
Delay 1
IF Jump% <> 0 THEN GOSUB Jump
IF Shoot% = 1 THEN GOSUB Shoot1
IF rs% = 1 THEN rs% = 0: GOTO 10
GOSUB CheckSpike

IF rt% = 1 THEN
rt% = 0: Lives% = Lives% - 1
IF Lives% = 0 THEN CALL Continue
LaryX% = 0: LaryY% = 125: Jump% = 0: ct% = 0: jp% = 0
IF Ammo% < 10 THEN Ammo% = 10
Center 1, "LIVES =" + STR$(Lives%), 15, 1
SLEEP
Center 1, "  ", 0, 1
IF Level% = 1 THEN CALL DrawBackGround
IF Level% = 2 THEN CALL DrawBackGround2
IF Level% = 3 THEN CALL DrawBackground3
am1% = 0: am2% = 0: am3% = 0: am4% = 0
am5% = 0: am6% = 0
IF XenoX% < 50 THEN XenoX% = 50
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
IF jp% > -1 THEN Jump% = 4: An% = 0
CASE IS = 3
ct% = ct% + 1
IF ct% > 2 THEN Jump% = 2
END SELECT
SOUND 40 - (jp% * 5), .5
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


IF POINT(xx%, LaryY% + 8) = 100 THEN
PUT (XenoX%, 125), sprites%((eps% * 75) + 1), PSET: Delay 1
BossLife% = BossLife% - 1
ABossLife% = ABossLife% - 2
CALL CheckBoss
gt% = 1
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

IF POINT(xx%, LaryY% + 8) = 100 THEN
PUT (XenoX%, 125), sprites%((eps% * 76) + 1), PSET: Delay 1
BossLife% = BossLife% - 1
ABossLife% = ABossLife% - 2
CALL CheckBoss
st% = 1
END IF

IF st% = 1 THEN EXIT FOR
NEXT xx%
END IF
nt% = 1
END IF
RETURN

'***** Move Xenophobe *****

Xenophobe:
bm% = 4
IF BossLife% < 1 THEN CALL BossExplode
IF BossLife% < 41 AND fo% = 0 THEN fo% = 1: CALL Scene4
hs% = BossLife%
IF hs% < 30 THEN hs% = 30
bsh% = bsh% + 1
IF bsh% > hs% AND XenoX% > 50 THEN bsh% = 0: BossShoot% = 1
IF BossShoot% = 0 THEN
BossM% = BossM% + 1
IF BossM% > 0 THEN
BossM% = 0
BossAn% = BossAn% + 1
IF XenoX% < LaryX% THEN XenoX% = XenoX% + bm%: BossP% = 1
IF XenoX% > LaryX% THEN XenoX% = XenoX% - bm%: BossP% = 2
END IF
IF BossAn% > 2 THEN BossAn% = 1
IF BossP% = 1 THEN LINE (XenoX% - 10, 125)-(XenoX%, 140), 162, BF: PUT (XenoX%, 125), sprites%((eps% * 74) + 1), PSET
IF BossP% = 2 THEN LINE (XenoX% + 16, 125)-(XenoX% + 26, 140), 162, BF: PUT (XenoX%, 125), sprites%((eps% * 73) + 1), PSET
ELSE
GOSUB BossShoot1
END IF
FOR zz% = 1 TO 15
IF POINT(LaryX% + 15, LaryY% + zz%) = 100 OR POINT(LaryX% + 7, LaryY% + zz%) = 100 OR POINT(LaryX%, LaryY% + zz%) = 100 THEN PUT (XenoX%, 125), sprites%((eps% * 77) + 1), PSET: CALL LaryExplode
NEXT zz%
RETURN


' ***** Boss shoot *****

BossShoot1:                                                                                    
IF BossP% = 1 THEN LINE (XenoX% - 4, 125)-(XenoX%, 140), 162, BF: PUT (XenoX%, 125), sprites%((eps% * 79) + 1), PSET
IF BossP% = 2 THEN LINE (XenoX% - 4, 125)-(XenoX%, 140), 162, BF: PUT (XenoX%, 125), sprites%((eps% * 78) + 1), PSET
IF BossP% = 1 THEN PUT (XenoX% + (16 + ok%), 125), sprites%((eps% * 115) + 1), PSET
IF BossP% = 2 THEN PUT (XenoX% - (16 - ok%), 125), sprites%((eps% * 115) + 1), PSET
IF BossP% = 1 THEN PUT (XenoX% + (16 + sk%), 125), sprites%((eps% * 114) + 1), PSET
IF BossP% = 2 THEN PUT (XenoX% - (16 - sk%), 125), sprites%((eps% * 113) + 1), PSET
ok% = sk%
IF BossP% = 1 THEN sk% = sk% + 10
IF BossP% = 2 THEN sk% = sk% - 10
IF BossP% = 1 THEN IF XenoX% + sk% > 280 THEN PUT (XenoX% + (16 + ok%), 125), sprites%((eps% * 115) + 1), PSET: BossShoot% = 0
IF BossP% = 2 THEN IF XenoX% + sk% < 16 THEN PUT (XenoX% - (16 - ok%), 125), sprites%((eps% * 115) + 1), PSET: BossShoot% = 0

FOR zz% = 1 TO 15
IF POINT(LaryX% + 15, LaryY% + zz%) = 14 OR POINT(LaryX% + 7, LaryY% + zz%) = 14 OR POINT(LaryX%, LaryY% + zz%) = 14 THEN LINE (LaryX% - 10, LaryY% - 4)-(LaryX% + 25, LaryY% + 15), 162, BF: FOR zx% = 117 TO 144: PUT (LaryX%, 125), sprites%((eps% *  _
zx%) + 1), PSET: Delay 2: NEXT zx%: Delay 10: rt% = 1: BossShoot% = 0: sk% = 0: ok% = 0: bsh% = 0: EXIT FOR
NEXT zz%

IF BossShoot% = 0 THEN ok% = 0: sk% = 0

RETURN

SUB Ambushes

'***** Make the ambushes for level 2 *****

IF Room% = 1 AND am1% = 0 THEN
RockGuy%(1) = 50
RockGuy%(2) = 250
RockLife%(1) = 4
RockLife%(2) = 4
RockN% = 2
am1% = 1
END IF

IF Room% = 2 AND am2% = 0 THEN
Jelly%(1) = 50
Jelly%(2) = 250
JellyLife%(1) = 10
JellyLife%(2) = 10
JellyN% = 2
am2% = 1
END IF

IF Room% = 3 AND am3% = 0 THEN
RockGuy%(1) = 50
RockGuy%(2) = 70
RockGuy%(3) = 300
RockGuy%(4) = 270
RockLife%(1) = 4
RockLife%(2) = 4
RockLife%(3) = 4
RockLife%(4) = 4
RockN% = 4
am3% = 1
END IF

IF Room% = 4 AND am4% = 0 THEN
Blob%(1) = 50
Blob%(2) = 100
Blob%(3) = 200
Blob%(4) = 280
BlobN% = 4
am4% = 1
END IF

IF Room% = 5 AND am5% = 0 THEN
Jelly%(1) = 50
Jelly%(2) = 280
Blob%(1) = 100
Blob%(2) = 300
RockGuy%(1) = 120
JellyLife%(1) = 10
JellyLife%(2) = 10
RockLife%(1) = 4
JellyN% = 2
BlobN% = 2
RockN% = 1
am5% = 1
END IF

IF Room% = 6 AND am6% = 0 THEN
RockGuy%(1) = 130
RockGuy%(2) = 210
RockLife%(1) = 4
RockLife%(2) = 4
Jelly%(1) = 50
JellyLife%(1) = 10
Blob%(1) = 230
Blob%(2) = 250
Blob%(3) = 270
BlobN% = 3
RockN% = 2
JellyN% = 1
am6% = 1
END IF

IF Room% = 7 THEN
LINE (LaryX% - 4, LaryY%)-(LaryX% + 19, LaryY% + 15), 162, BF
PUT (LaryX%, 125), sprites%((eps% * 60) + 1), PSET
Delay 30
DO
LOOP UNTIL INKEY$ = ""
Center 1, "WOA", 2, 1
LaryTalk 2, 1
SLEEP
Center 1, "  ", 2, 0
fr% = 1
END IF

END SUB

SUB BossExplode

DrawBackground3
LINE (XenoX% - 4, 125)-(XenoX%, 140), 162, BF: PUT (XenoX%, 125), sprites%((eps% * 78) + 1), PSET
LINE (LaryX% - 4, LaryY%)-(LaryX% + 19, LaryY% + 15), 162, BF
IF LaryX% < 20 THEN LaryX% = 20
PUT (LaryX%, 125), sprites%((eps% * 60) + 1), PSET
PUT (0, 125), sprites%((eps% * 64) + 1), PSET
IF LaryX% > XenoX% THEN PUT (LaryX%, 125), sprites%((eps% * 62) + 1), PSET
IF LaryX% < XenoX% THEN PUT (LaryX%, 125), sprites%((eps% * 60) + 1), PSET

Center 1, "DIE XENOPHOBE!!!", 7, 1
Delay 30
MattTalk 4
Center 1, "  ", 2, 0
Delay 20
PUT (0, 125), sprites%((eps% * 65) + 1), PSET
Delay 10
PUT (0, 125), sprites%((eps% * 66) + 1), PSET
Delay 10
PUT (0, 125), sprites%((eps% * 67) + 1), PSET
Delay 10
dl% = 5: ld% = 1
cnd% = 8: cnx% = 0
DO
PUT (0, 125), sprites%((eps% * 68) + 1), PSET
PUT (XenoX% + ld%, 125), sprites%((eps% * 88) + 1), PSET
Delay dl%
PUT (0, 125), sprites%((eps% * 69) + 1), PSET
Delay dl%
LINE (16, 130)-(XenoX% + ld%, 135), 14, BF
LINE (16, 131)-(XenoX% + ld%, 134), 15, BF
cnd% = cnd% - 8
IF cnd% < 1 THEN cnd% = 8: dl% = dl% - 1
IF dl% < 1 THEN dl! = 1
ld% = ld% + 1
IF ld% > 1 THEN ld% = 0
cnx% = cnx% + 1
IF cnx% > 1000 THEN EXIT DO
LOOP

FOR zz% = 89 TO 112
PUT (XenoX%, 125), sprites%((eps% * zz%) + 1), PSET
Delay 2
NEXT zz%

CALL DrawBackground3

PUT (LaryX%, 125), sprites%((eps% * 62) + 1), PSET
PUT (0, 125), sprites%((eps% * 64) + 1), PSET

Center 1, "STEVE!", 2, 1
LaryTalk 2, 2
SLEEP
Center 1, "YEP, IT'S ME", 7, 0
MattTalk 3
SLEEP
Center 1, "I COULDN'T LEAVE YOU HEAR TO DIE", 7, 0
MattTalk 8
SLEEP
Center 1, "THAT WAS DANGEROUS, BUT THANKS", 2, 0
LaryTalk 7, 2
SLEEP
Center 1, "WELL...", 2, 0
LaryTalk 1, 2
SLEEP
Center 1, "I GUESS THAT'S IT", 2, 0
LaryTalk 4, 2
SLEEP
Center 1, "I'LL SEE YA LATER", 2, 0
LaryTalk 5, 2
SLEEP
Center 1, "BEFORE YOU GO...", 7, 0
MattTalk 4
SLEEP
Center 1, "WHAT'S YOUR NAME", 7, 0
MattTalk 3
SLEEP
Center 1, "LARRY", 2, 0
LaryTalk 2, 2
SLEEP
Center 1, "I'LL SEE YOU LATER, LARRY", 7, 0
MattTalk 7
SLEEP
Center 1, "YEA...", 2, 0
LaryTalk 1, 2
SLEEP
Center 1, "SEE YA LATER", 2, 0
LaryTalk 4, 2
SLEEP
Center 1, "  ", 0, 0

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

IF BossLife% = 39 THEN ABossLife% = 58
IF BossLife% = 19 THEN ABossLife% = 58
IF BossLife% > 39 THEN PAINT ((ABossLife% * 5.2) + 7, 188), 0, 0
IF BossLife% > 19 AND BossLife% < 40 THEN PAINT ((ABossLife% * 5.2) + 7, 178), 0, 0
IF BossLife% > -1 AND BossLife% < 20 THEN PAINT ((ABossLife% * 5.2) + 7, 168), 0, 0
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
IF Level% = 3 THEN DrawBackground3: LaryX% = 5
IF Level% = 4 THEN
CLS
SCREEN 0
WIDTH 80, 50
PRINT "LARRY THE DINOSAUR"
PRINT "=================="
PRINT "Created by Joe King"
PRINT "2000 Delta Code"
PRINT "=================="
PRINT "Graphics:        Joe King, Daniel King(Made the JellyBlob)"
PRINT "Level Design:    Joe King"
PRINT "Story Line:      Joe King"
PRINT "Sound:           Joe King"
PRINT "Testers:         Joe King, James Heath, Ben Black, Steven Degutis, Daniel King"
PRINT "Special Thanks:  Pixel Plus 256"
PRINT "=================="
PRINT "Cast"
PRINT "=================="
PRINT "Larry:                   Larry"
PRINT "Steve:                    Steve"
PRINT "Xenophobe:               Xenophobe"
PRINT "Kendall:                 Kendall"
PRINT "Boss 1:                  Boss 1"
PRINT "Boss 2:                  Boss 2"
PRINT "RockMonsters:            RockMonsters"
PRINT "Mine Blobs:              Mine Blobs"
PRINT "Venus Dinosaur Traps:    Venus Dinosaur Traps"
PRINT "Jelly Blobs:             Jelly Blobs"
PRINT "=================="
PRINT "THANKS FOR PLAYING"
PRINT "=================="
SLEEP
rts% = 1: rs% = 1
END
END IF
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

LINE (2, 180)-(100, 190), 6, BF

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
PAINT (1, 1), 22, 162
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

Spike%(1) = 150
Spike%(2) = 200
Plant%(1) = 250
SpikeN% = 2
PlantN% = 1

CASE IS = 2

RockGuy%(1) = 200
Jelly%(1) = 300
RockLife%(1) = 4
JellyLife%(1) = 10
RockN% = 1
JellyN% = 1

CASE IS = 4

Spike%(1) = 50
Spike%(2) = 66
Spike%(3) = 82
Spike%(4) = 130
Spike%(5) = 146
Spike%(6) = 162
Spike%(7) = 210
Plant%(1) = 290
PlantN% = 1
SpikeN% = 7

CASE IS = 5

Blob%(1) = 50
Blob%(2) = 110
Blob%(3) = 170
Blob%(4) = 230
Blob%(5) = 280
BlobN% = 5


CASE IS = 6

Jelly%(1) = 140
Jelly%(2) = 200
Jelly%(3) = 260
Spike%(1) = 160
Spike%(2) = 290
Plant%(1) = 80
JellyLife%(1) = 10
JellyLife%(2) = 10
JellyLife%(3) = 10
SpikeN% = 2
PlantN% = 1
JellyN% = 3

END SELECT


CALL DrawAmmo

END SUB

SUB DrawBackGround2

' ***** Draw background *****

CLS
DRAW "c162 bl160 bu10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10"
DRAW "bl320 bd50 r320"
DRAW "c164 bd10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10"
DRAW "bu9 r320"
PAINT (150, 105), 162, 162
PAINT (1, 1), 22, 162
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

CALL DrawAmmo

END SUB

SUB DrawBackground3

' ***** Draw background *****

CLS
DRAW "c162 bl160 bu10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10 e10 f10"
DRAW "bl320 bd50 r320"
DRAW "c164 bd10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10"
DRAW "bu9 r320"
PAINT (150, 105), 162, 162
PAINT (1, 1), 22, 162
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

FOR yy% = 165 TO 185 STEP 10
FOR zz% = 110 TO 300 STEP 10
LINE (zz%, yy%)-(zz% + 10, yy% + 10), 0, B
NEXT zz%
NEXT yy%

FOR yy% = 166 TO 186 STEP 10
FOR zz% = 111 TO 301 STEP 10
IF xx% < BossLife% THEN PAINT (zz%, yy%), 164, 0
IF xx% >= BossLife% THEN PAINT (zz%, yy%), 0, 0
xx% = xx% + 1
NEXT zz%
NEXT yy%

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

SUB GaryTalk (Times%, Whichway%)
SELECT CASE Whichway%
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

SUB LaryTalk (Times%, Whichway%)

SELECT CASE Whichway%
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
B = c& \ 65536: c& = c& - B * 65536
g = c& \ 256: c& = c& - g * 256
r = c&
RGBval(n, 0) = r
RGBval(n, 1) = g
RGBval(n, 2) = B
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
PUT (0, 125), sprites%((eps% * (64 + zz%)) + 1), PSET
Delay 2
NEXT zz%
Delay 2
NEXT xx%
PUT (0, 125), sprites%((eps% * 64) + 1), PSET


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
PRINT "EPISODE 3"
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
COLOR 30
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

LaryY% = 125
Jump% = 0
jp% = 0

Delay 10
DO
LOOP UNTIL INKEY$ = ""

Center 1, "ALL RIGHT XENOPHOBE!!!", 2, 1
LaryTalk 5, 1
SLEEP
Center 1, "I KNOW YOUR HERE!", 2, 0
LaryTalk 4, 1
SLEEP
Center 1, "PREPARE TO DIE!", 2, 0
LaryTalk 4, 1
SLEEP
Center 1, "I WISH I HADN'T TRIPPED AND FELL ON", 2, 0
Center 2, "THE WAY HERE", 2, 0
LaryTalk 12, 1
SLEEP
Center 1, "NOW I'M BLEEDING", 2, 1
LaryTalk 4, 1
SLEEP
Center 1, "  ", 0, 0

sc1% = 1

END SUB

SUB Scene2

LINE (LaryX% - 4, LaryY%)-(LaryX% + 19, LaryY% + 15), 162, BF
PUT (LaryX%, 125), sprites%((eps% * 60) + 1), PSET

Delay 30
DO
LOOP UNTIL INKEY$ = ""

LaryY% = 125
Jump% = 0
jp% = 0

Center 1, "I'M GLAD I'M THROUGH THAT", 2, 1
LaryTalk 5, 1
SLEEP
Center 1, "WHO KNOWS WHAT'S NEXT?", 2, 0
LaryTalk 4, 1
SLEEP
Center 1, "  ", 0, 1

sc3% = 1

END SUB

SUB Scene3

LINE (LaryX% - 4, LaryY%)-(LaryX% + 19, LaryY% + 15), 162, BF
PUT (LaryX%, 125), sprites%((eps% * 60) + 1), PSET
PUT (250, 125), sprites%((eps% * 70) + 1), PSET

XenoX% = 250
LaryY% = 125
Jump% = 0
jp% = 0

Delay 10
DO
LOOP UNTIL INKEY$ = ""
Center 1, "XENOPHOBE!!!", 2, 1
LaryTalk 3, 1
SLEEP
Center 1, "WELL WELL WELL", 5, 0
XenoTalk 3, 2
SLEEP
Center 1, "WE FINALLY MEET", 5, 0
XenoTalk 5, 2
SLEEP
Center 1, "IF IT WEREN'T FOR YOU, I WOULD", 5, 0
Center 2, "HAVE THE WORLD TAKEN OVER BY NOW", 5, 0
XenoTalk 21, 2
SLEEP
Center 1, "YOU MUST DIE NOW", 5, 1
XenoTalk 4, 2
SLEEP
Center 1, "  ", 2, 0
LINE (0, 0)-(319, 80), 22, BF
sc4% = 1
Xeno% = 1

END SUB

SUB Scene4

PUT (XenoX%, 125), sprites%((eps% * 80) + 1), PSET

Delay 10
DO
LOOP UNTIL INKEY$ = ""

IF XenoX% < LaryX% THEN dj% = 1 ELSE dj% = 2

Center 1, "YOUR DOING GOOD", 5, 1
XenoTalk 4, dj%
SLEEP
Center 1, "NEVERTHELESS, YOU JUST A CHALLENGE", 5, 0
Center 2, "THAT I WILL DEFEAT", 5, 0
XenoTalk 14, dj%
SLEEP
Center 1, "  ", 0, 1
Delay 20

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
Center 1, "MASTER XOX SENT ME TO KILL YOU", 5, 0
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
PAINT (0, 0), 22, 162
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

SUB Xenod (Times%, Whichway%)

'***** Xenophobe talk when bloody *****

SELECT CASE Whichway%
CASE IS = 1
FOR xx% = 1 TO Times%
IF INKEY$ <> "" THEN EXIT FOR
FOR zz% = 0 TO 1
PUT (XenoX%, 125), sprites%((eps% * (80 + zz%)) + 1), PSET
Delay 2
NEXT zz%
Delay 2
NEXT xx%
PUT (XenoX%, 125), sprites%((eps% * 80) + 1), PSET
CASE IS = 2
FOR xx% = 1 TO Times%
IF INKEY$ <> "" THEN EXIT FOR
FOR zz% = 0 TO 1
PUT (XenoX%, 125), sprites%((eps% * (81 + zz%)) + 1), PSET
Delay 2
NEXT zz%
Delay 2
NEXT xx%
PUT (XenoX%, 125), sprites%((eps% * 80) + 1), PSET
END SELECT

END SUB

SUB XenoTalk (Times%, Whichway%)

'***** Xenophobe talk *****

SELECT CASE Whichway%
CASE IS = 1
FOR xx% = 1 TO Times%
IF INKEY$ <> "" THEN EXIT FOR
FOR zz% = 0 TO 1
PUT (XenoX%, 125), sprites%((eps% * (76 + zz%)) + 1), PSET
Delay 2
NEXT zz%
Delay 2
NEXT xx%
PUT (XenoX%, 125), sprites%((eps% * 70) + 1), PSET
CASE IS = 2
FOR xx% = 1 TO Times%
IF INKEY$ <> "" THEN EXIT FOR
FOR zz% = 0 TO 1
PUT (XenoX%, 125), sprites%((eps% * (71 + zz%)) + 1), PSET
Delay 2
NEXT zz%
Delay 2
NEXT xx%
PUT (XenoX%, 125), sprites%((eps% * 70) + 1), PSET
END SELECT

END SUB

