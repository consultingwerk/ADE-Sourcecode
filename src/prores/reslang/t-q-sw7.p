/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-q-swe.p - Swedish language definitions for Query module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Post saknas med detta urvalskriterium.'
    qbf-lang[ 2] = 'Samtliga,Relation,Delm„ngd'
    qbf-lang[ 3] = 'Alla visade,Vid b”rjan,Vid slutet'
    qbf-lang[ 4] = 'Index saknas f”r denna fil.'
    qbf-lang[ 5] = 'S„kert att du vill ta bort denna post?'
    qbf-lang[ 6] = '' /* special total message: created from #7 or #8 */
    qbf-lang[ 7] = 'Antal operation stoppade.'
    qbf-lang[ 8] = 'Totalt antal tillg„ngliga poster „r '
    qbf-lang[ 9] = 'Antal k”rs...   Tryck [' + KBLABEL("END-ERROR")
                 + '] f”r att avbryta.'
    qbf-lang[10] = 'Lika med,„r mindre „n,„r mindre „n el lika med,'
                 + '„r st”rre „n,„r st”rre „n el lika med,'
                 + '„r skilt fr†n,matchar,b”rjar med'
    qbf-lang[11] = 'Nu finns inga poster tillg„ngliga.'
    qbf-lang[13] = 'Du „r redan vid filens f”rsta post.'
    qbf-lang[14] = 'Du „r redan vid filens sista post.'
    qbf-lang[15] = 'Det finns inga fr†geformul„r definierade nu.'
    qbf-lang[16] = 'Fr†ga'
    qbf-lang[17] = 'V„lj namn p† ”nskat fr†geformul„r.'
    qbf-lang[18] = 'Tryck [' + KBLABEL("GO")
                 + '] el [' + KBLABEL("RETURN")
                 + '] f”r val av formul„r, el [' + KBLABEL("END-ERROR")
                 + '] f”r avslut.'
    qbf-lang[19] = 'Laddar fr†geformul„r...'
    qbf-lang[20] = 'Kompilerade fr†geformul„ret saknas f”r denna procedur.  '
                 + 'Det kan bero p†:^1) inkorrekt PROPATH,^2) Fr†ge .r'
                 + 'fil saknas, el^3) okompilerad .r fil.^(Kontrollera '
                 + '<dbnamn>.ql fil om komp.felmeddelande).^^Du kan '
                 + 'forts„tta, men det kan resultera i ett felmeddelande.  '
                 + 'Vill du f”rs”ka att forts„tta?'
    qbf-lang[21] = 'Det finns en WHERE sats i aktuellt fr†geprogram i vilket '
                 + ' det efterfr†gas v„rden vid RUN-TIME.  Detta fungerar ej '
                 + 'i Fr†gemodulen.  Ignorera WHERE satser '
                 + 'och forts„tt?'
    qbf-lang[22] = 'Tryck [' + KBLABEL("GET")
                 + '] f”r att st„lla in olika bl„ddringsf„lt.'.

ELSE

IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = '+,N„sta post.'
    qbf-lang[ 2] = '-,F”reg†ende post.'
    qbf-lang[ 3] = '<,F”rsta posten.'
    qbf-lang[ 4] = '>,Sista posten.'
    qbf-lang[ 5] = 'L„gga till,Addera en ny post.'
    qbf-lang[ 6] = 'Uppdat,Uppdatera aktuell post.'
    qbf-lang[ 7] = 'Kopiera,Kopiera nu visad post till en ny post.'
    qbf-lang[ 8] = 'Ta bort,Ta bort nu visad post.'
    qbf-lang[ 9] = 'Visa,Visa ett annat fr†geformul„r.'
    qbf-lang[10] = 'Bl„ddra,Bl„ddra genom en lista av poster.'
    qbf-lang[11] = 'Relation,Relaterade poster.'
    qbf-lang[12] = 'Fr†ga,Fr†ga genom exempel efter ett urval av poster.'
    qbf-lang[13] = 'Delm„ngd,WHERE sats editor urval av poster.'
    qbf-lang[14] = 'Antal,Antal poster i aktuell m„ngd av poster.'
    qbf-lang[15] = 'Ordning,Skifta mellan olika index.'
    qbf-lang[16] = 'Modul,Skifta till en annan modul.'
    qbf-lang[17] = 'Info,Information om aktuella inst„llningar.'
    qbf-lang[18] = 'Egen,™verg† till egen tillverkad applikation.'
    qbf-lang[19] = 'Slut,Avsluta.'
    qbf-lang[20] = ''. /* terminator */

RETURN.
