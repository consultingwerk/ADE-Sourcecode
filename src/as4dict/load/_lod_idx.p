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
/* as4dict/load/_lod_idx.p

   Modified to work with PROGRESS/400 Data Dictionary 01/95
   Modified so that indexes can be renumbered DLM 03/28/96
   03/18/97 Change length of index to less than 200  97-03-18-060 
   03/21/97 Added Object Library support (user_env[34])  97-01-20-020
   06/25/97 Added word index support 
   08/07/97 Added new DBA command for word index support 
   04/13/98 Added assignment to _fil-misc1[1]  98-03-12-011
   11/30/98 Added loop for check of AS/400 name  98-09-11-038
   10/12/00 Changed where _fil-Res1[7] was being assigned 20001012-016
   11/22/00 Moved the check for index size higher in the code.
   
*/

{ as4dict/dictvar.i shared }
{ as4dict/load/loaddefs.i }

DEFINE VARIABLE scrap AS LOGICAL NO-UNDO.
DEFINE VARIABLE new_primary AS LOGICAL NO-UNDO.
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
FIND as4dict.p__File WHERE as4dict.p__File._File-number = pfilenumber.
FIND FIRST widx.
IF imod <> "a" AND imod <> "d" THEN DO:
  FIND as4dict.p__Index  WHERE as4dict.p__Index._File-number = as4dict.p__File._File-number
     AND TRIM(as4dict.p__Index._Index-name) = TRIM(widx._Index-name). /* proven to exist */

  IF As4dict.p__index._idx-num <> as4dict.P__file._Fil-Misc1[7] 
   AND as4dict.p__index._Wordidx = 0 THEN DO:
    /* If not adding, assume it exists and issue a reserve */
    dba_cmd = "RESERVE".
    RUN as4dict/_dbaocmd.p
      (INPUT "LF",
      INPUT as4dict.p__Index._As4-File,
      INPUT as4dict.p__Index._As4-Library,
      INPUT 0,
      INPUT 0).  
  
    If dba_return <> 1 THEN DO:
      RUN as4dict/_dbamsgs.p.
      ierror = 23.
      RETURN.
      END.
   END. /* idx-num <> fil-misc1[7] */
END.  /* Not adding */

IF imod = "a" THEN DO: /*---------------------------------------------------*/

  IF CAN-FIND(FIRST as4dict.p__Index where as4dict.p__Index._File-number = as4dict.p__File._File-number 
      	      AND TRIM(as4dict.p__Index._Index-name) = TRIM(widx._Index-name)) THEN DO:
    ierror = 7. /* "&2 already exists with name &3" */
    RETURN.
  END.                                             
 
/* Check for Word index, which we don't support in early versions.  
  Signal error if found and indicator is set to no */
  
  IF widx._Wordidx = 1 AND NOT allow_word_idx THEN DO:
     ierror = 45.  /* Word Index not supported in early versions */
     RETURN.
  END.

  ASSIGN lngidx = 0.

  IF widx._Wordidx = 0 THEN
  FOR EACH wixf:                   
    FIND as4dict.p__Field WHERE as4dict.p__Field._File-number = pfilenumber
                  AND as4dict.p__Field._Fld-number = wixf._Fld-number. 
                                                      
    ASSIGN lngidx = lngidx + as4dict.p__field._fld-stlen.
    IF lngidx >= 200 THEN DO:                                
       ierror = 44.
       RETURN.
    END.
  END.

  ASSIGN AS4Library = CAPS(user_dbname).

/* If we don't have an _As4-File Name, generate one.  Then, validate
   the As400 name and check or the object. */

   IF widx._As4-File = "" OR widx._As4-File = ? THEN
      IF LENGTH(widx._Index-name) < 11 THEN
        ASSIGN nam = CAPS(widx._Index-name).
      ELSE
        ASSIGN nam = CAPS(SUBSTRING(widx._Index-name,1,10)).
   ELSE
      assign nam = CAPS(widx._As4-File).

   {as4dict/load/as4name.i}
   ASSIGN As4Name = CAPS(nam).

/* Do a CHKF to see if the file exists already if not a word index */
  IF widx._Wordidx = 0 THEN DO:
     dba_cmd = "CHKF".
     RUN as4dict/_dbaocmd.p
       (INPUT "LF",
        INPUT As4Name,
        INPUT as4dict.p__File._AS4-Library,
        INPUT 0,
        INPUT 0).
             
     IF dba_return = 1 THEN 
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
          INPUT as4dict.p__File._AS4-Library,
          INPUT 0,
          INPUT 0).
   
       IF dba_return <> 1 THEN
         assign pass = 10000.
     END.    
    
     IF dba_return = 1 THEN DO:
        ierror = 7.  /* File already exists */
        RETURN.
     END.   

     ELSE If dba_return = 2 THEN DO:
         dba_cmd = "RESERVE".
         RUN as4dict/_dbaocmd.p 
           (INPUT "LF",
            INPUT As4Name,
            INPUT as4dict.p__File._AS4-Library,
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
	 INPUT CAPS(as4dict.p__File._AS4-file),
      	 INPUT  CAPS(as4dict.p__File._AS4-Library),
	 INPUT 0,
        INPUT 0).

      If dba_return <> 1 THEN DO:
            RUN as4dict/_dbamsgs.p.
            ierror = 26.
            RETURN.                 
      END.
      ELSE DO:
           dba_cmd = "CHKF".
           RUN as4dict/_dbaocmd.p
           (INPUT "*USRIDX",
            INPUT As4Name,
            INPUT as4dict.p__File._AS4-Library,
            INPUT 0,
            INPUT 0).
   
       IF dba_return = 1 THEN DO:
          ierror = 26.  /* File already exists */
          RETURN.
       END.   
     END.
   END.
   
  /* Ok to add - continue */
  
  FIND LAST as4dict.p__Index WHERE as4dict.p__Index._File-number = as4dict.p__File._File-number
              USE-INDEX   P__INDEXL1  NO-LOCK NO-ERROR.

  /* This is the new way to assign Idx-num to a new index. If there's a value in 
     this field take it.  */
     
  ASSIGN pidxnumber = (IF as4dict.p__file._Fil-Res1[2] <> ? THEN
                       as4dict.p__file._Fil-Res1[2] + 1 ELSE 1).
  
  CREATE as4dict.p__Index.
  ASSIGN
    as4dict.p__Index._File-number = pfilenumber
    as4dict.p__Index._Idx-num = pidxnumber       
    as4dict.p__Index._As4-file = As4Name
    as4dict.p__Index._AS4-Library = as4dict.p__File._AS4-Library
    as4dict.p__Index._Index-name = widx._Index-name  
    as4dict.p__Index._Desc = TRIM(REPLACE(widx._Desc, CHR(13), ""))
    as4dict.p__Index._For-Type = widx._For-Type
    as4dict.p__Index._For-name = as4dict.p__File._AS4-Library + "/" + As4Name
    as4dict.p__Index._I-misc2[4] = (IF widx._I-misc2[4] = '' THEN "NNNYYYYNN" else widx._I-misc2[4])
    as4dict.p__Index._I-Misc2[6] = as4dict.p__file._AS4-Library + "/" + as4dict.p__File._As4-File
    as4dict.p__index._Active  = (IF widx._Active = "N" THEN "N" ELSE "Y")
    as4dict.p__Index._Unique  = (IF widx._Unique = "" THEN "N" ELSE widx._Unique)
    as4dict.p__Index._Wordidx =  widx._Wordidx
    as4dict.p__Index._I-Res1[1] = 30.             
  
 
  FOR EACH wixf:   
    FIND as4dict.p__Field WHERE as4dict.p__Field._File-number = pfilenumber
                  AND as4dict.p__Field._Fld-number = wixf._Fld-number.

    CREATE as4dict.p__Idxfd.
    ASSIGN
      as4dict.p__Idxfd._Idx-num = as4dict.p__Index._Idx-num
      as4dict.p__Idxfd._Fld-number =   as4dict.p__Field._fld-number                     
      as4dict.p__Idxfd._File-number = pfilenumber
      as4dict.p__Idxfd._AS4-file = as4dict.p__Index._AS4-file
      as4dict.p__Idxfd._AS4-Library = as4dict.p__Index._AS4-Library
      as4dict.p__Idxfd._Index-Seq   = wixf._Index-Seq
      as4dict.p__Idxfd._Abbreviate  = (IF wixf._Abbreviate = "" OR wixf._Abbreviate = ?
           THEN "N" ELSE wixf._Abbreviate)
      as4dict.p__Idxfd._Ascending   = wixf._Ascending
      as4dict.p__Idxfd._If-misc2[1] = as4dict.p__Field._Fld-Misc2[2]
      as4dict.p__Idxfd._If-misc2[2] = SUBSTRING(as4dict.p__Field._For-name,1,10)
      as4dict.p__Index._Num-comp = as4dict.p__Index._Num-comp + 1.

      IF as4dict.p__Idxfd._If-misc2[1] = "Y" THEN
      	   ASSIGN as4dict.p__Index._I-Misc2[4] = "NNYYYYYNN".
      ELSE    ASSIGN as4dict.p__Index._I-Misc2[4] = "NNNYYYYNN".     

      /* Indicates cstring field within index */
      IF as4dict.p__field._fld-stdtype = 41 THEN
         ASSIGN as4dict.p__Field._Fld-Misc2[8] = "Y"
                as4dict.p__idxfd._If-Misc2[7] = "Y".

      /* Indicate if Index has case sensitive field in it */
      IF as4dict.p__Field._Fld-Misc2[6] = "A" AND as4dict.p__Field._Fld-case = "Y" THEN
	ASSIGN as4dict.p__Index._I-Misc2[4] = SUBSTRING(as4dict.p__Index._I-Misc2[4],1,9) + "Y".

   END.                               

   IF iprimary  THEN 
       ASSIGN as4dict.p__File._Prime-index = as4dict.p__Index._Idx-num
              as4dict.p__File._Fil-misc1[7] = as4dict.p__Index._Idx-num
              SUBSTRING(as4dict.p__Index._I-Misc2[4],9,1) = "Y".
 
        
   ASSIGN as4dict.p__Index._For-type = as4dict.p__File._For-format.
   ASSIGN as4dict.p__File._numkey = as4dict.p__File._Numkey + 1.                     
   ASSIGN as4dict.p__File._Fil-Res1[2] = pidxnumber
          as4dict.p__File._Fil-misc1[1] = as4dict.p__File._Fil-misc1[1] + 1.

END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "m" THEN DO: /*---------------------------------------------------*/
  IF widx._Active = "N" AND as4dict.p__Index._Active = "Y" THEN as4dict.p__Index._Active = "N".
  /* If new primary index - ie. UPDATE PRIMARY indexname in .DF  Since word index can not
     be a primary index, we do not have to worry about checking for LF  */
  IF iprimary AND as4dict.p__File._Prime-Index <> as4dict.p__Index._Idx-num THEN DO:       
    ASSIGN as4dict.p__File._Prime-index = as4dict.p__Index._Idx-num.

    IF as4dict.p__file._fil-Misc1[7] <> as4dict.p__file._Prime-Index THEN DO:
       /* Generate CHKF and RESERVE for old keyed index  */
       FIND keyed_index WHERE keyed_index._File-number = as4dict.p__file._file-number 
           AND keyed_index._idx-num = as4dict.p__file._Fil-Misc1[7] NO-ERROR.                             
       IF AVAILABLE (keyed_index) THEN DO:
          /* Check for AS400 unique name */
          IF keyed_index._As4-File = "" THEN
             IF LENGTH(keyed_index._Index-name) < 11 THEN
               ASSIGN nam = CAPS(keyed_index._Index-name).
             ELSE DO:
                ASSIGN nam = CAPS(SUBSTRING(keyed_index._Index-name,1,10)).
                {as4dict/load/as4name.i}
                ASSIGN As4Name = CAPS(nam).
             END.
          ELSE
             ASSIGN As4Name = CAPS(keyed_index._As4-File).

          ASSIGN AS4Library = CAPS(user_dbname).
         
            /* Do a CHKF to see if the file exists already, generate
              PF placeholder  */
          dba_cmd = "CHKF".
          RUN as4dict/_dbaocmd.p
            (INPUT "LF",
             INPUT As4Name,
             INPUT as4dict.p__File._AS4-Library,
             INPUT 0,
             INPUT 0).
          
          IF dba_return = 1 THEN DO:
            ierror = 7.  /* File already exists */
           RETURN.
          END.   
          ELSE If dba_return = 2 THEN DO:
             dba_cmd = "RESERVE".
             RUN as4dict/_dbaocmd.p 
                (INPUT "LF",
                 INPUT As4Name,
                 INPUT as4dict.p__File._AS4-Library,
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
          ASSIGN SUBSTRING(keyed_index._I-misc2[4],9,1) = "N"
                 keyed_index._I-Res1[4] = 1
                 as4dict.p__File._fil-Res1[7] = (IF as4dict.p__file._fil-Res1[7] > 0 THEN as4dict.p__file._fil-Res1[7]
                                                 ELSE Keyed_index._idx-num).
        END. /* Keyed Index Available */
      END.  /* Prime_index <> Fil-Misc1  */

      ASSIGN as4dict.p__File._Fil-Misc1[7] = as4dict.p__index._Idx-num
           SUBSTRING(as4dict.p__Index._I-Misc2[4],9,1) = "Y".
    END.  /* Primary Index change */

    IF widx._Desc     <> as4dict.p__Index._Desc     THEN as4dict.p__Index._Desc     = widx._Desc.
    IF widx._I-misc1[1] <> as4dict.p__Index._I-misc1[1] THEN as4dict.p__Index._I-misc1[1] = widx._I-misc1[1].
    ASSIGN as4dict.p__Index._I-Res1[8] = 1  /* ADE change occurred */
           as4dict.p__File._Fil-misc1[1] = as4dict.p__File._Fil-misc1[1] + 1.
END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "r" THEN DO: /*---------------------------------------------------*/
  IF CAN-FIND(FIRST as4dict.p__Index WHERE TRIM(as4dict.p__Index._Index-name) = irename
         AND as4dict.p__index._file-number = as4dict.p__file._file-number) THEN
    ierror = 7. /* "&2 already exists with name &3" */
  IF ierror > 0 THEN RETURN.
  IF irename <> "default" THEN as4dict.p__Index._Index-name = irename.
  ASSIGN as4dict.p__Index._I-Res1[8] = 1  /* ADE change occurred */
         as4dict.p__File._Fil-misc1[1] = as4dict.p__File._Fil-misc1[1] + 1.
END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "d" THEN DO: /*---------------------------------------------------*/
  FIND as4dict.p__Index WHERE TRIM(as4dict.p__Index._Index-name) = TRIM(widx._Index-name) 
         AND as4dict.p__index._file-number = as4dict.p__file._file-number NO-ERROR.

  /* if a field is deleted, then its index is deleted.  therefore, this
  index might be missing.  so don't complain if we don't find it. */

  IF NOT AVAILABLE as4dict.p__Index AND NOT CAN-DO(kindexcache,widx._Index-name) THEN
    ierror = 9. /* "Index already deleted" */
  IF ierror > 0 THEN RETURN.

  IF AVAILABLE as4dict.p__Index THEN DO:

    /* ------------- If primary index delete ---------------------- */
    FIND as4dict.p__File  WHERE as4dict.p__File._File-number = as4dict.p__Index._File-number.
    New_primary = FALSE.
    IF as4dict.p__Index._Idx-num = as4dict.p__File._Prime-Index THEN DO:
        RUN Swap_Primary (OUTPUT New_primary).
        IF ierror > 0 THEN RETURN.
    END.  /* ------ If primary index delete -------------- */

    IF NOT new_Primary THEN DO:
      IF as4dict.p__Index._Wordidx = 0 THEN DO:
       dba_cmd = "DLTOBJ".
       RUN as4dict/_dbaocmd.p 
 	  (INPUT "LF", 
	   INPUT as4dict.p__Index._AS4-File,
      	   INPUT as4dict.p__Index._AS4-Library,
	   INPUT as4dict.p__File._File-number,
	   INPUT as4dict.p__Index._Idx-Num).

       IF dba_return <> 1 THEN DO:
           RUN as4dict/_dbamsgs.p.
           ierror = 23. /* default error to general table attr error */              
         RETURN.
       END. 
     END.
     ELSE DO:
       dba_cmd = "DLTOBJ".
       RUN as4dict/_dbaocmd.p 
 	  (INPUT "*USRIDX", 
	   INPUT as4dict.p__Index._AS4-File,
      	   INPUT as4dict.p__Index._AS4-Library,
	   INPUT as4dict.p__File._File-number,
	   INPUT as4dict.p__Index._Idx-Num).

       IF dba_return <> 1 THEN DO:
           RUN as4dict/_dbamsgs.p.
           ierror = 23. /* default error to general table attr error */              
         RETURN.
       END. 
     END.
  
   END.  /* If NOT new_primary */
    
    FOR EACH as4dict.p__Idxfd WHERE as4dict.p__Idxfd._File-number = as4dict.p__Index._File-number
                           AND as4dict.p__Idxfd._Idx-num = as4dict.p__Index._Idx-num:
      DELETE as4dict.p__Idxfd.
    END.

   /* Needed to assign p__file information for re-organizing index numbers */
    ASSIGN as4dict.p__File._numkey = (as4dict.p__file._numkey - 1)
           as4dict.p__file._fil-Res1[1] = as4dict.p__file._Fil-Res1[1] + 1
           as4dict.p__File._Fil-misc1[1] = as4dict.p__File._Fil-misc1[1] + 1.
                
     IF as4dict.p__Index._Idx-num < as4dict.p__File._Fil-Res1[3] OR
        as4dict.p__file._Fil-Res1[3] = 0 then
           assign as4dict.p__file._Fil-Res1[3] =  as4dict.p__Index._Idx-num.   
           
    DELETE as4dict.p__Index.        
  END.  /* If index available */

END. /*---------------------------------------------------------------------*/

RETURN.





