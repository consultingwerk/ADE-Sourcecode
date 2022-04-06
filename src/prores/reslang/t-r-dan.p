/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-r-dan.p - Danish language definitions for Reports module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
/*r-header.p*/
    qbf-lang[ 1] = 'Indtast udtryk for'
    qbf-lang[ 2] = 'Linie' /* skal v�re < 8 characters */
		   /* 3..7 are format x(64) */
    qbf-lang[ 3] = 'Disse funktioner er tilg�ngelig for brug i top og '
		 + 'bund tekst'
    qbf-lang[ 4] = '~{COUNT~}  Record t�ller          :  '
		 + '~{TIME~}  Tid for rapport start'
    qbf-lang[ 5] = '~{TODAY~}  Dags dato              :  '
		 + '~{NOW~}   Aktuel tid'
    qbf-lang[ 6] = '~{PAGE~}   Aktuelt side nummer    :  '
		 + '~{User~}  Bruger navn'
    qbf-lang[ 7] = '~{VALUE <udtryk>~;<format>~} variabel inds�ttelse'
		 + ' (Tast [' + KBLABEL("GET") + '])'
    qbf-lang[ 8] = 'V�lg Felt'
    qbf-lang[ 9] = 'Tryk [' + KBLABEL("GO") + '] for gem, ['
		 + KBLABEL("GET") + '] for inds�t felt, ['
		 + KBLABEL("END-ERROR") + '] for fortryd.'

/*r-total.p*/    /*"|---------------------------|"*/
    qbf-lang[12] = 'Udf�r disse aktioner:'
		 /*"|--------------------------------------------|"*/
    qbf-lang[13] = 'N�r disse felter skifter v�rdi:'
		 /*"|---| |---| |---| |---| |---|" */
    qbf-lang[14] = 'Total Antal -Min- -Max- -Gns-'
    qbf-lang[15] = 'Summerings Linie'
    qbf-lang[16] = 'For felt:'
    qbf-lang[17] = 'V�lg Felt for Total'

/*r-calc.p*/
    qbf-lang[18] = 'Udv�lg felt for L�bende Total'
    qbf-lang[19] = 'Udv�lg felt for Procent af Total'
    qbf-lang[20] = 'L�bende Total'
    qbf-lang[21] = '% Total'
    qbf-lang[22] = 'Karakter,Dato,Logisk,Beregnet,Numerisk'
    qbf-lang[23] = 'v�rdi'
    qbf-lang[24] = 'Indtast start v�rdi for t�ller'
    qbf-lang[25] = 'Indtast opt�llings/nedt�llings v�rdi.'
    qbf-lang[26] = 'T�llere'
    qbf-lang[27] = 'T�ller'
		 /*"------------------------------|"*/
    qbf-lang[28] = '        Start nummer for t�ller' /*right justify*/
    qbf-lang[29] = '     For hver record, opt�l med' /*right justify*/
    qbf-lang[32] = 'Du har allerede defineret det maximale antal kolonner.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN
/* r-space.p */  /*"------------------------------|  ---------|  |------"*/
    qbf-lang[ 1] = '             Option                Aktuelle  Std.   '
    /* 2..8 skal v�re less than 32 characters long */
    qbf-lang[ 2] = 'Venstre margen'
    qbf-lang[ 3] = 'Mellemrum mellem kolonner'
    qbf-lang[ 4] = 'Start linie'
    qbf-lang[ 5] = 'Linier pr side'
    qbf-lang[ 6] = 'Linie afstand'
    qbf-lang[ 7] = 'Linier mellem top og rapport'
    qbf-lang[ 8] = 'Linier mellem rapport og bund'
		  /*1234567890123456789012345678901*/
    qbf-lang[ 9] = 'Afstand'
    qbf-lang[10] = 'Linie afstand skal v�re mellem een og side st�rrelsen'
    qbf-lang[11] = 'Negative side l�ngde ikke tilladt'
    qbf-lang[12] = 'Angiv kolonne 1 eller st�rre til rapport placeringen'
    qbf-lang[13] = 'Angiv en fornuftig v�rdi'
    qbf-lang[14] = 'Det �verste rapporten kan placeres er linie 1'

/*r-set.p*/        /* format x(30) for 15..22 */
    qbf-lang[15] = 'F.  Format og Label'
    qbf-lang[16] = 'S.  Side Skift'
    qbf-lang[17] = 'O.  Opsummerings Rapport'
    qbf-lang[18] = 'A.  Afstand'
    qbf-lang[19] = 'VT. Venstre Top'
    qbf-lang[20] = 'CT. Center  Top'
    qbf-lang[21] = 'HT. H�jre   Top'
    qbf-lang[22] = 'VB. Venstre Bund'
    qbf-lang[23] = 'CB. Center  Bund'
    qbf-lang[24] = 'HB. H�jre   Bund'
    qbf-lang[25] = 'FS. F�rste-side Top'
    qbf-lang[26] = 'SS. Sidste-side  Bund'
    qbf-lang[32] = 'Tryk [' + KBLABEL("END-ERROR")
		 + '] n�r �ndringer er udf�rt.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
    /* r-main.p,s-page.p */
    qbf-lang[ 1] = 'Filer:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Sort.:'
    qbf-lang[ 3] = 'Rapport Info'
    qbf-lang[ 4] = 'Rapport Layout'
    qbf-lang[ 5] = 'mere' /* for <<more og more>> */
    qbf-lang[ 6] = 'Rapport,Bredde' /* each word comma-separated */
    qbf-lang[ 7] = 'Benyt < og > for at flytte rapporten til venstre og h�jre'
    qbf-lang[ 8] = 'Det er ikke muligt at genererer rapport med en brede p� mere end '
		 + '255 karaktere'
    qbf-lang[ 9] = 'Du slettede ikke den aktuelle rapport.  �nsker du stadig '
		 + 'at forts�tte?'
    qbf-lang[10] = 'Genererer program...'
    qbf-lang[11] = 'Kompilerer generered program...'
    qbf-lang[12] = 'Afvikler det genererede program...'
    qbf-lang[13] = 'Kan ikke skrive til fil eller enhed'
    qbf-lang[14] = 'Er du sikker p� du �nsker at slette den aktuelle rapport '
		 + 'definition?'
    qbf-lang[15] = 'Er du sikker p� du �nsker at afslutte dette modul?'
    qbf-lang[16] = 'Tryk ['
		 + (IF KBLABEL("CURSOR-UP") BEGINS "CTRL-" THEN 'CURSOR-UP'
		   ELSE KBLABEL("CURSOR-UP"))
		 + '] og ['
		 + (IF KBLABEL("CURSOR-DOWN") BEGINS "CTRL-" THEN 'CURSOR-DOWN'
		   ELSE KBLABEL("CURSOR-DOWN"))
		 + '] for navigering, ['
		 + KBLABEL("END-ERROR") + '] n�r udf�rt.'
    qbf-lang[17] = 'Side'
    qbf-lang[18] = '~{1~} record indeholdt i rapporten.'
    qbf-lang[19] = 'Det er ikke muligt at generere en opsummerings rapport uden '
		 + 'definition af sorterings felter.'
    qbf-lang[20] = 'Det er ikke muligt at generere en opsummerings rapport'
		 + ' indeholdende stakkede-array felter.'
    qbf-lang[21] = 'Totaler alene'
    qbf-lang[23] = 'Det er ikke muligt at genererer en rapport uden definition af  felter.'.

ELSE

/*--------------------------------------------------------------------------*/
/* FAST TRACK interface test for r-ft.p r-ftsub.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = 'FAST TRACK supporterer ikke udskrift til terminal n�r der'
    qbf-lang[ 2] = 'sp�rges efter udv�lgelses data.  Udskrift sendes til PRINTER.'
    qbf-lang[ 3] = 'Analyserer top og bund tekster...'
    qbf-lang[ 4] = 'Opretter sorterings-grupper...'
    qbf-lang[ 5] = 'Opretter felter og samment�llinger...'
    qbf-lang[ 6] = 'Opretter filer og udv�lgelses betingelser...'
    qbf-lang[ 7] = 'Opretter top og bund tekster...'
    qbf-lang[ 8] = 'Opretter rapport-linier...'
    qbf-lang[ 9] = 'Der er allerede en rapport med navnet ~{1~} i FAST TRACK.  '
		 + '�nsker du at overskrive den?'
    qbf-lang[10] = 'Overskriver rapport...'
    qbf-lang[11] = '�nsker du at starte FAST TRACK?'
    qbf-lang[12] = 'Indtast et navn'
    qbf-lang[13] = 'FAST TRACK supporterer ikke TIME i top/bund, '
		 + 'erstattes af NOW.'
    qbf-lang[14] = 'FAST TRACK supporteret ikke procent af total, felt ignoreret'
    qbf-lang[15] = 'FAST TRACK supporterer ikke ~{1~} i top/bund, '
		 + '~{2~} ignoreret.'
    qbf-lang[16] = 'Rapport navn kan kun inkludere alfabetiske karakterer '
		 + 'eller under-streg.'
    qbf-lang[17] = 'Rapport navn i FAST TRACK:'
    qbf-lang[18] = 'Rapport IKKE overf�rt til FAST TRACK'
    qbf-lang[19] = 'Starter FAST TRACK, vent...'
    qbf-lang[20] = 'Problemer med kr�lle parrenteser i top/bund, '
		 + 'rapport IKKE overf�rt.'
    qbf-lang[21] = 'FAST TRACK supporterer ikke f�rste-side/sidste-side tekst.'
		 + '  Ignoreret.'
    qbf-lang[22] = 'Advarsel: Start v�rdi ~{1~} brugt til t�ller.'
    qbf-lang[23] = 'INDEHOLDER'
    qbf-lang[24] = 'TOTAL,ANTAL,MAX,MIN,GNS'
    qbf-lang[25] = 'FAST TRACK supporterer ikke opsummerings rapporter.  '
		 + 'Rapport kunne ikke overf�res.'
    qbf-lang[26] = 'Kan ikke overf�re en rapport til FAST TRACK n�r hverken filer eller '
		 + 'felter er defineret.'.


ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 5 THEN
  ASSIGN
    /* r-short.p */
    qbf-lang[ 1] = 'Definition af opsummerings rapport "kollapser" rapporten '
		 + 'til kun at vise summerings information.  Baseret p� det '
		 + 'sidste felt i din sorterings liste, en ny linie '
		 + 'vil komme hver gang sorterings feltet skifter v�rdi. '
		 + '^For denne rapport, vil en ny linie komme  hver '
		 + 'gang ~{1~} feltet skifter v�rdi.^Skal denne rapport laves '
		 + 'til en opsummerings rapport?'
    qbf-lang[ 2] = 'OPSUMMER'
    qbf-lang[ 3] = 'NORMAL'
    qbf-lang[ 4] = 'Du kan ikke benytte "Opsummerings" funktionen f�r '
		 + 'du v�lger felter for sorting af din rapport.^^'
		 + 'Udv�lg disse sorterings felter benyttende "Sorter" '
		 + 'funktionen fra menuen.'
    qbf-lang[ 5] = 'Denne liste viser de felter du har '
		 + 'defineret i'
    qbf-lang[ 6] = 'denne rapport.  De med stjerne markerede vil blive '
		 + 'summeret.'
    qbf-lang[ 7] = 'Hvis du udv�lger et numerisk felt til summering, vil en '
		 + 'subtotal vises hver gang feltet ~{1~} '
		 + '�ndrer v�rdi.'
    qbf-lang[ 8] = 'Hvis du udv�lg et ikke numerisk felt, vil der antallet af '
		 + 'record i hver ~{1~} gruppe vises.'
    qbf-lang[ 9] = 'Hvis du ikke v�lger et felt til summering, vil v�rdien '
		 + 'indeholdt i den sidste record i gruppen vises.'

    /* r-page.p */
    qbf-lang[26] = 'Side Skift'
    qbf-lang[27] = "Udelad side skift"

    qbf-lang[28] = 'N�r en v�rdi i et af f�lgende'
    qbf-lang[29] = 'felter �ndres, kan rapporten'
    qbf-lang[30] = 'automatisk g� til en ny side.'
    qbf-lang[31] = 'V�lg feltet fra listen nedenfor'
    qbf-lang[32] = 'hvor du �nsker at dette skal ske.'.

/*--------------------------------------------------------------------------*/

RETURN.
