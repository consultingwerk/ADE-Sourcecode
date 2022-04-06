/*---------------------------------------------------------------------------------
  File: rydesredop.p

  Description:  AppServer pass-through wrapper for retrieveDesignObject().
  
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

DEFINE INPUT PARAMETER pcObjectName             AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER pcResultCode             AS CHARACTER        NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttObject.
DEFINE OUTPUT PARAMETER TABLE FOR ttPage.
DEFINE OUTPUT PARAMETER TABLE FOR ttLink.
DEFINE OUTPUT PARAMETER TABLE FOR ttUIEvent.
DEFINE OUTPUT PARAMETER TABLE FOR ttObjectAttribute.


DEFINE VARIABLE hDesignManager          AS HANDLE                   NO-UNDO.

ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U IN TARGET-PROCEDURE,
                                         INPUT "RepositoryDesignManager":U).

RUN retrieveDesignObject IN hDesignManager ( INPUT  pcObjectName,
                                             INPUT  pcResultCode,
                                             OUTPUT TABLE ttObject,
                                             OUTPUT TABLE ttPage,
                                             OUTPUT TABLE ttLink,
                                             OUTPUT TABLE ttUiEvent,
                                             OUTPUT TABLE ttObjectAttribute ) NO-ERROR.
IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.
/* *** E - O - F *** */
