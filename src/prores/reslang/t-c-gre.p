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
/* t-c-eng.p - English language definitions for Scrolling Lists */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*
As of [Thu Apr 25 15:13:33 EDT 1991], this
is a list of the scrolling list programs:
  u-browse.i     c-print.p
  b-pick.p       i-pick.p
  c-entry.p      i-zap.p
  c-field.p      s-field.p
  c-file.p       u-pick.p
  c-flag.p       u-print.p
  c-form.p
*/

/* c-entry.p,c-field.p,c-file.p,c-form.p,c-print.p,c-vector.p,s-field.p */
ASSIGN
  qbf-lang[ 1] = '„§ ¢â¥«œ «¦ ˜¨®œå¦ š ˜ â¤à©ž ã §˜«ã©«œ ['
               + KBLABEL("END-ERROR") + '] š ˜ «â¢¦ª.'
  qbf-lang[ 2] = '˜«ã©«œ [' + KBLABEL("GO") + '] ˜­¦ç œ§ ¢â¥œ«œ,['
               + KBLABEL("INSERT-MODE") + '] š ˜ œ¤˜¢¢˜šã,['
               + KBLABEL("END-ERROR") + '] š ˜ «â¢¦ª.'
  qbf-lang[ 3] = '˜«ã©«œ [' + KBLABEL("END-ERROR")
               + '] ˜­¦ç œ§ ¢â¥œ«œ «˜ ˜¨®œå˜.'
  qbf-lang[ 4] = '˜«ã©«œ [' + KBLABEL("GO") + '] ˜­¦ç œ§ ¢â¥œ«œ, ['
               + KBLABEL("INSERT-MODE")
               + '] œ¤˜¢¢˜šã §œ¨ š¨./˜¨®./§¨æš¨.'
  qbf-lang[ 5] = '„« ¡â««˜/Ž¤¦£˜©å˜'
  qbf-lang[ 6] = 'œ¨ š¨˜­ã/Ž¤¦£˜©å˜-'
  qbf-lang[ 7] = '€¨®œå¦---,¨æš¨˜££˜,œ¨ š¨˜­ã'
  qbf-lang[ 8] = '€¤œç¨œ©ž «à¤ §œ›åà¤...'
  qbf-lang[ 9] = '„§ ¢¦šã œ›åà¤'
  qbf-lang[10] = '„§ ¢¦šã €¨®œå¦¬'
  qbf-lang[11] = '„§ ¢¦šã €¨®œå¦¬ £œ ©®â©ž'
  qbf-lang[12] = '„§ ¢¦šã ”æ¨£˜ª ¨¦™¦¢ãª'
  qbf-lang[13] = '„§ ¢¦šã ‹¦¤á›˜ª „¥æ›¦¬'
  qbf-lang[14] = '„¤à©ž' /* should match t-q-eng.p "Join" string */
  qbf-lang[16] = '        Database' /* max length 16 */
  qbf-lang[17] = '          €¨®œå¦' /* max length 16 */
  qbf-lang[18] = '           œ›å¦' /* max length 16 */
  qbf-lang[19] = '  ‹âš ©«¦ §¢ãŸ¦ª' /* max length 16 */
  qbf-lang[20] = '† « £ã'
  qbf-lang[21] = '¬§œ¨™˜å¤œ  «¦ §¢ãŸ¦ª ©«¦ ®œåà¤ «¦¬ §å¤˜¡˜ - 1 œàª'
  qbf-lang[22] = 'Œ˜ §¨¦©«œŸœå ©«¦ «â¢¦ª «¦¬ ¬§á¨®¦¤«˜ ˜¨®œå¦¬; '
  qbf-lang[23] = '€›ç¤˜«ž ž œ§ ¢¦šã £œ «¦ ©¬š¡œ¡¨ £â¤¦ §¨¦¦¨ ©£æ œ¥æ›¦¬'
  qbf-lang[24] = 'ƒé©«œ «ž¤ ¦¤¦£˜©å˜ «¦¬ ˜¨®œå¦¬ œ¥æ›¦¬'

               /* 12345678901234567890123456789012345678901234567890 */
  qbf-lang[27] = '€­ã©«â «¦ ¡œ¤æ š ˜ ¡˜«˜¡æ¨¬­¦ §å¤˜¡˜, ã ›é©«œ £å˜'
  qbf-lang[28] = '¢å©«˜ ©¬š¡œ¡¨ £â¤à¤ ©«¦ ®œåà¤ «¦¬ §å¤˜¡˜ (£œ«˜¥ç'
  qbf-lang[29] = '¡¦££á«à¤) š ˜ ¥œ®à¨ ©«âª ©«ã¢œª ©«ž¤ œ¡«ç§à©ž.'
  qbf-lang[30] = 'ƒé©«œ £å˜ ¢å©«˜ ©¬š¡œ¡¨ £â¤à¤ ©«¦ ®œåà¤ «¦¬ §å¤˜¡˜' 
  qbf-lang[31] = '(£œ«˜¥ç ¡¦££á«à¤) š ˜ §œ›å˜ ©œ ¥œ®à¨ ©«âª ©«ã¢œª.'
  qbf-lang[32] = 'ƒé©«œ «¦¤ ›œå¡«ž «¦¬ ©«¦ ®œå¦¬ «¦¬ §å¤˜¡˜.'.

RETURN.
