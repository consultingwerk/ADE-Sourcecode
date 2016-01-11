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
/* t-s-eng.p - English language definitions for general system use */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/

/* l-edit.p,s-edit.p */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Ins‚rer'
    qbf-lang[ 2] = 'Voulez-vous quitter sans sauver les modifications?'
    qbf-lang[ 3] = 'Entrer le nom du fichier … fusionner'
    qbf-lang[ 4] = 'Entrer la chaine … rechercher'
    qbf-lang[ 5] = 'Choisir le champ … ins‚rer'
    qbf-lang[ 6] = '[' + KBLABEL("GO") + '] sauver, ['
		 + KBLABEL("GET") + '] ajouter un champ, ['
		 + KBLABEL("END-ERROR") + '] annuler.'
    qbf-lang[ 7] = 'Chaine non trouv‚e.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-ask.p,s-where.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Egal'
    qbf-lang[ 2] = 'Diff‚rent'
    qbf-lang[ 3] = 'Inf‚rieur'
    qbf-lang[ 4] = 'Inf‚rieur ‚gal'
    qbf-lang[ 5] = 'Sup‚rieur'
    qbf-lang[ 6] = 'Sup‚rieur ‚gal'
    qbf-lang[ 7] = 'Commence'
    qbf-lang[ 8] = 'Contient'
    qbf-lang[ 9] = 'Correspond'

    qbf-lang[10] = 'Choisir un champ'
    qbf-lang[11] = 'Expression'
    qbf-lang[12] = 'Entrer une valeur'
    qbf-lang[13] = 'Comparaisons'

    qbf-lang[14] = 'A l''ex‚cution, on demande une valeur … l''utilisateur.'
    qbf-lang[15] = 'Entrer la question … poser … l''ex‚cution:'

    qbf-lang[16] = 'Demander' /* data-type */
    qbf-lang[17] = 'Valeur'

    qbf-lang[18] = '[' + KBLABEL("END-ERROR") + '] pour Sortir.'
    qbf-lang[19] = '[' + KBLABEL("END-ERROR") + '] pour Annuler avant.'
    qbf-lang[20] = '[' + KBLABEL("GET") + '] pour le Mode Expert.'

    qbf-lang[21] = 'Choisir le type de comparaison … ex‚cuter sur le champ.'

    qbf-lang[22] = 'Entrer la valeur ~{1~} … comparer avec "~{2~}".'
    qbf-lang[23] = 'Entrer la valeur ~{1~} pour "~{2~}".'
    qbf-lang[24] = '[' + KBLABEL("PUT")
		 + '] pour demander une valeur lors de l''ex‚cution.'
    qbf-lang[25] = 'Contexte: ~{1~} est ~{2~} de ~{3~} valeurs.'

    qbf-lang[27] = 'D‚sol‚, mais le "Mode Expert" n''est pas compatible avec'
		 + '"Poser une question avant l''ex‚cution".'
		 + 'Vous devez utiliser soit l''un soit l''autre.'
    qbf-lang[28] = 'Ne peut ˆtre inconnu!'
    qbf-lang[29] = 'Entrer plus de valeurs pour ' /* '?' append to string */
    qbf-lang[30] = 'Entrer plus de critŠres de s‚lections?'
    qbf-lang[31] = 'Combiner avec les critŠres pr‚c‚dents?'
    qbf-lang[32] = 'Mode Expert'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
/* s-info.p, s-format.p */
    qbf-lang[ 1] = 'Tri‚ par'  /* s-info.p automatically right-justifies */
    qbf-lang[ 2] = 'Et par'    /*   1..9 and adds colons for you. */
    qbf-lang[ 3] = 'Fichier'   /* but must fit in format x(24) */
    qbf-lang[ 4] = 'Relation'
    qbf-lang[ 5] = 'Ou'
    qbf-lang[ 6] = 'Champ'
    qbf-lang[ 7] = 'Expression'
    qbf-lang[ 9] = 'Cacher valeurs ‚gales?'

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
    qbf-lang[19] = 'Temps pass‚ la derniŠre fois, minutes:secondes'
    qbf-lang[20] = 'Expression ne peut etre inconnu (=?)'

/*s-calc.p*/ /* there are many more for s-calc.p, see qbf-s = 5 thru 8 */
/*s-calc.p also uses #14 */
    qbf-lang[27] = 'Constructeur d''expression'
    qbf-lang[28] = 'Expression'
    qbf-lang[29] = 'Ajouter encore … cette expression?'
    qbf-lang[30] = 'Operation  de s‚lection'
    qbf-lang[31] = 'Date du jour'
    qbf-lang[32] = 'Constante'.

ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 4 THEN
  ASSIGN
/*s-help.p*/
    qbf-lang[ 1] = 'D‚sol‚, mais il n''y a pas d''aide pour cette option.'
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
    qbf-lang[28] = 'M. Expression math‚matique'
    qbf-lang[29] = 'S. Expression chaine'
    qbf-lang[30] = 'N. Expression num‚rique'
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

    qbf-lang[24] = 'Entrer le nom du champ … inclure comme colonne dans votre '
		 + '‚dition, ou choisir <<Constante>> pour ins‚rer une chaine'
		 + 'dans votre ‚dition.'
    qbf-lang[25] = 'SUBSTRING vous autorise … extraire une portion de chaine '
		 + 'de caractŠres … afficher. Choisir un nom de champ.'
    qbf-lang[26] = 'Entrer la position du premier caractŠre'
    qbf-lang[27] = 'Entrer le nombre de caractŠres … extraire'
    qbf-lang[28] = 'S‚lectionner la premiŠre valeur'
    qbf-lang[29] = 'S‚lectionner la valeur suivante'
    qbf-lang[30] = 'S‚lectionner la premiŠre entr‚e … comparer'
    qbf-lang[31] = 'S‚lectionner la seconde valeur … comparer'
    qbf-lang[32] = 'Le nombre retourn‚ correspond … la longueur de la chaine'
		 + 's‚lectionn‚e.'.

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
    qbf-lang[ 8] = 'n,Racine carr‚e,n00=n30,SQRT(~{1~})'
    qbf-lang[ 9] = 'n,Afficher heure,s00=n23,STRING(INTEGER(~{1~});"HH:MM:SS")'

    qbf-lang[23] = 'S‚lectionner un champ … afficher comme HH:MM:SS'
    qbf-lang[24] = 'S‚lectionner la premiŠre entr‚e … comparer'
    qbf-lang[25] = 'S‚lectionner la seconde entr‚e … comparer'
    qbf-lang[26] = 'Entrer le nom du champ … inclure comme colonne dans l'''
		 + '‚dition, ou choisir <<Constante>> pour ins‚rer un nombre '
		 + 'dans votre ‚dition.'
    qbf-lang[27] = 'S‚lectionner un champ … afficher comme une valeur absolue.'
    qbf-lang[28] = 'S‚lectionner un champ … arrondir au plus proche entier.'
    qbf-lang[29] = 'S‚lectionner un champ … tronquer sans fraction.'
    qbf-lang[30] = 'S‚lectionner un champ pour en extraire la racine carr‚e.'
    qbf-lang[31] = 'Quel modulo voulez-vous extraire?'
    qbf-lang[32] = 'Divis‚ par?'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - date expressions */
IF qbf-s = 7 THEN
  ASSIGN
    qbf-lang[ 1] = 'd,Date courante,d00=,TODAY'
    qbf-lang[ 2] = 'd,Ajouter valeur … une date,d00=d22n23,~{1~} + ~{2~}'
    qbf-lang[ 3] = 'd,Enlever des jours … une date,d00=d22n24,~{1~} - ~{2~}'
    qbf-lang[ 4] = 'd,Diff‚rence entre deux dates,n00=d25d26,~{1~} - ~{2~}'
    qbf-lang[ 5] = 'd,Plus t“t de deux dates,d00=d20d21,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 6] = 'd,Plus tard de deux date,d00=d20d21,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 'd,Jour du mois,n00=d27,DAY(~{1~})'
    qbf-lang[ 8] = 'd,Mois de l''ann‚e,n00=d28,MONTH(~{1~})'
    qbf-lang[ 9] = 'd,Nom du mois,s00=d29,ENTRY(MONTH(~{1~});"Janvier'
		 + ';F‚vrier;Mars;Avril;Mai;Juin;Juillet;Ao–t;Septembre'
		 + ';Octobre;Novembre;D‚cembre")'
    qbf-lang[10] = 'd,Ann‚e,n00=d30,YEAR(~{1~})'
    qbf-lang[11] = 'd,Jour de la semaine,n00=d31,WEEKDAY(~{1~})'
    qbf-lang[12] = 'd,Jour dans la semaine,s00=d32,ENTRY(WEEKDAY(~{1~});"'
		 + 'Dimanche;Lundi;Mardi;Mercredi;Jeudi;Vendredi,Samedi")'

    qbf-lang[20] = 'S‚lectionner la premiŠre entr‚e … comparer'
    qbf-lang[21] = 'S‚lectionner la seconde entr‚e … comparer'
    qbf-lang[22] = 'S‚lectionner un champ date'
    qbf-lang[23] = 'S‚lectionner un champ conteant le nombre de jours … '
		 + 'ajouter … cette date.'
    qbf-lang[24] = 'S‚lectionner un champ contenant un nombre de jours … '
		 + 'soustraire … cette date.'
    qbf-lang[25] = 'Comparer deux dates et afficher la diff‚rence entre '
		 + 'les deux, en jours, dans une colonne. Choisir'
		 + ' le premier champ.'
    qbf-lang[26] = 'Choisir le second champ date.'
    qbf-lang[27] = 'Ceci retounr le jour dans le mois comme un nombre entre '
		 + '1 et 31.'
    qbf-lang[28] = 'Ceci retourne le mois dans l''ann‚e comme un nombre entre '
		 + '1 et 12.'
    qbf-lang[29] = 'Ceci retourne le nom du mois.'
    qbf-lang[30] = 'Ceci retourne l''ann‚e comme un entier.'
    qbf-lang[31] = 'Ceci retourne le num‚ro de jour dans la semaine, diman.= 1.'
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
    qbf-lang[ 5] = 'm,Elever … la puissance,n00=n25n32m...,EXP(~{1~};~{2~})'

    qbf-lang[25] = 'Entrer premier nombre'
    qbf-lang[26] = 'Entrer nombre suivant … ajouter'
    qbf-lang[27] = 'Entrer nombre suivant … soustraire'
    qbf-lang[28] = 'Entrer premier nombre … multiplier'
    qbf-lang[29] = 'Entrer nombre suivant … multiplier'
    qbf-lang[30] = 'Entrer le quotient'
    qbf-lang[31] = 'Entrer le diviseur'
    qbf-lang[32] = 'Entrer la puissance'.

/*--------------------------------------------------------------------------*/

RETURN.
