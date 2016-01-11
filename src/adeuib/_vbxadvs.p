&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/**************************************************************************
    Procedure:  _vbxadvs.p
    
    Purpose:    Displays various flavors of the VBX Advisor dialog for
                VBX Controls and Custom (.cst) files. Returns user response.

    Syntax :    RUN adeuib/_vbxadvs.p
                  (INPUT p_hwin, INPUT p_AdvType, INPUT p_vbxname, OUTPUT p_Choice).

    Parameters:
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : November, 1996
    Updated: January,  1997
**************************************************************************/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Parameters   ************************** */

DEFINE INPUT  PARAMETER p_hwin    AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER p_Advtype AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER p_vbxname AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER p_Choice  AS CHARACTER  NO-UNDO.

/* ***************************  Definitions  ************************** */

{adecomm/adefext.i}      /* ADE Tool Preprocessors - UIB_NAME is here.       */
{adeuib/pre_proc.i}      /* UIB Preprocessor Defs                            */
{adeuib/uniwidg.i}       /* Universal Widget TEMP-TABLE definition           */
{adeuib/sharvars.i}      /* Shared variables                                 */
{adeuib/uibhlp.i}        /* UIB Help Context ID's.                           */

DEFINE BUFFER b_U FOR _U.
DEFINE BUFFER b_P FOR _P.

DEFINE VAR adv_never  AS LOGICAL NO-UNDO.
DEFINE VAR adv_msg    AS CHAR    NO-UNDO.
DEFINE VAR f_prefix   AS CHAR    NO-UNDO.
DEFINE VAR f_name     AS CHAR    NO-UNDO.

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
         HEIGHT             = 2.01
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DO:
    /* Use _P to get the full name, then call routine to get the base .w name. */
    FIND b_P WHERE b_P._WINDOW-HANDLE = p_hwin NO-ERROR.
    IF AVAILABLE b_P THEN
      RUN adecomm/_osprefx.p (INPUT b_P._SAVE-AS-FILE, OUTPUT f_prefix, OUTPUT f_name).

    CASE p_advtype:

      WHEN "_VBX-1":U THEN
      DO:

        ASSIGN adv_msg =
            f_name + CHR(10) + CHR(10)
               + "This file contains VBX controls." + CHR(10) + CHR(10)
               + "What do you want the " + "{&UIB_SHORT_NAME}" + " to do?" .

        ASSIGN p_Choice = "_REPLACE-AUTO":U.
        DO ON STOP UNDO, RETRY:
          IF RETRY THEN
              ASSIGN p_Choice = "_CANCEL":U.
          ELSE
              RUN adeuib/_advisor.w (
                INPUT adv_msg ,
                INPUT
          "&Replace all VBX controls with OCXs.,_REPLACE-AUTO," +
          "&Delete all VBX controls and their code blocks.,_DELETE-ALL," +
          "&Cancel and do not load the file.,_CANCEL",
                INPUT FALSE,
                INPUT "AB",
                INPUT {&Advisor_VBX_Auto_Replace},
                INPUT-OUTPUT p_Choice ,
                OUTPUT adv_never ).
        END.
      END.

      WHEN "_VBX-2":U THEN
      DO:

        ASSIGN adv_msg =
            f_name + CHR(10) + CHR(10)
               + "{&UIB_SHORT_NAME}" + " could not automatically replace VBX control "
               + p_vbxname + "." + CHR(10) + CHR(10)
               + "What do you want to do?" .

        ASSIGN p_Choice = "_REPLACE-SELECT":U.
        DO ON STOP UNDO, RETRY:
          IF RETRY THEN
              ASSIGN p_Choice = "_CANCEL":U.
          ELSE
              RUN adeuib/_advisor.w (
                INPUT adv_msg ,
                INPUT
          "&Select OCX to replace VBX control.,_REPLACE-SELECT," +
          "&Delete VBX control and its code blocks.,_DELETE," +
          "&Cancel and do not load the file.,_CANCEL",
                INPUT FALSE,
                INPUT "AB",
                INPUT {&Advisor_VBX_Manual_Replace},
                INPUT-OUTPUT p_Choice ,
                OUTPUT adv_never ).
        END.
      END.
      
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


