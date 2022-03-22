/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-q-eng.p - English language definitions for Query module */
/* translation by Ton Voskuilen, PROGRESS Holland */
/* september, 1991 */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Geen bestandsregel gevonden met deze voorwaarde.'
    qbf-lang[ 2] = 'Allen,Relateer,Selektie'
    qbf-lang[ 3] = 'Alles getoond,Eerste regel getoond,Laatste regel getoond'
    qbf-lang[ 4] = 'Er zijn geen indexen gedefinieerd voor deze tabel.'
    qbf-lang[ 5] = 'Weet u zeker dat u deze bestandsregel wilt verwijderen?'
    qbf-lang[ 6] = '' /* special total message: created from #7 or #8 */
    qbf-lang[ 7] = 'Totaal telling gestopt.'
    qbf-lang[ 8] = 'Totaal aantal bestandsregels is '
    qbf-lang[ 9] = 'Totaal telling loopt...  Druk op [' + KBLABEL("END-ERROR")
		 + '] om te stoppen.'
    qbf-lang[10] = 'is gelijk aan,is minder dan,is minder/evenveel dan,'
		 + 'is meer dan,is meer/evenveel dan,'
		 + 'is NIET gelijk aan,bevat,begint met'
    qbf-lang[11] = 'Er zijn geen bestandsregels beschikbaar.'
    qbf-lang[13] = 'Eerste bestandsregel al op het scherm.'
    qbf-lang[14] = 'Laatste bestandsregel al op het scherm.'
    qbf-lang[15] = 'Er zijn nog geen opvraagscherm gedefinieerd.'
    qbf-lang[16] = 'OPVRAGEN'
    qbf-lang[17] = 'Kies de naam van het gewenste opvraagscherm.'
    qbf-lang[18] = 'Druk op [' + KBLABEL("GO")
		 + '] of [' + KBLABEL("RETURN")
		 + '] om opvraagscherm te kiezen, of [' + KBLABEL("END-ERROR")
		 + '] om te stoppen.'
    qbf-lang[19] = 'Opvraagscherm wordt ingelezen...'
    qbf-lang[20] = 'Bij dit programma behorende opvraagscherm niet aanwezig. '
		 + 'Probleem kan zijn:^1) PROPATH niet juist,^2) .r bestand '
		 + 'ontbreekt, of^3) .r bestand niet gecompileerd.^(Kontroleer '
		 + '<dbname>.ql bestand op compiler fouten).^^U kunt proberen '
		 + 'verder te gaan, maar dit kan problemen opleveren.  '
		 + 'Wilt u nog verder gaan?'
    qbf-lang[21] = 'De opgegeven kondities bevatten waarden die worden '
		 + 'opgevraagd tijdens het programma gebruik.  Dit is '
		 + 'is niet mogelijk in de OPVRAAG module. Wilt u dit negeren '
		 + 'en verder gaan?'
    qbf-lang[22] = 'Druk op [' + KBLABEL("GET")
		 + '] voor het instellen van deze velden'.

ELSE

IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = '+Vlgnd,Volgende bestandsregel [cursor-down].'
    qbf-lang[ 2] = '-Vorg,Vorige bestandsregel [cursor-up].'
    qbf-lang[ 3] = '1ste,Toon de eerste bestandsregel.'
    qbf-lang[ 4] = 'Laatste,Toon de laatste bestandsregel.'
    qbf-lang[ 5] = 'Voegtoe,Voeg een bestandsregel toe.'
    qbf-lang[ 6] = 'Wyzig,Wijzig deze bestandsregel.'
    qbf-lang[ 7] = 'Copie,Copieer deze bestandsregel naar een nieuwe.'
    qbf-lang[ 8] = '#Wis,Verwijder de huidige bestandsregel.'
    qbf-lang[ 9] = 'Nieuw,Ga naar nieuw opvraagscherm.'
    qbf-lang[10] = 'Overz,Geef een verkort overzicht.'
    qbf-lang[11] = 'Relateer,Relatie naar een andere table.'
    qbf-lang[12] = '*Opvragen,Gebruik scherm voor opvragen van bestandsregels.'
    qbf-lang[13] = 'Kondities,Maak een selektie van bestandsregels '
		 + 'die aan kondities moeten voldoen.'
    qbf-lang[14] = 'Aantal,Totaal aantal bestandsregels met deze kondities.'
    qbf-lang[15] = 'Sorteer,Gebruik andere sortering van bestandsregels.'
    qbf-lang[16] = 'Module,Wissel naar andere module.'
    qbf-lang[17] = 'Info,Informatie over de gebruikte tabellen.'
    qbf-lang[18] = 'Extra,Voer zelf-gedefinieerd programma uit.'
    qbf-lang[19] = 'Stop,Terug naar vorig scherm.'
    qbf-lang[20] = ''. /* terminator */

RETURN.
