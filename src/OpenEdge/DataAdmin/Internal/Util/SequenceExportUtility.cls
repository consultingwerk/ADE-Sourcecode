/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Internal.Util.SequenceUtility.
using OpenEdge.DataAdmin.Internal.Util.ISequenceExportUtility.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Internal.Util.SequenceExportUtility abstract inherits SequenceUtility implements ISequenceExportUtility: 
 
	define public property CodePage as character no-undo 
    get.
    set. 
 
    define public property SequenceSelection as character no-undo 
    get.
    set. 
       
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
		
	constructor public SequenceExportUtility (  pname as char ):
        super (pname).
		
	end constructor.
    
    method protected override void Serialize():
        /* assigns fields for super class */
        super:Serialize().
        assign 
            ttUtilityOptions.CodePage = CodePage      
            ttUtilityOptions.SequenceSelection = SequenceSelection.
             
    end.     
    
    method protected override void Deserialize():
        /* assigns fields for super class */
        super:Deserialize().
        assign 
            CodePage            = ttUtilityOptions.CodePage 
            SequenceSelection   = ttUtilityOptions.SequenceSelection. 
             
    end.     
    
    
end class.