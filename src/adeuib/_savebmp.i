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

File: _savebmp.i

Input Parameters:
     {&direction} = "UP" or "DOWN" 
     {&ocx} = 
Output Parameters:
   <None>

Author: 
Date Created: 
Modified by 
-----------------------------------------------------------------------------*/

DO:
    ASSIGN createIt = no
	   errCreate = no.
    /* IMAGE FILES
     * If the file isn't found in the propath then just 
     * use the name given by the user. 
     */
    fName = search(bmpFile).
    if fName = ? then fName = bmpFile.
    else if fName begins ".~\" then fName = replace(fName, ".~\", "").

    /* The user can specify a pathed filename create it if not there */
    RUN adecomm/_osprefx.p(INPUT fName, OUTPUT fPreFix, OUTPUT pBasename).
    /* The user can specify a pathed filename create it if not there */
    IF fPreFix <> "" THEN FILE-INFO:FILE-NAME = fPreFix.
    ELSE FILE-INFO:FILE-NAME = ".":U.
    
    IF FILE-INFO:FULL-PATHNAME = ? THEN
    DO:
       Assign 
          ThisMessage = "Directory " + fPrefix + " does not exist." + CHR(10) 
              	+ "Do you want to create it?"
	     createIt = yes.
	RUN adecomm/_s-alert.p (INPUT-OUTPUT createIt, "Q":U, "yes-no", ThisMessage).

       IF createIt THEN
       DO:
          RUN adecomm/_oscpath.p (INPUT fPrefix, OUTPUT errStatus).
          IF errStatus THEN errCreate = yes.
       END.
       ELSE errCreate = yes.

       IF NOT errCreate THEN FILE-INFO:FILE-NAME = fPreFix.
    END.
  

    /* At this point, FILE-INFO:FULL-PATHNAME should be fully available */
    IF NOT errCreate THEN
    DO:
       ASSIGN createIt = YES.

       IF FILE-INFO:FULL-PATHNAME <> ? THEN
       DO:
  	  RUN adecomm/_osfmush.p(FILE-INFO:FULL-PATHNAME, INPUT pBaseName, OUTPUT fullName).
  	  FILE-INFO:FILE-NAME = fullName.
  	  IF FILE-INFO:FULL-PATHNAME <> ? THEN
  	  DO:
            Assign ThisMessage = 
                   "Bitmap " + fullName + " exists." + CHR(10) 
    	        + "Do you want to overwrite it?".
    	     RUN adecomm/_s-alert.p (INPUT-OUTPUT createIt, "Q":U, "yes-no", ThisMessage).
    
             END. /* overwrite? */
       END. /* pathname = ? */
       
       IF createIt THEN
       DO:
	    IF "{&direction}" = "UP":U THEN
    	       {&ocx}:saveUpBitMap(fullName).
            ELSE
    	       {&ocx}:saveDownBitMap(fullName).
       END.
    	
    	/* double check that it was created */
    	FILE-INFO:FILE-NAME = fullName.
       IF FILE-INFO:FULL-PATHNAME = ? THEN errCreate = yes.
    END. /* errCreate */
END.
