/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-r-eng.p - English language definitions for Reports module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
/*r-header.p*/
    qbf-lang[ 1] = 'Žç¢“† “‹ ˆ†á†¡‹ Æ‚  “‡¡'
    qbf-lang[ 2] = 'Ç¤ è' /* must be < 8 characters */
                   /* 3..7 are format x(64) */
    qbf-lang[ 3] = 'àä¡ ¤“è¢†‚• Æ‚  “‹ ˆ†á†¡‹ “‡• †Ð‚ˆ†” ‰á„ • ˆ ‚ '
                 + 'äÐ‹¢‡†á—¢‡•'
    qbf-lang[ 4] = '~{COUNT~}  Þ†“¤‡“è• †ÆÆ¤ ”ç¡      :  '
                 + '~{TIME~}  ë¤  †ˆˆá¡‡¢‡•'
    qbf-lang[ 5] = '~{TODAY~}  à‡†¤‚¡è ‡†¤‹‡¡á     :  '
                 + '~{NOW~}   â¤íö‹ä¢  ç¤ '
    qbf-lang[ 6] = '~{PAGE~}  µ¤‚Š. “¤íö‹ä¢ • ¢†‰á„ • :  '
                 + '~{USER~}  Ø¡‹  ž¤è¢“‡•'
    qbf-lang[ 7] = '~{VALUE <Ð†„á‹>~;<‹¤”è>~} Æ‚  Ð¤‹¢Šèˆ‡ Ð†„á—¡'
                 + ' (Ð “è¢“† [' + KBLABEL("GET") + '])'
    qbf-lang[ 8] = 'Ð‚‰‹Æè Ð†„á‹ä Æ‚  Ð ¤†ƒ‹‰è'
    qbf-lang[ 9] = 'Ñ “è¢“† [' + KBLABEL("GO") + ']  Ð‹Šèˆ†ä¢‡, ['
                 + KBLABEL("GET") + '] Ð¤‹¢Šèˆ‡ Ð†„á‹ä, ['
                 + KBLABEL("END-ERROR") + ']  ¡šˆ‰‡¢‡.'

/*r-total.p*/    /*"|---------------------------|"*/
    qbf-lang[12] = '¡  Æá¡‹ä¡ ‹‚ Ð¤šŒ†‚•:'
                 /*"|--------------------------------------------|"*/
    qbf-lang[13] = 'Ø“ ¡ ‡ “‚è “‹ä Ð†„á‹ä †“ ƒš‰‰†“ ‚:'
                 /*"|---| |---| |---| |---| |---|" */
    qbf-lang[14] = 'àì¡‹‰ Þí“¤. Ò “ç“ ÞíÆ‚¢ Þí¢‡ '
    qbf-lang[15] = 'Ç¤ è àä¡‰—¡'
    qbf-lang[16] = 'Ç‚  Ð†„á‹:'
    qbf-lang[17] = 'Ð‚‰‹Æè Ñ†„á‹ä Æ‚  µŠ¤‹‚¢ '

/*r-calc.p*/
    qbf-lang[18] = 'Ð‚‰‹Æè à“è‰‡• Æ‚  â¤íö‹¡ àì¡‹‰‹'
    qbf-lang[19] = 'Ð‚‰‹Æè à“è‰‡• Æ‚  Ñ‹¢‹¢“ “‹ä àä¡‰‹ä'
    qbf-lang[20] = 'â¤íö‹¡ àì¡‹‰‹'
    qbf-lang[21] = '% àä¡‰‹ä'
    qbf-lang[22] = 'µ‰” ¤‚Š‡“‚ˆ,€†¤‹‡¡á ,Ó‹Æ‚ˆ,åÐ‹‰‹Æ‚¢“‚ˆ,µ¤‚Š‡“‚ˆ'
    qbf-lang[23] = ''
    qbf-lang[24] = 'Žç¢“† “‡¡  ¤ö‚ˆè “á‡ Æ‚  “‹¡ †“¤‡“è'
    qbf-lang[25] = 'Žç¢“† “‹ ƒè   ìŒ‡¢‡• è  ¤¡‡“‚ˆè “‚è Æ‚   ” á¤†¢‡'
    qbf-lang[26] = 'Þ†“¤‡“í•'
    qbf-lang[27] = 'Þ†“¤‡“è•'
                 /*"------------------------------|"*/
    qbf-lang[28] = '        µ¤ö‚ˆè “‚è Æ‚  †“¤‡“è' /*right justify*/
    qbf-lang[29] = '  ¶è   ìŒ‡¢‡• Æ‚  ˆšŠ† †ÆÆ¤ ”è' /*right justify*/
    qbf-lang[32] = 'ö†“† è„‡ ‹¤á¢†‚ “‹¡ íÆ‚¢“‹  ¤‚Š ¢“‡‰ç¡.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN
/* r-space.p */  /*"------------------------------|  ---------|  |------"*/
    qbf-lang[ 1] = '            Ð‚‰‹Æè                â¤íö‹ä¢   Ñ¤‹“†‚¡'
    /* 2..8 must be less than 32 characters long */
    qbf-lang[ 2] = 'µ¤‚¢“†¤ Ð†¤‚Šç¤‚‹'
    qbf-lang[ 3] = 'Ò†¡š †“ Œì ¢“‡‰ç¡'
    qbf-lang[ 4] = 'µ¤ö‚ˆè Æ¤ è'
    qbf-lang[ 5] = 'Ç¤ í•  ¡  ¢†‰á„ '
    qbf-lang[ 6] = 'ˆ“ìÐ—¢‡ Æ¤ ç¡ š¡ '
    qbf-lang[ 7] = 'Ç¤ í• †“ Œì †Ð‚ˆ†”./ˆ†‚í¡‹ä'
    qbf-lang[ 8] = 'Ç¤ í• †“ Œì ˆ†‚í¡‹ä/åÐ‹¢‡.'
                  /*1234567890123456789012345678901*/
    qbf-lang[ 9] = 'Ž‚ ¢“è “ '
    qbf-lang[10] = 'Ñ¤íÐ†‚ ¡  Æá¡†“ ‚ ¢† ˆšŠ† Æ¤ è (1) íö¤‚ ˆ ‚ “‹ íÆ†Š‹• ¢†‰á„ •'
    qbf-lang[11] = 'Ž†¡ †Ð‚“¤íÐ‹¡“ ‚  ¤¡‡“‚ˆí• “‚í•'
    qbf-lang[12] = 'Ñ¤†Ð†‚ ¡   ¤öá¢†‚ ‡ †ˆ“ìÐ—¢‡  Ð‹ “‡ ¢“è‰‡ 1 ˆ ‚ Ðš¡—'
    qbf-lang[13] = '€ “‚è Ð¤íÐ†‚ ¡  †á¡ ‚ ¢† ‰‹Æ‚ˆš Ð‰ á¢‚  !'
    qbf-lang[14] = 'Ñ¤†Ð†á ¡   ¤öá¢†‚ ‡ †ˆ“ìÐ—¢‡  Ð “‡¡ Ð¤ç“‡ Æ¤ è ˆ ‚ ˆš“—'

/*r-set.p*/        /* format x(30) for 15..22 */
    qbf-lang[15] = 'F.  Þ‹¤”í• Ñ†„á—¡/Ø¡‹ ¢á†•'
    qbf-lang[16] = 'P.  Ñ¤‹çŠ‡¢‡ à†‰á„ •'
    qbf-lang[17] = 'T.  àäÆˆ†¡“¤—“‚ˆè ˆ“ìÐ—¢‡'
    qbf-lang[18] = 'S.  Ž‚ ¢“è “ '
    qbf-lang[19] = 'LH. µ¤‚¢“†¤è Ð‚ˆ†” ‰á„ '
    qbf-lang[20] = 'CH. Ò†¡“¤‚ˆè Ð‚ˆ†” ‰á„ '
    qbf-lang[21] = 'RH. Ž†Œ‚š Ð‚ˆ†” ‰á„ '
    qbf-lang[22] = 'LF. µ¤‚¢“†¤è åÐ‹¢‡†á—¢‡'
    qbf-lang[23] = 'CF. Ò†¡“¤‚ˆè åÐ‹¢‡†á—¢‡'
    qbf-lang[24] = 'RF. Ž†Œ‚š åÐ‹¢‡†á—¢‡'
    qbf-lang[25] = 'FO. Ð‚ˆ†” ‰á„  Ñ¤ç“‡• ¢†‰.'
    qbf-lang[26] = 'LO. åÐ‹¢‡†á—¢‡ â†‰†ä“. ¢†‰.'
    qbf-lang[32] = 'Ñ “è¢“† [' + KBLABEL("END-ERROR")
                 + ']  ”‹ì ˆš¡†“† “‚• †“ ƒ‹‰í•.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
    /* r-main.p,s-page.p */
    qbf-lang[ 1] = 'µ¤ö. :,     :,     :,     :,     :'
    qbf-lang[ 2] = 'â Œ‚¡:'
    qbf-lang[ 3] = 'à“‹‚ö†á  ˆ“ìÐ—¢‡•'
    qbf-lang[ 4] = 'àö†„á ¢‡ ˆ“ìÐ—¢‡•'
    qbf-lang[ 5] = '¢ä¡íö' /* for <<more and more>> */
    qbf-lang[ 6] = 'Ñ‰š“‹•,ˆ“ìÐ—¢‡•' /* each word comma-separated */
    qbf-lang[ 7] = '< ˆ ‚ > Æ‚  ‹¤‚‘¡“‚  ‹‰á¢Š‡¢‡  ¤‚¢“†¤š & „†Œ‚š'
    qbf-lang[ 8] = 'µ„ì¡ “‡ ‡ „‡‚‹ä¤Æá  †ˆ“ìÐ—¢‡• † Ð‰š“‹• Ðš¡—  Ð '
                 + '255 ö ¤ ˆ“è¤†•'
    qbf-lang[ 9] = 'Ž†¡ íö†“†  ˆä¤ç¢†‚ “‡¡ “¤íö‹ä¢  ˆ“ìÐ—¢‡. '
                 + 'Ôí‰†“† ¡  ¢ä¡†öá¢†“†; '
    qbf-lang[10] = 'Ž‡‚‹ä¤Æá  Ð¤‹Æ¤š “‹•...'
    qbf-lang[11] = '"Compile" “‹ä Ñ¤‹Æ¤š “‹• ˆ“ìÐ—¢‡•...'
    qbf-lang[12] = 'ˆ“í‰†¢‡ “‹ä Ð¤‹Æ¤š “‹• Ð‹ä „‡‚‹ä¤ÆèŠ‡ˆ†...'
    qbf-lang[13] = 'µ„ì¡ “‡ ‡ †Ð‚ˆ‹‚¡—¡á  † “‹  ¤ö†á‹/‹¡š„ '
    qbf-lang[14] = 'Ð‚ƒ†ƒ á—¢‡  ˆì¤—¢‡• “‹ä ‹¤‚¢‹ì “‡• “¤íö‹ä¢ • '
                 + 'ˆ“ìÐ—¢‡•'
    qbf-lang[15] = 'Ð‚ƒ†ƒ á—¢‡ †Œ„‹ä  Ð “‡¡ “¤íö‹ä¢  †¤Æ ¢á '
    qbf-lang[16] = 'Ñ “è¢“† ['
                 + (IF KBLABEL("CURSOR-UP") BEGINS "CTRL-" THEN 'CURSOR-UP'
                   ELSE KBLABEL("CURSOR-UP"))
                 + '] ˆ ‚ ['
                 + (IF KBLABEL("CURSOR-DOWN") BEGINS "CTRL-" THEN 'CURSOR-DOWN'
                   ELSE KBLABEL("CURSOR-DOWN"))
                 + '] Æ‚  ‹‰á¢Š‡¢‡, ['
                 + KBLABEL("END-ERROR") + '] Æ‚  “í‰‹•.'
    qbf-lang[17] = 'à†‰á„ '
    qbf-lang[18] = '~{1~} †ÆÆ¤ ”í• ¢“‡¡ †ˆ“ìÐ—¢‡.'
    qbf-lang[19] = 'µ„ì¡ “‡ ‡ „‡‚‹ä¤Æá  “‡• àäÆˆ†¡“¤—“‚ˆè• ˆ“ìÐ—¢‡• ö—¤á• “‹¡ ˆ Š‹¤‚¢ '
                 + '“‡• “ Œ‚¡‡¢‡• Ð†„á—¡.'
    qbf-lang[20] = 'µ„ì¡ “‡ ‡ „‡‚‹ä¤Æá  “‡• àäÆˆ†¡“¤—“‚ˆè• ˆ“ìÐ—¢‡• † '
                 + 'ˆ “ ˆ¤ä”‹ä• Ðá¡ ˆ†•.'
    qbf-lang[21] = 'Þ¡‹ µŠ¤‹á¢†‚•'
    qbf-lang[23] = 'µ„ì¡ “‡ ‡ „‡‚‹ä¤Æá  †ˆ“ìÐ—¢‡• ö—¤á• “‹¡ ‹¤‚¢ Ð†„á—¡.'.

ELSE

/*--------------------------------------------------------------------------*/
/* FAST TRACK interface test for r-ft.p r-ftsub.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = 'â‹ FAST TRACK „†¡ äÐ‹¢“‡¤á‘†‚ “‡ ¤‹è †Œ„‹ä Ð¤‹• “†¤ “‚ˆ “ ¡ '
    qbf-lang[ 2] = '‹ ö¤è¢“‡• ‹¤á‘†‚ “‚í• ¢“‡¡ ç¤  †ˆ“í‰†¢‡•. µ‰‰ Æè ¤‹è• †Œ„‹ä ¢“‹¡ PRINTER.'
    qbf-lang[ 3] = 'Ð†Œ†¤Æ ¢á  “—¡ †Ð‚ˆ†” ‰á„—¡/äÐ‹¢‡†‚ç¢†—¡...'
    qbf-lang[ 4] = 'Ž‡‚‹ä¤Æá  ‹š„—¡ †ÆÆ¤ ”ç¡...'
    qbf-lang[ 5] = 'Ž‡‚‹ä¤Æá  Ð†„á—¡ ˆ ‚  Š¤‹á¢†—¡...'
    qbf-lang[ 6] = 'Ž‡‚‹ä¤Æá   ¤ö†á—¡ ˆ ‚ ”á‰“¤  WHERE...'
    qbf-lang[ 7] = 'Ž‡‚‹ä¤Æá  †Ð‚ˆ†” ‰á„—¡ ˆ ‚ äÐ‹¢‡†‚ç¢†—¡...'
    qbf-lang[ 8] = 'Ž‡‚‹ä¤Æá  Æ¤ ç¡ “‡• †ˆ“ìÐ—¢‡•...'
    qbf-lang[ 9] = 'åÐš¤ö†‚ è„‡ á  †ˆ“ìÐ—¢‡ † ‹¡‹ ¢á  ~{1~} ¢“‹ FAST TRACK. '
                 + 'Ôí‰†“† ¡  “‡¡ †Ð‚ˆ ‰ì›†“†; '
    qbf-lang[10] = 'Ð‚ˆš‰ä›‡ †ˆ“ìÐ—¢‡•...'
    qbf-lang[11] = 'Ôí‰†“† ¡  †ˆ“†‰í¢†“† “‹ FAST TRACK; '
    qbf-lang[12] = 'Žç¢“† “‡¡ ‹¡‹ ¢á '
    qbf-lang[13] = 'â‹ FAST TRACK „†¡ äÐ‹¢“‡¤á‘†‚ TIME ¢† †Ð‚ˆ†” ‰á„†•/äÐ‹¢‡†‚ç¢†‚•, '
                 + ' ¡“‚ˆ “š¢“ ¢‡ † NOW.'
    qbf-lang[14] = 'â‹ FAST TRACK „†¡ äÐ‹¢“‡¤á‘†‚ “‹ Ð‹¢‹¢“ “‹ä ¢ä¡‰‹ä, “‹ Ð†„á‹ Ð ¤ ‰†áÐ†“ ‚'
    qbf-lang[15] = 'â‹ FAST TRACK „†¡ äÐ‹¢“‡¤á‘†‚ ~{1~} ¢† †Ð‚ˆ†” ‰á„ /äÐ‹¢‡†á—¢‡, '
                 + '~{2~} Ð ¤ ‰†áÐ†“ ‚.'
    qbf-lang[16] = '€ ‹¡‹ ¢á  †ˆ“ìÐ—¢‡• Ð‹¤†á ¡  Ð†¤‚íö†‚ ¡‹  ‰” ¤‚Š‡“‚ˆ‹ì• ö ¤ ˆ“è¤†• è '
                 + 'è "_"'
    qbf-lang[17] = 'Ø¡‹ ¢á  †ˆ“ìÐ—¢‡• ¢“‹ FAST TRACK:'
    qbf-lang[18] = '€ †ˆ“ìÐ—¢‡ „†¡ †“ ”í¤Š‡ˆ† ¢“‹ FAST TRACK'
    qbf-lang[19] = 'ˆ“í‰†¢‡ “‹ä FAST TRACK, Ð ¤ ˆ ‰ç Ð†¤‚í¡†“†...'
    qbf-lang[20] = 'Ð‚Ð‰í‹¡ šÆˆ‚¢“¤  ¢“‡¡ †Ð‚ˆ†” ‰á„ /äÐ‹¢‡†á—¢‡, '
                 + 'è †ˆ“ìÐ—¢‡ ŽÖ †“ ”í¤Š‡ˆ†.'
    qbf-lang[21] = 'â‹ FAST TRACK „†¡ äÐ‹¢“‡¤á‘†‚ ¡‹-Ð¤ç“‹/¡‹-“†‰†ä“ á‹ †Ð‚ˆ†” ‰á„†•.'
                 + 'Ñ ¤ ‰†áÐ†“ ‚.'
    qbf-lang[22] = 'Ñ¤‹¢‹öè: µ¤ö‚ˆè “‚è ~{1~} ö¤‡¢‚‹Ð‹‚èŠ‡ˆ† Æ‚  “‹¡ †“¤‡“è.'
    qbf-lang[23] = 'Ñ¥ž'
    qbf-lang[24] = 'TOTAL,COUNT,MAX,MIN,AVG'
    qbf-lang[25] = 'â‹ FAST TRACK „†¡ äÐ‹¢“‡¤á‘†‚ àäÆˆ†¡“¤—“‚ˆí• ˆ“äÐç¢†‚•.'
                 + 'H †ˆ“ìÐ—¢‡ ŽÖ †“ ”í¤Š‡ˆ†.'
    qbf-lang[26] = 'µ„ì¡ “‡ ‡ †“ ”‹¤š †ˆ“ìÐ—¢‡• ¢“‹ FAST TRACK ö—¤á• “‹¡ ‹¤‚¢ '
                 + ' ¤ö†á—¡ è Ð†„á—¡.'.


ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 5 THEN
  ASSIGN
    /* r-short.p */
    qbf-lang[ 1] = '€ àäÆˆ†¡“¤—“‚ˆè ˆ“ìÐ—¢‡ Ð ¤‹ä¢‚š‘†‚ ¡‹ “   Š¤‹‚¢“‚ˆš'
                 + '¢“‹‚ö†á . Þ† ƒš¢‡ “‹ “†‰†ä“ á‹ Ð†„á‹ ¢“‡ ‰á¢“  "â Œ‚¡‡¢‡•", '
                 + 'á  ¡í  Æ¤ è Š  “äÐç¡†“ ‚ ˆšŠ† ”‹¤š Ð‹ä ‡ “‚è “‹ä Ðí„‚‹ä '
                 + '“ Œ‚¡‡¢‡•  ‰‰š‘†‚.^Ç‚  “‡¡ ¢äÆˆ†ˆ¤‚í¡‡ †ˆ“ìÐ—¢‡, á  ¡í  Æ¤š‡ Š  '
                 + '“äÐç¡†“ ‚ ˆšŠ† ”‹¤š Ð‹ä “‹ Ð†„á‹ ~{1~}  ‰‰š‘†‚.^Ôí‰†“† ¡  ˆ Š‹¤á¢†“† '
                 + '“‡¡ †ˆ“ìÐ—¢‡ ç¢“† ¡  Ð ¤‹ä¢‚š‘†‚ ¡‹ “‚•  Š¤‹á¢†‚•; '
    qbf-lang[ 2] = 'Öµ'
    qbf-lang[ 3] = 'Øž'
    qbf-lang[ 4] = 'µ„ì¡ “‡ ‡ †Ð‚‰‹Æè "àäÆˆ†¡“¤—“‚ˆè ˆ“ìÐ—¢‡" ö—¤á• ¡  íö†“†'
                 + 'ˆ Š‹¤á¢†‚ Ð—• Š  Æá¡†‚ ‡ “ Œ‚¡‡¢‡ “ç¡ Ð†„á—¡.^^'
                 + 'Ð‚‰íŒ“† "â Œ‚¡‡¢‡"  Ð “‹ †¡‹ì ˆ“äÐç¢†—¡ ˆ ‚ †Ð‚‰íŒ“† '
                 + '“  Ð†„á , ‹¤á‘‹¡“ •  ìŒ‹ä¢  è ”Šá¡‹ä¢  ¢†‚¤š Æ‚  “‹ ˆ Ší¡  '
                 + 'ˆ ‚ †“š „ç¢“†  ä“è “‡¡ †Ð‚‰‹Æè Œ ¡š.'
    qbf-lang[ 5] = '€ ‰á¢“  Ð†¤‚íö†‚ ‰  “  Ð†„á  Ð‹ä íö†“† †Ð‚‰íŒ†‚ Æ‚  “‡¡ '
                 + '†ˆ“ìÐ—¢‡.'
    qbf-lang[ 6] = 'Ø  ¢“†¤á¢ˆ‹• „‡‰ç¡†‚ “‚ ¡‹ “   Š¤‹‚¢“‚ˆš ¢“‹‚ö†á  Š  '
                 + '†ˆ“äÐ—Š‹ì¡.'
    qbf-lang[ 7] = 'µ¡ †Ð‚‰íŒ†“†  ¤‚Š‡“‚ˆ Ðí„‚‹, í¡  äÐ‹¢ì¡‹‰‹ Š  †ˆ“äÐ—Š†á '
                 + 'ˆšŠ† ”‹¤š Ð‹ä ‡ “‚è “‹ä Ð†„á‹ä ~{1~}'
                 + ' ‰‰š‘†‚.'
    qbf-lang[ 8] = 'µ¡ †Ð‚‰íŒ†“† í¡  ‡- ¤‚Š‡“‚ˆ Ð†„á‹, í¡ • †“¤‡“è• Š  '
                 + '†ˆ“äÐ—Š†á „‡‰ç¡‹¡“ • “‹¡  ¤‚Š †ÆÆ¤ ”ç¡ ¢† ˆšŠ† ‹š„  “‹ä ~{1~}.'
    qbf-lang[ 9] = 'à† Ð†¤áÐ“—¢‡ Ð‹ä „†¡ †Ð‚‰íŒ†“† Ð†„á‹, ‡ “‚è “‹ä “†‰†ä“ á‹ä '
                 + 'Ð†„á‹ä “‡• ‹š„ • Š  †ˆ“äÐ—Š†á.'

    /* r-page.p */
    qbf-lang[26] = 'Ñ¤‹çŠ‡¢‡ à†‰á„ •'
    qbf-lang[27] = "ž—¤á• Ð¤‹çŠ‡¢‡ ¢†‰á„ •"

    qbf-lang[28] = 'Ø“ ¡ ˆšÐ‹‚  “‚è “—¡ Ð ¤ ˆš“— Ð†„á—¡'
    qbf-lang[29] = ' ‰‰š‘†‚, ‡ †ˆ“ìÐ—¢‡ Ð‹¤†á ¡  ¢ä¡†ö‚¢Š†á'
    qbf-lang[30] = '¢† á  ¡í  ¢†‰á„   ä“ “ .'
    qbf-lang[31] = 'Ð‚‰íŒ“† “‹ Ð†„á‹  Ð “‡ Ð ¤ ˆš“— ‰á¢“ '
    qbf-lang[32] = 'Ð‹ä Ší‰†“† “‡¡ Ð¤‹çŠ‡¢‡ “‡• ¢†‰á„ •.'.

/*--------------------------------------------------------------------------*/

RETURN.
