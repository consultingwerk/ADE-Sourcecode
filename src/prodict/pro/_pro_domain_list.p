/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
/*------------------------------------------------------------------------
    File        : _pro_domain_list.p
    Purpose     : return a list of _sec_authentication-domain names 
    Author(s)   : hdaniels 
    Created     :  
    Notes       : used by prodict/user/_usruchg.p and prodict/gui/_guiuchg.p        
  ----------------------------------------------------------------------*/
using prodict.pro._domain-model.
using prodict.misc._query.

/* ***************************  Definitions  ************************** */
/* usertable or all   */
define input  parameter  pcType    as character    no-undo.
/* delimiter - commas in area names allowed */
define input  parameter  pdlm          as character no-undo.    
define output parameter  pDomains      as character no-undo.

define variable cSkipArea as character no-undo.
define variable Model as _domain-model no-undo.
define variable DataView as _query no-undo.

/* ***************************  Main Block  *************************** */

Model = new _domain-model ().
if pcType > "" then   
    Model:FetchData("for each ttdomain where ttdomain.DomainTypeName = " + quoter(pcType)).
else
    Model:FetchData().
        
DataView = Model:GetQuery("ttdomain"). 
 
DataView:Init(). 
pDomains = DataView:ValueList("Name","",pdlm).
delete object Model.
catch e2 as Progress.Lang.Error :
	message e2:GetMessage(1) skip
	        if session:error-stack-trace then e2:CallStack else ""
    view-as alert-box.	
end catch.
 