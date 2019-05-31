/*************************************************************/
/* Copyright (c) 2014,2019 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------
    File        : PasswordPolicy
    Purpose     : defines password rules currently used by user and domain
    Syntax      :  
    Description : 
    Author(s)   : hdaniels
    Created     : Wed Oct 29 2014
    Notes       :                  
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Core.IPasswordPolicy from propath. 

class OpenEdge.DataAdmin.Core.PasswordPolicy implements IPasswordPolicy:  
  
    /** Set to true to avoid encoding of IUser password by service (data access) 
        If false (default) the User password will be encded using ENCODE
    */
	define public property PreEncodeUserPassword as logical init false no-undo 
	get.
	set. 

    /** Set to true to avoid encoding of IDomain access code by service (data access)
    If false (default) the domain access code will be encded using 
    AUDIT-POLICY:ENCRYPT-AUDIT-MAC-KEY()
    */
    define public property PreEncodeDomainAccessCode as logical init false no-undo 
    get.
    set.
    
end class.
