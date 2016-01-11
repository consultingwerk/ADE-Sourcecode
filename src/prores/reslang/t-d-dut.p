/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-d-eng.p - English language definitions for Data Export module */
/* translation by Ton Voskuilen, PROGRESS Holland */
/* september, 1991 */

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
    qbf-lang[ 1] = 'is een symbool zoals'
    qbf-lang[ 2] = 'van de volgende tabel.'
    qbf-lang[ 3] = 'Druk op [' + KBLABEL("GET")
		 + '] om Expert Mode aan/uit te wisselen.'
    /* format x(70): */
    qbf-lang[ 4] = 'Bij invoeren kodes, gelden de volgende regels: '
    /* format x(60): */
    qbf-lang[ 5] = 'Letterlijke karakters met enkele quotes aangeven.'
    qbf-lang[ 6] = 'wordt vertaald naar besturingskarakter.'
    qbf-lang[ 7] = 'Een of twee hexadecimale cijfers gevolgd door "h".'
    qbf-lang[ 8] = 'Een, twee of drie cijfers, decimaal getal.'
    qbf-lang[ 9] = 'Kode onbekend, veranderen aub.'
    qbf-lang[10] = 'Printerbesturing wordt verwerkt...'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Tabel:,     :,     :,     :,     :'
    qbf-lang[ 2] = ' Orde:'
    qbf-lang[ 3] = 'Data Export Info'
    qbf-lang[ 4] = 'Data Export Layout'
    qbf-lang[ 5] = 'Velden:,      :,      :,      :,      :'
    qbf-lang[ 7] = '    Export Type:'
    qbf-lang[ 8] = 'Kopregels:'
    qbf-lang[ 9] = ''
    qbf-lang[10] = 'Best.regl start:'
    qbf-lang[11] = 'Best.regl einde:'
    qbf-lang[12] = '     Veld einde:'
    qbf-lang[13] = ' Veld scheiding:'
    qbf-lang[14] = 'Het is niet mogelijk om array velden te exporteren. '
		 + 'Als u toch verder gaat zullen deze velden niet worden '
		 + 'geexporteerd. ^Verder gaan?'
    qbf-lang[15] = 'Niet mogelijk data te exporteren als geen velden '
		 + 'gedefinieerd.'
    qbf-lang[21] = 'Het huidige export formaat is nog niet gewist!.  '
		 + 'Wilt u wel verder gaan?'
    qbf-lang[22] = 'Exporteer programma wordt aangemaakt...'
    qbf-lang[23] = 'Exporteer programma wordt gecompileerd...'
    qbf-lang[24] = 'Programma wordt uitgevoerd...'
    qbf-lang[25] = 'Niet mogelijk naar uitvoer bestemming te schrijven'
    qbf-lang[26] = '~{1~} bestandsregels geexporteerd.'
    qbf-lang[31] = 'Weet u zeker dat u de export instellingen wilt wissen?'
    qbf-lang[32] = 'Weet u zeker dat u deze module wilt verlaten?'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
/* this set contains only export formats.  Each is composed of the */
/* internal RESULTS id and the description.  The description must  */
/* not contain a comma, and must fit within format x(32).          */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'PROGRESS,PROGRESS Export'
    qbf-lang[ 2] = 'ASCII   ,Standaard ASCII'
    qbf-lang[ 3] = 'ASCII-H ,ASCII met veldnaam omschrijving'
    qbf-lang[ 4] = 'FIXED   ,ASCII met vaste lengte'
    qbf-lang[ 5] = "CSV     ,Met komma's gescheiden waarden"
    qbf-lang[ 6] = 'DIF     ,DIF'
    qbf-lang[ 7] = 'SYLK    ,SYLK'
    qbf-lang[ 8] = 'WS      ,WordStar'
    qbf-lang[ 9] = 'WORD    ,Microsoft Word'
    qbf-lang[10] = 'WORD4WIN,Microsoft Word for Windows'
    qbf-lang[11] = 'WPERF   ,WordPerfect'
    qbf-lang[12] = 'OFISW   ,CTOS/BTOS OfisWriter'
    qbf-lang[13] = 'EXTRA   ,Zelf-gedefinieerd export formaat'
    qbf-lang[14] = '*'. /* terminator for list */

/*--------------------------------------------------------------------------*/

RETURN.
