/*********************************************************************
* Copyright (C) 2010 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: confirmmt.i

Description:   
   functions with text for multi-tenant change confirmation dialog box.

Returns:  
    
Author: hdaniels
                      
Date Created: 06/27/10

Modified:

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES

function layout returns logical (ed as handle):
    define variable dHeight as decimal no-undo.
    define variable hWidget as handle no-undo.
    dHeight = ed:height.
    ed:inner-lines = ed:num-lines.
    hWidget = ed:next-sibling.
    do while valid-handle(hWidget):
        hWidget:row = hWidget:row -  (dHeight - ed:height).
        hWidget = hWidget:next-sibling.
    end.     
    ed:frame:height = ed:frame:height - (dHeight - ed:height).  
    return true.
end function.   

function showAgain returns char (): 
     return "&Don't show me this again (for this session)".
end function.

function confirmYes returns char (pcObject as char,plkeepdefault as log):     
     return "Confirm that you want to multi-tenant enable this " 
     + (if pcobject = "s" then "sequence" else if pcobject = "t" then "table" else pcObject)
     + (if pcobject = "t" and plkeepdefault = false then " and delete the data" else "")
     + ".".
end function.

function confirmSequence returns char ():
   return "The multi-tenant change cannot be reverted after you commit the changes.".
end function.


function confirmTable returns char (plKeepDefault as log):
    define variable ctext as character no-undo.
    define variable inumtenants as integer no-undo. 
    define variable iimmediatetenants as integer no-undo. 
    define variable ctenants as char  no-undo. 
    define variable cAllocation as char  no-undo. 
    define variable cRule as char  no-undo. 
    define variable cWarning as char  no-undo. 
    define variable cDataDelete as char  no-undo. 
    define variable cAllOrOne as char  no-undo. 
    
    /* count the number of tenants to shpw in the message, but give up if many many 
      don't count the default and super */
    
    for each dictdb._tenant where dictdb._tenant._tenant-type = 1 no-lock:
       inumtenants = inumtenants + 1.
       if dictdb._tenant._tenant-allocation-default = "immediate" then
          iimmediatetenants = iimmediatetenants + 1.
        
       
       if inumtenants = 1001 then
          leave.
    end. 
    
    if not plkeepdefault then 
         cDataDelete =  "The choice to not keep the default area will cause all existing data in the table to be deleted.". 
    if inumtenants = 0 then 
    do:
        cText = "The change to make this into a multi-tenant table cannot be reverted after the transaction has been committed.".
    end.    
    else do:
        if inumtenants > 1000 then
        do:
            cAllocation = "The partitions will be allocated according to the defaults settings of the (more than 1000) regular tenants.".
        end.
        else do:
            ctenants = "the " + string(inumtenants) + " existing regular tenants".
            if inumtenants = 1 then
               cAllOrOne = "The single existing regular tenant is".
            else
               cAllOrOne = "All of " + ctenants + " are".   
            
            cAllOrOne =  cAllOrOne + " defined to allocate partitions". 
            
            if iimmediatetenants > 0 then
            do: 
                cRule = "immediately according to the default area settings on the tenant.".              
                if iimmediatetenants lt inumtenants then                           
                   cAllocation = 
                        "The partitions for " + string(iimmediatetenants)
                      + " of " + ctenants + " will be allocated " + cRule 
                      + " The remaining partitions are defined to be allocated by tenant or individually later.".
                 else
                    cAllocation = 
                       cAllOrOne + " " + cRule.
                                      
            end.
            else 
              cAllocation = cAllOrOne + " by tenant or individually later.".
             
        end.    
        
        cWarning = "The change to make this into a multi-tenant table will cause new storage partitions to be created" 
                + " for the table, indexes and lob fields for each regular tenant.".
        
           
        cText = cWarning
                 
            + " " + cAllocation 
            + chr(10) + chr (10)
      + "You cannot change the table to not be multi tenant-enabled after you commit the changes."
      /*
      + chr(10) + chr (10)
      + " If you want to customize the area allocation per tenant and object you should use" 
      + " OpenEdge Management or the Multi-tenant Data Dictionary API."
      */
      .

    end.
    if cDataDelete > "" then 
       ctext = cText + chr(10) + chr(10) + cDataDelete. 
    
    return cText
           + "~n~n" 
           + confirmYes("t":U,plKeepDefault).   
    
end function.    

    
