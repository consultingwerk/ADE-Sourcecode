/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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
    qbf-lang[ 2] = 'Aucun champ n''a ete trouve par recherche automatique.'
    qbf-lang[ 4] = 'Mise a jour des champs'
    qbf-lang[ 5] = 'nom,adresse 1,adresse 2,adresse 3,ville,'
		 + 'etat,cp+4,cp,ville-etat-cp,pays'
    qbf-lang[ 6] = 'Ligne ~{1~}: Probleme de parentheses.'
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
    qbf-lang[ 3] = 'Informations etiquette'
    qbf-lang[ 4] = 'Format etiquette'
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
    qbf-lang[19] = 'Vous n''avez pas efface cette etiquette. '
		 + 'Voulez-vous continuer?'
    qbf-lang[20] = 'La hauteur d''etiq. est de ~{1~}, mais vous avez ~{2~} '
		 + 'lignes. Des informations ne tiendront pas sur les etiquette'
		 + 's et ne seront donc pas imprimees. '
		 + 'Voulez-vous continuer et imprimer ces etiquettes?'
    qbf-lang[21] = 'il n''y a pas d''etiquette ou de champs a imprimer!'
    qbf-lang[22] = 'Generation du programme...'
    qbf-lang[23] = 'Compilation du programme...'
    qbf-lang[24] = 'Execution du programme genere...'
    qbf-lang[25] = 'Impossible d''ecrire vers le fichier ou sortie...'
    qbf-lang[26] = '~{1~} etiquettes imprimees'
    qbf-lang[27] = 'C. Champs'
    qbf-lang[28] = 'F. Fichiers actifs'
    qbf-lang[29] = 'Ce programme doit-il selectionner automatiquement les'
		 + ' champs pour ces etiquettes?'
    qbf-lang[31] = 'Voulez-vous effacer la definition de l''etiquette ' +
		   'courante ?'
    qbf-lang[32] = 'Voulez-vous quitter ce module?'.

ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'Si plus d''une etiquette de front, l''espacement texte > 0'
    qbf-lang[ 2] = 'La marge haut ne peut etre negative'
    qbf-lang[ 3] = 'La hauteur totale doit etre superieure a 1'
    qbf-lang[ 4] = 'Le nombre d''etiquette de front doit etre d''au moins 1'
    qbf-lang[ 5] = 'Le nombre de copies doit etre au moins de 1'
    qbf-lang[ 6] = 'La marge gauche ne peut etre negative'
    qbf-lang[ 7] = 'L''espacement texte doit etre plus grand que 1'
    qbf-lang[ 8] = 'Remonter la ligne suivantes si la ligne est vide'
  qbf-lang[ 9] = 'Nombre de lignes entre le haut de l''etiquette et l''imprim.'
    qbf-lang[10] = 'Hauteur totale de l''etiquette mesure en lignes'
    qbf-lang[11] = 'Nombre d''etiquettes de front'
    qbf-lang[12] = 'Nombre de copies de chaque etiquette'
    qbf-lang[13] = 'Nombre d''espaces du bord de l''etiquette a la suivante'
    qbf-lang[14] = 'Distance entre la gauche d''une etiquette a la suivante'.

/*--------------------------------------------------------------------------*/

RETURN.
