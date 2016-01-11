/*************************************************************/
/* Copyright (c) 2013 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : resolve relative path of full path file
                  prompts if relative name shadowed by other file in propath
    Syntax      :
     
    Description : 

    Author(s)   : 
    Created     : Apr 2013
    Notes       : No check for valid-file. 
                  will return passed file if invalid
                  will return relative filename if path matches propath even if file does not exist
    Parameter      input-output filename
                   in - full pathed file 
                   out - relative path if in propath (and confirmed if shadowed) 
                          
                       - "" if cancel shadowed selection 
                       - fullpath in all other cases (no check for valid file)
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

routine-level on error undo, throw.

define input-output  parameter pcfile as character no-undo.

define variable DOS-SLASH   as character no-undo initial "~\":U.
define variable UNIX-SLASH  as character no-undo initial "/":U.
define variable cSearch     as character no-undo.
define variable lok         as logical no-undo.
define variable cMsg        as character no-undo.
define variable i           as integer no-undo.
define variable cPickedFile as character no-undo. 
define variable cUseSlash   as character no-undo.
define variable cNotUseSlash as character no-undo.
define variable MSG_TITLE    as character initial "Confirm use of relative path" no-undo.
{adecomm/oeideservice.i}

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
if opsys = "UNIX":U then
do:
    assign 
        cUseSlash = DOS-SLASH
        cNotUseSlash  = UNIx-SLASH.
end.
else do:
    assign 
        cUseSlash = UNIx-SLASH
        cNotUseSlash  = DOS-SLASH.
end.        
pcfile = replace(pcfile,cUseSlash,cNotUseSlash).
do i = 1 to num-entries(propath):
    file-info:file-name = trim(entry(i,propath)).
    if pcFile begins file-info:full-pathname and file-info:full-pathname ne ? then 
    do:
        cPickedfile = pcFile.
        /* If it's there, chop off the leading part */
        pcFile = substring(pcFile, length(right-trim(file-info:full-pathname,cUseSlash)) + 2, -1,"CHARACTER":U).
        cSearch = search(pcFile).
        if cSearch <> ? and not cSearch begins file-info:full-pathname then
        do:
            lok = true.
            cMsg =    "The relative path " + pcFile + " of the selected file "
                        + cPickedfile + " resolves to a different file " + cSearch + " in propath." + "~n~n"
                        + "Confirm use of relative path." + "~n~n"  + "Select:" + "~n"
                        + "   Yes to use relative path."  + "~n"  
                        + "   No to use full path (not recommended)."  + "~n" 
                        + "   Cancel to select a different file.".
            if OEIDE_CanShowMessage() then 
                lok = ShowMessageInIDE(cMsg,"Question":U,MSG_TITLE,"yes-no-cancel":U,lok).
            else 
                message cMsg       
                    view-as alert-box question buttons yes-no-cancel title MSG_TITLE update lok .
            if not lok then 
                pcfile = cPickedfile.
            else if lok = ? then
                pcfile = "". 
        end.
    end.
end.            