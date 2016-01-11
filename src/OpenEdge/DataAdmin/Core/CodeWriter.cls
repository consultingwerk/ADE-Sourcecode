/*************************************************************/
/* Copyright (c) 2011-2014 by progress Software Corporation. */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : CodeWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Aug 16 20:18:09 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.DataAdmin.* from propath.
using OpenEdge.DataAdmin.Binding.ContextTree from propath.
using OpenEdge.DataAdmin.Binding.IContextTree from propath.
using OpenEdge.DataAdmin.Binding.IStreamFieldHandler from propath.
using OpenEdge.DataAdmin.Core.DataAdminWriter from propath.
using OpenEdge.DataAdmin.Core.IDataAdminWriter from propath.
using Progress.Lang.* from propath.
using Progress.Lang.Object from propath.

routine-level on error undo, throw.


class OpenEdge.DataAdmin.Core.CodeWriter inherits DataAdminWriter  implements IDataAdminExporter:  
    define stream script. 
    define private variable mfile as character no-undo.
    define private variable mCannotSetImmediate as logical no-undo.
    define variable mreadonly as character no-undo init 
"ttPartitionPolicy.Type,ttPartitionPolicy.HasComposite,ttPartitionPolicy.IsCompositeReadOnly,ttPartitionPolicyDetail.IsComposite,ttpartitionPolicyDetail.IsDataEnabled,ttPartitionPolicyDetail.DefaultAllocation".    
   define variable mNOVariable as character no-undo init "ttLocalIndex,ttPartitionPolicyField".    

   define variable mAddEarly as character no-undo init "ttPartitionPolicyDetail".    
   
    define protected property ContextTree as IContextTree no-undo get. private set.
    
    
    define public property Formatted as logical no-undo 
    init true
    get.
    set.
    
/*    define private variable mParentCreated as logical no-undo.*/
    
	constructor public CodeWriter (  ):
		super ().
    end constructor.
      
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/

	method public char GetStateDefault(phBuff as handle ):
		return if phbuff:name begins "ttPartitionPolicy" then "None" else "Delayed".
	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/

	method public logical HasPolicyPartitionChanges( phbuffer as handle ):
		define variable hDetbuffer as handle no-undo.
		define variable hPartbuffer as handle no-undo.
	    define variable hPartQuery as handle no-undo.
	    hDetbuffer =  GetChildBuffer(phbuffer,"ttPartitionPolicyDetail").   
		if valid-handle(hDetbuffer) then    
		do:
		    hPartbuffer =  GetChildBuffer(hDetbuffer,"ttPartition").   
            if valid-handle(hPartbuffer) then                                   
            do:
                hPartquery = GetPartitionChangeQuery(hPartbuffer,yes).
                hPartQuery:query-open().
                hPartQuery:get-first.
                hPartbuffer = hPartquery:get-buffer-handle ("ttPartition").
                return hPartbuffer:available.
            end.
        end.     
        return false. 
	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/

/*	method public void WritePartitionPolicyDetailPartitions( phbuffer as handle ):*/
/*		                                                                               */
/*		define variable hquery        as handle no-undo.                             */
/*        define variable hparent       as handle no-undo.                       */
/*        define variable hDetailbuffer as handle no-undo.                       */
/*        define variable hPartbuffer   as handle no-undo.                       */
/*        define variable hPartquery    as handle no-undo.                       */
/*        define variable cQuery        as char no-undo.                         */
/*        define variable ichild        as integer no-undo.                      */
/*        define variable hrel as handle no-undo.                                */
/*        hquery =  GetChildQuery(phbuffer,"ttPartitionPolicyDetail").           */
/*        if not valid-handle(hquery) then                                       */
/*            return.                                                            */
/*        hDetailbuffer = hquery:get-buffer-handle (1).                          */
/*        hquery:query-open ().                                                  */
/*        hquery:get-first ( ).                                                  */
/*        if hDetailbuffer:avail then                                            */
/*        do:                                                                    */
/*            hPartbuffer =  GetChildBuffer(hDetailbuffer,"ttPartition").        */
/*            if valid-handle(hPartbuffer) then                                  */
/*            do:                                                                */
/*                hPartquery = GetPartitionChangeQuery(hPartbuffer).             */
/*                hPartQuery:query-open().                                       */
/*                hPartQuery:get-first.                                          */
/*                hPartbuffer = hPartquery:get-buffer-handle ("ttPartition").    */
/*                if hPartbuffer:avail then                                      */
/*                do:                                                            */
/*                     WritePartitions(hDetailbuffer,hPartquery).                */
/*                end.                                                           */
/*            end.                                                               */
/*            hquery:get-next ( ).                                               */
/*        end.                                                                   */
/*                                                                               */
/*                                                                               */
/*	end method.                                                                   */
    
        
    method private void WritePartitionPolicyDetails(pquery as handle):
        define variable hBuffer as handle no-undo.
        define variable hPartBuffer as handle no-undo.
        define variable hPartQuery  as handle no-undo.
        define variable lWritealloc as logical no-undo.
        define variable hParent as handle no-undo.
        pQuery:query-open () .
        pquery:get-first ( ).
        hBuffer = pQuery:get-buffer-handle(1).
        do while hbuffer:avail:
            WriteBuffer(hbuffer).
            lWriteAlloc = hBuffer::IsAllocated.
            /* check if partitons were written in which case the allocation
               was written on partition and we don;t write allocate 
               isAllocated will fail if partitions has area changes 
               in that case partition:AllocationState must be used
               */
            if lWriteAlloc then
            do:
                hparent = hbuffer:parent-relation:parent-buffer. 
                if hParent::DefaultAllocation <> "immediate"  or mCannotSetImmediate then
                do:     
                    hPartbuffer =  GetChildBuffer(hBuffer,"ttPartition").   
                    if valid-handle(hPartbuffer) then                                   
                    do:
                         hPartquery = GetPartitionChangeQuery(hPartbuffer,no).
                         hPartQuery:query-open().
                         hPartQuery:get-first.
                         hPartbuffer = hPartquery:get-buffer-handle ("ttPartition").
                         lwriteAlloc = not hPartBuffer:avail.
                    end.
                end.
            end. 
            if lWriteAlloc then
            do:
                put stream script unformatted
                     "/* Allocate partitions ". 
                if mCannotSetImmediate then
                    put stream script unformatted
                      "(This is done because the policy's DefaultAllocation is" skip
                      "   set to ""None"" before the policy is Created in the service in order to handle" skip
                      "   non default partition properties)". 
                 put stream script unformatted
                     " */" 
                     skip
                     GetEntityInstance(hBuffer:name) 
                     ":Allocate()." skip. 
            end.    
            pQuery:get-next. 
        end.
        finally:
            delete object hPartquery no-error.		
        end finally.
    end method.
    
	    
    method private void WriteLocalIndexBuffer(hparent as handle,pquery as handle):
        define variable hBuffer as handle no-undo.
        pQuery:query-open () .
        pquery:get-first ( ).
        hBuffer = pQuery:get-buffer-handle(1).
        do while hbuffer:avail:
                put stream script unformatted 
                   "/* Add " + hBuffer::IndexName + " to the local index collection */" skip.
                put stream script unformatted  
                     GetEntityInstance(hParent:name) 
                     ":Indexes:Add(" + GetEntityInstance(hParent:name) + ":Table:Indexes:Find(" +  quoter(hBuffer::IndexName) ")). "  skip .    
                put stream script unformatted skip .
             pQuery:get-next.
        end.
    end method.
     
    method protected override IContextTree CreateContextTree():
         define variable tree as IContextTree no-undo.
         tree = new ContextTree().
         tree:WriteCode = true. 
         return tree.
    end method.
    
    method public void WriteToFile(serializable as IDataAdminSerializable,pcFile as char,pcMode as char):
        define variable h as handle no-undo.
        define variable tree as IContextTree no-undo.
        tree = this-object:Write(serializable,pcMode).
        h = tree:GetWriteHandle().
        mfile = pcfile.
        WriteCode(h).
        delete object h no-error.
    end method.
    
    method private void WriteCode(h as handle):
        output stream script to value(mfile).
        WriteHeader(h).
        WriteDefs(h).
        WriteInit().
        WriteQuery(h:top-nav-query(1)).
        WriteErrorHandler ().
        finally:
            output stream script close.
        end.
    end method.
    
    method private void WriteInit():
         put stream script unformatted
             "/* Start a service for the " quoter(ldbname("dictdb")) " database. */" skip.
         put stream script unformatted 
             "service = new DataAdminService(" + quoter(ldbname("dictdb"))  + ")." skip.
    end method.
    
    method private char GetDate():  
        define variable mweekdays as char init "Sun,Mon,Tue,Wed,Thu,Fri,Sat" no-undo.
        define variable myears as char init "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec" no-undo.
        return entry(weekday(today),mWeekdays)
            + ' ' 
            + entry(month(today),myears)
            + ' '
            + string(day(today))
            + ' '
            + string(time,"hh:mm:ss")
            + ' '
            + string(year(today)).    
    end.
    
    
    method private char GetComment(phDs as handle, pcfile as char,pcpurpose as char):
         /* Sun Oct 17 15:10:33 EDT 2010 */
        return
     '/*' +  fill("-",78) + chr(10)
   + '  Purpose: '  + pcpurpose  + chr(10)
   + '  Created: ' + GetDate() + " by dataadmin code writer." + chr(10)
   + '    Notes: ' + GetNote(phDs) + chr(10)
   +  fill("-",78) + '*/'
      .
    end method.    
    
    method private char GetNote(phDs as handle):
        if valid-handle(phds:get-buffer-handle ("ttPartitionPolicy")) then
        do:
             return
                "This procedure is intended to create a PartitionPolicy for an empty" +  "~n" 
                + "           table. To create a PartitionPolicy for a table with data it is " + "~n" 
                + "           typically better to use the AddDetailsFromData method to create" + "~n" 
                + "           the PartitionPolicyDetails instead of creating each detail" + "~n"
                + "           individually. You can create them individually also in this case," + "~n"
                + "           but you will get an error if the details do not match the data" +  "~n" 
                + "           or if you attempt to Allocate() the details.".
        end.    
        return "". 
    end method.    
    
    
    
    method private void WriteHeader(hDs as handle):
        define variable i as integer no-undo.
        define variable hbuf as handle no-undo.
        define variable cPurpose as character no-undo.
        if valid-handle(hds:get-buffer-handle ("ttTenant")) then  
            cPurpose =  "Create tenant".
        else if valid-handle(hds:get-buffer-handle ("ttTenantGroup")) then
            cPurpose =  "Create partition group".
        else    
            cPurpose =  "Create partition policy".
             
        put stream script unformatted 
           GetComment(hDs,mfile,cPurpose) skip(1).
        put stream script unformatted 
           "block-level on error undo, throw." skip
           "using Progress.Lang.Error from propath." skip   
           "using OpenEdge.DataAdmin.DataAdminService from propath." skip 
           "using OpenEdge.DataAdmin.Error.DataAdminErrorHandler from propath." skip.   
        do i = 1 to hDs:num-buffers:
            hbuf = hDs:get-buffer-handle (i).
            if lookup(hbuf:name,mNOVariable) = 0 then
                put stream script unformatted "using OpenEdge.DataAdmin." + GetEntityInterface(hbuf:name) + " from propath."  skip.     
        end.
        put stream script unformatted skip(1).
    end method.    
    
    method private void WriteDefs(hDs as handle):
        define variable i as integer no-undo.
        define variable hbuf as handle no-undo.
        put stream script unformatted 
            "define variable service as DataAdminService no-undo." skip   
            "define variable errorHandler as DataAdminErrorHandler no-undo." skip.     
               
        do i = 1 to hDs:num-buffers:
            hbuf = hDs:get-buffer-handle (i).
            if lookup(hbuf:name,mNOVariable) = 0 then
            do:
                put stream script unformatted 
                   "define variable " + GetEntityInstance(hbuf:name) + " as " GetEntityInterface(hbuf:name) + " no-undo." skip.     
                if hbuf:name = "ttUser" then
                   put stream script unformatted 
                    "/* Default user password - can only be changed by the user after creation */" skip
                    "define variable cPassword as character init ~"password~" no-undo." skip.     
                if hbuf:name = "ttDomain" then
                   put stream script unformatted 
                   "/* Default domain AccessCode   */" skip
                   "define variable cAccessCode as character init ~"accesscode~" no-undo." skip.     
       
            end.
        end.
        put stream script unformatted skip(1).
    end method.    
    
    method private void WritePartitionBuffer(hparent as handle,hbuffer as handle):
       
       put stream script unformatted 
          "assign " skip.
/*       if plfindpartition then                                                                                         */
/*          put stream script unformatted                                                                                */
/*                       GetEntityInstance(hparent:name) at 5                                                            */
/*                       " = "  GetEntityInstance("ttPartitionPolicy")  ":Details:Find("  quoter(hparent::name) ")" skip.*/
/*                                                                                                                       */
        put stream script unformatted 
              
               GetEntityInstance(hbuffer:name) at 5 
               " = " 
               GetEntityInstance(hParent:name) 
               ":Partitions:" .    
       if hbuffer::Objecttype = "table" then
           put stream script unformatted 
              "FindTable(" quoter(hBuffer::Tablename) ") "  skip.
       else if hbuffer::Objecttype = "field" then
           put stream script unformatted 
              "FindField(" quoter(hBuffer::Tablename) "," quoter(hBuffer::FieldName) ")" skip.
       else if hbuffer::Objecttype = "index" then
           put stream script unformatted 
              "FindIndex(" quoter(hBuffer::Tablename) "," quoter(hBuffer::IndexName) "," quoter(hBuffer::Collation) ")" skip.
      
       put stream script unformatted 
          GetEntityInstance(hBuffer:name) at 5 ":Area = " GetArea(hbuffer::Areaname)  skip. 
       
       if hbuffer::Objecttype = "table" then
          put stream script unformatted 
             GetEntityInstance(hBuffer:name) at 5 ":AllocationState = " quoter(hbuffer::AllocationState)  skip. 
       
       if hBuffer::BufferPool <> "Primary" then
          put stream script unformatted 
            GetEntityInstance(hBuffer:name) at 5 ":BufferPool = " quoter(hbuffer::BufferPool)  skip. 
        put stream script unformatted "." at 5 skip .     
    end.

    /** NOTE : this is actually generating code for the Tenants and TenantGroups collections 
       and not the tenantGroupMembers 
       (it's the same data just different collections - see implementations)*/ 
    method private void WriteTenantGroupMembersBuffer(hparent as handle,hbuffer as handle):
       
       if hParent:name = "ttTenant" then
       do:
           put stream script unformatted 
              "/* Add a group to the tenantgroups collection */" skip.
           put stream script unformatted  
                   GetEntityInstance(hParent:name) 
                   ":TenantGroups:Add(service:GetTenantGroup(" quoter(hBuffer::TenantGroupName) ")). "  skip .    
           put stream script unformatted skip(1).
       end.
       else do:
           put stream script unformatted 
              "/* Add a tenant to the tenants collection */" skip.
           put stream script unformatted  
                   GetEntityInstance(hParent:name) 
                   ":Tenants:Add(service:GetTenant(" quoter(hBuffer::TenantName) ")). "  skip .    
           put stream script unformatted skip(1).
       
       end.     
    end.
    
    /** NOTE : this is actually generating code for the Fields collections 
       and not the PartitionPolicyFields 
       (it's the same data just different collections - see implementations)*/ 
    method private void WritePartitionPolicyFieldBuffer(hparent as handle,hbuffer as handle):
        put stream script unformatted 
          "/* Add " + hBuffer::FieldName + " to the fields collection */" skip.
        put stream script unformatted  
               GetEntityInstance(hParent:name) 
               ":Fields:Add(" + GetEntityInstance(hParent:name) + ":Table:Fields:Find(" +  quoter(hBuffer::FieldName) ")). "  skip .    
        put stream script unformatted skip .
    end.
    
    method private void WriteBuffer(hbuffer as handle):
        define variable i as integer no-undo.
        define variable hfld as handle no-undo.
        define variable cStatementFields as character no-undo.
        define variable cAssignedFields as character no-undo.
        define variable Fieldhandler as IStreamFieldHandler no-undo.
        define variable obj as Object no-undo.
        define variable htbl as handle no-undo.
        define variable iChild as integer no-undo.
        define variable hRel as handle no-undo.
        
        put stream script unformatted  skip(1)
           "/* Instantiate a new "  GetEntityInterface(hbuffer:name)    " */" skip.
        put stream script unformatted 
           GetEntityInstance(hbuffer:name) " = service:New"  GetEntityClass(hbuffer:name)  "(" + quoter(hBuffer::name) ")." skip.
       
        if valid-handle(hbuffer:parent-relation) then
        do: 
            /* we could possibly do this for all, but for some classes 
               it is important, since validation or collections require parent
               to be known (i.e. partitionpolicydetail need to know parent table
               and field to access new partitions)  */
            if lookup(mAddEarly,hBuffer:name) <> 0 then
                 writeAddToParent(hBuffer). 
        end. 
        put stream script unformatted "assign" skip.
        obj = ContextTree:GetFieldHandler(hbuffer:serialize-name).
        if valid-object(obj) then
        do: 
             Fieldhandler = cast(obj,IStreamFieldHandler).
             cStatementFields = Fieldhandler:StatementFieldNames.
             hTbl = hbuffer:table-handle.
        end.       
        if  valid-object(Fieldhandler) then
        do:
            cAssignedFields = Fieldhandler:WriteFieldAssignments(stream script:handle, GetEntityInstance(hbuffer:name),5, hbuffer).   
        end.  
        
        do i = 1 to hbuffer:num-fields:
            hFld =  hBuffer:buffer-field (i).
            if cStatementFields > "" and lookup(hFld:name,cStatementFields) > 0 then 
                next.
            if cAssignedFields > "" and lookup(hFld:name,cAssignedFields) > 0 then 
                next.    
            if lookup(hbuffer:name + "." + hFld:name,mreadonly) = 0 then
                 WriteField(hFld).
        end.
        put stream script unformatted "    ." skip.
        if  cStatementFields > ""  then 
        do:
            /* @todo add position param */
            Fieldhandler:WriteFieldStatements(stream script:handle, GetEntityInstance(hbuffer:name),hbuffer).   
        end.
        
        do iChild = 1 to hbuffer:num-child-relations:
            hrel = hbuffer:get-child-relation (iChild).   
            WriteQuery(hRel:query). 
        end.
            
        if valid-handle(hbuffer:parent-relation) then
        do:
           if lookup(mAddEarly,hBuffer:name) = 0 then
               writeAddToParent(hBuffer). 
        end.
        
    end method.    
    
    method private void writeAddToParent(hBuffer as handle): 
         put stream script unformatted skip(1)
                   "/* Add the new "  GetEntityInstance(hbuffer:name) 
                   " to the " GetEntityInstance(hbuffer:parent-relation:parent-buffer:name)  "'s " 
                   GetCollectionName(hbuffer:name) " collection. "  "*/" skip. 
                put stream script unformatted 
                   GetEntityInstance(hbuffer:parent-relation:parent-buffer:name) 
                   ":" 
                   GetCollectionName(hbuffer:name) 
                   ":Add(" GetEntityInstance(hbuffer:name)  ")." skip.
    end.
    
    method private char GetArea(cvalue as char): 
        return "service:GetArea(" + quoter(cValue) + ")" .
    end method.
     
    method private char GetAreaExpression(phbuffer as handle ): 
         define variable cAreaQuery as character no-undo.
         define variable cDataArea  as character no-undo.
         define variable cIndexArea as character no-undo.
         define variable cLobArea as character no-undo.
         define variable hgrandparent as handle no-undo.
         /*   Note: maybe there should be an error if grandparent not found, but as of current the general stratey is to 
             continue to generate code.  
             Writing those as blank or unknown may actually be ok (or in worst case give an error when run). 
             (unknown may be skipped in writefield, but that's probably ok also...)   */
         if phbuffer:name = "ttPartitionPolicyDetail" and valid-handle(phbuffer:parent-relation) then 
                hgrandparent =  phbuffer:parent-relation:parent-buffer.
         cDataArea = if valid-handle(hgrandparent) 
                     then if phbuffer::DefaultDataAreaName > "" 
                          then phbuffer::DefaultDataAreaName 
                          else hgrandparent::DefaultDataAreaName 
                     else phbuffer::DefaultDataAreaName.
        cIndexArea = if valid-handle(hgrandparent) 
                     then if phbuffer::DefaultIndexAreaName > "" 
                          then phbuffer::DefaultIndexAreaName 
                          else hgrandparent::DefaultIndexAreaName
                     else phbuffer::DefaultIndexAreaName.
         cLobArea = if valid-handle(hgrandparent) 
                    then (if phbuffer::DefaultLobAreaName > "" 
                           then  phbuffer::DefaultLobAreaName 
                           else hgrandparent::DefaultLobAreaName)
                    else phbuffer::DefaultLobAreaName.     
         cAreaQuery =   " (ttPartition.ObjectType = 'table' and ttPartition.Areaname <> ~"&1~")"
                      + " or "            
                      + " (ttPartition.ObjectType = 'index' and ttPartition.Areaname <> ~"&2~")"
                      + " or "            
                      + " (ttPartition.ObjectType = 'field' and ttPartition.Areaname <> ~"&3~")".
         return  substitute (cAreaQuery,cDataArea,cIndexArea,cLobArea).             
    end method.
    
    method private char GetPolicyAreaExpression(): 
         define variable cAreaQuery as character no-undo.
         define variable cDataArea  as character no-undo.
         define variable cIndexArea as character no-undo.
         define variable cLobArea as character no-undo.
         cAreaQuery = "(if ttPartitionPolicyDetail.Default&1AreaName > """" then ttPartitionPolicyDetail.Default&1AreaName else ttPartitionPolicy.Default&1AreaName)". 
         cDataArea = substitute(cAreaQuery,"Data").
         cIndexArea = substitute(cAreaQuery,"Index").
         cLobArea = substitute(cAreaQuery,"Lob").
         cAreaQuery =  " (ttPartition.ObjectType = 'table' and ttPartition.Areaname <> &1)"
                      + " or "            
                      + " (ttPartition.ObjectType = 'index' and ttPartition.Areaname <> &2)"
                      + " or "            
                      + " (ttPartition.ObjectType = 'field' and ttPartition.Areaname <> &3)".
         return  substitute (cAreaQuery,cDataArea,cIndexArea,cLobArea).             
    end method.           
                   
    method private handle GetChildQuery(phBuffer as handle , pcname as char): 
        define variable hRel as handle no-undo.
        hRel = GetChildRelation(phBuffer,pcname).
        if valid-handle(hrel) then
            return hrel:query.
        return ?.
    end method.
    
    /* we could have just used the dataset as of current, but this is more correct
       since we want the buffer if it is a child  */
    method private handle GetChildBuffer(phBuffer as handle , pcname as char): 
        define variable hRel as handle no-undo.
        hRel = GetChildRelation(phBuffer,pcname).
        if valid-handle(hrel) then
            return hrel:child-buffer.
        return ?.
    end method.
    
    method private handle GetChildRelation(phBuffer as handle , pcname as char): 
        define variable ichild        as integer no-undo.
        define variable hrel as handle no-undo.
        
        do iChild = 1 to phbuffer:num-child-relations:
            hrel = phbuffer:get-child-relation (iChild).  
            if hrel:child-buffer:name = pcname then
            do:
               return hRel.
            end.
        end.
        return ?.
    end method.
    
    method private char GetAuthenticationSystem(cvalue as char): 
        return "service:GetAuthenticationSystem(" + quoter(cValue) + ")" .
    end method.
    
    method private char GetTable(cvalue as char): 
        return "service:GetTable(" + quoter(cValue) + ")" .
    end method.
    
    method private char GetTenantGroup(cvalue as char): 
        return "service:GetTenantGroup(" + quoter(cValue) + ")" .
    end method.
    
    method private void WriteField(hField as handle):
        if hfield:name matches "AuthenticationSystemName" then
           put stream script unformatted 
             GetEntityInstance(hfield:Table) at 5 ":"  
             replace(hfield:name,"name","") 
             " = " 
             GetAuthenticationSystem(hField:buffer-value) skip.
        else
        if hfield:name matches "*AreaName" then
        do: 
            if hField:buffer-value > "" then
            do:   
              put stream script unformatted 
                 GetEntityInstance(hfield:Table) at 5 ":"  
                 replace(hfield:name,"name","") 
                 " = " 
                 GetArea(hField:buffer-value) skip.
            end. 
        end.
        else
        if hfield:name matches "TableName" then
        do: 
            if hField:buffer-value > "" then
            do:   
              put stream script unformatted 
                 GetEntityInstance(hfield:Table) at 5 ":"  
                 replace(hfield:name,"name","") 
                 " = " 
                 GetTable(hField:buffer-value) skip.
            end. 
        end.
        else if hField:name = "isbuiltin" then
        do:
        end.
        else if hField:name = "schemaname" then
        do: 
           /** TODO check parent and write service:GetTenant("<value>") if not tenant */
           /*   or handle  foreignkey  **/  
        end.    
        else if hField:name = "tenantname" then
        do: 
           /** TODO check parent and write service:GetTenant("<value>") if not tenant **/ 
               /*   or handle  foreignkey  **/   
        end.
        else if hField:name = "partitionpolicyname" then
        do: 
           /** TODO check parent and write service:GetPartitionPolicy("<value>") if not tenant **/  
           /*   or handle  foreignkey  **/      
        end.
        else if hField:name = "domainname" then
        do: 
           /** TODO check parent and write service:GetDomain("<value>") if not domain **/         
           /*   or handle  foreignkey  **/  
        end.
        else if hField:name = "DefaultAllocation" then
        do:
           if hField:buffer-value > "" then 
               put stream script unformatted 
                   GetEntityInstance(hfield:Table) at 5 ":"  
                   hfield:name " = " 
                   quoter(hField:buffer-value ()) skip.
            
        end.    
           
        else if hField:name = "IsAllocated" then
        do:
           
        end.    
        else if not hfield:serialize-hidden 
        and hfield:name <> "name"
        and hfield:name <> "id"
        and hField:buffer-value <> ?
        and not hField:name matches "*url" then
           put stream script unformatted 
               GetEntityInstance(hfield:Table) at 5 ":"  
               hfield:name " = " 
               (if hfield:name = "password" then "cPassword"
                else if hfield:name = "AccessCode" then "cAccessCode"
                else if hfield:data-type = "character" then quoter(hField:buffer-value ())
                else hField:buffer-value ()) skip.
    end method.    
    
    method private char GetEntityInterface(pcBuffername as char): 
        return "I" + GetEntityClass(pcBuffername). 
    end.
    
    method private char GetEntityClass(pcBuffername as char): 
        return caps(substr(pcBufferName,3,1))
               + substr(pcBufferName,4). 
    end.
    
    method private char GetCollectionClass(pcBuffername as char): 
        return  
              caps(substr(pcBufferName,3,1))
               + substr(pcBufferName,4)
               + if pcBuffername = "ttpartition" 
                 then "SchemaMap"
                 else "Set". 
    end.
    
    method private char GetEntityInstance(pcBuffername as char): 
        if pcBuffername = 'ttuser' then 
            return "myUser".
        return 
               lc(substr(pcBufferName,3,1))
              + substr(pcBufferName,4). 
    end.
    
    method private char GetCollectionInstance(pcBuffername as char): 
        return  lc(substr(pcBufferName,3,1))
               + substr(pcBufferName,4)
               + if pcBuffername = "ttpartition" 
                 then "Map"
                 else "Set". 
    end.
    
    method private char GetCollectionName(pcBuffername as char): 
        if pcBuffername = "ttPartitionPolicyDetail" then 
             return "Details".
        return  caps(substr(pcBufferName,3,1))
               + substr(pcBufferName,4)
               + "s". 
    end.
    
    method private char GetNameExpression(phBuffer as handle): 
        return "each " + phBuffer:name + " where " + phBuffer:name + ".Name =" + quoter(phBuffer::name).
    end.
    
    /* creates a query with changed partitions  
      @param  partition buffer 
      @param true if search from grandparent (only valid when parent ttPartitionPolicyDetail ) to
             precheck all details 
       */ 
    method private handle GetPartitionChangeQuery(phbuffer as handle,plgrandparent as log): 
        define variable hquery        as handle no-undo.
        define variable hparent       as handle no-undo.
        define variable hparentBuffer as handle no-undo.
        define variable hPartition    as handle no-undo.     
        define variable cQuery        as char no-undo.
        define variable cparentname   as character no-undo.
        define variable cAreaQuery as character no-undo.
        define variable hGrandparent as handle no-undo.
        define variable hGrandparentbuffer as handle no-undo.
        define variable cAllocDiffExpression as character no-undo.
        define variable cGrandparentname   as character no-undo.
        define variable lfirst as logical no-undo.
        
        create query hquery.
        
        create buffer hPartition for table phbuffer.
       
        cquery = "for each ttPartition".
        if valid-handle(phbuffer:parent-relation) then
        do:
            hparent = phbuffer:parent-relation:parent-buffer.
            if hParent:name = "ttTenant" or hparent:name = "ttTenantGroup" or hparent:name = "ttPartitionPolicyDetail" then
            do:
                /* policy defaults are either specified on policy or detail 
                   (allocationstate is only on policy, but is exposed as read-only on the child so we do not need to 
                   check grandparent for the state value)
              */
            
               if plgrandparent then 
               do:
                   hgrandparent = hparent:parent-relation:parent-buffer.
                   cGrandparentname = lc(substr(hgrandparent:name,3,1)) + substr(hgrandparent:name,4).
            
                   cquery = "for " + GetNameExpression(hgrandparent) + ","
                          + " each " + hParent:name + " where " + hParent:name + "." + cGrandparentname + "Name = " + hgrandparent:name + ".Name,".
                   create buffer hGrandparentbuffer for table hgrandparent. 
                   hquery:add-buffer(hGrandparentbuffer). 
                   cAreaQuery = GetPolicyAreaExpression().
               end.
               else do:  
                   cAreaQuery  = GetAreaExpression(hParent).  
                   cquery = "for " + GetNameExpression(hparent) + ",". 
               end.
               cParentname = lc(substr(hParent:name,3,1)) + substr(hParent:name,4).
               /* policydetails writes Allocate if isAllocated and do not need to include allocated in partititon changes */
               if hparent:name = "ttPartitionPolicyDetail" then
                    cAllocDiffExpression = "( if " + hParent:name + ".DefaultAllocation = 'Immediate' then 'Allocated' else ttPartition.AllocationState )".
         
               else
                   cAllocDiffExpression = "( if " + hParent:name + ".DefaultAllocation = 'Immediate' then 'Allocated' else " + hParent:name + ".DefaultAllocation )".
                
               create buffer hParentBuffer for table hParent. 
               hquery:add-buffer(hParentBuffer).
               
               cquery = cQuery  
                      + " each ttPartition where ttPartition." + cParentname + "Name = " + hParent:name + ".Name "
                      + "and ("
                      + cAreaQuery
                      + " or "
                      + " (ttPartition.ObjectType = 'table' and ttPartition.AllocationState <> " 
                         + cAllocDiffExpression
                      + ")"
                      + " or "
                      + " ttPartition.BufferPool <> 'Primary'"
                       + ")".
            
            end.                  
        end.
        hquery:add-buffer(hPartition).
        hquery:query-prepare(cquery).
        return hQuery.
    end method.
    
    method private void WritePartitions(phParent as handle,phquery as handle): 
        define variable hPartition    as handle no-undo.     
        define variable cQuery        as char no-undo.
        define variable cparentname   as character no-undo.
        define variable cAreaQuery as character no-undo.
        define variable cTempState as character no-undo.
        define variable lfirst as logical no-undo.
        phquery:query-open ().
        phquery:get-first ( ).
        hPartition = phquery:get-buffer-handle ("ttPartition").
        /* the WritePartitionPolicydetail will write detail:Allocate() if isAllocated and do not need to change the query for allocated so
           skip partitions if no changes found */
        if phParent:name <> "ttPartitionPolicyDetail" or hPartition:avail then
        do:
            
            /* extend query to include allocated if immediate is turned off */
            if valid-handle(phParent) 
            and (phParent:name = "tttenant" or phParent:name = "tttenantgroup" or phParent:name = "ttPartitionPolicyDetail")  
            and phParent::DefaultAllocation = "immediate"  then
            do:
                mCannotSetImmediate = true.
                cAreaQuery  = GetAreaExpression(phParent).
                cParentname = lc(substr(phParent:name,3,1)) + substr(phParent:name,4).
                cquery = "for each " + phParent:name + " where " + phParent:name + ".name =" + quoter(phParent::name) + ", " 
                          + " each ttPartition where ttPartition." + cParentname + "Name = " + phParent:name + ".name "
                          + "and ("
                          + cAreaQuery
                          + " or "
                          + " (ttPartition.AllocationState <> " + quoter(GetStateDefault(phParent)) + ")" 
                          + " or "
                          + " ttPartition.BufferPool <> 'Primary'"
                       + ")".
                       
                phQuery:query-close ().
                phquery:query-prepare(cquery).
                phquery:query-open ().
                phquery:get-first ( ).
            end.
            if hPartition:avail then
            do:
                put stream script unformatted 
                    skip(1) "/* Edit the partitions that have non default settings */" skip.
                
                if mCannotSetImmediate then    
                do: 
                    cTempState = GetStateDefault(phParent).          
                    put stream script unformatted 
                        "/******************************************************************************" SKIP   
                         " WARNING: The " + GetEntityClass(phParent:name) + " needs two transactions." skip
                         " The " + GetEntityInstance(phParent:name) +  " DefaultAllocation is ~"Immediate~", but the Partitions " skip 
                         " have properties that do not match the defaults." skip
                         " The DefaultAllocation will be set to " + quoter(cTempState) + " before create to " skip 
                         " allow changes to partitions. The generated partition changes below " skip
                         " takes this into account and includes 'Allocated' partitions." skip 
                         " The DefaultAllocation is set back to ~"Immediate~" in a separate " skip
                         " transaction after the create." skip 
                         "**************************************************************************** */" SKIP   
                    . 
                end. 
                
                lfirst = true.
                do while hPartition:avail:
                    if not lfirst then   
                        put stream script unformatted skip(1).
                    WritePartitionBuffer(phParent,hPartition).
                    lfirst = false.     
                    phquery:get-next ().
                end.
            end.
         end.
 
    end method.
    
    method private void WriteQuery(pquery as handle):
        define variable hBuff as handle no-undo.
        define variable hparent as handle no-undo.
        define variable lWritepartition as logical no-undo.
        define variable cTempState as character no-undo.
        define variable hPartQuery as handle no-undo.
        hbuff = pQuery:get-buffer-handle (1).
        
        if hbuff:name = "ttPartition" then
        do:
            if valid-handle(hbuff:parent-relation) then 
            do:
                hParent =  hbuff:parent-relation:parent-buffer .          
            end.
            hPartQuery = GetPartitionChangeQuery(hbuff,no).
            WritePartitions(hParent, hPartQuery).
        end. 
        else if hbuff:name = "ttTenantGroupMember" then
        do:
            WriteTenantGroupMembers( hbuff).
        end. 
        else if hbuff:name = "ttPartitionPolicyField" then
        do:
            WritePartitionPolicyFields( hbuff).
        end.     
        else if hbuff:name = "ttPartitionPolicyDetail" then
        do:
             WritePartitionPolicyDetails(pQuery).
        end.     
        else if hbuff:name = "ttLocalIndex" then
        do:
            WriteLocalIndexBuffer(hBuff:parent-relation:parent-buffer, pQuery).
        end.     
        else do:
            pQuery:query-open () .
            pquery:get-first ( ).
            do while hbuff:avail:
                if hbuff:name = "ttPartitionPolicy" then
                do:
                    if hbuff::DefaultAllocation = "Immediate" then
                         mCannotSetImmediate = HasPolicyPartitionChanges(hbuff).
                end.    
                WriteBuffer(hbuff).             
                if not valid-handle(hbuff:parent-relation) then
                do:
                    if mCannotSetImmediate and (hbuff:name = "ttTenant" or hbuff:name = "ttTenantGroup" or hbuff:name = "ttPartitionPolicy") then
                    do:
                      cTempState = GetStateDefault(hBuff).
                       put stream script unformatted skip(1)
                     "/******************************************************************************" SKIP   
                     " WARNING: The " + GetEntityClass(hBuff:name) + " needs two transactions."  skip
                     " The " + GetEntityInstance(hBuff:name) +  " DefaultAllocation is ~"Immediate~", but the Partitions " skip 
                     " have properties that do not match the defaults." skip
                     " The DefaultAllocation is set to " + quoter(cTempState) + " before create to allow changes to" skip 
                     " partitions. The generated partition changes above takes this into account " skip
                     " and includes 'Allocated' partitions." skip 
                     " The DefaultAllocation is set back to ~"Immediate~" in a separate call to the " skip  
                     " service's Update" + GetEntityClass(hBuff:name) " method below." skip
                     "**************************************************************************** */" SKIP   
                       GetEntityInstance(hBuff:name) + ":DefaultAllocation = " quoter(cTempState) "." skip.  
                    
                    end.
                    
                    WriteCreateInService(hBuff).
                    
                    if mCannotSetImmediate and (hbuff:name = "ttTenant" or hbuff:name = "ttTenantGroup" or hbuff:name = "ttPartitionPolicy" ) then
                    do:
                  
                        put stream script unformatted 
                        "/** Set default allocation back to 'immediate'  */" skip 
                        GetEntityInstance(hBuff:name) + ":DefaultAllocation = " quoter(hbuff::DefaultAllocation) "." skip.  
               
                        put stream script unformatted

                        "/* Update (commit) the " GetEntityClass(hBuff:name)
                         " with the DefaultAllocation. */ " skip

                         "service:Update" GetEntityClass(hBuff:name)
                              "(" GetEntityInstance(hBuff:name)  ")." skip(1).
                        
                        mCannotSetImmediate = false.               
                    end.
                end.
                pquery:get-next ().
            end.  
        end.
        finally:
            if valid-handle(hPartQuery) then
                delete object hPartQuery  .		
        end finally.
    end.
    
    method private void WriteCreateInService (phBuff as handle):
   
        put stream script unformatted skip(1)
             "/* Create (commit) the " GetEntityInstance(phBuff:name) " in the service */" skip.

        put stream script unformatted
             'service:Create' GetEntityClass(phBuff:name)
                "(" GetEntityInstance(phBuff:name)  ")." skip.

          
    end method.
    
    method private void WritePartitionPolicyFields (phBuffer as handle):
        define variable hquery        as handle no-undo.
        define variable hparent       as handle no-undo.
        define variable hparentBuffer as handle no-undo.
        define variable hPolicyField  as handle no-undo.     
        define variable cQuery        as char no-undo.
        
        create query hquery.
        create buffer hPolicyField for table phbuffer.
       
        cquery = "for each ttPartitionPolicyField".   
        hquery:add-buffer(hPolicyField).
        if valid-handle(phbuffer:parent-relation) then
        do:
             hparent = phbuffer:parent-relation:parent-buffer.
             cquery = "for each ttPartitionPolicyField where ttPartitionPolicyField.PartitionPolicyName = " + quoter(hparent::name).
        end. 
        hquery:query-prepare(cquery).
        hquery:query-open ().
        hquery:get-first ( ).
        if hPolicyField:avail then
        do:
            
            if valid-handle(hParent) 
            and hParent:name = "ttPartitionPolicy"  then 
            do while hPolicyField:avail:
                WritePartitionPolicyFieldBuffer(hparent,hPolicyField).
                hquery:get-next ().
            end.
                    
        end.    
        
        finally:
            delete object hPolicyField  no-error.
            delete object hParentBuffer no-error.
            delete object hQuery  no-error.
        		
        end finally.   
     
    end method.
    
    method private void WriteTenantGroupMembers (phBuffer as handle):
        define variable hquery        as handle no-undo.
        define variable hparent       as handle no-undo.
        define variable hparentBuffer as handle no-undo.
        define variable hPartitionDetail    as handle no-undo.     
        define variable cQuery        as char no-undo.
        
        create query hquery.
        create buffer hPartitionDetail for table phbuffer.
       
        cquery = "for each ttTenantGroupMember".
        hquery:add-buffer(hPartitionDetail).
        if valid-handle(phbuffer:parent-relation) then
        do:
            hparent = phbuffer:parent-relation:parent-buffer.
            if hParent:name = "ttTenant" then
            do:
               cquery = "for each ttTenantGroupMember where ttTenantGroupMember.TenantName = " + quoter(hparent::name).
            end.                  
            if hParent:name = "ttTenantGroup" then
            do:
               cquery = "for each ttTenantGroupMember where ttTenantGroupMember.TenantGroupName = " + quoter(hparent::name).
            end.                  
        end.
        
        hquery:query-prepare(cquery).
        hquery:query-open ().
        hquery:get-first ( ).
        if hPartitionDetail:avail then
        do:
            
            if valid-handle(hParent) 
            and (hParent:name = "tttenant" or hParent:name = "tttenantGroup") then 
            do while hPartitionDetail:avail:
                WriteTenantGroupMembersBuffer(hparent,hPartitionDetail).
                hquery:get-next ().
            end.
                    
        end.       
        delete object hPartitionDetail.
        delete object hParentBuffer NO-ERROR.
        delete object hQuery.
    
    end method.
    
    method private void WriteErrorHandler ():
        put stream script unformatted 
            skip(1)
            "catch e as Error:" skip
            "    errorHandler = new DataAdminErrorHandler()." skip
            "    errorHandler:Error(e)." skip      
            "end catch." skip
            "finally:" skip
            "    delete object service no-error." skip
            "end finally" skip.
    end method.
    
    /** incomplete */
    method public longchar WriteToLongchar(serializable as IDataAdminSerializable,pcMode as char):
        define variable h as handle no-undo.
        define variable cl as longchar no-undo.
        define variable tree as IContextTree no-undo.
        tree = this-object:Write(serializable,pcMode).
        h = tree:GetWriteHandle().
        h:write-json ("Longchar",cl,Formatted). 
        delete object h no-error.
    end method.
    
        /** incomplete */
    method public void WriteToMemptr(serializable as IDataAdminSerializable,m as memptr,pcMode as char):
        define variable h as handle no-undo.
        define variable tree as IContextTree no-undo.
        tree = this-object:Write(serializable,pcMode).
        h = tree:GetWriteHandle().
        h:write-json ("memptr",m,Formatted). 
        delete object h no-error.
        
    end method.
    
        /** incomplete */
    method public void WriteToStream(serializable as IDataAdminSerializable,phStream as handle,pcMode as char):
        define variable h as handle no-undo.
        define variable tree as IContextTree no-undo.
        tree = this-object:Write(serializable,pcMode).
        h = tree:GetWriteHandle().
        h:write-json ("STREAM-HANDLE",phStream,Formatted). 
        delete object h no-error.
    end method.
    
    method public override IContextTree Write(serializable as IDataAdminSerializable,pcMode as char):
         define variable tree as IContextTree no-undo.
         ContextTree = super:Write(serializable,pcMode).
         return ContextTree.
    end method.   
    
end class.
