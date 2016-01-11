 /*************************************************************/
  /* Copyright (c) 2011,2014 by progress Software Corporation. */
  /*                                                           */
  /* all rights reserved.  no part of this program or document */
  /* may be  reproduced in  any form  or by  any means without */
  /* permission in writing from progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    File        : _pro-sel-dialog-tty
    Purpose     : 
    Syntax      : 
    Description : general selection dialog  
    Author(s)   : hdaniels
    Created     :  
    Notes       : This compiles and runs on gui, but differs from gui as follows:
                  - no rectangles
                  - no help button 
                  - simplified sizing (override Layout()) 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

using prodict.misc._browse from propath. 
using prodict.pro._ipresenter from propath.
using prodict.pro._pro-sel-dialog from propath.
class prodict.pro._pro-sel-dialog-tty inherits _pro-sel-dialog:  
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
 
    define button btnCancel label "Ca&ncel" auto-end-key size 11 by 1.
    define button btnOk label "&OK" auto-go size 11 by 1.
  	define variable mb as prodict.misc._browse no-undo.
  	
  	/* the button's row will be adjusted in the Layout override below */
 	define frame Dialog-Frame       
        btnOk      at row 1 col 2  
        btnCancel  at row 1 col 14       
        with view-as dialog-box three-d
        keep-tab-order side-labels
        no-underline scrollable centered overlay.  
    
     /* pass presenter and browse - the browse will be parented to the frame in super*/   
    constructor public _pro-sel-dialog-tty (pPresenter as _ipresenter,pbrowse as _browse ):
        super (pPresenter,frame Dialog-Frame:handle,pbrowse ).
        mb =   pbrowse.  
    end constructor.
 
    method public override void Layout():
          
         frame Dialog-Frame:title = Presenter:title.
         /* adjust width to fit browse */
         frame Dialog-Frame:width = mb:width. 
         /* set row from presenter (ignore Col - keep centered) */
         /* NOTE - GPF if row is set before width (because it is centered? ) */
         frame Dialog-Frame:row = Presenter:row .
       
      
         /* set frame height to take all available space 
            and adjust buttons and browse accordingly- use SCREEN-LINES */
         frame Dialog-Frame:height = SCREEN-LINES - Presenter:Row.
         mb:Height = frame Dialog-Frame:height - 4.
         btnOk:row = frame Dialog-Frame:height - 2.
         btnCancel:row = frame Dialog-Frame:height - 2.
      
    end method.   
        
    method public override void Enable(): 
	    enable btnOk btnCancel with frame Dialog-Frame.
	    super:Enable().
	end method. 
 
end class.