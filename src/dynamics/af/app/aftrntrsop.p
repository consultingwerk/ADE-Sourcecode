/*---------------------------------------------------------------------------------
  File: aftrntrsop.p

  Description:  AppServer pass-through wrapper for translateSingleObject() in the
                Dynamics Translation/Localization Manager.

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/30/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
define input  parameter pdLanguageObj   as decimal              no-undo.
define input  parameter pcObjectName    as character            no-undo.
define input  parameter pcWidgetName    as character            no-undo.
define input  parameter pcWidgetType    as character            no-undo.
define input  parameter piWidgetEntries as integer              no-undo.
define output parameter pcLabels        as character            no-undo.
define output parameter pcTooltips      as character            no-undo.

{src/adm2/globals.i}

run translateSingleObject in gshTranslationManager ( input  pdLanguageObj,
                                                     input  pcObjectName,
                                                     input  pcWidgetName,
                                                     input  pcWidgetType,
                                                     input  piWidgetEntries,
                                                     output pcLabels,
                                                     output pcTooltips          ) no-error.
IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.
/* *** E - O - F *** */