/*---------------------------------------------------------------------------------
         File: afsecmiscp.p

  Description: Dynamics Security Manager proxy for menuStructureSecurityCheck()

      Purpose: This procedure acts as the server-side proxy for the menuStructureSecurityCheck
               API in the Security Manager. 

  Parameters: 
                  
 -------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcstructure         as CHARACTER            NO-UNDO.
    DEFINE OUTPUT PARAMETER plStructureHidden   as logical              NO-UNDO.
    
    {src/adm2/globals.i}
    
    run menuStructureSecurityCheck in gshSecurityManager (input pcStructure, output plStructureHidden) no-error.
    if error-status:error or return-value ne '' then
        return error return-value.
    
    error-status:error = no.
    return. 
/* E O F */
