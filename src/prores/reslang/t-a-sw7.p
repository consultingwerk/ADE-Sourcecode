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
/* t-a-swe.p - Swedish language definitions for Admin module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/*results.p,s-module.p*/
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'F. FrÜgor'
    qbf-lang[ 2] = 'R. Rapporter'
    qbf-lang[ 3] = 'E. Etiketter'
    qbf-lang[ 4] = 'D. Dataexport'
    qbf-lang[ 5] = 'K. Egen applikation'
    qbf-lang[ 6] = 'A. Administration'
    qbf-lang[ 7] = 'S. Slut'
    qbf-lang[ 8] = 'F. FAST TRACK'
    qbf-lang[10] = 'Filen' /*DBNAME.qc*/
    qbf-lang[11] = 'saknas. Det innebÑr att du mÜste gîra en "Initial'
                 + ' Uppbyggnad" pÜ denna databas. Vill du gîra det nu?'
    qbf-lang[12] = 'VÑlj ny modul eller tryck [' + KBLABEL("END-ERROR")
                 + '] fîr att stanna i denna modul.'
    qbf-lang[13] = 'Du har inte kîpt RESULTS. Program avslutat.'
    qbf-lang[14] = 'Vill du verkligen avsluta "~{1~}" nu?'
    qbf-lang[15] = 'MANUAL,SEMI,AUTO'
    qbf-lang[16] = 'Ingen databas ansluten.'
    qbf-lang[17] = 'Kan ej exekvera nÑr en databas har ett logiskt namn '
                 + 'som bîrjar med "QBF$".'
    qbf-lang[18] = 'Avbryt'
    qbf-lang[19] = '** RESULTS konfunderad **^^I  ~{1~} katalogen kan '
                 + 'varken ~{2~}.db eller ~{2~}.qc hittas.  ~{3~}.qc '
                 + 'finns i PROPATH, men den tycks tillhîra '
                 + '~{3~}.db. RÑtta till din PROPATH eller dîp om/tabort '
                 + '~{3~}.db och .qc.'
    /* 24,26,30,32 available if necessary */
    qbf-lang[21] = '         Det finns tre sÑtt att skapa frÜgeformulÑr fîr '
                 + 'PROGRESS'
    qbf-lang[22] = '         RESULTS.  NÑr som helst efter RESULTS skapat '
                 + 'frÜgeformulÑren,'
    qbf-lang[23] = '         kan du manuellt fîrÑndra dem.'
    qbf-lang[25] = 'Du vill manuellt definiera varje frÜgeformulÑr.'
    qbf-lang[27] = 'Sedan du valt en delmÑngd av filer frÜn de anslutna'
    qbf-lang[28] = 'databaserna, genererar RESULTS frÜgeformulÑr endast fîr'
    qbf-lang[29] = 'dessa filer.'
    qbf-lang[31] = 'RESULTS genererar alla frÜgeformulÑr automatiskt.'.


/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-user.p*/
IF qbf-s = 2 THEN
  /* format x(72) for 1,2,9-14,19-22 */
  ASSIGN
    qbf-lang[ 1] = 'Ange namnet pÜ den include fil som skall anvÑndas fîr'
    qbf-lang[ 2] = 'BlÑddringsvalet i FrÜgemodulen.'
    qbf-lang[ 3] = '   Default Include Fil:' /*format x(24)*/

    qbf-lang[ 8] = 'Hittar ej program'

    qbf-lang[ 9] = 'Ange namnet pÜ logga-pÜ-programmet.  Detta program kan '
                 + 'antingen vara'
    qbf-lang[10] = 'en enkel bild, eller en komplett loginprocedur liknande '
                 + '"login.p"'
    qbf-lang[11] = 'i "DLC" biblioteket.  Detta program exekveras sÜ snart '
                 + 'som'
    qbf-lang[12] = '"signon=" raden lÑses frÜn DBNAME.qc filen.'
    qbf-lang[13] = 'Ange namnet pÜ produkten sÜ som du vill visa den'
    qbf-lang[14] = 'pÜ Huvudmenyn.'
    qbf-lang[15] = '       Logga-pÜ program:' /*format x(24)*/
    qbf-lang[16] = '            Produktnamn:' /*format x(24)*/
    qbf-lang[17] = 'Default:'

    qbf-lang[18] = 'PROGRESS Egen procedur:'
    qbf-lang[19] = 'Denna procedur kîrs nÑr "Egen" alternativet har valts '
                 + 'frÜn nÜgon meny.'

    qbf-lang[20] = 'Dataexportprogram tillverkat av anvÑndaren.'
    qbf-lang[21] = 'Ange bÜde procedurnamnet och beskrivningen'
    qbf-lang[22] = 'fîr "Data Export - InstÑllning" menyn.'
    qbf-lang[23] = 'Procedur:'
    qbf-lang[24] = 'Beskrivning:'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-load.p:*/
IF qbf-s = 3 THEN
  ASSIGN
    /* menu strip for d-main.p,l-main.p,r-main.p */
    qbf-lang[ 1] = 'HÑmta,Ladda en tidigare definierad ~{1~}.'
    qbf-lang[ 2] = 'Lagra,Spara aktuell ~{1~}.'
    qbf-lang[ 3] = 'Kîr,Kîr aktuell ~{1~}.'
    qbf-lang[ 4] = 'Def,VÑlj tabeller och fÑlt.'
    qbf-lang[ 5] = 'StÑlla in,éndra typ, format el layout av aktuell ~{1~}.'
    qbf-lang[ 6] = 'Urval,WHERE-sats-editor fîr urval av poster.'
    qbf-lang[ 7] = 'Ordning,éndrar utdata ordning av poster.'
    qbf-lang[ 8] = 'Rensa,Suddar ut nu definierad ~{1~}.'
    qbf-lang[ 9] = 'Info,Information om aktuell instÑllning.'
    qbf-lang[10] = 'Modul,ôvergÜng till annan modul.'
    qbf-lang[11] = 'Egen,ôvergÜng till av kund vald funktion.'
    qbf-lang[12] = 'Avsluta,Avslut.'
    qbf-lang[13] = '' /* terminator */
    qbf-lang[14] = 'export,etikett,rapport'

    qbf-lang[15] = 'LÑser konfigurationsfil...'

    /* system values for CONTINUE Must be <= 12 characters */
    qbf-lang[18] = '  FortsÑtt' /* for error dialog box */
    qbf-lang[19] = 'Svensk' /* this name of this language */
    /* word "of" for "xxx of yyy" on scrolling lists */
    qbf-lang[20] = 'av'
    /* standard product name */
    qbf-lang[22] = 'PROGRESS RESULTS'
    /* system values for descriptions of calc fields */
    qbf-lang[23] = ',Kummulativ total,Procent av total,Antal,StrÑnguttr,'
                 + 'Datumuttr,Numeriskt uttr,Logiskt uttr,Stacked Array'
    /* system values for YES and NO.  Must be <= 8 characters each */
    qbf-lang[24] = '  Ja  ,  Nej  ' /* for yes/no dialog box */

    qbf-lang[25] = 'En pÜgÜende automatisk generering av appl. avbrîts.  '
                 + 'FortsÑtt med automatisk generering?'

    qbf-lang[26] = '* VARNING - Versionsblandning *^^Aktuell version Ñr '
                 + '<~{1~}> medan .qc fil Ñr fîr version <~{2~}>.  Problem '
                 + 'kan uppstÜ innan FrÜgeformulÑr Üter genererats m.h.a. '
                 + '"èteruppbyggnad av applikation".'

    qbf-lang[27] = '* VARNING - Databaser saknas *^^Fîljande '
                 + 'databas(er) behîvs men Ñr ej anslutna:'

    qbf-lang[32] = '* VARNING - Schema Ñndrat *^^Databasstruktur har '
                 + 'Ñndrats efter uppbyggnad av nÜgra frÜgeformulÑr.  '
                 + 'AnvÑnd "èteruppbyggnad av applikation" frÜn Administration '
                 + 'meny snarast mîjligt.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-main.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = " A. èteruppbyggnad av applikation"
    qbf-lang[ 2] = " F. Definitioner FrÜgeformulÑr"
    qbf-lang[ 3] = " R. Relationer mellan tabeller"

    qbf-lang[ 4] = " C. InnehÜll av anvÑndarbibliotek"
    qbf-lang[ 5] = " H. Hur avsluta applikation"
    qbf-lang[ 6] = " M. Modul behîrighet"
    qbf-lang[ 7] = " Q. FrÜgeformulÑr behîrighet"
    qbf-lang[ 8] = " S. Logga-pÜ program/produktnamn"

    qbf-lang[11] = " G. SprÜk"
    qbf-lang[12] = " P. SkrivareinstÑllning"
    qbf-lang[13] = " T. Terminal fÑrginstÑllning"

    qbf-lang[14] = " B. BlÑddr.program FrÜgeformulÑr"
    qbf-lang[15] = " D. Normal rapportinstÑllning"
    qbf-lang[16] = " E. AnvÑndardef. exportformat"
    qbf-lang[17] = " L. Val av etikettfÑlt"
    qbf-lang[18] = " U. Egna alternativ"

    qbf-lang[21] = 'Gîr ett val eller tryck [' + KBLABEL("END-ERROR")
                 + '] fîr avslut och spara Ñndringar.'
    /* these next four have a length limit of 20 including colon */
    qbf-lang[22] = 'Tabeller:'
    qbf-lang[23] = 'Konfiguration:'
    qbf-lang[24] = 'SÑkerhet:'
    qbf-lang[25] = 'Moduler:'

    qbf-lang[26] = 'Administration'
    qbf-lang[27] = 'Version'
    qbf-lang[28] = 'Laddar administrationsdata frÜn '
                 + 'konfigurationsfilen.'
    qbf-lang[29] = 'SÑkert att du vill Üteruppbygga applikationen?'
/* QUIT and RETURN are the PROGRESS keywords and cannot be translated */
    qbf-lang[30] = 'NÑr anvÑndaren lÑmnar huvudmenyn, skall programmet dÜ '
                 + 'lÑmna PROGRESS(QUIT) eller RESULTS(RETURN) ?'
    qbf-lang[31] = 'SÑkert att du nu vill lÑmna administrations'
                 + 'menyn?'
    qbf-lang[32] = 'Verifierar konfigurationsfilsstrukturen och sparar ev. '
                 + 'Ñndringar.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 5 THEN
  ASSIGN
/*a-perm.p, 1..7 also used by a-form.p and a-print.p*/
    qbf-lang[ 1] = 'Behîrighet'
    qbf-lang[ 2] = '    *                   - Alla anvÑndare har access.'
    qbf-lang[ 3] = '    <user>,<user>,etc.  - Endast angivna anv har access'
    qbf-lang[ 4] = '    !<user>,!<user>,*   - Alla utom dessa anv har '
                 + 'access.'
    qbf-lang[ 5] = '    acct*               - Endast anv som bîrjar med '
                 + '"acct" tillÜts'
    qbf-lang[ 6] = 'Lista anv per loginid, och separera dem med '
                 + 'kommatecken.'
    qbf-lang[ 7] = 'Id kan innehÜlla wildcards.  Anv utropstecken fîr att '
                 + 'utesluta anv.'
                   /* from 8 thru 13, format x(30) */
    qbf-lang[ 8] = 'VÑlj en modul frÜn'
    qbf-lang[ 9] = 'listan till vÑnster'
    qbf-lang[10] = 'sÑtt behîrighet fîr.'
    qbf-lang[11] = 'VÑlj en funktion frÜn'
    qbf-lang[12] = 'listan till vÑnster'
    qbf-lang[13] = 'sÑtt behîrighet fîr.'
    qbf-lang[14] = 'Tryck [' + KBLABEL("END-ERROR")
                 + '] nÑr Ñndring Ñr klar.'
    qbf-lang[15] = 'Tryck [' + KBLABEL("GO") + '] fîr att spara, ['
                 + KBLABEL("END-ERROR") + '] fîr att Üngra.'
    qbf-lang[16] = 'Du kan ej utesluta dig sjÑlv frÜn Administration!'
/*a-print.p:*/     /*21 thru 26 must be format x(16) and right-justified */
    qbf-lang[21] = '      Initiering'
    qbf-lang[22] = '                '
    qbf-lang[23] = '    Normalskrift'
    qbf-lang[24] = '       Hopdragen'
    qbf-lang[25] = '     Fet stil Pè'
    qbf-lang[26] = '     Fet stil AV'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 6 THEN
  ASSIGN
/*a-write.p:*/
    qbf-lang[ 1] = 'Laddar modulinstÑllningar'
    qbf-lang[ 2] = 'Laddar fÑrginstÑllningar'
    qbf-lang[ 3] = 'Laddar skrivareinstÑllning'
    qbf-lang[ 4] = 'Laddar lista av visningsbara filer'
    qbf-lang[ 5] = 'Laddar lista av relationer'
    qbf-lang[ 6] = 'Laddar auto-val fÑltlista fîr postetiketter'
    qbf-lang[ 7] = 'Laddar behîrighetslista fîr frÜgefunktioner'
    qbf-lang[ 8] = 'Laddar anv.funktion information'
    qbf-lang[ 9] = 'Laddar systemrapport standards'

/* a-color.p*/
                 /* 12345678901234567890123456789012 */
    qbf-lang[11] = '  FÑrger fîr vilken terminaltyp:' /* must be 32 */
                 /* 1234567890123456789012345 */
    qbf-lang[12] = 'Meny:             Normal:' /* must be 25 */
    qbf-lang[13] = '                 Upplyst:'
    qbf-lang[14] = 'Dialogbox:        Normal:'
    qbf-lang[15] = '                 Upplyst:'
    qbf-lang[16] = 'BlÑddr-lista:     Normal:'
    qbf-lang[17] = '                 Upplyst:'

/*a-field.p*/    /*"----- ----- ----- ----- ----"*/
    qbf-lang[30] = 'Visa? Uppd? FrÜga?BlÑddr? Seq'
    qbf-lang[31] = 'MÜste ligga i intervallet 1 till 9999.'
    qbf-lang[32] = 'Vill du spara just gjorda Ñndringar i '
                 + 'fÑltlistan?'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 8 THEN
/*a-label.p*/
  ASSIGN            /* 1..8 use format x(78) */
                    /* 1 and 8 are available for more explanation, in */
                    /*   case the translation won't fit in 2 thru 7.  */
    qbf-lang[ 2] = 'Ange fÑltnamnen som innehÜller adressinformation.  '
                 + 'AnvÑnd CAN-DO'
    qbf-lang[ 3] = 'typlistor fîr att matcha dessa fÑlt-namn ("*" matchar '
                 + 'godtyckligt antal'
    qbf-lang[ 4] = 'tecken, "." matchar ett tecken).  Denna '
                 + 'information anvÑnds'
    qbf-lang[ 5] = 'fîr att skapa standardetiketter.  Obs att nÜgra '
                 + 'indata kan vara'
    qbf-lang[ 6] = 'îverflîdiga - t.ex, om du alltid lagrar stad '
                 + 'och postnr i'
    qbf-lang[ 7] = 'separata fÑlt, behîver du ej anvÑnda "Pnr-S" raden.'
                  /* each entry in list must be <= 5 characters long */
                  /* but may be any portion of address that is applicable */
                  /* in the target country */
 /*   qbf-lang[ 9] = 'Namn,Adr1,Adr2,Adr3,Stad,Stat,P-nr,Pnr+4,S-P,Land' */
    qbf-lang[ 9] = 'Namn,Adr1,Adr2,Adr3,pnr-S,pnr,Stad,Land,Ex-1,Ex-2'
    qbf-lang[10] = 'FÑlt som innehÜller <namn>'
    qbf-lang[11] = 'FÑlt som innehÜller <fîrsta> adressrad (t.e. gata)'
    qbf-lang[12] = 'FÑlt som innehÜller <andra> adressrad (t.e.  Box)'
    qbf-lang[13] = 'FÑlt som innehÜller <tredje> adressrad (ev.)'
    qbf-lang[14] = 'FÑlt som innehÜller <kombination av pnr-stad>'
    qbf-lang[15] = 'FÑlt som innehÜller <pnr>'
    qbf-lang[16] = 'FÑlt som innehÜller namn pÜ <stad>'
    qbf-lang[17] = 'FÑlt som innehÜller namn pÜ <land>'
    qbf-lang[18] = 'AnvÑnds inte'
    qbf-lang[19] = 'AnvÑnds inte'

/*a-join.p*/
    qbf-lang[23] = 'Hittills Ñr self-joins ej tillÜtna.'
    qbf-lang[24] = 'Maxantal av  relationer har uppnÜtts.'
    qbf-lang[25] = 'Relation av' /* 25 and 26 are automatically */
    qbf-lang[26] = 'till'          /*   right-justified           */
    qbf-lang[27] = 'Ange WHERE el OF sats: (lÑmna blank = borttag av relation)'
    qbf-lang[28] = 'Tryck [' + KBLABEL("END-ERROR") + '] nÑr uppdat Ñr klar.'
    qbf-lang[30] = 'Kommando mÜste bîrja med WHERE el OF.'
    qbf-lang[31] = 'Ange fîrsta fil i relation att addera el ta bort.'
    qbf-lang[32] = 'Och nu andra filen i relationen.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-form.p */
IF qbf-s = 9 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' A. Addera nytt frÜgeformulÑr '
    qbf-lang[ 2] = ' C. VÑlj frÜgeformulÑr att editera '
    qbf-lang[ 3] = ' G. Generella formulÑregenskaper '
    qbf-lang[ 4] = ' W. Vilka fÑlt i formulÑr '
    qbf-lang[ 5] = ' P. Behîrigheter '
    qbf-lang[ 6] = ' D. Tag bort aktuellt frÜgeformulÑr '
    qbf-lang[ 7] = ' VÑlj: ' /* format x(10) */
    qbf-lang[ 8] = ' Uppdat: ' /* format x(10) */
                 /* cannot changed width of 9..16 from defined below */
    qbf-lang[ 9] = '     Databas tabellnamn' /* right-justify 9..14 */
    qbf-lang[10] = '            FormulÑrtyp'
    qbf-lang[11] = '   FrÜgeprogram filnamn'
    qbf-lang[12] = '  FormulÑr fys. filnamn'
    qbf-lang[13] = '   Ram namn fîr 4GL-kod'
    qbf-lang[14] = '            Beskrivning'
    qbf-lang[15] = '(.p antaget)     ' /* left-justify 15 and 16 */
    qbf-lang[16] = '(behîver filtillÑgg)'
    qbf-lang[18] = 'Detta formulÑr Ñr ~{1~} rader lÜng.  DÜ RESULTS reserverar '
                 + '5 rader fîr eget bruk, kommer skÑrmstorleken 24x80 att '
                 + 'îverskridas.  SÑkert att du vill definiera ett sÜ '
                 + 'hÑr stort formulÑr?'
    qbf-lang[19] = 'Ett frÜgeprogram med detta namn finns redan.'
    qbf-lang[20] = 'Detta formulÑr mÜste redan finnas, el mÜste sluta med .f  '
                 + 'fîr automatisk generering.'
    qbf-lang[21] = 'Namnet du valde fîr 4GL-formulÑret Ñr reserverat.  '
                 + 'VÑlj ett annat.'
    qbf-lang[22] = ' VÑlj Ütkomliga filer '
    qbf-lang[23] = 'Tryck [' + KBLABEL("END-ERROR") + '] nÑr updatering Ñr klar'
    qbf-lang[24] = 'Sparar formulÑrinformation i frÜgeformulÑr cache...'
    qbf-lang[25] = 'Du har Ñndrat minst ett frÜgeformulÑr.  Du kan '
                 + 'antingen kompilera det Ñndrade formulÑret nu, el senare '
                 + 'gîra en "èteruppbygga applikation ".  Kompilera nu?'
    qbf-lang[26] = 'FrÜgeformulÑr "~{1~}" saknas.  Vill du generera '
                 + 'ett sÜdant?'
    qbf-lang[27] = 'Ett frÜgeformulÑr "~{1~}" finns.  AnvÑnd fÑlt frÜn '
                 + 'detta formulÑr?'
    qbf-lang[28] = 'SÑkert att du vill ta bort frÜgeformulÑr'
    qbf-lang[29] = '** FrÜgeprogram "~{1~}" borttaget**'
    qbf-lang[30] = 'Skriver frÜgeformulÑr...'
    qbf-lang[31] = 'Maxantal av frÜgeformulÑr har nÜtts.'
    qbf-lang[32] = 'Kan ej bygga frÜgeformulÑr fîr denna fil.^^Fîr att '
                 + 'bygga ett frÜgeformulÑr, mÜste antingen gateway stîdja '
                 + 'RECIDs el ocksÜ mÜste filen ha ett unikt index.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-print.p */
IF qbf-s = 10 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' A. Addera ny utdataenhet '
    qbf-lang[ 2] = ' C. VÑlj enhet att editera '
    qbf-lang[ 3] = ' G. Generella enhetsegenskaper '
    qbf-lang[ 4] = ' S. Styrsekvenser  '
    qbf-lang[ 5] = ' P. Skrivare behîrigheter '
    qbf-lang[ 6] = ' D. Tag bort aktuell enhet '
    qbf-lang[ 7] = ' VÑlj: ' /* format x(10) */
    qbf-lang[ 8] = ' Uppdat: ' /* format x(10) */
    qbf-lang[ 9] = 'MÜste ligga i intervallet 1 till 255'
    qbf-lang[10] = 'Typ mÜste vara term, thru, to, view, file, page el prog'
    qbf-lang[11] = 'Maxantal utdata enheter har nÜtts.'
    qbf-lang[12] = 'Endast enhetstyp "term" kan styra utdata till TERMINAL.'
    qbf-lang[13] = 'Kunde ej hitta detta program med aktuell PROPATH.'
                  /*17 thru 20 must be format x(16) and right-justified */
    qbf-lang[17] = 'Beskr fîr listn.'
    qbf-lang[18] = '      Enhetsnamn'
    qbf-lang[19] = '        Maxbredd'
    qbf-lang[20] = '             Typ'
    qbf-lang[21] = 'se nedan'
    qbf-lang[22] = 'TERMINAL, som i OUTPUT TO TERMINAL PAGED'
    qbf-lang[23] = 'TO en enhet, sÜsom OUTPUT TO PRINTER'
    qbf-lang[24] = 'THROUGH en UNIX eller OS/2 spooler eller filter'
    qbf-lang[25] = 'SÑnd rapporten till en fil, dÑrefter kîr detta program'
    qbf-lang[26] = 'Be anvÑndaren om ett filnamn fîr utdatadestinationen'
    qbf-lang[27] = 'Till skÑrm med fîreg-sida och nÑsta-sida stîd'
    qbf-lang[28] = 'Kalla pÜ ett 4GL-program fîr att starta/stoppa utdatastrîm'
    qbf-lang[30] = 'Tryck [' + KBLABEL("END-ERROR") + '] nÑr uppdatering klar'
    qbf-lang[31] = 'Det mÜste finnas minst en utdataenhet!'
    qbf-lang[32] = 'SÑkert att du vill ta bort denna skrivare?'.

/*--------------------------------------------------------------------------*/

RETURN.
