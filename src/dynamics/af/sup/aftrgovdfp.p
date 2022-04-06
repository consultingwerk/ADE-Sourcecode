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
    File        : aftrgovdfp.p
    Purpose     : Make triggers override-able quickly

    Parameters  : INPUT ip_df_path = the path to a .df output file

    Description : Generates a .df file which makes all triggers in the
                  specified database override-able

    Author(s)   : Sean Enraght-Moony
    Created     : 23 July 1998
    Notes       : This procedure expects a database alias db_metaschema
                  to be created prior to being called
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT PARAMETER ip_df_path   AS CHARACTER NO-UNDO.
DEFINE VARIABLE        lv_new_table AS LOGICAL   NO-UNDO.

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
         HEIGHT             = 2.64
         WIDTH              = 47.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

OUTPUT TO VALUE(ip_df_path).

FOR EACH db_metaschema._file NO-LOCK:
    ASSIGN lv_new_table = YES.
    FOR EACH db_metaschema._file-trig OF db_metaschema._file NO-LOCK:
        IF lv_new_table THEN
          DO:
            ASSIGN lv_new_table = NO.
            PUT UNFORMATTED
                SKIP(1)
                'UPDATE TABLE "':U
                db_metaschema._file._file-name
                '"':U
                SKIP.
          END.

        PUT UNFORMATTED
            '  TABLE-TRIGGER "':U
            db_metaschema._file-trig._event
            '" OVERRIDE PROCEDURE "':U
            db_metaschema._file-trig._proc-name
            '" CRC "?"':U
            SKIP.
    END.
END.

OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


