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
    qbf-lang[ 1] = 'í¡  ¢ìƒ‹‰‹ Ð—•'
    qbf-lang[ 2] = ' Ð “‹¡ Ð ¤ ˆš“— Ðá¡ ˆ .'
    qbf-lang[ 3] = 'Ñ “è¢“† [' + KBLABEL("GET")
                 + '] Æ‚  †Ð‚‰‹Æè/ ˆì¤—¢‡ †Ð‚‰‹Æè• “‹ä µ†¢‹ä Ø¤‚¢‹ì.'
    /* format x(70): */
    qbf-lang[ 4] = 'Ò “š “‡¡ †‚¢ Æ—Æè ˆ—„‚ˆç¡, “  Ð ¤ ˆš“— ¢ä¡„‚š‘‹¡“ ‚ '
                 + '†‰†ìŠ†¤  :'
    /* format x(60): */
    qbf-lang[ 5] = ' Ð‰• ö ¤ ˆ“è¤ • í¢  ¢† ‹¡š †‚¢ Æ—Æ‚ˆš.'
    qbf-lang[ 6] = '†¤‡¡†ì†“ ‚ ç• ö ¤ ˆ“è¤ • †‰íÆö‹ä.'
    qbf-lang[ 7] = 'í¡  è Ð ¤ Ðš¡— „†ˆ†Œ „‚ˆš ›‡”á  ¢ä¡ “‹ Æ¤š  "h".'
    qbf-lang[ 8] = 'í¡ , „ì‹ è “¤á  ›‡”á , í¡ • „†ˆ „‚ˆ•  ¤‚Š•.'
    qbf-lang[ 9] = '†á¡ ‚ šÆ¡—¢“‹• ˆ—„‚ˆ•. Ñ ¤ ˆ ‰ç „‚‹¤Šç¢“í “‹.'
    qbf-lang[10] = 'Ð†Œ†¤Æ ¢á  “—¡ ö ¤ ˆ“è¤—¡ †‰íÆö‹ä “‹ä †ˆ“äÐ—“è...'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'µ¤ö. :,     :,     :,     :,     :'
    qbf-lang[ 2] = 'â Œ‚¡:'
    qbf-lang[ 3] = 'à“‹‚ö†á  Œ Æ—Æè•'
    qbf-lang[ 4] = 'àö†„á ¢‡ Œ Æ—Æè•'
    qbf-lang[ 5] = 'Ñ†„á :,      :,      :,      :,      :'
    qbf-lang[ 7] = ' âìÐ‹• Œ Æ—Æè•:'
    qbf-lang[ 8] = 'Ð‚ˆ†” ‰á„ :'
    qbf-lang[ 9] = '(Ð¤ç“‡ †ÆÆ¤ ”è= ‹¡‹ ¢á†• Ð†„á—¡)'
    qbf-lang[10] = '  µ¤öè †ÆÆ¤ ”è•:'
    qbf-lang[11] = ' âí‰‹• †ÆÆ¤ ”è•:'
    qbf-lang[12] = ' Ø¤‚‹Ší“‡• Ñ†„.:'
    qbf-lang[13] = 'Ž‚ ö—¤‚¢“è• Ñ†„:'
    qbf-lang[14] = '€ Œ Æ—Æè à“‹‚ö†á—¡ „†¡ äÐ‹¢“‡¤á‘†‚ “‹ä• ˆ “ ˆ¤ä”‹ä• '
                 + 'Ðá¡ ˆ†•. à“‡ ¢ä¡íö†‚ , Š   ” ‚¤†Š‹ì¡  Ð “‡¡ †Œ Æ—Æè.'
                 + '^Ôí‰†“† ¡  ¢ä¡†öá¢†“†; '
    qbf-lang[15] = 'µ„ì¡ “‡ ‡ †Œ Æ—Æè ¢“‹‚ö†á—¡ ö—¤á• “‹¡ ‹¤‚¢ Ð†„á—¡.'
    qbf-lang[21] = 'Ž†¡ íö†“†  ˆä¤ç¢†‚ “‡¡ “¤íö‹ä¢  ‹¤”è Œ Æ—Æè•. '
                 + 'Ôí‰†“† ¡  ¢ä¡†öá¢†“†; '
    qbf-lang[22] = 'Ž‡‚‹ä¤Æá  “‹ä Ð¤‹Æ¤š “‹• Œ Æ—Æè•...'
    qbf-lang[23] = '"Compile" “‹ä Ð¤‹Æ¤š “‹• Œ Æ—Æè•...'
    qbf-lang[24] = 'ˆ“í‰†¢‡ “‹ä Ð¤‹Æ¤š “‹• Ð‹ä „‡‚‹ä¤ÆèŠ‡ˆ†...'
    qbf-lang[25] = 'µ„ì¡ “‡ ‡ †Ð‚ˆ‹‚¡—¡á  † “‹  ¤ö†á‹/‹¡š„ '
    qbf-lang[26] = 'µ¤‚Š• Œ Æ—í¡—¡ ÆÆ¤ ”ç¡ - ~{1~} .'
    qbf-lang[31] = 'Ð‚ƒ†ƒ á—¢‡ †Ð ¡ Ší“‡¢‡• “—¡ ¤äŠá¢†—¡ †Œ Æ—Æè•'
    qbf-lang[32] = 'Ð‚ƒ†ƒ á—¢‡ †Œ„‹ä  Ð  ä“è “‡¡ †¤Æ ¢á '.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
/* this set contains only export formats.  Each is composed of the */
/* internal RESULTS id and the description.  The description must  */
/* not contain a comma, and must fit within format x(32).          */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'PROGRESS,Œ Æ—Æè PROGRESS'
    qbf-lang[ 2] = 'ASCII   ,Ç†¡‚ˆè ASCII (Generic)'
    qbf-lang[ 3] = 'ASCII-H ,ASCII † †Ð‚ˆ†”.‹¡‹ ¢á • Ð†„á‹ä'
    qbf-lang[ 4] = 'FIXED   ,ASCII ¢“ Š†¤‹ì èˆ‹ä• (SDF)'
    qbf-lang[ 5] = 'CSV     ,Ž‚ ö—¤‚¢í¡  † ˆ “  (CSV)'
    qbf-lang[ 6] = 'DIF     ,DIF'
    qbf-lang[ 7] = 'SYLK    ,SYLK'
    qbf-lang[ 8] = 'WS      ,WordStar'
    qbf-lang[ 9] = 'WORD    ,Microsoft Word'
    qbf-lang[10] = 'WORD4WIN,Microsoft Word Æ‚  Windows'
    qbf-lang[11] = 'WPERF   ,WordPerfect'
    qbf-lang[12] = 'OFISW   ,CTOS/BTOS OfisWriter'
    qbf-lang[13] = 'USER    ,Ò Š‹¤‚¢í¡‡  Ð “‹¡ ž¤è¢“‡'
    qbf-lang[14] = '*'. /* terminator for list */

/*--------------------------------------------------------------------------*/

RETURN.
