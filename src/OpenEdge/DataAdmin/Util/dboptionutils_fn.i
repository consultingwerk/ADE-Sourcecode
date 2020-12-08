/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : dboptionutils_fn.i
    Purpose     : Common util functions for the dbconnectionrole_*.p utilities
    Author(s)   : pjudge 
    Created     : 2016-05-03
    Notes       :
  ----------------------------------------------------------------------*/
function InitLog returns logical ():
    output to value({&EXPORT-LOG}).
    output close.
end function.

function PutMessage returns logical (input pcMessage as character, 
                                     input poLevel as OpenEdge.Logging.LogLevelEnum):
    output to value({&EXPORT-LOG}) append.
    put unformatted 
        substitute('[&1] &2 &3 &4':u,
            iso-date(now),
            {&EXPORT-LOG-GROUP},
            string(poLevel),  
            pcMessage) 
        skip.
    finally:
        output close.
    end finally.        
end function.    

function IsAdmin returns logical (input pcUserId as character):
    define variable lIsAdmin as logical no-undo.
    run prodict/_dctadmn.p (input  pcUserId, output lIsAdmin ).
    
    return lIsAdmin.
end function.

function GetOutputFolder returns character (input pcFolder as character):
    assign file-info:file-name = pcFolder 
           pcFolder            = file-info:full-pathname.
    if pcFolder eq ? then
        assign file-info:file-name = os-getenv('WRKDIR':u) 
               pcFolder = file-info:full-pathname.
    if pcFolder eq ? then
        assign file-info:file-name = '.':u 
               pcFolder = file-info:full-pathname.
    if pcFolder eq ? then
        assign file-info:file-name = session:temp-dir 
               pcFolder = file-info:full-pathname.

    return pcFolder.
end function.

/* eof */