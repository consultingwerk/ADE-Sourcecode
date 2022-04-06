/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
    qbf-lang[ 3] = 'Ces fonctions sont utilisables dans l''entete et bas'
		 + ' de page'
    qbf-lang[ 4] = '~{COUNT~}  Nombre d''enreg. listes  :  '
		 + '~{TIME~}  Date de depart'
    qbf-lang[ 5] = '~{TODAY~}  Date du jour            :  '
		 + '~{NOW~}   Heure courante'
    qbf-lang[ 6] = '~{PAGE~}   page courante           :  '
		 + '~{USER~}  Nom de l''utilisateur'
    qbf-lang[ 7] = '~{VALUE <expression>~;<format>~} Inserer une valeur'
		 + ' (touche [' + KBLABEL("GET") + '])'
    qbf-lang[ 8] = 'Choisir le champ a inserer'
    qbf-lang[ 9] = '[' + KBLABEL("GO") + '] Sauver, ['
		 + KBLABEL("GET") + '] Ajouter champ, ['
		 + KBLABEL("END-ERROR") + '] Annuler.'

/*r-total.p*/    /*"|---------------------------|"*/
    qbf-lang[12] = 'Executer ces actions:'
		 /*"|--------------------------------------------|"*/
    qbf-lang[13] = 'Quand ces champs changent de valeur:'
		 /*"|---| |---| |---| |---| |---|" */
    qbf-lang[14] = 'Total -Nb-- -Min- -Max- -Avg-'
    qbf-lang[15] = 'Ligne resumee'
    qbf-lang[16] = 'Champs   :'
    qbf-lang[17] = 'Choisir le champ a totaliser'

/*r-calc.p*/
    qbf-lang[18] = 'Choisir la colonne de total courant'
    qbf-lang[19] = 'Choisir la colonne pour le % du total'
    qbf-lang[20] = 'Total courant'
    qbf-lang[21] = '% Total'
    qbf-lang[22] = 'Chaine,Date,Logique,Math,Numerique'
    qbf-lang[23] = 'Valeur'
    qbf-lang[24] = 'Entrer le nombre de depart pour le compteur'
    qbf-lang[25] = 'Entrer l''increment (positif ou negatif)'
    qbf-lang[26] = 'Compteurs'
    qbf-lang[27] = 'Compteur'
		 /*"------------------------------|"*/
    qbf-lang[28] = 'Nombre de depart pour compteurs' /*right justify*/
    qbf-lang[29] = '    Pour chaque enreg., ajouter' /*right justify*/
    qbf-lang[32] = 'Vous avez atteint le nombre maximum de colonnes.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN
/* r-space.p */  /*"------------------------------|  ---------|  |------"*/
    qbf-lang[ 1] = '             Option                 Courant   Defaut'
    /* 2..8 must be less than 32 characters long */
    qbf-lang[ 2] = 'Marge gauche'
    qbf-lang[ 3] = 'Espaces entre colonnes'
    qbf-lang[ 4] = 'Ligne de depart'
    qbf-lang[ 5] = 'Lignes par page'
    qbf-lang[ 6] = 'Espace inter lignes'
    qbf-lang[ 7] = 'Lignes entre entete/corps page'
    qbf-lang[ 8] = 'Lignes entre corps/bas de page'
		  /*1234567890123456789012345678901*/
    qbf-lang[ 9] = 'Espacement'
    qbf-lang[10] = 'Espace inter-ligne doit etre entre 1 et taille de la page'
    qbf-lang[11] = 'pas de longueur negative pour la page'
    qbf-lang[12] = 'La colonne la plus a gauche est la colonne 1'
    qbf-lang[13] = 'SVP, que cette valeur soit raisonnable...'
    qbf-lang[14] = 'Le plus haut pour l''edition est la ligne 1'

/*r-set.p*/        /* format x(30) for 15..22 */
    qbf-lang[15] = 'F.  Formats et Libelles'
    qbf-lang[16] = 'P.  Sauts de Pages'
    qbf-lang[17] = 'S.  Sans ligne de detail'
    qbf-lang[18] = 'E.  Espacement'
    qbf-lang[19] = 'EG. Entete Gauche'
    qbf-lang[20] = 'EC. Entete Centre'
    qbf-lang[21] = 'ED. Entete Droite'
    qbf-lang[22] = 'BG. Bas de page Gauche'
    qbf-lang[23] = 'BC. Bas de page Centre'
    qbf-lang[24] = 'BD. Bas de page Droit'
    qbf-lang[25] = 'EP. Entete Premiere page'
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
    qbf-lang[ 7] = 'Utiliser < et > pour derouler l''edition a gauche et droite'
    qbf-lang[ 8] = 'Vous ne pouvez generer une edition avec plus de 255 car.'
    qbf-lang[ 9] = 'Vous n''avez pas efface cette edition. Voulez-vous '
		 + 'continuer?'
    qbf-lang[10] = 'Generation du programme...'
    qbf-lang[11] = 'Compilation du programme genere...'
    qbf-lang[12] = 'Execution du programme genere...'
    qbf-lang[13] = 'Impossible d''ecrire sur le fichier ou sortie...'
    qbf-lang[14] = 'Voulez-vous effacer la definition de l''edition courante?'
    qbf-lang[15] = 'Voulez-vous quitter ce module?'

    qbf-lang[16] = '['
		 + (IF KBLABEL("CURSOR-UP") BEGINS "CTRL-" THEN 'CURSOR-UP'
		   ELSE KBLABEL("CURSOR-UP"))
		 + '] et ['
		 + (IF KBLABEL("CURSOR-DOWN") BEGINS "CTRL-" THEN 'CURSOR-DOWN'
		   ELSE KBLABEL("CURSOR-DOWN"))
		 + '] pour se deplacer, ['
		 + KBLABEL("END-ERROR") + '] pour terminer.'
    qbf-lang[17] = 'Page'
    qbf-lang[18] = '~{1~} enreg. inclus dans l''edition.'
    qbf-lang[19] = 'Impossible de generer un total sans tris definis.'
    qbf-lang[20] = 'Impossible de generer un total sur des champs '
		 + 'tableaux.'
    qbf-lang[21] = 'Totaux Uniquement'
    qbf-lang[22] = 'balayer avec le pave curseurs; '
		 + 'ou entrer la chaine a rechercher et ['
		 + KBLABEL("RETURN") + '].'
    qbf-lang[23] = 'Impossible de generer une edition sans colonne definie.'.

ELSE

/*--------------------------------------------------------------------------*/
/* FAST TRACK interface test for r-ft.p r-ftsub.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = '/* FAST TRACK ne supporte pas les sorties terminal quand'
    qbf-lang[ 2] = ' vous demandez la saisie de valeur. Sortie vers PRINTER. */'
    qbf-lang[ 3] = 'Analyse entetes et bas de page...'
    qbf-lang[ 4] = 'Creation des ruptures...'
    qbf-lang[ 5] = 'Creation champs et cumuls...'
    qbf-lang[ 6] = 'Creation champs et clauses WHERE...'
    qbf-lang[ 7] = 'Creation entetes et bas de page...'
    qbf-lang[ 8] = 'Creation colonnes de l''edition...'
    qbf-lang[ 9] = 'il y a deja une edition appelee ~{1~} dans FAST TRACK. '
		 + 'Voulez-vous le remplacer?'
    qbf-lang[10] = 'Remplacement de l''edition...'
    qbf-lang[11] = 'Voulez-vous demarrer FAST TRACK?'
    qbf-lang[12] = 'Entrer un nom'
    qbf-lang[13] = 'FAST TRACK ne supporte pas TIME en entete/base de page, '
		 + 'remplace par NOW.'
    qbf-lang[14] = 'FAST TRACK ne supporte pas % du total, champs omis'
    qbf-lang[15] = 'FAST TRACK ne supporte pas ~{1~} en entete/bas de page, '
		 + '~{2~} omis.'
    qbf-lang[16] = 'Les noms d''editions ne peuvent pas contenir de carac'
		 + 'teres "_".'
    qbf-lang[17] = 'Nom de l''edition dans FAST TRACK:'
    qbf-lang[18] = 'Edition non transferee dans FAST TRACK'
    qbf-lang[19] = 'Lancement de FAST TRACK...'
    qbf-lang[20] = 'Problemes de ~{ ou ~} dans entete/base de page, '
		 + 'edition NON transferee.'
    qbf-lang[21] = 'FAST TRACK ne supporte pas premiere/derniere entete: '
		 + 'ignore.'
    qbf-lang[22] = 'ALERTE: Demarre nombre ~{2~} utilise comme compteur.'
    qbf-lang[23] = 'CONTIENT'
    qbf-lang[24] = 'TOTAL,COUNT,MAX,MIN,AVG'
    qbf-lang[25] = 'FAST TRACK ne supporte les totaux cumules.  '
		 + 'L''edition ne peut etre transfefee.'
    qbf-lang[26] = 'Impossible de transferer une edition vers FAST TRACK quand'
		 + ' aucun champ n''a ete defini.'.

ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 5 THEN
  ASSIGN
    /* r-short.p */
    qbf-lang[ 1] = 'Activer un "Pas de detail" interdit a l''edition de '
		 + 'montrer les details. Base sur le dernier champ '
		 + 'de votre liste de "tri", un saut de ligne '
		 + 'apparaitra a chaque rupture de cette valeur.'
		 + '^Pour cette edition, un saut de ligne sera insere'
		 + ' a chaque changement de ~{1~} .^Activer ce mode?'
    qbf-lang[ 2] = '  OUI'
    qbf-lang[ 3] = '  NON'
    qbf-lang[ 4] = 'Vous ne pouvez activer cette option tant que vous n'''
		 + 'avez pas choisi de champs de "Tri" pour votre edition.^^'
		 + 'Selectionner ces criteres de tris par l''option "Tri" '
		 + 'du menu et reessayer alors cette option.'
    qbf-lang[ 5] = 'Cette liste recence tous champs definis pour cette edition.'
    qbf-lang[ 6] = 'Ceux selectionnes seront groupes.'
    qbf-lang[ 7] = 'Si vous selectionnez un champ num. a grouper, un sous- '
		 + 'total apparaitra pour ce champs des que la valeur de ~{1~} '
		 + 'changera.'
    qbf-lang[ 8] = 'Si vous selectionnez un champ non numerique, il apparaitra '
		 + 'le nombre d''enregistrements dans chaque groupe ~{1~}.'
    qbf-lang[ 9] = 'Si vous ne groupez pas un champ, alors la valeur contenue '
		 + 'dans le dernier enregistrement du groupe apparaitra.'

    /* r-page.p */
    qbf-lang[26] = 'Sauts de page'
    qbf-lang[27] = 'Pas de saut de page'
	       /*   123456789012345678901234567890123456789012 */
    qbf-lang[28] = 'Quand la valeur d''un de ces champs est'
    qbf-lang[29] = 'modifiee, l''edition peut changer de page'
    qbf-lang[30] = 'automatiquement.'
    qbf-lang[31] = 'Choisir le champ de rupture dans la liste'
    qbf-lang[32] = 'qui suit.'.

/*--------------------------------------------------------------------------*/

RETURN.
