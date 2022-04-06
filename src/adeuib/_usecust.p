/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _usecust.p

Description:  Modify the Universal widget record based on the Custom Widget
              definition.
              
Input Parameters:
       pcCustom: Name of custom widget to draw.
       prUrecid: Recid of the target universal widget record.
       
Output Parameters:
   <None>

Author: Wm.T.Wood

Date Created: Feb. 11, 1994   

Modified: 
  WTWood 4/30/96 - Allow RUN xyz.p options.
                 - Ignore lines beginning with "/*" (until the first "*/"
                   is found.)
     GFS 4/18/98 - Fix situation when user specifies WIDTH-PIXELS or HEIGHT-PIXELS
                   and we don't match _prop
     tsm 4/07/99 - Added support for various Intl Numeric Formats (in addition to
                   American and European) by using session set-numeric-format method
                   to set format back to user's setting after setting it to American
     jep 8/08/00 - Assign _P recid to newly created _TRG records.
     jep 2/22/01 - Removed internal proc adecomm/_rsearch.p so the external
                   procedure adecomm/_rsearch.p is called.
-----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcCustom AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER prUrecid AS RECID NO-UNDO.

/* Standard Shared Variables */
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/custwidg.i}
{adeuib/property.i}
{adeuib/triggers.i}   /* Definition of Triggers TEMP-TABLE          */
{adeuib/sharvars.i}

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

/* Local Buffers */
DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_C FOR _C.
DEFINE BUFFER parent_P FOR _P.

DEFINE VARIABLE  lParentIsDynview  AS LOGICAL NO-UNDO.
DEFINE VARIABLE  isDynbrow         AS LOGICAL NO-UNDO.
DEFINE VARIABLE  isDynview         AS LOGICAL NO-UNDO.

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

/* Get the Universal Widget Record */
FIND _U WHERE RECID(_U) eq prUrecid.
FIND _L WHERE RECID(_L) eq _U._lo-recid.
FIND _F WHERE RECID(_F) eq _U._x-recid NO-ERROR.
FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE NO-ERROR.

/* If this is not a field level widget, then find the Container record. */
IF NOT AVAILABLE _F THEN DO:
  FIND _C WHERE RECID(_C) eq _U._x-recid.
  IF _C._q-recid NE ? THEN FIND _Q WHERE RECID(_Q) = _C._q-recid NO-ERROR.
END.

/* Get the parent records. (This is not used very often, perhaps only in
   buttons.  But find it anyway just to be safe).  */ 
FIND parent_U WHERE RECID(parent_U) eq _U._parent-recid.
FIND parent_C WHERE RECID(parent_C) eq parent_U._x-recid.
FIND parent_P WHERE parent_P._WINDOW-HANDLE = parent_U._WINDOW-HANDLE NO-ERROR.

/* save parent's object type */
ASSIGN lParentIsDynview = ( PARENT_P.OBJECT_type_code = "dynview":U).
/*Note that certain fields are not sensitized if not dynamic object*/
    isDynbrow =  (AVAILABLE _P AND _P.OBJECT_type_code = "DynBrow":U).
    isDynView =  (AVAILABLE _P AND _P.OBJECT_type_code = "DynView":U AND _U._type = "frame":U).
   
/* Get the customization record */
FIND _custom WHERE _custom._name eq pcCustom 
               AND _custom._type eq _U._TYPE NO-ERROR.
IF NOT AVAILABLE _custom 
THEN MESSAGE "Invalid Parameter passed to adeuib/_usecust.p:" pcCustom {&SKP}
             "This is an invalid custom name for objects of type:" _U._TYPE {&SKP}
             "This is an ADE/UIB bug resulting from a 4GL coding error."
              VIEW-AS ALERT-BOX ERROR.
ELSE RUN process-cst (INPUT _custom._attr).

RETURN.

/*************************** Internal Procedures ****************************/

/* ---------------------------------------------------------------------------
   process-cst: 
   
     Process list of lines of the form
       ATTRIBUTE VALUE <cr><lf>  
     This list is called: p_attr-list.
     
     For each line, get the Attribute Name and the TRIMMED value (trimming will
     remove any <cr> and any extra spaces.
     NOTE: i is incremented inside this loop if we get to a trigger block.
     In this case we look at all lines until an END TRIGGER section is found. 
   --------------------------------------------------------------------------- */
PROCEDURE process-cst:     
  DEFINE INPUT PARAMETER p_attr-list AS CHAR NO-UNDO.
 
  /* Local Variables */
  DEF VAR attr_name AS CHAR NO-UNDO.
  DEF VAR cCode AS CHAR     NO-UNDO.
  DEF VAR cLine AS CHAR     NO-UNDO.
  DEF VAR err_text AS CHAR  NO-UNDO.
  DEF VAR i AS INTEGER      NO-UNDO.
  DEF VAR iCount AS INTEGER NO-UNDO.
  DEF VAR idummy AS INTEGER NO-UNDO.
  
  /* Attribute Values -- by Datatype */ 
  DEF VAR cValue AS CHAR    NO-UNDO.
  DEF VAR dValue AS DECIMAL NO-UNDO.
  DEF VAR iValue AS INTEGER NO-UNDO.
  DEF VAR lValue AS LOGICAL NO-UNDO.
  
  iCount = NUM-ENTRIES(p_attr-list, CHR(10)).
  DO i = 1 TO iCount:
    ASSIGN cLine = ENTRY(i, p_attr-list, CHR(10)) /* Get the ith line */
           attr_name = ENTRY (1, cLine, " ":U)
           cValue = TRIM(SUBSTRING(cLine,LENGTH(attr_name) + 1))
           /* Reset the DATA-TYPEd versions of the attribute value to UNKNOWN.
              These will be set correctly later, but I want to set them to ?
              now in order to catch programming errors. (For example, I don't
              want to "forget" to assign iValue and end up using an outdated
              value). */
           lValue = ?
           iValue = ?
           dValue = ?.

    /* Now assign the attribute.  Handle the special cases first. */

    /* CASE 0: Blank Line --- just ignore it. */
    IF TRIM(cLine) eq "" THEN . /* Do nothing */    
    
    /* CASE 1: Comment Line --- look for first line containing "" */
    ELSE IF LEFT-TRIM(cLine) BEGINS "~/*":U THEN DO:  
      /* Look for close of comment. */
      DO WHILE R-INDEX(cLine, "*~/":U) eq 0 AND i < iCount:   
        ASSIGN i = i + 1 
               cLine = ENTRY(i, p_attr-list, CHR(10)) /* Get next line */
               .
      END.
    END.
    
    /* CASE 2: Recursively inherit from other other custom types */
    ELSE IF attr_name eq "INHERIT":U THEN DO:
      /* If this is a valid attribute to inherit, then inherit it recursively.*/
      IF CAN-FIND(_custom WHERE _custom._name eq cValue 
                            AND _custom._type eq _U._TYPE)
      THEN RUN adeuib/_usecust.p (cValue, prUrecid).
      ELSE MESSAGE "INHERIT Invalid: Custom Object" cValue SKIP
                   "cannot be applied to objects of type" _U._TYPE + "."
                   VIEW-AS ALERT-BOX ERROR.
    END.
    
    /* CASE 3: RUN another .p (and potentially recursively call this
               this procedure. */
    ELSE IF attr_name eq "RUN":U THEN DO:
      /* Strip off any trailing "." on the RUN statement.  This allows us to
         accept "RUN xyz.p." as well as "RUN xyz.p" [This would be a common 
         error for 4GL Programmers. */
      cValue = RIGHT-TRIM (RIGHT-TRIM(cValue), ".":U). 
      RUN adecomm/_rsearch.p (INPUT cValue, OUTPUT cValue).
      IF cValue ne ? THEN DO:  
        /* Pass in the Context ID and get back the new value. */  
        RUN VALUE(cValue) (INPUT INTEGER(prUrecid), OUTPUT cValue).
        IF cValue ne "":U 
        THEN RUN process-cst (INPUT cValue).
      END.
      ELSE MESSAGE "RUN Option Invalid:" cValue SKIP
                   "cannot be found to run." _U._TYPE + "."
                   VIEW-AS ALERT-BOX ERROR.
    END.
    
    /* CASE 4: Add a Trigger */
    ELSE IF attr_name eq "TRIGGER":U THEN DO:
      /* Create a trigger all the lines up to the next END TRIGGER line. */
      ASSIGN cCode = ""
             i     = i + 1 
             cLine = ENTRY(i, p_attr-list, CHR(10)). /* Get the ith line */
      DO WHILE TRIM(cLine) NE "END TRIGGER" AND i < iCount:
        ASSIGN cCode = cCode + cLine + CHR(10)
               i     = i + 1 
               cLine = ENTRY(i, p_attr-list, CHR(10)). /* Get the ith line */
      END.
      /* Did we go over the end w/o finding the END TRIGGER line? */
      IF TRIM(cLine) NE "END TRIGGER":U
      THEN MESSAGE "TRIGGER Invalid:" SKIP
                   "No END TRIGGER statement found for" cValue "event."
                   VIEW-AS ALERT-BOX ERROR.
      /* Is the event valid? (Note: we needed to go to the end of the
         code block anyway, even if the event was invalid, because we have
         to throw away the lines we cannot use).  */
      ELSE IF NOT VALID-EVENT(_U._HANDLE, cValue) /* _U._HANDLE CAN be ? */
      THEN MESSAGE "EVENT Invalid: " cValue SKIP
                   "This is not a valid event name."
                   VIEW-AS ALERT-BOX ERROR.
      ELSE DO:
         /* Make the trigger (or override any existing trigger). */
         FIND _TRG WHERE _TRG._tSECTION eq "_CONTROL":U
                     AND _TRG._tEVENT   eq cValue
                     AND _TRG._wRECID   eq RECID(_U)  NO-ERROR.
         IF NOT AVAILABLE _TRG THEN
         DO:
           CREATE _TRG.
           ASSIGN _TRG._pRECID   = (IF AVAIL(parent_P) THEN RECID(parent_P) ELSE ?)
                  _TRG._tSECTION = "_CONTROL":U
                  _TRG._tEVENT   = cValue
                  _TRG._tSPECIAL = ?
                  _TRG._wRECID   = RECID(_U).
         END.
         /* Assign the new code block */
         _TRG._tCODE    = cCode.
       END.
     END.
    
    /* CASE 3: Description (ignore this) */
    ELSE IF attr_name eq "DESCRIPTION":U THEN DO:
      /* Do nothing */
      END.
      
    /* CASE 5: Normal Attributes */
    ELSE DO:
      /* Use the Property Database (temp-table) to validate the attribute */
      
      FIND _prop WHERE _prop._custom AND attr_name = _prop._name NO-ERROR.
      /* Some attributes in the _prop file are abbreviated. So, the next FIND
       * uses BEGINS. Also, attr_name is reset below to take on the _prop value */
      IF NOT AVAILABLE _prop THEN DO:
        FIND _prop WHERE _prop._custom AND attr_name BEGINS _prop._name NO-ERROR.
        IF AMBIGUOUS _prop THEN DO:  
          /* This block fixes the situation when a user specifies either <something>-PIXELS
           * and we need to match _prop, which contains <something>-P (e.g. WIDTH-P). It's
           * AMBIGUOUS because _prop contains, for example, WIDTH and WIDTH-P.
           */
          IF LOOKUP("PIXELS":U, attr_name,"-":U) > 0 THEN DO:
            FIND _prop WHERE _prop._custom AND 
              REPLACE(attr_name,"-PIXELS":U,"-P":U) EQ _prop._name NO-ERROR.
          END.
        END.
        ELSE IF NOT AVAILABLE _prop THEN
          FIND _prop WHERE _prop._custom AND _prop._name BEGINS attr_name NO-ERROR.
      END.
      /* Is this a valid property for this type of widget */
      IF NOT AVAILABLE _prop OR NOT CAN-DO(_prop._widgets,_U._TYPE)
      THEN MESSAGE "Invalid Property:" attr_name SKIP
                   "This attribute does not apply to objects of type" _U._TYPE + "."
                   VIEW-AS ALERT-BOX ERROR.
      ELSE DO:
        /* If the value specified of the appropriate type. */
        ASSIGN attr_name = _prop._name
                err_text = "".
        CASE _prop._data-type:
          WHEN "L":U THEN DO:
            idummy = LOOKUP(cValue,"on,yes,true,c,char,character,off,no,false,p,pixel":U). /* refs to char and pixel are for LAYOUT-UNIT */
            IF idummy eq 0 THEN err_text = "integer":U.
            ELSE lValue = (idummy <= 6).  /* on, yes, or true */
          END.
          WHEN "D":U THEN DO:
            /* Before converting, make sure everthing is in American format */
            cValue = REPLACE(cValue, SESSION:NUMERIC-DECIMAL-POINT, ".":U).
            SESSION:NUMERIC-FORMAT = "AMERICAN":U.
            ASSIGN dValue = DECIMAL (cValue) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN err_text = "decimal".
            SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
          END.
          WHEN "I":U THEN DO:
            ASSIGN iValue = INTEGER (cValue) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN err_text = "decimal".
          END.
        END CASE.
        IF err_text NE "" 
        THEN MESSAGE "Invalid Attribute Value:" cValue SKIP
                     "Attribute" _prop._name "must be of type" err_text + "."
                     VIEW-AS ALERT-BOX ERROR.
        ELSE DO: 
          /* If we got here, then we have a valid attribute name, a valid
             attribute value and can map it into the Universal Widget Record.
             Note that err_text may be set internally here.  If so, then report
             the error. */
          CASE attr_name:
            { adeuib/custprop.i }
            OTHERWISE MESSAGE 
             "Unexpected Attribute used in adeuib/_usecust.p:" attr_name SKIP
             "This attribute should have been handled in a CASE statement." {&SKP}
             "This is an ADE/UIB bug resulting from a 4GL coding error."
              VIEW-AS ALERT-BOX ERROR.       
          END CASE.
          /* Was there an error? */
          IF err_text NE "" 
          THEN MESSAGE "Invalid Attribute Value:" cValue SKIP err_text
                       VIEW-AS ALERT-BOX ERROR.
        END. /* If valid data-type        */
      END. /* If valid attribute name   */
    END. /* CASE 5: Normal Attributes */
  END. /* DO i = 1 TO NUM-ENTRIES.. */
END PROCEDURE. /* process-cst */
