/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afsecclntp.p

  Description:  Astra Client Security Manager

  Purpose:      This is the actual Client Side Security Manager.
                The actual code for the Security Manager is contained in the 
                include file af/app/afsecmngrp.i
                This code is also used by the Server Side Security Manager
                af/app/afsecsrvrp.p
                Server side and client side code is conditionally included using
                the pre-processors server-side and client-side.
                This is not a structured include and contains no wizards as it
                contains no specific code other than the definition of a 
                pre-processor and an include file containing the actual code.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   30/05/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

&global-define client-side  yes
{af/app/afsecmngrp.i}
