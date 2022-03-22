/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: triggers.i

Description:
    This include file defines the Trigger TEMP-TABLE.  Mostly this contains
    triggers, but it could also contain any code block.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter 

Date Created: 1992     

Last Modified by by JEP on 12/16/97 - Added _PRIVATE-BLOCK
                    GFS on 09/16/94 - Added _xRECID & _tLocation

----------------------------------------------------------------------------*/
DEFINE {1} SHARED TEMP-TABLE _TRG
   FIELD _tSECTION            AS CHAR     LABEL "Major Section"
   FIELD _pRECID              AS RECID    LABEL "Procedure"
   FIELD _wRECID              AS RECID    LABEL "WIDGET RECID"
   FIELD _seq                 AS INTEGER  LABEL "Order"
   FIELD _tEVENT              AS CHAR     LABEL "Trigger Event"
   FIELD _tSPECIAL            AS CHAR     LABEL "Special Function"
   FIELD _tCODE               AS CHAR     LABEL "Code Text"
   FIELD _tOFFSET             AS INTEGER  LABEL "Code Offset"
   FIELD _tOFFSET-END         AS INTEGER  LABEL "Code Offset end"
   FIELD _STATUS              AS CHAR     LABEL "Status" INITIAL "NORMAL"
   FIELD _xRECID              AS RECID    LABEL "XFTR Recid"
   FIELD _tLocation           AS INT      LABEL "Location in .W"
   FIELD _tTYPE               AS CHAR     LABEL "Special Code Type"
   FIELD _DB-REQUIRED         AS LOGICAL  LABEL "DB-Required" INITIAL TRUE
   FIELD _PRIVATE-BLOCK       AS LOGICAL  LABEL "Private"
  INDEX _RECID-EVENT IS PRIMARY UNIQUE _wRECID _tEVENT
  INDEX _ID      _pRECID _seq
  INDEX _tOFFSET _tOFFSET
  INDEX _STATUS  _STATUS
  INDEX _tLocation _tLocation.

