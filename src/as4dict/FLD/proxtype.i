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

/*----------------------------------------------------------------------------

File: proxtype.i

Description:
   Set default values based on the chosen data type.

   This include will be used to determine the DDS Type code based on the
   p__Field._Fld-Stdtype.  These variables must be kept in sync with
   as4/as4_type.p.  There is also a file on the AS400 called proxtype
   which contains the same information contained in this include and the
   as4/as4_type.p.

Arguments:
   &prefix = The buffer name b_Field from new field procedure
                     or as4dict.p__field from the load procedures
                     
Created 01/05/95 D. McMann
Modified:
        05/15/98 D. McMann Added default format variable.
        08/16/00 D. McMann Added Raw Data Type Support
*/    

DEFINE VARIABLE fdtcode  AS INTEGER EXTENT 27 INITIAL
    [ 31,41, 33, 34, 42, 35, 36, 37, 38, 39, 40,   
      71, 72, 73, 74, 75, 76, 77, 78, 79, 
      80, 81, 82, 83, 84, 85, 86 ] NO-UNDO.   
DEFINE VARIABLE ddstype  AS CHARACTER EXTENT 27 INITIAL
  [ "A","A", "S", "P", "P", "B", "B", "F", "F", "A", "A",  
    "L", "L", "L", "L", "L", "L", "L", "L",
    "T", "T", "T", "T", "T", "Z", "A", "H" ] NO-UNDO.
    
DEFINE VARIABLE dftfmt AS CHARACTER EXTENT 27 INITIAL
  [ "x(8)", "x(8)", "->>,>>>,>>9.99", "->>>,>>>,>>9.99",
    "->,>>>,>>>,>>9.99", "->>,>>9", "->>>,>>>,>>9", "->,>>>,>>9",
    "->>>,>>>,>>9", "yes/no", "x(8)", "99/99/99", "99/99/99",
    "99/99/99", "99/99/99", "99/99/99", "99/99/99",
    "99/99/99", "99/99/99", "x(8)", "x(8)",
    "x(8)", "x(8)", "x(8)", "x(26)", ">>>>>>9", "x(256)" ] NO-UNDO.
    
DEFINE VARIABLE dpos AS INTEGER NO-UNDO.

IF {&prefix}._Fld-stdtype = 0 THEN ASSIGN dpos = 1.     

ELSE
DO dpos = 1 TO 27:
  IF fdtcode[dpos] = {&prefix}._Fld-stdtype THEN LEAVE. 
END.

