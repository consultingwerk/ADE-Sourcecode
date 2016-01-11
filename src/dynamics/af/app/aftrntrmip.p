/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: aftrntrmip.p

  Description:  Translation Manager: translateMenuItem() server proxy

  Purpose:      This procedure acts as the server-side proxy for the translateMenuItem
                API in the Localization (Translation) Manager. It performs translations
                on a single menu item.
                
  Parameters:   
                                    
  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   2005-08-25  Author:     pjudge

  Update Notes: Created from scratch.
  
 -------------------------------------------------------------------------------------*/
    define input  parameter pcLanguageCode       as character         no-undo.
    define input  parameter pcItem               as character         no-undo.
    define output parameter pcLabel              as character         no-undo.
    define output parameter pcCaption            as character         no-undo.
    define output parameter pcTooltip            as character         no-undo.
    define output parameter pcAccelerator        as character         no-undo.
    define output parameter pcImage              as character         no-undo.
    define output parameter pcImageDown          as character         no-undo.
    define output parameter pcImageInsensitive   as character         no-undo.
    define output parameter pcImage2             as character         no-undo.
    define output parameter pcImage2Down         as character         no-undo.
    define output parameter pcImage2Insensitive  as character         no-undo.
    
    {src/adm2/globals.i}
    
    /* No validation done here, the API does it all */
    
    run translateAction in gshTranslationManager ( input  pcLanguageCode,
                                                   input  pcItem,
                                                   output pcLabel,
                                                   output pcCaption,
                                                   output pcTooltip,
                                                   output pcAccelerator,
                                                   output pcImage,
                                                   output pcImageDown,
                                                   output pcImageInsensitive,
                                                   output pcImage2,
                                                   output pcImage2Down,
                                                   output pcImage2Insensitive ) no-error.
    if error-status:error or return-value ne '' then
        return error return-value.
    
    error-status:error = no.
    return. 
/* E O F */
