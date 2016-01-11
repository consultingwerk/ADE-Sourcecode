/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-c-eng.p - English language definitions for Scrolling Lists */
/* translation by Ton Voskuilen, PROGRESS Holland */
/* september, 1991 */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*
As of [Thu Apr 25 15:13:33 EDT 1991], this
is a list of the scrolling list programs:
  u-browse.i     c-print.p
  b-pick.p       i-pick.p
  c-entry.p      i-zap.p
  c-field.p      s-field.p
  c-file.p       u-pick.p
  c-flag.p       u-print.p
  c-form.p
*/

/* c-entry.p,c-field.p,c-file.p,c-form.p,c-print.p,c-vector.p,s-field.p */
ASSIGN
  qbf-lang[ 1] = 'Kies tabel voor relatie of druk op ['
	       + KBLABEL("END-ERROR") + '] voor einde.'
  qbf-lang[ 2] = '[' + KBLABEL("GO") + '] einde selektie, ['
	       + KBLABEL("INSERT-MODE") + '] tekst wissel, ['
	       + KBLABEL("END-ERROR") + '] voor einde.'
  qbf-lang[ 3] = 'Druk op [' + KBLABEL("END-ERROR")
	       + '] voor einde selektie.'
  qbf-lang[ 4] = '[' + KBLABEL("GO") + '] einde selektie, ['
	       + KBLABEL("INSERT-MODE")
	       + '] tekst wissel omsch/tabel/progr.'
  qbf-lang[ 5] = 'Veld-/Naam-'
  qbf-lang[ 6] = 'Omsch/Naam'
  qbf-lang[ 7] = 'Tabel,Progr,Omsch'
  qbf-lang[ 8] = 'Opzoeken van beschikbare velden...'
  qbf-lang[ 9] = 'Kies velden'
  qbf-lang[10] = 'Kies tabel'
  qbf-lang[11] = 'Kies gerelateerde tabel'
  qbf-lang[12] = 'Kies opvraagscherm'
  qbf-lang[13] = 'Kies uitvoer bestemming'
  qbf-lang[14] = 'Relateer' /* should match t-q-eng.p "Join" string */
  qbf-lang[16] = '        Database' /* max length 16 */
  qbf-lang[17] = '           Tabel' /* max length 16 */
  qbf-lang[18] = '            Veld' /* max length 16 */
  qbf-lang[19] = '  Maximum Extent' /* max length 16 */
  qbf-lang[20] = 'Waarde'
  qbf-lang[21] = 'valt buiten het bereik van 1 tot'
  qbf-lang[22] = 'Toevoegen aan bestaand bestand?'
  qbf-lang[23] = 'Optie niet te gebruiken met gekozen uitvoer bestemming'
  qbf-lang[24] = 'Geef bestandsnaam voor uitvoer'

	       /* 12345678901234567890123456789012345678901234567890 */
  qbf-lang[27] = 'Niets invoeren indien alle array velden gewenst,'
  qbf-lang[28] = 'of geef (met komma gescheiden) gewenste elementen'
  qbf-lang[29] = 'die naast elkaar in het rapport komen te staan.'
  qbf-lang[30] = 'Geef (met komma gescheiden) gewenste velden'
  qbf-lang[31] = 'die naast elkaar in het rapport komen te staan.'
  qbf-lang[32] = 'Geef het nummer van het gewenste array element.'.

RETURN.
