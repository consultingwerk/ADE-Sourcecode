&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/**************************************************************************
*Copyright (C) 2006 by Progress Software Corporation.                     *
*All rights reserved.  Prior versions of this work may contain portions   *
*contributed by participants of Possenet.                                 *
**************************************************************************/
/*--------------------------------------------------------------------------
    File        : adeuib/_setsize.p
    Purpose     : Sizes SmartObjects in the UIB.

    Syntax      : RUN adeuib/_setsize.p (RECID(_U), height, width) 
    
    Parameters  :
        p_u-recid -- recid of the _U record
        p_height  -- Height for the display
        p_width   -- Width for the display

    Description : This can be called for BOTH visual and non-visual SmartObjects.
                  If the SmartObject is visual, then this routine simply runs
                  set-size in the object itself.
                  
                  If the object is our internal (UIB) visualization, it sets
                  this up as well.

    Author(s)   : Wm. T. Wood
    Created     : July 1996
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p_u-recid AS RECID   NO-UNDO.
DEFINE INPUT PARAMETER p_height  AS DECIMAL NO-UNDO.
DEFINE INPUT PARAMETER p_width   AS DECIMAL NO-UNDO.

{adeuib/uniwidg.i}   /* Universal Widget Records */
{adeuib/layout.i}    /* Layout information */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.1
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Definitions  ************************** */

DEFINE VAR adm-version AS CHAR  NO-UNDO.
DEFINE VAR ch       AS CHAR     NO-UNDO.
DEFINE VAR l_hidden AS LOGICAL  NO-UNDO.
DEFINE VAR l_image  AS LOGICAL  NO-UNDO.
DEFINE VAR l_type   AS LOGICAL  NO-UNDO.
DEFINE VAR l_name   AS LOGICAL  NO-UNDO.
DEFINE VAR h        AS WIDGET   NO-UNDO.
DEFINE VAR h_image  AS WIDGET   NO-UNDO. /* Handle to IMAGE in simulation */
DEFINE VAR h_type   AS WIDGET   NO-UNDO. /* Handle to TYPE text in simulation */
DEFINE VAR h_name   AS WIDGET   NO-UNDO. /* Handle to NAME text in simulation */
DEFINE VAR i_hgt-p  AS INTEGER  NO-UNDO.
DEFINE VAR i_wdth-p AS INTEGER  NO-UNDO.
DEFINE VAR i_Y      AS INTEGER  NO-UNDO.
DEFINE VAR height-p AS INTEGER  NO-UNDO.
DEFINE VAR width-p  AS INTEGER  NO-UNDO.

/* ***************************  Main Block  *************************** */

/* Get the SmartObject and Layout record. */
FIND _U WHERE RECID(_U) eq p_u-recid.
FIND _S WHERE RECID(_S) eq _U._x-recid.
FIND _L WHERE RECID(_L) eq _U._lo-recid.

/* If height or width is not specified, use the actual height of the object.  */
/* If it is specified, then convert to pixels (because pixel math is better). */
IF p_height ne ?
THEN ASSIGN height-p = p_height * SESSION:PIXELS-PER-ROW * _L._ROW-MULT.
ELSE ASSIGN p_height = _U._HANDLE:HEIGHT
            height-p = _U._HANDLE:HEIGHT-PIXELS.
IF p_width ne ?
THEN ASSIGN width-p  = p_width  * SESSION:PIXELS-PER-COLUMN * _L._COL-MULT.
ELSE ASSIGN p_width  = _U._HANDLE:WIDTH
            width-p  = _U._HANDLE:WIDTH-PIXELS.

adm-version = dynamic-function("getObjectVersion" IN _S._HANDLE) NO-ERROR.
IF ERROR-STATUS:ERROR or adm-version = ? or adm-version = "" THEN
  adm-version = "ADM1".

/* Should the object size itself? */
IF _S._visual THEN DO:
   /* Set the size in the object itelf.  If the object does not support "set-size"
      then this will be ignored. NOTE: the object will only be visual if the
      ROW and COL-MULT are 1 so we don't need to multiply by these numbers.  */
   IF adm-version < "ADM2" THEN
     RUN set-size IN _S._HANDLE (p_height, p_width) NO-ERROR.
   ELSE
     RUN resizeObject IN _S._HANDLE (p_height, p_width) NO-ERROR.
END.
ELSE DO:
  /* Loop through the children of the object hiding anything that won't fit. 
     Remember that our visualization is a FRAME.  Hide the visualization before
     we work on it. */
  ASSIGN h = _U._HANDLE:CURRENT-ITERATION  /* the field group */
         h = h:FIRST-CHILD
         l_hidden = _U._HANDLE:HIDDEN
         _U._HANDLE:HIDDEN = yes.
  DO WHILE VALID-HANDLE (h):
    /* Look for the image and text widgets that make up the visualization. 
       (The PRIVATE-DATA was set in adeuib/_undsmar.p). */
    IF h:TYPE eq "IMAGE":U and h:PRIVATE-DATA eq "Image":U    THEN h_image = h.
    ELSE IF h:TYPE eq "TEXT":U and h:PRIVATE-DATA eq "Type":U THEN h_type  = h. 
    ELSE IF h:TYPE eq "TEXT":U and h:PRIVATE-DATA eq "Name":U THEN h_name  = h. 
    ELSE IF (h:X + h:WIDTH-P + 1) >= width-p OR (h:Y + h:HEIGHT-P + 1) >= height-p
    THEN h:HIDDEN = yes.
    ELSE h:HIDDEN = no.
    /* Get the next one. */
     h = h:NEXT-SIBLING.
  END.
  /* Position and size the components of the visualization. Assume everything
     is visible. */
  ASSIGN h_image:HIDDEN = yes
         h_type:HIDDEN  = yes
         h_name:HIDDEN  = yes
         l_image        = yes
         l_type         = yes
         l_name         = yes
         .
  
    /* Don't even try to handle really small frames. */
  IF height-p >= 16 AND width-p >= 16 THEN DO:
    /* Check the height and size of the text. */
    i_hgt-p = FONT-TABLE:GET-TEXT-HEIGHT-P (h_type:FONT).
    IF h_image:HEIGHT-P >= height-p THEN l_image = no.
    IF l_image THEN DO:
      /* Is there room for the image AND text? */
      IF h_image:HEIGHT-P + i_hgt-p >= height-p       THEN l_name  = no.
      IF h_image:HEIGHT-P + (2 * i_hgt-p) >= height-p THEN l_type  = no.
    END.
    ELSE DO:
      /* Is there room for just one or two lines of text (no image). */
      IF i_hgt-p >= height-p       THEN l_name  = no.
      IF (2 * i_hgt-p) >= height-p THEN l_type  = no.
    END.  
        /* Check the width of the objects. */
    IF l_image AND h_image:WIDTH-P >= width-p THEN l_image = no.
    ELSE h_image:X = (width-p - h_image:WIDTH-P) / 2 NO-ERROR.
    IF l_name THEN DO:
      /* Get just the file name (excluding path). */
      ASSIGN ch = REPLACE (_S._FILE-NAME, "~\":U, "~/":U)
             ch = ENTRY (NUM-ENTRIES (ch, "~/":U), ch, "~/":U)
             i_wdth-p = FONT-TABLE:GET-TEXT-WIDTH-P (ch, h_name:FONT).
      IF i_wdth-p >= width-p OR ch eq "":U
      THEN l_name = no.
      ELSE
        ASSIGN h_name:SCREEN-VALUE = ch
               h_name:WIDTH-P      = i_wdth-p
               h_name:HEIGHT-P     = i_hgt-p
               h_name:X            = (width-p - i_wdth-p) / 2 NO-ERROR.
    END. /* IF l_name... */
    IF l_type THEN DO:
      
        /*Check if the object subtype is "SmartDataObject" and db-aware is false;
          if that condition is true is because the SmartObject is a DataView*/
        IF _U._SUBTYPE EQ "SmartDataObject" AND
                          _S._valid-object AND
                          VALID-HANDLE(_S._handle) AND
                          NOT ({fn getDBAware _S._handle}) THEN
        ASSIGN ch = "DataView":U.
        
        ELSE
        ASSIGN ch = _U._SUBTYPE.
      
      ASSIGN i_wdth-p = FONT-TABLE:GET-TEXT-WIDTH-P (ch, h_name:FONT).
      
      IF i_wdth-p >= width-p OR ch eq "":U 
      THEN l_type = no.
      ELSE
        ASSIGN h_type:SCREEN-VALUE = ch     
               h_type:WIDTH-P      = i_wdth-p
               h_type:HEIGHT-P     = i_hgt-p
               h_type:X            = (width-p - i_wdth-p) / 2  NO-ERROR.
        
    END. /* IF l_type... */
    
    /* What is the combined height of everything we will show now? 
       (Add in an extra pixel to avoid rounding error later on.) */
    i_hgt-p = 1.
    IF l_image THEN i_hgt-p = i_hgt-p + h_image:HEIGHT-P.
    IF l_name  THEN i_hgt-p = i_hgt-p + h_name:HEIGHT-P.
    IF l_type  THEN i_hgt-p = i_hgt-p + h_type:HEIGHT-P.
    
    /* Center and show the visible things. */
    i_Y = (height-p - i_hgt-p) / 2.
    IF l_image THEN ASSIGN h_image:Y = i_Y
                           h_image:HIDDEN = no
                           i_Y = i_Y + h_image:HEIGHT-P NO-ERROR.
    IF l_type  THEN ASSIGN h_type:Y = i_Y
                           h_type:HIDDEN = no
                           i_Y = i_Y + h_type:HEIGHT-P NO-ERROR.
    IF l_name  THEN ASSIGN h_name:Y = i_Y
                           h_name:HIDDEN = no
                           i_Y = i_Y + h_name:HEIGHT-P NO-ERROR.
  END.
  
  /* Assign the size of the frame itself. */
  ASSIGN _U._HANDLE:WIDTH-P  = width-p
         _U._HANDLE:HEIGHT-P = height-p
         NO-ERROR
         .
  /* View the visualization again, (if necessary). Note that the hiding will
     have removed any "selection". */
  IF NOT l_hidden THEN DO:
    ASSIGN _U._HANDLE:HIDDEN = no NO-ERROR.
    IF _U._SELECTEDib THEN _U._HANDLE:SELECTED = yes.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


