/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-d-eng.p - English language definitions for Data Export module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* d-edit.p,a-edit.p */
IF qbf-s = 1 THEN
/*
When entering codes, the following methods may be used:
  'x' - literal character enclosed in single quotes.
  ^x  - interpreted as control-character.
  ##h - one or two hex digits followed by the letter "h".
  ### - one, two or three digits, a decimal number.
  xxx - "xxx" is a symbol such as "lf" from the following table.
*/
  ASSIGN
    qbf-lang[ 1] = 'â¤˜ ©ç£™¦¢¦ æ§àª'
    qbf-lang[ 2] = '˜§æ «¦¤ §˜¨˜¡á«à §å¤˜¡˜.'
    qbf-lang[ 3] = '˜«ã©«œ [' + KBLABEL("GET")
                 + '] š ˜ œ§ ¢¦šã/˜¡ç¨à©ž œ§ ¢¦šãª «¦¬ €£œ©¦¬ Ž¨ ©£¦ç.'
    /* format x(70): */
    qbf-lang[ 4] = '‰˜«á «ž¤ œ ©˜šàšã ¡à› ¡é¤, «˜ §˜¨˜¡á«à ©¬¤› á¦¤«˜  '
                 + 'œ¢œçŸœ¨˜ :'
    /* format x(60): */
    qbf-lang[ 5] = '˜§¢æª ®˜¨˜¡«ã¨˜ª £â©˜ ©œ £¦¤á œ ©˜šàš ¡á.'
    qbf-lang[ 6] = 'œ¨£ž¤œçœ«˜  éª ®˜¨˜¡«ã¨˜ª œ¢âš®¦¬.'
    qbf-lang[ 7] = 'â¤˜ ã §˜¨˜§á¤à ›œ¡œ¥˜› ¡á ¯ž­å˜ ©¬¤ «¦ š¨á££˜ "h".'
    qbf-lang[ 8] = 'â¤˜, ›ç¦ ã «¨å˜ ¯ž­å˜, â¤˜ª ›œ¡˜› ¡æª ˜¨ Ÿ£æª.'
    qbf-lang[ 9] = 'œå¤˜  áš¤à©«¦ª ¡à› ¡æª. ˜¨˜¡˜¢é › ¦¨Ÿé©«â «¦.'
    qbf-lang[10] = '„§œ¥œ¨š˜©å˜ «à¤ ®˜¨˜¡«ã¨à¤ œ¢âš®¦¬ «¦¬ œ¡«¬§à«ã...'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = '€¨®. :,     :,     :,     :,     :'
    qbf-lang[ 2] = '’˜¥ ¤:'
    qbf-lang[ 3] = '‘«¦ ®œå˜ „¥˜šàšãª'
    qbf-lang[ 4] = '‘®œ›å˜©ž „¥˜šàšãª'
    qbf-lang[ 5] = 'œ›å˜:,      :,      :,      :,      :'
    qbf-lang[ 7] = ' ’ç§¦ª „¥˜šàšãª:'
    qbf-lang[ 8] = '„§ ¡œ­˜¢å›˜:'
    qbf-lang[ 9] = '(§¨é«ž œšš¨˜­ã= ¦¤¦£˜©åœª §œ›åà¤)'
    qbf-lang[10] = '  €¨®ã œšš¨˜­ãª:'
    qbf-lang[11] = ' ’â¢¦ª œšš¨˜­ãª:'
    qbf-lang[12] = ' Ž¨ ¦Ÿâ«žª œ›.:'
    qbf-lang[13] = 'ƒ ˜®à¨ ©«ãª œ›:'
    qbf-lang[14] = '† „¥˜šàšã ‘«¦ ®œåà¤ ›œ¤ ¬§¦©«ž¨åœ  «¦¬ª ¡˜«˜¡æ¨¬­¦¬ª '
                 + '§å¤˜¡œª. ‘«ž ©¬¤â®œ ˜, Ÿ˜ ˜­˜ ¨œŸ¦ç¤ ˜§æ «ž¤ œ¥˜šàšã.'
                 + '^‡â¢œ«œ ¤˜ ©¬¤œ®å©œ«œ; '
    qbf-lang[15] = '€›ç¤˜«ž ž œ¥˜šàšã ©«¦ ®œåà¤ ®à¨åª «¦¤ ¦¨ ©£æ §œ›åà¤.'
    qbf-lang[21] = 'ƒœ¤ â®œ«œ ˜¡¬¨é©œ  «ž¤ «¨â®¦¬©˜ £¦¨­ã „¥˜šàšãª. '
                 + '‡â¢œ«œ ¤˜ ©¬¤œ®å©œ«œ; '
    qbf-lang[22] = 'ƒž£ ¦¬¨šå˜ «¦¬ §¨¦š¨á££˜«¦ª „¥˜šàšãª...'
    qbf-lang[23] = '"Compile" «¦¬ §¨¦š¨á££˜«¦ª „¥˜šàšãª...'
    qbf-lang[24] = '„¡«â¢œ©ž «¦¬ §¨¦š¨á££˜«¦ª §¦¬ ›ž£ ¦¬¨šãŸž¡œ...'
    qbf-lang[25] = '€›ç¤˜«ž ž œ§ ¡¦ ¤à¤å˜ £œ «¦ ˜¨®œå¦/£¦¤á›˜'
    qbf-lang[26] = '€¨ Ÿ£æª „¥˜šà£â¤à¤ „šš¨˜­é¤ - ~{1~} .'
    qbf-lang[31] = '„§ ™œ™˜åà©ž œ§˜¤˜Ÿâ«ž©žª «à¤ ¨¬Ÿ£å©œà¤ œ¥˜šàšãª'
    qbf-lang[32] = '„§ ™œ™˜åà©ž œ¥æ›¦¬ ˜§æ ˜¬«ã «ž¤ œ¨š˜©å˜'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
/* this set contains only export formats.  Each is composed of the */
/* internal RESULTS id and the description.  The description must  */
/* not contain a comma, and must fit within format x(32).          */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'PROGRESS,„¥˜šàšã PROGRESS'
    qbf-lang[ 2] = 'ASCII   ,‚œ¤ ¡ã ASCII (Generic)'
    qbf-lang[ 3] = 'ASCII-H ,ASCII £œ œ§ ¡œ­.¦¤¦£˜©å˜ª §œ›å¦¬'
    qbf-lang[ 4] = 'FIXED   ,ASCII ©«˜Ÿœ¨¦ç £ã¡¦¬ª (SDF)'
    qbf-lang[ 5] = 'CSV     ,ƒ ˜®à¨ ©£â¤˜ £œ ¡æ££˜«˜ (CSV)'
    qbf-lang[ 6] = 'DIF     ,DIF'
    qbf-lang[ 7] = 'SYLK    ,SYLK'
    qbf-lang[ 8] = 'WS      ,WordStar'
    qbf-lang[ 9] = 'WORD    ,Microsoft Word'
    qbf-lang[10] = 'WORD4WIN,Microsoft Word š ˜ Windows'
    qbf-lang[11] = 'WPERF   ,WordPerfect'
    qbf-lang[12] = 'OFISW   ,CTOS/BTOS OfisWriter'
    qbf-lang[13] = 'USER    ,‰˜Ÿ¦¨ ©£â¤ž ˜§æ «¦¤ •¨ã©«ž'
    qbf-lang[14] = '*'. /* terminator for list */

/*--------------------------------------------------------------------------*/

RETURN.
