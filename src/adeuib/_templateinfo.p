/* ***********************************************************/
/* Copyright (c) 2009-2012 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : _templateinfo.p
    Purpose     : 
    Parameters  :  
          pcTemplateFile -  template file
          pcRequest - comma separated list of requested info 
                    -- DESCRIPTION 
                    -- DEFAULTFILENAME 
                    -- HASWIZARD 
                    -- VALIDWIZARD.      
          pcDelimiter - delimiter for output parameter
          pcResponse - list of request options and value delimited by pcdelimiter 
 
    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Sun Mar 15 21:57:43 EDT 2009
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define input  parameter pcTemplateFile as character no-undo.
define input  parameter pcRequest      as character no-undo.
define input  parameter pcDelimiter    as character no-undo.

define output parameter pcResponse     as character no-undo.

define variable ProcDescription as character no-undo.
define variable DefaultFileName as character no-undo.
define variable isWizard        as logical   no-undo.
define variable validWizard     as char      no-undo.

define var tline as character  no-undo.
define var i     as integer    no-undo.
define var crlf  as char       no-undo.
define var iDesc as int        no-undo.
define var cwizardname as char no-undo.

define variable iDescPos         as integer no-undo.
define variable iNamePos         as integer no-undo.
define variable iWizardPos       as integer no-undo.
define variable isValidWizardPos as integer no-undo.
define variable cWizChildren     as character no-undo.
define variable cWizPage         as character no-undo.
define variable isWizardFileAvail as character no-undo.
/* ********************  Preprocessor Definitions  ******************** */

/* ************************  Function Prototypes ********************** */


function getNameFromHeader returns character 
	(pcHeader as char) forward.

function CheckValidWizard return character 
         (wizardname as char) forward.

/* ***************************  Main Block  *************************** */

pcTemplateFile = search(pcTemplateFile).
if (pcTemplateFile) = ? then 
   return.
input FROM VALUE(pcTemplateFile) NO-ECHO.

assign
  iDescPos         = lookup("DESCRIPTION",pcRequest)
  iNamePos         = lookup("DEFAULTFILENAME",pcRequest)
  iWizardPos       = lookup("HASWIZARD",pcRequest)
  isValidWizardPos = lookup("VALIDWIZARD",pcRequest).
    
repeat:     
    import unformatted tline. 
    i = i + 1. 
    if i = 2 then 
    do:
        if tline = "/* Procedure Description" or tline begins "<!--":U then 
        do:
            import tline.
            ProcDescription = tline.   
        end.
        else /* signal to use  the next 20 lines of the source as description*/
           iDesc = 20.
    end.
    /* iDesc is set if the next 20 lines of the source is to be used as description */
    else if iDesc > 0 then 
    do:
        if tline > "" then
        do:
            assign 
                ProcDescription = ProcDescription + crlf + tline
                crlf = chr(10).
        end.
        iDesc = iDesc - 1.          
    end. 
    
    if tline begins "&ANALYZE-SUSPEND _UIB-CODE-BLOCK":U then 
    do:
        if DefaultFileName = "" and num-entries(tline," ") > 4 then
            DefaultFileName = entry(5,tline," ").
     
        if not isWizard and tline begins "&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR":U then
        do:      
            import unformatted tline.
            if num-entries(tline," ") > 2 then
                cwizardname = entry(3,tline," ").
            /* if open procedure is defined we may have a wizard */
            if trim(cwizardname) <> "?" then  
            repeat:
                import unformatted tline.
                if tline begins "&ANALYZE" then 
                   leave.
                /* check if last line in xftr has a procedure reference */   
                if tline begins "*/" and 
                num-entries(cWizChildren) > 1 then 
                do:
                   cWizPage = entry(1,cWizChildren).
                   isWizardFileAvail = search(cWizPage).
                   if search(cWizPage) = ? then
                   do:
                      cWizPage = replace(cWizPage,".w",".r").
                      isWizardFileAvail = search(cWizPage).
                   end.   
                   if isWizardFileAvail <> ? then
                   do:
                       isWizard = true.
                       leave. /* repeat block */
                   end.             
                end.     
                cWizChildren = tline.
            end. /* repeat  */
            if isWizard then 
                validWizard = CheckValidWizard(input cwizardname).
        end.       
    end.
    /* leave if we found everything  */     
    if iDesc = 0 and ProcDescription > "" and isWizard = true and DefaultFileName > "" then
       leave.
end. /* repeat */ 
 
assign
   pcResponse = fill(pcDelimiter,num-entries(pcRequest) - 1)
   entry(iDescPos,pcResponse,pcDelimiter)         = ProcDescription when iDescpos > 0
   entry(iNamePos,pcResponse,pcDelimiter)         = DefaultFileName when iNamePos > 0
   entry(iWizardPos,pcResponse,pcDelimiter)       = string(isWizard) when iWizardpos > 0
   entry(isValidWizardPos,pcResponse,pcDelimiter) = validWizard when isValidwizardPos > 0.

/*input close.*/

finally:
 input close. 
end finally.
 
function CheckRcode  returns logical (wizardname as char):
        define variable fileLine as character no-undo.
        define variable cc as character no-undo.
        define variable c2 as longchar  no-undo.
        define variable i as integer no-undo.
        input from value(wizardname) binary no-echo.
/*        seek input to 50. /* really no idea where to stsrt... just saving some loops */*/
        etime(true).
        do while true:
            readkey.
            cc = chr(lastkey).
            i = i + 1.
            if i > seek(input) then
                leave.
            if lastkey = 0 then cc = chr(1).
            c2 = c2 + cc.
        end.
        return false.
        finally:
           input close. 		
        end finally.
            
    end.
   
 
function CheckValidWizard return character (wizardname as char):
    define variable FullName as character no-undo.
    define variable fileLine      as character no-undo.
    define variable cRfile       as character no-undo.
    define variable lread as logical no-undo.
    
    
    cRfile = wizardname.  
    
    if r-index(cRfile,".") > 1 then
        entry(num-entries(cRfile,"."),cRfile,".")= "r".
    else 
        cRfile = cRfile + ".r".
    /* if r-code found return the name. 
       The eclipse client will do further checks */    
    FullName = search(cRfile).
    if Fullname <> ? then 
    do:
       /*  Return r-file to java and checj internal entries for the entry that 
           is used to identify the supported temaplate.  */ 
      
        return FullName.
     
    end.
    
    /* continue and check source if no r-code */
    FullName = search(wizardname).
    
/*    /* checkl src */                          */
/*                                              */
/*    if FullName = ? then                      */
/*    do:                                       */
/*       FullName = search("src/" + wizardname).*/
/*    end.                                      */
    
    if FullName <> ? then 
    do:
        input from value(FullName) no-echo.
        lread = true.
        repeat:
            import unformatted fileLine.
            /*  we currently use the the call to the wizard server as supported 
                identifier. Feel free to improve... */ 
            if lookup("adeuib/_oeidewizard.p",fileLine, " ") > 0 then
               return FullName.
        end.
    end.
    return "".
    catch e as progress.Lang.error :
        return "". 
    end catch.
    finally:
        if lRead then 
            input close. 
    end finally.
end function. 