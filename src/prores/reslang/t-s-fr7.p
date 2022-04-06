/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-s-eng.p - English language definitions for general system use */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/

/* l-edit.p,s-edit.p */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Inserer'
    qbf-lang[ 2] = 'Voulez-vous quitter sans sauver les modifications?'
    qbf-lang[ 3] = 'Entrer le nom du fichier a fusionner'
    qbf-lang[ 4] = 'Entrer la chaine a rechercher'
    qbf-lang[ 5] = 'Choisir le champ a inserer'
    qbf-lang[ 6] = '[' + KBLABEL("GO") + '] sauver, ['
		 + KBLABEL("GET") + '] ajouter un champ, ['
		 + KBLABEL("END-ERROR") + '] annuler.'
    qbf-lang[ 7] = 'Chaine non trouvee.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-ask.p,s-where.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Egal'
    qbf-lang[ 2] = 'Different'
    qbf-lang[ 3] = 'Inferieur'
    qbf-lang[ 4] = 'Inferieur egal'
    qbf-lang[ 5] = 'Superieur'
    qbf-lang[ 6] = 'Superieur egal'
    qbf-lang[ 7] = 'Commence'
    qbf-lang[ 8] = 'Contient'
    qbf-lang[ 9] = 'Correspond'

    qbf-lang[10] = 'Choisir un champ'
    qbf-lang[11] = 'Expression'
    qbf-lang[12] = 'Entrer une valeur'
    qbf-lang[13] = 'Comparaisons'

    qbf-lang[14] = 'A l''execution, on demande une valeur a l''utilisateur.'
    qbf-lang[15] = 'Entrer la question a poser a l''execution:'

    qbf-lang[16] = 'Demander' /* data-type */
    qbf-lang[17] = 'Valeur'

    qbf-lang[18] = '[' + KBLABEL("END-ERROR") + '] pour Sortir.'
    qbf-lang[19] = '[' + KBLABEL("END-ERROR") + '] pour Annuler avant.'
    qbf-lang[20] = '[' + KBLABEL("GET") + '] pour le Mode Expert.'

    qbf-lang[21] = 'Choisir le type de comparaison a executer sur le champ.'

    qbf-lang[22] = 'Entrer la valeur ~{1~} a comparer avec "~{2~}".'
    qbf-lang[23] = 'Entrer la valeur ~{1~} pour "~{2~}".'
    qbf-lang[24] = '[' + KBLABEL("PUT")
		 + '] pour demander une valeur lors de l''execution.'
    qbf-lang[25] = 'Contexte: ~{1~} est ~{2~} de ~{3~} valeurs.'

    qbf-lang[27] = 'Desole, mais le "Mode Expert" n''est pas compatible avec'
		 + '"Poser une question avant l''execution".'
		 + 'Vous devez utiliser soit l''un soit l''autre.'
    qbf-lang[28] = 'Ne peut etre inconnu!'
    qbf-lang[29] = 'Entrer plus de valeurs pour ' /* '?' append to string */
    qbf-lang[30] = 'Entrer plus de criteres de selections?'
    qbf-lang[31] = 'Combiner avec les criteres precedents?'
    qbf-lang[32] = 'Mode Expert'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
/* s-info.p, s-format.p */
    qbf-lang[ 1] = 'Trie par'  /* s-info.p automatically right-justifies */
    qbf-lang[ 2] = 'Et par'    /*   1..9 and adds colons for you. */
    qbf-lang[ 3] = 'Fichier'   /* but must fit in format x(24) */
    qbf-lang[ 4] = 'Relation'
    qbf-lang[ 5] = 'Ou'
    qbf-lang[ 6] = 'Champ'
    qbf-lang[ 7] = 'Expression'
    qbf-lang[ 9] = 'Cacher valeurs egales?'

    qbf-lang[10] = 'FROM,BY,FOR'
    qbf-lang[11] = 'Vous n''avez pas choisi de tables!'
    qbf-lang[12] = 'Formats et Labels'
    qbf-lang[13] = 'Formats'
    qbf-lang[14] = 'Choisir un champ' /* also used by s-calc.p below */
    /* 15..18 must be format x(16) (see notes on 1..7) */
    qbf-lang[15] = 'Label'
    qbf-lang[16] = 'Format'
    qbf-lang[17] = 'Base'
    qbf-lang[18] = 'Type'
    qbf-lang[19] = 'Temps passe la derniere fois, minutes:secondes'
    qbf-lang[20] = 'Expression ne peut etre inconnu (=?)'

/*s-calc.p*/ /* there are many more for s-calc.p, see qbf-s = 5 thru 8 */
/*s-calc.p also uses #14 */
    qbf-lang[27] = 'Constructeur d''expression'
    qbf-lang[28] = 'Expression'
    qbf-lang[29] = 'Ajouter encore a cette expression?'
    qbf-lang[30] = 'Operation  de selection'
    qbf-lang[31] = 'Date du jour'
    qbf-lang[32] = 'Constante'.

ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 4 THEN
  ASSIGN
/*s-help.p*/
    qbf-lang[ 1] = 'Desole, mais il n''y a pas d''aide pour cette option.'
    qbf-lang[ 2] = 'Aide'

/*s-order.p*/
    qbf-lang[15] = 'asc/desc' /*neither can be over 8 characters */
    qbf-lang[16] = 'Pour chaque composante, "a" pour ascendant'
    qbf-lang[17] = 'ou "d" pour descendant.'

/*s-define.p*/
    qbf-lang[21] = 'L. Largeur/Format des champs'
    qbf-lang[22] = 'C. Champs'
    qbf-lang[23] = 'A. Tables Actives'
    qbf-lang[24] = 'T. Totaux et Soustotaux'
    qbf-lang[25] = 'R. Total Courant'
    qbf-lang[26] = 'P. Pourcentage du Total'
    qbf-lang[27] = 'C. Compteurs'
    qbf-lang[28] = 'M. Expression mathematique'
    qbf-lang[29] = 'S. Expression chaine'
    qbf-lang[30] = 'N. Expression numerique'
    qbf-lang[31] = 'D. Expression date'
    qbf-lang[32] = 'L. Expression logique'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - string expressions */
IF qbf-s = 5 THEN
  ASSIGN
    qbf-lang[ 1] = 's,Constante ou Champ,s00=s24,~{1~}'
    qbf-lang[ 2] = 's,Sous-Chaine,s00=s25n26n27,SUBSTRING(~{1~}'
		 + ';INTEGER(~{2~});INTEGER(~{3~}))'
    qbf-lang[ 3] = 's,Combiner 2 chaines,s00=s28s29,~{1~} + ~{2~}'
    qbf-lang[ 4] = 's,Combiner 3 chaines,s00=s28s29s29,'
		 + '~{1~} + ~{2~} + ~{3~}'
    qbf-lang[ 5] = 's,Combiner 4 chaines,s00=s28s29s29s29,'
		 + '~{1~} + ~{2~} + ~{3~} + ~{4~}'
    qbf-lang[ 6] = 's,Plus petit de 2 chaines,s00=s30s31,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 's,Plus grand de 2 chaines,s00=s30s31,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 8] = 's,Longueur d''une chaine,n00=s32,LENGTH(~{1~})'
    qbf-lang[ 9] = 's,User ID,s00=,USERID("RESULTSDB")'
    qbf-lang[10] = 's,Heure courante,s00=,STRING(TIME;"HH:MM:SS")'

    qbf-lang[24] = 'Entrer le nom du champ a inclure comme colonne dans votre '
		 + 'edition, ou choisir <<Constante>> pour inserer une chaine'
		 + 'dans votre edition.'
    qbf-lang[25] = 'SUBSTRING vous autorise a extraire une portion de chaine '
		 + 'de caracteres a afficher. Choisir un nom de champ.'
    qbf-lang[26] = 'Entrer la position du premier caractere'
    qbf-lang[27] = 'Entrer le nombre de caracteres a extraire'
    qbf-lang[28] = 'Selectionner la premiere valeur'
    qbf-lang[29] = 'Selectionner la valeur suivante'
    qbf-lang[30] = 'Selectionner la premiere entree a comparer'
    qbf-lang[31] = 'Selectionner la seconde valeur a comparer'
    qbf-lang[32] = 'Le nombre retourne correspond a la longueur de la chaine'
		 + 'selectionnee.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - numeric expressions */
IF qbf-s = 6 THEN
  ASSIGN
    qbf-lang[ 1] = 'n,Constante ou Champ,n00=n26,~{1~}'
    qbf-lang[ 2] = 'n,Plus petit de 2 nombres,n00=n24n25,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 3] = 'n,Plus grand de 2 nombres,n00=n24n25,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 4] = 'n,Modulo,n00=n31n32,~{1~} MODULO ~{2~}'
    qbf-lang[ 5] = 'n,Valeur absolue,n00=n27,'
		 + '(IF ~{1~} < 0 THEN - ~{1~} ELSE ~{1~})'
    qbf-lang[ 6] = 'n,Arrondi,n00=n28,ROUND(~{1~};0)'
    qbf-lang[ 7] = 'n,Troncature,n00=n29,TRUNCATE(~{1~};0)'
    qbf-lang[ 8] = 'n,Racine carree,n00=n30,SQRT(~{1~})'
    qbf-lang[ 9] = 'n,Afficher heure,s00=n23,STRING(INTEGER(~{1~});"HH:MM:SS")'

    qbf-lang[23] = 'Selectionner un champ a afficher comme HH:MM:SS'
    qbf-lang[24] = 'Selectionner la premiere entree a comparer'
    qbf-lang[25] = 'Selectionner la seconde entree a comparer'
    qbf-lang[26] = 'Entrer le nom du champ a inclure comme colonne dans l'''
		 + 'edition, ou choisir <<Constante>> pour inserer un nombre '
		 + 'dans votre edition.'
    qbf-lang[27] = 'Selectionner un champ a afficher comme une valeur absolue.'
    qbf-lang[28] = 'Selectionner un champ a arrondir au plus proche entier.'
    qbf-lang[29] = 'Selectionner un champ a tronquer sans fraction.'
    qbf-lang[30] = 'Selectionner un champ pour en extraire la racine carree.'
    qbf-lang[31] = 'Quel modulo voulez-vous extraire?'
    qbf-lang[32] = 'Divise par?'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - date expressions */
IF qbf-s = 7 THEN
  ASSIGN
    qbf-lang[ 1] = 'd,Date courante,d00=,TODAY'
    qbf-lang[ 2] = 'd,Ajouter valeur a une date,d00=d22n23,~{1~} + ~{2~}'
    qbf-lang[ 3] = 'd,Enlever des jours a une date,d00=d22n24,~{1~} - ~{2~}'
    qbf-lang[ 4] = 'd,Difference entre deux dates,n00=d25d26,~{1~} - ~{2~}'
    qbf-lang[ 5] = 'd,Plus tot de deux dates,d00=d20d21,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 6] = 'd,Plus tard de deux date,d00=d20d21,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 'd,Jour du mois,n00=d27,DAY(~{1~})'
    qbf-lang[ 8] = 'd,Mois de l''annee,n00=d28,MONTH(~{1~})'
    qbf-lang[ 9] = 'd,Nom du mois,s00=d29,ENTRY(MONTH(~{1~});"Janvier'
		 + ';Fevrier;Mars;Avril;Mai;Juin;Juillet;Aout;Septembre'
		 + ';Octobre;Novembre;Decembre")'
    qbf-lang[10] = 'd,Annee,n00=d30,YEAR(~{1~})'
    qbf-lang[11] = 'd,Jour de la semaine,n00=d31,WEEKDAY(~{1~})'
    qbf-lang[12] = 'd,Jour dans la semaine,s00=d32,ENTRY(WEEKDAY(~{1~});"'
		 + 'Dimanche;Lundi;Mardi;Mercredi;Jeudi;Vendredi,Samedi")'

    qbf-lang[20] = 'Selectionner la premiere entree a comparer'
    qbf-lang[21] = 'Selectionner la seconde entree a comparer'
    qbf-lang[22] = 'Selectionner un champ date'
    qbf-lang[23] = 'Selectionner un champ conteant le nombre de jours a '
		 + 'ajouter a cette date.'
    qbf-lang[24] = 'Selectionner un champ contenant un nombre de jours a '
		 + 'soustraire a cette date.'
    qbf-lang[25] = 'Comparer deux dates et afficher la difference entre '
		 + 'les deux, en jours, dans une colonne. Choisir'
		 + ' le premier champ.'
    qbf-lang[26] = 'Choisir le second champ date.'
    qbf-lang[27] = 'Ceci retounr le jour dans le mois comme un nombre entre '
		 + '1 et 31.'
    qbf-lang[28] = 'Ceci retourne le mois dans l''annee comme un nombre entre '
		 + '1 et 12.'
    qbf-lang[29] = 'Ceci retourne le nom du mois.'
    qbf-lang[30] = 'Ceci retourne l''annee comme un entier.'
    qbf-lang[31] = 'Ceci retourne le numero de jour dans la semaine, diman.= 1.'
    qbf-lang[32] = 'Ceci retourne le nom du jour dans la semaine.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - mathematical expressions */
IF qbf-s = 8 THEN
  ASSIGN
    qbf-lang[ 1] = 'm,Ajouter,n00=n25n26m...,~{1~} + ~{2~}'
    qbf-lang[ 2] = 'm,Soustraire,n00=n25n27m...,~{1~} - ~{2~}'
    qbf-lang[ 3] = 'm,Multiplier,n00=n28n29m...,~{1~} * ~{2~}'
    qbf-lang[ 4] = 'm,Diviser,n00=n30n31m...,~{1~} / ~{2~}'
    qbf-lang[ 5] = 'm,Elever a la puissance,n00=n25n32m...,EXP(~{1~};~{2~})'

    qbf-lang[25] = 'Entrer premier nombre'
    qbf-lang[26] = 'Entrer nombre suivant a ajouter'
    qbf-lang[27] = 'Entrer nombre suivant a soustraire'
    qbf-lang[28] = 'Entrer premier nombre a multiplier'
    qbf-lang[29] = 'Entrer nombre suivant a multiplier'
    qbf-lang[30] = 'Entrer le quotient'
    qbf-lang[31] = 'Entrer le diviseur'
    qbf-lang[32] = 'Entrer la puissance'.

/*--------------------------------------------------------------------------*/

RETURN.
