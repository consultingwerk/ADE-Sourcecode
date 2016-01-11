/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _rdcont.p

Description:
    Reads the contents of a _CREATE-DYNAMIC section in a UIB-generated .w file.
    This procedure creates (and realizes) all (OCX) Control Frames.

Note:
    Called from _gen4gl.p when it finds a "adm-create-objects" method.
    The object

Input Parameters:
    ph_win: Window handle of the associated .w being read in.

Output Parameters:
   <None>

Author: Wm.T.Wood


Date Created:  1995
Date Modified:  
  02/02/01 alex - fixed issue 469 (SCC_bug 20000811-014) 
  06/07/99 tsm  - added CONTEXT-HELP-ID attribute
  02/10/98 gfs  - added support for NO-TAB-STOP
  12/19/96 gfs  - ported for use with OCX's
---------------------------------------------------------------------------- */
DEFINE INPUT PARAMETER ph_win     AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER importMode AS CHARACTER     NO-UNDO.

{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/layout.i}       /* multi-layout information                          */
{adeuib/name-rec.i}     /* Name indirection table                            */
{adeuib/sharvars.i}     /* Shared variables                                  */
{adecomm/adefext.i}


DEFINE SHARED VAR OCX-Tab-Info   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cur-lo           AS CHARACTER NO-UNDO.
DEFINE VARIABLE file-name        AS CHARACTER NO-UNDO.
DEFINE VARIABLE i                AS INTEGER   NO-UNDO.
DEFINE VARIABLE old-adm          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE var-name         AS CHARACTER NO-UNDO.
DEFINE VARIABLE fr-name          AS CHARACTER NO-UNDO.
DEFINE VARIABLE s                AS INTEGER   NO-UNDO.
DEFINE VARIABLE ok               AS LOGICAL   NO-UNDO.
DEFINE VARIABLE loadedFromBinary AS LOGICAL   NO-UNDO.
DEFINE VARIABLE ParentHWND       AS INTEGER   NO-UNDO.

/* Names TT keeps track of old and newly generated name */
DEFINE TEMP-TABLE Names 
  FIELD oldname AS CHARACTER
  FIELD newname AS CHARACTER.
  
/* Standard End-of-line character */
&Scoped-define EOL &IF "{&WINDOW-SYSTEM}":U <> "OSF/Motif":U &THEN "~r":U + &ENDIF CHR(10)

/* If we ever get to the END then we have come too far. */
&Scoped-define END-CONDITION (_inp_line[2] eq "End":U AND _inp_line[4] eq "_CREATE-DYNAMIC":U)

/* Use this to turn debugging on after each line that is read in. 
   (i.e. rename no-DEBUG  to DEBUG) */
&Scoped-define no-debug message "[1] "_inp_line[1] " [2] "_inp_line[2] " [3] "_inp_line[3] _inp_line[4] _inp_line[5] .


DEFINE SHARED STREAM   _P_QS.
DEFINE SHARED VARIABLE _inp_line  AS CHARACTER NO-UNDO EXTENT 100.
DEFINE SHARED VARIABLE VbxChoice  AS CHARACTER NO-UNDO. /* new in _qssuckr.p */

DEFINE VARIABLE junk       AS CHARACTER NO-UNDO.
DEFINE VARIABLE wName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE fName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE par-rec    AS RECID     NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.
DEFINE BUFFER tab_U    FOR _U.

/* Get the current procedure file */
FIND _P WHERE _P._WINDOW-HANDLE eq ph_win.

/* Process WRX files for OCXs. */
IF OPSYS = "WIN32":u THEN
DO:
    /*
     * Is this a read from a file or clipboard operation.
     * The location of the file will be different. 
     */
    
    IF importMode = "WINDOW":U THEN DO:
        /*
         * Create the default name for the binary file. If one is found in
         * the .w file then fName will be changed. The location of the 
         * binary file is before first control definition. 
         */

        RUN adecomm/_osprefx.p (INPUT _P._save-as-file, OUTPUT junk, OUTPUT wName).
    
        ASSIGN
          fName = substr(wName, 1, r-index(wName, ".":u) - 1) + {&STD_EXT_UIB_WVX} .

        /*
         * Check to see if we can find the file on the PROPATH.
         * If the file isn't there then the user has provided 
         * us with a name that isn't on the PROPATH. It may be
         * relative, or absolute.  
         *
         * At this time, we don't know if there is a non-default
         * location for the binary file. All this work was done
         * try to create the default filename of the binary
         */
         
        IF SEARCH(fName) = ? THEN DO:
            /* Name not on PROPATH. Take the name as given. */
             
            ASSIGN
                fName = substr(_P._save-as-file, 1, r-index(_P._save-as-file, ".":u) - 1)
                      + {&STD_EXT_UIB_WVX} .
        END.
    END.
    ELSE DO:
        IF _control_cb_op THEN
            ASSIGN fName = _control_cut_file.
        ELSE DO:
            RUN adecomm/_osprefx.p (INPUT _save_file, OUTPUT junk, OUTPUT wName).
    
            ASSIGN
                fName = substr(wName, 1, r-index(wName, ".":u) - 1) + {&STD_EXT_UIB_WVX}
                fName = junk + fName .
        END.
    END.

    /* Can we find the file? */
    ASSIGN fName = SEARCH(fName).
        
END.
              
/* Repeat the following block for each page in the case statement */
READ-SECTION:
REPEAT:

  ASSIGN _inp_line = "":U.
  IMPORT STREAM _P_QS _inp_line. {&debug}
  /* It is an error if we get into another section */
  IF _inp_line[1] BEGINS "_":U THEN DO:
    RUN error-msg ("Unexpected new section found while processing {&WT-CONTROL} section.") .
    RETURN.  
  END.
  
  /* We stop processing when we reach the END of _CREATE-DYNAMIC. */
  IF {&END-CONDITION} THEN LEAVE READ-SECTION.

  /* Are we migrating a VBX to OCX? */
  IF _inp_line[1] eq "CREATE":U and _inp_line[2] eq "{&WVT-CONTAINER}":U THEN
  DO:
    /* Overwrite type with OCX type to allow for correct reading. */
    ASSIGN _inp_line[2] = "{&WT-CONTAINER}".
    ASSIGN var-name     = _inp_line[3].
    
    /* Ask the first VBX-OCX migration question via VBX Advisor.
       Because of how we read the file, we take no action until later during the
       reading process. Except we can process if user chooses to cancel load. */
    IF VbxChoice = "_VBX-1":U THEN
    DO:
        RUN adeuib/_vbxadvs.p
          (INPUT _h_win, INPUT "_VBX-1":U, INPUT var-name, OUTPUT VbxChoice).
        IF VbxChoice = "_CANCEL":U THEN RETURN "_ABORT":U.
    END.
  END.

  IF _inp_line[1] eq "CREATE":U and _inp_line[2] eq "{&WT-CONTAINER}":U THEN DO:
    /* The next item should be the variable name */
    var-name = _inp_line[3]. 
  
    /* The next line(s) should be the container attributes (of the form).
       NOTE that FRAME must be the first item.
             FRAME  = FRAME xxx:HANDLE
             attribute = value
             SENSITIVE = no.   <<<< this will be the last line  
     */ 
    _inp_line = "":U.
    IMPORT STREAM _P_QS _inp_line. {&debug}
    IF _inp_line[1] ne "FRAME" THEN DO:
      RUN error-msg ("The first attribute should be FRAME for " + var-name + ".").
      RETURN. 
    END.
    ELSE DO:
      /* Get the frame name out of "FRAME = name:HANDLE" */
      
      fr-name = ENTRY(1, _inp_line[4], ":":U) . 
      
      FIND _NAME-REC WHERE _NAME-REC._wNAME   = fr-name
                       AND (   _NAME-REC._wTYPE   = "FRAME":U
                            OR _NAME-REC._wTYPE   = "DIALOG-BOX":U)
                       NO-ERROR.
                       
      
      IF AVAILABLE _NAME-REC THEN DO:
         FIND parent_U WHERE RECID(parent_U) = _NAME-REC._wRECID.
      END.
      ELSE DO:
      
          /*
           * If we couldn't find the frame rec then try to create
           * the container/control in the current frame. This
           * will happen for cut/copy/paste situations.
           */
          find parent_U where parent_U._HANDLE = _h_frame no-error.
          if not available parent_U then do:
              RUN error-msg ("No parent frame exists for FRAME " + fr-name + ".") . 
              RETURN.
          end.     
      END.

      /* 
       * At this point we can create the _U records -- the code read in is
       * for the Master Layout. 
       */
      ASSIGN cur-lo  = "Master Layout":U
             par-rec = RECID(parent_U).
      FIND parent_L WHERE parent_L._u-recid eq par-rec
                      AND parent_L._LO-NAME eq cur-lo.

      /* We now have enough to create a universal widget record.
         Create the record and populate it as much as possible. */
      CREATE _U.
      CREATE _F.
      CREATE _L.
      CREATE _NAME-REC.
   
      ASSIGN /* TYPE-specific settings */
             _U._TYPE          = "{&WT-CONTROL}"
             /* Standard Settings for Universal and Field records */
             { adeuib/std_uf.i &SECTION = "DRAW-SETUP" }
             /* Widget Handles are NEVER displayed or enabled */
             _U._ENABLE        = NO
             _U._DISPLAY       = NO
             _F._VBX-BINARY    = fName + "," + var-name
             _NAME-REC._wTYPE  = _U._TYPE
             _NAME-REC._wRECID = RECID(_U)
             _NAME-REC._WFRAME = fr-name
             .
      
      /* Make sure the name is unique. */
      assign 
          _NAME-REC._wNAME  = var-name
          _U._WINDOW-HANDLE = parent_U._WINDOW-HANDLE /* assures bstname will work */
       .
      VALIDATE _NAME-REC.
      /* Make sure the name doesn't exist already */
      RUN adeshar/_bstname.p
              (_NAME-REC._wNAME, ?, "", 0, _P._WINDOW-HANDLE, OUTPUT _U._NAME).
      
      CREATE Names.
      ASSIGN Names.oldname = _NAME-REC._wNAME
             Names.newname = _U._NAME.
                           
    END. /* IF...FRAME... */
    PROCESS-CONTAINER:
    REPEAT:
      /* Process the container until we get to the SENSITIVE attribute */
      _inp_line = "":U.
      IMPORT STREAM _P_QS _inp_line. {&debug}

      CASE _inp_line[1]:

        WHEN "CREATE":U THEN DO:
          /* Whoops! We aren't expecting a CREATE here */
          RUN error-msg (
            "Tried to CREATE a new object while reading attributes for " +
            var-name + ".") . 
          RETURN.
        END.
        WHEN "HELP":U THEN DO:
          ASSIGN _U._HELP = _inp_line[3] NO-ERROR.
          IF ERROR-STATUS:ERROR 
          THEN RUN error-msg ("Could not parse HELP for object.") .
        END.
        WHEN "PRIVATE-DATA":U THEN DO:
          ASSIGN _U._PRIVATE-DATA = _inp_line[3] NO-ERROR.
          IF ERROR-STATUS:ERROR 
          THEN RUN error-msg ("Could not parse PRIVATE-DATA for object.") .
          ELSE
          DO:
             IF _inp_line[4] <> "":U THEN
             ASSIGN _U._PRIVATE-DATA-ATTR = LEFT-TRIM(_inp_line[4],":":U).
          END.
        END.
        WHEN "SENSITIVE":U THEN DO:        
          ASSIGN _U._SENSITIVE = _inp_line[3] begins "Y":U NO-ERROR.
          IF ERROR-STATUS:ERROR 
          THEN RUN error-msg ("Could not parse SENSITIVE for object.") .
                    
          /*
           * THe PRogress attrs are complete!
           */           
          IF LENGTH(_inp_line[3],"CHARACTER") eq INDEX(_inp_line[3],".":U)
            THEN LEAVE PROCESS-CONTAINER.
        END.
        WHEN "HIDDEN":U THEN DO:
          ASSIGN _U._HIDDEN = _inp_line[3] begins "Y":U NO-ERROR.
          IF ERROR-STATUS:ERROR 
          THEN RUN error-msg ("Could not parse HIDDEN for object.") .
        END.
        WHEN "VISIBLE":U THEN DO:    
          ASSIGN _L._REMOVE-FROM-LAYOUT = _inp_line[3] begins "N":U NO-ERROR.
          IF ERROR-STATUS:ERROR 
          THEN RUN error-msg ("Could not parse VISIBLE for object.") .
        END.
        WHEN "BGCOLOR":U THEN DO:
          ASSIGN _L._BGCOLOR = DECIMAL(_inp_line[3]) NO-ERROR.
          IF ERROR-STATUS:ERROR 
          THEN RUN error-msg ("Could not parse BGCOLOR for object.") .
        END. 
        WHEN "ROW":U THEN DO:
          ASSIGN _L._ROW = DECIMAL(_inp_line[3]) NO-ERROR.
          IF ERROR-STATUS:ERROR 
          THEN RUN error-msg ("Could not parse ROW for object.") .
        END. 
        WHEN "COLUMN":U THEN DO:
          ASSIGN _L._COL = DECIMAL(_inp_line[3]) NO-ERROR.
          IF ERROR-STATUS:ERROR 
          THEN RUN error-msg ("Could not parse COLUMN for object.") .
        END. 
        WHEN "HEIGHT":U THEN DO:
          ASSIGN _L._HEIGHT = DECIMAL(_inp_line[3]) NO-ERROR.
          IF ERROR-STATUS:ERROR 
          THEN RUN error-msg ("Could not parse HEIGHT for object.") .
        END. 
        WHEN "WIDTH":U THEN DO:
          ASSIGN _L._WIDTH = DECIMAL(_inp_line[3]) NO-ERROR.
          IF ERROR-STATUS:ERROR 
          THEN RUN error-msg ("Could not parse WIDTH for object.") .
          IF _inp_line[4] = "." THEN LEAVE PROCESS-CONTAINER.
        END. 
        WHEN "TAB-STOP":U THEN DO:
          ASSIGN _U._NO-TAB-STOP = NOT _inp_line[3] begins "Y":U NO-ERROR.
          IF ERROR-STATUS:ERROR 
          THEN RUN error-msg ("Could not parse NO-TAB-STOP for object.") .
        END.
        WHEN "CONTEXT-HELP-ID":U THEN DO:
          ASSIGN _U._CONTEXT-HELP-ID = INTEGER(_inp_line[3]) NO-ERROR.
          IF ERROR-STATUS:ERROR
          THEN RUN error-msg ("Could not parse CONTEXT-HELP-ID for object.") .
        END.
        WHEN "WIDGET-ID":U THEN DO:
          ASSIGN _U._WIDGET-ID = INTEGER(_inp_line[3]) NO-ERROR.
          IF ERROR-STATUS:ERROR
          THEN RUN error-msg ("Could not parse WIDGET-ID for object.") .
        END.
      END CASE. 
    END. /* PROCESS-CONTAINER: REPEAT... */ 
          
    /*
     * All the Master Layout information has been read in.
     * Create multiple layout records if necessary.
     * Then set the _L for the current layout (instead of the
     * Master Layout.
     */   
    {adeuib/crt_mult.i}
    FIND _L WHERE RECID(_L) = _U._lo-recid.

  END. /* IF...CREATE... */
  ELSE IF _inp_line[2] = "=" AND _inp_line[4] = ":U" AND
          _inp_line[5] = "." AND _inp_line[1] MATCHES "*:NAME" THEN DO:
    /* We have found the assignment statement that names a control frame.
       We now need to reset the value of par-rec because we have lost the
       correct value if there are multiple control-frames in multiple frames */
    FIND FIRST _NAME-REC WHERE
               _NAME-REC._wNAME = ENTRY(1, _inp_line[1], ":":U) AND
               _NAME-REC._wTYPE = "{&WT-CONTROL}" NO-ERROR.
    IF AVAILABLE _NAME-REC THEN DO:
      fr-name = _NAME-REC._wFRAME.
      FIND _NAME-REC WHERE _NAME-REC._wNAME   = fr-name
                       AND (   _NAME-REC._wTYPE   = "FRAME":U
                            OR _NAME-REC._wTYPE   = "DIALOG-BOX":U)
                       NO-ERROR.
      IF AVAILABLE _NAME-REC THEN DO:
         FIND parent_U WHERE RECID(parent_U) = _NAME-REC._wRECID.
         par-rec = RECID(parent_U).
      END.  /* We have the parent frame (or dialog) */
    END.
  END.  /* If we have found the control frame name assignment */
  ELSE IF INDEX(_inp_line[3], ":":U) > 0 THEN DO:
  
      DEFINE VARIABLE attrToken    AS CHARACTER NO-UNDO.
      DEFINE VARIABLE propertyType AS CHARACTER NO-UNDO.
      DEFINE VARIABLE lookAhead    AS CHARACTER NO-UNDO INITIAL "":U.
      DEFINE VARIABLE good-stuff   AS CHARACTER NO-UNDO.
      DEFINE VARIABLE this-tab     AS INTEGER   NO-UNDO.
      DEFINE VARIABLE widget-name  AS CHARACTER NO-UNDO.
      /*
       * Process the runtime attributes of the container/control
       */
       
      ASSIGN attrToken = ENTRY(2, _inp_line[3], ":":U).

      CASE attrToken:
          WHEN "CREATE-CONTROL":U THEN DO:
             /* With multiple OCX's need to refind the _U record */
             FIND FIRST _U WHERE _U._NAME = _inp_line[2] AND
                                 _U._HANDLE = ? AND
                                 _U._TYPE = "{&WT-CONTROL}" AND
                                 _U._PARENT-RECID = par-rec NO-ERROR.
             IF NOT AVAILABLE _U THEN DO: /* Duplicating an OCX here */
               FIND Names WHERE Names.oldname = _inp_line[2] NO-ERROR.
               IF AVAILABLE Names THEN ASSIGN _inp_line[2] = Names.newname.
               FIND FIRST _U WHERE _U._NAME BEGINS _inp_line[2] AND
                                   _U._HANDLE = ? AND
                                   _U._TYPE = "{&WT-CONTROL}" AND
                                   _U._PARENT-RECID = par-rec.
             END.
             FIND _F WHERE RECID(_F) = _U._x-recid.   
                    
             /* If user is migrating VBX to OCX, then _undcont.p will create the OCX
                and the _SUBTYPE and _IMAGE-FILE values will be overwritten with the
                new OCX values, where _SUBTYPE is com:ShortName and _IMAGE-FILE is
                com:ClassID. - jep 1/22/97 */
              ASSIGN
                 _U._SUBTYPE    = _inp_line[7]
                 _U._OCX-NAME   = _inp_line[7]
                 _U._LABEL      = _inp_line[7]
                 _F._IMAGE-FILE = _inp_line[5] .
             
             /* Handle migration of VBX to OCX. */
              RUN VbxMigrate.
              IF RETURN-VALUE = "_ABORT":U THEN RETURN "_ABORT":U.

             /* Got all the information needed to realize the control. */
              RUN realize-object.

             /* In VBX-OCX Migration, user may have chosen to delete VBX. We mark this in the
                _TYPE field with the "_DELETE-" prefix. _qssuckr.p does the actual delete.*/
              IF VbxChoice BEGINS "_DELETE":U THEN
              DO:
                ASSIGN _U._TYPE = "_DELETE-" + _U._TYPE.
                /* If single delete, force back to _REPLACE-AUTO to process any remaining VBXs. */
                IF VbxChoice = "_DELETE":U THEN
                  ASSIGN VbxChoice = "_REPLACE-AUTO":U.
              END.

             /* The vbx-binary field has served it purpose for the read. Reset it
              * so that it is never deleted accidently. */
              IF AVAILABLE(_F) THEN ASSIGN _F._VBX-BINARY = ?.

          END. /* CREATE-CONTROL */
          WHEN "FILENAME":U THEN DO:
              ASSIGN _P._VBX-FILE = _inp_line[5]
                     fName        = _P._VBX-FILE .
          END.  /* FILENAME */
      END. /* CASE */
  END.  /* IF INDEX(_inp_line[3], ":":U) > 0  */

  ELSE IF _inp_line[1] = "RUN":U AND
          (_inp_line[2] eq "adjust-tab-order":U OR _inp_line[2] eq "adjustTabOrder")
       THEN DO:
    /* Adjusting the tab order against a SMo anchor, unfortunately SMO's have not
       yet been read in, so we have to store this info in OCX-Tab-Info and set 
       the tab order in _rdsmar.p after we have read the SMO's.                */
    old-adm = (_inp_line[2] eq "adjust-tab-order").
    FIND _U WHERE _U._NAME = _inp_line[IF old-adm THEN 8 ELSE 6] AND
                  _U._TYPE eq "{&WT-CONTROL}":U AND
                  _U._PARENT-RECID = par-rec NO-ERROR.
    IF AVAILABLE _U THEN DO: /* We have the Control Frame _U */
      OCX-Tab-Info = (IF OCX-Tab-Info eq ? THEN "" ELSE
                     OCX-Tab-Info + CHR(4)) +
                     _inp_line[IF old-adm THEN 6 ELSE 4] + ",":U +
                     STRING(RECID(_U)) + ",":U +
                     IF _inp_line[IF old-adm THEN 10 ELSE 8] BEGINS "'BEFORE'":U
                     THEN "BEFORE":U ELSE "AFTER":U.
    END.  /* We have the Control Frame _U */
  END.  /* Adjusting the tab order */

  ELSE IF NUM-ENTRIES(_inp_line[1],":":U) > 1 AND
       ENTRY(2,_inp_line[1], ":":U) BEGINS "MOVE-":U THEN DO:
    FIND _U WHERE _U._NAME = ENTRY(1,_inp_line[1],":":U) AND
                  _U._TYPE eq "{&WT-CONTROL}":U AND
                  _U._PARENT-RECID = par-rec NO-ERROR.
    IF AVAILABLE _U THEN DO:
      ASSIGN good-stuff = ENTRY(2, _inp_line[1], ":":U)
      /* good-stuff is "MOVE-AFTER(WIDGET-NAME" or "MOVE-BEFORE(WIDGET-NAME" or
                       "MOVE-AFTER(ControlName)." or "MOVE-BEFORE(ControlName)." in
                       "CtrlFrame:MOVE-AFTER(WIDGET-NAME:HANDLE)."
                              ** OR **
                       "CtrlFrame:MOVE-AFTER(ControlName)."
                              ** OR **
                       "MOVE-AFTER(FRAME" or "MOVE-BEFORE(FRAME" in
                       "CtrlFrame:MOVE-AFTER(FRAME frame-name:HANDLE)."    */
             widget-name = ENTRY(2, good-stuff, "(":U)
             widget-name = IF widget-name = "FRAME":U
                            THEN ENTRY(1, _inp_line[2], ":":U)
                            ELSE widget-name
             widget-name = IF NUM-ENTRIES(widget-name,")":U) = 2
                            THEN ENTRY(1, widget-name, ")":U)
                            ELSE widget-name.

      IF ENTRY(1, good-stuff, "(":U) = "MOVE-AFTER":U THEN DO:
        /* OCX-Tab-Info NE ? then at least one OCX is anchored to a  SMO.
           We must process them in sequence ot the TAB order will be screwed
           up.  Therefore, this OCX (and all subsequent OCX's) will have their
           tab order stored in OCX-Tab-Info and they will be processed later
           in _rdsmar.p                                                     */
        IF OCX-Tab-Info ne ? THEN DO:
          IF AVAILABLE _U THEN DO: /* We have the Control Frame _U */
            OCX-Tab-Info = OCX-Tab-Info + CHR(4) + widget-name + ",":U +
                           STRING(RECID(_U)) + ",BEFORE":U.
          END.  /* We have the Control Frame _U */
        END. /* If storing info in OCX-TAb-Info */
        ELSE DO: /* Process right now */
          IF NUM-ENTRIES(widget-name,".":U) = 1 THEN
            FIND FIRST tab_U WHERE tab_U._PARENT-RECID = par-rec AND
                                   tab_U._NAME         = widget-name
                             NO-ERROR.
          ELSE IF NUM-ENTRIES(widget-name,".":U) = 2 THEN
            FIND FIRST tab_U WHERE tab_U._PARENT-RECID = par-rec AND
                                   tab_U._TABLE        = ENTRY(1,widget-name,".":U) AND
                                   tab_U._NAME         = ENTRY(2,widget-name,".":U)
                           NO-ERROR.
          ELSE IF NUM-ENTRIES(widget-name,".":U) = 3 THEN
            FIND FIRST tab_U WHERE tab_U._PARENT-RECID = par-rec AND
                                   tab_U._DBNAME       = ENTRY(1,widget-name,".":U) AND
                                   tab_U._TABLE        = ENTRY(2,widget-name,".":U) AND
                                   tab_U._NAME         = ENTRY(3,widget-name,".":U)
                           NO-ERROR.          
          IF AVAILABLE tab_U THEN DO:
            this-tab = tab_U._TAB-ORDER + 1.
            FOR EACH tab_U WHERE tab_U._PARENT-RECID = par-rec AND
                                 tab_U._TAB-ORDER >= this-tab
                           BY tab_U._TAB-ORDER DESCENDING:
              tab_U._TAB-ORDER = tab_U._TAB-ORDER + 1.
            END.
            _U._TAB-ORDER = this-tab.
          END.  /* If found the widget before this control */
        END.  /* Else do process right now */
      END. /* If MOVE-AFTER */
      ELSE DO:  /* MOVE BEFORE */
        IF OCX-Tab-Info ne ? THEN DO: /* Store this for later processing */
          IF AVAILABLE _U THEN DO: /* We have the Control Frame _U */
            OCX-Tab-Info = OCX-Tab-Info + CHR(4) + widget-name + ",":U +
                           STRING(RECID(_U)) + ",AFTER":U.
          END.  /* We have the Control Frame _U */
        END. /* If storing info in OCX-TAb-Info */
        ELSE DO: /* Process right now */
          FOR EACH tab_U WHERE tab_U._PARENT-RECID = par-rec AND
                               tab_U._TAB-ORDER >= 1
                       BY tab_U._TAB-ORDER DESCENDING:
            tab_U._TAB-ORDER = tab_U._TAB-ORDER + 1.
          END.
          _U._TAB-ORDER = 1.
        END. /* Processing right now */
      END. /* If MOVE-BEFORE */
    END. /* IF MOVE-AFTER or MOVE-BEFORE */
  END.  /* If can find the OCX */
END.  /* READ-SECTION */


/* ************************* Internal Procedures ************************* */


/* If there is a valid _U and _F record, and it hasn't been realized, then
   recreate the object. */
PROCEDURE realize-object:
  /* Debugging:
   * MESSAGE "Realize" _U._NAME _L._ROW _L._COL _F._IMAGE-FILE. */
  IF AVAILABLE (_U) AND AVAILABLE (_F) THEN
  DO:
    RUN adeuib/_undcont.p (RECID(_U)).
    /* If there is a problem then clean up. Actual delete done by _qssuckr.p. */
    IF _F._SPECIAL-DATA <> ? THEN
      ASSIGN _U._TYPE = "_DELETE-" + _U._TYPE.
  END.
END PROCEDURE.

/* Handles migrating VBX's to OCX's. */
PROCEDURE VbxMigrate.

  DEFINE VAR CanMigrate   AS LOGICAL   NO-UNDO.
  DEFINE VAR VbxMsg       AS CHARACTER NO-UNDO.
  DEFINE VAR OcxClassID   AS CHARACTER NO-UNDO.
  DEFINE VAR OcxShortName AS CHARACTER NO-UNDO.
  
  /* Signifies no VBX's are being processed. */
  IF VbxChoice BEGINS "_VBX":U THEN RETURN.
  
  IF VbxChoice = "_REPLACE-AUTO":U THEN
  DO:
    /* Use VB.INI to get ClassID and Shortname of OCX that is proper
       replacement of VBX. */
    ASSIGN OcxClassID   = _F._IMAGE-FILE  /* VBX File Name  */
           OcxShortName = _U._SUBTYPE.    /* VBX Type       */
           
    RUN adeuib/_vbini.p
      (INPUT-OUTPUT OcxClassID    /* IN: VBX File; OUT: OCX ClassID   */,
       INPUT-OUTPUT OcxShortName  /* IN: VBX Type; OUT: OCX ShortName */,
       OUTPUT CanMigrate,
       OUTPUT VbxMsg).

    IF CanMigrate THEN
      ASSIGN _F._IMAGE-FILE = OcxClassID
             _U._SUBTYPE    = OcxShortName.
    ELSE
      RUN adeuib/_vbxadvs.p
        (INPUT _h_win, INPUT "_VBX-2":U, INPUT var-name, OUTPUT VbxChoice).
  END.
  IF VbxChoice = "_REPLACE-SELECT":U THEN
  DO:
    /* Allow user to select an OCX to replace VBX. */
    RUN GetParent IN _h_uib (INPUT _h_object_win:HWND, OUTPUT ParentHWND).
    ASSIGN _ocx_draw = _h_Controls:GetControl(ParentHWND) NO-ERROR.
    IF VALID-HANDLE(_ocx_draw) THEN
      ASSIGN VbxChoice = "_REPLACE-AUTO":U. /* Force back to auto for other VBX's. */
    ELSE
      ASSIGN VbxChoice = "_CANCEL":U.
  END.
  IF VbxChoice = "_CANCEL":U THEN RETURN "_ABORT".
  /* "_DELETE" cases are handled after realizing widget. This prevents
     inadvertently altering how _U is created based on _TYPE. We want it
     created based on  "{&WT-CONTROL}" without the "_DELETE" prefix. */

  RETURN.
  
END PROCEDURE.

/* Report an error to the user */
PROCEDURE error-msg:
  define input parameter pMsg as char no-undo.

  MESSAGE "{&WT-CONTROL} could not be processed." {&SKP} pMsg + " ({&FILE-NAME})"
          VIEW-AS ALERT-BOX ERROR.
END.  



