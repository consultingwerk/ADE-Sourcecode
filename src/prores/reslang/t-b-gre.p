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
/* t-b-eng.p - English language definitions for Build subsystem */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* b-build.p,b-again.p */
IF qbf-s = 1 THEN
  ASSIGN
                /* formats: x(10) x(45) x(8) */
    qbf-lang[ 1] = '¨æš¨˜££˜,"Database" ¡˜  €¨®œå¦,•¨æ¤¦ª'
    qbf-lang[ 2] = '’¦ ˜¨®œå¦ „¢âš®¦¬ (Checkpoint) ¡˜«˜©«¨á­ž¡œ. ƒ ˜š¨á¯«œ «¦ ˜¨®œå¦ .qc '
                 + '¡˜  ¡á¤«œ «ž¤ œš¡˜«á©«˜©ž ˜§æ «ž¤ ˜¨®ã.'
    qbf-lang[ 3] = '„§œ¥œ¨š˜©å˜ «¦¬'     /*format x(15)*/
    qbf-lang[ 4] = 'Compile'      /*format x(15)*/
    qbf-lang[ 5] = 'Re-Compiling'   /*format x(15)*/
    qbf-lang[ 6] = '„§œ¥œ¨š˜©å˜ «¦¬ ˜¨®œå¦¬,„§œ¥œ¨š˜©å˜ «žª ­æ¨£˜ª,„§œ¥œ¨š˜©å˜ §¨¦š¨á££˜«¦ª'
    qbf-lang[ 7] = 'Ž¢˜ «˜ œ§ ¢œš£â¤˜ ˜¨®œå˜ Ÿ˜ œš¡˜«˜©«˜Ÿ¦ç¤. ['
                 + KBLABEL("RETURN") + '] š ˜ œ§ ¢¦šã/˜¡ç¨à©ž œ§ ¢¦šãª.'
    qbf-lang[ 8] = '˜«ã©«œ [' + KBLABEL("GO") + '] ˜­¦ç œ§ ¢â¥œ«œ ã ['
                 + KBLABEL("END-ERROR") + '] š ˜ «â¢¦ª.'
    qbf-lang[ 9] = '€¤œç¨œ©ž ˜¨®œåà¤ š ˜ ›ž£ ¦¬¨šå˜ ˜¨® ¡ã ¢å©«˜ ”¦¨£é¤ ¨¦™¦¢ãª...'
    qbf-lang[10] = '„®œ«œ ¦¨å©œ  æ¢œª « ª ”¦¨£œª ¨¦™¦¢ãª; '
    qbf-lang[11] = '€¤œç¨œ©ž â££œ©à¤ œ¤à« ¡é¤ ©®â©œà¤ -OF.'
    qbf-lang[12] = '„§œ¥œ¨š˜©å˜ «žª ¢å©«˜ª „¤à« ¡é¤ ‘®â©œà¤.'
    qbf-lang[13] = 'ƒœ¤ œ¤«¦§å©«ž¡˜¤ æ¢œª ¦  „¤é©œ ª.'
    qbf-lang[14] = 'ƒ ˜š¨˜­ã «à¤ œ§ §¢â¦¤ ©«¦ ®œåà¤ «à¤ „¤à« ¡é¤ ‘®â©œà¤.'
    qbf-lang[15] = '„§ ™œ™˜åà©ž œ¥æ›¦¬'
    qbf-lang[16] = '‘¬¤¦¢ ¡æª ®¨¦¤¦ª,‹â©¦ª ®¨æ¤¦ª'
    qbf-lang[17] = '€¤áš¤à©ž «¦¬ ˜¨®œå¦¬ „¢âš®¦¬ (checkpoint)...'
    qbf-lang[18] = 'ƒž£ ¦¬¨šå˜ «¦¬ ˜¨®œå¦¬ „¢âš®¦¬ (checkpoint)...'
    qbf-lang[19] = 'ã›ž ¬§á¨®œ . €¤« ¡˜«á©«˜©ž £œ «¦'
    qbf-lang[20] = '„§˜¤œš¡˜«á©«˜©ž «¦¬ ˜¨®œå¦¬'
    qbf-lang[21] = '€¤œç¨œ©ž «žª ”¦¨£˜ª "~{1~}" š ˜ £œ«˜™¦¢âª.'
    qbf-lang[22] = '€›ç¤˜«ž ž œš¡˜«á©«˜©ž «žª ”¦¨£˜ª ®é¨ ª RECID ã UNIQUE INDEX '
    qbf-lang[23] = '† ”æ¨£˜ ›œ¤ á¢¢˜¥œ.'
    qbf-lang[24] = '›œ¤ ®¨œ áœ«˜  "recompiling".'
    qbf-lang[25] = 'ƒœ¤ ¬§á¨®¦¬¤ á¢¢˜ §œ›å˜ ©«ž ”æ¨£˜. ƒœ¤ ›ž£ ¦¬¨šãŸž¡œ † ”æ¨£˜.'
    qbf-lang[26] = 'ƒœ¤ ¬§á¨®¦¬¤ á¢¢˜ §œ›å˜ ©«ž ”æ¨£˜. † ¬§á¨®¦¬©˜ ”æ¨£˜ › ˜š¨á­ž¡œ.'
    qbf-lang[27] = '‘¬£§åœ©ž «žª ¢å©«˜ª ˜¨®œåà¤ §¨¦™¦¢ãª.'
    qbf-lang[28] = '‘¬¤¦¢ ¡æª ®¨æ¤¦ª'
    qbf-lang[29] = '’â¢¦ª!'
    qbf-lang[30] = '€§¦«¬®å˜ "Compile" «¦¬ "~{1~}".'
    qbf-lang[31] = 'ƒž£ ¦¬¨šå˜ «¦¬ ˜¨®œå¦¬ ˜¨˜£â«¨à¤ (config)'
    qbf-lang[32] = '„¤«¦§å©«ž¡˜¤ ŠáŸž ¡˜«á «ž¤ ­á©ž "œš¡˜«á©«˜©ž" ¡˜ /ã "compile".'
                 + '^^˜«ã©«œ ¡á§¦ ¦ §¢ã¡«¨¦ š ˜ ¤˜ ›œå«œ «¦  ©«¦¨ ¡æ ˜¨®œå¦ (query log file).'
                 + '† š¨˜££âª §¦¬ §œ¨ â®¦¬¤ «˜ ¢áŸž «¦¤å¦¤«˜ .'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN

/* b-misc.p */
    /* 1..10 for qbf-l-auto[] */
    qbf-lang[ 1] = 'onoma,*onoma*,eponymia,*eponymia*,Name'
    qbf-lang[ 2] = 'contact,*contact*,ypeythinos,yp*opsin,Address'
    qbf-lang[ 3] = '*odos,dieyth*,*dieythinsh,*dieythinsh*1,Address2'
    qbf-lang[ 4] = '*tax*thyrida*,*dieythinsh*2'
    qbf-lang[ 5] = '*dieythinsh*3,City'
    qbf-lang[ 6] = 'tax*kod*,*tax*kvd*,t*k*,St'
    qbf-lang[ 7] = 'polh,*polh*,Zip'
    qbf-lang[ 8] = 't*p,*tax*polh*,tk*polh,t*k*polh'
    qbf-lang[ 9] = 'nomos,*nomos*'
    qbf-lang[10] = '*xvra*,*xora*'

    qbf-lang[15] = 'ƒœåš£˜ ‹¦¨­ãª „¥˜šàšãª'.

/*--------------------------------------------------------------------------*/
RETURN.
