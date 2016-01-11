/* Program:     fixpanelextensions.p 
   Parameters:  <none>
   Purpose:     This utility looks for output created by checkpanelextensions.p
                and fixes the toolbar class to extend a custom visual class if
                the panel class extended the custom visual class.
                This is done after gscot020023.ado is loaded.  
 * ------------------------------------------------------------------------------*/
DEFINE VARIABLE cFile       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLine       AS CHARACTER  NO-UNDO.

DEFINE BUFFER bToolbarType FOR gsc_object_type.

PUBLISH 'DCU_SetStatus':U ('Checking whether the new Toolbar class extension needs to change ' +
                           'based on the previous Panel class extension ...').

cFile = SEARCH(SESSION:TEMP-DIRECTORY + 'visualext.txt').
IF cFile = ? THEN
  PUBLISH 'DCU_WriteLog':U ('The Toolbar class extension does not need to change.').
ELSE DO:
  INPUT FROM VALUE(cFile).
  IMPORT UNFORMATTED cLine.
  INPUT CLOSE.
  OS-DELETE VALUE(cFile).

  FIND gsc_object_type WHERE
    gsc_object_type.OBJECT_type_obj = DECIMAL(cLine) NO-LOCK NO-ERROR.
  IF AVAILABLE gsc_object_type THEN
  DO:
    FIND bToolbarType WHERE bToolbarType.OBJECT_type_code = 'Toolbar':U EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE bToolbarType THEN
    DO:
      ASSIGN bToolbarType.extends_object_type_obj = gsc_object_type.OBJECT_type_obj.
      PUBLISH 'DCU_WriteLog':U ('The Toolbar class was changed to extend the ' +
                                gsc_object_type.OBJECT_type_code + ' class.').
    END.  /* if available bPanelType */
    ELSE PUBLISH 'DCU_WriteLog':U ('The Toolbar class could not be found. The Toolbar class extension could not be changed').

  END.
  ELSE PUBLISH 'DCU_WriteLog':U ('The class that Panel class extended could not be found.' +
                                 'The Toolbar class extension was not changed, any customizations ' +
                                 'will need to be manually applied').
END.  /* else do - visualext.txt file found */

RETURN. 
 
