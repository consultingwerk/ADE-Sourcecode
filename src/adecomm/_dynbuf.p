&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : adecomm/_dynbuf.p
    Purpose     : Run persistent for programs that need to access query data  

    Syntax      : RUN adecomm/_dynbuf.p persistetn set <handle>
                  setBuffers('<bufferlist>') in <handle>

    Description : A dynamic query is used to store the buffer handles. 
                  the get* functions retrieves the data through the dynamic query  
                                                        
    Author(s)   : H Danielsen 
    Created     : April 1999 
    Notes       : The program is used to make ForeignFields (adecomm/_mfldmap) 
                  available for queries.  
                  The current use could probably have been achieved by just
                  having a getTables function that returned a character string,
                  But by using a dynamic query we ensure that the buffers 
                  always are valid.      
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE VARIABLE ghQuery AS HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataColumns Procedure 
FUNCTION getDataColumns RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTables Procedure 
FUNCTION getTables RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBuffers Procedure  _DB-REQUIRED
FUNCTION setBuffers RETURNS LOGICAL
  (pcBuffers AS CHAR)  FORWARD.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataColumns Procedure 
FUNCTION getDataColumns RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return the unqualified names of all Columns of the buffers  
    Notes: This is equivalent to what is returned by a SmartDataObject  
------------------------------------------------------------------------------*/
  DEF VAR iBuf    AS INT     NO-UNDO. 
  DEF VAR iFld    AS INT     NO-UNDO. 
  DEF VAR hFld    AS HANDLE  NO-UNDO. 
  DEF VAR hBuffer AS HANDLE  NO-UNDO. 
  DEF VAR cCols   AS CHAR    NO-UNDO. 
  
  IF NOT VALID-HANDLE(ghQuery) THEN
    RETURN ?. 

  DO iBuf = 1 TO ghQuery:NUM-BUFFERS:
     hBuffer = ghQuery:GET-BUFFER-HANDLE(iBuf).
     DO iFld = 1 TO hBuffer:NUM-FIELDS:
       ASSIGN
         hFld  = hBuffer:BUFFER-FIELD(iFld)
         cCols = cCols + (IF cCols = "":U THEN "":U ELSE ",":U)
                 + hFld:NAME.
     END.  
  END.
  
  RETURN cCols. 
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTables Procedure 
FUNCTION getTables RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the TABLE names of this object.  
    Notes: Note that the <buffer>:TABLE always returns the dictionary name
           also if the setBuffers used buffer names.   
------------------------------------------------------------------------------*/
  DEF VAR i       AS INT     NO-UNDO. 
  DEF VAR hBuffer AS HANDLE  NO-UNDO. 
  DEF VAR cTables AS CHAR    NO-UNDO. 
  
  IF NOT VALID-HANDLE(ghQuery) THEN 
    RETURN ?.
  
  ELSE 
  DO i = 1 TO ghQuery:NUM-BUFFERS:
    ASSIGN
      hBuffer  = ghQuery:GET-BUFFER-HANDLE(i)
      cTables = cTables 
                 + (IF cTables = "":U THEN "":U ELSE ",":U) 
                 + hBuffer:TABLE.
  END.
  RETURN cTables.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBuffers Procedure 
FUNCTION setBuffers RETURNS LOGICAL
  (pcBuffers AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Create dynamic buffers and add them to the dynamic query.   
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR i       AS INT     NO-UNDO. 
  DEF VAR hBuffer AS HANDLE  NO-UNDO. 
 
  IF NOT VALID-HANDLE(ghQuery) THEN 
    CREATE query ghQuery.
  
  ELSE 
  DO i = 1 TO ghQuery:NUM-BUFFERS:
     hBuffer = ghQuery:GET-BUFFER-HANDLE(i).
     DELETE WIDGET hBuffer.
  END.
  
  DO i = 1 TO NUM-ENTRIES(pcBuffers):
    CREATE BUFFER hBuffer FOR TABLE ENTRY(i,pcBuffers). 
    IF i = 1 THEN 
      ghQuery:SET-BUFFERS(hBuffer).
    ELSE
      ghQuery:ADD-BUFFER(hBuffer).
      
  END.
   
  RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

