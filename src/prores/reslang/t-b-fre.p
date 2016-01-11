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
/* t-b-eng.p - English language definitions for Build subsystem */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* b-build.p,b-again.p */
IF qbf-s = 1 THEN
  ASSIGN
		/* formats: x(10) x(45) x(8) */
    qbf-lang[ 1] = 'Programme,Base et Table,Dur‚e'
    qbf-lang[ 2] = 'Fichier endommag‚. Enlever le fichier .qc et relancer '
		 + 'la construction du d‚but.'
    qbf-lang[ 3] = 'Travail sur'    /*format x(15)*/
    qbf-lang[ 4] = 'Compilation'    /*format x(15)*/
    qbf-lang[ 5] = 'Re-Compilation' /*format x(15)*/
    qbf-lang[ 6] = 'Travail sur table,Travail sur forme,Travail sur programme'
    qbf-lang[ 7] = 'Toutes les formes marqu‚es vont etre construites. ['
		 + KBLABEL("RETURN") + '] s‚lect./d‚select.'
    qbf-lang[ 8] = '[' + KBLABEL("GO") + '] pour terminer, ['
		 + KBLABEL("END-ERROR") + '] pour quitter.'
    qbf-lang[ 9] = 'Balayer les tables pour la construction des formes...'
    qbf-lang[10] = 'Etes-vous d''acord sur la d‚finition des requˆtes?'
    qbf-lang[11] = 'Trouve les relations implicites.'
    qbf-lang[12] = 'Mise … jour des relations.'
    qbf-lang[13] = 'Aucune jointure n''a ‚t‚ trouv‚e.'
    qbf-lang[14] = 'Elimination des informations redondantes.'
    qbf-lang[15] = 'Voulez-vous vraiment quitter?'
    qbf-lang[16] = 'Temps ‚coul‚,Temps moyen'
    qbf-lang[17] = 'Lecture fichier de v‚rification...'
    qbf-lang[18] = 'Ecriture fichier v‚rification...'
    qbf-lang[19] = 'existe d‚j…. Au lieu d''utiliser'
    qbf-lang[20] = 'reconstruit la table'
    qbf-lang[21] = 'Balaye la forme "~{1~}" pour modifications.'
    qbf-lang[22] = 'ne peut construire de forme sans RECID ou UNIQUE INDEX '
		 + 'disponible.'
    qbf-lang[23] = 'Forme non modifi‚e.'
    qbf-lang[24] = 'ne n‚cessite pas de recompilation.'
    qbf-lang[25] = 'Plus de champs dans la forme. Forme non g‚n‚r‚e.'
    qbf-lang[26] = 'pas de champs dans la forme. Forme existante supprim‚e.'
    qbf-lang[27] = 'optimise la liste des tables visibles.'
    qbf-lang[28] = 'Temps ‚coul‚'
    qbf-lang[29] = 'Termin‚!'
    qbf-lang[30] = 'La compilation de "~{1~}" ‚chou‚e.'
    qbf-lang[31] = 'Ecriture du fichier de configuration'
    qbf-lang[32] = 'Des erreurs ont ‚t‚ trouv‚es lors des ‚tapes de constructio'
		 + 'n^^Appuyer sur une touche pour voir les traces. Les lignes '
		 + 'contenant les erreur seront invers‚es.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN

/* b-misc.p */
    /* 1..10 for qbf-l-auto[] */
    qbf-lang[ 1] = 'nom,*nom*,contact,*contact*,Name'
    qbf-lang[ 2] = '*rue,*ad,*adresse,*adresse*1,Address'
    qbf-lang[ 3] = '*cp*bp*,*adresse*2,Address2'
    qbf-lang[ 4] = '*adresse*3'
    qbf-lang[ 5] = 'ville,*ville*,City'
    qbf-lang[ 6] = 'departement,departement,*departement*,St'
    qbf-lang[ 7] = 'codepostal,*codepostal*,Zip'
    qbf-lang[ 8] = 'codepostal*4'
    qbf-lang[ 9] = '*csz*,*ville*cp*codepostal*'
    qbf-lang[10] = '*pays*'

    qbf-lang[15] = 'Exemple d''export.'.

/*--------------------------------------------------------------------------*/

RETURN.
