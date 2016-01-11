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
/* t-b-swe.p - Swedish language definitions for Build subsystem */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* b-build.p,b-again.p */
IF qbf-s = 1 THEN
  ASSIGN
                /* formats: x(10) x(45) x(8) */
    qbf-lang[ 1] = 'Program,Databas och tabell,tid'
    qbf-lang[ 2] = 'Kontrollfil „r f”rst”rd.  Tag bort .qc fil och starta '
                 + 'om helt fr†n b”rjan.'
    qbf-lang[ 3] = 'Arbetar med'     /*format x(15)*/
    qbf-lang[ 4] = 'Kompilerar'      /*format x(15)*/
    qbf-lang[ 5] = 'Om-kompilerar'   /*format x(15)*/
    qbf-lang[ 6] = 'Arbetar med tabell,Arbetar med formul„r,Arbetar med program'
    qbf-lang[ 7] = 'Alla markerade formul„r byggs upp.  Anv ['
                 + KBLABEL("RETURN") + '] f”r mark/ejmark.'
    qbf-lang[ 8] = 'Tryck [' + KBLABEL("GO") + '] n„r klart, el ['
                 + KBLABEL("END-ERROR") + '] f”r avbryt.'
    qbf-lang[ 9] = 'S”ker tabeller f”r att bygga initiallistor t fr†geform...'
    qbf-lang[10] = 'Klar med definition av fr†geformul„r?'
    qbf-lang[11] = 'Hittar implicerade OF-relationer.'
    qbf-lang[12] = 'Processar lista med relationer.'
    qbf-lang[13] = 'Alla relationer kunde ej lokaliseras.'
    qbf-lang[14] = 'Eliminerar ”verfl”dig relationsinformation.'
    qbf-lang[15] = 'S„kert att du vill avsluta?'
    qbf-lang[16] = 'F”rfluten tid,Medeltid'
    qbf-lang[17] = 'L„ser kontrollfil...'
    qbf-lang[18] = 'Skriver kontrollfil...'
    qbf-lang[19] = 'finns redan.  Anv„nd i st„llet'
    qbf-lang[20] = '†terbygger tabell'
    qbf-lang[21] = 'S”ker genom formul„r "~{1~}" efter „ndringar.'
    qbf-lang[22] = 'Kan ej bygga fr†geformul„r om ej RECID el UNIKT INDEX '
                 + ' „r tillg„ngligt.'
    qbf-lang[23] = 'Formul„r of”r„ndrat.'
    qbf-lang[24] = 'beh”ver ej omkompileras.'
    qbf-lang[25] = 'Inga f„lt kvar i formul„r.  Fr†geformul„r genereras ej.'
    qbf-lang[26] = 'Inga f„lt kvar i formul„r.  Fr†geformul„r borttaget.'
    qbf-lang[27] = 'Packar lista ”ver visningsbara tabeller.'
    qbf-lang[28] = 'F”rfluten tid'
    qbf-lang[29] = 'Klart!'
    qbf-lang[30] = 'Kompilering av "~{1~}" misslyckades.'
    qbf-lang[31] = 'Skriver konfig.fil'
    qbf-lang[32] = 'Fel hittades under bygg- och/el kompileringsstadiet.'
                 + '^^Tryck p† en tangent f”r att se fr†geloggfilen.  Rader '
                 + 'som inneh†ller fel „r upplysta.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN

/* b-misc.p */
    /* 1..10 for qbf-l-auto[] */
    qbf-lang[ 1] = 'namn,*namn*,kontakt,*kontakt*,Name'
    qbf-lang[ 2] = '*gata,*adr,*adress,*adress*1,Address'
    qbf-lang[ 3] = '*box*,*adress*2,Address2'
    qbf-lang[ 4] = '*adress*3'
    qbf-lang[ 5] = 'stad,*stad*,City'
    qbf-lang[ 6] = 'st,stat,*stat*'
    qbf-lang[ 7] = 'postnr,*nr*,Zip'
    qbf-lang[ 8] = 'pnr*4'
    qbf-lang[ 9] = '*csz*,*city*st*z*'
    qbf-lang[10] = '*land*'

    qbf-lang[15] = 'Exempel p† Export'.

/*--------------------------------------------------------------------------*/

RETURN.
