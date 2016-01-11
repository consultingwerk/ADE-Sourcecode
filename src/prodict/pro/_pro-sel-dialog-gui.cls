/*************************************************************/
/* Copyright (c) 2011 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : _pro-sel-dialog-gui
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Feb 21 00:10:09 EST 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

using prodict.misc._browse from propath.   
using prodict.pro._ipresenter from propath.
using prodict.pro._pro-sel-dialog from propath.

class prodict.pro._pro-sel-dialog-gui inherits _pro-sel-dialog:  
    define variable mb  as _browse no-undo.
 	
 	define button btnCancel label "Ca&ncel" auto-end-key size 15 by .95  .
    define button btnOk auto-go label "&OK" size 15 by .95. 
    define button BtnHelp label "&Help" size 15 by .95. 
    
 	define frame Dialog-Frame
       
      btnOk at row 1 col 1  
      btnCancel at row 1 col 16
      BtnHelp at row 1  col 31
      with
      
      view-as dialog-box three-d
      keep-tab-order side-labels
      no-underline no-box  centered overlay.  
       
    constructor public _pro-sel-dialog-gui (pPresenter as _ipresenter, pbrowse as _browse ):
        super (pPresenter,frame Dialog-Frame:handle,pbrowse).   
        mb = pbrowse.
    end constructor.
    
    method public override void Layout():
         
         frame Dialog-Frame:title = Presenter:title.
         /* adjust width to fit browse */
/*         frame Dialog-Frame:width = mb:width.*/
         /* set row from presenter (ignore Col - keep centered) */
         /* NOTE - GPF if row is set before width (because it is centered? ) */
         frame Dialog-Frame:row = Presenter:row.
         frame Dialog-Frame:col = Presenter:col.
         frame Dialog-Frame:width = mb:width + 1.7.
 
         frame Dialog-Frame:height = mb:height + 3 .
/*         frame Dialog-Frame:height = 14.*/
         btnOk:row = frame Dialog-Frame:height - btnOk:height - 0.7.
         btnCancel:row = frame Dialog-Frame:height - btnCancel:height - 0.7.
         btnhelp:row = frame Dialog-Frame:height - btnhelp:height - 0.7  .
         btnhelp:col = frame Dialog-Frame:width - btnhelp:width - 1. /* */
    
    end method.   
    
    method public override void WidgetEvent(pcname as char):
       case pcname:
           when "Help" then 
           do:
               Presenter:ShowHelp().
           end.
           otherwise super:WidgetEvent(pcName).    
       end.               
    end method.
    
    method public override void Init(  ):        
        on "choose" of btnhelp in frame Dialog-Frame 
            persistent run widgetEvent in widgetHandler("Help").
        super:Init().
         
    end method.   
    
    method public override void Enable(): 
	    super:Enable().
	    enable btnOk btnCancel btnHelp 
	    with frame Dialog-Frame.
	end method. 

end class.