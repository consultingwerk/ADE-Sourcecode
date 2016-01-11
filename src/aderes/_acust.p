/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _acust.p
 *
 *    This dialog box handles the "simple" GUI customization features of
 *    RESULTS.
 */
&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-define.i }
{ aderes/y-define.i }
{ adecomm/adestds.i }
{ aderes/s-system.i }
{ aderes/_alayout.i }
{ aderes/reshlp.i   }

&SCOPED-DEFINE FRAME-NAME customize

DEFINE OUTPUT PARAMETER lRet AS LOGICAL NO-UNDO.

DEFINE VARIABLE tmpName AS CHARACTER NO-UNDO. /* logo filename */
DEFINE VARIABLE qbf-a   AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-a-h AS HANDLE    NO-UNDO.
DEFINE VARIABLE qbf-d-h AS HANDLE    NO-UNDO.
DEFINE VARIABLE qbf-e   AS CHARACTER NO-UNDO. /* file extension */
DEFINE VARIABLE qbf-g-h AS HANDLE    NO-UNDO.
DEFINE VARIABLE qbf-i   AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i-h AS HANDLE    NO-UNDO.
DEFINE VARIABLE qbf-p-h AS HANDLE    NO-UNDO.
DEFINE VARIABLE qbf-s   AS LOGICAL   NO-UNDO.

DEFINE BUTTON imageBut SIZE-PIXELS 38 BY 38.
{ aderes/_asbar.i }

DEFINE RECTANGLE rect-1 SIZE-PIXELS 10 BY 3 EDGE-PIXELS 3 BGCOLOR 0.
DEFINE RECTANGLE rect-2 SIZE-PIXELS 10 BY 3 EDGE-PIXELS 3 BGCOLOR 0.

FORM
  SKIP(1)
  qbf-i FORMAT "x(20)":u VIEW-AS TEXT NO-LABEL
 
  qbf-product FORMAT "x(30)":u {&STDPH_FILL} AT 2 
    LABEL "&Product Name"
    VIEW-AS FILL-IN SIZE 30 BY 1
    
  imageBut NO-LABEL 

  qbf-left FORMAT "x(1)":u {&STDPH_FILL} LABEL "&Delimiters"
    VIEW-AS FILL-IN SIZE 3 BY 1

  qbf-right FORMAT "x(1)":u {&STDPH_FILL} NO-LABEL
    VIEW-AS FILL-IN SIZE 3 BY 1
  SKIP(.5)
  rect-1 AT 2
  SKIP(1)

  qbf-goodbye AT 2 LABEL "How To Leave"
    VIEW-AS RADIO-SET SIZE 30 BY 2.5 VERTICAL 
    RADIO-BUTTONS "b":u, NO, "a":u, YES

  qbf-awrite AT 80
    LABEL "Write Configuration"
    VIEW-AS RADIO-SET SIZE 30 BY 2.5 VERTICAL
    RADIO-BUTTONS "b":u, NO, "&After each Dialog Box", YES
  SKIP(.5)
  rect-2 AT 2
  SKIP(.5)

  qbf-checkdb AT 2 LABEL "&Rebuild Check During Startup" 
    VIEW-AS TOGGLE-BOX
   
  &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &THEN
  qbf-threed AT 2
    VIEW-AS TOGGLE-BOX
  &ENDIF

  {adecomm/okform.i 
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  WITH FRAME {&FRAME-NAME} VIEW-AS DIALOG-BOX KEEP-TAB-ORDER THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee SIDE-LABELS WIDTH 150
  TITLE "Preferences".

ON GO OF FRAME {&FRAME-NAME} DO:
  IF    qbf-product         = qbf-product:SCREEN-VALUE
    AND _minLogo            = tmpName
    AND qbf-left            = qbf-left:SCREEN-VALUE
    AND qbf-right           = qbf-right:SCREEN-VALUE
    AND STRING(qbf-goodbye) = qbf-goodbye:SCREEN-VALUE
    AND STRING(qbf-awrite)  = qbf-awrite:SCREEN-VALUE
    AND STRING(qbf-checkdb) = qbf-checkdb:SCREEN-VALUE
    &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &THEN
    AND STRING(qbf-threed)  = qbf-threed:SCREEN-VALUE
    &ENDIF
    THEN RETURN.

  IF qbf-left:SCREEN-VALUE = qbf-right:SCREEN-VALUE THEN DO:
    MESSAGE "The Start and End delimiters must be" SKIP
            "different characters."
      VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.

  IF tmpName > "" THEN DO:
    ASSIGN
      tmpName = SUBSTRING(tmpName,1,R-INDEX(tmpName,".":u) - 1,"CHARACTER":u)
      qbf-s   = qbf-win:LOAD-ICON(tmpName)
      .

    IF NOT qbf-s THEN DO:
      MESSAGE tmpName + " could not be loaded to the window."
        VIEW-AS ALERT-BOX WARNING.
      tmpName = "".
    END.
  END.
  
  RUN adecomm/_setcurs.p ("WAIT":u).

  /* Update the current values into the configuration file */
  ASSIGN
    qbf-win:TITLE   = qbf-product:SCREEN-VALUE
    qbf-product     = qbf-product:SCREEN-VALUE
    qbf-left        = qbf-left:SCREEN-VALUE
    qbf-right       = qbf-right:SCREEN-VALUE
    qbf-goodbye     = (qbf-goodbye:SCREEN-VALUE = STRING(TRUE))
    qbf-awrite      = (qbf-awrite:SCREEN-VALUE = STRING(TRUE))
    qbf-checkdb     = (qbf-checkdb:SCREEN-VALUE = STRING(TRUE))
    &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &THEN
    qbf-redraw      = (qbf-threed:SCREEN-VALUE <> STRING(qbf-threed))
    qbf-threed      = (qbf-threed:SCREEN-VALUE = STRING(TRUE))
    SESSION:THREE-D = qbf-threed
    &ENDIF
    _minLogo        = tmpName
    _configDirty    = TRUE
    .

  RUN aderes/_awrite.p (0). /* write qc7 now if qbf-awrite set */
  RUN adecomm/_setcurs.p ("").
END.

ON LEAVE OF qbf-product DO:
  IF qbf-product:SCREEN-VALUE = "" THEN DO:
    MESSAGE "You must provide a product name."
      VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
  END.
END.

ON LEAVE OF qbf-left DO:
  IF qbf-left:SCREEN-VALUE = "" THEN DO:
    MESSAGE "You must provide a character for the left delimiter."
      VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
  END.
END.

ON LEAVE OF qbf-right DO:
  IF qbf-right:SCREEN-VALUE = "" THEN DO:
    MESSAGE "You must provide a character for the right delimiter."
      VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
  END.
END.

ON CHOOSE OF imageBut OR ALT-I OF FRAME {&FRAME-NAME} DO:
  DEFINE VARIABLE absoluteName AS CHARACTER NO-UNDO.

  /* fileFilters needs to be in format of list-items-pairs for the combo-box in
     _fndfile.p that displays the File Types */ 

  &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &THEN
  DEFINE VARIABLE fileFilters AS CHARACTER NO-UNDO INITIAL "Icons (*.ico)|*.ico":u.
  &ELSE
  DEFINE VARIABLE fileFilters AS CHARACTER NO-UNDO INITIAL "*.xbm,*.xpm|*":u.
  &ENDIF

  RUN adecomm/_setcurs.p ("WAIT":u).
  RUN adecomm/_fndfile.p ("Image":u,"Image":u,fileFilters,
    INPUT-OUTPUT _iconPath,INPUT-OUTPUT tmpName,OUTPUT absoluteName,
    OUTPUT qbf-s).

  IF qbf-s = FALSE THEN RETURN.

  /*
  /* If the new logo is a BMP, raise error condition */
  qbf-e = SUBSTRING(absoluteName,R-INDEX(absoluteName,".":u) + 1,-1,
                    "CHARACTER":u). 

  IF ("{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u 
      AND qbf-e <> "ico":u) OR
     ("{&WINDOW-SYSTEM}":u = "OSF/Motif":u  
      AND NOT CAN-DO("xbm,xpm":u,qbf-e)) THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u, 
      SUBSTITUTE('You can only choose &1 files for the &2 icon.', 
      fileFilters,qbf-product))).
    RETURN. 
  END.
  */
  ASSIGN qbf-s = imageBut:LOAD-IMAGE-UP(tmpName).

  IF NOT qbf-s THEN
    MESSAGE tmpName + " could not be loaded to the Icon button."
      VIEW-AS ALERT-BOX WARNING.

  RUN adecomm/_setcurs.p ("").
END.

ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} 
  APPLY "END-ERROR":u TO SELF.

/*---------------------------- Mainline Code ------------------------------*/
{ aderes/_arest.i &FRAME-NAME = {&FRAME-NAME}
                  &HELP-NO    = {&Customize_Dlg_Box}}

/* Run-time layout */
ASSIGN
  qbf-p-h                   = qbf-product:SIDE-LABEL-HANDLE
  qbf-p-h:ROW               = qbf-product:ROW - 1
  qbf-p-h:COL               = qbf-product:COL
  qbf-product:COL           = 2

  imageBut:COL              = qbf-product:COL + qbf-product:WIDTH + 4
  qbf-i                     = "&Icon:"
  qbf-i:ROW                 = qbf-product:ROW - .8
  qbf-i:COL                 = imageBut:COL
  qbf-i:WIDTH-PIXELS        = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(qbf-i)
 
  qbf-d-h                   = qbf-left:SIDE-LABEL-HANDLE
  qbf-d-h:ROW               = qbf-product:ROW - 1
  qbf-left:COL              = imageBut:COL + imageBut:WIDTH + 4
  qbf-d-h:COL               = qbf-left:COL + qbf-d-h:WIDTH
  qbf-d-h:WIDTH-PIXELS      = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(qbf-left:LABEL)
  qbf-right:COL             = qbf-left:COL + qbf-left:WIDTH + 1
  
  qbf-g-h                   = qbf-goodbye:SIDE-LABEL-HANDLE
  qbf-g-h:ROW               = qbf-goodbye:ROW - 1
  qbf-g-h:COL               = qbf-goodbye:COL
  qbf-goodbye:COL           = 2

  qbf-a-h                   = qbf-awrite:SIDE-LABEL-HANDLE
  qbf-awrite:COL            = qbf-goodbye:COL + qbf-goodbye:WIDTH + 1
  qbf-a-h:ROW               = qbf-awrite:ROW - 1
  qbf-a-h:COL               = qbf-awrite:COL + qbf-a-h:WIDTH
  qbf-a-h:WIDTH-PIXELS      = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(qbf-awrite:LABEL)

  FRAME {&FRAME-NAME}:WIDTH = qbf-awrite:COL + qbf-awrite:WIDTH + 1
  rect-1:WIDTH              = FRAME {&FRAME-NAME}:WIDTH - 2
  rect-2:WIDTH              = rect-1:WIDTH
  .
  
/* Runtime layout for the Sullivan bar */
{adecomm/okrun.i 
  &FRAME = "FRAME {&FRAME-NAME}"
  &BOX   = rect_btns
  &OK    = qbf-ok
  &HELP  = qbf-help}

/* Initialize the interface */
ASSIGN
  FRAME {&FRAME-NAME}:HIDDEN  = TRUE
  qbf-product:SCREEN-VALUE    = qbf-product
  qbf-goodbye:SCREEN-VALUE    = STRING(qbf-goodbye)
  qbf-awrite:SCREEN-VALUE     = STRING(qbf-awrite)
  qbf-left:SCREEN-VALUE       = STRING(qbf-left)
  qbf-right:SCREEN-VALUE      = STRING(qbf-right)
  qbf-checkdb:SCREEN-VALUE    = STRING(qbf-checkdb)
  qbf-i:SCREEN-VALUE          = qbf-i
  
  &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &THEN
  qbf-threed:SCREEN-VALUE     = STRING(qbf-threed)
  qbf-threed:LABEL            = SUBSTITUTE("Display &1 in &&3D",qbf-product)
  &ENDIF
  
  /* Set the radio sets to include the current application name.  */
  qbf-s = qbf-goodbye:REPLACE("&Quit From " + qbf-product, YES, "a":u)
  qbf-s = qbf-goodbye:REPLACE("Re&turn From " + qbf-product, NO, "b":u)
  qbf-s = qbf-awrite:REPLACE("E&xit From " + qbf-product, NO, "b":u)

  /* Load the image, only if we find it! If we don't find the image, then
     notify the user.  */
  qbf-s = imageBut:LOAD-IMAGE(_minLogo)
  .

IF NOT qbf-s THEN
  MESSAGE SUBSTITUTE("&1 was not found.",_minLogo)
    VIEW-AS ALERT-BOX ERROR.
ELSE
  tmpName = _minLogo.

/* Figure out the default icon directory */
IF _iconPath = "" THEN
  RUN aderes/_aicdir.p (OUTPUT _iconPath).

FRAME {&FRAME-NAME}:HIDDEN = FALSE.

ENABLE qbf-product imageBut qbf-left qbf-right qbf-goodbye 
  qbf-awrite qbf-checkdb 
  &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &THEN qbf-threed &ENDIF 
  WITH FRAME {&FRAME-NAME}.

DO TRANSACTION ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

RETURN.

/* _acust.p - end of file */

