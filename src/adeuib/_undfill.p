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

File: _undfill.p

Description: Undelete a FILL-IN widget.

Input Parameters:  uRecId - RecID of object of interest.

Output Parameters: <None>

Author: Ravi-Chandar Ramalingam

Date Created: 26 February 1993

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER uRecId AS RECID NO-UNDO.
   
{src/adm2/globals.i}
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

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
IF NOT _L._WIN-TYPE THEN _L._HEIGHT = 1.

/* Instantiate Fill-In  */
CREATE VALUE(IF _L._WIN-TYPE AND _U._SUBTYPE NE "TEXT" THEN "FILL-IN" ELSE "TEXT")
       _U._HANDLE
       ASSIGN { adeuib/std_attr.i }    
              WIDTH             = _L._WIDTH * _L._COL-MULT
        TRIGGERS:
              {adeuib/std_trig.i}
         END TRIGGERS.

IF _DynamicsIsRunning THEN DO:
  IF LOOKUP(_U._CLASS-NAME,  
            DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager,
                             INPUT "DataField":U)) <> 0 AND
    _U._SUBTYPE NE "TEXT":U THEN
     /* Attach the edit master popup */
    RUN createDataFieldPopup IN _h_uib (_U._HANDLE).
  ELSE /* Remove this ELSE when IZ 9978 is fixed */
    IF _U._SUBTYPE EQ "TEXT":U THEN _U._SHOW-POPUP = FALSE.
END.  /* If ICF is running */

IF _L._WIN-TYPE THEN _U._HANDLE:DATA-TYPE = _F._DATA-TYPE.

/* Assign Handles that we now know */
ASSIGN { adeuib/std_uf.i &SECTION = "HANDLES" } .

/* Set the height, if known. */
IF _L._HEIGHT ne ? THEN _U._HANDLE:HEIGHT = _L._HEIGHT * _L._ROW-MULT. 

/* Set the FORMAT and SCREEN-VALUE */
/* Use the specified format if it exists (and it is valid). */
IF _F._FORMAT ne ? THEN ASSIGN _U._HANDLE:FORMAT = _F._FORMAT NO-ERROR. 
_F._FORMAT = _U._HANDLE:FORMAT.

IF _L._WIN-TYPE THEN 
  ASSIGN _U._HANDLE:SCREEN-VALUE = IF _F._DATA-TYPE = "LOGICAL":U AND
                                      _F._INITIAL-DATA = "":U THEN ?
                                   ELSE _F._INITIAL-DATA
         _U._HANDLE:BLANK        = NO.
IF NOT _L._WIN-TYPE OR _U._SUBTYPE = "TEXT" THEN
  RUN adeuib/_sim_lbl.p (_U._HANDLE).

/* Add a label to the current widget */
{ adeuib/addlabel.i }

/* NOTE: _showlbl.p runs onframe to guarantee that the object is within
   frame boundary. */
RUN adeuib/_showlbl.p (INPUT _U._HANDLE).

/* Make sure the Universal Widget Record is "correct" by reading the actually
   instantiated values. */
ASSIGN  {adeuib/std_uf.i &section = "GEOMETRY"} .

{ adeuib/rstrtrg.i } /* Restore triggers */
  
IF _L._WIN-TYPE THEN 
  ASSIGN _U._HANDLE:SCREEN-VALUE = STRING(IF _F._DATA-TYPE = "LOGICAL":U AND
                                      _F._INITIAL-DATA = "":U THEN ?
                                   ELSE _F._INITIAL-DATA)
  /* These lines allow initial value to be shown, but not changed in the design screen */
  _U._HANDLE:READ-ONLY = YES
  _U._HANDLE:BGCOLOR   = IF _L._BGCOLOR = ? THEN 15 ELSE _L._BGCOLOR.
