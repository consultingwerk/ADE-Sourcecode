/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-l-eng.p - English language definitions for Labels module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* l-guess.p:1..5,l-verify.p:6.. */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Recherche "~{1~}" pour le champ "~{2~}" ...'
    qbf-lang[ 2] = 'Aucun champ n''a ‚t‚ trouv‚ par recherche automatique.'
    qbf-lang[ 4] = 'Mise … jour des champs'
    qbf-lang[ 5] = 'nom,adresse 1,adresse 2,adresse 3,ville,'
		 + '‚tat,cp+4,cp,ville-‚tat-cp,pays'
    qbf-lang[ 6] = 'Ligne ~{1~}: Probl‚me de parenthŠses.'
    qbf-lang[ 7] = 'Ligne ~{2~}: Champ "~{1~}" inconnu.'
    qbf-lang[ 8] = 'Ligne ~{2~}: Champ "~{1~}", pas un tableau.'
    qbf-lang[ 9] = 'Ligne ~{2~}: Champ "~{1~}", occurence ~{3~} hors ensemble.'
    qbf-lang[10] = 'Ligne ~{2~}: Champ "~{1~}", d''une table non choisie.'.
ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    /* each entry of 1 and also 2 must fit in format x(6) */
    qbf-lang[ 1] = 'Table:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Tri  :'
    qbf-lang[ 3] = 'Informations ‚tiquette'
    qbf-lang[ 4] = 'Format ‚tiquette'
    qbf-lang[ 5] = 'Choisir un champ'
    /*cannot change length of 6 thru 17, right-justify 6-11,13-14 */
    qbf-lang[ 6] = 'Pas de lig. blc.:'
    qbf-lang[ 7] = '    Nb de copies:'
    qbf-lang[ 8] = 'Hauteur totale:'
    qbf-lang[ 9] = '   Marge haute:'
    qbf-lang[10] = '   Espacement texte  :'
    qbf-lang[11] = '   Indentation gauche:'
    qbf-lang[12] = '(larg.)'
    qbf-lang[13] = ' Etiquettes  '
    qbf-lang[14] = '    et champs'
    qbf-lang[15] = 'Nombre            ' /* 15..17 used as group.   */
    qbf-lang[16] = 'd''etiquettes      ' /*   do not change length, */
    qbf-lang[17] = 'de front:    ' /*        but do right-justify  */
    qbf-lang[19] = 'Vous n''avez pas effac‚ cette ‚tiquette. '
		 + 'Voulez-vous continuer?'
    qbf-lang[20] = 'La hauteur d''‚tiq. est de ~{1~}, mais vous avez ~{2~} '
		 + 'lignes. Des informations ne tiendront pas sur les ‚tiquette'
		 + 's et ne seront donc pas imprim‚es. '
		 + 'Voulez-vous continuer et imprimer ces ‚tiquettes?'
    qbf-lang[21] = 'il n''y a pas d''‚tiquette ou de champs … imprimer!'
    qbf-lang[22] = 'G‚n‚ration du programme...'
    qbf-lang[23] = 'Compilation du programme...'
    qbf-lang[24] = 'Ex‚cution du programme g‚n‚r‚...'
    qbf-lang[25] = 'Impossible d''‚crire vers le fichier ou sortie...'
    qbf-lang[26] = '~{1~} ‚tiquettes imprim‚es'
    qbf-lang[27] = 'C. Champs'
    qbf-lang[28] = 'F. Fichiers actifs'
    qbf-lang[29] = 'Ce programme doit-il s‚lectionner automatiquement les'
		 + ' champs pour ces ‚tiquettes?'
    qbf-lang[31] = 'Voulez-vous effacer la d‚finition de l''‚tiquette ' +
		   'courante ?'
    qbf-lang[32] = 'Voulez-vous quitter ce module?'.

ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'Si plus d''une ‚tiquette de front, l''espacement texte > 0'
    qbf-lang[ 2] = 'La marge haut ne peut etre n‚gative'
    qbf-lang[ 3] = 'La hauteur totale doit ˆtre sup‚rieure … 1'
    qbf-lang[ 4] = 'Le nombre d''‚tiquette de front doit ˆtre d''au moins 1'
    qbf-lang[ 5] = 'Le nombre de copies doit ˆtre au moins de 1'
    qbf-lang[ 6] = 'La marge gauche ne peut ˆtre n‚gative'
    qbf-lang[ 7] = 'L''espacement texte doit ˆtre plus grand que 1'
    qbf-lang[ 8] = 'Remonter la ligne suivantes si la ligne est vide'
  qbf-lang[ 9] = 'Nombre de lignes entre le haut de l''‚tiquette et l''imprim.'
    qbf-lang[10] = 'Hauteur totale de l''‚tiquette mesur‚ en lignes'
    qbf-lang[11] = 'Nombre d''‚tiquettes de front'
    qbf-lang[12] = 'Nombre de copies de chaque ‚tiquette'
    qbf-lang[13] = 'Nombre d''espaces du bord de l''‚tiquette … la suivante'
    qbf-lang[14] = 'Distance entre la gauche d''une ‚tiquette … la suivante'.

/*--------------------------------------------------------------------------*/

RETURN.
