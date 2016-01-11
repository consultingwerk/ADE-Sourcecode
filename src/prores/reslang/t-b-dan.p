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
/* t-b-dan.p - Danish language definitions for Build subsystem */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* b-build.p,b-again.p */
IF qbf-s = 1 THEN
  ASSIGN
		/* formats: x(10) x(45) x(8) */
    qbf-lang[ 1] = 'Program,Database og Fil,Tid'
    qbf-lang[ 2] = 'Checkpoint filen er ›delagt.  Fjern .qc filen og genstart '
		 + 'opbygningen fra begyndelsen.'
    qbf-lang[ 3] = 'Arbejder med'     /*format x(15)*/
    qbf-lang[ 4] = 'Kompilerer'      /*format x(15)*/
    qbf-lang[ 5] = 'Genkompilerer'   /*format x(15)*/
    qbf-lang[ 6] = 'Arbejder med fil,Arbejder med sk‘rm,Arbejder med program'
    qbf-lang[ 7] = 'Alle markerede sk‘rme vil blive opbygget.  Benyt ['
		 + KBLABEL("RETURN") + '] til til/fra valg.'
    qbf-lang[ 8] = 'Tryk [' + KBLABEL("GO") + '] for udf›r, eller ['
		 + KBLABEL("END-ERROR") + '] for fortryd.'
    qbf-lang[ 9] = 'Selekterer filer til initiel liste af foresp›rgsel sk‘rme...'
    qbf-lang[10] = 'Er du f‘rdig med definering af foresp›rgsel sk‘rme?'
    qbf-lang[11] = 'Finder indblandede OF-relationer.'
    qbf-lang[12] = 'Behandler liste af relationer.'
    qbf-lang[13] = 'Ikke alle relationer kunne findes.'
    qbf-lang[14] = 'Eliminere redundant relations information.'
    qbf-lang[15] = 'Er du sikker p† du ›nsker at afslutte?'
    qbf-lang[16] = 'Forl›bet tid,Gennemsnit tid'
    qbf-lang[17] = 'L‘ser checkpoint fil...'
    qbf-lang[18] = 'Skriver checkpoint fil...'
    qbf-lang[19] = 'eksisterer allerede. Benytter istedet'
    qbf-lang[20] = 'genopbygger fil'
    qbf-lang[21] = 'skanner sk‘rm "~{1~}" for ‘ndringer.'
    qbf-lang[22] = 'Kan ikke opbygge foresp›rgsel sk‘rm medmindre RECID eller UNIQUE INDEX '
		 + 'findes.'
    qbf-lang[23] = 'Sk‘rm u‘ndret.'
    qbf-lang[24] = 'beh›ver ikke rekompilering.'
    qbf-lang[25] = 'Ingen felter tilbage p† sk‘rm.  Foresp›rgsel sk‘rm bliver ikke genereret.'
    qbf-lang[26] = 'Ingen felter tilbage p† sk‘rm.  Eksisterende foresp›rgsel sk‘rm slettet.'
    qbf-lang[27] = 'Pakker listen over l‘sbare filer.'
    qbf-lang[28] = 'Forl›bet tid'
    qbf-lang[29] = 'Udf›rt!'
    qbf-lang[30] = 'Kompilering af "~{1~}" mislykket.'
    qbf-lang[31] = 'Skriver konfigurations fil.'
    qbf-lang[32] = 'Fejl fundet under opbygningen og/eller kompileringen.'
		 + '^^Tryk en tast for at se log filen.  Linier '
		 + 'indeholdende fejl vil v‘re markeret.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN

/* b-misc.p */
    /* 1..10 for qbf-l-auto[] */
    qbf-lang[ 1] = 'person,*pers*,*navn*,*kontakt*,*contact*,Name'
    qbf-lang[ 2] = '*titel,*title,funktion,Address'
    qbf-lang[ 3] = 'firma,f*navn*,c*name*,Address2'
    qbf-lang[ 4] = '*gade,*vej,*adresse,*adresse*1'
    qbf-lang[ 5] = '*po*box*,*adresse*2,City'
    qbf-lang[ 6] = '*adresse*3,St'
    qbf-lang[ 7] = '*po*num*,*po*nr*,Zip'
    qbf-lang[ 8] = '*po*dist*,*po*by*,*dist*'
    qbf-lang[ 9] = '*post*'
    qbf-lang[10] = '*land*,*country*,*stat*'

    qbf-lang[15] = 'Export format pr›ve'.

/*--------------------------------------------------------------------------*/

RETURN.
