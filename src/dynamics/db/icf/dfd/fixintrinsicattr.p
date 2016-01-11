/* Attribute Fix program - This program is designed to bring attributes of 
   objects in existing dynamic viewers upto V2 standards                          */

DEFINE BUFFER bryc_attribute_value FOR ryc_attribute_value.

DISABLE TRIGGERS FOR LOAD OF ryc_attribute.
DISABLE TRIGGERS FOR LOAD OF ryc_attribute_value.
DISABLE TRIGGERS FOR LOAD OF bryc_attribute_value.
DISABLE TRIGGERS FOR DUMP OF bryc_attribute_value.

DEFINE VARIABLE DataType         AS INTEGER     NO-UNDO.
DEFINE VARIABLE Is-A-Widget-Attr AS LOGICAL     NO-UNDO.

DEFINE BUFFER admGroup FOR ryc_attribute_group.
DEFINE BUFFER bAttrValue FOR ryc_attribute_value.


/* Create a table of widget handles to query for valid attributes */
DEFINE TEMP-TABLE WidgetType NO-UNDO
    FIELD hHandle AS WIDGET-HANDLE
  INDEX TYPE hHandle.

CREATE WidgetType.
CREATE BUTTON widgetType.hHandle.
CREATE WidgetType.
CREATE COMBO-BOX widgetType.hHandle.
CREATE WidgetType.
CREATE EDITOR widgetType.hHandle.
CREATE WidgetType.
CREATE FILL-IN widgetType.hHandle.
CREATE WidgetType.
CREATE IMAGE widgetType.hHandle.
CREATE WidgetType.
CREATE RADIO-SET widgetType.hHandle.
CREATE WidgetType.
CREATE RECTANGLE widgetType.hHandle.
CREATE WidgetType.
CREATE SELECTION-LIST widgetType.hHandle.
CREATE WidgetType.
CREATE SLIDER widgetType.hHandle.
CREATE WidgetType.
CREATE TEXT widgetType.hHandle.
CREATE WidgetType.
CREATE TOGGLE-BOX widgetType.hHandle.
CREATE WidgetType.
CREATE FRAME widgetType.hHandle.
CREATE WidgetType.
CREATE WINDOW widgetType.hHandle.


/* Uppercase all attribute labels of the WidgetAttributes group that correspond to
   4GL Widget Attributes */
FIND ryc_attribute_group WHERE ryc_attribute_group.attribute_group_name = "WidgetAttributes" NO-LOCK.
FIND admGroup WHERE admGroup.attribute_group_name = "AdmAttributes" NO-LOCK.


FOR EACH  ryc_attribute 
    WHERE ryc_attribute.attribute_group_obj = ryc_attribute_group.attribute_group_obj
    EXCLUSIVE-LOCK:

  /* Assume NOT a widget Attribute until proven otherwise */
  Is-A-Widget-Attr = NO.

  SEARCH-WIDGET-TYPES:
  FOR EACH widgetType:
     IF LOOKUP(ryc_attribute.attribute_label, LIST-SET-ATTRS(widgetType.hHandle)) > 0 THEN DO:
       ASSIGN Is-A-Widget-Attr = YES
              ryc_attribute.attribute_label = UPPER(ryc_attribute.attribute_label).
       LEAVE SEARCH-WIDGET-TYPES.
     END. /* IF found */
  END.  /* For each Widget Type */

  /* Handle a special cases where we want psuedo widget attributes to be treated the same way */
  /* Note: the above should identified Column and LABELS ... but didn't.  LABELS is read-only
           I'm not sure why Column wasn't identified.                                        */
  IF lookup(ryc_attribute.attribute_label, "Column,Enabled,IMAGE-FILE,LABELS") > 0 THEN
       ASSIGN Is-A-Widget-Attr = YES
              ryc_attribute.attribute_label = UPPER(ryc_attribute.attribute_label).

  /* Handle cases where we don't want to upper case the psuedo attribute but want it
     to still be grouped with field widgets */
  IF lookup(ryc_attribute.attribute_label, 
            "VisualizationType,Order,InitialValue,ShowPopup,LabelFGColor,LabelBGColor,LabelFont") > 0 THEN
       ASSIGN Is-A-Widget-Attr = YES.


  DataType = ?.
  /* Many attributes have the wrong datatype.  Fix this */
  /* Char = 1
     Date = 2
     Log  = 3
     Int  = 4
     Deci = 5 */
  CASE ryc_attribute.attribute_label:
      /* Should be Logicals */
      WHEN "ATTR-SPACE" OR
      WHEN "AUTO-COMPLETION" OR
      WHEN "AUTO-END-KEY" OR
      WHEN "AUTO-ENDKEY" OR
      WHEN "AUTO-GO" OR
      WHEN "AUTO-INDENT" OR
      WHEN "AUTO-RESIZE" OR
      WHEN "AUTO-RETURN" OR
      WHEN "AUTO-ZAP" OR
      WHEN "BLANK" OR
      WHEN "BOX" OR
      WHEN "CONVERT-3D-COLORS" OR
      WHEN "DEBLANK" OR
      WHEN "DEFAULT" OR
      WHEN "DISABLE-AUTO-ZAP" OR
      WHEN "DRAG-ENABLED" OR
      WHEN "DROP-TARGET" OR
      WHEN "DROPTARGET" OR
      WHEN "EDIT-CAN-UNDO" OR
      WHEN "FLAT-BUTTON" OR
      WHEN "HIDDEN" OR
      WHEN "MANUAL-HIGHLIGHT" OR
      WHEN "MODIFIED" OR
      WHEN "MOVABLE" OR
      WHEN "MULTIPLE" OR
      WHEN "NO-FOCUS" OR
      WHEN "NOLOOKUPS" OR
      WHEN "PROGRESS-SOURCE" OR
      WHEN "READ-ONLY" OR
      WHEN "RESIZABLE" OR
      WHEN "SCROLLBAR-HORIZONTAL" OR
      WHEN "SELECTABLE" OR
      WHEN "SELECTED" OR
      WHEN "SENSITIVE" OR
      WHEN "SORT" OR
      WHEN "TAB-STOP" OR
      WHEN "LARGE"
        THEN 
             ASSIGN DataType = 3
                    ryc_attribute.data_type = 3.

      /* Should be integer */
      WHEN "BGCOLOR" OR
      WHEN "BUFFER-CHARS" OR
      WHEN "BUFFER-LINES" OR
      WHEN "COLUMNNUMBER" OR
      WHEN "COLUMNS" OR
      WHEN "COLUMNSEQUENCE" OR
      WHEN "CONTEXT-HELP-ID" OR
      WHEN "CURSOR-CHAR" OR
      WHEN "CURSOR-LINE" OR
      WHEN "CURSOR-OFFSET" OR
      WHEN "DCOLOR" OR
      WHEN "CONVERT-3D-COLORS" OR
      WHEN "EDGE-CHARS" OR
      WHEN "FGCOLOR" OR
      WHEN "HEIGHT-PIXELS" OR
      WHEN "INNER-CHARS" OR
      WHEN "LABELBGCOLOR" OR
      WHEN "LABELFGCOLOR" OR
      WHEN "MAX-CHARS" OR
      WHEN "MENU-MOUSE" OR
      WHEN "PFCOLOR" OR
      WHEN "WIDTH-PIXELS" OR
      WHEN "X" OR
      WHEN "Y" OR
      WHEN "LINES" OR
      WHEN "CHARS"
        THEN 
          ASSIGN DataType = 4
                 ryc_attribute.data_type = 4.
  END CASE.
  /* If DataType = 3 then update all ryc_attribute_value records */
  IF DataType = 3 THEN DO:
    FOR EACH ryc_attribute_value WHERE 
             ryc_attribute_value.attribute_label = ryc_attribute.attribute_label
        EXCLUSIVE-LOCK:
       IF ryc_attribute_value.character_value BEGINS "Y" OR
          ryc_attribute_value.character_value BEGINS "T" THEN
           ASSIGN ryc_attribute_value.logical_value = YES
                  ryc_attribute_value.character_value = "".
       ELSE IF ryc_attribute_value.character_value BEGINS "N" OR
               ryc_attribute_value.character_value BEGINS "F" OR
               (ryc_attribute_value.character_value EQ "" AND 
                ryc_attribute_value.logical_value NE YES /* Done already */ ) OR
               ryc_attribute_value.character_value EQ ? THEN
           ASSIGN ryc_attribute_value.logical_value = NO
                  ryc_attribute_value.character_value = "".
    END.  /* FOR EACH logical value that needs to be converted */
  END. /* If a logical attribute got converted from character */

  ELSE IF DataType = 4 THEN DO:  /* Convert to INTEGER */
      FOR EACH ryc_attribute_value WHERE 
               ryc_attribute_value.attribute_label = ryc_attribute.attribute_label:
         IF ryc_attribute_value.character_value NE "" /* done already */  THEN
             ASSIGN ryc_attribute_value.integer_value = 
                       INTEGER(ryc_attribute_value.character_value)
                    ryc_attribute_value.character_value = "".
      END.  /* FOR EACH logical value that needs to be converted */
  END. /* If an integer value got converted */

  /* For now, move all attributes that aren't widget attributes to the 
     AdmAttributes group */
  IF NOT Is-A-Widget-Attr THEN
    ASSIGN ryc_attribute.attribute_group_obj = ADMGroup.attribute_group_obj.
END.  /* For each attribute in the widget attributes group */

/* Three attributes starting with IMAGE- (IMAGE-FILE, IMAGE-DOWN-FILE and 
   IMAGE-UP-FILE belonged to a non-existing group with attribute_group_obj
   of 0.000000000.  The code below assigns them to the WidgetAttribute Group */
FOR EACH ryc_attribute WHERE ryc_attribute.attribute_label BEGINS "IMAGE-":U:
  ASSIGN ryc_attribute.attribute_group_obj = ryc_attribute_group.attribute_group_obj.
END.

/* In V1 and early V2 objects had an attribute with label "widgetName".  Now 
   it should be switched to "NAME".                                        */
FOR EACH ryc_attribute_value WHERE ryc_attribute_value.attribute_label = "widgetName":

   FIND bAttrValue 
     WHERE bAttrValue.object_type_obj     = ryc_attribute_value.object_type_obj
       AND bAttrValue.smartobject_obj     = ryc_attribute_value.smartobject_obj
       AND bAttrValue.object_instance_obj = ryc_attribute_value.object_instance_obj
       AND bAttrValue.attribute_label     = "NAME":U
       AND bAttrValue.container_smartobject_obj = ryc_attribute_value.container_smartobject_obj
     NO-ERROR.

   IF NOT AVAILABLE(bAttrValue) THEN
   DO:
     ASSIGN
       ryc_attribute_value.attribute_label = "NAME":U
     .
   END.
   ELSE
   DO:
     ASSIGN
       bAttrValue.character_value = ryc_attribute_value.character_value
     .
     DELETE ryc_attribute_value.
   END.
END.

/** V1 DataFields have an attribute called FieldName which should also change
 *  to NAME.
 *  ----------------------------------------------------------------------- **/
FIND FIRST gsc_object_type WHERE
           gsc_object_type.object_type_code = "DataField":U 
           NO-LOCK NO-ERROR.
IF AVAILABLE gsc_object_type THEN
DO:    
    FOR EACH ryc_attribute_value WHERE
             ryc_attribute_value.object_type_obj = gsc_object_type.object_type_obj AND
             ryc_attribute_value.attribute_label = "FieldName":
        ASSIGN ryc_attribute_value.attribute_label = "NAME" NO-ERROR.
    END.
END.

/* In V1 and early V2 objects had an attribute with label "FieldOrder" or
   "TabOrder".  Now it should be switched to "Order".                    */
FOR EACH ryc_attribute_value 
    WHERE ryc_attribute_value.attribute_label = "fieldOrder"
    EXCLUSIVE-LOCK:
  FIND FIRST bryc_attribute_value
       WHERE bryc_attribute_value.object_type_obj           = ryc_attribute_value.object_type_obj          
       AND   bryc_attribute_value.container_smartobject_obj = ryc_attribute_value.container_smartobject_obj
       AND   bryc_attribute_value.smartobject_obj           = ryc_attribute_value.smartobject_obj          
       AND   bryc_attribute_value.object_instance_obj       = ryc_attribute_value.object_instance_obj      
       AND   bryc_attribute_value.attribute_label           = "Order" 
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE bryc_attribute_value THEN
    DELETE bryc_attribute_value.
   ryc_attribute_value.attribute_label = "Order".
END.

FOR EACH ryc_attribute_value WHERE ryc_attribute_value.attribute_label = "TabOrder":
  FIND FIRST bryc_attribute_value
       WHERE bryc_attribute_value.object_type_obj           = ryc_attribute_value.object_type_obj          
       AND   bryc_attribute_value.container_smartobject_obj = ryc_attribute_value.container_smartobject_obj
       AND   bryc_attribute_value.smartobject_obj           = ryc_attribute_value.smartobject_obj          
       AND   bryc_attribute_value.object_instance_obj       = ryc_attribute_value.object_instance_obj      
       AND   bryc_attribute_value.attribute_label           = "Order" 
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE bryc_attribute_value THEN
    DELETE bryc_attribute_value.
   ryc_attribute_value.attribute_label = "Order" NO-ERROR.
   /* There is some junk records to clean out.  These records are duplicates once the
      label change is made */
   IF ERROR-STATUS:ERROR AND ryc_attribute_value.integer_value = 0 THEN
       DELETE ryc_attribute_value.
END.

/* In V1 and early V2 objects had an attribute with label "NoLabel".  Now it 
   should be switched to "LABELS" and the sense switched.                  */
FOR EACH ryc_attribute_value WHERE ryc_attribute_value.attribute_label = "NoLabel":
  FIND FIRST bryc_attribute_value
       WHERE bryc_attribute_value.object_type_obj           = ryc_attribute_value.object_type_obj          
       AND   bryc_attribute_value.container_smartobject_obj = ryc_attribute_value.container_smartobject_obj
       AND   bryc_attribute_value.smartobject_obj           = ryc_attribute_value.smartobject_obj          
       AND   bryc_attribute_value.object_instance_obj       = ryc_attribute_value.object_instance_obj      
       AND   bryc_attribute_value.attribute_label           = "LABELS" 
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE bryc_attribute_value THEN
    DELETE bryc_attribute_value.
   ASSIGN ryc_attribute_value.attribute_label = "LABELS"
          ryc_attribute_value.logical_value   = NOT ryc_attribute_value.logical_value.
END.


/* In V1 and early V2 objects had an attribute with label "WORDWRAP".  Now it 
   should be switched to "WORD-WRAP".                                             */
FOR EACH ryc_attribute_value WHERE ryc_attribute_value.attribute_label = "WORDWRAP":
  FIND FIRST bryc_attribute_value
       WHERE bryc_attribute_value.object_type_obj           = ryc_attribute_value.object_type_obj          
       AND   bryc_attribute_value.container_smartobject_obj = ryc_attribute_value.container_smartobject_obj
       AND   bryc_attribute_value.smartobject_obj           = ryc_attribute_value.smartobject_obj          
       AND   bryc_attribute_value.object_instance_obj       = ryc_attribute_value.object_instance_obj      
       AND   bryc_attribute_value.attribute_label           = "WORD-WRAP" 
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE bryc_attribute_value THEN
    DELETE bryc_attribute_value.
   ryc_attribute_value.attribute_label = "WORD-WRAP".
END.

/* In V1 and early V2 objects had an attribute with label "DROPTARGET".  Now it 
   should be switched to "DROP-TARGET".                                             */
FOR EACH ryc_attribute_value WHERE ryc_attribute_value.attribute_label = "DROPTARGET":
  FIND FIRST bryc_attribute_value
       WHERE bryc_attribute_value.object_type_obj           = ryc_attribute_value.object_type_obj          
       AND   bryc_attribute_value.container_smartobject_obj = ryc_attribute_value.container_smartobject_obj
       AND   bryc_attribute_value.smartobject_obj           = ryc_attribute_value.smartobject_obj          
       AND   bryc_attribute_value.object_instance_obj       = ryc_attribute_value.object_instance_obj      
       AND   bryc_attribute_value.attribute_label           = "DROP-TARGET" 
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE bryc_attribute_value THEN
    DELETE bryc_attribute_value.
   ryc_attribute_value.attribute_label = "DROP-TARGET".
END.

/* This loop removes attributes that are no longer supported and should not be used.
   However, we only remove them if they are not being used, whether they should be 
   or not.                                                                          */
FOR EACH ryc_attribute WHERE CAN-DO(
     "DROPTARGET,FIELDORDER,MAXCHARS,NOLABEL,PROGRESSSOURCE,READONLY," +
     "RETURNINSERTED,SCROLLBARHORIZONTAL,SCROLLBARVERTICAL,TABORDER," +
     "WIDGETNAME,WORDWRAP", ryc_attribute.attribute_label):
    IF NOT CAN-FIND(FIRST ryc_attribute_value
                          WHERE ryc_attribute_value.attribute_label =
                                ryc_attribute.attribute_label) THEN
       DELETE ryc_attribute.
END.

                                              
                                                                       
