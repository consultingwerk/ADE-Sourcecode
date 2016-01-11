 /* ***********************************************************/
 /* Copyright (c) 2014 by Progress Software Corporation       */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : IndexData
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Nov 25 21:49:11 EST 2013
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.DataSource.DataSource.
using OpenEdge.DataAdmin.DataSource.DataSourceUtil.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using OpenEdge.DataAdmin.Error.IllegalOperationError.
using OpenEdge.DataAdmin.Lang.QueryString.
using Progress.Lang.*.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError from propath.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.DataSource.IndexDataReader inherits DataSource: 
    
   /*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	define protected property DataSourceUtil as DataSourceUtil no-undo 
        get():
            if not valid-object(DataSourceUtil) then
                DataSourceUtil = new DataSourceUtil().
            return DataSourceUtil.     
        end. 
        set.
	
    define private property PartitionPolicyName as char  get. set. 
    
    define private property IndexName                  as char         no-undo get. set. 
    define private property FieldNames                 as char extent  no-undo get. set. 
    define private property FieldList                  as char         no-undo get. set. 
    define private property TableName                  as char         no-undo get. set. 
    define private property HasRange                   as logical      no-undo get. set. 
    define private property NumFields                  as integer      no-undo get. set. 
    define private property DetailNameSubstituteBase   as char         no-undo get. set. 
    define private property DetailNameSubstituteNames  as char         no-undo get. set. 
          
    define variable mSeq  as integer no-undo.
    
    define private property UseIndex    as char         no-undo 
       get():
          return "use-index " + this-object:IndexName.
       end. 
       set. 
   
	constructor public IndexDataReader (  ):
		super ("_partition-policy-detail","dictdb._partition-policy-detail","").
	end constructor.
    
    method char GetFieldExpression (pcTable as char, pcFields as char extent,pcValues as char extent,pilevel as int) :
        
        define variable i as integer no-undo.
        define variable cExp as character no-undo.
        define variable cOper  as character no-undo.
        define variable cand as character no-undo.
        
        coper = " = ".
        
        do i = 1 to pilevel:
            if i = pilevel then
               cOper = " > ".
                   
            cExp = cExp 
                + (if i = 1 then "where " else " and ") 
                + pcTable + "." + pcFields[i] + cOper + quoter(pcValues[i]). 
        end.
        cExp = trim(cExp + " " + UseIndex).     
        if cExp = ? then 
            undo, throw new IllegalArgumentError("Cannot generate query expression for data traverse").
        return cExp.
    end.
    
    method private char extent GetIndexFields (pcTable as char, pcIndex as char, pimax as int) :
        define variable cflds as character extent no-undo.
        define variable i as integer no-undo.
        define variable dbRecid  as recid no-undo.
        dbRecid = DatabaseInfo:DatabaseRecid. 
        find dictdb._file where dictdb._file._db-recid = dbRecid
                         and   dictdb._file._file-name = pcTable
                         and   dictdb._file._owner = "PUB" no-lock no-error. 
        if not avail dictdb._file then 
            undo, throw new IllegalArgumentError("Table " + quoter(pcTable) + " does not exist."). 
                      
        find dictdb._index of dictdb._file where dictdb._index._index-name = pcIndex no-lock no-error.
        if not avail dictdb._index then 
            undo, throw new IllegalArgumentError("Index " + quoter(pcIndex) + " does not exist in Table " + quoter(pcTable) ). 
       
        extent(cflds) = if pimax > 0 then min(dictdb._index._num-comp,pimax)
                        else dictdb._index._num-comp .
        for each dictdb._index-field of dictdb._index no-lock:
             find dictdb._field of dictdb._index-field no-lock.
             cFlds[dictdb._index-field._index-seq] = dictdb._field._field-name.
             if pimax > 0 and pimax = dictdb._index-field._index-seq then
                 leave. 
        end.    
        return cFlds.  
    end.
        
    method private char extent GetValues (pfieldhandles as handle extent):
        define variable i as integer no-undo.
        define variable cValues as character extent no-undo.
        define variable cSep as char      no-undo. 
        define variable cdec as char      no-undo.
        define variable cVal as character no-undo.
        define variable cdat as char      no-undo. 
        define variable ddat as date no-undo. 
            
        cdec = session:numeric-decimal-point.
        csep = session:numeric-separator.
        cdat = session:date-format.
        
        session:numeric-format = "american".
        session:date-format = "mdy".
        
        extent(cValues) = extent(pfieldhandles).
        do i = 1 to extent(pfieldhandles):
            /* force 4 digits - (not absolutely required , but best practice ) */
            if pfieldhandles[i]:data-type = "date"  then
            do:
                ddat = pfieldhandles[i]:buffer-value.
                cValues[i] = string(ddat,"99/99/9999").
            end.   
            else   
                cValues[i] = pfieldhandles[i]:buffer-value.
        end.  
        return cValues.  
        finally:
            session:set-numeric-format (csep,cdec). 	
            session:date-format = cdat. 
        end finally.
        
    end method.    
    
    method public override logical Prepare(phBuffer as handle,pcTargetQuery as char,pcJoin as char):
        define variable oQueryString as QueryString no-undo.
        define variable cIndexes as character no-undo.
        define variable i as integer no-undo.
        define variable dbRecid as recid no-undo.
        define variable ibadchar as integer no-undo.
        dbRecid = DatabaseInfo:DatabaseRecid. 
   
        DataBuffer = phBuffer.
        oQueryString = new QueryString(pcTargetQuery,this-object).
        if PartitionPolicyName = "" or PartitionPolicyName = ? then
            undo, throw new IllegalArgumentError("No PartitionPolicy name specified in new detail request").
        if can-find (dictdb._partition-policy where dictdb._partition-policy._partition-policy-name = PartitionPolicyName) then
             undo, throw new IllegalArgumentError("Existing PartitionPolicy name " + quoter(PartitionPolicyName) +  " specified in new detail request").
         
        if TableName = "" or TableName = ? then
            undo, throw new IllegalArgumentError("No table specified in new detail request").
            
        if not can-find (first dictdb._file where dictdb._file._db-recid = dbRecid
                         and   dictdb._file._file-name = TableName
                         and   dictdb._file._owner = "PUB") then
             undo, throw new IllegalArgumentError("Invalid table name " + quoter(TableName) +  " specified in new detail request").
         
         
        /*        super:Prepare(phBuffer, pcTargetQuery,pcJoin).*/
        if IndexName > "" then
            this-object:FieldNames = GetIndexFields(TableName,IndexName,NumFields).
        else do:
           cIndexes = DataSourceUtil:GetIndexes(TableName,FieldList).
           if cIndexes = "" then 
           do:
               undo, throw new IllegalArgumentError("No index found that starts with " + quoter(FieldList)).
           end.    
           IndexName = entry(1,Cindexes).
           extent(FieldNames) = num-entries(FieldList).
           do i = 1 to num-entries(FieldList):
               FieldNames[i] = entry(i,FieldList).
           end.    
        end.    
        if extent(FieldNames) = ? then 
            undo, throw new IllegalArgumentError("No fields specified for new detail request").
        if DetailNameSubstituteBase > "" then
        do:
            ibadchar = index(DetailNameSubstituteBase,".").
            if ibadchar = 0 then
                ibadchar = index(DetailNameSubstituteBase," ").
            
            if ibadchar = 0 then
               ibadchar = index(DetailNameSubstituteBase,"@").
            
            if ibadchar > 0 then 
                undo, throw new IllegalArgumentError("The character "
                                  + quoter(substr(DetailNameSubstituteBase,ibadchar,1)) + " in the template name is illegal.").
                                  
            /* probably really bad idea to have curly braces in name 
               but the use of curly braces for tokens in UI could make this occur by accident 
               report as unsupported as it will it will give a really weird error in client side query used to join if we keep it 
               (a replace with tilde would fix that, but not worth it )
               maybe illegal argument is better (even correct)    
             */                      
            ibadchar = index(DetailNameSubstituteBase,"~{").  
            if ibadchar = 0 then
               ibadchar = index(DetailNameSubstituteBase,"~}").    
             if ibadchar > 0 then    
               undo, throw new UnsupportedOperationError('"~{" or "~}" are not supported as constants in detail template name').            
        end.    
        return true.
    end method.
    
    method public override logical Fill():
        define variable hDataBuffer as handle no-undo.
        define variable i as integer no-undo.
        define variable hFieldHandles as handle extent no-undo  . 
        
        create buffer hDataBuffer for table this-object:TableName.
        extent(hFieldHandles) = extent(this-object:FieldNames).
    
        do i = 1 to extent(this-object:FieldNames):
            hFieldHandles[i] = hDataBuffer:buffer-field(this-object:FieldNames[i]).
        end.  
          
        if HasRange then
            fillRangeBuffer(hdatabuffer,hFieldHandles).
        else     
            fillBuffer(hdatabuffer,hFieldHandles).  
             
    end method.
    
    method private void FillBuffer(phdatabuffer as handle,phFieldHandles as handle extent) :
        define variable cQuery  as character no-undo.
        define variable iLevel  as integer no-undo.
        define variable cValues as character extent no-undo.
        define variable i as integer no-undo.
        define variable iNumFields as integer no-undo.
        
        iNumFields = extent(phFieldHandles).
        extent(cValues) = iNumFields.
        
        phDataBuffer:find-first(cQuery) no-error.
          
        do while true : 
            /* ilevel is 0 the first time - in which case the cQuery only returns "use-index " */                         
            cQuery = GetFieldExpression(this-object:TableName,this-object:FieldNames,cvalues,ilevel).          
            phDataBuffer:find-first(cQuery) no-error.
            if phDataBuffer:avail then
            do:
                cValues = GetValues(phFieldHandles) .
                FillRow(cValues,phFieldHandles).
                if(ilevel < iNumFields) then
                do:
                    /* FillBuffer(phdatabuffer,phFieldHandles,(extent(pcvalues)),input-output pcvalues).*/
                    ilevel = iNumFields.             
                end.
            end. 
            else do:
               ilevel = iLevel - 1.
               if iLevel le 0 then 
                  leave. 
            end.
        end.
    end. 
    
    method private void FillRangeBuffer(phdatabuffer as handle,phFieldHandles as handle extent) :
        define variable cQuery  as character no-undo.
        define variable iLevel  as integer no-undo.
        define variable cValues as character extent no-undo.
        define variable i as integer no-undo.
        define variable iNumFields as integer no-undo.
        iNumFields = extent(phFieldHandles).
        extent(cValues) = iNumFields.
        do while true : 
            /* ilevel is 0 the first time - in which case the cQuery only returns "use-index " */                         
            cQuery = GetFieldExpression(this-object:TableName,this-object:FieldNames,cvalues,ilevel).          
            phDataBuffer:find-first(cQuery) no-error.
            if phDataBuffer:avail then
            do:
                cValues = GetValues(phFieldHandles) .
                cQuery = GetFieldExpression(this-object:TableName,this-object:FieldNames,cvalues,iNumFields).          
                phDataBuffer:find-last(cQuery) no-error.
                if phDataBuffer:avail then
                    cValues = GetValues(phFieldHandles) .
                FillRow(cValues,phFieldHandles).
                
                if iNumFields = 1 then
                    leave. 
                
                if(ilevel lt iNumFields) then
                do:
                    /* FillBuffer(phdatabuffer,phFieldHandles,(extent(pcvalues)),input-output pcvalues).*/
                    ilevel = iNumFields - 1.             
                end.
                
            end. 
            else do:
               ilevel = iLevel - 1.
               if iLevel le 0 then 
                  leave. 
            end.
        end.
    end.    
    
    method private void FillRow(pcvalues as char extent,phfldhandles as handle extent):
        define variable i as integer no-undo.
        define variable inumtokens as integer no-undo.
        define variable cTokens  as character extent 9 no-undo.
        define variable itest as integer no-undo.
        DataBuffer:buffer-create.
        
        mSeq = mSeq + 1.
        DataBuffer::PartitionPolicyName = PartitionPolicyName.
        DataBuffer::TableName = TableName.
        DataBuffer::InternalSort = mSeq.
        DataBuffer::IsAllocated = true.
        DataBuffer::IsComposite = true.
        do i = 1 to extent(pcvalues):
            DataBuffer::StringValues(i) = pcValues[i].
        end.  
        
        if DetailNameSubstituteBase > "" then
        do:
            inumtokens = num-entries(DetailNameSubstituteNames).
            do i = 1 to inumtokens:
                cTokens[i] = GetPropertyValue(DataBuffer,entry(i,DetailNameSubstituteNames),mSeq,phfldhandles).
            end.
            DataBuffer::Name = substitute(DetailNameSubstituteBase,cTokens[1],cTokens[2],cTokens[3],cTokens[4],cTokens[5],cTokens[6],cTokens[7],cTokens[8],cTokens[9]).
            do on error undo, leave:
                itest = int(substr(DataBuffer::Name,1,1)).
                undo, throw new AppError("The generated name " + quoter(DataBuffer::Name) + " is invalid. The policy detail name cannot start with a number.").         
                catch e1 as Progress.Lang.AppError :
                    undo, throw e1. 
                end catch.     
                catch e2 as Progress.Lang.Error :
                  /*ok */		
                end catch.
            end.    
        end.
        else
            DataBuffer::Name = PartitionPolicyName + "-" + string(mSeq).
       
         if length(DataBuffer::Name) > 32 then 
              undo, throw new AppError("The generated name " + quoter(DataBuffer::Name) + " exceeds maximum length of 32 characters").
            
        catch e1 as Progress.Lang.AppError :
            undo, throw e1. 
        end catch.     
        catch e as Progress.Lang.Error :
        	undo, throw new AppError("The generated name " + quoter(DataBuffer::Name) + " causes error: ~n"
        	            + replace(e:GetMessage(1),"ttPartitionPolicyDetail","PartitionPolicyDetail") ).
        end catch.
    end.     
    
    method private character GetPropertyValue( phbuffer as handle, pcFld as char, pinum as int, phfldhandles as handle extent):
        define variable ipos as integer no-undo.
        define variable iEndPos as integer no-undo.
        define variable iext as integer no-undo.
        define variable cTable as character no-undo.
        define variable cFld as character no-undo.
        define variable hFld as handle no-undo.
         
        if pcfld = "ttPartitionPolicy.Name" then
            return PartitionPolicyName. 
        else if pcfld = "ttPartitionPolicy.Type" then
            return if HasRange = false then "List"
                   else if NumFields = 1 then "Range"
                   else "List-Range". 
        else if pcfld = "ttPartitionPolicy.TableName" then
            return TableName.
                    
        /* the field in the list are qualified, not really needed for this  (for future generalization) */
        cTable = entry(1,pcFld,".").
        cFld   = entry(2,pcFld,".").
        
        if cTable <> phBuffer:name then 
        do:
            undo, throw new AppError("Table reference  " + quoter(cTable) + " in template is invalid").
        end.    
        
        if cFld = "Number" then 
            return string(pinum).
 
        ipos = index(cFld,"[").
        if ipos > 1 then 
        do:
            iEndPos = index(cFld,"]").
            iext = int(substr(cFld,ipos + 1,iEndPos - ipos - 1)).
            cFld = substr(cFld,1,ipos - 1).
            hFld = phbuffer:buffer-field(cFld).
            return GetValueForName(hFld:buffer-value (iext), phfldhandles[iext]:data-type ) . 
        end. 
        else do:
            hFld = phbuffer:buffer-field(cFld).
            return GetValueForName(hFld:buffer-value (),hFld:data-type ) . 
        end.
        catch e1 as Progress.Lang.AppError :
            undo, throw e1. 
        end catch.   
        catch e as Error :
            undo, throw new AppError("Field reference  " + quoter(pcFld) + " in template is invalid: " + e:GetMessage(1))   .
        end catch.

    end method.
   
   /** The _Partition-Policy-Name must conform to the same rules as required of Progress table, index and field names.
        Namely the name is limited to the ASCII character set.  It must start with a letter 
        (although unlike Progress table names it can start with an ‘_’).  
        The name cannot contain an embedded space, punctuation or the ‘@’ character.*/
    method private character GetValueForName(pcvalue as char, pcdatatype as char):
         define variable ddate as date no-undo.
         define variable newValue as char no-undo.
         
         case pcdatatype:
              /* @todo support formatting 
             for now use mdy for date - sortable - best international default (on average)..
              */
             when "integer" or when "logical" then
                newValue = pcvalue.
             when "character" or when "char" then
             do:
                 /* replace invalid chars */
                 newValue = replace(pcvalue,".","x").
                 newValue = replace(newValue," ","_").
                 newValue = replace(newValue,"@","X").
                 return newValue.
             end.
             when "date" then
             do:
                 ddate = date(pcvalue). 
                 newValue =  string(year(ddate)) + "-" + string(month(ddate),"99") + "-" + string(day(ddate),"99") .   
             end.   
             otherwise do:
                 /* replace invalid period with x*/
                 newValue = replace(pcvalue,".","x").
             end.   
          end.
          
          return newValue.     
       
    end method.
   
    /* don't access map for anything (not attached ) */
    method public override character ColumnSource (pcColumn as char):
        return pcColumn. 
    end.       
     
     /* return source columns for query mapping 
    (part of IQueryMap interface used by QueryString to map query */
    method public override character ColumnExpression (pcColumn as char,pcoperator as char,pcvalue as char):
        if lookup(pcOperator,"EQ,=") = 0 then
        do:
            undo, throw new IllegalOperationError("IndexDataReader does not support query expressions. Only 'EQ' or '=' is allowed for parameter values.").
        end.    
        case pccolumn:
            when "ttPartitionPolicy.Name" then
                PartitionPolicyName = pcvalue.   
            when "ttPartitionPolicy.TableName" then
                TableName = pcvalue.   
            when "ttPartitionPolicy.IndexName" then 
                IndexName = pcValue.
            when "ttPartitionPolicy.HasRange"  then
                HasRange = logical(pcValue).  
            when "ttpartitionPolicyField.FieldName" then 
                FieldList = FieldList + (if FieldList = "" then "" else ",") + pcValue.
            when  "ttpartitionPolicy.DetailNameSubstituteBase"  then 
                DetailNameSubstituteBase =  pcValue.
            when  "ttpartitionPolicy.DetailNameSubstituteNames"  then 
            do:
                if num-entries(pcValue) > 9 then 
                    undo, throw new AppError("More than 9 properties in template is not supported" ) .
         
                DetailNameSubstituteNames =  pcValue.
            end.
        end.    
    end method.  
end class.