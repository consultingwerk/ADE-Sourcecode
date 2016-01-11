/* ***********************************************************/
/* Copyright (c) 2008-2012,2013 by Progress Software         */
/* Corporation                                               */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
   
/*------------------------------------------------------------------------
    File        : _oeideuib.p
    Purpose     : server for the ide 
                  client for the uib.
                  Receives appbuilder commands from the IDE  
    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Wed Nov 26 12:54:13 EST 2008
    Notes       : Started by the appbuilder. 
                 
                 <ide>/runtime/_server will publish OEIDE_UIB to get the handle
                 
                - Many of the actions depend on AppBuilder widgets both for 
                  check of state (sensitive) and the execution (apply "choose"). 
                - The main reason is that it is difficult to separate the Appbuilder 
                  logical enablement from the physical enablement.                       
  
  BIG NOTE: Return "OK" or "CANCEL" for calls that are embeeded in eclipse dialogs. 
            Most calls do not have client handling, so OK is in many cases returned 
            when cancelled (it is a bit work to get the response from deep down in uibmain where
            many dialogs are fired. Could be supported in the dialogservice object.  
            (ERROR may also be used, but may not be handled)
  
  ----------------------------------------------------------------------*/
using Progress.Lang.* from propath.
using adeuib.ide.request.* from propath.

/* ***************************  Definitions  ************************** */

/* ********************  Preprocessor Definitions  ******************** */

/* ***************************  Main Block  *************************** */ 

define variable STATIC_OBJ  as char no-undo init "Static":U.
define variable REPOS_OBJ   as char no-undo init "Repository":U.
define variable NATIVE_OBJ  as char no-undo init "Native":U.
define variable DYNAMIC_OBJ as char no-undo init "Dynamic":U.
define variable TTY_OBJ     as char no-undo init "TTY":U.
define variable ERROR_OBJ   as char no-undo init "Error":U.

define variable SAVE_CURRENT     as int no-undo init 0.
define variable SAVE_AS          as int no-undo init 1.
define variable SAVE_AS_IN_REPOS as int no-undo init 2.
define variable SAVE_AS_STATIC   as int no-undo init 3.
define variable SAVE_AS_DYNAMIC  as int no-undo init 4.
define variable SAVE_TO_REPOS    as int no-undo init 5.

define variable fContextHandle   as handle no-undo.
define variable fUIB             as handle no-undo.
define variable fCopy            as handle no-undo.
define variable fCut             as handle no-undo.
define variable fDelete          as handle no-undo.
define variable fDuplicate       as handle no-undo.
define variable fPaste           as handle no-undo.
define variable fUndo            as handle no-undo.
define variable fAlign           as handle no-undo.
define variable fSave            as handle no-undo.
define variable fAlternateLayout as handle no-undo.
define variable fCustomLayout    as handle no-undo.
define variable fCustomizationPriority as handle no-undo.
define variable fTabOrder              as handle no-undo.
define variable fWindowHandle          as handle no-undo.
define variable fSaveDynamicAsStatic        as handle no-undo.
define variable fSaveStaticAsDynamic        as handle no-undo.
define variable fRegisterinRepository       as handle no-undo.
define variable fOpenAssociateProcedure     as handle no-undo.
define variable fDynamicObjectGenerator     as handle no-undo.
define variable RequestManager as _requestmanager  no-undo.

define variable PARAMETER_DELIMITER as char no-undo. 
     
define temp-table ttHandle no-undo
    field name as char
    field hdl as handle 
    index name as unique name.
    
/*** forward declaration of context functions ***/   
function createLinkedFile returns char (piHwnd as int64,pcfileName as char) in fContextHandle. 
function clearNewFileName returns logical () in fContextHandle.
function getCurrentEventObject returns Object () in fContextHandle. 
function getDesignHwnd returns int64 (pcFile as char) in fContextHandle. 
function getDesignWindow returns handle (piHwnd as int64) in fContextHandle. 
function getHasNextDialog returns logical () in fContextHandle.
function getLinkFileWindow returns handle  (pcLinkedFile as char) in fContextHandle.
function getNewFileName returns character (  ) in fContextHandle.  
function getObject returns Object (piHwnd as int64) in fContextHandle.  
function getProjectFullPath returns character  (  ) in fContextHandle.
/*function getRequestContext returns character  () in fContextHandle.*/
function removeHwnd returns logical (piHwnd as int64) in fContextHandle.
function setDesignFileName returns logical (piHwnd as int64,pcFilename as char)  in fContextHandle.
function setDesignHwnd returns logical (pcFile as char,piHwnd as int64) in fContextHandle.
function setOpenDialogHwnd returns logical (piHwnd as int64) in fContextHandle.
function setRequestContext returns logical (pcContext as char) in fContextHandle.
               
/********************** Main *********************************************/  
/* Keep this in one place. Used for both incoming and return */
PARAMETER_DELIMITER = _designrequest:DELIMITER.

/* _server.p publishes OEIDE_ + servername to find services started by ade */
subscribe procedure this-procedure to "OEIDE_UIB" anywhere run-procedure "thisProcedure":U. 


/* **********************  Internal Procedures  *********************** */
{adecomm/_adetool.i} /* ADEpersistent */ 

 
procedure setHandles :
    define input parameter pcNames   as char   no-undo extent.
    define input parameter pcHandles as handle no-undo extent.
    define variable i as integer no-undo.

    do i = 1 to extent(pcNames):
        case pcNames[i]:
            when "UIB" then fUIB = pcHandles[i]. 
            when "Cut" then fCut = pcHandles[i]. 
            when "Copy" then fCopy = pcHandles[i]. 
            when "Delete" then fDelete = pcHandles[i]. 
            when "Paste" then fPaste = pcHandles[i]. 
            when "Duplicate" then fDuplicate = pcHandles[i].                  
            when "Undo" then fUndo = pcHandles[i]. 
            when "Save" then fSave = pcHandles[i].
            when "Align" then fALign = pcHandles[i]. 
            when "AlternateLayout" then fAlternateLayout = pcHandles[i]. 
            when "CustomLayout" then fCustomLayout = pcHandles[i]. 
            when "CustomizationPriority" then fCustomizationPriority = pcHandles[i]. 
            when "TabOrder" then fTabOrder = pcHandles[i]. 
            when "Window" then fWindowHandle = pcHandles[i].
            when "OpenAssociateProcedure" then fOpenAssociateProcedure =  pcHandles[i].
            when "SaveDynamicAsStatic" then fSaveDynamicAsStatic =  pcHandles[i].
            when "SaveStaticAsDynamic" then fSaveStaticAsDynamic = pcHandles[i].
            when "RegisterinRepository" then fRegisterinRepository = pcHandles[i].
            when "DynamicObjectGenerator" then fDynamicObjectGenerator = pcHandles[i].
            
            otherwise do transaction:
                if pcNames[i] <> "" then 
                do:
                   create ttHandle.
                   assign ttHandle.name = pcNames[i] 
                          ttHandle.hdl  = pcHandles[i].
                end.          
            end.    
        end.
    end.     
end procedure.

/** return size and title to the embedding dialog */
procedure getCurrentDialogInfo:
    define input parameter pcHwnd as char no-undo.
    define variable cReturn as character no-undo.
    define variable dialogService as adeuib.idialogservice no-undo.
    dialogService = cast(getObject(int64(pcHwnd)),adeuib.idialogservice). 
    if not valid-object(dialogService) then
    do:
        return "ERROR:NoDialogAvail":U.  
    end.
    return 
       quoter(dialogService:title) + PARAMETER_DELIMITER +
       quoter(dialogService:WidthPixels) + PARAMETER_DELIMITER +
       quoter(dialogService:HeightPixels). 
    
end procedure.    


procedure getActionStates:
    define input  parameter pcNameList as char no-undo.
    pcNameList = entry(2,pcNameList,PARAMETER_DELIMITER).
    define variable pcEnabled as char no-undo.
    define variable widgetname as character no-undo.
    define variable i as integer no-undo.
    define variable ActionRecord     as logical no-undo.
    define variable ObjectCanConvert as integer no-undo.
    
    do i = 1 to num-entries(pcNameList):
        widgetname = entry(i,pcNameList).
        case widgetName:
            when "Cut":U then pcEnabled = pcEnabled + string(int(fCut:sensitive)). 
            when "Copy":U then pcEnabled = pcEnabled + string(int(fCopy:sensitive)).
            when "Paste":U then pcEnabled = pcEnabled + string(int(fPaste:sensitive)).
            when "Duplicate":U then pcEnabled = pcEnabled 
                             + (if not valid-handle(fDuplicate) then "0":U else string(int(fDuplicate:sensitive))).      
            when "Delete":U then pcEnabled = pcEnabled       
                             + (if not valid-handle(fDelete) then "0":U else string(int(fDelete:sensitive))).      
            when "Undo":U then
            do: 
                run canundocurrentwindow in fuib(output ActionRecord).
               
                if not ActionRecord then 
                  pcEnabled =  pcEnabled + "0":U. 
                else
                  pcEnabled = pcEnabled       
                             + (if not valid-handle(fUndo) then "0":U else string(int(fUndo:sensitive))).
            end.           
            /*  align covers all align actions and SendToBack and BringToFront for editor, 
                outline view asks specificcally for SendToBack and BringToFront        */
            when "Align":U or when "SendToBack" or when "BringToFront" then pcEnabled = pcEnabled       
                             + (if not valid-handle(fALign) then "0":U else string(int(fAlign:sensitive))).      
            when "AlternateLayout":U then pcEnabled = pcEnabled       
                             + (if not valid-handle(fAlternateLayout) then "0":U else string(int(fAlternateLayout:sensitive))). 
            when "CustomLayout":U then pcEnabled = pcEnabled       
                             + (if not valid-handle(fCustomLayout) then "0":U else string(int(fCustomLayout:sensitive))). 
            when "CustomizationPriority":U then pcEnabled = pcEnabled       
                             + (if not valid-handle(fCustomizationPriority) then "0":U else string(int(fCustomizationPriority:sensitive))). 
            when "TabOrder":U then pcEnabled = pcEnabled       
                             + (if not valid-handle(fTabOrder) then "0":U else string(int(fAlign:sensitive))).
            when "OpenAssociateProcedure":U then pcEnabled = pcEnabled
                             + (if not valid-handle(fOpenAssociateProcedure) then "0":U else string(int(fOpenAssociateProcedure:sensitive))).
            when "SaveDynamicAsStatic":U then 
            do:
                
                run  CanConvertFormToDynamic in fuib(output ObjectCanConvert).
                pcEnabled = pcEnabled
                             + (if ObjectCanConvert = 2 then "1":U else "0").
            end.                 
            when "SaveStaticAsDynamic":U then 
            do:
                run  CanConvertFormToDynamic in fuib(output ObjectCanConvert).                
                pcEnabled = pcEnabled
                             + (if ObjectCanConvert = 1 then "1":U else "0").
            end.    
            when "RegisterinRepository":U then pcEnabled = pcEnabled
                             + (if not valid-handle(fRegisterinRepository) then "0":U else string(int(fRegisterinRepository:sensitive))).
            
            when "DynamicObjectGenerator":U then pcEnabled = pcEnabled 
                             + (if not valid-handle(fDynamicObjectGenerator) then "0":U else string(int(fDynamicObjectGenerator:sensitive))). 
         
                                                 
            otherwise do:
                /* all align_ are sensitive if align is (SendToBack and BringToFront are already handled
                 above  (should really have lookup of list to be safe and not rely on this naming convention) */
                if widgetName begins "Align_":U then pcEnabled = pcEnabled       
                             + (if not valid-handle(fALign) then "0":U else string(int(fAlign:sensitive))).      
                else 
                do: /* called from menu drop down so add variables and don't rely on this 
                       for common stuff */
                         
                    find ttHandle where ttHandle.name = widgetName no-error.
                    if avail ttHandle then 
                        pcEnabled = pcEnabled + string(int(ttHandle.hdl:sensitive)). 
                    else   
                        pcEnabled = pcEnabled + "0":U. 
                end.      
            end.                
        end.
    end.     
    return pcEnabled.
end procedure.

procedure alternateLayout:
    define input  parameter pcFile as char no-undo.
    define variable pid as int64 no-undo.
    assign pid = int64(entry(2,pcFile,PARAMETER_DELIMITER))
           pcFile = entry(1,pcFile,PARAMETER_DELIMITER).
    setOpenDialogHwnd(pid).
/*    apply "choose":U to fAlternateLayout.*/
     
    run morph_layout in fUIB.
    
    return "OK":U. 
    finally:
        removeHwnd(pid).          
    end finally.
   
end.    
 
/* same procedure as alternateLayout, only called for dynamic objects, 
   It starts a window, but it has modal behavior in standalone in that it hides eall desing objects
    and uibmain goes in wait-for  */
procedure customLayout:
    define input  parameter pcFile as char no-undo.
    define variable pid as int64 no-undo.
    assign pid = int64(entry(2,pcFile,PARAMETER_DELIMITER))
           pcFile = entry(1,pcFile,PARAMETER_DELIMITER).
    
    setOpenDialogHwnd(pid).
  
    run morph_layout in fUIB. 
   
    return "OK":U. 
    finally:
        removeHwnd(pid).
    end finally.
end.    

procedure customizationPriority:
    define input  parameter pcFile as char no-undo.
    define variable pid as int64 no-undo.
    assign pid = int64(entry(2,pcFile,PARAMETER_DELIMITER))
           pcFile = entry(1,pcFile,PARAMETER_DELIMITER).
    
    setOpenDialogHwnd(pid).
  
    run Change_Customization_Parameters in fUIB. 
   
    return "OK":U. 
    finally:
        removeHwnd(pid).
    end finally.
end.  

procedure alignColon:
    define input  parameter pcFile as char no-undo.
    run adeuib/_align.p ("COLON",?).     
end.

procedure alignLeft:
    define input  parameter pcFile as char no-undo.
    run adeuib/_align.p ("LEFT",?).     
end.

procedure alignRight:
    define input  parameter pcFile as char no-undo.
    run adeuib/_align.p ("RIGHT",?).     
end.

procedure alignHorizontal:
    define input  parameter pcFile as char no-undo.
    run adeuib/_align.p ("CENTER",?).     
end.

procedure alignVertical:
    define input  parameter pcFile as char no-undo.
    run adeuib/_align.p (?,"CENTER").     
end.

procedure alignTop:
    define input  parameter pcFile as char no-undo.
    run adeuib/_align.p (?,"TOP").     
end.

procedure alignBottom:
    define input  parameter pcFile as char no-undo.
    run adeuib/_align.p (?,"BOTTOM").     
end.
/*                                                                    */
/*procedure align:                                                    */
/*    define input  parameter pcFile as char no-undo.                  */
/*                                                                    */
/*    define variable cHorizontal as character no-undo.               */
/*    define variable cVertical   as character no-undo.               */
/*    assign                                                          */
/*      cHorizontal = ?                                               */
/*      cVertical = ?.                                                */
/*                                                                    */
/*    case pcFile:                                                     */
/*      when "TOP":U or when "BOTTOM":U then                              */
/*          cVertical = pcFile.                                        */
/*      when "VERTICAL":U then                                          */
/*         cVertical = "CENTER":U.                                       */
/*      when "HORIZONTAL":U then                                        */
/*         cHorizontal = "CENTER":U.                                     */
/*      otherwise /*when "COLON":U or when "LEFT":U or when "RIGHT":U then*/*/
/*         cHorizontal = pcFile.                                       */
/*    end case.                                                       */
/*    run adeuib/_align.p (cHorizontal,cVertical).                    */
/*end.                                                                */
 
procedure centerHorizontal:
    define input  parameter pcFile as char no-undo.
    run Center-l-to-r in fUIB.
    return.
end.    

procedure centerVertical:
    define input  parameter pcFile as char no-undo.
    run Center-t-to-b in fUIB.
    return.
end.    

procedure equalSpacingHorizontal:
    define input  parameter pcFile as char no-undo.
    run Even-l-to-r in fUIB.
    return.
end.    

procedure equalSpacingVertical:
    define input  parameter pcFile as char no-undo.
    run Even-t-to-b in fUIB.   
    return.
end.    

procedure sendToBack:
    define input  parameter pcFile as char no-undo.
     run movetobottom in fUIB.
    return.
end.    

procedure bringToFront:
    define input  parameter pcFile as char no-undo.
    run movetotop in fUIB.
    return.
end.    

procedure exportFile:
    define input  parameter pcFile as char no-undo.
    define variable iHand as int64 no-undo.
    iHand = int64(entry(2,pcFile,PARAMETER_DELIMITER)).
    setOpenDialogHwnd(iHand).
    run do_export_file in fUIB.
    return "OK":U. 
    finally:
        removeHwnd(iHand).          
    end finally.  
end. 

procedure exportPalette:
    define input  parameter pcInfo as char no-undo.
    define variable cDir as character no-undo.
    define variable cPalette as character no-undo.
    define variable cCustom as character no-undo.
    assign 
      cDir = entry(1,pcInfo,PARAMETER_DELIMITER)
      cPalette = entry(2,pcInfo,PARAMETER_DELIMITER)
      cCustom = entry(3,pcInfo,PARAMETER_DELIMITER).
        
    run adeuib/_oeidepalette.p(cDir,cPalette,cCustom).
    
    return "OK":U. 
end. 

procedure exportWidgets:
    define input  parameter pcInfo as char no-undo.
    define variable cEditFile as character no-undo.
    define variable cDir as character no-undo.
    define variable cFname as character no-undo.
    define variable ihwnd as int64 no-undo.
    define variable hwin as handle no-undo.
    
    cEditFile =  entry(1,pcInfo,PARAMETER_DELIMITER).
    cDir = entry(2,pcInfo,PARAMETER_DELIMITER).
    cFname = entry(3,pcInfo,PARAMETER_DELIMITER).        
    
    ihwnd = getDesignHwnd(cEditFile).
    hwin = getDesignWindow(ihwnd).    
    run ExportCurrentWidgetTree in fuib(hwin, cDir,cFname ).
   
    return "OK":U. 
end. 



procedure importFile:
    define input  parameter pcFile as char no-undo.
    define variable iHand as int64 no-undo.
    iHand = int64(entry(2,pcFile,PARAMETER_DELIMITER)).
    setOpenDialogHwnd(iHand).
    run do_import_file in fUIB.
    return "OK":U. 
    finally:
        removeHwnd(iHand).          
    end finally.   

end. 

procedure gotoPage:
    define input  parameter pcFile as char no-undo.
    define variable iHand as int64 no-undo.
    iHand = int64(entry(2,pcFile,PARAMETER_DELIMITER)).
    setOpenDialogHwnd(iHand).
    run do_goto_page in fUIB.
    return "OK":U. 
    finally:
        removeHwnd(iHand).          
    end finally.   
end. 

procedure getPageNum: 
    define input  parameter pcFile as char no-undo.
    define variable epageNumber as integer no-undo.
    run getCurrentPageNo in fUIB(output epageNumber).
    if epageNumber = ? then epageNumber = -1.
    return string(epageNumber).
end procedure.

procedure setPageNum:
    define input parameter pcFile as char no-undo. 
    define variable iPage as int no-undo.
    assign ipage  = integer(entry(2,pcFile,PARAMETER_DELIMITER))
           pcFile = entry(1,pcFile,PARAMETER_DELIMITER). 
           
    run setPage in fUIB (ipage).
end procedure. 

procedure tabOrder:
    define input parameter pcFile as char no-undo.
    define variable iHand as int64 no-undo.
    iHand = int64(entry(2,pcFile,PARAMETER_DELIMITER)).
    
    setOpenDialogHwnd(iHand).
 
    run do_tab_edit in fUIB.
    return "OK":U. 
    finally:
        removeHwnd(iHand).          
    end finally.
end. 

procedure OpenAssociateProcedure:
    define input  parameter pcFile as char no-undo.
    run OpenAssociatedProcedure in fuib.
    return.
 end.    

    
procedure undo:
    define input  parameter pcFile as char no-undo.
    apply "choose":U to fUndo.
    return.
end.    

procedure delete:
    define input  parameter pcFile as char no-undo.
    apply "choose":U to fDelete.
    return.
end.    

procedure cut:
    define input  parameter pcFile as char no-undo.
    apply "choose":U to fCut.
    return.
end.    

procedure save:
     define input  parameter pcFileRequest as char no-undo.     
     define variable saveobj as irequest  no-undo.
     saveobj = new _saverequest(pcFileRequest).
     return RequestManager:Execute(saveobj).
end.

procedure saveAs:
     define input  parameter pcFileRequest as char no-undo.     
     define variable saveobj as idesignrequest no-undo.
     saveobj = new _saveasrequest(pcFileRequest ).
     return RequestManager:Execute(saveobj).
end.

procedure saveAsInRepository:
     define input  parameter pcFileRequest as char no-undo.     
     define variable saveobj as idesignrequest no-undo.
     saveobj = new _saveasreposrequest(pcFileRequest).
     return RequestManager:Execute(saveobj).
end.

 /** save as static object for dynamics */
procedure SaveDynamicAsStatic: 
     define input  parameter pcFileRequest as char no-undo.     
     define variable saveobj as idesignrequest no-undo.
     saveobj = new _saveasreposrequest(pcFileRequest,"Static").
     return RequestManager:Execute(saveobj).
end procedure.

/** save as dynamic object for dynamics */
procedure SaveStaticAsDynamic: 
     define input  parameter pcFileRequest as char no-undo.     
     define variable saveobj as idesignrequest no-undo.
     saveobj = new _saveasreposrequest(pcFileRequest,"Dynamic").
     return RequestManager:Execute(saveobj).
end procedure.

procedure RegisterInRepository:
    define input  parameter pcFileRequest as char no-undo.     
    define variable saveobj as idesignrequest no-undo.
    saveobj = new _registerinrepository(pcFileRequest).
    return RequestManager:Execute(saveobj).
end. 

procedure CheckSyntax:
    define input  parameter pcFile as char no-undo.
    define variable iOffset as integer no-undo. 
    run do_check_syntax  in fUIB.
    if return-value > "" then 
        return return-value.
    return "OK".
end.    

procedure copy:
    define input  parameter pcFile as char no-undo.
    apply "choose":U to fCopy.
    return.
end.    

procedure paste:
    define input  parameter pcFile as char no-undo.
    apply "choose":U to fPaste.
    return.
end.    

procedure duplicate:
    define input  parameter pcFile as char no-undo.
    apply "choose":U to fDuplicate.
    return.
end.    

/*  No dialog handle passed CURRENTLY, since uibmain currently calls chooseDataObject 
    in  _tv-proc, which calls runChildDialog in PDS again.  
    The reason is that we want the shared avm info passed to runchildDialog from PDS */
procedure chooseSmartDataObject:
    define input  parameter pcFile as char no-undo.
    run chooseSmartDataObject in fUib.
    return "OK".
end.   
 
procedure chooseDataSource:
    define input  parameter pcFile as char no-undo.
    define variable ihwnd  as int64 no-undo.
    ihwnd = int64(entry(2,pcFile,PARAMETER_DELIMITER)).
    setOpenDialogHwnd(ihwnd).
  
    run chooseDataSource in fUib.
    return "OK".
    finally:
        removeHwnd(ihwnd).    
    end.
end.    

procedure htmlAutomapAll:
    define input  parameter pcFile as char no-undo.
    define variable hwin as handle no-undo.
    define variable ihwnd as int64 no-undo.
    ihwnd = getDesignHwnd(pcFile).
    hwin = getDesignWindow(ihwnd).    
    run htmlAutomapAll in fUib (hwin).
end.    

procedure htmlUnmapAll:
    define input  parameter pcFile as char no-undo.
    define variable hwin as handle no-undo.
    define variable ihwnd as int64 no-undo.
    ihwnd = getDesignHwnd(pcFile).
    hwin = getDesignWindow(ihwnd).    
    run htmlUnmapAll in fUib (hwin).
end.    

procedure htmlMapField:
    define input  parameter pcFile as char no-undo.
/*    define variable ihwnd  as int64 no-undo.           */
/*    ihwnd = int64(entry(2,pcFile,PARAMETER_DELIMITER)).*/
/*    setOpenDialogHwnd(ihwnd).                          */
    define variable hwin as handle no-undo.
    define variable ihwnd as int64 no-undo.
    ihwnd = getDesignHwnd(pcFile).
    hwin = getDesignWindow(ihwnd).  
    run htmlMapField in fUib (hwin).
    return "OK".
/*    finally:              */
/*        removeHwnd(ihwnd).*/
/*    end.                  */
end.    

procedure htmlUnmapField:
    define input  parameter pcFile as char no-undo.
    define variable hwin as handle no-undo.
    define variable ihwnd as int64 no-undo.
    ihwnd = getDesignHwnd(pcFile).
    hwin = getDesignWindow(ihwnd).  
    run htmlUnmapField in fUib(hwin).
end.    

procedure editMaster:
    define input  parameter pcFile as char no-undo.
    run editMaster in fUib.
    return "OK".
end.   

procedure smartInstanceProperties:
    define input  parameter pcFile as char no-undo.
    run smartInstanceProperties in fUib.
    return "OK".
end.  

procedure smartInfo:
    define input  parameter pcFile as char no-undo.
    run choose_smartInfo in fUib.
    return "OK".
end.  

procedure closeWindow:
    define input  parameter pcFile as char no-undo.
    define variable cfile as character no-undo.
    define variable hwin  as handle no-undo. 
    define variable ihwnd as int64 no-undo.
    cfile = entry(1,pcfile,PARAMETER_DELIMITER).
    ihwnd = int64(entry(2,pcfile,PARAMETER_DELIMITER)).
    
    /* This should not happen anymore.   
       The designerid was 0 previously since the widget was already disposed when it was called from
       editor dispose. This was too late (OE00222478) and it is now called before the 
       Eclipse handle is disposed. It is a cheap check so we keep it (for now..). 
       if this ever should be called after disposal we would want to delete it  */
    if ihwnd = 0 then
        ihwnd = getDesignHwnd(cfile).
    hwin = getDesignWindow(ihwnd).
    if valid-handle(hwin) then
    do:
        run setSendFocustoUI in fUIB (no).
        run wind-close in fUIB (hwin).   
    end.
    return "OK".
    finally:
        run setSendFocustoUI in fUIB (yes).
        removeHwnd(ihwnd).    
    end.
end.

procedure openDesignWindow:
/*------------------------------------------------------------------------------
        Purpose:  opens a static window (from repository if exists and dynamics is running) 
                  embedded in the passed eclipse control handle (uses ad id here)                                                                   
        Notes:  The only difference (now.. ) from openDynamicsDesignWindow is that this 
                expects full path file name                                                                      
------------------------------------------------------------------------------*/
    define input parameter cCmd as character no-undo.
 
    define variable iHwnd as int64 no-undo.
    define variable cFile as char    no-undo.
    define variable lInRepos as logical no-undo.
    define variable cLinkedFile as character no-undo.
    define variable isTTY       as logical no-undo.
    define variable ipageNumber as integer no-undo.
/*    define variable lNative as logical no-undo. */
/*    define variable lDynamic as logical no-undo.*/
         
    iHwnd = int64(trim(entry(num-entries(cCmd,PARAMETER_DELIMITER),cCmd,PARAMETER_DELIMITER))) no-error.
    cFile = entry(1,cCmd,PARAMETER_DELIMITER).
    if cfile > "":U then
    do:
        cfile = replace(cfile, "~\":U, "/":U).
        /* opens from dynamics if dynamics is enabled */
        run OpenRyObject in fUib (cFile, output linRepos). 
        setDesignHwnd(cFile,iHwnd).  
        run setSendFocustoUI in fUIB (no).
        run adeuib/_open-w.p (cfile, "", "IDE-WINDOW":U).
        run setSendFocustoUI in fUIB (yes).
        if return-value <> "_abort":U then
        do on error undo, throw :
            cLinkedFile = createLinkedFile(iHwnd,cFile).
            run isTTY in fUib(output isTTY).
            run getCurrentPageNo in fUIB(output ipageNumber).
            return (STATIC_OBJ) 
                 /* should always be static here.. 
                   save as dynamic after stored to history will likely not be found with full path? */ 
                    + PARAMETER_DELIMITER 
                    + (if linRepos then REPOS_OBJ else "") 
                    + PARAMETER_DELIMITER
                    
                   /*   + cFile no point in returning this.. ? */
                    + PARAMETER_DELIMITER 
                    + cLinkedFile
                    + PARAMETER_DELIMITER
                    + (if isTTY then TTY_OBJ else "")
                    + PARAMETER_DELIMITER
                    + (if ipageNumber = ? then "-1" else string(ipageNumber)).
             
            /* editor errors will be shown as overlay in canvas */
            catch e as Progress.Lang.Error :
                return ERROR_OBJ + PARAMETER_DELIMITER + e:GetMessage(1).   
            end catch.
    
        end.
        else
            return ".":U.  
    
    end.
    else 
        return error ERROR_OBJ + PARAMETER_DELIMITER + "No file name specified for open design window.". 
      
end procedure.

procedure openDynamicsDesignWindow:
/*------------------------------------------------------------------------------
      Purpose:  opens a dynamic window from repository if exists and dynamics is running 
                embedded in the passed eclipse control handle (uses ad id here)                                                                   
        Notes:  The only difference (now.. ) from openDesignWindow is that this 
                expects relative file name                                                                            
------------------------------------------------------------------------------*/
    define input parameter cCmd as character no-undo.
 
    define variable iHwnd as int64 no-undo.
    define variable cFile as char    no-undo.
    define variable lAvail as logical no-undo.    
    define variable cLinkedFile as character no-undo. 
    define variable hRyobj  as handle no-undo.
    define variable lNative as logical no-undo.
    define variable lDynamic as logical no-undo. 
    define variable isTTY    as logical no-undo.        
    iHwnd = int64(trim(entry(num-entries(cCmd,PARAMETER_DELIMITER),cCmd,PARAMETER_DELIMITER))) no-error.
    cFile = entry(1,cCmd,PARAMETER_DELIMITER).
    if cfile > "":U then
    do:
        cfile = replace(cfile, "~\":U, "/":u).
        run OpenRyObject in fUib (cfile,output lavail).
         
        if not lavail then
        do:
            return ERROR_OBJ + PARAMETER_DELIMITER + "Object " + cfile + " not found in Repository.".       
        end. 
        
        setDesignHwnd(cFile,iHwnd).  
        run setSendFocustoUI in fUIB (no).
        run adeuib/_open-w.p (cfile, "", "IDE-WINDOW":U).
        run setSendFocustoUI in fUIB (yes).
        
        if return-value <> "_ABORT":U then
        do on error undo, throw :
            cLinkedFile = createLinkedFile(iHwnd,cFile).
            run isTTY in fUib(output isTTY).
            /* check if dynamic (dynamics object may be static)  */
            run isCurrentWindowDynamic in fUib (output lDynamic,output lNative).
            /* could have been saved as static if this is called from editor history...?? */   
            return (if lDynamic then DYNAMIC_OBJ else STATIC_OBJ) /* should always be static here.. */ 
                    + PARAMETER_DELIMITER 
                    + (if lDynamic and lNative then NATIVE_OBJ else if lDynamic = false then REPOS_OBJ else "") 
                    + PARAMETER_DELIMITER 
                    
                   /*   + cFile no point in returning this.. ? */
                    + PARAMETER_DELIMITER 
                    + cLinkedFile
                    + PARAMETER_DELIMITER
                    +  (if isTTY then TTY_OBJ else "") 
                    + PARAMETER_DELIMITER
                    + "-1". /* dynamic objects are not page target */ 
          /* editor errors will be shown as overlay in canvas */
            catch e as Progress.Lang.Error :
                return ERROR_OBJ + PARAMETER_DELIMITER + e:GetMessage(1). 
            end catch.
        end.
        else 
            return ".":U. /* signal close */
    end.
    else 
        return error "No file name specified for open design window.". 
      
end procedure.

/** open object for dynamics */
procedure openObject: 
    define input parameter pcFile as char no-undo.
    define variable iHand as int64 no-undo.
/*    iHand = int(entry(1,pcFile,PARAMETER_DELIMITER)).*/
    iHand = int64(pcfile).
    
    setOpenDialogHwnd(iHand).
    
    run ide_choose_object_open in fUIB.
    return "OK":U. 
    finally:
        removeHwnd(iHand).          
    end finally.
       
end procedure.

procedure DynamicAdministration:
    define input  parameter pcFile as char no-undo.
    run ry/prc/rycsolnchp.p (input "afallmencw":U , input yes , input yes ).
    return.
end.
   
procedure DynamicDevelopment:
    define input  parameter pcFile as char no-undo.
    run ry/prc/rycsolnchp.p (input "rywizmencw":U , input yes , input yes ).
    return.
end.

procedure DynamicObjectGenerator:
    define input  parameter pcFile as char no-undo.
    run ry/prc/rycsolnchp.p (input "afgenobjsw":U , input yes , input yes ).
    return.
end.

procedure DynamicContainerBuilder:
    define input  parameter pcFile as char no-undo.
    run ry/prc/rycsolnchp.p (input "rycntpshtw":U , input yes , input yes ).
    return.
end.

   
procedure DynamicToolbarMenuDesigner:
    define input  parameter pcFile as char no-undo.
    run af/cod2/afmenumaintw.w.
    return.
end.

   
procedure DynamicClassMaintenance:
    define input  parameter pcFile as char no-undo.
    run ry/prc/rycsolnchp.p (input "gscottreew":U , input yes , input yes ).
    return.
end.

procedure DynamicClearRepositoryCache:
    define input  parameter pcFile as char no-undo.
    run ry/prc/ryclrcachp.p.
    return "OK".
end.

procedure DynamicRunLauncher:
    define input  parameter pcFile as char no-undo.
    run ry/uib/rycsolnchw.w PERSISTENT.
    return "OK".
end.

procedure DynamicRepositoryMaintenance:
    define input  parameter pcFile as char no-undo.
    run ry/prc/rycsolnchp.p (input "rycsotreew":U , input yes , input yes ).
    return.
end.

  
procedure DynamicStartDatafieldMaintenance:
    define input  parameter pcFile as char no-undo.
    run ry/prc/rycsolnchp.p (input "rysdfmaintw":U , input yes , input yes ).
    return.
end.
  
procedure DynamicSetSiteNumber:
    define input  parameter pcFile as char no-undo.
    run ry/prc/rycsolnchp.p (input "gsmsisetnw":U , input yes , input yes ).
    return.
end.

 
procedure DynamicTreenoDecontrol:
    define input  parameter pcFile as char no-undo.
    run ry/prc/rycsolnchp.p (input "gsmndtreew":U , input yes , input yes ).
    return.
end.

procedure DynamicTreeviewBuilder:
    define input  parameter pcFile as char no-undo.
    run ry/prc/rycsolnchp.p (input "rytreemntw":U , input yes , input yes ).
    return.
end.
   
procedure closeAppbuilder:
    define input  parameter pcParam as char no-undo.
    apply "window-closed":U to fWindowHandle.
end.

procedure cancelCurrentDialog:
    define input parameter pcHwnd as char no-undo.
    define variable dialogService as adeuib.idialogservice no-undo.
    
    dialogService = cast(getObject(int64(pcHwnd)),adeuib.idialogservice). 
    if not valid-object(dialogService) then
        return "ERROR:NoDialogAvail":U.  
    dialogService:Cancel().    
    
    return "OK" .
end.

procedure leaveWindow:
    define input  parameter pcFile as char no-undo.
    run apply_leave in fUIB.
end.
 
procedure enterWindow:
    define input parameter pcFile as char no-undo.
    define variable ihwnd as int64 no-undo.
    define variable hwin as handle no-undo.
    ihwnd = getDesignHwnd(pcfile).
    hwin = getDesignWindow(ihwnd).
    run WinIDEChoose in fUIB(hwin).
end.

procedure editCustomFiles:
    define input parameter pcFile as char no-undo.
    define variable iHand as int64 no-undo.
    iHand = int64(entry(2,pcFile,PARAMETER_DELIMITER)).
    setOpenDialogHwnd(iHand).
    /* due to this being fired from right click in the ide the pointer may not have been reset */
    run choose-pointer in fUIB.
    
    run get_custom_widget_defs in fUIB.
    return "OK":U. 
    finally:
        removeHwnd(iHand).          
    end finally.
   
end. 

procedure editCode:
    define input parameter pcFile as char no-undo.
    run call_sew in fUIB("SE_OEOPEN").
end. 

procedure getOCXEvents:
    define input parameter pcParam  as char no-undo.
    define output parameter response as longchar  no-undo.
    define variable cfile as character no-undo.
    define variable cName as character no-undo.
    define variable ihwnd  as int64 no-undo.
    define variable hWin   as handle no-undo.
    define variable cType  as character no-undo.
    define variable ipos as integer no-undo.
    cFile = entry(1,pcParam,PARAMETER_DELIMITER).
    cName = entry(2,pcParam,PARAMETER_DELIMITER).
  
    cfile = replace(cfile, "~\":U, "/":U).    
    ihwnd = getDesignHwnd(cfile).
    hwin = getDesignWindow(ihwnd).
    run ide_get_ocx_events in fUIB (cfile,cName,hwin,output response).
    /* add different delimiter between type and events */
   ipos = index(response,",").
   if ipos > 0 then
       overlay(response,ipos,1) = PARAMETER_DELIMITER.
end procedure.    

procedure getOverrides:
    define input parameter pcParam  as char no-undo.
    define output parameter response as longchar  no-undo.
    define variable ctype as character no-undo.
    define variable cFile as character no-undo. 
    define variable ihwnd as int64 no-undo. 
    define variable hwin as handle no-undo. 
    cType = entry(1,pcParam,PARAMETER_DELIMITER).
    cFile = entry(2,pcParam,PARAMETER_DELIMITER).
    cfile = replace(cfile, "~\":U, "/":U).    
    ihwnd = getDesignHwnd(cfile).
    hwin = getDesignWindow(ihwnd).
    run ide_get_overrides in fUIB (ctype,cfile,hwin,output response).
    
end procedure.

procedure getOverrideBody:
    define input parameter pcParam  as char no-undo.
    define output parameter response as longchar  no-undo.
    define variable ctype as character no-undo.
    define variable cFile as character no-undo. 
    define variable cName as character no-undo.
    define variable ihwnd as int64 no-undo. 
    define variable hwin as handle no-undo. 
    cType = entry(1,pcParam,PARAMETER_DELIMITER).
    cFile = entry(2,pcParam,PARAMETER_DELIMITER).
    cName = entry(3,pcParam,PARAMETER_DELIMITER).
    cfile = replace(cfile, "~\":U, "/":U).    
    ihwnd = getDesignHwnd(cfile).
    hwin = getDesignWindow(ihwnd).
    run ide_get_override_body in fUIB (ctype,cfile,hwin,cName,output response).
    
end procedure.

procedure InsertTrigger:
    define input parameter pcParam  as char no-undo.
    define variable cFile   as character no-undo. 
    define variable ctype   as character no-undo.
    define variable cName   as character no-undo.
    define variable cEvent  as character no-undo.
    define variable cParent as character no-undo.
    define variable ihwnd as int64 no-undo. 
    define variable hwin  as handle no-undo. 
    define variable lok   as logical no-undo.
    define variable cLinkedFile as character no-undo.
    
    assign 
        cFile  = entry(1,pcParam,PARAMETER_DELIMITER)
        cfile = replace(cfile, "~\":U, "/":U)    
        cType  = entry(2,pcParam,PARAMETER_DELIMITER)
        cName  = entry(3,pcParam,PARAMETER_DELIMITER)
        cEvent = entry(4,pcParam,PARAMETER_DELIMITER).
        cParent =  if(num-entries(pcParam,PARAMETER_DELIMITER) > 4 ) 
                   then entry(5,pcParam,PARAMETER_DELIMITER)
                   else "".
    
    ihwnd = getDesignHwnd(cfile).
    hwin = getDesignWindow(ihwnd).
    /* hwin = ? means the file is not opened in AppBuilder. 
       create a linked file and pass to uib for the new trigger to be saved  */
    if hwin = ? then
    do: 
        run adecomm/_tmpfile.p("newtrigger",".tmp",output cLinkedFile).
    end.
   
    run ide_insert_trigger in fUIB (cfile,cLinkedFile,hwin,ctype,cName,cEvent,cParent,output lok).
    
    if lok then 
    do: 
        /* if no AppBuilder return the file name to load text editor from */
        if cLinkedFile > "" then 
            return "FILE:" + cLinkedFile.
        
        return "OK".
    end.
    else /* use period as cancel (blank may pick up wrong error from error-status) */
        return ".".
    /* return unexpected errors with ERROR:  This will be shown as reason for add trigger failed  */    
    catch e1 as Progress.Lang.AppError :
        if e1:ReturnValue <> ? and e1:ReturnValue <> "" then 
    	    return "ERROR:" +  e1:ReturnValue.
    	else  
            return "ERROR:" + e1:GetMessage(1). 
    end catch.        
    catch e2 as Progress.Lang.Error :
    	return "ERROR:" + e2:GetMessage(1).	
    end catch.
    
end procedure.

/* not in use - calls correct dialog, but needs embedding logic to work properly */ 
procedure AddFunction:
    define input parameter pcFile as char no-undo.
    run do_insert_function in fUIB.
end procedure.

/* not in use - calls correct dialog, but needs embedding logic to work properly */ 
procedure AddProcedure:
    define input parameter pcFile as char no-undo.
    run do_insert_procedure in fUIB.
end procedure.

/* not in use - calls correct dialog, but needs embedding logic to work properly */ 
procedure AddTrigger:
    define input parameter pcFile as char no-undo.
    run do_insert_trigger in fUIB.
end procedure.

procedure thisProcedure :
    define output parameter phHandle as handle no-undo.
    phHandle = this-procedure.
end procedure.

procedure openProcedureSettings:
    define input parameter pcFile as char no-undo.
    define variable iHand as int64 no-undo.
    iHand = int64(entry(2,pcFile,PARAMETER_DELIMITER)).

    setOpenDialogHwnd(iHand).
    run choose_proc_settings in fUIB.
    return "OK":U.
    finally:
        removeHwnd(iHand).
    end finally.
end.

procedure openAppbuilderProperties: 
    define input parameter pcParam as char no-undo.
    run choose_attributes in fUIB.
end.    

procedure closeAppbuilderProperties: 
    /* not currently in use (see AppbuilderPropertiesView for current status) */
    define input parameter pcParam as char no-undo.
    run close_attributes in fUIB.
end. 
    
procedure openPropertySheet:
    define input parameter pcFile as char no-undo.
    define variable iHand as int64 no-undo.
    /* We pass the dialog handle if it is used, 
       but we do not pass it for dynamcis non-native object types, which have
       persistent property sheets like container builder  */
    if num-entries(pcFile,PARAMETER_DELIMITER) > 1 then
    do:
        iHand = int64(entry(2,pcFile,PARAMETER_DELIMITER)).
        setOpenDialogHwnd(iHand).
    end.   
    run do_choose_prop_sheet in fUIB.
    return "OK":U. 
    finally:
        if iHand <> 0 then
            removeHwnd(iHand).
    end finally.
   
end.

 
procedure openNewFile:
/*------------------------------------------------------------------------------
        Purpose:  opens and saves the new file                                                                    
        Notes: NO CHECK IF FILE EXISTS - callers responsibility     
        Parameter - delimited list  
             Template   = full path name of template
             NewFile    = new file name (project relative path) or blank if name comes 
                          from finish wizard
             WizHwnd    = parent of wizard (0 if no wizard)
             EditorHwnd = parent of design (0 if received from finish wizard)                                                     
------------------------------------------------------------------------------*/
    define input parameter pcInfo as character no-undo.
    define variable cProjectPath  as character no-undo.
    define variable cNewFile      as character no-undo. 
    define variable cSaveFile     as character no-undo. 
    define variable cFullFileName as character no-undo. 
    define variable cTemplate     as character no-undo. 
    define variable cPaletteType  as character no-undo.
    define variable cCustom       as character no-undo.
    define variable cId           as character no-undo. 
    define variable lCancel       as logical no-undo. 
    define variable iWizHwnd      as int64 no-undo. 
    define variable iEditorHwnd   as int64 no-undo. 
    define variable lNative       as logical no-undo.
    define variable lDynamic      as logical no-undo.   
    define variable lInRepos      as logical no-undo.
    define variable cWindowtitle  as character no-undo.
    define variable cLinkedFile   as character no-undo.
    define variable isTTY         as logical no-undo.
    define variable cWizardContext as character no-undo.
    define variable ipageNumber  as integer no-undo.
    assign 
        cProjectPath = entry(1,pcInfo,PARAMETER_DELIMITER)
        cId          = entry(2,pcInfo,PARAMETER_DELIMITER)
        cTemplate    = entry(3,pcInfo,PARAMETER_DELIMITER)
        cNewFile     = entry(4,pcInfo,PARAMETER_DELIMITER)
        iWizHwnd     = int64(entry(5,pcInfo,PARAMETER_DELIMITER)) 
        iEditorHwnd  = int64(entry(6,pcInfo,PARAMETER_DELIMITER)) 
        cWizardContext = (if num-entries(pcInfo,PARAMETER_DELIMITER) >= 7 
                          then entry(7,pcInfo,PARAMETER_DELIMITER)
                          else "") 
        no-error.
    
    cProjectPath = replace(cProjectPath, "~\":U, "/":U) + "/".
    /* as of current the id is only ised for dynamics it is always passed from eclipse though */
    if num-entries(cId,":") > 1 then 
    do:
       assign 
         cCustom = entry(2,cId,":")
         cPaletteType = entry(1,cId,":"). 
        run NewRyObject in fuib(cPalettetype,cCustom,cTemplate,output lInRepos).
    end. 
     
    if iWizHwnd > 0 then 
    do:  
        setRequestContext(cWizardContext).     
        setDesignHwnd("WIZARD":U,iWizHwnd).
    end.
    
    if iEditorHwnd > 0 then 
        setDesignHwnd("NEW":U,iEditorHwnd).   
  
    run Open_Untitled in fuib(cTemplate).   
    run display_curwin in fuib.
    if return-value <> "_ABORT":U then
    do: 
       /* If _open-w started a supported wizard the file name may have changed by now. 
          FinishWizard will store this in context */ 
        cSaveFile = getNewFileName(). 
        /* @TODO check file name for unsupported wizard?   */ 
        if cSaveFile > "":U then 
        do:
            cNewFile = cSaveFile.
            clearNewFileName().
        end.
        
        /* check if dynamic (dynamics object may be static)  */
        run isCurrentWindowDynamic in fUib (output lDynamic,output lNative).         
        /* @TODO make dynamics pick up filename from Eclipse Wizard */
        
        /* if there is a dynamic prop sheet then the uib will call run dialog property sheet in PDS 
           This command will wait until the appbuilder is opened (return from here successfully)  */
        run startDynPropSheet in fuib.
        
        /* if repso this is not going to save the object so return 
           the unique untitled:n   */
        if linRepos then
        do:
            /* _wintitl.p manages untitled numbers deep down  */
            run getCurrentWindowTitle in fuib (output cWindowtitle). 
            cNewFile = trim(entry(num-entries(cWindowtitle,"-"),cWindowtitle,"-")).
            
        end.
      
        
        /** NOTE: we return with unsaved object from here if dynamics . 
           The ABLNewWindowInfo class on java has the following override to reflect 
           this behavior. 
            
            @Override
             public boolean isNew() {
               return isDynamic() || isRepositoryObject();
             }
            If we need more flexibility or change this to ssave for example static objects here, 
            which we could do just by calling save (with some struggle to get embedding working) 
            rhwn we can add NEW or SAVED as paramter and pass to Eclipse in whihc case the override
            above need to be removed and the base class changed to return yes or no from what is 
            returned here */
    
        if not lDynamic then
        do: 
            if not lInRepos then
            do:
                cFullFileName = cProjectPath + cNewFile.
                run save_new_file in fUIB (cFullFileName, output lCancel).
                /* the Java command is waiting for this to complete and will pass the 
                    returned name to the editor 
                    this also updates the filename */   
                cLinkedFile = createLinkedFile(iEditorHwnd,cFullFileName).
            end.
            else /* store the untitled:n  passed to ide */ 
                setDesignFileName(iEditorHwnd,cNewFile).
            run isTTY in fUib(output isTTY).
            run getCurrentPageNo in fUIB(output ipageNumber).
            if not lCancel then
               return STATIC_OBJ + PARAMETER_DELIMITER 
                               + (if lInRepos then REPOS_OBJ else "")
                               + PARAMETER_DELIMITER 
                               + cNewFile
                               + PARAMETER_DELIMITER 
                               + cLinkedFile
                               + PARAMETER_DELIMITER
                               +  (if isTTY then TTY_OBJ else "")
                               + PARAMETER_DELIMITER
                               + (if ipageNumber = ? then "-1" else string(ipageNumber)).
        end.
        else do:
             /* store the untitled:n and return it to ide as the name */ 
             setDesignFileName(iEditorHwnd,cNewFile).
             run isTTY in fUib(output isTTY).
             return DYNAMIC_OBJ + PARAMETER_DELIMITER 
                              + (if lNative then NATIVE_OBJ else "") 
                              + PARAMETER_DELIMITER 
                              + cNewFile
                              + PARAMETER_DELIMITER 
                              + cLinkedFile
                              + PARAMETER_DELIMITER
                              + (if isTTY then TTY_OBJ else "")
                              + PARAMETER_DELIMITER
                              + "-1". /* dynamics objects are not page target */             
        end.
    end.
    /* Signal close  - returns something that is not a valid file name. 
       Note : cannot return blank 
              The _server is using error-status and return-value and will check 
              and return these if we return blank */    
    return ".":U. 
    
end procedure.
 
procedure chooseTemplate:
    define input parameter pcparam as char no-undo.
    define variable cReturn as character no-undo.
    define variable iHand as int64 no-undo.
   
/*    iHand = int(entry(2,pcFile,PARAMETER_DELIMITER)).*/
    ihand = int64(pcparam).
    setOpenDialogHwnd(iHand).
    run ide_choose_template in fUIB(output cReturn).
    /* Signal close */
    if cReturn = "" then 
        return ".".
    return cReturn.
    catch e as Progress.Lang.Error :
    	return ".".	
    end catch.
    finally:
        removeHwnd(iHand).
    end finally.
   
end procedure.    

procedure runChooseColor:
    define input parameter pcFile as char no-undo.
    define variable iHand as int64 no-undo.
    iHand = int64(entry(2,pcFile,PARAMETER_DELIMITER)).
    
    setOpenDialogHwnd(iHand).
 
    run adeuib/_selcolr.p.
  
     if return-value = "cancel":U then
        return "CANCEL":U.  
    return "OK":U. 
    finally:
        removeHwnd(iHand).
    end finally.
   
end.

procedure runChildDialog:
    define input parameter pcRequest  as char no-undo.
    define variable iHand     as int64 no-undo.
    define variable cProjInfo as character no-undo. 
    define variable ideService as adeuib.iideeventservice no-undo.
    define variable dialogService as adeuib.idialogservice no-undo.
    
    iHand = int64(entry(1,pcRequest,PARAMETER_DELIMITER)).
    
    if num-entries(pcRequest,PARAMETER_DELIMITER) > 1 then
    do:
        cProjInfo = entry(2,pcRequest,PARAMETER_DELIMITER).    
    end.
    
    /** blank is also context */
    setRequestContext(cProjInfo).
     
    ideService = cast(getCurrentEventObject(),adeuib.iideeventservice). 
    if not valid-object(ideService) then
        return "ERROR:NoEventHandlerAvail":U.  
        
    setOpenDialogHwnd(iHand). 
    ideService:RunEvent().
    dialogService = cast(getObject(iHand),adeuib.idialogservice). 
    if not valid-object(dialogService) then
        return "ERROR:NoDialogAvail":U.  
   
    if dialogService:OK then
    do:
        if getHasNextDialog() then 
        do:
            return "CONTINUE":U.
        end.    
        if dialogService:ReturnValue > "" then
        do:
             return dialogService:ReturnValue .
        end.    
        return "OK":U. 
    end.
    else
        return ".".
    finally:
        removeHwnd(iHand).
    end finally.
     
end.
/*                                                       */
/*procedure testwin:                                     */
/*    define input  parameter hparent as integer no-undo.*/
/*    define variable h as handle no-undo.               */
/*                                                       */
/*    create window h                                    */
/*    assign three-d = true                              */
/*           height = 10                                 */
/*           width = 32                                  */
/*           message-area = false .                      */
/*                                                       */
/*    h:ide-parent-hwnd = hparent.                       */
/*    h:ide-window-type = 1.                             */
/*                                                       */
/*    define button bok label "Ok"  size 15 by 1.         */
/*    define button bcancel label "Cancel"  size 15 by 1. */
/*    define frame a                                     */
/*        bok at col 1 row 7                             */
/*        bcancel at col 16 row 7                        */
/*        with width 32 three-d no-box.                  */
/*    current-window = h.                                */
/*    enable all with frame a.                           */
/*    wait-for "choose" of bok.                          */
/*end.                                                   */
/*                                                       */
procedure runDrawBrowse:
    define input parameter pcFile as char no-undo.
    define variable iHand as int64 no-undo.
    iHand = int64(entry(2,pcFile,PARAMETER_DELIMITER)).
    setOpenDialogHwnd(iHand).
    run adeuib/_drwbrow.p.
 
    if return-value = "cancel":U then
        return "CANCEL":U. 

    return "OK":U. 
    finally:
        removeHwnd(iHand).          
    end finally.
    
end.

procedure runDrawFields:
    define input parameter pcFile as char no-undo.
    define variable iHand as int64 no-undo.
    iHand = int64(entry(2,pcFile,PARAMETER_DELIMITER)).
    
    setOpenDialogHwnd(iHand).
    run ide_draw_fields in fUIB.
    
    if return-value = "cancel":U then
        return "CANCEL":U. 
    return "OK":U. 
    
    finally:
        removeHwnd(iHand).          
    end finally.
   
end.    
    
procedure runDrawQuery:
    define input parameter pcFile as char no-undo.
    define variable iHand as int64 no-undo.
    iHand = int64(entry(2,pcFile,PARAMETER_DELIMITER)).
    
    setOpenDialogHwnd(iHand).
    run adeuib/_drwqry.p.    
  
    if return-value = "cancel":U then
        return "CANCEL":U. 
    
    return "OK":U. 
    
    finally:
        removeHwnd(iHand).          
    end finally.
    
end.

procedure runXFTRProcedure:
    define input parameter pcFile as char no-undo.
    run run_xftr_procedure_context_runner in fUIB.
end.

/** tool selected in the palette */
procedure ToolSelected:
    define input parameter pcFile as char no-undo.
    define variable cTool as character no-undo. 
    define variable cCustom as character no-undo. 
    define variable cSharedProjects as character no-undo.
    
    cTool = entry(2,pcFile,PARAMETER_DELIMITER).
    
    if(num-entries(pcFile,PARAMETER_DELIMITER)>=3) then
    do:    
        cSharedProjects = entry(3,pcFile,PARAMETER_DELIMITER). 
    end.
    if num-entries(cTool,":") > 1 then 
       assign 
         cCustom = entry(2,cTool,":")
         ctool = entry(1,cTool,":"). 
    else 
       cCustom = ?. 
    run tool_choose_with_projects in fUIB(1,ctool,ccustom,cSharedProjects).

end.

procedure textEditorSaveEvent:
    define input parameter pcParam  as char no-undo.
    define variable cFile as character no-undo. 
    define variable ihwnd as int64 no-undo. 
    define variable hwin as handle no-undo. 
    cFile = entry(1,pcParam,PARAMETER_DELIMITER).
    cfile = replace(cfile, "~\":U, "/":U).    
    ihwnd = getDesignHwnd(cfile).
    hwin = getDesignWindow(ihwnd).
    run ide_texteditor_save_event in fUIB (cfile,hwin).
    
end procedure.


procedure setContextHandle:
    define input parameter hContext as handle no-undo.
    fContextHandle = hContext.
    RequestManager = new _requestmanager(hContext,fuib).
end.   

procedure destroyObject:
    run closeAppbuilder ("").
    delete procedure this-procedure.
end.
   
procedure setIDEpreferences:
    define input parameter prefOptions as char no-undo.
    define variable hHand as handle no-undo.
    run adeuib/_oeidepref.p persistent set hHand.
    run setIDEpreferences in hHand (input prefOptions,true /* fire/propagate changes () */ ).
    if valid-handle(hHand) then
       delete object hHand no-error. 
end procedure.

procedure setIDEproperties:
   define input parameter prefOptions as char no-undo.
   define variable projName    as char no-undo.
   assign projname    = entry(1,prefOptions,PARAMETER_DELIMITER)
          prefOptions = entry(2,prefOptions,PARAMETER_DELIMITER).
   define variable iHand as handle no-undo.
    run adeuib/_oeidepref.p persistent set iHand.
    run setIDEproperties in iHand (input projName,input prefOptions).
    if valid-handle(iHand) then
       delete object iHand no-error.
end procedure.

procedure runTTYTerminalColorChooser:
    define input parameter pcolors as character no-undo.
    define variable cProject as character no-undo.
    define variable iFg as integer no-undo.
    define variable iBg as integer no-undo.
    define variable hHand as handle no-undo.
    define variable Pid   as int64 no-undo. 
    /* TODO remove project */
    assign
        pid      = int64(entry(1,pColors,PARAMETER_DELIMITER))
        cProject = entry(2,pColors,PARAMETER_DELIMITER)
        iBg      = int(entry(3,pColors,PARAMETER_DELIMITER))
        iFg      = int(entry(4,pColors,PARAMETER_DELIMITER)).
    
    setOpenDialogHwnd(pid).
  
    run adeuib/_oeidepref.p persistent set hHand.
    run runTTYTerminalColorChooser in hHand (cProject,iBg,iFg).
    return "OK":U. 
    catch e as Progress.Lang.Error :
         return ERROR_OBJ. 
    end catch.
    
    finally:
        removeHwnd(pid).    
        if valid-handle(hHand) then
           delete object hHand no-error. 
    end finally.
end procedure.

procedure RunDynamicPropertySheet:
    define input parameter pcFile as char no-undo.
    run RunDynamicPropertySheet in fUIB.
end procedure.    

procedure SelectWidgetinUI:
    define input parameter pcFile as char no-undo.
    define variable widgetName as char no-undo.
    assign widgetName = entry(2,pcFile,PARAMETER_DELIMITER)
           pcFile     = entry(1,pcFile,PARAMETER_DELIMITER).
    run selectWidgetinUI in FUIB(WidgetName). 
    return "ok".   
end procedure.

procedure RunTempdbMaintenance:
     define input parameter pcFile as char no-undo.
     run choose_tempdb_maint in FUIB.
end procedure.  

/*procedure RunAdvisor:                                                                                                                               */
/*    define input parameter pcFile as char no-undo.                                                                                                  */
/*    define variable pc_text         as char no-undo.                                                                                                */
/*    define variable pc_options      as char no-undo.                                                                                                */
/*    define variable pl_never_toggle as logical no-undo.                                                                                             */
/*    define variable pc_help_tool    as char no-undo.                                                                                                */
/*    define variable pi_help_context as integer no-undo.                                                                                             */
/*    define variable pc_choice       as char no-undo.                                                                                                */
/*    define variable pl_never_again  as logical no-undo.                                                                                             */
/*    define variable iHand as int64 no-undo.                                                                                                         */
/*                                                                                                                                                    */
/*    assign                                                                                                                                          */
/*        iHand = int64(entry(1,pcFile,PARAMETER_DELIMITER)) .                                                                                        */
/*        pc_text = entry(1,pcfile,PARAMETER_DELIMITER).                                                                                              */
/*        pc_options = entry(1,pcfile,PARAMETER_DELIMITER).                                                                                           */
/*        pl_never_toggle = logical(entry(1,pcfile,PARAMETER_DELIMITER)).                                                                             */
/*        pc_help_tool = entry(1,pcfile,PARAMETER_DELIMITER).                                                                                         */
/*        pi_help_context = int(entry(1,pcfile,PARAMETER_DELIMITER)).                                                                                 */
/*        pc_choice = entry(1,pcfile,PARAMETER_DELIMITER).                                                                                            */
/*                                                                                                                                                    */
/*    setOpenDialogHwnd(iHand).                                                                                                                       */
/*    run adeuib/ide/_dialog_advisor.p(pc_Text,pc_Options,pl_never_toggle,pc_help_tool,pi_help_context,input-output pc_Choice, output pl_never_again).*/
/*    return pc_Choice + PARAMETER_DELIMITER + string(pl_never_again).                                                                                */
/*    finally:                                                                                                                                        */
/*        removeHwnd(iHand).                                                                                                                          */
/*    end finally.                                                                                                                                    */
/*                                                                                                                                                    */
/*end procedure.                                                                                                                                      */

procedure RunNewAdmClass:
    define input parameter pcFile as char no-undo.
    define variable iHand as int64 no-undo.
    iHand = int64(entry(1,pcFile,PARAMETER_DELIMITER)).
    setOpenDialogHwnd(iHand).
    RUN choose_new_adm2_class in FUIB.
    if return-value = "cancel":U then
       return "CANCEL":U.
        
    return "OK":U. 
    finally:
        removeHwnd(iHand).          
    end finally.
end procedure. 

procedure syncFromAppbuilder:
    define input parameter pcParam  as char no-undo.
    define variable cLinkedFile as character no-undo.
    define variable cFile as character no-undo.  
    define variable ihwnd as int64 no-undo. 
    define variable hwin as handle no-undo. 
    cLinkedFile = entry(1,pcParam,PARAMETER_DELIMITER).
    if num-entries(pcParam) > 1 then 
    do: 
        cFile = entry(1,pcParam,PARAMETER_DELIMITER).
        cfile = replace(cfile, "~\":U, "/":U).  
    end.      
    hwin = getLinkFileWindow(cLinkedFile).
    run ide_syncFromAppbuilder in fUIB (cLinkedFile,cfile,hwin).
    
    return "OK":U. 
    catch e as Progress.Lang.Error :
    	return "CANCEL":U.
    end catch.
end procedure.

procedure syncFromFile:
    define input parameter pcParam  as char no-undo.
    define variable cLinkedFile as character no-undo.
    define variable cFile as character no-undo.  
    define variable ihwnd as int64 no-undo. 
    define variable hwin as handle no-undo. 
    cLinkedFile = entry(1,pcParam,PARAMETER_DELIMITER).
/*    if num-entries(pcParam) > 1 then                 */
/*    do:                                              */
/*        cFile = entry(1,pcParam,PARAMETER_DELIMITER).*/
/*        cfile = replace(cfile, "~\":U, "/":U).       */
/*    end.                                             */
    hwin = getLinkFileWindow(cLinkedFile).
    run ide_syncFromFile in fUIB (cLinkedFile,hwin).
    
    return "OK":U. 
    catch e as Progress.Lang.Error :
        return "CANCEL":U.
    end catch.
end procedure.



