/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-b-eng.p - English language definitions for Build subsystem */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* b-build.p,b-again.p */
IF qbf-s = 1 THEN
  ASSIGN
                /* formats: x(10) x(45) x(8) */
    qbf-lang[ 1] = 'Ñ¤Æ¤  ,"Database" ˆ ‚ µ¤ö†á‹,ž¤¡‹•'
    qbf-lang[ 2] = 'â‹  ¤ö†á‹ ‰íÆö‹ä (Checkpoint) ˆ “ ¢“¤š”‡ˆ†. Ž‚ Æ¤š›“† “‹  ¤ö†á‹ .qc '
                 + 'ˆ ‚ ˆš¡“† “‡¡ †Æˆ “š¢“ ¢‡  Ð “‡¡  ¤öè.'
    qbf-lang[ 3] = 'Ð†Œ†¤Æ ¢á  “‹ä'     /*format x(15)*/
    qbf-lang[ 4] = 'Compile'      /*format x(15)*/
    qbf-lang[ 5] = 'Re-Compiling'   /*format x(15)*/
    qbf-lang[ 6] = 'Ð†Œ†¤Æ ¢á  “‹ä  ¤ö†á‹ä,Ð†Œ†¤Æ ¢á  “‡• ”¤ •,Ð†Œ†¤Æ ¢á  Ð¤‹Æ¤š “‹•'
    qbf-lang[ 7] = 'Ø‰  “  †Ð‚‰†Æí¡   ¤ö†á  Š  †Æˆ “ ¢“ Š‹ì¡. ['
                 + KBLABEL("RETURN") + '] Æ‚  †Ð‚‰‹Æè/ ˆì¤—¢‡ †Ð‚‰‹Æè•.'
    qbf-lang[ 8] = 'Ñ “è¢“† [' + KBLABEL("GO") + ']  ”‹ì †Ð‚‰íŒ†“† è ['
                 + KBLABEL("END-ERROR") + '] Æ‚  “í‰‹•.'
    qbf-lang[ 9] = 'µ¡†ì¤†¢‡  ¤ö†á—¡ Æ‚  „‡‚‹ä¤Æá   ¤ö‚ˆè ‰á¢“  ™‹¤ç¡ Ñ¤‹ƒ‹‰è•...'
    qbf-lang[10] = 'ö†“† ‹¤á¢†‚ ‰†• “‚• ™‹¤†• Ñ¤‹ƒ‹‰è•; '
    qbf-lang[11] = 'µ¡†ì¤†¢‡ í†¢—¡ †¡—“‚ˆç¡ ¢öí¢†—¡ -OF.'
    qbf-lang[12] = 'Ð†Œ†¤Æ ¢á  “‡• ‰á¢“ • ¡—“‚ˆç¡ àöí¢†—¡.'
    qbf-lang[13] = 'Ž†¡ †¡“‹Ðá¢“‡ˆ ¡ ‰†• ‹‚ ¡ç¢†‚•.'
    qbf-lang[14] = 'Ž‚ Æ¤ ”è “—¡ †Ð‚Ð‰í‹¡ ¢“‹‚ö†á—¡ “—¡ ¡—“‚ˆç¡ àöí¢†—¡.'
    qbf-lang[15] = 'Ð‚ƒ†ƒ á—¢‡ †Œ„‹ä'
    qbf-lang[16] = 'àä¡‹‰‚ˆ• ö¤‹¡‹•,Þí¢‹• ö¤¡‹•'
    qbf-lang[17] = 'µ¡šÆ¡—¢‡ “‹ä  ¤ö†á‹ä ‰íÆö‹ä (checkpoint)...'
    qbf-lang[18] = 'Ž‡‚‹ä¤Æá  “‹ä  ¤ö†á‹ä ‰íÆö‹ä (checkpoint)...'
    qbf-lang[19] = 'è„‡ äÐš¤ö†‚. µ¡“‚ˆ “š¢“ ¢‡ † “‹'
    qbf-lang[20] = 'Ð ¡†Æˆ “š¢“ ¢‡ “‹ä  ¤ö†á‹ä'
    qbf-lang[21] = 'µ¡†ì¤†¢‡ “‡• ™‹¤ • "~{1~}" Æ‚  †“ ƒ‹‰í•.'
    qbf-lang[22] = 'µ„ì¡ “‡ ‡ †Æˆ “š¢“ ¢‡ “‡• ™‹¤ • öç¤‚• RECID è UNIQUE INDEX '
    qbf-lang[23] = '€ ™¤  „†¡ š‰‰ Œ†.'
    qbf-lang[24] = '„†¡ ö¤†‚š‘†“ ‚ "recompiling".'
    qbf-lang[25] = 'Ž†¡ äÐš¤ö‹ä¡ š‰‰  Ð†„á  ¢“‡ ™¤ . Ž†¡ „‡‚‹ä¤ÆèŠ‡ˆ† € ™¤ .'
    qbf-lang[26] = 'Ž†¡ äÐš¤ö‹ä¡ š‰‰  Ð†„á  ¢“‡ ™¤ . € äÐš¤ö‹ä¢  ™¤  „‚ Æ¤š”‡ˆ†.'
    qbf-lang[27] = 'àäÐá†¢‡ “‡• ‰á¢“ •  ¤ö†á—¡ Ð¤‹ƒ‹‰è•.'
    qbf-lang[28] = 'àä¡‹‰‚ˆ• ö¤¡‹•'
    qbf-lang[29] = 'âí‰‹•!'
    qbf-lang[30] = 'µÐ‹“äöá  "Compile" “‹ä "~{1~}".'
    qbf-lang[31] = 'Ž‡‚‹ä¤Æá  “‹ä  ¤ö†á‹ä Ñ ¤ í“¤—¡ (config)'
    qbf-lang[32] = '¡“‹Ðá¢“‡ˆ ¡ ÓšŠ‡ ˆ “š “‡¡ ”š¢‡ "†Æˆ “š¢“ ¢‡" ˆ ‚/è "compile".'
                 + '^^Ñ “è¢“† ˆšÐ‹‚‹ Ð‰èˆ“¤‹ Æ‚  ¡  „†á“† “‹ ‚¢“‹¤‚ˆ  ¤ö†á‹ (query log file).'
                 + '€ Æ¤ í• Ð‹ä Ð†¤‚íö‹ä¡ “  ‰šŠ‡ “‹¡á‘‹¡“ ‚.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN

/* b-misc.p */
    /* 1..10 for qbf-l-auto[] */
    qbf-lang[ 1] = 'onoma,*onoma*,eponymia,*eponymia*,Name'
    qbf-lang[ 2] = 'contact,*contact*,ypeythinos,yp*opsin,Address'
    qbf-lang[ 3] = '*odos,dieyth*,*dieythinsh,*dieythinsh*1,Address2'
    qbf-lang[ 4] = '*tax*thyrida*,*dieythinsh*2'
    qbf-lang[ 5] = '*dieythinsh*3,City'
    qbf-lang[ 6] = 'tax*kod*,*tax*kvd*,t*k*,St'
    qbf-lang[ 7] = 'polh,*polh*,Zip'
    qbf-lang[ 8] = 't*p,*tax*polh*,tk*polh,t*k*polh'
    qbf-lang[ 9] = 'nomos,*nomos*'
    qbf-lang[10] = '*xvra*,*xora*'

    qbf-lang[15] = 'Ž†áÆ  Þ‹¤”è• Œ Æ—Æè•'.

/*--------------------------------------------------------------------------*/

RETURN.
