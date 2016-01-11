 /*************************************************************/
  /* Copyright (c) 2011 by progress Software Corporation.      */
  /*                                                           */
  /* all rights reserved.  no part of this program or document */
  /* may be  reproduced in  any form  or by  any means without */
  /* permission in writing from progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    File        : _tenant-sel-dialog
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Feb 21 00:10:09 EST 2011
    Notes       : Define with static frame in order to be added to other frames
                  (cannot do that with static browse)
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
 
 
using prodict.misc._browse from propath.
 
class prodict.pro._tenant-sel-browse inherits _browse :  
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
    {daschema/tenant.i}
 
 	define query qTenant for ttTenant scrolling.

    define browse bTenant query qTenant
        display Name format "x(32)"
                Id  format "->>>>9"
                ExternalId format "x(200)" width 25
                Type       format "x(8)"   
        WITH NO-ROW-MARKERS SEPARATORS  
         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 7 DOWN   NO-BOX
         &ELSE 10 DOWN   &ENDIF 
         FIT-LAST-COLUMN.
         
 	define frame Browse-Frame
      bTenant    
      with
      three-d no-box
        &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
         centered
        &ENDIF
      no-underline scrollable  overlay.  
      /* title "Tenants" set from Presenter:title */
    
    constructor public _tenant-sel-browse ():
        super (btenant:handle in frame Browse-Frame ).    
    end constructor.
     	
	constructor public _tenant-sel-browse (hParent as handle ):
		super (btenant:handle in frame Browse-Frame ). 	   
	    Parent = hParent.	
	end constructor.
 
end class.