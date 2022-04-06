/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-a-eng.p - English language definitions for Admin module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/*results.p,s-module.p*/
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'R. Requetes'
    qbf-lang[ 2] = 'E. Editions'
    qbf-lang[ 3] = 'T. Etiquettes'
    qbf-lang[ 4] = 'X. Exportations'
    qbf-lang[ 5] = 'U. Utilisateur'
    qbf-lang[ 6] = 'A. Administration'
    qbf-lang[ 7] = 'F. Fin'
    qbf-lang[ 8] = 'T. FAST-TRACK'
    qbf-lang[10] = 'Le fichier' /*DBNAME.qc*/
    qbf-lang[11] = 'n''a pas ete trouve. Cela veut dire qu''il faut passer par'
		 + ' sa creation. Voulez-vous le faire maintenant ?'
    qbf-lang[12] = 'Choisissez le module ou [' + KBLABEL("END-ERROR")
		 + '] pour rester dans ce module'
    qbf-lang[13] = 'Vous n''avez pas achete RESULTS. Fin de programme.'
    qbf-lang[14] = 'Voulez-vous vraiment quitter "~{1~}" maintenant ?'
    qbf-lang[15] = 'MANUEL,SEMI,AUTO'
    qbf-lang[16] = 'Il n''y a pas de base connectee.'
    qbf-lang[17] = 'Impossible d''executer une base dont le nom logique'
		 + 'commence par "QBF$".'
    qbf-lang[18] = 'Terminer'
    qbf-lang[19] = '** RESULTS ne comprend pas **^^Dans le repertoire ~{1~}, '
		 + 'ni ~{2~}.db ni ~{2~}.qc ne peuvent etre trouves.  ~{3~}.qc '
		 + 'a ete vu dans le PROPATH, mais il appartient a '
		 + '~{3~}.db.  Renommez votre PROPATH ou renommer/supprimer'
		 + '~{3~}.db et .qc.'
    /* 24,26,30,32 available if necessary */

    qbf-lang[21] = 'Voici les trois facons de construire des modules '
		    + 'de requetes pour'
    qbf-lang[22] = ' RESULTS de PROGRESS.'

    qbf-lang[25] = 'Vous voulez definir manuellement chaque requete.'

    qbf-lang[27] = 'Apres avoir selectionne un sous-ensemble de tables,'
    qbf-lang[28] = 'RESULTS genere les requetes pour ces tables.'

    qbf-lang[31] = 'RESULTS genere les modules de requetes automatiquement.'.


/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-user.p*/
IF qbf-s = 2 THEN
  /* format x(72) for 1,2,9-14,19-22 */
  ASSIGN
    qbf-lang[ 1] = 'Entrez le nom du fichier ''include'' a utiliser ' +
		   'pour l''option'
    qbf-lang[ 2] = 'Visualisation du module requete.'
    qbf-lang[ 3] = ' Fichier include defaut:' /*format x(24)*/

    qbf-lang[ 8] = 'Programme introuvable'

    qbf-lang[ 9] = 'Entrer le nom du programme d''entree. Ce programme peut '
		 + 'etre soit'
    qbf-lang[10] = 'un simple logo, soit une procedure de connection comme '
		 + '"login.p"'
    qbf-lang[11] = 'dans "DLC".  Ce programme est lance aussitot que la ligne'
    qbf-lang[12] = '"signon=" est lue dans le fichier DBNAME.qc.'
    qbf-lang[13] = 'Entrez le nom du produit que vous voulez afficher sur le'
    qbf-lang[14] = 'menu principal.'
    qbf-lang[15] = '      Programme sign-on:' /*format x(24)*/
    qbf-lang[16] = '         Nom du produit:' /*format x(24)*/
    qbf-lang[17] = 'Par defaut:'

    qbf-lang[18] = 'Procedure utilisateur PROGRESS:'
    qbf-lang[19] = 'Cette procedure est celle lancee par l''option "Utilisateur'
		 + '".'

    qbf-lang[20] = 'Cela autorise le lancement d''un module utilisateur.'
    qbf-lang[21] = 'Entrez le nom de la procedure et son descriptif'
    qbf-lang[22] = 'pour le menu "Exportations - Param.".'
    qbf-lang[23] = 'Procedure:'
    qbf-lang[24] = 'Descriptif:'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-load.p:*/
IF qbf-s = 3 THEN
  ASSIGN
    /* menu strip for d-main.p,l-main.p,r-main.p */
    qbf-lang[ 1] = 'Recup.,Recuperer une ~{1~} existante.'
    qbf-lang[ 2] = 'Sauve,Sauver l''~{1~} courante.'
    qbf-lang[ 3] = 'Lance,Execute l''~{1~} courante.'
    qbf-lang[ 4] = 'Def.,Selectionner les tables et colonnes.'
    qbf-lang[ 5] = 'Param.,Modifier le type, ' +
		   'format et formes de l''~{1~} courante.'
    qbf-lang[ 6] = 'Cond.,Definit les selections de lignes.'
    qbf-lang[ 7] = 'Tri,Modifie l''ordre d''apparitions des lignes.'
    qbf-lang[ 8] = 'Eff.,Efface l''~{1~} courante.'
    qbf-lang[ 9] = 'Infos,Information sur les parametres courants.'
    qbf-lang[10] = 'Module,Changement de module.'
    qbf-lang[11] = 'Util.,Passage au module utilisateur.'
    qbf-lang[12] = 'Fin,Fin.'
    qbf-lang[13] = '' /* terminator */
    qbf-lang[14] = 'Exportation,Etiquette,Edition'

    qbf-lang[15] = 'Lecture du fichier de configuration...'

    /* system values for CONTINUE Must be <= 12 characters */
    qbf-lang[18] = '  Continuer' /* for error dialog box */
    qbf-lang[19] = 'Francais' /* this name of this language */
    /* word "of" for "xxx of yyy" on scrolling lists */
    qbf-lang[20] = 'sur'
    /* standard product name */
    qbf-lang[22] = 'RESULTS de PROGRESS'
    /* system values for descriptions of calc fields */
    qbf-lang[23] = ',Total courant,% du total,Fonctions Enum.,'
		 + 'Expressions Car., Expressions Date,'
		 + 'Expressions Numeriques,Expressions Logiques,'
		 + 'Tableaux Empilees'
    /* system values for YES and NO.  Must be <= 8 characters each */
    qbf-lang[24] = '  Oui  ,  Non ' /* for yes/no dialog box */

    qbf-lang[25] = 'La construction automatique en cours a ete interrompue.'
		 + 'Continuer ?'

    qbf-lang[26] = '* ALERTE - Erreur version *^^Version courante '
		 + '<~{1~}> alors que .qc est de version <~{2~}>.'

    qbf-lang[27] = '* ALERTE - Bases manquantes *^^Les bases '
		 + 'suivantes sont necessaires mais ne sont pas connectees:'

    qbf-lang[30] = 'CONTINUER'
    qbf-lang[31] = 'TERMINER'

    qbf-lang[32] = '* ALERTE - Schema modifie *^^La structure de la base a '
		 + 'ete modifie depuis que des formes ont ete creees.  '
		 + 'Utiliser "Reconstruction Application" du menu Admin. '
		 + 'aussi rapidement que possible.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-main.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = " A. Reconstruction Application"
    qbf-lang[ 2] = " F. Definitions Formes pour Req."
    qbf-lang[ 3] = " R. Relations entre tables"

    qbf-lang[ 4] = " C. Contenu d'un repertoire"
    qbf-lang[ 5] = " Q. Comment quitter l'application"
    qbf-lang[ 6] = " M. Permissions Module"
    qbf-lang[ 7] = " R. Permissions Requetes"
    qbf-lang[ 8] = " N. Nom du produit de connection"

    qbf-lang[11] = " G. Langue"
    qbf-lang[12] = " P. Configuration des imprimantes"
    qbf-lang[13] = " T. Definition des couleurs"

    qbf-lang[14] = " B. Programme de visualisation"
    qbf-lang[15] = " D. Options Edition par defaut"
    qbf-lang[16] = " E. Format specifique d'export"
    qbf-lang[17] = " L. Selection format etiquettes"
    qbf-lang[18] = " U. Option utilisateur"

    qbf-lang[21] = 'Choisir une option ou [' + KBLABEL("END-ERROR")
		 + '] pour quitter et sauver les modifications.'
    /* these next four have a length limit of 20 including colon */
    qbf-lang[22] = 'Fichiers:'
    qbf-lang[23] = 'Configuration:'
    qbf-lang[24] = 'Securite:'
    qbf-lang[25] = 'Modules:'

    qbf-lang[26] = 'Administration'
    qbf-lang[27] = 'Version'
    qbf-lang[28] = 'Chargement des informations supplementaires du '
		 + 'fichier de configuration'
    qbf-lang[29] = 'Reconstruire l''application ?'
/* QUIT and RETURN are the PROGRESS keywords and cannot be translated */
    qbf-lang[30] = 'Quand l''utilisateur quitte le menu principal, doit-on '
		 + 'lancer un Quit ou un Return?'
    qbf-lang[31] = 'Voulez-vous quitter le menu Administration maintenant?'
    qbf-lang[32] = 'Verification des modifications de la structure du fichier '
		 + 'configuration.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 5 THEN
  ASSIGN
/*a-perm.p, 1..7 also used by a-form.p and a-print.p*/
    qbf-lang[ 1] = 'Permissions'
    qbf-lang[ 2] = '    *                   - Tous ont acces.'
    qbf-lang[ 3] = '    <x>,<x>,etc.        - Seuls les <x> y ont acces.'
    qbf-lang[ 4] = '    !<x>,!<x>,*         - Tous sauf les <x> y ont acces.'
    qbf-lang[ 5] = '    x*                  - Seuls ceux commencant par '
		 + '"x" sont autorises'
    qbf-lang[ 6] = 'Enumerer tous les userid, et les separer par des virgules.'
    qbf-lang[ 7] = 'Les userid peuvent contenir les caracteres "joker".'
		   /* from 8 thru 13, format x(30) */
    qbf-lang[ 8] = 'Choisir un module de la liste'
    qbf-lang[ 9] = 'a gauche pour mettre a jour'
    qbf-lang[10] = 'les droits d''acces'
    qbf-lang[11] = 'Choisir un module de la liste'
    qbf-lang[12] = 'a gauche pour mettre a jour'
    qbf-lang[13] = 'les droits d''aces de.'
    qbf-lang[14] = '[' + KBLABEL("END-ERROR")
		 + '] pour valider les modifications.'
    qbf-lang[15] = '[' + KBLABEL("GO") + '] Sauver, ['
		 + KBLABEL("END-ERROR") + '] Annuler les modifications.'
    qbf-lang[16] = 'Vous ne pouvez vous exclure de l''administration.'
/*a-print.p:*/     /*21 thru 26 must be format x(16) and right-justified */
    qbf-lang[21] = '  Initialisation'
    qbf-lang[22] = '                '
    qbf-lang[23] = '    Imp. normale'
    qbf-lang[24] = '       Compresse'
    qbf-lang[25] = '     Gras active'
    qbf-lang[26] = '  Gras desactive'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 6 THEN
  ASSIGN
/*a-write.p:*/
    qbf-lang[ 1] = 'Chargement module'
    qbf-lang[ 2] = 'Chargement couleurs'
    qbf-lang[ 3] = 'Chargement configuration imprimante'
    qbf-lang[ 4] = 'Chargement liste des fichiers visualisable'
    qbf-lang[ 5] = 'Chargement liste des relations'
    qbf-lang[ 6] = 'Chargement des champs par defaut des etiquettes'
    qbf-lang[ 7] = 'Chargement des permissions pour les requetes'
    qbf-lang[ 8] = 'Chargement informations utilisateur'
    qbf-lang[ 9] = 'Chargement parametres par defaut'

/* a-color.p*/
		 /* 12345678901234567890123456789012 */
    qbf-lang[11] = ' Couleurs pour ce type de term.:' /* must be 32 */
		 /* 1234567890123456789012345 */
    qbf-lang[12] = 'Menu:             Normal:' /* must be 25 */
    qbf-lang[13] = '             Selectionne:'
    qbf-lang[14] = 'Dialog Box:       Normal:'
    qbf-lang[15] = '             Selectionne:'
    qbf-lang[16] = 'Scrolling List:   Normal:'
    qbf-lang[17] = '             Selectionne:'

/*a-field.p*/    /*"----- ----- ----- ----- ----"*/
    qbf-lang[30] = 'Voir? maj?  Req?  Visu?  Seq'
    qbf-lang[31] = 'Doit etre entre 1 et 9999.'
    qbf-lang[32] = 'Voulez-vous sauver les modifications de la liste des '
		 + 'champs ?'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 8 THEN
/*a-label.p*/
  ASSIGN            /* 1..8 use format x(78) */
		    /* 1 and 8 are available for more explanation, in */
		    /*   case the translation won't fit in 2 thru 7.  */
    qbf-lang[ 2] = 'Entrer les noms de champs qui ont les infos adresses.  '
		 + 'Utiliser le '
    qbf-lang[ 3] = 'format CAN-DO pour choisir ces champs ("*" remplace '
		 + 'tout caracte-'
    qbf-lang[ 4] = 'res, "." remplace un caractere).  Cette'
		 + ' information est '
    qbf-lang[ 5] = 'utilisee pour les entetes de mailing. Noter que des '
		 + 'entrees '
    qbf-lang[ 6] = 'peuvent etre redondantes.'
    qbf-lang[ 7] = ''
		  /* each entry in list must be <= 5 characters long */
		  /* but may be any portion of address that is applicable */
		  /* in the target country */
    qbf-lang[ 9] = 'Nom,Adresse,Adresse2,Adresse3,Ville,bp,cp,cp+4,V-E-C,Pays'
    qbf-lang[10] = 'Champ contenant <Nom>'
    qbf-lang[11] = 'Champ contenant <prem.> ligne d''adresse (= Rue)'
    qbf-lang[12] = 'Champ contenant <deux.> ligne d''adresse (= Cp)'
    qbf-lang[13] = 'Champ contenant <trois.> ligne d''adresse (facultatif)'
    qbf-lang[14] = 'Champ contenant nom de <ville>'
    qbf-lang[15] = 'Champ contenant nom de l''<etat>'
    qbf-lang[16] = 'Champ contenant <Codepost> (5 or 9 chiffres)'
    qbf-lang[17] = 'Champ contenant <4 derniers chiffres> du Cp'
    qbf-lang[18] = 'Champ contenant <Ville+Etat+Cp>'
    qbf-lang[19] = 'Champ contenant <Pays>'

/*a-join.p*/
    qbf-lang[23] = 'Desole, les auto-jointures ne sont pas encore autorisees.'
    qbf-lang[24] = 'Le nombre maximum de relations a ete atteint.'
    qbf-lang[25] = 'Relation de' /* 25 and 26 are automatically */
    qbf-lang[26] = ' a'          /*   right-justified           */
    qbf-lang[27] = 'Entrer une clause WHERE ou OF : (blanc enleve la relation)'
    qbf-lang[28] = '[' + KBLABEL("END-ERROR") + '] pour terminer.'
    qbf-lang[30] = 'La commande doit commencer par WHERE ou OF.'
    qbf-lang[31] = 'Entrer premier fichier de la relation a ajouter ou enlever.'
    qbf-lang[32] = 'Entrer second fichier de la relation.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-form.p */
IF qbf-s = 9 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' A. Ajouter un format requete '
    qbf-lang[ 2] = ' C. Choisir requete a editer '
    qbf-lang[ 3] = ' G. Caracteristiques generales de la forme '
    qbf-lang[ 4] = ' Q. Quels champs dans la forme '
    qbf-lang[ 5] = ' P. Permissions '
    qbf-lang[ 6] = ' S. Supprimer requete courante '
    qbf-lang[ 7] = 'Selection:' /* format x(10) */
    qbf-lang[ 8] = 'Modifie  : ' /* format x(10) */
		 /* cannot changed width of 9..16 from defined below */
    qbf-lang[ 9] = '    Nom base de donnees' /* right-justify 9..14 */
    qbf-lang[10] = '          Type de forme'
    qbf-lang[11] = '   Nom prog. de requete'
    qbf-lang[12] = '  Nom phys. de la forme'
    qbf-lang[13] = ' Nom de la Frame en L4G'
    qbf-lang[14] = '             Descriptif'
    qbf-lang[15] = '(.p assume)     ' /* left-justify 15 and 16 */
    qbf-lang[16] = '(demande extension)'
    qbf-lang[18] = 'Cette forme est trop longue de ~{1~} lignes. RESULTS'
		 + 'se reserve 5 lignes pour son usage. Etes-vous sur de '
		 + 'vouloir definir une forme de cette taille ?'
    qbf-lang[19] = 'Une requete porte deja ce nom.'
    qbf-lang[20] = 'Cette forme doit deja exister ou doit finir avec un .f '
		 + 'pour la generation automatique.'
    qbf-lang[21] = 'Le nom selectionne est un mot-cle du L4G PROGRESS.  '
		 + 'Choisissez un autre.'
    qbf-lang[22] = ' Selectionner les fichiers adressables'
    qbf-lang[23] = '[' + KBLABEL("END-ERROR") + '] pour terminer'
    qbf-lang[24] = 'Sauvegarde des informations...'
    qbf-lang[25] = 'Vous avez modifie au moins une forme requete. Vous '
		 + 'pouvez soit recompiler maintenant ou faire une '
		 + '"reconstruction d''application" plus tard. '
		 + 'Compiler maintenant ?'
    qbf-lang[26] = 'Aucune requete appelee "~{1~}" n''a ete trouvee. '
		 + 'Voulez-vous la generer ?'
    qbf-lang[27] = 'Une requete appelee "~{1~}" existe.  Utiliser les champ'
		 + ' de cette forme ?'
    qbf-lang[28] = 'Voulez-vous detruire la forme de cette requete '
    qbf-lang[29] = '** Programme requete "~{1~}" detruit. **'
    qbf-lang[30] = 'Export forme requete...'
    qbf-lang[31] = 'Le nombre maximum de formes a ete atteint.'
    qbf-lang[32] = 'Impossible de creer la forme pour ce fichier.^^Pour '
		 + 'construire une forme de requete, la GATEWAY doit '
		 + 'supporter les RECID ou doit avoir un index unique sur '
		 + 'cette table.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-print.p */
IF qbf-s = 10 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' A. Ajouter une nouvelle sortie '
    qbf-lang[ 2] = ' C. Choisir la sortie a editer '
    qbf-lang[ 3] = ' G. Caracteristiques generales de la sortie '
    qbf-lang[ 4] = ' S. Sequences de controles '
    qbf-lang[ 5] = ' P. Permissions imprimante '
    qbf-lang[ 6] = ' D. Detruire sortie courante '
    qbf-lang[ 7] = 'Selection:' /* format x(10) */
    qbf-lang[ 8] = 'Modifie  :' /* format x(10) */
    qbf-lang[ 9] = 'Doit etre entre 1 et 255'
    qbf-lang[10] = 'Le type doit etre term, thru, to, view, file, page ou prog'
    qbf-lang[11] = 'Le nombre maximum de sorties a ete atteint.'
    qbf-lang[12] = 'Seules les sorties "term" peuvent sortit vers TERMINAL.'
    qbf-lang[13] = 'Impossible de trouver les programme avec PROPATH.'
		  /*17 thru 20 must be format x(16) and right-justified */
		  /*1234567890123456*/
    qbf-lang[17] = ' Descr. listing'
    qbf-lang[18] = '     Nom sortie'
    qbf-lang[19] = '   Largeur max.'
    qbf-lang[20] = '           Type'
    qbf-lang[21] = 'voir dessous'
    qbf-lang[22] = 'TERMINAL, comme dans OUTPUT TO TERMINAL PAGED'
    qbf-lang[23] = 'TO <sortie>, comme OUTPUT TO PRINTER'
    qbf-lang[24] = 'Via un spooler ou un filtre'
    qbf-lang[25] = 'Envoyer l''edition vers un fichier, executer ce programme'
    qbf-lang[26] = 'Demander a l''utilisateur pour la sortie'
    qbf-lang[27] = 'Vers l''ecran avec le support page avant-arriere'
    qbf-lang[28] = 'Appeler un programme L4G pour la sortie'
    qbf-lang[30] = '[' + KBLABEL("END-ERROR") + '] pour terminer'
    qbf-lang[31] = 'Il doit y avoir au moins une sortie!'
    qbf-lang[32] = 'Voulez-vous detruire cette imprimante ?'.

/*--------------------------------------------------------------------------*/

RETURN.
