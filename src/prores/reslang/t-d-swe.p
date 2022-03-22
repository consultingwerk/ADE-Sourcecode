/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-d-swe.p - Swedish language definitions for Data Export module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* d-edit.p,a-edit.p */
IF qbf-s = 1 THEN
/*
When entering codes, the following methods may be used:
  'x' - literal character enclosed in single quotes.
  ^x  - interpreted as control-character.
  ##h - one or two hex digits followed by the letter "h".
  ### - one, two or three digits, a decimal number.
  xxx - "xxx" is a symbol such as "lf" from the following table.
*/
  ASSIGN
    qbf-lang[ 1] = '„r en symbol s† som'
    qbf-lang[ 2] = 'fr†n f”ljande tabell.'
    qbf-lang[ 3] = 'Tryck [' + KBLABEL("GET")
                 + '] f”r att skifta Expertl„ge  av och p†.'
    /* format x(70): */
    qbf-lang[ 4] = 'N„r koder anges, kan dessa metoder anv„ndas och mixas '
                 + 'fritt:'
    /* format x(60): */
    qbf-lang[ 5] = 'bokstavstecken inneslutet mellan enkelcitattecken.'
    qbf-lang[ 6] = 'tolkat som styrtecken.'
    qbf-lang[ 7] = 'en eller tv† hexsiffror f”ljda av bokstaven "h".'
    qbf-lang[ 8] = 'en, tv† eller tre siffror, ett decimaltal.'
    qbf-lang[ 9] = '„r en ok„nd kod.  Korrigera.'
    qbf-lang[10] = 'Processar definitioner av skrivarstyrningar...'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Filer:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Ordn.:'
    qbf-lang[ 3] = 'Dataexport info'
    qbf-lang[ 4] = 'Dataexport layout'
    qbf-lang[ 5] = 'F„lt  :,      :,      :,      :,      :'
    qbf-lang[ 7] = '      Exporttyp:'
    qbf-lang[ 8] = 'Rubriker:'
    qbf-lang[ 9] = '    (export namn som f”rsta post)'
    qbf-lang[10] = '     Post start:'
    qbf-lang[11] = '     Post  slut:'
    qbf-lang[12] = ' F„ltbegr„nsare:'
    qbf-lang[13] = ' F„lt separator:'
    qbf-lang[14] = 'Dataexport klarar ej export av hel matris (ange de element'
                 + 'du vill exportera). Om du forts„tter kommer de att tas '
                 + ' bort fr†n exporten.^Vill du forts„tta?'
    qbf-lang[15] = 'Kan ej exportera data med inga definierade f„lt.'
    qbf-lang[21] = 'Du rensade inte det aktuella exportformatet.  '
                 + 'Vill du „nd† forts„tta?'
    qbf-lang[22] = 'Genererar exportprogram...'
    qbf-lang[23] = 'Kompilerar exportprogram...'
    qbf-lang[24] = 'K”r genererat program...'
    qbf-lang[25] = 'Kunde ej skriva till fil eller enhet'
    qbf-lang[26] = '~{1~} poster exporterade.'
    qbf-lang[31] = 'S„kert att du vill †terst„lla exportinst„llningen?'
    qbf-lang[32] = 'S„kert att du vill avsluta denna modul?'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
/* this set contains only export formats.  Each is composed of the */
/* internal RESULTS id and the description.  The description must  */
/* not contain a comma, and must fit within format x(32).          */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'PROGRESS,PROGRESS Export'
    qbf-lang[ 2] = 'ASCII   ,Normal ASCII'
    qbf-lang[ 3] = 'ASCII-H ,ASCII med f„ltnamnsrubrik'
    qbf-lang[ 4] = 'FIXED   ,Fix bredd ASCII (SDF)'
    qbf-lang[ 5] = 'CSV     ,Komma-separerat v„rde (CSV)'
    qbf-lang[ 6] = 'DIF     ,DIF'
    qbf-lang[ 7] = 'SYLK    ,SYLK'
    qbf-lang[ 8] = 'WS      ,WordStar'
    qbf-lang[ 9] = 'WORD    ,Microsoft Word'
    qbf-lang[10] = 'WORD4WIN,Microsoft Word f”r Windows'
    qbf-lang[11] = 'WPERF   ,WordPerfect'
    qbf-lang[12] = 'OFISW   ,CTOS/BTOS OfisWriter'
    qbf-lang[13] = 'USER    ,Egen'
    qbf-lang[14] = '*'. /* terminator for list */

/*--------------------------------------------------------------------------*/

RETURN.
