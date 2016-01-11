
/*------------------------------------------------------------------------
    File        : _oeidewizard.p
    Purpose     : server for the ide 
                  client for the wizard.  
    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Wed Nov 26 12:54:13 EST 2008
    Notes       : Started and stopped by the wizard. 
                 <ide>/runtime/_server will publish OEIDE_WIZARD to get the handle
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define variable fWizard        as handle no-undo.
define variable fContextHandle as handle no-undo.

define variable fClosing as logical no-undo.

define variable PARAMETER_DELIMITER as char no-undo init "|".
define variable phand as handle no-undo.
/* ********************  Preprocessor Definitions  ******************** */

/* ***************************  Main Block  *************************** */
/* _server.p publishes OEIDE_ + servername to find services started by ade */
subscribe procedure this-procedure to "OEIDE_WIZARD" anywhere run-procedure "thisProcedure".

/*** forward declaration of context functions ***/   
function setNewFileName returns logical  
    (pcNewFileName as char) in fContextHandle.

function setDesignHwnd returns logical 
	(pcFile as char,
	 piHwnd as integer) in fContextHandle.
    
/*** internal procedures ***/   
{adecomm/_adetool.i} /* ADEpersistent */
 
procedure thisProcedure :
    define output parameter phHandle as handle no-undo.
    phHandle = this-procedure.
end procedure.

procedure setWizard:
    define input parameter phHandle as handle no-undo.
    fWizard = phHandle.
end.

procedure setHandles :
    define input parameter pcNames   as char   no-undo extent.
    define input parameter pcHandles as handle no-undo extent.
    define variable i as integer no-undo.

    do i = 1 to extent(pcNames):
        case pcNames[i]:
            when "Wizard" then fWizard = pcHandles[i]. 
/*            otherwise do transaction:               */
/*                create ttHandle.                    */
/*                assign ttHandle.name = pcNames[i]   */
/*                       ttHandle.hdl  = pcHandles[i].*/
/*            end.                                    */
               
        end.
        
    end.     
end procedure.

procedure validateAction:
/*------------------------------------------------------------------------------
		Purpose: validate current wizard page and apply action and 
		         return status 
		          
		param:
	      	action - Back or Next 																	  
		Notes: Does not display data in order to return status.
		       client must wait since the request may show message. 															  
------------------------------------------------------------------------------*/
    define input parameter cCmd as character no-undo.
    define variable cResult as character no-undo.

    run validateAction in fWizard (cCmd, output cResult).
    
    return cResult.      

end procedure.

procedure showPage:
/*------------------------------------------------------------------------------
		Purpose: Show the current page 																	  
		Notes:   Displays data to IDE, so don't wait for this request in UI 
		         thread 																	  
------------------------------------------------------------------------------*/
    define input parameter cCmd as character no-undo.
    run showCurrentPage in fWizard.

    return "OK".      

end procedure.

procedure finishWizard:
/*------------------------------------------------------------------------------
		Purpose: Finish the wizard																	  
		Notes:    																  
------------------------------------------------------------------------------*/
    define input parameter pcInfo as character no-undo.
    
    define variable cNewFile    as char no-undo.
/*    define variable iEditorHwnd as int  no-undo.              */
/*                                                              */
    assign
        cNewFile    = entry(1,pcInfo,PARAMETER_DELIMITER)
/*        iEditorHwnd = int(entry(2,pcInfo,PARAMETER_DELIMITER))*/
        no-error.
/*                                                              */
/*                                                              */
    setNewFileName(cNewFile).
    fClosing = true.
    run finishWizard in fWizard.
    
    return "OK".      

end procedure.

procedure cancel:
/*------------------------------------------------------------------------------
		Purpose: Cancel the wizard 																	  
		Notes:    																	  
------------------------------------------------------------------------------*/
    define input parameter cCmd as character no-undo.
    fClosing = true.
    run CancelWizard in fWizard.
     
    return "OK".      

end procedure. 

procedure destroyObject:
    
    if not fClosing and valid-handle(fWizard) then 
        run cancel(""). 
    else
    do:
        publish "OEIDE_UnregisterScope" from this-procedure (input "wizard").
        delete procedure this-procedure.
    end.    
end.   
    
/* set from runtime/_serverdefault */
procedure setContextHandle:
    define input parameter hContext as handle no-undo.
    fContextHandle = hContext.
end.   
         