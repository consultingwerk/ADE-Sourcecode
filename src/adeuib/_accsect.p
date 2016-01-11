&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-----------------------------------------------------------------------------

  File: _accsect.p

  Description: 
      Code to allow developers to access sections (read and write) in the UIB.

  Input Parameters:
     pc_mode    - Mode of operation
                   "GET" - returns the value of the section (or unknown).
                   "SET" - changes the value of the section
                   "DELETE" - Deletes the current section.
     pi_context - The integer context (i.e. recid) of the object to access. 
                  [If UNKNOWN then the UIB assumes the current window or
                  procedure].
     pc_section - the name of the code section to access.  This name
                  will have multiple parts in the case of XFTRs, TRIGGER's 
                  and PROCEDURE's
                  Valid section names are:
                      DEFINITIONS
                      MAIN-CODE-BLOCK
                      TRIGGER:<event-name>            eg TRIGGER:CHOOSE
                      PROCEDURE:<name>:               eg PROCEDURE:enable_UI
                      FUNCTION:<name>:                eg FUNCTION:Test
                      PROCEDURE:<name>:<handler> 
                      XFTR:<xftr-name>:<section-name>
                 
                 NOTE: PROCEDURE sections can take an optional handler. If
                 this is given, then the PROCEDURE section will be marked
                 as READ-ONLY. Whenever the UIB needs to find the contents
                 of this section (e.g. to write the file, or view the 
                 section in the Section Editor), then this file will be run
                 to populate the section, as in:
                    RUN VALUE(<handler>) (INPUT <Context ID of .w file>,
                                          OUTPUT <code AS CHAR>).
                                              
                 NOTE: When you have a TRIGGER, then pi_context will refer to
                 a widget.  In all other cases, pi_context will point to the
                 procedure (In some cases, the context of the main window 
                 or dialog-box in a procedure MAY be the same as the context 
                 ID for the  procedure itself, but do not rely on this). 
                    
                 NOTE: if pi_Srecid is NOT UNKNOWN (ne ?), the the
                 pi_context and pc_section are ignored
                 
                 NOTE: A value of pi_Srecid ? 0 is treated the same as
                 pi_Srecid eq ?. [Forgetting to initialize pi_Srecid is a
                 common user error, so we handle it explicitly.]

  Input-Output Parameters:
      pi_Srecid  - The "recid" of the current section.  If the INPUT value
                   is NOT UNKNOWN, then the pi_context and pc_section are
                   ignored.
      pc_Code    - Contents of the trigger/code section (Ignored if trying
                   to SET a PROCEDURE with a <handler>.

  NOTES:  You cannot actually DELETE either the MAIN-CODE-BLOCK or the
          DEFINITIONS sections.  DELETE will empty the section ( but it
          will not actually delete it).
          
          The procedure returns "Error" if pi_context is not specified and
          there is NO current procedure or window.
  
  Sample: Suppose you wanted to reset the main-code-block to an include file
          /* Get the current value */
          RUN adeuib/_accsect.p ("GET", ?, "MAIN-CODE-BLOCK",
                                 INPUT-OUTPUT Srecid
                                 INPUT-OUTPUT code).
          IF code ne "{include.i}" THEN DO:
            code = "{include.i}".
            RUN adeuib/_accsect.p ("SET", ?, ?,
                                    INPUT-OUTPUT Srecid,
                                    INPUT-OUTPUT code). 
          END.
                 
  Author: Wm. T. Wood
  
  Created: February 1995
  
  Modified:
    GFS on 3/3/95   - Added delete for xftr pointed to by _trg.
    WTW on 4/26/96  - Add support for PROCEDURE:<name>:<handler>
    WTW on 5/6/96   - Support passing in of the _P context instead of _U for
                      non-trigger sections.
    WTW on 5/19/96  - When pi_Srecid = 0, treat it as UNKNOWN.
    GFS on 7/26/96  - Call adeshar/_coddlft.p for GET of a UIB gen'd proc.
    GFS on 7/21/98  - Added support for FUNCTIONs 
    
-----------------------------------------------------------------------------*/

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
         HEIGHT             = 7.33
         WIDTH              = 49.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* Define Parameters. */
DEFINE INPUT        PARAMETER  pc_mode      AS CHAR    NO-UNDO.
DEFINE INPUT        PARAMETER  pi_context   AS INTEGER NO-UNDO.
DEFINE INPUT        PARAMETER  pc_section   AS CHAR    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER  pi_Srecid    AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER  pc_Code      AS CHAR    NO-UNDO.
  
/* Include Files */
{adecomm/adefext.i}
{adeuib/uniwidg.i}             /* Definition of Universal Widget TEMP-TABLE  */
{adeuib/triggers.i}            /* Definition of Triggers TEMP-TABLE          */
{adeuib/sharvars.i}            /* Shared UIB variables                       */
{adeuib/xftr.i}                /* XFTR temp-table def                        */

/* Preprocessor variables */
&SCOPED-DEFINE C 'CHARACTER':U

/* Local Variables */
DEFINE VAR hSecEd    AS WIDGET-HANDLE NO-UNDO.
DEFINE VAR i         AS INTEGER NO-UNDO.
DEFINE VAR ipos      AS INTEGER NO-UNDO.
DEFINE VAR section   AS CHAR EXTENT 3 NO-UNDO.
DEFINE VAR procRecid AS RECID NO-UNDO.
DEFINE VAR tSection  LIKE _TRG._tSection NO-UNDO.
DEFINE VAR tEvent    LIKE _TRG._tEvent NO-UNDO.
DEFINE VAR tSpecial  LIKE _TRG._tSpecial NO-UNDO.

DEFINE BUFFER xTRG FOR _TRG.

/* ***************************  Main Block  *************************** */

/* Make sure mode is valid */
IF NOT CAN-DO("DELETE,GET,SET":U, pc_mode) THEN DO:
  MESSAGE "{&UIB_SHORT_NAME} API Error [in call to 'adeuib/_accsect.p']:" SKIP 
          "Invalid mode :" pc_mode SKIP (1)
          "Valid modes are DELETE, GET, or SET."         
          VIEW-AS ALERT-BOX ERROR.
  RETURN "Error". 
END.   

/* Get the desired trigger record.  Go directly to the section if the 
   section ID is given, and the pc_section is not specified. [NOTE:
   handle the most common error, where the user forgets to initialize the
   pi_Srecid to ?, and leaves it as 0 (the default value for an integer).] */
IF pi_Srecid NE ? AND pi_Srecid NE 0
THEN DO:
  FIND _TRG WHERE INT(RECID(_TRG)) eq pi_Srecid NO-ERROR. 
  IF NOT AVAILABLE _TRG THEN DO:
    MESSAGE "{&UIB_SHORT_NAME} API Error [in call to 'adeuib/_accsect.p']:" SKIP 
            "No Section exists with ID:" pi_Srecid
            VIEW-AS ALERT-BOX ERROR.
    /* Recid is bad, and there is no pc_section to parse. */
    RETURN "Error".  
  END.     
  ASSIGN tSection = _TRG._tSECTION.
END.
ELSE DO:
  /* Parse the Section if we don't have a valid section. */
  /* There can only be three sections.  The last section may therefore
     contain colons. (It could be "PROCEDURE:my-stuff:C:/MYFILE.P".). */
  ASSIGN i = 1
         section[1] = TRIM(pc_section).
  DO WHILE LENGTH(section[i],{&C}) > 0 AND i < 3: 
    ipos = INDEX (section[i], ":":U).
    IF ipos > 0 THEN DO:    
      ASSIGN section[i + 1] = TRIM(SUBSTRING(section[i], ipos + 1, -1, {&C})) 
             section[i] = TRIM(SUBSTRING(section[i], 1, ipos - 1, {&C})).     
    END.     
    i = i + 1.
  END.

  /* Convert the input sections into our internal structure */
  CASE section[1]: 
    WHEN "DEFINITIONS" THEN 
      ASSIGN tSection = "_CUSTOM"
             tEvent   = "_DEFINITIONS"
             .
    WHEN "MAIN-CODE-BLOCK" THEN 
      ASSIGN tSection = "_CUSTOM"
             tEvent   = "_MAIN-BLOCK"
             .  
    WHEN "PROCEDURE" THEN 
      ASSIGN tSection = "_PROCEDURE"
             tEvent   = section[2]
             tSpecial = IF section[3] ne "" THEN section[3] ELSE ?
             .  
   WHEN "FUNCTION" THEN 
      ASSIGN tSection = "_FUNCTION"
             tEvent   = section[2]
             tSpecial = IF section[3] ne "" THEN section[3] ELSE ?
             .  
    WHEN "TRIGGER" THEN 
      ASSIGN tSection = "_CONTROL"
             tEvent   = section[2]
             .  
    WHEN "XFTR" THEN DO:
      ASSIGN tSection = "_XFTR"
             tEvent   = section[3]
             .   
    END. /* XFTR */
    OTHERWISE DO:
      MESSAGE "{&UIB_SHORT_NAME} API Error [in call to 'adeuib/_accsect.p']:" SKIP
              "Invalid Section:" pc_Section
              VIEW-AS ALERT-BOX ERROR.
       RETURN "Error". 
    END.
  END CASE.  
  
  /* Now find the trigger.  Note that the ID of the widget depends on 
     the section.  All sections bind to the WINDOW (i.e. _h_win), except 
     triggers. This is for historical reasons. Before v8.0a, there was no
     procedure (_P) recid. If the user passes in a pi_context of a Procedure
     then map this to the Window. */
  IF tSection ne "_CONTROL" THEN DO:
    /* Get the current Window, if none provided. */
    IF pi_context eq ? THEN DO:
      IF NOT VALID-HANDLE(_h_win) THEN DO:
        MESSAGE "{&UIB_SHORT_NAME} API Error [in call to 'adeuib/_accsect.p']:" SKIP
                "There is no current window or procedure selected."
                 VIEW-AS ALERT-BOX ERROR.
        RETURN "Error". 
      END.
      FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.
      pi_context = _P._u-recid.
    END.  
    ELSE DO:
      /* If the user passed in a Procedure recid, then map this to
         the _U record. */
      FIND _P WHERE RECID(_P) eq pi_context NO-ERROR.
      IF AVAILABLE _P THEN pi_context = _P._u-recid.
    END.
  END. /* IF...not...TRIGGER */

  /* Get the trigger */  
  IF tSection NE "_XFTR" THEN DO:
    FIND _TRG WHERE _TRG._tSECTION eq tSection
                AND _TRG._wRECID   eq pi_context
                AND _TRG._tEVENT   eq tEvent
             NO-ERROR.   
  END.
  ELSE DO:
    /* The _TRG is also indexed on the XFTR id, if it is an XFTR. 
       So, find the relevant XFTR. NOTE that it is impossible to SET 
       an XFTR which does not exist. */
    FIND _xftr WHERE _xftr._name eq section[2] AND _xftr._wRecid eq pi_context NO-ERROR.
    IF NOT AVAILABLE _xftr AND pc_mode eq "SET":U THEN DO:
      MESSAGE "{&UIB_SHORT_NAME} API Error [in call to 'adeuib/_accsect.p']:" SKIP
              "No XFTR exists in this procedure with the name" SKIP
              section[2] + ".":U
            VIEW-AS ALERT-BOX ERROR.
      RETURN "Error".  
    END.   
    IF tEvent = "" THEN tEvent = ?.
    FIND _TRG WHERE _TRG._tSECTION eq tSection
                AND _TRG._wRECID   eq pi_context
                AND _TRG._xRECID   eq RECID(_xftr)
                AND _TRG._tEVENT   eq tEvent
             NO-ERROR.   
    
  END.
END. /* Parse pc_section. */

/* Process the user request. */              
IF NOT AVAILABLE _TRG THEN DO:  
  IF pc_mode eq "SET":U THEN DO:   
    /* Make sure the widget (pi_context) is valid */
    FIND _U WHERE RECID(_U) eq pi_context NO-ERROR.
    IF NOT AVAILABLE _U THEN DO:
      MESSAGE "{&UIB_SHORT_NAME} API Error [in call to 'adeuib/_accsect.p']:" SKIP
              "Cannot SET code section on invalid object ID:" 
               pi_context
             VIEW-AS ALERT-BOX ERROR.
      RETURN "Error". 
    END.

    ASSIGN procRecid = IF AVAILABLE _P THEN RECID(_P) ELSE ?.
    
    /* Make the trigger */
    CREATE _TRG.
    IF tSection NE "_XFTR" THEN DO:
      ASSIGN _TRG._tSECTION = tSection
             _TRG._wRECID   = pi_context
             _TRG._tEVENT   = tEvent
             _TRG._tCODE    = pc_Code
             _TRG._STATUS   = "NORMAL":U
             _TRG._pRECID   = procRecid
             .
      /* Handle special case of PROCEDURE's with <handler> */
      IF  _TRG._tSECTION eq "_PROCEDURE":U AND tSpecial ne ?
      THEN ASSIGN _TRG._tSPECIAL = tSpecial 
                  _TRG._tCODE    = ?
                  .
    END.
  END. /* Set mode */  
  /* GETTING or DELETING a non-existent code block returns "" */
  ELSE pc_Code = ?.
END. /* Not available _TRG */
ELSE DO:
  /* Get, Set or Delete the Code */  
  CASE pc_mode:
    WHEN "GET":U THEN DO:
      IF _TRG._tSPECIAL NE ?  AND 
         _TRG._tSPECIAL NE "" AND 
         _TRG._tCODE    EQ ?  THEN 
        /* UIB generated procedure - generate it */  
        RUN adeshar/_coddflt.p ( INPUT _TRG._tSPECIAL, INPUT _TRG._wRECID,
                                 OUTPUT pc_Code).                           
      ELSE
        pc_Code = _TRG._tCODE. 
    END.
    WHEN "SET":U THEN DO:
      _TRG._tCODE = pc_Code. 
      /* Handle special case of PROCEDURE's and <handler> */
      IF _TRG._tSECTION eq "_PROCEDURE":U THEN DO:
         _TRG._tSPECIAL = tSpecial.
         IF (_TRG._tSPECIAL NE ? AND _TRG._tSPECIAL NE "") 
           THEN _TRG._tCode = ?.
      END.
    END.
    WHEN "DELETE":U THEN DO:   
      /* Special case -- never delete MAIN-CODE-BLOCK or DEFINITIONS */
      IF tSection eq "_CUSTOM" AND 
         CAN-DO("_DEFINITIONS,_MAIN-BLOCK", tEvent) 
      THEN ASSIGN _TRG._tCode = ""
                  pc_Code     = "".
      ELSE DO:
        IF _TRG._xRecid NE ? THEN DO: 
          ASSIGN tSection = "_XFTR".
          FIND _XFTR WHERE RECID(_XFTR) = _TRG._xRecid NO-ERROR.
          IF AVAILABLE _XFTR THEN
             DELETE _XFTR.
        END.
        /* If another trigger points to this one in the linked list,
         * point the other trigger to what this one points to - 
         * therefore, removing this one from the list before deleting.
         */
        FIND xTRG WHERE xTRG._tLocation = INT(RECID(_TRG)) NO-ERROR.
        IF AVAILABLE (xTRG) THEN
          xTRG._tLocation = _TRG._tLocation.
        DELETE _TRG.          
        pc_Code = ?.
      END.
    END.
  END CASE.
END. /* Get, Set, Delete existing code */

/* Refresh the Section Editor display. */
IF tSection <> "_XFTR":U THEN RUN RefreshSecEd.

/* Return the current section recid.  Even if we had a valid section recid
   when we came in, it may have been deleted. */
pi_Srecid = IF AVAILABLE _TRG THEN INT(RECID(_TRG)) ELSE ?.
RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-RefreshSecEd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RefreshSecEd Procedure 
PROCEDURE RefreshSecEd :
/*------------------------------------------------------------------------------
  Purpose:      Refresh the Section Editor display.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR SEW_Value AS CHARACTER NO-UNDO.
  
  RUN get-attribute IN _h_UIB ("Section-Editor-Handle":U).
  ASSIGN hSecEd = WIDGET-HANDLE (RETURN-VALUE) NO-ERROR.
  IF NOT VALID-HANDLE ( hSecEd ) THEN RETURN.
  
  CASE pc_mode:
    WHEN "SET":U THEN DO:
      RUN GetAttribute IN hSecEd
        (INPUT "CURRENT-TRG":U , OUTPUT SEW_Value).
      /* Determine if we need to force a redisplay in the Section Editor. */
      IF STRING(RECID(_TRG)) = SEW_Value THEN
        RUN display_trg IN hSecEd.
    END.
    
    WHEN "DELETE":U THEN DO:
      /* On a delete, we have to force the Section Editor to "re-open"
         for the window its editing. */
      RUN GetAttribute IN hSecEd
        (INPUT "CURRENT-OBJECT":U , OUTPUT SEW_Value).
      IF STRING(pi_context) = SEW_Value THEN
        RUN call_sew IN _h_uib (INPUT "":U).
    END.
  END CASE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

