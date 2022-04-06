/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* brsleave.i - trigger code for ROW-LEAVE trigger of SmartBrowse*/
/* If the object selected is not a SmartPanel button 
   (which could be e.g. Cancel or Reset), then save any changes to the row. 
   Otherwise let the button take the appropriate action. */
DEFINE VARIABLE widget-enter  AS HANDLE NO-UNDO.
DEFINE VARIABLE widget-frame  AS HANDLE NO-UNDO.
DEFINE VARIABLE widget-parent AS HANDLE NO-UNDO.
  /* If the object has a valid frame attribute, see if it's a SmartPanel. */
  widget-enter = last-event:widget-enter.
  IF VALID-HANDLE(widget-enter) THEN widget-parent = widget-enter:PARENT.
  IF VALID-HANDLE(widget-parent) AND widget-parent:TYPE NE "BROWSE":U
    THEN widget-frame = widget-enter:FRAME.  /* Can't check FRAME on Brs flds */

  IF ((NOT VALID-HANDLE(widget-enter)) OR  /* Some events don't go to a widget*/
      (widget-parent:TYPE = "BROWSE":U) OR /* Clicked elsewhere in the Browser*/
      (NOT VALID-HANDLE(widget-frame)) OR  /* Check parent Frame if present */
      (NOT CAN-DO(widget-frame:PRIVATE-DATA, "ADM-PANEL":U))) /*SmartPanel?*/
  THEN DO:                                 /* If not a SmartPanel then do upd */

      IF adm-brs-in-update THEN    
      DO:
        MESSAGE 
        "You must complete or cancel the update before leaving the current row."
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
      END.
      /* If they selected some other object or the LEAVE was initiated 
         from outside then check before continuing. Otherwise just save. 
         If they were adding a new record and didn't change any initial values,
         make sure that gets Saved as well. */
      IF {&BROWSE-NAME}:CURRENT-ROW-MODIFIED  OR 
        (adm-new-record AND BROWSE {&BROWSE-NAME}:NUM-SELECTED-ROWS = 1) THEN
      DO:
        IF VALID-HANDLE (widget-parent) AND widget-parent:TYPE NE "BROWSE":U
        THEN DO:
          MESSAGE 
          "Current record has been changed. " SKIP
          "Do you wish to save those changes?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-save AS LOGICAL.
          IF l-save THEN
          DO:
             RUN dispatch('update-record':U).
             IF RETURN-VALUE = "ADM-ERROR":U THEN 
                 RETURN NO-APPLY.
          END.
          ELSE RUN dispatch ('cancel-record':U).
        END. 
        ELSE DO:
          RUN dispatch('update-record':U).
          IF RETURN-VALUE = "ADM-ERROR":U THEN 
              RETURN NO-APPLY.
        END.
      END.
  END.
