/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
         File: afsecccsep.p

  Description: Dynamics Security Manager proxy for cacheContainerSecurity()

      Purpose: This procedure acts as the server-side proxy for the cacheContainerSecurity
               API in the Security Manager. 

   Parameters: pcContainerName		 - The name of the conatiner being secured 
   			   pcRunAttribute 		 - the run attribute for the current container
   			   pcMenuStructure		 - CSV list of menu structures (bands) 
   			   pcMenuItem     		 - CSV list of menu items (actions)
   			   pcCheckType    		 - CSV list of type of caching to perform.
   			   							One of more of Object, Field, Token, MenuStructure and MenuItem.
   			   					       Only those types of checks specified in this parameter
   			   					       will be performed.
			   All of the remaining parameter are output parameters, and will only be populated
			   if the security they refer to is in the check type paramter.
   			   plObjectSecured		 - whether the object is secured
   			   pdObjectObj    		 - the object id of the secured object
   			   pcSecuredFields		 - CSV list of secured fields, and their security type
   			   pcSecuredTokens		 - CSV list of secured tokens, and their security type
   			   pcMenuItemHidden		 - CSV list of hidden menu items, subset of input items
   			   pcMenuItemDisabled 	 - CSV list of disabled menu items, subset of input items
   			   pcMenuStructureHidden - CSV list of hidden menu structures, subset of input structures
   
 -------------------------------------------------------------------------------------*/
    define input  parameter pcContainerName               as character            no-undo.
    define input  parameter pcRunAttribute                as character            no-undo.
    define input  parameter pcMenuStructure               as character            no-undo.
    define input  parameter pcMenuItem                    as character            no-undo.
    define input  parameter pcCheckType                   as character            no-undo.
    define output parameter plObjectSecured               as logical              no-undo.
    define output parameter pdObjectObj                   as decimal              no-undo.
    define output parameter pcSecuredFields               as character            no-undo.
    define output parameter pcSecuredTokens               as character            no-undo.
    define output parameter pcMenuItemHidden              as character            no-undo.
    define output parameter pcMenuItemDisabled            as character            no-undo.
    define output parameter pcMenuStructureHidden         as character            no-undo.
    
    {src/adm2/globals.i}
    
    if can-do(pcCheckType, 'Object') then
    do:
        run objectSecurityCheck in gshSecurityManager (input-output pcContainerName,
                                                       input-output pdObjectObj,
                                                             output plObjectSecured ) no-error.
        if error-status:error or return-value ne '' then return error return-value.
    end.    /* secure object */
    
    /* Bundle Field and Token/Action security into one call */
    if can-do(pcCheckType, 'Field') or can-do(pcCheckType, 'Token') then    
    do:
        run fieldAndTokenSecurityCheck in gshSecurityManager (input  pcContainerName,
                                                              input  pcRunAttribute,
                                                              input  can-do(pcCheckType, 'Field'),  /* check field sec? */
                                                              input  can-do(pcCheckType, 'Token'),  /* check token sec? */
                                                              output pcSecuredFields,
                                                              output pcSecuredTokens  ) no-error.
        if error-status:error or return-value ne '' then return error return-value.
    end.    /* field and token security */
    
    /* Bundle menu item and structure security into one call */
    if can-do(pcCheckType, 'MenuStructure') or can-do(pcCheckType, 'MenuItem') then
    do:
	    run menuItemStructureSecurityCheck in gshSecurityManager ( input  pcMenuItem,
	                                                               input  pcMenuStructure,
	                                                               output pcMenuItemHidden,
	                                                               output pcMenuItemDisabled,
	                                                               output pcMenuStructureHidden ) no-error.
        if error-status:error or return-value ne '' then return error return-value.
    end.    /* item or structure security */
    
    error-status:error = no.
    return. 
/* E O F */
