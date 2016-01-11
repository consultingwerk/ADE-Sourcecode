&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
  DEFINE VARIABLE OK2Save   AS LOGICAL                            NO-UNDO.
  DEFINE VARIABLE save-file AS CHARACTER INITIAL "TM-fltrs.d"     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
RUN adecomm/_setcurs.p ("":U).
IF NOT CAN-FIND(FIRST xlatedb.XL_SelectedFilter) THEN DO:
  MESSAGE "There are no filters defined yet."
          VIEW-AS ALERT-BOX ERROR.
  RETURN.
END.

SYSTEM-DIALOG GET-FILE save-file
  TITLE    "Export to..."
  FILTERS  "Dump files (*.d)"   "*.d":U,
           "Text files (*.txt)" "*.txt":U,
           "All files (*.*)"    "*.*":U
        SAVE-AS USE-FILENAME ASK-OVERWRITE
        CREATE-TEST-FILE UPDATE OK2Save.
          
IF OK2Save THEN DO:
  RUN adecomm/_setcurs.p ("WAIT":u).
  OUTPUT TO VALUE(save-file).
  PUT UNFORMATTED "TranMan II Filter Export Format":U SKIP.
  FOR EACH xlatedb.XL_SelectedFilter:
    EXPORT xlatedb.XL_SelectedFilter.
  END.
  PUT UNFORMATTED ".":U SKIP.
  FOR EACH xlatedb.XL_CustomFilter:
    EXPORT xlatedb.XL_CustomFilter.
  END.
  PUT UNFORMATTED ".":U SKIP.
  OUTPUT CLOSE.
  RUN adecomm/_setcurs.p ("":U).
END.
ELSE MESSAGE "Nothing was exported." VIEW-AS ALERT-BOX INFORMATION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


