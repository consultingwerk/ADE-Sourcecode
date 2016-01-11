/*********************************************************************
* Copyright (C) 2000-2001 by Progress Software Corporation ("PSC"),  *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------

File: _cr_cust.p

Description:  Read the Custom Widget file ([ProUIB]customWidgetFile) and 
              create the appropriate _custom records.
              
              The file should be of the form:
                *BUTTON   OK
                DESCRIPTION This is the description [optional]
                ATTRIBUTE VALUE
                ATTRIBUTE VALUE
                TRIGGER EVENT
                code
                END TRIGGER
                *FILL-IN Integer
                etc.
              
Input Parameters:
      
Output Parameters:
   <None>

Author: Wm.T.Wood

Date Created: Feb. 11, 1994
Modified by GFS on 2/10/95 -- Add new palette support for RoadRunner.
            GFS on 1/08/97 -- Throw away VBX defs (Beta 1)
            GFS on 1/15/97 -- Reenable OCX
            SLK on 1/21/97 -- Eliminate VBX, Add OCX
    Check for UP & DOWN Image, Label
     SLK on 2/14/97 -- Changed phrasing from OCX control to OCX
   Eliminated ERROR Messages
     SLK on 2/28/97 -- Bug#96-03-04-032 
  do not strip blank lines from cst trigger code
      -- Bug#96-05-02-015
  disregard comments in body of the cst file and only if 
  the comments begin in a separate line. 
  Read in if w/in trigger code 
  TRIGGER 
  END TRIGGER
  Only if TRIGGER and END TRIGGER start a new line
     SLK on 3/18/97 -- Bug#97-02-27-085
  Handle filenames with blanks etc in them. Long Filenames.
           GFS on 3/17/98 - Do not add or warn about missing containers
                            if Webspeed-only product.
           GFS on 08/31/01 - ICF support of TYPE for NEW dialog items. "DYN"
                             begins type means object is logical object.
----------------------------------------------------------------------------*/

/* Depeding on location of call - main or use custom/add custom */
DEFINE INPUT PARAMETER _start AS LOGICAL NO-UNDO.
{adeuib/sharvars.i}
{adeuib/custwidg.i}
{src/adm2/globals.i}
{adeuib/property.i}
/** Contains definitions for all design-time temp-tables. **/
{destdefi.i}

DEF VAR cnt        AS INTEGER   NO-UNDO.
DEF VAR i          AS INTEGER   NO-UNDO.
DEF VAR next_order AS INTEGER   NO-UNDO.
DEF VAR overWrite  AS CHARACTER NO-UNDO INITIAL "".
DEF VAR justMade   AS LOGICAL   NO-UNDO.
DEF VAR temp       AS CHARACTER NO-UNDO.
  
DEFINE VARIABLE _ocx_trans AS COMPONENT-HANDLE NO-UNDO.
DEFINE VARIABLE _ocx_image AS COMPONENT-HANDLE NO-UNDO.
DEF VAR vbxClassId       AS CHARACTER NO-UNDO.
DEF VAR typeShortName      AS CHARACTER NO-UNDO.
DEF VAR CanMigrate       AS LOGICAL NO-UNDO.
DEF VAR vbxMsg           AS CHARACTER NO-UNDO.

DEF VAR advisorText  AS CHARACTER NO-UNDO.
DEF VAR advisorChoice  AS CHARACTER NO-UNDO.
DEF VAR ParentHWND     AS INTEGER   NO-UNDO.

DEFINE VARIABLE choice      AS CHARACTER NO-UNDO.
DEFINE VARIABLE choiceTrans    AS CHARACTER NO-UNDO.
DEFINE VARIABLE pl_never_again AS LOGICAL   NO-UNDO.
DEFINE VARIABLE vbxtype     AS LOGICAL   NO-UNDO.
DEFINE STREAM In_Stream.
DEFINE STREAM Out_Stream.

DEFINE VARIABLE upFile   AS CHARACTER NO-UNDO.
DEFINE VARIABLE downFile  AS CHARACTER NO-UNDO.

define variable fName       AS CHARACTER NO-UNDO.
DEFINE VARIABLE fPrefix  AS CHARACTER NO-UNDO.
DEFINE VARIABLE pBasename  AS CHARACTER NO-UNDO.
DEFINE VARIABLE createIt  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE ThisMessage AS CHARACTER NO-UNDO.
DEFINE VARIABLE errStatus  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE bmpFile  AS CHARACTER NO-UNDO.
DEFINE VARIABLE fullName  AS CHARACTER NO-UNDO.
DEFINE VARIABLE errCreate  AS LOGICAL   NO-UNDO.

/* Handle blanks in IMAGE filenames */
DEFINE VARIABLE r-quoteloc AS INTEGER  NO-UNDO.
DEFINE VARIABLE quoteloc AS INTEGER  NO-UNDO.
DEFINE VARIABLE temp2  AS CHARACTER NO-UNDO.

/* Dynamics specific variables */
DEFINE VARIABLE cDynamicMsg            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghDesignManager        AS HANDLE     NO-UNDO.

/* Workfiles */
/* trans = _TRANS, _NOTTRANS, _DELETE */
DEFINE WORKFILE wVbxOcx
   FIELD _vbxFile  AS CHARACTER
   FIELD _subType  AS CHARACTER
   FIELD _classId  AS CHARACTER
   FIELD _shortName  AS CHARACTER
   FIELD _up-image-file   AS CHARACTER
   FIELD _down-image-file AS CHARACTER
   FIELD _trans  AS CHARACTER
   FIELD _vbxMsg  AS CHARACTER
.

DEFINE WORKFILE wSubFiles
   FIELD _filename   AS CHARACTER
.

DEFINE WORKFILE wFiles
   FIELD _filename   AS CHARACTER
   FIELD _vbxFile   AS CHARACTER
.

DEFINE WORKFILE wLine
   FIELD _linenum  AS INTEGER
   FIELD _filename AS CHARACTER
   FIELD _line  AS CHARACTER
   FIELD _controlLine AS LOGICAL
   FIELD _vbxFile AS CHARACTER
   FIELD _vbxLine AS LOGICAL
.

DEFINE BUFFER wLineCreate FOR wLine.
DEFINE VARIABLE _warning AS LOGICAL NO-UNDO.

&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

IF _DynamicsIsRunning THEN 
DO:
  ghDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
  RUN read-customTemplate-Dynamics IN THIS-PROCEDURE (OUTPUT cDynamicMsg).
  IF cDynamicMsg <> "NO-MESSAGE":U  THEN
     RUN read-customPalette-Dynamics IN THIS-PROCEDURE (INPUT-OUTPUT cDynamicMsg).
 
     
  IF cDynamicMsg > "" AND cDynamicMsg <> "NO-MESSAGE":U THEN 
     MESSAGE cDynamicMsg + CHR(10) 
             + "Dynamic design templates and palettes cannot be loaded unless they are both properly defined." + CHR(10)
             + "The appBuilder will now load the static .cst files."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
  ELSE IF cDynamicMsg > "" THEN
      ASSIGN _dyn_cst_palette  = ""
             _dyn_cst_template = "".
END.

IF cDynamicMsg > "" OR NOT _DynamicsIsRunning  THEN
DO:
   /* Read each custom file. */
   cnt = NUM-ENTRIES ({&CUSTOM-FILES}).
   DO i = 1 TO cnt:
     overWrite = "".
     RUN read-custom-file (INPUT ENTRY(i, {&CUSTOM-FILES} )).
     
   /* REMOVE per bug request
     IF LENGTH(overWrite) > 0 THEN DO:
       overWrite = "The following menu items have been redefined in "
                 + ENTRY(i, {&CUSTOM-FILES}) + ":" + chr(10) + chr(10) + overWrite.
       MESSAGE overWrite view-as alert-box information.
     END. 
   REMOVE*/
   END.
END.
/*
 * Loop through the records and delete any entries palette items with no images.
 * It is easier to delete now than to
 * try to have the parser throw away records in the middle of
 * parser. (Only WIN 3.1 is MSDOS Based.)
 */
ASSIGN _warning = FALSE.
FOR EACH _palette_item WHERE ((_palette_item._icon_up = "" 
               AND _palette_item._icon_down = "") 
     OR (_palette_item._label = "")):
  FOR EACH _custom WHERE _custom._type = _palette_item._name:
 DELETE _custom.
  END.
  DELETE _palette_item.
  _palette_count = _palette_count - 1.
  ASSIGN _warning = TRUE.
END.
IF _warning THEN
DO:
   ASSIGN ThisMessage = "Custom widget defined without palette icon and/or label.".
   RUN adecomm/_s-alert.p(INPUT-OUTPUT errStatus, INPUT "E":U, "ok":U, ThisMessage).
END.

/*
 * VBXs can only live on MS-WINDOWS 3.1. Loop through the records
 * and delete any VBX entries. It is easier to delete now than to
 * try to have the parser throw away records in the middle of
 * parser. (Only WIN 3.1 is MSDOS Based.)
 */
RUN handle-vbx.
IF RETURN-VALUE = "_ABORT" THEN 
DO:
   IF VALID-HANDLE(_ocx_trans) THEN RELEASE OBJECT _ocx_trans.
   IF VALID-HANDLE(_ocx_image) THEN RELEASE OBJECT _ocx_image.
   RETURN "_ABORT".
END.
ELSE IF RETURN-VALUE = "_CANCEL" THEN
DO:
   IF VALID-HANDLE(_ocx_trans) THEN RELEASE OBJECT _ocx_trans.
   IF VALID-HANDLE(_ocx_image) THEN RELEASE OBJECT _ocx_image.
   RETURN "_CANCEL".
END.

/*
 * Loop through the records and check if any palette items with valid images.
 */
ASSIGN _warning = FALSE.
FOR EACH _palette_item WHERE _palette_item._TYPE = {&P-XCONTROL}
  AND _palette_item._name <> "{&WT-CONTROL}":
   FILE-INFO:FILE-NAME = _palette_item._icon_up.
   IF FILE-INFO:FULL-PATHNAME = ? THEN
   DO:
      ASSIGN ThisMessage = "Custom widget defined with invalid palette icon."
 + chr(10) 
 + "Widget: " + _palette_item._name + CHR(10) 
 + "Up Image Icon: " + _palette_item._icon_up 
 .
      RUN adecomm/_s-alert.p(INPUT-OUTPUT errStatus, INPUT "E":U, INPUT "ok":U, INPUT ThisMessage).
   END.
   FILE-INFO:FILE-NAME = _palette_item._icon_down.
   IF FILE-INFO:FULL-PATHNAME = ? THEN
   DO:
      ASSIGN ThisMessage = "Custom widget defined with invalid palette icon."
 + CHR(10) 
 + "Widget: " + _palette_item._name + CHR(10) 
 + "Down Image Icon: " + _palette_item._icon_down
 .
      RUN adecomm/_s-alert.p(INPUT-OUTPUT errStatus, INPUT "E":U, INPUT "ok":U, INPUT ThisMessage).
   END.
END.

/* Update User-Defined/SmartObjects to their defaults */
FOR EACH _palette_item WHERE _palette_item._TYPE <> {&P-BASIC}:
    FIND _custom WHERE _custom._type = _palette_item._name AND
                       _custom._name = "&Default" NO-ERROR.
    IF AVAILABLE (_custom) THEN DO:
        ASSIGN _palette_item._attr =_custom._attr.
        DELETE _custom. /* don't need _custom, will use _palatte_item */
    END.
    /* All attribute fields were read in with a leading CHR(10).  Strip these out */
    _palette_item._attr = TRIM(_palette_item._attr).
END.

/* If C/S AB then check to see if any basic 'Containers' were read in. */
IF NOT CAN-FIND (FIRST _custom WHERE _custom._type = "Container") AND
   _AB_license NE 2 /* Not Webspeed */ THEN 
DO:
  MESSAGE "Your custom object files do not contain any Container objects. " {&SKP}
          "If you are using a custom object file from another version of " {&SKP}
          "PROGRESS, you should update it to the latest version."
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.
  CREATE _custom.
  ASSIGN _custom._type  = "Container"
         _custom._name  = "Window"
         _custom._attr  = "NEW-TEMPLATE src/template/window.w"
         _custom._order = next_order
         next_order     = next_order + 1.
  CREATE _custom.
  ASSIGN _custom._type  = "Container"
         _custom._name  = "Dialog"
         _custom._attr  = "NEW-TEMPLATE src/template/dialog.w"
         _custom._order = next_order.
END.

        
/* * * * * * * * * * * * * *  Internal Procedures * * * * * * * * * * * * * * */
PROCEDURE read-customPalette-Dynamics :
/*------------------------------------------------------------------------------
  Purpose:     Read in the palette information from the repository
  Parameters:  OUTPUT pcMessage   Error messages
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER pcMessage  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cIDEPalettes       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iloop              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPalLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPalette           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPaletteList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lExists            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cProfileData       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rRowid             AS ROWID      NO-UNDO.

   /* Read in the session parameter 'IDEPalette' */
  ASSIGN cIDEPalettes  = DYNAMIC-FUNCTION('getSessionParam' IN THIS-PROCEDURE, 'IDEPalette':U).

  IF cIDEPalettes = "" OR cIDEPalettes = ? THEN
  DO:
     pcMessage = "NO-MESSAGE":U.
     RETURN.
  END.
  
  /* Check for user defined template information */
   RUN checkProfileDataExists IN gshProfileManager (INPUT "General":U,
                                                    INPUT "Preference":U,
                                                    INPUT "CustomPalette":U,
                                                    INPUT YES,
                                                    INPUT NO,
                                                    OUTPUT lExists).

  
   IF lExists THEN 
     RUN getProfileData IN gshProfileManager (INPUT "General":U,
                                             INPUT "Preference":U,
                                             INPUT "CustomPalette":U,
                                             INPUT NO,
                                             INPUT-OUTPUT rRowid,
                                             OUTPUT cProfileData).

   IF lExists AND cProfileData = "" THEN
   DO:
      pcMessage = "NO-MESSAGE":U.
      RETURN.
   END.
   ELSE IF NOT lExists THEN
      cProfileData = "*".
     
   /* Add customized objects onto list */
   DO iLoop = 1 TO NUM-ENTRIES(cProfileData):
      cPalette = TRIM(ENTRY(iLoop,cProfileData)).
      IF cPalette BEGINS "*" OR cPalette = "" OR SUBSTRING(cPalette,LENGTH(cPalette),1) = "*" OR cPalette BEGINS "!" THEN 
         NEXT.
      cIDEPalettes = cIDEPalettes + (IF cIDEPalettes = "" THEN "" ELSE ",")
                                    + ENTRY(iLoop,cProfileData).
   END.



  /* Check whether the specified palettes exist in the repository. If any one template
     is invalid, return without using the repository.  */
  DO iLoop = 1 TO NUM-ENTRIES(cIDEPalettes):
     cPalette = trim(ENTRY(iLoop,cIDEPalettes)).
     IF NOT DYNAMIC-FUNCTION("ObjectExists":U IN ghDesignManager, INPUT cPalette) THEN
        cMessage = cMessage + (IF cMessage = "" THEN "" ELSE ",")
                              +  cPalette .
  END.
  IF cMessage > "" THEN
  DO:
     cMessage = SUBSTITUTE("The palette&1 '&2' as defined in the session parameter 'IDEPalette' could not be found in the repository." + CHR(10),
                            IF NUM-ENTRIES(cMessage) > 1 THEN "s" ELSE "",
                            cMessage).
     pcMessage = pcMessage + (IF pcMessage = "" THEN "" ELSE CHR(10)) 
                          + cMessage.
  END.
  IF pcMessage > "" THEN
     RETURN.
  
  DO iPalLoop = 1 TO NUM-ENTRIES(cIDEPalettes):
      cPalette = TRIM(ENTRY(iPalLoop,cIDEPalettes)).
      IF NOT CAN-DO(cProfileData,cPalette) THEN
         NEXT.
     cPaletteList = cPaletteList + (IF cPaletteList = "" THEN "" ELSE ",") + cPalette.
  END.   
  RUN read-CustomPaletteObjects (INPUT cPaletteList, INPUT cProfileData).
  
  

END PROCEDURE.

PROCEDURE read-CustomPaletteObjects:
/*------------------------------------------------------------------------------
  Purpose:     Read in palette objects from repository and create appBuilder
               temp table records required for palette
  Parameters:  pcObject       Name of palette Object
               pcProfileData  Profiledata of custom palettes in user preferences 
  Notes:       Called from read-customPalette-Dynamics and called recursively if 
               the instance object is a palette class
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectList   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcProfileData  AS CHARACTER  NO-UNDO.

  
  DEFINE VARIABLE cClass             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInstanceName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPalType           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPalControl        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lPalDBConnect      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cPalDirList        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPalFilter         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPalImageUp        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPalImageDown      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lPalDefault        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cPalLabel          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPalTemplateFile   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPalOrder          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPalChooseTitle    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPalTooltip        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPalTriggerEvent   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPalTriggerCode    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAttrList          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iAttrLoop          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cName              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOffset            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLastOrderBasic    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLastOrder         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lEditOnDrop        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cWidgetList        AS CHARACTER  INITIAL "Browse,Frame,Rectangle,Image,Radio-Set,~
Toggle-Box,Slider,Button,Selection-List,Editor,Combo-Box,Fill-In,Text,~
{&WT-CONTROL},DB-Fields,Pointer,Query" NO-UNDO.
  DEFINE VARIABLE hDesignManager     AS HANDLE     NO-UNDO.
  
  DEFINE BUFFER b_ttObject FOR ttObject.
  
  FIND LAST _palette_item WHERE _palette_item._type = {&P-BASIC} USE-INDEX _order NO-ERROR.
  IF AVAILABLE _palette_item  THEN 
     iLastOrderBasic = _palette_item._order.
  ELSE iLastOrderBasic = 0.
  
  /* Retrieve the objects and instances for the current existing object opened in the appBuilder */
  ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
  
  /* Retrieve the objects and instances for the current existing object opened in the appBuilder */
  RUN retrieveDesignAttribute IN ghDesignManager ( INPUT  pcObjectList,
                                                   INPUT  "",          /* Get default result Code */
                                                   INPUT "INSTANCE":U, /* Get instance attributes only */
                                                   INPUT YES,          /* Retrieve the class attributes */
                                                   INPUT YES,          /* Perfrom recursion */
                                                   OUTPUT TABLE ttObject ,
                                                   OUTPUT TABLE ttObjectAttribute ,
                                                   OUTPUT TABLE ttClassAttribute) .    
  ASSIGN _dyn_cst_palette  = "".  
  OBJECT-LOOP:
  FOR EACH ttObject WHERE ttObject.tContainerSmartObjectObj > 0:
     /* Ensure the palette master object is not exluded from the user profile */
     FIND FIRST b_ttObject WHERE b_ttObject.tSmartObjectObj = ttObject.tContainerSmartObjectObj NO-ERROR.
     IF AVAIL b_ttObject AND NOT CAN-DO(pcProfileData,b_ttObject.tLogicalObjectName) THEN
        NEXT.
     /* If instance is a palette class, then this is a grouping. Get next object */       
     IF ttObject.tClassName = "Palette":U THEN
     DO:
       IF LOOKUP(ttObject.tLogicalObjectName,_dyn_cst_palette) = 0 AND CAN-DO(pcProfileData,ttObject.tLogicalObjectName) THEN
           _dyn_cst_palette = _dyn_cst_palette + (IF _dyn_cst_palette = "" then "" else ",")
                                               + ttObject.tLogicalObjectName.  
                                               
       NEXT OBJECT-LOOP.
     END.   
        
     
     /* Check whether the palette is included in the list */
     ASSIGN cClass          = ttObject.tClassName
            cObjectName     = ttObject.tLogicalObjectName
            cInstanceName   = ttObject.tObjectInstanceName
            cInstanceName   = IF cInstanceName = "" OR cInstanceName = ? THEN cObjectName ELSE cInstanceName
            cAttrList        = ""
            cPalToolTip      = ""
            cPalTriggerEvent = ""
            cPalTriggerCode  = ""
            cPalLabel        = ""
            cPalTemplateFile = ""
            cPalDirList      = ""
            cPalImageUp      = ""
            cPalImageDown    = ""
            lPalDefault      = No
            lEditOndrop      = No  NO-ERROR.
     /* Get the palette type before looping through attributes */       
     FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj = ttObject.tSmartObjectObj
                              AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj
                              AND ttObjectAttribute.tAttributeLabel    = "PaletteType":U NO-ERROR.
                              
     IF AVAILABLE ttObjectAttribute THEN
        cPalType = ttObjectAttribute.tAttributeValue.
     ELSE
        cPalType = "FILL-IN":U.   
      /* Loop through all attributes of the objects class */
     ATTRIBUTE-LOOP: 
     FOR EACH ttClassAttribute WHERE ttClassAttribute.tClassName = ttObject.tClassName:
        ASSIGN cName  = ttClassAttribute.tAttributeLabel
               cValue = ttClassAttribute.tAttributeValue.
        /* get the instance attribute if defined. */
        FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                 AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj
                                 AND ttObjectAttribute.tAttributeLabel    = ttClassAttribute.tAttributeLabel NO-ERROR.
        IF AVAIL ttObjectAttribute THEN
           cValue = ttObjectAttribute.tAttributeValue.
         
        IF cValue = "" OR cValue = ? THEN
           NEXT ATTRIBUTE-LOOP.
        CASE cName:
          WHEN "PaletteLabel" THEN
             ASSIGN cPalLabel = cValue
                    cName    = "LABEL":U.
          WHEN "PaletteisDefault" THEN
             lPalDefault = LOGICAL(cValue) NO-ERROR.
          WHEN "PaletteControl" THEN
             cPalControl = cValue.            
          WHEN "PaletteImageUp" THEN
             cPalImageUp = cValue.
          WHEN "PaletteImageDown" THEN
             cPalImageDown = cValue.
          WHEN "PaletteOrder" THEN
             iPalOrder = INTEGER(cValue) NO-ERROR.
          WHEN "PaletteDBConnect" THEN
             lPalDBConnect = LOGICAL(cValue) NO-ERROR.
          WHEN "PaletteDirectoryList" THEN
             cPalDirList = cValue.
          WHEN "PaletteFilter" THEN
             cPalFilter = cValue.
          WHEN "PaletteNewTemplate" THEN
             cPalTemplateFile = cValue.
          WHEN "PaletteTitle" THEN
             cPalChooseTitle = cValue.
          WHEN "PaletteTooltip" THEN
             cPalTooltip = cValue.
          WHEN "PaletteTriggerEvent" THEN
             cPalTriggerEvent = cValue.
          WHEN "PaletteTriggerCode" THEN
             cPalTriggerCode = cValue.
          WHEN "PaletteEditOnDrop" THEN
             lEditOnDrop = LOGICAL(cValue) NO-ERROR.
         /* There are various exceptions of repository names that are not the same as the 
            appBuilder required name. Map it to the expected attribute */   
          WHEN "THREE-D":u THEN
             cName = "3D".
          WHEN "CANCEL-BUTTON" THEN
             cName = "CANCEL-BTN":U.
          WHEN "ALLOW-COLUMN-SEARCHING":U THEN
             cName = "COLUMN-SEARCHING":U.
          WHEN "DEFAULT":u THEN
             cName = "DEFAULT-BTN":U.
          WHEN "ENABLED":u THEN
             cName = "ENABLE":U.
          WHEN "FLAT-BUTTON":u THEN
             cName = "FLAT":U.
          WHEN "HEIGHT-CHARS":u THEN
             cName = "HEIGHT":U.
          WHEN "HEIGHT-PIXELS":u THEN
             cName = "HEIGHT-P":U.
          WHEN "IMAGE-DOWN-FILE":u THEN
             cName = "IMAGE-DOWN":U.
          WHEN "IMAGE-INSENSITIVE-FILE":u THEN
             cName = "IMAGE-INSENSITIVE":U.
          WHEN "INITIALVALUE":u THEN
             cName = "INITIAL-VALUE":U.
          WHEN "NUM-LOCKED-COLUMNS":u THEN
             cName = "LOCK-COLUMNS":U.
          WHEN "MinHeight":u THEN
             cName = "Min-Height":U.
          WHEN "MinWidth":u THEN
             cName = "Min-Width":U.
          WHEN "LABELS":u THEN
             cName = "NO-LABELS":U.
          WHEN "AUTO-VALIDATE":u THEN
             cName = "NO-AUTO-VALIDATE":U.
           WHEN "TAB-STOP":u THEN
             cName = "NO-TAB-STOP":U.
          WHEN "ROW-HEIGHT-CHARS":u THEN
             cName = "ROW-HEIGHT-":U.
          WHEN "SCROLLBAR-HORIZONTAL":u THEN
             cName = "SCROLLBAR-H":U.
          WHEN "SCROLLBAR-VERTICAL":u THEN
             cName = "SCROLLBAR-V":U.
          WHEN "ShowPopup":u THEN
             cName = "SHOW-POPUP":U.
          WHEN "WIDTH-CHARS":u THEN
             cName = "WIDTH":U.
          WHEN "WIDTH-PIXELS":u THEN
             cName = "WIDTH-P":U.   
          /* Ensure the Name Tag is added to the attribute list */   
          WHEN "NameDefault":U THEN
            IF INDEX(cAttrList,CHR(10) + "NAME":U) = 0  AND LOOKUP(cPalType,cWidgetList) > 0 THEN
               ASSIGN cName = "NAME":U
                      cValue = IF cValue = ? OR cValue = "" THEN REPLACE(cInstanceName," ","") ELSE cValue.                       
        END CASE.
        
       /* If attribute has value NO-LABELS, NO-TAB-STOP, NO-AUTO-VALIDATE, then set opposite */
       IF LOOKUP(cName,"NO-LABELS,NO-TAB-STOP,NO-AUTO-VALIDATE":U) > 0 THEN
          cValue = IF cvalue = "TRUE":U OR cValue = "YES":U
                   THEN "NO":U
                   ELSE "YES":U.
       /* Only allow those properties supported by the appBuilder */
       FIND _prop WHERE _prop._custom AND _prop._name = cName NO-ERROR.
       IF AVAILABLE _prop AND CAN-DO(_prop._widgets,cPalType) AND cValue <> ? THEN 
            cAttrList = cAttrList + (IF cAttrList = "" THEN "" ELSE CHR(10))
                    + cName + " " +  cValue.
     
     END.    /* End For each ttClassAttribtue */

     /* Check for NAME attribute in cAttr list */
     IF INDEX(cAttrList,CHR(10) + "NAME":U) = 0  AND LOOKUP(cPalType,cWidgetList) > 0 THEN
     DO:
      FIND ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                               AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj
                               AND ttObjectAttribute.tAttributeLabel    = "NameDefault":U NO-ERROR.
      
      ASSIGN cValue = "".
      IF AVAILABLE ttObjectAttribute THEN                            
         cValue = ttObjectAttribute.tAttributeValue.
      IF cValue = ? or cValue = "" THEN
         ASSIGN cValue = REPLACE(cInstanceName," ","").
      ASSIGN  cAttrList = cAttrList + (IF cAttrList = "" THEN "" ELSE CHR(10))
                                        + "NAME":U + " " + cValue.  
     END.                          
     
    IF cPalLabel = "" THEN
       cPalLabel = cInstanceName. 
   
    /* Check template file */
    IF cPalTemplateFile > "" THEN 
    DO:
       FILE-INFO:FILE-NAME = cPalTemplateFile.
       IF FILE-INFO:FULL-PATHNAME = ? THEN
       DO:
         MESSAGE "Cannot find template:" + QUOTER(cPalTemplateFile)
                + " for " + QUOTER(cClass) + ": "
                + cPalLabel skip
                "Please check the name and make sure that it can be located in your PROPATH."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
         NEXT OBJECT-LOOP.
       END.
    END.

    /* Add on the Static TriggerCode */
    IF cPalTriggerEvent > "" THEN
    DO iLoop = 1 TO NUM-ENTRIES(cPalTriggerEvent,"|"):
       cAttrlist = cAttrList + (IF cAttrList = "" THEN "" ELSE CHR(10))
                             + (IF ENTRY(iLoop,cPalTriggerEvent,"|":U) BEGINS "TRIGGER":U THEN "" ELSE "TRIGGER ":U )
                             + ENTRY(iLoop,cPalTriggerEvent,"|":U) + CHR(10)
                             + "DO:":U + CHR(10) 
                             + ENTRY(iLoop,cPalTriggerCode,"|":U) + CHR(10)
                             + "END.":U + CHR(10)
                             + "END TRIGGER":U.
    END.

    /* Add USE or DIRECTORY-LIST,FILTER,TITLE options in attr */
    IF lPalDefault AND cPalDirList > "" THEN
      ASSIGN  cAttrList = cAttrList  
                        + (IF cPalDirList > "" THEN CHR(10) + "DIRECTORY-LIST ":U + cPalDirList ELSE "")
                        + (IF cPalFilter > "" THEN  CHR(10) + "FILTER ":U + cPalFilter ELSE "")
                        + (IF cPalChooseTitle  > "" THEN  CHR(10) + "TITLE ":U + cPalChooseTitle ELSE "").
    ELSE IF cPalTemplateFile > ""  THEN
      ASSIGN cAttrList = cAttrList + (IF cAttrList = "" THEN "" ELSE CHR(10))
                         + "USE ":U + cPalTemplateFile.

    /* Add edit-on-drop tag causing instance dialog to appear when object is dropped
       on design window */
    IF lEditOndrop  THEN 
       cAttrlist = cAttrList + (IF cAttrList = "" THEN "" ELSE CHR(10))
                             + "EDIT-ON-DROP":U.

    /* Create palette_item record for each default (lPaldefault is true) */
    FIND FIRST _palette_item WHERE _palette_item._NAME eq cPalType NO-ERROR.
    IF NOT AVAILABLE _palette_item AND lPalDefault THEN
    DO:   
       FIND LAST _palette_item USE-INDEX _order NO-ERROR.
       IF AVAILABLE _palette_item  THEN iLastOrder = _palette_item._order.
                                   ELSE iLastOrder = 0.
       CREATE _palette_item.
       ASSIGN _palette_item._NAME  = cPalType
              _palette_item._TYPE  = {&P-USER}
              _palette_item._ORDER = IF iPalOrder > 0 
                                     THEN iLastOrderBasic + iPalOrder + 1
                                     ELSE iLastOrder + 1
              _palette_count       = _palette_count + 1.

    END.

    IF lPalDefault AND AVAILABLE _palette_item THEN
    DO:
       ASSIGN _palette_item._Label        = IF _palette_item._type = {&P-BASIC} 
                                               AND _palette_item._Label NE ""
                                            THEN _palette_item._Label ELSE cPalLabel
              _palette_item._Label2       = IF cPalTooltip = "" AND LOOKUP(cPalType,cWidgetList) > 0
                                            THEN  _palette_item._Label2 
                                            ELSE IF cPalTooltip = "" THEN cPalLabel ELSE cPalTooltip
              _palette_item._ATTR         = cAttrList 
              _palette_item._NEW_TEMPLATE = IF cPalTemplateFile > "" AND cPalDirList > "" 
                                            THEN cPalTemplateFile 
                                            ELSE _palette_item._NEW_TEMPLATE
              _palette_item._dbconnect    = lPalDBConnect
              _palette_item._object_class = cClass
              _palette_item._object_name  = cObjectName.


       /* Assign icon information */
       IF cPalImageUp > "" THEN
       DO:
          ASSIGN _palette_item._icon_up   = ENTRY(1,cPalImageUp," ")
                 _palette_item._icon_up   = REPLACE(_palette_item._icon_up,"~"","")
                 _palette_item._icon_up   = REPLACE(_palette_item._icon_up,"'","")
                 cOffset                  = IF INDEX(cPalImageUp," ") > 0 
                                            THEN TRIM(SUBSTRING(cPalImageUp,INDEX(cPalImageUp," "),-1,"CHARACTER":U))
                                            ELSE ""
                 NO-ERROR.
          IF cOffset > "" THEN
             ASSIGN _palette_item._icon_up_x = INTEGER(ENTRY(1, cOffset ))
                    _palette_item._icon_up_y = INTEGER(ENTRY(2, cOffset ))
                    NO-ERROR.
       END.
       IF cPalImageDown > "" THEN
       DO:
          ASSIGN _palette_item._icon_down = ENTRY(1,cPalImageDown," ")
                 _palette_item._icon_down = REPLACE(_palette_item._icon_down,"~"","")
                 _palette_item._icon_down = REPLACE(_palette_item._icon_down,"'","")
                 cOffset                  = IF INDEX(cPalImageDown," ") > 0 
                                            THEN TRIM(SUBSTRING(cPalImageDown,INDEX(cPalImageDown," "),-1,"CHARACTER":U))
                                            ELSE ""
                 NO-ERROR.
          IF cOffset > "" THEN
             ASSIGN _palette_item._icon_down_x = INTEGER(ENTRY(1, cOffset ))
                    _palette_item._icon_down_y = INTEGER(ENTRY(2, cOffset ))
                    NO-ERROR. 
       END.
       /* Set OCX infomration */
       IF cPalControl > "" THEN DO:
          ASSIGN _palette_item._TYPE = {&P-XCONTROL}
                 cAttrList           = "CONTROL":U
                                        + CHR(10)
                                        + STRING(ENTRY(1, cPalControl," "))
                                        + CHR(10)
                                        + ENTRY(2, cPalControl," ")
                 _palette_item._Attr =  cAttrList
                 NO-ERROR.

       END.
    END. /* End default palette item */

     /* Add the palette item to the custom */
    FIND FIRST _custom WHERE _custom._name eq (IF lPalDefault THEN "&Default":U ELSE cPalLabel)
                         AND _custom._type eq cPalType NO-ERROR.
                         
                         
                 
    IF NOT AVAILABLE _custom THEN
    DO:
       CREATE _custom.
       ASSIGN _custom._type             = cPalType
              _custom._name             = IF lPalDefault THEN "&Default":U ELSE cPalLabel   /* e.g. "OK"     */
              _custom._attr             = cAttrList
              _custom._order            = iPalOrder
              _custom._object_type_code = cClass
              _custom._object_name      = cObjectName.

       /* Assign the template file */
       IF cPalTemplateFile > "" THEN
       DO:
          ASSIGN FILE-INFO:FILE-NAME = TRIM(cPalTemplateFile).
          IF FILE-INFO:FULL-PATHNAME > "" THEN
              ASSIGN _custom._design_template_file = FILE-INFO:FULL-PATHNAME.
       END.
    END.
  END.  /* End FOR EACH ttObject */
  
  
END PROCEDURE.

PROCEDURE read-customTemplate-Dynamics :
/*------------------------------------------------------------------------------
  Purpose:     Read in the template information from the repository
  Parameters:  OUTPUT pcMessage
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE OUTPUT PARAMETER pcMessage  AS CHARACTER  NO-UNDO.

   DEFINE VARIABLE cIDETemplates      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE iloop              AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cTemplate          AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cClass             AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cObjectName        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cInstanceName      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE iOrder             AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cTemplateFile      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cTemplateGroup     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cTemplateLabel     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cTemplateImage     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cTemplatePropSheet AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE lIsDynamic         AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lExists            AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE rRowID             AS ROWID      NO-UNDO.
   DEFINE VARIABLE cProfileData       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cMessageCustom     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cMessageTemplate   AS CHARACTER  NO-UNDO.

   ASSIGN cIDETemplates  = DYNAMIC-FUNCTION('getSessionParam' IN THIS-PROCEDURE, 'IDETemplate':U)
          NO-ERROR.

  /* If Session parameter is not defined, return NO-MESSAGE string  and load static .cst without giving a message*/
   IF cIDETemplates = "" OR cIDETemplates = ? THEN
   DO:
      pcMessage = "NO-MESSAGE":U.
      RETURN.
   END.
   
   /* Check for user defined template information */
   RUN checkProfileDataExists IN gshProfileManager (INPUT "General":U,
                                                    INPUT "Preference":U,
                                                    INPUT "CustomTemplate":U,
                                                    INPUT YES,
                                                    INPUT NO,
                                                    OUTPUT lExists).

  
   IF lExists THEN 
     RUN getProfileData IN gshProfileManager (INPUT "General":U,
                                             INPUT "Preference":U,
                                             INPUT "CustomTemplate":U,
                                             INPUT NO,
                                             INPUT-OUTPUT rRowid,
                                             OUTPUT cProfileData).
 /* If User blanked out the custom palette, return NO-MESSAGE string  and load static .cst without giving a message*/
   IF lExists AND cProfileData = "" THEN
   DO:
      pcMessage = "NO-MESSAGE":U.
      RETURN.
   END.
   ELSE IF NOT lExists THEN
      cProfileData = "*".
     
   /* Add customized objects onto list */
   DO iLoop = 1 TO NUM-ENTRIES(cProfileData):
      cTemplate = TRIM(ENTRY(iLoop,cProfileData)).
      IF cTemplate BEGINS "*" OR cTemplate = "" OR SUBSTRING(cTemplate,LENGTH(cTemplate),1) = "*" OR cTemplate BEGINS "!" THEN 
         NEXT.
      cIdetemplates = cIdeTemplates + (IF cIdeTemplates = "" THEN "" ELSE ",")
                                    + ENTRY(iLoop,cProfileData).
   END.
   

   /* Check whether the specified templates exist in the repository. If any one template
      is invalid, return without using the repository */
   DO iLoop = 1 TO NUM-ENTRIES(cIDETemplates):
      cTemplate = trim(ENTRY(iLoop,cIDETemplates)).
      IF NOT CAN-DO(cProfileData,cTemplate) THEN
      DO:
         ENTRY(iLoop,cIDETemplates) = "".
         NEXT.
      END.

      IF NOT DYNAMIC-FUNCTION("ObjectExists":U IN ghDesignManager, INPUT cTemplate) THEN
               pcMessage = pcMessage + (IF pcMessage = "" THEN "" ELSE ",")
                               +  ctemplate .
   END.
   /* Remove blank entries */
   DO WHILE INDEX(cIDETemplates,",,":U) > 0:
     cIDETemplates = REPLACE(cIDETemplates,",,":U,",":U).
   END.
   
   IF pcMessage > "" THEN
   DO:
      DO iLoop = 1 TO NUM-ENTRIES(pcMessage):
           IF LOOKUP(ENTRY(iLoop,pcMessage),cProfileData) > 0 THEN
                  cMessageCustom = cMessageCustom + (IF cMessageCustom = "" THEN "" ELSE ",")
                                   +  ENTRY(iLoop,pcMessage) .
           ELSE 
                cMessageTemplate = cMessageTemplate + (IF cMessageTemplate = "" THEN "" ELSE ",")
                                   +  ENTRY(iLoop,pcMessage) .
      END.
      pcMessage = (IF cMessageCustom > "" 
                  THEN (SUBSTITUTE("The template&1 '&2' as defined in the custom template field (File/Preferences) could not be found in the repository",
                             IF NUM-ENTRIES(cMessageCustom) > 1 THEN "s" ELSE "",
                             cMessageCustom) + CHR(10) 
                       )
                  ELSE "")
               + IF cMessageTemplate > "" 
                 THEN SUBSTITUTE("The template&1 '&2' as defined in the session parameter 'IDETemplate' could not be found in the repository",
                             IF NUM-ENTRIES(cMessageTemplate) > 1 THEN "s" ELSE "",
                             cMessageTemplate) + CHR(10)
                  ELSE "".

     RETURN.
   END.
      

    /* Add template to shared variable list */   
      _dyn_cst_template = cIdetemplates.   
    /* Retrieve the objects and instances for the current existing object opened in the appBuilder */
   RUN retrieveDesignAttribute IN ghDesignManager ( INPUT  cIdetemplates,
                                                    INPUT  "",  /* Get default result Code */
                                                    INPUT "INSTANCE":U, /* Get instance attributes only */
                                                    INPUT NO,   /* Don't retrieve the class attributes */
                                                    INPUT NO,  /* No recursion */
                                                    OUTPUT TABLE ttObject ,
                                                    OUTPUT TABLE ttObjectAttribute,
                                                    OUTPUT TABLE ttClassAttribute) NO-ERROR.   
                                                      
   /* Retrieve all instances */
   OBJECT-LOOP:
   FOR EACH  ttObject WHERE ttObject.tContainerSmartObjectObj > 0:
      ASSIGN cClass             = ttObject.tClassName
             cObjectName        = ttObject.tLogicalObjectName
             cInstanceName      = ttObject.tObjectInstanceName
             cInstanceName      = IF cInstanceName = "" OR cInstanceName = ? THEN cObjectName ELSE cInstanceName
             ctemplateFile      = ""
             ctemplateGroup     = ""
             ctemplateLabel     = ""
             iOrder             = 0
             lIsDynamic         = No
             cTemplateImage     = ""
             cTemplatePropSheet = "" .
         
      /* Now get instance values. These should only be defined on the instance */       
      FOR EACH ttObjectAttribute WHERE ttObjectAttribute.tSmartObjectObj    = ttObject.tSmartObjectObj
                                   AND ttObjectAttribute.tObjectInstanceObj = ttObject.tObjectInstanceObj:
                                   
         CASE TRIM(ttObjectAttribute.tAttributeLabel):
            WHEN "templateFile":U THEN
               ctemplateFile = ttObjectAttribute.tAttributeValue.
            WHEN "templateGroup":U THEN
              ctemplateGroup = ttObjectAttribute.tAttributeValue.
            WHEN "templateLabel":U THEN
               ctemplateLabel = ttObjectAttribute.tAttributeValue.
            WHEN "templateOrder":U THEN
               iOrder = INTEGER(ttObjectAttribute.tAttributeValue) .
            WHEN "DynamicObject":U THEN
               lIsDynamic = LOGICAL(ttObjectAttribute.tAttributeValue) .
            WHEN "templateImageFile":U THEN
               cTemplateImage = ttObjectAttribute.tAttributeValue.
            WHEN "templatePropertySheet":U THEN
               cTemplatePropSheet = ttObjectAttribute.tAttributeValue.
         END CASE.
      END.
      ASSIGN ctemplateGroup = IF ctemplateGroup = "" THEN "Container" ELSE ctemplateGroup     
             cTemplateLabel = IF cTemplateLabel = "" THEN cInstanceName ELSE cTemplateLabel.

      /* Check template file */
      FILE-INFO:FILE-NAME = ctemplateFile.
      IF FILE-INFO:FULL-PATHNAME = ? THEN
      DO:
        MESSAGE "Cannot find TEMPLATE: " + cTemplateFile
               + " for " + CAPS(cClass) + ": "
               + ctemplateLabel skip
               "Please check the name and make sure that it can be located in your PROPATH."
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        NEXT OBJECT-LOOP.
      END.

      FIND FIRST _custom WHERE _custom._name eq ctemplateLabel                                                                        
             AND _custom._type eq cTemplateGroup NO-ERROR.

      IF NOT AVAIL _Custom THEN
      DO:
         CREATE _Custom.
         ASSIGN _custom._name                  = cTemplateLabel
                _custom._type                  = cTemplateGroup
                _custom._files                 = IF _custom._FILES <> "" 
                                                 THEN _custom._Files + Chr(10) + cTemplate
                                                 ELSE cTemplate
                _custom._order                 = iOrder
                _custom._design_template_file  = FILE-INFO:FULL-PATHNAME
                _custom._object_type_code      = cClass
                _custom._design_image_file     = cTemplateImage
                _custom._design_propsheet_file = cTemplatePropSheet
                _custom._static_object         = NOT lIsDynamic
                _custom._attr                  = "NEW-TEMPLATE   ":U + cTemplateFile + CHR(10) 
                                                 + (IF NOT cTemplateGroup = "PROCEDURE":U 
                                                       THEN  "TYPE           ":U + cClass + CHR(10)  ELSE "")
                                                 + IF lIsDynamic AND cTemplateGroup = "Container":U
                                                   THEN ("IMAGE-FILE     ":U + cTemplateImage + CHR(10) +
                                                       "PROPERTY-SHEET ":U + cTemplatePropSheet)
                                                   ELSE ""
                _custom._object_name            = cObjectName
                 NO-ERROR.
             
      END.
   END. /* End For each ttObject */
   

END PROCEDURE.
/* read-custom-file: Read a custom file. */
PROCEDURE read-custom-file :
  DEFINE INPUT PARAMETER p_filename AS CHAR NO-UNDO.


  DEF VAR cLine         AS CHAR     NO-UNDO.
  DEF VAR cToken        AS CHAR     NO-UNDO.
  DEF VAR empty-file    AS LOGICAL  NO-UNDO.
  DEF VAR mode          AS CHAR     NO-UNDO INITIAL "".
  DEF VAR temp          AS CHAR     NO-UNDO.
  DEF VAR lastone       AS INT      NO-UNDO.
  DEF VAR master        AS LOGICAL  NO-UNDO.
  DEF VAR mstr-recid    AS RECID    NO-UNDO.
  DEF VAR mstr-precid   AS RECID    NO-UNDO.

  DEF VAR inTrigger     AS LOGICAL  NO-UNDO.
  DEF VAR inComment     AS LOGICAL  NO-UNDO.
  DEF VAR commentBeg    AS CHARACTER INITIAL "/*" NO-UNDO.
  DEF VAR commentEnd    AS CHARACTER INITIAL "*/" NO-UNDO.
  DEF VAR lSkip         AS LOGICAL  NO-UNDO.

  /* Read until the end of file.  Assume the file is empty until we hear
     otherwise. */
  empty-file = yes.
  DO ON STOP  UNDO, RETRY
     ON ERROR UNDO, RETRY:
    IF NOT RETRY THEN DO:
      /* Does the appropriate file exist? */
      ASSIGN FILE-INFO:FILE-NAME = p_filename NO-ERROR .
      IF ( FILE-INFO:FULL-PATHNAME ne ? ) THEN 
      DO:
        INPUT STREAM In_Stream FROM VALUE(FILE-INFO:FULL-PATHNAME) NO-ECHO.
        /* Skip all initial lines until we get a valid one */
                
        /* Read line-by-line (DON'T USE A "REPEAT" HERE BECAUSE WE WANT TO
           SCOPE THE _custom RECORD TO THE WHOLE PROCEDURE).  */
        LINE-LOOP:
        DO WHILE TRUE ON STOP   UNDO LINE-LOOP, LEAVE LINE-LOOP
                      ON ENDKEY UNDO LINE-LOOP, LEAVE LINE-LOOP:
          cLine = "". /* Inialize the variable before the read. */
          IMPORT STREAM In_Stream UNFORMATTED cLine.
          IF cLine BEGINS "*" OR cLine BEGINS "#" THEN
             lSkip = NO.
          IF lSkip THEN
              NEXT LINE-LOOP.
              

          /* Do not eliminate blank lines */
          IF cLine NE "" THEN
            ASSIGN cLine  = REPLACE(cLine,CHR(9)," ") /* convert Tabs to Spaces */
                   cToken = ENTRY(1,cLine," ":U) 
                   cToken = SUBSTRING(cToken,2,-1,"CHARACTER").
          ELSE ASSIGN cToken = "":U.

          /* Deal with comments */
          ASSIGN master = no.
          IF cLine BEGINS commentBeg THEN inComment = yes.
          ELSE IF cLine BEGINS "TRIGGER":U THEN inTrigger = yes.
          ELSE IF cLine BEGINS "END TRIGGER":U THEN inTrigger = no.
          ELSE IF (cline BEGINS "*":U  OR cline BEGINS "#":U) THEN master = yes.

          IF NOT inTrigger and inComment THEN DO:
            IF CAN-DO(commentEnd,cLine) THEN ASSIGN inComment = no.
            NEXT LINE-LOOP.
          END.
          
          IF mode = "Custom" AND NOT master THEN
          DO:
            /* Append the next line. (Note: the first line will be blank) */
            IF NOT AVAILABLE _custom THEN
                FIND _custom WHERE RECID(_custom) = mstr-recid.
            IF CAN-DO("Container,Procedure,SmartObject,WebObject", _custom._type) AND
               TRIM(cline) BEGINS "NEW-TEMPLATE" THEN
            DO: /* validate NEW-TEMPLATE */
              FILE-INFO:FILE-NAME = TRIM(SUBSTRING(TRIM(cline),13,-1,"CHARACTER")).
              IF FILE-INFO:FULL-PATHNAME = ? THEN
              DO:
                MESSAGE "Cannot find NEW-TEMPLATE: " +
                      TRIM(SUBSTRING(TRIM(cline),13,-1,"CHARACTER"))
                      + " for " + CAPS(_custom._type) + ": "
                      + _custom._name skip
                      "Please check the name and make sure that it can be located in your PROPATH."
                      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                DELETE _custom.
                lSkip = TRUE.
                NEXT LINE-LOOP.
              END.
              IF AVAILABLE(_custom) THEN
                ASSIGN _custom._design_template_file = FILE-INFO:FULL-PATHNAME.
            END.
            IF CLine BEGINS "TYPE":U              AND
               NUM-ENTRIES(TRIM(CLine)," ":U) > 1 AND
               AVAILABLE(_custom)                 THEN
            DO:
              ASSIGN _custom._object_type_code = TRIM(SUBSTRING(cLine,5,-1,"CHARACTER")).
              IF _custom._object_type_code BEGINS "DYN":U THEN
                ASSIGN _custom._static_object = FALSE.
            END.
            IF cLine BEGINS "IMAGE-FILE":U        AND
               NUM-ENTRIES(TRIM(cLine)," ":U) > 1 AND
               AVAILABLE(_custom)                 THEN
              ASSIGN _custom._design_image_file = TRIM(SUBSTRING(cLine,11,-1,"CHARACTER")).
            IF cLine BEGINS "PROPERTY-SHEET":U    AND
               NUM-ENTRIES(TRIM(cLine)," ":U) > 1 AND
               AVAILABLE(_custom)                 THEN
              ASSIGN _custom._design_propsheet_file = TRIM(SUBSTRING(cLine,15,-1,"CHARACTER")).
            IF cLine BEGINS "CONTROL" THEN
            DO:
                     temp = REPLACE(TRIM(SUBSTRING(cLine,8,-1,"CHARACTER"))," ",",").
                     ASSIGN
                         _custom._ATTR = "CONTROL"
                                             + CHR(10)
                                             + STRING(entry(1, temp))
                                             + CHR(10)
                                             + entry(2, temp)
                     .
            END.
            ELSE
                /* Add the line to the rest of the attributes for this
                   Custom Object .  NOTE: DO NOT LEFT-TRIM THE LINE.  This line
                   may contain some trigger code for the widget.  Trimming it
                   will remove any indenting that the user really wants. */
              _custom._attr = _custom._attr + CHR(10) + RIGHT-TRIM(cLine).
            NEXT LINE-LOOP.
          END. /* Process Custom record */
          

          IF mode = "Icon" AND NOT master THEN
          DO:
            IF NOT AVAILABLE _palette_item THEN 
                FIND _palette_item WHERE RECID(_palette_item) = mstr-recid.
            /* Process Icon definition line 
          * Handle
         */
            IF cLine BEGINS "UP-IMAGE-FILE" THEN 
            DO:
      /* Determine if there's a quote */
         ASSIGN temp = TRIM(SUBSTRING(cLine,14,-1,"CHARACTER":U))
                r-quoteloc = R-INDEX(temp,"~"")
                quoteloc = INDEX(temp,"~"").
            IF r-quoteloc <> 0 
               AND r-quoteloc > quoteloc 
               AND quoteloc = 1 THEN 
            DO:
               ASSIGN 
               temp2 = TRIM(SUBSTRING(temp,r-quoteloc + 1,-1,"CHARACTER":U)).
               ASSIGN 
            _palette_item._icon_up = SUBSTRING(temp,2,r-quoteloc - 2).
               IF temp2 <> "" AND NUM-ENTRIES(temp2,",":U) = 2 THEN 
                         ASSIGN _palette_item._icon_up_x = INT(ENTRY(1,temp2))
                                _palette_item._icon_up_y = INT(ENTRY(2,temp2)).
            END.
         ELSE DO:
            ASSIGN  temp = REPLACE(temp," ",",").
                  IF NUM-ENTRIES(temp) >= 1 THEN 
                  DO: 
                    ASSIGN _palette_item._icon_up = ENTRY(1,temp).
              IF NUM-ENTRIES(temp) = 3 THEN                   
                      ASSIGN _palette_item._icon_up_x = INT(ENTRY(2,temp))
                             _palette_item._icon_up_y = INT(ENTRY(3,temp)).
               END.
            END. /* Usual filename */
          END.
          
          ELSE IF cLine BEGINS "DOWN-IMAGE-FILE" THEN 
          DO:
      /* Determine if there's a quote */
      ASSIGN temp = TRIM(SUBSTRING(cLine,16,-1,"CHARACTER":U))
             r-quoteloc = R-INDEX(temp,"~"")
             quoteloc = INDEX(temp,"~"").
      IF r-quoteloc <> 0 
               AND r-quoteloc > quoteloc 
         AND quoteloc = 1 THEN
      DO:
        ASSIGN temp2 = TRIM(SUBSTRING(temp,quoteloc + 1, -1, "CHARACTER":U)).
        ASSIGN _palette_item._icon_down = SUBSTRING(temp,2,r-quoteloc - 2).
        IF temp2 <> "" AND NUM-ENTRIES(temp2,",":U) = 2 THEN 
                      ASSIGN _palette_item._icon_down_x = INT(ENTRY(1,temp2))
                             _palette_item._icon_down_y = INT(ENTRY(2,temp2)).
      END.
      ELSE DO:
        ASSIGN temp = REPLACE(temp," ",",").
              IF NUM-ENTRIES(temp) >= 1 THEN 
              DO: 
                ASSIGN _palette_item._icon_down = ENTRY(1,temp).
           IF NUM-ENTRIES(temp) = 3 THEN                   
                        ASSIGN _palette_item._icon_down_x = INT(ENTRY(2,temp))
                               _palette_item._icon_down_y = INT(ENTRY(3,temp)).
              END.
            END. /* Usual filename */
          END.
          
          ELSE IF cLine BEGINS "CONTROL" THEN 
          DO: 
       temp = REPLACE(TRIM(SUBSTRING(cLine,8,-1,"CHARACTER"))," ",",").
            ASSIGN  _palette_item._TYPE = {&P-XCONTROL}
                    _palette_item._ATTR = "CONTROL"
                                          + CHR(10)
                                          + STRING(entry(1, temp))
                                          + CHR(10)
                                          + entry(2, temp)
                     .
          END.                  
            
          ELSE IF cLine BEGINS "LABEL" THEN
                ASSIGN _palette_item._LABEL = REPLACE( REPLACE( REPLACE(
                                              TRIM(SUBSTRING(cLine, 6)), "~~", ""), 
                                              "~"", ""), 
                                              "~\", "")
                       _palette_item._LABEL2 = REPLACE(_palette_item._LABEL,"&",""). 
          
          ELSE IF cLine BEGINS "NEW-TEMPLATE" THEN 
          DO:
            ASSIGN _palette_item._NEW_TEMPLATE = TRIM(SUBSTRING(cLine, 13, -1, "CHARACTER")).  
            FILE-INFO:FILE-NAME = _palette_item._NEW_TEMPLATE.
            IF FILE-INFO:FULL-PATHNAME = ? THEN 
            DO:
                 MESSAGE "Cannot find NEW-TEMPLATE: " + _palette_item._NEW_TEMPLATE + 
                   " for OBJECT: " + _palette_item._NAME skip
                   "Please check the name and make sure that it can be located in your PROPATH."
                   VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                 DELETE _palette_item.
                 ASSIGN lSkip = true.
                 NEXT LINE-LOOP.
            END.
            ELSE ASSIGN _palette_item._NEW_TEMPLATE = FILE-INFO:FULL-PATHNAME.
          END.
          
          ELSE IF cLine BEGINS "DB-CONNECT" THEN 
              ASSIGN _palette_item._dbconnect = YES.
            ELSE ASSIGN _palette_item._attr = _palette_item._attr + CHR(10) + cLine.  
          END. /* Process Icon Record */
          
          /* Does this define a new palette icon? */
          IF cline BEGINS "#":U THEN 
          DO:
            ASSIGN empty-file = no
                   mode       = "Icon".

            FIND _palette_item WHERE _palette_item._NAME eq cToken NO-ERROR.
            IF AVAILABLE _palette_item THEN 
            DO:
/*REMOVE per bug request
              MESSAGE "Duplicate Palette Icon:" cToken 
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
REMOVE*/
              NEXT LINE-LOOP.
            END.
            ELSE DO:
                FIND LAST _palette_item USE-INDEX _order NO-ERROR.
                IF AVAILABLE _palette_item THEN lastone = _palette_item._order.
                ELSE lastone = 0.
                CREATE _palette_item.             
            END.
            ASSIGN _palette_item._NAME  = cToken
                   _palette_item._ORDER = lastone + 1
                   _palette_item._TYPE  = {&P-USER}
                   _palette_item._ATTR  = ""
                   _palette_count = _palette_count + 1
                   mstr-recid     = RECID(_palette_item)
                   mstr-precid     = RECID(_palette_item).
         /* Determine which cst files have it */
         IF _palette_item._FILES <> "" THEN 
         DO:
           IF INDEX(_palette_item._FILES,p_filename) = 0 THEN
           ASSIGN _palette_item._FILES = _palette_item._FILES + Chr(10) + p_filename.
         END.
         ELSE _palette_item._FILES = p_filename.
                    
            NEXT LINE-LOOP.
          END. /* "#" REC */                      
          
          /* Does this start a new Custom Widget ? 
             TEST for "*TYPE   Name"  */
          
          IF cLine BEGINS "*":U THEN
          DO:
            ASSIGN mode        = "Custom".
            
            /* If icon defined, then create a record for it. */
            IF CAN-FIND (FIRST _palette_item WHERE _palette_item._NAME = cToken) OR
               CAN-DO( "New-Container,New-Procedure,New-SmartObject,New-WebObject",
                      cToken )
            THEN DO:
            /* Extract the type and name into cToken and cLine .
               cLine = "*BUTTON    OK" becomes cLine = OK, cToken = BUTTON. */

              ASSIGN empty-file = no
                     cLine  = TRIM(SUBSTRING(cLine, LENGTH(cToken) + 2)).

              /* Remove any embarassing characters from the name. */
              cLine = REPLACE( REPLACE( REPLACE(
                          cLine, "~~", ""),
                                 "~"", ""),
                                 "~\", "").

              /*
               * If no record exists, then make one. If there
               * are multiple definitions the last one will
               * be the one that is used. Note, the "overwrite"
               * is silent. The user is not told that there
               * are multiple definitions.
               */
              FIND FIRST _custom WHERE _custom._name eq cLine
                                   AND _custom._type eq (IF cToken BEGINS "NEW-":U THEN ENTRY(2,cToken,"-":U) ELSE cToken) NO-ERROR.

              IF NOT AVAILABLE _custom THEN
              DO:
                CREATE _custom.
                justMade = yes.
              END.
              ELSE DO:
                justMade = no.
                overWrite = overWrite
                          + "The "
                          + cLine
                          + " menu item for the "
                          + cToken
                          + " palette button."
                          + chr(10).
              END.
              ASSIGN _custom._type  = REPLACE(cToken,"NEW-","")  /* e.g. "BUTTON" */
                     _custom._name  = cLine   /* e.g. "OK"     */
                     _custom._attr  = ""
              .
              /* Determine which cst files have it */
              IF _custom._FILES <> "" THEN
              DO:
               IF INDEX(_custom._FILES,p_filename) = 0 THEN
                 ASSIGN _custom._FILES = _custom._FILES + Chr(10) + p_filename.
              END.
              ELSE _custom._FILES = p_filename.

               /* We want to maintain the order that custom widgets
                  were read-in in the menus.  So remember the order. */
              IF justMade THEN
                ASSIGN _custom._order = next_order
                       next_order     = next_order + 1
                       mstr-recid     = RECID(_custom)
                       .
            END. /* IF New... */
            ELSE DO:

                /*
                 * In case a user brings up a custom.txt from the
                 * pc side and it references VBX don't make a big deal
                 * if we can't find a record.
                 */

                IF OPSYS = "MSDOS" AND cToken = "VBX" THEN
                  MESSAGE "Custom widget," cToken + ", defined without palette icon."
                      VIEW-AS ALERT-BOX ERROR BUTTONS OK.

                /* Added to prevent the now bogus "*VBX" definitions from
                 * being blindly added onto the last good definition (gfs)
                 */
                IF OPSYS = "WIN32" AND cToken = "VBX" THEN
                  mode = ?.
            END.
          
          END. /* "*" REC */

        END. /* LINE-LOOP: REPEAT for each line */

        /* Close the file */
        INPUT STREAM In_Stream  CLOSE.
  
        /* If the file was empty (i.e. it contained no Custom Object definitions) 
           then let the user know something was wrong. */
        IF empty-file THEN
          MESSAGE p_filename SKIP
                  "This file did not define any Custom Objects." SKIP(1)
                  "Please make sure you were pointing to the correct file."
              VIEW-AS ALERT-BOX WARNING BUTTONS OK.
      END. /* IF valid file */
    END. /* IF NOT RETRY */
  END. /* DO ON STOP... */

END PROCEDURE.

PROCEDURE getListVBXandCST:
DEFINE VARIABLE filename AS CHARACTER NO-UNDO.
DEFINE VARIABLE cnt AS INTEGER NO-UNDO.
DEFINE VARIABLE i AS INTEGER NO-UNDO.
DEFINE VARIABLE transAll AS LOGICAL NO-UNDO.

  /* Determine which files to read */
   FOR EACH _palette_item WHERE _palette_item._TYPE  = {&P-XCONTROL}
     AND _palette_item._ATTR BEGINS "CONTROL":U:

 /* Note that in _attr and _files fields, entries are 
  * separated by CHR(10) */
      temp = TRIM(SUBSTRING(_palette_item._attr,8,-1,"CHARACTER")).
      IF INDEX(CAPS(temp),"VBX") <> 0  THEN
      DO:
 FIND FIRST wVbxOcx WHERE wVbxOcx._vbxFile = ENTRY(1,temp,CHR(10)) NO-ERROR.
 IF NOT AVAILABLE wVbxOcx THEN
 DO:
    CREATE wVbxOcx.
    ASSIGN
  wVbxOcx._vbxFile = ENTRY(1,temp,CHR(10))
  wVbxOcx._subType = ENTRY(2,temp,CHR(10)).
 END.

        cnt = NUM-ENTRIES(_palette_item._files,CHR(10)).
        DO i = 1 TO cnt:
    filename = ENTRY(i,_palette_item._files,CHR(10)).
    FIND FIRST wFiles WHERE wFiles._filename = filename 
          AND wFiles._vbxFile = wVbxOcx._vbxFile NO-ERROR.
    IF NOT AVAILABLE wFiles THEN 
    DO:
      CREATE wFiles.
      ASSIGN wFiles._filename = filename
           wFiles._vbxFile = wVbxOcx._vbxFile
  .
    END.
 END. /* cycle through cst files */
      END. /* vbx exists */
   END. /* palette */

   FOR EACH _custom WHERE _custom._attr  BEGINS "CONTROL":
    temp = TRIM(SUBSTRING(_custom._attr,8,-1,"CHARACTER")).
    IF INDEX(CAPS(temp),"VBX") <> 0  THEN
    DO:
 FIND FIRST wVbxOcx WHERE wVbxOcx._vbxFile = ENTRY(1,temp,CHR(10)) NO-ERROR.
 IF NOT AVAILABLE wVbxOcx THEN
 DO:
    CREATE wVbxOcx.
    ASSIGN
  wVbxOcx._vbxFile = ENTRY(1,temp,CHR(10))
  wVbxOcx._subType = ENTRY(2,temp,CHR(10)).
 END.
        cnt = NUM-ENTRIES(_custom._files,CHR(10)).
        DO i = 1 TO cnt:
    filename = ENTRY(i,_custom._files,CHR(10)).
    FIND FIRST wFiles WHERE wFiles._filename = filename 
              AND wFiles._vbxFile = wVbxOcx._vbxFile 
  NO-ERROR.
    IF NOT AVAILABLE wFiles THEN 
    DO:
      CREATE wFiles.
      ASSIGN wFiles._filename = filename
           wFiles._vbxFile = wVbxOcx._vbxFile.
    END.
 END. /* cycle through cst files */
    END.
   END.
END PROCEDURE. /* getListVBXandCST */

PROCEDURE initReplace:
  DEFINE VARIABLE fName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ThisMessage AS CHARACTER NO-UNDO.
  DEFINE VARIABLE errStatus AS LOGICAL NO-UNDO.
  DEFINE VARIABLE createIt AS LOGICAL NO-UNDO.
DEFINE VARIABLE fPrefix  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE pBasename  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE bmpFile  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE errCreate AS LOGICAL NO-UNDO.

  FOR EACH wVbxOcx:
       ASSIGN vbxClassId = wVbxOcx._vbxFile
       typeShortName = wVbxOcx._subType
       CanMigrate = FALSE
       vbxMsg = "":U.
       RUN adeuib/_vbini.p (INPUT-OUTPUT vbxClassid
  , INPUT-OUTPUT typeShortName
  , OUTPUT CanMigrate
  , OUTPUT vbxMsg
  ).
       IF CanMigrate THEN
       DO:
          ASSIGN upFile = "adeicon/" + typeShortName + "-u.bmp"  
            downFile = "adeicon/" + typeShortName + "-d.bmp".
   CREATE "PROX.ControlDef" _ocx_image.
          IF VALID-HANDLE(_ocx_image) THEN 
   DO:
      ASSIGN _ocx_image:ClassID = vbxClassid
          _ocx_image:ShortName = typeShortName
  . 
   
    /* UP IMAGE FILES */
    ASSIGN bmpFile = upFile.
    {adeuib/_savebmp.i &direction="UP" &ocx="_ocx_image"}
    IF errCreate THEN
    DO:
 ASSIGN ThisMessage = "The Up Image File could not be created. Check that you have write permission to the directory and/or file. " + upFile
 .
 RUN adecomm/_s-alert.p (INPUT-OUTPUT errStatus, "W":U, "ok":U, ThisMessage).
    END.

    /* DOWN IMAGE FILES */
    ASSIGN bmpFile = downFile.
    {adeuib/_savebmp.i &direction="DOWN" &ocx="_ocx_image"}
    IF errCreate THEN
    DO:
 ASSIGN ThisMessage = "The Down Image File could not be created. Check that you have write permission to the directory and/or file. " + downFile
 .
 RUN adecomm/_s-alert.p (INPUT-OUTPUT errStatus, "W":U, "ok":U, ThisMessage).
    END.
          ASSIGN wVbxOcx._classId = vbxClassid
          wVbxOcx._shortName = typeShortName
          wVbxOcx._trans = "_TRANS"
          wVbxOcx._up-image-file = upFile
          wVbxOcx._down-image-file = downFile
   .
   END. /* valid _ocx_image */
       END.
       ELSE
   ASSIGN
          wVbxOcx._vbxMsg = vbxMsg
          wVbxOcx._trans = "_NOTTRANS".
  END.
END PROCEDURE. /* initReplace */

PROCEDURE handle-vbx:
DEFINE VARIABLE vbxFound AS LOGICAL NO-UNDO INITIAL FALSE.
DEFINE VARIABLE canTransAll AS LOGICAL NO-UNDO INITIAL FALSE.
define variable fName as character no-undo.
DEFINE VARIABLE fPrefix  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE pBasename  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE createIt  AS LOGICAL  NO-UNDO.
DEFINE VARIABLE ThisMessage  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE errStatus  AS LOGICAL  NO-UNDO.
DEFINE VARIABLE bmpFile  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE errCreate  AS LOGICAL  NO-UNDO.
  
  FIND FIRST _palette_item WHERE 
 _palette_item._type  = {&P-XCONTROL}
    AND _palette_item._attr BEGINS "CONTROL":U
    AND INDEX(CAPS(_palette_item._attr),"VBX") <> 0 NO-ERROR.
  IF AVAILABLE _palette_item THEN vbxFound = TRUE.
  ELSE 
  DO:
    FIND FIRST _custom WHERE _custom._attr BEGINS "CONTROL"
      AND INDEX(CAPS(_custom._attr),"VBX") <> 0 NO-ERROR.
    IF AVAILABLE _custom THEN ASSIGN vbxFound = TRUE.
  END.

  IF vbxFound THEN
  DO:
 ASSIGN
    advisorText = IF _start THEN "progress.cst and/or smart.cst."
    ELSE "custom cst file".
    advisorText = advisorText + " contains VBX controls. " 
  + CHR(10) + CHR(10)
  + "What do you want the UIB to do?"
    .
 ASSIGN
    advisorChoice = "&Replace all VBX controls with OCX.,_REPLACE-AUTO"
    advisorChoice = advisorChoice + ",&Delete all VBX controls.,_DELETE"
    advisorChoice = IF _start THEN advisorChoice + ",&Cancel " + "AB"
      ELSE advisorChoice + ",&Cancel custom cst file load"
    advisorChoice = advisorChoice + ",_CANCEL"
 .
 RUN adeuib/_advisor.w 
  (INPUT advisorText
         , INPUT advisorChoice
  , INPUT FALSE
  , INPUT "AB"
  , INPUT 0
  , INPUT-OUTPUT choice
  , OUTPUT pl_never_again).


 /* If cancel and start of UIB, exit UIB */
 /* start */
 IF _start THEN
 DO:
    IF choice = "_CANCEL" THEN RETURN "_ABORT".
           RUN getListVBXandCST.
    IF choice = "_DELETE" THEN
       RUN delVBX(INPUT "_ALL").
    ELSE 
    DO: 
       RUN initReplace.
       FOR EACH wVbxOcx WHERE wVbxOcx._trans = "_NOTTRANS":
          ASSIGN
      advisorText = "UIB could not automatically replace VBX control " + wVbxOcx._vbxFile + "." + CHR(10) + chr(10) 
  + "What do you want to do?" 
      advisorChoice = "&Select OCX to replace VBX control."
      advisorChoice = advisorChoice + ",_REPLACE-SELECT,&Delete VBX control,_DELETE"
      advisorChoice = advisorChoice + ",&Cancel UIB,_CANCEL"
      .
      RUN adeuib/_advisor.w 
   (INPUT advisorText
          , INPUT advisorChoice
   , INPUT FALSE
   , INPUT ?
   , INPUT ?
   , INPUT-OUTPUT choiceTrans
   , OUTPUT pl_never_again).
 
     IF choiceTrans = "_CANCEL" THEN 
         RETURN "_ABORT".
     ELSE IF choiceTrans = "_DELETE" THEN 
         ASSIGN wVbxOcx._trans = "_DELETE".
     ELSE 
     DO:
            RUN GetParent(INPUT _h_menu_win:HWND, OUTPUT ParentHWND).
   _ocx_trans = _h_Controls:GetControl(ParentHWND) NO-ERROR.
   IF NOT VALID-HANDLE(_ocx_trans) THEN 
   DO:
   /* same as cancel */
       RETURN "_ABORT". 
   END.
   ELSE
      ASSIGN 
         upFile = "adeicon/" + wVbxOcx._shortName + "-u.bmp"
         downFile = "adeicon/" + wVbxOcx._shortName + "-d.bmp"
      .
    /* DOWN IMAGE FILES */
    ASSIGN bmpFile = downFile.
    {adeuib/_savebmp.i &direction="DOWN" &ocx="_ocx_image"}
    IF errCreate THEN
    DO:
 ASSIGN ThisMessage = "The Down Image File could not be created. Check that you have write permission to the directory and/or file. " + downFile
 .
 RUN adecomm/_s-alert.p (INPUT-OUTPUT errStatus, "W":U, "ok":U, ThisMessage).
    END.

    /* UP IMAGE FILES */
    ASSIGN bmpFile = upFile.
    {adeuib/_savebmp.i &direction="UP" &ocx="_ocx_image"}
    IF errCreate THEN
    DO:
 ASSIGN ThisMessage = "The Up Image File could not be created. Check that you have write permission to the directory and/or file. " + upFile
 .
 RUN adecomm/_s-alert.p (INPUT-OUTPUT errStatus, "W":U, "ok":U, ThisMessage).
    END.

      ASSIGN
           wVbxOcx._trans = "_TRANS"
           wVbxOcx._classId = _ocx_trans:classId
           wVbxOcx._shortName = _ocx_trans:shortname
    wVbxOcx._up-image-file = upFile
    wVbxOcx._down-image-file = downFile
      .
     END.
      END. /* each not trans vbx */
     END. /* do replace */
   END. /* _start */
   ELSE
   DO:
            RUN getListVBXandCST.
     IF choice = "_CANCEL" THEN 
  RETURN "_CANCEL".
     ELSE IF choice = "_DELETE" THEN
  /* remove traces of vbx from file that we tried to load */
  ASSIGN wVbxOcx._trans = "_DELETE".
     ELSE
     DO: /* convert */
       RUN initReplace.
       FOR EACH wVbxOcx WHERE wVbxOcx._trans = "_NOTTRANS":
          ASSIGN
      advisorText = "UIB could not automatically replace VBX control " + wVbxOcx._vbxFile + "." + CHR(10) + chr(10) 
  + "What do you want to do?" 
      advisorChoice = "&Select OCX to replace VBX control."
      advisorChoice = advisorChoice + ",_REPLACE-SELECT,&Delete VBX control,_DELETE"
      advisorChoice = advisorChoice + ",&Cancel,_CANCEL"
      .
      RUN adeuib/_advisor.w 
   (INPUT advisorText
          , INPUT advisorChoice
   , INPUT FALSE
   , INPUT ?
   , INPUT ?
   , INPUT-OUTPUT choiceTrans
   , OUTPUT pl_never_again).
 
     IF choiceTrans = "_CANCEL" THEN 
   RETURN "_CANCEL".
     ELSE IF choiceTrans = "_DELETE" THEN 
  /* remove traces of vbx from all files that we tried to load */
   ASSIGN wVbxOcx._trans = "_DELETE".
     ELSE 
     DO:
   /* menu win since palette_win may not be avail yet */
            RUN GetParent(INPUT _h_menu_win:HWND, OUTPUT ParentHWND).
   _ocx_trans = _h_Controls:GetControl(ParentHWND) NO-ERROR.
   IF NOT VALID-HANDLE(_ocx_trans) THEN 
   /* same as cancel */
   /* remove traces of cst file that we tried to load */
      RETURN "_CANCEL".
   ELSE
      ASSIGN 
         wVbxOcx._trans = "_TRANS"
         wVbxOcx._classId = _ocx_trans:classId
         wVbxOcx._shortName = _ocx_trans:shortname
         upFile = "adeicon/" + wVbxOcx._shortName + "-u.bmp"
         downFile = "adeicon/" + wVbxOcx._shortName + "-d.bmp"
      .
    /* UP IMAGE FILES */
    ASSIGN bmpFile = upFile.
    {adeuib/_savebmp.i &direction="UP" &ocx="_ocx_image"}
    IF errCreate THEN
    DO:
 ASSIGN ThisMessage = "The Up Image File could not be created. Check that you have write permission to the directory and/or file. " + upFile
 .
 RUN adecomm/_s-alert.p (INPUT-OUTPUT errStatus, "W":U, "ok":U, ThisMessage).
    END.

    /* DOWN IMAGE FILES */
    ASSIGN bmpFile = downFile.
    {adeuib/_savebmp.i &direction="DOWN" &ocx="_ocx_image"}
    IF errCreate THEN
    DO:
 ASSIGN ThisMessage = "The Up Image File could not be created. Check that you have write permission to the directory and/or file. " + downFile
 .
 RUN adecomm/_s-alert.p (INPUT-OUTPUT errStatus, "W":U, "ok":U, ThisMessage).
    END.
   ASSIGN 
       wVbxOcx._up-image-file = upFile
       wVbxOcx._down-image-file = downFile
   .
     END. /* convert individually */
    END. /* Each that could not be convert */
 END. /* convert */
 END. /* not init */
 RUN cleanup.
 IF RETURN-VALUE = "_CANCEL" THEN RETURN "_CANCEL".
   END. /* vbx found */
END PROCEDURE. /* handleVBX */

PROCEDURE delVBX:
/* Have the list of files with VBX 
 * _deleteType may be _ALL, _NOTTRANS or the actual vbx filename
 */
DEFINE INPUT PARAMETER _deleteType AS CHARACTER NO-UNDO.
   IF _deleteType = "_ALL" THEN
   DO:
      FOR EACH wVbxOcx:
        wVbxOcx._trans = "_DELETE".
      END.
   END.
   ELSE IF _deleteType = "_NOTTRANS" THEN
   DO:
      FOR EACH wVbxOcx WHERE wVbxOcx._trans = "_NOTTRANS":
        wVbxOcx._trans = "_DELETE".
      END.
   END.
   ELSE
   DO:
      FOR EACH wVbxOcx WHERE wVbxOcx._vbxFile = _deleteType:
        wVbxOcx._trans = "_DELETE".
      END.
   END.
END PROCEDURE. /* delVBX */

/* read-store-custom-file: Read a custom file. */
PROCEDURE read-store-custom-file :
  DEFINE INPUT PARAMETER p_filename AS CHAR NO-UNDO.

  DEF VAR cLine         AS CHAR     NO-UNDO.
  DEF VAR temp          AS CHAR     NO-UNDO.
  DEF VAR master        AS LOGICAL  NO-UNDO.
  DEF VAR mstr-recid    AS RECID    NO-UNDO.
  DEF VAR newMstr-recid AS RECID    NO-UNDO.

  DEF VAR lineCnt  AS INTEGER NO-UNDO.
  DEF VAR controlLine  AS LOGICAL NO-UNDO INIT no.
  DEF VAR vbxFile  AS CHARACTER NO-UNDO.
  DEF VAR vbxLine  AS LOGICAL NO-UNDO INIT no.
  DEF VAR linenum AS INTEGER NO-UNDO.

  /* Read until the end of file.  Assume the file is empty until we hear
     otherwise. */
  DO ON STOP  UNDO, RETRY
     ON ERROR UNDO, RETRY:
    IF NOT RETRY THEN DO:
      /* Does the appropriate file exist? */
      ASSIGN FILE-INFO:FILE-NAME = p_filename NO-ERROR .
      IF ( FILE-INFO:FULL-PATHNAME ne ? ) THEN DO:
        INPUT STREAM In_Stream FROM VALUE(FILE-INFO:FULL-PATHNAME) NO-ECHO.
        /* Read line-by-line (DON'T USE A "REPEAT" HERE BECAUSE WE WANT TO
           SCOPE THE _custom RECORD TO THE WHOLE PROCEDURE).  */
        LINE-LOOP:
        DO WHILE TRUE ON STOP   UNDO LINE-LOOP, LEAVE LINE-LOOP
                      ON ENDKEY UNDO LINE-LOOP, LEAVE LINE-LOOP:
          ASSIGN
      cLine = "" /* Inialize the variable before the read. */
   .
          IMPORT STREAM In_Stream UNFORMATTED cLine.
   ASSIGN lineCnt = lineCnt + 1.

   /* Creation of workfile record */
   CREATE wLine.
   ASSIGN
     wLine._linenum = lineCnt
     wLine._filename = p_filename
     wLine._line = cLine
   .  
   /* Line manipulation */
          ASSIGN
             cLine = REPLACE(cLine,CHR(9)," "). /* convert Tabs to Spaces */
   .
          ASSIGN master      = IF (cline BEGINS "*":U  OR
                                   cline BEGINS "#":U) THEN yes ELSE no.
          
          IF NOT master THEN DO:
            IF cLine BEGINS "CONTROL" THEN DO:
        temp = REPLACE(TRIM(SUBSTRING(cLine,8,-1,"CHARACTER"))," ",",").
        IF INDEX(CAPS(temp),"VBX") <> 0  THEN
        DO:
     ASSIGN
              wLine._controlLine = yes
              wLine._vbxFile =  ENTRY(1,temp) 
              wLine._vbxLine =  yes
              vbxFile = wLine._vbxFile
              vbxLine = wLine._vbxLine
     . 
  END. /* vbx control line */
            END. /* control line */
     ELSE
     ASSIGN
              wLine._controlLine = no
              wLine._vbxFile = vbxFile
              wLine._vbxLine = vbxLine
     . 
            NEXT LINE-LOOP.
          END. /* Process record */
             
          /* Does this define a new palette icon? */
          IF cline BEGINS "#":U OR cLine BEGINS "*":U THEN DO:
     /* reached a new master record, was the last set a vbx control set of records?
      * if so, make sure that all records have the correct info */
     ASSIGN newMstr-recid = RECID(wLine).
     IF vbxLine THEN 
     DO:
        FIND FIRST wLine WHERE RECID(wLine) = mstr-recid NO-ERROR.
        IF AVAILABLE wLine THEN DO:
          ASSIGN linenum = wLine._linenum.
          FOR EACH wLine WHERE wLine._linenum >= linenum
    AND wLine._filename = p_filename
    AND NOT wLine._vbxLine
    AND RECID(wLine) <> newMstr-recid
   :

    ASSIGN wLine._vbxLine = vbxLine
    wLine._vbxFile = vbxFile.
          END.
        END.
     END.
            ASSIGN mstr-recid     = newMstr-recid
       controlLine    = no
       vbxFile    = "":U
       vbxLine    = no
     .
            NEXT LINE-LOOP.
          END. /* "#"  or "*" REC */                      
        END. /* LINE-LOOP: REPEAT for each line */
        /* Close the file */
        INPUT STREAM In_Stream  CLOSE.

 /* Take care of EOF */
 /* was the last set a vbx control set of records?
  * if so, make sure that all records have the correct info */
 IF vbxLine THEN 
 DO:
        FIND FIRST wLine WHERE RECID(wLine) = mstr-recid NO-ERROR.
        IF AVAILABLE wLine THEN DO:
          ASSIGN linenum = wLine._linenum.
          FOR EACH wLine WHERE wLine._linenum >= linenum
    AND wLine._filename = p_filename
    AND NOT wLine._vbxLine
   :

    ASSIGN wLine._vbxLine = vbxLine
    wLine._vbxFile = vbxFile.
          END.
        END.
 END.

      END. /* IF valid file */
    END. /* IF NOT RETRY */
  END. /* DO ON STOP... */
END PROCEDURE. /* read-store-custom-file */


PROCEDURE cleanup:
/* clean up cst and _palette_item and custom */
/* _trans:
 * _TRANS = can be converted into ocx
 * _DELETE = remove from any cst files that contain this vbx
 */

DEFINE VARIABLE linenum AS INTEGER NO-UNDO. 

 /* Deal with the osfiles */
 FOR EACH wFiles BREAK BY wFiles._filename:
           IF FIRST-OF(wFiles._filename) THEN
    DO:
              ASSIGN FILE-INFO:FILE-NAME = wFiles._filename NO-ERROR .
              IF ( FILE-INFO:FULL-PATHNAME ne ? ) THEN DO:
          FIND FIRST wLine WHERE wLine._filename = wFiles._filename NO-ERROR.
          IF NOT AVAILABLE wLine THEN RUN read-store-custom-file(wFiles._filename).

   /* Remove _DELETE vbx */
          FOR EACH wVbxOcx WHERE wVbxOcx._trans = "_DELETE":
                    FOR EACH wLine WHERE wLine._filename = wFiles._filename
       AND wLine._vbxLine = yes
       AND wLine._vbxFile = wVbxOcx._vbxFile:
                DELETE wLine.
             END.  
          END.  
  FOR EACH wVbxOcx WHERE wVbxOcx._trans = "_TRANS":
     FOR EACH wLine WHERE wLine._filename = wFiles._filename
   AND wLine._vbxFile = wVbxOcx._vbxFile
   AND wLine._vbxLine = yes:
         IF wLine._controlLine THEN 
  ASSIGN
  wLine._line =  "CONTROL " + wVbxOcx._classId + " " + wVbxOcx._shortName.
  ELSE IF wLine._line BEGINS "#" THEN
    wLine._line = "#" + wVbxOcx._shortname + " " + wVbxOcx._shortname.
  ELSE IF wLine._line BEGINS "LABEL" THEN
    wLine._line = "LABEL " + wVbxOcx._shortname.
  ELSE IF wLine._line BEGINS "UP-IMAGE-FILE" THEN
    wLine._line = 'UP-IMAGE-FILE "' + wVbxOcx._up-image-file + '"'.
  ELSE IF wLine._line BEGINS "DOWN-IMAGE-FILE" THEN
    wLine._line = 'DOWN-IMAGE-FILE "' + wVbxOcx._down-image-file + '"'.

  IF wLine._line BEGINS "*" THEN
  DO:
    wLine._line = "#" + wVbxOcx._shortname + " " + wVbxOcx._shortname.
     /* Since we are converting to an icon, we need to 
      * create the label, and image 
      */
     ASSIGN linenum = wLine._linenum.
     CREATE wlineCreate.
     ASSIGN wLineCreate._line = 'UP-IMAGE-FILE "' + wVbxOcx._up-image-file + '"'
     wlineCreate._filename = wFiles._filename
     wlineCreate._vbxFile = wVbxOcx._vbxFile
     wlineCreate._vbxLine = yes
     wlineCreate._linenum = linenum + 1.
     CREATE wlineCreate.
     ASSIGN wlineCreate._line = 'DOWN-IMAGE-FILE "' + wVbxOcx._down-image-file + '"'
     wlineCreate._filename = wFiles._filename
     wlineCreate._vbxFile = wVbxOcx._vbxFile
     wlineCreate._vbxLine = yes
     wlineCreate._linenum = linenum + 1.
     CREATE wlineCreate.
     ASSIGN wlineCreate._line = "LABEL " + wVbxOcx._shortname
     wlineCreate._filename = wFiles._filename
     wlineCreate._vbxFile = wVbxOcx._vbxFile
     wlineCreate._vbxLine = yes
     wlineCreate._linenum = linenum + 1.
  END.
     END.
  END.
          OUTPUT STREAM Out_STREAM TO VALUE(FILE-INFO:FULL-PATHNAME) NO-ECHO.
          FOR EACH wLine WHERE wLine._filename = wFiles._filename
        BY wLine._linenum:
      IF LENGTH(wLine._line) = 0 THEN 
                PUT STREAM Out_STREAM UNFORMATTED SKIP(1).
      ELSE
                PUT STREAM Out_STREAM UNFORMATTED wLine._line SKIP.
          END.
          OUTPUT STREAM Out_Stream CLOSE.
       END. /* valid filename */
           END. /* FIRST-OF wFiles */
 END. /* wFiles */

 /* Deal with the _palette_list and custom */
 FOR EACH _custom: DELETE _custom. END.
 RUN adeuib/_initpal.p.
 RUN adeuib/_cr_cust.p (INPUT no).
 IF RETURN-VALUE = "_CANCEL" THEN RETURN "_CANCEL".
END PROCEDURE. /* cleanup */

/* GetParent - Get the parent of a Progress window (real HWND) */
PROCEDURE GetParent EXTERNAL "USER32.DLL":
   DEFINE INPUT  PARAMETER in-hwn AS LONG.
   DEFINE RETURN PARAMETER hwnd   AS LONG.
END.          



