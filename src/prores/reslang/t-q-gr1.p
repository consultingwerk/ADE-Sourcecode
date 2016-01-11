/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-q-eng.p - English language definitions for Query module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Ž†¡ ƒ¤íŠ‡ˆ† †ÆÆ¤ ”è '' ä“š “  ˆ¤‚“è¤‚   ¡ ‘è“‡¢‡•.'
    qbf-lang[ 2] = 'àì¡‹‰‹ ÆÆ¤ ”ç¡,¡—¢‡,åÐ‹¢ì¡‹‰‹ ÆÆ¤ ”ç¡'
    qbf-lang[ 3] = '” ¡á‘‹¡“ ‚ ‰ ,à“‡¡  ¤öè,à“‹ “í‰‹•'
    qbf-lang[ 4] = 'Ž†¡ íö†“† ‹¤á¢†‚ ˆ‰†‚„á Æ‚'' ä“ “‹  ¤ö†á‹.'
    qbf-lang[ 5] = 'Ð‚ƒ†ƒ á—¢‡ „‚ Æ¤ ”è• “‡• †ÆÆ¤ ”è•'
    qbf-lang[ 6] = '' /* special total message: created from #7 or #8 */
    qbf-lang[ 7] = 'Ž‚ ˆ‹Ðè í“¤‡¢‡•.'
    qbf-lang[ 8] = 'Ø  ¤‚Š• „‚ Ší¢‚—¡ íÆÆ¤ ”ç¡ †á¡ ‚ '
    qbf-lang[ 9] = 'Þí“¤‡¢‡ †ÆÆ¤ ”ç¡...   Ñ “è¢“† [' + KBLABEL("END-ERROR")
                 + '] Æ‚  „‚ ˆ‹Ðè.'
    qbf-lang[10] = '¢‹ì“ ‚ †,†á¡ ‚ Þ‚ˆ¤“†¤‹  Ð,†á¡ ‚ Þ‚ˆ¤“†¤‹  Ð è á¢‹ †,'
                 + '†á¡ ‚ Þ†Æ ‰ì“†¤‹  Ð,†á¡ ‚ Þ†Æ ‰ì“†¤‹  Ð è á¢‹ †,'
                 + '„†¡ ¢‹ì“ ‚ †,µ¡“‚¢“‹‚ö†á †,µ¤öá‘†‚  Ð'
    qbf-lang[11] = 'Ž†¡ äÐš¤ö‹ä¡ „‚ Ší¢‚†• †ÆÆ¤ ”í•.'
    qbf-lang[13] = 'ö†“† ”“š¢†‚ è„‡ ¢“‡¡ Ð¤ç“‡ †ÆÆ¤ ”è “‹ä  ¤ö†á‹ä.'
    qbf-lang[14] = 'ö†“† ”“š¢†‚ è„‡ ¢“‡¡ “†‰†ä“ á  †ÆÆ¤ ”è “‹ä  ¤ö†á‹ä.'
    qbf-lang[15] = 'Ž†¡ íö†“† ‹¤á¢†‚ ™¤  Ñ¤‹ƒ‹‰è•.'
    qbf-lang[16] = 'Ñ¤‹ƒ‹‰í•'
    qbf-lang[17] = 'Ð‚‰íŒ“† “‡¡ ‹¡‹ ¢á  “‡• ™¤ • Ñ¤‹ƒ‹‰è•.'
    qbf-lang[18] = 'Ñ “è¢“† [' + KBLABEL("GO")
                 + '] è [' + KBLABEL("RETURN")
                 + '] Æ‚  †Ð‚‰‹Æè ”¤ •, è [' + KBLABEL("END-ERROR")
                 + '] Æ‚  “í‰‹•.'
    qbf-lang[19] = '™¤“—¢‡ “‡• ™¤ • Ñ¤‹ƒ‹‰è•...'
    qbf-lang[20] = '€ ™¤  Ñ¤‹ƒ‹‰è• (‹¤”è "compiled") ‰†áÐ†‚ Æ‚'' ä“ “‹ Ð¤Æ¤  . '
                 + 'ÞÐ‹¤†á ¡  ‹”†á‰†“ ‚ ¢“  †Œè• :^1) ‰šŠ‹• PROPATH,^2) ‰†áÐ†‚ '
                 + '“‹  ¤ö†á‹ Ñ¤‹ƒ‹‰è• .r , è^3) “‹  ¤ö†á‹  †á¡ ‚ "uncompiled" „‡‰ „è .p.^(Ž†á“† “‹ '
                 + ' ¤ö†á‹ <dbname>.ql Æ‚  ‡¡ì “  ‰šŠ‹ä• “‹ä "compiler").^^ÞÐ‹¤†á“† '
                 + '¡  ¢ä¡†öá¢†“†,  ‰‰š Ð‹¤†á ¡  Ð¤‹ˆ ‰í¢†‚ è¡ä  ‰šŠ‹ä• ¢ ¡ ¢ä¡íÐ†‚ . '
                 + 'Ôí‰†“† ¡  ¢ä¡†öá¢†“†; '
    qbf-lang[21] = 'åÐš¤ö†‚ í¡  ”á‰“¤‹ "WHERE" ¢“‡¡ “¤íö‹ä¢  ™¤  Ñ¤‹ƒ‹‰è• '
                 + 'Ð‹ä ‘‡“š “‚í• ¢“‡¡ ç¤  †ˆ“í‰†¢‡• (RUN-TIME). Ò “š “‡¡ '
                 + '¢äÆˆ†ˆ¤‚í¡‡ †¤Æ ¢á  —•, „†¡ äÐ‹¢“‡¤á‘†“ ‚. Ôí‰†“† ¡  '
                 + '¢ä¡†öá¢†“†  Æ¡‹ç¡“ • “‹ ”á‰“¤‹ WHERE; '
    qbf-lang[22] = 'Ñ “è¢“† [' + KBLABEL("GET")
                 + '] Æ‚  ¡  ‹¤á¢†“† „‚ ”‹¤†“‚ˆš Ð†„á   ¡†ì¤†¢‡•.'.

ELSE

IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Ð.,” ¡á‘†‚ “‡¡ †Ð†¡‡ †ÆÆ¤ ”è.'
    qbf-lang[ 2] = 'Ñ¤‹‡Æ.,” ¡á‘†‚ “‡¡ Ð¤‹‡Æ‹ì†¡‡ †ÆÆ¤ ”è.'
    qbf-lang[ 3] = 'Ñ¤ç“‡,” ¡á‘†‚ “‡¡ Ñ¤ç“‡ †ÆÆ¤ ”è.'
    qbf-lang[ 4] = 'â†‰†ä“.,” ¡á‘†‚ “‡¡ “†‰†ä“ á  †ÆÆ¤ ”è.'
    qbf-lang[ 5] = 'Öí ,Ñ¤‹¢Šèˆ‡ ¡í • †ÆÆ¤ ”è•.'
    qbf-lang[ 6] = 'Þ†“ ƒ.,Þ†“ ƒ‹‰è “‡• “¤íö‹ä¢ • †ÆÆ¤ ”è•.'
    qbf-lang[ 7] = 'µ¡“‚Æ¤.,µ¡“‚Æ¤ ”è “‡• “¤íö‹ä¢ • †ÆÆ¤ ”è• ¢† ¡í  †ÆÆ¤ ”è.'
    qbf-lang[ 8] = 'Ž‚ Æ¤ ”è,Ž‚ Æ¤ ”è “‡• “¤íö‹ä¢ • †ÆÆ¤ ”è•.'
    qbf-lang[ 9] = 'Ð‚‰‹Æè,Ð‚‰‹Æè š‰‰‡• ™¤ • Ñ¤‹ƒ‹‰è•.'
    qbf-lang[10] = 'µ¡†ì¤.,‚ˆ¡  “—¡ †ÆÆ¤ ”ç¡ † “  ˆ¤‚“è¤‚  Ð‹ä ‹¤á¢†“†'
    qbf-lang[11] = '¡—¢‡,¡ç¢‡ † †ÆÆ¤ ”í•  Ð š‰‰‹  ¤ö†á‹ Ð‹ä íö‹ä¡ ¢öí¢‡.'
    qbf-lang[12] = 'µ¡ ‘è“.,µ¡ ‘è“‡¢‡ † ˆ¤‚“è¤‚  †Ð‚‰‹Æè•.'
    qbf-lang[13] = 'ØÐ‹ä,Ð‚‰‹Æè †ÆÆ¤ ”ç¡ ˆ ‚ ‹¤‚¢• ¢ä¡Š‡ˆç¡ † “‹ ”á‰“¤‹ WHERE.'
    qbf-lang[14] = 'Þí“¤‡¢‡,µ¤‚Š• †ÆÆ¤ ”ç¡ ¢“‹ “¤íö‹¡ ¢ì¡‹‰‹ è äÐ‹¢ì¡‹‰‹.'
    qbf-lang[15] = 'â Œ‚¡.,Ðá‰‹Æ‡ „‚ ”‹¤†“‚ˆ‹ì ˆ‰†‚„‚‹ì.'
    qbf-lang[16] = '¤Æ ¢.,Ð‚‰‹Æè š‰‰‡• †¤Æ ¢á •.'
    qbf-lang[17] = 'Ñ‰‡¤‹”.,Ñ‰‡¤‹”‹¤á†• Æ‚  “  “¤íö‹¡“  ˆ¤‚“è¤‚  †Ð‚‰‹Æè•.'
    qbf-lang[18] = 'ž¤è¢“.,Ò‰è¢‡ Ð¤‹Æ¤š “‹• “‹ä ö¤è¢“‡.'
    qbf-lang[19] = 'âí‰‹•,âí‰‹•.'
    qbf-lang[20] = ''. /* terminator */

RETURN.
