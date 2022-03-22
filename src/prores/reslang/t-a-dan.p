/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-a-dan.p - Danish language definitions for Admin module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/*results.p,s-module.p*/
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'F. Forespõrgsel'
    qbf-lang[ 2] = 'R. Rapporter'
    qbf-lang[ 3] = 'L. Labels'
    qbf-lang[ 4] = 'E. Exporter data'
    qbf-lang[ 5] = 'B. Bruger defineret'
    qbf-lang[ 6] = 'O. Opsëtning'
    qbf-lang[ 7] = 'A. Afslut'
    qbf-lang[ 8] = 'F. FAST TRACK'
    qbf-lang[10] = 'Filen' /*DBNAME.qc*/
    qbf-lang[11] = 'kunne ikke findes. Du mÜ derfor initialisere'
	     + ' databasen. ùnsker du af gõre dette nu ?'
    qbf-lang[12] = 'Vëlg nyt modul eller tryk [' + KBLABEL("END-ERROR")
	     + '] for at blive i dette modul.'
    qbf-lang[13] = 'Du har ikke kõbt RESULTS.  Programmet afsluttes.'
    qbf-lang[14] = 'Er du sikker pÜ at du õnsker at afslutte "~{1~}" nu?'
    qbf-lang[15] = 'MANUEL,SEMI,AUTO'
    qbf-lang[16] = 'Der er ingen databaser opkoblet.'
    qbf-lang[17] = 'Kan ikke afvikles nÜr en database har et logisk navn '
	     + 'begyndende med "QBF$".'
    qbf-lang[18] = 'Afslut'
    qbf-lang[19] = '** RESULTS er forvirret **^^I Katalog ~{1~}, '
	     + 'findes hverken ~{2~}.db eller ~{2~}.qc.  ~{3~}.qc '
	     + 'findes i PROPATH, men tilhõre tilsyneladende '
	     + '~{3~}.db.  Du mÜ ëndre din PROPATH eller '
	     + 'flytte/slette ~{3~}.db og .qc.'
    /* 24,26,30,32 available if necessary */
    qbf-lang[21] = '         Der er tre mÜder at opbygge forespõrgsels '
	     + 'moduler for'
    qbf-lang[22] = '         PROGRESS RESULTS pÜ. Du kan altid efter '
	     + 'RESULTS opbygning'
    qbf-lang[23] = '         af modulerne, manuelt gÜ ind og ëndre dem'
    qbf-lang[25] = 'Du õnsker manuelt at definere hver enkelt '
    qbf-lang[26] = 'forespõrgsels modul.'
    qbf-lang[27] = 'Efter du har udvalgt et antal filer fra de opkoblede'
    qbf-lang[28] = 'databaser, generere RESULTS forespõrgsels moduler'
    qbf-lang[29] = 'alene for de udvalgte filer.'
    qbf-lang[31] = 'RESULTS generere alle forespõrgsels moduler automatisk.'.


/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-user.p*/
IF qbf-s = 2 THEN
  /* format x(72) for 1,2,9-14,19-22 */
  ASSIGN
    qbf-lang[ 1] = 'Indtast navnet pÜ den include fil der skal benyttes'
    qbf-lang[ 2] = 'til List funktionen i forespõrgsels modulet.'
    qbf-lang[ 3] = '    Default Include Fil:' /*format x(24)*/

    qbf-lang[ 8] = 'Kan ikke finde program'

    qbf-lang[ 9] = 'Indtast navnet pÜ opstarts programmet.  Dette program '
	     + 'kan vëre enten'
    qbf-lang[10] = 'et simpelt logo, eller en komplet login procedure svarende '
	     + 'til "login.p"'
    qbf-lang[11] = 'i Katalog "DLC".  Programmet afvikles umiddelbart efter '
	     + 'lësningen'
    qbf-lang[12] = 'af linien "signon=" i filen DBNAME.qc.'
    qbf-lang[13] = 'Indtast produkt navnet, som du õnsker det vist pÜ'
    qbf-lang[14] = 'hoved menuen.'
    qbf-lang[15] = '       Opstarts Program:' /*format x(24)*/
    qbf-lang[16] = '           Produkt Navn:' /*format x(24)*/
    qbf-lang[17] = 'Defaults:'

    qbf-lang[18] = 'PROGRESS Bruger procedure:'
    qbf-lang[19] = 'Denne procedure afvikler nÜr "Bruger" optionen vëlges '
	     + 'pÜ alle menuer.'

    qbf-lang[20] = 'Dette tillader benyttelsen af et bruger-oprettet data '
	     + 'export program.'
    qbf-lang[21] = 'Indtast venligst bÜde procedure navnet og en beskrivelse'
    qbf-lang[22] = 'til brug pÜ "Exporter Data - Opsëtning" menuen.'
    qbf-lang[23] = 'Procedure:'
    qbf-lang[24] = 'Beskrivelse:'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-load.p:*/
IF qbf-s = 3 THEN
  ASSIGN
    /* menu strip for d-main.p,l-main.p,r-main.p */
    qbf-lang[ 1] = 'Hent,Lës en tidligere defineret ~{1~}.'
    qbf-lang[ 2] = 'Gem,Skriv den aktuelle ~{1~}.'
    qbf-lang[ 3] = 'Kõr,Kõr den aktuelle ~{1~}.'
    qbf-lang[ 4] = 'Definer,Udvëlg filer og felter.'
    qbf-lang[ 5] = 'Opsët, índring af type, format eller layout af den '
		 + 'aktuelle ~{1~}.'
    qbf-lang[ 6] = 'Udvëlg,Record udvëlgelses editor.'
    qbf-lang[ 7] = 'Sorter,índring af rëkkefõlgen af de valgte record.'
    qbf-lang[ 8] = 'Blank,Slet definitionen for den aktuelle ~{1~}.'
    qbf-lang[ 9] = 'Info,Information om den aktuelle opsëtning.'
    qbf-lang[10] = 'Modul,Skift til et andet modul.'
    qbf-lang[11] = 'Extern,Skift til det externe bruger definerede modul.'
    qbf-lang[12] = 'Afslut,Afslut.'
    qbf-lang[13] = '' /* terminator */
    qbf-lang[14] = 'export,label,rapport'

    qbf-lang[15] = 'Lëser konfigurations filen...'

    /* system values for CONTINUE Must be <= 12 characters */
    qbf-lang[18] = '    Forsët' /* for error dialog box */
    qbf-lang[19] = 'Dansk' /* this name of this language */
    /* word "of" for "xxx of yyy" on scrolling lists */
    qbf-lang[20] = 'af'
    /* standard product name */
    qbf-lang[22] = 'PROGRESS RESULTS'
    /* system values for descriptions of calc fields */
    qbf-lang[23] = ',Lõbende Total,Procent af Total,Antal Funk,Streng Udtryk,'
	     + 'Dato Udtryk,Numerisk Udtryk,Logisk Udtryk,Stakket Array'
    /* system values for YES and NO.  Must be <= 8 characters each */
    qbf-lang[24] = '  Ja  ,  Nej  ' /* for yes/no dialog box */

    qbf-lang[25] = 'En automatisk opbygning blev afbrudt. Skal der forsëttes '
	     + 'med den automatiske opbygning?'

    qbf-lang[26] = '* ADVARSEL - Versions konflikt *^^Aktuelle version '
	     + 'er  <~{1~}> mens .qc filen er for version <~{2~}>.  Der '
	     + 'kan opstÜ problemer, indtil forespõrgsels moduler er '
	     + 'genopbygget med "Applikations Genopbygning".'

    qbf-lang[27] = '* ADVARSEL - Manglende databaser *^^De(n) fõlgende '
	     + 'database(r) er krëvet men er ikke opkoblet:'

    qbf-lang[32] = '* ADVARSEL - Definitions ëndring *^^Database strukturen '
	     + 'er ëndret siden nogle af forespõrgslerne blev opbygget.  '
	     + 'Benyt "Applikation Genopbygning" fra Opsëtnings menuen '
	     + 'sÜ snart som muligt.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-main.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = " A. Applikations Genopbygning"
    qbf-lang[ 2] = " S. Skërm def for Forespõrgsel"
    qbf-lang[ 3] = " R. Relationer mellem filer"

    qbf-lang[ 4] = " I. Indhold af Bruger Katalog"
    qbf-lang[ 5] = " H. Hvordan man Afslutter Appl"
    qbf-lang[ 6] = " M. Modul Rettigheder"
    qbf-lang[ 7] = " F. Forespõrgsel Rettigheder"
    qbf-lang[ 8] = " O. Opstarts Program/Produkt"

    qbf-lang[11] = " V. Vëlg Sprog"
    qbf-lang[12] = " P. Printer opsëtning"
    qbf-lang[13] = " T. Terminal Farve opsëtning"

    qbf-lang[14] = " L. Liste Program, Forespõrgsel"
    qbf-lang[15] = " D. Default Rapport Opsëtning"
    qbf-lang[16] = " E. Brugerdefineret Export Format"
    qbf-lang[17] = " U. Label Felt Udvëlgelse"
    qbf-lang[18] = " B. Bruger Funktion"

    qbf-lang[21] = 'Vëlg et af punkterne, eller tryk [' + KBLABEL("END-ERROR")
	     + '] for at afslutte og gemme ëndringer.'
    /* these next four have a length limit of 20 including colon */
    qbf-lang[22] = 'Filer:'
    qbf-lang[23] = 'Konfiguration:'
    qbf-lang[24] = 'Sikkerhed:'
    qbf-lang[25] = 'Moduler:'

    qbf-lang[26] = 'Opsëtning'
    qbf-lang[27] = 'Version'
    qbf-lang[28] = 'Lëser yderligere opsëtninger fra '
	     + 'konfigurations filen.'
    qbf-lang[29] = 'Er du sikker pÜ at du õnsker at gendanne applikation?'
/* QUIT and RETURN are the PROGRESS keywords and cannot be translated */
    qbf-lang[30] = 'NÜr brugeren forlader hovedmenuen, skal programmet sÜ '
	     + 'udfõre ''QUIT'' eller ''RETURN''?'
    qbf-lang[31] = 'Er du sikker pÜ du õnsker at forlade Opsëtnings '
	     + 'menuen nu?'
    qbf-lang[32] = 'Verificerer konfigurations filen, og gemmer alle '
	     + 'ëndringer.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 5 THEN
  ASSIGN
/*a-perm.p, 1..7 also used by a-form.p and a-print.p*/
    qbf-lang[ 1] = 'Rettigheder'
    qbf-lang[ 2] = '    *                      - Alle brugere har adgang.'
    qbf-lang[ 3] = '    <bruger>,<bruger>,etc. - Kun disse brugeres har adgang.'
    qbf-lang[ 4] = '    !<bruger>,!<bruger>,*  - Alle undtagen disse brugers har '
	     + 'adgang.'
    qbf-lang[ 5] = '    acct*                  - Kun brugere der begynder med '
	     + '"acct" har adgang'
    qbf-lang[ 6] = 'Vis brugere efter deres login navn, og separer dem med'
	     + 'kommaer.'
    qbf-lang[ 7] = 'Bruger navne kan indeholde wildcards.  Benyt udrÜbstegn til '
	     + 'udelukkelse af brugere.'
	       /* from 8 thru 13, format x(30) */
    qbf-lang[ 8] = 'Vëlg et modul fra listen'
    qbf-lang[ 9] = 'til venstre der skal'
    qbf-lang[10] = 'sëttes restriktioner pÜ.'
    qbf-lang[11] = 'Vëlg en funktion fra listen'
    qbf-lang[12] = 'til venstre, der skal'
    qbf-lang[13] = 'sëttes restriktioner pÜ.'
    qbf-lang[14] = 'Tryk [' + KBLABEL("END-ERROR")
	     + '] nÜr ëndringerne er foretaget.'
    qbf-lang[15] = 'Tryk [' + KBLABEL("GO") + '] for gem, ['
	     + KBLABEL("END-ERROR") + '] for at fortryde ëndringer.'
    qbf-lang[16] = 'Du kan ikke udelukke dig selv fra system Opsëtning!'
/*a-print.p:*/     /*21 thru 26 must be format x(16) and right-justified */
    qbf-lang[21] = '  Initialisering'
    qbf-lang[22] = '                '
    qbf-lang[23] = '    Normal Print'
    qbf-lang[24] = '     Komprimeret'
    qbf-lang[25] = '  Fed skrift til'
    qbf-lang[26] = '  Fed skrift fra'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 6 THEN
  ASSIGN
/*a-write.p:*/
    qbf-lang[ 1] = 'Lëser modul opsëtning'
    qbf-lang[ 2] = 'Lëser farve opsëtning'
    qbf-lang[ 3] = 'Lëser printer opsëtning'
    qbf-lang[ 4] = 'Lëser liste af lësbare filer'
    qbf-lang[ 5] = 'Lëser liste af relationer'
    qbf-lang[ 6] = 'Lëser udvëlgelses liste for adresse labels'
    qbf-lang[ 7] = 'Lëser adgangs liste for forespõrgsel funktioner'
    qbf-lang[ 8] = 'Lëser bruger funktions informationer'
    qbf-lang[ 9] = 'Lëser system rapport definitioner'

/* a-color.p*/
	     /* 12345678901234567890123456789012 */
    qbf-lang[11] = '  Angiv farve for terminal type:' /* must be 32 */
	     /* 1234567890123456789012345 */
    qbf-lang[12] = 'Menu:             Normal:' /* must be 25 */
    qbf-lang[13] = '                Markeret:'
    qbf-lang[14] = 'Dialog Ramme:     Normal:'
    qbf-lang[15] = '                Markeret:'
    qbf-lang[16] = 'Rulle liste:      Normal:'
    qbf-lang[17] = '                Markeret:'

/*a-felt.p*/    /*"----- ----- ----- ----- ----"*/
    qbf-lang[30] = 'Vis?  Opda?  Sõg? List? Srt?'
    qbf-lang[31] = 'Skal vëre i omrÜdet mellem 1 og 9999.'
    qbf-lang[32] = 'ùnsker du at gemme de ëndringer du lige har foretaget til'
	     + 'felt listen?'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 8 THEN
/*a-label.p*/
  ASSIGN            /* 1..8 use format x(78) */
		/* 1 and 8 are available for more explanation, in */
		/*   case the translation won't fit in 2 thru 7.  */
    qbf-lang[ 2] = 'Indtast felt navnene der indeholder adresse information.  '
	     + 'Benytter CAN-DO'
    qbf-lang[ 3] = 'formatet til at sammenligne disse felt navne ("*" svarer '
	     + 'til et vilkÜrligt antal'
    qbf-lang[ 4] = 'karakterer, "." svarer til een vilkÜrlig karakter).  Denne '
	     + 'information benyttes'
    qbf-lang[ 5] = 'ved oprettelse af std. adresse labels.  Bemërk at nogle'
	     + 'informationer kan vëre'
    qbf-lang[ 6] = 'redundante - for eksempel, hvis du altid gemmer post nummer'
	     + 'og by i'
    qbf-lang[ 7] = 'seperate felter, behõver du ikke benytte "Nr-By" linien.'
	      /* each entry in list must be <= 5 characters long */
	      /* but may be any portion of address that is applicable */
	      /* in the target country */
    qbf-lang[ 9] = 'Pers,Titel,Firma,Adr1,Adr2,Adr3,Numm,By,Nr-By,Land'
    qbf-lang[10] = 'Felt indeholdende <Person navn>'
    qbf-lang[11] = 'Felt indeholdende <Titel>'
    qbf-lang[12] = 'Felt indeholdende <Firma navn>'
    qbf-lang[13] = 'Felt indeholdende <fõrste> linie af adressen (fx. vej)'
    qbf-lang[14] = 'Felt indeholdende <anden> linie af adressen (fx. PO Box)'
    qbf-lang[15] = 'Felt indeholdende <tredie> linie af adressen (valgfri)'
    qbf-lang[16] = 'Felt indeholdende <post nummer>'
    qbf-lang[17] = 'Felt indeholdende <post distrikt>'
    qbf-lang[18] = 'Felt indeholdende <kombineret post nr og distrikt>'
    qbf-lang[19] = 'Felt indeholdende <land>'

/*a-join.p*/
    qbf-lang[23] = 'Automatisk fil relatering er ikke tilladt.'
    qbf-lang[24] = 'Maximum antal af fil relationer er nÜet.'
    qbf-lang[25] = 'Relation fra' /* 25 and 26 are automatically */
    qbf-lang[26] = 'til'          /*   right-justified           */
    qbf-lang[27] = 'Indtast WHERE eller OF betingelse: (blank angiver ingen relation)'
    qbf-lang[28] = 'Tryk [' + KBLABEL("END-ERROR") + '] nÜr opdateringen er udfõrt.'
    qbf-lang[30] = 'Sëtningen skal begynde med WHERE eller OF.'
    qbf-lang[31] = 'Indtast fõrste file i relationen der skal indsëttes/fjernes.'
    qbf-lang[32] = 'Indtast anden fil i relation.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-form.p */
IF qbf-s = 9 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' I. Indsët ny Forespõrgsel Skërm '
    qbf-lang[ 2] = ' V. Vëlg Forespõrgsel Skërm til editering '
    qbf-lang[ 3] = ' G. General Skërm karakteristik '
    qbf-lang[ 4] = ' F. Felter pÜ Skërm '
    qbf-lang[ 5] = ' R. Rettigheder '
    qbf-lang[ 6] = ' S. Slet aktuelle Forespõrgsel Skërm '
    qbf-lang[ 7] = ' Udvëlg: ' /* format x(10) */
    qbf-lang[ 8] = ' Opdater: ' /* format x(10) */
	     /* cannot changed width of 9..16 from defined below */
    qbf-lang[ 9] = '      Database fil navn' /* right-justify 9..14 */
    qbf-lang[10] = '             Skërm type'
    qbf-lang[11] = 'Forespõrg. program navn'
    qbf-lang[12] = 'Skërm''s fysisk fil navn'
    qbf-lang[13] = 'Frame navn for 4GL kode'
    qbf-lang[14] = '            Beskrivelse'
    qbf-lang[15] = '(.p forventet)   ' /* left-justify 15 and 16 */
    qbf-lang[16] = '(krëver .navn)'
    qbf-lang[18] = 'Denne skërm er pÜ ~{1~} linier.  Da RESULTS reserverer '
	     + 'fem linier til eget brug, vil dette billede ikke kunne vëre '
	     + 'pÜ en 24 liniers terminal.  Er du sikker pÜ du õnsker at '
	     + 'definere en skërm med denne stõrrelse?'
    qbf-lang[19] = 'Et forespõrgsel program eksisterer allerede med dette navn.'
    qbf-lang[20] = 'Skërmen skal allerede findes, eller skal ende pÜ .f for '
	     + 'automatisk generering.'
    qbf-lang[21] = 'Det navn du har valgt til 4GL skërmen er reserveret. '
	     + 'Vëlg et andet.'
    qbf-lang[22] = ' Vëlg lësbare Filer '
    qbf-lang[23] = 'Tryk [' + KBLABEL("END-ERROR") + '] nÜr opdateringen er udfõrt'
    qbf-lang[24] = 'Gemmer skërm informationen i forespõrgsel skërm cache...'
    qbf-lang[25] = 'Du har ëndret mindst en forespõrgsel skërm.  Du kan '
	     + 'enten kompilere den ëndrede skërm nu, eller foretage'
	     + '"Applikation Genopbygning" senere.  Kompilering nu?'
    qbf-lang[26] = 'Ingen forespõrgsel skërm med navnet "~{1~}" fundet. ùnsker '
	     + 'du at generere en?'
    qbf-lang[27] = 'En forespõrgsel skërm kaldet "~{1~}" eksisterer. Benyt felter fra '
	     + 'denne skërm?'
    qbf-lang[28] = 'Er du sikker pÜ at du õnsker at slette forespõrgsel skërm'
    qbf-lang[29] = '** Forespõrgsel program "~{1~}" slettet. **'
    qbf-lang[30] = 'Udtrëkker forespõrgsel skërm...'
    qbf-lang[31] = 'Maximum antal af forespõrgsel skërme er nÜet.'
    qbf-lang[32] = 'Kan ikke opbygge forespõrgsel skërm for denne fil.^^For at '
	     + 'bygge en forespõrgsel skërm, krëves enten at det benyttede '
	     + 'gateway supportere RECID, eller et unique index pÜ filen.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-print.p */
IF qbf-s = 10 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' I. Indsët nyt Udskrifts Enhed '
    qbf-lang[ 2] = ' V. Vëlg Enhed der skal editeres '
    qbf-lang[ 3] = ' G. General Enheds karakteristik '
    qbf-lang[ 4] = ' K. Kontrol Sekvenser  '
    qbf-lang[ 5] = ' P. Printer Rettigheder '
    qbf-lang[ 6] = ' S. Slet aktuelle enhed '
    qbf-lang[ 7] = ' Udvëlg: ' /* format x(10) */
    qbf-lang[ 8] = ' Opdater: ' /* format x(10) */
    qbf-lang[ 9] = 'Skal vëre mindre end 256 men stõrre end 0'
    qbf-lang[10] = 'Type skal vëre term, thru, to, view, file, page eller prog'
    qbf-lang[11] = 'Maximum antal udskrifts enheder er nÜet.'
    qbf-lang[12] = 'Kun enheds type "term" kan skrive pÜ terminalen.'
    qbf-lang[13] = 'Kan ikke det pÜgëldende program navn i den aktuelle PROPATH.'
	      /*17 thru 20 must be format x(16) and right-justified */
    qbf-lang[17] = 'Beskiv for liste'
    qbf-lang[18] = '      Enhed navn'
    qbf-lang[19] = '   Maximum Brede'
    qbf-lang[20] = '            Type'
    qbf-lang[21] = 'se nedenfor'
    qbf-lang[22] = 'TERMINAL, som i OUTPUT TO TERMINAL PAGED'
    qbf-lang[23] = 'TO en enhed, som f.eks OUTPUT TO PRINTER'
    qbf-lang[24] = 'THROUGH et UNIX eller OS/2 spooler eller filter'
    qbf-lang[25] = 'Send rapporten til en fil, afvikl derefter program'
    qbf-lang[26] = 'Spõrg brugeren om et filnavn for udskrifts destination'
    qbf-lang[27] = 'Til skërm med forrige-side, nëste-side support'
    qbf-lang[28] = 'Kald et 4GL program til at starte/stoppe udskrift'
    qbf-lang[30] = 'Tryk [' + KBLABEL("END-ERROR") + '] nÜr opdateringen er udfõrt'
    qbf-lang[31] = 'Der skal vëre mindst een udskrifts enhed!'
    qbf-lang[32] = 'Er du sikker pÜ at du õnsker at slette denne printer?'.

/*--------------------------------------------------------------------------*/

RETURN.
