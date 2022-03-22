&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME d_addlink
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _linkadd.w

  Description: Adds (or Modify) links to link table 

  Input Parameters:
      p_Precid -- RECID of the current procedure.
      p_Lrecid -- RECID of a Link being Modified (or ?) if a link is to be
                  added.

  Output Parameters:
      p_OK -- TRUE if user pressed OK button.

  Author: Gerry Seidl 

  Created: 01/31/95 - 12:09 pm
           03/98 SLK Added button to access Foreign Fiels
           03/10/98 SLK Added signature match 
           03/19/98 SLK Changed call to _mfldmap.p
           06/22/98 SLK Advise signature mismatch vs disallowing link
   Notes: AppBuilder markup removed to support Appbuilder in IDE        
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adeuib/uibhlp.i}
{adeuib/uniwidg.i}
{adeuib/links.i}
{adeuib/advice.i}
{adeuib/vsookver.i}
{adeuib/sharvars.i}

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER p_Precid AS RECID NO-UNDO.   /* recid of _P record */
DEFINE INPUT  PARAMETER p_Lrecid AS RECID NO-UNDO.   /* recid of _P record */
DEFINE OUTPUT PARAMETER p_OK     AS LOGICAL NO-UNDO. /* Did user hit OK */
/* Local Variable Definitions ---                                       */
  
DEFINE SHARED TEMP-TABLE so
  FIELD name        AS CHARACTER
  FIELD type        AS CHARACTER
  FIELD links       AS CHARACTER
  FIELD _U-recid    AS RECID
  FIELD _S-handle   AS HANDLE
  FIELD queryObject AS LOGICAL INITIAL NO
  FIELD active      AS LOGICAL INITIAL YES.

DEFINE SHARED TEMP-TABLE nadmlinks
  FIELD _admlinks-recid AS RECID
  FIELD _active         AS LOGICAL INITIAL yes /* Set to no if source or target _U is "DELETED" */
  FIELD _source-name    AS CHARACTER FORMAT "X(28)" COLUMN-LABEL "Source"
  FIELD _target-name    AS CHARACTER FORMAT "X(28)" COLUMN-LABEL "Target"
  INDEX _admlinks-recid AS PRIMARY _admlinks-recid.

DEFINE VARIABLE CustomLinkTypes AS CHARACTER NO-UNDO.
DEFINE VARIABLE c_errMsg        AS CHARACTER NO-UNDO.
DEFINE VARIABLE i               AS INTEGER   NO-UNDO.
DEFINE VARIABLE l               AS LOGICAL   NO-UNDO.
DEFINE VARIABLE link-possible   AS LOGICAL   NO-UNDO.

DEFINE BUFFER b-so FOR so.
define variable frametitle as char no-undo init "Add a SmartLink" .
/* If a RECORD- link is being added, we may have to set a Key-Name on the Target
   when the dialog is SAVED. */
DEFINE VARIABLE Key-Name-to-Set AS CHARACTER NO-UNDO INITIAL ?.




/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME d_addlink

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS s_source s_linktype s_dest r_linkadd 
&Scoped-Define DISPLAYED-OBJECTS s_source s_dest 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */




/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_ForeignFields 
     LABEL "Foreign Fields" 
     SIZE 29 BY 1.14.

DEFINE BUTTON b_Info1 
     LABEL "Info on Source" 
     SIZE 29 BY 1.14.

DEFINE BUTTON b_Info2 
     LABEL "Info on Target" 
     SIZE 29 BY 1.14.

DEFINE RECTANGLE r_linkadd
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79 BY 8.67.

DEFINE VARIABLE s_dest AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE NO-DRAG SCROLLBAR-VERTICAL 
     SIZE 27 BY 7.14 NO-UNDO.

DEFINE VARIABLE s_linktype AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE NO-DRAG SCROLLBAR-VERTICAL 
     SIZE 21 BY 7.14 NO-UNDO.

DEFINE VARIABLE s_source AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE NO-DRAG SCROLLBAR-VERTICAL 
     SIZE 27 BY 7.14 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME d_addlink
     s_source AT ROW 2.52 COL 3 NO-LABEL
     s_linktype AT ROW 2.52 COL 31 NO-LABEL
     s_dest AT ROW 2.52 COL 53 NO-LABEL
     b_Info1 AT ROW 10.24 COL 2
     b_Info2 AT ROW 10.24 COL 52
     b_ForeignFields AT ROW 11.48 COL 52
     r_linkadd AT ROW 1.38 COL 2
     " Link Elements" VIEW-AS TEXT
          SIZE 15 BY .81 AT ROW 1 COL 4.6
     "Source:" VIEW-AS TEXT
          SIZE 10 BY .76 AT ROW 1.76 COL 3
     "Link Type:" VIEW-AS TEXT
          SIZE 12 BY .76 AT ROW 1.76 COL 31
     "Target:" VIEW-AS TEXT
          SIZE 13 BY .76 AT ROW 1.76 COL 53
     SPACE(15.99) SKIP(10.18)
    WITH 
    &if DEFINED(IDE-IS-RUNNING) = 0 &then
     VIEW-AS DIALOG-BOX TITLE frameTitle
     &else
     NO-BOX
     &endif 
     KEEP-TAB-ORDER 
     SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE .
     
{adeuib/ide/dialoginit.i "frame d_addlink:handle}
&if DEFINED(IDE-IS-RUNNING) <> 0  &then
    dialogService:View(). 
&endif
/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

/* SETTINGS FOR DIALOG-BOX d_addlink
                                                                        */
ASSIGN 
       FRAME d_addlink:SCROLLABLE       = FALSE.

/* SETTINGS FOR BUTTON b_ForeignFields IN FRAME d_addlink
   NO-ENABLE                                                            */
ASSIGN 
       b_ForeignFields:HIDDEN IN FRAME d_addlink           = TRUE.

/* SETTINGS FOR BUTTON b_Info1 IN FRAME d_addlink
   NO-ENABLE                                                            */
ASSIGN 
       b_Info1:HIDDEN IN FRAME d_addlink           = TRUE.

/* SETTINGS FOR BUTTON b_Info2 IN FRAME d_addlink
   NO-ENABLE                                                            */
ASSIGN 
       b_Info2:HIDDEN IN FRAME d_addlink           = TRUE.

/* SETTINGS FOR SELECTION-LIST s_linktype IN FRAME d_addlink
   NO-DISPLAY                                                           */
/* _RUN-TIME-ATTRIBUTES-END */

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME d_addlink
ON GO OF FRAME d_addlink /* Add a SmartLink */
DO:
  DEFINE VARIABLE rc          AS LOGICAL NO-UNDO.
  DEFINE VARIABLE choice      AS CHAR    NO-UNDO INITIAL "Cancel".
  DEFINE VARIABLE never-again AS LOGICAL NO-UNDO.
  DEFINE VARIABLE h_1stObj    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE h_2ndObj    AS HANDLE  NO-UNDO.
  
  DEFINE BUFFER x_U FOR _U.
  
  IF s_source:SCREEN-VALUE   <> ? AND
     s_linktype:SCREEN-VALUE <> ? AND
     s_dest:SCREEN-VALUE     <> ? THEN 
  DO:
    ASSIGN s_source s_linktype s_dest.
    /* Check for an invalid circular link!! */
    IF s_source = s_dest THEN DO:
      MESSAGE "You cannot create a circular link. Please make sure that the source and target are different."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN NO-APPLY.
    END.
    RUN Check_Link (s_source, s_dest, s_linktype, OUTPUT rc).
    IF rc THEN DO: /* Dup link */
      MESSAGE "This link already exists." VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
    END.
    ELSE DO: /* OK to make link, but check for reciprocal link first */
      RUN Check_Link (s_dest, s_source, s_linktype, OUTPUT rc).
      IF rc THEN DO: /* exists, confirm */
        RUN adeuib/_advisor.w (
          INPUT "This link already exists in the opposite direction.", 
          INPUT "Continue. Link them anyway.,Continue," + 
                "Cancel. Go back to SmartLink Editor.,Cancel",
          INPUT FALSE,
          INPUT "AB":U,
          INPUT {&Advisor_Link_Conflict},
          INPUT-OUTPUT choice,
          OUTPUT never-again). 
        CASE choice:
          WHEN "Cancel":U   THEN DO:
            s_dest:SCREEN-VALUE = "".
            RUN process-dest.
            RETURN NO-APPLY.
          END.
          WHEN "Continue":U THEN RUN Create_Link.
        END CASE.
      END.
      ELSE DO:
         FIND so WHERE so.name   = s_dest.

         /* WORK Check signature matching */
         ASSIGN link-possible = YES.
         IF admVersion >= "ADM2":U THEN
         DO:
            FIND so WHERE so.name   = s_dest.
            ASSIGN h_1stObj = so._S-HANDLE.
            FIND so WHERE so.name   = s_source.
            ASSIGN h_2ndObj = so._S-HANDLE.
           
            RUN ok-sig-match (INPUT h_1stObj, 
                              INPUT h_2ndObj, 
                              INPUT s_linktype, 
                              INPUT YES, 
                              OUTPUT link-possible,
                              OUTPUT c_errMsg).
            IF NOT link-possible THEN
               ASSIGN 
                  c_errMsg = "You are attempting to link two objects whose signatures do not match." + CHR(10) + c_errMsg. 
            ELSE
            DO:
               RUN ok-link (INPUT h_1stObj, 
                              INPUT h_2ndObj, 
                              INPUT s_linktype, 
                              INPUT YES, 
                              OUTPUT link-possible,
                              OUTPUT c_errMsg).
            IF NOT link-possible THEN
               ASSIGN 
                  c_errMsg = "Invalid Link. You are attempting to" + CHR(10) + c_errMsg. 
            END.
         END.

         IF NOT link-possible THEN 
         DO:
             RUN adeuib/_advisor.w (
              INPUT c_errMsg,
              INPUT "Continue. Link them anyway.,Continue," + 
                    "Cancel. Go back to SmartLink Editor.,Cancel",
              INPUT TRUE,
              INPUT "AB":U,
              INPUT {&Advisor_Link_Conflict},
              INPUT-OUTPUT choice,
              OUTPUT never-again). 

            /* Store the never again value */
            {&NA-Signature-Mismatch-advslnk} = never-again.

            CASE choice:
              WHEN "Cancel":U   THEN DO:
                s_dest:SCREEN-VALUE = "".
                RUN process-dest.
                RETURN NO-APPLY.
              END.
              WHEN "Continue":U THEN RUN Create_Link.
            END CASE.
         END. /* Signature Mismatch */
         ELSE
            RUN Create_Link. /* does not exist either way... */
      END.
    END.
  END.
  ELSE DO:
    MESSAGE "You must choose a source, link type and target to create a link."
         VIEW-AS ALERT-BOX ERROR BUTTONS OK.  
    RETURN NO-APPLY.
  END.
  
  /* If we have set a Record link, and if we need to set a Key-Name attribute
     in the target, then do it. */
  IF s_linktype eq "Record":U AND Key-Name-to-Set ne ? THEN DO:
    FIND so WHERE so.name   = s_dest.
   IF admVersion LT "ADM2":U THEN DO:
      RUN get-attribute IN so._S-HANDLE ('Key-Name':U).
      IF RETURN-VALUE ne Key-Name-to-Set 
      THEN RUN set-attribute-list IN so._S-HANDLE ('Key-Name=' + Key-Name-to-Set).
   END. /* ADM1 */
   ELSE DO:
      cValue = DYNAMIC-FUNCTION("getKeyName":U IN so._S-HANDLE) NO-ERROR.
      IF ERROR-STATUS:ERROR OR cValue ne Key-Name-to-Set 
      THEN lValue = DYNAMIC-FUNCTION("setKeyName":U IN so._S-HANDLE,Key-Name-to-Set) NO-ERROR.
   END. /* > ADM1 */
  END.
  
  /* Notify the UIB that something in this window changed. */
  RUN adeuib/_winsave.p (_P._WINDOW-HANDLE, FALSE). /* force save on window */
  
  /* Return YES -- user hit OK. */
  p_OK = yes.         
  
END.



&Scoped-define SELF-NAME b_ForeignFields
ON CHOOSE OF b_ForeignFields IN FRAME d_addlink /* Foreign Fields */
DO:  
  ASSIGN s_dest s_source.
  RUN ForeignFields (INPUT TRIM(s_dest:SCREEN-VALUE)
                    ,INPUT TRIM(s_source:SCREEN-VALUE)).
END.



&Scoped-define SELF-NAME b_Info1
ON CHOOSE OF b_Info1 IN FRAME d_addlink /* Info on Source */
DO:  
  RUN SmartInfo (INPUT TRIM(s_source:SCREEN-VALUE)).
END.



&Scoped-define SELF-NAME b_Info2
ON CHOOSE OF b_Info2 IN FRAME d_addlink /* Info on Target */
DO:
  RUN SmartInfo (INPUT TRIM(s_dest:SCREEN-VALUE)).
END.



&Scoped-define SELF-NAME s_dest
ON VALUE-CHANGED OF s_dest IN FRAME d_addlink
DO:
  DEFINE VARIABLE         stat        AS LOGICAL NO-UNDO.
  DEFINE VARIABLE         choice      AS CHAR    NO-UNDO INITIAL "Cancel".
  DEFINE VARIABLE         never-again AS LOGICAL NO-UNDO.
  
  /* Assign and process the current destination. */
  ASSIGN {&SELF-NAME}.
  RUN process-dest.

  /* Check for an invalid circular link!! */
  IF s_linktype:SCREEN-VALUE <> ? AND s_linktype:SCREEN-VALUE <> "" THEN 
  DO:
    IF s_source:SCREEN-VALUE = s_dest:SCREEN-VALUE THEN
    DO:
      MESSAGE "You cannot create a circular link. Please make sure that the source and target are different."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        s_dest:SCREEN-VALUE = "".
        RUN process-dest.
        RETURN NO-APPLY.
    END.  /* source = dest */
    IF s_linktype:SCREEN-VALUE <> "State" AND 
      NOT CAN-DO(CustomLinkTypes,s_linktype:SCREEN-VALUE) THEN
    DO:
      IF NOT CAN-DO(so.links,s_linktype:SCREEN-VALUE + "-TARGET") THEN
      DO:
        RUN adeuib/_advisor.w (
          INPUT SELF:SCREEN-VALUE + " is not configured to be a target for " + s_linktype:SCREEN-VALUE + ".", 
          INPUT "Continue. Link them anyway.,continue,Cancel. Go back to SmartLink Editor.,Cancel",
          INPUT FALSE,
          INPUT "AB",
          INPUT {&Advisor_Link_Conflict},
          INPUT-OUTPUT choice,
          OUTPUT never-again). 

        IF choice = "Cancel" THEN 
        DO:
          SELF:SCREEN-VALUE = "".
          RUN process-dest.
          APPLY "ENTRY" TO s_linktype.
          RETURN NO-APPLY.
        END. /* Cancel no link */
      END. /* no Target */
      IF s_linktype:SCREEN-VALUE = "Record" THEN
      DO:
        RUN Validate-Record-Link(OUTPUT stat).
        IF NOT stat THEN DO:
          SELF:SCREEN-VALUE = "".
          RUN process-dest.
          APPLY "ENTRY" TO s_linktype.        
          RETURN NO-APPLY.
        END.  /* Valid Record link */
      END. /* Record link */    
    END. /* Not state or custom link */
  END. /* link specified */
END. /* On value-changed of s_dest */



&Scoped-define SELF-NAME s_linktype
ON VALUE-CHANGED OF s_linktype IN FRAME d_addlink
DO:
  DEFINE VARIABLE         stat        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE         choice      AS CHAR      NO-UNDO INITIAL "Cancel".
  DEFINE VARIABLE         never-again AS LOGICAL   NO-UNDO.
  
  /* Check for an invalid circular link!! */
  IF s_source:SCREEN-VALUE = s_dest:SCREEN-VALUE THEN DO:
    MESSAGE "You cannot create a circular link. Please make sure that the source and target are different."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      s_linktype:SCREEN-VALUE = "".
      RETURN NO-APPLY.
  END. 
  
  /* Get the current value. */
  ASSIGN {&SELF-NAME}.  
  IF {&SELF-NAME} = "New..." THEN DO:
    RUN Create_LinkType(OUTPUT  {&SELF-NAME}).
    IF {&SELF-NAME}<> "" THEN DO:
        CustomLinkTypes = CustomLinkTypes + "," + {&SELF-NAME}.
        IF SUBSTRING(CustomLinkTypes,1,1,"CHARACTER") = "," THEN 
          CustomLinkTypes = SUBSTRING(CustomLinkTypes,2,-1,"CHARACTER").
        l = s_linktype:ADD-FIRST({&SELF-NAME}).
    END.
    s_linktype:SCREEN-VALUE = {&SELF-NAME}.
  END.
  ELSE IF s_dest:SCREEN-VALUE <> "" AND s_dest:SCREEN-VALUE <> ? THEN DO:
    IF SELF:SCREEN-VALUE <> "Data":U THEN 
    ASSIGN b_ForeignFields:HIDDEN = yes.

    IF SELF:SCREEN-VALUE = "Data":U THEN
    DO:
        FIND so WHERE so.name = s_dest:SCREEN-VALUE.
        FIND b-so WHERE b-so.name = s_source:SCREEN-VALUE.
        IF so.queryObject AND b-so.queryObject THEN
           ASSIGN b_ForeignFields:HIDDEN    = NO
                  b_ForeignFields:SENSITIVE = YES.
    END. /* Data link and object queries */
    ELSE IF SELF:SCREEN-VALUE <> "State" AND 
      NOT CAN-DO(CustomLinkTypes, {&SELF-NAME}) THEN
    DO:
      FIND so WHERE so.name = s_dest:SCREEN-VALUE.
      IF NOT CAN-DO(so.links, {&SELF-NAME} + "-TARGET") THEN
      DO:
        RUN adeuib/_advisor.w (
          INPUT s_dest:SCREEN-VALUE + " is not configured to be a target for " +  {&SELF-NAME} + ".", 
          INPUT "Continue. Link them anyway.,continue,Cancel. Go back to SmartLink Editor.,Cancel",
          INPUT FALSE,
          INPUT "AB",
          INPUT {&Advisor_Link_Conflict},
          INPUT-OUTPUT choice,
          OUTPUT never-again). 

        IF choice = "Cancel" THEN DO:
          SELF:SCREEN-VALUE = "".
          APPLY "ENTRY" TO s_linktype.
          RETURN NO-APPLY.
        END.
      END.
      IF SELF:SCREEN-VALUE = "Record":U THEN DO: 
        RUN Validate-Record-Link (OUTPUT stat).
        IF NOT stat THEN DO:
          SELF:SCREEN-VALUE = "".
          RETURN NO-APPLY.
        END.
      END.
    END. /* not 'state' or custom link type */
  END. 
END.



&Scoped-define SELF-NAME s_source
ON VALUE-CHANGED OF s_source IN FRAME d_addlink
DO:
  /* Change the linktypes displayed. */
  ASSIGN {&SELF-NAME}.
  RUN process-source.
END.



&UNDEFINE SELF-NAME



/* ***************************  Main Block  *************************** */
/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */

IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


{adecomm/commeng.i}
{adecomm/okbar.i &TOOL = "AB"
                 &CONTEXT = {&Add_SmartLink_Dlg_Box}}

{adeuib/_chkrlnk.i} /* routines to validate a record link between two objects */

/* Get the current Procedure. */
FIND _P WHERE RECID(_P) = p_Precid.
/* Determine admVersion - note that we only need to look at one 
* object since the window only contains same version objects */
ASSIGN admVersion = IF _P._adm-version LT "ADM2":U THEN 
                         "ADM1":U 
                    ELSE _P._adm-version.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN Init.
  RUN enable_UI.
  &SCOPED-DEFINE CANCEL-EVENT U2
  {adeuib/ide/dialogstart.i  btn_ok btn_cancel frametitle}
  &if DEFINED(IDE-IS-RUNNING) = 0 &then
      WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  &else
      WAIT-FOR GO OF FRAME {&FRAME-NAME} or "{&CANCEL-EVENT}" of this-procedure.
      if cancelDialog then 
          undo, leave.
  &endif
  
END.
RUN disable_UI.



/* **********************  Internal Procedures  *********************** */

PROCEDURE Check_Link :
/*------------------------------------------------------------------------------
  Purpose:     Checks to see if a link already exists
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER source   AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER dest     AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER linktype AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER rc       AS LOGICAL   NO-UNDO INITIAL no. /* yes = dup, no = ok */
  
  DEFINE BUFFER x_U FOR _U.
  
  DO WITH FRAME {&FRAME-NAME}:
    /* Find nadmlinks with source and target, then find corresponding
     * _admlinks to see if the same linktype selected. If all match, then
     * this is a duplicate link. Otherwise, create new nadmlinks and _admlinks
     * records. NOTE: If either or both widgets referenced in a existing link
     * is 'DELETED', we allow the creation of the new link since the new widget
     * has a different _U record.
     */
    FIND nadmlinks WHERE nadmlinks._source-name = source   AND
                         nadmlinks._target-name = dest     AND
                         nadmlinks._active      = TRUE       NO-ERROR.
    IF AVAILABLE nadmlinks THEN DO: /* see if same linktype in _admlinks */
      FIND _admlinks WHERE RECID(_admlinks) = nadmlinks._admlinks-recid 
                       AND RECID(_admlinks) ne p_Lrecid 
                     NO-ERROR.
      IF AVAILABLE _admlinks AND _admlinks._link-type = linktype THEN DO:
        FIND x_U WHERE RECID(x_U) = INTEGER(_admlinks._link-source) NO-ERROR.
        IF AVAILABLE (x_U) AND x_U._STATUS NE "DELETED" THEN DO:
          FIND x_U WHERE RECID(x_U) = INTEGER(_admlinks._link-dest) NO-ERROR.
          IF AVAILABLE (x_U) AND x_U._STATUS NE "DELETED" THEN DO:
            ASSIGN rc = yes. /* link already exists */
          END.
        END.
      END.
    END.
  END.
END PROCEDURE.


PROCEDURE Create_Link :
/* -----------------------------------------------------------
  Purpose:     Creates, or modifies, a link
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  /* Modify records in nadmlinks and _admlinks TTs. If these don't
     exist then create them.  */
  IF p_Lrecid ne ? THEN DO:
    FIND _admlinks WHERE RECID(_admlinks) eq p_Lrecid.
    FIND nadmlinks WHERE _admlinks-recid eq p_Lrecid.
  END.
  ELSE DO:
    CREATE nadmlinks.
    CREATE _admlinks.
    /* Tie them together and to the procedure.*/
    ASSIGN nadmlinks._admlinks-recid = RECID(_admlinks)
           _admlinks._P-recid        = RECID(_P).
  END.
  
  /* Assign the relevant information. */
  ASSIGN nadmlinks._source-name = s_source
         nadmlinks._target-name = s_dest 
         _admlinks._link-type   = s_linktype.
         
  FIND so WHERE so.name = s_source.
  ASSIGN _admlinks._link-source = STRING(so._U-recid).
  FIND so WHERE so.name = s_dest.
  ASSIGN _admlinks._link-dest   = STRING(so._U-recid).

END PROCEDURE.


PROCEDURE Create_LinkType :
/* -----------------------------------------------------------
  Purpose:     Create a new link type
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER linktype AS CHARACTER FORMAT "X(30)" 
      LABEL "Link Type" NO-UNDO.
  DEFINE BUTTON b_OK LABEL "OK" SIZE 10 BY 1 AUTO-GO.
  DEFINE BUTTON b_Cancel LABEL "Cancel" SIZE 10 BY 1 AUTO-ENDKEY.
  DEFINE BUTTON b_Help SIZE 10 BY 1 LABEL "&Help".
  DEFINE RECTANGLE r1 NO-FILL EDGE-PIXELS 2 SIZE 49 BY 1.6.  
  
  FORM linktype at row 1.5 col 3
    b_ok at row 3.5 col 4 b_cancel at row 3.5 col 15
    b_help at row 3.5 col 41 r1 at row 3.2 col 3
    WITH FRAME pt SIDE-LABELS 
    TITLE "New Link Type" THREE-D 
    &IF "{&WINDOW-SYSTEM}" EQ "OSF/MOTIF" &THEN
      SIZE 52 BY 4.2
    &ELSE
      SIZE 54 BY 5.6
    &ENDIF
    VIEW-AS DIALOG-BOX DEFAULT-BUTTON b_OK.

  ON GO OF FRAME pt DO:
      IF linktype:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Please enter a link type." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
      END.
      ELSE 
        IF CAN-DO(CustomLinkTypes,linktype:SCREEN-VALUE) THEN DO:
          MESSAGE "This custom link type already exists!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          RETURN NO-APPLY.
      END.       
      ASSIGN linktype = TRIM(linktype:SCREEN-VALUE).
  END.

  ON HELP OF FRAME pt OR CHOOSE OF b_help
  DO:
     RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&Help_on_Links}, ? ).
  END.

  ON ENDKEY,END-ERROR OF FRAME pt DO:
      ASSIGN linktype = "".
  END.
  
  ENABLE ALL WITH FRAME pt.
  WAIT-FOR GO OF FRAME pt.
  
END PROCEDURE.


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
  HIDE FRAME d_addlink.
END PROCEDURE.


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
  DISPLAY s_source s_dest 
      WITH FRAME d_addlink.
  ENABLE s_source s_linktype s_dest r_linkadd 
      WITH FRAME d_addlink.
  {&OPEN-BROWSERS-IN-QUERY-d_addlink}
END PROCEDURE.


PROCEDURE ForeignFields :
/*------------------------------------------------------------------------------
  WORK
  Purpose:     Get Foreign Fields for this object.
  Parameters:  source, link, target
  Notes: Find the related _S records to get the object handles.
         Pass the information onto mfldmap      
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_dest     AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_source   AS CHARACTER NO-UNDO.

  /* Local Variables */
  DEFINE VARIABLE h_dest            AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE h_source          AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE result            AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE dest_TblList      AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE lValue            AS LOGICAL       NO-UNDO.

  FIND FIRST so WHERE so.name = p_dest   NO-ERROR.
  IF AVAILABLE so AND so.queryObject THEN h_dest = so._S-HANDLE.
                                     ELSE h_dest = ?.
  IF VALID-HANDLE(h_dest) THEN
  DO:
     FIND FIRST so   WHERE so.name = p_source   NO-ERROR.
     IF AVAILABLE so AND so.queryObject THEN h_source = so._S-HANDLE.
                                        ELSE h_source = ?.
  END. /* First handle ok */

     IF VALID-HANDLE(h_dest) AND VALID-HANDLE(h_source) THEN
     DO:
            RUN createObjects IN h_dest NO-ERROR.
            ERROR-STATUS:ERROR = NO.
            ASSIGN 
                result = DYNAMIC-FUNCTION("getForeignFields":U IN h_dest) NO-ERROR.
            
            RUN adecomm/_mfldmap.p 
               (INPUT p_dest,
                INPUT p_source,
                INPUT h_dest,
                INPUT h_source,
                INPUT ?,
                INPUT IF _suppress_dbname THEN "2":U ELSE "3":U,
                INPUT ",":U,
                INPUT-OUTPUT result).
            ASSIGN 
                lValue = DYNAMIC-FUNCTION("setForeignFields":U IN h_dest, result) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN 
                MESSAGE "Could not set the Foreign Field Keys." VIEW-AS ALERT-BOX.
     END. /* both are valid handles */
END PROCEDURE. /* ForeignFields */


PROCEDURE SmartInfo :
/*------------------------------------------------------------------------------
  Purpose:     Get SmartInfo on this object.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER obj AS CHARACTER NO-UNDO.
  
  DEFINE BUFFER x_U  FOR _U.
  DEFINE BUFFER x_S  FOR _S.
  
  FIND so WHERE so.name = obj.
  IF admVersion LT "ADM2":U THEN
     RUN adm/support/_so-info.w (so._S-HANDLE,"":U).
  ELSE /* ADM1 */
     RUN adm2/support/_so-info.w (so._S-HANDLE,"":U).
  
END PROCEDURE.


PROCEDURE Init :
/* --------------------------------------------------------------------
  Purpose:     Initialize the dialog
  Parameters:  <none>
  Notes:       
   -------------------------------------------------------------------- */
  DEFINE VARIABLE pos AS INTEGER NO-UNDO.
  
  /* Change the title of the window if appropriate */
  &if DEFINED(IDE-IS-RUNNING) = 0 &then
  ASSIGN FRAME d_addlink:TITLE = IF p_Lrecid = ? THEN 
                     "Add a SmartLink"
                  ELSE 
                     "Modify a SmartLink".
  &else
  frametitle = IF p_Lrecid = ? THEN 
                     "Add a SmartLink"
                  ELSE 
                     "Modify a SmartLink".
  &endif                                      

  /* Add object names from 'so' T-T */
  FOR EACH SO WHERE so.active:
    ASSIGN
      l = s_source:ADD-LAST(so.name) IN FRAME {&FRAME-NAME}
      l = s_dest:ADD-LAST(so.name)   IN FRAME {&FRAME-NAME}.
  END.
  /* Insert any custom linktypes into the list */
  FOR EACH _admlinks WHERE _P-recid = RECID(_P):
    IF NOT CAN-DO("Navigation,Page,State,TableIO,Record,Data,Update,GroupAssign,Commit",_admlinks._link-type) THEN
      CustomLinkTypes = CustomLinkTypes + "," + _admlinks._link-type.
  END.
  IF CustomLinkTypes <> "" THEN
    CustomLinkTypes = SUBSTRING(CustomLinkTypes,2,-1,"CHARACTER"). /* leading , */
    
  /* If there is an existing link, then initialize the lists appropriately. */
  IF p_Lrecid ne ? THEN DO:
    FIND _admlinks WHERE RECID(_admlinks) eq p_Lrecid.
    FIND nadmlinks WHERE _admlinks-recid eq p_Lrecid.
    ASSIGN s_source   = nadmlinks._source-name 
           s_dest     = nadmlinks._target-name 
           s_linktype = _admlinks._link-type.
    RUN process-source.
    RUN process-dest.
  END.

END PROCEDURE.


PROCEDURE process-dest :
/*------------------------------------------------------------------------------
  Purpose:     Change the display based on the value of the link destination.  
      Note that the Foreign Fields button will display ONLY IF
         dest=Query Object, source=Query Objects, link-type=Data 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dash      AS INTEGER NO-UNDO.
  DEFINE VARIABLE stdtxtwid AS DECIMAL NO-UNDO.
  DEFINE VARIABLE objtxtwid AS DECIMAL NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    
    FIND so WHERE so.name = s_dest NO-ERROR.
    IF NOT AVAILABLE so THEN
    DO:
      ASSIGN b_Info2:HIDDEN = yes
             b_ForeignFields:HIDDEN = yes.
      RETURN.
    END. /* no s_dest */

    IF so.type = "SmartContainer":U THEN 
      ASSIGN b_Info2:HIDDEN = yes
             b_ForeignFields:HIDDEN = yes.
    ELSE DO:
      ASSIGN b_Info2:HIDDEN    = no
             b_Info2:SENSITIVE = yes.

      FIND b-so WHERE b-so.name = s_source NO-ERROR.
      /* Check to see if we should enable the Foreign Fields button
       * QueryObject DataLink QueryObject
       */
      IF     AVAILABLE b-so 
         AND so.queryObject 
         AND b-so.queryObject 
         AND s_linktype:SCREEN-VALUE = "Data":U THEN
        ASSIGN b_ForeignFields:HIDDEN = no
               b_ForeignFields:SENSITIVE = yes.
      ELSE 
        ASSIGN b_ForeignFields:HIDDEN = yes.
    END.
  END.
END PROCEDURE.


PROCEDURE process-source :
/*------------------------------------------------------------------------------
  Purpose:     Change the display based on the value of the link source.  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cnt       AS INTEGER NO-UNDO.
  DEFINE VARIABLE dash      AS INTEGER NO-UNDO.
  DEFINE VARIABLE link-name AS CHAR    NO-UNDO.
  DEFINE VARIABLE stdtxtwid AS DECIMAL NO-UNDO.
  DEFINE VARIABLE objtxtwid AS DECIMAL NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:    

    FIND so WHERE so.name = s_source NO-ERROR.
    IF NOT AVAILABLE so THEN 
    DO:
       ASSIGN b_ForeignFields:HIDDEN = YES
              b_Info1:HIDDEN = YES.
       RETURN.
    END. /* no source */

    ASSIGN s_linktype:LIST-ITEMS = ""
           cnt = NUM-ENTRIES (so.links).
    /* Load up linktype list with allowable 'SOURCE' links */
    DO i = 1 TO cnt:
      dash = R-INDEX (ENTRY(i,so.links), "-" ). /* Can have many dashes in name */
      IF dash NE 0 THEN DO:
        link-name = SUBSTRING(ENTRY(i,so.links),1,dash - 1,"CHARACTER":U).
        IF SUBSTRING(ENTRY(i,so.links), dash + 1, -1, "CHARACTER":U) = "SOURCE":U
           AND s_linktype:LOOKUP(link-name) < 1 
        THEN l = s_linktype:ADD-LAST(link-name). 
      END.
    END.

    /* Only Add state link if admVersion 8 */
    IF admVersion LT "ADM2":U THEN
       l = s_linktype:ADD-LAST("State":U). /* Can always have a 'state' link */ 

    /* Add any custom type-types */
    cnt = NUM-ENTRIES (CustomLinkTypes).
    DO i = 1 TO cnt:
      link-name = ENTRY(i,CustomLinkTypes).
      IF s_linktype:LOOKUP(link-name) < 1 THEN 
      l = s_linktype:ADD-LAST(link-name). 
    END.
    l = s_linktype:ADD-LAST("New..."). /* Opportunity to create a custom linktype */ 
    IF so.type = "SmartContainer":U THEN 
      ASSIGN b_Info1:HIDDEN = yes
             b_ForeignFields:HIDDEN = yes.
    ELSE DO:
      ASSIGN b_Info1:HIDDEN    = no
             b_Info1:SENSITIVE = yes.

      /* Check to see if we should enable the Foreign Fields button
       * QueryObject DataLink QueryObject
       */
      FIND b-so WHERE b-so.name = s_dest NO-ERROR.
      IF     AVAILABLE b-so 
         AND so.queryObject 
         AND b-so.queryObject 
         AND s_linktype:SCREEN-VALUE = "Data":U THEN
        ASSIGN b_ForeignFields:HIDDEN = no
               b_ForeignFields:SENSITIVE = yes.
      ELSE 
        ASSIGN b_ForeignFields:HIDDEN = yes.
    END.         
    /* Try to display the current link type, if it is supported. */
    IF s_linktype:LOOKUP(s_linktype) eq 0 
    THEN s_linktype = "".
    ELSE s_linktype:SCREEN-VALUE = s_linktype.
    
  END.
END PROCEDURE.


PROCEDURE Validate-Record-Link :
/*------------------------------------------------------------------------------
  Purpose:     Check to see if src and dest can have a record link.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER p_stat    AS LOGICAL NO-UNDO.
  
  DEFINE VAR msg               AS CHAR NO-UNDO.
  DEFINE VAR choice            AS CHAR NO-UNDO.
  DEFINE VAR h_target          AS HANDLE NO-UNDO.
  DEFINE VAR i                 AS INTEGER NO-UNDO.

  DEFINE VAR keys-possible     AS CHAR NO-UNDO.
     
  DEFINE VAR never-again       AS LOGICAL NO-UNDO.
  DEFINE VAR source-ext-tables AS CHAR NO-UNDO.
  DEFINE VAR source-int-tables AS CHAR NO-UNDO.
  DEFINE VAR source-all-tables AS CHAR NO-UNDO.
  DEFINE VAR source-keys-sup   AS CHAR NO-UNDO.
  DEFINE VAR target-key-name   AS CHAR NO-UNDO.
  DEFINE VAR target-keys-acc   AS CHAR NO-UNDO.
  DEFINE VAR target-ext-tables AS CHAR NO-UNDO.
 
  /* Assume record links to, or from, THIS-PROCEDURE are OK. */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN s_source s_dest.  
    IF s_source eq "THIS-PROCEDURE":U OR s_dest eq "THIS-PROCEDURE" THEN DO:
      p_stat = yes.
      RETURN.
    END.
  END.
  
  /* Figure out the Key-Name-to-Set within this procedure.  We will
     DELAY setting the key-name until the dialog-box is actually saved. */
  key-name-to-set = ?.
  
  /* Otherwise, check the actual SmartObjects. */
  FIND so WHERE so.name     = s_source.

  /* Determine admVersion */
  {adeuib/admver.i so._S-HANDLE admVersion}.

  IF admVersion LT "ADM2":U THEN DO:
     RUN get-attribute IN so._S-HANDLE ('Keys-Supplied':U).
     source-keys-sup = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
     RUN get-attribute IN so._S-HANDLE ('External-Tables':U).
     source-ext-tables = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
     RUN get-attribute IN so._S-HANDLE ('Internal-Tables':U).
     source-int-tables = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
  END. /* ADM1 */
  ELSE DO:
     cValue = DYNAMIC-FUNCTION("getKeysSupplied":U IN so._S-HANDLE) NO-ERROR.
     source-keys-sup = IF ERROR-STATUS:ERROR OR cValue eq ? THEN "":U ELSE cValue.
     source-ext-tables = "".
     cValue = DYNAMIC-FUNCTION("getInternalTables":U IN so._S-HANDLE) NO-ERROR.
     source-int-tables = IF ERROR-STATUS:ERROR OR cValue eq ? THEN "":U ELSE cValue.
  END. /* > ADM1 */

  /* The source can supply records from both internal and external tables. */
  source-all-tables = source-int-tables +
                      (IF source-int-tables ne "":U AND source-ext-tables ne "":U THEN ",":U ELSE "":U) +
                      source-ext-tables.

  FIND so WHERE so.name     = s_dest.
  h_target = so._S-HANDLE.

  /* Determine admVersion */
  {adeuib/admver.i h_target admVersion}.

  IF admVersion LT "ADM2":U THEN DO:
     RUN get-attribute IN h_target ('Key-Name':U).
     target-key-name = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
     RUN get-attribute IN h_target ('Keys-Accepted':U).
     target-keys-acc = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
     RUN get-attribute IN h_target ('External-Tables':U).
     target-ext-tables = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
  END. /* ADM1 */
  ELSE DO:
     cValue = DYNAMIC-FUNCTION("getKeyName":U IN h_target) NO-ERROR.
     target-key-name = IF ERROR-STATUS:ERROR OR cValue eq ? THEN "":U ELSE cValue.
     cValue = DYNAMIC-FUNCTION("getKeysAccepted":U IN h_target) NO-ERROR.
     target-keys-acc = IF ERROR-STATUS:ERROR OR cValue eq ? THEN "":U ELSE cValue.
     target-ext-tables = "".
  END. /* > ADM1 */
  
  /* If there are external tables, then use these. */
  IF target-ext-tables ne "" THEN DO:
    RUN ok-table-source (INPUT  source-int-tables, source-ext-tables,
                         INPUT  target-ext-tables,
                         OUTPUT p_stat).
    /* Remove any KEY-NAME attribute */
    IF target-key-name ne "" THEN key-name-to-set = "".
  END. 
  
  /* Should we test KEYS? */
  IF p_stat eq NO AND target-keys-acc ne "" THEN DO:
    RUN ok-key-source (INPUT  source-keys-sup, target-keys-acc,
                       OUTPUT keys-possible).
    CASE NUM-ENTRIES(keys-possible):
      WHEN 0 THEN ASSIGN p_stat          = NO.
      WHEN 1 THEN ASSIGN p_stat          = YES
                         key-name-to-set = keys-possible.
      OTHERWISE DO:
        /* Assume the current choice.  Optionally ask the user if they 
           want to change. */
        IF CAN-DO(keys-possible, target-key-name) 
        THEN choice = target-key-name.
        ELSE choice = ENTRY(1, keys-possible).
        /* Should we ask if there are multiple key choices? */
        IF NOT {&NA-Key-Choice-advslnk} THEN DO:
          /* Double up each entry in keys-possible and use the advisor to
             ask the user which entry should be used.  */
          msg = keys-possible.
          DO i = NUM-ENTRIES(msg) TO 1 BY -1:
            ENTRY(i,msg) = ENTRY(i, msg) + ",":U + ENTRY(i, msg).
          END.
          RUN adeuib/_advisor.w (
                  INPUT "Which foreign key should be used for this Record link?", 
                  INPUT msg + ",Cancel. Go back to SmartLink Editor.,Cancel",
                  INPUT yes,
                  INPUT "AB",
                  INPUT {&Advisor_Choose_Key_on_Add},
                  INPUT-OUTPUT choice,
                  OUTPUT {&NA-Key-Choice-advslnk}). 
          IF choice eq "Cancel":U THEN RETURN.
        END. /* IF NOT...key-choice... */
        ASSIGN p_stat = yes
               key-name-to-set = choice.
      END. /* OTHERWISE...*/
    END CASE.
  END.       
  /* Report any error. */         
  IF NOT p_stat THEN DO ON ERROR UNDO, LEAVE:
    choice = "Cancel":U.
    /* Report the situation where neither keys nor a traditional record link would work. That is, there
       are no keys that the target accepts, and there are no tables that will work because either the source
       or the target does not supply tables. */
    IF target-keys-acc eq "" AND (target-ext-tables = "" OR source-all-tables  = "") THEN DO:   
      ASSIGN msg = (IF target-ext-tables = "" THEN s_dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
                                                   " does not expect records from any table." + CHR(10)
                                              ELSE s_dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
                                                   " needs records from:" + CHR(10) + "  " +
                                                   REPLACE(target-ext-tables,",", CHR(10) + "  ") + CHR(10)) +                                 
                   (IF source-all-tables = "" THEN s_source:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
                                                   " cannot supply records from any table." + CHR(10)
                                              ELSE s_source:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
                                                   " supplies records from:" + CHR(10) + "  " +
                                                   REPLACE(source-all-tables,",", CHR(10) + "  ") + CHR(10) + CHR(10)). 
      IF target-ext-tables = "" AND source-all-tables  NE "" THEN
        msg = msg + s_dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " must define " 
                  + source-all-tables + " as" 
                  + (IF NUM-ENTRIES(source-all-tables) > 1 THEN " external tables." ELSE " an external table.").
      ELSE IF target-ext-tables NE "" AND source-all-tables  EQ ""   THEN
        msg = msg + s_source:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " should supply records from " + target-ext-tables.
      ELSE msg = msg +  s_source:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " does not supply all the information that " 
                     + s_dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " needs.". 
      RUN adeuib/_advisor.w (
        INPUT msg, 
        INPUT "Continue. Link them anyway.,Continue," + 
              "Cancel. Go back to SmartLink Editor.,Cancel",
        INPUT FALSE,
        INPUT "AB",
        INPUT {&Advisor_Link_Conflict},
        INPUT-OUTPUT choice,
        OUTPUT never-again). 
      CASE choice:
        WHEN "Cancel":U   THEN.
        WHEN "Continue":U THEN p_stat = yes.
      END CASE.
    END. /* IF...keys-acc eq "" AND (...ext-tables = "" OR ...all-tables  = "") THEN DO...*/
    ELSE DO:  
      /* If there are external-tables, then use them. */
      IF target-ext-tables ne ""                          
      THEN msg = s_dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
                 " needs records from:" + CHR(10) + "  " +
                 REPLACE(target-ext-tables,",", CHR(10) + "  ") + CHR(10) +                                 
                 s_source:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
                 " supplies records from:" + CHR(10) + "  " +
                 REPLACE(source-all-tables,",", CHR(10) + "  ") + CHR(10) + CHR(10) +
                 s_source:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " does not supply all the information that " 
                 + s_dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " needs.".                                
      ELSE msg = s_dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
                 " can accept one of these keys:" + CHR(10) + "  " +
                 REPLACE(target-keys-acc,",", CHR(10) + "  ") + CHR(10) +                                 
                 "However, " + s_source:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
                 " can only supply the following:" + CHR(10) + "  " +
                 REPLACE(source-keys-sup,",", CHR(10) + "  ") + CHR(10) + CHR(10) +
                 s_source:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " does not supply any of the foreign keys that " 
                 + s_dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " is looking for.".                                
      RUN adeuib/_advisor.w (
        INPUT msg, 
        INPUT "Help. Tell me the right way to do this.,Help," +
              "Continue. Ignore mismatch and link them anyway.,Continue," + 
              "Cancel. Go back to SmartLink Editor.,Cancel",
        INPUT FALSE,
        INPUT "AB",
        INPUT {&Advisor_No_SmQuery},
        INPUT-OUTPUT choice,
        OUTPUT never-again). 
      CASE choice:
        WHEN "Help":U THEN
          RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&Advisor_No_SmQuery}, ?).  
        WHEN "Continue":U THEN p_stat = yes.
        WHEN "Cancel":U   THEN.
      END CASE.
    END.  /* IF target-ext-tables = "" OR source-all-tables  = "" ...ELSE DO...*/
  END. /* IF p_stat eq no...*/    
END PROCEDURE.


