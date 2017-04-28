 /*************************************************************/
 /* Copyright (c) 2016 by Progress Software Corporation.      */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : AllFieldDataSource
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Fri Mar 04 13:07:58 IST 2016
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.DataSource.FieldDataSource.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.DataSource.AllFieldDataSource inherits FieldDataSource: 

    constructor public AllFieldDataSource (  ):
        super (yes). 
    end constructor.

end class.