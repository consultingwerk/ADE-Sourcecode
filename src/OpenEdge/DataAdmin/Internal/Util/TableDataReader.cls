 /*************************************************************/
  /* Copyright (c) 2011 by progress Software Corporation.      */
  /*                                                           */
  /* all rights reserved.  no part of this program or document */
  /* may be  reproduced in  any form  or by  any means without */
  /* permission in writing from progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    File        : TableDataReader
    Purpose     : wrapper for dataadmin .d import
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Apr 28 
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Internal.Util.TableDataUtility.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.Internal.Util.TableDataReader inherits TableDataUtility: 
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	
	constructor public TableDataReader ( ):
        super ("TableDataReader").
	end constructor.
 
end class.