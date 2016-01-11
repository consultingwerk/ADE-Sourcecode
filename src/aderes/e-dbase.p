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
/* Progress Lex Converter 7.1A->7.1C Version 1.26 */
 
/* e-dbase.p - program to dump data in various dbase formats */
 
{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/e-define.i }
{ aderes/j-define.i }
 
DEFINE INPUT PARAMETER qbf-s  AS CHARACTER NO-UNDO. /* Prolog, Body, Epilog */
DEFINE INPUT PARAMETER qbf-n  AS CHARACTER NO-UNDO. /* field name */
DEFINE INPUT PARAMETER qbf-l  AS CHARACTER NO-UNDO. /* field label */
DEFINE INPUT PARAMETER qbf-f  AS CHARACTER NO-UNDO. /* field format */
DEFINE INPUT PARAMETER qbf-p  AS INTEGER   NO-UNDO. /* field position */
DEFINE INPUT PARAMETER qbf-t  AS INTEGER   NO-UNDO. /* field datatype */
DEFINE INPUT PARAMETER qbf-m  AS CHARACTER NO-UNDO. /* left margin */
DEFINE INPUT PARAMETER qbf-b  AS LOGICAL   NO-UNDO. /* is first field? */
DEFINE INPUT PARAMETER qbf-e  AS LOGICAL   NO-UNDO. /* is last field? */
DEFINE INPUT PARAMETER lkup   AS LOGICAL   NO-UNDO. /* is it a lookup field? */
DEFINE INPUT PARAMETER nm-val AS CHARACTER NO-UNDO. /* no match value (lookup)*/
 
DEFINE VARIABLE qbf-2 AS LOGICAL   NO-UNDO. /* dbase-2? */
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO. /* scrap */
 
FIND FIRST qbf-esys.
IF NOT CAN-DO("DBASE-2,DBASE-3,DBASE-3+,DBASE-4":u,qbf-esys.qbf-type)
  THEN RETURN.
 
qbf-2 = (qbf-esys.qbf-type = "DBASE-2":u).
 
CASE qbf-s:
  WHEN "p":u THEN DO: /*----------------------------------------------------*/
    IF qbf-b THEN
      ASSIGN
        qbf-esys.qbf-code[1] = FILL(",":u,qbf-rc# - 1) /* name */
        qbf-esys.qbf-code[2] = FILL(",":u,qbf-rc# - 1) /* type */
        qbf-esys.qbf-code[3] = FILL(",":u,qbf-rc# - 1) /* length */
        qbf-esys.qbf-code[4] = FILL(",":u,qbf-rc# - 1) /* decimals */
        qbf-esys.qbf-width   = 1.
    /*
    Calculate record width as 1 (for delete flag) + sum of widths of all
    fields based on their _format_, not their normal PROGRESS column
    width (which is the greater of the width of the format and the width
    of the label).
    */
 
    IF (qbf-p <= 32 AND qbf-2) OR qbf-p <= 128 THEN DO:
      RUN convert_name (qbf-n,OUTPUT qbf-c).
      ASSIGN
        ENTRY(qbf-p,qbf-esys.qbf-code[1]) = qbf-c
        ENTRY(qbf-p,qbf-esys.qbf-code[2])
              = SUBSTRING(STRING(qbf-2,"CCLNN/CDLNN"),qbf-t,1,"CHARACTER":u)
        qbf-i = (IF     qbf-t = 1 THEN LENGTH(STRING("",qbf-f),"CHARACTER":u)
                ELSE IF qbf-t = 2 THEN 8 /* date width-pixels = 8 */
                ELSE IF qbf-t = 3 THEN 1 /* logi width-pixels = 1 */
                ELSE                   LENGTH(STRING(0,qbf-f),"CHARACTER":u))
        ENTRY(qbf-p,qbf-esys.qbf-code[3]) = STRING(qbf-i)
        qbf-esys.qbf-width = qbf-esys.qbf-width + qbf-i
        qbf-i = 0.
      IF qbf-t = 4 OR qbf-t = 5 THEN RUN decimal_places (qbf-f,OUTPUT qbf-i).
      ENTRY(qbf-p,qbf-esys.qbf-code[4]) = STRING(qbf-i).
    END.
 
    IF qbf-e THEN DO:
      RUN header_prefix.
 
      DO qbf-i = 1 TO qbf-p:
        qbf-c = ENTRY(qbf-i,qbf-esys.qbf-code[1]).
        PUT UNFORMATTED SKIP
          /* <- name */
          '  "':u qbf-c '"':u FILL(' ':u,10 - LENGTH(qbf-c,"CHARACTER":u)) 
          ' NULL':u
          (IF LENGTH(qbf-c,"CHARACTER":u) = 10 THEN
            '   ':u
          ELSE
            '(':u + STRING(11 - LENGTH(qbf-c,"CHARACTER":u)) + ')':u
          )
          ' "':u ENTRY(qbf-i,qbf-esys.qbf-code[2]) '"':u    /* <- type     */
          ' CHR(':u ENTRY(qbf-i,qbf-esys.qbf-code[3]) ')':u /* <- length   */
          ' NULL(':u (IF qbf-2 THEN 2 ELSE 4) ')':u         /* <- reserved */
          (IF INTEGER(ENTRY(qbf-i,qbf-esys.qbf-code[4])) = 0 THEN /*  decs */
            ' NULL':u
          ELSE
            ' CHR(':u + ENTRY(qbf-i,qbf-esys.qbf-code[4]) + ')':u
          )
          (IF qbf-2 THEN '' ELSE ' NULL(14)':u).            /* <- padding  */
      END.
 
      /* II & III use 'cr' to terminate field list.  III+ and IV do not. */
      IF CAN-DO("DBASE-2,DBASE-3":u,qbf-esys.qbf-type) THEN
        PUT UNFORMATTED SKIP '  CHR(13)':u.
      /* pad out II header. */
      IF qbf-2 AND qbf-rc# < 32 THEN
        PUT UNFORMATTED ' NULL(':u (32 - MINIMUM(qbf-rc#,32)) * 16 ')':u.
      PUT UNFORMATTED '.':u SKIP(1).
    END.
 
  END. /*-------------------------------------------------------------------*/
  WHEN "b":u THEN DO: /*----------------------------------------------------*/
    IF qbf-b THEN
      PUT UNFORMATTED
        '  PUT UNFORMATTED':u SKIP
        '    " " /* delete flag */':u.
 
    CASE qbf-t:
      WHEN 1 THEN /* character */
        PUT UNFORMATTED SKIP
          '    (IF ':u qbf-n ' = ? THEN':u SKIP
          '      "?':u FILL(' ':u,LENGTH(STRING("",qbf-f),"CHARACTER":u) - 1) 
          '"':u SKIP
          '    ELSE':u SKIP
          '      STRING(':u qbf-n ',"':u qbf-f '"))':u.
      WHEN 2 THEN /* date */
        PUT UNFORMATTED SKIP
          '    (IF ':u qbf-n ' = ? THEN':u SKIP
          '      "        "':u SKIP
          '    ELSE':u SKIP
          '      STRING(YEAR(':u qbf-n '),"9999")':u SKIP
          '      + STRING(MONTH(':u qbf-n '),"99")':u SKIP
          '      + STRING(DAY(':u qbf-n '),"99")':u SKIP
          '    )':u.
      WHEN 3 THEN /* logical */
        PUT UNFORMATTED SKIP
          '    (IF ':u qbf-n ' THEN':u
          '      "Y"':u SKIP
          '    ELSE IF NOT ':u qbf-n ' THEN':u
          '      "N"':u
          '    ELSE':u
          '      "?")':u.
      OTHERWISE /* 4 = integer & 5 = decimal */
        PUT UNFORMATTED SKIP
          '    (IF ':u qbf-n ' = ? THEN':u SKIP
          '      "?':u FILL(' ':u,LENGTH(STRING(0,qbf-f),"CHARACTER":u) - 1) 
          '"':u SKIP
          '    ELSE':u SKIP
          '      STRING(':u qbf-n ',"':u qbf-f '"))':u.
    END CASE.
 
    IF qbf-e OR qbf-p MODULO 4 = 0 THEN PUT UNFORMATTED '.':u SKIP.
    IF NOT qbf-e AND qbf-p MODULO 4 = 0 THEN
      PUT UNFORMATTED '  PUT UNFORMATTED':u.
  END. /*-------------------------------------------------------------------*/
  WHEN "e":u THEN DO: /*----------------------------------------------------*/
    IF qbf-e THEN
      PUT UNFORMATTED
        'PUT UNFORMATTED CHR(26).':u SKIP.
    IF qbf-e AND qbf-2 THEN
      PUT UNFORMATTED
        'IF SEEK(OUTPUT) MODULO 512 > 0 THEN':u SKIP
        '  PUT CONTROL NULL(512 - (SEEK(OUTPUT) MODULO 512)).':u SKIP(1).
  END. /*-------------------------------------------------------------------*/
END CASE.
 
RETURN.
 
/*----------------------------------------------------------------------------
HEADER STRUCTURE:
 
I have included a dump from a sample of each dBASE version.  The notes
are not complete, but they cover all that is necessary for this program
to write the output.  Reserved fields or data types that RESULTS does
not need (e.g. 'M'emo or 'F'loat) are not covered.
 
dBASE II:---------------------------------------------------------------------
00000000: 02                                        |.|
  file id byte.  0x02 for dBASE II.
 
00000001:   04 00                                    |..|
  number of records.  2 bytes.  lsb, msb.
 
00000003:        0a 0a58                               |..X|
  date.  month, day, year - 1900.
 
00000006:                5c00                             |\.|
  record size.  2 bytes.  lsb, msb.
 
00000008: 0000 004e 0400 0000  4e41 4d45 0000 0000  |...N....NAME....|
00000020: 0000 0043 1400 0000  4144 4452 4553 5300  |...C....ADDRESS.|
00000030: 0000 0043 1400 0000  4144 4452 4553 5332  |...C....ADDRESS2|
00000040: 0000 0043 1400 0000  4349 5459 0000 0000  |...C....CITY....|
00000050: 0000 0043 0f00 0000  5354 0000 0000 0000  |...C....ST......|
00000060: 0000 0043 0200 0000  5a49 5000 0000 0000  |...C....ZIP.....|
00000070: 0000 004e 0500 0000  4352 4544 4954 0000  |...N....CREDIT..|
00000080: 0000 004e 0500 0000  0d00 0000 0000 0000  |...N............|
00000090: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
000000a0: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
000000b0: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
000000c0: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
000000d0: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
000000e0: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
000000f0: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
00000100: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
00000110: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
00000120: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
00000130: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
00000140: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
00000150: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
00000160: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
00000170: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
00000180: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
00000190: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
000001a0: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
000001b0: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
000001c0: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
000001d0: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
000001e0: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
000001f0: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
00000200: 0000 0000 0000 0000  00                   |.........|
  field header.  each entry 16 bytes, always padded to 32 entries.
  each field consists of:
  11 bytes - null-terminated and null-padded field name.
  1  byte  - datatype - 'C'haracter 'N'umeric 'L'ogical.
  1  byte  - field length.
  2  bytes - internal dBASE use.
  1  byte  - decimal places.
  First byte of field name replaced with 0x0D after last field.  If all
  32 fields used, a single 0x0D terminates the list.  The first record
  always starts at offset 521.
 
00000209:                        20 2020 2031 5374           |    1St|
00000210: 6f72 7920 426f 6f6b  204f 6e65 2020 2020  |ory Book One    |
00000220: 2020 3120 4d61 696e  2073 7472 6565 7420  |  1 Main street |
00000230: 2020 2020 2020 7375  6974 6520 3230 3020  |      suite 200 |
00000240: 2020 2020 2020 2020  2020 626f 7374 6f6e  |          boston|
00000250: 2020 2020 2020 2020  206d 6131 3231 3231  |         ma12121|
00000260: 2032 3330 3020 2020  2032 656e 676c 616e  | 2300    2englan|
00000270: 6420 6c74 6420 2020  2020 2020 2020 6173  |d ltd         as|
00000280: 6420 6173 6420 6173  6420 2020 2020 2020  |d asd asd       |
00000290: 2020 6173 6461 7364  2020 2020 2020 2020  |  asdasd        |
000002a0: 2020 2020 2020 6c6f  6e64 6f6e 2020 2020  |      london    |
000002b0: 2020 2020 206d 6131  3233 3233 2033 3430  |     ma12323 340|
000002c0: 3020 2020 2033 6375  7374 2033 2020 2020  |0    3cust 3    |
000002d0: 2020 2020 2020 2020  2020 3132 3331 3233  |          123123|
000002e0: 2020 2020 2020 2020  2020 2020 2020 3132  |              12|
000002f0: 3320 2020 2020 2020  2020 2020 2020 2020  |3               |
00000300: 2020 6861 7277 6963  6820 2020 2020 2020  |  harwich       |
00000310: 2063 7431 3233 3132  2020 3130 3020 2020  | ct12312  100   |
00000320: 2034 5365 636f 6e64  2053 746f 7279 2020  | 4Second Story  |
00000330: 2020 2020 2020 6173  6420 2020 2020 2020  |      asd       |
00000340: 2020 2020 2020 2020  2020 6173 6420 2020  |          asd   |
00000350: 2020 2020 2020 2020  2020 2020 2020 4261  |              Ba|
00000360: 6873 746f 6e20 2020  2020 2020 206d 6120  |hston        ma |
00000370: 3132 3334 2020 3130  301a 1a1a 1a1a 1a1a  |1234  100.......|
00000380: 1a1a 1a1a 1a1a 1a1a  1a1a 1a1a 1a1a 1a1a  |................|
00000390: 1a1a 1a1a 1a1a 1a1a  1a1a 1a1a 1a1a 1a1a  |................|
000003a0: 1a1a 1a1a 1a1a 1a1a  1a1a 1a1a 1a1a 1a1a  |................|
000003b0: 1a1a 1a1a 1a1a 1a1a  1a1a 1a1a 1a1a 1a1a  |................|
000003c0: 1a1a 1a1a 1a1a 1a1a  1a1a 1a1a 1a1a 1a1a  |................|
000003d0: 1a1a 1a1a 1a1a 1a1a  1a1a 1a1a 1a1a 1a1a  |................|
000003e0: 1a1a 1a1a 1a1a 1a1a  1a1a 1a1a 1a1a 1a1a  |................|
000003f0: 1a1a 1a1a 1a1a 1a1a  1a1a 1a1a 1a1a 1a1a  |................|
  Each record is preceded by a 1 byte delete flag: ' ' for in use, '*'
  for deleted.
  There are no other field or record delimiters.
  A 0x1A in the delete flag marks the end of the records.  The file is
  padded to a 512-byte multiple.
 
dBASE III:--------------------------------------------------------------------
00000000: 03                                        |.|
  file id byte.  0x03 for dBASE III.
 
00000001:   54 060e                                  |T..|
  date.  year - 1900, month, day.
 
00000004:           1f00 0000                           |....|
  number of records.  4 bytes.  lsb ... msb.
 
00000008:                      8201                         |..|
  offset to first record.
 
0000000a:                           5e00                      |^.|
  record size.  2 bytes.  lsb, msb.
 
0000000c:                                0000 0000              |....|
00000010: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
00000020: 4348 4543 4b5f 4441  5445 0044 0700 7336  |CHECK_DATE.D..s6|
00000030: 0800 0000 0000 0000  0000 0000 0000 0000  |................|
00000040: 4348 4543 4b5f 4e4d  4252 0043 0f00 7336  |CHECK_NMBR.C..s6|
00000050: 0500 0000 0000 0000  0000 0000 0000 0000  |................|
00000060: 434c 4945 4e54 0000  0000 0043 1400 7336  |CLIENT.....C..s6|
00000070: 0300 0000 0000 0000  0000 0000 0000 0000  |................|
00000080: 4a4f 425f 4e4d 4252  0000 004e 1700 7336  |JOB_NMBR...N..s6|
00000090: 0400 0000 0000 0000  0000 0000 0000 0000  |................|
000000a0: 414d 4f55 4e54 0000  0000 004e 1b00 7336  |AMOUNT.....N..s6|
000000b0: 0902 0000 0000 0000  0000 0000 0000 0000  |................|
000000c0: 4e41 4d45 0000 0000  0000 0043 2400 7336  |NAME.......C$.s6|
000000d0: 1400 0000 0000 0000  0000 0000 0000 0000  |................|
000000e0: 4445 5343 5249 5000  0000 0043 3800 7336  |DESCRIP....C8.s6|
000000f0: 1400 0000 0000 0000  0000 0000 0000 0000  |................|
00000100: 4249 4c4c 5f44 4154  4500 0044 4c00 7336  |BILL_DATE..DL.s6|
00000110: 0800 0000 0000 0000  0000 0000 0000 0000  |................|
00000120: 4249 4c4c 5f4e 4d42  5200 0043 5400 7336  |BILL_NMBR..CT.s6|
00000130: 0700 0000 0000 0000  0000 0000 0000 0000  |................|
00000140: 484f 5552 5300 0000  0000 004e 5b00 7336  |HOURS......N[.s6|
00000150: 0602 0000 0000 0000  0000 0000 0000 0000  |................|
00000160: 454d 505f 4e4d 4252  0000 004e 6100 7336  |EMP_NMBR...Na.s6|
00000170: 0300 0000 0000 0000  0000 0000 0000 0000  |................|
00000180: 0d                                        |.|
  field header.  each entry 32 bytes.
  each field consists of:
  11 bytes - null-terminated and null-padded field name.
  1  byte  - datatype - 'C'haracter 'N'umeric 'L'ogical 'D'ate.
  1  byte  - field length.
  4  bytes - internal dBASE use.
  1  byte  - decimal places.
  14 bytes - padding.
  A 0x0D as the first character of a field name terminates the list.
 
00000181:   20 2020 2020 2020  2020 2020 2020 2020   |               |
00000190: 4341 4c32 3332 3320  2031 3130 302e 3030  |CAL2323  1100.00|
000001a0: 574f 4c46 452c 2052  4943 4841 5244 2020  |WOLFE, RICHARD  |
000001b0: 2020 2020 5048 4f54  4f47 5241 5048 5920  |    PHOTOGRAPHY |
000001c0: 2020 2020 2020 2020  3037 3834 3037 3031  |        07840701|
000001d0: 3138 3131 3420 2020  2030 2e30 3020 2030  |18114    0.00  0|
000001e0: 2020 2020 2020 2020  2020 2020 20         |             |
000001ed:                                  20 4341               | CA|
000001f0: 4c32 3332 3320 2020  3233 302e 3030 464f  |L2323   230.00FO|
00000200: 4e54 2047 5241 5048  4943 5320 2020 2020  |NT GRAPHICS     |
00000210: 2020 5459 5045 5345  5454 494e 4720 2020  |  TYPESETTING   |
00000220: 2020 2020 2020 3037  3834 3037 3031 3435  |      0784070145|
00000230: 3136 2020 2020 2030  2e30 3020 2030 2031  |16     0.00  0 1|
00000240: 3938 3430 3731 322d  2d2d 2d20 4341 4c32  |9840712---- CAL2|
  :
  :
  :
00000c90: 2020 2020 4c47 5832  3435 3220 2020 3131  |    LGX2452   11|
00000ca0: 302e 3030 474c 4f42  414c 2043 4f4c 4f52  |0.00GLOBAL COLOR|
00000cb0: 2020 2020 2020 2020  5245 544f 5543 4849  |        RETOUCHI|
00000cc0: 4e47 2c20 4455 5045  2020 2020 3131 3834  |NG, DUPE    1184|
00000cd0: 3131 3231 3435 3333  2020 2020 2030 2e30  |11214533     0.0|
00000ce0: 3020 2030 1a                              |0  0.           |
  Each record is preceded by a 1 byte delete flag: ' ' for in use, '*'
  for deleted.
  There are no other field or record delimiters.
  A 0x1A in the delete flag marks the end of the records.
 
dBASE III+:-------------------------------------------------------------------
00000000: 83                                        |.|
  file id byte.  0x03 for dBASE III+.  0x83 indicates memo field.
 
00000001:   58 0c0e                                  |X..|
  date.  year - 1900, month, day.
 
00000004:           0300 0000                           |....|
  number of records.  4 bytes.  lsb ... msb.
 
00000008:                      0101                         |..|
  offset to first record.
 
0000000a:                           3400                      |4.|
  record size.  2 bytes.  lsb, msb.
 
0000000c:                                0000 0000              |....|
00000010: 0000 0000 0000 0000  0000 0000 0000 0000  |................|
00000020: 4355 5354 5f4e 554d  0000 004e 0900 6d46  |CUST_NUM...N..mF|
00000030: 0500 0000 0100 0000  0000 0000 0000 0000  |................|
00000040: 4e41 4d45 0000 0000  0000 0043 0e00 6d46  |NAME.......C..mF|
00000050: 1400 0000 0100 0000  0000 0000 0000 0000  |................|
00000060: 4d41 5843 5245 4449  5400 004e 2200 6d46  |MAXCREDIT..N".mF|
00000070: 0503 0000 0100 0000  0000 0000 0000 0000  |................|
00000080: 5354 4152 5445 4400  0000 0044 2700 6d46  |STARTED....D'.mF|
00000090: 0800 0000 0100 0000  0000 0000 0000 0000  |................|
000000a0: 4144 4452 4553 5300  0000 004c 2f00 6d46  |ADDRESS....L/.mF|
000000b0: 0100 0000 0100 0000  0000 0000 0000 0000  |................|
000000c0: 434f 4d4d 454e 5400  0000 004d 3000 6d46  |COMMENT....M0.mF|
000000d0: 0a00 0000 0100 0000  0000 0000 0000 0000  |................|
000000e0: 5354 0000 0000 0000  0000 0043 3a00 6d46  |ST.........C:.mF|
000000f0: 0200 0000 0100 0000  0000 0000 0000 0000  |................|
  field header.  each entry 32 bytes.
  each field consists of:
  11 bytes - null-terminated and null-padded field name.
  1  byte  - datatype - 'C'haracter 'N'umeric 'L'ogical 'D'ate.
  1  byte  - field length.
  4  bytes - internal dBASE use.
  1  byte  - decimal places.
  14 bytes - padding.
  There is no 0x0D to terminate the list, unlike II and III.
 
00000100: 2020 2020 2031 6665  696e 7374 6569 6e20  |     1feinstein |
00000110: 2020 2020 2020 2020  2020 312e 3233 3031  |          1.2301|
00000120: 3931 3231 3231 3259  2020 2020 2020 2020  |9121212Y        |
00000130: 2020 6d61 2020 2020  2032 746f 6e79 2020  |  ma     2tony  |
00000140: 2020 2020 2020 2020  2020 2020 2020 322e  |              2.|
00000150: 3330 3031 3934 3331  3232 334e 2020 2020  |30019431223N    |
00000160: 2020 2020 2020 6463  2020 2020 2033 6368  |      dc     3ch|
00000170: 7269 7320 7269 6365  2020 2020 2020 2020  |ris rice        |
00000180: 2020 2020 2020 2020  2020 2020 2020 2020  |                |
00000190: 2020 2020 2020 2020  2031 2020 1a         |         1  .   |
  Each record is preceded by a 1 byte delete flag: ' ' for in use, '*'
  for deleted.
  There are no other field or record delimiters.
  A 0x1A in the delete flag marks the end of the records.
 
dBASE IV:---------------------------------------------------------------------
00000000: 03                                        |.|
  file id byte.  0x03 for dBASE III+.  0x83 indicates memo field.
 
00000001:   58 0b1e                                  |X..|
  date.  year - 1900, month, day.
 
00000004:           0700 0000                           |....|
  number of records.  4 bytes.  lsb ... msb.
 
00000008:                      c100                         |..|
  offset to first record.
 
0000000a:                           1800                      |..|
  record size.  2 bytes.  lsb, msb.
 
0000000c:                                0000 0000              |....|
00000010: 0000 0000 0000 0000  0000 0000 0100 3901  |..............9.|
00000020: 4f52 4445 5200 0000  0000 004e 0900 2b7e  |ORDER......N..+~|
00000030: 0400 0000 0a00 0000  0000 0000 0000 0001  |................|
00000040: 4c49 4e45 0000 0000  0000 004e 0d00 2b7e  |LINE.......N..+~|
00000050: 0200 0000 0a00 0000  0000 0000 0000 0000  |................|
00000060: 4954 454d 0000 0000  0000 0043 0f00 2b7e  |ITEM.......C..+~|
00000070: 0700 0000 0a00 0000  0000 0000 0000 0001  |................|
00000080: 554e 4954 5300 0000  0000 004e 1600 2b7e  |UNITS......N..+~|
00000090: 0300 0000 0a00 0000  0000 0000 0000 0000  |................|
000000a0: 5052 4943 4500 0000  0045 004e 1900 2b7e  |PRICE......N..+~|
000000b0: 0702 0000 0a00 0000  0000 0000 0000 0000  |................|
  field header.  each entry 32 bytes.
  each field consists of:
  11 bytes - null-terminated and null-padded field name.
  1  byte  - datatype - 'C'haracter 'N'umeric 'L'ogical 'D'ate 'F'loat.
  1  byte  - field length.
  4  bytes - internal dBASE use.
  1  byte  - decimal places.
  14 bytes - padding.
  There is no 0x0D to terminate the list, unlike II and III.
 
000000c0: 2031 3030 3120 3157  4944 2d30 3031 2020  | 1001 1WID-001  |
000000d0: 3120 2031 302e 3030  2031 3030 3220 3157  |1  10.00 1002 1W|
000000e0: 4944 2d30 3033 2020  3520 2033 302e 3030  |ID-003  5  30.00|
000000f0: 2031 3030 3220 3257  4944 2d30 3032 2031  | 1002 2WID-002 1|
00000100: 3020 2032 302e 3030  2031 3030 3320 3157  |0  20.00 1003 1W|
00000110: 4944 2d30 3033 2020  3220 2033 302e 3030  |ID-003  2  30.00|
00000120: 2031 3030 3420 3157  4944 2d30 3031 2020  | 1004 1WID-001  |
00000130: 3420 2031 302e 3030  2031 3030 3420 3257  |4  10.00 1004 2W|
00000140: 4944 2d30 3032 2020  3520 2032 302e 3030  |ID-002  5  20.00|
00000150: 2031 3030 3420 3357  4944 2d30 3033 2031  | 1004 3WID-003 1|
00000160: 3020 2033 302e 3030  1a                   |0  30.00.|
  Each record is preceded by a 1 byte delete flag: ' ' for in use, '*'
  for deleted.
  There are no other field or record delimiters.
  A 0x1A in the delete flag marks the end of the records.
----------------------------------------------------------------------------*/
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE header_prefix:
  DEFINE VARIABLE qbf_i AS INTEGER NO-UNDO. /* scrap */
 
  PUT UNFORMATTED
    'DEFINE VARIABLE qbf-1 AS INTEGER NO-UNDO.':u SKIP
    'DEFINE VARIABLE qbf-2 AS INTEGER NO-UNDO.':u SKIP.
  IF NOT qbf-2 THEN
    PUT UNFORMATTED
      'DEFINE VARIABLE qbf-3 AS INTEGER NO-UNDO.':u SKIP
      'DEFINE VARIABLE qbf-4 AS INTEGER NO-UNDO.':u SKIP.
 
  /* version number: 2 for dbase-2, 3 for others */
  PUT UNFORMATTED
    'PUT CONTROL CHR(':u (IF qbf-2 THEN 2 ELSE 3) ').':u SKIP
    'ASSIGN':u SKIP.
 
  /* num records, lsb...msb order.  2-bytes for dbase-2, 4-bytes for others */
  IF qbf-2 THEN
    PUT UNFORMATTED
      '  qbf-1 = TRUNCATE(qbf-count / 256,0)':u SKIP
      '  qbf-2 = qbf-count MODULO 255.':u SKIP
      'IF qbf-2 = 0 THEN PUT CONTROL NULL. ELSE PUT CONTROL CHR(qbf-2).':u SKIP
      'IF qbf-1 = 0 THEN PUT CONTROL NULL. ELSE PUT CONTROL CHR(qbf-1).':u SKIP.
  ELSE
    PUT UNFORMATTED
      '  qbf-1 = TRUNCATE(qbf-count / 16777216,0)':u SKIP
      '  qbf-4 = qbf-4 - qbf-1 * 16777216':u         SKIP
      '  qbf-2 = TRUNCATE(qbf-4 / 65536,0)':u        SKIP
      '  qbf-4 = qbf-4 - qbf-2 * 65536':u            SKIP
      '  qbf-3 = TRUNCATE(qbf-4 / 256,0)':u          SKIP
      '  qbf-4 = qbf-4 - qbf-3 * 256.':u             SKIP
      'IF qbf-4 = 0 THEN PUT CONTROL NULL. ELSE PUT CONTROL CHR(qbf-4).':u SKIP
      'IF qbf-3 = 0 THEN PUT CONTROL NULL. ELSE PUT CONTROL CHR(qbf-3).':u SKIP
      'IF qbf-2 = 0 THEN PUT CONTROL NULL. ELSE PUT CONTROL CHR(qbf-2).':u SKIP
      'IF qbf-1 = 0 THEN PUT CONTROL NULL. ELSE PUT CONTROL CHR(qbf-1).':u SKIP.
 
  /* date: m/d/y for dbase-2, y/m/d for others */
  IF qbf-2 THEN
    PUT UNFORMATTED
      'PUT CONTROL':u SKIP
      '  CHR(MONTH(TODAY)) CHR(DAY(TODAY)) CHR(YEAR(TODAY) - 1900)':u SKIP.
  ELSE
    PUT UNFORMATTED
      'PUT CONTROL':u SKIP
      '  CHR(YEAR(TODAY) - 1900) CHR(MONTH(TODAY)) CHR(DAY(TODAY))':u SKIP.
 
  /* size of header (non-dbase-2 only) */
  qbf_i = qbf-rc# * 32 + 32
        + (IF qbf-esys.qbf-type = "DBASE-3":u THEN 1 ELSE 2).
  IF NOT qbf-2 THEN
    PUT UNFORMATTED
      (IF qbf_i MODULO 255 = 0 THEN
        '  NULL':u
      ELSE
        SUBSTITUTE('  CHR(&1)':u,qbf_i MODULO 255)
      )
      (IF qbf_i < 256 THEN
        ' NULL':u
      ELSE
        SUBSTITUTE(' CHR(&1)':u,TRUNCATE(qbf_i / 256,0))
      )
      SKIP.
 
  /* record length */
  PUT UNFORMATTED
    (IF qbf-esys.qbf-width MODULO 255 = 0 THEN
        '  NULL':u
      ELSE
        SUBSTITUTE('  CHR(&1)':u,qbf-esys.qbf-width MODULO 255)
      )
      (IF qbf-esys.qbf-width < 256 THEN
        ' NULL':u
      ELSE
        SUBSTITUTE(' CHR(&1)':u,TRUNCATE(qbf-esys.qbf-width / 256,0))
      )
      SKIP.
 
  /* pad out header prefix */
  IF NOT qbf-2 THEN PUT UNFORMATTED '  NULL(20)':u SKIP.
 
END PROCEDURE. /* header_prefix */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE convert_name:
  DEFINE INPUT  PARAMETER qbf_p AS CHARACTER NO-UNDO. /* progress name */
  DEFINE OUTPUT PARAMETER qbf_d AS CHARACTER NO-UNDO. /* dbase name */
 
  DEFINE VARIABLE qbf_l AS INTEGER           NO-UNDO. /* loop variable */
  DEFINE VARIABLE qbf_u AS INTEGER INITIAL 0 NO-UNDO. /* tie breaker */
 
  qbf_d = CAPS(SUBSTRING(ENTRY(3,ENTRY(1,qbf_p),".":u),1,10,"CHARACTER":u)).
 
  DO qbf_l = 1 TO LENGTH(qbf_d,"CHARACTER":u):
    IF INDEX("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789":u,
      SUBSTRING(qbf_d,qbf_l,1,"CHARACTER":u)) = 0 THEN
      SUBSTRING(qbf_d,qbf_l,1,"CHARACTER":u) = STRING(qbf-2,":/_":u).
  END.
 
  /* first character must be alphabetic */
  IF INDEX("ABCDEFGHIJKLMNOPQRSTUVWXYZ":u,
           SUBSTRING(qbf_d,1,1,"CHARACTER":u)) = 0 THEN
    SUBSTRING(qbf_d,1,1,"CHARACTER":u) = "Z":u.
 
  /* last character must be alphanumeric */
  IF SUBSTRING(qbf_d,LENGTH(qbf_d,"CHARACTER":u),1,"CHARACTER":u) = 
    STRING(qbf-2,":/_":u) THEN
    IF LENGTH(qbf_d,"CHARACTER":u) = 10 THEN
      SUBSTRING(qbf_d,10,1,"CHARACTER":u) = "1":u.
    ELSE
      qbf_d = qbf_d + "1":u.
 
  /* now make sure name is unique within record */
  DO WHILE LOOKUP(qbf_d,qbf-esys.qbf-code[1]) > 0:
    ASSIGN
      qbf_d = SUBSTRING(qbf_d + FILL(STRING(qbf-2,":/_":u),10),1,10,
                        "CHARACTER":u)
      qbf_u = qbf_u + 1
      SUBSTRING(qbf_d,11 - LENGTH(STRING(qbf_u),"CHARACTER":u),-1,
                "CHARACTER":u) = STRING(qbf_u).
  END.
END.
 
/*--------------------------------------------------------------------------*/
 
/* see y-guess.p for a more complete version of this code */
PROCEDURE decimal_places:
  DEFINE INPUT  PARAMETER qbf_f AS CHARACTER         NO-UNDO. /* format in */
  DEFINE OUTPUT PARAMETER qbf_n AS INTEGER INITIAL 0 NO-UNDO. /* # decs out */
  DEFINE VARIABLE qbf_i AS INTEGER NO-UNDO. /* loop */
  DEFINE VARIABLE qbf_s AS INTEGER NO-UNDO. /* state */
  /*
    0 = nothing
    1 = before decimal
    2 = after decimal
    9 = unknown - terminate parsing
  */
  DO qbf_i = 1 TO LENGTH(qbf_f,"CHARACTER":u) WHILE qbf_s <> 9:
    CASE qbf_s:
      WHEN 0 OR WHEN 1 THEN DO:
        IF INDEX("9Z*>,":u,SUBSTRING(qbf_f,qbf_i,1,"CHARACTER":u)) > 0 THEN 
          qbf_s = 1.
        ELSE IF SUBSTRING(qbf_f,qbf_i,1,"CHARACTER":u) = ".":u THEN qbf_s = 2.
        ELSE IF qbf_s = 1 THEN qbf_s = 9.
      END.
      WHEN 2 THEN DO:
        IF INDEX("9Z<":u,SUBSTRING(qbf_f,qbf_i,1,"CHARACTER":u)) > 0 THEN 
          qbf_n = qbf_n + 1.
        ELSE IF SUBSTRING(qbf_f,qbf_i,1,"CHARACTER":u) <> ",":u THEN qbf_s = 9.
      END.
    END CASE.
  END.
END.
 
/*--------------------------------------------------------------------------*/
 
/* e-dbase.p - end of file */

