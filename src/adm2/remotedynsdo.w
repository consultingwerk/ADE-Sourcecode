/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------
  File: remotedynsdo.w

  Description:  Remote Dynamic SmartDataObject

  Purpose:      This is the remote dynamic SDO rendering procedure, for 
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


{src/adm2/dynsdo.w}

