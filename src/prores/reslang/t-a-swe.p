/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-a-swe.p - Swedish language definitions for Admin module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/*results.p,s-module.p*/
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'F. Fr�gor'
    qbf-lang[ 2] = 'R. Rapporter'
    qbf-lang[ 3] = 'E. Etiketter'
    qbf-lang[ 4] = 'D. Dataexport'
    qbf-lang[ 5] = 'K. Egen applikation'
    qbf-lang[ 6] = 'A. Administration'
    qbf-lang[ 7] = 'S. Slut'
    qbf-lang[ 8] = 'F. FAST TRACK'
    qbf-lang[10] = 'Filen' /*DBNAME.qc*/
    qbf-lang[11] = 'saknas. Det inneb�r att du m�ste g�ra en "Initial'
                 + ' Uppbyggnad" p� denna databas. Vill du g�ra det nu?'
    qbf-lang[12] = 'V�lj ny modul eller tryck [' + KBLABEL("END-ERROR")
                 + '] f�r att stanna i denna modul.'
    qbf-lang[13] = 'Du har inte k�pt RESULTS. Program avslutat.'
    qbf-lang[14] = 'Vill du verkligen avsluta "~{1~}" nu?'
    qbf-lang[15] = 'MANUAL,SEMI,AUTO'
    qbf-lang[16] = 'Ingen databas ansluten.'
    qbf-lang[17] = 'Kan ej exekvera n�r en databas har ett logiskt namn '
                 + 'som b�rjar med "QBF$".'
    qbf-lang[18] = 'Avbryt'
    qbf-lang[19] = '** RESULTS konfunderad **^^I  ~{1~} katalogen kan '
                 + 'varken ~{2~}.db eller ~{2~}.qc hittas.  ~{3~}.qc '
                 + 'finns i PROPATH, men den tycks tillh�ra '
                 + '~{3~}.db. R�tta till din PROPATH eller d�p om/tabort '
                 + '~{3~}.db och .qc.'
    /* 24,26,30,32 available if necessary */
    qbf-lang[21] = '         Det finns tre s�tt att skapa fr�geformul�r f�r '
                 + 'PROGRESS'
    qbf-lang[22] = '         RESULTS.  N�r som helst efter RESULTS skapat '
                 + 'fr�geformul�ren,'
    qbf-lang[23] = '         kan du manuellt f�r�ndra dem.'
    qbf-lang[25] = 'Du vill manuellt definiera varje fr�geformul�r.'
    qbf-lang[27] = 'Sedan du valt en delm�ngd av filer fr�n de anslutna'
    qbf-lang[28] = 'databaserna, genererar RESULTS fr�geformul�r endast f�r'
    qbf-lang[29] = 'dessa filer.'
    qbf-lang[31] = 'RESULTS genererar alla fr�geformul�r automatiskt.'.


/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-user.p*/
IF qbf-s = 2 THEN
  /* format x(72) for 1,2,9-14,19-22 */
  ASSIGN
    qbf-lang[ 1] = 'Ange namnet p� den include fil som skall anv�ndas f�r'
    qbf-lang[ 2] = 'Bl�ddringsvalet i Fr�gemodulen.'
    qbf-lang[ 3] = '   Default Include Fil:' /*format x(24)*/

    qbf-lang[ 8] = 'Hittar ej program'

    qbf-lang[ 9] = 'Ange namnet p� logga-p�-programmet.  Detta program kan '
                 + 'antingen vara'
    qbf-lang[10] = 'en enkel bild, eller en komplett loginprocedur liknande '
                 + '"login.p"'
    qbf-lang[11] = 'i "DLC" biblioteket.  Detta program exekveras s� snart '
                 + 'som'
    qbf-lang[12] = '"signon=" raden l�ses fr�n DBNAME.qc filen.'
    qbf-lang[13] = 'Ange namnet p� produkten s� som du vill visa den'
    qbf-lang[14] = 'p� Huvudmenyn.'
    qbf-lang[15] = '       Logga-p� program:' /*format x(24)*/
    qbf-lang[16] = '            Produktnamn:' /*format x(24)*/
    qbf-lang[17] = 'Default:'

    qbf-lang[18] = 'PROGRESS Egen procedur:'
    qbf-lang[19] = 'Denna procedur k�rs n�r "Egen" alternativet har valts '
                 + 'fr�n n�gon meny.'

    qbf-lang[20] = 'Dataexportprogram tillverkat av anv�ndaren.'
    qbf-lang[21] = 'Ange b�de procedurnamnet och beskrivningen'
    qbf-lang[22] = 'f�r "Data Export - Inst�llning" menyn.'
    qbf-lang[23] = 'Procedur:'
    qbf-lang[24] = 'Beskrivning:'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-load.p:*/
IF qbf-s = 3 THEN
  ASSIGN
    /* menu strip for d-main.p,l-main.p,r-main.p */
    qbf-lang[ 1] = 'H�mta,Ladda en tidigare definierad ~{1~}.'
    qbf-lang[ 2] = 'Lagra,Spara aktuell ~{1~}.'
    qbf-lang[ 3] = 'K�r,K�r aktuell ~{1~}.'
    qbf-lang[ 4] = 'Def,V�lj tabeller och f�lt.'
    qbf-lang[ 5] = 'St�lla in,�ndra typ, format el layout av aktuell ~{1~}.'
    qbf-lang[ 6] = 'Urval,WHERE-sats-editor f�r urval av poster.'
    qbf-lang[ 7] = 'Ordning,�ndrar utdata ordning av poster.'
    qbf-lang[ 8] = 'Rensa,Suddar ut nu definierad ~{1~}.'
    qbf-lang[ 9] = 'Info,Information om aktuell inst�llning.'
    qbf-lang[10] = 'Modul,�verg�ng till annan modul.'
    qbf-lang[11] = 'Egen,�verg�ng till av kund vald funktion.'
    qbf-lang[12] = 'Avsluta,Avslut.'
    qbf-lang[13] = '' /* terminator */
    qbf-lang[14] = 'export,etikett,rapport'

    qbf-lang[15] = 'L�ser konfigurationsfil...'

    /* system values for CONTINUE Must be <= 12 characters */
    qbf-lang[18] = '  Forts�tt' /* for error dialog box */
    qbf-lang[19] = 'Svensk' /* this name of this language */
    /* word "of" for "xxx of yyy" on scrolling lists */
    qbf-lang[20] = 'av'
    /* standard product name */
    qbf-lang[22] = 'PROGRESS RESULTS'
    /* system values for descriptions of calc fields */
    qbf-lang[23] = ',Kummulativ total,Procent av total,Antal,Str�nguttr,'
                 + 'Datumuttr,Numeriskt uttr,Logiskt uttr,Stacked Array'
    /* system values for YES and NO.  Must be <= 8 characters each */
    qbf-lang[24] = '  Ja  ,  Nej  ' /* for yes/no dialog box */

    qbf-lang[25] = 'En p�g�ende automatisk generering av appl. avbr�ts.  '
                 + 'Forts�tt med automatisk generering?'

    qbf-lang[26] = '* VARNING - Versionsblandning *^^Aktuell version �r '
                 + '<~{1~}> medan .qc fil �r f�r version <~{2~}>.  Problem '
                 + 'kan uppst� innan Fr�geformul�r �ter genererats m.h.a. '
                 + '"�teruppbyggnad av applikation".'

    qbf-lang[27] = '* VARNING - Databaser saknas *^^F�ljande '
                 + 'databas(er) beh�vs men �r ej anslutna:'

    qbf-lang[32] = '* VARNING - Schema �ndrat *^^Databasstruktur har '
                 + '�ndrats efter uppbyggnad av n�gra fr�geformul�r.  '
                 + 'Anv�nd "�teruppbyggnad av applikation" fr�n Administration '
                 + 'meny snarast m�jligt.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-main.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = " A. �teruppbyggnad av applikation"
    qbf-lang[ 2] = " F. Definitioner Fr�geformul�r"
    qbf-lang[ 3] = " R. Relationer mellan tabeller"

    qbf-lang[ 4] = " C. Inneh�ll av anv�ndarbibliotek"
    qbf-lang[ 5] = " H. Hur avsluta applikation"
    qbf-lang[ 6] = " M. Modul beh�righet"
    qbf-lang[ 7] = " Q. Fr�geformul�r beh�righet"
    qbf-lang[ 8] = " S. Logga-p� program/produktnamn"

    qbf-lang[11] = " G. Spr�k"
    qbf-lang[12] = " P. Skrivareinst�llning"
    qbf-lang[13] = " T. Terminal f�rginst�llning"

    qbf-lang[14] = " B. Bl�ddr.program Fr�geformul�r"
    qbf-lang[15] = " D. Normal rapportinst�llning"
    qbf-lang[16] = " E. Anv�ndardef. exportformat"
    qbf-lang[17] = " L. Val av etikettf�lt"
    qbf-lang[18] = " U. Egna alternativ"

    qbf-lang[21] = 'G�r ett val eller tryck [' + KBLABEL("END-ERROR")
                 + '] f�r avslut och spara �ndringar.'
    /* these next four have a length limit of 20 including colon */
    qbf-lang[22] = 'Tabeller:'
    qbf-lang[23] = 'Konfiguration:'
    qbf-lang[24] = 'S�kerhet:'
    qbf-lang[25] = 'Moduler:'

    qbf-lang[26] = 'Administration'
    qbf-lang[27] = 'Version'
    qbf-lang[28] = 'Laddar administrationsdata fr�n '
                 + 'konfigurationsfilen.'
    qbf-lang[29] = 'S�kert att du vill �teruppbygga applikationen?'
/* QUIT and RETURN are the PROGRESS keywords and cannot be translated */
    qbf-lang[30] = 'N�r anv�ndaren l�mnar huvudmenyn, skall programmet d� '
                 + 'l�mna PROGRESS(QUIT) eller RESULTS(RETURN) ?'
    qbf-lang[31] = 'S�kert att du nu vill l�mna administrations'
                 + 'menyn?'
    qbf-lang[32] = 'Verifierar konfigurationsfilsstrukturen och sparar ev. '
                 + '�ndringar.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 5 THEN
  ASSIGN
/*a-perm.p, 1..7 also used by a-form.p and a-print.p*/
    qbf-lang[ 1] = 'Beh�righet'
    qbf-lang[ 2] = '    *                   - Alla anv�ndare har access.'
    qbf-lang[ 3] = '    <user>,<user>,etc.  - Endast angivna anv har access'
    qbf-lang[ 4] = '    !<user>,!<user>,*   - Alla utom dessa anv har '
                 + 'access.'
    qbf-lang[ 5] = '    acct*               - Endast anv som b�rjar med '
                 + '"acct" till�ts'
    qbf-lang[ 6] = 'Lista anv per loginid, och separera dem med '
                 + 'kommatecken.'
    qbf-lang[ 7] = 'Id kan inneh�lla wildcards.  Anv utropstecken f�r att '
                 + 'utesluta anv.'
                   /* from 8 thru 13, format x(30) */
    qbf-lang[ 8] = 'V�lj en modul fr�n'
    qbf-lang[ 9] = 'listan till v�nster'
    qbf-lang[10] = 's�tt beh�righet f�r.'
    qbf-lang[11] = 'V�lj en funktion fr�n'
    qbf-lang[12] = 'listan till v�nster'
    qbf-lang[13] = 's�tt beh�righet f�r.'
    qbf-lang[14] = 'Tryck [' + KBLABEL("END-ERROR")
                 + '] n�r �ndring �r klar.'
    qbf-lang[15] = 'Tryck [' + KBLABEL("GO") + '] f�r att spara, ['
                 + KBLABEL("END-ERROR") + '] f�r att �ngra.'
    qbf-lang[16] = 'Du kan ej utesluta dig sj�lv fr�n Administration!'
/*a-print.p:*/     /*21 thru 26 must be format x(16) and right-justified */
    qbf-lang[21] = '      Initiering'
    qbf-lang[22] = '                '
    qbf-lang[23] = '    Normalskrift'
    qbf-lang[24] = '       Hopdragen'
    qbf-lang[25] = '     Fet stil P�'
    qbf-lang[26] = '     Fet stil AV'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 6 THEN
  ASSIGN
/*a-write.p:*/
    qbf-lang[ 1] = 'Laddar modulinst�llningar'
    qbf-lang[ 2] = 'Laddar f�rginst�llningar'
    qbf-lang[ 3] = 'Laddar skrivareinst�llning'
    qbf-lang[ 4] = 'Laddar lista av visningsbara filer'
    qbf-lang[ 5] = 'Laddar lista av relationer'
    qbf-lang[ 6] = 'Laddar auto-val f�ltlista f�r postetiketter'
    qbf-lang[ 7] = 'Laddar beh�righetslista f�r fr�gefunktioner'
    qbf-lang[ 8] = 'Laddar anv.funktion information'
    qbf-lang[ 9] = 'Laddar systemrapport standards'

/* a-color.p*/
                 /* 12345678901234567890123456789012 */
    qbf-lang[11] = '  F�rger f�r vilken terminaltyp:' /* must be 32 */
                 /* 1234567890123456789012345 */
    qbf-lang[12] = 'Meny:             Normal:' /* must be 25 */
    qbf-lang[13] = '                 Upplyst:'
    qbf-lang[14] = 'Dialogbox:        Normal:'
    qbf-lang[15] = '                 Upplyst:'
    qbf-lang[16] = 'Bl�ddr-lista:     Normal:'
    qbf-lang[17] = '                 Upplyst:'

/*a-field.p*/    /*"----- ----- ----- ----- ----"*/
    qbf-lang[30] = 'Visa? Uppd? Fr�ga?Bl�ddr? Seq'
    qbf-lang[31] = 'M�ste ligga i intervallet 1 till 9999.'
    qbf-lang[32] = 'Vill du spara just gjorda �ndringar i '
                 + 'f�ltlistan?'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 8 THEN
/*a-label.p*/
  ASSIGN            /* 1..8 use format x(78) */
                    /* 1 and 8 are available for more explanation, in */
                    /*   case the translation won't fit in 2 thru 7.  */
    qbf-lang[ 2] = 'Ange f�ltnamnen som inneh�ller adressinformation.  '
                 + 'Anv�nd CAN-DO'
    qbf-lang[ 3] = 'typlistor f�r att matcha dessa f�lt-namn ("*" matchar '
                 + 'godtyckligt antal'
    qbf-lang[ 4] = 'tecken, "." matchar ett tecken).  Denna '
                 + 'information anv�nds'
    qbf-lang[ 5] = 'f�r att skapa standardetiketter.  Obs att n�gra '
                 + 'indata kan vara'
    qbf-lang[ 6] = '�verfl�diga - t.ex, om du alltid lagrar stad '
                 + 'och postnr i'
    qbf-lang[ 7] = 'separata f�lt, beh�ver du ej anv�nda "Pnr-S" raden.'
                  /* each entry in list must be <= 5 characters long */
                  /* but may be any portion of address that is applicable */
                  /* in the target country */
 /*   qbf-lang[ 9] = 'Namn,Adr1,Adr2,Adr3,Stad,Stat,P-nr,Pnr+4,S-P,Land' */
    qbf-lang[ 9] = 'Namn,Adr1,Adr2,Adr3,pnr-S,pnr,Stad,Land,Ex-1,Ex-2'
    qbf-lang[10] = 'F�lt som inneh�ller <namn>'
    qbf-lang[11] = 'F�lt som inneh�ller <f�rsta> adressrad (t.e. gata)'
    qbf-lang[12] = 'F�lt som inneh�ller <andra> adressrad (t.e.  Box)'
    qbf-lang[13] = 'F�lt som inneh�ller <tredje> adressrad (ev.)'
    qbf-lang[14] = 'F�lt som inneh�ller <kombination av pnr-stad>'
    qbf-lang[15] = 'F�lt som inneh�ller <pnr>'
    qbf-lang[16] = 'F�lt som inneh�ller namn p� <stad>'
    qbf-lang[17] = 'F�lt som inneh�ller namn p� <land>'
    qbf-lang[18] = 'Anv�nds inte'
    qbf-lang[19] = 'Anv�nds inte'

/*a-join.p*/
    qbf-lang[23] = 'Hittills �r self-joins ej till�tna.'
    qbf-lang[24] = 'Maxantal av  relationer har uppn�tts.'
    qbf-lang[25] = 'Relation av' /* 25 and 26 are automatically */
    qbf-lang[26] = 'till'          /*   right-justified           */
    qbf-lang[27] = 'Ange WHERE el OF sats: (l�mna blank = borttag av relation)'
    qbf-lang[28] = 'Tryck [' + KBLABEL("END-ERROR") + '] n�r uppdat �r klar.'
    qbf-lang[30] = 'Kommando m�ste b�rja med WHERE el OF.'
    qbf-lang[31] = 'Ange f�rsta fil i relation att addera el ta bort.'
    qbf-lang[32] = 'Och nu andra filen i relationen.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-form.p */
IF qbf-s = 9 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' A. Addera nytt fr�geformul�r '
    qbf-lang[ 2] = ' C. V�lj fr�geformul�r att editera '
    qbf-lang[ 3] = ' G. Generella formul�regenskaper '
    qbf-lang[ 4] = ' W. Vilka f�lt i formul�r '
    qbf-lang[ 5] = ' P. Beh�righeter '
    qbf-lang[ 6] = ' D. Tag bort aktuellt fr�geformul�r '
    qbf-lang[ 7] = ' V�lj: ' /* format x(10) */
    qbf-lang[ 8] = ' Uppdat: ' /* format x(10) */
                 /* cannot changed width of 9..16 from defined below */
    qbf-lang[ 9] = '     Databas tabellnamn' /* right-justify 9..14 */
    qbf-lang[10] = '            Formul�rtyp'
    qbf-lang[11] = '   Fr�geprogram filnamn'
    qbf-lang[12] = '  Formul�r fys. filnamn'
    qbf-lang[13] = '   Ram namn f�r 4GL-kod'
    qbf-lang[14] = '            Beskrivning'
    qbf-lang[15] = '(.p antaget)     ' /* left-justify 15 and 16 */
    qbf-lang[16] = '(beh�ver filtill�gg)'
    qbf-lang[18] = 'Detta formul�r �r ~{1~} rader l�ng.  D� RESULTS reserverar '
                 + '5 rader f�r eget bruk, kommer sk�rmstorleken 24x80 att '
                 + '�verskridas.  S�kert att du vill definiera ett s� '
                 + 'h�r stort formul�r?'
    qbf-lang[19] = 'Ett fr�geprogram med detta namn finns redan.'
    qbf-lang[20] = 'Detta formul�r m�ste redan finnas, el m�ste sluta med .f  '
                 + 'f�r automatisk generering.'
    qbf-lang[21] = 'Namnet du valde f�r 4GL-formul�ret �r reserverat.  '
                 + 'V�lj ett annat.'
    qbf-lang[22] = ' V�lj �tkomliga filer '
    qbf-lang[23] = 'Tryck [' + KBLABEL("END-ERROR") + '] n�r updatering �r klar'
    qbf-lang[24] = 'Sparar formul�rinformation i fr�geformul�r cache...'
    qbf-lang[25] = 'Du har �ndrat minst ett fr�geformul�r.  Du kan '
                 + 'antingen kompilera det �ndrade formul�ret nu, el senare '
                 + 'g�ra en "�teruppbygga applikation ".  Kompilera nu?'
    qbf-lang[26] = 'Fr�geformul�r "~{1~}" saknas.  Vill du generera '
                 + 'ett s�dant?'
    qbf-lang[27] = 'Ett fr�geformul�r "~{1~}" finns.  Anv�nd f�lt fr�n '
                 + 'detta formul�r?'
    qbf-lang[28] = 'S�kert att du vill ta bort fr�geformul�r'
    qbf-lang[29] = '** Fr�geprogram "~{1~}" borttaget**'
    qbf-lang[30] = 'Skriver fr�geformul�r...'
    qbf-lang[31] = 'Maxantal av fr�geformul�r har n�tts.'
    qbf-lang[32] = 'Kan ej bygga fr�geformul�r f�r denna fil.^^F�r att '
                 + 'bygga ett fr�geformul�r, m�ste antingen gateway st�dja '
                 + 'RECIDs el ocks� m�ste filen ha ett unikt index.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-print.p */
IF qbf-s = 10 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' A. Addera ny utdataenhet '
    qbf-lang[ 2] = ' C. V�lj enhet att editera '
    qbf-lang[ 3] = ' G. Generella enhetsegenskaper '
    qbf-lang[ 4] = ' S. Styrsekvenser  '
    qbf-lang[ 5] = ' P. Skrivare beh�righeter '
    qbf-lang[ 6] = ' D. Tag bort aktuell enhet '
    qbf-lang[ 7] = ' V�lj: ' /* format x(10) */
    qbf-lang[ 8] = ' Uppdat: ' /* format x(10) */
    qbf-lang[ 9] = 'M�ste ligga i intervallet 1 till 255'
    qbf-lang[10] = 'Typ m�ste vara term, thru, to, view, file, page el prog'
    qbf-lang[11] = 'Maxantal utdata enheter har n�tts.'
    qbf-lang[12] = 'Endast enhetstyp "term" kan styra utdata till TERMINAL.'
    qbf-lang[13] = 'Kunde ej hitta detta program med aktuell PROPATH.'
                  /*17 thru 20 must be format x(16) and right-justified */
    qbf-lang[17] = 'Beskr f�r listn.'
    qbf-lang[18] = '      Enhetsnamn'
    qbf-lang[19] = '        Maxbredd'
    qbf-lang[20] = '             Typ'
    qbf-lang[21] = 'se nedan'
    qbf-lang[22] = 'TERMINAL, som i OUTPUT TO TERMINAL PAGED'
    qbf-lang[23] = 'TO en enhet, s�som OUTPUT TO PRINTER'
    qbf-lang[24] = 'THROUGH en UNIX eller OS/2 spooler eller filter'
    qbf-lang[25] = 'S�nd rapporten till en fil, d�refter k�r detta program'
    qbf-lang[26] = 'Be anv�ndaren om ett filnamn f�r utdatadestinationen'
    qbf-lang[27] = 'Till sk�rm med f�reg-sida och n�sta-sida st�d'
    qbf-lang[28] = 'Kalla p� ett 4GL-program f�r att starta/stoppa utdatastr�m'
    qbf-lang[30] = 'Tryck [' + KBLABEL("END-ERROR") + '] n�r uppdatering klar'
    qbf-lang[31] = 'Det m�ste finnas minst en utdataenhet!'
    qbf-lang[32] = 'S�kert att du vill ta bort denna skrivare?'.

/*--------------------------------------------------------------------------*/

RETURN.
