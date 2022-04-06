&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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


