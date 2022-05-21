'====================================
'  DELTA CODE PRESENTS
' *****Larry The Dinosaur*****
' *****Episode 2********
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
DECLARE SUB DrawBackground2 ()
DECLARE SUB Intro ()
DECLARE SUB Scene2 ()
DECLARE SUB MattTalk (Times%)
DECLARE SUB Scene1 ()
DECLARE SUB LaryTalk (Times%, WhichWay%)
DECLARE SUB GaryTalk (Times%, WhichWay%)
DECLARE SUB Center (Row%, Text$, Color1%, Clear1%)
DECLARE SUB Title ()
DECLARE SUB DrawAmmo ()
DECLARE SUB DrawBackground ()
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
COMMON SHARED eps%, dt%, zz%, Speed&, GaryX%, rs%, rt%, rts%
COMMON SHARED sc1%, sc2%, sc3%, sc4%, sc5%, Level%, An%
COMMON SHARED Lives%, Continues%, BossX%, BossAn%, BossP%, BossLife%, ABossLife%
RANDOMIZE TIMER

CALL Notice

'CHDIR "c:\qb45\platform\larry"
SCREEN 13

CLS

CALL LoadPalette

' *****Load the sprites*****
FileName$ = "LARYB.PUT"
FileNo = FREEFILE
OPEN FileName$ FOR BINARY AS #FileNo
Ints = (LOF(FileNo) - 7) \ 2
CLOSE #FileNo
REDIM SHARED sprites%(1 TO Ints)
DEF SEG = VARSEG(sprites%(1))
BLOAD FileName$, 0
eps% = 138
DEF SEG


OPEN "LARYDATA.LRY" FOR INPUT AS #1
INPUT #1, Speed&, BSpeed&
CLOSE #1

' ***** Set the variables *****
' ***** Change the speed constant if it goes too slow or too fast*****

5

ABossLife% = 60
BossLife% = 60
Level% = 1
Lives% = 5
Continues% = 5

10
IF rts% = 1 THEN rts% = 0: cat% = 0: GOTO 5
jp% = 0: rs% = 0
Room% = 1: Position% = 1
LaryX% = 0: LaryY% = 124
IF Level% = 1 THEN Ammo% = 20
IF Level% = 2 THEN Ammo% = Ammo% + 10
IF Level% = 3 THEN Ammo% = 99
IF Level% = 4 THEN Ammo% = 99
IF cat% = 0 THEN CALL Title: cat% = 1
IF Level% = 1 THEN CALL DrawBackground
IF Level% = 2 THEN CALL DrawBackground2
IF Level% = 3 THEN CALL DrawBackGround3

' *****Start the game*****
100
IF Position% = 1 THEN LINE (LaryX% - 5, LaryY%)-(LaryX% - 1, LaryY% + 16), 132, BF
IF Position% = 2 THEN LINE (LaryX% + 16, LaryY%)-(LaryX% + 20, LaryY% + 16), 132, BF
IF Jump% = 1 OR Jump% = 3 THEN LINE (LaryX% - 5, LaryY% + 16)-(LaryX% + 20, LaryY% + 18), 132, BF
IF Jump% = 2 OR Jump% = 4 THEN LINE (LaryX% - 5, LaryY% - 1)-(LaryX% + 20, LaryY% - 2), 132, BF

IF Shoot% = 0 THEN
IF Position% = 1 THEN PUT (LaryX%, LaryY%), sprites%((eps% * An%) + 1), PSET
IF Position% = 2 THEN PUT (LaryX%, LaryY%), sprites%((eps% * (5 + An%)) + 1), PSET
ELSE
IF Position% = 1 THEN PUT (LaryX%, LaryY%), sprites%((eps% * sh%) + 1), PSET
IF Position% = 2 THEN PUT (LaryX%, LaryY%), sprites%((eps% * (4 + sh%)) + 1), PSET
END IF

DO
a% = INP(96)
Count% = Count% + 1
IF Count% > Speed& / 500 THEN Count% = 0: An% = 0: EXIT DO
LOOP UNTIL a% <> 170

MoveBadGuyX% = MoveBadGuyX% + 1
IF MoveBadGuyX% > BSpeed& / 200 THEN MoveBadGuyX% = 0: CALL MoveBadGuy

IF a% = &H4D THEN LaryX% = LaryX% + 4: Position% = 1: An% = An% + 1: Count% = 0
IF a% = &H4B THEN LaryX% = LaryX% - 4: Position% = 2: An% = An% + 1: Count% = 0
IF Jump% = 0 AND a% = &H38 THEN Jump% = 1: ct% = 0
IF Ammo% > 0 AND Shoot% = 0 AND a% = &H1D THEN nt% = 0: Shoot% = 1: sh% = 10: An% = 0: Ammo% = Ammo% - 1: CALL DrawAmmo
IF a% = 1 THEN END

IF An% > 4 THEN An% = 1
IF Jump% = 4 THEN Jump% = 0

IF Room% = 1 AND LaryX% < 0 THEN LaryX% = 0
IF Level% = 1 AND LaryX% > 304 THEN Room% = Room% + 1: CALL DrawBackground: LaryX% = 0
IF Level% = 1 AND LaryX% < 0 THEN Room% = Room% - 1: CALL DrawBackground: LaryX% = 304
IF Level% = 2 AND LaryX% > 304 THEN Room% = Room% + 1: CALL DrawBackground2: LaryX% = 0
IF Level% = 2 AND LaryX% < 0 THEN Room% = Room% - 1: CALL DrawBackground2: LaryX% = 304
IF Level% = 3 AND LaryX% > 250 THEN LaryX% = 250
IF sc1% = 0 AND Level% = 1 AND Room% = 3 AND LaryX% > 100 THEN CALL Scene1
IF sc2% = 0 AND Level% = 1 AND Room% = 4 THEN CALL Scene2
IF sc3% = 0 AND Level% = 1 AND Room% = 6 AND LaryX% > 200 THEN CALL Scene3: dt% = 6: CALL Dead: rs% = 1
IF sc4% = 0 AND Level% = 2 AND Room% = 6 AND LaryX% > 200 THEN CALL Scene4: dt% = 6: CALL Dead: rs% = 1
IF Level% = 2 AND Room% = 4 AND kk% = 0 AND LaryX% > 100 THEN
RockGuy%(1) = 0
RockGuy%(2) = 30
RockGuy%(3) = 250
RockGuy%(4) = 300
Blob%(1) = 50
Blob%(2) = 200
RockLife%(1) = 3
RockLife%(2) = 3
RockLife%(3) = 3
RockLife%(4) = 3
RockN% = 4
BlobN% = 2
kk% = 1
END IF
IF Level% = 2 AND Room% = 5 AND jj% = 0 AND LaryX% > 50 THEN
RockGuy%(1) = 0
RockGuy%(2) = 304
RockLife%(1) = 3
RockLife%(2) = 3
Jelly%(1) = 20
Jelly%(2) = 250
JellyLife%(1) = 8
JellyLife%(2) = 8
RockN% = 2
JellyN% = 2
jj% = 1
END IF
IF rs% = 0 AND sc5% = 0 AND Level% = 3 THEN CALL Scene5: sc5% = 1

DO
LOOP UNTIL INKEY$ = ""
Delay 1

IF rs% = 1 THEN rs% = 0: GOTO 10
GOSUB CheckSpike
IF Jump% = 0 THEN IF An% = 1 OR An% = 3 THEN SOUND 40, .5
IF rs% = 1 THEN GOTO 10
IF Level% = 3 THEN GOSUB MoveBoss
IF Jump% <> 0 THEN GOSUB Jump
IF Shoot% = 1 THEN GOSUB Shoot1

IF rt% = 1 THEN
rt% = 0: Lives% = Lives% - 1
IF Lives% = 0 THEN CALL Continue
LaryX% = 0: LaryY% = 124: Jump% = 0: ct% = 0: jp% = 0
IF Ammo% < 10 THEN Ammo% = 10
Center 1, "LIVES =" + STR$(Lives%), 15, 1
SLEEP
Center 1, "  ", 0, 1
IF Level% = 1 THEN CALL DrawBackground
IF Level% = 2 THEN CALL DrawBackground2
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
PUT (Spike%(zz%), 124), sprites%((eps% * 51) + 1), PSET
IF POINT(LaryX% + 15, LaryY% + 16) = 164 OR POINT(LaryX% + 15, LaryY% + 16) = 163 OR POINT(LaryX% + 7, LaryY% + 16) = 164 OR POINT(LaryX% + 7, LaryY% + 16) = 163 OR POINT(LaryX%, LaryY% + 16) = 164 OR POINT(LaryX%, LaryY% + 16) = 163 THEN
LINE (LaryX% - 4, LaryY% - 5)-(LaryX% + 19, LaryY% + 16), 132, BF
IF Spike%(zz%) - 12 < LaryX% AND Spike%(zz%) + 12 > LaryX% THEN
PUT (Spike%(zz%), 124), sprites%((eps% * 52) + 1), PSET
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
IF bh% > Speed& / Speed& THEN bh% = 0: sh% = sh% + 1
IF sh% > 13 THEN sh% = 0: Shoot% = 0
SOUND 40, .5
IF nt% = 0 AND sh% = 11 THEN
IF Position% = 1 THEN
FOR xx% = LaryX% TO LaryX% + 320
IF POINT(xx%, LaryY% + 8) = 24 THEN
FOR cc% = 1 TO RockN%
IF RockGuy%(cc%) < xx% + 5 AND RockGuy%(cc%) > xx% - 16 THEN
PUT (RockGuy%(cc%), 124), sprites%((eps% * 28) + 1), PSET: Delay 1
RockLife%(cc%) = RockLife%(cc%) - 1
IF RockLife%(cc%) < 1 THEN PUT (RockGuy%(cc%), 124), sprites%((eps% * 29) + 1), PSET: Delay 2: LINE (RockGuy%(cc%), 124)-(RockGuy%(cc%) + 16, 140), 132, BF
gt% = 1
END IF
NEXT cc%
END IF

IF POINT(xx%, LaryY% + 8) = 195 OR POINT(xx%, LaryY% + 8) = 196 THEN
FOR cc% = 1 TO JellyN%
IF Jelly%(cc%) < xx% + 5 AND Jelly%(cc%) > xx% - 16 THEN
PUT (Jelly%(cc%), 124), sprites%((eps% * 39) + 1), PSET: Delay 1
JellyLife%(cc%) = JellyLife%(cc%) - 1
IF JellyLife%(cc%) < 1 THEN PUT (Jelly%(cc%), 124), sprites%((eps% * 40) + 1), PSET: Delay 2: LINE (Jelly%(cc%), 124)-(Jelly%(cc%) + 16, 140), 132, BF
gt% = 1
END IF
NEXT cc%
END IF


IF POINT(xx%, LaryY% + 8) = 164 AND Level% = 3 THEN
PUT (BossX%, 124), sprites%((eps% * 81) + 1), PSET
BossLife% = BossLife% - 1
ABossLife% = ABossLife% - 2
CALL CheckBoss
Delay 1
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
PUT (RockGuy%(cc%), 124), sprites%((eps% * 26) + 1), PSET: Delay 1
RockLife%(cc%) = RockLife%(cc%) - 1
IF RockLife%(cc%) < 1 THEN PUT (RockGuy%(cc%), 124), sprites%((eps% * 27) + 1), PSET: Delay 2: LINE (RockGuy%(cc%), 124)-(RockGuy%(cc%) + 16, 140), 132, BF
st% = 1
END IF
NEXT cc%
END IF

IF POINT(xx%, LaryY% + 8) = 195 OR POINT(xx%, LaryY% + 8) = 196 THEN
FOR cc% = 1 TO JellyN%
IF Jelly%(cc%) < xx% + 5 AND Jelly%(cc%) > xx% - 16 THEN
PUT (Jelly%(cc%), 124), sprites%((eps% * 39) + 1), PSET: Delay 1
JellyLife%(cc%) = JellyLife%(cc%) - 1
IF JellyLife%(cc%) < 1 THEN PUT (Jelly%(cc%), 124), sprites%((eps% * 40) + 1), PSET: Delay 2: LINE (Jelly%(cc%), 124)-(Jelly%(cc%) + 16, 140), 132, BF
st% = 1
END IF
NEXT cc%
END IF

IF POINT(xx%, LaryY% + 8) = 164 AND Level% = 3 THEN
PUT (BossX%, 124), sprites%((eps% * 82) + 1), PSET
BossLife% = BossLife% - 1
ABossLife% = ABossLife% - 2
CALL CheckBoss
Delay 1
st% = 1
END IF

IF st% = 1 THEN EXIT FOR
NEXT xx%
END IF
nt% = 1
END IF
RETURN


' ***** Move the boss *****

MoveBoss:
IF BossLife% < 1 THEN CALL BossExplode
hs% = BossLife% * 2
IF hs% < 30 THEN hs% = 30
bsh% = bsh% + 1
IF bsh% > hs% AND BossX% > 50 THEN bsh% = 0: BossShoot% = 1
IF BossLife% > 30 THEN bm% = 4
IF BossLife% > 20 AND BossLife% < 30 THEN bm% = 6
IF BossLife% > 10 AND BossLife% < 20 THEN bm% = 7
IF BossLife% > 0 AND BossLife% < 10 THEN bm% = 8
IF BossShoot% = 0 THEN
BossM% = BossM% + 1
IF BossM% > 2 THEN
BossM% = 0
BossAn% = BossAn% + 1
IF BossX% < LaryX% THEN BossX% = BossX% + bm%: BossP% = 1
IF BossX% > LaryX% THEN BossX% = BossX% - bm%: BossP% = 2
END IF
IF BossAn% > 2 THEN BossAn% = 1
IF BossP% = 1 THEN LINE (BossX% - 10, 124)-(BossX%, 140), 132, BF: PUT (BossX%, 124), sprites%((eps% * (77 + BossAn%)) + 1), PSET
IF BossP% = 2 THEN LINE (BossX% + 16, 124)-(BossX% + 26, 140), 132, BF: PUT (BossX%, 124), sprites%((eps% * (75 + BossAn%)) + 1), PSET
ELSE
GOSUB BossShoot1
END IF
FOR zz% = 1 TO 15
IF POINT(LaryX% + 15, LaryY% + zz%) = 164 OR POINT(LaryX% + 7, LaryY% + zz%) = 164 OR POINT(LaryX%, LaryY% + zz%) = 164 THEN
FOR sz% = 1 TO 20
CIRCLE (LaryX% + 7, LaryY% + 7), sz%, 4
SOUND 40, .1
NEXT sz%
rt% = 1: IF BossX% < 80 THEN BossX% = 80
EXIT FOR
END IF
NEXT zz%
RETURN


' ***** Boss shoot *****

BossShoot1:
IF BossP% = 1 THEN LINE (BossX% - 4, 124)-(BossX%, 140), 132, BF: PUT (BossX%, 124), sprites%((eps% * (75)) + 1), PSET
IF BossP% = 2 THEN LINE (BossX% - 4, 124)-(BossX%, 140), 132, BF: PUT (BossX%, 124), sprites%((eps% * (74)) + 1), PSET
IF BossP% = 1 THEN PUT (BossX% + (16 + sk%), 124), sprites%((eps% * 80) + 1), PSET
IF BossP% = 2 THEN PUT (BossX% - (16 - sk%), 124), sprites%((eps% * 80) + 1), PSET
IF BossP% = 1 THEN sk% = sk% + 4
IF BossP% = 2 THEN sk% = sk% - 4
IF BossP% = 1 THEN IF BossX% + sk% > 240 THEN LINE (BossX% + (12 + sk%), 124)-(BossX% + (28 + sk%), 140), 132, BF: sk% = 0: BossShoot% = 0: bsh% = 0
IF BossP% = 2 THEN IF BossX% + sk% < 16 THEN LINE (BossX% - (20 - sk%), 124)-(BossX% - (1 - sk%), 140), 132, BF: sk% = 0: BossShoot% = 0: bsh% = 0

FOR zz% = 1 TO 15
IF Position% = 1 AND POINT(LaryX% + 16, LaryY% + zz%) = 24 THEN LINE (LaryX% - 4, LaryY% - 4)-(LaryX% + 20, LaryY% + 15), 132, BF: PUT (LaryX%, 124), sprites%((eps% * 83) + 1), PSET: Delay 10: rt% = 1: BossShoot% = 0: sk% = 0: bsh% = 0
IF Position% = 2 AND POINT(LaryX% - 1, LaryY% + zz%) = 24 THEN LINE (LaryX% - 4, LaryY% - 4)-(LaryX% + 20, LaryY% + 15), 132, BF: PUT (LaryX%, 124), sprites%((eps% * 84) + 1), PSET: Delay 10: rt% = 1: BossShoot% = 0: sk% = 0: bsh% = 0
NEXT zz%

RETURN

SUB BossExplode

ABossLife% = 20
CALL CheckBoss

LINE (LaryX% - 4, LaryY%)-(LaryX% + 19, LaryY% + 15), 132, BF
PUT (LaryX%, 124), sprites%((eps * 0) + 1), PSET
LINE (BossX%, 124)-(BossX%, 140), 132, BF
PUT (BossX%, 124), sprites%((eps% * 72) + 1), PSET
Delay 20

FOR zz% = 85 TO 111
PUT (BossX%, 124), sprites%((eps% * zz%) + 1), PSET
Delay 5
NEXT zz%

LINE (BossX%, 124)-(BossX% + 15, 140), 132, BF

Delay 50

Center 1, "WOW", 7, 1
GaryTalk 1, 2
SLEEP
Center 1, "THAT WAS SOME NICE SHOOTING", 7, 0
GaryTalk 6, 2
SLEEP
Center 1, "WELL", 2, 0
LaryTalk 1, 1
SLEEP
Center 1, "YOU BETTER FEEL LUCKY THAT YOUR STILL", 2, 0
Center 2, "ALIVE", 2, 0
LaryTalk 11, 1
SLEEP
Center 1, "WHAT?!", 7, 1
GaryTalk 1, 2
SLEEP
Center 1, "WHY DO YOU HAVE TO BE SO MEAN!?", 7, 0
GaryTalk 8, 2
SLEEP
Center 1, "I'M NOT!", 2, 0
LaryTalk 2, 1
SLEEP
Center 1, "I'M TRYING TO SAVE YOUR LIFE BY", 2, 0
Center 2, "TELLING YOU TO GET OUT OF HERE!", 2, 0
LaryTalk 16, 1
SLEEP
Center 1, "DO YOU WANT TO BE EATEN UP LIKE MATT!?", 2, 1
LaryTalk 10, 1
SLEEP
Center 1, "...", 7, 1
GaryTalk 1, 2
SLEEP
Center 1, "WELL DO YOU!?", 2, 0
LaryTalk 3, 1
SLEEP
Center 1, "NO", 7, 0
GaryTalk 1, 2
SLEEP
Center 1, "THEN YOU SHOULD LEAVE THIS PLACE", 2, 0
LaryTalk 6, 1
SLEEP
Center 1, "GO BACK TO YOUR HOME, YOUR FAMILY,", 2, 0
Center 2, "YOUR FRIENDS", 2, 0
LaryTalk 11, 1
SLEEP
Center 1, "WHO KNOWS WHAT MATT'S FAMILY WILL GO", 2, 1
Center 2, "THROUGH WHEN THEY FIND OUT THAT HE'S", 2, 0
LaryTalk 16, 1
SLEEP
Center 1, "DEAD", 2, 1
LaryTalk 1, 1
SLEEP
Center 1, "GO NOW", 2, 0
LaryTalk 2, 1
SLEEP
Center 1, "YOU STILL HAVE YOUR WHOLE LIFE AHEAD", 2, 0
Center 2, "OF YOU", 2, 0
LaryTalk 10, 1
SLEEP
Center 1, "AND WHAT ABOUT YOUR LIFE!?", 7, 1
GaryTalk 6, 2
SLEEP
Center 1, "WHAT ABOUT YOUR FAMILY, YOUR FREINDS!?", 7, 0
GaryTalk 9, 2
SLEEP
Center 1, "THAT'S NONE OF YOUR BUSINESS!", 2, 0
LaryTalk 6, 1
SLEEP
Center 1, "WHY ISN'T IT?", 7, 0
GaryTalk 4, 2
SLEEP
Center 1, "ALL RIGHT! YOU WANNA KNOW?", 2, 0
LaryTalk 6, 1
SLEEP
Center 1, "YEA", 7, 0
GaryTalk 1, 2
SLEEP
Center 1, "THEY'RE DEAD", 2, 0
LaryTalk 2, 1
SLEEP
Center 1, "I HAVE NOTHING TO LOOSE, THAT'S WHY", 2, 0
Center 2, "I'M THE PERFECT GUY FOR THIS MISSION", 2, 0
LaryTalk 17, 1
SLEEP
Center 1, "THIS IS MAINLY A SUICIDE MISSION", 2, 1
LaryTalk 10, 1
SLEEP
Center 1, "I'LL BE LUCKY IF I SURVIVE", 2, 0
LaryTalk 8, 1
SLEEP
Center 1, "OH...", 7, 1
GaryTalk 1, 2
SLEEP
Center 1, "I SEE", 7, 0
GaryTalk 2, 2
SLEEP
Center 1, "I BETTER LEAVE THEN", 7, 1
GaryTalk 5, 2
SLEEP
Center 1, "SEE YA LATER STEVE", 2, 0
LaryTalk 4, 1
SLEEP
Center 1, "  ", 0, 0

dt% = 6
CALL Dead

END SUB

SUB BossTalk (Times%)

FOR xx% = 1 TO Times%
IF INKEY$ <> "" THEN EXIT FOR
FOR zz% = 0 TO 1
PUT (100, 124), sprites%((eps% * (71 + zz%)) + 1), PSET
Delay 2
NEXT zz%
Delay 2
NEXT xx%
PUT (100, 124), sprites%((eps% * 70) + 1), PSET

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

' ***** Paint the spot on the boss' life bar when he gets shot *****

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
IF Level% = 4 THEN rts% = 1: rs% = 1
Room% = 1
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

LINE (2, 180)-(100, 190), 134, BF

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

SUB DrawBackground

' ***** Draw background *****

CLS

LINE (0, 80)-(319, 89), 133, BF
LINE (0, 90)-(319, 140), 132, BF
LINE (0, 141)-(319, 141), 6
DRAW "r5 d15 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10"
PAINT (10, 150), 6, 6
PAINT (10, 180), 134, 6

PAINT (0, 0), 72, 133

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

DRAW "bm0,30 c129 r50 d30 r20 u50 r210 d30 r40 d39 l321 "
LINE (10, 40)-(40, 60), 129, BF
LINE (80, 20)-(120, 40), 129, BF
LINE (130, 20)-(170, 40), 129, BF
LINE (180, 20)-(220, 40), 129, BF
LINE (230, 20)-(270, 40), 129, BF
LINE (80, 50)-(120, 70), 129, BF
LINE (130, 50)-(170, 70), 129, BF
LINE (180, 50)-(220, 70), 129, BF
LINE (230, 50)-(270, 70), 129, BF
PAINT (5, 50), 132, 129

Spike%(1) = 250
Spike%(2) = 266
RockGuy%(1) = 152
RockLife%(1) = 4
SpikeN% = 2
RockN% = 1

CASE IS = 2

DRAW "bm0,40 c129 r45 u30 r200 d40 r75 d29 l320"

LINE (60, 20)-(80, 50), 129, BF
LINE (90, 20)-(110, 50), 129, BF
LINE (120, 20)-(140, 50), 129, BF
LINE (150, 20)-(170, 50), 129, BF
LINE (180, 20)-(200, 50), 129, BF
LINE (210, 20)-(230, 50), 129, BF
LINE (60, 60)-(80, 78), 129, BF
LINE (90, 60)-(110, 78), 129, BF
LINE (120, 60)-(140, 78), 129, BF
LINE (150, 60)-(170, 78), 129, BF
LINE (180, 60)-(200, 78), 129, BF
LINE (210, 60)-(230, 78), 129, BF

PAINT (10, 50), 132, 129

Spike%(1) = 110
Spike%(2) = 126
Spike%(3) = 174
Spike%(4) = 190
Plant%(1) = 230
Plant%(2) = 270
Blob%(1) = 80
SpikeN% = 4
PlantN% = 2
BlobN% = 1

CASE IS = 3

DRAW "bm0,50 c129 r320 d29 l320"

LINE (10, 60)-(30, 78), 129, BF
LINE (50, 60)-(70, 78), 129, BF
LINE (90, 60)-(110, 78), 129, BF
LINE (130, 60)-(150, 78), 129, BF
LINE (170, 60)-(190, 78), 129, BF
LINE (210, 60)-(230, 78), 129, BF
LINE (250, 60)-(270, 78), 129, BF
LINE (290, 60)-(310, 78), 129, BF

PAINT (5, 60), 132, 129

CASE IS = 4

DRAW "bm0,50 c129 r320 d29 l320"

LINE (10, 60)-(30, 78), 129, BF
LINE (50, 60)-(70, 78), 129, BF
LINE (90, 60)-(110, 78), 129, BF
LINE (130, 60)-(150, 78), 129, BF
LINE (170, 60)-(190, 78), 129, BF
LINE (210, 60)-(230, 78), 129, BF
LINE (250, 60)-(270, 78), 129, BF
LINE (290, 60)-(310, 78), 129, BF

PAINT (5, 60), 132, 129

Spike%(1) = 160
Plant%(1) = 228
Plant%(2) = 260
Plant%(3) = 276
SpikeN% = 1
PlantN% = 3

CASE IS = 5

DRAW "bm0,50 c129 r50 u30 r20 u20 r110 d30 r50 d20 r50 u30 r40 d59 l320"

LINE (10, 60)-(30, 78), 129, BF
LINE (50, 60)-(70, 78), 129, BF
LINE (90, 60)-(110, 78), 129, BF
LINE (130, 60)-(150, 78), 129, BF
LINE (170, 60)-(190, 78), 129, BF
LINE (210, 60)-(230, 78), 129, BF
LINE (250, 60)-(270, 78), 129, BF
LINE (290, 60)-(310, 78), 129, BF
LINE (55, 25)-(65, 50), 129, BF
LINE (75, 25)-(85, 50), 129, BF
LINE (95, 25)-(105, 50), 129, BF
LINE (115, 25)-(125, 50), 129, BF
LINE (135, 25)-(145, 50), 129, BF
LINE (155, 25)-(165, 50), 129, BF
LINE (180, 35)-(220, 50), 129, BF
LINE (290, 30)-(310, 50), 129, BF

PAINT (5, 60), 132, 129

Jelly%(1) = 140
Jelly%(2) = 200
Jelly%(3) = 260
Spike%(1) = 160
Spike%(2) = 290
Plant%(1) = 80
JellyLife%(1) = 8
JellyLife%(2) = 8
JellyLife%(3) = 8
SpikeN% = 2
PlantN% = 1
JellyN% = 3

CASE IS = 6

DRAW "bm0,20 c129 r130 g10 f10 g10 f10 g10 f9 l130"

LINE (10, 60)-(30, 78), 129, BF
LINE (50, 60)-(70, 78), 129, BF
LINE (90, 60)-(110, 78), 129, BF
LINE (10, 30)-(30, 50), 129, BF
LINE (50, 30)-(70, 50), 129, BF
LINE (90, 30)-(110, 50), 129, BF

PAINT (5, 60), 132, 129

LINE (170, 79)-(260, 0), 76
LINE (190, 79)-(290, 0), 76
LINE (170, 79)-(190, 79), 76

PAINT (175, 75), 86, 76

LINE (220, 79)-(320, 0), 76
LINE (190, 79)-(220, 79), 76

PAINT (224, 75), 42, 76

LINE (220, 79)-(320, 79), 76

PAINT (310, 75), 41, 76

DRAW "bm250,79 c131 e5 u20 r10 d15 f10 l25 r25 e15 u40 r10 d40 f15 l50"
PAINT (255, 75), 131, 131
PAINT (310, 75), 131, 131

END SELECT

CALL DrawAmmo

END SUB

SUB DrawBackground2

' ***** Draw background *****

CLS

LINE (0, 80)-(319, 89), 133, BF
LINE (0, 90)-(319, 140), 132, BF
LINE (0, 141)-(319, 141), 6
DRAW "r5 d15 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10"
PAINT (10, 150), 6, 6
PAINT (10, 180), 134, 6

PAINT (0, 0), 41, 133

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

DRAW "bm5,79 c131 e5 u50 r10 d40 f15 l30  br40 e20 u50 r20 d50 f20 l60 br50 bu12 e15 u30 r5 d30 f20 g7 l30 br30 e70 u10 r20 d20 f60 l150 br160 e20 u40 r10 d40 f20 l50"

PAINT (15, 60), 131, 131
PAINT (80, 60), 131, 131
PAINT (110, 60), 130, 131
PAINT (200, 50), 131, 131
PAINT (310, 60), 131, 131

Blob%(1) = 100
RockGuy%(1) = 200
RockGuy%(2) = 250
RockLife%(1) = 3
RockLife%(2) = 4
RockN% = 2
BlobN% = 1

CASE IS = 2

DRAW "bm0,60 c131 f19 l20 br40 e10 u40 r10 d40 f10 l30 br30 e20 u60 r15 d50 f30 l70 br80 e50 u20 r60 d20 f50 l160 bm280,60 e50 d69 l50"

PAINT (5, 70), 131, 131
PAINT (50, 70), 130, 131
PAINT (80, 70), 131, 131
PAINT (200, 60), 131, 131
PAINT (310, 50), 130, 131

Plant%(1) = 50
Plant%(2) = 100
Plant%(3) = 150
Plant%(4) = 200
Plant%(5) = 250
RockGuy%(1) = 225
RockLife%(1) = 3
RockN% = 1
PlantN% = 5

CASE IS = 3

DRAW "bm0,20 c 131 r50 f59 l110 br110 e20 u50 r20 d50 f20 l60 br65 e20 u70 r100 d70 f20 l150 br130 bu20 e30 d50 l20"

PAINT (10, 70), 130, 131
PAINT (120, 70), 129, 131
PAINT (200, 60), 131, 131
PAINT (300, 60), 130, 131

RockGuy%(1) = 20
RockLife%(1) = 3
Spike%(1) = 150
Spike%(2) = 166
Spike%(3) = 182
Spike%(4) = 230
Spike%(5) = 246
RockN% = 1
SpikeN% = 4

CASE IS = 4

DRAW "bm0,30 c131 e5 u20 r10 d20 f40 g14 l50 r50 e30 u30 r20 d30 f30 l100 br105 e40 r50 f40 l130 br140 e20 u50 r10 d40 f30 l60"

PAINT (10, 60), 130, 131
PAINT (60, 70), 131, 131
PAINT (200, 70), 131, 131
PAINT (300, 60), 131, 131

Plant%(1) = 100
Plant%(2) = 200
PlantN% = 2

CASE IS = 5

DRAW "bm0,70 c131 f9 l10 br4 bu6 e50 u20 r10 d20 f30 r50 f26 l200 br280 e10 u60 r5 d60 f10 l25"

PAINT (4, 75), 131, 131
PAINT (80, 50), 130, 131
PAINT (260, 75), 131, 131

CASE IS = 6

DRAW "bm20,79 c131 e15 u40 r10 d40 f15 l40 br50 e10 u50 r5 d45 f15 l30 br60 c129 u50 r100 u20 r100 d70 l200"

LINE (140, 40)-(180, 50), 129, BF
LINE (190, 40)-(230, 50), 129, BF
LINE (140, 60)-(180, 70), 129, BF
LINE (190, 60)-(230, 70), 129, BF
LINE (240, 20)-(260, 50), 129, BF
LINE (270, 20)-(290, 50), 129, BF
LINE (300, 20)-(320, 50), 129, BF
LINE (240, 60)-(260, 79), 129, BF
LINE (270, 60)-(290, 79), 129, BF
LINE (300, 60)-(320, 79), 129, BF
PAINT (290, 55), 132, 129
PAINT (50, 70), 131, 131
PAINT (90, 70), 130, 131

END SELECT

CALL DrawAmmo

END SUB

SUB DrawBackGround3

' ***** Draw background *****

CLS

LINE (0, 80)-(319, 89), 133, BF
LINE (0, 90)-(319, 140), 132, BF
LINE (0, 141)-(319, 141), 6
DRAW "r5 d15 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10 u5 l10 d5 l10"
PAINT (10, 150), 6, 6
PAINT (10, 180), 134, 6

PAINT (0, 0), 41, 133

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

DRAW "bm0,10 c129 r200 d50 r50 u30 r70 d49 l320"

LINE (10, 20)-(30, 50), 129, BF
LINE (40, 20)-(60, 50), 129, BF
LINE (70, 20)-(90, 50), 129, BF
LINE (100, 20)-(120, 50), 129, BF
LINE (130, 20)-(150, 50), 129, BF
LINE (160, 20)-(180, 50), 129, BF
LINE (10, 60)-(30, 79), 129, BF
LINE (40, 60)-(60, 79), 129, BF
LINE (70, 60)-(90, 79), 129, BF
LINE (100, 60)-(120, 79), 129, BF
LINE (130, 60)-(150, 79), 129, BF
LINE (160, 60)-(180, 79), 129, BF
LINE (260, 40)-(310, 50), 129, BF
LINE (260, 60)-(310, 70), 129, BF
PAINT (5, 60), 132, 129

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

PUT (280, 124), sprites%((eps% * 57) + 1), PSET

CALL DrawAmmo

END SUB

SUB DrawBackground4

' ***** Draw background *****

CLS
DRAW "bm0,140 c132 r319"
DRAW "bm319,140 c164 bd10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10 g10 h10"
DRAW "bu9 r320"
PAINT (150, 105), 132, 132
PAINT (150, 150), 164, 164
PAINT (150, 190), 6, 164

LINE (0, 141)-(150, 146), 7, BF
LINE (0, 147)-(150, 199), 132, BF

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
PUT (GaryX%, 124), sprites%((eps% * (55 + zz%)) + 1), PSET
Delay 2
NEXT zz%
Delay 2
NEXT xx%
PUT (GaryX%, 124), sprites%((eps% * 55) + 1), PSET
CASE IS = 2
FOR xx% = 1 TO Times%
IF INKEY$ <> "" THEN EXIT FOR
FOR zz% = 0 TO 1
PUT (GaryX%, 124), sprites%((eps% * (58 + zz%)) + 1), PSET
Delay 2
NEXT zz%
Delay 2
NEXT xx%
PUT (GaryX%, 124), sprites%((eps% * 58) + 1), PSET
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
PUT (LaryX%, 124), sprites%((eps% * (60 + zz%)) + 1), PSET
Delay 2
NEXT zz%
Delay 2
NEXT xx%
PUT (LaryX%, 124), sprites%((eps% * 60) + 1), PSET
CASE IS = 2
FOR xx% = 1 TO Times%
IF INKEY$ <> "" THEN EXIT FOR
FOR zz% = 0 TO 1
PUT (LaryX%, 124), sprites%((eps% * (62 + zz%)) + 1), PSET
Delay 2
NEXT zz%
Delay 2
NEXT xx%
PUT (LaryX%, 124), sprites%((eps% * 62) + 1), PSET
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
PUT (GaryX%, 124), sprites%((eps% * (65 + zz%)) + 1), PSET
Delay 2
NEXT zz%
Delay 2
NEXT xx%
PUT (GaryX%, 124), sprites%((eps% * 65) + 1), PSET


END SUB

SUB MoveBadGuy

' ***** Move the badguy *****

RockAn% = RockAn% + 1
IF RockAn% > 3 THEN RockAn% = 0

FOR zz% = 1 TO RockN%
IF RockLife%(zz%) > 0 THEN
IF (RockGuy%(zz%) + 8) > LaryX% THEN
LINE (RockGuy%(zz%) + 13, 124)-(RockGuy%(zz%) + 16, 140), 132, BF
RockGuy%(zz%) = RockGuy%(zz%) - 3
IF RockGuy%(zz%) < 0 THEN RockGuy%(zz%) = 0
PUT (RockGuy%(zz%), 124), sprites%((eps% * (22 + RockAn%)) + 1), PSET
IF POINT(LaryX% + 15, LaryY% + 16) = 24 OR POINT(LaryX% + 6, LaryY% + 16) = 24 OR POINT(LaryX% + 15, LaryY% + 10) = 24 THEN
FOR xx% = 1 TO 10
LINE (LaryX%, LaryY%)-(LaryX% + 15, LaryY% + 16), 132, BF
en% = en% + 1
IF en% > 2 THEN en% = 1
PUT (RockGuy%(zz%), 124), sprites%(eps% * (31 + en%) + 1), PSET
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
LINE (RockGuy%(zz%) - 3, 124)-(RockGuy%(zz%), 140), 132, BF
PUT (RockGuy%(zz%), 124), sprites%((eps% * (18 + RockAn%)) + 1), PSET
IF POINT(LaryX%, LaryY% + 16) = 24 OR POINT(LaryX% + 6, LaryY% + 16) = 24 OR POINT(LaryX%, LaryY% + 10) = 24 THEN
FOR xx% = 1 TO 10
LINE (LaryX%, LaryY%)-(LaryX% + 15, LaryY% + 16), 132, BF
en% = en% + 1
IF en% > 2 THEN en% = 1
PUT (RockGuy%(zz%), 124), sprites%(eps% * (29 + en%) + 1), PSET
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
IF Blob%(zz%) > LaryX% THEN LINE (Blob%(zz%) + 16, 124)-(Blob%(zz%) + 2, 140), 132, BF
IF Blob%(zz%) < LaryX% THEN LINE (Blob%(zz%) - 2, 124)-(Blob%(zz%) + 1, 140), 132, BF
IF Blob%(zz%) > LaryX% THEN Blob%(zz%) = Blob%(zz%) - 2
IF Blob%(zz%) < LaryX% THEN Blob%(zz%) = Blob%(zz%) + 2
IF Blob%(zz%) < 0 THEN Blob%(zz%) = 0
IF Blob%(zz%) > 304 THEN Blob%(zz%) = 304
PUT (Blob%(zz%), 124), sprites%((eps% * (34 + BlobAn%)) + 1), PSET

IF POINT(LaryX% + 15, LaryY% + 16) = 196 OR POINT(LaryX%, LaryY% + 16) = 196 OR POINT(LaryX% + 7, LaryY% + 16) = 196 THEN CALL LaryExplode

NEXT zz%


' ***** Animate the Venus Dinosaur Trap *****

PlantAn% = PlantAn% + 1
IF PlantAn% > 5 THEN PlantAn% = 1

FOR zz% = 1 TO PlantN%
PUT (Plant%(zz%), 124), sprites%((eps% * (43 + PlantAn%) + 1)), PSET
IF POINT(LaryX% + 15, LaryY% + 16) = 164 OR POINT(LaryX% + 7, LaryY% + 16) = 164 OR POINT(LaryX%, LaryY% + 16) = 164 OR POINT(LaryX% + 15, LaryY% + 7) = 161 OR POINT(LaryX%, LaryY% + 7) = 161 THEN
LINE (LaryX%, LaryY%)-(LaryX% + 15, LaryY% + 16), 132, BF
FOR xx% = 1 TO 10
IF xx% > 0 AND xx% < 10 THEN sd% = INT(RND * (900)) + 40
IF xx% > 9 AND xx% < 20 THEN sd% = INT(RND * (1300)) + 500
IF xx% > 19 AND xx% < 30 THEN sd% = INT(RND * (1800)) + 900
IF xx% > 29 THEN sd% = INT(RND * (2300)) + 1200
PUT (Plant%(zz%), 124), sprites%((eps% * (49 + ll%)) + 1), PSET
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
LINE (Jelly%(zz%) - 2, 124)-(Jelly%(zz%) + 1, 140), 132, BF
LINE (Jelly%(zz%) + 14, 124)-(Jelly%(zz%) + 17, 140), 132, BF
IF Jelly%(zz%) < LaryX% THEN Jelly%(zz%) = Jelly%(zz%) + 2
IF Jelly%(zz%) > LaryX% THEN Jelly%(zz%) = Jelly%(zz%) - 2
IF Jelly%(zz%) < 0 THEN Jelly%(zz%) = 0
IF Jelly%(zz%) > 304 THEN Jelly%(zz%) = 304
PUT (Jelly%(zz%), 124), sprites%((eps% * (36 + JellyAn%)) + 1), PSET
IF POINT(LaryX% + 15, LaryY% + 16) = 195 OR POINT(LaryX% + 15, LaryY% + 16) = 196 OR POINT(LaryX% + 7, LaryY% + 16) = 195 OR POINT(LaryX% + 7, LaryY% + 16) = 196 OR POINT(LaryX%, LaryY% = 15) = 195 OR POINT(LaryX%, LaryY% + 16) = 196 THEN
LINE (LaryX%, LaryY%)-(LaryX% + 15, LaryY% + 16), 132, BF
IF Jelly%(zz%) - 4 < LaryX% AND Jelly%(zz%) + 20 > LaryX% THEN
FOR xx% = 1 TO 10
sd% = INT(RND * (200)) + 40
PUT (Jelly%(zz%), 124), sprites%((eps% * (41 + yy%)) + 1), PSET
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
LINE (LaryX%, LaryY%)-(LaryX% + 15, LaryY% + 16), 132, BF
FOR xx% = 1 TO 10
sd% = INT(RND * (200)) + 40
PUT (Jelly%(zz%), 124), sprites%((eps% * (41 + yy%)) + 1), PSET
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

END SUB

SUB Notice

SCREEN 0
COLOR 15, 1
CLS
PRINT "LARRY THE DINOSAUR"
PRINT "EPISODE 2"
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

LINE (LaryX% - 4, LaryY%)-(LaryX% + 19, LaryY% + 16), 132, BF

PUT (LaryX%, 124), sprites%((eps% * 0) + 1), PSET

LaryY% = 124
GaryX% = 0
Jump% = 0
jp% = 0

Delay 10
DO
LOOP UNTIL INKEY$ = ""

Center 1, "HEY!", 7, 1
GaryTalk 2, 1
SLEEP
Center 1, "WHAT!", 2, 0
LaryTalk 1, 1
SLEEP
Center 1, "STEVE!", 2, 0
LaryTalk 2, 2
SLEEP
Center 1, "HOW DID YOU GET HERE!?", 2, 0
LaryTalk 5, 2
SLEEP
Center 1, "I FOLLOWED YOU", 7, 0
GaryTalk 4, 1
SLEEP
Center 1, "WHY?", 2, 0
LaryTalk 1, 2
SLEEP
Center 1, "I THOUGHT YOU COULD USE SOME HELP", 7, 0
GaryTalk 7, 1
SLEEP
Center 1, "STEVE!", 2, 0
LaryTalk 2, 2
SLEEP
Center 1, "IT'S DANGEROUS HERE", 2, 0
LaryTalk 5, 2
SLEEP
Center 1, "YOU SHOULD GET OUT OF HERE", 2, 0
LaryTalk 6, 2
SLEEP
Center 1, "YOU'LL GET KILLED", 2, 0
LaryTalk 3, 2
SLEEP
Center 1, "WHAT ARE YOU DOING HERE?", 7, 0
GaryTalk 6, 1
SLEEP
Center 1, "I'M HERE ON A MISSION", 2, 0
LaryTalk 6, 2
SLEEP
Center 1, "LOOK OUT!!!", 7, 0
GaryTalk 2, 1
Delay 5
GaryTalk 0, 2
Delay 5
LINE (GaryX%, 124)-(GaryX% + 15, 140), 132, BF
Delay 2

Center 1, "  ", 2, 0

RockGuy%(1) = 200
RockGuy%(2) = 220
RockGuy%(3) = 240
RockGuy%(4) = 260
RockGuy%(5) = 280
RockGuy%(6) = 300
RockLife%(1) = 3
RockLife%(2) = 3
RockLife%(3) = 3
RockLife%(4) = 3
RockLife%(5) = 3
RockLife%(6) = 3
RockN% = 6

sc1% = 1

An% = 0

END SUB

SUB Scene2

LINE (LaryX% - 4, LaryY%)-(LaryX% + 19, LaryY% + 16), 132, BF

PUT (LaryX%, 124), sprites%((eps% * 0) + 1), PSET

Delay 10
DO
LOOP UNTIL INKEY$ = ""


LaryY% = 124
Jump% = 0
jp% = 0

Center 1, "WOA", 2, 1
LaryTalk 1, 1
SLEEP
Center 1, "THAT WAS A CLOSE ONE", 2, 0
LaryTalk 5, 1
SLEEP
Center 1, "I SURE HOPE STEVE'S OKAY", 2, 0
LaryTalk 7, 1
SLEEP

Center 1, "  ", 2, 0

sc2% = 1

An% = 0

END SUB

SUB Scene3

Delay 10
DO
LOOP UNTIL INKEY$ = ""


LINE (LaryX% - 4, LaryY%)-(LaryX% + 19, LaryY% + 16), 132, BF
PUT (LaryX%, 124), sprites%((eps% * 0) + 1), PSET

LaryY% = 124
Jump% = 0
jp% = 0

sc3% = 1

END SUB

SUB Scene4

LINE (LaryX% - 4, LaryY%)-(LaryX% + 19, LaryY% + 16), 132, BF
PUT (LaryX%, 124), sprites%((eps% * 60) + 1), PSET

LaryY% = 124
Jump% = 0
jp% = 0

Delay 10
DO
LOOP UNTIL INKEY$ = ""

Center 1, "BACK INTO THE CITY", 2, 1
LaryTalk 6, 1
SLEEP
Center 1, "  ", 1, 0

dt% = 6

END SUB

SUB Scene5

LINE (LaryX%, LaryY%)-(LaryX% + 16, LaryY% + 16), 132, BF

PUT (0, 124), sprites%((eps% * 0) + 1), PSET
PUT (200, 124), sprites%((eps% * 70) + 1), PSET


LaryY% = 124
GaryX% = 280
Jump% = 0
jp% = 0

Delay 10

Center 1, "STEVE!", 2, 1
LaryTalk 2, 1
SLEEP
Center 1, "LOOK OUT!", 7, 0
GaryTalk 4, 2
SLEEP
Center 1, "THAT'S NO CACTUS", 7, 0
GaryTalk 4, 2
SLEEP
Center 1, "  ", 1, 0

Delay 20
PUT (200, 124), sprites%((eps% * 71) + 1), PSET
Delay 20
PUT (200, 124), sprites%((eps% * 72) + 1), PSET
BossX% = 200
BossAn% = 0
BossP% = 2

END SUB

SUB Title

DO
LOOP UNTIL INKEY$ = ""

CLS


LINE (0, 80)-(319, 90), 134, BF
LINE (0, 91)-(319, 199), 132, BF
PAINT (1, 1), 72, 134
DRAW "bm0,20 c129 r100 d30 r40 u60 r160 d50 r50 d40 l350 u60"

LINE (10, 30)-(30, 50), 129, BF
LINE (40, 30)-(60, 50), 129, BF
LINE (70, 30)-(90, 50), 129, BF
LINE (10, 60)-(30, 80), 129, BF
LINE (40, 60)-(60, 80), 129, BF
LINE (70, 60)-(90, 80), 129, BF
LINE (150, 10)-(170, 40), 129, BF
LINE (180, 10)-(200, 40), 129, BF
LINE (210, 10)-(230, 40), 129, BF
LINE (240, 10)-(260, 40), 129, BF
LINE (270, 10)-(290, 40), 129, BF
LINE (150, 50)-(170, 80), 129, BF
LINE (180, 50)-(200, 80), 129, BF
LINE (210, 50)-(230, 80), 129, BF
LINE (240, 50)-(260, 80), 129, BF
LINE (270, 50)-(290, 80), 129, BF

PAINT (5, 70), 132, 129

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

DRAW "bm20,119 c134 h10 e5 r70 f5 g10 h5 l50 g5"
DRAW "bm30,103 c133 e5 r30 f5 l40"
PAINT (15, 110), 134, 134
PAINT (40, 100), 133, 133

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

