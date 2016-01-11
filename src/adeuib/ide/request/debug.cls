 
 /*------------------------------------------------------------------------
    File        : debug
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Aug 23 23:57:26 EDT 2012
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

routine-level on error undo, throw.

class adeuib.ide.request.debug: 

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
    
    define static property FileName as char no-undo 
         get():
             if Filename = "" then
             do:
                file-info:file-name = ".".
                return file-info:full-pathname + "debug.log".
             end.
         end. 
         set. 
    
    define stream mystream.
     
     
    
	method public static final void log(msg as char):
		output stream mystream to "c:\abintegration\MyProj\debug.log" append.
		put stream mystream unformatted now msg skip.
        output stream mystream close. 
	end method.

    method public static final void log(msg as char,stack as log):
        define variable cc as character no-undo.
        define variable i as integer no-undo.
        output stream mystream to "c:\abintegration\MyProj\debug.log" append.
        put stream mystream unformatted now space(1) msg skip.
        i = 1. /* skip this one */
        if stack then 
        do while true:
            i = i + 1.
            cc = program-name(i).
            if cc = ? then leave.
            put stream mystream unformatted cc at 5  skip.
            
        end.    
        output stream mystream close. 
        
    end method.


end class.