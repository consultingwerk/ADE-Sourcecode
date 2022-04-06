&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: aftopmostp.p

  Description: Defines a window to be TOP-MOST or not.

  Purpose: This template should be used to create structured procedures.

  Input Parameters:
       usrhwnd (int) - hWnd of Progress window client area
       mode    (log) - turn TOP-MOST on or off

  Output Parameters:
       rc (int)      - return code (non-zero = ok)

  History:
  (010000)  Task: 6     05/04/1997  Anthony D Swindells
            Written from scratch, but copied from Progress supplied code
            Task: 6     29/09/1997  Alec Tucker
            Brought in new copy from Progress supplied code incorporating
            32 bit DLL calls


------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       aftopmostp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001



DEFINE INPUT  PARAMETER usrhwnd AS INTEGER NO-UNDO. /* hWnd of window (really client area only) */
DEFINE INPUT  PARAMETER mode    AS LOGICAL NO-UNDO. /* yes = on, no = off */
DEFINE OUTPUT PARAMETER rc      AS INTEGER NO-UNDO. /* non-zero = ok */

DEFINE VARIABLE topmost         AS INTEGER NO-UNDO.
DEFINE VARIABLE flags           AS INTEGER NO-UNDO INITIAL  3.  /* 0x0001 OR 0x0002 */  
DEFINE VARIABLE parent          AS INTEGER NO-UNDO.             /* hold parent hWnd */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

IF OPSYS = "WIN32" THEN DO:
  RUN GetParent ( INPUT usrhwnd, OUTPUT parent).

  RUN SetWindowPos ( INPUT  parent,
                       INPUT  (IF mode THEN -1 ELSE -2),
                       INPUT  0,
                       INPUT  0,
                       INPUT  0,
                       INPUT  0,
                       INPUT  flags,
                       OUTPUT rc ).
END.
ELSE DO:
  RUN GetParent16 ( INPUT usrhwnd, OUTPUT parent).

  RUN SetWindowPos16 ( INPUT  parent,
                     INPUT  (IF mode THEN -1 ELSE -2),
                     INPUT  0,
                     INPUT  0,
                     INPUT  0,
                     INPUT  0,
                     INPUT  flags,
                     OUTPUT rc ).
END.

/* 32bit DLLs */
PROCEDURE SetWindowPos EXTERNAL "user32.dll":
  DEFINE INPUT PARAMETER hWnd            AS LONG.
  DEFINE INPUT PARAMETER hWndInsertAfter AS LONG.
  DEFINE INPUT PARAMETER x               AS LONG.
  DEFINE INPUT PARAMETER y               AS LONG.
  DEFINE INPUT PARAMETER cx              AS LONG.
  DEFINE INPUT PARAMETER cy              AS LONG.
  DEFINE INPUT PARAMETER wflags          AS LONG.   
  DEFINE RETURN PARAMETER rc             AS LONG.
END.

PROCEDURE GetParent EXTERNAL "user32.dll":
  DEFINE INPUT  PARAMETER hWnd1           AS LONG.
  DEFINE RETURN PARAMETER hWnd2           AS LONG.
END. 

/* 16bit DLLs */
PROCEDURE SetWindowPos16 EXTERNAL "user.exe" ORDINAL 232:
  DEFINE INPUT PARAMETER hWnd            AS SHORT.
  DEFINE INPUT PARAMETER hWndInsertAfter AS SHORT.
  DEFINE INPUT PARAMETER x               AS SHORT.
  DEFINE INPUT PARAMETER y               AS SHORT.
  DEFINE INPUT PARAMETER cx              AS SHORT.
  DEFINE INPUT PARAMETER cy              AS SHORT.
  DEFINE INPUT PARAMETER wflags          AS SHORT.   
  DEFINE RETURN PARAMETER rc             AS SHORT.
END.

PROCEDURE GetParent16 EXTERNAL "user.exe" ORDINAL 46:
  DEFINE INPUT  PARAMETER hWnd1           AS SHORT.
  DEFINE RETURN PARAMETER hWnd2           AS SHORT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


