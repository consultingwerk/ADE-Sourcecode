/*************************************************************/
/* Copyright (c) 2014 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------
    File        : IPasswordPolicy
    Purpose     : defines password rules currently used by user and domain
    Syntax      :  
    Description : 
    Author(s)   : hdaniels
    Created     : Wed Oct 29 2014
    Notes       : Defined as separate interface in case we want more 
                  rules.(a simple case would be password length) 
               -  Exposed through DataAdminService:PasswordPolicy,
                  which have a default implementation.  
               -  The DataAdminService:PasswordPolicy property is settable 
                  so one could add a class that implements this, but keep in
                  mind that this interface is likely to change in future 
                  versions                    
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

interface OpenEdge.DataAdmin.Core.IPasswordPolicy:  
  
    /** Set to true to avoid encoding of IUser password by service (data access) 
        If false (default) the User password will be encded using ENCODE
    */
    
	define public property PreEncodeUserPassword as logical no-undo 
	get.
	set. 

    /** Set to true to avoid encoding of IDomain access code by service (data access)
    If false (default) the domain access code will be encded using 
    AUDIT-POLICY:ENCRYPT-AUDIT-MAC-KEY()
    */
    define public property PreEncodeDomainAccessCode as logical no-undo 
    get.
    set.
    
end interface.