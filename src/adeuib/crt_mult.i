/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
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
/* crt_mult.i -  create multiple layout _L record if necessary              */
/*                                                                          */
/*            This is called by all of the field level _rdxxxx.p 's.        */
/*               as well as the frame's _L but not WINDOW or DIALOG-BOX     */
/*            If only the Master Layout is Active then it is a no-op.       */
/*            If the current layout is other than the master, only make a   */
/*               record for this layout and mark the master record as       */
/*               being removed-from-layout                                  */
/*            If the current layout is the Master Layout and others are     */
/*               active, create and populate _L records (alt_L) for each    */
/*            You want to create an alternate layout for each layout that   */
/*               the parent object has.                                     */
/*                                                                          */
/*  IMPORTANT!!!  When this include file is entered                         */
/*                 parent_U._LAYOUT-NAME is the current layout name         */
/*      BUT!!!     parent_L is the parents Master Layout _L                 */
/*      AND!!!     _L is the Master Layout _L                               */
/*                These values should NOT be changed by this include file   */
/*                                                                          */
/* NOTES:                                                                   */
/*   - SmartObjects (v8.0a) cannot be removed from any layout.              */
DEFINE BUFFER   alt_L FOR _L.
DEFINE BUFFER   alt_parent_L FOR _L.  

/* For each layout, create an alt_L record.  Set REMOVE-FROM-LAYOUT if the parent
   layout is NOT the Master Layout (or the current layout). */
FOR EACH alt_parent_L WHERE alt_parent_L._u-recid eq RECID(parent_U)
                        AND alt_parent_L._LO-NAME ne "Master Layout":U:    
  CREATE alt_L.
  ASSIGN alt_L._LO-NAME         = alt_parent_L._LO-NAME
         alt_L._u-recid         = RECID(_U)
         alt_L._WIN-TYPE        = alt_parent_L._WIN-TYPE
         alt_L._BGCOLOR         = IF alt_L._WIN-TYPE AND _L._WIN-TYPE
                                      THEN _L._BGCOLOR ELSE ?
         alt_L._COL             = IF alt_L._WIN-TYPE THEN _L._COL
                                                        ELSE INTEGER(_L._COL)
         alt_L._COL-MULT        = alt_parent_L._COL-MULT
         alt_L._CUSTOM-POSITION = FALSE
         alt_L._CUSTOM-SIZE     = FALSE
         alt_L._FGCOLOR         = IF alt_L._WIN-TYPE AND _L._WIN-TYPE
                                      THEN _L._FGCOLOR ELSE ?
         alt_L._FONT            = IF alt_L._WIN-TYPE AND _L._WIN-TYPE
                                      THEN _L._FONT ELSE ?
         alt_L._HEIGHT          = IF alt_L._WIN-TYPE THEN _L._HEIGHT ELSE
                                    (IF CAN-DO("FILL-IN,TOGGLE,BUTTON,TEXT",
                                        _U._TYPE) THEN 1 ELSE INTEGER(_L._HEIGHT))
         alt_L._NO-LABELS       = _L._NO-LABELS   
         /* Remove (not-Smart) objects from various layouts. */
         alt_L._REMOVE-FROM-LAYOUT = (IF (parent_U._LAYOUT-NAME eq "Master Layout":U OR
                                          _U._TYPE eq "SmartObject":U)
                                      THEN FALSE
                                      ELSE (IF parent_U._LAYOUT-NAME eq alt_L._LO-NAME
                                            THEN FALSE
                                            ELSE TRUE))
         
         alt_L._ROW             = IF alt_L._WIN-TYPE THEN _L._ROW
                                                        ELSE INTEGER(_L._ROW)
         alt_L._ROW-MULT        = alt_parent_L._ROW-MULT
         alt_L._WIDTH           = IF alt_L._WIN-TYPE THEN _L._WIDTH
                                                        ELSE INTEGER(_L._WIDTH)
         alt_L._WIN-TYPE        = alt_parent_L._WIN-TYPE.
         
  IF _U._TYPE = "RECTANGLE" THEN
    ASSIGN alt_L._EDGE-PIXELS   = _L._EDGE-PIXELS
           alt_L._FILLED        = _L._FILLED
           alt_L._GRAPHIC-EDGE  = _L._GRAPHIC-EDGE.
  ELSE
    ASSIGN alt_L._3-D               = _L._3-D
           alt_L._CONVERT-3D-COLORS = _L._CONVERT-3D-COLORS
           alt_L._NO-BOX            = _L._NO-BOX
           alt_L._NO-FOCUS          = _L._NO-FOCUS
           alt_L._NO-UNDERLINE      = _L._NO-UNDERLINE
           alt_L._SEPARATORS        = _L._SEPARATORS
           alt_L._SEPARATOR-FGCOLOR = IF alt_L._WIN-TYPE AND _L._WIN-TYPE THEN
                                        _L._SEPARATOR-FGCOLOR ELSE ?
           alt_L._TITLE-BGCOLOR     = IF alt_L._WIN-TYPE AND _L._WIN-TYPE THEN
                                         _L._TITLE-BGCOLOR ELSE ?
           alt_L._TITLE-FGCOLOR     = IF alt_L._WIN-TYPE AND _L._WIN-TYPE THEN
                                         _L._TITLE-FGCOLOR ELSE ?
           alt_L._VIRTUAL-HEIGHT    = IF alt_L._WIN-TYPE THEN _L._VIRTUAL-HEIGHT
                                         ELSE INTEGER(_L._VIRTUAL-HEIGHT)
           alt_L._VIRTUAL-WIDTH     = IF alt_L._WIN-TYPE THEN _L._VIRTUAL-WIDTH
                                         ELSE INTEGER(_L._VIRTUAL-WIDTH).

  /* If this Layout is the Current Layout, note it as such by connecting the _U and alt_L
     records. */
  IF parent_U._LAYOUT-NAME eq alt_L._LO-NAME 
  THEN DO:
    ASSIGN _U._lo-recid           = RECID(alt_L)
           _U._LAYOUT-NAME        = alt_L._LO-NAME
           .
  END.
END.  /* For each active layout */

/* If we are pasting into an alternate layout, set the REMOVE-FROM-LAYOUT
   on the master. Note SmartObjects cannot be REMOVED-FROM-LAYOUT (in v8)*/
IF _U._TYPE ne "SmartObject":U AND 
   parent_U._LAYOUT-NAME ne "Master Layout":U AND 
   _L._LO-NAME eq "Master Layout":U 
THEN _L._REMOVE-FROM-LAYOUT = TRUE. 
