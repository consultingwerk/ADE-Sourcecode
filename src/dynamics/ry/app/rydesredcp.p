/*---------------------------------------------------------------------------------
  File: rydesredcp.p

  Description:  AppServer pass-through wrapper for retrieveDesignClass().
  
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
{destdefi.i}

DEFINE INPUT  PARAMETER pcClassName             AS CHARACTER        NO-UNDO.
DEFINE OUTPUT PARAMETER pcInheritsFromClasses   AS CHARACTER        NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttClassAttribute.
DEFINE OUTPUT PARAMETER TABLE FOR ttUiEvent.
DEFINE output parameter table for ttSupportedLink.

DEFINE VARIABLE hDesignManager          AS HANDLE                   NO-UNDO.

ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U IN TARGET-PROCEDURE,
                                         INPUT "RepositoryDesignManager":U).

RUN retrieveDesignClass IN hDesignManager ( INPUT  pcClassName,
                                            OUTPUT pcInheritsFromClasses,
                                            OUTPUT TABLE ttClassAttribute,
                                            OUTPUT TABLE ttUiEvent,
                                            output table ttSupportedLink        ) NO-ERROR.
IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.
/* *** E - O - F *** */
