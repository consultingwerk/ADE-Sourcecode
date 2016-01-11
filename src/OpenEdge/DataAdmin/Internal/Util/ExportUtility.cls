/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : ExportUtility
    Purpose     : common wrapper for data admin dump of sequences and tables
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

using OpenEdge.DataAdmin.Internal.Util.DataUtility. 
using OpenEdge.DataAdmin.Internal.Util.IExportUtility.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Internal.Util.ExportUtility abstract inherits DataUtility implements IExportUtility: 

	define public property CodePage as character no-undo 
    get.
    set. 
  
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
		
	constructor public ExportUtility( pname as char ):
		super (pname).
	end constructor.

    method protected override void Serialize():
        /* assigns fields for super class */
        super:Serialize().
        assign 
            ttUtilityOptions.CodePage = CodePage.
             
    end.     
    
    method protected override void Deserialize():
        /* assigns fields for super class */
        super:Deserialize().
        assign 
            CodePage = ttUtilityOptions.CodePage.  
            
    end.     

end class.