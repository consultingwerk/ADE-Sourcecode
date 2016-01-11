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
/* t-r-swe.p - Swedish language definitions for Reports module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
/*r-header.p*/
    qbf-lang[ 1] = 'Ange uttryck fîr'
    qbf-lang[ 2] = 'Rad' /* must be < 8 characters */
                   /* 3..7 are format x(64) */
    qbf-lang[ 3] = 'Dessa funktioner kan anvÑndas i rubrik- och '
                 + 'sidfottext'
    qbf-lang[ 4] = '~{COUNT~}  poster hittills listade  :  '
                 + '~{TIME~}  Tidpunkt rapp.start'
    qbf-lang[ 5] = '~{TODAY~}  Dagens datum             :  '
                 + '~{NOW~}   Aktuell tid'
    qbf-lang[ 6] = '~{PAGE~}   Aktuellt sidnummer    :  '
                 + '~{USER~}  Anv. som kîr rapport'
    qbf-lang[ 7] = '~{VALUE <uttryck>~;<format>~} fîr att infoga variabler'
                 + ' ([' + KBLABEL("GET") + ']tangent)'
    qbf-lang[ 8] = 'VÑlj fÑlt att infoga'
    qbf-lang[ 9] = 'Tryck [' + KBLABEL("GO") + '] fîr att spara, ['
                 + KBLABEL("GET") + ']  addera fÑlt, ['
                 + KBLABEL("END-ERROR") + ']  Üngra.'

/*r-total.p*/    /*"|---------------------------|"*/
    qbf-lang[12] = 'Utfîr dessa  aktioner:'
                 /*"|--------------------------------------------|"*/
    qbf-lang[13] = 'NÑr dessa fÑlt Ñndrar vÑrde:'
                 /*"|---| |---| |---| |---| |---|" */
    qbf-lang[14] = 'Total Antal -Min- -Max- Medel'
    qbf-lang[15] = 'Sluttotal'
    qbf-lang[16] = 'Fîr fÑlt:'
    qbf-lang[17] = 'VÑlj fÑlt fîr total'

/*r-calc.p*/
    qbf-lang[18] = 'VÑlj kolumn fîr kummulativ total'
    qbf-lang[19] = 'VÑlj kolumn fîr procent av total'
    qbf-lang[20] = 'Kummulativ total'
    qbf-lang[21] = '% Total'
    qbf-lang[22] = 'StrÑng,Datum,Logiskt,Mat.,Numeriskt'
    qbf-lang[23] = 'vÑrde'
    qbf-lang[24] = 'Ange startvÑrde fîr rÑknare'
    qbf-lang[25] = 'Ange tillÑgg, positivt eller negativt tal'
    qbf-lang[26] = 'RÑknare'
    qbf-lang[27] = 'RÑknare'
                 /*"------------------------------|"*/
    qbf-lang[28] = '       Start tal fîr rÑknare' /*right justify*/
    qbf-lang[29] = '          Fîr varje post, addera' /*right justify*/
    qbf-lang[32] = 'Du har redan max antal definierade kolumner.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN
/* r-space.p */  /*"------------------------------|  ---------|  |------"*/
    qbf-lang[ 1] = '            Funktion              Nuvarande  Standard'
    /* 2..8 must be less than 32 characters long */
    qbf-lang[ 2] = 'VÑnstermarg'
    qbf-lang[ 3] = 'Blanka mellan kolumner'
    qbf-lang[ 4] = 'Startrad'
    qbf-lang[ 5] = 'Rader per sida'
    qbf-lang[ 6] = 'RadavstÜnd'
    qbf-lang[ 7] = 'Rader mellan rubrik och text'
    qbf-lang[ 8] = 'Rader mellan text och sidfot'
                  /*1234567890123456789012345678901*/
    qbf-lang[ 9] = 'Radavst.'
    qbf-lang[10] = 'RadavstÜnd mÜste vara mellan 1 och sidlÑngden'
    qbf-lang[11] = 'Inga negativa sidlÑngder'
    qbf-lang[12] = 'Rapporten kan ej vara mer vÑnster Ñn kolumn 1'
    qbf-lang[13] = 'HÜll detta vÑrde rimligt'
    qbf-lang[14] = 'Rapporten kan ej bîrja fîre rad 1'

/*r-set.p*/        /* format x(30) for 15..22 */
    qbf-lang[15] = 'F.  Format och rubriker'
    qbf-lang[16] = 'S.  Sidbrytningar'
    qbf-lang[17] = 'T.  Enbart totalrapport'
    qbf-lang[18] = 'M.  Mellanrum'
    qbf-lang[19] = 'VR. VÑnsterrubrik'
    qbf-lang[20] = 'MR. Mittrubrik'
    qbf-lang[21] = 'HR. Hîgerrubrik'
    qbf-lang[22] = 'VS. VÑnster sidfot'
    qbf-lang[23] = 'MS. Mittsidfot'
    qbf-lang[24] = 'HS. Hîger sidfot'
    qbf-lang[25] = 'EF. Enbart-fîrsta-sidan rubr'
    qbf-lang[26] = 'ES. Enbart-sista-sid sidfot'
    qbf-lang[32] = 'Tryck [' + KBLABEL("END-ERROR")
                 + '] nÑr du Ñr klar med Ñndringar.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
    /* r-main.p,s-page.p */
    qbf-lang[ 1] = 'Filer:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Ordn.:'
    qbf-lang[ 3] = 'Rapportinfo'
    qbf-lang[ 4] = 'Rapportlayout'
    qbf-lang[ 5] = 'mera' /* for <<more and more>> */
    qbf-lang[ 6] = 'Rapport,Bredd' /* each word comma-separated */
    qbf-lang[ 7] = 'AnvÑnd < och > fîr att blÑddra vÑnster och hîger'
    qbf-lang[ 8] = 'Kan ej generera rapport med stîrre bredd Ñn '
                 + '255 tecken'
    qbf-lang[ 9] = 'Du tog ej bort aktuell rapport.  Vill du '
                 + 'fortsÑtta?'
    qbf-lang[10] = 'Genererar program...'
    qbf-lang[11] = 'Kompilerar genererat program...'
    qbf-lang[12] = 'Kîr genererat program...'
    qbf-lang[13] = 'Kunde ej skriva till fil eller enhet'
    qbf-lang[14] = 'SÑkert att du vill ta bort aktuell rapport '
                 + 'definition?'
    qbf-lang[15] = 'SÑkert att du vill avsluta denna modul?'
    qbf-lang[16] = 'Tryck ['
                 + (IF KBLABEL("CURSOR-UP") BEGINS "CTRL-" THEN 'CURSOR-UP'
                   ELSE KBLABEL("CURSOR-UP"))
                 + '] och ['
                 + (IF KBLABEL("CURSOR-DOWN") BEGINS "CTRL-" THEN 'CURSOR-DOWN'
                   ELSE KBLABEL("CURSOR-DOWN"))
                 + '] fîr att blÑddra, ['
                 + KBLABEL("END-ERROR") + '] efter klar.'
    qbf-lang[17] = 'Sida'
    qbf-lang[18] = '~{1~} poster i rapporten.'
    qbf-lang[19] = 'Kan ej generera en Enbart-Total-Rapport nÑr inget '
                 + 'sorteringsfÑlt Ñr definierat.'
    qbf-lang[20] = 'Kan ej generera en Enbart-Total-Rapport med '
                 + 'matrisfÑlt definierade.'
    qbf-lang[21] = 'Enbart-Totaler'
    qbf-lang[23] = 'Kan ej generera en rapport utan definierade fÑlt.'.

ELSE

/*--------------------------------------------------------------------------*/
/* FAST TRACK interface test for r-ft.p r-ftsub.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = 'FAST TRACK kan ej skicka utdata till terminal nÑr'
    qbf-lang[ 2] = 'du kan ange utdataval.  Utdata Ñndrat till PRINTER.'
    qbf-lang[ 3] = 'Analyserar rubriker och fotrubriker...'
    qbf-lang[ 4] = 'Skapar brytbegrepp...'
    qbf-lang[ 5] = 'Skapar fÑlt och totaler...'
    qbf-lang[ 6] = 'Skapar filer och WHERE satser...'
    qbf-lang[ 7] = 'Skapar rubriker och sidfîtter...'
    qbf-lang[ 8] = 'Skapar rapportrader...'
    qbf-lang[ 9] = 'Det finns redan en rapport ~{1~} i FAST TRACK.  Vill '
                 + 'du skriva îver den?'
    qbf-lang[10] = 'Skriver îver rapport...'
    qbf-lang[11] = 'Vill du starta FAST TRACK?'
    qbf-lang[12] = 'Ange ett namn'
    qbf-lang[13] = 'FAST TRACK kan ej anvÑnda TIME i rubrik/sidfot, '
                 + 'ersatt med NOW.'
    qbf-lang[14] = 'FAST TRACK klarar ej procent av total, fÑlt tas ej med'
    qbf-lang[15] = 'FAST TRACK klarar ej ~{1~} i rubrik/sidfot, '
                 + '~{2~} tas ej med.'
    qbf-lang[16] = 'Rapportnamn fÜr bara bestÜ av alfanumeriska tecken '
                 + 'eller understrykning.'
    qbf-lang[17] = 'Rapportnamn i FAST TRACK:'
    qbf-lang[18] = 'Rapport ej îverfîrd till FAST TRACK'
    qbf-lang[19] = 'Startar FAST TRACK, vÑnta...'
    qbf-lang[20] = 'Klamrar ej parvis i rubrik/sidfot, '
                 + 'rapport EJ îverfîrd.'
    qbf-lang[21] = 'FAST TRACK klarar ej endast fîrst/sist rubriker.'
                 + '  Ignorerad.'
    qbf-lang[22] = 'Varning: Starttal ~{1~} anvÑnt till rÑknare.'
    qbf-lang[23] = 'INNEHèLLER'
    qbf-lang[24] = 'TOTAL,COUNT,MAX,MIN,AVG'
    qbf-lang[25] = 'FAST TRACK klarar ej Enbart-Totaler-rapporter.  '
                 + 'Rapport kunde ej îverfîras.'
    qbf-lang[26] = 'Kan ej îverfîra en rapport till FAST TRACK med inga '
                 + 'definierade tabeller eller fÑlt.'.


ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 5 THEN
  ASSIGN
    /* r-short.p */
    qbf-lang[ 1] = 'Definition av Enbart-Total-rapport medfîr att endast '
                 + 'summerad information visas.  Baserad pÜ '
                 + 'sista fÑltet i din "Ordning" lista, kommer en ny rad '
                 + 'att visas varje gÜng som detta ordn.fÑlts vÑrde '
                 + 'Ñndras.^Fîr denna rapport kommer en ny rad att visas '
                 + 'varje gÜng ~{1~} fÑltet Ñndras.^Gîr denna till '
                 + 'en Enbart-Total-Rapport?'
    qbf-lang[ 2] = 'JA'
    qbf-lang[ 3] = 'NEJ'
    qbf-lang[ 4] = 'Du kan ej anvÑnda "Enbart-Totaler"-valet fîrrÑn du '
                 + 'valt "Ordning" fÑlt fîr att sortera din rapport.^^'
                 + 'VÑlj dessa ordningsfÑlt genom att anvÑnda "Ordning" '
                 + '-valet i Rapports huvudmeny, och fîrsîk sedan '
                 + 'igen.'
    qbf-lang[ 5] = 'Denna lista visar alla fÑlt som du nu har '
                 + 'definierat fîr'
    qbf-lang[ 6] = 'denna rapport.  FÑlt markerade med en asterisk  '
                 + 'summeras.'
    qbf-lang[ 7] = 'Om du vÑljer ett numeriskt fÑlt att summeras, kommer en '
                 + 'subtotal fîr detta fÑlt att visas varje gÜng ~{1~} fÑltets '
                 + 'vÑrde Ñndras.'
    qbf-lang[ 8] = 'Om du vÑljer ett ej numeriskt fÑlt, kommer antalet '
                 + 'poster i varje ~{1~} grupp att visas.'
    qbf-lang[ 9] = 'Om du inte vÑljer att summera ett fÑlt kommer det vÑrde '
                 + 'som gruppens sista post innehîll att visas.'

    /* r-page.p */
    qbf-lang[26] = 'Sidbrytningar'
    qbf-lang[27] = "inga sidbrytningar"

    qbf-lang[28] = 'NÑr ett vÑrde i ett av fîljande'
    qbf-lang[29] = 'fÑlt Ñndras kan sidbrytning ske'
    qbf-lang[30] = 'automatiskt.'
    qbf-lang[31] = 'VÑlj frÜn fîljande lista det fÑlt som'
    qbf-lang[32] = 'skall Üstadkomma denna sidbrytning.'.

/*--------------------------------------------------------------------------*/

RETURN.
