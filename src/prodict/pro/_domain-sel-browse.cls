 /*************************************************************/
  /* Copyright (c) 2011 by progress Software Corporation.      */
  /*                                                           */
  /* all rights reserved.  no part of this program or document */
  /* may be  reproduced in  any form  or by  any means without */
  /* permission in writing from progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    File        : _domain-sel-browse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  
    Notes       : Define with frame in order to be added to other frames
                  (cannot do that with static browse)
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

 
using prodict.misc._browse from propath.
 
class prodict.pro._domain-sel-browse inherits _browse :  
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
    {daschema/domain.i}
 
 	define query qDomain for ttDomain scrolling.

    define browse bDomain query qDomain
        display Name format "x(64)" label "Domain"  width 32
                TenantName format "x(32)" label "Tenant"  
/*                DomainTypeName format "x(32)" label "Type" width 15*/
             
                IsEnabled 
        WITH NO-ROW-MARKERS SEPARATORS  
         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 5 DOWN   NO-BOX
         &ELSE 10 DOWN   &ENDIF 
         FIT-LAST-COLUMN.
         
 	define frame Browse-Frame
      bDomain    
      with
      three-d no-box
        &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
         centered
        &ENDIF
      no-underline scrollable  overlay.  
      /* title "Tenants" set from Presenter:title */
    
    constructor public _domain-sel-browse ():
        super (bDomain:handle in frame Browse-Frame ).    
    end constructor.
     	
	constructor public _domain-sel-browse (hParent as handle ):
		super (bDomain:handle in frame Browse-Frame ). 	   
	    Parent = hParent.	
	end constructor.
 
end class.