 /*************************************************************/
  /* Copyright (c) 2011 by progress Software Corporation.      */
  /*                                                           */
  /* all rights reserved.  no part of this program or document */
  /* may be  reproduced in  any form  or by  any means without */
  /* permission in writing from progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    File        : _domain-sel-presenter
    Purpose     : Browse and select domain
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Feb 21  
    Notes       : 
	
    Modifications:
    04/18/11 Rajinder Kamboj - added functionality to hide Tenant column for Non-MT database.
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

using prodict.misc._browse from propath.
using prodict.pro._pro-presenter from propath.
using prodict.pro._domain-model from propath.
using prodict.pro._pro-sel-dialog-gui from propath.
using prodict.pro._pro-sel-dialog-tty from propath.

class prodict.pro._domain-sel-presenter inherits _pro-presenter: 
    
    constructor public _domain-sel-presenter ( ):
		super ().
	end constructor. 
  
    method protected override void Create():
        define variable mbrowse as _browse no-undo.
        if can-find(first dictdb._tenant) then		
           mbrowse = new prodict.pro._domain-sel-browse(). 
        else
           mbrowse = new prodict.pro._domain-sel-nonmt-browse(). 
        Model = new _domain-model ().
        if session:window-system = "tty" then
        do:
            this-object:View = new _pro-sel-dialog-tty (this-object, mbrowse).
        end.
        else
            this-object:View = new _pro-sel-dialog-gui (this-object, mbrowse).
    end method.
   
end class.