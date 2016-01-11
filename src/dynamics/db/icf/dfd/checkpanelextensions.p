/* Program:     checkpanelextensions.p 
   Parameters:  <none>
   Purpose:     This utility checks for extensions to visual and panel
                classes.  Extensions to visual may be changed in 
                fixpanelextensions.p after gscot020023.ado is loaded.  
                Extensions to panel will be reported in the DCU log. 
 * ------------------------------------------------------------------------------*/
DEFINE VARIABLE cFile AS CHARACTER  NO-UNDO.

DEFINE BUFFER bPanelType    FOR gsc_object_type. 
DEFINE BUFFER bSmartPanel   FOR gsc_object_type.
DEFINE BUFFER bSmartToolbar FOR gsc_object_type.
DEFINE BUFFER bVisualType   FOR gsc_object_type.                

PUBLISH 'DCU_SetStatus':U ('Checking for extensions to Panel and Visual classes ...').

FIND bVisualType WHERE bVisualType.OBJECT_type_code = 'Visual':U NO-LOCK NO-ERROR.
FIND bPanelType WHERE bPanelType.OBJECT_type_code = 'Panel':U NO-LOCK NO-ERROR.

/* Check for extensions to visual class that panel extends */
IF AVAILABLE bVisualType AND AVAILABLE bPanelType THEN
DO:
  IF bPanelType.extends_object_type_obj NE bVisualType.OBJECT_type_obj THEN 
  DO:
    FIND gsc_object_type WHERE gsc_object_type.OBJECT_type_obj = bPanelType.extends_object_type_obj NO-LOCK NO-ERROR.
    IF AVAILABLE gsc_object_type THEN
    DO:
      PUBLISH 'DCU_WriteLog':U ('The Panel class does not extend the Visual class. It extends the ' + 
                                gsc_object_type.OBJECT_type_code + ' class. ' +
                                'An attempt will be made to extend the new Toolbar class from the ' +
                                gsc_object_type.OBJECT_type_code + ' class.').
                                 
      cFile = SESSION:TEMP-DIRECTORY + 'visualext.txt'.
      OUTPUT TO VALUE(cFile).
      PUT UNFORMATTED bPanelType.extends_object_type SKIP.
      OUTPUT CLOSE.
    END.  /* if available object type */
    ELSE PUBLISH 'DCU_WriteLog':U ('The Panel class extends a class that does not exist. ' +
                                   'The Panel class extension should be fixed manually.').
  END.  /* panel does not extend visual class */
END.  /* if available visual type and panel type */
ELSE PUBLISH 'DCU_WriteLog':U ('The Visual and/or Panel classes were not found. ' +
                               'Visual extensions could not be checked.').

FIND bSmartPanel WHERE bSmartPanel.OBJECT_type_code = 'SmartPanel':U NO-LOCK NO-ERROR.
FIND bSmartToolbar WHERE bSmartToolbar.OBJECT_type_code = 'SmartToolbar':U NO-LOCK NO-ERROR.

/* Check for extensions to panel class */
IF AVAILABLE bPanelType AND AVAILABLE bSmartPanel AND AVAILABLE bSmartToolbar THEN
DO:
  FOR EACH gsc_object_type WHERE gsc_object_type.extends_object_type_obj = bPanelType.OBJECT_type_obj NO-LOCK:
    
    IF gsc_object_type.OBJECT_type_obj NE bSmartPanel.OBJECT_type_obj AND
       gsc_object_type.OBJECT_type_obj NE bSmartToolbar.OBJECT_type_obj THEN

      PUBLISH 'DCU_WriteLog':U ('The ' + gsc_object_type.object_type_code + ' class extends the Panel class. ' +
                                'It may need to be changed manually to extend the new Toolbar class.'). 

  END.  /* for each gsc_object_type */
END.  /* if available panel type */
ELSE PUBLISH 'DCU_WriteLog':U ('The Panel and/or SmartToolbar classes were not found. ' +
                               'Panel extensions could not be checked.').

                
                
