&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
    File        : _sdoinfo.p
    Purpose     : Return columnprops or other functions from a SmartDataObject
    Syntax      :
                 Return columnprops 
                  URL 
                    + <path>/_sdocolp.p
                    + "?procedure=d-cust.w"
                    + "&columns=*"   
                    + "&properties=Datatype,initial"
                 
                 Return ADM2 properties 
                 URL 
                  + <path>/_sdocolp.p
                  + "?procedure=d-cust.w"
                  + "&properties=AppService,RowsToBatch"
                 
                 Call any function 
                 URL 
                  + <path>/_sdocolp.p
                  + "?procedure=d-cust.w"
                  + "&function=getAppService" OR "&attribute=getAppService" 
                                    
 
    Parameters  : procedure  = SmartDataObject 
                  function   = functionname
                  columns    = First parameter when function = "columnProps" 
                               - Which columns (* = all)
                  properties = If columns <> '' 
                               - Second parameter to columnProps 
                               else
                               - adm2 properties 
                  attribute  = 'db-reference' and 'objectViewer'
                               but will also work for any function   
                  
                               
    Description : Made to be called from the Crescent CIHTTP control.  
                  Just sends back whatever the columnprops function returns 
                  without any HTML tags.

    Author(s)   : Haavard Danielsen                  
    Created     : April, 1998
    Notes       : Kills the SDO when its finished
------------------------------------------------------------------------*/
/*       This .W file was created with the Progress AppBuilder.         */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE VARIABLE hProc      AS HANDLE    NO-UNDO.
DEFINE VARIABLE cFunction  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAttribute AS CHARACTER NO-UNDO.
DEFINE VARIABLE cProcName  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumns   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cProps     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cReturn    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDelimit   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFuncValue AS CHARACTER NO-UNDO.

DEFINE VARIABLE i         AS INTEGER   NO-UNDO.
DEFINE VARIABLE CallError AS LOG       NO-UNDO.

DEFINE TEMP-TABLE ttEntries
  FIELD cEntry AS CHARACTER
  FIELD cParam AS CHARACTER
  INDEX cEntry IS PRIMARY cEntry.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetParams Procedure 
FUNCTION GetParams RETURNS CHARACTER
  (pFunc AS CHAR)  FORWARD.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{webtools/webtool.i}
{src/web/method/wrap-cgi.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


ASSIGN 
  cProcName  = get-field("Procedure":U)

  cAttribute = get-field("Attribute")
  cFunction  = get-field("Function":U)  
  /* properties may be a list of adm2 properties or 
     the list of columnprops */
  cProps     = get-Field("Properties":U)   
  cColumns   = get-field("Columns":U).

/* both 'functions' and 'function' are valid */ 
IF cFunction = "" THEN 
   cfunction = get-field("Functions":U).
 
/* Support the case where attribute is used instead of function  (v3.0) */ 
IF cAttribute <> "" AND cFunction = "" THEN
  cFunction = cAttribute.  

RUN outputContentType IN web-utilities-hdl ("text/plain":U).  
{&out} "<!-- Generated by Webspeed: http://www.webspeed.com/ -->~n~n" .

/*** 
Should we consider looking for a running one ? 
If we do we need to have means to ask for a fresh one in case its been changed.   
    
hProc = SESSION:FIRST-PROCEDURE.
DO WHILE VALID-HANDLE(hProc) :
  IF hProc:file-name =  
  hProc = hProc:NEXT-SIBLING.
END.
***/

/* Do on stop to catch compile errors */ 
DO ON STOP UNDO, LEAVE:  
  RUN VALUE(cProcName) PERSISTENT SET hProc NO-ERROR.
END.
   
IF VALID-HANDLE(hProc) THEN DO:
  IF cColumns = "" THEN
  DO:  
    IF cAttribute eq "DB-REFERENCES":U THEN     
      ASSIGN
        cReturn = hProc:DB-REFERENCES NO-ERROR.      
    ELSE IF cAttribute eq "ObjectViewer" THEN
      RUN showObject.
    
    ELSE DO i = 1 TO IF cProps <> "" 
                     THEN NUM-ENTRIES(cProps)
                     ELSE NUM-ENTRIES(cFunction):
                      
      cFuncValue = DYNAMIC-FUNCTION(
                       (IF cProps <> "" THEN "get" ELSE "")
                       + ENTRY(i,IF cProps <> "" THEN cProps ELSE cFunction)
                         in hProc 
                                    ) 
                   NO-ERROR.           
      
      IF cFuncValue = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
      DO:
        cReturn = ?.   
        LEAVE.
      END.  
      ASSIGN 
         cReturn = cReturn 
                   + cDelimit
                   + (IF cFuncValue = ? THEN "?" ELSE cFuncValue)          
         cDelimit = CHR(1).
    END.   
  END.
  ELSE DO:  
    /*** 
    This is only designed to support columnprops, 
    but using whatever is passed as a function will return meaningful (?)
    Progress messages.    
    It might even work if the function called has 2 parameters  
    */         
    ASSIGN
      cReturn = DYNAMIC-FUNCTION(cFunction in hProc,
                                 cColumns,
                                 cProps) NO-ERROR.      

   END.
   
   IF cReturn = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
     CallError = TRUE. 
     Run OutError.            
   END.
END.

IF VALID-HANDLE(hProc) THEN 
  DELETE PROCEDURE hProc NO-ERROR.

IF CallError THEN RETURN.

IF COMPILER:ERROR 
OR ERROR-STATUS:ERROR THEN
DO:
  Run OutError.
  RETURN.
END.

{&OUT}
    cReturn.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OutError Procedure 
PROCEDURE OutError :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   {&OUT} 
   "ERROR:":U SKIP.           
   DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:            
     {&OUT}
     ERROR-STATUS:GET-MESSAGE(i) SKIP.
   END.  
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showObject Procedure 
PROCEDURE showObject :
/*------------------------------------------------------------------------------
  Purpose:     Display Internal Entries and associated Parameters
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSmartData AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cParamList AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPList     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ij         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ix         AS INTEGER   NO-UNDO.

  /* Standard header */
  {&OUT}
    {webtools/html.i
      &AUTHOR   = "D.M.Adams"
      &FRAME    = "WS_main"
      &TITLE    = "Internal Entries and Parameters"
      &SEGMENTS = "head,open-body,title-line"
      &CONTEXT  = "{&Webtools_Smart_Data_Object_Help}" }.

  ASSIGN
    FILE-INFO:FILE-NAME = hProc:FILE-NAME
    cSmartData          = FILE-INFO:FULL-PATHNAME.
    
  {&OUT}
    '<BR><CENTER><FONT SIZE = +2>':U cSmartData '</FONT></CENTER>~n':U.
    
  /* Output a table header. */
  {&OUT}
    '<CENTER>~n':U
    '<BR><TABLE':U get-table-phrase('') '>~n':U
    '<TR><TH>':U format-label ('Internal Entries', "COLUMN":U, "") '</TH>~n':U
    '    <TH>':U format-label ('Parameters', "COLUMN":U, "":U) '</TH>~n':U
    '</TR>~n':U
    .
    
  /* Load temp-table with entries for sorting. */
  DO ix = 1 TO NUM-ENTRIES(hProc:INTERNAL-ENTRIES):
    CREATE ttEntries.
    ASSIGN
      ttEntries.cEntry = ENTRY(ix, hProc:INTERNAL-ENTRIES)
      cPList           = hProc:GET-SIGNATURE(ttEntries.cEntry).
      
    /* If it's a Function, insert a line indicating the data type of the 
       return value. */
    IF ENTRY(1,cPList) = "FUNCTION":U THEN
      ASSIGN
        ttEntries.cParam = "FUNCTION returns ":U + CAPS(ENTRY(2,cPList)).
     
    IF NUM-ENTRIES(cPList) > 2 THEN
    DO ij = 3 TO NUM-ENTRIES(cPList):
      ttEntries.cParam = ttEntries.cParam + 
                         (IF ttEntries.cParam eq "" THEN "" ELSE "<BR>":U) + 
                         ENTRY(ij,cPList).
    END.
    
    IF ttEntries.cParam eq "" THEN
      ttEntries.cParam = "&nbsp~;":U.
  END.
  
  /* Display the sorted internal entries and parameters. */
  FOR EACH ttEntries:
    {&OUT}
      '<TR><TD>':U ttEntries.cEntry '</TD>~n':U
      '    <TD>':U ttEntries.cParam '</TD></TR>~n':U.
  END.
  
  {&OUT}
    '</TABLE>~n':U
    '</BODY>~n':U
    '</HTML>~n':U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetParams Procedure 
FUNCTION GetParams RETURNS CHARACTER
  (pFunc AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE LeftPos AS INT NO-UNDO. 
  DEFINE VARIABLE RightPos AS INT NO-UNDO. 
  
  LeftPos = INDEX (pFunc,"(").
    
  IF LeftPos > 1 THEN 
  DO: 
    RightPos = MAX(LeftPos,R-INDEX(pFunc,")") - 1).
     
    RETURN(SUBSTR(pFunc,LeftPos + 1,RightPos - Leftpos)) .    
  END.
  ELSE
    RETURN "".   /* Function return value. */
  
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

