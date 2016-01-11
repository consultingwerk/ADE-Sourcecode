/*---------------------------------------------------------------------------------
         File: afsecmiscp.p

  Description: Dynamics Security Manager proxy for menuItemSecurityCheck()

      Purpose: This procedure acts as the server-side proxy for the menuItemSecurityCheck
               API in the Security Manager. 

  Parameters: 
                  
 -------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcItem          as CHARACTER            NO-UNDO.
    DEFINE OUTPUT PARAMETER plItemHidden    as logical              NO-UNDO.
    DEFINE OUTPUT PARAMETER plItemDisabled  as logical              NO-UNDO.
    
    {src/adm2/globals.i}
    
    run menuItemSecurityCheck in gshSecurityManager (input pcItem, output plItemHidden, output plItemDisabled) no-error.
    if error-status:error or return-value ne '' then
        return error return-value.
    
    error-status:error = no.
    return. 
/* E O F */
