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
/**************************************************************************
    Procedure:  _osprefx.p
    
    Purpose:    Returns a file spec's path prefix and basename.

    Syntax :
    Parameters:
    Description:
    
    Notes  :
    Authors: Warren Bare
    Date   : 
    Updated: 
**************************************************************************/

/* ksu 94/02/24 SUBSTRING use default mode */
DEFINE INPUT  PARAMETER filename AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER fiprefix AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER basename AS CHARACTER NO-UNDO.
DEFINE VARIABLE i AS INTEGER NO-UNDO.

ASSIGN basename = TRIM(filename).

IF CAN-DO("WIN32,MSDOS,UNIX":u,OPSYS) THEN DO:
  i = R-INDEX(basename,":":u).
  IF i > 0 THEN
    basename = SUBSTRING(basename,i + 1,-1,"CHARACTER":u).
END.

IF CAN-DO("WIN32,MSDOS,UNIX":u,OPSYS) THEN DO:
  i = MAXIMUM(R-INDEX(basename,"~\":u),R-INDEX(basename,"/":u)).
  IF i > 0 THEN
  DO:
    /* WIN95-UNC - Check for UNC \\SERVER\SHARE and treat it like a
       drive specification. In which case, there is no basename and
       the prefix is the UNC or drive spec.  - jep 12/14/95 */
    IF basename BEGINS "~\~\":u AND NUM-ENTRIES(basename, "~\") <= 4 THEN
      basename = "".
    ELSE
      basename = SUBSTRING(basename,i + 1,-1,"CHARACTER":u).
  END.
END.

fiprefix = SUBSTRING(filename,1,LENGTH(filename,"CHARACTER":u) 
                     - LENGTH(basename,"CHARACTER":u),"CHARACTER":u).
RETURN.
