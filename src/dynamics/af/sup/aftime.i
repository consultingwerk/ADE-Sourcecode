&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Include _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Include _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: aftime.i

  Description:  Time entry trigger include file

  Purpose:      This include file contains standard triggers for a local fill-in used for entering
                time. Time is entered as a character string and then converted back to
                seconds.
                The variable to store the time in must be declared in the definition section of
                your program as an integer. A local fill-in must be used to enter the time in,
                declared as a character fill-in with a format of 99:99.
                The fill-in must be displayed and the variable initial value set-up in
                mip-displayval. Then in mip-updateval, the variable must be assigned to the
                database field.
                This include file must be included at the top of the main-block of your
                program

  Parameters:   {&fill-in} = Local fill-in you are entering time into. Must be a character fill-in with
                a format mask of 99:99.
                {&variable} = The variable the time entered in seconds will be written to on
                leave of the fill-in.

  History:
  --------
  (v:010000)    Task:         392   UserRef:    
                Date:   02/07/1998  Author:     Anthony Swindells

  Update Notes: Created from Template afteminclu.i

  (v:010002)    Task:        2011   UserRef:    
                Date:   30/07/1999  Author:     Anthony Swindells

  Update Notes: add hook for triggers to do specific code in certain viewers

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       aftime.i
&scop object-version    010002


/* MIP object identifying preprocessor */
&glob   mip-structured-include  yes

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

ON ANY-PRINTABLE OF {&fill-in} IN FRAME {&frame-name}
DO:
  DEFINE VARIABLE lv_offset AS INTEGER NO-UNDO.
  IF KEYLABEL(LASTKEY) = ":" AND SELF:CURSOR-OFFSET <= 3 THEN
    DO:
      APPLY "U1" TO SELF.
      ASSIGN lv_offset = 4.
      ASSIGN SELF:CURSOR-OFFSET = lv_offset.
    END.
  ELSE IF KEYLABEL(LASTKEY) >= "0" AND KEYLABEL(LASTKEY) <= "9" AND
    lv_offset < 6 THEN
    DO:
      DEFINE VARIABLE lv_screen_value AS CHARACTER NO-UNDO.
      ASSIGN lv_offset = SELF:CURSOR-OFFSET
             lv_screen_value = SELF:SCREEN-VALUE
             SUBSTRING(lv_screen_value,SELF:CURSOR-OFFSET,1) = KEYLABEL(LASTKEY)
             SELF:SCREEN-VALUE = lv_screen_value
             NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
        RETURN NO-APPLY.       
      IF lv_offset = 3 THEN ASSIGN lv_offset = lv_offset + 1.
      IF lv_offset < 5 THEN ASSIGN SELF:CURSOR-OFFSET = lv_offset + 1.
                       ELSE APPLY "CURSOR-RIGHT" TO SELF.
    END.
  ELSE
    BELL.
  UNDO, RETURN NO-APPLY.
END.


ON LEAVE OF {&fill-in} IN FRAME {&frame-name}
DO:
  DEFINE VARIABLE lv_time_seconds   AS INTEGER NO-UNDO.
  DEFINE VARIABLE lv_hours          AS INTEGER NO-UNDO.
  DEFINE VARIABLE lv_minutes        AS INTEGER NO-UNDO.

  APPLY "U1" TO SELF.
  APPLY "U2" TO SELF.

  ASSIGN lv_hours = INTEGER(SUBSTRING(SELF:SCREEN-VALUE,1,2))
         lv_minutes = INTEGER(SUBSTRING(SELF:SCREEN-VALUE,4,2))
         NO-ERROR.

  IF (lv_hours < 0 OR lv_hours > 23) OR
     (lv_minutes < 0 OR lv_minutes > 59) THEN
    DO:
      MESSAGE "Invalid time entered"
        VIEW-AS ALERT-BOX INFORMATION
        BUTTONS OK.
      UNDO, RETURN NO-APPLY.
    END.

  ASSIGN lv_time_seconds = (INTEGER(SUBSTRING(SELF:SCREEN-VALUE,1,2)) * 60 * 60) + 
                           (INTEGER(SUBSTRING(SELF:SCREEN-VALUE,4,2)) * 60) NO-ERROR.

  /* Run internal procedure and pass in variable name, old value and new value before we change it */
  IF LOOKUP("mip-time-changed":U, THIS-PROCEDURE:INTERNAL-ENTRIES) <> 0 THEN
    RUN mip-time-changed (INPUT "{&variable}":U, INPUT {&variable}, INPUT lv_time_seconds).
  ASSIGN {&variable} = lv_time_seconds.

END.


ON U1 OF {&fill-in} IN FRAME {&frame-name}
DO:
  DEFINE VARIABLE lv_screen_value AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lv_hours AS INTEGER  NO-UNDO.

  ASSIGN lv_screen_value = SELF:SCREEN-VALUE.
         lv_hours = INTEGER(SUBSTRING(SELF:SCREEN-VALUE,1,2)).
  IF lv_hours = ? THEN lv_hours = 0.
  ASSIGN SUBSTRING(lv_screen_value,1,2) = STRING(lv_hours,"99")
         SELF:SCREEN-VALUE = lv_screen_value.
END.


ON U2 OF {&fill-in} IN FRAME {&frame-name}
DO:
  DEFINE VARIABLE lv_screen_value AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lv_minutes AS INTEGER  NO-UNDO.

  ASSIGN lv_screen_value = SELF:SCREEN-VALUE.
         lv_minutes = INTEGER(SUBSTRING(SELF:SCREEN-VALUE,4,5)).
  IF lv_minutes = ? THEN lv_minutes = 0.
  ASSIGN SUBSTRING(lv_screen_value,4,5) = STRING(lv_minutes,"99")
         SELF:SCREEN-VALUE = lv_screen_value.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


