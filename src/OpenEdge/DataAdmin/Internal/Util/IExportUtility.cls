/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
/*------------------------------------------------------------------------
    File        : IFileExportOptions
    Purpose     : common wrapper for data admin dump of sequences and tables
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Apr 28  
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Internal.Util.IDataUtility.

interface OpenEdge.DataAdmin.Internal.Util.IExportUtility inherits IDataUtility:  
    define public property CodePage as character no-undo get. set.  

end interface.