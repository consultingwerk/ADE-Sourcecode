/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
    qbf-lang[ 1] = 'Ange uttryck f�r'
    qbf-lang[ 2] = 'Rad' /* must be < 8 characters */
                   /* 3..7 are format x(64) */
    qbf-lang[ 3] = 'Dessa funktioner kan anv�ndas i rubrik- och '
                 + 'sidfottext'
    qbf-lang[ 4] = '~{COUNT~}  poster hittills listade  :  '
                 + '~{TIME~}  Tidpunkt rapp.start'
    qbf-lang[ 5] = '~{TODAY~}  Dagens datum             :  '
                 + '~{NOW~}   Aktuell tid'
    qbf-lang[ 6] = '~{PAGE~}   Aktuellt sidnummer    :  '
                 + '~{USER~}  Anv. som k�r rapport'
    qbf-lang[ 7] = '~{VALUE <uttryck>~;<format>~} f�r att infoga variabler'
                 + ' ([' + KBLABEL("GET") + ']tangent)'
    qbf-lang[ 8] = 'V�lj f�lt att infoga'
    qbf-lang[ 9] = 'Tryck [' + KBLABEL("GO") + '] f�r att spara, ['
                 + KBLABEL("GET") + ']  addera f�lt, ['
                 + KBLABEL("END-ERROR") + ']  �ngra.'

/*r-total.p*/    /*"|---------------------------|"*/
    qbf-lang[12] = 'Utf�r dessa  aktioner:'
                 /*"|--------------------------------------------|"*/
    qbf-lang[13] = 'N�r dessa f�lt �ndrar v�rde:'
                 /*"|---| |---| |---| |---| |---|" */
    qbf-lang[14] = 'Total Antal -Min- -Max- Medel'
    qbf-lang[15] = 'Sluttotal'
    qbf-lang[16] = 'F�r f�lt:'
    qbf-lang[17] = 'V�lj f�lt f�r total'

/*r-calc.p*/
    qbf-lang[18] = 'V�lj kolumn f�r kummulativ total'
    qbf-lang[19] = 'V�lj kolumn f�r procent av total'
    qbf-lang[20] = 'Kummulativ total'
    qbf-lang[21] = '% Total'
    qbf-lang[22] = 'Str�ng,Datum,Logiskt,Mat.,Numeriskt'
    qbf-lang[23] = 'v�rde'
    qbf-lang[24] = 'Ange startv�rde f�r r�knare'
    qbf-lang[25] = 'Ange till�gg, positivt eller negativt tal'
    qbf-lang[26] = 'R�knare'
    qbf-lang[27] = 'R�knare'
                 /*"------------------------------|"*/
    qbf-lang[28] = '       Start tal f�r r�knare' /*right justify*/
    qbf-lang[29] = '          F�r varje post, addera' /*right justify*/
    qbf-lang[32] = 'Du har redan max antal definierade kolumner.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN
/* r-space.p */  /*"------------------------------|  ---------|  |------"*/
    qbf-lang[ 1] = '            Funktion              Nuvarande  Standard'
    /* 2..8 must be less than 32 characters long */
    qbf-lang[ 2] = 'V�nstermarg'
    qbf-lang[ 3] = 'Blanka mellan kolumner'
    qbf-lang[ 4] = 'Startrad'
    qbf-lang[ 5] = 'Rader per sida'
    qbf-lang[ 6] = 'Radavst�nd'
    qbf-lang[ 7] = 'Rader mellan rubrik och text'
    qbf-lang[ 8] = 'Rader mellan text och sidfot'
                  /*1234567890123456789012345678901*/
    qbf-lang[ 9] = 'Radavst.'
    qbf-lang[10] = 'Radavst�nd m�ste vara mellan 1 och sidl�ngden'
    qbf-lang[11] = 'Inga negativa sidl�ngder'
    qbf-lang[12] = 'Rapporten kan ej vara mer v�nster �n kolumn 1'
    qbf-lang[13] = 'H�ll detta v�rde rimligt'
    qbf-lang[14] = 'Rapporten kan ej b�rja f�re rad 1'

/*r-set.p*/        /* format x(30) for 15..22 */
    qbf-lang[15] = 'F.  Format och rubriker'
    qbf-lang[16] = 'S.  Sidbrytningar'
    qbf-lang[17] = 'T.  Enbart totalrapport'
    qbf-lang[18] = 'M.  Mellanrum'
    qbf-lang[19] = 'VR. V�nsterrubrik'
    qbf-lang[20] = 'MR. Mittrubrik'
    qbf-lang[21] = 'HR. H�gerrubrik'
    qbf-lang[22] = 'VS. V�nster sidfot'
    qbf-lang[23] = 'MS. Mittsidfot'
    qbf-lang[24] = 'HS. H�ger sidfot'
    qbf-lang[25] = 'EF. Enbart-f�rsta-sidan rubr'
    qbf-lang[26] = 'ES. Enbart-sista-sid sidfot'
    qbf-lang[32] = 'Tryck [' + KBLABEL("END-ERROR")
                 + '] n�r du �r klar med �ndringar.'.

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
    qbf-lang[ 7] = 'Anv�nd < och > f�r att bl�ddra v�nster och h�ger'
    qbf-lang[ 8] = 'Kan ej generera rapport med st�rre bredd �n '
                 + '255 tecken'
    qbf-lang[ 9] = 'Du tog ej bort aktuell rapport.  Vill du '
                 + 'forts�tta?'
    qbf-lang[10] = 'Genererar program...'
    qbf-lang[11] = 'Kompilerar genererat program...'
    qbf-lang[12] = 'K�r genererat program...'
    qbf-lang[13] = 'Kunde ej skriva till fil eller enhet'
    qbf-lang[14] = 'S�kert att du vill ta bort aktuell rapport '
                 + 'definition?'
    qbf-lang[15] = 'S�kert att du vill avsluta denna modul?'
    qbf-lang[16] = 'Tryck ['
                 + (IF KBLABEL("CURSOR-UP") BEGINS "CTRL-" THEN 'CURSOR-UP'
                   ELSE KBLABEL("CURSOR-UP"))
                 + '] och ['
                 + (IF KBLABEL("CURSOR-DOWN") BEGINS "CTRL-" THEN 'CURSOR-DOWN'
                   ELSE KBLABEL("CURSOR-DOWN"))
                 + '] f�r att bl�ddra, ['
                 + KBLABEL("END-ERROR") + '] efter klar.'
    qbf-lang[17] = 'Sida'
    qbf-lang[18] = '~{1~} poster i rapporten.'
    qbf-lang[19] = 'Kan ej generera en Enbart-Total-Rapport n�r inget '
                 + 'sorteringsf�lt �r definierat.'
    qbf-lang[20] = 'Kan ej generera en Enbart-Total-Rapport med '
                 + 'matrisf�lt definierade.'
    qbf-lang[21] = 'Enbart-Totaler'
    qbf-lang[23] = 'Kan ej generera en rapport utan definierade f�lt.'.

ELSE

/*--------------------------------------------------------------------------*/
/* FAST TRACK interface test for r-ft.p r-ftsub.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = 'FAST TRACK kan ej skicka utdata till terminal n�r'
    qbf-lang[ 2] = 'du kan ange utdataval.  Utdata �ndrat till PRINTER.'
    qbf-lang[ 3] = 'Analyserar rubriker och fotrubriker...'
    qbf-lang[ 4] = 'Skapar brytbegrepp...'
    qbf-lang[ 5] = 'Skapar f�lt och totaler...'
    qbf-lang[ 6] = 'Skapar filer och WHERE satser...'
    qbf-lang[ 7] = 'Skapar rubriker och sidf�tter...'
    qbf-lang[ 8] = 'Skapar rapportrader...'
    qbf-lang[ 9] = 'Det finns redan en rapport ~{1~} i FAST TRACK.  Vill '
                 + 'du skriva �ver den?'
    qbf-lang[10] = 'Skriver �ver rapport...'
    qbf-lang[11] = 'Vill du starta FAST TRACK?'
    qbf-lang[12] = 'Ange ett namn'
    qbf-lang[13] = 'FAST TRACK kan ej anv�nda TIME i rubrik/sidfot, '
                 + 'ersatt med NOW.'
    qbf-lang[14] = 'FAST TRACK klarar ej procent av total, f�lt tas ej med'
    qbf-lang[15] = 'FAST TRACK klarar ej ~{1~} i rubrik/sidfot, '
                 + '~{2~} tas ej med.'
    qbf-lang[16] = 'Rapportnamn f�r bara best� av alfanumeriska tecken '
                 + 'eller understrykning.'
    qbf-lang[17] = 'Rapportnamn i FAST TRACK:'
    qbf-lang[18] = 'Rapport ej �verf�rd till FAST TRACK'
    qbf-lang[19] = 'Startar FAST TRACK, v�nta...'
    qbf-lang[20] = 'Klamrar ej parvis i rubrik/sidfot, '
                 + 'rapport EJ �verf�rd.'
    qbf-lang[21] = 'FAST TRACK klarar ej endast f�rst/sist rubriker.'
                 + '  Ignorerad.'
    qbf-lang[22] = 'Varning: Starttal ~{1~} anv�nt till r�knare.'
    qbf-lang[23] = 'INNEH�LLER'
    qbf-lang[24] = 'TOTAL,COUNT,MAX,MIN,AVG'
    qbf-lang[25] = 'FAST TRACK klarar ej Enbart-Totaler-rapporter.  '
                 + 'Rapport kunde ej �verf�ras.'
    qbf-lang[26] = 'Kan ej �verf�ra en rapport till FAST TRACK med inga '
                 + 'definierade tabeller eller f�lt.'.


ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 5 THEN
  ASSIGN
    /* r-short.p */
    qbf-lang[ 1] = 'Definition av Enbart-Total-rapport medf�r att endast '
                 + 'summerad information visas.  Baserad p� '
                 + 'sista f�ltet i din "Ordning" lista, kommer en ny rad '
                 + 'att visas varje g�ng som detta ordn.f�lts v�rde '
                 + '�ndras.^F�r denna rapport kommer en ny rad att visas '
                 + 'varje g�ng ~{1~} f�ltet �ndras.^G�r denna till '
                 + 'en Enbart-Total-Rapport?'
    qbf-lang[ 2] = 'JA'
    qbf-lang[ 3] = 'NEJ'
    qbf-lang[ 4] = 'Du kan ej anv�nda "Enbart-Totaler"-valet f�rr�n du '
                 + 'valt "Ordning" f�lt f�r att sortera din rapport.^^'
                 + 'V�lj dessa ordningsf�lt genom att anv�nda "Ordning" '
                 + '-valet i Rapports huvudmeny, och f�rs�k sedan '
                 + 'igen.'
    qbf-lang[ 5] = 'Denna lista visar alla f�lt som du nu har '
                 + 'definierat f�r'
    qbf-lang[ 6] = 'denna rapport.  F�lt markerade med en asterisk  '
                 + 'summeras.'
    qbf-lang[ 7] = 'Om du v�ljer ett numeriskt f�lt att summeras, kommer en '
                 + 'subtotal f�r detta f�lt att visas varje g�ng ~{1~} f�ltets '
                 + 'v�rde �ndras.'
    qbf-lang[ 8] = 'Om du v�ljer ett ej numeriskt f�lt, kommer antalet '
                 + 'poster i varje ~{1~} grupp att visas.'
    qbf-lang[ 9] = 'Om du inte v�ljer att summera ett f�lt kommer det v�rde '
                 + 'som gruppens sista post inneh�ll att visas.'

    /* r-page.p */
    qbf-lang[26] = 'Sidbrytningar'
    qbf-lang[27] = "inga sidbrytningar"

    qbf-lang[28] = 'N�r ett v�rde i ett av f�ljande'
    qbf-lang[29] = 'f�lt �ndras kan sidbrytning ske'
    qbf-lang[30] = 'automatiskt.'
    qbf-lang[31] = 'V�lj fr�n f�ljande lista det f�lt som'
    qbf-lang[32] = 'skall �stadkomma denna sidbrytning.'.

/*--------------------------------------------------------------------------*/

RETURN.
