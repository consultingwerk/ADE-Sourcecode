/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : DataUtility
    Purpose     : Client side common wrapper for data admin dump/load of sequences 
                  and tables
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Apr 28 
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Util.IDataAdminUtility.
using OpenEdge.DataAdmin.IDataAdminCollection .
using OpenEdge.DataAdmin.Message.UtilityRequest.
using OpenEdge.DataAdmin.Message.IUtilityRequest.
using OpenEdge.DataAdmin.Internal.Util.IDataUtility.
 
routine-level on error undo, throw.

class OpenEdge.DataAdmin.Internal.Util.DataUtility abstract implements IDataUtility, IDataAdminUtility : 
    {daschema/utilityoptions.i}
    {daschema/tenantdata.i}

    define dataset dsoption serialize-name "root" for ttUtilityOptions , ttTenantData.
/*        data-relation xx for ttFileOptions,ttExportTenants*/
/*            relation-fields(name,utilityname).            */
            
	define public property DataHandle as handle no-undo 
    get.
    set. 
	
	define public property AllTenants as logical no-undo 
	get.
	set. 

	define public property Directory as character no-undo 
	get.
	set. 

	define public property FileName as character no-undo 
	get.
	set. 

	define public property Name as character no-undo 
	get.
	set. 
	define public property EntityName as character no-undo 
    get.
    set. 

	define public property Tenants as IDataAdminCollection no-undo 
	get.
	set. 

	define public property UseDefaultLocation as logical no-undo 
	get.
	set. 
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
		
	constructor public DataUtility (cname as char  ):
		super ().
		create ttUtilityOptions.
		EntityName = cname.
    end constructor.

    method protected void Serialize():
         
        assign 
            
           
            ttUtilityOptions.Directory = Directory
            ttUtilityOptions.FileName = FileName
            ttUtilityOptions.UseDefaultLocation = UseDefaultLocation
            /*
            ttUtilityOptions.TenantSelection = TenantSelection
            ttUtilityOptions.SequenceSelection  = SequenceSelection
            ttUtilityOptions.TableSelection  = TableSelection 
            */
            .
           
    end.     
    
    method protected void Deserialize():
        assign 
           
            Directory          = ttUtilityOptions.Directory 
            FileName           = ttUtilityOptions.FileName 
            UseDefaultLocation = ttUtilityOptions.UseDefaultLocation. 
    end.     
    
    method public IUtilityRequest GetRequest().  
        return new UtilityRequest(EntityName,dataset dsoption:handle).
    end method. 
    
    method public void ImportOptions(pcFile as char):
        find ttUtilityOptions.
        delete ttUtilityOptions.
        dataset dsoption:read-json ("file",pcfile,"append").
         
        find ttUtilityOptions. 
   
    end.     
     
    method public void ExportOptions(pcFile as char):
        Create ttUtilityOptions.
        Serialize().
       
        dataset dsoption:write-json ("file",pcfile,yes).       
    end.     

end class.