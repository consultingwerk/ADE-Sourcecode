&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : adeuib/_assignwidgid.p
    Purpose     : Assigns widget ids to frames and widgets of a design window
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Handle of design window */
DEFINE INPUT  PARAMETER iphWin AS HANDLE     NO-UNDO.

{adeuib/uniwidg.i}
{adeuib/sharvars.i}

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE iFrameWidgetID AS INTEGER    NO-UNDO.
DEFINE VARIABLE iNumButtons    AS INTEGER    NO-UNDO.
DEFINE VARIABLE iWidgetID      AS INTEGER    NO-UNDO.

DEFINE BUFFER child_U FOR _U.

  FIND _P WHERE _P._WINDOW-HANDLE EQ iphWin.
  IF AVAILABLE _P THEN
  DO:

    /* Assign widgt ids to frames and browse widgets starting with the
       "Starting widget id for frames" preference value */
    iFrameWidgetID = _widgetid_start.
    FOR EACH _U WHERE _U._window-handle = _P._window-handle AND
      LOOKUP(_U._TYPE,'FRAME,DIALOG-BOX,BROWSE':U) > 0:
         
      /* Increment using "Frame widget id increment" preference value */
      ASSIGN
        _U._WIDGET-ID = iFrameWidgetID
        iFrameWidgetID = iFrameWidgetID + _widgetid_increment.

      /* Assign widget id for widgets of frames starting with 2 
         and incrementing by 2 or the number of radio buttons */
      IF _U._TYPE = 'FRAME':U OR _U._TYPE = 'DIALOG-BOX':U THEN
      DO:
        iWidgetID = 2.
        FOR EACH child_U WHERE child_U._parent-recid = RECID(_U) AND
          LOOKUP(child_U._TYPE,'FRAME,DIALOG-BOX,BROWSE':U) = 0 AND
          child_U._SUBTYPE NE 'LABEL':U:

          child_U._WIDGET-ID = iWidgetID.

          IF child_U._TYPE = 'RADIO-SET':U THEN
          DO:
            FIND _F WHERE RECID(_F) = child_U._x-recid NO-ERROR.
            IF AVAILABLE _F THEN
              iNumButtons = NUM-ENTRIES(_F._LIST-ITEMS,_F._DELIMITER) / 2.

            iWidgetID = IF iNumButtons MODULO 2 NE 0 THEN
                          iWidgetID + iNumButtons + 1
                        ELSE 
                          iWidgetID + iNumButtons + 2.
          END.  /* if radio set */
          ELSE iWidgetID = iWidgetID + 2.
        END.  /* for each child _U */
      END.  /* if frame or dialog box */
    END.  /* for each _U */
  END.  /* if avail _P */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


