 /*************************************************************/
 /* Copyright (c) 2011-2017 by Progress Software Corporation  */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/ 
/*------------------------------------------------------------------------
    File        : ISecurityOptions.cls
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : rkumar
    Created     : 2011
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */



/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
 
using OpenEdge.DataAdmin.DataAdminService from propath.
using OpenEdge.DataAdmin.IDataAdminElement from propath.
using OpenEdge.DataAdmin.Binding.IContextTree from propath.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
interface OpenEdge.DataAdmin.ISecurityOptions inherits IDataAdminElement :  
    define public property TrustApplicationDomainRegistry as logical no-undo get. set.
    define public property RecordAuthenticatedSessions as logical no-undo get. set.
    define public property DisallowBlankUserid as logical no-undo get. set.
    define public property UseRuntimePermissions as logical no-undo get. set.
    define public property CDCUserid as character no-undo get. set.
     
end interface.