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

/*  as4dict/load/_lodnidx.p

    Created 12/01/95 D McMann to work with new load which creates
                    temporary files and loads DB2/400 all at once.
           03/18/97 Change length of index to less than 200 D. McMann
                    97-03-18-060  
           03/21/97 Added Object Library support (user_env[34]) D. McMann 
                    97-01-20-020      
           06/26/97 D. McMann Added word index support
           08/07/97 Added new DBA command for word index support D. McMann 
           11/30/98 Added loop for check of AS/400 name D. McMann 98-09-11-038  
           11/22/00 Moved check for size of index before creating information
           02/18/02 Added logic to handle WRONG FILE FORMAT when calculating AS4 names
          
*/
                    
{ as4dict/dictvar.i shared }
{ as4dict/load/loaddefs.i }

DEFINE VARIABLE scrap AS LOGICAL NO-UNDO.
DEFINE VARIABLE lngidx AS INTEGER NO-UNDO.

/* defines for AS4 Name and Library validations */

DEFINE VARIABLE As4Name AS CHARACTER NO-UNDO.
DEFINE VARIABLE As4Library AS CHARACTER NO-UNDO.

/* For As4Name validation */
DEFINE VARIABLE i AS INTEGER.
DEFINE VARIABLE lngth AS INTEGER.
DEFINE VARIABLE nam  AS CHARACTER NO-UNDO.
DEFINE VARIABLE pass AS INTEGER   NO-UNDO.              

/*----------------------Main Line --------------------------*/          

FIND wtp__File WHERE wtp__File._File-number = pfilenumber.
FIND FIRST widx.

IF CAN-FIND(FIRST wtp__Index where wtp__Index._File-number = wtp__File._File-number 
      	      AND TRIM(wtp__Index._Index-name) = TRIM(widx._Index-name)) THEN DO:
    ierror = 7. /* "&2 already exists with name &3" */    
    RETURN.
END.                                             
  
/* Check for Word index, which we didn't support in early versions and signal error if found. */
IF widx._Wordidx = 1 AND NOT allow_word_idx THEN DO:
     ierror = 45.  /* Word Index not supported */
     RETURN.
END.
   
ASSIGN lngidx = 0.
  
IF widx._Wordidx = 0 THEN
FOR EACH wixf:                   
  FIND wtp__Field WHERE wtp__Field._File-number = pfilenumber
                  AND wtp__Field._Fld-number = wixf._Fld-number. 
                                                      
  ASSIGN lngidx = lngidx + wtp__field._fld-stlen.
  IF lngidx >= 200 THEN DO:
    ierror = 44.
    RETURN.
  END.
END.
ASSIGN AS4Library = CAPS(user_dbname).

/* If we don't have an _As4-File Name, generate one.  Then, validate
   the As400 name and check or the object. */

IF widx._As4-File = "" OR widx._As4-file = ? THEN
    IF LENGTH(widx._Index-name) < 11 THEN
        ASSIGN nam = CAPS(widx._Index-name).
    ELSE
        ASSIGN nam = CAPS(SUBSTRING(widx._Index-name,1,10)).
ELSE
      assign nam = CAPS(widx._As4-File).

{as4dict/load/wtpname.i}
ASSIGN As4Name = CAPS(nam).

/* Do a CHKF to see if the file exists already if not a word index */
IF widx._Wordidx = 0 THEN DO:
    dba_cmd = "CHKF".
    RUN as4dict/_dbaocmd.p
         (INPUT "LF",
          INPUT As4Name,
          INPUT CAPS(user_env[34]),
          INPUT 0,
          INPUT 0).
          
   IF dba_return = 1 OR dba_return = 11 OR
       CAN-FIND(FIRST wtp__Index WHERE wtp__Index._AS4-FILE = as4name
                  AND wtp__Index._AS4-Library = wtp__File._AS4-Library) THEN 
   DO pass = 1 TO 9999:
     IF user_env[29] = "yes" THEN
       ASSIGN As4Name = SUBSTRING(As4Name,1,lngth - LENGTH(STRING(pass)))
                          + STRING(pass).
     ELSE        
       ASSIGN As4Name = SUBSTRING(As4Name + "_______",1,10 - LENGTH(STRING(pass)))
                      + STRING(pass)   
                      
     dba_cmd = "CHKF".
     RUN as4dict/_dbaocmd.p
       (INPUT "LF",
        INPUT As4Name,
        INPUT CAPS(user_env[34]),
        INPUT 0,
        INPUT 0).
   
     IF dba_return <> 1 AND dba_return <> 11 AND 
         NOT CAN-FIND(FIRST wtp__Index WHERE wtp__Index._AS4-FILE = as4name
                  AND wtp__Index._AS4-Library = wtp__File._AS4-Library) THEN
       assign pass = 10000.
   END.    
          
   
    IF dba_return = 1 OR dba_return = 11 THEN DO:
      ierror = 7.  /* File already exists */
      RETURN.
    END.   

    ELSE If dba_return = 2 THEN DO:
         dba_cmd = "RESERVE".
         RUN as4dict/_dbaocmd.p 
              (INPUT "LF",
               INPUT As4Name,
               INPUT CAPS(user_env[34]),
               INPUT 0,
               INPUT 0).                     

        If dba_return <> 12 THEN DO:
              RUN as4dict/_dbamsgs.p.
              ierror = 23.
              RETURN.                 
        END.
    END.

    ELSE IF dba_return > 2 THEN DO:
         RUN as4dict/_dbamsgs.p.
         ierror = 23. /* default error to general table attr error */              
         RETURN.
    END.
END.
/* Now check if word index*/
ELSE DO:
    dba_cmd = "VALWRDIDX".
    RUN as4dict/_dbaocmd.p 
       (INPUT "", 
	 INPUT CAPS(wtp__File._AS4-file),
      	 INPUT CAPS(wtp__File._AS4-Library),
        INPUT 0,
        INPUT 0).

    If dba_return <> 1 THEN DO:
        RUN as4dict/_dbamsgs.p.
            ierror = 26.
        RETURN.                 
    END.
    ELSE DO:
      dba_cmd = "CHKOBJ".
      RUN as4dict/_dbaocmd.p 
       (INPUT "*USRIDX", 
	 INPUT As4Name,
        INPUT CAPS(user_env[34]),
        INPUT 0,
        INPUT 0).

      if dba_return = 1 THEN DO:
        RUN as4dict/_dbamsgs.p.
        ierror = 26.
        RETURN. 
      END.                  
    END.

END.
  
ASSIGN pidxnumber = (IF wtp__file._Fil-Res1[2] <> ? THEN
                                              wtp__file._Fil-Res1[2] + 1 ELSE 1)
                 wtp__File._Fil-Res1[2] = wtp__File._Fil-res1[2] + 1.                             
  
CREATE wtp__Index.
ASSIGN wtp__Index._File-number = pfilenumber
                 wtp__Index._Idx-num = pidxnumber       
                 wtp__Index._As4-file = As4Name
                wtp__Index._AS4-Library = user_env[34]
                wtp__Index._Index-name = widx._Index-name  
                wtp__Index._Desc = TRIM(REPLACE(widx._Desc, CHR(13), ""))
                wtp__Index._For-Type = widx._For-Type
                wtp__Index._For-name = user_env[34] + "/" + As4Name
                wtp__Index._I-misc2[4] = (IF widx._I-misc2[4] = '' THEN "NNNYYYYNN" else widx._I-misc2[4])
                wtp__Index._I-Misc2[6] = wtp__file._AS4-Library + "/" + wtp__File._As4-File
                wtp__index._Active  = (IF widx._Active = "N" THEN "N" ELSE "Y")
                wtp__Index._Unique  = (IF widx._Unique = "" THEN "N" ELSE widx._Unique)
                wtp__Index._Wordidx =  widx._Wordidx
                wtp__Index._I-Res1[1] = 30.              
  
FOR EACH wixf:    
    FIND wtp__Field WHERE wtp__Field._File-number = pfilenumber
                  AND wtp__Field._Fld-number = wixf._Fld-number.

    CREATE wtp__Idxfd.
    ASSIGN wtp__Idxfd._Idx-num = wtp__Index._Idx-num
                    wtp__Idxfd._Fld-number =   wtp__Field._fld-number                     
                    wtp__Idxfd._File-number = pfilenumber
                    wtp__Idxfd._AS4-file = wtp__Index._AS4-file
                    wtp__Idxfd._AS4-Library = wtp__Index._AS4-Library
                    wtp__Idxfd._Index-Seq   = wixf._Index-Seq
                    wtp__Idxfd._Abbreviate  = (IF wixf._Abbreviate = "" OR wixf._Abbreviate = ?
                                                                        THEN "N" ELSE wixf._Abbreviate)
                    wtp__Idxfd._Ascending   = wixf._Ascending
                    wtp__Idxfd._If-misc2[1] = wtp__Field._Fld-Misc2[2]
                    wtp__Idxfd._If-misc2[2] = SUBSTRING(wtp__Field._For-name,1,10)
                    wtp__Index._Num-comp = wtp__Index._Num-comp + 1.

      IF wtp__Idxfd._If-misc2[1] = "Y" THEN
      	   ASSIGN wtp__Index._I-Misc2[4] = "NNYYYYYNN".
      ELSE    ASSIGN wtp__Index._I-Misc2[4] = "NNNYYYYNN".     

      /* Indicates cstring field within index */
      IF wtp__field._fld-stdtype = 41 THEN
         ASSIGN wtp__Field._Fld-Misc2[8] = "Y"
                          wtp__idxfd._If-Misc2[7] = "Y".

      /* Indicate if Index has case sensitive field in it */
      IF wtp__Field._Fld-Misc2[6] = "A" AND wtp__Field._Fld-case = "Y" THEN
	ASSIGN wtp__Index._I-Misc2[4] = SUBSTRING(wtp__Index._I-Misc2[4],1,9) + "Y".

END.                               

IF iprimary  THEN 
       ASSIGN wtp__File._Prime-index = wtp__Index._Idx-num
              wtp__File._Fil-misc1[7] = wtp__Index._Idx-num
              SUBSTRING(wtp__Index._I-Misc2[4],9,1) = "Y".
 
        
   ASSIGN wtp__Index._For-type = wtp__File._For-format
                    wtp__File._numkey = wtp__File._Numkey + 1.                     

RETURN.




