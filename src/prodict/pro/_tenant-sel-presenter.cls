/*************************************************************/
/* Copyright (c) 2011 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : _tenant-sel-presenter
    Purpose     : Browse and select tenant
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Feb 21  
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

using prodict.misc._browse from propath.
using prodict.pro._pro-presenter from propath.
using prodict.pro._tenant-model from propath.
using prodict.pro._pro-sel-dialog-gui from propath.
using prodict.pro._pro-sel-dialog-tty from propath.

{prodict/admnhlp.i}
        
class prodict.pro._tenant-sel-presenter inherits _pro-presenter: 
    
    constructor public _tenant-sel-presenter ( ):
		super ().
	end constructor. 
  
    method protected override void Create():
        define variable mbrowse as _browse no-undo.
        mbrowse = new prodict.pro._tenant-sel-browse(). 
        Model = new _tenant-model ().
        if session:window-system = "tty" then
        do:
            this-object:View = new _pro-sel-dialog-tty (this-object ,mbrowse).
        end.
        else do:
            HelpId = {&Select_Tenant_Dialog_Box}.
            this-object:View = new _pro-sel-dialog-gui (this-object,mbrowse).
        end.
    end method.
   
end class.