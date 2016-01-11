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
/* t-i-swe.p - Swedish language definitions for Directory */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*i-dir.p,i-pick.p,i-zap.p,a-info.p,i-read.p*/
ASSIGN
  qbf-lang[ 1] = 'export,graf,etikett,fr†ga,rapport'
  qbf-lang[ 2] = 'Ange beskrivning av'
  qbf-lang[ 3] = 'N†gra av tabellerna och/eller f„lten har f”rsummats p.g.a '
               + 'en av f”ljande orsaker:^1) originaldatabaser ej '
               + 'anslutna^2) databasdefinition „ndringar^3) otillr„cklig '
               + 'beh”righet'
  qbf-lang[ 4] = 'Varje ~{1~} m†ste ha ett unikt namn.  F”rs”k igen.'
  qbf-lang[ 5] = 'Du har sparat f”r m†nga definitioner. Tag bort n†gra!  '
               + 'Borttag fr†n n†got modulbibliotek skapar mer utrymme.'
  qbf-lang[ 6] = 'Beskrivn,Databas-,Program-'
  qbf-lang[ 7] = 'S„kert att du vill skriva ”ver'
  qbf-lang[ 8] = 'med'
  qbf-lang[ 9] = 'V„lj'
  qbf-lang[10] = 'ett Exportformat,en Graf,en Etikett,en Fr†ga,en Rapport'
  qbf-lang[11] = 'exportformat,graf,etikett,fr†ga,rapport'
  qbf-lang[12] = 'Exportformat,Grafer,Etiketter,Fr†gor,Rapporter'
  qbf-lang[13] = 'Dataexportformat,Grafer,Etikettformat,Fr†gor,'
               + 'Rapportdefinitioner'
  qbf-lang[14] = 'att ladda,att spara,att ta bort'
  qbf-lang[15] = 'Arbetar...'
  qbf-lang[16] = 'h„mta ~{1~} fr†n ett annat bibliotek'
  qbf-lang[17] = 'spara som ny ~{1~}'
  qbf-lang[18] = 'ej tillg„nglig'
  qbf-lang[19] = 'Alla markerade objekt tas bort.  Anv„nd ['
               + KBLABEL('RETURN') + '] f”r mark/avmark.'
  qbf-lang[20] = 'Tryck [' + KBLABEL('GO') + '] n„r det „r klart, el ['
               + KBLABEL('END-ERROR') + '] f”r att †ngra borttag.'
  qbf-lang[21] = 'Flyttar nummer ~{1~} till position ~{2~}.'
  qbf-lang[22] = 'Tar bort nummer ~{1~}.'
  qbf-lang[23] = '[' + KBLABEL("GO") + '] f”r v„lja, ['
               + KBLABEL("INSERT-MODE") + '] f”r skifta, ['
               + KBLABEL("END-ERROR") + '] f”r sluta.'
  qbf-lang[24] = 'Skriver uppdaterat rapportbibliotek...'
/*a-info.p only:*/ /* 25..29 use format x(64) */
  qbf-lang[25] = 'Detta program visar inneh†llet i en specifik'
  qbf-lang[26] = 'anv„ndares lokala biblioteksfil, som visar vilka genererade'
  qbf-lang[27] = 'program som svarar mot varje definierad rapport, export,'
  qbf-lang[28] = 'etikett och s† vidare.'
  qbf-lang[29] = 'Ange med full s”kv„g namnet p† anv„ndarens ".qd" fil:'
  qbf-lang[30] = 'Hittar ej indikerad fil.'
  qbf-lang[31] = 'Du gl”mde ".qd" till„gget.'
  qbf-lang[32] = 'L„ser bibliotek...'.

RETURN.
