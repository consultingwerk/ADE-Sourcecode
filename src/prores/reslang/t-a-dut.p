/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-a-dut.p - Dutch language definitions for Admin module */
/* translation by Ton Voskuilen, PROGRESS Holland */
/* september, 1991 */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/*results.p,s-module.p*/
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'O. Opvragen'
    qbf-lang[ 2] = 'R. Rapporten'
    qbf-lang[ 3] = 'E. Etiketten'
    qbf-lang[ 4] = 'D. Data Export'
    qbf-lang[ 5] = 'X. Extra'
    qbf-lang[ 6] = 'A. Administratie'
    qbf-lang[ 7] = 'S. Stoppen'
    qbf-lang[ 8] = 'F. FAST TRACK'
    qbf-lang[10] = 'Bestand' /*DBNAME.qc*/
    qbf-lang[11] = 'niet gevonden.  RESULTS zal moeten worden'
                 + ' gekonfigureerd. Wilt u dit nu doen?'
    qbf-lang[12] = 'Selekteer module of gebruik de ['
                   + KBLABEL("END-ERROR") + '] toets voor de huidige module.'
    qbf-lang[13] = 'Uw licentie voldoet niet voor het gebruik van RESULTS. '
                   + 'Programma gestopt.'
    qbf-lang[14] = '"~{1~}" verlaten?'
    qbf-lang[15] = 'GEEN,ENKELE,ALLE'
    qbf-lang[16] = 'Er is geen database-naam opgegeven.'
    qbf-lang[17] = 'Het gebruik van een database met een logische naam '
                 + 'beginnend met "QBF$" is niet toegestaan.'
    qbf-lang[18] = 'Stoppen'
    qbf-lang[19] = '** Verwarrende situatie **^^In de ~{1~} directory, '
                 + 'kunnen zowel ~{2~}.db als ~{2~}.qc niet gevonden worden.'
                 + '~{3~}.qc was gevonden via PROPATH, maar die hoort bij '
                 + '~{3~}.db.  Kontroleer PROPATH, of verwijder/herbenoem '
                 + '~{3~}.db en .qc.'
    /* 24,26,30,32 available if necessary */
    qbf-lang[21] = 'U kunt RESULTS nu opvraagschermen voor de "OPVRAGEN" '
    qbf-lang[22] = 'module laten genereren. Ongeacht welke manier u kiest, '
    qbf-lang[23] = 'u kunt ze altijd achteraf handmatig wijzigen.'
    qbf-lang[25] = 'U laat nu geen enkel opvraagscherm genereren.'
    qbf-lang[27] = 'U laat nu enkele opvraagschermen genereren.'
    qbf-lang[28] = 'RESULTS laat u hierna kiezen voor welke'
    qbf-lang[29] = 'tabellen u de opvraagschermen laat genereren.'
    qbf-lang[31] = 'U laat nu automatisch alle opvraagschermen '
    qbf-lang[32] = 'genereren.'.


/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-user.p*/
IF qbf-s = 2 THEN
  /* format x(72) for 1,2,9-14,19-22 */
  ASSIGN
    qbf-lang[ 1] = 'Geef de naam van de "include file" die gebruikt moet worden'
    qbf-lang[ 2] = 'voor de "Overzicht" optie in de "Opvragen" module.'
    qbf-lang[ 3] = 'Standaard include-file:' /*format x(24)*/

    qbf-lang[ 8] = 'Programma niet gevonden.'

    qbf-lang[ 9] = 'Voer de naam in van het Opstart Programma. Dit programma '
                 + 'kan een'
    qbf-lang[10] = 'eenvoudig logo, of een kompleet autorisatie programma '
                 + 'zijn '
    qbf-lang[11] = '(bv. login.p). Dit programma zal worden uitgevoerd  '
                 + 'zodra de'
    qbf-lang[12] = '"signon=" regel wordt gelezen van het DBNAME.qc bestand.'
    qbf-lang[13] = 'Voer de naam van het produkt in zoals u het getoond'
    qbf-lang[14] = 'wilt hebben op het Hoofd Menu.'
    qbf-lang[15] = '      Opstart Programma:' /*format x(24)*/
    qbf-lang[16] = '           Produkt Naam:' /*format x(24)*/
    qbf-lang[17] = 'Standaards:'

    qbf-lang[18] = "PROGRESS Extra Programma's:"
    qbf-lang[19] = 'Dit programma wordt uitgevoerd als "Extra" wordt gekozen. '

    qbf-lang[20] = 'Dit maakt een zelf-geschreven "Data Export" programma '
                 + 'mogelijk.'
    qbf-lang[21] = 'Vul zowel de programma-naam in als ook de omschrijving'
    qbf-lang[22] = 'van het "Data Export - Instellingen" menu.'
    qbf-lang[23] = 'Programma:'
    qbf-lang[24] = 'Omschrijving:'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-load.p:*/
IF qbf-s = 3 THEN
  ASSIGN
    /* menu strip for d-main.p,l-main.p,r-main.p */
    qbf-lang[ 1] = 'Laad,Laad een reeds gedefinieerd ~{1~}.'
    qbf-lang[ 2] = 'Bewaar,Bewaar het huidige ~{1~}.'
    qbf-lang[ 3] = 'Voeruit,Maak het huidige ~{1~}.'
    qbf-lang[ 4] = 'Def,Definieer tabellen en velden.'
    qbf-lang[ 5] = 'Inst,Verander type, formaat of layout.'
    qbf-lang[ 6] = 'Kond,Kondities waaraan bestandsregels moeten voldoen.'
    qbf-lang[ 7] = 'Orde,Sortering van uitvoer.'
    qbf-lang[ 8] = 'Wis,Wis het huidige ~{1~}.'
    qbf-lang[ 9] = '*Info,Informatie over gebruikte velden/tabellen.'
    qbf-lang[10] = 'Module,Wissel naar andere module.'
    qbf-lang[11] = 'Extra,Voer zelf-gedefinieerd programma uit.'
    qbf-lang[12] = 'Stop,Verlaat deze module.'
    qbf-lang[13] = '' /* terminator */
    qbf-lang[14] = 'export,etiket,rapport'

    qbf-lang[15] = 'Konfiguratie-gegevens worden ingelezen...'

    /* system values for CONTINUE Must be <= 12 characters */
    qbf-lang[18] = '   Stoppen' /* for error dialog box */
    qbf-lang[19] = 'Nederlands' /* this name of this language */
    /* word "of" voor "xxx of yyy" o  "scrolling lists" */
    qbf-lang[20] = 'van'
    /* standard product name */
    qbf-lang[22] = 'PROGRESS RESULTS'
    /* system values for descriptions of calc fields */
    qbf-lang[23] = ',Totaal op totaal,Procent van totaal,Aantal,'
                 + 'Tekst funktie,Datum funktie,Numerieke funktie,'
                 + 'Logische funktie,Array velden?'
    /* system values for YES and NO.  Must be <= 8 characters each */
    qbf-lang[24] = '  Ja ,  Nee ' /* for yes/no dialog box */

    qbf-lang[25] = 'Het automatisch genereren werd afgebroken. '
                 + 'Wilt u hiermee verder gaan?'

    qbf-lang[26] = '* Let op - versie klopt niet *^^De huidige versie is '
                 + '<~{1~}> en de ".qc file?" is versie <~{2~}>.  Er '
                 + 'kunnen problemen zijn met "Opvragen" zolang u niet '
                 + 'kiest voor "Applikatie konfiguratie".'

    qbf-lang[27] = '* Let op - Databases ontbreken *^^De volgende  '
                 + 'database(s) zijn nodig maar nog niet opgegeven?:'

    qbf-lang[32] = '* Let op - Schema is veranderd *^^Het database schema '
                 + 'is veranderd. Er kunnen problemen zijn met "Opvragen" '
                 + 'zolang u niet kiest voor "Applikatie konfiguratie"'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-main.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = " A. Applikatie konfiguratie"
    qbf-lang[ 2] = " O. Opvraagscherm definities"
    qbf-lang[ 3] = " R. Relaties tussen tabellen"

    qbf-lang[ 4] = " G. Gebruikers directory"
    qbf-lang[ 5] = " H. Hoe applikatie te verlaten"
    qbf-lang[ 6] = " M. Module autorisatie"
    qbf-lang[ 7] = " O. Opvraag autorisatie"
    qbf-lang[ 8] = " S. Start programma/Produkt Naam"

    qbf-lang[11] = " T. Taal instelling"
    qbf-lang[12] = " U. Uitvoerbestemmingen"
    qbf-lang[13] = " K. Kleuren instellingen"

    qbf-lang[14] = " B. Verkort overzicht programma"
    qbf-lang[15] = " D. Standaard rapport inst."
    qbf-lang[16] = " Z. Zelf gedef. export formaat"
    qbf-lang[17] = " V. Etiket veld definities"
    qbf-lang[18] = " X. Extra programma's"

    qbf-lang[21] = 'Maak keuze of [' + KBLABEL("END-ERROR")
                 + '] voor veranderingen opslaan.'
    /* these next four have a length limit of 20 including colon */
    qbf-lang[22] = 'Bestanden:'
    qbf-lang[23] = 'Konfiguratie:'
    qbf-lang[24] = 'Beveiliging:'
    qbf-lang[25] = 'Modules:'

    qbf-lang[26] = 'Administratie'
    qbf-lang[27] = 'Versie'
    qbf-lang[28] = 'De konfiguratie gegevens worden van het '
                 + 'konfiguratie bestand ingelezen.'
    qbf-lang[29] = 'Weet u zeker dat u de applikatie wilt her-konfigureren?'
/* QUIT and RETURN are the PROGRESS keywords and cannot be translated */
    qbf-lang[30] = 'Als het Hoofd Menu wordt verlaten, moet dit programma '
                 + 'PROGRESS verlaten (Quit) of in de editor blijven (Return)?'
    qbf-lang[31] = 'Weet u zeker dat u Administratie wilt verlaten? '
    qbf-lang[32] = 'Konfiguratie bestand wordt gekontroleerd en veranderingen '
                 + 'opgeslagen.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 5 THEN
  ASSIGN
/*a-perm.p, 1..7 also used by a-form.p and a-print.p*/
    qbf-lang[ 1] = 'Toegang'
    qbf-lang[ 2] = '    *                  - Alle gebruikers hebben toegang.'
    qbf-lang[ 3] = '    Jan,Piet,...       - Jan,Piet,... hebben toegang.'
    qbf-lang[ 4] = '    !Jan,!Piet,*       - Jan,Piet hebben GEEN toegang.'
    qbf-lang[ 5] = '    afd*               - Alleen gebruikers beginnende '
                 + '"afd" hebben toegang.'
    qbf-lang[ 6] = 'Geef gebruikersnamen op, gescheiden door een komma.'
    qbf-lang[ 7] = 'Gebruikersnamen mogen ''wildcards'' hebben, gebruikers '
                 + 'uitsluiten mbv. "!".'
                   /* from 8 thru 13, format x(30) */
    qbf-lang[ 8] = 'Kies een module'
    qbf-lang[ 9] = 'waarvoor de toegang'
    qbf-lang[10] = 'geregeld moet worden.'
    qbf-lang[11] = 'Kies een funktie'
    qbf-lang[12] = 'waarvoor de toegang'
    qbf-lang[13] = 'geregeld moet worden.'
    qbf-lang[14] = 'Druk op [' + KBLABEL("END-ERROR")
                 + '] als de veranderingen gedaan zijn.'
    qbf-lang[15] = 'Druk op [' + KBLABEL("GO") + '] voor opslaan, ['
                 + KBLABEL("END-ERROR") + '] voor ongedaan maken.'
    qbf-lang[16] = 'Je kunt jezelf niet uitsluiten Administratie!'
/*a-print.p:*/     /*21 thru 26 must be format x(16) and right-justified */
    qbf-lang[21] = '   Initialisatie'
    qbf-lang[22] = '                '
    qbf-lang[23] = ' Normaal geprint'
    qbf-lang[24] = "    'Compressed'"
    qbf-lang[25] = ' Vet gedrukt AAN'
    qbf-lang[26] = ' Vet gedrukt UIT'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 6 THEN
  ASSIGN
/*a-write.p:*/
    qbf-lang[ 1] = 'Module instellingen worden geladen'
    qbf-lang[ 2] = 'Kleur instellingen worden geladen'
    qbf-lang[ 3] = 'Printer instellingen worden geladen'
    qbf-lang[ 4] = 'Lijst van tabellen wordt geladen'
    qbf-lang[ 5] = 'Lijst van relaties wordt geladen'
    qbf-lang[ 6] = 'Lijst automatische velden selektie etiketten wordt geladen'
    qbf-lang[ 7] = 'Lijst van toegang voor OPVRAGEN wordt geladen'
    qbf-lang[ 8] = 'Informatie voor eXtra programma(s) wordt geladen'
    qbf-lang[ 9] = 'Standaard rapport instellingen worden geladen'

/* a-color.p*/
                 /* 12345678901234567890123456789012 */
    qbf-lang[11] = 'Terminal type om in te stellen: ' /* must be 32 */
                 /* 1234567890123456789012345 */
    qbf-lang[12] = 'Menu:            Normaal:' /* must be 25 */
    qbf-lang[13] = '               Opgelicht:'
    qbf-lang[14] = 'Dialog Box:      Normaal:'
    qbf-lang[15] = '               Opgelicht:'
    qbf-lang[16] = 'Scroll list:     Normaal:'
    qbf-lang[17] = '               Opgelicht:'

/*a-field.p*/    /*"----- ----- ----- ----- ----"*/
    qbf-lang[30] = 'Toon? Wijz? Opv?  Over? Orde'
    qbf-lang[31] = 'Alleen waarde van 1 tot en met 9999 zijn geldig.'
    qbf-lang[32] = 'Wilt u de veranderingen die u heeft gemaakt '
                 + 'opslaan?'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 8 THEN
/*a-label.p*/
  ASSIGN            /* 1..8 use format x(78) */
                    /* 1 and 8 are available for more explanation, in */
                    /*   case the translation won't fit in 2 thru 7.  */
    qbf-lang[ 3] = 'Voer de veldnamen in die adresgegevens kunnen bevatten '
                 + 'voor het'
    qbf-lang[ 4] = 'gebruik in de ETIKETTEN module. Gebruik "*" '
                 + 'ter vervanging van'
    qbf-lang[ 5] = 'nul of meerdere karakters, "." voor precies '
                 + 'een karakter.'
    qbf-lang[ 6] = 'Deze veldnamen worden gebruikt om automatisch '
                 + 'een etiket te'
    qbf-lang[ 7] = 'te laten genereren.'
                  /* each entry in list must be <= 5 characters long */
                  /* but may be any portion of address that is applicable */
                  /* in the target country */
    qbf-lang[ 9] = 'Name,Addr1,Addr2,Addr3,City,State,Zip,Zip+4,C-S-Z,Cntry'
    qbf-lang[10] = 'Veldnaam voor <name>'
    qbf-lang[11] = 'Veldnaam voor <first> line of address (e.g. street)'
    qbf-lang[12] = 'Veldnaam voor <second> line of address (e.g. PO Box)'
    qbf-lang[13] = 'Veldnaam voor <third> line of address (optional)'
    qbf-lang[14] = 'Veldnaam voor name of <city>'
    qbf-lang[15] = 'Veldnaam voor name of <state>'
    qbf-lang[16] = 'Veldnaam voor <zip code> (5 or 9 digits)'
    qbf-lang[17] = 'Veldnaam voor <last four digits> of zip code'
    qbf-lang[18] = 'Veldnaam voor <combined city-state-zip>'
    qbf-lang[19] = 'Veldnaam voor <country>'

/*a-join.p*/
    qbf-lang[23] = 'Relatie met zichzelf op dit moment niet mogelijk.'
    qbf-lang[24] = 'Maximum aantal relaties is bereikt.'
    qbf-lang[25] = 'Relatie met' /* 25 and 26 are automatically */
    qbf-lang[26] = 'tot'          /*   right-justified           */
    qbf-lang[27] = 'Voer konditie of relatie in: (veld leeg laten voor '
                   + 'relatie verwijderen)'
    qbf-lang[28] = 'Druk op [' + KBLABEL("END-ERROR") + '] voor einde '
                   + 'veranderingen.'
    qbf-lang[30] = 'De opdracht moet beginnen met WHERE of OF.'
    qbf-lang[31] = 'Eerste tabelnaam voor relatie voor toevoegen/verwijderen.'
    qbf-lang[32] = 'Tweede tabelnaam voor relatie.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-form.p */
IF qbf-s = 9 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' N. Toevoegen nieuw opvraagscherm '
    qbf-lang[ 2] = ' W. Kies opvraagscherm voor verandering '
    qbf-lang[ 3] = ' I. Opvraagscherm instellingen '
    qbf-lang[ 4] = ' V. Velden op het opvraagscherm '
    qbf-lang[ 5] = ' T. Toegang '
    qbf-lang[ 6] = ' V. Verwijderen huidige opvraagscherm '
    qbf-lang[ 7] = ' Kies: ' /* format x(10) */
    qbf-lang[ 8] = ' Wijzig: ' /* format x(10) */
                 /* cannot changed width of 9..16 from defined below */
    qbf-lang[ 9] = '    Database tabel naam' /* right-justify 9..14 */
    qbf-lang[10] = '    Opvraagscherm type'
    qbf-lang[11] = ' Bestandsnaam programma'
    qbf-lang[12] = 'Best.naam opvraagscherm'
    qbf-lang[13] = "  'Frame' naam voor 4GL"
    qbf-lang[14] = '           Omschrijving'
    qbf-lang[15] = '(.p standaard)     ' /* left-justify 15 and 16 */
    qbf-lang[16] = '(extensie nodig)'
    qbf-lang[18] = 'Dit opvraagscherm is ~{1~} regels. Omdat RESULTS zelf vijf '
                 + 'regels reserveerd, past het nu niet meer binnen de '
                 + '24x80 grootte van het scherm. Weet u zeker dat u dit '
                 + 'opvraagscherm wilt definieren?'
    qbf-lang[19] = 'Deze bestandsnaam komt al voor.'
    qbf-lang[20] = 'Dit opvraagscherm moet al bestaan, of eidigen op .f voor '
                 + 'automatische generatie.'
    qbf-lang[21] = 'De naam voor "Frame naam voor 4GL" is voorbestemd '
                 + 'Kies een andere.'
    qbf-lang[22] = ' Kies toegankelijke bestanden '
    qbf-lang[23] = 'Druk op [' + KBLABEL("END-ERROR") + '] voor einde '
                 + 'veranderingen.'
    qbf-lang[24] = 'Opvraagscherm wordt opgeslagen in geheugen...'
    qbf-lang[25] = 'Er zijn een of meer opvraagschermen gewijzigd.  U kunt nu '
                 + 'het veranderde opvraagscherm compileren, of later een  '
                 + '"Applikatie konfiguratie" uitvoeren.  Nu compileren?'
    qbf-lang[26] = 'Opvraagscherm "~{1~}" kan niet worden gevonden.  Moet deze '
                 + 'worden gegenereerd?'
    qbf-lang[27] = 'Opvraagscherm "~{1~}" bestaat al.  Hiervan veldnamen '
                 + 'gebruiken?'
    qbf-lang[28] = 'Weet u zeker dat u dit opvraagscherm wilt verwijderen? '
    qbf-lang[29] = '** Programma "~{1~}" verwijderd. **'
    qbf-lang[30] = 'Opvraagscherm wordt weggeschreven...'
    qbf-lang[31] = 'Maximum aantal opvraagscherm is bereikt.'
    qbf-lang[32] = 'Opvraagscherm kan niet worden gemaakt.^^Of de '
                 + '"gateway" moet RECIDs ondersteunen of er moet een'
                 + 'unieke index op de tabel aanwezig zijn.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-print.p */
IF qbf-s = 10 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' T. Voeg uitvoerbestemming toe '
    qbf-lang[ 2] = ' K. Kies uitvoerbestemming voor verandering '
    qbf-lang[ 3] = ' I. Uitvoerbestemming instellingen '
    qbf-lang[ 4] = ' S. Besturings signalen  '
    qbf-lang[ 5] = ' P. Printer toegang '
    qbf-lang[ 6] = ' V. Verwijderen uitvoerbestemming '
    qbf-lang[ 7] = ' Kies: ' /* format x(10) */
    qbf-lang[ 8] = ' Wijzig: ' /* format x(10) */
    qbf-lang[ 9] = 'Waarde minder dan 256 en groter dan 0'
    qbf-lang[10] = 'Type moet zijn term, thru, to, view, file, page of prog'
    qbf-lang[11] = 'Maximum aantal uitvoerbestemmingen is gedefinieerd.'
    qbf-lang[12] = 'Alleen apparaat type "term" mogelijk voor scherm-uitvoer.'
    qbf-lang[13] = 'Programma kan met huidige PROPATH niet gevonden worden.'
                  /*17 thru 20 must be format x(16) and right-justified */
    qbf-lang[17] = '    App. omschr.'
    qbf-lang[18] = 'Bestemmings naam'
    qbf-lang[19] = ' Maximum breedte'
    qbf-lang[20] = '            Type'
    qbf-lang[21] = 'zie hieronder'
    qbf-lang[22] = 'TERMINAL, zoals in OUTPUT TO TERMINAL PAGED'
    qbf-lang[23] = 'TO bestand/printer, zoals in OUTPUT TO PRINTER'
    qbf-lang[24] = 'THROUGH een unix of OS/2 spooler of filter'
    qbf-lang[25] = 'Rapport naar bestand, voer daarna bestand uit'
    qbf-lang[26] = 'Vraag gebruiker bestandsnaam voor uitvoer'
    qbf-lang[27] = 'Naar scherm met "blader" mogelijkheden'
    qbf-lang[28] = 'Gebruik een 4GL programma om in/uitvoer te regelen'
    qbf-lang[30] = '[END-ERROR] voor einde verwerking.'
    qbf-lang[31] = 'Er moet minimaal een uitvoerbestemming zijn!'
  qbf-lang[32] = 'Weet u zeker dat u deze uitvoerbestemming wilt verwijderen?'.
