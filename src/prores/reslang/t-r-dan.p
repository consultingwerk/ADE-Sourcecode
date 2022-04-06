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
    qbf-lang[ 2] = 'Linie' /* skal vëre < 8 characters */
		   /* 3..7 are format x(64) */
    qbf-lang[ 3] = 'Disse funktioner er tilgëngelig for brug i top og '
		 + 'bund tekst'
    qbf-lang[ 4] = '~{COUNT~}  Record tëller          :  '
		 + '~{TIME~}  Tid for rapport start'
    qbf-lang[ 5] = '~{TODAY~}  Dags dato              :  '
		 + '~{NOW~}   Aktuel tid'
    qbf-lang[ 6] = '~{PAGE~}   Aktuelt side nummer    :  '
		 + '~{User~}  Bruger navn'
    qbf-lang[ 7] = '~{VALUE <udtryk>~;<format>~} variabel indsëttelse'
		 + ' (Tast [' + KBLABEL("GET") + '])'
    qbf-lang[ 8] = 'Vëlg Felt'
    qbf-lang[ 9] = 'Tryk [' + KBLABEL("GO") + '] for gem, ['
		 + KBLABEL("GET") + '] for indsët felt, ['
		 + KBLABEL("END-ERROR") + '] for fortryd.'

/*r-total.p*/    /*"|---------------------------|"*/
    qbf-lang[12] = 'Udfõr disse aktioner:'
		 /*"|--------------------------------------------|"*/
    qbf-lang[13] = 'NÜr disse felter skifter vërdi:'
		 /*"|---| |---| |---| |---| |---|" */
    qbf-lang[14] = 'Total Antal -Min- -Max- -Gns-'
    qbf-lang[15] = 'Summerings Linie'
    qbf-lang[16] = 'For felt:'
    qbf-lang[17] = 'Vëlg Felt for Total'

/*r-calc.p*/
    qbf-lang[18] = 'Udvëlg felt for Lõbende Total'
    qbf-lang[19] = 'Udvëlg felt for Procent af Total'
    qbf-lang[20] = 'Lõbende Total'
    qbf-lang[21] = '% Total'
    qbf-lang[22] = 'Karakter,Dato,Logisk,Beregnet,Numerisk'
    qbf-lang[23] = 'vërdi'
    qbf-lang[24] = 'Indtast start vërdi for tëller'
    qbf-lang[25] = 'Indtast optëllings/nedtëllings vërdi.'
    qbf-lang[26] = 'Tëllere'
    qbf-lang[27] = 'Tëller'
		 /*"------------------------------|"*/
    qbf-lang[28] = '        Start nummer for tëller' /*right justify*/
    qbf-lang[29] = '     For hver record, optël med' /*right justify*/
    qbf-lang[32] = 'Du har allerede defineret det maximale antal kolonner.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN
/* r-space.p */  /*"------------------------------|  ---------|  |------"*/
    qbf-lang[ 1] = '             Option                Aktuelle  Std.   '
    /* 2..8 skal vëre less than 32 characters long */
    qbf-lang[ 2] = 'Venstre margen'
    qbf-lang[ 3] = 'Mellemrum mellem kolonner'
    qbf-lang[ 4] = 'Start linie'
    qbf-lang[ 5] = 'Linier pr side'
    qbf-lang[ 6] = 'Linie afstand'
    qbf-lang[ 7] = 'Linier mellem top og rapport'
    qbf-lang[ 8] = 'Linier mellem rapport og bund'
		  /*1234567890123456789012345678901*/
    qbf-lang[ 9] = 'Afstand'
    qbf-lang[10] = 'Linie afstand skal vëre mellem een og side stõrrelsen'
    qbf-lang[11] = 'Negative side lëngde ikke tilladt'
    qbf-lang[12] = 'Angiv kolonne 1 eller stõrre til rapport placeringen'
    qbf-lang[13] = 'Angiv en fornuftig vërdi'
    qbf-lang[14] = 'Det õverste rapporten kan placeres er linie 1'

/*r-set.p*/        /* format x(30) for 15..22 */
    qbf-lang[15] = 'F.  Format og Label'
    qbf-lang[16] = 'S.  Side Skift'
    qbf-lang[17] = 'O.  Opsummerings Rapport'
    qbf-lang[18] = 'A.  Afstand'
    qbf-lang[19] = 'VT. Venstre Top'
    qbf-lang[20] = 'CT. Center  Top'
    qbf-lang[21] = 'HT. Hõjre   Top'
    qbf-lang[22] = 'VB. Venstre Bund'
    qbf-lang[23] = 'CB. Center  Bund'
    qbf-lang[24] = 'HB. Hõjre   Bund'
    qbf-lang[25] = 'FS. Fõrste-side Top'
    qbf-lang[26] = 'SS. Sidste-side  Bund'
    qbf-lang[32] = 'Tryk [' + KBLABEL("END-ERROR")
		 + '] nÜr ëndringer er udfõrt.'.

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
    qbf-lang[ 7] = 'Benyt < og > for at flytte rapporten til venstre og hõjre'
    qbf-lang[ 8] = 'Det er ikke muligt at genererer rapport med en brede pÜ mere end '
		 + '255 karaktere'
    qbf-lang[ 9] = 'Du slettede ikke den aktuelle rapport.  ùnsker du stadig '
		 + 'at fortsëtte?'
    qbf-lang[10] = 'Genererer program...'
    qbf-lang[11] = 'Kompilerer generered program...'
    qbf-lang[12] = 'Afvikler det genererede program...'
    qbf-lang[13] = 'Kan ikke skrive til fil eller enhed'
    qbf-lang[14] = 'Er du sikker pÜ du õnsker at slette den aktuelle rapport '
		 + 'definition?'
    qbf-lang[15] = 'Er du sikker pÜ du õnsker at afslutte dette modul?'
    qbf-lang[16] = 'Tryk ['
		 + (IF KBLABEL("CURSOR-UP") BEGINS "CTRL-" THEN 'CURSOR-UP'
		   ELSE KBLABEL("CURSOR-UP"))
		 + '] og ['
		 + (IF KBLABEL("CURSOR-DOWN") BEGINS "CTRL-" THEN 'CURSOR-DOWN'
		   ELSE KBLABEL("CURSOR-DOWN"))
		 + '] for navigering, ['
		 + KBLABEL("END-ERROR") + '] nÜr udfõrt.'
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
    qbf-lang[ 1] = 'FAST TRACK supporterer ikke udskrift til terminal nÜr der'
    qbf-lang[ 2] = 'spõrges efter udvëlgelses data.  Udskrift sendes til PRINTER.'
    qbf-lang[ 3] = 'Analyserer top og bund tekster...'
    qbf-lang[ 4] = 'Opretter sorterings-grupper...'
    qbf-lang[ 5] = 'Opretter felter og sammentëllinger...'
    qbf-lang[ 6] = 'Opretter filer og udvëlgelses betingelser...'
    qbf-lang[ 7] = 'Opretter top og bund tekster...'
    qbf-lang[ 8] = 'Opretter rapport-linier...'
    qbf-lang[ 9] = 'Der er allerede en rapport med navnet ~{1~} i FAST TRACK.  '
		 + 'ùnsker du at overskrive den?'
    qbf-lang[10] = 'Overskriver rapport...'
    qbf-lang[11] = 'ùnsker du at starte FAST TRACK?'
    qbf-lang[12] = 'Indtast et navn'
    qbf-lang[13] = 'FAST TRACK supporterer ikke TIME i top/bund, '
		 + 'erstattes af NOW.'
    qbf-lang[14] = 'FAST TRACK supporteret ikke procent af total, felt ignoreret'
    qbf-lang[15] = 'FAST TRACK supporterer ikke ~{1~} i top/bund, '
		 + '~{2~} ignoreret.'
    qbf-lang[16] = 'Rapport navn kan kun inkludere alfabetiske karakterer '
		 + 'eller under-streg.'
    qbf-lang[17] = 'Rapport navn i FAST TRACK:'
    qbf-lang[18] = 'Rapport IKKE overfõrt til FAST TRACK'
    qbf-lang[19] = 'Starter FAST TRACK, vent...'
    qbf-lang[20] = 'Problemer med krõlle parrenteser i top/bund, '
		 + 'rapport IKKE overfõrt.'
    qbf-lang[21] = 'FAST TRACK supporterer ikke fõrste-side/sidste-side tekst.'
		 + '  Ignoreret.'
    qbf-lang[22] = 'Advarsel: Start vërdi ~{1~} brugt til tëller.'
    qbf-lang[23] = 'INDEHOLDER'
    qbf-lang[24] = 'TOTAL,ANTAL,MAX,MIN,GNS'
    qbf-lang[25] = 'FAST TRACK supporterer ikke opsummerings rapporter.  '
		 + 'Rapport kunne ikke overfõres.'
    qbf-lang[26] = 'Kan ikke overfõre en rapport til FAST TRACK nÜr hverken filer eller '
		 + 'felter er defineret.'.


ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 5 THEN
  ASSIGN
    /* r-short.p */
    qbf-lang[ 1] = 'Definition af opsummerings rapport "kollapser" rapporten '
		 + 'til kun at vise summerings information.  Baseret pÜ det '
		 + 'sidste felt i din sorterings liste, en ny linie '
		 + 'vil komme hver gang sorterings feltet skifter vërdi. '
		 + '^For denne rapport, vil en ny linie komme  hver '
		 + 'gang ~{1~} feltet skifter vërdi.^Skal denne rapport laves '
		 + 'til en opsummerings rapport?'
    qbf-lang[ 2] = 'OPSUMMER'
    qbf-lang[ 3] = 'NORMAL'
    qbf-lang[ 4] = 'Du kan ikke benytte "Opsummerings" funktionen fõr '
		 + 'du vëlger felter for sorting af din rapport.^^'
		 + 'Udvëlg disse sorterings felter benyttende "Sorter" '
		 + 'funktionen fra menuen.'
    qbf-lang[ 5] = 'Denne liste viser de felter du har '
		 + 'defineret i'
    qbf-lang[ 6] = 'denne rapport.  De med stjerne markerede vil blive '
		 + 'summeret.'
    qbf-lang[ 7] = 'Hvis du udvëlger et numerisk felt til summering, vil en '
		 + 'subtotal vises hver gang feltet ~{1~} '
		 + 'ëndrer vërdi.'
    qbf-lang[ 8] = 'Hvis du udvëlg et ikke numerisk felt, vil der antallet af '
		 + 'record i hver ~{1~} gruppe vises.'
    qbf-lang[ 9] = 'Hvis du ikke vëlger et felt til summering, vil vërdien '
		 + 'indeholdt i den sidste record i gruppen vises.'

    /* r-page.p */
    qbf-lang[26] = 'Side Skift'
    qbf-lang[27] = "Udelad side skift"

    qbf-lang[28] = 'NÜr en vërdi i et af fõlgende'
    qbf-lang[29] = 'felter ëndres, kan rapporten'
    qbf-lang[30] = 'automatisk gÜ til en ny side.'
    qbf-lang[31] = 'Vëlg feltet fra listen nedenfor'
    qbf-lang[32] = 'hvor du õnsker at dette skal ske.'.

/*--------------------------------------------------------------------------*/

RETURN.
