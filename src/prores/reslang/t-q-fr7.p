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
    qbf-lang[ 1] = 'Aucun enregistrement n''a ete trouve'
    qbf-lang[ 2] = 'Table complete,Jointure,Sous-ensemble'
    qbf-lang[ 3] = ' Tout , Debut , Fin '
    qbf-lang[ 4] = 'Il n''y a pas d''index pour cette table.'
    qbf-lang[ 5] = 'Voulez-vous supprimer cet enregistrement ?'
    qbf-lang[ 6] = '' /* special total message: created from #7 or #8 */
    qbf-lang[ 7] = 'Operation total abandonnee'
    qbf-lang[ 8] = 'Le nombre total d''enregistrements trouve est de '
    qbf-lang[ 9] = 'Total en cours... [' + KBLABEL("END-ERROR")
		 + '] pour arreter.'
    qbf-lang[10] = 'Egal a,Inferieur a,Inferieur ou egal a,'
		 + 'Plus grand que,Plus grand ou egal a,'
		 + 'Different de,Correspond a ,Commence par'
    qbf-lang[11] = 'Il n''y a pas d''enregistrement disponible'
    qbf-lang[13] = 'Vous etes deja en debut de fichier.'
    qbf-lang[14] = 'Vous etes deja en fin de fichier.'
    qbf-lang[15] = 'Il n''y a pas de forme definie pour cette requete.'
    qbf-lang[16] = 'Requete'
    qbf-lang[17] = 'Selectionner le nom de la requete a utiliser.'
    qbf-lang[18] = '[' + KBLABEL("GO")
		 + '] ou [' + KBLABEL("RETURN")
		 + '] pour selectionner ou [' + KBLABEL("END-ERROR")
		 + '] pour abandonner.'
    qbf-lang[19] = 'Chargement requete...'
    qbf-lang[20] = 'La requete compilee manque a la procedure.  '
		 + 'The probleme peut etre:^1) PROPATH errone,'
		 + '^2) fichier .r manquant ou '
		 + '^3) fichier .r non compile^(Verifier le fichier '
		 + '<dbname>.ql pour les messages d''erreur).^^Vous '
		 + 'pouvez continuer, mais cela donnera un message d''erreur.  '
		 + 'Voulez-vous continuer?'
    qbf-lang[21] = 'il existe une clause WHERE pour la requete qui contient'
		 + 'des valeurs qui sont resolules lors de l''exec. Ceci n''est'
		 + 'pas supporte dans le module requete. Ignorer la clause '
		 + 'WHERE et continuer?'
    qbf-lang[22] = '[' + KBLABEL("GET")
		 + '] pour selectionner les champs.'.

ELSE

IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Suivant,Enregistrement suivant.'
    qbf-lang[ 2] = 'Prec.,Enregistrement precedent.'
    qbf-lang[ 3] = 'Debut,Premier enregistrement.'
    qbf-lang[ 4] = 'Fin,Dernier enregistrement.'
    qbf-lang[ 5] = 'Ajoute,Ajouter un nouvel enregistrement.'
    qbf-lang[ 6] = 'M.a.j.,Mettre a jour l''enregistrement courant.'
    qbf-lang[ 7] = 'Copie,Copier l''enregistrement courant vers un nouveau.'
    qbf-lang[ 8] = 'Efface,Effacer l''enregistrement courant.'
    qbf-lang[ 9] = 'Autre,Passer a une autre requete.'
    qbf-lang[10] = 'Liste,Voir la liste des enregistrements.'
    qbf-lang[11] = 'Jointure,Joindre vers les enregistrements lies.'
    qbf-lang[12] = 'Requete,Requete par l''exemple d''enregistrements.'
    qbf-lang[13] = 'Condition,Condition de selection d''enregistrements'
    qbf-lang[14] = 'Total,Nombre d''enregistrements selectionnes.'
    qbf-lang[15] = 'Ordre,Ordre de tri different.'
    qbf-lang[16] = 'Module,Changement de module.'
    qbf-lang[17] = 'Info,Information sur les parametres courants.'
    qbf-lang[18] = 'Utilisateur,Transfert vers un module utilisateur.'
    qbf-lang[19] = 'Quitter,Quitter.'
    qbf-lang[20] = ''. /* terminator */

RETURN.
