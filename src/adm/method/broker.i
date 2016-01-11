&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
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
/*--------------------------------------------------------------------------
    Library     : 
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


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
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
         HEIGHT             = .67
         WIDTH              = 36.
                                                                        */
&ANALYZE-RESUME
 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

  /* Turn all of the lists in brokattr.i into settable attributes. */
  RUN broker-set-attribute-list 
      (THIS-PROCEDURE,
       'ADM-DEFAULT-DEACTIVATE-LINKS="':U + 
           adm-default-deactivate-links + 
       '",ADM-NOTIFY-METHODS="':U + adm-notify-methods + 
       '",ADM-NOTIFY-LINKS="':U + adm-notify-links + 
       '",ADM-STATE-NAMES="':U + adm-state-names +
       '",ADM-STATE-LINKS="':U + adm-state-links +
       '",ADM-PASS-THROUGH-LINKS="':U + adm-pass-through-links +
       '",ADM-CIRCULAR-LINKS="':U + adm-circular-links +
       '",ADM-TRANSLATION-ATTRS="':U + adm-translation-attrs +
       '",ADM-TRANS-METHODS="':U + adm-trans-methods +
       '",ADM-PRE-INITIALIZE-EVENTS="':U + adm-pre-initialize-events + '"':U).

  IF SEARCH('brokinit.r':U) NE ? THEN
    RUN brokinit.r (INPUT THIS-PROCEDURE).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-add-link) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE add-link Method-Library 
PROCEDURE add-link :
/* ------------------------------------------------------------------------
  Purpose:     Adds a procedure handle to the link-table for a particular
               link type, in both directions.
  Parameters:  INPUT source procedure handle,
               INPUT link type name, INPUT link target handle
  Notes:       add-link calls are generated by the UIB in adm-create-objects   
--------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-link-source       AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-link-type         AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p-link-target       AS HANDLE    NO-UNDO.  
  
  DEFINE VARIABLE        pass-through        AS LOGICAL   NO-UNDO INIT no. 
  DEFINE VARIABLE        ext-tables          AS CHARACTER NO-UNDO INIT "":U. 
  DEFINE VARIABLE        save-link-target    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE        pass-through-source-rec AS RECID NO-UNDO INIT ?.
  DEFINE BUFFER          adm-link-buffer     FOR adm-link-table.
  
  IF (NOT VALID-HANDLE (p-link-source)) OR (NOT VALID-HANDLE (p-link-target))
     THEN RETURN ERROR.  /* Verify objects have been created successfully. */

  /* Log the method name etc. if monitoring */
  IF VALID-HANDLE(adm-watchdog-hdl) THEN
    RUN receive-message IN adm-watchdog-hdl 
     (INPUT p-link-source, INPUT "{&PROCEDURE-TYPE}":U,  
          INPUT "add-link: ":U + p-link-type + " ":U + p-link-source:FILE-NAME
                 + " ":U + p-link-target:FILE-NAME) NO-ERROR.
  
  IF NOT adm-adding-links THEN     /* When the app starts adding links, */
  DO:                              /*  cleanup any old links. */
      RUN cleanup-links.
      ASSIGN adm-adding-links = yes.
  END. 
  
  /* When an object's first link is created, define its attribute which
     lists the object's links that are deactivated on hide. The initial
     value of this attribute is taken from the broker; it can be modified
     for each object. */
  IF {src/adm/method/get-attr.i p-link-target ADM-DEACTIVATE-LINKS} = "":U
      THEN RUN broker-set-attribute-list (p-link-target,
         'ADM-DEACTIVATE-LINKS="':U + adm-default-deactivate-links + '"':U).
      /* If this is the very first Container, create one for the source too. */
  IF {src/adm/method/get-attr.i p-link-source ADM-DEACTIVATE-LINKS} = "":U
      THEN RUN broker-set-attribute-list (p-link-source,
         'ADM-DEACTIVATE-LINKS="':U + adm-default-deactivate-links + '"':U).
  
  /* If this is a link type that doesn't permit circular links,
     verify that the new link won't create a loop. For example,
     circular RECORD links will cuase an infinite loop. "Circular"
     (or reciprocal) STATE links may be perfectly valid. */
  IF CAN-DO(adm-circular-links, p-link-type) THEN
    FOR EACH adm-link-table WHERE adm-link-table.link-type = p-link-type
      AND adm-link-table.link-source = p-link-target:
      /* Need to use a second buffer for the nested search. */
      FIND adm-link-buffer WHERE 
          adm-link-buffer.link-type = adm-link-table.link-type AND
          adm-link-buffer.link-source = adm-link-table.link-source AND
          adm-link-buffer.link-target = adm-link-table.link-target NO-ERROR.
      DO WHILE AVAILABLE adm-link-buffer:
          IF adm-link-buffer.link-target = p-link-source THEN 
          DO:
              MESSAGE "Circular link path found while adding":U
                  p-link-type "link between":U
                  p-link-source:FILE-NAME "and":U p-link-target:FILE-NAME
                  VIEW-AS ALERT-BOX ERROR.
              RETURN "ADM-ERROR":U.
          END.
          ELSE DO:
              save-link-target = adm-link-buffer.link-target.
              FIND adm-link-buffer WHERE 
                  adm-link-buffer.link-type = p-link-type AND
                  adm-link-buffer.link-source = save-link-target NO-ERROR.
          END.
      END.
  END.
  
  /* This code checks for "pass-through" situations. If a SmartContainer
     is a Source and Target for one of these link types, then it is
     assumed that the Container is only a "virtual" Source and Target
     for that link, and at runtime the link is made directly between
     the object inside and the object outside the Container. For RECORD
     links we first check that the Container does not have any External tables
     of its own; if it does, then it has the necessary send-records and
     adm-row-available methods to receive records and send them on without
     the pass-through link. */

  IF CAN-DO (adm-pass-through-links, p-link-type) THEN
  DO:
      IF {src/adm/method/get-attr.i p-link-source CONTAINER-TYPE} NE "":U THEN 
      DO:
        IF p-link-type = "RECORD":U THEN 
        DO:
            RUN get-attribute IN p-link-source 
                ('ADM-CONTAINER-EXTERNAL-TABLES':U).
            /* This returns the actual EXTERNAL-TABLES of the Container itself,
               without querying objects to which it has a RECORD link. If there
               are none, then we can try to make a pass-through link. Otherwise
               we let the Container receive the records, use them itself, 
               and pass them on. */
            ASSIGN ext-tables = RETURN-VALUE.
        END.
        IF ext-tables = "":U THEN  /* Either not a RECORD link or no ext-tbls*/
        DO:
          FIND adm-link-table WHERE adm-link-table.link-type = p-link-type
              AND adm-link-table.link-target = p-link-source NO-ERROR.
          IF AVAILABLE adm-link-table THEN 
          DO:
              ASSIGN adm-link-table.link-target = p-link-target
                     adm-link-table.link-target-id = p-link-target:UNIQUE-ID.
              pass-through = yes.    /* Don't create a new link below. */
              pass-through-source-rec = RECID(adm-link-table).
              p-link-source = adm-link-table.link-source.
          END.
        END.
      END.
      IF {src/adm/method/get-attr.i p-link-target CONTAINER-TYPE} NE "":U THEN 
      DO:
        ext-tables = "":U.
        IF p-link-type = "RECORD":U THEN 
        DO:
            RUN get-attribute IN p-link-target 
              ('ADM-CONTAINER-EXTERNAL-TABLES':U).
            ASSIGN ext-tables = RETURN-VALUE.
        END.
        IF ext-tables = "":U THEN  /*Either not a RECORD link or no ext-tbls*/
        DO:
          FIND adm-link-table WHERE adm-link-table.link-type = p-link-type
            AND adm-link-table.link-source = p-link-target NO-ERROR.
          IF AVAILABLE adm-link-table THEN 
          DO:
             IF pass-through-source-rec NE ? THEN
             DO TRANSACTION:
                 p-link-target = adm-link-table.link-target.
                 DELETE adm-link-table.
                 FIND adm-link-table WHERE RECID(adm-link-table) =
                    pass-through-source-rec.
                 ASSIGN adm-link-table.link-target = p-link-target
                        adm-link-table.link-target-id = p-link-target:UNIQUE-ID.
             END.
             ELSE DO: 
               pass-through = yes.    /* Don't create a new link below. */
               ASSIGN adm-link-table.link-source = p-link-source
                      adm-link-table.link-source-id = p-link-source:UNIQUE-ID.
             END.
          END.
          /* If no record had a source = desired target, then 
             re-establish the previous record for use below. */
          ELSE DO:
             IF pass-through-source-rec NE ? THEN
                 FIND adm-link-table WHERE RECID(adm-link-table) =
                    pass-through-source-rec.
          END.
        END.
      END.
  END.        
  
  IF NOT pass-through THEN  /* If this wasn't changed to pass-through, */
  DO:                       /*  create a new link. */
    /* Verify first that the link is not a duplicate. */
    FIND adm-link-table WHERE adm-link-table.link-type = p-link-type AND
         adm-link-table.link-source = p-link-source AND
         adm-link-table.link-target = p-link-target NO-ERROR.
    IF AVAILABLE adm-link-table THEN 
    DO:
        MESSAGE p-link-type "link already exists between":U
          p-link-source:file-name "and":U p-link-target:FILE-NAME
          VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    CREATE adm-link-table.
    ASSIGN adm-link-table.link-type   = p-link-type 
           adm-link-table.link-source = p-link-source
           adm-link-table.link-target = p-link-target
           adm-link-table.link-source-id = p-link-source:UNIQUE-ID
           adm-link-table.link-target-id = p-link-target:UNIQUE-ID
           adm-link-table.link-active = yes.  /* Pending hidden check below*/
  END.

  /* If the object on either side of the link, or its container, is hidden,
     then turn off the link's active flag if the link type is in the
     object's deactivate list. Note that CONTAINER and all PAGE links
     are never deactivated. */

  IF NOT CAN-DO ("CONTAINER,PAGE*":U, p-link-type) THEN
  DO:
    IF LOOKUP(adm-link-table.link-type, 
      {src/adm/method/get-attr.i p-link-source ADM-DEACTIVATE-LINKS})
              NE 0 THEN 
    DO:
      IF {src/adm/method/get-attr.i p-link-source CONTAINER-HIDDEN} = "YES":U OR
         {src/adm/method/get-attr.i p-link-source HIDDEN} = "YES":U THEN
        adm-link-table.link-active = no.  /* Turn link off when object hidden.*/
    END.
    /* If the link is still active then check the other end. */
    IF adm-link-table.link-active = yes THEN  
    DO:
      IF LOOKUP(adm-link-table.link-type, 
        {src/adm/method/get-attr.i p-link-target ADM-DEACTIVATE-LINKS})
                NE 0 THEN 
      DO:
        IF {src/adm/method/get-attr.i p-link-target CONTAINER-HIDDEN} = "YES":U
          OR {src/adm/method/get-attr.i p-link-target HIDDEN} = "YES":U THEN
            adm-link-table.link-active = no.
      END.
    END. 
  END.        /* End check for non-container/page links */
          
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adjust-tab-order) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adjust-tab-order Method-Library 
PROCEDURE adjust-tab-order :
/*------------------------------------------------------------------------------
  Purpose:     A broker method to call to change the tab order of SmartObjects
  Parameters:  p-smart-object - handle of the smart object
               p-anchor       - handle of either another smartobject procedure or
                                a widget-handle ofthe object that will anchor the
                                smartobject
               p-method       - "After" if smartobject is moved-after the anchor
                                "Before" if smartobject is moved-before anchor

  Notes:       adjust-tab-order calls are generated by the UIB in 
               adm-create-objects 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-smart-object AS HANDLE                      NO-UNDO.
  DEFINE INPUT PARAMETER p-anchor       AS HANDLE                      NO-UNDO.
  DEFINE INPUT PARAMETER p-method       AS CHARACTER                   NO-UNDO.
  
  DEFINE VARIABLE adm-object-handle AS HANDLE                          NO-UNDO.
  
  /* Get widget handle of p-smart-object */
  RUN get-attribute IN p-smart-object ( 'adm-object-handle':U).
  ASSIGN adm-object-handle = WIDGET-HANDLE(RETURN-VALUE).
  IF NOT VALID-HANDLE(adm-object-handle) THEN RETURN ERROR.
  
  /* If p-anchor is smart-object procedure handle, get its object-handle */
  IF p-anchor:TYPE = "PROCEDURE":U THEN DO:
    RUN get-attribute IN p-anchor ( 'adm-object-handle':U).
    ASSIGN p-anchor = WIDGET-HANDLE(RETURN-VALUE).
    IF NOT VALID-HANDLE(p-anchor) THEN RETURN ERROR.
  END.
  
  /* Check that the two handle have the same parent */
  IF adm-object-handle:PARENT NE p-anchor:PARENT THEN RETURN ERROR.
  
  IF p-method = "BEFORE":U THEN adm-object-handle:MOVE-BEFORE(p-anchor).
                           ELSE adm-object-handle:MOVE-AFTER(p-anchor).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cleanup-links) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cleanup-links Method-Library 
PROCEDURE cleanup-links :
/*------------------------------------------------------------------------------
  Purpose:    Check for any leftover links that point to invalid
              objects and get rid of them. This can happen if an
              application is stopped without explicitly destroying
              each object. Also gets rid of invalid attribute record as well.
  Parameters:  <none>
  Notes:      The UNIQUE-ID procedure attribute is assigned when the link is
              created (in add-link). This code also verifies that the procedure
              hasn't been deleted and the handle reused by some other procedure.
------------------------------------------------------------------------------*/

DEFINE VARIABLE bad-handle AS HANDLE NO-UNDO.

DO TRANSACTION:  
    FOR EACH adm-link-table:
        bad-handle = ?.
        IF (NOT VALID-HANDLE (adm-link-table.link-source)) OR
           (adm-link-table.link-source-id NE link-source:UNIQUE-ID) THEN
               bad-handle = adm-link-table.link-source.
        ELSE IF (NOT VALID-HANDLE (adm-link-table.link-target)) OR
           (adm-link-table.link-target-id NE link-target:UNIQUE-ID) THEN
               bad-handle = adm-link-table.link-target.
        IF bad-handle NE ? THEN
           DELETE adm-link-table.
    END.
END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-display-links) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE display-links Method-Library 
PROCEDURE display-links :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Define a dialog box                                                  */

DEFINE VARIABLE Radio-Sort AS CHARACTER  LABEL "Sort By" INIT "Type":U   
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Type", "Type":U,
          "Source", "Source":U,
          "Target", "Target":U
     SIZE 32 BY 1 NO-UNDO.

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

/* Query definitions                                */
DEFINE QUERY BROWSE-1 FOR 
      adm-link-table SCROLLING.

&SCOP OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH adm-link-table ~
  BY IF Radio-Sort = "Type":U THEN link-type ~
  ELSE IF Radio-Sort = "Source":U THEN link-source:file-name ~
  ELSE link-target:file-name.


/* Browse definitions                                */
DEFINE BROWSE BROWSE-1
  QUERY BROWSE-1 NO-LOCK DISPLAY
    CAPS(link-type) label "Type" Format "X(12)":U
    LC(link-source:FILE-NAME) label "Source" Format "X(35)":U
    LC(link-target:FILE-NAME) label "Target" Format "X(35)":U
    WITH NO-ROW-MARKERS SEPARATORS SIZE 87 BY 9.2.

DEFINE FRAME Dialog-Frame
     Radio-Sort AT ROW 1.5 COL 30
     Btn_OK AT ROW 13 COL 32
     BROWSE-1 AT ROW 3 COL 3 SPACE(2)
     Btn_Help AT ROW 13 COL 52
     SPACE(3) SKIP(1)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "ADM Links".
         
ON VALUE-CHANGED OF Radio-Sort 
DO:
  ASSIGN Radio-Sort.
  {&OPEN-QUERY-BROWSE-1}
END.
      
RUN cleanup-links.    /* get rid of any dead links before displaying. */

ENABLE Radio-Sort BROWSE-1   Btn_OK  Btn_Help 
      WITH FRAME Dialog-Frame.

{&OPEN-QUERY-BROWSE-1} 

WAIT-FOR GO OF FRAME Dialog-Frame.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-link-handle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-link-handle Method-Library 
PROCEDURE get-link-handle :
/* -----------------------------------------------------------
      Purpose:    Returns the current procedure handle(s) 
                  for the specified link.
      Parameters: INPUT source procedure handle,
                  INPUT link type,
                  OUTPUT procedure handle, or a comma-separated list of
                  procedure handles, in character format.
      Notes:       
    -------------------------------------------------------------*/   
      DEFINE INPUT  PARAMETER p-source-hdl    AS HANDLE    NO-UNDO.
      DEFINE INPUT  PARAMETER p-link-type     AS CHARACTER NO-UNDO.
      DEFINE OUTPUT PARAMETER p-link-hdls     AS CHARACTER NO-UNDO INIT "":U.

      DEFINE VARIABLE base-link               AS CHARACTER NO-UNDO.

      base-link = SUBSTR(p-link-type,1, R-INDEX(p-link-type, "-":U) - 1,
          "CHARACTER":U).
      IF INDEX(p-link-type, "-TARGET":U) NE 0 THEN
          FOR EACH adm-link-table WHERE adm-link-table.link-type = base-link
            AND adm-link-table.link-source = p-source-hdl 
              AND link-active:
                IF p-link-hdls NE "":U THEN p-link-hdls = p-link-hdls + ",":U.
                p-link-hdls = p-link-hdls + STRING(adm-link-table.link-target).
          END.
      ELSE
          FOR EACH adm-link-table WHERE adm-link-table.link-type = base-link
            AND adm-link-table.link-target = p-source-hdl 
              AND link-active:
                IF p-link-hdls NE "":U THEN p-link-hdls = p-link-hdls + ",":U.
                p-link-hdls = p-link-hdls + STRING(adm-link-table.link-source).
          END.

      /* Log the method name etc. if monitoring */
      IF VALID-HANDLE(adm-watchdog-hdl) THEN
        RUN receive-message IN adm-watchdog-hdl 
         (INPUT p-source-hdl, INPUT "{&PROCEDURE-TYPE}":U,  
              INPUT "get-link-handle: ":U + p-link-type + p-link-hdls) NO-ERROR.

      RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-modify-deactivate-links) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modify-deactivate-links Method-Library 
PROCEDURE modify-deactivate-links :
/* -----------------------------------------------------------
      Purpose:     Add or remove link types from the list of those
                   to be disabled when an object is hidden.
      Parameters:  Caller procedure handle, "ADD"/"REMOVE" flag, 
                   comma-separated list of link types
      Notes:       
    -------------------------------------------------------------*/   
  DEFINE INPUT PARAMETER p-caller    AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-add-rem   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p-link-list AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cntr                AS INTEGER NO-UNDO.
  DEFINE VARIABLE current-entry       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE index-pos           AS INTEGER NO-UNDO.
  DEFINE VARIABLE deactivate-links    AS CHARACTER NO-UNDO.

  deactivate-links = {src/adm/method/get-attr.i p-caller ADM-DEACTIVATE-LINKS}.
 
  DO cntr = 1 TO NUM-ENTRIES(p-link-list):
    current-entry = ENTRY(cntr, p-link-list).
    index-pos = INDEX(deactivate-links, current-entry).
    IF p-add-rem = "ADD":U THEN 
    DO:
        IF index-pos = 0 THEN     /* Add to the list if not already there: */
          deactivate-links = deactivate-links + ",":U + current-entry.

        /* If the object (or its container) is currently hidden, 
           and it participates in a link of this kind (as source or target), 
           deactivate the link now. */
        IF {src/adm/method/get-attr.i p-caller CONTAINER-HIDDEN} = "YES":U OR
           {src/adm/method/get-attr.i p-caller HIDDEN} = "YES":U THEN
        DO:
            FIND adm-link-table WHERE adm-link-table.link-source = p-caller 
              AND adm-link-table.link-type = current-entry NO-ERROR.
            IF AVAILABLE adm-link-table THEN 
                ASSIGN adm-link-table.link-active = no.
            FIND adm-link-table WHERE adm-link-table.link-target = p-caller 
              AND adm-link-table.link-type = current-entry NO-ERROR.
            IF AVAILABLE adm-link-table THEN 
                ASSIGN adm-link-table.link-active = no.
        END.
            
    END.
    ELSE IF p-add-rem = "REMOVE":U THEN 
    DO:                                  /* Remove both SOURCE and TARGET */
        IF index-pos NE 0 THEN           /*  from the list if link is there: */
        DO:
            IF index-pos = 1 THEN    /* Remove the first entry from the list: */
                deactivate-links = SUBSTR(deactivate-links, 
                  LENGTH(current-entry, "CHARACTER":U) + 1, -1, "CHARACTER":U).
            ELSE                     /* Remove an entry other than the first:*/ 
                deactivate-links = SUBSTR(deactivate-links, 1, 
                   index-pos - 2, "CHARACTER":U)
                    + SUBSTR(deactivate-links, 
                        index-pos + LENGTH(current-entry, "CHARACTER":U),
                           -1, "CHARACTER":U).
        END.

        /* If the object (or its container) is currently hidden, 
           and it participates in a link of this kind (as source or target), 
           activate the link now. */
        IF {src/adm/method/get-attr.i p-caller CONTAINER-HIDDEN} = "YES":U OR
           {src/adm/method/get-attr.i p-caller HIDDEN} = "YES":U THEN
        DO:
            FIND adm-link-table WHERE adm-link-table.link-source = p-caller 
              AND adm-link-table.link-type = current-entry NO-ERROR.
            IF AVAILABLE adm-link-table THEN 
                ASSIGN adm-link-table.link-active = yes.
            FIND adm-link-table WHERE adm-link-table.link-target = p-caller
              AND adm-link-table.link-type = current-entry NO-ERROR.
            IF AVAILABLE adm-link-table THEN 
                ASSIGN adm-link-table.link-active = yes.
        END.
    END.
    ELSE 
    DO:
        MESSAGE "Invalid add/remove argument ":U p-add-rem 
          " encountered in modify-deactivate-links. ":U
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR":U.
    END.
  END.          /* End of outer cntr loop. */

  {src/adm/method/set-attr.i p-caller ADM-DEACTIVATE-LINKS deactivate-links}

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-modify-list-attribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modify-list-attribute Method-Library 
PROCEDURE modify-list-attribute :
/*------------------------------------------------------------------------------
  Purpose:     Allows values to be added or deleted from any ADM attribute
               which is a comma-separated list (SUPPORTED-LINKS, etc.)
  Parameters:  INPUT handle of the object whose attribute is being changed
               INPUT 'ADD' or 'REMOVE'
               INPUT name of the attribute
               INPUT the value to add or remove
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-caller      AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-mode        AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p-list-name   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p-list-value  AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE adding-value         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE value-list           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE value-index          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE comma-index          AS INTEGER   NO-UNDO.
  
  IF p-mode = "ADD":U THEN adding-value = yes.
  ELSE IF p-mode = "REMOVE":U THEN adding-value = no.
  ELSE DO:
      MESSAGE "Add/Remove flag not recognized in modify-list-attribute call.":U
              VIEW-AS ALERT-BOX ERROR.
      RETURN.
  END.
  
  RUN broker-get-attribute (p-caller, p-list-name).
  value-list = TRIM(RETURN-VALUE).        /* trim any extraneous spaces */
  
  IF value-list = "?":U OR value-list = ? THEN
     value-list = "":U.                   /* Give us a value we can INDEX in. */
  
  value-index = INDEX(value-list, p-list-value).

  /* Removing a value that's not there or adding a value that *is* there: */
  IF (value-index = 0 AND not adding-value) 
     OR (value-index NE 0 AND adding-value)   
       THEN RETURN.                           /* -> Nothing to do. */
  ELSE IF adding-value THEN             /* New item is added to the list */
      value-list = value-list +         /* (or is the only thing in the list) */
          (IF LENGTH(value-list, "CHARACTER":U) > 0 THEN ",":U ELSE "":U)
          + p-list-value.
  ELSE DO:                              /* Removing a value */
      comma-index =                     /* Is this the last thing in the list?*/
          INDEX(value-list, ",":U, value-index).
          
      IF value-index = 1 THEN           /* Is it the first thing in the list? */
      DO:
          IF comma-index = 0 THEN value-list = "":U.  /* It was the only value*/
          ELSE value-list =             /* Remove the first value in the list.*/
             SUBSTR(value-list, comma-index + 1, -1, "CHARACTER":U).
      END.
      ELSE DO:                          /* It isn't the first value in list. */
          IF comma-index = 0 THEN       /* It was the last value. */
              value-list =              /* Remove starting from the last comma*/
                SUBSTR(value-list, 1, 
                  R-INDEX(value-list, ",":U) - 1, "CHARACTER":U).
          ELSE value-list =             /* Remove the value and the comma */
            SUBSTR(value-list, 1, value-index - 1, "CHARACTER":U) +
              SUBSTR(value-list, comma-index + 1, -1, "CHARACTER":U).
      END.
  END.  
  
  /* Reset the attribute value, putting in the required double quotes. */
  RUN broker-set-attribute-list (p-caller, 
      p-list-name + '="':U + value-list + '"':U).
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-remove-all-links) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remove-all-links Method-Library 
PROCEDURE remove-all-links :
/* ---------------------------------------------------------------------
  Purpose:     Removes all links as part of destroying a procedure.
  Parameters:  source procedure handle
  Notes:       
-----------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p-source-hdl AS HANDLE NO-UNDO.

  FOR EACH adm-link-table WHERE adm-link-table.link-source = p-source-hdl 
                             OR adm-link-table.link-target = p-source-hdl:
      DELETE adm-link-table.
  END.
  
  IF adm-adding-links THEN     /* When the app starts removing links,*/
  DO:                          /*  cleanup any old links. */
      RUN cleanup-links.
      ASSIGN adm-adding-links = no.
  END. 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-remove-link) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remove-link Method-Library 
PROCEDURE remove-link :
/* ---------------------------------------------------------------------
  Purpose:     Removes a procedure handle from the link-tables for a
               particular link type.
  Parameters:  INPUT source procedure handle,
               INPUT link type name, INPUT link target object handle
  Notes:       actual-link-target is not used by this method, but is
               needed for the remove-link calling sequence.
-----------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p-source-hdl   AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-link-type    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p-target-hdl   AS HANDLE    NO-UNDO.   
 
  FIND adm-link-table WHERE adm-link-table.link-source = p-source-hdl
                        AND adm-link-table.link-target = p-target-hdl
                        AND adm-link-table.link-type   = p-link-type NO-ERROR.
  IF ERROR-STATUS:ERROR THEN 
  DO:
      IF VALID-HANDLE (p-source-hdl) AND VALID-HANDLE (p-target-hdl) THEN
          MESSAGE "adm-remove-link did not find Link Type ":U p-link-type SKIP
                  "between procedures ":U p-source-hdl:FILE-NAME " and ":U SKIP
                  p-target-hdl:FILE-NAME VIEW-AS ALERT-BOX ERROR.
      ELSE MESSAGE "adm-remove-link was passed an invalid procedure handle.":U
                   VIEW-AS ALERT-BOX ERROR.
  END.
  ELSE
      DELETE adm-link-table.
                        
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE request Method-Library 
PROCEDURE request :
/* -----------------------------------------------------------
      Purpose:    Sends a request to another procedure.
      Parameters: INPUT link-type to send the request to;
                  INPUT method-name to 'request' (RUN) in the other proc.
      Notes:      This procedure assumes that the source or target
                  procedure the request is sent to is unique. 
                  However, if the requested method does not exist in
                  the procedure at the other end of the link, request 
                  will continue to search in the same direction. 
                  For example, if p-link-type is RECORD-SOURCE, and
                  the RECORD-SOURCE of p-source-hdl
                  does not have the requested method, we will look to
                  see if *its* RECORD-SOURCE (if any) has the method.
    -------------------------------------------------------------*/   
      DEFINE INPUT PARAMETER p-source-hdl     AS HANDLE    NO-UNDO.
      DEFINE INPUT PARAMETER p-link-type      AS CHARACTER NO-UNDO.
      DEFINE INPUT PARAMETER p-method-name    AS CHARACTER NO-UNDO.

      DEFINE VARIABLE base-link-type AS CHARACTER NO-UNDO.
      DEFINE VARIABLE link-direction AS CHARACTER NO-UNDO.
      DEFINE VARIABLE temp-hdl       AS HANDLE    NO-UNDO.

      IF VALID-HANDLE(adm-watchdog-hdl) THEN
        RUN receive-message IN adm-watchdog-hdl 
         (INPUT p-source-hdl,  INPUT "{&PROCEDURE-TYPE}":U, 
              INPUT "request: ":U + p-link-type + p-method-name) NO-ERROR.

      RUN split-link(INPUT p-link-type, OUTPUT base-link-type,
                     OUTPUT link-direction).
      IF RETURN-VALUE NE "ERROR":U THEN
      DO:
          temp-hdl = p-source-hdl.    
          IF link-direction = 'SOURCE':U THEN 
          REPEAT:
              FIND adm-link-table WHERE 
                       adm-link-table.link-type = base-link-type
                   AND adm-link-table.link-target = temp-hdl
                   AND adm-link-table.link-active NO-ERROR.
              IF NOT AVAILABLE adm-link-table THEN RETURN. /* Note: No error.*/
              IF LOOKUP (p-method-name, 
                adm-link-table.link-source:INTERNAL-ENTRIES) NE 0 THEN
              DO:
                  RUN VALUE(p-method-name) IN adm-link-table.link-source
                    (INPUT p-source-hdl). 
                  RETURN.
              END.
              ELSE temp-hdl = adm-link-table.link-source. /* Keep looking. */
          END.
          ELSE               /* send request to TARGET procedure */
          REPEAT:
              FIND adm-link-table WHERE 
                       adm-link-table.link-type = base-link-type
                   AND adm-link-table.link-source = temp-hdl
                   AND adm-link-table.link-active NO-ERROR.
              IF NOT AVAILABLE adm-link-table THEN RETURN. /* Note: No error.*/
              IF LOOKUP (p-method-name, 
                adm-link-table.link-target:INTERNAL-ENTRIES) NE 0 THEN
              DO:
                  RUN VALUE(p-method-name) IN adm-link-table.link-target
                    (INPUT p-source-hdl). 
                  RETURN.
              END.
              ELSE temp-hdl = adm-link-table.link-target. /* Keep looking. */
          END.
      END.
     
      RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-request-attribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE request-attribute Method-Library 
PROCEDURE request-attribute :
/* -----------------------------------------------------------
      Purpose:    Requests an attribute from an object with the
                  specified link type and returns the attribute value
      Parameters: INPUT source procedure handle,
                  INPUT link-type to get the attribute from,
                  INPUT attribute to request.
      Notes:      This procedure returns "?" if there is not
                  exactly one object of that link type active.
    -------------------------------------------------------------*/   
      DEFINE INPUT PARAMETER p-source-hdl        AS HANDLE    NO-UNDO.
      DEFINE INPUT PARAMETER p-link-type         AS CHARACTER NO-UNDO.
      DEFINE INPUT PARAMETER p-attribute-name    AS CHARACTER NO-UNDO.

      DEFINE VARIABLE base-link-type AS CHARACTER NO-UNDO.
      DEFINE VARIABLE link-direction AS CHARACTER NO-UNDO.
      DEFINE VARIABLE ret-val AS CHARACTER NO-UNDO.
      
      RUN split-link(INPUT p-link-type, OUTPUT base-link-type,
                     OUTPUT link-direction).
      IF RETURN-VALUE EQ "ERROR":U THEN
          ret-val = "?":U.
      ELSE
      DO:
          IF link-direction = "SOURCE":U THEN 
          DO:
              FIND adm-link-table WHERE 
                  adm-link-table.link-target = p-source-hdl AND
                  adm-link-table.link-type = base-link-type AND
                  adm-link-table.link-active NO-ERROR.
              IF NOT AVAILABLE adm-link-table THEN RETURN "?":U.
              RUN broker-get-attribute (adm-link-table.link-source,
                  p-attribute-name).
              ret-val = RETURN-VALUE.
          END.
          ELSE
          DO:
              FIND adm-link-table WHERE 
                  adm-link-table.link-source = p-source-hdl AND
                  adm-link-table.link-type = base-link-type AND
                  adm-link-table.link-active NO-ERROR.
              IF NOT AVAILABLE adm-link-table THEN RETURN "?":U.
              RUN broker-get-attribute (adm-link-table.link-target,
                  p-attribute-name).
              ret-val = RETURN-VALUE.
          END.
      END.

      RETURN ret-val. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-active-links) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-active-links Method-Library 
PROCEDURE set-active-links :
/* -----------------------------------------------------------
      Purpose:     Turn links on or off when the current object is 
                   viewed or hidden; touches only the links that
                   are marked as ok to deactivate (adm-deactivate-links).
      Parameters:  INPUT source procedure handle, INPUT on/off flag.
      Notes:       Run from adm-view and adm-hide by default.
                   Note that all links beginning with "PAGE" are exempted
                   from being turned on and off, so that containers can
                   communicate with hidden pages. The "deactivate-links"
                   list default is changed using modify-deactivate-links.
    -------------------------------------------------------------*/   
    DEFINE INPUT PARAMETER p-source-hdl  AS HANDLE  NO-UNDO.
    DEFINE INPUT PARAMETER p-link-active AS LOGICAL NO-UNDO.
    DEFINE VARIABLE        tmp-hdl       AS HANDLE NO-UNDO.
    DEFINE VARIABLE deactivate-links     AS CHARACTER NO-UNDO.
           
    deactivate-links = 
        {src/adm/method/get-attr.i p-source-hdl ADM-DEACTIVATE-LINKS}.

    /* If this is a Group-Assign-Target and its Source is a
       Tableio-Target, then re-activate the Tableio link if necessary. 
       This case will normally be caught by the other special code below,
       but when a page is first selected the links won't be there yet,
       so this code will catch that case. */
    IF p-link-active THEN
    DO: 
        FIND FIRST adm-link-table WHERE
          adm-link-table.link-type = "GROUP-ASSIGN":U AND
          adm-link-table.link-target = p-source-hdl NO-ERROR. 
        IF AVAILABLE (adm-link-table) THEN
        DO: 
          tmp-hdl = adm-link-table.link-source. 
          /* Is my Group-Assign-Source a Tableio-Target? */
          FIND adm-link-table WHERE 
            adm-link-table.link-target = tmp-hdl AND
            adm-link-table.link-type = "TABLEIO":U NO-ERROR.
          /* If so, and the Tableio link has been turned off, turn the 
             Tableio link back on and tell the Update Panel to stay active. */
          IF AVAILABLE (adm-link-table) AND adm-link-table.link-active = no
          THEN DO:
              adm-link-table.link-active = yes.
              RUN state-changed IN adm-link-table.link-source 
                (tmp-hdl, 'link-changed':U).  
          END.
        END.
    END.

    FOR EACH adm-link-table WHERE 
      (adm-link-table.link-source = p-source-hdl OR
       adm-link-table.link-target = p-source-hdl) AND
          (LOOKUP(adm-link-table.link-type, deactivate-links) NE 0) AND
             (NOT adm-link-table.link-type BEGINS "PAGE":U):
        
        /* Special case: If this is a Tableio link and this procedure is also
           a Group-Assign-Source, then skip it. We don't want to deactivate
           the Tableio link when another page of the Group-Assign is being
           viewed. */
        IF adm-link-table.link-type EQ "TABLEIO":U AND 
          CAN-FIND(FIRST adm-link-table WHERE 
           adm-link-table.link-source = p-source-hdl AND
           adm-link-table.link-type = "GROUP-ASSIGN":U) THEN
             NEXT.

        ASSIGN adm-link-table.link-active = p-link-active.
        /* Notify the object at the other end of the link that the
           link state changed. Keep track of each notification
           to avoid duplication. */
        IF adm-link-table.link-source = p-source-hdl THEN 
             tmp-hdl = adm-link-table.link-target.
        ELSE tmp-hdl = adm-link-table.link-source.
        FIND FIRST adm-link-procedure WHERE 
          adm-link-procedure.link-proc-hdl =
            tmp-hdl NO-ERROR.
        IF NOT AVAILABLE adm-link-procedure THEN
        DO:
            RUN state-changed IN tmp-hdl
                (p-source-hdl, 'link-changed':U) NO-ERROR. 
            DO TRANSACTION:
                CREATE adm-link-procedure.
                ASSIGN adm-link-procedure.link-proc-hdl = tmp-hdl.
            END.
        END.
    END.
    /* Notify "myself" that the link(s)' state changed, if not done already. */
    FIND FIRST adm-link-procedure WHERE adm-link-procedure.link-proc-hdl =
         p-source-hdl NO-ERROR.
    IF NOT AVAILABLE adm-link-procedure THEN
      RUN state-changed IN p-source-hdl
        (p-source-hdl, 'link-changed':U) NO-ERROR. 
        
    DO TRANSACTION:
        FOR EACH adm-link-procedure:
            DELETE adm-link-procedure.  /* Empty the work-table for next use. */
        END.
    END.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-broker-owner) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-broker-owner Method-Library 
PROCEDURE set-broker-owner :
/*------------------------------------------------------------------------------
  Purpose:   This procedure allows the procedure which initialized
             the broker (or potentially some other procedure) to
             declare itself to be the "owner" of the broker process.
             When this procedure runs remove-all-links to indicate that
             it is terminating, the broker will look for another owner
             or terminate itself.  
  Parameters:  Owner's procedure handle.
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-broker-owner AS HANDLE NO-UNDO.
ASSIGN adm-broker-owner = p-broker-owner.
RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-cursor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-cursor Method-Library 
PROCEDURE set-cursor :
/*------------------------------------------------------------------------------
  Purpose:  Sets the cursor on all windows and on any dialog box frames 
            that are currently on the screen.   
  Parameters: p_cursor - name of cursor to use.  This should be either
              "WAIT" or "".
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_cursor  AS CHAR           NO-UNDO.

DEFINE VAR ldummy AS LOGICAL NO-UNDO.

&IF "{&WINDOW-SYSTEM}" ne "TTY" &THEN
      /* Set the Wait state, which changes the cursor automatically */
      ldummy = SESSION:SET-WAIT-STATE(IF p_cursor = "WAIT" THEN "GENERAL" 
                                                           ELSE "").
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-link-attribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-link-attribute Method-Library 
PROCEDURE set-link-attribute :
/*------------------------------------------------------------------------------
  Purpose:     Allows caller to set one or more attributes in another object(s)
               knowing only the link type, not the other objects' handle(s).
  Parameters:  calling procedure handle, link type, attribute list (as for
               set-attribute-list).
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-caller         AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-link-type      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p-attribute-list AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE base-link               AS CHARACTER NO-UNDO.
  
  base-link = SUBSTR(p-link-type,1,R-INDEX(p-link-type,"-":U) - 1,
    "CHARACTER":U).
  
  IF INDEX(p-link-type, "-TARGET":U) NE 0 THEN
  DO:
      FOR EACH adm-link-table WHERE adm-link-table.link-source = p-caller
        AND adm-link-table.link-type = base-link AND adm-link-table.link-active:
          RUN set-attribute-list IN adm-link-table.link-target
            (p-attribute-list) NO-ERROR.
      END.
  END.
  ELSE DO:
     FOR EACH adm-link-table WHERE adm-link-table.link-target = p-caller
        AND adm-link-table.link-type = base-link AND adm-link-table.link-active:
          RUN set-attribute-list IN adm-link-table.link-source
            (p-attribute-list) NO-ERROR.
      END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-one-active-link) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-one-active-link Method-Library 
PROCEDURE set-one-active-link :
/* -----------------------------------------------------------
      Purpose:     Sets an individual link's active flag on or off.
      Parameters:  Source procedure handle, Target procedure handle,
                   link type, yes/no flag (for on/off)
      Notes:       
    -------------------------------------------------------------*/   
  DEFINE INPUT PARAMETER p-source-hdl     AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-target-hdl     AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-link-type      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p-activate       AS LOGICAL   NO-UNDO.

  FIND adm-link-table WHERE adm-link-table.link-source = p-source-hdl AND
     adm-link-table.link-target = p-target-hdl AND 
     adm-link-table.link-type = p-link-type NO-ERROR. /* Error if not found? */
  IF AVAILABLE adm-link-table THEN 
      ASSIGN adm-link-table.link-active = p-activate.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-watchdog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-watchdog Method-Library 
PROCEDURE set-watchdog :
/* -----------------------------------------------------------
      Purpose:     Turns the watchdog flag on for a proc and 
                   its contained descendents.
      Parameters:  watchdog handle
      Notes:       Run internally to initialize PRO*Spy
    -------------------------------------------------------------*/   
    DEFINE INPUT PARAMETER p-watchdog-hdl     AS HANDLE  NO-UNDO.  

    ASSIGN adm-watchdog-hdl    = p-watchdog-hdl.

    RETURN.
  END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-split-link) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE split-link Method-Library 
PROCEDURE split-link :
/* -----------------------------------------------------------
  Purpose:     Splits a link name such as RECORD-SOURCE into its
               base link type (RECORD) and link direction (SOURCE).
  Parameters:  INPUT full link name,
               OUTPUT base link type, OUTPUT link-direction.
  Notes:       
-------------------------------------------------------------*/
      DEFINE INPUT  PARAMETER p-link-type AS CHARACTER NO-UNDO.
      DEFINE OUTPUT PARAMETER p-base-link AS CHARACTER NO-UNDO.
      DEFINE OUTPUT PARAMETER p-direction AS CHARACTER NO-UNDO.

      DEFINE VARIABLE hyphen-pos     AS INTEGER   NO-UNDO.

      ASSIGN hyphen-pos = R-INDEX(p-link-type,"-":U).
      IF hyphen-pos NE 0 THEN 
      DO:
          ASSIGN p-base-link = SUBSTR(p-link-type,1,hyphen-pos - 1,
                     "CHARACTER":U)
                 p-direction = SUBSTR(p-link-type,hyphen-pos + 1, -1,
                     "CHARACTER":U).
      END.

      IF hyphen-pos = 0 OR 
          (p-direction NE "SOURCE":U AND p-direction NE "TARGET":U) THEN DO:
          MESSAGE ENTRY(1,PROGRAM-NAME(1)," ":U) 
                  " was passed an invalid link type: ":U p-link-type SKIP
                  " Make sure that -SOURCE or -TARGET suffix is specified.":U
                  VIEW-AS ALERT-BOX ERROR.
          RETURN "ERROR":U.
      END.
      ELSE 
          RETURN "":U.
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-use-adm-circular-links) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-adm-circular-links Method-Library 
PROCEDURE use-adm-circular-links :
/*------------------------------------------------------------------------------
  Purpose:     Sets the variable corresponding to this attribute
  Parameters:  attribute value
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-attr-value AS CHARACTER NO-UNDO.
  
  adm-circular-links = p-attr-value.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-use-adm-default-deactivate-links) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-adm-default-deactivate-links Method-Library 
PROCEDURE use-adm-default-deactivate-links :
/*------------------------------------------------------------------------------
  Purpose:     Sets the variable corresponding to this attribute
  Parameters:  attribute value
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-attr-value AS CHARACTEr NO-UNDO.
  
  adm-default-deactivate-links = p-attr-value.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-use-adm-notify-links) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-adm-notify-links Method-Library 
PROCEDURE use-adm-notify-links :
/*------------------------------------------------------------------------------
  Purpose:     Sets the variable corresponding to this attribute
  Parameters:  attribute value
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-attr-value AS CHARACTER NO-UNDO.
  
  adm-notify-links = p-attr-value.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-use-adm-notify-methods) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-adm-notify-methods Method-Library 
PROCEDURE use-adm-notify-methods :
/*------------------------------------------------------------------------------
  Purpose:     Sets the variable corresponding to this attribute
  Parameters:  attribute value
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-attr-value AS CHARACTER NO-UNDO.
  
  adm-notify-methods = p-attr-value.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-use-adm-pass-through-links) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-adm-pass-through-links Method-Library 
PROCEDURE use-adm-pass-through-links :
/*------------------------------------------------------------------------------
  Purpose:     Sets the variable corresponding to this attribute
  Parameters:  attribute value
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-attr-value AS CHARACTER NO-UNDO.
  
  adm-pass-through-links = p-attr-value.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-use-adm-pre-initialize-events) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-adm-pre-initialize-events Method-Library 
PROCEDURE use-adm-pre-initialize-events :
/*------------------------------------------------------------------------------
  Purpose:     Sets the variable corresponding to this attribute
  Parameters:  attribute value
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-attr-value AS CHARACTER NO-UNDO.
  
  adm-pre-initialize-events = p-attr-value.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-use-adm-state-links) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-adm-state-links Method-Library 
PROCEDURE use-adm-state-links :
/*------------------------------------------------------------------------------
  Purpose:     Sets the variable corresponding to this attribute
  Parameters:  attribute value
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-attr-value AS CHARACTER NO-UNDO.
  
  adm-state-links = p-attr-value.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-use-adm-state-names) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-adm-state-names Method-Library 
PROCEDURE use-adm-state-names :
/*------------------------------------------------------------------------------
  Purpose:     Sets the variable corresponding to this attribute
  Parameters:  attribute value
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-attr-value AS CHARACTER NO-UNDO.
  
  adm-state-names = p-attr-value.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-use-adm-trans-methods) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-adm-trans-methods Method-Library 
PROCEDURE use-adm-trans-methods :
/*------------------------------------------------------------------------------
  Purpose:     Sets the variable corresponding to this attribute
  Parameters:  attribute value
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-attr-value AS CHARACTER NO-UNDO.
  
  adm-trans-methods = p-attr-value.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-use-adm-translation-attrs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE use-adm-translation-attrs Method-Library 
PROCEDURE use-adm-translation-attrs :
/*------------------------------------------------------------------------------
  Purpose:     Sets the variable corresponding to this attribute
  Parameters:  attribute value
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-attr-value AS CHARACTER NO-UNDO.
  
  adm-translation-attrs = p-attr-value.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

