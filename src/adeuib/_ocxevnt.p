/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _ocxevnt.p

Description:
    Perform the following:
      - Return comma-delimited list of OCX Control Event Names or
      - Return comma-delimited list of Event "Mode Name Type" Parameters.

Input Parameters:
   p_hWidget    - Widget handle of the control-frame.

   p_EventName  - Event name whose Parameters info is to be returned.

Output Parameters:
   p_List - If p_EventName is null, return event name list with OCX prepended
            to each event name. This distinguishes them from Progress widget
            events. E.g., "OCX.ClickDown,OCX.ClickUp"
            
            If p_EventName <> null, return delimited list of
            parameters and param info. E.g., "Mode Name Datatype,Mode Name Datatype"

Author  : John Palazzo
Created : 14 Jan 1997
Modified: 03 Feb 1997

---------------------------------------------------------------------------- */
{adeuib/sharvars.i}

DEFINE INPUT  PARAMETER p_hWidget   AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p_EventName AS CHARACTER     NO-UNDO.
DEFINE OUTPUT PARAMETER p_List      AS CHARACTER     NO-UNDO INITIAL "".

DEFINE VAR hdlColl  AS COM-HANDLE NO-UNDO.
DEFINE VAR ch       AS COM-HANDLE NO-UNDO.
DEFINE VAR ch2      AS COM-HANDLE NO-UNDO.
DEFINE VAR ch3      AS COM-HANDLE NO-UNDO.
DEFINE VAR ch4      AS COM-HANDLE NO-UNDO.
DEFINE VAR ICount   AS INTEGER    NO-UNDO.
DEFINE VAR JCount   AS INTEGER    NO-UNDO.

DO ON STOP UNDO, LEAVE:

    SET ch = p_hWidget:COM-HANDLE.
    SET hdlColl = ch:Controls.

    /* In 8.2A, Controls and Control-Frame are 1-to-1. This will need
       modification to accept which control to return event names after
       8.2A. */
    SET ch = hdlColl:Item(1).
    RELEASE OBJECT hdlColl.
    
    /* Get Collection Handle to the Control's Events. */
    SET ch = _h_controls:GetControlEvents(ch).

    IF (p_EventName = "") THEN
      RUN GetEvents.
    ELSE
      RUN GetParameters.
END. /* DO ON STOP */

PROCEDURE GetEvents.
/* Create the comma-delimited list of event names. */
      
  REPEAT ICount = 1 TO ch:Count:
    SET ch2 = ch:Item(ICount).
    SET p_List = p_List + "," + "{&WT-CONTROL}.":U + ch2:Name.
    RELEASE OBJECT ch2.
  END.
  RELEASE OBJECT ch.

  /* Ensure there are no trailing delimiters. */
  SET p_List = TRIM( p_List , ",").

END PROCEDURE.

PROCEDURE GetParameters.
/* Build comma-delimited list of "Mode Name Type, Mode Name Type,..." parameter items. */
      
  REPEAT ICount = 1 TO ch:Count:
    SET ch2 = ch:Item(ICount).
    IF (p_EventName <> ch2:Name) THEN
    DO:
      RELEASE OBJECT ch2.
      NEXT.
    END.    

    SET ch3 = ch2:Parameters.
    REPEAT JCount = 1 TO ch3:Count:
      SET ch4 = ch3:Item(JCount).
      SET p_List = p_List + "," + ch4:Mode + " " + ch4:Name + " " + ch4:Type.
      RELEASE OBJECT ch4.
    END.
    RELEASE OBJECT ch3.
    RELEASE OBJECT ch2.
    LEAVE.
  END.
  RELEASE OBJECT ch.

  /* Ensure there are no trailing delimiters. */
  SET p_List = TRIM( p_List, ",").

END PROCEDURE.
