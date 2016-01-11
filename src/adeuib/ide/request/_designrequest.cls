/*************************************************************/
/* Copyright (c) 2012 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : read and save design windows to  _uibmain 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
 
    Notes       :   
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
using Progress.Lang.* from propath.
using adeuib.ide.request.idesignrequest from propath.
using adeuib.ide.request._designrequest from propath.
using adeuib.ide.request._request from propath.
class adeuib.ide.request._designrequest abstract inherits _request implements idesignrequest :  
    
    define  public property  DYNAMIC_OBJ as char no-undo init "Dynamic":U get.
    define  public property  STATIC_OBJ as char no-undo init "Static":U get.
    define  public property  NATIVE_OBJ as char no-undo init "Native":U get.
    define  public property  REPOS_OBJ as char no-undo init "Repository":U get.    
    
    define public property NewName    as character no-undo get. protected set. 
    define public property LinkName   as character no-undo get. private set. 
    define public property IsSaved    as logical no-undo get. private set.
    define public property IsRepositoryObject as logical no-undo get. private set.
    define public property IsDynamic  as logical no-undo get. private set.
    define public property IsNative   as logical no-undo get. private set.
    
    function getDesignHwnd returns integer   (pcFile as char) in ContextHandle. 
    function createLinkedFile returns char (piHwnd as int, pcfileName as char) in ContextHandle. 
    function setDesignFileName returns logical (piHwnd as integer,pcFilename as char) in ContextHandle.
    
	constructor public _designrequest (pcRequest as char ):
		super (pcRequest).
		SetRequest(pcRequest ).
	end constructor.
    
    method public override logical Execute( ):
        PerformRequest().
        UpdateState().
        return ValidateState(). 
    end method.
    
    method protected void UpdateState():
        run getCurrentWindowInfo in UIBHandle(output NewName,output IsSaved, output IsRepositoryObject, output IsDynamic, output IsNative ).
        NewName = replace(NewName,"~\":U,"/":U). 
        
    end.  
    
    method abstract protected void PerformRequest() .
    method abstract protected logical ValidateState() .
    
    method public override character GetResponse():
        /* NOTE if anything ned to be added the entries used by _oeideuib open* must be included/taken into account
                the response is handled in ABLWindowInfo (sublcass for save)  
                @TODO add response object (ABL version of ABLWindowInfo) to encapsulate the response format */    
        return  (if IsDynamic then DYNAMIC_OBJ else STATIC_OBJ)    
                 + _request:DELIMITER
                 + (if IsNative then NATIVE_OBJ else if IsRepositoryObject then REPOS_OBJ else "")
                 + _request:DELIMITER
                 + NewName
                 + (if LinkName > "" then _request:DELIMITER + LinkName else "").           
    end.             
    
    method protected void CreateNewLinkFile():
        define variable i as integer no-undo.
        i = getDesignHwnd(Name).
        LinkName = createLinkedFile(i,NewName).
    end method.
    
    method protected void UpdateDesignFileName():
        define variable i as integer no-undo.
        i = getDesignHwnd(Name).
        /* we set this also if the file was saved in a different project
           this is a wrong/unnecessary since PDS will send a close request 
           with the old file name when it needs to open the new file in the other project.
           To resolve this we also send the designerid
           see _oeideuib.p closeWindow  */
        setDesignFileName(i,NewName).
    end method.
        
         
end class.