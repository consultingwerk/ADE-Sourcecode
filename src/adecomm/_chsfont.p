/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*****************************************************************************

Procedure: adecomm/_chsfont.p

Syntax:
    RUN adecomm/_chsfont.p( INPUT cipTitle, INPUT-OUTPUT iiopFontNumber,
                           OUTPUT pressed_OK)

Description:
    This is the font selector which lets the user change the current font.
    The trick is to represent is the DEFAULT font  A button should show the
    default font of its frame for the default, while a frame or window 
    should show the System Default.

Parameters:
  INPUT         cipTitle: Title for the Font Dialog.
  INPUT         iipDfltFontNumber: Font to show when user chooses DEFAULT.
  INPUT-OUTPUT  iiopFontNumber: The initial font, also reset to output values.
	OUTPUT  pressed_OK: FALSE if cancelled dialog box.

Author: Ravi-Chandar Ramalingam

---------------------------------------------------------------------------- 
Test code:
def var ifont AS INTEGER NO-UNDO.
def var pressed_OK  AS LOGICAL.
RUN adecomm/_chsfont.p ("Title", ?,
  INPUT-OUTPUT ifont,
  OUTPUT pressed_OK).
MESSAGE ifont pressed_OK.
******************************************************************************/

&GLOBAL-DEFINE WIN95-BTN
&Global-define SKP ""
{adecomm/commeng.i}   /* Help pre-processor directives                       */
{adecomm/adestds.i}
/******************************* Definitions *********************************/
DEFINE INPUT        PARAMETER cipTitle          AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER iipDfltFontNumber AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER iiopFontNumber    AS INTEGER NO-UNDO.
DEFINE       OUTPUT PARAMETER pressed_OK        AS LOGICAL NO-UNDO.

DEFINE BUTTON bOk LABEL "OK" {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON bCancel LABEL "Cancel" {&STDPH_OKBTN} AUTO-END-KEY.
DEFINE BUTTON bEdit LABEL "Edit...":C10 SIZE 10 BY {&H_OKBTN} MARGIN-EXTRA DEFAULT.
DEFINE BUTTON bSave LABEL "&Save Font Settings":C19 SIZE 22 BY {&H_OKBTN} MARGIN-EXTRA DEFAULT.
DEFINE BUTTON bHelp LABEL "&Help" {&STDPH_OKBTN}.

DEFINE VARIABLE ldummy AS LOGICAL NO-UNDO.
DEFINE BUTTON iRightArrow IMAGE-UP FILE "btn-right-arrow":U.
DEFINE BUTTON iLeftArrow  IMAGE-UP FILE "btn-left-arrow":U.

DEFINE VARIABLE iFontNumber AS INTEGER NO-UNDO.

DEFINE VARIABLE lChanged AS LOGICAL NO-UNDO.
DEFINE VARIABLE lSaved AS LOGICAL NO-UNDO.
DEFINE VARIABLE highest-font AS INTEGER NO-UNDO.

DEFINE VARIABLE tFontDefault AS CHARACTER INITIAL "AaBbYyZz" FORMAT "X(10)"
	VIEW-AS TEXT SIZE 10 BY 3.
DEFINE VARIABLE tFont0 LIKE tFontDefault.
DEFINE VARIABLE tFont1 LIKE tFontDefault.
DEFINE VARIABLE tFont2 LIKE tFontDefault.
DEFINE VARIABLE tFont3 LIKE tFontDefault.

DEFINE VARIABLE tDefault AS CHARACTER INITIAL "Default"
	FONT 4 FORMAT "X(7)" VIEW-AS TEXT.
DEFINE VARIABLE tZero AS CHARACTER INITIAL "0"
	FONT 4 FORMAT "X(3)" VIEW-AS TEXT.
DEFINE VARIABLE tOne LIKE tZero INITIAL "1".
DEFINE VARIABLE tTwo LIKE tZero INITIAL "2".
DEFINE VARIABLE tThree LIKE tZero INITIAL "3".

DEFINE VARIABLE ivFrameWidth AS INTEGER.

DEFINE RECTANGLE rFontDefault
	SIZE 11 BY 3.25 FGCOLOR ? EDGE-PIXELS 1.
DEFINE RECTANGLE rFont0 LIKE rFontDefault.
DEFINE RECTANGLE rFont1 LIKE rFontDefault.
DEFINE RECTANGLE rFont2 LIKE rFontDefault.
DEFINE RECTANGLE rFont3 LIKE rFontDefault.

DEFINE VARIABLE tSample AS CHARACTER INITIAL "Sample"
	FORMAT "X(9)" LABEL "Sample" VIEW-AS TEXT.

DEFINE RECTANGLE rSelected SIZE-PIXELS 1 BY 1 FGCOLOR ? BGCOLOR 0 EDGE-PIXELS 3 NO-FILL.

&IF {&OKBOX} &THEN
DEFINE RECTANGLE rHeavyRule {&STDPH_OKBOX}.
&ENDIF

DEFINE FRAME frFontEdit
  SKIP({&TFM_WID})
  tSample NO-LABEL AT 25 SKIP(3)
  iLeftArrow AT 4 SPACE iRightArrow SPACE(2)
  tFontDefault NO-LABEL SPACE(2)
  tFont0 NO-LABEL SPACE(2)
  tFont1 NO-LABEL SPACE(2)
  tFont2 NO-LABEL SPACE(2)
  tFont3 NO-LABEL 

  rFontDefault AT ROW-OF tFontDefault - 0.1 COL-OF tFontDefault - 0.4
  rFont0 AT ROW-OF tFont0 - 0.1 COL-OF tFont0 - 0.4
  rFont1 AT ROW-OF tFont1 - 0.1 COL-OF tFont1 - 0.4
  rFont2 AT ROW-OF tFont2 - 0.1 COL-OF tFont2 - 0.4
  rFont3 AT ROW-OF tFont3 - 0.1 COL-OF tFont3 - 0.4 SKIP(0.25)

  rSelected tDefault AT ROW-OF rSelected COL-OF tFontDefault + 2 NO-LABEL
  tZero AT ROW-OF rSelected COL-OF tFont0 + 4 NO-LABEL
  tOne AT ROW-OF rSelected COL-OF tFont1 + 4 NO-LABEL
  tTwo AT ROW-OF rSelected COL-OF tFont2 + 4 NO-LABEL
  tThree AT ROW-OF rSelected COL-OF tFont3 + 4 NO-LABEL

  {adecomm/okform.i
      &BOX    = "rHeavyRule"
      &STATUS = "no"
      &OK     = "bOK"
      &CANCEL = "bCancel"
      &OTHER  = "space({&HM_DBTNG}) bEdit space({&HM_DBTNG}) bSave"
      &HELP   = "bHelp"}
WITH SIDE-LABELS TITLE cipTitle WIDTH 90
     VIEW-AS DIALOG-BOX DEFAULT-BUTTON bOK.

/* **************************** THREE-D Support *************************** */       
/* In 3D, we want to change some of the characteristics of the widgets
   to show better in this environment. Changes include:
      - Make Hilight box solid black
 */
IF SESSION:THREE-D THEN ASSIGN 
  rSelected:EDGE-PIXELS = 1  
  rSelected:FILLED      = YES
  .

/**************************** Internal Procedures ***************************/
PROCEDURE EditFont.
  DEFINE INPUT PARAMETER iipFontNumber AS INTEGER NO-UNDO.
  DEFINE VARIABLE lvAccepted AS LOGICAL NO-UNDO.

  IF iipFontNumber > -1 AND iipFontNumber < 256 THEN DO:
    /* Change cursor to wait.  The dialog will set the pointer back */
    ldummy = FRAME frFontEdit:LOAD-MOUSE-POINTER ("WAIT":U).
    SYSTEM-DIALOG FONT iipFontNumber UPDATE lvAccepted.
    ldummy = FRAME frFontEdit:LOAD-MOUSE-POINTER ("":U).
    /* If anything changed, then note the fact. */
    IF lvAccepted   
    THEN ASSIGN lChanged      = YES
                highest-font = MAX(highest-font, iipFontNumber).
  END.
  ELSE
    MESSAGE "Font number" iipFontNumber "is not valid." SKIP
	    "Valid font numbers are from 0 - 255."
	VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.   
END PROCEDURE.

PROCEDURE GetStartingFontNumber.
  DEFINE INPUT PARAMETER ipFontNumber AS INTEGER.
  DEFINE OUTPUT PARAMETER opFontStart AS INTEGER.

  opFontStart = TRUNCATE(ipFontNumber / 4, 0) * 4.
END PROCEDURE.

PROCEDURE SetSampleFont:
  DEF INPUT PARAMETER iipFont AS INTEGER NO-UNDO.
       
  DEFINE VAR new-Width-P AS INTEGER NO-UNDO.
  DEFINE VAR new-X       AS INTEGER NO-UNDO.
       
  DO WITH FRAME frFontEdit:
    ASSIGN tSample:FONT = iipFont
           new-width-p  = MIN(ivFrameWidth - 2,
                          FONT-TABLE:GET-TEXT-WIDTH-PIXELS
                                       (tSample:SCREEN-VALUE,iipFont))
  	   new-x        = (ivFrameWidth - new-width-p) / 2
                                       .
    /* Set X and WIDTH-P in the order that won't cause any "Widget in Frame"
       errors. */                                  
    IF new-width-p < tSample:WIDTH-P                                    
    THEN ASSIGN tSample:WIDTH-P = new-width-p
  	      tSample:X         = new-x.  
    ELSE ASSIGN tSample:X       = new-x
                tSample:WIDTH-P = new-width-p.
  END.
END PROCEDURE.

PROCEDURE SetTextFonts.
  DEFINE INPUT PARAMETER ivFontStart AS INTEGER.

  DO WITH FRAME frFontEdit:
    IF FONT-TABLE:NUM-ENTRIES < (ivFontStart + 4) OR
       highest-font <= (ivFontStart + 4) 
    THEN FONT-TABLE:NUM-ENTRIES = ivFontStart + 4.
    
    ASSIGN tFont0:FONT = ivFontStart
	   tZero:SCREEN-VALUE = STRING(ivFontStart)
	   tFont1:FONT = tFont0:FONT + 1
	   tOne:SCREEN-VALUE = STRING(tFont0:FONT + 1)
	   tFont2:FONT = tFont1:FONT + 1
	   tTwo:SCREEN-VALUE = STRING(tFont1:FONT + 1)
	   tFont3:FONT = tFont2:FONT + 1
	   tThree:SCREEN-VALUE = STRING(tFont2:FONT + 1).

    IF iFontNumber <> ? AND (iFontNumber < tFont0:FONT OR
        iFontNumber > tFont3:FONT) THEN
      rSelected:HIDDEN = TRUE.
    ELSE IF rSelected:HIDDEN THEN
      rSelected:HIDDEN = FALSE.

    IF iFontNumber = ? OR iFontNumber < 8 OR 
        iFontNumber < tFont0:FONT OR iFontNumber > tFont3:FONT THEN
      bEdit:SENSITIVE = FALSE.
    ELSE IF NOT bEdit:SENSITIVE THEN
      bEdit:SENSITIVE = TRUE.

    IF tFont0:FONT = 0 THEN
      iLeftArrow:SENSITIVE = FALSE.
    ELSE IF NOT iLeftArrow:SENSITIVE THEN
      iLeftArrow:SENSITIVE = TRUE.
      
    IF tFont3:FONT = 255 THEN
      iRightArrow:SENSITIVE = FALSE.
    ELSE IF NOT iRightArrow:SENSITIVE THEN
      iRightArrow:SENSITIVE = TRUE.   
  END.
END PROCEDURE.


PROCEDURE HighlightSelectedFont.
  DEFINE INPUT PARAMETER whipBox AS WIDGET-HANDLE.

  DO WITH FRAME frFontEdit:
    ASSIGN rSelected:X             = whipBox:X - 4
	   rSelected:Y             = whipBox:Y - 4
	   rSelected:WIDTH-PIXELS  = whipBox:WIDTH-PIXELS + 8
	   rSelected:HEIGHT-PIXELS = whipBox:HEIGHT-PIXELS + 8.
  END.
END PROCEDURE.
  
PROCEDURE SaveSettings:       
  DEFINE VAR ok_save AS LOGICAL NO-UNDO.
  /* Check the ability to save settings */
  RUN adeshar/_chksave.p (INPUT "uib", OUTPUT ok_save).
  IF ok_save THEN DO:
    PUT-KEY-VALUE FONT ALL. 
    lSaved = YES.
  END.
END PROCEDURE.

/*************************** UserInterface Triggers **************************/
ON WINDOW-CLOSE OF FRAME frFontEdit APPLY "END-ERROR":U TO SELF.

ON CHOOSE OF bHelp IN FRAME frFontEdit OR HELP OF FRAME frFontEdit
  RUN adecomm/_adehelp.p ( "comm", "CONTEXT", {&Font_Dlg_Box}, ? ).

ON CHOOSE OF bEdit IN FRAME frFontEdit 
  RUN EditFont(iFontNumber).

ON MOUSE-SELECT-CLICK OF tFont0, tFont1, tFont2, tFont3
	IN FRAME frFontEdit DO:
  ASSIGN iFontNumber = SELF:FONT
         rSelected:HIDDEN = TRUE.
  RUN HighlightSelectedFont(SELF).
  ASSIGN rSelected:HIDDEN = FALSE.
  RUN SetSampleFont (iFontNumber).
  IF iFontNumber = ? OR iFontNumber < 8 THEN
    bEdit:SENSITIVE = FALSE.
  ELSE IF NOT bEdit:SENSITIVE THEN
    bEdit:SENSITIVE = TRUE.
END.

ON MOUSE-SELECT-CLICK OF tFontDefault IN FRAME frFontEdit DO:
  ASSIGN iFontNumber = ?
         rSelected:HIDDEN = TRUE.
  RUN HighlightSelectedFont(SELF). 
  ASSIGN rSelected:HIDDEN = FALSE
         bEdit:SENSITIVE  = FALSE.
  RUN SetSampleFont (SELF:FONT).
END.


ON MOUSE-SELECT-DBLCLICK OF tFont0, tFont1, tFont2, tFont3 IN FRAME frFontEdit
DO:
  DEFINE VARIABLE lvAcceptChange AS LOGICAL INITIAL FALSE.

  IF SELF:FONT > 7 THEN RUN EditFont (SELF:FONT).
  ELSE DO:
    MESSAGE "Only font numbers 8-255 are customizable."
	VIEW-AS ALERT-BOX INFORMATION BUTTONS Ok.
  END.
END.


ON MOUSE-SELECT-DBLCLICK OF tFontDefault
DO:
  MESSAGE "Only font numbers 8-255 are customizable."
	VIEW-AS ALERT-BOX INFORMATION BUTTONS Ok.
END.

ON CHOOSE OF iLeftArrow DO:
  DEFINE VARIABLE ivFontStart AS INTEGER.

  ASSIGN ivFontStart = tFont0:FONT IN FRAME frFontEdit.
  IF ivFontStart <> 0 THEN DO:
    IF iFontNumber <> ? THEN  /* if default font is not selected */
      ASSIGN rSelected:HIDDEN = TRUE.
    ivFontStart = ivFontStart - 4.
    RUN SetTextFonts(ivFontStart).
  END.
END.


ON CHOOSE OF iRightArrow DO:
  DEFINE VARIABLE ivFontStart as integer.

  ASSIGN ivFontStart = tFont3:FONT IN FRAME frFontEdit + 1.
  IF ivFontStart > 255 THEN
    MESSAGE "Valid Font numbers are from 0 to 255."
	VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  ELSE
    DO:
      IF FONT-TABLE:NUM-ENTRIES < (ivFontStart + 4) THEN
        FONT-TABLE:NUM-ENTRIES = ivFontStart + 4.
      IF iFontNumber <> ? THEN /* if default font is not selected */
        rSelected:HIDDEN = TRUE.
      RUN SetTextFonts(ivFontStart).
    END.
END.

ON CHOOSE OF bSave 
  RUN SaveSettings.

ON GO OF FRAME frFontEdit DO:
  DEF VAR lOK AS LOGICAL NO-UNDO.
  /* Tell the user if they changed any colors, but did not save. */
  IF lChanged AND NOT lSaved THEN DO:
    MESSAGE "Font settings were edited, but they have" {&SKP}
            "not been saved.  These changes will be lost when" {&SKP}
            "you leave the PROGRESS session." SKIP(1)
            "Would you like to save settings?"
            VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO-CANCEL UPDATE lOK.
    IF lOK eq ? THEN RETURN NO-APPLY.
    ELSE IF lOK THEN RUN SaveSettings.
  END.
END.

ON ENDKEY OF FRAME frFontEdit DO:
  /* Tell the user that changes make to the SYSTEM-DIALOG will not
     be undone. */
  IF lChanged OR lSaved THEN DO:
    MESSAGE "Changes make editing fonts or saving" {&SKP}
            "font settings cannot be undone." SKIP(1)
            "Cancelling this dialog will not undo those changes."
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
  END.
END.

/****************************** Main Loop ******************************/
DO WITH FRAME frFontEdit:
  DEFINE VARIABLE ivFontStart AS INTEGER.

  /* Always make sure that we have the minimal font entries. */
  IF FONT-TABLE:NUM-ENTRIES < 8 THEN
    FONT-TABLE:NUM-ENTRIES = 8.

  /* Note the highest font so far. */
  highest-font = FONT-TABLE:NUM-ENTRIES.
  
  /* Run time layout for button area. */
  {adecomm/okrun.i  
     &FRAME = "FRAME frFontEdit" 
     &BOX   = "rHeavyRule"
     &OK    = "bOK" 
     &HELP  = "bHelp"
  }

  ASSIGN FRAME frFontEdit:HIDDEN = TRUE.
  
  ASSIGN iFontNumber = iiopFontNumber /* Copy output parameter to local var */
  
         tSample:HEIGHT-PIXELS = tSample:HEIGHT-PIXELS + 50
	 tSample:WIDTH-PIXELS = tSample:WIDTH-PIXELS + 80
	 tSample:SCREEN-VALUE = "Sample"
	 
	 tDefault:SCREEN-VALUE = "Default"
	 tZero:SCREEN-VALUE = "0"
	 tOne:SCREEN-VALUE = "1"
	 tTwo:SCREEN-VALUE = "2"
	 tThree:SCREEN-VALUE = "3"

	 tFont0:FONT = 0
	 tFont1:FONT = 1
	 tFont2:FONT = 2
	 tFont3:FONT = 3
	 tFontDefault:FONT = iipDfltFontNumber
	 
	 tFont0:SCREEN-VALUE = "AaBbYyZz"
	 tFont1:SCREEN-VALUE = "AaBbYyZz"
	 tFont2:SCREEN-VALUE = "AaBbYyZz"
	 tFont3:SCREEN-VALUE = "AaBbYyZz"
	 tFontDefault:SCREEN-VALUE = "AaBbYyZz"
         
         rFontDefault:X = tFontDefault:X - 1
         rFontDefault:Y = tFontDefault:Y - 1
         rFontDefault:WIDTH-P  = tFontDefault:WIDTH-P + 2
         rFontDefault:HEIGHT-P = tFontDefault:HEIGHT-P + 2
         
         rFont0:X = tFont0:X - 1
         rFont0:Y = tFont0:Y - 1
         rFont0:WIDTH-P  = tFont0:WIDTH-P + 2
         rFont0:HEIGHT-P = tFont0:HEIGHT-P + 2
         
         rFont1:X = tFont1:X - 1
         rFont1:Y = tFont1:Y - 1
         rFont1:WIDTH-P  = tFont1:WIDTH-P + 2
         rFont1:HEIGHT-P = tFont1:HEIGHT-P + 2
         
         rFont2:X = tFont2:X - 1
         rFont2:Y = tFont2:Y - 1
         rFont2:WIDTH-P  = tFont2:WIDTH-P + 2
         rFont2:HEIGHT-P = tFont2:HEIGHT-P + 2
         
         rFont3:X = tFont3:X - 1
         rFont3:Y = tFont3:Y - 1
         rFont3:WIDTH-P  = tFont3:WIDTH-P + 2
         rFont3:HEIGHT-P = tFont3:HEIGHT-P + 2
         
        ldummy = rSelected:MOVE-TO-BOTTOM()
        iLeftArrow:HEIGHT-PIXELS = iLeftArrow:HEIGHT-PIXELS *
                   (IF SESSION:PIXELS-PER-ROW = 21 THEN 1.4 ELSE 1)
        iLeftArrow:WIDTH-PIXELS = iLeftARROW:WIDTH-PIXELS *
                   (IF SESSION:PIXELS-PER-COLUMN = 6 THEN 1.2 ELSE 1) 
        iLeftArrow:Y = (rFontDefault:Y + (rFontDefault:HEIGHT-PIXELS / 2))
				- (iLeftArrow:HEIGHT-PIXELS / 2)
        iRightArrow:HEIGHT-PIXELS = iLeftArrow:HEIGHT-PIXELS
        iRightArrow:WIDTH-PIXELS  = iLeftArrow:WIDTH-PIXELS
 	iRightArrow:Y = (rFont3:Y + (rFont3:HEIGHT-PIXELS / 2))
				- (iRightArrow:HEIGHT-PIXELS / 2).

  /*
    Display the correct initial font based on the font that was passed in
    and highlight the passed font.
  */
  
  IF iFontNumber = ? THEN DO:
    RUN SetTextFonts(0).
    RUN HighlightSelectedFont(tFontDefault:HANDLE).
  END.
  ELSE DO:
    RUN GetStartingFontNumber(iFontNumber, OUTPUT ivFontStart).
    RUN SetTextFonts(ivFontStart). 
    IF iFontNumber = ivFontStart THEN
      RUN HighlightSelectedFont(tFont0:HANDLE).
    ELSE IF iFontNumber = ivFontStart + 1 THEN
      RUN HighlightSelectedFont(tFont1:HANDLE).
    ELSE IF iFontNumber = ivFontStart + 2 THEN
      RUN HighlightSelectedFont(tFont2:HANDLE).
    ELSE IF iFontNumber = ivFontStart + 3 THEN
      RUN HighlightSelectedFont(tFont3:HANDLE).
  END.

  ASSIGN ivFrameWidth = FRAME frFontEdit:WIDTH-PIXELS -
                        FRAME frFontEdit:BORDER-LEFT-P -
                        FRAME frFontEdit:BORDER-RIGHT-P.
  ASSIGN FRAME frFontEdit:HIDDEN = FALSE.

  DO TRANSACTION ON ENDKEY UNDO, LEAVE:
    ASSIGN pressed_OK = no.
    RUN setSampleFont (IF iFontNumber eq ? 
                       THEN iipDfltFontNumber
                       ELSE iFontNumber).

    ENABLE ALL EXCEPT bEdit iLeftArrow iRightArrow WITH FRAME frFontEdit.
    IF NOT RETRY THEN
      UPDATE bOk bCancel bHelp WITH FRAME frFontEdit.
    ASSIGN iiopFontNumber = iFontNumber  /* Send back changes */
           pressed_OK     = yes.
  END.
  HIDE FRAME frFontEdit.
END.
