/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
