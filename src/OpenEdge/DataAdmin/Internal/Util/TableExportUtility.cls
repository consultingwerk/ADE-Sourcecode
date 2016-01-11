/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : TableExportUtility
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Internal.Util.DataUtility.
using OpenEdge.DataAdmin.Internal.Util.ITableExportUtility.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Internal.Util.TableExportUtility abstract inherits DataUtility implements ITableExportUtility: 
 
	define public property CodePage as character no-undo 
    get.
    set. 
	
	define public property CharacterMap as character no-undo 
	get.
	set. 

	define public property NoMap as logical no-undo 
	get.
	set. 
	
	define public property NoLobs as logical no-undo 
    get.
    set. 
	
	define public property LobDirectory as character no-undo 
    get.
    set. 
	
	define public property TenantDirectory as character no-undo 
    get.
    set. 
    
    define public property TenantLobDirectory as character no-undo 
    get.
    set. 
    
    define public property TableSelection as character no-undo 
    get.
    set. 
        
	
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
		
	constructor public TableExportUtility (  pname as char ):
        super (pname).
		
	end constructor.
    
    method protected override void Serialize():
        /* assigns fields for super class */
        super:Serialize().
        assign 
            ttUtilityOptions.CodePage = CodePage
            ttUtilityOptions.CharacterMap = CharacterMap
            ttUtilityOptions.NoMap = NoMap
            ttUtilityOptions.NoLob = NoLob
            ttUtilityOptions.LobDirectory = LobDirectory
            ttUtilityOptions.TenantLobDirectory = TenantLobDirectory
            ttUtilityOptions.TenantDirectory = TenantDirectory
            ttUtilityOptions.TableSelection = TableSelection.
             
    end.     
    
    method protected override void Deserialize():
        /* assigns fields for super class */
        super:Deserialize().
        assign 
            CodePage            = ttUtilityOptions.CodePage 
            CharacterMap        = ttUtilityOptions.CharacterMap  
            NoMap               = ttUtilityOptions.NoMap 
            NoLob               = ttUtilityOptions.NoLob 
            LobDirectory        = ttUtilityOptions.LobDirectory  
            TenantLobDirectory  = ttUtilityOptions.TenantLobDirectory  
            TenantDirectory     = ttUtilityOptions.TenantDirectory
            TableSelection      = ttUtilityOptions.TableSelection. 
             
    end.     
    
    
end class.