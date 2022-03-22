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
    Library     : broksmrt.i
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
         HEIGHT             = .85
         WIDTH              = 35.
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

&IF DEFINED(EXCLUDE-broker-apply-entry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE broker-apply-entry Method-Library 
PROCEDURE broker-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Guts of adm-apply-entry event procedure. Applies "ENTRY" to the
               first enabled object in the default frame.
  Parameters:  Caller's procedure handle
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-caller AS HANDLE NO-UNDO.
  
  DEFINE VARIABLE widget-hdl      AS HANDLE NO-UNDO.
  DEFINE VARIABLE object-hdl      AS HANDLE NO-UNDO.

    object-hdl = 
      WIDGET-HANDLE({src/adm/method/get-attr.i p-caller ADM-OBJECT-HANDLE}).
  
    IF VALID-HANDLE(object-hdl) THEN
    DO:     
       DO WHILE object-hdl:TYPE = "WINDOW":U: 
           object-hdl = object-hdl:FIRST-CHILD.    
       END.
       ASSIGN widget-hdl = object-hdl:CURRENT-ITERATION
              widget-hdl = widget-hdl:FIRST-TAB-ITEM.
          
          DO WHILE VALID-HANDLE(widget-hdl) :          
            IF widget-hdl:SENSITIVE AND widget-hdl:VISIBLE THEN
            DO:
               /* In case the new widget with focus is not in the
                  CURRENT-WINDOW, change CURRENT-WINDOW to be the
                  window of the new widget; otherwise it won't actually
                  get focus. */
               DO WHILE (VALID-HANDLE(object-hdl) AND 
                 object-hdl:TYPE NE "WINDOW":U):
                   object-hdl = object-hdl:PARENT.
               END.

               APPLY "ENTRY":U TO widget-hdl.                
               RETURN.
            END.
            ELSE ASSIGN widget-hdl = widget-hdl:NEXT-TAB-ITEM.            
          END.          
    END.  
  
    RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-broker-destroy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE broker-destroy Method-Library 
PROCEDURE broker-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Guts of adm-destory
  Parameters:  Caller's procedure handle
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-caller      AS HANDLE    NO-UNDO.
  
  DEFINE VARIABLE container-hdl-str    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE page-hdl-str         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE container-type       AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE current-page         AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE container-hdl        AS HANDLE    NO-UNDO. 

    /* Unless we're in UIB design mode, verify that there's no transaction
       active that was started within this object before allowing objects 
       to be destroyed. */
    IF ({src/adm/method/get-attr.i p-caller UIB-MODE} EQ ?) 
      AND TRANSACTION THEN 
    DO:
        /* YES if txn started in  a child of this object.*/  
        RUN broker-get-attribute (p-caller, 'ADM-TRANSACTION':U).
        IF RETURN-VALUE = "YES":U THEN 
        DO:
          MESSAGE "You must complete the open transaction before exiting."
            VIEW-AS ALERT-BOX WARNING.
          RETURN.
        END.
    END.

    /* Check MODIFIED field attr. */
    RUN check-modified IN p-caller ('check':U) NO-ERROR.  
  
    container-type = {src/adm/method/get-attr.i p-caller CONTAINER-TYPE}. 
    IF container-type NE "":U THEN
      /* Hide containers before  destroying contents.  */
      {src/adm/method/dispatch.i p-caller 'hide':U}
              
    RUN broker-notify (p-caller, 'destroy':U).
    /* If we close a subwindow in character mode, we need to explicitly
       re-view its parent. */
    &IF "{&WINDOW-SYSTEM}":U = "TTY":U &THEN
        IF CAN-DO('*Window*':U, 
          {src/adm/method/get-attr.i p-caller TYPE}) THEN
        DO:
            RUN request-attribute
              (p-caller, 'CONTAINER-SOURCE':U, 'ADM-OBJECT-HANDLE':U).
            IF VALID-HANDLE(WIDGET-HANDLE(RETURN-VALUE)) THEN
                RUN broker-notify (p-caller, 'view,CONTAINER-SOURCE':U).
        END.
    &ENDIF

    RUN remove-all-links (p-caller) NO-ERROR.

    RUN disable_UI IN p-caller.
    
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-broker-dispatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE broker-dispatch Method-Library 
PROCEDURE broker-dispatch :
/*------------------------------------------------------------------------------
  Purpose:     Guts of dispatch procedure
  Parameters:  Caller's procedure-handle, base method-name
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER p-caller      AS HANDLE    NO-UNDO.
    DEFINE INPUT PARAMETER p-method-name AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE trans-block             AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE caller-name             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE caller-file             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dispatch-qualifier      AS CHARACTER NO-UNDO.

    IF p-method-name BEGINS "adm-":U THEN /* Remove any adm prefix. */
        p-method-name = SUBSTR(p-method-name,5, -1, "CHARACTER":U). 

    /* We must check to make sure that no event procedures are dispatched
       before the object is initialized, to allow users to put code
       into local-initialize and know that it will be first. 
       The exceptions are initialize itself, create-objects,
       and any other event procedures which dispatch create-objects. */
    IF ({src/adm/method/get-attr.i p-caller INITIALIZED} NE "YES":U) AND
       (LOOKUP (p-method-name, adm-pre-initialize-events) = 0 )
          THEN RETURN.

    ASSIGN trans-block = IF LOOKUP(p-method-name, adm-trans-methods) NE 0 
        THEN true ELSE false.     /* Do we need a DO TRANS block? yes/no */
    
    /* Find out who called us to determine which form of the method to run
       next. If this was called from 'dispatch', then look at its caller. 
       IF (in an exceptional case) this event was dispatched from a
       different program altogether, then ignore the caller's event name. */
    caller-name = ENTRY(1, program-name(2), " ":U). /* Internal proc name */
    IF caller-name = "dispatch":U THEN
    DO:
        caller-name = ENTRY(1, program-name(3), " ":U).
        caller-file = IF NUM-ENTRIES(program-name(3), " ":U) = 2 
           THEN ENTRY(2, program-name(3), " ":U)
           ELSE "":U.      /* In case not called from any internal procedure. */
    END.
    ELSE caller-file = IF NUM-ENTRIES(program-name(2), " ":U) = 2 
           THEN ENTRY(2, program-name(2), " ":U)
           ELSE "":U.      

    IF caller-file NE p-caller:file-name THEN
        caller-name = "":U.
    
    /* Unless we are being run from the local- or "custom" (dispatch qualifier)
       form of the method, run the local- form if there is one. */
    dispatch-qualifier = 
        {src/adm/method/get-attr.i p-caller ADM-DISPATCH-QUALIFIER}.
    IF (caller-name NE "local-":U + p-method-name) AND
       (caller-name NE dispatch-qualifier + "-":U + p-method-name) AND
       (LOOKUP("local-":U + p-method-name, 
            p-caller:INTERNAL-ENTRIES) NE 0) 
              THEN p-method-name = "local-":U + p-method-name.
    ELSE IF (dispatch-qualifier NE "":U )
         AND (caller-name NE dispatch-qualifier + "-":U + p-method-name)
         AND (LOOKUP(dispatch-qualifier + "-":U + p-method-name,
            p-caller:INTERNAL-ENTRIES) NE 0) 
              THEN p-method-name = dispatch-qualifier + "-":U 
                 + p-method-name.
    ELSE IF LOOKUP("adm-":U + p-method-name, p-caller:INTERNAL-ENTRIES) NE 0
        THEN p-method-name = "adm-":U + p-method-name.
    /* If no prefixed forms are found, just run the base procedure name. */ 

    /* Log the method name etc. if monitoring */
    IF VALID-HANDLE(adm-watchdog-hdl) THEN
    DO:
      RUN receive-message IN adm-watchdog-hdl 
       (INPUT p-caller, INPUT "":U,
            INPUT p-method-name) NO-ERROR.
    END.

    /* If this method is one that needs an enclosing transaction block
       and there isn't already a transaction active, then start one. 
       This will assure that a local version of the method will also be
       in the transaction. */
    IF trans-block AND NOT TRANSACTION THEN 
    DO:
      DO TRANSACTION ON ERROR  UNDO, RETURN "ADM-ERROR":U
                     ON ENDKEY UNDO, RETURN "ADM-ERROR":U
                     ON STOP   UNDO, RETURN "ADM-ERROR":U :
          RUN VALUE(p-method-name) IN p-caller NO-ERROR.
          IF ERROR-STATUS:ERROR AND ERROR-STATUS:GET-NUMBER(1) <> 2129 AND
             ERROR-STATUS:GET-NUMBER(1) <> 6465
              THEN UNDO, RETURN "ADM-ERROR":U.
      END.   
    END.
    ELSE
        RUN VALUE(p-method-name) IN p-caller NO-ERROR.
    
    /* Catch ADM-detected update errors. */
    IF RETURN-VALUE = "ADM-ERROR":U THEN 
        RETURN "ADM-ERROR":U. 

    IF ERROR-STATUS:ERROR THEN 
    DO:
      /* The SHOW-DISPATCH-ERRORS preprocessor causes "procedure not found"
         errors to be displayed for debugging purposes. Otherwise these
         are suppressed. */
      IF adm-show-dispatch-errors = ? THEN 
      DO:         
          RUN broker-get-attribute 
              (p-caller, 'ADM-SHOW-DISPATCH-ERRORS':U). 
          IF RETURN-VALUE NE "YES":U THEN
            RUN broker-get-attribute 
              (THIS-PROCEDURE, 'ADM-SHOW-DISPATCH-ERRORS':U). 
          adm-show-dispatch-errors = IF RETURN-VALUE = "YES":U THEN yes
            ELSE no.
      END.
      IF adm-show-dispatch-errors OR
        (ERROR-STATUS:GET-NUMBER(1) <> 2129 AND
            ERROR-STATUS:GET-NUMBER(1) <> 6456) /* procedure not found */ 
        THEN DO:
          {src/adm/method/dispatch.i p-caller 'show-errors':U}
          RETURN "ADM-ERROR":U.
        END.
    END.
        

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-broker-get-attribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE broker-get-attribute Method-Library 
PROCEDURE broker-get-attribute :
/*------------------------------------------------------------------------------
  Purpose:     Guts of get-attribute procedure
  Parameters:  Caller's procedure handle, attribute name
  Notes:       
------------------------------------------------------------------------------*/
 
  DEFINE INPUT PARAMETER p-caller       AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-attr-name    AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE attr-value            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE record-hdl-str        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tbl-cntr              AS INTEGER   NO-UNDO.
  DEFINE VARIABLE target-cntr           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE table-list            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE table-name            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE local-tables          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE container-type        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE object-hdl            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE record-hdl            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE attr-index            AS INTEGER   NO-UNDO.

  /* If this attribute is one of the basic ones stored at the head of
     the ADM-DATA list, this will get its position in the list. */
  attr-index = LOOKUP(p-attr-name, adm-basic-attrs).

  CASE p-attr-name:
  
    {src/adm/method/smartget.i}      /* user-defined CASEs */
    
      WHEN "ADM-CONTAINER-EXTERNAL-TABLES":U OR
         WHEN "EXTERNAL-TABLES":U OR
         WHEN "INTERNAL-TABLES":U THEN
         DO:
             local-tables = IF p-attr-name = "INTERNAL-TABLES":U THEN
               {src/adm/method/get-attr.i p-caller INTERNAL-TABLES}
             ELSE {src/adm/method/get-attr.i p-caller EXTERNAL-TABLES}.
             IF local-tables = ? THEN local-tables = "":U.
         
             container-type = 
               {src/adm/method/get-attr.i p-caller CONTAINER-TYPE}.
             IF container-type = ? THEN container-type = "":U.

             /* For EXTERNAL-TABLES, a SmartContainer that has one or more 
                RECORD-TARGETs will pass the request onto that source.  
                Otherwise just return EXTERNAL-TABLES. */
             /* For INTERNAL-TABLES, a SmartContainer that has a 
                RECORD-SOURCE will pass the request onto that source.  
                Otherwise just return INTERNAL-TABLES. */
             /* ADM-CONTAINER-EXTERNAL-TABLES id for internal ADM use, 
                to return the actual value of &EXTERNAL-TABLES for a container 
                without checking for External Tables of contained objects. */

             IF container-type = "":U OR 
                 p-attr-name = "ADM-CONTAINER-EXTERNAL-TABLES":U 
                     THEN RETURN local-tables.
             ELSE IF p-attr-name = "EXTERNAL-TABLES":U THEN
             DO:
               RUN get-link-handle 
                 (p-caller, 'RECORD-TARGET':U, OUTPUT record-hdl-str) NO-ERROR.
               /* Check for at least one target. */
               IF record-hdl-str eq "":U THEN 
                 ASSIGN attr-value = local-tables.
               ELSE DO:
                 ASSIGN table-list = local-tables.
                 /* Pass the request onto each one. */
                 DO target-cntr = 1 TO NUM-ENTRIES(record-hdl-str):
                   record-hdl = 
                     WIDGET-HANDLE(ENTRY(target-cntr,record-hdl-str)).
                   table-name =
                     ENTRY(attr-index, record-hdl:{&ADM-DATA}, "`":U).
                   DO tbl-cntr = 1 TO NUM-ENTRIES(table-name," ":U):
                     IF LOOKUP(table-list, 
                       ENTRY(tbl-cntr, table-name," ":U)," ":U) = 0 THEN 
                     DO:
                       IF table-list NE "":U THEN 
                         table-list = table-list + " ":U.
                       table-list = table-list + 
                         TRIM(ENTRY(tbl-cntr, table-name," ":U)).
                     END.
                   END.
                 END.
                 ASSIGN attr-value = table-list.
               END.
             END.
             ELSE IF p-attr-name = "INTERNAL-TABLES":U THEN 
             DO:
               RUN get-link-handle 
                 (p-caller, 
                   'RECORD-SOURCE':U, OUTPUT record-hdl-str) NO-ERROR.
               /* Check for at least one source. */
               IF record-hdl-str eq "":U THEN 
               ASSIGN attr-value = local-tables.
               ELSE DO:
                 /* Pass the request onto the first (should be only) one. */
                 record-hdl = WIDGET-HANDLE(ENTRY(1,record-hdl-str)).
                 table-name =
                     ENTRY(attr-index, record-hdl:{&ADM-DATA}, "`":U).
                 ASSIGN table-list = "{&INTERNAL-TABLES}":U.
                 DO tbl-cntr = 1 TO NUM-ENTRIES(table-name," ":U):
                   IF LOOKUP(table-list, 
                     ENTRY(tbl-cntr, table-name," ":U)," ":U) = 0 THEN
                   DO:
                     IF table-list NE "":U THEN 
                       table-list = table-list + " ":U.
                     table-list = table-list + 
                       TRIM(ENTRY(tbl-cntr, table-name," ":U)).
                   END.
                 END.
                 ASSIGN attr-value = table-list.
               END.
             END.
      END.
     
      OTHERWISE DO:  
        IF attr-index NE 0 THEN     /* This is one of the basic attrs. */
        DO:
            attr-value = ENTRY(attr-index, p-caller:{&ADM-DATA}, "`":U).
            IF attr-value = "":U THEN attr-value = ?.  /* Attr is undefined. */
        END.
        ELSE DO:
            attr-index = LOOKUP(p-attr-name, 
              ENTRY(2, p-caller:{&ADM-DATA}, "^":U), "`":U).
            IF attr-index NE 0 THEN
              attr-value = ENTRY(attr-index, 
                ENTRY(3, p-caller:{&ADM-DATA}, "^":U), "`":U).
            ELSE DO:
                RUN VALUE ("get-":U + p-attr-name) IN p-caller NO-ERROR.
                attr-value = IF ERROR-STATUS:ERROR THEN ? ELSE RETURN-VALUE.
            END.
        END.
      END.
    END CASE.
    
  /* Log the method name etc. if monitoring */
  IF VALID-HANDLE(adm-watchdog-hdl) THEN
    RUN receive-message IN adm-watchdog-hdl 
     (INPUT p-caller, INPUT "":U,  
          INPUT "get-attribute: ":U + p-attr-name + "=":U + attr-value) 
            NO-ERROR.
          
  IF attr-value = "?":U THEN attr-value = ?.  /* Return Unknown value properly*/
  RETURN attr-value.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-broker-get-attribute-list) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE broker-get-attribute-list Method-Library 
PROCEDURE broker-get-attribute-list :
/*------------------------------------------------------------------------------
  Purpose:     Guts of get-attribute-list procedure
  Parameters:  INPUT Caller's procedure handle, 
               INPUT optional specific list of attribute values to return,
               OUTPUT attribute list, in the format usable in a call to
                      set-attribute-list
  Notes:       
               get-attribute-list is intended to be called only from the UIB
               or other utility programs. The list of attributes which is
               normally returned includes only those whose values are specified
               in the Instance Attribute Dialog for the object, that is, those
               which determine particular runtime behavior defined at design
               time in the UIB.

               The extra p-attr-names argument allows the caller who
               runs broker-get-attribute-list directly to customize what is
               returned. 
               The value "*" causes all attributes and their
               values to be returned (including HIDDEN, INITIALIZED, etc.etc.).
               A comma-separated list causes exactly that list of attributes
               and their values to be returned. 
               The value "ADM-TRANSLATABLE-FORMAT" causes the standard list
               to be returned, but in the format needed by the UIB in
               generating the attribute argument to RUN init-object in
               adm-create-objects. This format includes quote marks and ":U"
               symbols where appropriate to differentiate translatable from
               non-translatable attributes.
------------------------------------------------------------------------------*/

   DEFINE INPUT  PARAMETER p-caller        AS HANDLE    NO-UNDO.
   DEFINE INPUT  PARAMETER p-attr-names    AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER p-attr-list     AS CHARACTER NO-UNDO.
  
   DEFINE VARIABLE i             AS INTEGER   NO-UNDO.
   DEFINE VARIABLE num-attrs     AS INTEGER   NO-UNDO.
   DEFINE VARIABLE attr-index    AS INTEGER   NO-UNDO.
   DEFINE VARIABLE attr-value    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE attr-name     AS CHARACTER NO-UNDO.
   DEFINE VARIABLE obj-attr-list AS CHARACTER NO-UNDO.
   DEFINE VARIABLE trans-format  AS LOGICAL   NO-UNDO INIT no.
   DEFINE VARIABLE ADM-compat    AS CHARACTER NO-UNDO.

   IF p-attr-names = "ADM-TRANSLATABLE-FORMAT":U THEN
   DO:                          /* set flag to return list with :U's */
       trans-format = yes.
       p-attr-names = "":U.
   END.

   /* Find out if the application has set "compatibility" mode for ADM1.0 */
   RUN get-attribute ('ADM-compat':U).
   ADM-compat = RETURN-VALUE.

   obj-attr-list = {src/adm/method/get-attr.i p-caller ADM-ATTRIBUTE-LIST}.  

   IF p-attr-names = "*":U THEN
   /* Build a list of all attributes out of the basic ones plus any
      user-defined ones in the second part of the list. */
       p-attr-names = adm-basic-attrs + 
           IF NUM-ENTRIES(ENTRY(2, p-caller:{&ADM-DATA}, "^":U)) > 0 THEN
            ",":U + REPLACE(ENTRY(2, p-caller:{&ADM-DATA}, "^":U), 
               "`":U, ",":U) ELSE "":U.
   ELSE IF (p-attr-names = "":U OR p-attr-names = ?) AND
             (ADM-compat NE "ADM1.0") AND    
             obj-attr-list NE ? AND obj-attr-list NE "?":U THEN 
               p-attr-names = obj-attr-list.
   ELSE DO:
       IF (p-attr-names = "":U OR p-attr-names = ? OR
            ADM-compat = "ADM1.0":U) THEN
       DO:
           /* If there's no attribute listing the attributes to return,
              then we build a list of all the object's attributes which
              aren't on the list of ones we never return. This is mostly
              for backward compatibility with user-defined objects in 8.0
              which wouldn't have this list defined in them. This list is
              in the second group of the object's ADM-DATA. */

               p-attr-names = REPLACE(ENTRY(2, p-caller:{&ADM-DATA}, "^":U),
                   "`":U, ",":U).
       END.
   END.

   p-attr-list = IF trans-format THEN "'":U ELSE "":U. /* In quotes if txlatbl*/
   
   num-attrs = NUM-ENTRIES(p-attr-names).

   DO i = 1 TO num-attrs:
  /* If this attribute is one of the basic ones stored at the head of
     the ADM-DATA list, this will get its position in the list. */
       attr-name = ENTRY(i, p-attr-names).
       attr-index = LOOKUP(attr-name, adm-basic-attrs).

       IF attr-index NE 0 THEN     /* This is one of the basic attrs. */
           attr-value = ENTRY(attr-index, p-caller:{&ADM-DATA}, "`":U).
       ELSE DO:
           attr-index = LOOKUP(attr-name, 
             ENTRY(2, p-caller:{&ADM-DATA}, "^":U), "`":U).
           IF attr-index NE 0 THEN
             attr-value = ENTRY(attr-index, 
               ENTRY(3, p-caller:{&ADM-DATA}, "^":U), "`":U).
           ELSE DO:
               RUN VALUE ("get-":U + attr-name) IN p-caller NO-ERROR.
               attr-value = IF ERROR-STATUS:ERROR THEN ? ELSE RETURN-VALUE.
           END.
       END.
       /* If a value has embedded commas, we enclose it in quotes,
          because this is the form that would be needed to
          resend the entire list to set-attribute-list. */
       IF INDEX(attr-value,",":U) NE 0 THEN
           attr-value = '"':U + attr-value + '"':U.

       IF attr-value NE ? THEN   /* Don't put any entry for undefined attrs */
       DO:
         IF trans-format THEN    /* return the special form with :U's */
         DO:
           IF p-attr-list NE "'":U THEN 
               p-attr-list = p-attr-list + ",":U + CHR(10).
           p-attr-list = p-attr-list + attr-name + " = ":U.
           IF LOOKUP(attr-name, adm-translation-attrs) NE 0 THEN
           DO:                      /* Add the translatable value without :U */
             p-attr-list = p-attr-list + "':U + '":U + attr-value + "'":U.
             IF i NE num-attrs THEN
               p-attr-list = p-attr-list + " + '":U.  /* Prepare for the next */
           END.
           ELSE                  /* If not txlatable just keep building */
             p-attr-list = p-attr-list + attr-value.
         END.

         ELSE DO:                /* Here we build the standard list format: */
           IF p-attr-list NE "":U THEN 
             p-attr-list = p-attr-list + ",":U + CHR(10).
           p-attr-list = p-attr-list + attr-name + " = ":U + attr-value.
         END.
       END.
   END.

   /* If this is the last attribute and the user wants the translatable
      format and this last attribute was not translatable, then
      put ':U at the very end */
   IF trans-format AND LOOKUP(attr-name, adm-translation-attrs) = 0 THEN
       p-attr-list = p-attr-list + "':U":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-broker-hide) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE broker-hide Method-Library 
PROCEDURE broker-hide :
/*------------------------------------------------------------------------------
  Purpose:     Guts of adm-hide
  Parameters:  Caller's procedure handle
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-caller AS HANDLE NO-UNDO.
  
  DEFINE VARIABLE object-hdl      AS HANDLE NO-UNDO.
  
  object-hdl = 
    WIDGET-HANDLE({src/adm/method/get-attr.i p-caller ADM-OBJECT-HANDLE}). 
  
  IF VALID-HANDLE(object-hdl) THEN
  &IF "{&WINDOW-SYSTEM}":U = "TTY":U &THEN
      IF object-hdl:TYPE EQ "WINDOW" THEN  /* Can't hide character window */
      &IF "{&FRAME-NAME}":U NE "":U &THEN
        HIDE FRAME {&FRAME-NAME} NO-PAUSE /* So hide the contents instead */
      &ENDIF
      .                                   /* punctuation for THEN or HIDE */
      ELSE
  &ENDIF
        ASSIGN object-hdl:HIDDEN  =   YES.        
 
  {src/adm/method/set-attr.i p-caller HIDDEN 'YES':U}

  IF {src/adm/method/get-attr.i p-caller CONTAINER-TYPE} NE "":U THEN
    /* We don't need to physically hide the SmartObjects in this Container -
       they will disappear when it is hidden - but we need to tell them that
       they are part of a hidden Container so that they can set links
       and other states dependent on HIDDEN accordingly. */
    RUN set-link-attribute 
        (p-caller, 'CONTAINER-TARGET':U, 'CONTAINER-HIDDEN=YES':U).
  
  /* Turn off any activated links. */
  RUN set-active-links (p-caller, no) NO-ERROR.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-broker-initialize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE broker-initialize Method-Library 
PROCEDURE broker-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Guts of adm-initialize
  Parameters:  Caller's procedure handle
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-caller AS HANDLE NO-UNDO.
  
  DEFINE VARIABLE group-source-str AS CHARACTER NO-UNDO.
  DEFINE VARIABLE group-source-hdl AS HANDLE    NO-UNDO.    
  DEFINE VARIABLE hide-on-init     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE disable-on-init  AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE attr-list        AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE page-handle-list AS CHARACTER NO-UNDO.   
  DEFINE VARIABLE page-handle      AS HANDLE    NO-UNDO.   
  DEFINE VARIABLE object-cntr      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE container-type   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE object-type      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE external-tables  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE query-object     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE source-hdl-str   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE parent-hdl-str   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE parent-hdl       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE initial-add      AS LOGICAL   NO-UNDO INIT no.

  IF {src/adm/method/get-attr.i p-caller INITIALIZED} = "YES":U
      THEN RETURN.             /* Just get out if already initialized. */

  {src/adm/method/set-attr.i p-caller INITIALIZED 'YES':U}

  container-type = {src/adm/method/get-attr.i p-caller CONTAINER-TYPE}. 
  IF container-type = "FRAME":U THEN
  DO:
    /* A SmartFrame does not RUN is own create-objects. It's postponed
       until the SmartFrame is actually initialized by its container
       (or by the UIB in design mode). */
    {src/adm/method/dispatch.i p-caller 'create-objects':U}
  END.
  
  RUN broker-get-attribute (p-caller, 'HIDE-ON-INIT':U).
  ASSIGN hide-on-init = RETURN-VALUE.
  RUN broker-get-attribute (p-caller, 'DISABLE-ON-INIT':U).
  ASSIGN disable-on-init = RETURN-VALUE.  
      
    IF container-type NE "":U THEN
    DO:
      /* For containers, we need to propogate the hide-on-init and
         disable-on-init attributes to children before initializing them. */   
      IF hide-on-init = "YES":U OR disable-on-init = "YES":U THEN
      DO:
         /* Tell all the objects on the page to come up hidden,
           so the page doesn't flash on the screen. */
         IF hide-on-init = "YES":U THEN  
            attr-list = "HIDE-ON-INIT=yes":U.
         IF disable-on-init = "YES":U THEN   
            attr-list = attr-list + ",DISABLE-ON-INIT=yes":U.               
         RUN set-link-attribute 
            (p-caller, 'CONTAINER-TARGET':U, attr-list).
         /* For containers, whether DISABLE is explicitly set or not, we
            need to set it for the container itself if HIDE-ON-INIT is true,
            because otherwise the 'enable' below will force the container
            to be viewed if it contains any simple objects. */
         disable-on-init = "YES":U.
      END.    
      /* In any case, initialize descendents first. */
      RUN broker-notify (p-caller, 'initialize':U).  
    END.
    
    object-type = {src/adm/method/get-attr.i p-caller TYPE}. 

    IF disable-on-init NE "YES":U THEN DO:
        {src/adm/method/dispatch.i p-caller 'enable':U}
        IF CAN-DO ("*Viewer*":U, object-type) THEN  
        DO:
          /* Initialize editor widgets properly to be read-only or not. */
          RUN set-editors IN p-caller ("INITIALIZE":U).
          RUN set-editors IN p-caller 
            (IF {src/adm/method/get-attr.i p-caller FIELDS-ENABLED} = "YES":U 
              THEN "ENABLE":U ELSE "DISABLE":U). 
        END.
    END.

    /* Before Viewing, change the object to the correct layout. */
    IF {src/adm/method/get-attr.i p-caller Layout} ne ? 
    THEN RUN broker-dispatch (p-caller, 'apply-layout':U).
    ELSE DO:
      RUN broker-get-attribute (p-caller, 'Default-Layout':U).
      IF RETURN-VALUE ne "":U AND RETURN-VALUE ne ? THEN DO:
        {src/adm/method/set-attr.i p-caller Layout RETURN-VALUE}
        RUN broker-dispatch (p-caller, 'apply-layout':U).
      END.
    END.

    IF hide-on-init NE "YES":U THEN 
        {src/adm/method/dispatch.i p-caller 'view':U}
    
  /* Set the procedure's CURRENT-WINDOW to its parent window container
     (which may be several levels up). This will assure correct parenting
     of alert boxes, etc. */
  parent-hdl-str = {src/adm/method/get-attr.i p-caller ADM-PARENT}.
  parent-hdl = WIDGET-HANDLE(parent-hdl-str).
  IF VALID-HANDLE(parent-hdl) 
        AND NOT CAN-DO ("*Window*":U, object-type) THEN  
  DO:
    DO WHILE VALID-HANDLE(parent-hdl:PARENT) AND parent-hdl:TYPE NE "WINDOW":U:
      parent-hdl = parent-hdl:PARENT.
    END.
    IF VALID-HANDLE(parent-hdl) AND parent-hdl:TYPE = "WINDOW":U THEN
      p-caller:CURRENT-WINDOW = parent-hdl.
  END.

    /* Initialize any OCX's in the SmartObjects. */
    {src/adm/method/dispatch.i p-caller 'create-controls':U}
    RUN control_load IN p-caller NO-ERROR.

    /* For SmartBrowsers which are connected to an Update SmartPanel in
       Update mode (meaning the user has to press the Update button before
       beginning to make changes to the current row), then we want to make
       the Browser initially READ-ONLY. */
    IF CAN-DO ("*Browser*":U, object-type) THEN
    DO:
      RUN request-attribute (p-caller, 'TABLEIO-SOURCE':U,
        'SmartPanelType':U).
      IF RETURN-VALUE BEGINS "UPDATE":U THEN  /* Update or Update-Trans */
        {src/adm/method/dispatch.i p-caller 'disable-fields':U}
    END.

    /* In the case where this object is part of a GROUP ASSIGN object group and
       the main object is already initialized and enabled, enable
       this new object's fields now. Also, if the Main object is in an Add,
       then initiate one here also. */
    RUN get-link-handle 
        (p-caller, 'GROUP-ASSIGN-SOURCE':U, OUTPUT group-source-str)
          NO-ERROR.
    IF NUM-ENTRIES(group-source-str) = 1 THEN 
    DO:
        ASSIGN group-source-hdl = WIDGET-HANDLE(group-source-str).
        IF {src/adm/method/get-attr.i group-source-hdl FIELDS-ENABLED} 
         = "YES":U THEN
            {src/adm/method/dispatch.i p-caller 'enable-fields':U}
        IF {src/adm/method/get-attr.i group-source-hdl ADM-NEW-RECORD} 
          EQ "YES":U THEN 
        DO:
           RUN check-modified IN p-caller ('clear':U). /* Initialize MOD state*/
           initial-add = yes.                          /* Signal code below. */
           {src/adm/method/dispatch.i p-caller 'add-record':U} 
        END.
    END.
    
    /* +++ This logic was changed for 8.1 to understand that a query object
       with no external tables may still have dependencies on another
       object as its record source, using the KEY passing mechanism. */
    /* If a record source link is already defined, then run row-available 
       to see if there is already a record waiting, unless we're already
       in the middle of an Add operation. */
    IF NOT initial-add THEN
    DO:
      RUN get-link-handle (INPUT p-caller,
        INPUT 'RECORD-SOURCE':U, OUTPUT source-hdl-str)
            NO-ERROR. 
      IF source-hdl-str NE "":U THEN
        {src/adm/method/dispatch.i p-caller 'row-available':U}
      ELSE DO:
      /* Otherwise (no record source) if this object has a query to open 
         and no external tables to receive records from, then we want 
         to open its query as part of the startup process. */
        query-object = 
          IF {src/adm/method/get-attr.i p-caller QUERY-OBJECT} = "YES" 
             THEN yes ELSE no. 
        external-tables = {src/adm/method/get-attr.i p-caller EXTERNAL-TABLES}. 
        IF query-object AND (external-tables = "":U) THEN
        DO:
            /* Don't open query in design mode */
            IF NOT {src/adm/method/get-attr.i p-caller UIB-MODE} BEGINS 
             "Design":U THEN
               {src/adm/method/dispatch.i p-caller 'open-query':U}
        END.
      END.
    END.

    /* Set up the SmartObject for viewing in the UIB, if necessary. */
    IF {src/adm/method/get-attr.i p-caller UIB-MODE} ne "":U THEN 
      {src/adm/method/dispatch.i p-caller 'UIB-mode':U}

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-broker-new-state) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE broker-new-state Method-Library 
PROCEDURE broker-new-state :
/* ---------------------------------------------------------
      Purpose: Allows a procedure to send a state change message to another.
      Parameters: INPUT source procedure handle, new state name
      Notes:   If the state name is found in a lookup-list, then
               it is sent to the matching link type(s).
               If one or more link types are included following the
               state name (separated by commas), the state message
               will be sent there.
               Otherwise the state message is sent to STATE-TARGETs.
               If "SELF" is the first or only thing in the link list,
               the message will be sent to this procedure also.
   -----------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-source-hdl   AS HANDLE    NO-UNDO.  
    DEFINE INPUT PARAMETER p-state        AS CHARACTER NO-UNDO.  

    DEFINE VARIABLE state-entry  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE state-links  AS CHARACTER NO-UNDO INIT ?.
    DEFINE VARIABLE i            AS INTEGER   NO-UNDO.
    DEFINE VARIABLE one-link     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE base-link    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE send-to-self AS LOGICAL   NO-UNDO INIT no.
    
    DEFINE BUFFER adm-link-buffer FOR adm-link-table.

    IF VALID-HANDLE(adm-watchdog-hdl) THEN
      RUN receive-message IN adm-watchdog-hdl 
       (INPUT p-source-hdl,  INPUT "":U, 
           INPUT "new-state: ":U + p-state) NO-ERROR.

    IF NUM-ENTRIES(p-state) = 1 THEN      /* user has not passed link names */
    DO:
        state-entry = LOOKUP(p-state, adm-state-names). 
        IF state-entry NE 0 THEN 
            state-links = TRIM(ENTRY(state-entry, adm-state-links, ";":U)).
    END.
    ELSE 
    DO:
        state-links = TRIM(SUBSTR(p-state, INDEX(p-state,",":U) + 1, -1,
            "CHARACTER":U)).
        p-state = TRIM(ENTRY(1,p-state)).
        IF TRIM(ENTRY(1, state-links)) = "SELF":U THEN 
        DO:
            send-to-self = yes.
            IF NUM-ENTRIES(state-links) = 1 THEN  /* Self was the only thing */
            DO:         
                state-entry = LOOKUP(p-state, adm-state-names). 
                IF state-entry NE 0 THEN 
                    state-links = 
                        TRIM(ENTRY(state-entry, adm-state-links, ";":U)).
                ELSE state-links = ?.
            END.
            ELSE                /* remove SELF from the list */
                state-links = 
                    TRIM(SUBSTR(state-links, INDEX(state-links,",":U) + 1,
                        -1, "CHARACTER":U)).
        END.
                          
    END.

    IF state-links NE ? THEN    /* we have specific links to pass to */
    DO:
        IF state-links = "*":U THEN       /* send the message to all links */
            FOR EACH adm-link-buffer WHERE 
              adm-link-buffer.link-source = p-source-hdl AND
                adm-link-buffer.link-active:
                  RUN state-changed IN adm-link-buffer.link-target
                    (INPUT p-source-hdl, INPUT p-state) NO-ERROR.
            END.
        ELSE
        DO i = 1 TO NUM-ENTRIES(state-links):
            one-link = TRIM(ENTRY(i, state-links)).
            IF one-link = "SELF":U THEN       /* SELF can also be in the */
                send-to-self = yes.           /* default links list */
            ELSE
            DO:
                base-link = 
                    TRIM(SUBSTR(one-link, 1, R-INDEX(one-link, "-":U) - 1,
                        "CHARACTER":U)).
                IF INDEX(one-link, "-TARGET":U) NE 0 THEN
                   FOR EACH adm-link-buffer WHERE 
                     adm-link-buffer.link-type = base-link
                       AND adm-link-buffer.link-source = p-source-hdl
                         AND adm-link-buffer.link-active:
                           RUN state-changed IN adm-link-buffer.link-target
                             (INPUT p-source-hdl, INPUT p-state) NO-ERROR.
                   END.
                ELSE
                   FOR EACH adm-link-buffer WHERE 
                     adm-link-buffer.link-type = base-link
                       AND adm-link-buffer.link-target = p-source-hdl
                         AND adm-link-buffer.link-active:
                           RUN state-changed IN adm-link-buffer.link-source
                            (INPUT p-source-hdl, INPUT p-state) NO-ERROR.
                   END.
            END.
        END.
    END.
    /* Unless we already sent the message to everybody, send it to
       any STATE-TARGETs even if it also went to some other link type. */
    IF state-links NE "*":U THEN
      FOR EACH adm-link-buffer WHERE adm-link-buffer.link-type = "STATE":U 
        AND adm-link-buffer.link-source = p-source-hdl AND link-active:
          RUN state-changed IN adm-link-buffer.link-target
            (INPUT p-source-hdl, INPUT p-state) NO-ERROR.
    END.                                    

    IF send-to-self THEN RUN state-changed IN p-source-hdl
        (INPUT p-source-hdl, INPUT p-state) NO-ERROR.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-broker-notify) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE broker-notify Method-Library 
PROCEDURE broker-notify :
/* -----------------------------------------------------------
      Purpose:    Sends an event in the form of a method invocation
                  to all objects of a particular link type.
      Parameters: INPUT source procedure handle (used as starting point),
                  INPUT method name. 

      Notes:      If the method name is a comma-separated list then 
                  the first entry is the method-name
                  and the remaining entries are link types to which
                  it should be sent; "*":U indicates all TARGET links.
    -------------------------------------------------------------*/   

    DEFINE INPUT PARAMETER p-source-hdl     AS HANDLE    NO-UNDO.
    DEFINE INPUT PARAMETER p-method-name    AS CHARACTER NO-UNDO.

    DEFINE VARIABLE method-index AS INTEGER NO-UNDO.
    DEFINE VARIABLE method-link  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE base-link    AS CHARACTER NO-UNDO.

    DEFINE BUFFER   adm-link-buffer FOR adm-link-table.

    IF VALID-HANDLE(adm-watchdog-hdl) THEN
      RUN receive-message IN adm-watchdog-hdl 
       (INPUT p-source-hdl,  INPUT "":U, 
             INPUT "notify: ":U + p-method-name) NO-ERROR.
    IF NUM-ENTRIES(p-method-name) > 1 THEN 
    DO:
        /* "*" goes to all TARGETs*/
        IF TRIM(ENTRY(2, p-method-name)) = "*":U THEN 
        FOR EACH adm-link-buffer WHERE 
            adm-link-buffer.link-source = p-source-hdl
                   AND link-active:
            {src/adm/method/dispatch.i adm-link-buffer.link-target
                ENTRY(1,p-method-name)}
            IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.
        END.
        ELSE                      /* Send to all links in parameter list */
        DO method-index = 2 TO NUM-ENTRIES(p-method-name):
            method-link = TRIM(ENTRY(method-index, p-method-name)).
            base-link = SUBSTR(method-link, 1, R-INDEX(method-link, "-":U) - 1,
                "CHARACTER":U).
            IF INDEX(method-link, "-TARGET":U) NE 0 THEN
                FOR EACH adm-link-buffer WHERE adm-link-buffer.link-type =
                  base-link AND adm-link-buffer.link-source = p-source-hdl
                    AND link-active:
                      {src/adm/method/dispatch.i adm-link-buffer.link-target
                          ENTRY(1,p-method-name)}
                      IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.
                END.
            ELSE
                FOR EACH adm-link-buffer WHERE adm-link-buffer.link-type =
                  base-link AND adm-link-buffer.link-target = p-source-hdl
                    AND link-active:
                      {src/adm/method/dispatch.i adm-link-buffer.link-source
                        ENTRY(1,p-method-name)}
                      IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.
                END.
        END.
    END.
    ELSE
    DO:                           /* Send to the link in the default list */
        method-index = LOOKUP(p-method-name, adm-notify-methods).
        IF method-index NE 0 THEN  
        DO:
            method-link = ENTRY(method-index, adm-notify-links).
            base-link = SUBSTR(method-link, 1, R-INDEX(method-link, "-":U) - 1,
                "CHARACTER":U).
            IF INDEX(method-link, "-SOURCE":U) NE 0 THEN
            DO: /* Unique FIND req'd to prevent possible nested FOR EACHs */
                FIND adm-link-buffer WHERE 
                  adm-link-buffer.link-type = base-link AND 
                    adm-link-buffer.link-target = p-source-hdl AND
                      link-active NO-ERROR.
                IF NOT AVAILABLE adm-link-buffer THEN 
                    RETURN.                     /* Note: No error */
                {src/adm/method/dispatch.i adm-link-buffer.link-source
                   p-method-name}
                IF RETURN-VALUE = "ADM-ERROR":U THEN 
                    RETURN "ADM-ERROR":U.
            END.
            ELSE 
            FOR EACH adm-link-buffer WHERE 
              adm-link-buffer.link-type = base-link AND 
                adm-link-buffer.link-source = p-source-hdl AND
                  link-active: 
                    {src/adm/method/dispatch.i adm-link-buffer.link-target
                      p-method-name}
                    IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.
            END.
        END.
        ELSE 
        DO:
            MESSAGE "Method name ":U p-method-name "not found in 'notify'":U
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR":U.
        END.
    END.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-broker-set-attribute-list) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE broker-set-attribute-list Method-Library 
PROCEDURE broker-set-attribute-list :
/*------------------------------------------------------------------------------
  Purpose:     Guts of set-attribute-list procedure
  Parameters:  Caller's procedure handle, attribute list
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-caller    AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-attr-list AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cntr             AS INTEGER   NO-UNDO.
  DEFINE VARIABLE quote-end        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE num-attrs        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE num-values       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE attr-index       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE attr-name        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE attr-value       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE attr-entry       AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE folder-attrs-set AS LOGICAL   NO-UNDO INIT no.
  DEFINE VARIABLE parent-hdl       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE object-hdl       AS HANDLE    NO-UNDO.  
  DEFINE VARIABLE value-str        AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE name-str         AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE entry-str        AS CHARACTER NO-UNDO.
  
  IF VALID-HANDLE(adm-watchdog-hdl) THEN
  DO:
    RUN receive-message IN adm-watchdog-hdl 
       (INPUT p-caller, INPUT "":U,
            INPUT "set-attribute-list: ":U + p-attr-list) NO-ERROR.
  END.

  IF p-attr-list = "":U OR p-attr-list = ? THEN RETURN. /* skip empty list */

  /* If the attribute list has not yet been initialized (because we're being
     called from above where smart.i is included, then initialize it. */
  IF p-caller:{&ADM-DATA} = "":U OR p-caller:{&ADM-DATA} = ? THEN
      p-caller:{&ADM-DATA} = "~^~^":U.

  /* In an entry whose value is a double-quoted (") comma-separated list,
     replace the commas with vertical bars to facilitate parsing.
     These will be reset to commas by get-attribute. */
  cntr = INDEX(p-attr-list, '"':U). 
  DO WHILE cntr NE 0:
      quote-end = INDEX(p-attr-list, '"':U, cntr + 1).
      IF quote-end = 0 THEN 
      DO:
          MESSAGE "Unmatched quote mark found in set-attribute-list: ":U SKIP
                   p-attr-list VIEW-AS ALERT-BOX ERROR.
          RETURN.
      END.
      /* Remove extraneous final comma if present. */
      IF SUBSTR(p-attr-list,quote-end - 1,1, "CHARACTER":U) = ",":U
          THEN SUBSTR(p-attr-list,quote-end - 1,1, "CHARACTER":U) = "":U.

      SUBSTR(p-attr-list,cntr,quote-end - cntr, "CHARACTER":U) = 
          REPLACE(SUBSTR(p-attr-list,cntr,quote-end - cntr, "CHARACTER":U),
            ",":U,"|":U).
      cntr = INDEX(p-attr-list, '"':U, quote-end + 1). 
  END.

  num-attrs = NUM-ENTRIES(p-attr-list).
  DO cntr = 1 TO num-attrs:
      attr-entry = ENTRY(cntr, p-attr-list).
      IF INDEX(attr-entry,"=":U) = 0
      THEN DO:
          MESSAGE "Invalid element in set-attribute call:":U SKIP
                attr-entry SKIP "in":U p-caller:FILE-NAME 
                    VIEW-AS ALERT-BOX WARNING.
          NEXT.
      END.
      attr-name = TRIM(SUBSTR(attr-entry, 1, INDEX(attr-entry, "=":U) - 1,
          "CHARACTER":U)).
      attr-value = TRIM(SUBSTR(attr-entry, INDEX(attr-entry, "=":U) + 1, -1,
          "CHARACTER":U)).
      /* If attribute value had embedded commas, restore them & remove quotes.*/
      IF SUBSTR(attr-value, 1, 1, "CHARACTER":U) = '"':U THEN
          attr-value = SUBSTR(REPLACE(attr-value,"|":U,",":U), 2, 
              LENGTH(attr-value, "CHARACTER":U) - 2, "CHARACTER":U).
      CASE attr-name:
 
      {src/adm/method/smartset.i}  /* User-defined CASEs */
     
      WHEN "ADM-PARENT":U THEN DO:
          object-hdl = WIDGET-HANDLE
              ({src/adm/method/get-attr.i p-caller ADM-OBJECT-HANDLE}). 
          IF VALID-HANDLE(object-hdl) THEN DO:
              ASSIGN parent-hdl = WIDGET-HANDLE(attr-value).
              IF CAN-DO( "DIALOG-BOX,FRAME":U, parent-hdl:TYPE) THEN
                  ASSIGN object-hdl:FRAME = parent-hdl.
              ELSE
                  ASSIGN object-hdl:PARENT = parent-hdl.
          END.
      END.
      WHEN "CONTAINER-HIDDEN":U THEN DO:
          /* When a Container is hidden we don't set HIDDEN in its contents,
             but we do tell them about it and set their links appropriately
             (turn them off ("no") if object *is* being hidden). */
          RUN set-active-links (p-caller,
              IF attr-value = "YES":U THEN no ELSE yes) NO-ERROR.
      END.
               
      END CASE.

      /* If this attribute is one of the basic ones stored at the head of
         the ADM-DATA list, this will get its position in the list. */
      attr-index = LOOKUP(attr-name, adm-basic-attrs).

      IF attr-index NE 0 THEN     /* This is one of the basic attrs. */
      DO: 
          adm-tmp-str = p-caller:{&ADM-DATA}. 
          ENTRY(attr-index, adm-tmp-str, "`":U) = attr-value.
          p-caller:{&ADM-DATA} = adm-tmp-str.  
      END. 
      ELSE DO:
          attr-index = LOOKUP(attr-name, 
              ENTRY(2, p-caller:{&ADM-DATA}, "^":U), "`":U).
          IF attr-index NE 0 THEN      /* Attribute was already defined: */
          DO: 
            adm-tmp-str = p-caller:{&ADM-DATA}. 
            value-str =  ENTRY(3, adm-tmp-str, "^":U).
            ENTRY(attr-index, 
              value-str, "`":U) = attr-value. 
            ENTRY(3, adm-tmp-str, "^":U) = value-str.
            p-caller:{&ADM-DATA} = adm-tmp-str.  
          END. 
          ELSE DO:                     /* Attribute was not yet defined: */
            /* If there is special code to set the attribute value,
               run that rather than putting the value into the list. */
            RUN VALUE ("set-":U + attr-name) IN p-caller (attr-value) NO-ERROR.
            IF NOT ERROR-STATUS:ERROR THEN NEXT.
            /* If the procedure wasn't just not found, give a message 
               if they forgot to declare the parameter.*/
            ELSE IF ERROR-STATUS:GET-NUMBER(1) EQ 1005 THEN  
              MESSAGE "Custom attribute procedure set-":U + attr-name
                      "failed because its input parameter":U
                      "was not declared properly.":U VIEW-AS ALERT-BOX.
            ELSE DO:
              /* Otherwise create the attribute by appending its name
                 to the second group in the overall list and its value
                 to the third. */
              name-str = ENTRY(2, p-caller:{&ADM-DATA}, "^":U).
              value-str = ENTRY(3, p-caller:{&ADM-DATA}, "^":U).
              num-values = NUM-ENTRIES(name-str).
              name-str = name-str +
                (IF num-values = 0 THEN "":U ELSE "~`":U) + attr-name.
              value-str = value-str + 
                (IF num-values = 0 THEN "":U ELSE "~`":U) + attr-value.   
              p-caller:{&ADM-DATA} = ENTRY(1, p-caller:{&ADM-DATA}, "^":U)
                 + "^":U + name-str + "^":U + value-str.
            END.  
          END.
      END.  

      /* If there's a special procedure to perform some action whenever the
         attribute's value is set, with the name "set-<sttr-name>", then
         execute it here. */

      RUN VALUE("use-":U + attr-name) IN p-caller (attr-value) NO-ERROR.
      /* If the procedure wasn't just not found, give a message 
         if they forgot to declare the parameter.*/
      IF ERROR-STATUS:ERROR AND ERROR-STATUS:GET-NUMBER(1) EQ 1005 THEN  
              MESSAGE "Custom attribute procedure use-":U + attr-name
                      "failed because its input parameter":U
                      "was not declared properly.":U VIEW-AS ALERT-BOX.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-broker-UIB-mode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE broker-UIB-mode Method-Library 
PROCEDURE broker-UIB-mode :
/*------------------------------------------------------------------------------
  Purpose:     Guts of the adm-UIB-mode procedure.
  Parameters:  Caller's procedure handle.
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-caller AS HANDLE NO-UNDO.
  
  DEFINE VARIABLE uib-mode       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE source-hdl-str AS CHARACTER NO-UNDO.
  DEFINE VARIABLE source-hdl     AS HANDLE    NO-UNDO.

    ASSIGN uib-mode = {src/adm/method/get-attr.i p-caller UIB-MODE}. 
    IF uib-mode = "Design":U THEN 
    DO:
        RUN adeuib/_uibmode.p (INPUT p-caller).
        RUN broker-notify (p-caller, 'UIB-mode, CONTAINER-TARGET':U).
    END.
    ELSE IF uib-mode EQ ? THEN    /* Check if parent is in design mode. */
    DO:
        RUN request-attribute 
            (p-caller, 'CONTAINER-SOURCE':U, 'UIB-MODE':U).
        IF RETURN-VALUE BEGINS "Design":U THEN
            {src/adm/method/set-attr.i p-caller UIB-MODE 'Design-Child':U}
    END.
     
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-broker-view) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE broker-view Method-Library 
PROCEDURE broker-view :
/*------------------------------------------------------------------------------
  Purpose:     Guts of the adm-view procedure 
  Parameters:  Caller's procedure handle
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-caller AS HANDLE NO-UNDO.
 
  DEFINE VARIABLE object-hdl       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE frame-hdl        AS HANDLE    NO-UNDO.
    
  IF {src/adm/method/get-attr.i p-caller CONTAINER-TYPE} NE "":U THEN
    /* We don't need to physically view the SmartObjects in this Container -
       they will reappear when it is viewed - but we need to tell them that
       they are part of a viewed Container so that they can set links
       and other states dependent on HIDDEN accordingly. */
    RUN set-link-attribute 
        (p-caller, 'CONTAINER-TARGET':U, 'CONTAINER-HIDDEN=NO':U).
    
  object-hdl = 
    WIDGET-HANDLE({src/adm/method/get-attr.i p-caller ADM-OBJECT-HANDLE}). 
  IF VALID-HANDLE(object-hdl) THEN
  &IF "{&WINDOW-SYSTEM}":U = "TTY":U &THEN
      IF object-hdl:TYPE EQ "WINDOW" THEN
      DO:                                      /* Can't view character window */
          frame-hdl = object-hdl:FIRST-CHILD.
          IF VALID-HANDLE(frame-hdl) THEN
            VIEW frame-hdl.                    /* So view the contents instead*/
      END. 
       ELSE
  &ENDIF
          object-hdl:HIDDEN = NO.      /* View yourself last. */
    
    /* Turn on any deactivated links. */
    RUN set-active-links (p-caller, yes) NO-ERROR.
    {src/adm/method/set-attr.i p-caller HIDDEN 'NO':U}
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


