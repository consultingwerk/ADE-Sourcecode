/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-d-ger.p - German language definitions for Data Export module */

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
    qbf-lang[ 1] = 'ist ein Zeichen wie z.B.'
    qbf-lang[ 2] = 'aus nachfolgender Tabelle.'
    qbf-lang[ 3] = '[' + KBLABEL("GET")
		 + '] Expertenmodus ein/ausschalten'
    /* format x(70): */
    qbf-lang[ 4] = 'Bei der Code-Eingabe k”nnen Sie folgende Symbole '
		 + 'verwenden:'
    /* format x(60): */
    qbf-lang[ 5] = 'Buchstaben und Zahlen in einfachem Hochkomma.'
    qbf-lang[ 6] = 'werden als Kontrollzeichen interpretiert.'
    qbf-lang[ 7] = 'ein bis zwei HEX-Zeichen gefolgt von einem "h".'
    qbf-lang[ 8] = 'ein, zwei oder drei Zahlen, eine Dezimalzahl.'
    qbf-lang[ 9] = 'ist nicht zul„ssig. Bitte korrigieren!'
    qbf-lang[10] = 'šbernahme der Steuerzeichen...'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Datei:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Order:'
    qbf-lang[ 3] = 'Datenexport Info'
    qbf-lang[ 4] = 'Datenexport Layout'
    qbf-lang[ 5] = 'Felder:,      :,      :,      :,      :'
    qbf-lang[ 7] = '     Export Typ:'
    qbf-lang[ 8] = 'Kopfzle:'
    qbf-lang[ 9] = '     (Exportname als erster Satz)'
    qbf-lang[10] = '      Satzstart:'
    qbf-lang[11] = '       Satzende:'
    qbf-lang[12] = ' Feldbegrenzung:'
    qbf-lang[13] = 'Feldtrennzeich.:'
    qbf-lang[14] = 'Sie k”nnen keine Listenelemente exportieren. '
		 + 'Wenn Sie weitermachen, werden die Listen'
		 + 'elemente herausgenommen.^Wollen Sie weitermachen?'
    qbf-lang[15] = 'Sie k”nnen keine Daten exportiert werden, wenn keine '
		 + 'Felder definiert sind.'
    qbf-lang[21] = 'Sie haben noch ein Datenexport-Format in Bearbeitung. '
		 + 'Soll der Bildschirm gel”scht werden? '
    qbf-lang[22] = 'Das Exportprogramm wird erstellt...'
    qbf-lang[23] = 'Das Exportprogramm wird kompiliert...'
    qbf-lang[24] = 'Das Exportprogramm wird ausgefhrt...'
    qbf-lang[25] = 'Keine Schreibrechte fr die Datei bzw. das Ger„t'
    qbf-lang[26] = '~{1~} Datens„tze wurden exportiert.'
    qbf-lang[31] = 'Soll der Bildschirm jetzt wirklich gel”scht werden?'
    qbf-lang[32] = 'Sind Sie sicher, daá Sie das Modul "Datenexport" '
		 + 'verlassen wollen?'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
/* this set contains only export formats.  Each is composed of the */
/* internal RESULTS id and the description.  The description must  */
/* not contain a comma, and must fit within format x(32).          */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'PROGRESS,PROGRESS Export'
    qbf-lang[ 2] = 'ASCII   ,ASCII allgemein'
    qbf-lang[ 3] = 'ASCII-H ,ASCII m. Feldberschriften'
    qbf-lang[ 4] = 'FIXED   ,ASCII m. fester Satzl„nge (SDF)'
    qbf-lang[ 5] = 'CSV     ,Werte d. Komma getrennt (CSV)'
    qbf-lang[ 6] = 'DIF     ,DIF'
    qbf-lang[ 7] = 'SYLK    ,SYLK'
    qbf-lang[ 8] = 'WS      ,WordStar'
    qbf-lang[ 9] = 'WORD    ,Microsoft Word'
    qbf-lang[10] = 'WORD4WIN,Microsoft Word fr Windows'
    qbf-lang[11] = 'WPERF   ,WordPerfect'
    qbf-lang[12] = 'OFISW   ,CTOS/BTOS OfisWriter'
    qbf-lang[13] = 'USER    ,Sonst.'
    qbf-lang[14] = '*'. /* terminator for list */

/*--------------------------------------------------------------------------*/

RETURN.
