&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afdynabrws.p

  Description:  Dynamic browser build procedure

  Purpose:      Builds a dynamic browser based on a query string

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        5484   UserRef:    
                Date:   16/08/2000  Author:     Johan Meyer

  Update Notes: Created from Template aftemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afdynabrws.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

&SCOPED-DEFINE MAX-BRW-FIELD 40     /* Max. supported fields in a single browse */

&SCOPED-DEFINE BROWSE-NAME ttDataBrowse
&SCOPED-DEFINE FRAME-NAME  ttDataFrame
&SCOPED-DEFINE WINDOW-NAME ttDataWindow

DEFINE VARIABLE lv_query_list                       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_field_list                       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_method                           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_sort_by                          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_output_rows                      AS INTEGER      NO-UNDO.

ASSIGN
    lv_query_list     = "FOR EACH icfdb._file":U
    lv_field_list     = "":U
    lv_sort_by        = "":U
    lv_method         = "NORMAL":U
    lv_output_rows    = ?.

DEFINE VARIABLE lh_query_proc AS HANDLE NO-UNDO.
DEFINE VARIABLE lh_query      AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt_datatable NO-UNDO
    FIELD tt_tag AS CHARACTER 
    FIELD tt_data AS CHARACTER EXTENT {&MAX-BRW-FIELD} FORMAT "X(100)" 
    INDEX tt_main tt_tag.

DEFINE TEMP-TABLE tt_browsetable NO-UNDO LIKE tt_datatable.

DEFINE QUERY {&BROWSE-NAME} FOR tt_browsetable SCROLLING.

DEFINE BROWSE {&BROWSE-NAME}
    QUERY {&BROWSE-NAME} NO-LOCK 
    DISPLAY 
        tt_browsetable.tt_data WIDTH 1 NO-LABELS
        tt_browsetable.tt_tag WIDTH 20 FORMAT "X(20)"
    WITH NO-ASSIGN NO-ROW-MARKERS SEPARATORS SIZE 100 BY 10.

DEFINE FRAME {&FRAME-NAME}
    {&BROWSE-NAME} AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX OVERLAY THREE-D SCROLLABLE.

DEFINE VARIABLE {&WINDOW-NAME} AS WIDGET-HANDLE NO-UNDO.

ON OFF-END OF {&BROWSE-NAME} IN FRAME {&FRAME-NAME}
DO:
    IF lv_output_rows <> ? THEN DO:
        RUN mipDynamicQuery IN lh_query_proc ( INPUT lv_query_list
                                             , INPUT lv_field_list
                                             , INPUT lv_sort_by
                                             , INPUT lv_output_rows).
        RUN mipGetDataTable IN lh_query_proc (OUTPUT TABLE tt_datatable).
        RUN mipAddDataTable IN THIS-PROCEDURE (INPUT TABLE tt_datatable).
        OPEN QUERY {&BROWSE-NAME}
            FOR EACH tt_browsetable NO-LOCK
                WHERE tt_browsetable.tt_tag BEGINS "FVALUE":U.

        APPLY "END" TO {&BROWSE-NAME}.
    END.    
END.

    CREATE WINDOW {&WINDOW-NAME} 
    ASSIGN
        HIDDEN             = YES
        TITLE              = "Dynamic Data Browse"
        HEIGHT             = {&BROWSE-NAME}:HEIGHT
        WIDTH              = {&BROWSE-NAME}:WIDTH 
        THREE-D            = yes
        STATUS-AREA        = no
        MESSAGE-AREA       = no
        SENSITIVE          = yes.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



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
         HEIGHT             = 10.48
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

    SESSION:APPL-ALERT-BOXES = YES.

    RUN af/sup/afdynplipp.p PERSISTENT SET lh_query_proc.

    RUN mipFollowLinks IN lh_query_proc (INPUT lv_method, INPUT-OUTPUT lv_query_list, INPUT-OUTPUT lv_field_list).

    RUN mipDynamicQuery IN lh_query_proc ( INPUT lv_query_list
                                         , INPUT lv_field_list
                                         , INPUT lv_sort_by
                                         , INPUT lv_output_rows).

    RUN mipFormatBrowse IN lh_query_proc (INPUT {&BROWSE-NAME}:HANDLE).
    RUN mipGetDataTable IN lh_query_proc (OUTPUT TABLE tt_datatable).
    RUN mipAddDataTable IN THIS-PROCEDURE (INPUT TABLE tt_datatable).

    VIEW FRAME {&FRAME-NAME} IN WINDOW {&WINDOW-NAME}.
    VIEW {&WINDOW-NAME}.

    OPEN QUERY {&BROWSE-NAME}
        FOR EACH tt_browsetable NO-LOCK
            WHERE tt_browsetable.tt_tag BEGINS "FVALUE":U.

    ENABLE {&BROWSE-NAME} WITH FRAME {&FRAME-NAME}.
    APPLY "VALUE-CHANGED" TO BROWSE {&BROWSE-NAME}. 
    WAIT-FOR WINDOW-CLOSE OF {&WINDOW-NAME} FOCUS {&BROWSE-NAME}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-mipAddDataTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mipAddDataTable Procedure 
PROCEDURE mipAddDataTable :
/*------------------------------------------------------------------------------
  Purpose:     Adds the contents of tt_datatable to tt_browsetable 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt_browsetable APPEND. 

    EMPTY TEMP-TABLE tt_datatable.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

