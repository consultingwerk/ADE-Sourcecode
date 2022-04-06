/*---------------------------------------------------------------------------------
  File: rycussrvrp.p

  Description:  Dynamics Customisation Manager (Server)

  Purpose:      This is the actual Server Side Customisation Manager.
                The actual code for the Customisation Manager is contained in the 
                include file ry/app/rycusmngrp.i.i
                This code is also used by the Client Side Customisation Manager
                ry/prc/ryrepclntp.p
                Server side and client side code is conditionally included using
                the pre-processors server-side and client-side.
                This is not a structured include and contains no wizards as it
                contains no specific code other than the definition of a 
                pre-processor and an include file containing the actual code.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:              UserRef:    
                Date:   22/04/2002  Author:     Peter Judge

  Update Notes: Created from scratch.

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

&global-define server-side YES
{ry/app/rycusmngrp.i}

