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
    Library     : keyproc.i
    Purpose     : Standard procedures related to the "Foreign-Keys" XFTR
                  section.

    Syntax      : {src/adm/support/keyproc.i}

    Description : 

    Author(s)   : Wm. T. Wood
    Created     : June 14, 1996
    Notes       : This is used by the KEYEDIT.W (edit XFTR for Foreign Keys)
                  as well as the SmartViewer, SmartBrowser, and SmartQuery
                  wizards.
                  
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
         HEIGHT             = 2
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-build-xftr-section) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE build-xftr-section Method-Library 
PROCEDURE build-xftr-section :
/*------------------------------------------------------------------------------
  Purpose:     Build the XFTR section for the Foreign-Keys XFTR.  This creates
               the structured data as well as attributes for the keys-supplied
               and keys accepted.
  Input Parameters:  
    p_foreign-keys (CHAR) the FOREIGN-KEYS tagged data
    p_key-object   (CHAR) the KEY-OBJECT tagged data
  Output Parameters:
    p_code         (CHAR) the XFTR code block
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_foreign-keys AS CHAR NO-UNDO.
  DEFINE INPUT  PARAMETER p_key-object   AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER p_code         AS CHAR NO-UNDO.
  
  DEFINE VAR ch       AS CHAR NO-UNDO.
  DEFINE VAR cnt      AS INTEGER NO-UNDO.
  DEFINE VAR cline    AS CHAR NO-UNDO.
  DEFINE VAR cname    AS CHAR NO-UNDO.
  DEFINE VAR i        AS INTEGER NO-UNDO.
  DEFINE VAR keys-acc AS CHAR NO-UNDO. /* Keys-Accepted attribute. */
  DEFINE VAR keys-sup AS CHAR NO-UNDO. /* Keys-Supplied attribute. */
  
  /* Loop through the FOREIGN-KEYS and create the Keys-Accepted and Keys-Supplied
     lists. */
  ASSIGN p_foreign-keys = TRIM(p_foreign-keys) 
         cnt            = NUM-ENTRIES(p_foreign-keys, CHR(10)).
  DO i = 1 TO cnt:
    ASSIGN cline = ENTRY(i, p_foreign-keys, CHR(10))
           cname = ENTRY (1, cline, "|":U).
    IF ENTRY(2, cline, "|":U) eq "y":U 
    THEN keys-acc = (IF keys-acc eq "":U THEN "":U ELSE keys-acc + ",":U)
                   + cname.
    IF ENTRY(3, cline, "|":U) eq "y":U 
    THEN keys-sup = (IF keys-sup eq "":U THEN "":U ELSE keys-sup + ",":U)
                   + cname.                   
  END. /* DO i... */
  
  /* Keys-Accepted and Keys-Supplied are quoted lists. */
  IF keys-acc ne "" THEN keys-acc = '"':U + keys-acc + '"':U.
  IF keys-sup ne "" THEN keys-sup = '"':U + keys-sup + '"':U.
  /* Create a block of running code which will be inserted into the tagged
     data. 
     NOTE: Structured data is COMMENTED.  So we need to "un-comment" this
     block. */
  ch = "**************************":U + CHR(10)
     + "* Set attributes related to FOREIGN KEYS" + CHR(10) 
     + "*/" + CHR(10)
     + "RUN set-attribute-list (" + CHR(10)  
     + "    'Keys-Accepted = " + keys-acc + ",":U + CHR(10) 
     + "     Keys-Supplied = " + keys-sup + "':U).":U + CHR(10) 
     + (IF CAN-DO ("&BROWSE-NAME,&QUERY-NAME":U, p_key-object)
        THEN (CHR(10)
             +  "/* Tell the ADM to use the OPEN-QUERY-CASES. */" + CHR(10) 
             +  "~&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U)." 
             +  CHR(10))
        ELSE "":U)
     + "/**************************":U. 
     
  /* Store the tagged data. */
  RUN adm/support/_tagdat.p ("SET":U, "EXECUTING-CODE":U, 
                             INPUT-OUTPUT ch, INPUT-OUTPUT p_code).
  RUN adm/support/_tagdat.p ("SET":U, "FOREIGN-KEYS":U, 
                             INPUT-OUTPUT p_foreign-keys, INPUT-OUTPUT p_code).
  RUN adm/support/_tagdat.p ("SET":U, "KEY-OBJECT":U, 
                             INPUT-OUTPUT p_key-object, INPUT-OUTPUT p_code).
 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-check-procedures) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check-procedures Method-Library 
PROCEDURE check-procedures :
/*------------------------------------------------------------------------------
  Purpose:     Make sure the target procedure has the "correct" 
               internal procedures. 
  Input Parameters:  
    p_proc-id    (INTEGER) The context ID of this procedure.
    p_key-object (CHAR) The type of this object.
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER p_proc-id    AS INTEGER NO-UNDO.
  DEF INPUT PARAMETER p_key-object AS CHAR    NO-UNDO.
 
  /* Make sure there are send-key and adm-find-using-key functions. */
  DEF VAR trg-id AS INTEGER NO-UNDO.
  DEF VAR ch AS CHAR NO-UNDO.
 
  /* Make sure there are the correct procedures. */
  CASE p_key-object:
    WHEN "THIS-PROCEDURE" THEN DO:
      trg-id = ?.
      RUN adeuib/_accsect.p ("GET", p_proc-id, "PROCEDURE:adm-find-using-key",
                             INPUT-OUTPUT trg-id, INPUT-OUTPUT ch).
      IF trg-id eq ? THEN
      RUN adeuib/_accsect.p ("SET", p_proc-id, "PROCEDURE:adm-find-using-key:adm/support/_key-fnd.p",
                             INPUT-OUTPUT trg-id, INPUT-OUTPUT ch).
    END.
    /* QUERY-OBJECTS should have an adm-open-query-cases procedure. */
    WHEN "&QUERY-NAME":U OR WHEN "&BROWSE-NAME":U THEN DO:
      trg-id = ?.
      RUN adeuib/_accsect.p ("GET", p_proc-id, "PROCEDURE:adm-open-query-cases",
                             INPUT-OUTPUT trg-id, INPUT-OUTPUT ch).
      IF trg-id eq ? THEN
      RUN adeuib/_accsect.p ("SET", p_proc-id, "PROCEDURE:adm-open-query-cases:adm/support/_adm-opn.p",
                             INPUT-OUTPUT trg-id, INPUT-OUTPUT ch).
    END.
  END CASE.
  /* Always create a send-key method. */
  trg-id = ?.
  RUN adeuib/_accsect.p ("GET", p_proc-id, "PROCEDURE:send-key",
                         INPUT-OUTPUT trg-id, INPUT-OUTPUT ch).
  IF trg-id eq ? THEN
  RUN adeuib/_accsect.p ("SET", p_proc-id, "PROCEDURE:send-key:adm/support/_key-snd.p",
                         INPUT-OUTPUT trg-id, INPUT-OUTPUT ch).
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

