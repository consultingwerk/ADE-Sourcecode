&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
    File        : _ablink.p
    
    Parameters  : 
      pcRequest       - "ADD,REMOVE|DELETE"
      piSource        - CHAR The contextId(s) of the Source object(s). 
                        Note that contecxt id is recid, but the parameter
                        is char to allow for a list of values or '*'    
                        [If ? or '?' then the UIB current procedure
                         The same as linking to THIS-PROCEDURE ]
                        (* delete all sources)   
                       
      pcLink          - LinkName           
      piTarget        - CHAR The contextId(s) of the Target object(s). 
                        Note that contecxt id is recid, but the parameter
                        is char to allow for a list of values or '*'    
                        [If ? then the UIB current procedure.
                        (* delete all targets)   
                         The same as linking to THIS-PROCEDURE ]
    Syntax      :  
    Author(s)   : H. Danielsen  
    Created     : June 99
 
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Define Parameters. */     
DEFINE INPUT PARAMETER pcRequest  AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pcSource   AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pcLink     AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pcTarget   AS CHAR NO-UNDO.

/* Include Files. */
{adeuib/uniwidg.i}             /* Definition of Universal Widget TEMP-TABLE  */
{adeuib/sharvars.i}            /* Shared UIB variables                       */
{adeuib/links.i}

DEFINE VARIABLE ghWindow AS HANDLE NO-UNDO.
DEFINE VARIABLE iTarget  AS INTEGER NO-UNDO. 
DEFINE VARIABLE iSource  AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-errorMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD errorMsg Procedure 
FUNCTION errorMsg RETURNS LOGICAL
  (MSG as char)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isSmartObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isSmartObject Procedure 
FUNCTION isSmartObject RETURNS LOGICAL
  (prRecid AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 3.81
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE BUFFER b_P FOR _P.

IF pcSource = '?':U THEN pcSource = ?.
IF pcTarget = '?':U THEN pcTarget = ?.

/* Both links cannot be this-procedure */  
IF pcSource eq ? OR pcTarget eq ? THEN 
DO:
  IF NOT VALID-HANDLE(_h_win) THEN 
  DO:
    errorMsg ( "No procedure or window is currently selected." ).
    RETURN "Error":U.
  END.  
  ghWindow = _h_win.    
END.                                               

/* Multiple links not allowed for add */
IF pcRequest = "ADD":U THEN
DO: 
  IF (NUM-ENTRIES(pcSource) > 1 OR NUM-ENTRIES(pcTarget) > 1) THEN
  DO:
    errorMsg ("A list of Contrext Ids is not allowed in an ADD request.").
    RETURN "Error":U.
  END.
  IF pcSource = "*":U OR pcTarget = "*":U THEN
  DO:
    errorMsg ("'*' is not allowed in an ADD request.").
    RETURN "Error":U.
  END.
END. /* pcRequest = "add" */

IF  (NUM-ENTRIES(pcSource) > 1 OR pcSource = "*":U) 
AND (NUM-ENTRIES(pcTarget) > 1 OR pcTarget = "*")   THEN
DO:
  errorMsg ("A list of Context Id's or '*' is not allowed for both source and target.").
  RETURN "Error":U.
END.

/* Convert "*" to 0 before passing them to processLink as integers */
IF      pcSource = "*":U THEN pcSource = "0":U.
ELSE IF pcTarget = "*":U THEN pcTarget = "0":U.
  
/* multiple Sources */  
IF NUM-ENTRIES(pcSource) > 1 THEN
DO iSource = 1 TO NUM-ENTRIES(pcSource):
  RUN processLink (INT(ENTRY(iSource,pcSource)), INT(pcTarget) ).
  IF RETURN-VALUE = "ERROR":U THEN
    RETURN "ERROR":U.
END. 

/* multiple targets */
ELSE
IF NUM-ENTRIES(pcTarget) > 1 THEN
DO iTarget = 1 TO NUM-ENTRIES(pcTarget):
  RUN processLink (INT(pcSource), INT(ENTRY(iTarget,pcSource))).
  IF RETURN-VALUE = "ERROR":U THEN
    RETURN "ERROR":U.

END.

ELSE
 RUN processLink (INT(pcSource),INT(pcTarget)).

IF RETURN-VALUE = "ERROR":U THEN
  RETURN "ERROR":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-processLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processLink Procedure 
PROCEDURE processLink :
/*------------------------------------------------------------------------------
  Purpose: Process the request    
           The main purpose of this procedure is to use the same call 
           when the input pcSource or pcTarget is a list of objects 
           "*" is converted to 0      
  Parameters:  piSource - Source context Id
                           0 = ALL 
               piTarget - Target Context Id
                           0 = ALL
  Notes: The external input parameters pcLink and pcRequest is used directly
          
------------------------------------------------------------------------------*/
 DEF INPUT PARAMETER piSource AS INT NO-UNDO.
 DEF INPUT PARAMETER piTarget AS INT NO-UNDO.
 
 IF piSource EQ piTarget THEN 
 DO:
   errorMsg ( "Cannot" + lc(pcRequest) + " circular links." ).
   RETURN "Error".  
 END.
 
 /* ghWindow is set in the function if its unknown, otherwise its compared */
 IF piSource <> ? AND piSource <> 0 AND NOT isSmartObject(piSource) THEN
    RETURN "Error".

 /* ghWindow is set in the function if its unknown, otherwise its compared */
 IF piTarget <> ? AND piTarget <> 0 AND NOT isSmartObject(piTarget) THEN
   RETURN "Error".
  
 /* If source or target is unknown ghWindow is current window otherwise it's 
   found in isSmartObject. isSmartObject also validates when it's already set */
 FIND b_P WHERE b_P._WINDOW-HANDLE = ghWindow NO-ERROR.
 IF NOT AVAIL b_P THEN 
 DO:
   /* Is this even possible ? */
   errorMsg ( "Could not find the window of the specified link(s)" ).
   RETURN "Error":U.
 END.

 /* THIS-PROCEDURE is linked using the recid of the current window's procedure */     
 IF      piSource = ? THEN piSource = (RECID(b_P)).
 ELSE IF piTarget = ? THEN piTarget = (RECID(b_P)).
     
 IF pcRequest = "ADD":U THEN 
 DO:  
   /* Check that none of the links are 0  */
   IF piSource = 0 OR piTarget = 0 THEN 
   DO:
     errorMsg ( "0 is only allowed when links are removed." ).
     RETURN "Error".  
   END.
  
   CREATE _admlinks.
  
   ASSIGN 
     _admlinks._p-recid = RECID(b_P) 
     _admlinks._link-type   = pcLink     
     _admlinks._link-source = STRING(piSource)                                     
     _admlinks._link-dest   = STRING(piTarget). 
                                
 END. /* pcRequest =  add */

 ELSE IF CAN-DO("DELETE,REMOVE":U,pcRequest) THEN 
 DO:  
   IF piSource = 0 THEN 
   FOR EACH _admlinks WHERE _admlinks._p-recid   = RECID(b_P) 
                      AND   _admlinks._link-type = pcLink 
                      AND   _admlinks._link-dest = STRING(piTarget).
     DELETE _admlinks.
   END.                    
   ELSE
   IF piTarget = 0 THEN 
   FOR EACH _admlinks WHERE _admlinks._p-recid     = RECID(b_P) 
                      AND   _admlinks._link-type   = pcLink 
                      AND   _admlinks._link-source = STRING(piSource):
      DELETE _admlinks.
   END.                    
   ELSE
   DO:
     FIND _admlinks WHERE _admlinks._p-recid     = RECID(b_P) 
                   AND   _admlinks._link-type   = pcLink 
                   AND   _admlinks._link-source = STRING(piSource)
                   AND   _admlinks._link-dest   = STRING(piTarget) No-ERROR.
                    
     IF AVAIL _admlinks THEN
       DELETE _admlinks.
    
     ELSE
       RUN errorMsg ( "Could not find any " + pcLink + " to " + lc(pcRequest)  ).         
   END.                            
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-errorMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION errorMsg Procedure 
FUNCTION errorMsg RETURNS LOGICAL
  (MSG as char) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  MESSAGE "[{&FILE-NAME}]" SKIP msg VIEW-AS ALERT-BOX ERROR.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isSmartObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isSmartObject Procedure 
FUNCTION isSmartObject RETURNS LOGICAL
  (prRecid AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose: Check if the ContextId is a SmartObject or THIS-PROCEDURE
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER b_U FOR _U.
  DEFINE BUFFER b_S FOR _S.  
  DEFINE BUFFER b_P FOR _P.
    
  FIND b_U WHERE RECID(b_U) = prRecid NO-ERROR. 
  IF NOT AVAIL b_U THEN
  DO:
    errorMsg( STRING(prRecid) + " is not a valid Context Id.").
    RETURN FALSE.
  END.

  /* First time true we set the global variable */
  IF ghWindow = ? THEN 
    ASSIGN ghWindow = b_U._WINDOW-HANDLE. 
  
  ELSE IF ghWindow <> b_u._WINDOW-HANDLE THEN
  DO:   
    IF pcRequest = "ADD":U THEN
    DO:
       errorMsg(" Attempt to link objects in diffent Windows. No link created.").         
       RETURN FALSE.
    END.   
  END.
    
  FIND b_S WHERE RECID(b_S) eq b_U._x-Recid NO-ERROR.
  IF NOT AVAIL b_S THEN
  DO:
    errorMsg( STRING(prRecid) + " is not a SmartObject Context Id.").
    RETURN FALSE.
  END.
  
  RETURN TRUE.
      
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

