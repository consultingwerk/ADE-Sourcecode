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

