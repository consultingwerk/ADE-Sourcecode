&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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
/*------------------------------------------------------------------------

  File: afrtbdeplw.w

  Description: Copy r-code into deployment package / delete source code if required

  Input Parameters:

  Output Parameters:

  Author: 

  Created: December 2000

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE INPUT  PARAMETER lCopyRcode          AS LOGICAL      NO-UNDO.
DEFINE INPUT  PARAMETER lDeleteSource       AS LOGICAL      NO-UNDO.
DEFINE INPUT  PARAMETER cWspaceId           AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER cWspaceDirectory    AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER cDeployDirectory    AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER cSchemaDirectory    AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER cDeployLicence      AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER cErrorValue         AS CHARACTER    NO-UNDO.

{af/sup/afproducts.i}

DEFINE STREAM sMain.

DEFINE TEMP-TABLE ttObject      NO-UNDO
            FIELD tfOfilename   AS CHARACTER
            FIELD tfOfiletype   AS CHARACTER
            INDEX tiOmain       IS PRIMARY UNIQUE
                    tfOfilename
                    .

DEFINE TEMP-TABLE ttRcode      NO-UNDO
            FIELD tfRmodule    AS CHARACTER
            FIELD tfRobject    AS CHARACTER
            INDEX tiRmain      IS PRIMARY UNIQUE
                    tfRmodule
                    tfRobject
                    .
DEFINE VARIABLE glDone AS LOGICAL INITIAL NO NO-UNDO.

DEFINE TEMP-TABLE ttSchema    NO-UNDO
FIELD cFlags                  AS CHARACTER
FIELD cDBName                 AS CHARACTER
FIELD cTable                  AS CHARACTER
FIELD cDone                   AS CHARACTER
FIELD cNumFields              AS CHARACTER
.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ToAll edResults buOK buCancel 
&Scoped-Define DISPLAYED-OBJECTS ToAll edResults 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buCancel AUTO-END-KEY DEFAULT 
     LABEL "&Cancel" 
     SIZE 14.4 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buOK DEFAULT 
     LABEL "C&ontinue" 
     SIZE 15 BY 1.14 TOOLTIP "Proceed with deployment options selected"
     BGCOLOR 8 .

DEFINE VARIABLE edResults AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 100 BY 12.57 NO-UNDO.

DEFINE VARIABLE ToAll AS LOGICAL INITIAL no 
     LABEL "Send All R-Code with Deployment Package" 
     VIEW-AS TOGGLE-BOX
     SIZE 61.6 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     ToAll AT ROW 1.29 COL 7
     edResults AT ROW 2.33 COL 5 NO-LABEL
     buOK AT ROW 15.29 COL 73.8
     buCancel AT ROW 15.29 COL 90.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 106 BY 21.52
         CANCEL-BUTTON buCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert window title>"
         HEIGHT             = 15.91
         WIDTH              = 106
         MAX-HEIGHT         = 23.91
         MAX-WIDTH          = 138
         VIRTUAL-HEIGHT     = 23.91
         VIRTUAL-WIDTH      = 138
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
ASSIGN 
       edResults:RETURN-INSERTED IN FRAME DEFAULT-FRAME  = TRUE
       edResults:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:

    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel C-Win
ON CHOOSE OF buCancel IN FRAME DEFAULT-FRAME /* Cancel */
DO:

  IF NOT glDone THEN
  DO:
    MESSAGE "You have elected not to copy r-code and/or delete source code for" SKIP
            "this deployment package. Normally you should always copy r-code into" SKIP
            "the deployment package. You should only delete source code if not a" SKIP 
            "partner site, and you have finished all the other deployment hooks " SKIP
            "(as these require the objects in the directory to work out what is" SKIP
            "being deployed)" SKIP(1)
            "Continue with Cancel" SKIP
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE lChoice AS LOGICAL.
    IF lChoice = NO THEN RETURN NO-APPLY.
    ELSE ASSIGN cErrorValue = "Cancelled".
  END.

  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOK C-Win
ON CHOOSE OF buOK IN FRAME DEFAULT-FRAME /* Continue */
DO:

  DEFINE VARIABLE lChoice                   AS LOGICAL  NO-UNDO.

  ASSIGN
    toAll.

  MESSAGE "Do you want to copy the r-code from the workspace directory" SKIP
          cWspaceDirectory + " into the deployment directory " + cDeployDirectory SKIP
          "":U + (IF NOT lDeleteSource THEN "":U ELSE ("and delete the source code from the deployment directory." + CHR(10))) 
          SKIP
          "Continue?" SKIP
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE lChoice.

  IF lChoice = YES
  THEN
  DO:
    RUN objectProcess.

    ASSIGN
        buCancel:LABEL IN FRAME {&FRAME-NAME} = "&Close":U
        glDone = YES.
  END.
  ELSE
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

RUN mainSetup.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.

    IF NOT THIS-PROCEDURE:PERSISTENT
    THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE FOCUS buOk.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildObject C-Win 
PROCEDURE buildObject :
/*------------------------------------------------------------------------------
  Purpose:     Build a list of r-code objects to deploy.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttObject.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttRcode.

    DEFINE VARIABLE cExtensions AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cBatchFile  AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cOutputFile AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cFileName   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iLoop       AS INTEGER      NO-UNDO.

    DEFINE VARIABLE cObjectName AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cDirectory  AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cSchemaFile AS CHARACTER    NO-UNDO.

    DEFINE BUFFER brtb_object FOR rtb_object.

    /* Write batch file to do a directory listing of all files in the directory specified */
    ASSIGN
        cBatchFile      = SESSION:TEMP-DIRECTORY + "dir.bat":U
        cOutputFile     = SESSION:TEMP-DIRECTORY + "dir.log":U
        cExtensions     = "i,p,w,v":U
        .

    IF cSchemaDirectory <> "" THEN
      ASSIGN cSchemaFile = SEARCH(cSchemaDirectory + "/schctrl":U).
    ELSE
      ASSIGN cSchemaFile = ?.

    IF toAll THEN
      ASSIGN cDirectory = LC(TRIM(REPLACE(cWspaceDirectory,"/":U,"\":U))).
    ELSE
      ASSIGN cDirectory = LC(TRIM(REPLACE(cDeployDirectory,"/":U,"\":U))).

    /* send r-code for schema xref records as well */
    IF NOT toAll AND cSchemaFile <> ? THEN
    DO:
      EMPTY TEMP-TABLE ttSchema.
      INPUT STREAM sMain FROM VALUE(cSchemaFile) NO-ECHO.
      schema-loop:
      REPEAT:
        CREATE ttSchema.
        IMPORT STREAM sMain ttSchema.
      END.
      INPUT STREAM sMain CLOSE.

      table-loop:
      FOR EACH ttSchema:
        IF ttSchema.cTable = ? OR ttSchema.cTable = "":U THEN NEXT table-loop.
        /* found a changed table, check x-ref */
        FIND brtb_object NO-LOCK
            WHERE brtb_object.wspace-id = cWspaceId
            AND   brtb_object.obj-type  = "PFILE"
            AND   brtb_object.object    = ttSchema.cTable
            NO-ERROR.
        IF AVAILABLE brtb_object THEN edResults:INSERT-STRING("      Processing xref r-code for table: ":U + ttSchema.cTable + "~n") IN FRAME {&FRAME-NAME}.
        IF AVAILABLE brtb_object THEN
          FOR EACH rtb_xref NO-LOCK
              WHERE rtb_xref.ref-recid1 = RECID(brtb_object)
              AND   rtb_xref.src-type = 1
              AND   rtb_xref.ref-type <> 1
              :
              FIND rtb_object NO-LOCK
                  WHERE RECID(rtb_object) = rtb_xref.src-recid
                  NO-ERROR.
              IF AVAILABLE rtb_object
              THEN DO:
                  FIND ttRcode EXCLUSIVE-LOCK
                      WHERE ttRcode.tfRmodule = rtb_object.module
                      AND   ttRcode.tfRobject = rtb_object.object
                      NO-ERROR.
                  IF NOT AVAILABLE ttRcode
                  THEN DO:
                      CREATE ttRcode.
                      ASSIGN
                          ttRcode.tfRmodule = rtb_object.module
                          ttRcode.tfRobject = rtb_object.object
                          .
                  END.
              END.
          END.
      END. /* table-loop */
    END. /* we have a schema file */

    OUTPUT STREAM sMain TO VALUE(cBatchFile).
    DO iLoop = 1 TO NUM-ENTRIES(cExtensions):
        PUT STREAM sMain UNFORMATTED
            "dir /b/l/on/s ":U
            cDirectory
            "\*.":U
            ENTRY(iLoop, cExtensions)
            (IF iLoop = 1 THEN " > ":U ELSE " >> ":U)
            cOutputFile
            SKIP.
    END.
    OUTPUT STREAM sMain CLOSE.

    /* Execute batch file */
    OS-COMMAND SILENT VALUE(cBatchFile).

    /* Check result */
    IF SEARCH(cOutputFile) <> ? THEN
    DO:
        INPUT STREAM sMain FROM VALUE(cOutputFile) NO-ECHO.
        REPEAT:
            IMPORT STREAM sMain UNFORMATTED cFileName.

            ASSIGN
              cFileName = LC(TRIM(cFileName))
              cFileName = REPLACE(cFileName,cDirectory,"":U)
              cFileName = REPLACE(cFileName,"~\":U,"~/":U)
              cFileName = TRIM(cFileName,"~/":U)
              .            

            FIND FIRST ttObject NO-LOCK
                WHERE ttObject.tfOfilename = cFileName
                NO-ERROR.
            IF NOT AVAILABLE ttObject THEN
            DO:
                CREATE ttObject.
                ASSIGN
                    ttObject.tfOfilename = cFileName
                    ttObject.tfOfiletype = ENTRY( NUM-ENTRIES(ttObject.tfOfilename,".":U) , ttObject.tfOfilename, ".":U )
                    .

                IF NUM-ENTRIES(ttObject.tfOfilename,"~/":U) > 1
                THEN ASSIGN cObjectName = ENTRY( NUM-ENTRIES(ttObject.tfOfilename,"~/":U) , ttObject.tfOfilename , "~/":U ).
                ELSE ASSIGN cObjectName = ttObject.tfOfilename.

                IF edResults:INSERT-STRING("      Processing object ":U + cObjectName + "~n") IN FRAME {&FRAME-NAME} THEN .

                FIND brtb_object NO-LOCK
                    WHERE brtb_object.wspace-id = cWspaceId
                    AND   brtb_object.obj-type  = "PCODE"
                    AND   brtb_object.object    = cObjectName
                    NO-ERROR.
                IF AVAILABLE brtb_object THEN
                DO:
                    IF ttObject.tfOfiletype = "i":U
                    THEN
                    FOR EACH rtb_xref NO-LOCK
                        WHERE rtb_xref.ref-recid1 = RECID(brtb_object)
                        AND   rtb_xref.src-type = 1
                        AND   rtb_xref.ref-type <> 1
                        :
                        FIND rtb_object NO-LOCK
                            WHERE RECID(rtb_object) = rtb_xref.src-recid
                            NO-ERROR.
                        IF AVAILABLE rtb_object
                        THEN DO:
                            FIND ttRcode EXCLUSIVE-LOCK
                                WHERE ttRcode.tfRmodule = rtb_object.module
                                AND   ttRcode.tfRobject = rtb_object.object
                                NO-ERROR.
                            IF NOT AVAILABLE ttRcode
                            THEN DO:
                                CREATE ttRcode.
                                ASSIGN
                                    ttRcode.tfRmodule = rtb_object.module
                                    ttRcode.tfRobject = rtb_object.object
                                    .
                            END.
                        END.
                    END.
                    ELSE
                    IF ttObject.tfOfiletype = "p":U
                    OR ttObject.tfOfiletype = "w":U
                    THEN DO:
                        FIND ttRcode EXCLUSIVE-LOCK
                            WHERE ttRcode.tfRmodule = brtb_object.module
                            AND   ttRcode.tfRobject = brtb_object.object
                            NO-ERROR.
                        IF NOT AVAILABLE ttRcode
                        THEN DO:
                            CREATE ttRcode.
                            ASSIGN
                                ttRcode.tfRmodule = brtb_object.module
                                ttRcode.tfRobject = brtb_object.object
                                .
                        END.
                    END.
                END. /* available brtb_object */
                ELSE IF INDEX(cObjectName, "_cl.":U) > 0 THEN
                DO: /* deal with _cl files that are just parts and not actual rtb objects */
                  FIND brtb_object NO-LOCK
                      WHERE brtb_object.wspace-id = cWspaceId
                      AND   brtb_object.obj-type  = "PCODE"
                      AND   brtb_object.object    = REPLACE(cObjectName,"_cl":U,"":U)
                      NO-ERROR.
                  IF AVAILABLE brtb_object THEN
                  DO:
                    FIND ttRcode EXCLUSIVE-LOCK
                        WHERE ttRcode.tfRmodule = brtb_object.module
                        AND   ttRcode.tfRobject = cObjectName
                        NO-ERROR.
                    IF NOT AVAILABLE ttRcode
                    THEN DO:
                        CREATE ttRcode.
                        ASSIGN
                            ttRcode.tfRmodule = brtb_object.module
                            ttRcode.tfRobject = cObjectName
                            .
                    END.
                  END. /* available brtb_object */
                END.  /* _cl file */

            END. /* not available ttobject */
        END. /* repeat */
        INPUT STREAM sMain CLOSE.
    END.

    /* Delete temp files */
    OS-DELETE VALUE(cBatchFile).
    OS-DELETE VALUE(cOutputFile). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY ToAll edResults 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE ToAll edResults buOK buCancel 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mainSetup C-Win 
PROCEDURE mainSetup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN
            {&WINDOW-NAME}:TITLE = "Dynamics SCM Object Deploy Hook":U
            .
        APPLY "entry":U TO buOK.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectProcess C-Win 
PROCEDURE objectProcess :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cObjectName                 AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cObjectRcode                AS CHARACTER    NO-UNDO.

    EMPTY TEMP-TABLE ttObject.
    EMPTY TEMP-TABLE ttRcode.

    IF edResults:INSERT-STRING("***   Starting with ICF SCM Object R-code Deploying ":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .

    DISABLE
        buCancel WITH FRAME {&FRAME-NAME}.

    RUN buildObject (INPUT-OUTPUT TABLE ttObject
                    ,INPUT-OUTPUT TABLE ttRcode).

    IF lCopyRcode = YES
    THEN
    FOR EACH ttRcode NO-LOCK:
        ASSIGN
            cObjectRcode = ttRcode.tfRobject
            cObjectRcode = REPLACE(cObjectRcode,".p":U,".r":U)
            cObjectRcode = REPLACE(cObjectRcode,".w":U,".r":U)
            .
        FIND FIRST rtb.rtb_pmod NO-LOCK
             WHERE rtb.rtb_pmod.pmod = ttRcode.tfRmodule
             NO-ERROR.
        IF AVAILABLE rtb.rtb_pmod THEN
          FIND rtb.rtb_moddef NO-LOCK
              WHERE rtb.rtb_moddef.module = rtb.rtb_pmod.module
              NO-ERROR.
        IF AVAILABLE rtb.rtb_moddef
        THEN DO:
            IF SEARCH( cWspaceDirectory + "~/":U + TRIM(rtb.rtb_moddef.directory,"~/":U) + (IF rtb.rtb_moddef.directory = "":U THEN "":U ELSE "~/":U  ) + cObjectRcode ) <> ?
            THEN DO:
              IF edResults:INSERT-STRING("      Copying r-code for object ":U + TRIM(rtb.rtb_moddef.directory,'~/':U) + (IF rtb.rtb_moddef.directory = '':U THEN '':U ELSE '~/':U  ) + cObjectRcode + "~n") IN FRAME {&FRAME-NAME} THEN .
              OS-CREATE-DIR
                  VALUE(cDeployDirectory + "~/":U + TRIM(rtb.rtb_moddef.directory,"~/":U) )
                  .
              OS-COPY
                  VALUE(cWspaceDirectory + "~/":U + TRIM(rtb.rtb_moddef.directory,"~/":U) + (IF rtb.rtb_moddef.directory = "":U THEN "":U ELSE "~/":U  ) + cObjectRcode)
                  VALUE(cDeployDirectory + "~/":U + TRIM(rtb.rtb_moddef.directory,"~/":U) + (IF rtb.rtb_moddef.directory = "":U THEN "":U ELSE "~/":U  ) + cObjectRcode)
                  .
            END.
        END.
    END.

    IF lDeleteSource  =  YES
    THEN
    FOR EACH ttObject NO-LOCK:
        ASSIGN
            cObjectName = TRIM(ttObject.tfOfilename,"~/":U).
        IF SEARCH( cDeployDirectory + "~/":U + cObjectName ) <> ?
        THEN DO:
            IF edResults:INSERT-STRING("***   Deleting object ":U + cObjectName + "~n") IN FRAME {&FRAME-NAME} THEN .
            OS-DELETE VALUE(cDeployDirectory + "~/":U + cObjectName ).
        END.

    END. 

    ENABLE buCancel WITH FRAME {&FRAME-NAME}.
    IF edResults:INSERT-STRING("~n" + "~n" + "***   Completed with ICF SCM Object Deploying ":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

