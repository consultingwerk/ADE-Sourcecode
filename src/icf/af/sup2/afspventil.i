&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
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
/*------------------------------------------------------------------------
    Library     : Ventilator.i

    Purpose     : Adds Options to Hide Ventilator and repaint object

    Syntax      : src/adm2/support/Ventilator.i

  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE VARIABLE hVentilator AS HANDLE NO-UNDO.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
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

&IF DEFINED(EXCLUDE-_addVentilatorPopup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _addVentilatorPopup Method-Library 
PROCEDURE _addVentilatorPopup PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Add a MENU-ITEM to a Pop-Up
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER hMenu AS HANDLE NO-UNDO.

  DEFINE VARIABLE hItem AS HANDLE NO-UNDO.

  IF VALID-HANDLE(hMenu) THEN
  DO:
    CREATE MENU-ITEM hItem
    ASSIGN
        SUBTYPE = "RULE"
        PARENT  = hMenu.

    CREATE MENU-ITEM hItem
    ASSIGN
        LABEL  = "&Repaint"
        PARENT = hMenu
    TRIGGERS:
      ON "CHOOSE" PERSISTENT RUN _repaintObject IN THIS-PROCEDURE.
    END TRIGGERS.

    CREATE MENU-ITEM hItem
    ASSIGN
        SUBTYPE = "RULE"
        PARENT  = hMenu.

    CREATE MENU-ITEM hItem
    ASSIGN
        LABEL      = "&Hide Ventilator"
        TOGGLE-BOX = TRUE
        CHECKED    = FALSE
        PARENT     = hMenu
    TRIGGERS:
      ON "VALUE-CHANGED" PERSISTENT RUN _hideVentilator IN THIS-PROCEDURE.
    END TRIGGERS.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-_getVentilator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _getVentilator Method-Library 
PROCEDURE _getVentilator PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Get the handle of the ADM's ventilator
  Parameters:  Object Instance Frame handle
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.

  pHandle = pHandle:LAST-CHILD.

  DO WHILE VALID-HANDLE(pHandle) ON ERROR UNDO, RETURN ERROR:

    IF CAN-DO("WINDOW,FIELD-GROUP,FRAME",pHandle:TYPE) THEN 
      RUN _getVentilator(pHandle).
    ELSE 
      IF pHandle:DYNAMIC       = TRUE     AND
         pHandle:WIDTH-PIXELS  = 17       AND
         pHandle:HEIGHT-PIXELS = 16       AND
         pHandle:X             < 5        AND
         pHandle:Y             < 5        AND
         CAN-QUERY(pHandle,"POPUP-MENU")  AND
         VALID-HANDLE(pHandle:POPUP-MENU) THEN
      DO:
        hVentilator = pHandle.

        RETURN ERROR.
      END.

    pHandle = pHandle:PREV-SIBLING.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-_hideVentilator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _hideVentilator Method-Library 
PROCEDURE _hideVentilator PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF VALID-HANDLE(hVentilator) THEN
  DO:
    hVentilator:VISIBLE = NOT SELF:CHECKED.

    hVentilator:MOVE-TO-TOP().
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-_repaintObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _repaintObject Method-Library 
PROCEDURE _repaintObject PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Call resizeObject to force a repaint
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN resizeObject IN THIS-PROCEDURE (INPUT FRAME {&FRAME-NAME}:HEIGHT,
                                      INPUT FRAME {&FRAME-NAME}:WIDTH).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

