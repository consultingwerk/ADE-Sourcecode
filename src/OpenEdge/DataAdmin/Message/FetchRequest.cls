 /*************************************************************/
  /* Copyright (c) 2011 by progress Software Corporation.      */
  /*                                                           */
  /* all rights reserved.  no part of this program or document */
  /* may be  reproduced in  any form  or by  any means without */
  /* permission in writing from progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    Purpose     : Message for fetch of data 
                  currently also used for reponse   
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Sep 30   2010
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using OpenEdge.DataAdmin.Rest.IPageRequest from propath.

using OpenEdge.DataAdmin.Message.DataAdminMessage from propath.
using OpenEdge.DataAdmin.Message.IFetchRequest from propath.
using OpenEdge.DataAdmin.Message.IFetchResponse from propath.
using OpenEdge.DataAdmin.Message.ITableRequest from propath.
using OpenEdge.DataAdmin.Message.ITableResponse from propath.
using OpenEdge.DataAdmin.Message.TableRequest from propath.
using OpenEdge.DataAdmin.Message.TableResponse from propath.

using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Message.FetchRequest 
                        inherits DataAdminMessage                       
                        implements IFetchRequest, IFetchResponse    : 
     
    define public property IsPageRequest as logical no-undo get. set.
    /* init true 
       - replace on client - append on server (complex queries)
       - better separation - deep copy from dataaccess (overhead, but small - ?)
       - can be split to run on server (see serviceAdapter) 
      */   
    define public property UseReplaceOnClient as logical init true no-undo get. set.
    define variable KeepDataset as logical no-undo.     
    constructor public FetchRequest (h as handle ):
		super (h).	
	end constructor.
    
    /*
    constructor public FetchRequest (h as handle, pcurl as char ):
        super (h,pcurl).  
    end constructor.
    
    constructor public FetchRequest (ctnxtid as char,h as handle, pcurl as char ):
        super (ctnxtid,h,pcurl).  
    end constructor.
    */
/*    constructor public FetchRequest (name as char, ctnxtid as char,h as handle):*/
/*        super (name,ctnxtid,h).                                                 */
/*    end constructor.                                                            */
    
    constructor public FetchRequest (name as char, ctnxtid as char,h as handle,lkeep as log ):
        super (name,ctnxtid,h).   
        KeepDataset = lkeep.   
    end constructor.
    
    /** serialize over TT handle */ 
    constructor public FetchRequest (name as char,hds as handle, hMsgTbl as handle):
        super (name,hds,hmsgtbl).      
    end constructor.
    
    method public logical HasTable (pcTable as char).
        define variable h as handle no-undo.
        h = DataHandle:get-buffer-handle (pcTable).
        return valid-handle(h).   
    end method.
     
    /* use where-string for non top tables */   
    method public char GetTableQuery (pcTable as char):
        AssertTable(pcTable).
        find ttTableMessage where ttTableMessage.TableName   = pctable no-error.
        if avail ttTableMessage then 
        do:
          /* ensure this works also when only keyfield and keyvalue is passed from client */
          if (ttTableMessage.QueryString = "" or ttTableMessage.QueryString = ?)
          and ttTableMessage.KeyField > "" and ttTableMessage.KeyValue > "" then  
              return subst("for each &1 where &1.&2 = &3",pctable,ttTableMessage.KeyField,quoter(ttTableMessage.KeyValue)).
          else
            return ttTableMessage.QueryString. 
        end.
        return "".
    end method.    
    
     /* key field for single row request */   
    method public char GetTableKeyField (pcTable as char):
        AssertTable(pcTable).
        find ttTableMessage where ttTableMessage.TableName   = pctable no-error.
        if avail ttTableMessage then 
        do:
            return ttTableMessage.KeyField. 
        end.
        return "".
    end method.    
    
         /* key value for single row request 
            values are quoted in query so datatype is not important
            if we know the type we may just convert to the right type 
            in static code */   
    method public char GetTableKeyValue (pcTable as char):
        AssertTable(pcTable).
        find ttTableMessage where ttTableMessage.TableName   = pctable no-error.
        if avail ttTableMessage then 
        do:
            return ttTableMessage.KeyValue. 
        end.
        return "".
    end method.  
    
    method public char GetTableRequestType (pcTable as char):
        AssertTable(pcTable).
        find ttTableMessage where ttTableMessage.TableName   = pctable no-error.
        if avail ttTableMessage then 
        do:
            return ttTableMessage.RequestType. 
        end.
        return "".
    end method.    
    
    /* optional so don't assertTable - just return false if not found  */
    method public logical GetTableLazy  (pcTable as char).
        find ttTableMessage where ttTableMessage.TableName   = pctable no-error.
        if avail ttTableMessage then 
        do:
            return ttTableMessage.Lazy. 
        end.
        return false.
    end method.
    
    method public ITableRequest GetTableRequest(pcName as char):
        define variable hmsg as handle no-undo.
        define variable hBuffer as handle no-undo.
       
        hMsg = GetRow(pcname).    
        /* return a default request if table in dataset */
        if not valid-handle(hMsg) then 
        do:
            hBuffer = DataHandle:get-buffer-handle (pcName) no-error.
            if not valid-handle(hBuffer) then
               return ?.
            hmsg = FindOrCreateTable(pcName).  
        end.
        return new TableRequest(hmsg).
    end method.   
    
     /** Set total (response after fill) */   
    method public void SetTableTotal (pcTable as char, piTotal as int):     
        find ttTableMessage where ttTableMessage.TableName   = pctable no-error.
        if not avail ttTableMessage then 
           undo, throw new IllegalArgumentError("Invalid table name " + quoter(pctable) + " passed to SetTableTotal"). 
        ttTableMessage.Total = pitotal. 
    
    end method.    
    
    method public void SetTableKeyValue (pcTable as char, pcField as char, pcValue as char):     
        FindOrCreateTable(pctable).
        assign
            ttTableMessage.KeyField = pcField
            ttTableMessage.KeyValue = pcValue
            .
    end method.    
    
    method public void SetTableRequestType (pcTable as char, pcType as char):     
        FindOrCreateTable(pctable).
        ttTableMessage.RequestType = pcType.
    end method.    
    
    method public void SetTableLazy     (pcTable as char, pLazy as logical).
        FindOrCreateTable(pctable).
        ttTableMessage.Lazy = pLazy.
    end method.    
    
    method public void SetTablePageRequest (pcTable as char, pisize as int):     
        SetTablePageRequest(pcTable, pisize, 0).
    end method.    
    
    method public void SetTablePageRequest (pcTable as char, pisize as int, pistart as int):     
        FindOrCreateTable(pctable).
        assign 
            ttTableMessage.PageSize = pisize
            ttTableMessage.Start = piStart.         
/*        DataHandle:top-nav-query(pcTable):query-prepare(pcQuery).*/
    end method.    
    
    method protected override character MessageString():
        define variable i as integer no-undo.
        define variable cname as character no-undo.
        define variable hBuf as handle no-undo.
        define variable cQuery as character no-undo.
        define variable cString as character no-undo.
        if valid-handle(DataHandle) then
        do i = 1 to DataHandle:num-buffers:
           hBuf  = DataHandle:get-buffer-handle(i).
           cName = hbuf:name.
           cQuery = GetTableQuery(cName).
           cString = cString + "~n" 
                   + (if cQuery > "" then cQuery else cName)
                   + " hasRecords: "  + string(hBuf:table-handle:has-records) 
                   + " table-handle: "  + string(hBuf:table-handle) .    
        end.     
        return cString.
    end.    

	/*------------------------------------------------------------------------------
	 Purpose: Added to allow keep alive of dynamic dataset
	         (before this all dynamic ds IN where deleted by ServoceAdapter)
	 Notes: Relying on the garbage collector could lead to errors, for example if checking 
	        valid-handle before it was deleted and then getting in trouble when the gc kicks in.
	        But if the dataset is needed then set keep alive must be set.   
	------------------------------------------------------------------------------*/
	destructor public FetchRequest ( ):
        /* delete the request dataset retrieved from the message if it is dynamic */
        if not KeepDataset and valid-handle(DataHandle) and DataHandle:dynamic then
        do: 
            delete object DataHandle no-error. 
        end.
            
	end destructor.
         
end class.
