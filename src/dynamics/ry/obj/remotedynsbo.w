/*--------------------------------------------------------------------
  File: ry/obj/remotedynsbo.w

  Description:  Remote Dynamic SmartBusinessObject

  Purpose:      This is the remote dynamic SBO rendering procedure, for 
                support of binding on server ( called from getAsHandle ).
                  
                It has a logicalname parameter and defines itself as
                adm-logicalname-callback for prepareInstance. 

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


{ry/obj/dynsbo.w}

