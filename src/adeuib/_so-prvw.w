&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
/* Procedure Description
"Preview a SmartObject file in a dialog-box."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f_dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f_dlg 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _so-prvw.w

  Description: Preview a SmartObject file in a dialog-box.

  Input Parameters:
      p_filename - name of the master file to run.

  Output Parameters:
      <none>

  Author: Wm.T.Wood

  Created: March 31, 1995
  Modified: 1/98 SLK Special display for non-visual object SmartData
                Modified to handle ADM1 and ADM2 SmartObjects
            2/98 SLK replace run dispatch, getversion, get fields, datatype etc.
            3/98 SLK correct getType to getObjectType.
            5/98 HD  Preview a remote SDO 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* Parameters Definitions ---                                           */
&IF DEFINED(UIB_is_Running) eq 0 &THEN
  /* Variables normally passed as parameters */
  DEFINE INPUT PARAMETER p_filename AS CHAR NO-UNDO.
&ELSE
  /* When testing, create these as Variables. */
  DEFINE VARIABLE p_filename AS CHAR NO-UNDO INITIAL "adm/objects/p-navvl.w" .
&ENDIF

/* Local Variable Definitions ---                                       */
DEFINE VAR cnt            AS INTEGER NO-UNDO.
DEFINE VAR cTemp          AS CHAR    NO-UNDO.
DEFINE VAR err-msg        AS CHAR    NO-UNDO.
DEFINE VAR file-name      AS CHAR    NO-UNDO.
DEFINE VAR ldummy         AS LOGICAL NO-UNDO.
DEFINE VAR s_HANDLE       AS HANDLE  NO-UNDO.
DEFINE VAR s_visual       AS LOGICAL NO-UNDO.
DEFINE VAR s_valid-object AS LOGICAL NO-UNDO.
DEFINE VAR s_remote       AS LOGICAL NO-UNDO.
DEFINE VAR u_HANDLE       AS WIDGET  NO-UNDO.

DEFINE VARIABLE cTemp2          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE admVersion      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lValue          AS LOGICAL      NO-UNDO.
DEFINE VARIABLE cInfo           AS CHARACTER    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f_dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-BORDER Btn_Close Btn_Help ed_report ~
fi_master fi_type 
&Scoped-Define DISPLAYED-OBJECTS ed_report fi_master fi_type 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Close AUTO-END-KEY 
     LABEL "Close" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE VARIABLE ed_report AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 72.57 BY 4.62 NO-UNDO.

DEFINE VARIABLE fi_master AS CHARACTER FORMAT "X(256)":U 
     LABEL "Master File" 
      VIEW-AS TEXT 
     SIZE 29.57 BY .62 NO-UNDO.

DEFINE VARIABLE fi_type AS CHARACTER FORMAT "X(256)":U 
     LABEL "Type" 
      VIEW-AS TEXT 
     SIZE 29.57 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-BORDER
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 74.57 BY 5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f_dlg
     Btn_Close AT ROW 1.19 COL 46
     Btn_Help AT ROW 1.19 COL 61.57
     ed_report AT ROW 2.81 COL 3 NO-LABEL
     fi_master AT ROW 1.38 COL 13.57 COLON-ALIGNED
     fi_type AT ROW 2 COL 13.57 COLON-ALIGNED
     RECT-BORDER AT ROW 2.62 COL 2
     SPACE(0.99) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Preview SmartObject"
         CANCEL-BUTTON Btn_Close.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB f_dlg 
/* ***************************  Included-Libraries  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX f_dlg
                                                                        */
ASSIGN 
       FRAME f_dlg:SCROLLABLE       = FALSE
       FRAME f_dlg:HIDDEN           = TRUE.

ASSIGN 
       ed_report:READ-ONLY IN FRAME f_dlg        = TRUE.

ASSIGN 
       RECT-BORDER:HIDDEN IN FRAME f_dlg           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME f_dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f_dlg f_dlg
ON WINDOW-CLOSE OF FRAME f_dlg /* Preview SmartObject */
DO:
 APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help f_dlg
ON CHOOSE OF Btn_Help IN FRAME f_dlg /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO:  
  { adeuib/uibhlp.i }   /* Include File containing HELP file Context ID's */
  RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&Preview_SmartObject_Dlg_Box}, ? ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f_dlg 


/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

RUN adeuib/_uibinfo.p (?,"SESSION":U,"Remote",OUTPUT cInfo).

ASSIGN s_remote = cInfo = "TRUE":U
  
      /* 
      Visualize the dialog-box while we are waiting to load the smartobject.
      NOTE: We need to visualize it now, otherwise there is some problems
      parenting a frame to a DIALOG-BOX. */
      
      fi_master = p_filename
      fi_type   = "[Unknown]"
      ed_report = "Loading SmartObject Master file..."
      .
      
RUN enable_UI.

/* Realize the SmartObject so that we can preview it. */
RUN Realize_SmartObject.

/* If it was a valid-object, then get some information on it. */
IF NOT s_valid-object THEN DO:
  ASSIGN fi_type   = "Unknown" 
         ed_report = err-msg
         .
END.

IF s_valid-object OR s_remote THEN
DO:
  
  IF s_remote THEN 
  DO:
    RUN getRemoteAttribute("getObjectType", OUTPUT fi_type).
    ed_report = "Remote SmartObjects have no visualization to preview." +
                 CHR(10) + CHR(10).

  END.
  /* Get the subtype. [If it is not in the object, then don't overwrite
     the value which was set to _next_draw in _drwobj.p.] */
  ELSE
  IF admVersion LT "ADM2":U THEN 
  DO:
     RUN get-attribute IN s_HANDLE (INPUT "TYPE") NO-ERROR.  
     IF RETURN-VALUE ne "" 
     THEN fi_type = RETURN-VALUE.
     ELSE fi_type = "SmartObject".  /* [default subtype = "SmartObject"] */
  END.
  ELSE
  DO:
     cValue =  DYNAMIC-FUNCTION("getObjectType":U IN s_HANDLE) NO-ERROR.  
     IF ERROR-STATUS:ERROR OR cValue = "":U THEN
         fi_type = "SmartObject".  /* [default subtype = "SmartObject"] */
     ELSE 
         fi_type = cValue.
  END.

  IF fi_type = "SmartDataObject":U THEN DO:
    
     /* Display the fields */
  
     ASSIGN cTemp2 = "Fields".
     
     IF s_remote THEN 
       RUN getRemoteAttribute("getDataColumns", OUTPUT cValue).
     ELSE       
       ASSIGN cValue = DYNAMIC-FUNCTION("getDataColumns":U IN s_HANDLE) NO-ERROR.
  
     ASSIGN cTemp = IF ERROR-STATUS:ERROR OR cValue = ? THEN "":U ELSE cValue
            ed_report = ed_report + 
                        fi_type + " " + cTemp2 + " are:" + CHR(10) + "  " + 
                    REPLACE (cTemp, ",", CHR(10) + "  ")
                    + CHR(10) + CHR(10).
  END.
  ELSE IF NOT s_remote THEN
  DO:
     IF admVersion LT "ADM2":U THEN
     DO: 
        /* Get the links and tables supported by the object. */
        RUN get-attribute IN s_HANDLE (INPUT "EXTERNAL-TABLES") NO-ERROR. 
        ASSIGN cTemp = RETURN-VALUE
                ed_report = ed_report +
                        "Requires Record-Source for External Tables:" + 
                        CHR(10) + "  " + 
                        (IF cTemp eq "" OR cTemp eq ? 
                         THEN "[no tables]"
                         ELSE REPLACE (cTemp, ",", CHR(10) + "  ")
                        ) + CHR(10) + CHR(10).
   
        RUN get-attribute IN s_HANDLE (INPUT "INTERNAL-TABLES") NO-ERROR.  
        cTemp = RETURN-VALUE.
        IF cTemp ne "" AND cTemp ne ? THEN 
        ASSIGN ed_report = ed_report + 
                   "Can also SEND-RECORDS for:" + CHR(10) + "  " + 
                    REPLACE (cTemp, ",", CHR(10) + "  ")
                    + CHR(10) + CHR(10).
    END. /* If ADM1 */
  END.
END.

/* Restore the cursor */
RUN adecomm/_setcurs.p ("").

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   
  DISPLAY fi_type WITH FRAME {&FRAME-NAME}.
  IF ed_report:VISIBLE THEN ed_report:SCREEN-VALUE = ed_report.  

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* Get rid of the Persistent Object we just created. */
/* Explicitly delete it, if we can't destroy it.     */
IF VALID-HANDLE (s_HANDLE) THEN DO:
  IF admVersion = "ADM1.1":U THEN
     RUN dispatch IN s_HANDLE ('destroy') NO-ERROR.
  ELSE
     RUN destroyObject IN s_HANDLE NO-ERROR.
  IF VALID-HANDLE (s_HANDLE) THEN DELETE PROCEDURE s_HANDLE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI f_dlg _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f_dlg.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI f_dlg _DEFAULT-ENABLE
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
  DISPLAY ed_report fi_master fi_type 
      WITH FRAME f_dlg.
  ENABLE RECT-BORDER Btn_Close Btn_Help ed_report fi_master fi_type 
      WITH FRAME f_dlg.
  VIEW FRAME f_dlg.
  {&OPEN-BROWSERS-IN-QUERY-f_dlg}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRemoteAttribute f_dlg 
PROCEDURE getRemoteAttribute :
/*------------------------------------------------------------------------------
  Purpose:     Request a remote objects attribute  
  Parameters:  input filename to search for
               output attribute  
  Notes:       Cannot use function because of wait-for in _rsdoatt.p !
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pAttribute AS CHARACTER No-UNDO.
  DEFINE OUTPUT PARAMETER pValue     AS CHARACTER No-UNDO.
   
  RUN adeweb/_rsdoatt.p (p_filename,
                        "Functions",                          
                         pAttribute,
                         OUTPUT pValue).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize_SmartObject f_dlg 
PROCEDURE Realize_SmartObject :
/*------------------------------------------------------------------------------
  Purpose:     Attach the SmartObject to the dialog-box and show it.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  define variable object-height-p as integer no-undo.
  define variable object-width-p  as integer no-undo.
define variable ro as integer no-undo.
define variable co as integer no-undo.
  
  CURRENT-WINDOW = {&WINDOW-NAME}.
  REALIZE-BLOCK:
  /* Note that STOP will occur if we try to compile a SmartObject that uses
     a database that is not connected (for example). */
  DO ON STOP  UNDO REALIZE-BLOCK, LEAVE REALIZE-BLOCK
     ON ERROR UNDO REALIZE-BLOCK, LEAVE REALIZE-BLOCK:
  
    /* Error conditions: Object not found -- LEAVE the block. */
    RUN SearchFile (fi_master, OUTPUT file-name).
    
    IF file-name eq ? 
    THEN DO:
      /* Try looking for r-code (i.e. replace end with .r).  Note: if we
         can find r-code only, then we won't be able to Edit Master. */
      ASSIGN cnt         = NUM-ENTRIES (file-name,".":U).
      CASE cnt :
        WHEN 0 THEN
          file-name = ?.
        WHEN 1 THEN  /* eg. "src/folder" becomes "src/folder.r" */
          file-name = file-name + ".r". 
        OTHERWISE 
          ENTRY(cnt, file-name, ".":U) = "r".
      END CASE.
      
      IF file-name <> ? THEN 
        RUN SearchFile(file-name, OUTPUT file-name).
      
      IF file-name = ? THEN 
      DO:
        ASSIGN s_valid-object = NO.
               err-msg        = "The object's master file '" + fi_master + "'" +
                                  "could not be found.".
        LEAVE REALIZE-BLOCK.   
      END. 
    END.
    
    /* Run and initialize the SmartObject. This might take awhile. */
    RUN adecomm/_setcurs.p ("WAIT").
    
    IF NOT s_remote THEN
    DO:   
      RUN VALUE(fi_master) PERSISTENT SET s_HANDLE . 
    
      IF NOT VALID-HANDLE(s_HANDLE) THEN LEAVE REALIZE-BLOCK.
      /* Determine the version of the SmartObject */
   
      admVersion = DYNAMIC-FUNCTION("getObjectVersion" IN s_HANDLE) NO-ERROR.
      
      IF ERROR-STATUS:ERROR or admVersion = "":U THEN admVersion = "ADM1".

   
      /* Check to make sure this is a UIB supported SmartObject */
      RUN valid-SmartObject (INPUT s_HANDLE, OUTPUT s_valid-object, OUTPUT err-msg).

      IF NOT s_valid-object THEN DO:
        /* Explicitly delete it, if we can't destroy it. */
        IF admVersion LT "ADM2":U THEN
           RUN dispatch IN s_HANDLE ('destroy') NO-ERROR.
        ELSE RUN destroyObject.
        IF VALID-HANDLE (s_HANDLE) THEN DELETE PROCEDURE s_HANDLE.
      END.
      ELSE DO:
        /* Reinitialize the report */
        ed_report = "".
 
        /* Set the UIB mode for the object.  Do this FIRST thing, in case the
        SmartObject does anything based on this. */
        /* Get the widget-handle of the object. */
        IF admVersion LT "ADM2":U THEN 
        DO:
          RUN set-attribute-list IN s_HANDLE ("UIB-mode = Preview").
          RUN get-attribute IN s_HANDLE ('ADM-OBJECT-HANDLE':U) NO-ERROR.
          ASSIGN u_HANDLE = WIDGET-HANDLE(RETURN-VALUE) NO-ERROR.
        END.
        ELSE 
        DO:
          lValue = DYNAMIC-FUNCTION("setUIBMode" IN s_HANDLE,"Preview") NO-ERROR.
          cValue = DYNAMIC-FUNCTION("getContainerHandle" IN s_HANDLE) NO-ERROR.
          IF NOT ERROR-STATUS:ERROR THEN 
          ASSIGN u_HANDLE = WIDGET-HANDLE(cValue) NO-ERROR.
        END.
        
        /* Parent the SmartObject to our little dialog-box, if possible.  Move
          window-based SMO's to the top. */
        s_visual = VALID-HANDLE(u_HANDLE) AND u_HANDLE:TYPE eq "FRAME".
        IF NOT s_visual THEN DO:
          IF NOT VALID-HANDLE(u_HANDLE) 
          THEN ed_report = "This SmartObject has no visualization to preview." +
                           CHR(10) + CHR(10).
          ELSE DO:
            ed_report = "This SmartObject has its own " + u_HANDLE:TYPE + "." +
                         CHR(10) + CHR(10).
            IF u_HANDLE:TYPE eq "WINDOW" 
            THEN ASSIGN ldummy =  u_HANDLE:MOVE-TO-TOP().
          END.
        END.
        ELSE DO WITH FRAME {&FRAME-NAME}:
          /* Make sure the dialog-box holds the frame. */
          ASSIGN object-height-p = u_HANDLE:HEIGHT-P
                 object-width-p  = u_HANDLE:WIDTH-P
                 ed_report:HIDDEN = YES
                 FRAME {&FRAME-NAME}:WIDTH-P =
                      MAX (FRAME {&FRAME-NAME}:WIDTH-P,
                          object-width-p + 
                          FRAME {&FRAME-NAME}:BORDER-LEFT-P +
                          FRAME {&FRAME-NAME}:BORDER-RIGHT-P +
                          2 * (RECT-BORDER:X + RECT-BORDER:EDGE-PIXELS + 2))
                 FRAME {&FRAME-NAME}:HEIGHT-P =
                     MAX (FRAME {&FRAME-NAME}:HEIGHT-P,
                          object-height-p + 
                          FRAME {&FRAME-NAME}:BORDER-TOP-P +
                          FRAME {&FRAME-NAME}:BORDER-BOTTOM-P +
                          RECT-BORDER:X + RECT-BORDER:EDGE-PIXELS + 2 +
                          RECT-BORDER:Y + RECT-BORDER:EDGE-PIXELS + 2 ) .                        
          IF admVersion LT "ADM2":U THEN
               RUN set-attribute-list IN s_HANDLE
               ( 'ADM-PARENT = ':U + STRING(FRAME {&FRAME-NAME}:CURRENT-ITERATION)) NO-ERROR.
          ELSE
               lValue = DYNAMIC-FUNCTION("setObjectParent" IN s_HANDLE, (STRING(FRAME {&FRAME-NAME}:CURRENT-ITERATION))).
        /* Position the SmartObject centered HORIZONTALLY within the rectangle.
           Note the case of the rectangle being too small to hold the entire
           SmartObject. In this case, place the SmartObject at the left edge of
           the rectangle. */
        
          ro = 1.0 + ((RECT-BORDER:Y + RECT-BORDER:EDGE-PIXELS + 2) / 
                     SESSION:PIXELS-PER-ROW).
          IF u_HANDLE:WIDTH-P > RECT-BORDER:WIDTH-P + 
                     (2 * (RECT-BORDER:EDGE-PIXELS + 2)) THEN
            co = 1.0 + (RECT-BORDER:X + RECT-BORDER:EDGE-PIXELS + 2) / 
                      SESSION:PIXELS-PER-COLUMN.
          ELSE 
            co = 1.0 + (RECT-BORDER:COLUMN + (RECT-BORDER:WIDTH - u_HANDLE:WIDTH) / 2).

          IF admVersion < "ADM2" THEN
            RUN set-position IN s_HANDLE (ro, co) NO-ERROR.
          ELSE
            RUN repositionObject IN s_Handle (ro, co) NO-ERROR.

        /* Place the rectangle around the smartObject */

          ASSIGN RECT-BORDER:WIDTH-P  = u_HANDLE:WIDTH-P + 
                                        2 * ( RECT-BORDER:EDGE-PIXELS + 2)
                 RECT-BORDER:X        = u_HANDLE:X - (RECT-BORDER:EDGE-PIXELS + 2)
                 RECT-BORDER:HEIGHT-P = u_HANDLE:HEIGHT-P + 
                                        2 * ( RECT-BORDER:EDGE-PIXELS + 2)
                 RECT-BORDER:Y        = u_HANDLE:Y - (RECT-BORDER:EDGE-PIXELS + 2)
                 .
          /* Visualize the object */
          ASSIGN u_HANDLE:HIDDEN = NO
                /* Reset height and width (otherwise they may be reset to the height
                   and width of the Dialog's parent window.  [this is a core bug]). */
                 u_HANDLE:HEIGHT-P = object-height-p
                 u_HANDLE:WIDTH-P  = object-width-p.
      
        END. /* IF a visual frame ... */    
      END. /* A valid SmartObject */
    END.  /* if not s_remote */
  END. /* Realize-Block */

  /* Visualize the Object (non-visual objects were visualized above in 
     parent.  Set it up for UIB design mode.)   NOTE that this might raise
     STOP or ERROR if 'initialize' of a SmartFrame can't find the files for
     its contained SmartObjects. */
  
  /* s_handle is not set for remte */ 
  IF VALID-HANDLE (s_HANDLE) THEN DO:
    INITIALIZE-BLOCK:
    DO ON STOP  UNDO INITIALIZE-BLOCK, LEAVE INITIALIZE-BLOCK
       ON ERROR UNDO INITIALIZE-BLOCK, LEAVE INITIALIZE-BLOCK:

      IF admVersion = "ADM1":U THEN
         RUN dispatch IN s_HANDLE ("initialize":U) NO-ERROR.
      ELSE
        RUN initializeObject IN s_HANDLE NO-ERROR.
    END. /* INITIALIZE-BLOCK */
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SearchFile f_dlg 
PROCEDURE SearchFile :
/*------------------------------------------------------------------------------
  Purpose:   Search local or remote  
  Parameters:  input filename to search for
  Notes:       The remote/local differences is encapsulated here to be able to 
               use the same .r logic for local and remote. 
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pFileName AS CHARACTER No-UNDO.
  DEFINE OUTPUT PARAMETER pRelName  AS CHARACTER No-UNDO.
  
  DEF VAR BrokerURL AS CHAR NO-UNDO.
  DEF VAR TempFile  AS CHAR NO-UNDO.

  IF NOT s_remote THEN 
     pRelName = SEARCH(pFileName).
  
  ELSE 
  DO:   
    RUN adeuib/_uibinfo.p (?,"SESSION":U,"BrokerURL",OUTPUT BrokerURL).

    RUN adeweb/_webcom.w (?, 
                          BrokerURL, 
                          p_fileName, 
                          "SEARCH":U, 
                          OUTPUT pRelName, 
                          INPUT-OUTPUT tempFile).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valid-SmartObject f_dlg 
PROCEDURE valid-SmartObject :
/* --------------------------------------------------------------
     Check that the procedure handle has all the pieces that make
     it a valid SmartObject that can be used by the UIB.
     handle ADM1.1 and ADM2.0 version
   -------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_h AS HANDLE  NO-UNDO.
  DEFINE OUTPUT PARAMETER pOK AS LOGICAL NO-UNDO.
  DEFINE OUTPUT PARAMETER p_msg AS CHAR    NO-UNDO.

  DEFINE VARIABLE methods AS CHAR NO-UNDO.
  DEFINE VARIABLE not-found AS CHAR NO-UNDO.
  
  /* Assume its OK, until we find otherwise */
  methods = p_h:INTERNAL-ENTRIES.
        
  IF admVersion LT "ADM2":U THEN 
  DO:
     pOK = CAN-DO (methods, "dispatch").
     IF NOT pOK THEN not-found = "dispatch".
     ELSE DO:
       pOK =    CAN-DO (methods, "adm-initialize") OR
                CAN-DO (methods, "local-initialize") OR
                CAN-DO (methods, "initialize").
       IF NOT pOK THEN not-found = "initialize".
       ELSE DO:
         pOK =    CAN-DO (methods, "adm-destroy") OR
                  CAN-DO (methods, "local-destroy") OR
                  CAN-DO (methods, "destroy").
         IF NOT pOK THEN not-found = "destroy".
         ELSE DO:
           /* A smartObject must be able to set and get attributes (esp. UIB-mode). */
           pOK = CAN-DO (methods, "set-attribute-list").
           IF NOT pOK THEN not-found = "set-attribute-list".
           ELSE DO:
             pOK = CAN-DO (methods, "get-attribute-list").
             IF NOT pOK THEN not-found = "get-attribute-list".
             ELSE DO:
               pOK = CAN-DO (methods, "get-attribute").
               IF NOT pOK THEN not-found = "get-attribute".
             END.
           END.
         END. /* ..set-attribute-list */
       END. /* ..destroy */
     END. /* initialize */
  END. /* ADM1 valid object */
  ELSE
  DO: /* Since the objectVersion already succeed in the past, then this 
       * Smart Object is valid */
       pOK =    TRUE.
  END.
     
  /* Report any error */
  IF NOT pOK THEN
    p_msg = "The Persistent Object '" + p_h:FILE-NAME + "' could not be used as a SmartObject in the UIB.  It is missing a '" + not-found + "' method.".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

