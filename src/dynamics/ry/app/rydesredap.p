/*---------------------------------------------------------------------------------
  File: rydesredap.p

  Description:  AppServer pass-through wrapper for retrieveDesignAttribute().
  
  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/22/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/** Contains definitions for all design-time API temp-tables.
 *  ----------------------------------------------------------------------- **/
{ry/inc/rydestdefi.i}

 DEFINE INPUT  PARAMETER pcObjectList    AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER pcResultCode    AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER pcGetWhat       AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER plGetClass      AS LOGICAL   NO-UNDO.
 DEFINE INPUT  PARAMETER plRecursive     AS LOGICAL   NO-UNDO.
 DEFINE OUTPUT PARAMETER TABLE FOR ttObject.
 DEFINE OUTPUT PARAMETER TABLE FOR ttObjectAttribute.
 DEFINE OUTPUT PARAMETER TABLE FOR ttClassAttribute.

DEFINE VARIABLE hDesignManager          AS HANDLE                   NO-UNDO.

ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U IN TARGET-PROCEDURE,
                                         INPUT "RepositoryDesignManager":U).

RUN retrieveDesignAttribute IN hDesignManager ( INPUT pcObjectList,
                                                INPUT pcResultCode,
                                                INPUT pcGetWhat,
                                                INPUT plgetClass,
                                                INPUT plRecursive,
                                                OUTPUT TABLE ttObject,
                                                OUTPUT TABLE ttObjectAttribute,
                                                OUTPUT TABLE ttClassAttribute ) NO-ERROR.
IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.
/* *** E - O - F *** */
