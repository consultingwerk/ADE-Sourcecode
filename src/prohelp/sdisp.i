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
DISPLAY
	  {&array}[01] @ disp-arr[01] {&array}[21] @ disp-arr[21]
	  {&array}[02] @ disp-arr[02] {&array}[22] @ disp-arr[22]
	  {&array}[03] @ disp-arr[03] {&array}[23] @ disp-arr[23]
	  {&array}[04] @ disp-arr[04] {&array}[24] @ disp-arr[24]
	  {&array}[05] @ disp-arr[05] {&array}[25] @ disp-arr[25]
	  {&array}[06] @ disp-arr[06] {&array}[26] @ disp-arr[26]
	  {&array}[07] @ disp-arr[07] {&array}[27] @ disp-arr[27]
	  {&array}[08] @ disp-arr[08] {&array}[28] @ disp-arr[28]
	  {&array}[09] @ disp-arr[09] {&array}[29] @ disp-arr[29]
	  {&array}[10] @ disp-arr[10] {&array}[30] @ disp-arr[30]
	  {&array}[11] @ disp-arr[11] {&array}[31] @ disp-arr[31]
	  {&array}[12] @ disp-arr[12] {&array}[32] @ disp-arr[32]
	  {&array}[13] @ disp-arr[13] {&array}[33] @ disp-arr[33]
	  {&array}[14] @ disp-arr[14] {&array}[34] @ disp-arr[34]
	  {&array}[15] @ disp-arr[15] {&array}[35] @ disp-arr[35]
	  {&array}[16] @ disp-arr[16] {&array}[36] @ disp-arr[36]
	  {&array}[17] @ disp-arr[17] {&array}[37] @ disp-arr[37]
	  {&array}[18] @ disp-arr[18] {&array}[38] @ disp-arr[38]
	  {&array}[19] @ disp-arr[19] {&array}[39] @ disp-arr[39]
	  {&array}[20] @ disp-arr[20] {&array}[40] @ disp-arr[40]
	  {&array}[41] @ disp-arr[41] {&array}[42] @ disp-arr[42]
	  {&array}[43] @ disp-arr[43] {&array}[44] @ disp-arr[44]
	  {&array}[45] @ disp-arr[45] {&array}[46] @ disp-arr[46]
	  {&array}[47] @ disp-arr[47] {&array}[48] @ disp-arr[48]
WITH FRAME disp-arr.

PUT SCREEN ROW 2 COLUMN 63
    COLOR MESSAGES ATTR-SPACE " PAGE " + "{&pagenum} OF 3 ".

IF {&pagenum} = 1 THEN
   PUT SCREEN ROW more-row COLUMN 63
       COLOR MESSAGES ATTR-SPACE  "   MORE >> ".
ELSE
IF {&pagenum} = 2 THEN
    PUT SCREEN ROW more-row COLUMN 63
	COLOR MESSAGES ATTR-SPACE " << MORE >> ".
ELSE
   PUT SCREEN ROW more-row COLUMN 63
       COLOR MESSAGES ATTR-SPACE  " << MORE   ".
