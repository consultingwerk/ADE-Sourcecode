/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-a-eng.p - English language definitions for Admin module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/*results.p,s-module.p*/
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Q. Ñ¤‹ƒ‹‰í•'
    qbf-lang[ 2] = 'R. ˆ“äÐç¢†‚•'
    qbf-lang[ 3] = 'L. “‚ˆ†““/”‹•'
    qbf-lang[ 4] = 'D. Œ Æ—Æè'
    qbf-lang[ 5] = 'U. ž¤è¢“‡•'
    qbf-lang[ 6] = 'A. Ž‚ ö†á¤‚¢‡'
    qbf-lang[ 7] = 'E. Œ‹„‹•'
    qbf-lang[ 8] = 'F. FAST TRACK'
    qbf-lang[10] = 'â‹  ¤ö†á‹' /*DBNAME.qc*/
    qbf-lang[11] = '„†¡ ƒ¤íŠ‡ˆ†. µä“ ¢‡ á¡†‚ “‚ Š  Ð¤íÐ†‚ ¡  ˆš¡†“† "µ¤ö‚ˆè'
                 + ' Æˆ “š¢“ ¢‡" “‡• "database". Ôí‰†“† ¡  “‹ ˆš¡†“† “ç¤ ; '
    qbf-lang[12] = 'Ð‚‰íŒ“† š‰‰‡ †¤Æ ¢á  è Ð “è¢“† [' + KBLABEL("END-ERROR")
                 + '] Æ‚  ¡  Ð ¤ †á¡†“† †„ç.'
    qbf-lang[13] = 'Ž†¡ íö†“†  Æ‹¤š¢†‚ “‹ RESULTS.  â‹ Ñ¤Æ¤   “†‰†á—¢†'
    qbf-lang[14] = 'Ð‚ƒ†ƒ á—¢‡ †Œ„‹ä  Ð "~{1~}"'
    qbf-lang[15] = 'Þ€-µåâØÞ,€ÞµåâØÞ,µåâØÞµâØ'
    qbf-lang[16] = 'Ž†¡ äÐš¤ö†‚ ¢ì¡„†¢‡ † "database".'
    qbf-lang[17] = 'µ„ì¡ “‡ ‡ †ˆ“í‰†¢‡ “ ¡ á  DB íö†‚ †¡ ‰‰ ˆ“‚ˆè (logical) '
                 + '‹¡‹ ¢á  Ð‹ä  ¤öá‘†‚  Ð "QBF$".'
    qbf-lang[18] = 'âí‰‹•'
    qbf-lang[19] = '** â‹ RESULTS Ð¤‹ƒ‰‡ “á‘†“ ‚ **^^à“‹¡ ˆ “š‰‹Æ‹ ~{1~}, '
                 + '‹ì“† “‹ ~{2~}.db ‹ì“† “‹  ~{2~}.qc „†¡ ƒ¤íŠ‡ˆ ¡. â‹ ~{3~}.qc'
                 + ' äÐš¤ö†‚ ¢“‹ PROPATH,  ‰‰š ” á¡†“ ‚ “‚  ¡èˆ†‚ ¢“‹ '
                 + '~{3~}.db. Ñ ¤ ˆ ‰ç, „‚‹¤Šç¢“† “‹ PROPATH è †“‹¡‹š¢“†/„‚ Æ¤š›“†'
                 + ' “‹ ~{3~}.db ˆ ‚ .qc.'
    /* 24,26,30,32 available if necessary */
    qbf-lang[21] = '         åÐš¤ö‹ä¡ “¤†á• “¤Ð‹‚ Æ‚  ¡  †Æˆ “ ¢“è¢†“† ™¤†• Ñ¤‹ƒ‹‰è• Æ‚  '
                 + 'PROGRESS'
    qbf-lang[22] = '         RESULTS.  µ”‹ì “‹ RESULTS íö†‚ †Æˆ “ ¢“è¢†‚ “‚• '
                 + '™¤†• Ñ¤‹ƒ‹‰è•,'
    qbf-lang[23] = '         Ð‹¤†á“† ¡  “‚• Ð ¤ †“¤‹Ð‹‚è¢†“†, Ð‹“† Ší‰†“†.'
    qbf-lang[24] = 'Ôí‰†“† ¡  ‹¤á¢†“† “‚• Ð ¤ í“¤‹ä• †¢†á•, Æ‚  “‡ ˆšŠ†' 
    qbf-lang[25] = '™¤  Ñ¤‹ƒ‹‰è•.'
    qbf-lang[27] = 'ö‹¡“ • ‹¤á¢†‚ †¢†á• í¡  äÐ‹¢ì¡‹‰‹ †ÆÆ¤ ”ç¡  Ð “   ¤ö†á '
    qbf-lang[28] = '“—¡ ¢ä¡„†„†í¡—¡ "database", “‹ RESULTS „‡‚‹ä¤Æ†á ™¤†•' 
    qbf-lang[29] = 'Ñ¤‹ƒ‹‰è• ¡‹ Æ‚   ä“š “  †Ð‚‰†Æí¡   ¤ö†á .'
    qbf-lang[31] = 'â‹ RESULTS „‡‚‹ä¤Æ†á ‰†• “‚• ™¤†• Ñ¤‹ƒ‹‰è•  ä“ “ .'.


/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-user.p*/
IF qbf-s = 2 THEN
  /* format x(72) for 1,2,9-14,19-22 */
  ASSIGN
    qbf-lang[ 1] = 'Žç¢“† “‡¡ ‹¡‹ ¢á  “‹ä †¡¢— “—í¡‹ä  ¤ö†á‹ä (Include) Ð‹ä Š '
    qbf-lang[ 2] = 'ö¤‡¢‚‹Ð‹‚‡Š†á ¢“‡¡ †Ð‚‰‹Æè "µ¡†ì¤†¢‡" ˆ “š “‡¡ †¤Æ ¢á  Ñ¤‹ƒ‹‰è•.'
    qbf-lang[ 3] = '   Ñ¤‹“†‚¡†¡‹ Include:' /*format x(24)*/

    qbf-lang[ 8] = 'â‹ Ð¤Æ¤   „†¡ ƒ¤íŠ‡ˆ†'

    qbf-lang[ 9] = 'Žç¢“† “‡¡ ‹¡‹ ¢á  “‹ä Ð¤‹Æ¤š “‹• †‚¢ Æ—Æè•. â‹ Ð¤Æ¤   '
                 + 'Ð‹¤†á ¡  '
    qbf-lang[10] = '†á¡ ‚ á   Ð‰è ‹Š¡‡ †‚¢ Æ—Æè• è Ð¤Æ¤   †‚¢„‹ä Ð—• '
                 + '“‹ login.p'
    qbf-lang[11] = 'Ð‹ä äÐš¤ö†‚ ¢“‹¡ ˆ “š‰‹Æ‹ "DLC". µä“ “‹ Ð¤Æ¤   †ˆ“†‰†á“ ‚ '
                 + '‰‚• '
    qbf-lang[12] = '„‚ ƒ ¢“†á ‡ Æ¤ è "signon="  Ð “‹  ¤ö†á‹ DBNAME.qc.'
    qbf-lang[13] = 'Žç¢“† “‡¡ ‹¡‹ ¢á  “‹ä Ð¤‹£¡“‹• Ð‹ä Š  †” ¡á‘†“ ‚ '
    qbf-lang[14] = '¢“‹  ¤ö‚ˆ †¡‹ì.'
    qbf-lang[15] = '    Ñ¤Æ¤   ‚¢ Æ—Æè•:' /*format x(24)*/
    qbf-lang[16] = '     Ø¡‹ ¢á  Ñ¤‹£¡“‹•:' /*format x(24)*/
    qbf-lang[17] = 'Ñ¤‹“†‚¡†¡  :'

    qbf-lang[18] = 'PROGRESS Ñ¤Æ¤   ž¤è¢“‡:'
    qbf-lang[19] = 'â‹ Ð¤Æ¤   †ˆ“†‰†á“ ‚ Ð‹“† „á¡†“ ‚ “‡¡ †Ð‚‰‹Æè "ž¤è¢“‡•" '
                 + ' Ð †¡‹ì.'

    qbf-lang[20] = '„ç, Ð‹¤†á“† ¡  ˆ Š‹¤á¢†“† í¡  Ð¤Æ¤   †Œ Æ—Æè• ¢“‹‚ö†á—¡ “‹ä '
    qbf-lang[21] = 'ö¤è¢“‡. Ñ ¤ ˆ ‰ç „ç¢“† “‡¡ ‹¡‹ ¢á  “‹ä Ð¤‹Æ¤š “‹• ˆ ‚ “‡ Ð†¤‚Æ¤ ”è'
    qbf-lang[22] = '“‹ä Æ‚  “‹ †¡‹ì "Œ Æ—Æè ¢“‹‚ö†á—¡ - ¥äŠá¢†‚•".'
    qbf-lang[23] = 'Ñ¤Æ¤  :'
    qbf-lang[24] = 'Ñ†¤‚Æ¤ ”è:'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-load.p:*/
IF qbf-s = 3 THEN
  ASSIGN
    /* menu strip for d-main.p,l-main.p,r-main.p */
    qbf-lang[ 1] = '™¤“.,™¤“—¢‡ á • ~{1~}.'
    qbf-lang[ 2] = 'µÐ‹Š.,µÐ‹Šèˆ†ä¢‡ “‡• “¤íö‹ä¢ • ~{1~}.'
    qbf-lang[ 3] = 'ˆ“í‰.,ˆ“í‰†¢‡ “‡• “¤íö‹ä¢ • ~{1~}.'
    qbf-lang[ 4] = 'Ø¤‚¢.,Ð‚‰‹Æè  ¤ö†á—¡ ˆ ‚ Ð†„á—¡.'
    qbf-lang[ 5] = '¥äŠ.,µ‰‰ Æè “ìÐ‹ä, ‹¤”è• è ¢ö†„á ¢‡• “‡• “¤íö‹ä¢ • ~{1~}.'
    qbf-lang[ 6] = 'ØÐ‹ä,Ð‚‰‹Æè †ÆÆ¤ ”ç¡ ˆ ‚ ‹¤‚¢• ¢ä¡Š‡ˆç¡ † “‹ ”á‰“¤‹ WHERE.'
    qbf-lang[ 7] = 'â Œ‚¡.,µ‰‰ Æè “‡• ¢†‚¤š• “ Œ‚¡‡¢‡• “—¡ †ÆÆ¤ ”ç¡.'
    qbf-lang[ 8] = 'µˆì¤.,µˆì¤—¢‡ “‡• “¤íö‹ä¢ • ~{1~}.'
    qbf-lang[ 9] = 'Ñ‰‡¤.,Ñ‰‡¤‹”‹¤á†• Æ‚  “‚• “¤íö‹ä¢ • ¤äŠá¢†‚•.'
    qbf-lang[10] = '¤Æ.,Ð‚‰‹Æè š‰‰‡• †¤Æ ¢á •.'
    qbf-lang[11] = 'ž¤è¢.,ˆ“í‰†¢‡ Ð¤‹Æ¤š “‹• Ð‹ä ‹¤á‘†“ ‚  Ð “‹¡ ö¤è¢“‡.'
    qbf-lang[12] = 'âí‰‹•,âí‰‹•.'
    qbf-lang[13] = '' /* terminator */
    qbf-lang[14] = '†Œ Æ—Æè•,†“‚ˆí““ •,†ˆ“ìÐ—¢‡•'

    qbf-lang[15] = 'µ¡šÆ¡—¢‡ “‹ä  ¤ö†á‹ä Ñ ¤ í“¤—¡ àä¢“è “‹•...'

    /* system values for CONTINUE Must be <= 12 characters */
    qbf-lang[18] = '  àä¡íö†‚ ' /* for error dialog box */
    qbf-lang[19] = '‰‰‡¡‚ˆš (928)' /* this name of this language */
    /* word "of" for "xxx of yyy" on scrolling lists */
    qbf-lang[20] = ' Ð'
    /* standard product name */
    qbf-lang[22] = 'PROGRESS RESULTS'
    /* system values for descriptions of calc fields */
    qbf-lang[23] = ',â¤íö‹¡ àì¡‹‰‹,Ñ‹¢‹¢“ “‹ä àä¡‰‹ä,Þ†“¤‡“è•,Ñ¤šŒ‡ † µ‰” ¤‚Š‡“‚ˆš,'
                 + 'Ñ¤šŒ‡ † €†¤‹‡¡á†•,Ñ¤šŒ‡ † µ¤‚Š‡“‚ˆš,Ó‹Æ‚ˆí• Ñ¤šŒ†‚•,Ò “ ˆ¤ä”‹• Ñá¡ ˆ •'
    /* system values for YES and NO.  Must be <= 8 characters each */
    qbf-lang[24] = '  Ö ‚  ,  Øö‚  ' /* for yes/no dialog box */

    qbf-lang[25] = 'Æ‚¡† „‚ ˆ‹Ðè ˆ “š “‡¡ µä“ “‡ Æˆ “š¢“ ¢‡.  '
                 + 'Ö  ¢ä¡†öá¢†‚ ‡ µä“ “‡ Æˆ “š¢“ ¢‡; '

    qbf-lang[26] = '* Ñ¥ØàØž€ - Ž‚ ”‹¤†“‚ˆí• †ˆ„¢†‚• *^^€ “¤íö‹ä¢  íˆ„‹¢‡ †á¡ ‚ '
                 + '<~{1~}> †¡ç ‡ íˆ„‹¢‡ ¢“‹  ¤ö†á‹ .qc †á¡ ‚ <~{2~}>.  ÞÐ‹¤†á '
                 + '¡  äÐš¤ö‹ä¡ Ð¤‹ƒ‰è “  ç¢Ð‹ä ¡  Œ ¡ „‡‚‹ä¤Æè¢†“† “‚• ™¤†• '
                 + 'Ñ¤‹ƒ‹‰è• † “‡¡ †Ð‚‰‹Æè "Ð ¡†Æˆ “š¢“ ¢‡ ” ¤‹Æè•".'

    qbf-lang[27] = '* Ñ¥ØàØž€ - Ó†áÐ‹ä¡ "Database" *^^Ø‚ †Œè• "database" '
                 + 'ö¤†‚š‘‹¡“ ‚  ‰‰š „†¡ íö‹ä¡ ¢ä¡„†Š†á :'

    qbf-lang[32] = '* Ñ¥ØàØž€ - € „‹è “‡• DB íö†‚  ‰‰šŒ†‚ *^^€ „‡ š‰‰ Œ† '
                 + ' ”‹ì †Æˆ “ ¢“šŠ‡ˆ ¡ ™¤†• Ñ¤‹ƒ‹‰è•.  '
                 + 'Ñ ¤ ˆ ‰ç ö¤‡¢‚‹Ð‹‚è¢“† “‡¡ †Ð‚‰‹Æè "Ð ¡†Æˆ “š¢“ ¢‡ ” ¤‹Æè•" '
                 + ' Ð “‹ †¡‹ì „‚ ö†á¤‚¢‡• ¢ä¢“è “‹•.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-main.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = " A. Ð ¡†Æˆ “š¢“ ¢‡ ” ¤‹Æè•"
    qbf-lang[ 2] = " F. Ø¤‚¢‹á ™‹¤ç¡ Æ‚  Ñ¤‹ƒ‹‰í•"
    qbf-lang[ 3] = " R. àöí¢†‚• Þ†“ Œì µ¤ö†á—¡"

    qbf-lang[ 4] = " C. Ñ†¤‚†ö†¡  Ò “ ‰Æ‹ä ž¤è¢“‡"
    qbf-lang[ 5] = " H. â¤Ð‹• Œ„‹ä  Ð ” ¤‹Æè"
    qbf-lang[ 6] = " M. Ñ¤‹¢ƒš¢†‚• ¤Æ ¢‚ç¡"
    qbf-lang[ 7] = " Q. Ñ¤‹¢ƒš¢†‚• Ñ¤‹ƒ‹‰ç¡"
    qbf-lang[ 8] = " S. Ñ¤Æ¤   ‚¢ Æ—Æè•/Ñ¤‹£¡"

    qbf-lang[11] = " G. Ç‰ç¢¢ "
    qbf-lang[12] = " P. Ø¤‚¢• ˆ“äÐ—“ç¡"
    qbf-lang[13] = " T. ž¤ç “  ØŠ¡‡• â†¤ “‚ˆ‹ì"

    qbf-lang[14] = " B. Ñ¤Æ¤   µ¡†ì¤†¢‡•(Ñ¤‹ƒ‹‰í•)"
    qbf-lang[15] = " D. Ñ ¤š†“¤‹‚ ˆ“äÐç¢†—¡"
    qbf-lang[16] = " E. Ñ¤Æ¤   Œ Æ—Æè• à“‹‚ö†á—¡"
    qbf-lang[17] = " L. Ð‚‰‹Æè Ñ†„á—¡ Æ‚  “‚ˆí““†•"
    qbf-lang[18] = " U. Ø¤‚¢• Ñ¤‹Æ¤š “‹• ž¤è¢“‡"

    qbf-lang[21] = 'Ð‚‰íŒ“† †¤Æ ¢á  è [' + KBLABEL("END-ERROR")
                 + '] Æ‚  “í‰‹• ˆ ‚  Ð‹Šèˆ†ä¢‡ †“ ƒ‹‰ç¡.'
    /* these next four have a length limit of 20 including colon */
    qbf-lang[22] = 'µ¤ö†á :'
    qbf-lang[23] = 'Ñ ¤š†“¤‹‚:'
    qbf-lang[24] = 'µ¢”š‰†‚ :'
    qbf-lang[25] = '¤Æ ¢á†•:'

    qbf-lang[26] = 'Ž‚ ö†á¤‚¢‡ àä¢“è “‹•'
    qbf-lang[27] = 'ˆ„‹¢‡'
    qbf-lang[28] = '™¤“—¢‡ “—¡ †Ð‚Ð‰í‹¡ Ð ¤ í“¤—¡ „‚ ö†á¤‚¢‡•  Ð '
                 + '“‹  ¤ö†á‹ Ñ ¤ í“¤—¡.'
    qbf-lang[29] = 'Ð‚ƒ†ƒ á—¢‡ Æ‚  “‡¡ †Ð ¡†Æˆ “š¢“ ¢‡ “‡• †” ¤‹Æè•'
/* QUIT and RETURN are the PROGRESS keywords and cannot be translated */
    qbf-lang[30] = 'Ø“ ¡ ‹ ö¤è¢“‡• †Ð‚‰íÆ†‚ "âí‰‹•"  Ð “‹  ¤ö‚ˆ †¡‹ì, '
                 + '“‚ Ší‰†“† ¡  ˆš¡†‚ “‹ Ð¤Æ¤   ; "Quit" è "Return"'
    qbf-lang[31] = 'Ð‚ƒ†ƒ á—¢‡ †Œ„‹ä  Ð “‹ í¡‹ä '  
                 + 'Ž‚ ö†á¤‚¢‡• àä¢“è “‹•'
    qbf-lang[32] = '‰†Æö‹• “‡• „‹è• “‹ä  ¤ö†á‹ä Ñ ¤ í“¤—¡ ˆ ‚  Ð‹Šèˆ†ä¢‡ '
                 + '“—¡ †“ ƒ‹‰ç¡.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 5 THEN
  ASSIGN
/*a-perm.p, 1..7 also used by a-form.p and a-print.p*/
    qbf-lang[ 1] = 'Ñ¤‹¢ƒš¢†‚•'
    qbf-lang[ 2] = ' *                         - Ø‰‹‚ ‹‚ ö¤è¢“†• íö‹ä¡ Ð¤¢ƒ ¢‡.'
    qbf-lang[ 3] = ' <ö¤è¢“‡•>,<ö¤è¢“‡•>,ˆ‹ˆ.  - Þ¡‹  ä“‹á ‹‚ ö¤è¢“†• íö‹ä¡ Ð¤¢ƒ ¢‡.'
    qbf-lang[ 4] = ' !<ö¤è¢“‡•>,!<ö¤è¢“‡•>,*   - Ø‰‹‚ †ˆ“• “—¡ ö¤‡¢“ç¡  ä“ç¡ íö‹ä¡ '
                 + 'Ð¤¢ƒ ¢‡.'
    qbf-lang[ 5] = ' acct*                     - Þ¡‹ ö¤è¢“†• Ð‹ä  ¤öá‘‹ä¡ "acct" '
                 + 'íö‹ä¡ Ð¤¢ƒ ¢‡.'
    qbf-lang[ 6] = 'Žç¢“† “‹ä• ö¤è¢“†• ˆ “š ¡‹  †‚¢ Æ—Æè• (Login ID), ö—¤‚¢í¡  † '
                 + 'ˆ “ .'
    qbf-lang[ 7] = 'â  ‹¡ “  Ð‹¤‹ì¡ ¡  Ð†¤‚íö‹ä¡ ö ¤ ˆ“è¤†• "Ð ‰ ¡“í¤". â‹ Š ä ¢“‚ˆ '
                 + ' Ð‹ˆ‰†á.'
                   /* from 8 thru 13, format x(30) */
    qbf-lang[ 8] = 'Ð‚‰íŒ“† á  †¤Æ ¢á   Ð “‡'
    qbf-lang[ 9] = '‰á¢“   ¤‚¢“†¤š Æ‚  ¡  „‡‰ç¢†“†'
    qbf-lang[10] = '“  ‹¡ “  ö¤‡¢“ç¡ † Ð¤¢ƒ ¢‡.'
    qbf-lang[11] = 'Ð‚‰íŒ“† á  ‰†‚“‹ä¤Æá   Ð “‡ '
    qbf-lang[12] = '‰á¢“   ¤‚¢“†¤š Æ‚  ¡  „‡‰ç¢†“† '
    qbf-lang[13] = '“  ‹¡ “  ö¤‡¢“ç¡ † Ð¤¢ƒ ¢‡.'
    qbf-lang[14] = 'Ñ “è¢“† [' + KBLABEL("END-ERROR")
                 + ']  ”‹ì ˆš¡†“† “‚• †“ ƒ‹‰í•.'
    qbf-lang[15] = 'Ñ “è¢“† [' + KBLABEL("GO") + '] Æ‚   Ð‹Šèˆ†ä¢‡, ['
                 + KBLABEL("END-ERROR") + '] Æ‚   ¡šˆ‰‡¢‡.'
    qbf-lang[16] = 'Ž†¡ Ð‹¤†á“† ¡   Ð‹ˆ‰†á¢†“† “‹¡ † ä“ ¢ •  Ð “‡ Ž‚ ö†á¤‚¢‡ “‹ä àä¢“è “‹• !'
/*a-print.p:*/     /*21 thru 26 must be format x(16) and right-justified */
    qbf-lang[21] = 'Ð ¡ ”‹¤š(Reset)'
    qbf-lang[22] = '                '
    qbf-lang[23] = '        Ò ¡‹¡‚ˆè'
    qbf-lang[24] = '    àä¡†Ð“äÆí¡‡'  
    qbf-lang[25] = '          ¡“‹¡‡'
    qbf-lang[26] = ' µˆì¤—¢‡ ¡“‹¡‡•'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 6 THEN
  ASSIGN
/*a-write.p:*/
    qbf-lang[ 1] = '™¤“—¢‡ Ð ¤ í“¤—¡ †¤Æ ¢á •'
    qbf-lang[ 2] = '™¤“—¢‡ Ð ¤ í“¤—¡ ö¤—š“—¡ ‹Š¡‡•'
    qbf-lang[ 3] = '™¤“—¢‡ ¤äŠá¢†—¡ †ˆ“äÐ—“è'
    qbf-lang[ 4] = '™¤“—¢‡ ‰á¢“ •  ¤ö†á—¡ Æ‚  Ð¤‹ƒ‹‰í•'
    qbf-lang[ 5] = '™¤“—¢‡ ‰á¢“ • ¢öí¢†—¡ †“ Œì  ¤ö†á—¡'
    qbf-lang[ 6] = '™¤“—¢‡ ‰á¢“ •  ä“ “‡• †Ð‚‰‹Æè• Ð†„á—¡ Æ‚  †“‚ˆí““†•'
    qbf-lang[ 7] = '™¤“—¢‡ ‰á¢“ • Ð¤‹¢ƒš¢†—¡ Æ‚  †Ð‚‰‹Æí• Ð¤‹ƒ‹‰è•'
    qbf-lang[ 8] = '™¤“—¢‡ ¢“‹‚ö†á—¡ “‹ä Ð¤‹Æ¤š “‹• “‹ä ö¤è¢“‡'
    qbf-lang[ 9] = '™¤“—¢‡ Ð¤‹“†‚¡†¡—¡ Ð ¤ í“¤—¡ †ˆ“äÐç¢†—¡ “‹ä ¢ä¢“è “‹•'

/* a-color.p*/
                 /* 12345678901234567890123456789012 */
    qbf-lang[11] = '    ž¤ç “  Æ‚  “ìÐ‹ “†¤ “‚ˆ‹ì:' /* must be 32 */
                 /* 1234567890123456789012345 */
    qbf-lang[12] = 'Þ†¡‹ì:          Ò ¡‹¡‚ˆš:' /* must be 25 */
    qbf-lang[13] = '           ™—“†‚¡è Ðš¤ :'
    qbf-lang[14] = 'Ñ ¤šŠ.Ž‚ ‰Æ‹ä: Ò ¡‹¡‚ˆš:'
    qbf-lang[15] = '           ™—“†‚¡è Ðš¤ :'
    qbf-lang[16] = 'Óá¢“  †Ð‚‰‹Æç¡: Ò ¡‹¡‚ˆš:'
    qbf-lang[17] = '           ™—“†‚¡è Ðš¤ :'

/*a-field.p*/    /*"----- ----- ----- ----- ----"*/
    qbf-lang[30] = '”š¡ Þ†“ ƒ µ¡ ‘. µ¡†ì¤ à†‚¤'
    qbf-lang[31] = 'Ø‚ µÐ‹„†ˆ“í• “‚í• †á¡ ‚  Ð 1 í—• 9999.'
    qbf-lang[32] = 'Ôí‰†“† ¡   Ð‹Š‡ˆ†ì¢†“† “‚• †“ ƒ‹‰í• Ð‹ä ˆš¡†“† ¢“è '
                 + '‰á¢“  Ð†„á—¡; '.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 8 THEN
/*a-label.p*/
  ASSIGN            /* 1..8 use format x(78) */
                    /* 1 and 8 are available for more explanation, in */
                    /*   case the translation won't fit in 2 thru 7.  */
    qbf-lang[ 1] = 'Žç¢“† “‚• ‹¡‹ ¢á†• Ð†„á—¡ Ð‹ä Ð†¤‚íö‹ä¡ “  ¢“‹‚ö†á  “‡• '
                 + '„‚†ìŠä¡¢‡•. '
    qbf-lang[ 2] = 'ž¤‡¢‚‹Ð‹‚è¢“† ¢ì¡“ Œ‡ ‹¤”è• CAN-DO ¢ ¡ š¢ˆ  Æ‚  ¡  '
                 + 'ƒ¤†á“† “  Ð†„á  ("*" '
    qbf-lang[ 3] = ' ¡“‚¢“‹‚ö†á † í¡ ¡ è Ð ¤ Ðš¡— ö ¤ ˆ“è¤†•, "."  ¡“‚¢“‹‚ö†á '
                 + '† í¡ ¡ ö ¤ ˆ“è¤ ).'
    qbf-lang[ 4] = 'µä“š “  ¢“‹‚ö†á  ö¤‡¢‚‹Ð‹‚‹ì¡“ ‚ ¢“‡¡ „‡‚‹ä¤Æá  “—¡ '
                 + 'Ð¤‹“†‚¡†¡—¡ †“‚ˆ†““ç¡.'
    qbf-lang[ 5] = 'Ö  íö†“† äÐ''›‚¡ “‚ †¤‚ˆí• ˆ “ ö—¤è¢†‚• Ð‹¤†á ¡  Ð†¤‚¢¢†ì‹ä¡ '
                 + '„‡‰ „è,  ¡ '
    qbf-lang[ 6] = 'ö¤‡¢‚‹Ð‹‚è¢†“† Ñ‰‡, Ö‹ ˆ ‚ â.Ò. ¢ ¡ Œ†ö—¤‚¢“š Ð†„á  ““†, '
                 + '‡ Æ¤ è "Ñ-Ö-â "'
    qbf-lang[ 7] = 'Ð‰†‹¡š‘†‚.'
                  /* each entry in list must be <= 5 characters long */
                  /* but may be any portion of address that is applicable */
                  /* in the target country */
    qbf-lang[ 9] = 'Ø¡‹ ,åÐ›‡,Ž‚†ì1,Ž‚†ì2,Ž‚†ì3,â.Ò.,Ñ‰‡,â-Ñ,Ö‹•,žç¤ '
    qbf-lang[10] = 'â‹ Ñ†„á‹ Ð‹ä Ð†¤‚íö†‚ “‡¡ Ð—¡äá /Ø¡‹  <Ø¡‹ >'
    qbf-lang[11] = 'â‹ Ñ†„á‹ Ð‹ä Ð†¤‚íö†‚ “‹ ¡‹  “‹ä äÐ†ìŠä¡‹ä <åÐ›‡>'
    qbf-lang[12] = 'â‹ Ñ†„á‹ Ð‹ä Ð†¤‚íö†‚ “‡¡ <Ð¤ç“‡> Æ¤ è “‡• „‚†ìŠä¡¢‡• (Ð.ö. ‹„•)'
    qbf-lang[13] = 'â‹ Ñ†„á‹ Ð‹ä Ð†¤‚íö†‚ <„†ì“†¤‡> Æ¤ è “‡• „‚†ìŠä¡¢‡• (Ð.ö. âšö.Ôä¤á„ )'
    qbf-lang[14] = 'â‹ Ñ†„á‹ Ð‹ä Ð†¤‚íö†‚ <“¤á“‡> Æ¤ è “‡• „‚†ìŠä¡¢‡• (Ð¤‹ ‚¤†“‚ˆ)'
    qbf-lang[15] = 'â‹ Ñ†„á‹ Ð‹ä Ð†¤‚íö†‚ “‹¡ â öä„¤‹‚ˆ Òç„‚ˆ  <â.Ò.>'
    qbf-lang[16] = 'â‹ Ñ†„á‹ Ð‹ä Ð†¤‚íö†‚ “‡¡ <Ñ‰‡>'
    qbf-lang[17] = 'â‹ Ñ†„á‹ Ð‹ä Ð†¤‚íö†‚ <â.Ò.- Ñ‰‡> ¢† á  Æ¤ è'
    qbf-lang[18] = 'â‹ Ñ†„á‹ Ð‹ä Ð†¤‚íö†‚ “‹¡ ¡‹ <Ö‹•>'
    qbf-lang[19] = 'â‹ Ñ†„á‹ Ð‹ä Ð†¤‚íö†‚ “‡ öç¤  <žç¤ >'

/*a-join.p*/
    qbf-lang[23] = 'Ž†¡ †Ð‚“¤íÐ†“ ‚ ‡ " ä“-í¡—¢‡" “‹ä  ¤ö†á‹ä  ä“è “‡ ¢“‚Æè.'
    qbf-lang[24] = 'ö†“† ”“š¢†‚ ¢“‹ ¤‚‹ Æ‚  †¡—“‚ˆí• ¢öí¢†‚• †“ Œì  ¤ö†á—¡.'
    qbf-lang[25] = '¡ç¢‡ “‹ä' /* 25 and 26 are automatically */
    qbf-lang[26] = '† “‹'          /*   right-justified           */
    qbf-lang[27] = 'Žç¢“† “‹ ”á‰“¤‹ WHERE è OF : ( ”è¢“í “‹ ˆ†¡ Æ‚   ˆì¤—¢‡ “‡• í¡—¢‡•)'
    qbf-lang[28] = 'Ñ “è¢“† [' + KBLABEL("END-ERROR") + ']  ”‹ì ˆš¡†“† “‚• †“ ƒ‹‰í•.'
    qbf-lang[30] = '€ ¢ä¡Šèˆ‡ Ð¤íÐ†‚ ¡   ¤öá¢†‚ † WHERE è OF.'
    qbf-lang[31] = 'Žç¢“† “‡¡ ‹¡‹ ¢á  “‹ä Ð¤ç“‹ä  ¤ö†á‹ä “‡• í¡—¢‡• Æ‚  Ð¤‹¢Šèˆ‡ è  ˆì¤—¢‡.'
    qbf-lang[32] = 'âç¤ , „ç¢“† “‡¡ ‹¡‹ ¢á  “‹ä „†ì“†¤‹ä  ¤ö†á‹ä “‡• í¡—¢‡•.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-form.p */
IF qbf-s = 9 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' A. Ñ¤‹¢Šèˆ‡ Öí • ™¤ • Ñ¤‹ƒ‹‰è•'
    qbf-lang[ 2] = ' C. Ð‚‰‹Æè ™¤ • Ñ¤‹ƒ‹‰è• Æ‚  Þ†“ ƒ‹‰è '
    qbf-lang[ 3] = ' G. Ç†¡‚ˆš ž ¤ ˆ“‡¤‚¢“‚ˆš “‡• ™¤ •'
    qbf-lang[ 4] = ' W. Ð‚‰‹Æè Ñ†„á—¡ Æ‚  “‡ ™¤ '
    qbf-lang[ 5] = ' P. Ñ¤‹¢ƒš¢†‚• '
    qbf-lang[ 6] = ' D. Ž‚ Æ¤ ”è “‡• â¤íö‹ä¢ • ™¤ •'
    qbf-lang[ 7] = ' Ð‚‰‹Æè :' /* format x(10) */
    qbf-lang[ 8] = ' Þ†“ ƒ‹‰è:' /* format x(10) */
                 /* cannot changed width of 9..16 from defined below */
    qbf-lang[ 9] = '    Ø¡‹š¢‚   ¤ö†á‹ä DB' /* right-justify 9..14 */
    qbf-lang[10] = '           âìÐ‹• ™¤ •'
    qbf-lang[11] = '     Ñ¤Æ¤   Ñ¤‹ƒ‹‰è•'
    qbf-lang[12] = 'Ø¡‹ ¢á  µ¤ö†á‹ä ™¤ •'
    qbf-lang[13] = ' Ø¡‹ ¢á  Frame Æ‚  4GL'
    qbf-lang[14] = '              Ñ†¤‚Æ¤ ”è'
    qbf-lang[15] = '(Ô†—¤†á“ ‚ .p)' /* left-justify 15 and 16 */
    qbf-lang[16] = '(Žç¢“† extension)'
    qbf-lang[18] = 'H ™¤  íö†‚ ~{1~} Æ¤ í•. Ð†‚„è “‹ RESULTS „†¢†ì†‚ '
                 + 'Ðí¡“† Æ¤ í• Æ‚  ö¤è¢‡ “‹ä ‚„á‹ä, Œ†Ð†¤¡š “‹ ¤‚‹ Æ¤ ç¡ '
                 + '‹Š¡‡• ¢† “†¤ “‚ˆ 24x80. Ôí‰†“† ¡  ‹¤á¢†“† ‚  ”¤  † '
                 + ' ä“ “‹ íÆ†Š‹•; '
    qbf-lang[19] = '€„‡ äÐ ¤ö†á í¡  Ð¤Æ¤   Ð¤‹ƒ‹‰è• '' ä“è “‡¡ ‹¡‹ ¢á .'
    qbf-lang[20] = '€ ™¤  Ð¤íÐ†‚ ¡  äÐš¤ö†‚ è„‡ è ¡  íö†‚ “‡¡ ˆ “š‰‡Œ‡ .f  ¡ '
                 + 'Ð¤ˆ†‚“ ‚ Æ‚  µä“ “‡ Ž‡‚‹ä¤Æá .'
    qbf-lang[21] = '€ ‹¡‹ ¢á  “‹ä "Frame" Æ‚  “‹¡ ˆç„‚ˆ  4GL Ð‹ä „ç¢ “† '
                 + '†á¡ ‚ „†¢†äí¡‡. Žç¢“† „‚ ”‹¤†“‚ˆè ‹¡‹ ¢á .'
    qbf-lang[22] = ' Ð‚‰‹Æè µ¤ö†á—¡ '
    qbf-lang[23] = 'Ñ “è¢“† [' + KBLABEL("END-ERROR") + ']  ”‹ì ˆš¡†“† “‚• †“ ƒ‹‰í•'
    qbf-lang[24] = 'µÐ‹Šèˆ†ä¢‡ ¢“‹‚ö†á—¡ “‡• ™¤ • ¢“‡ ¶‚ƒ‰‚‹Šèˆ‡ ™‹¤ç¡...'
    qbf-lang[25] = 'ö†“† †“ ƒš‰†‚ “‹ä‰šö‚¢“‹¡ á  ™‹¤  Ñ¤‹ƒ‹‰è•. ÞÐ‹¤†á“† ¡  '
                 + 'ˆš¡†“†, †á“† "compile" “‡• ™¤ • “ç¤ , †á“† "Ð ¡†Æˆ “š¢“ ¢‡ '
                 + '” ¤‹Æè•" †“š.  Ôí‰†“† "Compile" “ç¤ ; '
    qbf-lang[26] = 'Ž†¡ ƒ¤íŠ‡ˆ† ”¤  † “‡¡ ‹¡ ¢‚  "~{1~}".'
                 + 'Ôí‰†“† ¡  “‡ „‡‚‹ä¤è¢†“†; '
    qbf-lang[27] = 'åÐš¤ö†‚ ™¤  Ñ¤‹ƒ‹‰è• † “‡¡ ‹¡‹ ¢á  "~{1~}".'
                 + 'Ôí‰†“† ¡  ö¤‡¢‚‹Ð‹‚è¢†“† “  Ð†„á  Ð‹ä  ¡èˆ‹ä¡ ¢'' ä“è “‡ ™¤ ; '
    qbf-lang[28] = 'Ð‚ƒ†ƒ á—¢‡ „‚ Æ¤ ”è• “‡• ™¤ • Ñ¤‹ƒ‹‰è•'
    qbf-lang[29] = '** To Ñ¤Æ¤   Ñ¤‹ƒ‹‰è• - "~{1~}" „‚ Æ¤š”‡ˆ†. **'
    qbf-lang[30] = 'Ž‡‚‹ä¤Æá  “‡• ™¤ • Ñ¤‹ƒ‹‰è•...'
    qbf-lang[31] = 'ö†“† ”“š¢†‚ ¢“‹ ¤‚‹  Ð‹Šèˆ†ä¢‡• Æ‚  ™¤†• Ñ¤‹ƒ‹‰è•.'
    qbf-lang[32] = 'µ„ì¡ “‡ ‡ †Æˆ “š¢“ ¢‡ “‡• ™¤ • Ñ¤‹ƒ‹‰è• Æ‚''šä“‹ “‹  ¤ö†á‹.^^Ç‚  ¡  '
                 + '†Æˆ “ ¢“ Š†á è ”¤ , †á“† ‡ "Çí”ä¤ " Ð¤íÐ†‚ ¡  äÐ‹¢“‡¤á‘†‚ "RECIDs", '
                 + '†á“† ¡  äÐš¤ö†‚ ‹¡ „‚ˆ ˆ‰†‚„á (unique index) Æ‚  “‹  ¤ö†á‹.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-print.p */
IF qbf-s = 10 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' A. Ñ¤‹¢Šèˆ‡ Öí • Þ‹¡š„ • Œ„‹ä '
    qbf-lang[ 2] = ' C. Ð‚‰‹Æè Þ‹¡š„ • Æ‚  Þ†“ ƒ‹‰è '
    qbf-lang[ 3] = ' G. Ç†¡‚ˆš ž ¤ ˆ“‡¤‚¢“‚ˆš “‡• Þ‹¡š„ • '
    qbf-lang[ 4] = ' S. ž ¤ ˆ“è¤†• ‰íÆö‹ä '
    qbf-lang[ 5] = ' P. Ñ¤‹¢ƒš¢†‚• ˆ“äÐ—“ç¡ '
    qbf-lang[ 6] = ' D. Ž‚ Æ¤ ”è “‡• â¤íö‹ä¢ • Þ‹¡š„ • '
    qbf-lang[ 7] = ' Ð‚‰‹Æè: ' /* format x(10) */
    qbf-lang[ 8] = ' Þ†“ ƒ‹‰è:' /* format x(10) */
    qbf-lang[ 9] = 'Ø‚ µÐ‹„†ˆ“í• “‚í• †á¡ ‚  Ð 1 í—• 255.'
    qbf-lang[10] = 'O âìÐ‹• Ð¤íÐ†‚ ¡  †á¡ ‚ term, thru, to, view, file, page è prog'
    qbf-lang[11] = 'ö†“† ”“š¢†‚ ¢“‹ ¤‚‹ Æ‚  Þ‹¡š„†• Œ„‹ä.'
    qbf-lang[12] = 'Þ¡‹ Ø âìÐ‹• Þ‹¡š„ • "term" Ð¤†‚ ¡  íö†‚ íŒ‹„‹ ¢† TERMINAL.'
    qbf-lang[13] = 'Ž†¡ ƒ¤íŠ‡ˆ† ‡ ‹¡‹ ¢á  Ð¤‹Æ¤š “‹• † “‹ “¤íö‹¡ PROPATH.'
                  /*17 thru 20 must be format x(16) and right-justified */
    qbf-lang[17] = 'Ñ†¤‚Æ¤ ”è ‰á¢“ •'
    qbf-lang[18] = 'Ø¡  ¢á  Þ‹¡š„ •'
    qbf-lang[19] = '   ÞíÆ‚¢“‹ ì¤‹•'
    qbf-lang[20] = '           âìÐ‹•'
    qbf-lang[21] = '¶‰íÐ† Ð ¤ ˆš“—'
    qbf-lang[22] = 'TERMINAL, Ð—• OUTPUT TO TERMINAL PAGED'
    qbf-lang[23] = 'TO Ð¤• ‹¡š„ , Ð—• OUTPUT TO PRINTER'
    qbf-lang[24] = 'THROUGH í¢— spooler è ”á‰“¤‹ UNIX è OS/2'
    qbf-lang[25] = 'à“í‰¡†‚ “‡¡ †ˆ“ìÐ—¢‡ ¢†  ¤ö†á‹, ˆ ‚ †“š †ˆ“†‰†á  ä“ “‹ Ð¤Æ¤  '
    qbf-lang[26] = '’‡“š “‡¡ ‹¡‹ ¢á  “‹ä  ¤ö†á‹ä †Œ„‹ä  Ð “‹¡ ö¤è¢“‡'
    qbf-lang[27] = 'µ‰‰ Æè ¢†‰á„ • † Ð¤‹‡Æ‹ì†¡‡/†Ð†¡‡ ‹Š¡‡ (prev-page ˆ ‚ next-page)'
    qbf-lang[28] = 'Ò‰è¢‡ Ð¤‹Æ¤š “‹• 4GL Æ‚  “‡¡  ¤öè/“í‰‹• “‡• ¤‹è• †Œ„‹ä'
    qbf-lang[30] = 'Ñ “è¢“† [' + KBLABEL("END-ERROR") + ']  ”‹ì ˆš¡†“† “‚• †“ ƒ‹‰í•'
    qbf-lang[31] = 'Ñ¤íÐ†‚ ¡  äÐš¤ö†‚ “‹ä‰šö‚¢“‹¡ á  Þ‹¡š„  Œ„‹ä !'
    qbf-lang[32] = 'Ð‚ƒ†ƒ á—¢‡ „‚ Æ¤ ”è• “‹ä †ˆ“äÐ—“è'.

/*--------------------------------------------------------------------------*/

RETURN.
