&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    Library     : brokcntn.i
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

DEFINE VARIABLE adm-prev-page AS INTEGER NO-UNDO. /*for TTY select/change-page*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = .04
         WIDTH              = 37.14.
                                                                        */
&ANALYZE-RESUME
 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

{src/adm/method/attribut.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-broker-change-page) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE broker-change-page Method-Library 
PROCEDURE broker-change-page :
/*------------------------------------------------------------------------------
  Purpose:     Guts of adm-change-page procedure.
  Parameters:  Caller's procedure handle
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-caller AS HANDLE NO-UNDO.
  
  DEFINE VARIABLE page-char          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE page-handle-list   AS CHARACTER NO-UNDO. 
  
    /* Let folder know, if any*/
    RUN broker-notify (p-caller, 'change-folder-page,PAGE-SOURCE':U). 
    page-char = "PAGE":U + {src/adm/method/get-attr.i p-caller CURRENT-PAGE} 
       + "-TARGET":U.

    /* If changing to page 0, don't look for PAGE0 links (there won't be any)
       or try to re-run create-objects for it. */
    IF page-char NE "PAGE0-TARGET":U THEN
    DO:
      RUN get-link-handle in adm-broker-hdl (INPUT p-caller, 
        INPUT page-char, OUTPUT page-handle-list) NO-ERROR.
      IF page-handle-list = "":U THEN
      DO:                            /* Page hasn't been created yet: */
        RUN set-cursor IN adm-broker-hdl('WAIT':U) NO-ERROR.
        /* Get objects on the new page created. */
        {src/adm/method/dispatch.i p-caller 'create-objects':U}
        /* If the current container object has been initialized already,
           then initialize the new objects. Otherwise wait to let it happen
           when the container is init'ed. */
        IF {src/adm/method/get-attr.i p-caller INITIALIZED} EQ "YES":U THEN
            RUN broker-notify IN THIS-PROCEDURE 
                (p-caller, 'initialize,':U + page-char).
        RUN set-cursor IN adm-broker-hdl("":U) NO-ERROR.
      END.
      ELSE 
      DO:
         /* If the container has been init'ed, then view its contents.
            If not, 'view' will have no effect yet, so just mark the
            contents to be viewed when the container *is* init'ed. */
         IF {src/adm/method/get-attr.i p-caller INITIALIZED} EQ "YES":U THEN
           RUN broker-notify (p-caller, 'view,':U + page-char).
         ELSE
           RUN set-link-attribute (p-caller, page-char, 'HIDE-ON-INIT=NO':U).
      END.
    END.

    /* Hide and view Page 0 (the default frame) of the window for character
       mode if switching to/from a page which is another window in GUI. */
    &IF "{&WINDOW-SYSTEM}":U = "TTY":U AND "{&FRAME-NAME}":U NE "":U &THEN
        DEFINE VARIABLE prev-page-hdl    AS HANDLE NO-UNDO.
        DEFINE VARIABLE new-page-hdl     AS HANDLE NO-UNDO.
        DEFINE VARIABLE prev-page-is-win AS LOGICAL NO-UNDO INIT no.
        DEFINE VARIABLE new-page-is-win  AS LOGICAL NO-UNDO INIT no.
        DEFINE VARIABLE parent-win-hdl   AS HANDLE NO-UNDO.
        DEFINE VARIABLE default-frame-hdl AS HANDLE NO-UNDO.
        DEFINE VARIABLE page-hdl         AS HANDLE NO-UNDO.

        RUN get-link-handle IN adm-broker-hdl (INPUT p-caller,
            INPUT page-char, OUTPUT page-handle-list) NO-ERROR.
        IF page-handle-list NE "":U THEN DO:
            page-hdl = WIDGET-HANDLE(ENTRY(1,page-handle-list)).
            new-page-hdl =         /* Is the new page a window? */
              WIDGET-HANDLE
                ({src/adm/method/get-attr.i page-hdl ADM-OBJECT-HANDLE}). 
        END.
        RUN get-link-handle IN adm-broker-hdl (INPUT p-caller,
            INPUT "PAGE":U + STRING(adm-prev-page) + "-TARGET":U,
            OUTPUT page-handle-list) NO-ERROR.
        IF page-handle-list NE "":U THEN DO:
            page-hdl = WIDGET-HANDLE(ENTRY(1,page-handle-list)).
            prev-page-hdl =        /* Is the old page a window? */ 
              WIDGET-HANDLE
                ({src/adm/method/get-attr.i page-hdl ADM-OBJECT-HANDLE}). 
        END.
        /* If both the prev and new pages are other windows, then do nothing. 
           Else if going to another window then HIDE page 0 of current window,
           or if coming *from* another window then VIEW page 0. */
        parent-win-hdl = 
          WIDGET-HANDLE
            ({src/adm/method/get-attr.i p-caller ADM-OBJECT-HANDLE}). 
        IF VALID-HANDLE(parent-win-hdl) THEN
            default-frame-hdl = parent-win-hdl:FIRST-CHILD.
        IF VALID-HANDLE(default-frame-hdl) THEN /* Sanity check that there is */
        DO:                                     /* a default frame in the caller. */
            IF VALID-HANDLE(new-page-hdl) AND new-page-hdl:TYPE = "WINDOW":U
              THEN new-page-is-win = yes.
            IF VALID-HANDLE(prev-page-hdl) AND prev-page-hdl:TYPE = "WINDOW":U
              THEN prev-page-is-win = yes.
            IF new-page-is-win AND NOT prev-page-is-win 
              THEN HIDE default-frame-hdl.         
            ELSE IF prev-page-is-win AND NOT new-page-is-win
              THEN  VIEW default-frame-hdl.
        END.
    &ENDIF
            

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-broker-delete-page) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE broker-delete-page Method-Library 
PROCEDURE broker-delete-page :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-caller AS HANDLE  NO-UNDO.
  DEFINE INPUT PARAMETER p-page#  AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE current-page   AS CHARACTER NO-UNDO.
  
    current-page = {src/adm/method/get-attr.i p-caller CURRENT-PAGE}. 
    /* Temporarily reset the current page, to tell the folder */  
    {src/adm/method/set-attr.i p-caller CURRENT-PAGE STRING(p-page#)}
    RUN broker-notify IN THIS-PROCEDURE 
        (p-caller, 'destroy,PAGE':U + STRING(p-page#) + '-TARGET':U).
    /* Also tell the folder or other paging visualization, if any. */
    RUN broker-notify (p-caller, 'delete-page, PAGE-SOURCE':U). 
    
    {src/adm/method/set-attr.i p-caller CURRENT-PAGE current-page}

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-broker-init-object) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE broker-init-object Method-Library 
PROCEDURE broker-init-object :
/*------------------------------------------------------------------------------
  Purpose:     Guts of the init-object procedure.
  Parameters:  The caller's procedure handle, plus the
               procedure name to run, handle to parent its adm-object to,
               attribute list to set, and OUTPUT the new procedure handle.
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  p-caller      AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER  p-proc-name   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  p-parent-hdl  AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER  p-attr-list   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p-proc-hdl    AS HANDLE    NO-UNDO.

  DEFINE VARIABLE         tmp-handle    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE         obj-version   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE         current-page  AS CHARACTER NO-UNDO.
 
  RUN VALUE(p-proc-name) PERSISTENT SET p-proc-hdl.
  /* Verify that the object was created successfully. */
  IF NOT VALID-HANDLE (p-proc-hdl) THEN RETURN ERROR.  

  /* Check to make sure that the object version matches the broker version. 
     In the event this is a new ADM2 object, then the old get-attr won't
     work at all. */

  obj-version = dynamic-function("getObjectVersion":U IN p-proc-hdl) NO-ERROR.
  IF obj-version = ? THEN    /* it isn't a V9 object */
    obj-version = {src/adm/method/get-attr.i p-proc-hdl VERSION}. 
  IF obj-version NE "{&ADM-VERSION}":U THEN 
  DO:
      MESSAGE "Version":U obj-version "for SmartObject":U p-proc-hdl:FILE-NAME 
              SKIP "does not match ADM Broker Version {&ADM-VERSION}":U.
      IF obj-version < "ADM2.0":U THEN
        {src/adm/method/dispatch.i p-proc-hdl 'destroy':U}
      ELSE RUN destroyObject IN p-proc-hdl NO-ERROR.
      STOP.
  END.    /* END DO If wrong version */
  
  /* For character mode, don't attempt to parent a new window procedure. */
&IF "{&WINDOW-SYSTEM}":U = "TTY":U &THEN
  tmp-handle = 
    WIDGET-HANDLE({src/adm/method/get-attr.i p-proc-hdl ADM-OBJECT-HANDLE}). 
  IF VALID-HANDLE(tmp-handle) AND tmp-handle:TYPE NE "WINDOW" THEN
&ENDIF
    RUN broker-set-attribute-list (p-proc-hdl, 
        'ADM-PARENT=' + STRING(p-parent-hdl)).

  IF p-attr-list <> "":U THEN RUN broker-set-attribute-list IN adm-broker-hdl
      (p-proc-hdl, p-attr-list).
  
  /* Now create the default link to the containing object. */

  RUN add-link IN adm-broker-hdl
      (INPUT p-caller, INPUT "CONTAINER":U, INPUT p-proc-hdl).     
  
  /* If the current "page" is not 0, then this object is part
     of a paging control. Setup a page link for it. */
  
  current-page = {src/adm/method/get-attr.i p-caller CURRENT-PAGE}.
  IF current-page <> "0":U THEN
      RUN add-link IN adm-broker-hdl
          (INPUT p-caller, INPUT "PAGE":U + current-page, 
          INPUT p-proc-hdl). 
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-broker-init-pages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE broker-init-pages Method-Library 
PROCEDURE broker-init-pages :
/*------------------------------------------------------------------------------
  Purpose:     Guts of the init-pages procedure.
  Parameters:  Caller's procedure handle, and a list of pages to initialize.
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-caller    AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-page-list AS CHARACTER NO-UNDO.

  DEFINE VARIABLE        page-cntr        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE        object-cntr      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE        save-page        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE        page-char        AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE        page-handle-list AS CHARACTER NO-UNDO.
  DEFINE VARIABLE        page-handle      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE        current-page     AS CHARACTER NO-UNDO.
    
    save-page = {src/adm/method/get-attr.i p-caller CURRENT-PAGE}. 
    
    DO page-cntr = 1 TO NUM-ENTRIES(p-page-list): 
        current-page = ENTRY(page-cntr,p-page-list).     
        {src/adm/method/set-attr.i p-caller CURRENT-PAGE current-page}
        IF current-page NE "0" THEN 
        DO:                     /* Shouldn't be called for page 0 */
            page-char = "PAGE":U + current-page + 
                "-TARGET":U.
            RUN get-link-handle IN adm-broker-hdl (INPUT p-caller, 
                INPUT page-char, OUTPUT page-handle-list) NO-ERROR.
            IF page-handle-list = "":U THEN
            DO:
                /* Page hasn't been created yet:
                   Get all objects on page init'd*/
                {src/adm/method/dispatch.i p-caller 'create-objects':U}
                /* Tell the objects not to view themselves when they
                   are init'ed; wait until that page is actually selected.*/
                RUN set-link-attribute (p-caller, page-char, 
                    'HIDE-ON-INIT=YES':U).
                /* If the current container object has been initialized already,
                   then initialize the new objects. Otherwise wait to let it 
                   happen when the container is init'ed. */
                IF {src/adm/method/get-attr.i p-caller INITIALIZED} 
                  EQ "YES":U THEN
                    RUN broker-notify (p-caller, 'initialize,':U + page-char). 
            END.
        END.
    END.

    {src/adm/method/set-attr.i p-caller CURRENT-PAGE save-page}
    
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-broker-select-page) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE broker-select-page Method-Library 
PROCEDURE broker-select-page :
/*------------------------------------------------------------------------------
  Purpose:     Guts of the select-page procedure.
  Parameters:  Caller's procedure handle, and new page number to select.
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-caller AS HANDLE  NO-UNDO.
  DEFINE INPUT PARAMETER p-page#  AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE current-page    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE page-hdl-list   AS CHARACTER NO-UNDO.

  current-page = INT({src/adm/method/get-attr.i p-caller CURRENT-PAGE}). 
  IF current-page EQ p-page# THEN 
  /* Don't reselect the same page unless the object(s) on that page
     have since been destroyed (a SmartWindow that was closed, e.g.). */
  DO:                   
      RUN get-link-handle 
        (p-caller, 'PAGE':U + STRING(current-page) + '-TARGET':U, 
         OUTPUT page-hdl-list).
      IF page-hdl-list NE "":U THEN 
        RETURN.
  END.

  IF current-page NE 0 THEN
      RUN broker-notify IN THIS-PROCEDURE 
          (p-caller, 'hide,PAGE':U + STRING(current-page) + '-TARGET':U).
  adm-prev-page = current-page. /* Save old page for TTY change-page*/
  {src/adm/method/set-attr.i p-caller CURRENT-PAGE STRING(p-page#)}
  {src/adm/method/dispatch.i p-caller 'change-page':U}

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-broker-view-page) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE broker-view-page Method-Library 
PROCEDURE broker-view-page :
/*------------------------------------------------------------------------------
  Purpose:     Guts of the view-page procedure.
  Parameters:  Caller's procedure handle, and the new page number to view.
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-caller AS HANDLE  NO-UNDO.
  DEFINE INPUT PARAMETER p-page#  AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE current-page    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE page-hdl-list   AS CHARACTER NO-UNDO.
  
  current-page = INT({src/adm/method/get-attr.i p-caller CURRENT-PAGE}). 
  IF current-page EQ p-page# THEN 
  /* Don't reselect the same page unless the object(s) on that page
     have since been destroyed (a SmartWindow that was closed, e.g.). */
  DO:                   
      RUN get-link-handle 
        (p-caller, 'PAGE':U + STRING(current-page) + '-TARGET':U, 
         OUTPUT page-hdl-list).
      IF page-hdl-list NE "":U THEN 
        RETURN.
  END.

  adm-prev-page = current-page.   /* prev-page used in TTY */
  /* Reset the current page temporarily for change-page */
  {src/adm/method/set-attr.i p-caller CURRENT-PAGE STRING(p-page#)}
  {src/adm/method/dispatch.i p-caller 'change-page':U}
  /* Now restore the currently selected page */
  {src/adm/method/set-attr.i p-caller CURRENT-PAGE STRING(adm-prev-page)}

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

