/*---------------------------------------------------------------------------------
  File: rydessrvrp.p

  Description:  Dynamics Repository Design Client Manager

  Purpose:      This is the actual Client Side Repository Design Manager.
                The actual code for the Repository Design Manager is contained in the 
                include file ry/app/rydesmngrp.i
                This code is also used by the Client Side Repository Design Manager
                ry/prc/rydesclntp.p
                Server side and client side code is conditionally included using
                the pre-processors server-side and client-side.
                This is not a structured include and contains no wizards as it
                contains no specific code other than the definition of a 
                pre-processor and an include file containing the actual code.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:               UserRef:    
                Date:   21/05/2002  Author:     Peter Judge

  Update Notes: Created from Template aftemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

&global-define Client-side YES
{ry/app/rydesmngrp.i}
