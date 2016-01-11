/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-q-eng.p - English language definitions for Query module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN

  ASSIGN
    qbf-lang[ 1] = 'Aucun enregistrement n''a ‚t‚ trouv‚'
    qbf-lang[ 2] = 'Table complŠte,Jointure,Sous-ensemble'
    qbf-lang[ 3] = ' Tout , D‚but , Fin '
    qbf-lang[ 4] = 'Il n''y a pas d''index pour cette table.'
    qbf-lang[ 5] = 'Voulez-vous supprimer cet enregistrement ?'
    qbf-lang[ 6] = '' /* special total message: created from #7 or #8 */
    qbf-lang[ 7] = 'Op‚ration total abandonn‚e'
    qbf-lang[ 8] = 'Le nombre total d''enregistrements trouv‚ est de '
    qbf-lang[ 9] = 'Total en cours... [' + KBLABEL("END-ERROR")
		 + '] pour arrˆter.'
    qbf-lang[10] = 'Egal …,Inf‚rieur …,Inferieur ou ‚gal …,'
		 + 'Plus grand que,Plus grand ou ‚gal …,'
		 + 'Diff‚rent de,Correspond … ,Commence par'
    qbf-lang[11] = 'Il n''y a pas d''enregistrement disponible'
    qbf-lang[13] = 'Vous ˆtes d‚j… en d‚but de fichier.'
    qbf-lang[14] = 'Vous ˆtes d‚j… en fin de fichier.'
    qbf-lang[15] = 'Il n''y a pas de forme d‚finie pour cette requˆte.'
    qbf-lang[16] = 'Requˆte'
    qbf-lang[17] = 'S‚lectionner le nom de la requˆte … utiliser.'
    qbf-lang[18] = '[' + KBLABEL("GO")
		 + '] ou [' + KBLABEL("RETURN")
		 + '] pour s‚lectionner ou [' + KBLABEL("END-ERROR")
		 + '] pour abandonner.'
    qbf-lang[19] = 'Chargement requˆte...'
    qbf-lang[20] = 'La requˆte compil‚e manque … la proc‚dure.  '
		 + 'The problŠme peut ˆtre:^1) PROPATH erron‚,'
		 + '^2) fichier .r manquant ou '
		 + '^3) fichier .r non compil‚^(V‚rifier le fichier '
		 + '<dbname>.ql pour les messages d''erreur).^^Vous '
		 + 'pouvez continuer, mais cela donnera un message d''erreur.  '
		 + 'Voulez-vous continuer?'
    qbf-lang[21] = 'il existe une clause WHERE pour la requˆte qui contient'
		 + 'des valeurs qui sont r‚solules lors de l''exec. Ceci n''est'
		 + 'pas support‚ dans le module requˆte. Ignorer la clause '
		 + 'WHERE et continuer?'
    qbf-lang[22] = '[' + KBLABEL("GET")
		 + '] pour s‚lectionner les champs.'.

ELSE

IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Suivant,Enregistrement suivant.'
    qbf-lang[ 2] = 'Pr‚c.,Enregistrement pr‚c‚dent.'
    qbf-lang[ 3] = 'D‚but,Premier enregistrement.'
    qbf-lang[ 4] = 'Fin,Dernier enregistrement.'
    qbf-lang[ 5] = 'Ajoute,Ajouter un nouvel enregistrement.'
    qbf-lang[ 6] = 'M.a.j.,Mettre … jour l''enregistrement courant.'
    qbf-lang[ 7] = 'Copie,Copier l''enregistrement courant vers un nouveau.'
    qbf-lang[ 8] = 'Efface,Effacer l''enregistrement courant.'
    qbf-lang[ 9] = 'Autre,Passer … une autre requˆte.'
    qbf-lang[10] = 'Liste,Voir la liste des enregistrements.'
    qbf-lang[11] = 'Jointure,Joindre vers les enregistrements li‚s.'
    qbf-lang[12] = 'Requˆte,Requˆte par l''exemple d''enregistrements.'
    qbf-lang[13] = 'Condition,Condition de s‚lection d''enregistrements'
    qbf-lang[14] = 'Total,Nombre d''enregistrements s‚lectionn‚s.'
    qbf-lang[15] = 'Ordre,Ordre de tri diff‚rent.'
    qbf-lang[16] = 'Module,Changement de module.'
    qbf-lang[17] = 'Info,Information sur les paramŠtres courants.'
    qbf-lang[18] = 'Utilisateur,Transfert vers un module utilisateur.'
    qbf-lang[19] = 'Quitter,Quitter.'
    qbf-lang[20] = ''. /* terminator */

RETURN.
