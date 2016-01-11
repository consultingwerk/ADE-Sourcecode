/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : _edtsmar.p
    Purpose     : Calls the 'edit-attribute-list' method in a SmartObject
                  and checks to see if the value has changed.  If so
                  we set the 'save' flag on the .w file.
    Parameters  : p_context-id -- INTEGER context (i.e. RECID) of the
                  SmartObject's Universal Widget record.

    Author(s)   : Wm.T.Wood 
    Created     : August, 1996
    Modified    : 03/25/98 SLK Corrected call to instancePropertyList
  ------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p_context-id AS INTEGER NO-UNDO.

DEFINE VAR orig-attr-list AS CHAR NO-UNDO.
DEFINE VAR new-attr-list  AS CHAR NO-UNDO.
DEFINE VAR cTranslatable  AS CHAR NO-UNDO.
DEFINE VAR i              AS INT  NO-UNDO.
DEFINE VAR ii             AS INT  NO-UNDO.
DEFINE VAR cFieldName     AS CHAR NO-UNDO.

/* Variables used for adm version */
{adeuib/vsookver.i}
{ adeuib/uniwidg.i } /* Universal widget definitions. */
{adeuib/sharvars.i} 
{src/adm2/globals.i}

/* Get the Universal Widget Record(s) */
FIND _U WHERE RECID(_U) eq p_context-id.
FIND _S WHERE RECID(_S) eq _U._x-recid.

/* Determine admVersion */
{adeuib/admver.i _S._HANDLE admVersion}.

/* Save the original attribute list. Edit the list, and check the new
 * value. */
IF admVersion LT "ADM2":U THEN DO:
   RUN get-attribute-list IN _S._HANDLE (OUTPUT orig-attr-list) NO-ERROR.
   RUN dispatch IN _S._HANDLE ("edit-attribute-list":U) NO-ERROR.
   RUN get-attribute-list IN _S._HANDLE (OUTPUT new-attr-list) NO-ERROR.
END. /* ADM1 */
ELSE DO:
   orig-attr-list = 
      DYNAMIC-FUNCTION("instancePropertyList":U IN _S._HANDLE, "":U) NO-ERROR.
   RUN editInstanceProperties IN _S._HANDLE NO-ERROR.
   new-attr-list = 
      DYNAMIC-FUNCTION("instancePropertyList":U IN _S._HANDLE, "":U) NO-ERROR.
END. /* > ADM1 */

/* Ensure the affordance button is on top */
IF AVAILABLE _S AND 
   _S._affordance-handle <> ? AND 
   VALID-HANDLE(_S._affordance-handle) THEN
     _S._affordance-handle:MOVE-TO-TOP().  

/* Check for differences. */
IF NOT ERROR-STATUS:ERROR AND orig-attr-list NE new-attr-list THEN DO:
  /* Save the settings locally. */
  IF admVersion LT "ADM2" THEN
    /* DRH (10/12/98) I don't understand this, but it was this way in 8.2 */
    _S._settings = new-attr-list.
  ELSE DO: /* ADM 2 or Greater */
    DO i = 1 TO NUM-ENTRIES(new-attr-list, CHR(3)):
      IF i > NUM-ENTRIES(orig-attr-list,CHR(3)) OR
         ENTRY(i,orig-attr-list,CHR(3)) NE ENTRY(i,new-attr-list,CHR(3)) THEN DO:
        /* Property is different - First see if it is already in _S._settings */
        IF INDEX(_S._settings, ENTRY(1,ENTRY(i,new-attr-list,CHR(3)),CHR(4))) > 0
        THEN DO:  /* Found it - replace value */
          REPLACE-PROP:
          DO ii = 1 TO NUM-ENTRIES(_S._settings, CHR(3)):
            IF ENTRY(1, ENTRY(ii,_S._settings,CHR(3)), CHR(4)) EQ
               ENTRY(1, ENTRY(i, new-attr-list, CHR(3)), CHR(4)) THEN DO:
              /* HAve located the property replace its value */
              ENTRY(ii, _S._settings, CHR(3)) = ENTRY(i, new-attr-list, CHR(3)).
              LEAVE REPLACE-PROP.
            END.  /* IF have located the property */
          END. /* DO ii = 1 to num-entries */
        END.  /* Modified property is already in settings */
        ELSE DO:  /* The modified property is not already in the settings */
          _S._settings = _S._SETTINGS +
                         (IF _S._settings NE "" THEN CHR(3) ELSE "") +
                         ENTRY(i,new-attr-list,CHR(3)).
        END.  /* Else the modified propert isn't in the settings */
      END.  /* IF there is a change in the property list */
    END.  /* DO i = 1 to entries in new-attr-list */

    /* If this is a SmartLOBField and this is a dynamic viewer than 
       the instance name (_U._NAME) must be set to the FieldName 
       attribute of the SmartLOBField.  The table name is set to 
       the first entry of the FieldName as well.  This seems strange 
       but it must be set to control how the Object name field on 
       the AppBuilder main window is sensitized.  When the viewer
       is read from the repository on open, this is how _U._TABLE 
       is set in support of SBO viewers. */
    IF _DynamicsIsRunning AND _U._SUBTYPE = "SmartLOBField":U THEN
    DO:
      FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE.
      IF DYNAMIC-FUNCTION("ClassIsA" IN gshRepositoryManager, _P.object_type_code, "DynView":U) THEN
      DO:
        cFieldName = DYNAMIC-FUNCTION("getFieldName":U IN _S._HANDLE).
        ASSIGN
          _U._NAME  = IF NUM-ENTRIES(cFieldName, ".":U) > 1 THEN ENTRY(2, cFieldName, ".":U) 
                      ELSE cFieldName
          _U._TABLE = ENTRY(1,cFieldName,".":U).
        RUN display_current IN _h_uib.
      END.  /* if dynamic viewer */
    END.  /* if SmartLOBField */
        
  END.  /* Else it is ADM2 or greater */
  
  /* File has changed. */
  RUN adeuib/_winsave.p (INPUT _U._WINDOW-HANDLE, INPUT false /* not saved */ ).
END.

