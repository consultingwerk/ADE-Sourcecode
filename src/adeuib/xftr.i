/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: xftr.i

Description:
    This include file defines the eXtended Feature  (XFTR) TEMP-TABLE. 
    Mostly this contains descriptions of what to do when an XFTR is changed.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: Wm.T.Wood 

Date Created: August 1994 

Last modified on 9/29/94 by GFS

----------------------------------------------------------------------------*/
DEFINE {1} SHARED TEMP-TABLE _xftr
    FIELD _name     AS CHAR      LABEL "Name"
    FIELD _desc     AS CHAR      LABEL "Description"    
    FIELD _mode     AS LOGICAL   LABEL "XFTR on palette? y/n"
    FIELD _defloc   AS INT       LABEL "Default location in .w"
    FIELD _image    AS CHAR      LABEL "Image name"
    FIELD _wRECID   AS RECID     LABEL "RECID of associated .w window"
    FIELD _create   AS CHAR      LABEL "Create Procedure"
    FIELD _realize  AS CHAR      LABEL "Realize Procedure"
    FIELD _edit     AS CHAR      LABEL "Edit Procedure"
    FIELD _destroy  AS CHAR      LABEL "Destroy Procedure"
    FIELD _read     AS CHAR      LABEL "Read Procedure"
    FIELD _write    AS CHAR      LABEL "Write (gen4gl) Procedure"
  INDEX _name _name
  .

