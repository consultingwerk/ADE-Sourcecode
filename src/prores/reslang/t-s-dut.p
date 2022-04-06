/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* translation by Ton Voskuilen, PROGRESS Holland */
/* september, 1991 */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/

/* l-edit.p,s-edit.p */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Invoegen'
    qbf-lang[ 2] = 'U wilt stoppen zonder de wijzigingen op te slaan?'
    qbf-lang[ 3] = 'Geef de naam van het bestand om toe te voegen'
    qbf-lang[ 4] = 'Geef de te zoeken tekst'
    qbf-lang[ 5] = 'Kies een veld om in te voegen'
    qbf-lang[ 6] = '[' + KBLABEL("GO") + '] voor opslaan, ['
		 + KBLABEL("GET") + '] veld toevoegen, ['
		 + KBLABEL("END-ERROR") + '] voor annuleren.'
    qbf-lang[ 7] = 'Tekst niet gevonden.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-ask.p,s-where.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Gelijk aan'
    qbf-lang[ 2] = 'Niet gelijk aan'
    qbf-lang[ 3] = 'Minder dan'
    qbf-lang[ 4] = 'Minder/gelijk'
    qbf-lang[ 5] = 'Meer dan'
    qbf-lang[ 6] = 'Meer/gelijk aan'
    qbf-lang[ 7] = 'Begint met'
    qbf-lang[ 8] = 'Bevat'    /* must match [r.4.23] */
    qbf-lang[ 9] = 'Masker'

    qbf-lang[10] = 'Kies een veld'
    qbf-lang[11] = 'Bewerking'
    qbf-lang[12] = 'Voer een waarde in'
    qbf-lang[13] = 'Vergelijkingen'

    qbf-lang[14] = 'Voer een waarde tijdens uitvoer in.'
    qbf-lang[15] = 'Geef de tekst voor de vraag om waarde tijdens uitvoer:'

    qbf-lang[16] = 'Vraag naar' /* data-type */
    qbf-lang[17] = 'waarde'

    qbf-lang[18] = 'Druk op [' + KBLABEL("END-ERROR") + '] om te stoppen.'
    qbf-lang[19] = 'Druk op [' + KBLABEL("END-ERROR") + '] laatste '
		 + 'verandering annuleren.'
    qbf-lang[20] = 'Druk op [' + KBLABEL("GET") + '] voor Expert Mode.'

    qbf-lang[21] = 'Kies de vergelijking die moet gelden voor het veld.'

    qbf-lang[22] = 'Geef de ~{1~} waarde om te vergelijken met "~{2~}".'
    qbf-lang[23] = 'Geef de ~{1~} waarde voor "~{2~}".'
    qbf-lang[24] = 'Druk op [' + KBLABEL("PUT")
		 + '] om een waarde op te vragen tijdens uitvoer.'
    qbf-lang[25] = 'Kontext: ~{1~} is ~{2~} enige ~{3~} waarde.'

    qbf-lang[27] = '"Expert Mode" en "Geef een waarde tijdens uitvoer"'
		 + 'kan niet gelijktijdig.  Slechts een van beiden gebruiken.'
    qbf-lang[28] = 'Dit kan niet de "unknown value" zijn!'
    qbf-lang[29] = 'Nog meer waarden voor' /* '?' append to string */
    qbf-lang[30] = 'Wilt u nog meer selektie-kriteria toevoegen?'
    qbf-lang[31] = 'Selektie kriterium toevoegen middels?'
    qbf-lang[32] = 'Expert Mode'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
/* s-info.p, s-format.p */
    qbf-lang[ 1] = 'Sorteer op'  /* s-info.p automatically right-justifies */
    qbf-lang[ 2] = 'en op'      /*   1..9 and adds colons for you. */
    qbf-lang[ 3] = 'Tabel'        /* but must fit in format x(24) */
    qbf-lang[ 4] = 'Relatie'
    qbf-lang[ 5] = 'Konditie'
    qbf-lang[ 6] = 'Veld'
    qbf-lang[ 7] = 'Bewerking'
    qbf-lang[ 9] = 'Geen dubbele waarden?'

    qbf-lang[10] = 'van,tot,voor'
    qbf-lang[11] = 'U heeft nog geen tabellen geselekteerd!'
    qbf-lang[12] = 'Formaten en veldteksten'
    qbf-lang[13] = 'Formaten'
    qbf-lang[14] = 'Kies een veld' /* also used by s-calc.p below */
    /* 15..18 must be format x(16) (see notes on 1..7) */
    qbf-lang[15] = 'Veldtekst'
    qbf-lang[16] = 'Formaat'
    qbf-lang[17] = 'Database'
    qbf-lang[18] = 'Type'
    qbf-lang[19] = 'Doorlooptijd laatste aktie,minuten:seconden'
    qbf-lang[20] = 'Bewerking kan geen unknown value (?) bevatten'

/*s-calc.p*/ /* there are many more for s-calc.p, see qbf-s = 5 thru 8 */
/*s-calc.p also uses #14 */
    qbf-lang[27] = 'Bewerking opzetten'
    qbf-lang[28] = 'Bewerking'
    qbf-lang[29] = 'Wilt u nog toevoegen aan deze uitdrukking?'
    qbf-lang[30] = 'Kies bewerking'
    qbf-lang[31] = 'Datum van vandaag'
    qbf-lang[32] = 'Konstante waarde'.

ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 4 THEN
  ASSIGN
/*s-help.p*/
    qbf-lang[ 1] = 'Geen help-informatie beschikbaar voor deze optie'
    qbf-lang[ 2] = 'Help'

/*s-order.p*/
    qbf-lang[15] = 'oplopend/afnemend' /*neither can be over 8 characters */
    qbf-lang[16] = 'Voor ieder element, toets "o" voor'
    qbf-lang[17] = 'oplopend of "a" voor afnemend.'

/*s-define.p*/
    qbf-lang[21] = 'B. Breedte/Formaat velden'
    qbf-lang[22] = 'V. Velden'
    qbf-lang[23] = 'A. Aktieve tabellen'
    qbf-lang[24] = 'T. Totalen/subtotalen'
    qbf-lang[25] = 'R. Totaal op Totaal'
    qbf-lang[26] = 'P. Percentage van Totaal'
    qbf-lang[27] = 'C. Tellers'
    qbf-lang[28] = 'M. Reken bewerking'
    qbf-lang[29] = 'S. Tekst bewerking'
    qbf-lang[30] = 'N. Numerieke bewerking'
    qbf-lang[31] = 'D. Datum bewerking'
    qbf-lang[32] = 'L. Logische bewerking'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - string expressions */
IF qbf-s = 5 THEN
  ASSIGN
    qbf-lang[ 1] = 's,Konstante of veldnaam,s00=s24,~{1~}'
    qbf-lang[ 2] = 's,Tekstgedeelte,s00=s25n26n27,SUBSTRING(~{1~}'
		 + ';INTEGER(~{2~});INTEGER(~{3~}))'
    qbf-lang[ 3] = 's,Twee teksten samenvoegen,s00=s28s29,~{1~} + ~{2~}'
    qbf-lang[ 4] = 's,Drie teksten samenvoegen,s00=s28s29s29,'
		 + '~{1~} + ~{2~} + ~{3~}'
    qbf-lang[ 5] = 's,Vier teksten samenvoegen,s00=s28s29s29s29,'
		 + '~{1~} + ~{2~} + ~{3~} + ~{4~}'
    qbf-lang[ 6] = 's,''Laagste'' van twee teksten,'
		 + 's00=s30s31,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 's,''Grootste'' van twee teksten,s00=s30s31,'
		 + 'MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 8] = 's,Lengte van tekst,n00=s32,LENGTH(~{1~})'
    qbf-lang[ 9] = 's,Gebruikersnaam,s00=,USERID("RESULTSDB")'
    qbf-lang[10] = 's,Huidige tijd,s00=,STRING(TIME;"HH:MM:SS")'

    qbf-lang[24] = 'Geef veldnaam voor de kolom die opgenomen moet worden in'
		 + 'het rapport, of kies <<vaste waarde>> voor het gebruik'
		 + 'van een konstante waarde in het rapport.'
    qbf-lang[25] = 'Tekstgedeelte maakt het mogelijk om slechts een gedeelte '
		 + 'van een tekst te gebruiken. Kies een veldnaam.'
    qbf-lang[26] = 'Geef begin positie voor gewenste tekstgedeelte'
    qbf-lang[27] = 'Geef de gewenste lengte van het tekstgedeelte'
    qbf-lang[28] = 'Kies de eerste waarde'
    qbf-lang[29] = 'Kies de volgende waarde'
    qbf-lang[30] = 'Kies de eerste waarde voor vergelijking'
    qbf-lang[31] = 'Kies de tweede waarde voor vergelijking'
    qbf-lang[32] = 'Het getal wat u terugkrijgt komt overeen met de lengte van '
		 + 'de geselekteerde tekst.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - numeric expressions */
IF qbf-s = 6 THEN
  ASSIGN
   qbf-lang[ 1] = 'n,Konstante of veldnaam,n00=n26,~{1~}'
   qbf-lang[ 2] = 'n,Kleinste van twee getallen,n00=n24n25,MINIMUM(~{1~};~{2~})'
   qbf-lang[ 3] = 'n,Grootste van twee getallen,n00=n24n25,MAXIMUM(~{1~};~{2~})'
   qbf-lang[ 4] = 'n,Rest,n00=n31n32,~{1~} MODULO ~{2~}'
   qbf-lang[ 5] = 'n,Absolute waarde,n00=n27,'
		 + '(IF ~{1~} < 0 THEN - ~{1~} ELSE ~{1~})'
    qbf-lang[ 6] = 'n,Afgeronde waarde,n00=n28,ROUND(~{1~};0)'
    qbf-lang[ 7] = 'n,Afgekapte waarde,n00=n29,TRUNCATE(~{1~};0)'
    qbf-lang[ 8] = 'n,Worteltrekken,n00=n30,SQRT(~{1~})'
    qbf-lang[ 9] = 'n,Geef getal als tijd weer,s00=n23,'
		 + 'STRING(INTEGER(~{1~});"HH:MM:SS")'

    qbf-lang[23] = 'Geef de veldnaam dat als tijd HH:MM:SS moet worden getoond'
    qbf-lang[24] = 'Geef eerste waarde voor vergelijking'
    qbf-lang[25] = 'Geef tweede waarde voor vergelijking'
    qbf-lang[26] = 'Geef veldnaam voor de kolom die opgenomen moet worden in'
		 + 'het rapport, of kies <<vaste waarde>>.'
    qbf-lang[27] = 'Kies veldnaam dat moet worden weergegeven als een absolute '
		 + 'waarde.'
    qbf-lang[28] = 'Kies veldnaam wat afgerond moet worden.'
    qbf-lang[29] = 'Kies veldnaam waarvan gedeelte achter komma moet worden '
		 + 'weggelaten).'
   qbf-lang[30] = 'Kies veldnaam waarop worteltrekken van toepassing moet zijn.'
    qbf-lang[31] = 'Na het delen door een waarde is dit de restwaarde die '
		 + 'overblijft. Geef veldnaam waarvan u na deling de rest wilt.'
    qbf-lang[32] = 'Delen door?'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - date expressions */
IF qbf-s = 7 THEN
  ASSIGN
    qbf-lang[ 1] = 'd,Datum van vandaag,d00=,TODAY'
    qbf-lang[ 2] = 'd,Tel aantal dagen bij datum,d00=d22n23,~{1~} + ~{2~}'
    qbf-lang[ 3] = 'd,Trek aantal dagen af van datum,d00=d22n24,~{1~} - ~{2~}'
    qbf-lang[ 4] = 'd,Verschil tussen data,n00=d25d26,~{1~} - ~{2~}'
    qbf-lang[ 5] = 'd,Eerste van twee data,d00=d20d21,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 6] = 'd,Laaste van twee data,d00=d20d21,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 'd,Dag van maand,n00=d27,DAY(~{1~})'
    qbf-lang[ 8] = 'd,Maand van jaar,n00=d28,MONTH(~{1~})'
    qbf-lang[ 9] = 'd,Naam van maand,s00=d29,ENTRY(MONTH(~{1~});"Januari'
		 + ';Februari;Maart;April;Mei;Juni;Juli;Augustus;September'
		 + ';Oktober;November;December")'
    qbf-lang[10] = 'd,Jaartal,n00=d30,YEAR(~{1~})'
    qbf-lang[11] = 'd,Dag van week,n00=d31,WEEKDAY(~{1~})'
    qbf-lang[12] = 'd,Naam van weekdag,s00=d32,ENTRY(WEEKDAY(~{1~});"'
		+ 'Zondag;Maandag;Dinsdag;Woensdag;Donderdag;Vrijday;Zaterdag")'

    qbf-lang[20] = 'Geef de eerste waarde voor vergelijking'
    qbf-lang[21] = 'Geef de tweede waarde voor vergelijking'
    qbf-lang[22] = 'Kies een datum-veld.'
    qbf-lang[23] = 'Kies een veld dat het aantal dagen bevat om bij deze '
		 + 'datum te tellen.'
    qbf-lang[24] = 'Kies een veld dat het aantal dagen bevat om van deze '
		 + 'datum af te trekken.'
    qbf-lang[25] = 'Geeft het verschil in dagen tussen twee data als een '
		 + 'nieuwe kolom. Geef het eerte datum-veld.'
    qbf-lang[26] = 'Geef het tweede datum-veld.'
    qbf-lang[27] = 'Geeft de dag van de maand als een getal van 1 tot 31.'
    qbf-lang[28] = 'Geeft de maand van het jaar als een getal van 1 tot 12.'
    qbf-lang[29] = 'Geeft de naam van de maand.'
    qbf-lang[30] = 'Geeft het jaartal als een getal.'
    qbf-lang[31] = 'Geeft een getal voor de dag van de week, met Zondag als 1.'
    qbf-lang[32] = 'Geeft de naam van de dag van de week.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - mathematical expressions */
IF qbf-s = 8 THEN
  ASSIGN
    qbf-lang[ 1] = 'm,Optellen,n00=n25n26m...,~{1~} + ~{2~}'
    qbf-lang[ 2] = 'm,Aftrekken,n00=n25n27m...,~{1~} - ~{2~}'
    qbf-lang[ 3] = 'm,Vermenigvuldigen,n00=n28n29m...,~{1~} * ~{2~}'
    qbf-lang[ 4] = 'm,Delen door,n00=n30n31m...,~{1~} / ~{2~}'
    qbf-lang[ 5] = 'm,Machtsverheffen,n00=n25n32m...,EXP(~{1~};~{2~})'

    qbf-lang[25] = 'Geef het eerste getal'
    qbf-lang[26] = 'Geef het volgende getal voor de optelling'
    qbf-lang[27] = 'Geef het volgende getal om af te trekken'
    qbf-lang[28] = 'Geef het eerste getal voor vermenigvuldiging'
    qbf-lang[29] = 'Geef het tweede getal voor vermenigvuldiging'
    qbf-lang[30] = 'Geef het te delen getal'
    qbf-lang[31] = 'Geef de deler'
    qbf-lang[32] = 'Tot welke macht ?'.

/*--------------------------------------------------------------------------*/

RETURN.
