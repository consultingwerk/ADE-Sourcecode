/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/***************************************************************************
  Include   : ttysnap.i
  Purpose   : Adjusts Graphical Frames to simulate TTY Frames.
  Syntax    : { adeuib/ttysnap.i &hSELF=SELF &Mode="MODE" }
   
   
   &hSELF   - Handle of Frame widget being adjusted.  
   &hPARENT - Handle of Parent Frame of Window
   &U_Type  - Type of widget (we need to know if it is a FRAME)
   &Mode    - DRAW  : Draw and adjust Frame based on SELF attributes queried
                      after user completes the draw.
              MOVE  : Adjust position based on SELF COL and ROW.
              RESIZE: Adjust Resize and Move based on SELF.
              READ  : MOVE and RESIZE based on _U attributes.
  
  Author: J. Palazzo

  Date Created: 01/1994 
***************************************************************************/

/* TTY FRAMES with BOXES. */
IF NOT _L._WIN-TYPE AND {&U_Type} = "FRAME":U AND (NOT _L._NO-BOX) THEN DO:
  /* Decrease the WIDTH of a Frame the equivalent of 2 TTY characters
     to recognize that TTY frames have less inner-width than their GUI 
     counterparts because of the left and right vertical box lines. 
     However, under GUI, we must take into account the GUI borders. */     
  /* We do not adjust W,H if only MOVING or READING. -jep 01/94 */
  IF ("{&Mode}" <> "MOVE") THEN DO:
    /* Update _U W,H from widget's screen position. Don't for READ because we
       use the _U values directly instead (later in this code). -jep 01/94 */
    IF ("{&Mode}" <> "READ") THEN DO: 
      ASSIGN _L._WIDTH = ( ({&hSELF}:WIDTH - ({&hSELF}:BORDER-LEFT-CHARS +
                                             {&hSELF}:BORDER-RIGHT-CHARS)) /
                             _L._COL-MULT) + 2
            _L._HEIGHT = ( ({&hSELF}:HEIGHT - ({&hSELF}:BORDER-TOP-CHARS +
                                             {&hSELF}:BORDER-BOTTOM-CHARS)) /
                             _L._ROW-MULT) + 2 .
    END.
    /* Convert any fractional W,H values to nearest integer. */
    ASSIGN _L._WIDTH = MAX( 1 , INTEGER(_L._WIDTH))
           _L._HEIGHT= MAX( 1 , INTEGER(_L._HEIGHT)).
  END. /* <> MOVE */

 /* Always adjust Col,Row.  Do this on Resize too, because user may have
    resized the upper left corner, causing a MOVE. Again, as with W,H, we do not
    need to get the COL and ROW from the Screen when performing a READ because
    we get these values directly from the _U record instead.  -jep 01/94 */
  IF ("{&Mode}" <> "READ") THEN DO:
    /* Update _U Col,Row from widget's screen position. */
    ASSIGN _L._COL = ((({&hSELF}:COL - _L._COL-MULT + {&hSELF}:BORDER-LEFT-CHARS) - 1) / 
                                          _L._COL-MULT) + 1
           _L._ROW = (({&hSELF}:ROW - 1) /  _L._ROW-MULT) + 1 .
  END.         
         
  /* Convert any fractional COL,ROW values to nearest integer. */
  ASSIGN _L._COL = MAX( 1 , INTEGER(_L._COL))
         _L._ROW = MAX( 1 , INTEGER(_L._ROW)) .

  IF ("{&Mode}" <> "READ") THEN DO:
  /* Can the Frame fit width-wise given its column location? If no, 
     move it back to a column where it will fit. The moving is the amount
     of the difference the width will not fit.  Ditto for height 
     and row. Note we use the row and col mults to move the frame
     a tty row amount and a tty column amount. - jep 01/94 */
    IF ("{&Mode}" = "MOVE") THEN DO:
      IF (_L._COL + _L._WIDTH - 1) > 
          INTEGER({&hPARENT}:VIRTUAL-WIDTH / _L._COL-MULT)
      THEN _L._COL = _L._COL 
                   - (_L._COL + _L._WIDTH - 1)
                   + INTEGER({&hPARENT}:VIRTUAL-WIDTH / _L._COL-MULT).
      IF (_L._ROW + _L._HEIGHT - 1) >
        INTEGER({&hPARENT}:VIRTUAL-HEIGHT / _L._ROW-MULT)
      THEN _L._ROW = _L._ROW 
                   - (_L._ROW + _L._HEIGHT - 1) 
                   + INTEGER({&hPARENT}:VIRTUAL-HEIGHT / _L._ROW-MULT).

    END.
    ELSE DO: /* DRAW OR RESIZE */
    /* Can the Frame fit width-wise given its column location? If no, 
       size it smaller to a width where it will fit. The sizing is the amount
       of the difference the width will not fit.  Ditto for height 
       and row. Note we use the row and col mults to size the frame
       a tty row amount and a tty column amount. - jep 01/94 */
      IF (_L._COL + _L._WIDTH - 1) >
          INTEGER({&hPARENT}:VIRTUAL-WIDTH / _L._COL-MULT)
      THEN _L._WIDTH = _L._WIDTH  
                     - (_L._COL + _L._WIDTH - 1)
                     + INTEGER({&hPARENT}:VIRTUAL-WIDTH / _L._COL-MULT).
      IF (_L._ROW + _L._HEIGHT - 1) >
         INTEGER({&hPARENT}:VIRTUAL-HEIGHT / _L._ROW-MULT) 
      THEN _L._HEIGHT = _L._HEIGHT 
                      - (_L._ROW + _L._HEIGHT - 1)  
                      + INTEGER({&hPARENT}:VIRTUAL-HEIGHT / _L._ROW-MULT).
    END. /* ELSE DRAW OR RESIZE */ 
  END. /* <> "READ" */
  
  /* After converting to integers, we adjust the W and H accordingly. */
  IF ("{&Mode}" <> "MOVE") THEN DO:
    ASSIGN {&hSELF}:WIDTH  = ((DECIMAL(_L._WIDTH) - 2) * _L._COL-MULT) +
                             {&hSELF}:BORDER-LEFT-CHARS + {&hSELF}:BORDER-RIGHT-CHARS

           {&hSELF}:HEIGHT = ((DECIMAL(_L._HEIGHT) - 2) * _L._ROW-MULT) +
                             {&hSELF}:BORDER-TOP-CHARS + {&hSELF}:BORDER-BOTTOM-CHARS.
  END. /* <> "MOVE" */
  
  /* After converting to integers, we adjust the C and R accordingly. */
  ASSIGN {&hSELF}:COLUMN = MAX( 1 ,
                           ((_L._COL - 1) * _L._COL-MULT) + 1 +
                            _L._COL-MULT - {&hSELF}:BORDER-LEFT-CHARS)
         {&hSELF}:ROW    = MAX( 1 ,
                           ((_L._ROW - 1) * _L._ROW-MULT) + 1 ).
END. /* DO */

/* TTY FRAMES without BOXES. */
ELSE IF NOT _L._WIN-TYPE AND {&U_Type} = "FRAME":U AND _L._NO-BOX THEN
DO: /* Convert _U values to integers. */
  IF "{&MODE}" <> "READ" THEN DO:
    ASSIGN _L._COL    = (({&hSELF}:COLUMN - 1) / _L._COL-MULT) + 1
           _L._ROW    = (({&hSELF}:ROW - 1) / _L._ROW-MULT) + 1
           _L._WIDTH  = {&hSELF}:WIDTH / _L._COL-MULT
           _L._HEIGHT = {&hSELF}:HEIGHT / _L._ROW-MULT.
  END.
  /* TTY Frame, so store these attributes as integers. */
  ASSIGN _L._COL    = MAX(1 , INTEGER(_L._COL))
         _L._ROW    = MAX(1 , INTEGER(_L._ROW))
         _L._WIDTH  = MAX(1 , INTEGER(_L._WIDTH))
         _L._HEIGHT = MAX(1 , INTEGER(_L._HEIGHT))
         {&hSELF}:COLUMN = MAX(1 , (_L._COL - 1) * _L._COL-MULT + 1)
         {&hSELF}:ROW    = MAX(1 , (_L._ROW - 1) * _L._ROW-MULT + 1).
END.
