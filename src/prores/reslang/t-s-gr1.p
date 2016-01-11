/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-s-eng.p - English language definitions for general system use */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/

/* l-edit.p,s-edit.p */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Insert'
    qbf-lang[ 2] = 'Ð‚ƒ†ƒ á—¢‡ †Œ„‹ä ö—¤á•  Ð‹Šèˆ†ä¢‡'
    qbf-lang[ 3] = 'Žç¢“† “‡¡ ‹¡‹ ¢á  “‹ä  ¤ö†á‹ä Æ‚  ¢äÆöç¡†ä¢‡'
    qbf-lang[ 4] = 'Žç¢“† “‹ä• ö ¤ ˆ“è¤†• Æ‚   ¡ ‘è“‡¢‡'
    qbf-lang[ 5] = 'Ð‚‰‹Æè Ð†„á‹ä Æ‚  Ð ¤†ƒ‹‰è'
    qbf-lang[ 6] = 'Ñ “è¢“† [' + KBLABEL("GO") + ']  Ð‹Šèˆ†ä¢‡, ['
		 + KBLABEL("GET") + '] Ð¤‹¢Šèˆ‡ Ð†„á‹ä, ['
		 + KBLABEL("END-ERROR") + ']  ¡šˆ‰‡¢‡.'
    qbf-lang[ 7] = 'Ž†¡ ƒ¤íŠ‡ˆ† ˆ “š “‡¡  ¡ ‘è“‡¢‡.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-ask.p,s-where.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = '¢‹ì“ ‚ †'
    qbf-lang[ 2] = 'Ž†¡ ¢‹ì“ ‚ †'
    qbf-lang[ 3] = 'Þ‚ˆ¤“†¤‹  Ð'
    qbf-lang[ 4] = 'Þ‚ˆ¤“†¤‹ è á¢‹'
    qbf-lang[ 5] = 'Þ†Æ ‰ì“†¤‹  Ð'
    qbf-lang[ 6] = 'Þ†Æ ‰ì“†¤‹ è á¢‹'
    qbf-lang[ 7] = 'µ¤öá‘†‚  Ð'
    qbf-lang[ 8] = 'Ñ†¤‚íö†‚'    /* must match [r.4.23] */
    qbf-lang[ 9] = 'µ¡“‚¢“‹‚ö†á †'

    qbf-lang[10] = 'Ð‚‰‹Æè Ð†„á‹ä'
    qbf-lang[11] = 'Ñ¤šŒ‡'
    qbf-lang[12] = 'Ð‚‰íŒ“† “‚è'
    qbf-lang[13] = 'àäÆˆ¤á¢†‚•'

    qbf-lang[14] = 'Ò Š‹¤‚¢• “‚è•  Ð “‹¡ ö¤è¢“‡ ¢“‡¡ ç¤  †ˆ“í‰†¢‡•.'
    qbf-lang[15] = 'Žç¢“† “‡¡ †¤ç“‡¢‡ Ð‹ä Š  †” ¡‚¢“†á ¢“‡¡ ç¤  †ˆ“í‰†¢‡• :'

    qbf-lang[16] = 'Ò Š‹¤‚¢• “‚è• ‹¤”è•' /* data-type */
    qbf-lang[17] = ''

    qbf-lang[18] = 'Ñ “è¢“† [' + KBLABEL("END-ERROR") + '] Æ‚  “í‰‹•.'
    qbf-lang[19] = 'Ñ “è¢“† [' + KBLABEL("END-ERROR") + '] Æ‚   ¡šˆ‰‡¢‡.'
    qbf-lang[20] = 'Ñ “è¢“† [' + KBLABEL("GET") + '] Æ‚  µ†¢‹ Ø¤‚¢.'

    qbf-lang[21] = 'Ð‚‰íŒ“† “‡ ‹¤”è ¢ìÆˆ¤‚¢‡• Æ‚  “‹ Ð†„á‹.'

    qbf-lang[22] = 'Žç¢“† “‡ “‚è, ‹¤”è• ~{1~} Æ‚  ¢ìÆˆ¤‚¢‡ † "~{2~}".'
    qbf-lang[23] = 'Žç¢“† “‡ “‚è ‹¤”è• ~{1~} Æ‚  "~{2~}".'
    qbf-lang[24] = 'Ñ “è¢“† [' + KBLABEL("PUT")
		 + '] Æ‚  ˆ Š‹¤‚¢  Ð “‹¡ ö¤è¢“‡ ¢“‡¡ ç¤  †ˆ“í‰†¢‡•.'
    qbf-lang[25] = 'àì¡“ Œ‡:â‹  ~{1~} †á¡ ‚ ~{2~} ˆšÐ‹‚  “‚è, ‹¤”è• ~{3~}.'

    qbf-lang[27] = 'Ø µ†¢‹• Ø¤‚¢• „†¡ ¢ä¡†¤Æš‘†“ ‚ † “‹¡ ˆ Š‹¤‚ “‚è• '
		 + ' Ð “‹¡ ö¤è¢“‡ ¢“‡¡ ç¤  †ˆ“í‰†¢‡•. ž¤‡¢‚‹Ð‹‚è¢“† ¡‹ “‹ í¡ .'
    qbf-lang[28] = '€ “‚è Ð¤íÐ†‚ ¡  †á¡ ‚ Æ¡—¢“è !'
    qbf-lang[29] = 'Žç¢“† š‰‰†• “‚í• Æ‚ ' /* '?' append to string */
    qbf-lang[30] = 'Ôí‰†“† ¡  ‹¤á¢†“† š‰‰  ˆ¤‚“è¤‚  †Ð‚‰‹Æè•; '
    qbf-lang[31] = 'Ø ¢ä¡„‚ ¢• † “  Ð¤‹‡Æ‹ì†¡  ˆ¤‚“è¤‚  ¡  Æá¡†‚ †'
    qbf-lang[32] = 'µ†¢‹ Ø¤‚¢'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
/* s-info.p, s-format.p */
    qbf-lang[ 1] = 'â Œ‚¡‡¢‡ ˆ “š'  /* s-info.p automatically right-justifies */
    qbf-lang[ 2] = 'ˆ ‚ ˆ “š'    /*   1..9 and adds colons for you. */
    qbf-lang[ 3] = 'µ¤ö†á‹'      /* but must fit in format x(24) */
    qbf-lang[ 4] = '¡—“‚ˆè ¢öí¢‡'
    qbf-lang[ 5] = 'ØÐ‹ä'
    qbf-lang[ 6] = 'Ñ†„á‹'
    qbf-lang[ 7] = 'Ñ¤šŒ‡'
    qbf-lang[ 9] = 'Ñ ¤š‰†‚›‡ Ð ¡ ‰.“‚ç¡; '

    qbf-lang[10] = 'µÑØ,µÖµ,µÑØ'
    qbf-lang[11] = 'Ž†¡ íö†“† †Ð‚‰íŒ†‚ “   ¤ö†á  !'
    qbf-lang[12] = 'Þ‹¤”í• Ñ†„á—¡ ˆ ‚ Ø¡‹ ¢á†•'
    qbf-lang[13] = 'Þ‹¤”í•'
    qbf-lang[14] = 'Ð‚‰‹Æè Ñ†„á‹ä' /* also used by s-calc.p below */
    /* 15..18 must be format x(16) (see notes on 1..7) */
    qbf-lang[15] = 'Ø¡‹ ¢á '
    qbf-lang[16] = 'Þ‹¤”è'
    qbf-lang[17] = 'Database'
    qbf-lang[18] = 'âìÐ‹•'
    qbf-lang[19] = 'Ñ¤‹‡Æ‹ì†¡‹• ö¤¡‹• †ˆ“í‰†¢‡•,‰†Ð“š:„†ä“†¤‰†Ð“ '
    qbf-lang[20] = '€ “‚è Ð¤íÐ†‚ ¡  †á¡ ‚ Æ¡—¢“è (?)'

/*s-calc.p*/ /* there are many more for s-calc.p, see qbf-s = 5 thru 8 */
/*s-calc.p also uses #14 */
    qbf-lang[27] = 'Ž‡‚‹ä¤Æá  Ñ¤ Œ†—¡'
    qbf-lang[28] = 'Ñ¤šŒ‡'
    qbf-lang[29] = 'Ô†‰†“† ¡  Ð¤‹¢Ší“†“† š‰‰  ¢“‹‚ö†á  ¢'' ä“è “‡ Ð¤šŒ‡; '
    qbf-lang[30] = 'Ð‚‰‹Æè Ó†‚“‹ä¤Æá •'
    qbf-lang[31] = '‡ ¢‡†¤‚¡è ‡†¤‹‡¡á '
    qbf-lang[32] = '¢“ Š†¤è “‚è'.

ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 4 THEN
  ASSIGN
/*s-help.p*/
    qbf-lang[ 1] = 'Ž†¡ äÐš¤ö†‚ ƒ‹èŠ†‚  Æ‚'' ä“è “‡¡ †Ð‚‰‹Æè.'
    qbf-lang[ 2] = '¶‹èŠ†‚ '

/*s-order.p*/
    qbf-lang[15] = 'µìŒ‹ä¢ /™Šá¡‹ä¢ ' /*neither can be over 8 characters */
    qbf-lang[16] = 'Ç‚  “‹ ˆ Ší¡  „ç¢“† "µ" Æ‚   ìŒ‹ä¢  ¢†‚¤š'
    qbf-lang[17] = 'è "™" Æ‚  ”Šá¡‹ä¢  ¢†‚¤š.'

/*s-define.p*/
    qbf-lang[21] = 'W. Ñ‰š“‹•/Þ‹¤”è “—¡ Ñ†„á—¡'
    qbf-lang[22] = 'F. Ñ†„á '
    qbf-lang[23] = 'A. ¡†¤Æš µ¤ö†á '
    qbf-lang[24] = 'T. µŠ¤‹á¢ “  ˆ ‚ åÐ‹¢ì¡‹‰ '
    qbf-lang[25] = 'R. â¤íö‹¡ àì¡‹‰‹'
    qbf-lang[26] = 'P. Ñ‹¢‹¢“ “‹ä àä¡‰‹ä'
    qbf-lang[27] = 'C. Þ†“¤‡“í•'
    qbf-lang[28] = 'M. Þ Š‡ “‚ˆí• Ñ¤šŒ†‚•'
    qbf-lang[29] = 'S. Ñ¤šŒ†‚• † µ‰” ¤‚Š‡“‚ˆš'
    qbf-lang[30] = 'N. Ñ¤šŒ†‚• † µ¤‚Š‡“‚ˆš'
    qbf-lang[31] = 'D. Ñ¤šŒ†‚• † €†¤‹‡¡á†•'
    qbf-lang[32] = 'L. Ó‹Æ‚ˆí• Ñ¤šŒ†‚•'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - string expressions */
IF qbf-s = 5 THEN
  ASSIGN
    qbf-lang[ 1] = 's,à“ Š†¤ è Ñ†„á‹,s00=s24,~{1~}'
    qbf-lang[ 2] = 's,Substring,s00=s25n26n27,SUBSTRING(~{1~}'
		 + ';INTEGER(~{2~});INTEGER(~{3~}))'
    qbf-lang[ 3] = 's,àä¡„‚ ¢• „ì‹ µ‰” ¤‚Š‡“‚ˆç¡,s00=s28s29,~{1~} + ~{2~}'
    qbf-lang[ 4] = 's,àä¡„‚ ¢• “¤‚ç¡ µ‰” ¤‚Š‡“‚ˆç¡,s00=s28s29s29,'
		 + '~{1~} + ~{2~} + ~{3~}'
    qbf-lang[ 5] = 's,àä¡„‚ ¢• “†¢¢š¤—¡ µ‰” ¤‚Š‡“‚ˆç¡,s00=s28s29s29s29,'
		 + '~{1~} + ~{2~} + ~{3~} + ~{4~}'
    qbf-lang[ 6] = 's,â‹ ‚ˆ¤“†¤‹ „ì‹ µ‰” ¤‚Š‡“‚ˆç¡,s00=s30s31,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 's,â‹ †Æ ‰ì“†¤‹ „ì‹ µ‰” ¤‚Š‡“‚ˆç¡,s00=s30s31,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 8] = 's,Þèˆ‹• µ‰” ¤‚Š‡“‚ˆ‹ì,n00=s32,LENGTH(~{1~})'
    qbf-lang[ 9] = 's,Ø¡‹  ž¤è¢“‡ (User ID),s00=,USERID("RESULTSDB")'
    qbf-lang[10] = 's,â¤íö‹ä¢  ç¤ ,s00=,STRING(TIME;"HH:MM:SS")'

    qbf-lang[24] = 'Žç¢“† “‡¡ ‹¡‹ ¢á  Ð†„á‹ä Ð‹ä Š  †” ¡‚¢Š†á ¢† ¡í  ¢“è‰‡ '
		 + '¢“‡¡ †ˆ“ìÐ—¢‡ è †Ð‚‰íŒ“† <<¢“ Š†¤è “‚è>> Æ‚  ¡  Ð ¤†ƒš‰‰†“† '
		 + 'í¡   ‰” ¤‚Š‡“‚ˆ † ¢“ Š†¤è “‚è.'
    qbf-lang[25] = 'â‹ SUBSTRING ¢ • „á¡†‚ “‡ „ä¡ ““‡“  ¡   Ð‹‹¡ç¢†“† í¡  '
		 + '“è  †¡•  ‰” ¤‚Š‡“‚ˆ‹ì Æ‚  †”š¡‚¢‡. Ð‚‰íŒ“† “‡¡ '
		 + '‹¡‹ ¢á  Ð†„á‹ä.'  
    qbf-lang[26] = 'Ò Š‹¤á¢“† “‹¡ Ð¤ç“‹ ö ¤ ˆ“è¤  “‹ä “è “‹• “‹ä  ‰” ¤‚Š‡“‚ˆ‹ì'
    qbf-lang[27] = 'Žç¢“† “‹¡  ¤‚Š ö ¤ ˆ“è¤—¡ Ð‹ä Ší‰†“† ¡   Ð‹‹¡ç¢†“†'
    qbf-lang[28] = 'Ð‚‰íŒ“† “‡¡ Ð¤ç“‡ “‚è'
    qbf-lang[29] = 'Ð‚‰íŒ“† “‡¡ †Ð†¡‡ “‚è'
    qbf-lang[30] = 'Ð‚‰íŒ“† “‹¡ Ð¤ç“‹ ¢“‹‚ö†á‹ Æ‚  ¢ìÆˆ¤‚¢‡'
    qbf-lang[31] = 'Ð‚‰íŒ“† “‹ „†ì“†¤‹ ¢“‹‚ö†á‹ Æ‚  ¢ìÆˆ¤‚¢‡'
    qbf-lang[32] = 'Ø  ¤‚Š• Ð‹ä „á¡†“ ‚  ¡“‚¢“‹‚ö†á ¢“‹ èˆ‹• “‹ä †Ð‚‰†Æí¡‹ä '
		 + ' ‰” ¤‚Š‡“‚ˆ‹ì.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - numeric expressions */
IF qbf-s = 6 THEN
  ASSIGN
    qbf-lang[ 1] = 'n,à“ Š†¤ è Ñ†„á‹,n00=n26,~{1~}'
    qbf-lang[ 2] = 'n,â‹ Þ‚ˆ¤“†¤‹ „ì‹  ¤‚Šç¡,n00=n24n25,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 3] = 'n,â‹ Þ†Æ ‰ì“†¤‹ „ì‹  ¤‚Šç¡,n00=n24n25,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 4] = 'n,åÐ‰‹‚Ð‹ Ž‚ á¤†¢‡• (MOD),n00=n31n32,~{1~} MODULO ~{2~}'
    qbf-lang[ 5] = 'n,µÐ‰ä“‡ â‚è,n00=n27,'
		 + '(IF ~{1~} < 0 THEN - ~{1~} ELSE ~{1~})'
    qbf-lang[ 6] = 'n,à“¤‹ÆÆä‰‹Ð‹á‡¢‡,n00=n28,ROUND(~{1~};0)'
    qbf-lang[ 7] = 'n,Ñ†¤‚ˆ‹Ðè,n00=n29,TRUNCATE(~{1~};0)'
    qbf-lang[ 8] = 'n,â†“¤ Æ—¡‚ˆè ¥á‘ ,n00=n30,SQRT(~{1~})'
    qbf-lang[ 9] = 'n,”š¡‚¢‡ “‡• ç¤ •,s00=n23,STRING(INTEGER(~{1~});"HH:MM:SS")'

    qbf-lang[23] = 'Ð‚‰íŒ“† “‹ Ðí„‚‹ Æ‚  †”š¡‚¢‡ —• HH:MM:SS'
    qbf-lang[24] = 'Ð‚‰íŒ“† “‹ Ð¤ç“‹ ¢“‹‚ö†á‹ Æ‚  ¢ìÆˆ¤‚¢‡'
    qbf-lang[25] = 'Ð‚‰†Œ“† “‹ „†ì“†¤‹ ¢“‹‚ö†á‹ Æ‚  ¢ìÆˆ¤‚¢‡'
    qbf-lang[26] = 'Žç¢“† “‡¡ ‹¡‹ ¢á  Ð†„á‹ä Ð‹ä Š  †” ¡‚¢Š†á ¢† ¡í  ¢“è‰‡ '
		 + '¢“‡¡ †ˆ“ìÐ—¢‡ è †Ð‚‰íŒ“† <<¢“ Š†¤è “‚è>> Æ‚  ¡  Ð ¤†ƒš‰†“† '
		 + 'á  ¢“ Š†¤è  ¤‚Š‡“‚ˆè “‚è.'
    qbf-lang[27] = 'Ð‚‰íŒ“† †¡  Ð†„á‹ Ð‹ä Š  †” ¡‚¢Š†á —•  Ð‰ä“‡ “‚è '
		 + '(ö—¤á• Ð¤¢‡‹).'
    qbf-lang[28] = 'Ð‚‰íŒ“† í¡  Ð†„á‹ Ð‹ä Š  ¢“¤ÆÆä‰‹Ð‹‚‡Š†á ¢“‹ Ð‰‡¢‚í¢“†¤‹  ˆí¤ ‚‹.'
    qbf-lang[29] = 'Ð‚‰íŒ“† í¡  Ð†„á‹ Æ‚  Ð†¤‚ˆ‹Ðè ( ” á¤†¢‡ “‹ä „†ˆ „‚ˆ‹ì í¤‹•).'
    qbf-lang[30] = 'Ð‚‰íŒ“† í¡  Ð†„á‹ Æ‚  äÐ‹‰‹Æ‚¢ “‡• “†“¤ Æ—¡‚ˆè• ¤á‘ •.'
    qbf-lang[31] = 'â‹ äÐ‰‹‚Ð‹ “‡• Ð¤šŒ‡• : „‚ ‚¤†“í‹• / „‚ ‚¤í“‡• = Ð‡‰áˆ‹ '
		 + '+ äÐ‰‹‚Ð‹.  Žç¢“† “‹¡ „‚ ‚¤†“í‹'
    qbf-lang[32] = 'Žç¢“† “‹¡ „‚ ‚¤í“‡'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - date expressions */
IF qbf-s = 7 THEN
  ASSIGN
    qbf-lang[ 1] = 'd,à‡†¤‚¡è €†¤‹‡¡á ,d00=,TODAY'
    qbf-lang[ 2] = 'd,Ñ¤‹¢Šèˆ‡ €†¤ç¡ ¢† €†¤‹‡¡á ,d00=d22n23,~{1~} + ~{2~}'
    qbf-lang[ 3] = 'd,µ” á¤†¢‡ €†¤ç¡  Ð €†¤‹‡¡á ,d00=d22n24,~{1~} - ~{2~}'
    qbf-lang[ 4] = 'd,Ž‚ ”‹¤š †“ Œì „ì‹ €†¤‹‡¡‚ç¡,n00=d25d26,~{1~} - ~{2~}'
    qbf-lang[ 5] = 'd,€ Ñ¤‹Æ†¡í¢“†¤‡ „ä‹ €†¤‹‡¡‚ç¡,d00=d20d21,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 6] = 'd,€ Þ†“ Æ†¡í¢“†¤‡ „ì‹ €†¤‹‡¡‚ç¡,d00=d20d21,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 'd,€ ‡í¤  —•  ¤‚Š•,n00=d27,DAY(~{1~})'
    qbf-lang[ 8] = 'd,â‹ Þè¡  —•  ¤‚Š•,n00=d28,MONTH(~{1~})'
    qbf-lang[ 9] = 'd,€ Ø¡‹ ¢á  “‹ä Þè¡ ,s00=d29,ENTRY(MONTH(~{1~});" ¡‹äš¤‚‹•'
		 + ';™†ƒ¤‹äš¤‚‹•;Þš¤“‚‹•;µÐ¤á‰‚‹•;Þ £‹•;‹ì¡‚‹•;‹ì‰‚‹•;µìÆ‹ä¢“‹•;à†Ð“íƒ¤‚‹•'
		 + ';Øˆ“çƒ¤‚‹•;Ö‹íƒ¤‚‹•;Ž†ˆíƒ¤‚‹•")'
    qbf-lang[10] = 'd,â‹ “‹• —• µ¤‚Š•,n00=d30,YEAR(~{1~})'
    qbf-lang[11] = 'd,€ €í¤  “‡• ƒ„‹š„ •,n00=d31,WEEKDAY(~{1~})'
    qbf-lang[12] = 'd,€ Ø¡‹ ¢á  “‡• €í¤ •,s00=d32,ENTRY(WEEKDAY(~{1~});"'
		 + 'Òä¤‚ ˆè;Ž†ä“í¤ ;â¤á“‡;â†“š¤“‡;ÑíÐ“‡;Ñ ¤ ¢ˆ†äè;àšƒƒ “‹")'

    qbf-lang[20] = 'Ð‚‰íŒ“† “‹ Ð¤ç“‹ ¢“‹‚ö†á‹ Æ‚  ¢ìÆˆ¤‚¢‡'
    qbf-lang[21] = 'Ð‚‰íŒ“† “‹ „†ì“†¤‹ ¢“‹‚ö†á‹ Æ‚  ¢ìÆˆ¤‚¢‡'
    qbf-lang[22] = 'Ð‚‰íŒ“† “‹ Ð†„á‹ ‡†¤‹‡¡á •.'
    qbf-lang[23] = 'Ð‚‰íŒ“† “‹ Ð†„á‹ Ð‹ä Ð†¤‚íö†‚ “‹¡  ¤‚Š ‡†¤ç¡ Ð‹ä '
		 + 'Š  Ð¤‹¢“†Š†á ¢“‡¡ ‡†¤‹‡¡á .'
    qbf-lang[24] = 'Ð‚‰íŒ“† “‹ Ð†„á‹ Ð‹ä Ð†¤‚íö†‚ “‹¡  ¤‚Š ‡†¤ç¡ Ð‹ä '
		 + 'Š   ” ‚¤†Š†á  Ð “‡¡ ‡ ¤‹‡¡á .'
    qbf-lang[25] = 'àìÆˆ¤‚¢‡ „ì‹ ‡†¤‹‡¡‚ç¡ ˆ ‚ ‡ †”š¡‚¢‡ ¢“è‰‡• Ð‹ä Ð†¤‚íö†‚ '
		 + '“‡ „‚ ”‹¤š †“ Œì “‹ä•, ¢† ‡í¤†•.  Ð‚‰íŒ“† “‹ '
		 + 'Ð¤ç“‹ Ð†„á‹.'
    qbf-lang[26] = 'Ð‚‰íŒ“† “‹ „†ì“†¤‹ Ð†„á‹ ‡†¤‹‡¡á •.'
    qbf-lang[27] = '€ ‡í¤  “‹ä è¡  —•  ¤‚Š•  Ð '
		 + '1 í—• 31.'
    qbf-lang[28] = 'â‹ è¡  “‹ä í“‹ä• —•  ¤‚Š•  Ð '
		 + '1 í—• 12.'
    qbf-lang[29] = '€ ‹¡‹ ¢á  “‹ä è¡ .'
    qbf-lang[30] = 'â‹ í¤‹• “‹ä í“‹ä• “‡• ‡†¤‹‡¡á • —•  ˆí¤ ‚‹•  ¤‚Š•.'
    qbf-lang[31] = 'Ø  ¤‚Š• Ð‹ä  ¡“‚¢“‹‚ö†á † “‡¡ ‡í¤ , ‡ Òä¤‚ ˆè †á¡ ‚ 1.'
    qbf-lang[32] = '€ ‹¡‹ ¢á  “‡• ‡í¤ • “‡• †ƒ„‹š„ •.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - mathematical expressions */
IF qbf-s = 8 THEN
  ASSIGN
    qbf-lang[ 1] = 'm,Ñ¤¢Š†¢‡,n00=n25n26m...,~{1~} + ~{2~}'
    qbf-lang[ 2] = 'm,µ” á¤†¢‡,n00=n25n27m...,~{1~} - ~{2~}'
    qbf-lang[ 3] = 'm,Ñ‹‰‰ Ð‰ ¢‚ ¢•,n00=n28n29m...,~{1~} * ~{2~}'
    qbf-lang[ 4] = 'm,Ž‚ á¤†¢‡,n00=n30n31m...,~{1~} / ~{2~}'
    qbf-lang[ 5] = 'm,å›—¢† ¢† „ì¡ ‡,n00=n25n32m...,EXP(~{1~};~{2~})'

    qbf-lang[25] = 'Žç¢“† “‹¡ Ð¤ç“‹  ¤‚Š'
    qbf-lang[26] = 'Žç¢“† “‹¡ †Ð†¡‹  ¤‚Š Æ‚  Ð¤¢Š†¢‡'
    qbf-lang[27] = 'Žç¢“† “‹¡ †Ð†¡‹  ¤‚Š Æ‚   ” á¤†¢‡'
    qbf-lang[28] = 'Žç¢“† “‹¡ Ð‹‰‰ Ð‰ ¢‚ ¢“í‹'
    qbf-lang[29] = 'Žç¢“† “‹¡ Ð‹‰‰ Ð‰ ¢‚ ¢“è'
    qbf-lang[30] = 'Žç¢“† “‹¡ „‚ ‚¤†“í‹'
    qbf-lang[31] = 'Žç¢“† “‹¡ „‚ ‚¤í“‡'
    qbf-lang[32] = 'Žç¢“† “‡ „ì¡ ‡'.

/*--------------------------------------------------------------------------*/

RETURN.
