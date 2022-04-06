&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    Library     : src/adm2/logic.i
    Purpose     : method library for data logic procedure
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE rowObjUpd  {&DATA-TABLE-NO-UNDO}
  /* Allow users to ommit the hardcoded RCODE-INFORMATION and put it in the 
     include instead. 
     This makes it possible to manually maintain the include using LIKE 
     and thus avoid -inp and -tok limitations 
   ----------------------------------------    
    LIKE  CUSTOMER {&TEMP-TABLE-OPTIONS}  
   --------------------------------------*/
 &IF '{&TEMP-TABLE-OPTIONS}' = '' &THEN
     RCODE-INFORMATION
 &ENDIF
  
 &IF '{&DATA-FIELD-DEFS}' BEGINS '"' &THEN
   {{&DATA-FIELD-DEFS}}
 &ELSE
   {&DATA-FIELD-DEFS}
 &ENDIF  
   {src/adm2/rupdflds.i}.

&IF DEFINED(TABLE-NAME) = 0 &THEN
   &SCOP TABLE-NAME {&DATA-LOGIC-TABLE}
&ENDIF

DEFINE BUFFER b_{&DATA-LOGIC-TABLE}   FOR rowObjUpd.
DEFINE BUFFER old_{&DATA-LOGIC-TABLE} FOR rowObjUpd.

{&DB-REQUIRED-START}
&IF "{&table-name}":U <> '':U &THEN
&IF DEFINED(EXCLUDE-delete{&DATA-TABLE}Static) = 0 &THEN

/* This is called from the SDO of the table cannot be deleted dynamically
   due to table validation expression */   
FUNCTION delete{&TABLE-NAME}Static RETURNS LOGICAL
   (prRowid AS ROWID):
  /* This is not an open API, ensure that transaction is established */ 
  IF TRANSACTION THEN
  DO:
    FIND {&TABLE-NAME} WHERE ROWID({&TABLE-NAME}) = prRowid EXCLUSIVE NO-ERROR.
    IF AVAIL {&TABLE-NAME} THEN
    DO:
      DELETE {&TABLE-NAME} NO-ERROR.
      RETURN NOT ERROR-STATUS:ERROR.
    END.
  END.
  RETURN FALSE.
END.
&ENDIF
&ENDIF

{&DB-REQUIRED-END}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-createBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createBuffer Method-Library 
FUNCTION createBuffer RETURNS HANDLE
  ( pcBuffer AS CHAR,
    pcPhysicalName AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isAdd Method-Library 
FUNCTION isAdd RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isCopy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isCopy Method-Library 
FUNCTION isCopy RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isCreate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isCreate Method-Library 
FUNCTION isCreate RETURNS LOGICAL FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 12.19
         WIDTH              = 52.
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

&IF DEFINED(EXCLUDE-clearLogicRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearLogicRows Method-Library 
PROCEDURE clearLogicRows :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
   IF AVAILABLE b_{&DATA-LOGIC-TABLE} THEN
       DELETE b_{&DATA-LOGIC-TABLE} NO-ERROR.
        
   IF AVAILABLE OLD_{&DATA-LOGIC-TABLE} THEN
       DELETE OLD_{&DATA-LOGIC-TABLE} NO-ERROR.

   EMPTY TEMP-TABLE rowObjUpd NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogicBeforeBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogicBeforeBuffer Method-Library 
PROCEDURE getLogicBeforeBuffer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE OUTPUT PARAMETER ohBeforeBuffer       AS HANDLE   NO-UNDO.
   ohBeforeBuffer = BUFFER old_{&DATA-LOGIC-TABLE}:HANDLE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogicBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogicBuffer Method-Library 
PROCEDURE getLogicBuffer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE OUTPUT PARAMETER ohUpdateBuffer       AS HANDLE   NO-UNDO.
   ohUpdateBuffer = BUFFER b_{&DATA-LOGIC-TABLE}:HANDLE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogicRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogicRows Method-Library 
PROCEDURE getLogicRows :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE OUTPUT PARAMETER TABLE FOR b_{&DATA-LOGIC-TABLE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-runTableEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runTableEvent Method-Library 
PROCEDURE runTableEvent :
/*------------------------------------------------------------------------------
  Purpose:  Receives RowObjUpd table by reference to allow static DLP table 
            hook to operate on it.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER TABLE FOR b_{&DATA-LOGIC-TABLE}.
  DEFINE INPUT PARAMETER pcHook AS CHARACTER  NO-UNDO.
 
  RUN VALUE(pcHook) IN TARGET-PROCEDURE.  

  RETURN RETURN-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogicBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLogicBuffer Method-Library 
PROCEDURE setLogicBuffer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE INPUT PARAMETER phAfterImageBuffer       AS HANDLE NO-UNDO. 
   DEFINE INPUT PARAMETER phBeforeImageBuffer      AS HANDLE NO-UNDO. 

   DEFINE VARIABLE hBuffer    AS HANDLE       NO-UNDO.
   
   IF VALID-HANDLE(phAfterImageBuffer) THEN
   DO:
       hBuffer = BUFFER b_{&DATA-LOGIC-TABLE}:HANDLE.
       hBuffer:BUFFER-COPY(phAfterImageBuffer).
   END.
 
   IF VALID-HANDLE(phBeforeImageBuffer) THEN
   DO:
       hBuffer = BUFFER OLD_{&DATA-LOGIC-TABLE}:HANDLE.
       hBuffer:BUFFER-COPY(phBeforeImageBuffer).
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogicRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLogicRows Method-Library 
PROCEDURE setLogicRows :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER TABLE FOR b_{&DATA-LOGIC-TABLE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-createBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createBuffer Method-Library 
FUNCTION createBuffer RETURNS HANDLE
  ( pcBuffer AS CHAR,
    pcPhysicalName AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Create a buffer  
    Notes: Called by create objects to create buffers for the query 
           Overridden by the data logic procedure for temp-tables that 
           are used in the query      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer AS HANDLE  NO-UNDO.
  CREATE BUFFER hBuffer FOR TABLE pcPhysicalName BUFFER-NAME pcBuffer NO-ERROR.
  RETURN hBuffer.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isAdd Method-Library 
FUNCTION isAdd RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN (AVAILABLE b_{&DATA-LOGIC-TABLE} AND b_{&DATA-LOGIC-TABLE}.Rowmod = 'A':U).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isCopy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isCopy Method-Library 
FUNCTION isCopy RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN (AVAILABLE b_{&DATA-LOGIC-TABLE} AND b_{&DATA-LOGIC-TABLE}.Rowmod = 'C':U).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isCreate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isCreate Method-Library 
FUNCTION isCreate RETURNS LOGICAL:
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN (AVAILABLE b_{&DATA-LOGIC-TABLE} 
          AND (b_{&DATA-LOGIC-TABLE}.Rowmod = 'A':U
               or
               b_{&DATA-LOGIC-TABLE}.Rowmod = 'C':U)
               ).      

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

