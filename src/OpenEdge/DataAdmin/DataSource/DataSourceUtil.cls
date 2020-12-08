/*************************************************************/
/* Copyright (c) 2014,2020 by progress Software Corporation. */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
/*------------------------------------------------------------------------
    File        : DataSourceUtil
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Jan 2014
    Notes       : 
 ----------------------------------------------------------------------*/
block-level on error undo, throw.      

using OpenEdge.DataAdmin.DataSource.DatabaseInfo.
using OpenEdge.DataAdmin.Error.IllegalArgumentError.
using Progress.Lang.*.

class OpenEdge.DataAdmin.DataSource.DataSourceUtil: 
    
    define protected property DatabaseInfo as DatabaseInfo no-undo 
        get():
            if not valid-object(DatabaseInfo) then
                DatabaseInfo = new DatabaseInfo().
            return DatabaseInfo.     
        end. 
        set.
        
    define public property DatabaseRecid as recid no-undo 
        get.
        private set. 
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
		
	constructor public DataSourceUtil (  ):
		super ().
		DatabaseRecid = DatabaseInfo:DatabaseRecid.
	end constructor.
    
    method public char GetIndexes (precid as recid, pcFieldNames as char extent) : 
        define variable i as integer no-undo.
        define variable cTable as character no-undo.
        define variable cIndexList as character no-undo.
        define variable cIndexList2 as character no-undo.
        do i = 1 to extent(pcFieldnames):
        
            find dictdb._field where dictdb._field._file-recid = precid and dictdb._field._field-name =  pcFieldnames[i] no-lock no-error.
            if not avail dictdb._field then 
            do:
                find dictdb._file where recid(dictdb._file) = precid no-lock no-error.
                if not avail dictdb._file then 
                    undo, throw new IllegalArgumentError("Table with recid " + quoter(precid) + " does not exist."). 
           
                undo, throw new IllegalArgumentError("Field " + quoter(pcFieldnames[i]) + " does not exist in table " + quoter(dictdb._file._file-name)). 
            end.
            cIndexList = "".
            for each dictdb._index-field of dictdb._field where dictdb._index-field._index-seq = i no-lock,
                first dictdb._index of dictdb._index-field no-lock by dictdb._index._index-name:
                if i = 1 then 
                   cIndexList = cIndexList 
                              + (if cIndexList = "" then "" else ",") 
                              + dictdb._index._index-name.       
                else do: 
                   if lookup(dictdb._index._index-name,cIndexList2) > 0 then
                      cIndexList = cIndexList 
                                 + (if cIndexList = "" then "" else ",") 
                                 + dictdb._index._index-name.       
                end.
            end.
            cIndexList2 = cIndexList. 
        end.    
        return cIndexList2.  
    end.
     /* returns list of indexes that begins with the passed list of fields 
       @param pcTable table (PUB only) 
       @param fieldnames - comma separated list of fieldnames 
       @returns comma separated list of index names
    */
    method public char GetIndexes (pcTable as char, pcFieldNames as char extent) :
        
        find dictdb._file where dictdb._file._db-recid = DatabaseRecid
                          and   dictdb._file._file-name = pcTable
                          and   dictdb._file._owner = "PUB" no-lock no-error. 
        if not avail dictdb._file then 
        do:
            undo, throw new IllegalArgumentError("Table " + quoter(pcTable) + " does not exist."). 
        end.
        return GetIndexes(recid(dictdb._file),pcFieldNames).
    end.
    
    /* returns list of indexes that begins with the passed list of fields 
       @param pcTable table (PUB only) 
       @param fieldnames - comma separated list of fieldnames 
       @returns comma separated list of index names
    */
    method public char GetIndexes (pcTable as char, pcFieldNames as char) :
        define variable i as integer no-undo.
        define variable cFldnames as character extent no-undo.
        extent(cFldnames) = num-entries(pcFieldnames).
        do i = 1 to num-entries(pcFieldnames):
            cFldnames[i] =  entry(i,pcFieldNames).
        end. 
        return GetIndexes(pcTable,cFldnames).
    end.
    
    /* returns list of indexes that begins with the passed list of fields 
       @param pcTable table (PUB only) 
       @param fieldnames - comma separated list of fieldnames 
       @returns comma separated list of index names
    */
    method public char GetIndexes (pcTable as char) :
        define variable cflds      as character extent no-undo.
        define variable i          as integer no-undo.
        define variable cIndexList as character no-undo.
        
        find dictdb._file where dictdb._file._db-recid = DatabaseRecid
                         and   dictdb._file._file-name = pcTable
                         and   dictdb._file._owner = "PUB" no-lock no-error. 
        if not avail dictdb._file then 
            undo, throw new IllegalArgumentError("Table " + quoter(pcTable) + " does not exist."). 
        
        for each dictdb._index of dictdb._file no-lock:
             cIndexList = cIndexList 
                        + (if cIndexList = "" then "" else ",") 
                        + dictdb._index._index-name.  
        end.    
        return cIndexList.  
    end.   
     
     /* returns list of indexes that begins with the passed list of fields 
       @param pcTable table (PUB only) 
       @param fieldnames - comma separated list of fieldnames 
       @returns comma separated list of index names
    */
    method public logical IsIndexLocal (pcTable as char, pcIndexName as char) :
        find dictdb._file where dictdb._file._db-recid = DatabaseRecid
                         and   dictdb._file._file-name = pcTable
                         and   dictdb._file._owner = "PUB" no-lock no-error. 
        if not avail dictdb._file then 
            undo, throw new IllegalArgumentError("Table " + quoter(pcTable) + " does not exist."). 
      
        find dictdb._index of dictdb._file where dictdb._index._index-name = pcIndexName no-lock no-error.
        if not avail dictdb._index then 
            undo, throw new IllegalArgumentError("Index " + quoter(pcIndexName) + " does not exist in table " + quoter(pcTable)). 
        return dictdb._index._index-attributes[1].
    end.
                
end class.
	    
