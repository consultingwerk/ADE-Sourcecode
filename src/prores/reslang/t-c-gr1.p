/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
  qbf-lang[ 1] = 'Ð‚‰íŒ“† “‹  ¤ö†á‹ Æ‚  í¡—¢‡ è Ð “è¢“† ['
               + KBLABEL("END-ERROR") + '] Æ‚  “í‰‹•.'
  qbf-lang[ 2] = 'Ñ “è¢“† [' + KBLABEL("GO") + ']  ”‹ì †Ð‚‰íŒ†“†,['
               + KBLABEL("INSERT-MODE") + '] Æ‚  †¡ ‰‰ Æè,['
               + KBLABEL("END-ERROR") + '] Æ‚  “í‰‹•.'
  qbf-lang[ 3] = 'Ñ “è¢“† [' + KBLABEL("END-ERROR")
               + ']  ”‹ì †Ð‚‰íŒ†“† “   ¤ö†á .'
  qbf-lang[ 4] = 'Ñ “è¢“† [' + KBLABEL("GO") + ']  ”‹ì †Ð‚‰íŒ†“†, ['
               + KBLABEL("INSERT-MODE")
               + '] †¡ ‰‰ Æè Ð†¤‚Æ¤./ ¤ö./Ð¤Æ¤.'
  qbf-lang[ 5] = '“‚ˆí““ /Ø¡‹ ¢á '
  qbf-lang[ 6] = 'Ñ†¤‚Æ¤ ”è/Ø¡‹ ¢á -'
  qbf-lang[ 7] = 'µ¤ö†á‹---,Ñ¤Æ¤  ,Ñ†¤‚Æ¤ ”è'
  qbf-lang[ 8] = 'µ¡†ì¤†¢‡ “—¡ Ð†„á—¡...'
  qbf-lang[ 9] = 'Ð‚‰‹Æè Ñ†„á—¡'
  qbf-lang[10] = 'Ð‚‰‹Æè µ¤ö†á‹ä'
  qbf-lang[11] = 'Ð‚‰‹Æè µ¤ö†á‹ä † ¢öí¢‡'
  qbf-lang[12] = 'Ð‚‰‹Æè ™¤ • Ñ¤‹ƒ‹‰è•'
  qbf-lang[13] = 'Ð‚‰‹Æè Þ‹¡š„ • Œ„‹ä'
  qbf-lang[14] = '¡—¢‡' /* should match t-q-eng.p "Join" string */
  qbf-lang[16] = '        Database' /* max length 16 */
  qbf-lang[17] = '          µ¤ö†á‹' /* max length 16 */
  qbf-lang[18] = '           Ñ†„á‹' /* max length 16 */
  qbf-lang[19] = '  ÞíÆ‚¢“‹ Ð‰èŠ‹•' /* max length 16 */
  qbf-lang[20] = '€ “‚è'
  qbf-lang[21] = 'äÐ†¤ƒ á¡†‚ “‹ Ð‰èŠ‹• ¢“‹‚ö†á—¡ “‹ä Ðá¡ ˆ  - 1 †—•'
  qbf-lang[22] = 'Ö  Ð¤‹¢“†Š†á ¢“‹ “í‰‹• “‹ä äÐš¤ö‹¡“   ¤ö†á‹ä; '
  qbf-lang[23] = 'µ„ì¡ “‡ ‡ †Ð‚‰‹Æè † “‹ ¢äÆˆ†ˆ¤‚í¡‹ Ð¤‹‹¤‚¢ †Œ„‹ä'
  qbf-lang[24] = 'Žç¢“† “‡¡ ‹¡‹ ¢á  “‹ä  ¤ö†á‹ä †Œ„‹ä'

               /* 12345678901234567890123456789012345678901234567890 */
  qbf-lang[27] = 'µ”è¢“í “‹ ˆ†¡ Æ‚  ˆ “ ˆ¤ä”‹ Ðá¡ ˆ , è „ç¢“† á '
  qbf-lang[28] = '‰á¢“  ¢äÆˆ†ˆ¤‚í¡—¡ ¢“‹‚ö†á—¡ “‹ä Ðá¡ ˆ  (†“ Œì'
  qbf-lang[29] = 'ˆ‹š“—¡) Æ‚  Œ†ö—¤‚¢“í• ¢“è‰†• ¢“‡¡ †ˆ“ìÐ—¢‡.'
  qbf-lang[30] = 'Žç¢“† á  ‰á¢“  ¢äÆˆ†ˆ¤‚í¡—¡ ¢“‹‚ö†á—¡ “‹ä Ðá¡ ˆ ' 
  qbf-lang[31] = '(†“ Œì ˆ‹š“—¡) Æ‚  Ð†„á  ¢† Œ†ö—¤‚¢“í• ¢“è‰†•.'
  qbf-lang[32] = 'Žç¢“† “‹¡ „†áˆ“‡ “‹ä ¢“‹‚ö†á‹ä “‹ä Ðá¡ ˆ .'.

RETURN.
