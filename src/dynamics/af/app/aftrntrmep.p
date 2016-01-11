/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: aftrntrmep.p

  Description:  Translation Manager: translateMenu() server proxy

  Purpose:      This procedure acts as the server-side proxy for the translateMenu
                API in the Localization (Translation) Manager. It performs translations
			    for a set of menu items (actions)
                
  Parameters:   
                                      
  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   2005-08-25  Author:     pjudge

  Update Notes: Created from scratch.
  
 -------------------------------------------------------------------------------------*/
    define input        parameter pcLanguageCode            as character            no-undo.
    define input-output parameter table-handle phTable.
    
    {src/adm2/globals.i}
    
    define variable hBuffer                as handle                        no-undo.
    
    /* Use a buffer handle to avoid deep copies. */
    hBuffer = phTable:default-buffer-handle.
    
    run translateToolbar in gshTranslationManager (input        pcLanguageCode,
                                                   input-output hBuffer         ) no-error.
    if error-status:error or return-value ne '' then
        return error return-value.
    
    error-status:error = no.
    return. 
/* E O F */
