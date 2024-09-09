/*************************************************************/
/* Copyright (c) 2011-2016,2024 by progress Software Corporation. */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
/*------------------------------------------------------------------------
    File        : DatabaseInfo
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sat Oct 30 2010
    Notes       : 
 ----------------------------------------------------------------------*/
routine-level on error undo, throw.      
using Progress.Lang.*.

class OpenEdge.DataAdmin.DataSource.DatabaseInfo: 
    
    define public property DatabaseRecid as recid no-undo 
        get.
        private set.
   
    define public property CodePage as char init ? no-undo 
        get.
        private set.
    
    /* TRUE if the Authentication Gateway feature is enabled. */
    define public property AuthenticationGatewayEnabled as logical no-undo
        init ?
        get():
            if this-object:AuthenticationGatewayEnabled eq ? then 
            do:
                find dictdb._Database-Feature where 
                     dictdb._Database-Feature._DBFeature_Name eq 'Authentication Gateway':u 
                     no-lock no-error.
                assign this-object:AuthenticationGatewayEnabled = (available dictdb._Database-Feature and 
                                                                   dictdb._Database-Feature._DBFeature_enabled eq '1':u).
            end.
            return this-object:AuthenticationGatewayEnabled.
        end get.
        private set.
            
    define public property IsNetworkClient as logical no-undo init ? 
        get():
            define variable cParams as character no-undo.
            define variable cParam  as character no-undo.
            define variable cOption as character no-undo.
            define variable i as integer no-undo.
            if IsNetworkClient = ? then
            do:
                IsNetworkClient = false.
                cParams = dbparam("dictdb").
                loop:
                do i = 1 to num-entries(cParams):
                    cParam = entry(i,cParams).
                    coption = left-trim(entry(1,cParam," "),"-").
                    if compare(coption,"=","S","case-sensitive") then
                    do:
                        IsNetworkClient = true.
                        leave loop. 
                    end.  
                end.
            end.
            return IsNetworkClient.
        end.
        private set. 
        
    define public property IsMultiTenant as logical init ? no-undo 
         get():
             if IsMultiTenant = ? then
             do:
                  IsMultiTenant = can-find(first dictdb._tenant).
             end.
             return IsMultiTenant.    
        end.
        private set.
    
    define public property IsPartitionEnabled as logical init ? no-undo 
        get():
            if IsPartitionEnabled = ? then 
            do:
                find dictdb._Database-feature where dictdb._Database-feature._DBFeature_Name = "Table Partitioning" no-lock no-error.
                isPartitionEnabled = avail dictdb._Database-feature and dictdb._Database-feature._dbfeature_enabled = "1".
            end. 
            return isPartitionEnabled.           
        end.
        private set.
        
    define public property IsCDCEnabled as logical init ? no-undo 
        get():
            if IsCDCEnabled = ? then 
            do:
                find dictdb._Database-feature where dictdb._Database-feature._DBFeature_Name = "Change Data Capture" no-lock no-error.
                isCDCEnabled = avail dictdb._Database-feature and dictdb._Database-feature._dbfeature_enabled = "1".
            end. 
            return isCDCEnabled.           
        end.
        private set.

    define public property IsDDMEnabled as logical init false no-undo 
        get():
            find dictdb._Database-feature where dictdb._Database-feature._DBFeature_Name = "Dynamic Data Masking" no-lock no-error.
            IsDDMEnabled = available dictdb._Database-feature and dictdb._Database-feature._dbfeature_enabled = "1".
             
            return IsDDMEnabled.           
        end.
        private set.
    
    define public property IsUserSuperTenant as logical no-undo 
        get():
            return tenant-id("dictdb") < 0.
        end.
        private set.
    
    define public property StorageFieldJoin as char no-undo 
        get():
            return 
                "_StorageObject._db-recid = " + quoter(DatabaseRecid)
              + " and _StorageObject._object-type = 3"
              + " and _StorageObject._object-number = _field._Fld-stlen". 

        end.
        
    define public property StorageIndexJoin as char no-undo 
        get():
            return 
               "_StorageObject._db-recid = " + quoter(DatabaseRecid)
             + " and _StorageObject._object-type = 2"
             + " and _StorageObject._object-number = _index._idx-num". 
        end.
    
    define public property StorageFileJoin as char no-undo 
        get():
           return "_StorageObject._db-recid = " + quoter(DatabaseRecid)
             + " and _StorageObject._object-type = 1"
             + " and _StorageObject._object-number = _file._file-number".
        end.
    
    define public property FileDBExpression as character no-undo 
        get:
            return "_file._db-recid = " + quoter(DatabaseRecid).
        end.
         
 	define public property FileExpression as character no-undo 
    	get:
	        return FileDBExpression + " and  _file._owner = 'PUB' and _file._hidden = 'false' and _file._File-Attributes[6] = 'false'".
	    end.
	
	/* Introduced this to acheive retrieval of non-PUB table/fields */    
	define public property FileExpression2 as character no-undo 
        get:
            return FileDBExpression + " and _file._hidden = 'false'".
        end.
    
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
		
	constructor public DatabaseInfo (  ):
		define buffer bdb  for dictdb._db.
		super ().
	    find first bdb where bdb._db-local = true no-lock.  
        this-object:DatabaseRecid = recid(bdb).      
	   
        this-object:CodePage = bdb._db-xl-name.
	end constructor.

               
end class.
	    