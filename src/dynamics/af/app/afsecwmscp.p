/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
         File: afsecwmscp.p

  Description: Dynamics Security Manager proxy for menuItemStructureSecurityCheck()

      Purpose: This procedure acts as the server-side proxy for the menuItemStructureSecurityCheck
               API in the Security Manager. 

   Parameters: See Security Manager API for details                  
 -------------------------------------------------------------------------------------*/
    define input  parameter pcItem             as character            no-undo.
    define input  parameter pcStructure        as character            no-undo.
    define output parameter pcItemHidden       as character            no-undo.
    define output parameter pcItemDisabled     as character            no-undo.
    define output parameter pcStructureHidden  as character            no-undo.
    
    {src/adm2/globals.i}
    
    run menuItemStructureSecurityCheck in gshSecurityManager ( input  pcItem,
                                                               input  pcStructure,
                                                               output pcItemHidden,
                                                               output pcItemDisabled,
                                                               output pcStructureHidden ) no-error.
    if error-status:error or return-value ne '' then
        return error return-value.
    
    error-status:error = no.
    return. 
/* E O F */
