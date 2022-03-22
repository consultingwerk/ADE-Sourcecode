&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*---------------------------------------------------------------------------------
  File: sbologic.i

  Description:  

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   01/27/2003  Author:     

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes


  /* This is an array of all the update table handles. */
  DEFINE VARIABLE ghUpdTables          AS HANDLE EXTENT 20    NO-UNDO.

  /* Now define all the actual Upd temp-tables using preprocessors which 
     are used in the SBO. */
  {src/adm2/updtabledef.i 1}
  {src/adm2/updtabledef.i 2}
  {src/adm2/updtabledef.i 3}
  {src/adm2/updtabledef.i 4}
  {src/adm2/updtabledef.i 5}
  {src/adm2/updtabledef.i 6}
  {src/adm2/updtabledef.i 7}
  {src/adm2/updtabledef.i 8}
  {src/adm2/updtabledef.i 9}
  {src/adm2/updtabledef.i 10}
  {src/adm2/updtabledef.i 11}
  {src/adm2/updtabledef.i 12}
  {src/adm2/updtabledef.i 13}
  {src/adm2/updtabledef.i 14}
  {src/adm2/updtabledef.i 15}
  {src/adm2/updtabledef.i 16}
  {src/adm2/updtabledef.i 17}
  {src/adm2/updtabledef.i 18}
  {src/adm2/updtabledef.i 19}
  {src/adm2/updtabledef.i 20}

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
         HEIGHT             = 7.24
         WIDTH              = 56.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearLogicRows Include 
PROCEDURE clearLogicRows :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE iCount  AS INTEGER    NO-UNDO.
DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.

  DO iCount = 1 TO 20:
    IF VALID-HANDLE(ghUpdTables[iCount]) THEN DO:
      hBuffer = ghUpdTables[iCount]:DEFAULT-BUFFER-HANDLE.
      hBuffer:EMPTY-TEMP-TABLE().
    END.
    ELSE LEAVE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogicRows Include 
PROCEDURE getLogicRows :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  {src/adm2/updparam.i 1 OUTPUT}
  {src/adm2/updparam.i 2 OUTPUT}
  {src/adm2/updparam.i 3 OUTPUT}
  {src/adm2/updparam.i 4 OUTPUT}
  {src/adm2/updparam.i 5 OUTPUT}
  {src/adm2/updparam.i 6 OUTPUT}
  {src/adm2/updparam.i 7 OUTPUT}
  {src/adm2/updparam.i 8 OUTPUT}
  {src/adm2/updparam.i 9 OUTPUT}
  {src/adm2/updparam.i 10 OUTPUT}
  {src/adm2/updparam.i 11 OUTPUT}
  {src/adm2/updparam.i 12 OUTPUT}
  {src/adm2/updparam.i 13 OUTPUT}
  {src/adm2/updparam.i 14 OUTPUT}
  {src/adm2/updparam.i 15 OUTPUT}
  {src/adm2/updparam.i 16 OUTPUT}
  {src/adm2/updparam.i 17 OUTPUT}
  {src/adm2/updparam.i 18 OUTPUT}
  {src/adm2/updparam.i 19 OUTPUT}
  {src/adm2/updparam.i 20 OUTPUT}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLogicRows Include 
PROCEDURE setLogicRows :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  {src/adm2/updparam.i 1 INPUT}
  {src/adm2/updparam.i 2 INPUT}
  {src/adm2/updparam.i 3 INPUT}
  {src/adm2/updparam.i 4 INPUT}
  {src/adm2/updparam.i 5 INPUT}
  {src/adm2/updparam.i 6 INPUT}
  {src/adm2/updparam.i 7 INPUT}
  {src/adm2/updparam.i 8 INPUT}
  {src/adm2/updparam.i 9 INPUT}
  {src/adm2/updparam.i 10 INPUT}
  {src/adm2/updparam.i 11 INPUT}
  {src/adm2/updparam.i 12 INPUT}
  {src/adm2/updparam.i 13 INPUT}
  {src/adm2/updparam.i 14 INPUT}
  {src/adm2/updparam.i 15 INPUT}
  {src/adm2/updparam.i 16 INPUT}
  {src/adm2/updparam.i 17 INPUT}
  {src/adm2/updparam.i 18 INPUT}
  {src/adm2/updparam.i 19 INPUT}
  {src/adm2/updparam.i 20 INPUT}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

