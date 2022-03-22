/***********************************************************************
* Copyright (C) 2006-2012 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
************************************************************************/
/*----------------------------------------------------------------------------

File: _prpsmar.p

Description:
    Procedure to show the SmartObject property sheet.

Input Parameters:
   ph_visual : The handle of the visualization for the current smartObject

Output Parameters:
   <None>

Author: Wm. T. Wood & Ross Hunter

Date Created: Feb. 1995

Modified on 10/24/96 gfs - removed text from buttons and added tooltips
----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ph_visual AS WIDGET                            NO-UNDO.

&SCOPED-DEFINE USE-3D           YES
&GLOBAL-DEFINE WIN95-BTN        YES

{adecomm/adestds.i}             /* Standards for "Sullivan Look"            */
{adeuib/uniwidg.i}              /* Universal widget definition              */
{adeuib/layout.i}               /* Definitions of the layout records        */
{adeuib/property.i}             /* Temp-Table containing attribute info     */
{adeuib/uibhlp.i}               /* Help pre-processor directives            */

&IF DEFINED(ADEICONDIR) = 0 &THEN
 {adecomm/icondir.i}
&ENDIF

&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

&SCOPED-DEFINE FRAME-NAME f_proc_sht

/* Checked as necessary */
DEFINE VARIABLE  adjust AS        DECIMAL           DECIMALS 2 NO-UNDO.
DEFINE BUTTON    btn_links        IMAGE-UP FILE {&ADEICON-DIR} + "linkedit" + "{&BITMAP-EXT}" FROM X 2 Y 2 
                                  IMAGE-SIZE-P 32 BY 32.  
DEFINE BUTTON    btn_file         LABEL "&File..." SIZE 15 BY 1.125.  
DEFINE BUTTON    btn_attr         LABEL "&Edit..." SIZE 15 BY 1.125. 
DEFINE BUTTON    btn_layout       LABEL "Sync with Master..." SIZE 21 BY 1.125.
DEFINE VARIABLE  last-tab         AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE  lRecreate        AS LOGICAL NO-UNDO.
DEFINE VARIABLE  lo-master        AS LOGICAL NO-UNDO.
DEFINE VARIABLE  name AS          CHAR LABEL "&Object":U FORMAT "X(80)" 
                                  VIEW-AS FILL-IN SIZE 51 BY 1 NO-UNDO.
DEFINE VARIABLE  org_name         AS CHAR NO-UNDO.
DEFINE VARIABLE  org_height       AS DECIMAL NO-UNDO.
DEFINE VARIABLE  org_width        AS DECIMAL NO-UNDO.
DEFINE VARIABLE  org_row          AS DECIMAL NO-UNDO.
DEFINE VARIABLE  org_col          AS DECIMAL NO-UNDO.

DEFINE VARIABLE  instanceLbl      AS CHARACTER NO-UNDO.

DEFINE RECTANGLE rect-pal         SIZE .18 BY 3  NO-FILL EDGE-PIXELS 3 FGC 1.
DEFINE VARIABLE  stupid           AS LOGICAL NO-UNDO.  /* Error catcher for methods */
DEFINE VARIABLE  tog_parameterize AS LOGICAL NO-UNDO
                                  LABEL "&Parameterize as Variable"
                                  VIEW-AS TOGGLE-BOX .                                  
DEFINE VARIABLE  tog_remove-from  AS LOGICAL NO-UNDO
                                  LABEL "&Remove from Layout"
                                  VIEW-AS TOGGLE-BOX .                                  
DEFINE VARIABLE  txt_advnc        AS CHAR VIEW-AS TEXT SIZE 64 BY .77 FORMAT "X(40)".
DEFINE VARIABLE  int-entries      AS CHAR NO-UNDO.

DEFINE VARIABLE h_btn-info        AS WIDGET-HANDLE           NO-UNDO.
DEFINE VARIABLE cur-row           AS DECIMAL DECIMALS 2      NO-UNDO.
DEFINE VARIABLE icon-hp           AS INTEGER                 NO-UNDO.
DEFINE VARIABLE icon-wp           AS INTEGER                 NO-UNDO.

/* Variables used for adm version */
{adeuib/vsookver.i}
DEFINE VARIABLE foundFunction     AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE i                 AS INTEGER                 NO-UNDO.

DEFINE VARIABLE _settingsScreenValue AS CHARACTER            NO-UNDO.
DEFINE VARIABLE _so-infoFile         AS CHARACTER            NO-UNDO.
DEFINE VARIABLE FrameTitle           AS CHARACTER            NO-UNDO init  "Property Sheet".
/** NO we may create widgets from the Instance Property Dialog
CREATE WIDGET-POOL.
**/ 
 
BIG-TRANS-BLK:
DO TRANSACTION:
  /* Turn off status messages, otherwise they will appear in the status area of
   * the Design window.  They are turned back on before exiting the procedure */
  STATUS INPUT OFF.

  /* Create necessary widgets and initialize with current data                */
  FIND _U WHERE _U._HANDLE eq ph_visual.
  FIND _S WHERE RECID(_S) eq _U._x-recid.
  FIND _L WHERE RECID(_L) eq _U._lo-recid.   

  /* Determine admVersion */
  {adeuib/admver.i _S._HANDLE admVersion}.
  ASSIGN _so-infoFile = IF admVersion LT "ADM2":U 
         THEN "adm/support/_so-info.w"
         ELSE "adm2/support/_so-info.w".
  
  /* Is this property sheet for the Master Layout. */
  lo-master = _L._LO-NAME eq "{&Master-Layout}":U.

  IF NOT RETRY THEN DO:
    DEFINE FRAME {&FRAME-NAME}
         name              AT ROW 1.13  COL 13 COLON-ALIGNED {&STDPH_FILL}
         _U._SUBTYPE       COLON 13
                           FORMAT "X(45)" LABEL "Type" 
                           VIEW-AS FILL-IN SIZE 51 BY 1
         _S._FILE-NAME     COLON 13 FORMAT "X(256)" LABEL "Master File"
                           VIEW-AS FILL-IN SIZE 41 BY 1
         btn_file          TO 71
         instanceLbl VIEW-AS TEXT AT 2 NO-LABEL
         _settingsScreenValue AT 13 NO-LABEL
                           VIEW-AS EDITOR SIZE 43 BY 4.5
                           SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL
         btn_attr          TO 71
         SKIP ({&VM_WIDG})
         txt_advnc         AT 2   BGC 1 FGC 15 NO-LABEL
         SKIP ({&VM_WID})
         tog_parameterize  AT 3 
         _S._var-name      TO 65 LABEL "&Variable" FORMAT "X(32)" 
                           {&STDPH_FILL} VIEW-AS FILL-IN SIZE 23 BY 1    
         tog_remove-from   AT 3 
         _U._LAYOUT-NAME   AT 3 FORMAT "X(256)" LABEL "Layout"
                           VIEW-AS FILL-IN SIZE 33 BY 1
         btn_layout        TO 71    

         rect-pal          AT ROW 1.13  COL 73.5
         btn_links         AT ROW 1.13  COL 74.75
       WITH 
       &if DEFINED(IDE-IS-RUNNING) = 0 &then
       VIEW-AS DIALOG-BOX      TITLE FrameTitle
       &else
       NO-BOX 
       &endif 
       KEEP-TAB-ORDER
       SIDE-LABELS SIZE 84 BY 22 
       THREE-D.

     ASSIGN    
         FrameTitle                 = "Property Sheet - " + _U._NAME +
                                      IF lo-master THEN "":U
                                      ELSE (" - Layout: " + _U._LAYOUT-NAME)
         FRAME {&FRAME-NAME}:HIDDEN = TRUE
         FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW
         &if DEFINED(IDE-IS-RUNNING) = 0  &then
         FRAME {&FRAME-NAME}:TITLE  = FrameTitle
         &endif
         btn_links:COLUMN       = IF SESSION:WIDTH-PIXELS > 700 THEN 75.5
                                                                   ELSE 74.75
         txt_advnc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " Advanced Options":L30
         name:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
         name:SCREEN-VALUE          = _U._NAME
         btn_file:SENSITIVE         = YES
         last-tab                   = btn_links:HANDLE IN FRAME {&FRAME-NAME}
         org_name                   = _S._FILE-NAME
         org_height                 = _L._HEIGHT
         org_width                  = _L._WIDTH
         org_row                    = _L._ROW
         org_col                    = _L._COL 
         _settingsScreenValue:SENSITIVE = TRUE
         _settingsScreenValue:READ-ONLY = TRUE
         _settingsScreenValue:BGCOLOR   = {&READ-ONLY_BGC}
         tog_parameterize:CHECKED   = _S._var-name ne ""
         tog_parameterize:SENSITIVE = lo-master
         _S._var-name:HIDDEN        = NOT tog_parameterize:CHECKED
         _S._var-name:SENSITIVE     = lo-master
         _S._var-name:SCREEN-VALUE  = _S._var-name
         .
    /* Only show Layout variables in alternate layouts. */
    IF lo-master 
    THEN ASSIGN tog_remove-from:HIDDEN = YES
                btn_layout:HIDDEN      = YES
                _U._LAYOUT-NAME:HIDDEN = YES
                cur-row                = _S._var-name:ROW + _S._var-name:HEIGHT  + 
                                         {&IVM_OKBOX}.
    ELSE ASSIGN tog_remove-from:SENSITIVE    = yes 
                tog_remove-from:CHECKED      = _L._REMOVE-FROM-LAYOUT
                btn_layout:SENSITIVE         = yes
                _U._LAYOUT-NAME:SCREEN-VALUE = _U._LAYOUT-NAME
                cur-row                      = btn_layout:ROW + btn_layout:HEIGHT  + 
                                               {&IVM_OKBOX}. 

  
    /* Handle sizing based on screen real estate */
   
    ASSIGN icon-hp = btn_links:HEIGHT-P IN FRAME {&FRAME-NAME}
           icon-wp = btn_links:WIDTH-P IN FRAME {&FRAME-NAME}.
      
    &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN 
    IF SESSION:WIDTH-PIXELS = 640 AND SESSION:PIXELS-PER-COLUMN = 6 THEN
      ASSIGN icon-hp = 32
             icon-wp = 34
             FRAME {&FRAME-NAME}:WIDTH = 89
             .
    &ENDIF
 

  
    /* *************************** Generate Needed Widgets ************************** */
    
    {adecomm/okbar.i}
    {adeuib/ide/dialoginit.i "FRAME {&FRAME-NAME}:handle"}
    &if DEFINED(IDE-IS-RUNNING) <> 0  &then
        dialogService:View(). 
    &endif
    ASSIGN FRAME {&FRAME-NAME}:DEFAULT-BUTTON = btn_OK:HANDLE IN FRAME {&FRAME-NAME}
           adjust                      = FRAME {&FRAME-NAME}:HEIGHT - cur-row - 2.25  
           btn_ok:ROW                   = btn_ok:ROW - adjust
           btn_cancel:ROW               = btn_cancel:ROW - adjust
           btn_help:ROW                 = btn_help:ROW - adjust
           frame {&FRAME-NAME}:HEIGHT   = frame {&FRAME-NAME}:HEIGHT - adjust
           rect-pal:HEIGHT              = btn_ok:ROW - 2
           FRAME {&FRAME-NAME}:HIDDEN   = FALSE no-error.
       
              
  END.  /* IF NOT RETRY */
 
  /* ******************************** Triggers ****************************** */
  
  ON VALUE-CHANGED OF tog_parameterize DO:
     _S._var-name:VISIBLE = SELF:CHECKED.
     /* Let the user type in a new name directly */
     IF _S._var-name:VISIBLE AND _S._var-name:SCREEN-VALUE eq ""
     THEN APPLY "ENTRY" TO _S._var-name.
  END.
  
  ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.
    
  ON CHOOSE OF btn_file IN FRAME {&FRAME-NAME} DO:
      run choose_file.
  END.
  
  ON CHOOSE OF btn_attr IN FRAME {&FRAME-NAME} DO:
    /* Ask the object itself to edit its attribute list.  NOTE: this button
       should never be enabled if the object is not valid, but we check here
       anyway. */
    IF VALID-HANDLE (_S._HANDLE) THEN DO:
      RUN adeuib/_edtsmar.p (INTEGER(RECID(_U))).
      /* Redisplay the settings (in case they changed). */
      ASSIGN _settingsScreenValue = REPLACE(_S._settings,CHR(3),CHR(10))
             _settingsScreenValue = REPLACE(_settingsScreenValue,CHR(4)," = ":U)
             _settingsScreenValue:SCREEN-VALUE = _settingsScreenValue.
      DISPLAY _settingsScreenValue WITH FRAME {&FRAME-NAME}.
    END.
  END.
  
  ON CHOOSE OF btn_links IN FRAME {&FRAME-NAME} DO:
    RUN edit-links.
  END.
  
  ON CHOOSE OF btn_layout IN FRAME {&FRAME-NAME} DO:      
    RUN adeuib/_massync.p  (INPUT RECID(_U), INPUT _U._LAYOUT-NAME).   
    /* Recreate the object if any thing has changed.  */
    IF (org_height ne _L._HEIGHT) OR (org_width ne _L._WIDTH) OR
       (org_row   ne _L._ROW)     OR (org_col   ne _L._COL)   
    THEN lRecreate = YES.
  END.
  
  ON CHOOSE OF btn_help IN FRAME {&FRAME-NAME} OR HELP OF FRAME {&FRAME-NAME} DO:
    RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&Property_Sheet_SmartObjects}, ?).
  END.
  
  /* Make sure names are valid */
  ON LEAVE OF name IN FRAME {&FRAME-NAME} DO:
    DEF VAR valid_name AS LOGICAL NO-UNDO.
  
    IF SELF:SCREEN-VALUE <> _U._NAME THEN DO:
      RUN adeuib/_ok_name.p (SELF:SCREEN-VALUE, RECID(_U), OUTPUT valid_name).
      IF valid_name THEN
        ASSIGN _U._NAME = INPUT FRAME {&FRAME-NAME} name
               FRAME {&FRAME-NAME}:TITLE = "Property Sheet - " + _U._NAME +
                                         IF _L._LO-NAME NE "Master Layout" THEN
                                         " - Layout: " + _U._LAYOUT-NAME ELSE "".
      ELSE RETURN NO-APPLY.
    END.
  END.
  
  /* Make sure the variable name is a valid Progress name. */
  ON LEAVE OF _S._var-name IN FRAME {&FRAME-NAME} DO:
    DEF VAR valid_name AS LOGICAL NO-UNDO.
  
    IF SELF:SCREEN-VALUE <> _S._var-name THEN DO:
      RUN adecomm/_valname.p (SELF:SCREEN-VALUE, FALSE, OUTPUT valid_name).
      IF valid_name
      THEN _S._var-name = INPUT FRAME {&FRAME-NAME} _S._var-name.
      ELSE RETURN NO-APPLY.
    END.
  END.
  
  /* Change REMOVE-FROM-LAYOUT */
  ON VALUE-CHANGED OF tog_remove-from IN FRAME {&FRAME-NAME} DO:
    _L._REMOVE-FROM-LAYOUT = SELF:CHECKED.
  END.
  RUN setup.
  
  DISPLAY _S._FILE-NAME WITH FRAME {&FRAME-NAME}. 
  IF admVersion LT "ADM2":U THEN
     DISPLAY "Instance Attributes:" @ instanceLbl WITH FRAME {&FRAME-NAME}.
  ELSE 
     DISPLAY "Instance Properties:" @ instanceLbl WITH FRAME {&FRAME-NAME}.
  
  &scoped-define CANCEL-EVENT U2
  {adeuib/ide/dialogstart.i btn_ok btn_cancel FrameTitle}
 
  RUN adecomm/_setcurs.p ("").
  
  &if DEFINED(IDE-IS-RUNNING) = 0  &then
     WAIT-FOR "GO" OF FRAME {&FRAME-NAME}. 
  &ELSE
     WAIT-FOR "GO" OF FRAME {&FRAME-NAME} or "u2" of this-procedure.       
     if cancelDialog THEN UNDO, LEAVE.  
  &endif
  
  
  /* Remove the _S._var-name if it is not required */
  IF (tog_parameterize:CHECKED eq NO) THEN _S._var-name = "":U.
  
  /* Turn status messages back on. (They were turned off at the top of the block */
  STATUS INPUT.
  
  RUN adeuib/_winsave.p (_U._WINDOW-HANDLE, FALSE).
  
END.  /* BIG-TRANS-BLK */
HIDE FRAME {&FRAME-NAME}.
DELETE WIDGET-POOL.

/* Has the SmartObject been removed from an alternate layout (or returned). */
IF NOT lo-master THEN DO:
  IF _L._REMOVE-FROM-LAYOUT THEN RUN HideObject IN _S._HANDLE. 
  ELSE RUN ViewObject IN _S._HANDLE.
END.
/* Do we need to recreat the SmartObject? If so, do it.  NOTE that we are
   outside of the BIG-TRANSACTION block, and that the WIDGET-POOL defined in
   this .p has already been deleted, so the recreate will occur in the UIB's
   widget pool. */
IF lRecreate THEN DO:
  RUN adecomm/_setcurs.p ("WAIT":U).
  RUN adeuib/_recreat.p (RECID(_U)).
END.

/* ***************** PERSISTENT TRIGGERS FOR DYNAMIC WIDGETS  **************** */

procedure choose_file:
    &if DEFINED(IDE-IS-RUNNING) <> 0 &then 
         dialogService:SetCurrentEvent(this-procedure,"do_choose_file").
         run runChildDialog in hOEIDEService (dialogService) .
    &else  
         RUN do_choose_file.
    &endif
    
end procedure.    

procedure do_choose_file:
    DEFINE VAR cnt          AS INTEGER NO-UNDO.
    DEFINE VAR ext          AS CHAR NO-UNDO.
    DEFINE VAR tmp_name     AS CHAR NO-UNDO.
    DEFINE VAR new_name     AS CHAR NO-UNDO.
    DEFINE VAR new_fullname AS CHAR NO-UNDO.
    DEFINE VAR org_fullname AS CHAR NO-UNDO.
    DEFINE VAR lMatch       AS LOGICAL NO-UNDO.
    DEFINE VAR lOK          AS LOGICAL NO-UNDO.
    
    /* Ask the user to Edit the name of the Master file. */
    new_name = _S._FILE-NAME.
    RUN
    &if DEFINED(IDE-IS-RUNNING) <> 0 &then 
        adeuib/ide/_dialog_filname.p
    &else
        adeshar/_filname.p
    &endif
         ( INPUT        "Modify Master File Name", /* Dialog Title Bar */
           INPUT        NO,                      /* YES is \'s converted to /'s */
           INPUT        YES,                     /* NO if file must exist */
           INPUT        'Runnable':U,            /* Options: ok to look for r-code */
           INPUT        "All Files (*.*)",       /* File Filter (eg. "Include") */
           INPUT        "*.*",                   /* File Spec  (eg. *.i) */
           INPUT        "AB",                    /* ADE Tool (for help call) */
           INPUT        {&Master_File_Name_Dlg_Box},  /* Help Context ID  */
           INPUT-OUTPUT new_name ,               /* File Spec entered */
           OUTPUT       lOK                      /* YES if user hits OK */
         ) .
    /*  Trim filename to relative path for recording in the SmartWindow. 
        19990224-038 (dma) */
    RUN adecomm/_relfile.p (new_name, VALID-HANDLE(_P._tv-proc), "":U, 
                            OUTPUT new_name).    
     
    /* Does the new name point to the same file as the old name? If so, there
       is no real problem just changing it.  NOTE: treat an empty new_name as
       a cancel. */
    IF lOK AND new_name NE "":U THEN DO:
      /* Assume that we won't have to recreate the SmartObject. */
      lRecreate = NO.
      /* Is it an exact match? */
      IF new_name eq org_name THEN _S._FILE-NAME = new_name.
      ELSE DO:
        /* Does the new filename exist? */
        ASSIGN FILE-INFO:FILE-NAME = new_name
               new_fullname = FILE-INFO:FULL-PATHNAME
               .
        IF new_fullname eq ? THEN DO:
          cnt = NUM-ENTRIES (new_name, ".":U).
          IF cnt < 2 THEN tmp_name = new_name + ".r":U.
          ELSE ASSIGN tmp_name = new_name
                      ENTRY(cnt, tmp_name, ".":U) = "r":U.
          ASSIGN FILE-INFO:FILE-NAME = tmp_name
                 new_fullname = FILE-INFO:FULL-PATHNAME .
        END. /* new_fullname does not exist. */  
        /* Does the new file exist? */
        IF new_fullname eq ? THEN DO:
          MESSAGE new_name SKIP
                  "A SmartObject Master File with this name could" {&SKP}
                  "not be found." SKIP(1)
                  "Please check the file name and path and try again."
               VIEW-AS ALERT-BOX ERROR.
        END.
        /* Does the old filename exist? */
        ASSIGN FILE-INFO:FILE-NAME = org_name
               org_fullname = FILE-INFO:FULL-PATHNAME
               .
        IF org_fullname eq ? THEN DO:
          cnt = NUM-ENTRIES (org_name, ".":U).
          IF cnt < 2 THEN tmp_name = org_name + ".r":U.
          ELSE ASSIGN tmp_name = org_name
                      ENTRY(cnt, tmp_name, ".":U) = "r":U.
          ASSIGN FILE-INFO:FILE-NAME = tmp_name
                 org_fullname = FILE-INFO:FULL-PATHNAME .
          /* If the original filename does not exist, that is OK.  We know the
             new name does exist. */
          IF org_fullname eq ? THEN org_fullname = org_name.         
        END.
        
        /* Do these two names match exactly? */
        IF org_fullname eq new_fullname THEN DO:
          ASSIGN _S._FILE-NAME = new_name
                 lMatch = YES.
        END.
        ELSE DO:
          /* Is one just r-code of the other one?  We don't need to check
             if both are r-code, because that should already have been caught. */
          cnt = NUM-ENTRIES (new_fullname, ".":U).
          IF cnt > 1 AND ENTRY(cnt, new_fullname, ".":U) eq "r":U 
          THEN DO:
            /* Convert the org_name to a .r. */
            cnt = NUM-ENTRIES (org_name, ".":U).
            IF cnt < 2 THEN tmp_name = org_name + ".r":U.
            ELSE ASSIGN tmp_name = org_name
                        ENTRY(cnt, tmp_name, ".":U) = "r":U.
            ASSIGN FILE-INFO:FILE-NAME = tmp_name
                   org_fullname = FILE-INFO:FULL-PATHNAME .
          END.
          ELSE DO:
            cnt = NUM-ENTRIES (org_fullname, ".":U).
            IF cnt > 1 AND ENTRY(cnt, org_fullname, ".":U) eq "r":U 
            THEN DO:
              /* Convert the new_name to a .r. */
              cnt = NUM-ENTRIES (new_name, ".":U).
              IF cnt < 2 THEN tmp_name = new_name + ".r":U.
              ELSE ASSIGN tmp_name = new_name
                          ENTRY(cnt, tmp_name, ".":U) = "r":U.
              ASSIGN FILE-INFO:FILE-NAME = tmp_name
                     new_fullname = FILE-INFO:FULL-PATHNAME .
            END.
          END.
          /* If both names are valid, and they are equal, then we have a match. */
          IF org_fullname ne ? AND new_fullname ne ? AND org_fullname eq new_fullname
          THEN DO:
            ASSIGN _S._FILE-NAME = new_name
                   lMatch        = YES.
          END.
        END. /* IF...ELSE Full Pathnames do not exactly match... */
        IF lMatch eq NO THEN DO:
          /* They do not match.  This means that the user typed in a brand
             new name.  Make sure they know that this is a potentially
             dangerous thing to do. */
          lOK = no.
          MESSAGE "The new Master File you have entered points to" {&SKP} 
                  "a different SmartObject than is currently in use." SKIP(1)
                  "Do you really want the UIB to reinstantiate the" {&SKP}
                  "SmartObject (when you leave the Property Sheet)?"
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lOK.
         IF lOK THEN ASSIGN lRecreate     = YES
                            _S._FILE-NAME = new_name.                             
        END. /* IF...ELSE DO: They do not match... */
      END. /* IF...ELSE DO: Full pathnames do not match... */
      
      /* Show the new name. */
      _S._FILE-NAME:SCREEN-VALUE in frame {&frame-name} = _S._FILE-NAME.
      
    END. /* IF lOK THEN DO... */
 end procedure. 


/* Change the links for objects in THIS-PROCEDURE */
PROCEDURE edit-links:
    &if DEFINED(IDE-IS-RUNNING) <> 0 &then 
      dialogService:SetCurrentEvent(this-procedure,"ide_choose_linked").
      run runChildDialog in hOEIDEService (dialogService) .
    &else  
    RUN adeuib/_linked.w (RECID(_P), RECID(_U)).
    &endif
END PROCEDURE.

/* ************************ OTHER INTERNAL PROCEDURES ************************ */

PROCEDURE setup :
  DO WITH FRAME {&FRAME-NAME}:    
    
    /* There can be no links if the procedure cannot contain smart-objects. */
    FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE.
    IF NOT CAN-DO (_P._allow, "Smart")
    THEN btn_links:HIDDEN = YES.
    ELSE DO:
      ASSIGN
        btn_lInks:SENSITIVE = YES
        Btn_Links:LABEL = "Smart&Links"
        Btn_Links:TOOLTIP = "SmartLinks"
      .
    END. 
    /* Link Info Button */
    CREATE BUTTON h_btn-info
         ASSIGN FRAME       = FRAME {&FRAME-NAME}:HANDLE
                ROW         = btn_links:ROW + btn_links:HEIGHT + 1
                X           = btn_links:X
                HEIGHT-P    = btn_links:HEIGHT-P
                WIDTH-P     = btn_links:WIDTH-P
                SENSITIVE   = TRUE   
                LABEL       = "Smart&Info"
                TOOLTIP     = "SmartInfo"
          TRIGGERS:
            ON CHOOSE PERSISTENT RUN choose_smart_info .
          END TRIGGERS.
    ASSIGN stupid = h_btn-info:LOAD-IMAGE({&ADEICON-DIR} + "info-u" +
                                              "{&BITMAP-EXT}",0,0,28,28).
                                              
    /* Check whether the object supports its own attribute editor. */
    IF NOT _S._valid-object 
    THEN ASSIGN _settingsScreenValue = REPLACE(_S._settings,CHR(3),CHR(10))
                _settingsScreenValue = REPLACE(_settingsScreenValue,CHR(4)," = ":U)
                _settingsScreenValue:SCREEN-VALUE = _settingsScreenValue
                _U._SUBTYPE:SCREEN-VALUE  = "Unknown [Object could not be run]"
                .
    ELSE DO:
      /*If subtype=SmartDataObject and db-aware=no is because the SmartObject is a DataView*/
      IF _U._SUBTYPE EQ "SmartDataObject":U AND
                        VALID-HANDLE(_S._handle) AND
                        NOT ({fn getDBAware _S._handle}) THEN
      ASSIGN _U._SUBTYPE:SCREEN-VALUE = "DataView":U.
      ELSE
      ASSIGN _U._SUBTYPE:SCREEN-VALUE = _U._SUBTYPE.
      
      ASSIGN int-entries = _S._HANDLE:INTERNAL-ENTRIES.

      IF admVersion LT "ADM2":U THEN DO:
         IF NOT CAN-DO (int-entries, "get-attribute-list") OR
            NOT CAN-DO (int-entries, "set-attribute-list") 
         THEN DO:
           /* Can't set/get settings */
           _settingsScreenValue:SCREEN-VALUE = "[Object does not support Attributes]".
         END. /* no get or set */
         ELSE DO:
            RUN get-attribute-list IN _S._HANDLE (OUTPUT _S._settings) NO-ERROR.
            ASSIGN 
                _settingsScreenValue = REPLACE(_S._settings,CHR(3),CHR(10))
                _settingsScreenValue = REPLACE(_settingsScreenValue,CHR(4)," = ":U)
                _settingsScreenValue:SCREEN-VALUE = _settingsScreenValue.
            /* Don't sensitize the Edit button on alternate layouts. */
            IF lo-master AND
               (CAN-DO (int-entries, "edit-attribute-list") OR
                CAN-DO (int-entries, "adm-edit-attribute-list") OR
                CAN-DO (int-entries, "local-edit-attribute-list"))
            THEN btn_attr:SENSITIVE = YES.
          END.
      END. /* ADM1 */
      ELSE DO:
         /* For ADM2 any attribute-list etc. */
         ASSIGN foundFunction = FALSE.
         DO i = 1 TO NUM-ENTRIES(int-entries):
            IF ENTRY(i,int-entries) BEGINS "get" OR
               ENTRY(i,int-entries) BEGINS "set" THEN
            DO:
               ASSIGN foundFunction = TRUE.
               LEAVE.
            END.
         END. /* DO loop int-entries */

         ASSIGN _S._settings = dynamic-function(
                             "InstancePropertyList":U IN _S._HANDLE,"":U) NO-ERROR.
         IF ERROR-STATUS:ERROR OR NOT foundFunction THEN 
         DO:
           /* Can't set/get settings */
           _settingsScreenValue:SCREEN-VALUE = "[Object does not support Instance Properties]".
         END. /* no get or set */
         ELSE DO:
           ASSIGN
             _settingsScreenValue = REPLACE(_S._settings,CHR(3),CHR(10))
             _settingsScreenValue = REPLACE(_settingsScreenValue,CHR(4)," = ":U)
             _settingsScreenValue:SCREEN-VALUE = _settingsScreenValue
             cValue = dynamic-function("getPropertyDialog":U IN _S._HANDLE)
            NO-ERROR.
            /* Don't sensitize the Edit button on alternate layouts. 
             * See if Dialog exists 
             */
            IF (NOT ERROR-STATUS:ERROR) AND cValue <> "":U AND cValue <> ? AND
               lo-master
            THEN btn_attr:SENSITIVE = YES.
          END.
      END. /* > ADM1 */
    END.  /* IF...valid-object...*/
  END.
END.  /* Procedure sensitize */

procedure choose_smart_info:
  /* 
   &if DEFINED(IDE-IS-RUNNING) <> 0 &then 
      dialogService:SetCurrentEvent(this-procedure,"do_choose_smart_info").
      run runChildDialog in hOEIDEService (dialogService) .
    &else  
    **/
      run do_choose_smart_info.
/*    &endif*/
end procedure.

procedure do_choose_smart_info:
/*    &if DEFINED(IDE-IS-RUNNING) <> 0 &then*/
/*    &else                                 */
    run VALUE(_so-infoFile) (_S._HANDLE,"").
/*    &endif*/
end procedure.

procedure ide_choose_linked:
    RUN adeuib/ide/_dialog_linked.p (RECID(_P), RECID(_U)).
end procedure.