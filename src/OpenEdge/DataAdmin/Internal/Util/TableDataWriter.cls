 /*************************************************************/
  /* Copyright (c) 2011 by progress Software Corporation.      */
  /*                                                           */
  /* all rights reserved.  no part of this program or document */
  /* may be  reproduced in  any form  or by  any means without */
  /* permission in writing from progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    File        : TableDataReader
    Purpose     : wrapper for dataadmin .d export
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Apr 28 
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Internal.Util.TableExportUtility.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Internal.Util.TableDataWriter inherits TableExportUtility: 
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	
	constructor public TableDataWriter (  ):
        super ("TableDataWriter").
	end constructor.
    
end class.