/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

