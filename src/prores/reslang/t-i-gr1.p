/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-i-eng.p - English language definitions for Directory */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*i-dir.p,i-pick.p,i-zap.p,a-info.p,i-read.p*/
ASSIGN
  qbf-lang[ 1] = '†Œ Æ—Æè,graph,†“‚ˆí““ ,query,†ˆ“ìÐ—¢‡'
  qbf-lang[ 2] = 'Žç¢“† á  Ð†¤‚Æ¤ ”è “‡•'
  qbf-lang[ 3] = 'Ç‚  í¡ ¡  Ð “‹ä• Ð ¤ ˆš“— ‰Æ‹ä• †¤‚ˆš  ¤ö†á  
                  ˆ ‚/è Ð†„á  Ð ¤ ‰†áÐ‹¡“ ‚ :^'
               + '1) Ø‚  ¤ö‚ˆí• "database" „†¡ íö‹ä¡ ¢ä¡„†Š†á^'
               + '2) ö‹ä¡ Æá¡†‚ †“ ƒ‹‰í• “—¡ ‹¤‚¢ç¡ “‡• "database"^'
               + '3) Ž†¡ íö†“† „‚ˆ ‚ç “  Ð¤¢ƒ ¢‡•'
  qbf-lang[ 4] = '€ ‹¡‹ ¢á  “‡• ˆšŠ† ~{1~} Ð¤íÐ†‚ ¡  †á¡ ‚ ‹¡ „‚ˆè. Ñ ¤ ˆ ‰ç Œ ¡ „ç¢“†.'
  qbf-lang[ 5] = 'Ø¤‚‹  Ð‹Šèˆ†ä¢‡•  ¤ö†á—¡. Ñ ¤ ˆ ‰ç „‚ Æ¤š›“† †¤‚ˆš ! '
               + '€ „‚ Æ¤ ”è  Ð ˆšÐ‹‚‹ ˆ “š‰‹Æ‹ †¤Æ ¢á—¡ Š   Ð‹†‰†äŠ†¤ç¢†‚ öç¤‹.'
  qbf-lang[ 6] = 'Ñ†¤‚Æ¤ ”è,Database-,Ñ¤Æ¤  '
  qbf-lang[ 7] = 'Ð‚ƒ†ƒ á—¢‡ †Ð‚ˆš‰ä›‡• “‹ä  ¤ö†á‹ä'
  qbf-lang[ 8] = '†'
  qbf-lang[ 9] = 'Ð‚‰‹Æè'
  qbf-lang[10] = '‹¤”è• †Œ Æ—Æè•,graph,†“‚ˆí““ •,query,†ˆ“ìÐ—¢‡•'
  qbf-lang[11] = '‹¤”è• †Œ Æ—Æè•,graph,†“‚ˆí““ •,query,†ˆ“ìÐ—¢‡•'
  qbf-lang[12] = '‹¤”ç¡ †Œ Æ—Æè•,graph,†“‚ˆ†““ç¡,query,†ˆ“äÐç¢†—¡'
  qbf-lang[13] = 'Þ‹¤”í• Œ Æ—Æè•,graph,Þ‹¤”í• “‚ˆ†““ç¡,query,'
               + 'Ø¤‚¢‹á ˆ“äÐç¢†—¡'
  qbf-lang[14] = 'Æ‚  ™¤“—¢‡,Æ‚  µÐ‹Šèˆ†ä¢‡,Æ‚  Ž‚ Æ¤ ”è'
  qbf-lang[15] = 'ˆ“í‰†¢‡...'
  qbf-lang[16] = '™¤“—¢‡ ~{1~}  Ð š‰‰‹ ˆ “š‰‹Æ‹'
  qbf-lang[17] = 'µÐ‹Šèˆ†ä¢‡ ¡í • ~{1~}'
  qbf-lang[18] = '„†¡ „‚ “áŠ†“ ‚'
  qbf-lang[19] = 'Ø‰  “  †Ð‚‰†Æí¡  Š  „‚ Æ¤ ”‹ì¡. ['
               + KBLABEL('RETURN') + '] Æ‚  †Ð‚‰‹Æè/ ˆì¤—¢‡ †Ð‚‰‹Æè•.'
  qbf-lang[20] = 'Ñ “è¢“† [' + KBLABEL('GO') + ']  ”‹ì †Ð‚‰íŒ†“†, è ['
               + KBLABEL('END-ERROR') + '] Æ‚  “í‰‹• ö—¤á• „‚ Æ¤ ”è.'
  qbf-lang[21] = 'Þ†“ ˆá¡‡¢‡ “‹ä ~{1~} ¢“‡ Ší¢‡ ~{2~}.'
  qbf-lang[22] = 'Ž‚ Æ¤ ”è “‹ä ~{1~}.'
  qbf-lang[23] = '[' + KBLABEL("GO") + '] Æ‚  †Ð‚‰‹Æè, ['
               + KBLABEL("INSERT-MODE") + '] Æ‚  †¡ ‰‰ Æè, ['
               + KBLABEL("END-ERROR") + '] Æ‚  “í‰‹•.'
  qbf-lang[24] = 'Ž‡‚‹ä¤Æá  “‹ä ˆ “ ‰Æ‹ä ˆ“äÐç¢†—¡ † “‚• †“ ƒ‹‰í• ...'
/*a-info.p only:*/ /* 25..29 use format x(64) */
  qbf-lang[25] = 'µä“ “‹ Ð¤Æ¤   †” ¡á‘†‚ “  Ð†¤‚†ö†¡  “‹ä  ¤ö†á‹ä'
  qbf-lang[26] = 'à“‹‚ö†á—¡ ž¤è¢“‡  Ð “‹¡ ˆ “ ‰Æ “‹ä, „†áö¡‹¡“ • Ð‹‚š'
  qbf-lang[27] = '„‡‚‹ä¤Æ‡í¡  Ð¤‹Æ¤š “   ¡èˆ‹ä¡ ¢† Ð‹‚í• †ˆ“äÐç¢†‚•,'
  qbf-lang[28] = '†Œ Æ—Æí•,†“‚ˆí““†• ˆ‹ˆ.'
  qbf-lang[29] = 'Žç¢“† “‡¡ Ð‰è¤‡ ‹¡‹ ¢á  “‹ä "path" “‹ä  ¤ö†á‹ä ".qd" “‹ä ö¤è¢“‡:'
  qbf-lang[30] = 'Ž†¡ ƒ¤íŠ‡ˆ† “‹  ¤ö†á‹ Ð‹ä „ç¢†“†.'
  qbf-lang[31] = 'Ñ¤íÐ†‚ ¡  „ç¢†“† ˆ ‚ “‡¡ Ð¤‹íˆ“ ¢‡ “‡• ‹¡‹ ¢á • ".qd".'
  qbf-lang[32] = 'µ¡šÆ¡—¢‡ “‹ä ˆ “ ‰Æ‹ä...'.

RETURN.
