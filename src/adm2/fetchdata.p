&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*-----------------------------------------------------------------------------
  File: fetchdata.p 

 Description: Stateless retrieval of data from a container  
 Purpose:     Allow a client container to retrieve data from the server 
              with ONE appserver call  

 Parameters: 
   input        pcObject    - physical object name of a container       
                              Will be extended to support logical icf SDOs 
   input-output piocContext - Context from client to server 
                              Will return new context to client  
                              See container.p   
   inout       pcObjects     
   input       pcClientnames
   input       pcQueries   -
   
   input       pcPosition 
   inout       pcForeignFields
   output table phRowObject1-32 - RowObject table
                                  We add this as dynamic definition to the 
                                  SDOs.                                    
   
   output        pocMessages    - error messages in adm format
                                                               
 Notes:      
 
 History:
------------------------------------------------------------------------------*/
 
/* ***************************  Definitions  ************************** */
  DEFINE INPUT  PARAMETER pcContainer     AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER piocContext AS CHARACTER  NO-UNDO.

  DEFINE INPUT  PARAMETER pcObjects       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcClientNames   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcForeignFields AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcQueries       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcPositions     AS CHARACTER  NO-UNDO.

  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject1.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject2.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject3.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject4.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject5.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject6.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject7.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject8.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject9.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject10.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject11.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject12.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject13.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject14.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject15.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject16.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject17.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject18.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject19.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject20.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject21.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject22.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject23.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject24.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject25.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject26.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject27.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject28.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject29.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject30.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject31.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject32.

  DEFINE OUTPUT PARAMETER pocMessages  AS CHARACTER  NO-UNDO.

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
         HEIGHT             = 6
         WIDTH              = 80.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
&SCOPED-DEFINE  TTHandle         phRowObject
&SCOPED-DEFINE  NumTTs           32
&SCOPED-DEFINE  ContextString    piocContext
&SCOPED-DEFINE  Container        pcContainer
&SCOPED-DEFINE  Messages         pocMessages
&SCOPED-DEFINE  createObjects    serverCreateDataObjects
&SCOPED-DEFINE  createParams     pcObjects,pcClientNames,pcForeignFields,piocContext
&SCOPED-DEFINE  initializeObject initializeObject
&SCOPED-DEFINE  fetchData        bufferFetchContainedData
&SCOPED-DEFINE  fetchParams      pcQueries,pcPositions

{src/adm2/fetchrowobject.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


