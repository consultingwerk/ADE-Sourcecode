&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
    File        : _openfile.w  
    Purpose     : Run system-dialog.. 
                  (dynamic number of filters) 
    Syntax      :
    Description :   copy of _opnfile, but no remote supprot
 
    Parameters  : 
     INPUT        ptitle  - Title of dialog 
     INPUT        pfilter - COMMA separated string with filters.
                            MUST have the real filter in parenthesis.                                                            
                            USE Semicolon to separate filters ! 
                            Example "ALl Source(*.p;*.i;*.w),R-code files (*.r)". 
     INPUT-OUTPUT pfile   - filename, set to "" if nothing is found.
       
    Author(s)   : Havard Danielsen
    Created     : Feb 1998
    Notes       : Currently maximum 6 filters.
                  Could easily be extended.                   
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT        PARAMETER pTitle  AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pFilter AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pFile   AS CHARACTER NO-UNDO.
  
DEFINE VAR PickedOne  AS LOGICAL   NO-UNDO.
DEFINE VAR Path       AS CHARACTER NO-UNDO.
DEFINE VAR TempFile   AS CHARACTER NO-UNDO.
DEFINE VAR i          AS INTEGER   NO-UNDO.
DEFINE VAR gDelimiter AS CHARACTER INIT ",":U NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFilter Procedure 
FUNCTION getFilter RETURNS CHARACTER
  ( pin as int)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFilterText Procedure 
FUNCTION getFilterText RETURNS CHARACTER
  ( pin as int)  FORWARD.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* Remove slash, SYSTEM-DIALOG GET_GILE Aborts if / is used in file name */
pFile = REPLACE (pFile,"/":U,"~\":U).

/* 
getFilterText() returns the entry from the comma separated 
input parameter pFilter.
   
getFilter strips the part in the parenthesis. 
   
The use of a function makes the System dialog overlook it 
if it is blank. (Magic ! ) 
*/  
                
SYSTEM-DIALOG GET-FILE pFile 
    FILTERS getFilterText(1) getFilter(1),           
            getFilterText(2) getFilter(2),
            getFilterText(3) getFilter(3),
            getFilterText(4) getFilter(4),
            getFilterText(5) getFilter(5),
            getFilterText(6) getFilter(6),
            getFilterText(7) getFilter(7),
            getFilterText(8) getFilter(8),
            getFilterText(9) getFilter(9)
    
    DEFAULT-EXTENSION  getFilter(1)
    TITLE              pTitle
    MUST-EXIST
    USE-FILENAME
    UPDATE             PickedOne.  

IF PickedOne then
   /* See if it can be located in the PROPATH */
DO i = 1 to NUM-ENTRIES(PROPATH):
  FILE-INFO:FILE-NAME = TRIM(ENTRY(i,PROPATH)).

  IF pFile BEGINS FILE-INFO:FULL-PATHNAME 
  AND FILE-INFO:FULL-PATHNAME NE ? THEN 
  DO:       
    /* If it's there, chop off the leading part */
    pFile = SUBSTRING(pFile, LENGTH(RIGHT-TRIM(FILE-INFO:FULL-PATHNAME,"~\":U)) + 2, -1,"CHARACTER":U).
    LEAVE.
  END.
END.

IF NOT PickedOne THEN 
  ASSIGN pFile = "":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilter Procedure 
FUNCTION getFilter RETURNS CHARACTER
  ( pin as int) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  Def var a as char.
  Def var rp as int.
  Def var lp as int.
  Assign 
    a  = getFilterText(pin)
    lp = index(a,'(') + 1
    rp = index(a,')').
  
  RETURN if lp > 1 and rp > lp 
         then (substr(a,lp,rp - lp))
         else "":U.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterText Procedure 
FUNCTION getFilterText RETURNS CHARACTER
  ( pin as int) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN if num-entries(pfilter,gDelimiter) >= pin 
         then entry(pin,pfilter,gDelimiter)
         else "":U. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

