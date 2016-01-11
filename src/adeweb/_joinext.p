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
    File        : adeweb/_joinext.p
    Purpose     : Add join criteria for different external tables for 
                  a query. 
    Syntax      :

    Description : This handles the conversion to and from QB attributes 
                  and WebSpeed ExternalJoin attributes.
                  QB - _Tbllist   <table1> WHERE <table2> ...  or OF <table2> 
                                  CHR(3) separated, second table is used to 
                                  find the right fields in the right selection 
                                  list in QB.    
                       _joincode  Array with blank if OF and expression if WHERE
                       _wherecode additonal 
                  WebSpeed:ExternalJoins CHR(3) separated for each external
                                         table, Comma separated for each table
                                         in the query. Contains OF phrase 
                                         or Expression.                                      
    Input Parameters:
                  pExternalTables - Comma seperated list of External tables
                  pmode           - 'Edit' - start QueryBuilder to edit the join  
                                    Blank  - Create output parameters from QB's
                                             or from input parameters.  
    Input-output parameters
                  pJoinCode       - Comma separated list of joins for each 
                                    table in the query.
                                    - INPUT Blank - use GLOBAL SHARED _joincode
                                    -      
                  pWhereCode      - Comma separated list of additional 
                                    where criteria for each 
                                    table in the query.  
                  p4glQuery       - The 4gl query. 
                                    Defined as I-O in order to keep it in case   
                                    the QB is cancelled.
    
    Author      : Haavard Danielsen    
    Created     : July 1998
    Notes       : The join and where criteria is NOT stored in the _Q record,
                  only output to the caller.
                  The following GLOBAL shared variables are temporarily changed,
                  but reset to their original values when exiting the program. 
                  _tbllist
                  _joincode
                  _where 
                  _4glqury
                  
                  Their original values are used to get correct data 
                  if the input parameter for joincode and where is empty.                                     
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT        PARAMETER pExternalTables AS CHAR NO-UNDO.
DEFINE INPUT        PARAMETER pMode           AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pJoinCode       AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pWhereCode      AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p4GLQuery       AS CHAR NO-UNDO.

DEFINE VARIABLE cLastExternal  AS CHAR NO-UNDO.
DEFINE VARIABLE cTable         AS CHAR NO-UNDO.
DEFINE VARIABLE cEntry         AS CHAR NO-UNDO.
DEFINE VARIABLE cOfJoin        AS CHAR NO-UNDO.
DEFINE VARIABLE cValidOptions  AS CHAR NO-UNDO.
DEFINE VARIABLE lCancelled     AS LOG  NO-UNDO.
DEFINE VARIABLE cLoopDelimit   AS CHAR NO-UNDO.
DEFINE VARIABLE i              AS INT  NO-UNDO.
DEFINE VARIABLE iInternal      AS INT  NO-UNDO.
DEFINE VARIABLE lOF            AS LOG  NO-UNDO.
DEFINE VARIABLE lIncomplete    AS LOG  NO-UNDO.
DEFINE VARIABLE lCanUseOf      AS LOG  NO-UNDO.
DEFINE VARIABLE xcDlmt         AS CHAR NO-UNDO.
xCDlmt = CHR(3).

/* QueryBuilder definitions */
{adeuib/uniwidg.i}
{adeuib/brwscols.i}
{adeuib/triggers.i}
{adeuib/sharvars.i}
{adecomm/adefext.i}
{adeshar/quryshar.i "NEW GLOBAL"}
{adecomm/tt-brws.i "NEW"}

DEFINE STREAM P_4GL.
DEFINE VARIABLE cOldTablelist  AS CHAR NO-UNDO.
DEFINE VARIABLE cOldQuery      AS CHAR NO-UNDO.
DEFINE VARIABLE cOldJoinCode   AS CHAR NO-UNDO EXTENT {&MaxTbl}.
DEFINE VARIABLE cOldWhereCode  AS CHAR NO-UNDO EXTENT {&MaxTbl}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CanJoin Procedure 
FUNCTION CanJoin RETURNS LOGICAL
  (pTable      AS CHAR,
   pJoinTable AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD JoinTable Procedure 
FUNCTION JoinTable RETURNS CHARACTER
  (pTable AS CHAR,
   pWhere AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SortByPhrase Procedure 
FUNCTION SortByPhrase RETURNS CHARACTER
  (Suppress_Dbname AS LOG)  FORWARD.

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
/**
message 
'_4GLQury:    ' _4GLQury  skip
'_TblList:    ' _TblList  skip
'_AliasList:  ' _AliasList  skip 
'_CallBack:   ' _CallBack  skip
'_OrdList:    ' _OrdList skip
'_JoinCode[1]:'  _JoinCode[1] skip
'_JoinCode[2]:'  _JoinCode[2] skip
'_JoinCode[3]:'  _JoinCode[3] skip
'_Where[1]:   ' _Where[1] skip
'_Where[2]:   ' _Where[2] skip 
'_Where[3]:   ' _Where[3] skip           
'_optionlist: ' _OptionList skip 
'_TblOptList: ' _TblOptList skip
'_TuneOptions:' _TuneOptions 
 view-as alert-box.
**/

&SCOP EOL  chr(10)

DO i = 1 TO {&MaxTbl}:
  ASSIGN
    cOldJoinCode[i]  = _JoinCode[i] 
    cOldWhereCode[i] = _Where[i] .
END.

/* If any of the externaltables is in the query it is removed */ 
DO i = 1 TO NUM-ENTRIES(_TblList,xcDlmt):     
  ASSIGN
    cEntry = ENTRY(i,_TblList,xcDlmt)          
    cTable = ENTRY(1,cEntry," ":U). /* find the table name */
  IF LOOKUP(cTable,pExternalTables) > 0 THEN
  DO:
    /* Blank the entry and remove extra commas at beginning, middle or end 
       of the list */
    ASSIGN
      ENTRY(LOOKUP(cTable,pExternalTables),pExternalTables) = "":U
      pExternalTables = REPLACE(pExternalTables,",,":U,",":U)
      pExternalTables = LEFT-TRIM(pExternalTables,",":U)
      pExternalTables = RIGHT-TRIM(pExternalTables,",":U).
  END. 
END.

/* We must do the jointest before the dbname is removed */
IF pJoinCode = "" THEN
DO:
  ASSIGN
    cLastExternal = ENTRY(NUM-ENTRIES(pExternalTables),pExternalTables)  
    lCanUseOf     = CanJoin(cLastExternal,cTable).
END.

/* qbuild.i cannot deal with a dbname in the _tbllist 
  so remove db name from external */                          
DO i = 1 TO NUM-ENTRIES(pExternalTables):
  ASSIGN
    cTable                   = ENTRY(i,pExternalTables)    
    ENTRY(i,pExternalTables) = IF NUM-ENTRIES(cTable,".":U) = 2  
                               THEN ENTRY(2,cTable,".":U) 
                               ELSE cTable.    
END.

/* 
If no input parameter (first time) 
move shared data to correct extent (ADD external tables) 
*/  

ASSIGN
  cOldQuery        = _4GlQury
  cOldTableList    = _Tbllist 
  cValidOptions    = IF NUM-ENTRIES(pExternalTables) = 1 THEN "Join":U
                     ELSE                                     "Join,Where":U 
  
  /* Add external tables to the list of tables used by _query.p and qbuild.i.
     Mark it as <external>. */
  _TblList         = REPLACE(pExternalTables + ",":U,",":U," <external>" + xcDlmt)
                     + _Tbllist.

IF pJoincode = "":U THEN
DO:
  /* Create a default join for the first table in the query with the 
     last external table */
  ASSIGN
    i         = NUM-ENTRIES(pExternalTables) + 1
    cEntry    = ENTRY(i,_TblList,xcDlmt)          
    cTable    = ENTRY(1,cEntry," ":U) /* find the table name */
    /* Remove db (qbuild requires that) */
    cEntry    = REPLACE(cEntry,cTable,
                      IF lCanUseOf THEN
                        cTable + " OF ":U + cLastExternal     
                      ELSE
                        cTable + " WHERE ":U + cLastExternal + " ...":U)                      
    ENTRY(i,_Tbllist,xcDlmt) = cEntry
   .  
  /* External table(s) are added to _tbllist so we must
     move all existing joincodes and where to their new corresponding extent */
  DO i = NUM-ENTRIES(_TblList,xcDlmt) TO NUM-ENTRIES(pExternalTables) + 1 BY -1:
    ASSIGN 
      _JoinCode[i] = _JoinCode[i - NUM-ENTRIES(pExternalTables) ]
      _Where[i]    = _Where[i - NUM-ENTRIES(pExternalTables)].     
  END.  
END. /* if pJoinCode = '' */

/* If input parameter copy them to the correct shared arrays */
ELSE DO:
     
  /* Move the comma separated list to the SHARED extents */  
  DO i = NUM-ENTRIES(pExternalTables) + 1 TO NUM-ENTRIES(_TblList,xcDlmt):        
    ASSIGN
       iInternal        = i - NUM-ENTRIES(pExternalTables)
       lOF              = ENTRY(iInternal,pJoinCode) BEGINS "OF ":U 
       lInComplete      = ENTRY(iInternal,pJoinCode) BEGINS "TRUE /*":U 
      _JoinCode[i]      = IF lOF OR lInComplete 
                          THEN ?
                          ELSE ENTRY(iInternal,pJoinCode)         
      _Where[i]         = ENTRY(iInternal,pWhereCode)       
      cEntry            = ENTRY(i,_TblList,xcDlmt)      
      cTable            = ENTRY(1,cEntry," ":U)      
      cEntry            = IF lOf THEN
                            cTable + " ":U + ENTRY(iInternal,pJoinCode)     
                          ELSE
                            cTable 
                            + " WHERE ":U 
                            + JoinTable(cTable,ENTRY(iInternal,pJoinCode))
                            + ' ...':U
      ENTRY(i,_Tbllist,xcDlmt) = cEntry.
  END.  
END. /* else do ie: (pJoincode <> '') */

/* Make the extents that now corresponds to external tables unknown */
DO i = 1 TO NUM-ENTRIES(pExternalTables):
  ASSIGN
    _Joincode[i] = ?
    _Where[i]    = ?. 
END.

IF pMode = "Edit":U THEN
DO:
  RUN adeshar/_query.p ("":U,             /* browsername */       
                      _suppress_dbname, 
                     'AB',              /* AppBuilder */ 
                      cValidOptions,   /* depending on num external tables */
                      NO,               /* visitfields */
                      YES,              /* autocheck */
                      OUTPUT lCancelled).

END. /* pmode = "edit" */
ELSE DO:
               
 {adeshar/qbuild.i 
    &4GLQury    = _4GLQury
    &TblList    = _TblList
    &JoinCode   = _JoinCode
    &Where      = _Where
    &SortBy     = sortByPhrase(_suppress_dbname)
    &use_dbname = "NOT _suppress_dbname"
    &OptionList = _OptionList
    &TblOptList = _TblOptList 
    &Sep1       = xcDlmt  
    &ExtTbls    =  1 
    &Mode       = "TRUE"  
    &Preprocess = "FALSE"
    }   
         
END. /* else do (pmode <> 'edit) */

IF NOT lCancelled THEN 
DO: 
 
 ASSIGN
   p4GLQuery    = LEFT-TRIM(REPLACE(_4glQury,":":U,"":U),"FOR ":U)  
   pJoinCode    = "":U 
   pWhereCode   = "":U
   cLoopDelimit = "":U.
 
 DO i = 1 + NUM-ENTRIES(pExternalTables) TO NUM-ENTRIES(_TblList,xcDlmt):
    
   ASSIGN
     cEntry     = ENTRY(i,_TblList,xcDlmt)
     cTable     = ENTRY(1,cEntry," ":U)
                  /* Find the phrase behind the table to see if it's a of */
     cOfJoin    = IF _Joincode[i] = ? OR _Joincode[i] = "":U THEN 
                  TRIM(REPLACE(ENTRY(i,_TblList,xcDlmt),cTable + " ":U,"":U))
                  ELSE "":U
     cOfJoin    = IF cOfJoin BEGINS "OF ":U
                  THEN cOfJoin 
                  ELSE "":U 
                  
     /* If OF phrase store it as a join else store the expressioin 
        If there is no join specified in JoinCode then 
        store "TRUE" + table name inside comments */ 
     pJoinCode  =  pJoinCode 
                   + cLoopDelimit
                   + IF cOfjoin <> "":U 
                     THEN cOfJoin  
                     ELSE 
                     IF _joinCode[i] = ?
                     OR _JoinCode[i] = "":U  
                     THEN "TRUE /* ":U + ENTRY(3, cEntry," ":U) + " */":U 
                     ELSE _joincode[i]         
     pWhereCode = pwhereCode 
                  + cLoopDelimit
                  + IF _Where[i] = ? THEN "":U 
                    ELSE _Where[i]
     cLoopDelimit = ",":U.  
 
 END. /* do i = 1 to .... */
    
END. /* if not lcancelled */
 
/* Reset GLOBAL shared variables */
DO i = 1 TO {&MaxTbl}:
  ASSIGN
    _JoinCode[i] = cOldJoinCode[i]  
    _Where[i]    = cOldWhereCode[i].
END.
ASSIGN 
  _TblList = cOldTableList
  _4GlQury = cOldQuery.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CanJoin Procedure 
FUNCTION CanJoin RETURNS LOGICAL
  (pTable      AS CHAR,
   pJoinTable AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Check if the two table can be joined with an OF 
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR cCompIn AS CHAR NO-UNDO.  
  
  RUN adecomm/_tmpfile.p ({&STD_TYP_UIB_TEMPLATE}, {&STD_EXT_UIB}, 
                           OUTPUT cCompIn).
  
  OUTPUT STREAM P_4GL TO VALUE (cCompIn) NO-ECHO {&NO-MAP}.
  
  PUT STREAM P_4GL UNFORMATTED 
      'FOR EACH ' pTable ', EACH ' pJoinTable ' OF ' pTable ': END.'.  
  
  OUTPUT STREAM P_4GL CLOSE.
  
  COMPILE VALUE(cCompin) NO-ERROR. 
  
  /* if the join failed becaus of ambiguos table name give them
     the message that advice them to qualify with db name or disconnect */ 
  IF ERROR-STATUS:GET-NUMBER(i) = 425 THEN
  DO:
    MESSAGE 
     ERROR-STATUS:GET-MESSAGE(i) SKIP
     "You should qualify tables with the logical name of the database" skip
     "or make sure you are only connected to one of the databases."
     VIEW-AS ALERT-BOX WARNING.  
  END. /* if error-status:get-number 425 */
  
  OS-DELETE VALUE(cCompin). 
  RETURN NOT (COMPILER:ERROR). 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION JoinTable Procedure 
FUNCTION JoinTable RETURNS CHARACTER
  (pTable AS CHAR,
   pWhere AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Find the first OTHER table in the where clause  
    Notes: Used to generate the 'table WHERE othertable ...' that is used 
           in the tablelist passed to the QB.     
------------------------------------------------------------------------------*/
  DEF VAR i     AS INT  NO-UNDO.
  DEF VAR iNum  AS INT  NO-UNDO.
  DEF VAR cName AS CHAR NO-UNDO.
  
  DO i = 1 TO NUM-ENTRIES(pWhere," ":U):
    ASSIGN 
      cName  = ENTRY(i,pWhere," ":U)
      iNum   = NUM-ENTRIES(cName,".":U).
    IF iNum > 1 THEN
    DO:      
      cName = ENTRY(iNum - 1,cName,".":U).
      IF cName <> pTable THEN 
        RETURN cName.    
    END.
    
    /* Incomplete join is stored as 'TRUE /* table */' */ 
    IF cName = "/*" THEN 
    DO:
      RETURN ENTRY(i + 1,pWhere," ":U).
    END.
  END.
  
  RETURN "".  /* Unsuccessful */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SortByPhrase Procedure 
FUNCTION SortByPhrase RETURNS CHARACTER
  (Suppress_Dbname AS LOG) :
  DEFINE VARIABLE cSortBy   AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cField AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDir   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i      AS INTEGER NO-UNDO.

 /* If the OptionList includes the SORTBY-PHRASE, then this indicates using a
    a preprocessor variable. */
  IF LOOKUP("SORTBY-PHRASE":U, _OptionList, " ":U) > 0 
  THEN cSortBy = "~~~{&SORTBY-PHRASE}":U.
  ELSE DO:
    &SCOP sep2 CHR(4)
    cSortBy     = "".
    DO i = 1 TO NUM-ENTRIES(_OrdList, xcDlmt):
      /* Indent each line of the "BY" phrase */
      cSortBy = cSortBy + FILL(" ":U, 5 + i).
  
      /* Get the i-th field.  The second element of the cField determines
         the sort direction.  The first element if DB.TABLE.FIELD.  */
      ASSIGN cField = ENTRY (i, _OrdList, xcDlmt)
             cDir   = IF ENTRY(2, cField, {&Sep2}) eq "yes":U
                        THEN "" ELSE " DESCENDING"
             cField = ENTRY(1, cField, {&Sep2}) .
      IF suppress_dbname AND NUM-ENTRIES(cField,".":U) = 3 AND
         INDEX(cField,"(":U) = 0 AND INDEX(cField," ":U) = 0  OR
         CAN-DO(_tt_log_name, ENTRY(1, cField, ".":U)) THEN 
        cField = ENTRY(2,cField,".":U) + ".":U + ENTRY(3,cField,".":U).
  
      /* Build the line. */
      cSortBy  =  cSortBy + "BY " + cField + cDir + {&EOL}.
    END.
  END.         
  RETURN cSortBy.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

