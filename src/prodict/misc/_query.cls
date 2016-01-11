/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
/*------------------------------------------------------------------------------
  Purpose:      
      
  Notes:                 
------------------------------------------------------------------------------*/
routine-level on error undo, throw.   
using Progress.Lang.* from propath.
 
 
class prodict.misc._query  :
  /* Pretend properties (must be controlled) */ 
  define public property Tables         as character no-undo get. set.
  define public property Table          as character no-undo 
      get .         
      set.
      
  define public property BaseQuery      as character no-undo get. set.
  define public property QueryString    as character no-undo get. set.
  define public property KeyFields      as character no-undo 
      get.  
      set.    
/*  define public property UseRowid       as logical   no-undo get. set. */
/*  define public property PhysicalTables as character no-undo  get. set.*/
  define public property QueryHandle    as handle    no-undo  get. set.
  define private variable mBuffers as handle extent no-undo. 
  
  constructor public _query(pcTables as char,pcKeyFields as char): 
/*       this-object(pcTables,pcTables,pcKeyFields).*/
      assign
         Tables         = pcTables  
         KeyFields      = pcKeyFields. 
  end constructor.
  
  constructor public _query(phbuffer as handle):     
      CreateQuery(phbuffer).
  end constructor.
  
  constructor public _query(phbuffers as handle extent): 
      CreateQuery(phbuffers). 
  end constructor.
  
  method private void CreateQuery(phbuffer as handle):
      define variable hBuffer as handle extent 1 no-undo.
      hBuffer[1] = phbuffer.
      CreateQuery(hBuffer).
  end method.
  
  method private void CreateQuery(phbuffers as handle  extent):
      define variable iBuffer as integer no-undo.
      define variable hBuffer as handle  no-undo.
     
      DeleteQuery().
      create query QueryHandle.    
      do iBuffer = 1 to extent(phbuffers):
          create buffer hBuffer for table phBuffers[ibuffer] .          
          QueryHandle:add-buffer(hBuffer).
          if ibuffer = 1 then 
          do:
            
              assign 
                  this-object:Table = hBuffer:name
                  Tables = this-object:Table 
                  KeyFields = hBuffer:keys.
          end.    
          else
              Tables = Tables + "," + hBuffer:name.
      end.
      
  end method.
  
  /*
  constructor public _query(pcTables as char,pcPhysicalTables as char,pcKeyFields as char): 
    /* We operate on Tables, but have it as optional parameter ! */
    if pcPhysicalTables = '' then
       pcPhysicalTables = pcTables.
    assign
        PhysicalTables = pcPhysicalTables
        Tables         = pcTables  
        KeyFields      = pcKeyFields.
  end constructor.
  */
  
  method protected void DeleteQuery():
      /* delete the handles  */
    define variable iBuffer as integer    no-undo.
    define variable h       as handle     no-undo extent 18.
    define variable iNum    as integer    no-undo.
 
    if valid-handle(QueryHandle) then
    do:
      iNum = QueryHandle:num-buffers.
      /* we loose num-buffers on first delete */
 
      do iBuffer = 1 to iNum:
        h[iBuffer] = QueryHandle:get-buffer-handle(iBuffer).
      end.
      
      do iBuffer = 1 to iNum: 
        delete object h[iBuffer]  no-error.
      end.
      delete object QueryHandle no-error.
    end.
      
  end method.
  
  /* delete the dynamic query and buffers */ 
  destructor public _query () :
      DeleteQuery().
  end destructor.

  method public logical Prepare ():
      define variable cQuery as character no-undo.
      if QueryString <> "" then 
          cQuery = QueryString.
      else
          cQuery = CurrentQuery().     
      return QueryHandle:query-prepare(cQuery ).     
  end.
  
  method public logical Init ():
      OpenQuery().
      GetFirst().      
  end.
  
   method public void GetFirst():
      QueryHandle:reposition-to-row(1) no-error.
      
  end method.     
  
  method public void OpenQuery():
      Prepare().
      QueryHandle:query-open().
  end method.     
  
  
  method protected logical ResetQuery ():
      return QueryHandle:query-prepare(defaultQuery()).     
  end.
  
  method protected character CurrentQuery ():
  /*------------------------------------------------------------------------------
    Purpose:     Return the current query for query manipulation and prepare.
                 returns the default if not yet prepared.
  ------------------------------------------------------------------------------*/
      define variable cQueryString as character  no-undo.
    
      if QueryHandle:prepare-string > '' then
          return QueryHandle:prepare-string.

      return DefaultQuery().

  end method. 
  
  method public character extent GetPosition():
      define variable i          as integer   no-undo.
      define variable bufferHdl  as handle    no-undo.
      define variable fieldName  as character no-undo.
      define variable bufferName as character no-undo.
      define variable tableNum   as integer   no-undo.
      define variable keyWhere   as character extent no-undo.
      define variable fieldWhere as character no-undo.
      
      extent(keyWhere) = num-entries(Tables).
      do i = 1 to num-entries(KeyFields):
          fieldName = entry(i,KeyFields).
          if num-entries(fieldName,".") > 2 then
              undo, throw new AppError("Too many qualifiers in KeyFields").
          if num-entries(fieldName,".") = 2 then
              assign 
                  bufferName = entry(1,fieldName,".")
                  fieldName  = entry(2,fieldName,".").
          else 
              bufferName = entry(1,Tables).
          
          assign
              tableNum   = lookup(bufferName,Tables)        
              bufferHdl  = QueryHandle:get-buffer-handle(bufferName).
 
          if (bufferHdl:avail) then   
              keyWhere[tableNum] = bufferName + "." + fieldName 
                                  + " = " 
                                  + quoter(bufferHdl:buffer-field(fieldName):buffer-value).
          else 
              keyWhere[tableNum] = ?.                       
      end.    
      return keyWhere.
  end method.    
  
  method protected character DefaultQuery ():
  /*------------------------------------------------------------------------------
    Purpose:     Return the BaseQuery or build a default query. 
  ------------------------------------------------------------------------------*/
    define variable iBuffer     as integer    no-undo.
    define variable cPrepare    as character  no-undo.
    define variable cBuffer     as character  no-undo.
    define variable cParent     as character  no-undo.
    define variable cMode       as character  no-undo.
    define variable cKeyTable   as character  no-undo.

    if BaseQuery <> '' then
      return BaseQuery.
    
    /* assume the first table in the definition is the main table that 
       the others join to and that need to have 'EACH' if joined from
       one of the other tables */
    cKeyTable = entry(1,Tables).
    
    /* If there's more than one buffer than add them, just assuming that
       an OF relationship to the first table in tables will properly relate them. */
    cPrepare = " FOR EACH " + QueryHandle:get-buffer-handle(1):NAME + " NO-LOCK ".
    do iBuffer = 2 to QueryHandle:num-buffers:

      assign 
          cBuffer  = QueryHandle:get-buffer-handle(iBuffer):NAME
          cParent  = if cKeyTable = cBuffer then 
                         QueryHandle:get-buffer-handle(1):NAME
                     else  
                         QueryHandle:get-buffer-handle(cKeyTable):NAME
          cMode    = if cKeyTable = cBuffer then 'EACH' else 'FIRST'
          cPrepare = cPrepare 
                 + ", " + cMode + " " + cBuffer + " OF " +  cParent + " NO-LOCK".

    end.   /* DO iBuffer = 2 */
    cPrepare = cPrepare + ' INDEXED-REPOSITION'.  
    return cPrepare.
  end.

  method public character ColumnValue (pcColumn as char):
    define variable cBuffer as character  no-undo.
    define variable cColumn as character  no-undo.
    define variable cValue  as character  no-undo.
    define variable hBuffer as handle     no-undo.
    if num-entries(pcColumn,".") = 2 then
        assign
            cBuffer = entry(1,pcColumn,'.')
            cColumn = entry(2,pcColumn,'.')  
            hBuffer = QueryHandle:get-buffer-handle(cBuffer).
    else 
        hBuffer = QueryHandle:get-buffer-handle(1).        
    if hBuffer:AVAIL then
    do:
      /* extent support could be added by <field>[i] as param, 
        but this used for keys though */
      cValue = hBuffer:buffer-field(cColumn):BUFFER-VALUE(0). 
      /* this string is for transport of values, so return unknown as string
       (assuming '?' never is a value in a progress DB...)*/        
      return if cValue <> ? then cValue else '?'.
    end.
    return ?. /* not avail*/ 
  end method.

/*  /* order neutral position that is safe if tables changes order in query          */
/*     passed back to setPosition                                                    */
/*     note that one need all rowids when the unique table is not                    */
/*     the first  */                                                                 */
/*  method public character extent GetPosition ():                                   */
/*     define variable iBuffer as integer    no-undo.                                */
/*     define variable cBuffer as character  no-undo.                                */
/*     define variable cPosition as character extent no-undo.                        */
/*                                                                                   */
/*     extent(cPosition) = num-entries(Tables).                                      */
/*                                                                                   */
/*     do iBuffer = 1 to num-entries(Tables):                                        */
/*       assign                                                                      */
/*         cBuffer = entry(iBuffer,Tables)                                           */
/*         cPosition[iBuffer] = string(QueryHandle:get-buffer-handle(cBuffer):rowid).*/
/*     end.                                                                          */
/*     return cPosition.                                                             */
/*  end method.                                                                      */
  
  /* set position as returned from GetPosition */
  method public logical SetPosition (prPosition as rowid extent):
      define variable lOk as logical no-undo.
      if extent(prPosition) = 1 then
          lOk = QueryHandle:reposition-to-rowid(prPosition[1]) no-error.
      else
          lOk = QueryHandle:reposition-to-rowid(prPosition) no-error.
      if lOk then 
          QueryHandle:get-next.
      return lOk.  
  end method. 
  
  method public logical SetPosition (pKeyWhere as char):
      define variable tableNum   as integer no-undo.
      define variable tokenNum   as integer no-undo.
      define variable fieldName  as character no-undo.
      define variable fieldValue as character no-undo.
      define variable bufferName as character no-undo.
      define variable keyWhere   as character extent no-undo.
      
      extent(keyWhere) = num-entries(Tables).
      /* remove double blanks */
      do while index(pKeyWhere,"  ") > 0:
          pKeyWhere = replace(pKeyWhere,"  "," ").
      end.     
      
      /* allow string passed without "where" and trim blanks front/end */ 
      pKeyWhere = (if entry(1,pKeyWhere," ") <> "where" then "where " else "")
                + trim(pKeyWhere," ").
          
      do tokenNum = 1 to num-entries(pKeyWhere," ") by 3:
          if tokenNum > 1 and entry(tokenNum,pKeyWhere," ") <> "and" then
              undo, throw new AppError("Illegal format of key where: "  + pKeyWhere).
      
          assign
              fieldName  = entry(tokenNum + 1,pKeyWhere," ")
              fieldValue = entry(tokenNum + 2,pKeyWhere," ").
          
          if num-entries(fieldName,".") = 1 then
          do:
              if num-entries(Tables) = 1 then 
                  bufferName = Tables.
              else
                  undo, throw new AppError("Illegal unqualified field reference: "  + fieldName).
          end.
          else if num-entries(fieldName,".") = 2 then
              assign 
                  bufferName = entry(1,fieldName,".")
                  fieldName  = entry(2,fieldName,".").
          else do:
              undo, throw new AppError("Too many qualifiers in field reference: "  + fieldName).
          end.
 
          assign 
              tableNum = lookup(bufferName,Tables) 
              keyWhere[tableNum] = (if keyWhere[tableNum] > "" 
                                    then keyWhere[tableNum] + " and " 
                                    else "where ")
                                  +  bufferName + "." + fieldName 
                                  + " = " 
                                  + if not fieldValue begins "'" and not fieldValue begins '"' 
                                    then quoter(fieldValue)
                                    else fieldValue.         
             
      end.    
      SetPosition(KeyWhere).
  end method.
  
  /* set position as returned from GetPosition */
  method public logical SetPosition (pcPosition as char extent):
      define variable hBuffer    as handle  no-undo.
      define variable iBuffer    as integer no-undo.
      define variable iTable     as integer no-undo.
      define variable rPosition  as rowid   extent no-undo.
      define variable lOk        as logical no-undo.
      
      extent(rPosition) = QueryHandle:num-buffers.
      do iBuffer = 1 to QueryHandle:num-buffers:
          iTable = lookup(QueryHandle:get-buffer-handle(iBuffer):NAME,Tables).
          /*
          if UseRowid then 
              rPosition[iBuffer] = to-rowid(pcPosition[iTable]).
          else do:
            */     
              hBuffer = QueryHandle:get-buffer-handle(iTable). 
              hBuffer:find-unique("where " + pcPosition[iTable]) no-error.
              rPosition[iBuffer] = hBuffer:rowid.
/*          end.*/
      end.
      
      return SetPosition(rPosition).
  end method.
 
  method public character ValueList  
   ( pcColumns   as char,
     pcFormat    as char,
     pcDelimiter as char) :
/*------------------------------------------------------------------------------
  Purpose: Retrieve a list of data from ALL rows in the dataobject.     
  Parameters: 
    pcColumns - Comma separated list of   column names.
    pcFormat  - Formatting option
                 blank or ?   - unformatted: columnValue()  
                'Formatted'   - Formatted without trailing blanks                                     
                'TrimNumeric' - Formatted without leading spaces for
                                numeric data (left justified).     
                'NoTrim'      - Formatted with leading and trailing blanks. 
                ' &1 &2 '     - &n, where the number references the column 
                                in pcColumns order, indicates that the column 
                                values should be substituted as specified 
                                instead of returned as delimiter separated
                                values. This allows formatting data to be mixed
                                with the returned values; f.ex: '&2 (&1)', 
                                '&2 / &1'  etc.. 
                                In order to build a list-item-pair list just 
                                ensure that the delimiter is in the format;
                                F. ex: '&2 (&1)' + ',' + '&1' where ',' also 
                                is passed as delimiter would return a paired
                                list where the second item of the pair is the 
                                column number one.   
              pcDelimiter     - Single char delimiter 
                                 ?      = chr(1) ! 
                                 blank  = single space !         
              
  Notes: - Should only be used with smaller amounts of records/data, as all data 
           need to fit in the character return value. The limit is in theory 32K,
           in reality somewhat smaller. The concatination of the data is 
           currently wrapped in an on stop block using no-error. The Progress 
           error message will be shown if the limit is encountered.
         - Maximum 9 columns can be passed when a substitute format is specified   
------------------------------------------------------------------------------*/ 
  define variable hDataQuery   as handle     no-undo.
  define variable hBuffer      as handle     no-undo.
  define variable rRowid       as rowid      no-undo.
  define variable iLastRowNum  as integer    no-undo.
  define variable iCol         as integer    no-undo.
  define variable cValue       as character  no-undo.
  define variable cList        as character  no-undo.
  define variable iReturnRows  as integer    no-undo.
  define variable iLoop        as integer    no-undo.
  define variable hColumnExt   as handle     no-undo extent 9.
  define variable cSub         as character  no-undo extent 9.
  define variable hColumn      as handle     no-undo.
  define variable lSizeError   as logical    no-undo. /* if bfx size error was detected */
  define variable iNumCols     as integer    no-undo.
  define variable lSubstitute  as logical    no-undo.
  define variable cSubstitute  as character  no-undo.
  define variable cMessage     as character  no-undo.
  define variable lRebuild     as logical    no-undo.
  define variable iFirstRowNum as integer    no-undo.
  define variable cTable       as character  no-undo.
  define variable cColumn      as character  no-undo.
  define variable cColName     as character  no-undo.
    
   /* It ain't pretty... but fast ..  
      This is used to assign 9 fields from the buffer to be substituted without looping 
      (9 = max substititute params)
      through the fields */
   &SCOPED-DEFINE  formatvalue ~
      IF VALID-HANDLE(~{&hdl~}) ~
      THEN IF ~{&hdl~}:BUFFER-VALUE = ? THEN '?':U ~
           ELSE IF pcFormat = '' OR lSubstitute THEN ~{&hdl~}:BUFFER-VALUE ~
           ELSE IF pcformat = 'TrimNumeric':U AND CAN-DO('Decimal,Integer':U,~{&hdl~}:DATA-TYPE) ~
                THEN TRIM(~{&hdl~}:STRING-VALUE) ~
                ELSE IF pcformat = 'Formatted':U OR pcFormat = 'TrimNumeric':U ~
                     THEN RIGHT-TRIM(~{&hdl~}:STRING-VALUE) ~
                     ELSE ~{&hdl~}:STRING-VALUE ~
      ELSE ''
  &SCOPED-DEFINE hdl hColumnExt[~{&Num~}]
  
  &SCOPED-DEFINE Num 1
  &SCOPED-DEFINE formatvalue1 {&formatvalue}
  &SCOPED-DEFINE Num 2
  &SCOPED-DEFINE formatvalue2 {&formatvalue}
  &SCOPED-DEFINE Num 3
  &SCOPED-DEFINE formatvalue3 {&formatvalue}
  &SCOPED-DEFINE Num 4
  &SCOPED-DEFINE formatvalue4 {&formatvalue}
  &SCOPED-DEFINE Num 5 
  &SCOPED-DEFINE formatvalue5 {&formatvalue}
  &SCOPED-DEFINE Num 6 
  &SCOPED-DEFINE formatvalue6 {&formatvalue}
  &SCOPED-DEFINE Num 7
  &SCOPED-DEFINE formatvalue7 {&formatvalue}
  &SCOPED-DEFINE Num 8
  &SCOPED-DEFINE formatvalue8 {&formatvalue}
  &SCOPED-DEFINE Num 9
  &SCOPED-DEFINE formatvalue9 {&formatvalue}
  
  &UNDEFINE hdl
  
  /* We are not opening the query from here .. */
  if valid-handle(QueryHandle) and QueryHandle:is-open then
  do:
      
        /* ? is CHR(1) */
    if pcDelimiter = ? then
      pcDelimiter = chr(1).
    /* Ensure blank delimiter is single space */ 
    else if pcDelimiter = "":U then
      pcDelimiter = " ":U.
    
    hBuffer = QueryHandle:get-buffer-handle(1). 
    
    assign           /* if then else used as ? is allowed in format */
      lSubstitute = if index(pcFormat,'&':U) > 0 then true else false  
      /* Used in WHEN, so must be set BEFORE Assign statement! */  
      iNumCols = num-entries(pcColumns). 
    
    if lSubstitute and iNumCols > 9 then
    do:
        undo, throw new AppError("The maximum number of columns that can be passed to ValueList()"
            +   " with a substitute format is 9.").  
     
    end.
  
    if lSubstitute then 
      assign
        cSubstitute = pcFormat
        /* for default substitute we remove trailing banks in data */
        pcFormat    = 'Formatted':U.
    
    else do: 
       /* support dashes in format input parameter */
       pcFormat = replace(pcformat,"-":U,"":U). 

      /* use substitute logic for any format in order to use the performance 
         preprocessor and avoid looping thru each column */   
       do iCol = 1 to MIN(9,iNumCols):
         cSubstitute = cSubstitute 
                     + (if iCol = 1 then '' else pcDelimiter)
                     +  '&':U + STRING(iCol).
       end.
    end.
    
    /* Maximize performance, avoid regetting dynamic buffer fields in row loop.
       (This loop is duplicated below inside the column loop for column 
        number 10 and higher )*/
       
    do iCol = 1 to iNumCols:
      cColumn  = entry(iCol,pcColumns).
      if num-entries(cColumn,'.':U) > 1 then
        assign
          cTable   = entry(1,cColumn,'.')
          cColName = entry(2,cColumn,'.').
      else 
        assign
          cTable   = ''  
          cColName = cColumn.   
     
       if cTable = '' or hBuffer:name = cTable then
           hColumnExt[iCol] = hBuffer:buffer-field(cColname).  
       else do:
           hColumnExt[iCol] = QueryHandle:get-buffer-handle(cTable):buffer-field(cColname).
       end.    
       if not valid-handle(hColumnExt[iCol]) then
       do:
           undo, throw new AppError("Column " + cColumn + " not found" ).
       end.
    end. /* DO iCol = 1 TO iNumCol */
  
 
    QueryHandle:get-first ().
    if hBuffer:available then 
    do:
        
      /**  
       /* We cannot call rowValues with data from the middle of the batch */
      if iFirstRowNum = ? then
      do:
        message "The rowValues() function is being called while the first record of"
                " the result set is not present in the existing batch." skip
                if {fn getRebuildOnRepos} 
                then "The RebuildOnRepos property must be FALSE in order to call rowValues()"
                   + " in an object that only has a batch of data."
                else ""   
                view-as alert-box error.

        return ?.
      end.
      **/
      BuildBlock:
      do iLoop = 1 to /*if iLastRowNum = ? then 2 else*/ 1: /* need two loops if batching */      
        /*
        if iLoop = 2 then
          dynamic-function("retrieveBatch":U in target-procedure,
                           'NEXT':U,
                           0). /* all remaining data */
          */  
        do while QueryHandle:query-off-end = false:
  
          /* on stop undo, leave to manage bfx error */
          do on stop undo, leave :
              /* Use local variable to avoid issues with -inp blowing up
                 the SUBSTITUTE() function.
               */
              assign cSub[1] = {&formatvalue1}
                     cSub[2] = {&formatvalue2}
                     cSub[3] = {&formatvalue3}
                     cSub[4] = {&formatvalue4}
                     cSub[5] = {&formatvalue5}.
              /* Break up assign stmt to avoind -inp errors
                 on the assign statement.
               */
              assign cSub[6] = {&formatvalue6}
                     cSub[7] = {&formatvalue7}
                     cSub[8] = {&formatvalue8}
                     cSub[9] = {&formatvalue9}.
              
              assign cList = cList + pcDelimiter
                           + SUBSTITUTE(cSubstitute,
                                        cSub[1], cSub[2], cSub[3],
                                        cSub[4], cSub[5], cSub[6],
                                        cSub[7], cSub[8], cSub[9]) NO-ERROR.
          end. /* end assign block */         
            
          if error-status:error then 
          do:
            assign
              lSizeError = true
              cMessage   = error-status:get-message(1). 
            leave BuildBlock.
          end.
          
          if iNumCols > 9 then
          do iCol = 10 to iNumCols on error undo, throw:
            cColumn  = entry(iCol,pcColumns).
            if num-entries(cColumn,'.':U) > 1 then
              assign
                cTable   = entry(1,cColumn,'.')
                cColName = entry(2,cColumn,'.').
            else 
              assign
                cTable   = ''  
                cColname = cColumn. 
           
            if cTable = '' or hBuffer:name = cTable then
                 hColumnExt[iCol] = hBuffer:buffer-field(cColname).  
            else do:
                hColumnExt[iCol] = QueryHandle:get-buffer-handle(cTable):buffer-field(cColname).
            end.
            if not valid-handle(hColumnExt[iCol]) then
            do:
                undo, throw new AppError("Column " + cColumn + " not found" ).
            end.
          
            &SCOPED-DEFINE hdl hColumn
            cValue = {&formatvalue}.
            &UNDEFINE hdl 
            /* on stop undo, leave to avoid bfx error */
            do on stop undo, leave :
              assign
               cList = cList 
                     + pcDelimiter
                     + cValue NO-ERROR.
          
            end. /* end assign block */         
            
            if error-status:error then 
            do:
              assign
                lSizeError = true
                cMessage   = error-status:get-message(1). 
              leave BuildBlock.
            end.
          end. /* do iCol = 9 to num-entries */         
          QueryHandle:get-next.
        end. /* BuildBlock: do while Query-off-end = false */    
      end.  /* do loop */
    end. /* if hRowObject:avail  */
    /*
    if rRowid <> ? then
    do:  
      QueryHandle:REPOSITION-TO-ROWID(rRowid). 
      if not hBuffer:AVAILABLE then
        QueryHandle:GET-NEXT.
    end.
     */
  end. /* queryopen and valid */
  
  /* More than 32K in string error... */ 
  if lSizeError then 
  do:
      undo, throw new AppError(cmessage).       
  end.

  /* Ensure that only the first delimiter is removed; as opposed to the 
     left-trim(...,Separator). We may have space as delimiter and prepend the 
     delimiter above */
  return substring(cList,2).

  &UNDEFINE formatvalue
  &UNDEFINE formatvalue1
  &UNDEFINE formatvalue2
  &UNDEFINE formatvalue3
  &UNDEFINE formatvalue4
  &UNDEFINE formatvalue5
  &UNDEFINE formatvalue6
  &UNDEFINE formatvalue7
  &UNDEFINE formatvalue8
  &UNDEFINE formatvalue9
  &UNDEFINE num
  end method. 
end class.