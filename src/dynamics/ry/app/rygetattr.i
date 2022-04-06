/* ry/app/rygetattr.i - Get Object Attribute - Used by B2B UI Manager (ry/app/ryuimsrvrp.p)
     Usage: {ry/app/rygetattr.i ghObjectBuffer 'attrName' cOutVar}
     where ghObjectBuffer is the handle to the return_Object tt that must already be positioned 
                          on the record for the object you are referring to
           'attrName'     is the attribute name you want to get the value of
           cOutVar        is the variable that the attribute value will be put into
                          If the attribute does not exist then this will be set to ?. 
    Requires the following variables (in ry/app/rygetattrvars.i):
      DEFINE VARIABLE hGetAttrAttrBuf AS HANDLE NO-UNDO.
      DEFINE VARIABLE hGetAttrFldBuf AS HANDLE NO-UNDO.
      DEFINE VARIABLE dGetAttrRecId AS DEC NO-UNDO.
    These are required because chained attributes do not currently support buffer-value as a handle
    eg
      {1}:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE:AVAILABLE
*/
  ASSIGN
    hGetAttrAttrBuf = {1}:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
    dGetAttrRecId   = {1}:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
    {3}             = ?.
  hGetAttrAttrBuf:FIND-FIRST(" WHERE ":U + hGetAttrAttrBuf:NAME + ".tRecordIdentifier = " + STRING(dGetAttrRecId)) NO-ERROR.
  IF hGetAttrAttrBuf:AVAILABLE THEN
  DO:
    ASSIGN hGetAttrFldBuf = hGetAttrAttrBuf:BUFFER-FIELD({2}) NO-ERROR.
    IF VALID-HANDLE(hGetAttrFldBuf) THEN
      {3} = hGetAttrFldBuf:BUFFER-VALUE.
  END.

/*** This is the ideal code for this as it does not require any variable to be defined.
     But causes error: Lead attributes in a chained-attribute expression (a:b:c) must be handles. (10068)
     However there is more overhead as it has to determine the handles each time, ie the above code is quicker.
 {3} = ?.
 widget-handle({1}:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE):FIND-FIRST(" WHERE ":U + {1}:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE:NAME + ".tRecordIdentifier = " + {1}:BUFFER-FIELD("tRecordIdentifier":U):STRING-VALUE) NO-ERROR.
  IF {1}:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE:AVAILABLE THEN
    IF VALID-HANDLE({1}:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE:BUFFER-FIELD({2})) THEN
      {3} = {1}:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE:BUFFER-FIELD({2}):BUFFER-VALUE.
***/