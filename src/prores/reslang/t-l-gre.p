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
/* t-l-eng.p - English language definitions for Labels module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* l-guess.p:1..5,l-verify.p:6.. */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = '€¤˜ã«© ©«¦ "~{1~}" £œ «¤ ¦¤¦£˜©å˜ §œ›å¦¬ "~{2~}" ...'
    qbf-lang[ 2] = 'ƒœ¤ ™¨âŸ¡˜¤ §â› ˜ ¡˜«á «¤ €¬«æ£˜« €¤˜ã«©.'
    qbf-lang[ 4] = 'ƒ£ ¦¬¨šå˜ «à¤ œ›åà¤ š ˜ « ª œ« ¡â««œª'
    qbf-lang[ 5] = '¤¦£˜,“§æ¯,ƒ œçŸ¬¤© #1,ƒ œçŸ¬¤© #2,ƒ œçŸ¬¤© #3,’.‰.,'
                 + 'æ¢,’.‰. ¡˜  æ¢ £˜å,Œ¦£æª,•é¨˜'

    qbf-lang[ 6] = '‚¨˜££ã ~{1~}: Šœå§œ /œ§ §¢â¦¤ áš¡ ©«¨¦.'
    qbf-lang[ 7] = '‚¨˜££ã ~{2~}: ƒœ¤ ™¨âŸ¡œ «¦ §œ›å¦ "~{1~}".'
    qbf-lang[ 8] = '‚¨˜££ã ~{2~}: ’¦ §œ›å¦ "~{1~}", ›œ¤ œå¤˜  «ç§¦¬ §å¤˜¡˜.'
    qbf-lang[ 9] = '‚¨˜££ã ~{2~}: ‘«¦ §œ›å¦ "~{1~}", §¢ãŸ¦ª - ~{3~} ¬§œ¨™˜å¤œ  «¦ £âš ©«¦ æ¨ ¦.'
    qbf-lang[10] = '‚¨˜££ã ~{2~}: ’¦ §œ›å¦ "~{1~}", §¨¦â¨®œ«˜  ˜§æ £-œ§ ¢œš£â¤¦ ˜¨®œå¦.'.

ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    /* each entry of 1 and also 2 must fit in format x(6) */
    qbf-lang[ 1] = '€¨®. :,     :,     :,     :,     :'
    qbf-lang[ 2] = '’˜¥ ¤:'
    qbf-lang[ 3] = '‘«¦ ®œå˜ „« ¡œ««é¤'
    qbf-lang[ 4] = '‘®œ›å˜© „« ¡œ««é¤'
    qbf-lang[ 5] = '„§ ¢¦šã œ›å¦¬'
    /*cannot change length of 6 thru 17, right-justify 6-11,13-14 */
    qbf-lang[ 6] = '€­˜å¨.‰œ¤é¤ ‚¨˜£:'
    qbf-lang[ 7] = ' €§æ §æ©œª ­¦¨âª:'
    qbf-lang[ 8] = ' ‘¬¤¦¢ ¡æ “¯¦ª:'
    qbf-lang[ 9] = 'á¤à œ¨ Ÿé¨ ¦:'
    qbf-lang[10] = '€§æ©«˜© £œ«˜¥ç „« ¡.:'
    qbf-lang[11] = '„©¦®ã €¨ ©.œ¨ Ÿà¨å¦¬:'
    qbf-lang[12] = '(§¢á«.)'
    qbf-lang[13] = '‰œå£œ¤¦ „« ¡.'
    qbf-lang[14] = '    ¡˜  œ›å˜'
    qbf-lang[15] = '€¨ Ÿ£æª           ' /* 15..17 used as group.   */
    qbf-lang[16] = '„« ¡œ««é¤         ' /*   do not change length, */
    qbf-lang[17] = '¡˜«á ¢á«¦ª: ' /*        but do right-justify  */
    qbf-lang[19] = 'ƒœ¤ â®œ«œ ˜¡¬¨é©œ  «¤ «¨â®¦¬©˜ œ« ¡â««˜. '
                 + '‡â¢œ«œ ¤˜ ©¬¤œ®å©œ«œ; '
    qbf-lang[20] = '’¦ ç¯¦ª «à¤ œ« ¡œ««é¤ œå¤˜  ~{1~}, ˜¢¢á â®œ«œ ¦¨å©œ  ~{2~} '
                 + 'š¨˜££âª £œ §œ›å˜ ¡˜  ¡œå£œ¤¦. ƒ¢˜›ã, £œ¨ ¡á ©«¦ ®œå˜ ›œ¤ '
                 + 'Ÿ˜ ®à¨â©¦¬¤ ¡˜  ©¬¤œ§éª, ›œ¤ Ÿ˜ œ¡«¬§àŸ¦ç¤. '
                 + '‡â¢œ«œ ¤˜ ©¬¤œ®å©œ«œ £œ «¤ œ¡«ç§à©; '
    qbf-lang[21] = 'ƒœ¤ ¬§á¨®¦¬¤ §â› ˜ ã ¡œå£œ¤¦ š ˜ «¤ œ¡«ç§à© !'
    qbf-lang[22] = 'ƒ£ ¦¬¨šå˜ «¦¬ §¨æš¨˜££˜«¦ª „¡«ç§à©ª „« ¡œ««é¤...'
    qbf-lang[23] = '"Compile" «¦¬ §¨æš¨˜££˜«¦ª „¡«ç§à©ª „« ¡œ««é¤...'
    qbf-lang[24] = '„¡«â¢œ© «¦¬ §¨¦š¨á££˜«¦ª §¦¬ ›£ ¦¬¨šãŸ¡œ...'
    qbf-lang[25] = '€›ç¤˜«  œ§ ¡¦ ¤à¤å˜ £œ «¦ ˜¨®œå¦/£¦¤á›˜'
    qbf-lang[26] = '€¨ Ÿ£æª œ¡«¬§à£â¤à¤ œ« ¡œ««é¤ - ~{1~} .'
    qbf-lang[27] = 'F. œ›å˜'
    qbf-lang[28] = 'A. „¤œ¨šá €¨®œå˜'
    qbf-lang[29] = '‡â¢œ«œ «¤ œ¡«â¢œ© «ª €¬«æ£˜«ª €¤˜ã«©ª œ›åà¤ '
                 + '˜§æ ˜¬«æ «¦ §¨æš¨˜££˜; '
    qbf-lang[31] = '„§ ™œ™˜åà© ˜¡ç¨à©ª «à¤ ¨¬Ÿ£å©œà¤'
    qbf-lang[32] = '„§ ™œ™˜åà© œ¥æ›¦¬ ˜§æ ˜¬«ã¤ «¤ œ¨š˜©å˜'.

ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = '„­''æ©¦¤ Ÿâ¢œ«œ > 1 œ« ¡â««˜ ¡˜«á §¢á«¦ª, «˜ ¡œ¤á §¨â§œ  > 0'
    qbf-lang[ 2] = '’¦ §á¤à §œ¨ Ÿé¨ ¦ ›œ¤ £§¦¨œå ¤˜ â®œ  ˜¨¤« ¡ã « £ã'
    qbf-lang[ 3] = '’¦ ©¬¤¦¢ ¡æ ç¯¦ª §¨â§œ  ¤˜ œå¤˜  > 1'
    qbf-lang[ 4] = '¨â§œ  ¤˜ ¬§á¨®œ  «¦¬¢á® ©«¦¤ £ ˜ œ« ¡â««˜ ¡˜«á §¢á«¦ª'
    qbf-lang[ 5] = '¨â§œ  ¤˜ œ¡«¬§àŸœå «¦¬¢á® ©«¦¤ ˜§æ £å˜ ­¦¨á'
    qbf-lang[ 6] = '’¦ ˜¨ ©«œ¨æ §œ¨ Ÿé¨ ¦ ›œ¤ £§¦¨œå ¤˜ â®œ  ˜¨¤« ¡ã « £ã'
    qbf-lang[ 7] = '† ¦¨ æ¤« ˜ ˜§æ©«˜© £œ«˜¥ã œ« ¡œ««é¤ §¨â§œ  ¤˜ œå¤˜  > 1'
    qbf-lang[ 8] = '‹œ«˜«æ§ © «à¤ š¨á££à¤ §¨¦ª «˜ §á¤à æ«˜¤ ¬§á¨®œ  ¡œ¤ã š¨˜££ã'
    qbf-lang[ 9] = '€¨ Ÿ£æª ¡œ¤é¤ š¨˜££é¤ ˜§æ «¤ ˜¨®ã £â®¨ «¦ ¡œå£œ¤¦'
    qbf-lang[10] = '’¦ ©¬¤¦¢ ¡æ ç¯¦ª «ª œ« ¡â««˜ª ©œ š¨˜££âª'
    qbf-lang[11] = 'æ©œª œ« ¡â««œª Ÿ˜ œ¡«¬§àŸ¦ç¤ ¡˜«á §¢á«¦ª'
    qbf-lang[12] = 'æ©œª ­¦¨âª Ÿ˜ œ¡«¬§àŸœå  ¡áŸœ œ« ¡â««˜'
    qbf-lang[13] = 'æ©˜ ¡œ¤á ˜§æ «¤ á¡¨ «ª œ« ¡â««˜ª £â®¨  «¦¤ §¨é«¦ ®˜¨˜¡«ã¨˜'
    qbf-lang[14] = '† ˜§æ©«˜© ˜§æ «¤ ˜¨ ©«œ¨ã á¡¨ £å˜ª œ« ¡â««˜ª ¡˜  «ª á¢¢ª'.
/*--------------------------------------------------------------------------*/

RETURN.
