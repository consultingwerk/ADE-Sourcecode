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
/*----------------------------------------------------------------------------

File: _undimag.p

Description: Undelete a IMAGE widget.

Input Parameters:  uRecId - RecID of object of interest.

Output Parameters: <None>

Author: Ravi-Chandar Ramalingam

Date Created: 26 February 1993

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER uRecId AS RECID NO-UNDO.

{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

DEFINE VARIABLE loaded AS LOGICAL INITIAL FALSE NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.
DEFINE BUFFER parent_C FOR _C.

FIND _U       WHERE RECID(_U)       eq uRecId.
FIND _L       WHERE RECID(_L)       eq _U._lo-recid.
FIND _F       WHERE RECID(_F)       eq _U._x-recid.
FIND parent_U WHERE RECID(parent_U) eq _U._parent-recid.
FIND parent_L WHERE RECID(parent_L) eq parent_U._lo-recid.
FIND parent_C WHERE RECID(parent_C) eq parent_U._x-recid.

ASSIGN _F._FRAME    = parent_U._HANDLE
       _L._WIN-TYPE = parent_L._WIN-TYPE.

CREATE IMAGE _U._HANDLE
    ASSIGN {adeuib/std_attr.i &NO-FONT   = YES 
                              &SIZE-CHAR = YES }       
      TRIGGERS:
           {adeuib/std_trig.i}
      END TRIGGERS.

/* Assign Handles that we now know */
ASSIGN  {adeuib/std_uf.i &section = "HANDLES"} .

IF _L._WIN-TYPE THEN DO:       

  /* Load the image before realizing to avoid errors */
  IF _F._IMAGE-FILE NE ? AND _F._IMAGE-FILE NE "" THEN
    loaded = _U._HANDLE:LOAD-IMAGE(_F._IMAGE-FILE).
  
  IF loaded NE yes AND _U._HANDLE:LOAD-IMAGE("adeicon/blank") NE yes THEN
    MESSAGE "Default image ""blank"" not found."
    	VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

  /* Place object within frame boundary. */
  {adeuib/onframe.i
     &_whFrameHandle = "_F._FRAME"
     &_whObjHandle   = "_U._HANDLE"
     &_lvHidden      = _L._REMOVE-FROM-LAYOUT}

  /* Make sure the Universal Widget Record is "correct" by reading the actually
     instantiated values. */
  ASSIGN  {adeuib/std_uf.i &section = "GEOMETRY"} .
        
  { adeuib/rstrtrg.i } /* Restore triggers */
END.
