/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*--------------------------------------------------------------------
  File: ry/obj/remotedynsbo.w

  Description:  Remote Dynamic SmartBusinessObject

  Purpose:      This is the remote dynamic SBO rendering procedure, for 
                support of binding on server ( called from getAsHandle ).
                  
                It has a logicalname parameter and defines itself as
                adm-logicalname-callback for prepareInstance. 
                
       NOTE:    The SDOs that are created will call the container and 
                thus use the same callback, so setCurrentLogicalName, which is 
                called from createObjects to define which SDO to load is also 
                overridden here.
                
  Parameters:   pcLogicalObjectName - LogicalObjectName passed from client
----------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcLogicalObjectName AS CHARACTER  NO-UNDO.

&GLOBAL-DEFINE ADM-EXCLUDE-PROTOTYPES
&GLOBAL-DEFINE ADM-EXCLUDE-STATIC

&SCOPED-DEFINE exclude-start-super-proc 

/* tell smartprp.i that we have the getCurrentLogicalname callback  */ 
&SCOPED-DEFINE ADM-LOGICALNAME-CALLBACK TARGET-PROCEDURE 

FUNCTION getCurrentLogicalName RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Called from prepareInstance to identify object to load  
------------------------------------------------------------------------------*/
  RETURN pcLogicalObjectName. 
END FUNCTION.

FUNCTION setCurrentLogicalName RETURNS CHARACTER
  ( picCurrentLogicalName AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Called from createObjects to define object to load  
------------------------------------------------------------------------------*/
  pcLogicalObjectName = picCurrentLogicalName. 
END FUNCTION.

{ry/obj/dynsbo.w}

