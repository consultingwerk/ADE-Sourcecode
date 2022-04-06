&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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
  File: afttnode.i

  Description:  ttNode temp-table manipulation

  Purpose:      This file contains the code that manipulates the ttNode table.
                
                It was extracted from afxmlcfgp.p to be reused in other programs.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   11/14/2001  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes

/* This table is a working table that is used to manipulate the data that 
   is contained in the ICFCONFIG file. */
DEFINE TEMP-TABLE ttNode NO-UNDO
  FIELD cNode      AS CHARACTER FORMAT "X(25)"
  FIELD cValue     AS CHARACTER FORMAT "X(50)"
  FIELD iNodeLevel AS INTEGER
  FIELD lDelete    AS LOGICAL
  INDEX pudx IS UNIQUE PRIMARY
    cNode
  INDEX dxDelete 
    lDelete
  INDEX dxNodeLevel
    iNodeLevel
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNode Include 
FUNCTION getNode RETURNS CHARACTER
  ( INPUT pcNode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNode Include 
FUNCTION setNode RETURNS LOGICAL
  ( INPUT pcNode   AS CHARACTER,
    INPUT pcValue  AS CHARACTER,
    INPUT piNodeLevel AS INTEGER,
    INPUT plDelete AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 21.81
         WIDTH              = 62.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNode Include 
FUNCTION getNode RETURNS CHARACTER
  ( INPUT pcNode AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value associated with a node.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttNode FOR ttNode.
  DEFINE VARIABLE cRetVal AS CHARACTER  NO-UNDO.

  /* Find the ttNode record and set the return value 
     to the value of the node */
  DO FOR bttNode:
    FIND bttNode
      WHERE bttNode.cNode = pcNode
      NO-ERROR.
    IF NOT AVAILABLE(bttNode) THEN
      cRetVal = ?.
    ELSE
      cRetVal = bttNode.cValue.
  END.
  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNode Include 
FUNCTION setNode RETURNS LOGICAL
  ( INPUT pcNode   AS CHARACTER,
    INPUT pcValue  AS CHARACTER,
    INPUT piNodeLevel AS INTEGER,
    INPUT plDelete AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the value of node entries in the node table.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE BUFFER bttNode FOR ttNode.

  /* Find the ttNode record, creating it if necessary, and set the 
     value of the node to the value in the input parameter */
  DO FOR bttNode:
    FIND bttNode
      WHERE bttNode.cNode = pcNode
      NO-ERROR.
    IF NOT AVAILABLE(bttNode) THEN
    DO:
      CREATE bttNode.
      ASSIGN
        bttNode.cNode = pcNode
        .
    END.
    ASSIGN
      bttNode.cValue     = replaceCtrlChar(pcValue,NO)
      bttNode.iNodeLevel = piNodeLevel
      bttNode.lDelete    = plDelete
      .
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

