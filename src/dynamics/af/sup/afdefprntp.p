&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "CreateWizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? af/sup/afwizdeltp.p */
/* MIP New Program Wizard
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
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
/*---------------------------------------------------------------------------------
  File: afdefprntp.p

  Description:  Get / modify the system default printer

  Purpose:      Get / modify the system default printer

  Parameters:   INPUT ip_action
                = "get" to get the current default printer.
                = "mod" to modify the default printer.
                INPUT-OUTPUT iop_printer
                If action is "get", passes back the default printer,
                If action is "mod", changes the default printer to the one passed in.
                For an example of use, see tstcrystlv.w.

  History:
  --------
  (v:010000)    Task:        1239   UserRef:    
                Date:   22/06/1999  Author:     Jenny Bond

  Update Notes: Created from Template aftemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afdefprntp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes


DEFINE INPUT        PARAMETER ip_action        AS CHARACTER        NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER iop_printer      AS CHARACTER        NO-UNDO.

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
         HEIGHT             = 4.91
         WIDTH              = 44.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

    &SCOPED-DEFINE HWND_BROADCAST 65535
    &SCOPED-DEFINE WM_WININICHANGE 26
    DEF VAR result AS INT.
    DEF VAR X AS CHAR FORMAT "X(50)".

    CASE ip_action:
        WHEN "get":U THEN DO:
            RUN GetKey("WINDOWS","DEVICE",?,OUTPUT X).
            ASSIGN
                iop_printer = X.
        END.

        WHEN "mod":U THEN DO:
            RUN SetKey("WINDOWS","DEVICE",iop_printer).
            RUN SendMessageA( {&HWND_BROADCAST},
                              {&WM_WININICHANGE},0,"WINDOWS",
                              OUTPUT result).
            SESSION:PRINTER-CONTROL-HANDLE = 0.
        END.
    END CASE.

    PROCEDURE SendMessageA EXTERNAL "USER32.DLL":
    DEF INPUT PARAMETER p1 AS LONG.
    DEF INPUT PARAMETER p2 AS LONG.
    DEF INPUT PARAMETER p3 AS LONG.
    DEF INPUT PARAMETER p4 AS CHAR.
    DEF RETURN PARAMETER result AS LONG.
    END.

    PROCEDURE GetKey:
    DEF INPUT PARAMETER pSection AS CHAR NO-UNDO.
    DEF INPUT PARAMETER pEntry AS CHAR NO-UNDO.
    DEF INPUT PARAMETER pDefault AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER pString AS CHAR NO-UNDO.

    DEF VAR result AS INT NO-UNDO.
    DEF VAR wbuf AS MEMPTR NO-UNDO.

    SET-SIZE(wbuf) = 255.

    RUN GetProfileStringA(pSection,pEntry,pDefault,wbuf,254,
                          OUTPUT result).
    IF result = 0 THEN
       pString = ?.
    ELSE
       pString = GET-STRING(wbuf,1).
    SET-SIZE(wbuf) = 0.
    END PROCEDURE.

    PROCEDURE SetKey:
    DEF INPUT PARAMETER pSection AS CHAR NO-UNDO.
    DEF INPUT PARAMETER pEntry AS CHAR NO-UNDO.
    DEF INPUT PARAMETER pString AS CHAR NO-UNDO.

    RUN WriteProfileStringA(pSection,pEntry,pString,
                            OUTPUT result).
    END PROCEDURE.

    PROCEDURE GetProfileStringA EXTERNAL "KERNEL32.DLL":
    DEF INPUT PARAMETER lpszSection AS CHAR.
        /* address of section       */ 
    DEF INPUT PARAMETER lpszEntry AS CHAR.  
          /* address of entry       */ 
    DEF INPUT PARAMETER lpszDefault AS CHAR. 
    DEF INPUT PARAMETER lpszReturnBuffer AS MEMPTR. 
    DEF INPUT PARAMETER cbReturnBuffer AS LONG.
    DEF RETURN PARAMETER result AS LONG.
    END.

    PROCEDURE WriteProfileStringA EXTERNAL "KERNEL32.DLL":
    DEF INPUT PARAMETER lpszSection AS CHAR.
    DEF INPUT PARAMETER lpszEntry AS CHAR.  
    DEF INPUT PARAMETER lpszString AS CHAR.
    DEF RETURN PARAMETER result AS LONG.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


