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
/* t-i-dan.p - Danish language definitions for katalog */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*i-dir.p,i-pick.p,i-zap.p,a-info.p,i-read.p*/
ASSIGN
  qbf-lang[ 1] = 'export,graf,label,foresp›rgsel,rapport'
  qbf-lang[ 2] = 'Indtast beskrivelse af'
  qbf-lang[ 3] = 'Nogle filer og/eller felter er blevet udeladt grundet '
	       + 'en af f›lgende †rsager:^1) oprindelige databaser er ikke '
	       + 'opkoblet^2) database definitions ‘ndringer^3) utilstr‘kkelig '
	       + 'adgangs-rettighed'
  qbf-lang[ 4] = 'Hver ~{1~} skal have et entydigt navn.  Pr›v igen.'
  qbf-lang[ 5] = 'Du har gemt for mange definitioner.  Der skal slettes nogle  '
	       + 'Sletning fra vilk†rligt katalog, vil frigive plads.'
  qbf-lang[ 6] = 'Beskriv-,Database,Program-'
  qbf-lang[ 7] = 'Er du sikker p† du ›nsker at overskrive'
  qbf-lang[ 8] = 'med'
  qbf-lang[ 9] = 'V‘lg'
  qbf-lang[10] = 'et Export Format,en Graf,en Label,en Foresp›rgsel,en Rapport'
  qbf-lang[11] = 'export format,graf,label,foresp›rgsel,rapport'
  qbf-lang[12] = 'Export Formats,Grafer,Labels,Queries,Rapporter'
  qbf-lang[13] = 'Exporter data Formats,Grafer,Label Formats,Queries,'
	       + 'Rapport Definitioner'
  qbf-lang[14] = 'der skal hentes,der skal gemmes,der skal slettes'
  qbf-lang[15] = 'Arbejder...'
  qbf-lang[16] = 'hent ~{1~} fra et andet katalog'
  qbf-lang[17] = 'gem som ny ~{1~}'
  qbf-lang[18] = 'ikke tilg‘ngelig'
  qbf-lang[19] = 'Alle markerede definitioner vil blive slettet.  Benyt ['
	       + KBLABEL('RETURN') + '] til markering.'
  qbf-lang[20] = 'Tryk [' + KBLABEL('GO') + '] n†r udf›rt, eller ['
	       + KBLABEL('END-ERROR') + '] for at udelade sletning.'
  qbf-lang[21] = 'Flytter nummer ~{1~} til position ~{2~}.'
  qbf-lang[22] = 'Sletter nummer ~{1~}.'
  qbf-lang[23] = '[' + KBLABEL("GO") + '] for udv‘lg, ['
	       + KBLABEL("INSERT-MODE") + '] for skift, ['
	       + KBLABEL("END-ERROR") + '] for afslut.'
  qbf-lang[24] = 'Udskriver opdateret rapport katalog...'
/*a-info.p only:*/ /* 25..29 use format x(64) */
  qbf-lang[25] = 'Dette program viser indholdet af en specifik'
  qbf-lang[26] = 'brugers lokale katalog, visende hvilke genererede'
  qbf-lang[27] = 'programmer der h›rer sammen med hvilke rapporter, export,'
  qbf-lang[28] = 'label, og s† fremdeles.'
  qbf-lang[29] = 'Indtast fuld katalog sti p† brugerens ".qd" fil:'
  qbf-lang[30] = 'Kan ikke finde den angivne fil.'
  qbf-lang[31] = 'Du glemte ".qd" extensionen.'
  qbf-lang[32] = 'L‘ser katalog...'.

RETURN.
