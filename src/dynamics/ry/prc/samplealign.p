/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
&GLOBAL-DEFINE g_supported_side_labels "FILL-IN,TEXT,COMBO-BOX":U


/* ON CHOOSE OF MENU-ITEM m_align_side_labels /* Align any side-labels along the selection frame's left side */ */
/* DO:                                                                                                          */
/*    DEFINE VARIABLE i_widget AS WIDGET-HANDLE NO-UNDO.                                                        */
/*    DEFINE VARIABLE i_label AS WIDGET-HANDLE NO-UNDO.                                                         */
/*    DEFINE VARIABLE i_private_data AS CHARACTER NO-UNDO.                                                      */
/*    DEFINE VARIABLE i_inx as INTEGER NO-UNDO.                                                                 */
/*    DEFINE VARIABLE i_x_min AS INTEGER NO-UNDO INITIAL 29999.                                                 */
/*                                                                                                              */
/*    DO i_inx = 1 TO i_target_frame:NUM-SELECTED-WIDGETS:                                                      */
/*       i_widget = i_target_frame:GET-SELECTED-WIDGET(i_inx).                                                  */
/*                                                                                                              */
/*       IF i_widget:PRIVATE-DATA = "|SIDELABEL":U                                                              */
/*       OR i_widget:PRIVATE-DATA = "|BOXLABEL":U THEN                                                          */
/*          NEXT.                                                                                               */
/*                                                                                                              */
/*       IF  LOOKUP(i_widget:TYPE, {&g_supported_side_labels}) > 0                                              */
/*       AND VALID-HANDLE(i_widget:SIDE-LABEL-HANDLE)                                                           */
/*       AND LOOKUP(ENTRY({&g_label_pos}, i_widget:PRIVATE-DATA, "|":U), "^,#":U) < 1 THEN                      */
/*       DO:                                                                                                    */
/*          i_label = i_widget:SIDE-LABEL-HANDLE.                                                               */
/*          IF i_label:X < i_x_min THEN                                                                         */
/*             i_x_min = i_label:X.                                                                             */
/*          NEXT.                                                                                               */
/*       END.                                                                                                   */
/*                                                                                                              */
/*       IF i_widget:X < i_x_min THEN                                                                           */
/*          i_x_min = i_widget:X.                                                                               */
/*    END.                                                                                                      */
/*                                                                                                              */
/*    DO i_inx = 1 TO i_target_frame:NUM-SELECTED-WIDGETS:                                                      */
/*       i_widget = i_target_frame:GET-SELECTED-WIDGET(i_inx).                                                  */
/*                                                                                                              */
/*       IF i_widget:PRIVATE-DATA = "|SIDELABEL":U                                                              */
/*       OR i_widget:PRIVATE-DATA = "|BOXLABEL":U                                                               */
/*       OR LOOKUP(i_widget:TYPE, {&g_supported_side_labels}) < 1                                               */
/*       OR NOT VALID-HANDLE(i_widget:SIDE-LABEL-HANDLE)                                                        */
/*       OR LOOKUP(ENTRY({&g_label_pos}, i_widget:PRIVATE-DATA, "|":U), "^,#":U) > 0 THEN                       */
/*          NEXT.                                                                                               */
/*                                                                                                              */
/*       ASSIGN                                                                                                 */
/*          i_label = i_widget:SIDE-LABEL-HANDLE                                                                */
/*          i_label:SELECTED = FALSE                                                                            */
/*          i_label:X = i_x_min                                                                                 */
/*          i_private_data = i_widget:PRIVATE-DATA                                                              */
/*          ENTRY({&g_label_pos}, i_private_data, "|":U) = STRING(i_label:COLUMN)                               */
/*          i_widget:PRIVATE-DATA = i_private_data                                                              */
/*                                                                                                              */
/*          i_config_updated = TRUE.                                                                            */
/*    END.                                                                                                      */
/* END.                                                                                                         */
/*                                                                                                              */
/*                                                                                                              */
/* ON CHOOSE OF MENU-ITEM m_unalign_side_labels /* Re-attach side-labels to the selected widgets */             */
/* DO:                                                                                                          */
/*    DEFINE VARIABLE i_widget AS WIDGET-HANDLE NO-UNDO.                                                        */
/*    DEFINE VARIABLE i_label AS WIDGET-HANDLE NO-UNDO.                                                         */
/*    DEFINE VARIABLE i_private_data AS CHARACTER NO-UNDO.                                                      */
/*    DEFINE VARIABLE i_inx as INTEGER NO-UNDO.                                                                 */
/*                                                                                                              */
/*    DO i_inx = 1 TO i_target_frame:NUM-SELECTED-WIDGETS:                                                      */
/*       i_widget = i_target_frame:GET-SELECTED-WIDGET(i_inx).                                                  */
/*                                                                                                              */
/*       IF i_widget:PRIVATE-DATA = "|SIDELABEL":U                                                              */
/*       OR i_widget:PRIVATE-DATA = "|BOXLABEL":U THEN                                                          */
/*          NEXT.                                                                                               */
/*                                                                                                              */
/*       IF  LOOKUP(i_widget:TYPE, {&g_supported_side_labels}) > 0                                              */
/*       AND VALID-HANDLE(i_widget:SIDE-LABEL-HANDLE)                                                           */
/*       AND LOOKUP(ENTRY({&g_label_pos}, i_widget:PRIVATE-DATA, "|":U), "^,#":U) < 1 THEN                      */
/*       DO:                                                                                                    */
/*          ASSIGN                                                                                              */
/*             i_label = i_widget:SIDE-LABEL-HANDLE                                                             */
/*             i_label:X = MAX(0, i_widget:X - i_label:WIDTH-PIXELS)                                            */
/*             i_label:SELECTED = TRUE                                                                          */
/*             i_private_data = i_widget:PRIVATE-DATA                                                           */
/*             ENTRY({&g_label_pos}, i_private_data, "|":U) = ""                                                */
/*             i_widget:PRIVATE-DATA = i_private_data                                                           */
/*                                                                                                              */
/*             i_config_updated = TRUE.                                                                         */
/*       END.                                                                                                   */
/*    END.                                                                                                      */
/* END.                                                                                                         */
/*                                                                                                              */
/*                                                                                                              */
