/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-q-dan.p - Danish language definitions for Forespõrgsel module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Ingen record fundet benyttende kriteriet.'
    qbf-lang[ 2] = 'Alle data,Relaterede,Udvalgte data'
    qbf-lang[ 3] = 'Alle vist,Ved toppen,Ved slutningen'
    qbf-lang[ 4] = 'Der er ingen index defineret for denne fil.'
    qbf-lang[ 5] = 'Er du sikker pÜ du õnsker at slette denne record?'
    qbf-lang[ 6] = '' /* special total message: created from #7 or #8 */
    qbf-lang[ 7] = 'Total operationen stoppet.'
    qbf-lang[ 8] = 'Total antal records tilgëngeligt '
    qbf-lang[ 9] = 'Total kõrer...   Tryk [' + KBLABEL("END-ERROR")
		 + '] for stop.'
    qbf-lang[10] = 'lig med,er mindre end,er mindre end eller lig med,'
		 + 'er stõrre end,er stõrre end eller lig med,'
		 + 'er forskellig fra,indeholder,begynder med'
    qbf-lang[11] = 'Der er ingen records tilgëngelige.'
    qbf-lang[13] = 'Du er allerede pÜ den fõrste record i filen.'
    qbf-lang[14] = 'Du er allerede pÜ den sidste record i filen.'
    qbf-lang[15] = 'Der er aktuelt ingen forespõrgsels skërme defineret.'
    qbf-lang[16] = 'Forespõrgsel'
    qbf-lang[17] = 'Vëlg navnet pÜ den Forespõrgsels skërm der skal benyttes.'
    qbf-lang[18] = 'Tryk [' + KBLABEL("GO")
		 + '] eller [' + KBLABEL("RETURN")
		 + '] for udvëlg skërm, eller [' + KBLABEL("END-ERROR")
		 + '] for afslut.'
    qbf-lang[19] = 'Lëser forespõrgsels skërm...'
    qbf-lang[20] = 'Den kompilerede forespõrgsels skërm til denne procedure mangler.  '
		 + 'Problemet kan vëre:^1) ukorrekt PROPATH,^2) manglende '
		 + 'forespõrgsel .r fil, eller^3) ukompileret .r fil.^(Kontroller '
		 + '<dbnavn>.ql filen for kompilerings fejlmeddelelser).^^Du '
		 + 'kan forsõge at fortsëtte, men det kan give yderligere fejl meddelelser. '
		 + 'ùnsker du at fortsëtte?'
    qbf-lang[21] = 'Der er en WHERE betingelse i den aktuelle forespõrgsel der '
		 + 'benytter vërdier spurgt efter pÜ RUN-TIME tidspunktet.  Dette '
		 + 'er ikke supporteret i Forespõrgsels modulet.  Ignorer WHERE '
		 + 'betingelsen og fortsët?'
    qbf-lang[22] = 'Tryk [' + KBLABEL("GET")
		 + '] for at opsëtte andre liste felter.'.

ELSE

IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Nëste,Nëste record.'
    qbf-lang[ 2] = 'Forrige,Forrige record.'
    qbf-lang[ 3] = 'Fõrste,Fõrste record.'
    qbf-lang[ 4] = 'Sidste,Sidste record.'
    qbf-lang[ 5] = 'Indsët,Indsët en ny record.'
    qbf-lang[ 6] = 'Opdater,Opdater den nu viste record.'
    qbf-lang[ 7] = 'Kopi,Kopi af den nu viste record til en ny.'
    qbf-lang[ 8] = 'Blank,Slet den nu viste record.'
    qbf-lang[ 9] = 'Vis,Vis en anden Forespõrgsel skërm.'
    qbf-lang[10] = 'List,List gennem en liste af record.'
    qbf-lang[11] = 'Relation,Relation til sammenkëdet fil.'
    qbf-lang[12] = 'QBE,Query by Example udvëlgelse af record.'
    qbf-lang[13] = 'Udvëlg,Udvëlgelse betingelses editor udvëlgelse af record.'
    qbf-lang[14] = 'Total,Antal af record i den aktuelle mëngde eller delmëngde.'
    qbf-lang[15] = 'Rëkkefõlge,Skift til et andet index.'
    qbf-lang[16] = 'Modul,Skift til et anden modul.'
    qbf-lang[17] = 'Info,Information om aktuelle opsëtning.'
    qbf-lang[18] = 'Extern,Skift til det externe bruger specifikke modul.'
    qbf-lang[19] = 'Afslut,Afslut.'
    qbf-lang[20] = ''. /* terminator */

RETURN.
