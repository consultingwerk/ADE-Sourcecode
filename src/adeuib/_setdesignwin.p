/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: adeuib/_setdesignwin.p

Description: Sets certain properties of an AB design window to support ICF.

Input Parameters:  pRecId - _P recid of design-time window.

Output Parameters: <None>

Author: John Palazzo

Date Created: 08/20/01

History:      10/10/01 jep-icf IZ 2101 Run button enabled when editing dynamic objects.
                       Added persistent triggers to "do nothing" when menu accel
                       keys fire for dynamic object windows.
----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pRecId AS RECID NO-UNDO.

{adeuib/uniwidg.i}
{adeuib/sharvars.i}
{adeuib/custwidg.i}  /* Define Palette-Items (and their images) */

DEFINE VARIABLE ldummy        AS LOGICAL NO-UNDO.
DEFINE VARIABLE h             as widget  no-undo.
DEFINE VARIABLE h_frame       as widget  no-undo.
DEFINE VARIABLE cWinTitle     AS CHARACTER  NO-UNDO.

DEFINE BUFFER local_P FOR _P.
DEFINE BUFFER local_U FOR _U.

DO ON ERROR UNDO, LEAVE:

    FIND local_P  WHERE RECID(local_P)  = pRecid.
    FIND local_U  WHERE local_U._HANDLE = local_P._WINDOW-HANDLE.
    
    /* create a frame and an image in the frame. 
       This will be the widget that the UIB uses to reference the object. 
       Use the image itself as the visualization within the UIB. */
    CREATE FRAME h_frame ASSIGN
           HEIGHT-P   = {&ImageSize} - 2
           WIDTH-P    = {&ImageSize} - 2
           ROW        = 1.14
           COLUMN     = 2.60
           HIDDEN     = YES
           OVERLAY    = YES
           BOX        = NO
           BGCOLOR    = 8
           SCROLLABLE = NO
         TRIGGERS:
    /*          {adeuib/std_trig.i} */
            /* IZ 2101 - Do "nothing" when disabled accel keys fire. */
            /* ***************** File Menu ********************* */
            ON SHIFT-F6 PERSISTENT RUN doNothing IN _h_menubar_proc. /* Save As       */
            /* ***************** Compile Menu ****************** */
            ON GO       PERSISTENT RUN doNothing IN _h_menubar_proc. /* Run           */
            ON Shift-F2 PERSISTENT RUN doNothing IN _h_menubar_proc. /* Check Syntax  */
            ON SHIFT-F4 PERSISTENT RUN doNothing IN _h_menubar_proc. /* Debug         */
            ON CTRL-F2  PERSISTENT RUN runDynamicRunLauncher IN _h_menubar_proc. /* Dynamic Launch */
            ON F5       PERSISTENT RUN doNothing IN _h_menubar_proc. /* Code Preview  */
            /* ****************** Tools Menu ******************* */
            ON CTRL-W   PERSISTENT RUN doNothing IN _h_menubar_proc. /* List Objects  */
            /* ****************** Window Menu ******************* */
            ON CTRL-S   PERSISTENT RUN doNothing IN _h_menubar_proc. /* Code Edit     */
         END TRIGGERS.

    /* jep-icf-temp: The image does not respond to double-clicks. I need to use
       std_trig.i or a variation of it. Will fix via an issue later. */
    
    IF local_U._TYPE eq "WINDOW" THEN 
      h_frame:PARENT = local_U._HANDLE.
    ELSE 
      h_frame:FRAME  = local_U._HANDLE.
           
    /* Place object within parent's boundaries. */
    {adeuib/onframe.i
       &_whFrameHandle = "local_U._HANDLE"
       &_whObjHandle   = "h_frame"
       &_lvHidden      = YES }
    
    
    /* Create a "visualization" image on the object. */
    CREATE IMAGE h ASSIGN
           FRAME        = h_frame
           X            = 0
           Y            = 0
           HEIGHT-P     = {&ImageSize} - 2 
           WIDTH-P      = {&ImageSize} - 2
           HIDDEN       = false
           .
    
    /* The image name is stored in _P record. Otherwise, just use a default icon. */
    ASSIGN ldummy = h:LOAD-IMAGE (local_P.design_image_file) NO-ERROR.
    IF NOT ldummy THEN
    ASSIGN ldummy = h:LOAD-IMAGE ("adeicon/smartobj", 1, 1, {&ImageSize} - 2, {&ImageSize} - 2).
    
    /* Make the visualization visible. */
    h_frame:VISIBLE = YES NO-ERROR.

    /* Reformat the window title  IZ 6665 */
    IF local_P.static_object = NO AND local_P.container_object = YES THEN DO:
      IF local_P._desc NE "":U THEN DO:
        cWinTitle = ENTRY(1, local_P._desc, "(":U) + "(":U + local_P.object_type_code + ")":U.
        RUN adeuib/_wintitl.p (local_P._WINDOW-HANDLE, cWinTitle, ? , local_P._SAVE-AS-FILE).
      END.         
    END.  /* If a dynamic container */

END. /* DO ON ERROR */
  
RETURN.
