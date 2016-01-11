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
/* t-d-eng.p - English language definitions for Data Export module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* d-edit.p,a-edit.p */
IF qbf-s = 1 THEN
/*
En entrant les codes, les m‚thodes suivantes y be used:
  'x' - literal character enclosed in single quotes.
  ^x  - interpreted as control-character.
  ##h - one or two hex digits followed by the letter "h".
  ### - one, two or three digits, a decimal number.
  xxx - "xxx" is a symbol such as "lf" from the following table.
*/
  ASSIGN
    qbf-lang[ 1] = 'est un symbole comme'
    qbf-lang[ 2] = 'de la table qui suit.'
    qbf-lang[ 3] = '[' + KBLABEL("GET")
		 + '] pour basculer entre Mode Expert actif ou non.'
    /* format x(70): */
    qbf-lang[ 4] = 'En entrant les codes, les m‚thodes suivantes sont possible'
		 + 's:'
    /* format x(60): */
    qbf-lang[ 5] = 'chaine constante entre simples quotes.'
    qbf-lang[ 6] = 'interpret‚ comme caractŠres de contr“les.'
    qbf-lang[ 7] = 'un ou plusieurs chiffres hexa suivis de "h".'
    qbf-lang[ 8] = 'un, deux ou trois chiffres d‚cimaux.'
    qbf-lang[ 9] = 'est un code inconnu. Veuillez le corriger.'
    qbf-lang[10] = 'D‚finition des s‚quences imprimante...'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Table:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Tri  :'
    qbf-lang[ 3] = 'Informations Export donn‚es'
    qbf-lang[ 4] = 'Format export donn‚es'
    qbf-lang[ 5] = 'Champs:,      :,      :,      :,      :'
    qbf-lang[ 7] = '    Type export:'
    qbf-lang[ 8] = 'Entˆtes:'
    qbf-lang[ 9] = '   (Noms exports du premier enr.)'
    qbf-lang[10] = '   Enreg d‚part:'
    qbf-lang[11] = '         fin   :'
    qbf-lang[12] = 'D‚limiteur     :'
    qbf-lang[13] = 'S‚parateur     :'
    qbf-lang[14] = 'L''export de donn‚es ne supporte pas les occurences de'
		 + 'champs.  Si vous continuez, ces champs seront ‚limin‚s '
		 + 'de l''export.^Voulez-vous continuer?'
    qbf-lang[15] = 'D‚sol‚, vous ne pouvez exporter les champs d‚finis.'
    qbf-lang[21] = 'Vous n''avez pas effac‚ l''export courant.  '
		 + 'Voulez-vous continuer?'
    qbf-lang[22] = 'G‚n‚ration du programme d''export...'
    qbf-lang[23] = 'Compilation du programme d''export...'
    qbf-lang[24] = 'Ex‚cution du programme d''export...'
    qbf-lang[25] = 'Impossible d''‚crire vers le fichier ou sortie'
    qbf-lang[26] = '~{1~} enregistrements export‚s.'
    qbf-lang[31] = 'Voulez-vous effacer la d‚finition de l''exportation ' +
		   'courante ?'
    qbf-lang[32] = 'Voulez-vous quitter ce module?'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
/* this set contains only export formats.  Each is composed of the */
/* internal RESULTS id and the description.  The description must  */
/* not contain a comma, and must fit within format x(32).          */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'PROGRESS,Export PROGRESS'
    qbf-lang[ 2] = 'ASCII   ,ASCII normal'
    qbf-lang[ 3] = 'ASCII-H ,ASCII avec entˆtes'
    qbf-lang[ 4] = 'FIXED   ,ASCII longueur fixe (SDF)'
    qbf-lang[ 5] = 'CSV     ,S‚parateur par virgules (CSV)'
    qbf-lang[ 6] = 'DIF     ,DIF'
    qbf-lang[ 7] = 'SYLK    ,SYLK'
    qbf-lang[ 8] = 'WS      ,WordStar'
    qbf-lang[ 9] = 'WORD    ,Microsoft Word'
    qbf-lang[10] = 'WORD4WIN,Microsoft Word pour Windows'
    qbf-lang[11] = 'WPERF   ,WordPerfect'
    qbf-lang[12] = 'OFISW   ,CTOS/BTOS OfisWriter'
    qbf-lang[13] = 'USER    ,Utilisateur'
    qbf-lang[14] = '*'. /* terminator for list */

/*--------------------------------------------------------------------------*/

RETURN.
