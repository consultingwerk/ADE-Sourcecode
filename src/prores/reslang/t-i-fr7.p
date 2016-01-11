/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-i-eng.p - English language definitions for Directory */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*i-dir.p,i-pick.p,i-zap.p,a-info.p,i-read.p*/
ASSIGN
  qbf-lang[ 1] = 'Exportations,Graphiques,Etiquettes,Requetes,Editions'
  qbf-lang[ 2] = 'Entrer le descriptif de l'''
  qbf-lang[ 3] = 'tables et/ou fichiers ayant ete omis pour une des raisons '
	       + 'suivantes :^1) bases originales non connectees'
	       + '^2) Modification definition de base^3) Permissions '
	       + 'insuffisantes'
  qbf-lang[ 4] = 'Chaque ~{1~} doit avoir un nom unique. Essayez encore.'
  qbf-lang[ 5] = 'Vous avez sauve trop d''entrees. Supprimez en!  '
	       + 'Supprimer a partir de tout module libere de l''espace.'
  qbf-lang[ 6] = 'Descriptif,Base------,Programme-'
  qbf-lang[ 7] = 'Voulez-vous ecraser'
  qbf-lang[ 8] = 'par'
  qbf-lang[ 9] = 'Choisir'
  qbf-lang[10] = 'un format d''export,un graphique,'
		+ 'une etiquette,une requete,une edition'
  qbf-lang[11] = 'format export,graphique,etiquette,requete,edition'
  qbf-lang[12] = 'formats export,graphiques,etiquettes,requetes,editions'
  qbf-lang[13] = 'format export donnees,graphiques,format etiquettes,requetes,'
	       + 'definition edition'
  qbf-lang[14] = 'a charger,a sauver,a detruire'
  qbf-lang[15] = 'Travail en cours...'
  qbf-lang[16] = 'Lecture ~{1~} d''un autre repertoire'
  qbf-lang[17] = 'Sauver ~{1~}'
  qbf-lang[18] = 'non disponible'
  qbf-lang[19] = 'Les objets selectionnes vont etre detruits. ['
	       + KBLABEL('RETURN') + '] Select./Deselect.'
  qbf-lang[20] = '[' + KBLABEL('GO') + '] pour valider ou ['
	       + KBLABEL('END-ERROR') + '] pour abandonner.'
  qbf-lang[21] = 'Deplacement nombre ~{1~} vers la position ~{2~}.'
  qbf-lang[22] = 'Suppression nombre ~{1~}.'
  qbf-lang[23] = '[' + KBLABEL("GO") + '] Choisir, ['
	       + KBLABEL("INSERT-MODE") + '] Basculer, ['
	       + KBLABEL("END-ERROR") + '] Quitter.'
  qbf-lang[24] = 'Ecriture mises a jour repertoire editions...'
/*a-info.p only:*/ /* 25..29 use format x(64) */
  qbf-lang[25] = 'Ce programme affiche le contenu d''un repertoire'
  qbf-lang[26] = 'utilisateur, montrant quels programmes generes'
  qbf-lang[27] = 'correspondent a chaque edition, export, etiquettes,'
  qbf-lang[28] = 'et autres.'
  qbf-lang[29] = 'Entrer le nom complet du fichier ".qd":'
  qbf-lang[30] = 'Fichier non trouve.'
  qbf-lang[31] = 'Vous avez ouble l''extension ".qd".'
  qbf-lang[32] = 'Lecture du repertoire...'.

RETURN.
