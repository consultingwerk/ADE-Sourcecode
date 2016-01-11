 /*************************************************************/
  /* Copyright (c) 2011 by progress Software Corporation.      */
  /*                                                           */
  /* all rights reserved.  no part of this program or document */
  /* may be  reproduced in  any form  or by  any means without */
  /* permission in writing from progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    File        : _browse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
using Progress.Lang.*.
using prodict.misc._iwidgethandler from propath. 

class prodict.misc._browse implements _iwidgethandler:
    
    define public event Sort signature void (columnName as char).
    define public event DefaultAction signature void ().
    
    define public property Browse as handle no-undo get. set.
     
       /* hidden frame parent of browse - static browse cannot be added to frame */
    define private variable BrowseFrame as handle no-undo.
    
    define public property Query as handle no-undo
        get():
            return Browse:query.
        end.       
        set(h as handle): 
            Browse:query = h.
        end.
    
    define public property Row as decimal no-undo
        get():
            return BrowseFrame:row.
        end.       
        set(drow as decimal): 
            BrowseFrame:row = drow.
        end.
    
    define public property Col as decimal no-undo
        get():
            return BrowseFrame:Col.
        end.       
        set(dcol as decimal): 
            BrowseFrame:Col = dcol.
        end.
    
    define public property Width as decimal no-undo
        get():
            return BrowseFrame:Width.
        end.       
        set(dwidth as decimal): 
            if dwidth > Width then 
            do:
                BrowseFrame:Width = dwidth.
                Browse:Width = dwidth.
            end.
            else do:  
                BrowseFrame:Width = dwidth.
                Browse:Width = dwidth.
            end.
        end.
   	
   	 define public property Height as decimal no-undo
        get():
            return BrowseFrame:Height.
        end.       
        set(dHeight as decimal): 
            if dHeight > Height then 
            do:
                BrowseFrame:Height = dHeight.
                Browse:Height = dHeight.
            end.
            else do:  
                BrowseFrame:Height = dHeight.
                Browse:Height = dHeight.
            end.
        end.
   	
	define public property Parent as handle no-undo 
    	get():
            return BrowseFrame:frame.
    	end.       
    	set(h as handle): 
    	     BrowseFrame:frame = h.
        end.
    
    define protected variable WidgetHandler as handle no-undo.
     
    /* expects browse with frame for parenting   */ 
    constructor public _browse (hBrowse as handle):
        super ( ).   
        Browse = hBrowse.
        BrowseFrame = Browse:frame.
        run prodict/misc/_eventhandler.p persistent set WidgetHandler (this-object).
    end constructor.
    
    method public void Init():    
        Browse:allow-column-searching = true.
             
        on start-search of browse persistent 
           run widgetEvent in WidgetHandler ("start-search").   
        on default-action of browse persistent 
           run widgetEvent in WidgetHandler ("default-action").    
        
    end method.
    
    method public void SetFocus():
        apply "entry" to browse.
    end method.
    
    method public void MoveAfter(h as handle):
        Browse:move-after-tab-item (h).
    end method.
    
    method public void MoveBefore(h as handle):
        Browse:move-before-tab-item (h).
    end method.
         
    method public void WidgetEvent(pcname as char):
        case pcname:
            when "start-search" then 
            do:
                Browse:select-focused-row() no-error.
                Browse:set-repositioned-row (int(Browse:down / 2),"conditional").
                Sort:Publish(Browse:current-column:name).
            end.  
            when "default-action" then do:
                DefaultAction:Publish().
            end.    
        end.               
    end method.
      
    method public void View(): 
        Browse:hidden = false. 
        Browse:select-focused-row() no-error.
    end method. 
    
    method public void ShowSort(pcSort as char): 
        define variable lDesc as logical no-undo.
        define variable cColumn as character no-undo.
        define variable hColumn as handle no-undo.
        define variable iColumn as integer no-undo.
        Browse:clear-sort-arrows().
        if pcSort > '' then
        do:
            
           lDesc = num-entries(pcSort,' ':U) > 1.
           do iColumn = 1 to Browse:num-columns:
              assign
                  cColumn = ''
                  hColumn = Browse:get-browse-column(iColumn) 
                  cColumn = hColumn:name. 
              if cColumn = entry(1,pcSort,' ':U) then
              do:
                  hColumn:sort-ascending = not lDesc.
                  return.
              end. /* column = sortcolumn */
          end. /* column loop */
        end. /* SortColumn > '' */
        finally:
           apply "end-search" to Browse.       		
        end finally.
    end method. 
  
    
    method public void Hide(): 
        Browse:hidden = true. 
    end method. 
        
    method public void Disable(): 
        Browse:sensitive = false. 
    end method. 
  
    method public void Enable(): 
        Browse:sensitive = true. 
    end method. 
    
    destructor public _browse ( ):
        delete object WidgetHandler no-error.
    end destructor.

end class.