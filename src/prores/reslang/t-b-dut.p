/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-b-eng.p - English language definitions for Build subsystem */
/* translation by Ton Voskuilen, PROGRESS Holland */
/* september, 1991 */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* b-build.p,b-again.p */
IF qbf-s = 1 THEN
  ASSIGN
		/* formats: x(10) x(45) x(8) */
    qbf-lang[ 1] = 'Programma,Database en tabel,Tijd'
    qbf-lang[ 2] = 'Kontrole bestand is korrupt.  Verwijder .qc bestand en '
		 + 'herstart konfiguratie.'
    qbf-lang[ 3] = 'Bezig met'     /*format x(15)*/
    qbf-lang[ 4] = 'Compileren'      /*format x(15)*/
    qbf-lang[ 5] = 'Her-compileren'   /*format x(15)*/
    qbf-lang[ 6] = 'Bezig met tabel,Bezig met opvraagscherm,Bezig met programma'
    qbf-lang[ 7] = 'Opvraagschermen worden gemaakt voor "*" tabellen. '
		 + '[' + KBLABEL("RETURN") + '] merken/niet merken.'
    qbf-lang[ 8] = '[' + KBLABEL("GO") + '] voor verder gaan, ['
		 + KBLABEL("END-ERROR") + '] voor terug vorig scherm.'
    qbf-lang[ 9] = 'Lijst voor keuze van opvraagschermen wordt aangemaakt...'
    qbf-lang[10] = 'Bent u klaar met het definieren van opvraagschermen?'
    qbf-lang[11] = 'Alle impliciete relaties worden gezocht.'
    qbf-lang[12] = 'Lijst van relaties wordt verwerkt.'
    qbf-lang[13] = 'Niet alle relatie kunnen worden gevonden.'
    qbf-lang[14] = 'Overbodige relatie informatie wordt verwijderd.'
    qbf-lang[15] = 'Weet u zeker dat u nu wilt stoppen?'
    qbf-lang[16] = 'Doorloop tijd,Gemiddelde tijd'
    qbf-lang[17] = 'Kontrole bestand wordt gelezen...'
    qbf-lang[18] = 'Kontrole bestand wordt geschreven...'
    qbf-lang[19] = 'bestaat al.  Gebruik nu'
    qbf-lang[20] = 'bestand wordt herbouwd'
    qbf-lang[21] = 'Opvraagscherm "{1}" wordt gekontroleerd op veranderingen.'
    qbf-lang[22] = 'Opvraagscherm kan alleen gemaakt als RECID of '
		 + 'UNIQUE INDEX beschikbaar.'
    qbf-lang[23] = 'Opvraagscherm niet gewijzigd.'
    qbf-lang[24] = 'Her-compilatie niet nodig.'
    qbf-lang[25] = 'Geen velden op opvraagscherm aanwezig dus niet gegenereerd.'
    qbf-lang[26] = 'Geen velden op opvraagscherm aanwezig dus verwijderd.'
    qbf-lang[27] = 'Lijst beschikbare tabellen wordt samengesteld.'
    qbf-lang[28] = 'Doorloop tijd'
    qbf-lang[29] = 'Klaar!'
    qbf-lang[30] = 'Het compileren van "{1}" is mislukt.'
    qbf-lang[31] = 'Konfiguratie-bestand wordt geschreven:'
    qbf-lang[32] = 'Fouten opgetreden tijdens konfiguratie/compile slag.'
		+ '^^Druk op een toets op controle bestand te bekijken. Regels '
		+ 'met fouten zijn opgelicht.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN

/* b-misc.p */
    /* 1..10 for qbf-l-auto[] */
    qbf-lang[ 1] = 'name,*name*,contact,*contact*'
    qbf-lang[ 2] = '*street,*addr,*address,*address*1'
    qbf-lang[ 3] = '*po*box*,*address*2'
    qbf-lang[ 4] = '*address*3'
    qbf-lang[ 5] = 'city,*city*'
    qbf-lang[ 6] = 'st,state,*state*'
    qbf-lang[ 7] = 'zip,*zip*'
    qbf-lang[ 8] = 'zip*4'
    qbf-lang[ 9] = '*csz*,*city*st*z*'
    qbf-lang[10] = '*country*'

    qbf-lang[15] = 'Voorbeeld van export'.

/*--------------------------------------------------------------------------*/

RETURN.
