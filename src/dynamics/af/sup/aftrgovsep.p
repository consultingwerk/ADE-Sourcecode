&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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
    File        : aftrgovsep.p
    Purpose     : Selects database and target file path for aftrgovdfp.p

    Parameters  : <none>

    Description : This is the user interface for aftrgovdfp.p

    Author(s)   : Sean Enraght-Moony
    Created     : 23 July 1998
    Notes       : 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE VARIABLE lv_loop AS INTEGER NO-UNDO.
DEFINE VARIABLE lv_db_list AS CHARACTER LABEL "Database" NO-UNDO VIEW-AS COMBO-BOX INNER-LINES 4.
DEFINE VARIABLE lv_df_path AS CHARACTER LABEL "DF file path" FORMAT "x(50)" NO-UNDO.
DEFINE BUTTON   bu_OK AUTO-GO LABEL "&OK" DEFAULT.
DEFINE BUTTON   bu_cancel AUTO-ENDKEY LABEL "&Cancel".
DEFINE FRAME f_select
       lv_db_list COLON 15
       SKIP
       lv_df_path COLON 15
       SKIP
       bu_cancel COLON 15
       bu_OK
       WITH SIDE-LABELS.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



/* _UIB-PREPROCESSOR-BLOCK-END */
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
         HEIGHT             = 2.22
         WIDTH              = 47.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ON CHOOSE OF bu_OK DO:
    ASSIGN lv_df_path.
    CREATE ALIAS db_metaschema FOR DATABASE VALUE(lv_db_list:SCREEN-VALUE IN FRAME f_select).
    RUN af/sup/aftrgovdfp.p (INPUT lv_df_path).
END.

DO lv_loop = 1 TO NUM-DBS:
    lv_db_list:ADD-LAST(LDBNAME(lv_loop)) IN FRAME f_select.
END.

ASSIGN lv_db_list:SCREEN-VALUE = lv_db_list:ENTRY(1)
       lv_df_path = "trigovr.df".

DISPLAY lv_df_path WITH FRAME f_select.
ENABLE ALL WITH FRAME f_select.
WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


