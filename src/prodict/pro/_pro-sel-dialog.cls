 
 /*------------------------------------------------------------------------
    File        : _pro-sel-dialog
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Feb 21 00:10:09 EST 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using prodict.misc._iwidgethandler. 
using prodict.misc._browse. 

using prodict.pro._tenant-sel-presenter from propath.
using prodict.pro._iview from propath.
using prodict.pro._ipresenter from propath.

class prodict.pro._pro-sel-dialog implements _iview, _iwidgethandler:  
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
    
    define protected property Presenter as _ipresenter no-undo get. set.	
    
 	define variable h as handle no-undo.
  	define variable mFrame as handle no-undo.
    define variable mBrowse as _browse no-undo.
    
    define protected property WidgetHandler as handle no-undo get. set.
    
	constructor public _pro-sel-dialog (pPresenter as _ipresenter, hframe as handle, pbrowse as _browse ):
		super ().
		mFrame = hframe.
		Presenter = pPresenter.   
        mBrowse =  pbrowse. 
        mBrowse:parent = mFrame. 
        run prodict/misc/_eventhandler.p persistent set WidgetHandler (this-object).
	end constructor.
	   
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
    method public void View(  ):
        mFrame:visible = true.
        mBrowse:View().
        return.
    end method.  
    
    method public void Hide(  ):
        mFrame:hidden = true.       
        return.
    end method.  
    
    method public void Disable(  ):
        mBrowse:Disable().       
        return.
    end method.  
    
    method public void WidgetEvent(pcname as char):

       case pcname:
           when "close" then do:
               Close().
           end.    
       end.               
   
    end method.
    
    method public void Close():
        apply "end-error" to mframe.  
    end method.    
   
    method public void Cancel():
    end method.    
   
    method public void Ok():
/*        Presenter:Selected().*/
        apply "go" to mframe.
    end method.    
    
    method public void Display(  ):
        
    end method.  
    
    method public void Enable(  ):
        
        mBrowse:Enable().  
       
        return.
    end method.  
    
    method public void Layout(  ):
        mFrame:Title = Presenter:Title.
        mFrame:column = Presenter:Col no-error.
        mFrame:row = Presenter:Row no-error.
        return.
    end method.  
    
	method public void Init(  ):
	    Layout().
	   
	    mBrowse:Sort:Subscribe(Presenter:Sort).
        mBrowse:DefaultAction:Subscribe(Ok).
	  
	    on window-close of mframe 
	        persistent run widgetEvent in widgetHandler("close").
	    
	    mBrowse:Query = Presenter:BindingHandle.
	
	    mBrowse:Init().
		 
    	this-object:Enable(). 
		 
		this-object:View().  
	 
/*		mBrowse:SetFocus().*/
   end method.    
    
    method public logical Wait(  ):
        define variable lok as logical no-undo.
        define variable h as handle no-undo.
        h = mBrowse:Browse.
        do on error undo, leave 
           on end-key undo, leave:           
            
            wait-for "GO" of mFrame focus h.
            lok = true.
        end.
        
        pause 0 before-hide.
        mFrame:hidden = true.
        return lok.   
    end method.    
    
    method public void ShowSort(pccolumn as char  ):
        mBrowse:ShowSort(pcColumn).
    end method.
    
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	destructor public _pro-sel-dialog ( ):
        delete object WidgetHandler no-error.
	end destructor.
    
     
end class.