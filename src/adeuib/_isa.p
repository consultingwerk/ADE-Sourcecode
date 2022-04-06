&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:   File: _isa.p

  Description:
     The procedure is called to decide the sub, or superclass of an object.
     For example, if we want to know if an object is a TEMPLATE, or if
     is VISUAL, or if it is a SmartObject, we can call this procedure
     and ask.

  Input Parameters:
      p_contextID : The context id of the object
      p_type      : The type we are checking for... Supported types include:
                         SmartObject 
                         SmartContainer -- can it include other SmartObjects
                         Template -- is the TEMPLATE flag set
                     Otherwise we check that the
                         Procedure Type matched p_type

  Output Parameters:
      p_yes-it-is : YES if the object is the correct type.

  Author: Wm. T. Wood

  Created: June 1996

  Modified: 
 
----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p_contextID AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER p_type      AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER p_yes-it-is AS LOGICAL NO-UNDO.

/* Include Files */
{adeuib/uniwidg.i}             /* Definition of Universal Widget TEMP-TABLE  */

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 2
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Find the procedure pointed to by the context. */
FIND _P WHERE RECID(_P) eq p_contextID.

/* Now test the type. */
CASE p_type:

  WHEN "SmartContainer":U THEN DO:
    p_yes-it-is = CAN-DO (_P._Allow, "Smart":U).
  END. /* SmartContainer */
  
  WHEN "SmartObject":U THEN DO:
    /* Check if it is a SmartContainer or a SmartObject. There is no
       field to check, so we have to be circumspect. It is easy to 
       check a SmartContainer -- these allow "Smart" object to be added.
       It is hard to check if another object is a SmartObject.  But
       here is how we will check:
             a) either it supports links; or
             b) it is a Window-less, Single-frame, persistent only .w
       We will treat this as a SmartObject. */          
    p_yes-it-is = CAN-DO (_P._Allow, "Smart":U)  /* not a SmartContainer */ 
                    OR (_P._links ne "":U        /* or a SmartObject     */      
                       OR (_P._persistent-only   
                           AND CAN-DO(_P._Allow, "Window":U) eq NO 
                           AND _P._max-frame-count eq 1)
                        ).
  END. /* SmartObject */
  
  WHEN "SmartDataObject" THEN DO:
    DEFINE VARIABLE isaSMO  AS  LOGICAL                          NO-UNDO.
    RUN adeuib/_isa.p (INPUT p_contextID, INPUT "SmartObject":U, OUTPUT isaSMO).
    p_yes-it-is = isaSMO AND
                  CAN-FIND(FIRST _U WHERE
                           _U._WINDOW-HANDLE = _P._WINDOW-HANDLE AND
                                    _U._TYPE = "QUERY") AND
                  NOT (CAN-FIND(FIRST _U WHERE
                           _U._WINDOW-HANDLE = _P._WINDOW-HANDLE AND
                                    _U._TYPE = "FRAME")) AND
                  _P._DB-AWARE.
  END.

  WHEN "Template":U THEN DO:
    p_yes-it-is = _P._TEMPLATE.
  END. /* Template */

  OTHERWISE DO:
    /* Check the TYPE directly. */
    p_yes-it-is = (p_type eq _P._TYPE).
  END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


