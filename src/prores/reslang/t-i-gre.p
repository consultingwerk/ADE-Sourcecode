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
/* t-i-eng.p - English language definitions for Directory */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*i-dir.p,i-pick.p,i-zap.p,a-info.p,i-read.p*/
ASSIGN
  qbf-lang[ 1] = 'œ¥˜šàšã,graph,œ« ¡â««˜,query,œ¡«ç§à©ž'
  qbf-lang[ 2] = 'ƒé©«œ £å˜ §œ¨ š¨˜­ã «žª'
  qbf-lang[ 3] = '‚ ˜ â¤˜¤ ˜§æ «¦¬ª §˜¨˜¡á«à ¢æš¦¬ª £œ¨ ¡á ˜¨®œå˜ 
                  ¡˜ /ã §œ›å˜ §˜¨˜¢œå§¦¤«˜  :^'
               + '1) Ž  ˜¨® ¡âª "database" ›œ¤ â®¦¬¤ ©¬¤›œŸœå^'
               + '2) „®¦¬¤ šå¤œ  £œ«˜™¦¢âª «à¤ ¦¨ ©£é¤ «žª "database"^'
               + '3) ƒœ¤ â®œ«œ › ¡˜ é£˜«˜ §¨æ©™˜©žª'
  qbf-lang[ 4] = '† ¦¤¦£˜©å˜ «žª ¡áŸœ ~{1~} §¨â§œ  ¤˜ œå¤˜  £¦¤˜› ¡ã. ˜¨˜¡˜¢é ¥˜¤˜›é©«œ.'
  qbf-lang[ 5] = 'Ž¨ ¦ ˜§¦Ÿã¡œ¬©žª ˜¨®œåà¤. ˜¨˜¡˜¢é › ˜š¨á¯«œ £œ¨ ¡á ! '
               + '† › ˜š¨˜­ã ˜§æ ¡á§¦ ¦ ¡˜«á¢¦š¦ œ¨š˜©åà¤ Ÿ˜ ˜§¦œ¢œ¬Ÿœ¨é©œ  ®é¨¦.'
  qbf-lang[ 6] = 'œ¨ š¨˜­ã,Database-,¨æš¨˜££˜'
  qbf-lang[ 7] = '„§ ™œ™˜åà©ž œ§ ¡á¢¬¯žª «¦¬ ˜¨®œå¦¬'
  qbf-lang[ 8] = '£œ'
  qbf-lang[ 9] = '„§ ¢¦šã'
  qbf-lang[10] = '£¦¨­ãª œ¥˜šàšãª,graph,œ« ¡â««˜ª,query,œ¡«ç§à©žª'
  qbf-lang[11] = '£¦¨­ãª œ¥˜šàšãª,graph,œ« ¡â««˜ª,query,œ¡«ç§à©žª'
  qbf-lang[12] = '£¦¨­é¤ œ¥˜šàšãª,graph,œ« ¡œ««é¤,query,œ¡«¬§é©œà¤'
  qbf-lang[13] = '‹¦¨­âª „¥˜šàšãª,graph,‹¦¨­âª „« ¡œ««é¤,query,'
               + 'Ž¨ ©£¦å „¡«¬§é©œà¤'
  qbf-lang[14] = 'š ˜ ”æ¨«à©ž,š ˜ €§¦Ÿã¡œ¬©ž,š ˜ ƒ ˜š¨˜­ã'
  qbf-lang[15] = '„¡«â¢œ©ž...'
  qbf-lang[16] = '”æ¨«à©ž ~{1~} ˜§æ á¢¢¦ ¡˜«á¢¦š¦'
  qbf-lang[17] = '€§¦Ÿã¡œ¬©ž ¤â˜ª ~{1~}'
  qbf-lang[18] = '›œ¤ › ˜«åŸœ«˜ '
  qbf-lang[19] = 'Ž¢˜ «˜ œ§ ¢œš£â¤˜ Ÿ˜ › ˜š¨˜­¦ç¤. ['
               + KBLABEL('RETURN') + '] š ˜ œ§ ¢¦šã/˜¡ç¨à©ž œ§ ¢¦šãª.'
  qbf-lang[20] = '˜«ã©«œ [' + KBLABEL('GO') + '] ˜­¦ç œ§ ¢â¥œ«œ, ã ['
               + KBLABEL('END-ERROR') + '] š ˜ «â¢¦ª ®à¨åª › ˜š¨˜­ã.'
  qbf-lang[21] = '‹œ«˜¡å¤ž©ž «¦¬ ~{1~} ©«ž Ÿâ©ž ~{2~}.'
  qbf-lang[22] = 'ƒ ˜š¨˜­ã «¦¬ ~{1~}.'
  qbf-lang[23] = '[' + KBLABEL("GO") + '] š ˜ œ§ ¢¦šã, ['
               + KBLABEL("INSERT-MODE") + '] š ˜ œ¤˜¢¢˜šã, ['
               + KBLABEL("END-ERROR") + '] š ˜ «â¢¦ª.'
  qbf-lang[24] = 'ƒž£ ¦¬¨šå˜ «¦¬ ¡˜«˜¢æš¦¬ „¡«¬§é©œà¤ £œ « ª £œ«˜™¦¢âª ...'
/*a-info.p only:*/ /* 25..29 use format x(64) */
  qbf-lang[25] = '€¬«æ «¦ §¨æš¨˜££˜ œ£­˜¤åœ  «˜ §œ¨ œ®æ£œ¤˜ «¦¬ ˜¨®œå¦¬'
  qbf-lang[26] = '‘«¦ ®œåà¤ •¨ã©«ž ˜§æ «¦¤ ¡˜«˜¢æšæ «¦¬, ›œå®¤¦¤«˜ª §¦ á'
  qbf-lang[27] = '›ž£ ¦¬¨šž£â¤˜ §¨¦š¨á££˜«˜ ˜¤ã¡¦¬¤ ©œ §¦ âª œ¡«¬§é©œ ª,'
  qbf-lang[28] = 'œ¥˜šàšâª,œ« ¡â««œª ¡¦¡.'
  qbf-lang[29] = 'ƒé©«œ «ž¤ §¢ã¨ž ¦¤¦£˜©å˜ «¦¬ "path" «¦¬ ˜¨®œå¦¬ ".qd" «¦¬ ®¨ã©«ž:'
  qbf-lang[30] = 'ƒœ¤ ™¨âŸž¡œ «¦ ˜¨®œå¦ §¦¬ ›é©œ«œ.'
  qbf-lang[31] = '¨â§œ  ¤˜ ›é©œ«œ ¡˜  «ž¤ §¨¦â¡«˜©ž «žª ¦¤¦£˜©å˜ª ".qd".'
  qbf-lang[32] = '€¤áš¤à©ž «¦¬ ¡˜«˜¢æš¦¬...'.

RETURN.
