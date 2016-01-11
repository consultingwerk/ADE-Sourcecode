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

/**************************************************************************
    Procedure:  _chksave.p

    Purpose:    Checks to see if the INI file is really writeable.  There
                are some cases where PUT-KEY-VALUE appears to succeed (i.e.
                it does not raise the error condition) however nothing is
                really written.  For example, on some DOS network drives.
                
                This file actually tries to write and read a value to
                verify the status of the file.  The procedure always tries
                to clean up after itself.  It tries to reset the sample
                string to its original value.
                               
                NOTE: this file does NOT report any error.  The calling
                program should check this.
                
    Syntax :    RUN adeshar/_chksave.p ( INPUT p_Section , OUTPUT p_OKsave ).

    Parameters:
        p_Section   String indicating section to try to save in (eg ProUIB).
                    This value should not affect the results, but I added it
                    for completeness.  Defaults to null if not passed.
        p_OKsave    True if save was successful.
        
    Authors: Wm.T.Wood
    Date   : June, 1995
**************************************************************************/
DEFINE INPUT PARAMETER p_Section AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p_OKsave AS LOGICAL NO-UNDO.

DEFINE VAR v          AS CHAR NO-UNDO.
DEFINE VAR test-value AS CHAR NO-UNDO.
DEFINE VAR orig-value AS CHAR NO-UNDO.

/* See if there is a current value of the TestSetting. */
GET-KEY-VALUE SECTION p_Section KEY "TestSetting" VALUE orig-value.
IF orig-value ne ?
THEN test-value = ?.
ELSE test-value = "OK".

/* Surround this with a ON ERROR statement to trap error of PUT-KEY-VALUE. */
p_OKsave = no.
PUTPREFS-BLOCK:
DO ON STOP  UNDO PUTPREFS-BLOCK, LEAVE PUTPREFS-BLOCK
   ON ERROR UNDO PUTPREFS-BLOCK, LEAVE PUTPREFS-BLOCK:

  /* Put the test value. */
  PUT-KEY-VALUE SECTION p_Section KEY "TestSetting" VALUE test-value NO-ERROR.
  IF ERROR-STATUS:ERROR THEN STOP.  
  
  /* Get it again. */
  GET-KEY-VALUE SECTION p_Section KEY "TestSetting" VALUE v.
  /* Verify the save. */
  IF v eq test-value THEN p_OKsave = yes.
  
  /* Reset the INI file by restoring the TestSetting value (if any). */
  PUT-KEY-VALUE SECTION p_Section KEY "TestSetting" VALUE orig-value NO-ERROR.
  
END. /* PUTPREFS-BLOCK */
RETURN. 
