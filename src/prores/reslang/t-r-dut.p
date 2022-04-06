/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-r-eng.p - English language definitions for Reports module */
/* translation by Ton Voskuilen, PROGRESS Holland */
/* september, 1991 */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
/*r-header.p*/
    qbf-lang[ 1] = 'Geef de bewerking voor: '
    qbf-lang[ 2] = 'Regel' /* must be < 8 characters */
		   /* 3..7 are format x(64) */
    qbf-lang[ 3] = 'Funkties beschikbaar voor gebruik in kop- en '
		 + 'voetregels'
    qbf-lang[ 4] = '~{COUNT~}  Aantal bestandsregels   :  '
		 + '~{TIME~}  Tijd start rapport'
    qbf-lang[ 5] = '~{TODAY~}  Huidige datum           :  '
		 + '~{NOW~}   De tijd nu'
    qbf-lang[ 6] = '~{PAGE~}   Pagina nummer           :  '
		 + '~{USER~}  Gebruikersnaam'
    qbf-lang[ 7] = '~{VALUE <expression>~;<format>~} invoeren variabelen'
		 + ' ([' + KBLABEL("GET") + '] toets)'
    qbf-lang[ 8] = 'Kies veld om in te voegen'
    qbf-lang[ 9] = '[' + KBLABEL("GO") + '] voor opslaan, ['
		 + KBLABEL("GET") + '] veld toevoegen, ['
		 + KBLABEL("END-ERROR") + '] annuleren.'

/*r-total.p*/    /*"|---------------------------|"*/
    qbf-lang[12] = 'Voer het volgende uit:'
		 /*"|--------------------------------------------|"*/
    qbf-lang[13] = 'Als deze velden van waarde veranderen:'
		 /*"|---| |---| |---| |---| |---|" */
    qbf-lang[14] = 'Tot.- Aant. -Min- -Max- Gemm.'
    qbf-lang[15] = 'Groeps-regels'
    qbf-lang[16] = 'Voor veld:'
    qbf-lang[17] = 'Kies veld voor totalisering'

/*r-calc.p*/
    qbf-lang[18] = 'Kies kolom voor totaal op totaal'
    qbf-lang[19] = 'Kies kolom voor percentage van totaal'
    qbf-lang[20] = 'Totaal op totaal'
    qbf-lang[21] = '% Totaal'
    qbf-lang[22] = 'Tekst,Datum,Logisch,Reken,Numeriek'
    qbf-lang[23] = 'Waarde'
    qbf-lang[24] = 'Geef beginwaarde voor teller'
    qbf-lang[25] = 'Geef stapgrootte, of een negatieve waarde voor vermindering'
    qbf-lang[26] = 'Tellers'
    qbf-lang[27] = 'Teller'
		 /*"------------------------------|"*/
    qbf-lang[28] = '        Beginwaarde voor teller' /*right justify*/
    qbf-lang[29] = 'Tel bij,bij ieder bestandsregel' /*right justify*/
    qbf-lang[32] = 'U heeft reeds het maximun aantal kolommen gedefinieerd.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN
/* r-space.p */  /*"------------------------------|  ---------|  |------"*/
    qbf-lang[ 1] = '             Optie                       Nu  Standrd'
    /* 2..8 must be less than 32 characters long */
    qbf-lang[ 2] = 'Linker kantlijn'
    qbf-lang[ 3] = 'Afstand tussen kolommen'
    qbf-lang[ 4] = 'Begin regel'
    qbf-lang[ 5] = 'Aantal regels per pagina'
    qbf-lang[ 6] = 'Regel afstand'
    qbf-lang[ 7] = 'Rgls tussen kopregels en tekst'
    qbf-lang[ 8] = 'Rgls tussen tekst en voetregels'
		  /*1234567890123456789012345678901*/
    qbf-lang[ 9] = 'Afstand instellen'
    qbf-lang[10] = 'Regels afstand moet tussen 1 en de pagina lengte liggen'
    qbf-lang[11] = 'Negatieve pagina lengte is niet mogelijk'
    qbf-lang[12] = 'De meest links mogelijke positie is 1'
    qbf-lang[13] = 'Deze waarde is niet zinnig'
    qbf-lang[14] = 'De meest bovenste regel mogelijke is 1'

/*r-set.p*/        /* format x(30) for 15..22 */
    qbf-lang[15] = 'F.  Formaten en veldnamen'
    qbf-lang[16] = 'N.  Nieuwe pagina'
    qbf-lang[17] = 'R.  Rapport alleen totalen'
    qbf-lang[18] = 'S.  Afstand Instellen'
    qbf-lang[19] = 'LK. Linker Kopregel'
    qbf-lang[20] = 'CK. Midden Kopregel'
    qbf-lang[21] = 'RK. Rechter Kopregel'
    qbf-lang[22] = 'LV. Linker voetregel'
    qbf-lang[23] = 'CV. Midden voetregel'
    qbf-lang[24] = 'RV. Rechter voetregel'
    qbf-lang[25] = 'KE. Kopregel eerste blad'
    qbf-lang[26] = 'VL. Voetregel laatste blad'
    qbf-lang[32] = 'Druk op [' + KBLABEL("END-ERROR")
		 + '] voor wijzigingen opslaan.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
    /* r-main.p,s-page.p */
    qbf-lang[ 1] = 'Tabel:,     :,     :,     :,     :'
    qbf-lang[ 2] = ' Orde:'
    qbf-lang[ 3] = 'Rapport Info'
    qbf-lang[ 4] = 'Rapport Layout'
    qbf-lang[ 5] = 'meer' /* for <<more and more>> */
    qbf-lang[ 6] = 'Rapport,Breedte' /* each word comma-separated */
    qbf-lang[ 7] = 'Gebruik < en > om links en rechts van rapport te bekijken'
    qbf-lang[ 8] = 'Het genereren van een rapport breder dan 255 karakters '
		 + 'is niet mogelijk'
    qbf-lang[ 9] = 'U heeft het huidige rapport niet gewist. Wilt u wel '
		 + 'verder gaan?'
    qbf-lang[10] = 'Programma wordt gemaakt...'
    qbf-lang[11] = 'Programma wordt gecompileerd...'
    qbf-lang[12] = 'Programma wordt uitgevoerd...'
    qbf-lang[13] = 'Schrijven naar uitvoer bestemming niet mogelijk'
    qbf-lang[14] = 'Weet u zeker dat u het huidige rapport wilt wissen? '
    qbf-lang[15] = 'Weet u zeker dat u de huidige module wilt verlaten?'
    qbf-lang[16] = '['
		 + (IF KBLABEL("CURSOR-UP") BEGINS "CTRL-" THEN 'CURSOR-UP'
		   ELSE KBLABEL("CURSOR-UP"))
		 + '] en ['
		 + (IF KBLABEL("CURSOR-DOWN") BEGINS "CTRL-" THEN 'CURSOR-DOWN'
		   ELSE KBLABEL("CURSOR-DOWN"))
		 + '] voor positionering, ['
		 + KBLABEL("END-ERROR") + '] voor einde.'
    qbf-lang[17] = 'Pagina'
    qbf-lang[18] = '~{1~} bestandsregels in het rapport.'
    qbf-lang[19] = 'Niet mogelijk een rapport met alleen totalen '
		 + 'te genereren als sortering niet opgegeven.'
    qbf-lang[20] = 'Niet mogelijk een rapport met alleen totalen '
		 + 'te genereren bij gebruik array velden.'
    qbf-lang[21] = 'Alleen totalen'
    qbf-lang[23] = 'Niet mogelijk rapport te maken zonder velddefinities.'.

ELSE

/*--------------------------------------------------------------------------*/
/* FAST TRACK interface test for r-ft.p r-ftsub.p */
IF qbf-s = 4 THEN
  ASSIGN
   qbf-lang[ 1] = 'Met FAST TRACK uitvoer naar scherm niet mogelijk als tijdens'
   qbf-lang[ 2] = 'uitvoer om waarden wordt gevraagd.  Uitvoer nu naar PRINTER.'
    qbf-lang[ 3] = 'Kop- en voetregels in behandeling...'
    qbf-lang[ 4] = 'Groepen worden gevormd...'
    qbf-lang[ 5] = 'Velden en geagregeerde waarden in behandeling...'
    qbf-lang[ 6] = 'Tabellen en kondities in behandeling...'
    qbf-lang[ 7] = 'Kop- en voetregels worden gemaakt...'
    qbf-lang[ 8] = 'Rapport regels worden gemaakt...'
    qbf-lang[ 9] = 'Rapport ~{1~} bestaat al in FAST TRACK. Wilt '
		 + 'u deze overschrijven?'
    qbf-lang[10] = 'Rapport wordt overschreven...'
    qbf-lang[11] = 'Wilt u FAST TRACK starten?'
    qbf-lang[12] = 'Voer een naam in'
    qbf-lang[13] = 'FAST TRACK ondersteunt geen TIME in kop/voetregels, '
		 + 'is vervangen door NOW.'
    qbf-lang[14] = 'FAST TRACK ondersteunt percentage van totaal niet, '
		 + 'veld overgeslagen'
    qbf-lang[15] = 'FAST TRACK ondersteunt ~{1~} niet in kop/voetregels, '
		 + '~{2~} overgeslagen.'
    qbf-lang[16] = 'Een rapportnaam kan alleen alfanumeriek zijn '
		 + 'of "_".'
    qbf-lang[17] = 'Rapport naam in FAST TRACK:'
    qbf-lang[18] = 'Rapport niet overgezet naar FAST TRACK'
    qbf-lang[19] = 'FAST TRACK wordt gestart...'
    qbf-lang[20] = 'Haakjes kloppen niet in kop/voetregels, '
		 + 'rapport NIET overgezet.'
    qbf-lang[21] = 'FAST TRACK ondersteunt geen kop/voetregels voor '
		 + 'eerste/laatste blad'
    qbf-lang[22] = 'Opgelet: Startnummer ~{1~} gebruikt voor teller.'
    qbf-lang[23] = 'BEVAT'
    qbf-lang[24] = 'TOTAAL,AANTAL,MAX,MIN,GEMM'
    qbf-lang[25] = 'FAST TRACK ondersteunt rapport met alleen totalen niet.  '
		 + 'Rapport kan niet worden overgezet.'
    qbf-lang[26] = 'Rapport kan niet worden overgezet naar FAST TRACK als geen'
		 + 'tabellen/velden bekend zijn.'.


ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 5 THEN
  ASSIGN
    /* r-short.p */
    qbf-lang[ 1] = 'Het definieren van een Rapport met Alleen Totalen '
		 + 'zal alleen de groeps-regels laten zien. Aan de hand '
		 + 'van het laatste veld in "orde" zal bij het veranderen '
		 + 'van de waarde van dit veld een nieuwe regel onstaan.  '
		 + '^Dit rapport zal bij elke verandering van ~{1~} een '
		 + 'nieuwe regel geven.^Wilt u dit een rapport van alleen '
		 + 'totalen laten zijn?'
    qbf-lang[ 2] = 'JA'
    qbf-lang[ 3] = 'NEE'
    qbf-lang[ 4] = 'U kunt dit geen "Rapport Alleen Totalen" laten zijn, '
		 + 'zolang u niet de orde van u rapport hebt opgegeven.^^'
		 + 'Geef de sortering van uw rapport op bij "Sorteer" uit het '
		 + 'Rapporten hoofdmenu. Daarna kunt u Rapport Met Alleen '
		 + 'totalen opgeven.'
    qbf-lang[ 5] = 'Dit overzicht geeft alle velden die u nu hebt gedefinieerd '
		 + 'voor '
    qbf-lang[ 6] = 'dit rapport.  De velden gemerkt met een "*" zullen worden '
		 + 'gegroepeerd.'
    qbf-lang[ 7] = 'Als u een numeriek veld kiest voor groepering, zal een '
		 + 'subtotaal worden getoond als het ~{1~} veld van waarde '
		 + 'veranderd.'
    qbf-lang[ 8] = 'Als u een niet-numeriek veld kiest, zal het aantal '
		 + 'bestandsregels in iedere ~{1~} groep verschijnen.'
    qbf-lang[ 9] = 'Als u een veld niet wilt groeperen, zal de waarde '
		 + 'van de laaste bestandsregel van de groep getoond worden.'

    /* r-page.p */
    qbf-lang[26] = 'Nieuwe pagina'
    qbf-lang[27] = "geen nieuwe pagina"

    qbf-lang[28] = 'Als de waarde van een van de volgende'
    qbf-lang[29] = 'velden veranderd, kan het rapport '
    qbf-lang[30] = 'automatisch naar een nieuwe pagina'
    qbf-lang[31] = 'overgaan. Kies een veld uit de onder-'
    qbf-lang[32] = 'staande lijst waarvoor dit moet gelden.'.

/*--------------------------------------------------------------------------*/

RETURN.
