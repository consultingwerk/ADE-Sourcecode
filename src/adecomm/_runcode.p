&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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

/**************************************************************************
    Procedure   : _runcode.p
    
    Purpose     : ADE routine to run code. Handles running code as
                  persistent or non-peristent.

    Syntax      :
    
        RUN adecomm/_runcode.p ( INPUT  p_RunFile    ,
                                 INPUT  p_RunFlags ,
                                 INPUT  p_Stop_Widget ,
                                 OUTPUT p_hProc ) .

    Parameters  :

      INPUT:
  
      p_RunFile
            Name of operating system file to run.
            
      p_RunFlags
            Controls various run characteristics.
        
        _PERSISTENT
            Tells routine whether to run specified file persistently or not.
            
            Not Present: Run code non-persistently. Persistent procedures
            created by the running code are deleted afterwards.
                    
            Present: Run code persistently. If you pass a valid handle
            for p_Stop_Widget, persistent procedures created by the
            running code are deleted after the run. If p_Stop_Widget
            is not a valid-handle, the persistent procedures are NOT
            deleted.
        
        _PAUSE
            ADE Tool calls and a tool running an os file directly
            should never pause after running.  This allows for control
            of that behavoir.
                        
        _KEEP-WIDGETS
            If not present, create a widget-pool before running
            code and delete that widget-pool after running code.

      p_Stop_Widget
            Handle of widget to WAIT-FOR CHOOSE when running code
            persistently.  Must be a BUTTON or MENU-ITEM.
            
            If passed in as Unknown (?), the WAIT-FOR is not performed.
            See Notes below for more details.

      OUTPUT:
    
      p_hProc
            Procedure handle when file is run persistently.
                 
    Notes       :
        This routine builds a table of PERSISTENT PROCEDURE handles which 
        exist prior to running user code.  After running user code, it
        automatically deletes all PERSISTENT PROCEDURES that are not
        part of the table (ie, those created while running user code)
        IF the code was run non-persistently or the caller passed in
        a valid p_Stop_Widget.
        
        This routine also builds a tables of AppServer and Socket handles
        that exist prior to running user code.  After running user code, it
        automatically deletes all AppServer and Socket handles that are not
        part of the table (ie, those created while running user code).
        
        
    Authors     : John Palazzo
    Created     : May, 1994
    Modified by : jep on 10/20/99 - Delete user AppServer and Sockets.
                  wtw on 09/11/95 - Cleanup the ADM-BROKER after a run.
                  jep on 08/04/95 - Support Unknown p_Stop_Widget value.
                  jep on 07/03/95 - Handle WINDOW-CLOSE for DEFAULT-WINDOW.
                  gfs on 01/18/94 - Added check for ADEPersistent in DeleteProc
**************************************************************************/

/* ***************************  Definitions  ************************** */

/* -- Preprocessor Definitions ---------------------------------------- */
&IF DEFINED(ADEICONDIR) = 0 &THEN
 {adecomm/icondir.i}
&ENDIF

/* -- Parameter Definitions ------------------------------------------- */
DEFINE INPUT  PARAMETER p_RunFile     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_RunFlags    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_Stop_Widget AS WIDGET    NO-UNDO.
DEFINE OUTPUT PARAMETER p_hProc       AS HANDLE    NO-UNDO.

/* -- Local Definitions ----------------------------------------------- */
/* WebSpeed stream and new global definitions. Customers who edit and
   recompile _runcode.p can comment out this include line if they
   do not have WebSpeed. */
{ src/web/method/cgidefs.i NEW}

DEFINE TEMP-TABLE PersistProc NO-UNDO
    FIELD hProc     AS HANDLE
    INDEX ObjHandle IS PRIMARY hProc.
    
DEFINE TEMP-TABLE PersistProcDelete NO-UNDO
    FIELD hProc      AS HANDLE
    FIELD isDelete   as logical 
    FIELD isADETool  as logical
    FIELD SuperString as char
    INDEX ObjHandle IS PRIMARY hProc
    INDEX isDELETE  isDelete.

DEFINE TEMP-TABLE AppServer   NO-UNDO
    FIELD hServer   AS HANDLE
    INDEX ObjHandle IS PRIMARY hServer.

DEFINE TEMP-TABLE ASocket     NO-UNDO
    FIELD hSocket   AS HANDLE
    INDEX ObjHandle IS PRIMARY hSocket.

DEFINE TEMP-TABLE AServSocket     NO-UNDO
    FIELD hSocket   AS HANDLE
    INDEX ObjHandle IS PRIMARY hSocket.

DEFINE VARIABLE v_RunPersist  AS LOGICAL     NO-UNDO INITIAL FALSE.
DEFINE VARIABLE v_Pause       AS LOGICAL     NO-UNDO INITIAL TRUE.
DEFINE VARIABLE v_KeepWidgets AS LOGICAL     NO-UNDO INITIAL FALSE.
DEFINE VARIABLE hCurWin       AS HANDLE      NO-UNDO.
DEFINE VARIABLE hWindow       AS HANDLE      NO-UNDO.  
DEFINE VARIABLE Delete_Proc   AS HANDLE      NO-UNDO.
DEFINE VARIABLE Def_Private   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_Logical     AS LOGICAL     NO-UNDO.

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
         HEIGHT             = 8.33
         WIDTH              = 54.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* Initialize RunFlags. */
ASSIGN v_RunPersist   = CAN-DO(p_RunFlags, "_PERSISTENT":U)
       v_Pause        = CAN-DO(p_RunFlags, "_PAUSE":U)
       v_KeepWidgets  = CAN-DO(p_RunFlags, "_KEEP-WIDGETS":U)
       NO-ERROR. /* END ASSIGN */
         
REPEAT ON QUIT       , LEAVE
       ON STOP   UNDO, LEAVE
       ON ERROR  UNDO, LEAVE
       ON ENDKEY UNDO, LEAVE :

  /* Build table of existing Persistent procedures. Delete ones not in
     table after user's code completes. */
  RUN BuildPersistProc.
  /* Build table of existing AppServer connections. Delete ones not in
     table after user's code completes. */
  RUN BuildAppServer.
  /* Build table of existing Socket connections. Delete ones not in
     table after user's code completes. */
  RUN BuildSocket.

  /* Reset Progress Session defaults for execute window. */
  RUN SessionDefaults ( INPUT DEFAULT-WINDOW ) .

  ASSIGN DEFAULT-WINDOW:SENSITIVE   = TRUE
         hCurWin                    = CURRENT-WINDOW
         CURRENT-WINDOW             = DEFAULT-WINDOW
         . /* END ASSIGN */

  /* Ensure the Tool does not have focus when running user's code by
     "killing" FOCUS - that is, making it null.
  */
  RUN KillFocus ( INPUT DEFAULT-WINDOW ,
                  INPUT DEFAULT-WINDOW:FIRST-CHILD ).

  /* Allow user to close Run window with click on close icon. */
  ASSIGN Def_Private = DEFAULT-WINDOW:PRIVATE-DATA.
  ON WINDOW-CLOSE OF DEFAULT-WINDOW
  DO:
    ASSIGN DEFAULT-WINDOW:PRIVATE-DATA = "END-ERROR":U.
    APPLY "END-ERROR" TO DEFAULT-WINDOW.
  END.
  /* Add purple Progress icon. */
  ASSIGN v_Logical = DEFAULT-WINDOW:LOAD-ICON("adeicon/progress.ico") NO-ERROR.

  IF NOT v_KeepWidgets THEN CREATE WIDGET-POOL .

  IF v_RunPersist = FALSE THEN
    RUN VALUE( p_RunFile ).
  ELSE
  DO:
    /* Run the user's file persistent. */
    RUN VALUE( p_RunFile ) PERSISTENT SET p_hProc.
        
    /* If the user has already deleted their own persistent procedure,
       then we don't wait in our window.  We take it to mean the user
       has nothing to run persistently.
    */
    IF VALID-HANDLE( p_hProc ) AND VALID-HANDLE( p_Stop_Widget ) THEN
    DO:
      /* If valid, we will use the persistent procedure's current window to
         check for events which close the window and hence close the
         persistent procedure.
      */
      ASSIGN hCurWin = IF VALID-HANDLE(p_hProc:CURRENT-WINDOW)
                       THEN p_hProc:CURRENT-WINDOW
                       ELSE DEFAULT-WINDOW. 
      /* In addition to waiting for CHOOSE of the stop widget, we also
         wait for the events most likely to close a persistent window:
         WINDOW-CLOSE and CLOSE.  By default, if the user does a Window Close 
         (Alt+F4) in a persistent window, the .w code sends a CLOSE event
         which we detect here along with WINDOW-CLOSE and force a STOP.
      */
      WAIT-FOR    WINDOW-CLOSE,CLOSE OF p_hProc 
               OR WINDOW-CLOSE,CLOSE OF hCurWin
               OR CHOOSE             OF p_Stop_Widget.
    END.
    
  END.
  
  LEAVE.

END. /* REPEAT */

REPEAT ON QUIT       , LEAVE
       ON STOP   UNDO, LEAVE
       ON ERROR  UNDO, LEAVE
       ON ENDKEY UNDO, LEAVE :
  /* Only pause in a window which is visible and user has requested to pause. */
  /* However, if user clicks Close icon, close with no pause. */
  IF ( DEFAULT-WINDOW:VISIBLE = TRUE ) AND ( v_Pause = TRUE ) AND
     ( DEFAULT-WINDOW:PRIVATE-DATA <> "END-ERROR")
  THEN PAUSE IN WINDOW DEFAULT-WINDOW
             MESSAGE "Procedure complete. Press space bar to continue.".
  LEAVE.
END.
ASSIGN DEFAULT-WINDOW:PRIVATE-DATA = Def_Private.

/* Delete Persistent Procedures created by running user code. */
IF v_RunPersist = FALSE OR
   VALID-HANDLE( p_Stop_Widget ) THEN RUN DeletePersistProc.

/* Delete AppServer and Socket connections created by running user code
   (done after DeletePersistProc call above to allow PPs to use the
    AppServer and/or Socket if needed during their cleanup).
*/
RUN DeleteAppServer.
RUN DeleteSocket.

/* Find the ADM-BROKER and ask it to clean itself up. */
RUN cleanup-ADM-broker.

/* Delete any widgets created dynamically in the default widget-pool. */
IF NOT v_KeepWidgets THEN DELETE WIDGET-POOL.
    
/* Reset Progress Session defaults for execute window. */
RUN SessionDefaults ( INPUT DEFAULT-WINDOW ) .

/* Reset major attributes for default/run window (font, title etc. */
RUN DefWinReset ( INPUT DEFAULT-WINDOW ).
IF VALID-HANDLE(hCurWin) THEN
  ASSIGN CURRENT-WINDOW = hCurWin.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-BuildAppServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuildAppServer Procedure 
PROCEDURE BuildAppServer :
/*------------------------------------------------------------------------------
  Purpose:    Build a table of existing AppServer connections. After user's
              code runs, any ones in addition to these are user created and
              will be deleted before ending.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hAppServer  AS HANDLE NO-UNDO.

  ASSIGN hAppServer = SESSION:FIRST-SERVER.

  DO WHILE VALID-HANDLE( hAppServer ):
    CREATE AppServer.
    ASSIGN AppServer.hServer = hAppServer
           hAppServer        = hAppServer:NEXT-SIBLING.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-BuildPersistProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuildPersistProc Procedure 
PROCEDURE BuildPersistProc :
/*------------------------------------------------------------------------------
  Purpose:  Build a table of existing Persistent Procedures. After user's
            code runs, any ones in addition to these are user created and
            will be deleted before ending.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hProcedure AS HANDLE NO-UNDO.

  ASSIGN hProcedure = SESSION:FIRST-PROCEDURE.

  DO WHILE VALID-HANDLE( hProcedure ):
    CREATE PersistProc.
    ASSIGN PersistProc.hProc = hProcedure
           hProcedure        = hProcedure:NEXT-SIBLING.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-BuildSocket) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuildSocket Procedure 
PROCEDURE BuildSocket :
/*------------------------------------------------------------------------------
  Purpose:    Build a table of existing Socket connections. After user's
              code runs, any ones in addition to these are user created and
              will be deleted before ending.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSocket     AS HANDLE NO-UNDO.

  ASSIGN hSocket = SESSION:FIRST-SOCKET.

  DO WHILE VALID-HANDLE( hSocket ):
    CREATE ASocket.
    ASSIGN ASocket.hSocket = hSocket
           hSocket         = hSocket:NEXT-SIBLING.
  END.

  ASSIGN hSocket = SESSION:FIRST-SERVER-SOCKET.

  DO WHILE VALID-HANDLE( hSocket ):
    CREATE AServSocket.
    ASSIGN AServSocket.hSocket = hSocket
           hSocket             = hSocket:NEXT-SIBLING.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cleanup-ADM-broker) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cleanup-ADM-broker Procedure 
PROCEDURE cleanup-ADM-broker :
/*------------------------------------------------------------------------------
  Purpose:   Look at all remaining procedures. If any are ADM-BROKER's, 
             then ask them to clean themselves up. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hProcedure AS HANDLE NO-UNDO. 
  DEFINE VARIABLE cType      AS CHAR   NO-UNDO.

  ASSIGN hProcedure = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE( hProcedure ):  
    /* If it is of TYPE = "ADM-BROKER" then it is a procedure we want
       to deal with. */
    RUN get-attribute IN hProcedure ('TYPE':U) NO-ERROR. 
    cType = IF ERROR-STATUS:ERROR THEN ? ELSE RETURN-VALUE.
    IF cType eq 'ADM-Broker':U THEN RUN cleanup-links IN hProcedure NO-ERROR.

    /* Get the next persistent procedure. */
    ASSIGN hProcedure = hProcedure:NEXT-SIBLING.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ContainerObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ContainerObjects Procedure 
PROCEDURE ContainerObjects :
/*------------------------------------------------------------------------------
  Purpose:     Find all contained objects and their super procedures 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phProc as HANDLE no-undo.
  DEFINE OUTPUT PARAMETER pcProcs as CHAR NO-UNDO.
   
  DEF VAR cType    AS CHARACTER NO-UNDO.
  DEF VAR cObjects AS CHARACTER NO-UNDO.
  DEF VAR i        AS INTEGER   NO-UNDO.
  DEF VAR hObject  AS HANDLE    No-UNDO.
  
  pcprocs = phProc:SUPER-PROCEDURES.
  
  cType = DYNAMIC-FUNCTION("getObjectType":U in phProc)  NO-ERROR.
  IF cType = "SmartWindow":U THEN
  DO:
    cObjects = DYNAMIC-FUNCTION("getContainerTarget":U in phProc).
    IF cObjects > "" THEN
       pcprocs = pcprocs + (IF pcprocs = "" then "" else ",") + cObjects.
    /* Now derive the super procedures */   
    DO i = 1 to NUM-ENTRIES(cObjects):
      hObject = WIDGET-HANDLE(ENTRY(i,cObjects)) NO-ERROR.
      IF VALID-HANDLE(hObject) AND hObject:SUPER-PROCEDURES > "" THEN
         pcprocs = pcprocs + (IF pcprocs = "" then "" else ",") 
                         + hObject:SUPER-PROCEDURES.
    END.
  END. 
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DefWinReset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DefWinReset Procedure 
PROCEDURE DefWinReset :
/*--------------------------------------------------------------------------
    Purpose:        Resets a window's attributes to the Progress 
                    Initial window defaults.

    Run Syntax:     RUN DefWinReset( INPUT p_Window ).

    Parameters:     INPUT p_Window  - Window to reset.

    Description:
    Notes:
  --------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.
    
    DEFINE VAR Default_Win AS WIDGET-HANDLE NO-UNDO.
    
    /* proc-main */
    REPEAT ON STOP UNDO, RETRY:
        IF ( SESSION:WINDOW-SYSTEM = "TTY" ) THEN
        DO:
            ASSIGN p_Window:MENUBAR = ?.
            RETURN.
        END.
        
        IF NOT RETRY
        THEN DO:
            CREATE WINDOW Default_Win.
            ASSIGN
                p_Window:FONT    = Default_Win:FONT
                p_Window:BGCOLOR = Default_Win:BGCOLOR
                p_Window:FGCOLOR = Default_Win:FGCOLOR
                p_Window:TITLE   = Default_Win:TITLE
                p_Window:MENUBAR = ?
                p_Window:VIRTUAL-WIDTH   = Default_Win:VIRTUAL-WIDTH
                p_Window:VIRTUAL-HEIGHT  = Default_Win:VIRTUAL-HEIGHT
                p_Window:MAX-WIDTH   = Default_Win:MAX-WIDTH
                p_Window:MAX-HEIGHT  = Default_Win:MAX-HEIGHT
                p_Window:MIN-WIDTH   = Default_Win:MIN-WIDTH
                p_Window:MIN-HEIGHT  = Default_Win:MIN-HEIGHT
                p_Window:WIDTH   = Default_Win:WIDTH
                p_Window:HEIGHT  = Default_Win:HEIGHT
            . /* END-ASSIGN */
        END.
        DELETE WIDGET Default_Win.
        LEAVE.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DeleteAppServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteAppServer Procedure 
PROCEDURE DeleteAppServer :
/*------------------------------------------------------------------------------
  Purpose:  Delete user-created AppServer connections by deleting the ones not
            in the table (ie, not present before running user's code).    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hAppServer AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDelServer AS HANDLE NO-UNDO.

  ASSIGN hAppServer = SESSION:FIRST-SERVER.

  DO WHILE VALID-HANDLE( hAppServer ):
    hDelServer = hAppServer.
    hAppServer = hAppServer:NEXT-SIBLING.
    FIND FIRST AppServer WHERE AppServer.hServer = hDelServer NO-ERROR.
    IF NOT AVAILABLE AppServer THEN
    DO:
      hDelServer:DISCONNECT() NO-ERROR.
      DELETE OBJECT hDelServer NO-ERROR.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DeletePersistProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeletePersistProc Procedure 
PROCEDURE DeletePersistProc :
/*------------------------------------------------------------------------------
  Purpose:     Delete user-created Persistent Procedures by deleting the ones 
               not in the table (ie, not present before running user's code). 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hProcedure  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cProcs      AS CHAR       NO-UNDO.
  DEFINE VARIABLE i           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cObjectType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuper      AS LOGICAL    NO-UNDO.

  ASSIGN hProcedure = SESSION:FIRST-PROCEDURE.
  
  DO WHILE VALID-HANDLE( hProcedure ):
    FIND FIRST PersistProc WHERE PersistProc.hProc = hProcedure NO-ERROR.
    IF NOT AVAILABLE PersistProc THEN
      ASSIGN Delete_Proc = hProcedure.
    ELSE
       ASSIGN Delete_Proc = ?.              
   
    ASSIGN hProcedure = hProcedure:NEXT-SIBLING.
    /* Store all procedures in a temp table to be flagged for deletion later */
    IF VALID-HANDLE(Delete_Proc) THEN
    DO:
      CREATE PersistProcDelete.
      ASSIGN PersistProcDelete.hProc = Delete_proc
             PersistProcDelete.isDelete = LOOKUP("ADEPersistent",Delete_Proc:INTERNAL-ENTRIES) EQ 0
             PersistProcDelete.isADETool = LOOKUP("ADEPersistent",Delete_Proc:INTERNAL-ENTRIES) NE 0.
      /* Calculate the super procedures for ADETool Objects */
      IF PersistProcDelete.isADETool THEN
      DO:
          /* This will retrieve the objects super procs, and it's contained objects if it's a smartWindow */
         RUN ContainerObjects in THIS-PROCEDURE (Delete_proc, OUTPUT cProcs).
         ASSIGN PersistProcDelete.superString = cProcs.
      END.
    END.

  END. /* End looping through procedure */
  /* Now flag any procedures used as non deletable */
  DEFINE BUFFER BuffPersist FOR PersistProcDelete.
  
  FOR EACH PersistProcDelete WHERE PersistProcDelete.isADETool:
    FOR EACH BuffPersist WHERE NOT BuffPersist.isADETool:
       /* If the list of deleted procedures is a super procedure or contained object of the AdeTool, do not delete it */
       IF LOOKUP(STRING(BuffPersist.hProc), PersistProcDelete.SuperString) NE 0 THEN
          ASSIGN BuffPersist.isDelete = NO.
    END.
    
  END.  
    
  FOR EACH PersistProcDelete WHERE PersistProcDelete.isDelete:      
    lSuper = FALSE.
    IF VALID-HANDLE(PersistProcDelete.hProc) THEN 
    DO:
      ASSIGN 
        cObjectType = ?
        cObjectType = {fn getObjectType PersistProcDelete.hProc} NO-ERROR. 
      IF cObjectType > '':U AND cObjectType <> 'SUPER':U THEN
        RUN destroyObject IN PersistProcDelete.hProc NO-ERROR.
      ELSE 
        lSuper = TRUE.
    END.
    IF NOT lSuper THEN
    DO:
      IF  VALID-HANDLE(PersistProcDelete.hProc) 
      AND LOOKUP("dispatch":U,PersistProcDelete.hProc:INTERNAL-ENTRIES) NE 0 THEN
        RUN dispatch IN PersistProcDelete.hProc ('destroy':U).
    
      ELSE IF VALID-HANDLE(PersistProcDelete.hProc) THEN 
        APPLY "CLOSE":U TO PersistProcDelete.hProc.
    
      IF VALID-HANDLE(PersistProcDelete.hProc) THEN
        DELETE PROCEDURE PersistProcDelete.hProc .    

      DELETE PersistProcDelete. 
    END.
  END.
  
  /* Delete supers last  */
  FOR EACH PersistProcDelete WHERE PersistProcDelete.isDelete:      
    IF VALID-HANDLE(PersistProcDelete.hProc) THEN
      DELETE PROCEDURE PersistProcDelete.hProc.        
  END.

  EMPTY TEMP-TABLE PersistProcDelete.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DeleteSocket) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteSocket Procedure 
PROCEDURE DeleteSocket :
/*------------------------------------------------------------------------------
  Purpose:  Delete user-created Socket connections by deleting the ones not
            in the table (ie, not present before running user's code). 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSocket    AS HANDLE NO-UNDO.
  DEFINE VARIABLE hDelSocket AS HANDLE NO-UNDO.

  ASSIGN hSocket = SESSION:FIRST-SOCKET.

  DO WHILE VALID-HANDLE( hSocket ):
    hDelSocket = hSocket.
    hSocket = hSocket:NEXT-SIBLING.
    FIND FIRST ASocket WHERE ASocket.hSocket = hDelSocket NO-ERROR.
    IF NOT AVAILABLE ASocket THEN
    DO:
      hDelSocket:DISCONNECT() NO-ERROR.
      DELETE OBJECT hDelSocket NO-ERROR.
    END.
  END.

  ASSIGN hSocket = SESSION:FIRST-SERVER-SOCKET.

  DO WHILE VALID-HANDLE( hSocket ):
    hDelSocket = hSocket.
    hSocket = hSocket:NEXT-SIBLING.
    FIND FIRST AServSocket WHERE AServSocket.hSocket = hDelSocket NO-ERROR.
    IF NOT AVAILABLE AServSocket THEN
    DO:
      hDelSocket:DISABLE-CONNECTIONS() NO-ERROR.
      DELETE OBJECT hDelSocket NO-ERROR.
    END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-KillFocus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE KillFocus Procedure 
PROCEDURE KillFocus :
/*--------------------------------------------------------------------------
    Purpose:        Kills FOCUS so its no longer in a Tool's window.

    Run Syntax:
        RUN KillFocus ( INPUT p_Execute_Window ,
                        INPUT p_hFrame ).
                        
    Parameters:
    
    Description:
        1. Ensures the Tool does not have focus
           when it becomes disabled before running user's code.
        2. User can no longer access the Tool's handle via
           FOCUS or FRAME-VALUE when their code runs.
    
    Notes:
        1. To move focus out of Tool, we move focus into a temp editor
           widget and then delete the widget.  Also...
        2. We Apply entry to the execute window.
        
        One and Two together move FOCUS out to nowhere (null focus) and
        deacticates FRAME-VALUE until user actives it. 
        
        This only works for GUI, not TTY.
  --------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Execute_Window  AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_hFrame          AS WIDGET-HANDLE NO-UNDO.

  DEFINE VARIABLE hTempEd                  AS WIDGET-HANDLE NO-UNDO.
  
  
  DO ON STOP UNDO, LEAVE:
  
      /* Create a temp editor widget. We'll put focus in it, then destroy
         it before running user's code. This ensures the Tool will not
         have focus when the user's code runs. User can no longer access
         the Tool's handle via FOCUS or FRAME-VALUE when their code runs.
      */
      CREATE FRAME p_hFrame
        ASSIGN PARENT = p_Execute_Window
               HIDDEN = TRUE.
             
      CREATE EDITOR hTempEd
        ASSIGN HIDDEN    = TRUE
               FRAME     = p_hFrame
               SENSITIVE = TRUE
        . /* ASSIGN */  
        
      APPLY "ENTRY" TO hTempED.
      ASSIGN hTempEd:SENSITIVE = FALSE.
  
  END. /* DO ON STOP */
  
  /* Destory the temp focus editor.  Progress puts focus nowhere, so the
     Tool will not have it. Note the VALID-HANDLE check prevents the
     DELETE WIDGET from executing if some stop condition occurred
     before hTempEd got created.
  */
  IF VALID-HANDLE( hTempEd ) THEN
      DELETE WIDGET hTempED.
  IF VALID-HANDLE( p_Execute_Window ) THEN
      APPLY "ENTRY" TO p_Execute_Window.
  IF VALID-HANDLE(p_hFrame) THEN
      DELETE WIDGET p_hFrame.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SessionDefaults) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SessionDefaults Procedure 
PROCEDURE SessionDefaults :
/*--------------------------------------------------------------------------
    Purpose:     Reset Progress Session defaults for specfied window.
    Run Syntax:     RUN SessionDefaults ( INPUT p_Window ).
    Parameters:     p_Window : Handle to window to set session defaults.
    Description:
    Notes:
  --------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Window AS WIDGET-HANDLE NO-UNDO.

  DEFINE VAR Temp_Var   AS LOGICAL NO-UNDO.
  DEFINE VAR Immed_Disp AS LOGICAL NO-UNDO.

  /* Most important after run.  Must be sure user wait state is cleared. */
  ASSIGN 
      Temp_Var = SESSION:SET-WAIT-STATE("")
      Temp_Var = p_Window:LOAD-MOUSE-POINTER("")
      NO-ERROR . /* END ASSIGN */

  /* Hide the execute window. */
  HIDE p_Window.
   
  /* Clear the execute window.      */
  HIDE ALL NO-PAUSE IN WINDOW p_Window .
  /* Clear previous messages.*/
  HIDE MESSAGE NO-PAUSE IN WINDOW p_Window .

  /* Reset Status Input and Default to PROGRESS defaults. */
  /* Needed to force display of status using IMMEDIATE-DISPLAY. */
  ASSIGN Immed_Disp = SESSION:IMMEDIATE-DISPLAY
         SESSION:IMMEDIATE-DISPLAY = TRUE.
  STATUS DEFAULT IN WINDOW p_Window .
  STATUS INPUT  IN WINDOW p_Window .
  ASSIGN SESSION:IMMEDIATE-DISPLAY = Immed_Disp.
   /* Default PAUSE processsing.      */   PAUSE IN WINDOW p_Window BEFORE-HIDE.
  
  /* Be certain to reset to default Progress Environment File. */
  USE "" NO-ERROR.
       
  /* In TTY, Use Message area for R-T errors. GUI: Use Alert-Boxes. */
  ASSIGN SESSION:SYSTEM-ALERT-BOXES = ( SESSION:WINDOW-SYSTEM <> "TTY" ) .
  
  /* Set DATA-ENTRY-RETURN to appropriate default for window system. */
  ASSIGN SESSION:DATA-ENTRY-RETURN  = ( SESSION:WINDOW-SYSTEM = "TTY" ) . 
  
  &IF ( "{&WINDOW-SYSTEM}" <> "TTY" ) &THEN
  /* Bring the default execution window (DEFAULT-WINDOW) topmost.  This
     does not mean its made visible.  It just means that if the user displays
     or gets input from it, by default the window will be brought to the
     top.  See bug 92-12-23-023. jep */
  ASSIGN Temp_Var = p_Window:MOVE-TO-TOP().
  &ENDIF

  &IF ( "{&WINDOW-SYSTEM}" <> "TTY" ) &THEN
  /* Set the ALT-TAB icon for the session. */
  SESSION:LOAD-ICON({&ADEICON-DIR} + "progress.ico":U) NO-ERROR.
  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

