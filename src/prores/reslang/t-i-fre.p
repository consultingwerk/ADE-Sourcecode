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
  qbf-lang[ 1] = 'Exportations,Graphiques,Etiquettes,Requˆtes,Editions'
  qbf-lang[ 2] = 'Entrer le descriptif de l'''
  qbf-lang[ 3] = 'tables et/ou fichiers ayant ‚t‚ omis pour une des raisons '
	       + 'suivantes :^1) bases originales non connect‚es'
	       + '^2) Modification d‚finition de base^3) Permissions '
	       + 'insuffisantes'
  qbf-lang[ 4] = 'Chaque ~{1~} doit avoir un nom unique. Essayez encore.'
  qbf-lang[ 5] = 'Vous avez sauv‚ trop d''entr‚es. Supprimez en!  '
	       + 'Supprimer … partir de tout module libŠre de l''espace.'
  qbf-lang[ 6] = 'Descriptif,Base------,Programme-'
  qbf-lang[ 7] = 'Voulez-vous ‚craser'
  qbf-lang[ 8] = 'par'
  qbf-lang[ 9] = 'Choisir'
  qbf-lang[10] = 'un format d''export,un graphique,'
		+ 'une ‚tiquette,une requˆte,une ‚dition'
  qbf-lang[11] = 'format export,graphique,‚tiquette,requˆte,‚dition'
  qbf-lang[12] = 'formats export,graphiques,‚tiquettes,requˆtes,‚ditions'
  qbf-lang[13] = 'format export donn‚es,graphiques,format ‚tiquettes,requˆtes,'
	       + 'd‚finition ‚dition'
  qbf-lang[14] = '… charger,… sauver,… d‚truire'
  qbf-lang[15] = 'Travail en cours...'
  qbf-lang[16] = 'Lecture ~{1~} d''un autre r‚pertoire'
  qbf-lang[17] = 'Sauver ~{1~}'
  qbf-lang[18] = 'non disponible'
  qbf-lang[19] = 'Les objets s‚lectionn‚s vont ˆtre d‚truits. ['
	       + KBLABEL('RETURN') + '] S‚lect./D‚select.'
  qbf-lang[20] = '[' + KBLABEL('GO') + '] pour valider ou ['
	       + KBLABEL('END-ERROR') + '] pour abandonner.'
  qbf-lang[21] = 'D‚placement nombre ~{1~} vers la position ~{2~}.'
  qbf-lang[22] = 'Suppression nombre ~{1~}.'
  qbf-lang[23] = '[' + KBLABEL("GO") + '] Choisir, ['
	       + KBLABEL("INSERT-MODE") + '] Basculer, ['
	       + KBLABEL("END-ERROR") + '] Quitter.'
  qbf-lang[24] = 'Ecriture mises … jour r‚pertoire editions...'
/*a-info.p only:*/ /* 25..29 use format x(64) */
  qbf-lang[25] = 'Ce programme affiche le contenu d''un r‚pertoire'
  qbf-lang[26] = 'utilisateur, montrant quels programmes g‚n‚r‚s'
  qbf-lang[27] = 'correspondent … chaque ‚dition, export, ‚tiquettes,'
  qbf-lang[28] = 'et autres.'
  qbf-lang[29] = 'Entrer le nom complet du fichier ".qd":'
  qbf-lang[30] = 'Fichier non trouv‚.'
  qbf-lang[31] = 'Vous avez oubl‚ l''extension ".qd".'
  qbf-lang[32] = 'Lecture du r‚pertoire...'.

RETURN.
