&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*---------------------------------------------------------------------------------
  File: rycsodsupr.p

  Description:  Object Deployment Destination Brws Super

  Purpose:      Object Deployment Destination Browser Super Procedure (for rycsodeplb)

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/17/2002  Author:     

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rycsodsupr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE TEMP-TABLE tt_selected NO-UNDO
    FIELD tt_filename       AS CHARACTER
    FIELD last_selected_row AS LOGICAL.

DEFINE VARIABLE ghBrowseHandle AS HANDLE     NO-UNDO.

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
         HEIGHT             = 7.05
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-fetchFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchFirst Procedure 
PROCEDURE fetchFirst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

APPLY "HOME":U TO ghBrowseHandle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchLast) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchLast Procedure 
PROCEDURE fetchLast :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
APPLY "END":U TO ghBrowseHandle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Dynamics doesn't support MULTI select browsers as standard, so make 
               this one a multi select here.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hToolbar      AS HANDLE     NO-UNDO.

{get browseHandle ghBrowseHandle}.

ASSIGN ghBrowseHandle:MULTIPLE = YES.

RUN SUPER.

{get containerSource hToolbar}.
{get containertoolbarSource hToolbar hToolbar}.
SUBSCRIBE TO "fetchFirst" IN hToolbar.
SUBSCRIBE TO "fetchLast" IN hToolbar.

ASSIGN ghBrowseHandle:NUM-LOCKED-COLUMNS = 3.
APPLY "HOME":U TO ghBrowseHandle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startSearch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startSearch Procedure 
PROCEDURE startSearch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phBrowseHandle AS HANDLE     NO-UNDO.

DEFINE VARIABLE hBufferHandle AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCnt          AS INTEGER    NO-UNDO.
DEFINE VARIABLE hDataSource   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hQuery        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField        AS HANDLE     NO-UNDO.
DEFINE VARIABLE rRowid        AS ROWID      NO-UNDO.

/* Store the selected rows rowidents */

IF phBrowseHandle:NUM-SELECTED-ROWS > 0 
THEN then-blk: DO:
    EMPTY TEMP-TABLE tt_selected.

    MESSAGE "You have rows selected in the browser." SKIP(1)
            "- Press YES to keep the selected rows, which will result" SKIP
            "  in the column sort taking longer." SKIP
            "- Press NO to discard the selected rows." SKIP
            "- Press CANCEL to cancel the column sort."
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE lYon AS LOGICAL.

    CASE lYon:
        WHEN NO THEN LEAVE then-blk. /* don't save selected rows */
        WHEN ?  THEN RETURN.         /* abort the column sort */
    END CASE.
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    ASSIGN phBrowseHandle:VISIBLE = FALSE
           hQuery                 = phBrowseHandle:QUERY
           hBufferHandle          = hQuery:GET-BUFFER-HANDLE(1)
           hField                 = hBufferHandle:BUFFER-FIELD("object_filename":U). /* The current row */

    DO iCnt = 1 TO phBrowseHandle:NUM-SELECTED-ROWS:    
        phBrowseHandle:FETCH-SELECTED-ROW(iCnt).
        CREATE tt_selected.
        ASSIGN tt_selected.tt_filename       = hField:BUFFER-VALUE
               tt_selected.last_selected_row = (iCnt = phBrowseHandle:NUM-SELECTED-ROWS). /* This is the row we're going to reposition to */
    END.
END.

RUN SUPER (INPUT phBrowseHandle).

IF CAN-FIND(FIRST tt_selected)
THEN DO:
    {get dataSource hDataSource}.

    hQuery:GET-FIRST().

    do-blk:
    DO WHILE hBufferHandle:AVAILABLE:

        IF CAN-FIND(FIRST tt_selected
                    WHERE tt_selected.tt_filename = hField:BUFFER-VALUE) 
        THEN DO:
            FIND FIRST tt_selected
                 WHERE tt_selected.tt_filename = hField:BUFFER-VALUE.

            hQuery:REPOSITION-TO-ROWID(hBufferHandle:ROWID).
            phBrowseHandle:SELECT-FOCUSED-ROW().
            IF tt_selected.last_selected_row THEN
                ASSIGN rRowid = hBufferHandle:ROWID.
        END.
        hQuery:GET-NEXT().
    END.

    /* Reposition to the row the user was on */
    phBrowseHandle:SET-REPOSITIONED-ROW(1, "ALWAYS":U).
    hQuery:REPOSITION-TO-ROWID(rRowid).

    ASSIGN phBrowseHandle:VISIBLE = TRUE.
END.

SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

