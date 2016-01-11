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
/* t-r-eng.p - English language definitions for Reports module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
/*r-header.p*/
    qbf-lang[ 1] = 'Entrer les expressions pour'
    qbf-lang[ 2] = 'Ligne' /* must be < 8 characters */
		   /* 28..31 are format x(64) */
    qbf-lang[ 3] = 'Ces fonctions sont utilisables dans l''entˆte et bas'
		 + ' de page'
    qbf-lang[ 4] = '~{COUNT~}  Nombre d''enreg. list‚s  :  '
		 + '~{TIME~}  Date de d‚part'
    qbf-lang[ 5] = '~{TODAY~}  Date du jour            :  '
		 + '~{NOW~}   Heure courante'
    qbf-lang[ 6] = '~{PAGE~}   page courante           :  '
		 + '~{USER~}  Nom de l''utilisateur'
    qbf-lang[ 7] = '~{VALUE <expression>~;<format>~} Ins‚rer une valeur'
		 + ' (touche [' + KBLABEL("GET") + '])'
    qbf-lang[ 8] = 'Choisir le champ … ins‚rer'
    qbf-lang[ 9] = '[' + KBLABEL("GO") + '] Sauver, ['
		 + KBLABEL("GET") + '] Ajouter champ, ['
		 + KBLABEL("END-ERROR") + '] Annuler.'

/*r-total.p*/    /*"|---------------------------|"*/
    qbf-lang[12] = 'Ex‚cuter ces actions:'
		 /*"|--------------------------------------------|"*/
    qbf-lang[13] = 'Quand ces champs changent de valeur:'
		 /*"|---| |---| |---| |---| |---|" */
    qbf-lang[14] = 'Total -Nb-- -Min- -Max- -Avg-'
    qbf-lang[15] = 'Ligne r‚sum‚e'
    qbf-lang[16] = 'Champs   :'
    qbf-lang[17] = 'Choisir le champ … totaliser'

/*r-calc.p*/
    qbf-lang[18] = 'Choisir la colonne de total courant'
    qbf-lang[19] = 'Choisir la colonne pour le % du total'
    qbf-lang[20] = 'Total courant'
    qbf-lang[21] = '% Total'
    qbf-lang[22] = 'Chaine,Date,Logique,Math,Num‚rique'
    qbf-lang[23] = 'Valeur'
    qbf-lang[24] = 'Entrer le nombre de d‚part pour le compteur'
    qbf-lang[25] = 'Entrer l''incr‚ment (positif ou n‚gatif)'
    qbf-lang[26] = 'Compteurs'
    qbf-lang[27] = 'Compteur'
		 /*"------------------------------|"*/
    qbf-lang[28] = 'Nombre de d‚part pour compteurs' /*right justify*/
    qbf-lang[29] = '    Pour chaque enreg., ajouter' /*right justify*/
    qbf-lang[32] = 'Vous avez atteint le nombre maximum de colonnes.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN
/* r-space.p */  /*"------------------------------|  ---------|  |------"*/
    qbf-lang[ 1] = '             Option                 Courant   D‚faut'
    /* 2..8 must be less than 32 characters long */
    qbf-lang[ 2] = 'Marge gauche'
    qbf-lang[ 3] = 'Espaces entre colonnes'
    qbf-lang[ 4] = 'Ligne de d‚part'
    qbf-lang[ 5] = 'Lignes par page'
    qbf-lang[ 6] = 'Espace inter lignes'
    qbf-lang[ 7] = 'Lignes entre entˆte/corps page'
    qbf-lang[ 8] = 'Lignes entre corps/bas de page'
		  /*1234567890123456789012345678901*/
    qbf-lang[ 9] = 'Espacement'
    qbf-lang[10] = 'Espace inter-ligne doit ˆtre entre 1 et taille de la page'
    qbf-lang[11] = 'pas de longueur n‚gative pour la page'
    qbf-lang[12] = 'La colonne la plus … gauche est la colonne 1'
    qbf-lang[13] = 'SVP, que cette valeur soit raisonnable...'
    qbf-lang[14] = 'Le plus haut pour l''‚dition est la ligne 1'

/*r-set.p*/        /* format x(30) for 15..22 */
    qbf-lang[15] = 'F.  Formats et Libell‚s'
    qbf-lang[16] = 'P.  Sauts de Pages'
    qbf-lang[17] = 'S.  Sans ligne de d‚tail'
    qbf-lang[18] = 'E.  Espacement'
    qbf-lang[19] = 'EG. Entˆte Gauche'
    qbf-lang[20] = 'EC. Entˆte Centre'
    qbf-lang[21] = 'ED. Entˆte Droite'
    qbf-lang[22] = 'BG. Bas de page Gauche'
    qbf-lang[23] = 'BC. Bas de page Centr‚'
    qbf-lang[24] = 'BD. Bas de page Droit'
    qbf-lang[25] = 'EP. Entˆte PremiŠre page'
    qbf-lang[26] = 'BD. Bas de page Dern. page'
    qbf-lang[32] = '[' + KBLABEL("END-ERROR")
		 + '] pour Terminer.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
    /* r-main.p,s-page.p */
    qbf-lang[ 1] = 'Table:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Tri  :'
    qbf-lang[ 3] = 'Informations Edition'
    qbf-lang[ 4] = 'Format Edition'
    qbf-lang[ 5] = 'Plus' /* for <<more and more>> */
    qbf-lang[ 6] = 'Largeur,Edition' /* each word comma-separated */
    qbf-lang[ 7] = 'Utiliser < et > pour d‚rouler l''‚dition … gauche et droite'
    qbf-lang[ 8] = 'Vous ne pouvez g‚n‚rer une ‚dition avec plus de 255 car.'
    qbf-lang[ 9] = 'Vous n''avez pas effac‚ cette ‚dition. Voulez-vous '
		 + 'continuer?'
    qbf-lang[10] = 'G‚n‚ration du programme...'
    qbf-lang[11] = 'Compilation du programme g‚n‚r‚...'
    qbf-lang[12] = 'Ex‚cution du programme g‚n‚r‚...'
    qbf-lang[13] = 'Impossible d''‚crire sur le fichier ou sortie...'
    qbf-lang[14] = 'Voulez-vous effacer la d‚finition de l''‚dition courante?'
    qbf-lang[15] = 'Voulez-vous quitter ce module?'

    qbf-lang[16] = '['
		 + (IF KBLABEL("CURSOR-UP") BEGINS "CTRL-" THEN 'CURSOR-UP'
		   ELSE KBLABEL("CURSOR-UP"))
		 + '] et ['
		 + (IF KBLABEL("CURSOR-DOWN") BEGINS "CTRL-" THEN 'CURSOR-DOWN'
		   ELSE KBLABEL("CURSOR-DOWN"))
		 + '] pour se d‚placer, ['
		 + KBLABEL("END-ERROR") + '] pour terminer.'
    qbf-lang[17] = 'Page'
    qbf-lang[18] = '~{1~} enreg. inclus dans l''‚dition.'
    qbf-lang[19] = 'Impossible de g‚n‚rer un total sans tris d‚finis.'
    qbf-lang[20] = 'Impossible de g‚n‚rer un total sur des champs '
		 + 'tableaux.'
    qbf-lang[21] = 'Totaux Uniquement'
    qbf-lang[22] = 'balayer avec le pav‚ curseurs; '
		 + 'ou entrer la chaine … rechercher et ['
		 + KBLABEL("RETURN") + '].'
    qbf-lang[23] = 'Impossible de g‚n‚rer une ‚dition sans colonne d‚finie.'.

ELSE

/*--------------------------------------------------------------------------*/
/* FAST TRACK interface test for r-ft.p r-ftsub.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = '/* FAST TRACK ne supporte pas les sorties terminal quand'
    qbf-lang[ 2] = ' vous demandez la saisie de valeur. Sortie vers PRINTER. */'
    qbf-lang[ 3] = 'Analyse entˆtes et bas de page...'
    qbf-lang[ 4] = 'Cr‚ation des ruptures...'
    qbf-lang[ 5] = 'Cr‚ation champs et cumuls...'
    qbf-lang[ 6] = 'Cr‚ation champs et clauses WHERE...'
    qbf-lang[ 7] = 'Cr‚ation entˆtes et bas de page...'
    qbf-lang[ 8] = 'Cr‚ation colonnes de l''‚dition...'
    qbf-lang[ 9] = 'il y a d‚j… une ‚dition appel‚e ~{1~} dans FAST TRACK. '
		 + 'Voulez-vous le remplacer?'
    qbf-lang[10] = 'Remplacement de l''‚dition...'
    qbf-lang[11] = 'Voulez-vous d‚marrer FAST TRACK?'
    qbf-lang[12] = 'Entrer un nom'
    qbf-lang[13] = 'FAST TRACK ne supporte pas TIME en entˆte/base de page, '
		 + 'remplac‚ par NOW.'
    qbf-lang[14] = 'FAST TRACK ne supporte pas % du total, champs omis'
    qbf-lang[15] = 'FAST TRACK ne supporte pas ~{1~} en entˆte/bas de page, '
		 + '~{2~} omis.'
    qbf-lang[16] = 'Les noms d''‚ditions ne peuvent pas contenir de carac'
		 + 'tŠres "_".'
    qbf-lang[17] = 'Nom de l''‚dition dans FAST TRACK:'
    qbf-lang[18] = 'Edition non transf‚r‚e dans FAST TRACK'
    qbf-lang[19] = 'Lancement de FAST TRACK...'
    qbf-lang[20] = 'ProblŠmes de ~{ ou ~} dans entˆte/base de page, '
		 + '‚dition NON transf‚r‚e.'
    qbf-lang[21] = 'FAST TRACK ne supporte pas premiŠre/derniŠre entˆte: '
		 + 'ignor‚.'
    qbf-lang[22] = 'ALERTE: D‚marr‚ nombre ~{2~} utilis‚ comme compteur.'
    qbf-lang[23] = 'CONTIENT'
    qbf-lang[24] = 'TOTAL,COUNT,MAX,MIN,AVG'
    qbf-lang[25] = 'FAST TRACK ne supporte les totaux cumul‚s.  '
		 + 'L''‚dition ne peut etre transf‚f‚e.'
    qbf-lang[26] = 'Impossible de transf‚rer une ‚dition vers FAST TRACK quand'
		 + ' aucun champ n''a ‚t‚ d‚fini.'.

ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 5 THEN
  ASSIGN
    /* r-short.p */
    qbf-lang[ 1] = 'Activer un "Pas de d‚tail" interdit … l''‚dition de '
		 + 'montrer les d‚tails. Bas‚ sur le dernier champ '
		 + 'de votre liste de "tri", un saut de ligne '
		 + 'apparaitra … chaque rupture de cette valeur.'
		 + '^Pour cette ‚dition, un saut de ligne sera ins‚r‚'
		 + ' … chaque changement de ~{1~} .^Activer ce mode?'
    qbf-lang[ 2] = '  OUI'
    qbf-lang[ 3] = '  NON'
    qbf-lang[ 4] = 'Vous ne pouvez activer cette option tant que vous n'''
		 + 'avez pas choisi de champs de "Tri" pour votre ‚dition.^^'
		 + 'S‚lectionner ces critŠres de tris par l''option "Tri" '
		 + 'du menu et r‚essayer alors cette option.'
    qbf-lang[ 5] = 'Cette liste recence tous champs d‚finis pour cette ‚dition.'
    qbf-lang[ 6] = 'Ceux s‚lectionn‚s seront group‚s.'
    qbf-lang[ 7] = 'Si vous s‚lectionnez un champ num. … grouper, un sous- '
		 + 'total apparaitra pour ce champs dŠs que la valeur de ~{1~} '
		 + 'changera.'
    qbf-lang[ 8] = 'Si vous s‚lectionnez un champ non num‚rique, il apparaitra '
		 + 'le nombre d''enregistrements dans chaque groupe ~{1~}.'
    qbf-lang[ 9] = 'Si vous ne groupez pas un champ, alors la valeur contenue '
		 + 'dans le dernier enregistrement du groupe apparaitra.'

    /* r-page.p */
    qbf-lang[26] = 'Sauts de page'
    qbf-lang[27] = 'Pas de saut de page'
	       /*   123456789012345678901234567890123456789012 */
    qbf-lang[28] = 'Quand la valeur d''un de ces champs est'
    qbf-lang[29] = 'modifi‚e, l''‚dition peut changer de page'
    qbf-lang[30] = 'automatiquement.'
    qbf-lang[31] = 'Choisir le champ de rupture dans la liste'
    qbf-lang[32] = 'qui suit.'.

/*--------------------------------------------------------------------------*/

RETURN.
