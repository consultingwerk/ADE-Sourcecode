/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afprosrvrp.p

  Description:  Astra Server Profile Manager

  Purpose:      This is the actual Server Side Profile Manager.
                The actual code for the Profile Manager is contained in the 
                include file af/app/afpromngrp.i
                This code is also used by the Client Side Profile Manager
                af/sup2/afproclntp.p
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

&global-define server-side  yes
{af/app/afpromngrp.i}
