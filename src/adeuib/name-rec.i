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

File: name-rec.i

Description:
    This include file defines the name indirection TEMP-TABLE.  This assists in
    reading in files that contain widgets with names that are the same as
    existing widgets.  Each widget that is read in has its original name placed
    in this table and the recid of its universal widget record.  When subsequent
    information for this widget is found (Attributes and trigger information)
    the name is looked up in this table and the appropriate _U record is found.


Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1993

----------------------------------------------------------------------------*/
DEFINE {1} SHARED TEMP-TABLE _NAME-REC
   FIELD _wDBNAME             AS CHAR     LABEL "WIDGET DBANME"  INITIAL ?
   FIELD _wTABLE              AS CHAR     LABEL "WIDGET TABLE"   INITIAL ?
   FIELD _wNAME               AS CHAR     LABEL "WIDGET NAME"
   FIELD _wFRAME              AS CHAR     LABEL "WIDGET FRAME"   INITIAL ?
   FIELD _wTYPE               AS CHAR     LABEL "WIDGET TYPE"
   FIELD _wRECID              AS RECID    LABEL "WIDGET RECID"
  INDEX _wNAME-TYPE IS PRIMARY UNIQUE _wNAME _wTYPE _wTABLE _wDBNAME _wFRAME.

