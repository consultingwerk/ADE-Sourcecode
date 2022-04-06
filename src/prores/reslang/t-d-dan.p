/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-d-dan.p - Danish language definitions for  Data Exportmodule */

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
    qbf-lang[ 1] = 'er et symbol ligesom'
    qbf-lang[ 2] = 'fra den f›lgende tabel.'
    qbf-lang[ 3] = 'Tryk [' + KBLABEL("GET")
		 + '] for at skifte Expert Mode til og fra.'
    /* format x(70): */
    qbf-lang[ 4] = 'Ved indtastningen af koder, kan disse metoder blandes frit:'
    /* format x(60): */
    qbf-lang[ 5] = 'selve karakteren omgivet af apostrof.'
    qbf-lang[ 6] = 'opfattes som en kontrol-karakter.'
    qbf-lang[ 7] = 'eet eller to hex tal efterfulgt af bogstavet "h".'
    qbf-lang[ 8] = 'eet, to eller tre cifre, et decimalt nummer'
    qbf-lang[ 9] = 'er en ukendt kode.  Angiv en korrekt v‘rdi.'
    qbf-lang[10] = 'Behandler printer kontrol definitioner...'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Filer:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Sort.:'
    qbf-lang[ 3] = 'Exporter data Info'
    qbf-lang[ 4] = 'Exporter data Layout'
    qbf-lang[ 5] = 'Felter:,      :,      :,      :,      :'
    qbf-lang[ 7] = '    Export Type:'
    qbf-lang[ 8] = 'Hoved:'
    qbf-lang[ 9] = '(exporter navn som f›rste record)'
    qbf-lang[10] = '   Record start:'
    qbf-lang[11] = '    Record slut:'
    qbf-lang[12] = ' Felt afgr‘nser:'
    qbf-lang[13] = ' Felt adskiller:'
    qbf-lang[14] = 'Exporter data supportere ikke export af stakkede '
		 + 'array.  Hvis du forts‘tter vil de blive fjernet fra '
		 + 'exporten.^nsker du at forts‘tte?'
    qbf-lang[15] = 'Der kan ikke exporters data n†r der ikke er defineret felter.'
    qbf-lang[21] = 'Du slettede ikke det aktuelle export format.  '
		 + 'nsker du at forts‘tte?'
    qbf-lang[22] = 'Genererer export program...'
    qbf-lang[23] = 'Kompilerer export program...'
    qbf-lang[24] = 'Afvikler det genererede program...'
    qbf-lang[25] = 'Kan ikke skrive til fil eller enhed'
    qbf-lang[26] = '~{1~} records exporteret.'
    qbf-lang[31] = 'Er du sikker p† du ›nsker at resette export ops‘tningen?'
    qbf-lang[32] = 'Er du sikker p† du ›nsker at afslutte dette modul?'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
/* this set contains only export formats.  Each is composed of the */
/* internal RESULTS id and the description.  The description must  */
/* not contain a comma, and must fit within format x(32).          */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'PROGRESS,PROGRESS Export'
    qbf-lang[ 2] = 'ASCII   ,Almindelig ASCII'
    qbf-lang[ 3] = 'ASCII-H ,ASCII med Felt-navn hoved'
    qbf-lang[ 4] = 'FIXED   ,Fast-brede ASCII (SDF)'
    qbf-lang[ 5] = 'CSV     ,Komma-sepererede v‘rdier (CSV)'
    qbf-lang[ 6] = 'DIF     ,DIF'
    qbf-lang[ 7] = 'SYLK    ,SYLK'
    qbf-lang[ 8] = 'WS      ,WordStar'
    qbf-lang[ 9] = 'WORD    ,Microsoft Word'
    qbf-lang[10] = 'WORD4WIN,Microsoft Word for Windows'
    qbf-lang[11] = 'WPERF   ,WordPerfect'
    qbf-lang[12] = 'OFISW   ,CTOS/BTOS OfisWriter'
    qbf-lang[13] = 'USER    ,Bruger'
    qbf-lang[14] = '*'. /* terminator for list */

/*--------------------------------------------------------------------------*/

RETURN.
