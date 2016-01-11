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
/*
# PROGRESS RESULTS default system settings
config= language
version= 2.0H
#
#------------------------------------------------------------------------
#
# Edit the following line to set the default language for RESULTS.
language= "eng"
#
# Currently supported languages include:
#   cze - Czech
#   dan - Danish
#   dut - Dutch
#   eng - English
#   fin - Finnish
#   fr7 - French (7-bit)
#   fre - French (8-bit)
#   ger - German
#   gr7 - Greek (code page 928, ELOT)
#   gre - Greek (code page 437, PC)
#   hun - Hungarian
#   ita - Italian
#   nor - Norwegian
#   pol - Polish
#   por - Portuguese
#   spa - Spanish
#   sw7 - Swedish (7-bit)
#   swe - Swedish (8-bit)
#   tur - Turkish
#
#------------------------------------------------------------------------
#
# These are the left and right delimiters used in the reports headers
# and footers, as well as in the labels module.  They must be different
# symbols (you cannot use "/" and "/").  Recommended are the pairs "{"
# and "}" or "<" and ">".  "(" and ")" confuse the label-write code,
# so should not be used.  "[" and "]" can be used, as long as there are
# no arrays.
#
left-delim= "{"
right-delim= "}"
#
#------------------------------------------------------------------------
#
# This is a table of the default RESULTS export formats.  These are the
# formats that come up when you start RESULTS for the first time
# against a database with no .qc7.  You may change this list, but at
# your own risk.  Info in brackets are defaults.
#
# The codes used are:
#   b= base date or ? to export date as char (used for DIF)       [?]
#   d= data types to delimit with '3=' from below, or '*' for all [*]
#   f= fixed width export? 'y' or 'n'.                            [n]
#   h= include field headers? 'y' or 'n'.                         [n]
#   i= needs initial prepass to count records? 'y' or 'n'.        [n]
#   l= description of format
#   p= name of program that generates code.
#   t= format type.  must be unique.
#   1= line starter characters, comma-delimited                   []
#   2= line delimiter characters, comma-delimited                 []
#   3= field delimiter characters, comma-delimited                []
#   4= field separator characters, comma-delimited                []
#
export[1]= "t=PROGRESS|p=e-pro|2=32,13,10|3=34|4=32|l=PROGRESS Export"
export[2]= "t=ASCII|p=e-ascii|2=13,10|3=34|4=44|l=Generic ASCII"
export[3]= "t=ASCII-H|p=e-ascii|h=y|2=13,10|3=34|4=44|l=ASCII w/headers"
export[4]= "t=FIXED|p=e-ascii|f=y|2=13,10|3=34|4=44|l=Fixed-width ASCII"
export[5]= "t=FIXED-H|p=e-ascii|h=y|f=y|2=13,10|3=34|4=44|l=Fixed w/headers"
export[6]= "t=CSV|p=e-ascii|d=123|2=13,10|3=34|4=44|l=Comma Separated Value (CSV)"
#export[7]= "t=DBASE-2|p=e-dbase|h=y|f=y|1=32|l=dBASE II"
#export[8]= "t=DBASE-3|p=e-dbase|h=y|f=y|1=32|l=dBASE III"
#export[9]= "t=DBASE-3+|p=e-dbase|h=y|f=y|1=32|l=dBASE III+"
#export[10]= "t=DBASE-4|p=e-dbase|h=y|f=y|1=32|l=dBASE IV"
export[11]= "t=DIF|p=e-dif|l=DIF (dates as strings)"
export[12]= "t=DIF-DASN|p=e-dif|b=12/30/1899|l=DIF (dates as numbers)"
export[13]= "t=OFISW|p=e-ascii|h=y|1=42,124|2=10|4=124|l=CTOS/BTOS OfisWriter"
export[14]= "t=SDF|p=e-ascii|f=y|2=13,10|l=System Data Format"
export[15]= "t=SYLK|p=e-sylk|l=SYLK"
#export[16]= "t=123/1A|p=e-wks|l=Lotus 1-2-3/1A"
#export[17]= "t=123/2|p=e-wks|l=Lotus 1-2-3/2"
#export[18]= "t=SYM/1.0|p=e-wks|l=Symphony 1.0"
#export[19]= "t=SYM/1.1|p=e-wks|l=Symphony 1.1"
export[20]= "t=WORD|p=e-ascii|h=y|d=123|2=13,10|3=34|4=44|l=Microsoft Word"
export[21]= "t=WORD4WIN|p=e-ascii|h=y|d=123|2=13,10|4=9|l=MS Word for Windows"
export[22]= "t=WPERF|p=e-ascii|2=5|4=18|l=WordPerfect (w/o crlf)"
export[23]= "t=WPERF-CR|p=e-ascii|2=5,13,10|4=18,13,10|l=WordPerfect (crlf)"
export[24]= "t=WS|p=e-ascii|d=123|2=13,10|3=34|4=44|l=WordStar".
#
#------------------------------------------------------------------------
#
# This is a table of the standard RESULTS label dimensions.  These are
# the label types that come up when you start RESULTS for the first time
# against a database with no .qc7.  You may change this list, but at your
# own risk.  Info in brackets are defaults.
#
# Each group of formats may have a category name.  The description is a
# single string with the first character an asterisk "*".  This will be
# used in a future version of RESULTS to allow label subsetting.
#
# The codes used are:
#   a= number labels across       [default 1]
#   c= comments
#   d= dimensions (width x height) in inches
#   h= label height in lines
#   l= vert space between labels  [default 1]
#   s= horiz space between labels [default 0]
#   w= label width in chars
#   x= horiz origin on paper      [default 0]
#
label[1]= "*Standard Label Sizes"
label[2]= "d=3-1/2 x 15/16 in|w=35|h=5|c=1-wide"
label[3]= "d=3-1/2 x 15/16 in|w=35|h=5|a=2|s=2|c=2-wide"
label[4]= "d=3-1/2 x 15/16 in|w=35|h=5|a=3|s=2|c=3-wide"
label[5]= "d=3-1/2 x 15/16 in|w=35|h=5|a=4|s=2|c=4-wide"
label[6]= "d=4 x 1-7/16 in|w=40|h=8|c=Large Mailing Label"
label[7]= "d=3-2/10 x 11/12 in|w=32|h=5|a=3|s=2|c=Cheshire"
label[8]= "d=6-1/2 x 3-5/8 in|w=65|h=14|l=8|c=Envelope-Small"
label[9]= "d=9-7/8 x 7-1/8 in|w=78|h=17|l=8|c=Envelope-Large"
label[10]= "d=4 x 6 in|w=60|h=24|c=Post Cards"
label[11]= "d=3 x 5 in|w=50|h=14|l=4|c=Rolodex-Small"
label[12]= "d=4 x 2-1/4 in|w=40|h=10|c=Rolodex-Large"
label[13]= "d=8-1/2 x 11 in|x=10|w=65|h=60|l=6|c=Form Letter"
#
label[14]= "*Avery Catalog Labels"
label[15]= "d=3-1/2 x 15/16 in|w=35|h=5|c=Avery 4145 Address"
label[16]= "d=3-1/2 x 15/16 in|w=35|h=5|c=Avery 4010 Address (roll)"
label[17]= "d=3-1/2 x 15/16 in|w=35|h=5|c=Avery 4600 Address (bulk)"
label[18]= "d=3-1/2 x 15/16 in|w=35|h=5|a=2|s=2|c=Avery 4602 Address 2-wide (bulk)"
label[19]= "d=3-1/2 x 15/16 in|w=35|h=5|a=3|s=2|c=Avery 4603 Address 3-wide (bulk)"
label[20]= "d=4 x 1-7/16 in|w=40|h=8|c=Avery 4146 Address"
label[21]= "d=4 x 1-7/16 in|w=40|h=8|c=Avery 4011 Address (roll)"
label[22]= "d=4 x 1-7/16 in|w=40|h=8|c=Avery 4604 Address (bulk)"
label[23]= "d=4 x 1-7/16 in|w=40|h=8|a=2|s=2|c=Avery 4605 Address 2-wide (bulk)"
label[24]= "d=2-1/2 x 15/16 in|w=25|h=5|a=3|s=2|c=Avery 4144 Address 3-wide"
label[25]= "d=2-1/2 x 15/16 in|w=25|h=5|a=3|s=2|c=Avery 4610 Address 3-wide (bulk)"
label[26]= "d=4 x 15/16 in|w=40|h=5|a=2|s=2|c=Avery 4143 Address 2-wide"
label[27]= "d=4 x 15/16 in|w=40|h=5|a=2|s=2|c=Avery 4611 Address 2-wide (bulk)"
label[28]= "d=3-1/2 x 15/16 in|w=35|h=5|c=Avery 4162 Address - clear"
label[29]= "d=3-1/2 x 15/16 in|w=35|h=5|c=Avery 4601 Address - clear"
label[30]= "d=3-1/2 x 15/16 in|w=35|h=5|c=Avery 4249 Address - green"
label[31]= "d=3-1/2 x 15/16 in|w=35|h=5|c=Avery 4250 Address - red"
label[32]= "d=3-1/2 x 15/16 in|w=35|h=5|c=Avery 4251 Address - pink"
label[33]= "d=3-1/2 x 15/16 in|w=35|h=5|c=Avery 4253 Address - yellow"
label[34]= "d=3-1/2 x 15/16 in|w=35|h=5|c=Avery 4254 Address - red glow"
label[35]= "d=4 x 2-15/16 in|x=2|w=36|h=16|l=2|c=Avery 4161 Shipping - red border"
label[36]= "d=4 x 2-15/16 in|w=40|h=17|c=Avery 4162 Shipping (bulk)"
label[37]= "d=3-1/2 x 15/16 in|w=35|h=5|c=Avery 4163 Piggy-back Address Label"
label[38]= "d=2-7/16 x 3-1/2 in|x=3|w=30|h=13|l=2|c=Avery 4160 Name Badge"
label[39]= "d=2-3/4 x 2-3/4 in|w=27|h=16|c=Avery 4241 3-1/2"" Diskette"
label[40]= "d=2-3/4 x 2-3/4 in|w=27|h=16|c=Avery 4607 3-1/2"" Diskette (bulk)"
label[41]= "d=1-1/4 x 4-3/4 in|w=47|h=7|c=Avery 4240 5-1/4"" Diskette"
label[42]= "d=1-1/4 x 4-3/4 in|w=47|h=7|c=Avery 4606 5-1/4"" Diskette (bulk)"
label[43]= "d=7/16 x 3-1/2 in|w=35|h=2|c=Avery 4255 File Folder - white"
label[44]= "d=7/16 x 3-1/2 in|w=35|h=2|c=Avery 4256 File Folder - blue"
label[45]= "d=7/16 x 3-1/2 in|w=35|h=2|c=Avery 4257 File Folder - red"
label[46]= "d=7/16 x 3-1/2 in|w=35|h=2|c=Avery 4258 File Folder - green"
label[47]= "d=7/16 x 3-1/2 in|w=35|h=2|c=Avery 4259 File Folder - yellow"
label[48]= "d=7/16 x 3-1/2 in|w=35|h=2|c=Avery 4266 File Folder - assorted"
label[49]= "d=3/8 x 1-1/2 in|w=14|h=2|a=5|s=2|c=Avery 4609 Price Marking (bulk)"
label[50]= "d=5 x 3 in|w=50|h=16|l=2|c=Avery 4166 Index Card"
label[51]= "d=6 x 3-1/2 in|w=60|h=19|l=2|c=Avery 4167 Post Card"
label[52]= "d=4 x 2-1/6 in|w=40|h=16|c=Avery 4168 Rotary Index Card"
label[53]= "d=5 x 3 in|w=50|h=17|c=Avery 4169 Rotary Index Card"
#
#------------------------------------------------------------------------
#
# This is a table of the standard RESULTS page dimensions.  These are
# the paper sizes that come up when you start RESULTS for the first time
# against a database with no .qc7.  You may change this list, but at your
# own risk.
#
# The codes used are:
#   c= comments
#   d= dimensions (width x height)
#   h= page height in lines
#   w= page width in chars
#
#Graphics-Screen  7.822 x 11 in     78 x  66
#
page[1]= "d=8-1/2 x 11 in|w=85|h=66|c=Letter"
page[2]= "d=8-1/2 x 14 in|w=85|h=84|c=Legal"
page[3]= "d=11 x 17 in|w=110|h=102|c=Tabloid"
page[4]= "d=9-1/2 x 4-1/8 in|w=95|h=24|c=Envelope-#10"
page[5]= "d=229 x 162 mm|w=90|h=38|c=Envelope-C5"
page[6]= "d=220 x 110 mm|w=86|h=26|c=Envelope-DL"
page[7]= "d=7-1/2 x 3-7/8 in|w=75|h=23|c=Envelope-Monarch"
page[8]= "d=7-1/4 x 10-1/2 in|w=72|h=63|c=Executive"
page[9]= "d=297 x 420 mm|w=117|h=99|c=A3"
page[10]= "d=210 x 297 mm|w=82|h=70|c=A4"
page[11]= "d=148 x 210 mm|w=58|h=49|c=A5"
page[12]= "d=182 x 257 mm|w=71|h=60|c=B5"
page[13]= "d=7-1/3 x 11 in|w=73|h=66|c=35mm-Slide"
#------------------------------------------------------------------------
*/
