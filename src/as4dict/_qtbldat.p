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

File: _qtbldat.p

Description:
   Display _File information for the quick table report.  It will go to 
   the currently set output device (e.g., a file, the printer).
 
Input Parameters:
   p_DbId    - Id of the _Db record for this database.

Author: Tony Lavinio, Laura Stern

Date Created: 10/02/92
     Modified 02/10/95 for AS400 Data Dictionary - Donna McMann
----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_DbId AS RECID NO-UNDO.

DEFINE SHARED STREAM rpt.


DEFINE VARIABLE asname AS CHARACTER NO-UNDO.                                                      
DEFINE VARIABLE nmfld      AS CHARACTER NO-UNDO.
DEFINE VARIABLE nmkey    AS CHARACTER NO-UNDO.

FORM    
    as4dict.p__File._File-name  FORMAT "x(25)"  COLUMN-LABEL "Progress Name"    
   asname                         FORMAT "x(21)"  COLUMN-LABEL "AS/400 Name"
   as4dict.p__File._Dump-name  FORMAT "x(8)"   COLUMN-LABEL "Dump Name"
   nmfld           FORMAT "x(5)"  COLUMN-LABEL "Field!count"
   nmkey     FORMAT "x(5)"  COLUMN-LABEL "Index!Count"    
   WITH FRAME shotable USE-TEXT STREAM-IO DOWN.
          

FOR EACH as4dict.p__File WHERE as4dict.p__File._Hidden = "N":
   ASSIGN
      asname = as4dict.p__File._For-name
      nmfld = string(as4dict.p__file._numfld)
      nmkey =     string(as4dict.p__File._numkey).
    
   DISPLAY STREAM rpt
      as4dict.p__File._File-name
      asname
      nmfld 
      nmkey
      as4dict.p__File._Dump-name
      WITH FRAME shotable.
   DOWN STREAM rpt WITH FRAME shotable.
END.







