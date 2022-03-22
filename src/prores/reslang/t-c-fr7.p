/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-c-eng.p - English language definitions for Scrolling Lists */

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
  qbf-lang[ 1] = 'Choisir la table a joindre ou ['
	       + KBLABEL("END-ERROR") + '] pour terminer.'
  qbf-lang[ 2] = '[' + KBLABEL("GO") + '] Terminer, ['
	       + KBLABEL("INSERT-MODE") + '] Basculer, ['
	       + KBLABEL("END-ERROR") + '] Annuler.'
  qbf-lang[ 3] = '[' + KBLABEL("END-ERROR")
	       + '] pour arreter la selection.'
  qbf-lang[ 4] = '[' + KBLABEL("GO") + '] Terminer, ['
	       + KBLABEL("INSERT-MODE")
	       + '] Basculer entre Descriptif/Table/Programme'
  qbf-lang[ 5] = 'Label/Nom--'
  qbf-lang[ 6] = 'Desc/Nom-'
  qbf-lang[ 7] = 'Table-----,Programme-,Descriptif'
  qbf-lang[ 8] = 'Recherche champs disponibles...'
  qbf-lang[ 9] = 'Choisir champ'
  qbf-lang[10] = 'Choisir table'
  qbf-lang[11] = 'Choisir table liee'
  qbf-lang[12] = 'Selectionner la requete'
  qbf-lang[13] = 'Choisir la sortie'
  qbf-lang[14] = 'Jointure' /* should match t-q-eng.p "Join" string */
  qbf-lang[16] = ' Base de donnees' /* max length 16 */
  qbf-lang[17] = '           Table' /* max length 16 */
  qbf-lang[18] = '           Champ' /* max length 16 */
  qbf-lang[19] = 'Nb max d''occurs.' /* max length 16 */
  qbf-lang[20] = 'la valeur'
  qbf-lang[21] = 'est hors de l''ensemble 1,'
  qbf-lang[22] = 'Ajoute au fichier existant?'
  qbf-lang[23] = 'Impossible d''utiliser cette option sans specifier la sortie'
  qbf-lang[24] = 'Entrer le fichier de sortie'

	       /* 12345678901234567890123456789012345678901234567890 */
  qbf-lang[27] = 'Laisser a blanc pour les elements selectionnes, ou entrer'
  qbf-lang[28] = 'le separateur "," pour une liste d''elements individuels '
  qbf-lang[29] = 'a inclure dans l''edition.'
  qbf-lang[30] = 'Entrer une liste d''elements separes par des virgules'
  qbf-lang[31] = 'pour inclure une selection de champs.'
  qbf-lang[32] = 'Entrer le numero de l''occurrence a utiliser.'.

RETURN.
