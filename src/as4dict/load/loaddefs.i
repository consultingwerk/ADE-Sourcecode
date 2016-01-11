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

/* loaddefs.i - definitions for load .df file 
    Modified from prodict/dump/loaddefs.i 2/23/95 DLM 
    Modified 12/01/95 for definitions of temportary tables DLM 
             10/09/01 Added new funtion for changing primary index on existing table. DLM    
*/

DEFINE {1} SHARED VARIABLE iarg AS CHARACTER NO-UNDO. /* usually = ilin[2] */
DEFINE {1} SHARED VARIABLE ikwd AS CHARACTER NO-UNDO. /* usually = ilin[1] */
DEFINE {1} SHARED VARIABLE imod AS CHARACTER NO-UNDO. /* add/mod/ren/del */
DEFINE {1} SHARED VARIABLE ipos	AS INTEGER   NO-UNDO. /* line# in file */
DEFINE {1} SHARED VARIABLE ilin AS CHARACTER EXTENT 256 NO-UNDO.

DEFINE {1} SHARED VARIABLE iprimary   AS LOGICAL   NO-UNDO. /* is prim idx */
DEFINE {1} SHARED VARIABLE irename    AS CHARACTER NO-UNDO. /* new name */
DEFINE {1} SHARED VARIABLE icomponent AS INTEGER   NO-UNDO. /* idx-fld seq # */

DEFINE {1} SHARED VARIABLE inoerror AS LOGICAL   NO-UNDO. /* no-error seen? */
DEFINE {1} SHARED VARIABLE ierror   AS INTEGER   NO-UNDO. /* error counter */
DEFINE {1} SHARED VARIABLE as400_type AS LOGICAL NO-UNDO. /* Table Type   */  
DEFINE {1} SHARED VARIABLE addtbl AS LOGICAL NO-UNDO. /* Adding new table */

/* Changed to reference p__xxx files   */

DEFINE {1} SHARED WORKFILE wdbs NO-UNDO LIKE as4dict.p__Db.
DEFINE {1} SHARED WORKFILE wfil NO-UNDO LIKE as4dict.p__File.
DEFINE {1} SHARED WORKFILE wfit NO-UNDO LIKE as4dict.p__Trgfl.
DEFINE {1} SHARED WORKFILE wfld NO-UNDO LIKE as4dict.p__Field.
DEFINE {1} SHARED WORKFILE wflt NO-UNDO LIKE as4dict.p__Trgfd.
DEFINE {1} SHARED WORKFILE widx NO-UNDO LIKE as4dict.p__Index.
DEFINE {1} SHARED WORKFILE wixf NO-UNDO LIKE as4dict.p__Idxfd.
DEFINE {1} SHARED WORKFILE wseq NO-UNDO LIKE as4dict.p__Seq.    

/* Work tables to be used if this is the initial load */

DEFINE {1} SHARED TEMP-TABLE wtp__file NO-UNDO LIKE as4dict.p__file.
DEFINE {1} SHARED TEMP-TABLE wtp__field NO-UNDO LIKE as4dict.p__field.
DEFINE {1} SHARED TEMP-TABLE wtp__index NO-UNDO LIKE as4dict.p__index.
DEFINE {1} SHARED TEMP-TABLE wtp__idxfd NO-UNDO LIKE as4dict.p__idxfd.
DEFINE {1} SHARED TEMP-TABLE wtp__trgfl NO-UNDO LIKE as4dict.p__trgfl.
DEFINE {1} SHARED TEMP-TABLE wtp__trgfd NO-UNDO LIKE as4dict.p__trgfd.
 DEFINE {1} SHARED TEMP-TABLE wtp__view NO-UNDO LIKE as4dict.p__view.

/* gate_xxx - for lookup of _for-type -> _fld-stdtype converions */
DEFINE {1} SHARED VARIABLE gate_dbtype AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE gate_proc   AS CHARACTER NO-UNDO. /* xxx_typ.p */

/* dblangcache - list of sql files - _File._Db-lang -> 1 */
DEFINE {1} SHARED VARIABLE dblangcache AS CHARACTER NO-UNDO.

/* kindexcache - list of index names deleted when fields deleted */
DEFINE {1} SHARED VARIABLE kindexcache AS CHARACTER NO-UNDO.

/* frozencache - list of files to be marked frozen */
DEFINE {1} SHARED VARIABLE frozencache AS CHARACTER NO-UNDO.

/* Definition needed for p__xxx files             */
DEFINE {1} SHARED VARIABLE pfilenumber LIKE as4dict.P__File._File-number.
DEFINE {1} SHARED VARIABLE pfldnumber  LIKE as4dict.p__Field._Fld-number.   
DEFINE {1} SHARED VARIABLE pidxnumber  LIKE as4dict.p__Index._Idx-num.   
DEFINE {1} SHARED VARIABLE as4filename LIKE as4dict.p__File._AS4-file.     

DEFINE {1} SHARED VARIABLE drec_db     AS RECID    INITIAL ?    NO-UNDO.
DEFINE {1} SHARED VARIABLE drec_file   AS RECID    INITIAL ?    NO-UNDO.

/* Error File if Errors_to_file selected */
DEFINE {1} SHARED STREAM loaderrs.
DEFINE {1} SHARED VARIABLE fil-e      AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE first_error AS LOGICAL  NO-UNDO init true.
DEFINE {1} SHARED VARIABLE diag_errs   AS LOGICAL  NO-UNDO. /* diagnostic errors */

/* Variables needed from prodict/dictvar.i brought here */
DEFINE {1} SHARED VARIABLE user_dbname   AS CHARACTER                NO-UNDO.
DEFINE {1} SHARED VARIABLE user_dbtype   AS CHARACTER                  NO-UNDO.
DEFINE {1} SHARED VARIABLE user_path     AS CHARACTER                     NO-UNDO.
DEFINE {1} SHARED VARIABLE cache_dirty AS LOGICAL  INITIAL TRUE NO-UNDO.

/* Needed for primary index swap in field and index load */
DEFINE BUFFER keyed_index FOR as4dict.p__Index.
DEFINE BUFFER another_index FOR as4dict.p__Index.

/* Needed for shared procedures   */
DEFINE VARIABLE Entity_name AS CHARACTER           NO-UNDO.
DEFINE VARIABLE Table_name  AS CHARACTER           NO-UNDO.
DEFINE VARIABLE lfld        AS CHARACTER           No-UNDO.

/*==================================================================*/
/* LOAD SHARED PROCEDURES                                           */
/* The following procedures are shared by the various load routines */
/*==================================================================*/
PROCEDURE New_Prime:
  DEFINE VARIABLE As4Name AS CHARACTER NO-UNDO.
  DEFINE VARIABLE As4Library AS CHARACTER NO-UNDO.

  /* For As4Name validation */
  DEFINE VARIABLE i AS INTEGER.
  DEFINE VARIABLE lngth AS INTEGER.
  DEFINE VARIABLE nam  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE pass AS INTEGER   NO-UNDO. 

  /* Find old primary index and create place holder for new logical */
  FIND keyed_index WHERE keyed_index._File-number = as4dict.p__file._file-number 
         AND keyed_index._idx-num = as4dict.p__file._Fil-Misc1[7] NO-ERROR.                             
  IF AVAILABLE (keyed_index) THEN DO:
  /* We should always have an As400 Name, but check for it just in case */
    IF keyed_index._As4-File = "" THEN
      IF LENGTH(keyed_index._Index-name) < 11 THEN
        ASSIGN nam = CAPS(keyed_index._Index-name).
      ELSE DO:
        ASSIGN nam = CAPS(SUBSTRING(keyed_index._Index-name,1,10)).
          {as4dict/load/as4name.i}
        ASSIGN As4Name = CAPS(nam).
      END.
    ELSE
      assign As4Name = CAPS(keyed_index._As4-File).

    ASSIGN AS4Library = CAPS(user_dbname).
         
      /* Do a CHKF to see if the file exists already */
      dba_cmd = "CHKF".
      RUN as4dict/_dbaocmd.p
       (INPUT "LF",
        INPUT As4Name,
        INPUT As4Library,
        INPUT 0,
        INPUT 0).
       
      IF dba_return = 1 THEN DO pass = 1 TO 9999:
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
          INPUT As4Library,
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
      ASSIGN SUBSTRING(keyed_index._I-Misc2[4],9,1) = "N"
             keyed_index._I-Res1[4] = 1.
    END. /* Keyed Index Available */
END PROCEDURE.


PROCEDURE Swap_Primary:

/*  If the primary index is being deleted, swap the primary to another
index.  This procedure is called from _lod_idx.p and _lod_fld.p  */

DEFINE OUTPUT PARAMETER New_Primary AS LOGICAL NO-UNDO.

DEFINE VARIABLE As4Name AS CHARACTER NO-UNDO.
DEFINE VARIABLE As4Library AS CHARACTER NO-UNDO.

/* For As4Name validation */
DEFINE VARIABLE i AS INTEGER.
DEFINE VARIABLE lngth AS INTEGER.
DEFINE VARIABLE nam  AS CHARACTER NO-UNDO.
DEFINE VARIABLE pass AS INTEGER   NO-UNDO.              

/* If the file is keyed by another index besides the primary, make
   that index the primary index.                                   */

   IF as4dict.p__file._Prime-Index <> as4dict.p__file._Fil-Misc1[7] THEN DO:
     FIND keyed_index WHERE keyed_index._File-number = as4dict.p__file._file-number 
         AND keyed_index._idx-num = as4dict.p__file._Fil-Misc1[7] NO-ERROR.                             
      IF AVAILABLE (keyed_index) THEN DO:
          /* We should always have an As400 Name, but check for it just
             in case */
         IF keyed_index._As4-File = "" THEN
             IF LENGTH(keyed_index._Index-name) < 11 THEN
                 ASSIGN nam = CAPS(keyed_index._Index-name).
             ELSE DO:
                 ASSIGN nam = CAPS(SUBSTRING(keyed_index._Index-name,1,10)).
                 {as4dict/load/as4name.i}
                 ASSIGN As4Name = CAPS(nam).
              END.
         ELSE
             assign As4Name = CAPS(keyed_index._As4-File).

         ASSIGN AS4Library = CAPS(user_dbname).
         
         /* Do a CHKF to see if the file exists already */
         dba_cmd = "CHKF".
         RUN as4dict/_dbaocmd.p
             (INPUT "LF",
              INPUT As4Name,
              INPUT As4Library,
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
               INPUT As4Library,
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
               
       ASSIGN as4dict.p__file._Prime-Index = keyed_index._idx-num
              SUBSTRING(keyed_index._I-Misc2[4],9,1) = "Y".
     END. /* Keyed Index Available */
   END.  /* Prime_index <> Fil-Misc1  */
    
   ELSE DO:
       /* move primary to another index */
       New_Primary = TRUE.   /* don't issue DLTOBJ */
       FIND FIRST another_index where another_index._File-number = as4dict.p__File._File-number
         AND another_index._Idx-num <> as4dict.p__Index._Idx-num
         AND another_index._Wordidx <> 1 NO-ERROR.
       IF AVAILABLE (another_index) THEN 
          ASSIGN as4dict.p__File._Prime-Index = another_index._Idx-num
                 as4dict.p__File._Fil-Misc1[7] = another_index._Idx-num
                 SUBSTRING(another_index._I-Misc2[4],9,1) = "Y"
                 another_index._I-Res1[4] = 1
                 as4dict.p__File._fil-Res1[7] = 
                  (IF as4dict.p__file._fil-Res1[7] > 0 THEN as4dict.p__file._fil-Res1[7]
                   ELSE as4dict.p__index._idx-num).

       ELSE 
          ASSIGN as4dict.p__file._Fil-Misc1[7] = -1  /* no primary index */          
                 as4dict.p__File._Prime-Index = -1.  
    END.  /* Prime_index = Fil-Misc1 */

END.  /* End Procedure */
/*------------------------------------------------------------------------
Procedure:  Error_log
Description:  Logs informational errors which do not stop the load
              and allow the entity to still be defined (ie. truncation
              errors, etc).
Input Parameter:  Type of message.  1 = Field too long, not loaded
                                    2 = Field truncated
                                    3 = Recid ID datatype changed to Long Integer
----------------------------------------------------------------*/
PROCEDURE Error_log:

  DEFINE INPUT PARAMETER fld_err_type AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER iobj AS CHARACTER NO-UNDO.

  DEFINE VARIABLE info_msg AS CHARACTER NO-UNDO.
  DEFINE VARIABLE entity_type AS CHARACTER NO-UNDO.
  DEFINE VARIABLE of_table AS CHARACTER NO-UNDO.

  CASE fld_err_type:
    WHEN 1 THEN info_msg = SUBSTITUTE("Value of &1 too long, &1 not loaded", lfld).
    WHEN 2 THEN info_msg = SUBSTITUTE("Value of &1 was truncated", lfld).

  END CASE.

  CASE iobj:
    WHEN "t" THEN DO:
        entity_type = "Table ".
        of_table = "".
     END.
    WHEN "f" THEN DO:
        entity_type = "Field ".
        of_table = " of " + Table_name.
     END.
    WHEN "i" THEN DO:
        entity_type = "Index ".
        of_table = " on " + Table_name.
     END.
  END CASE.

  IF first_error AND User_Env[27] BEGINS "y" THEN DO:
     RUN Open_Stream.
     first_error = false.
  END.
 
  IF User_Env[27] BEGINS "y" THEN
     PUT STREAM loaderrs UNFORMATTED 
         SKIP entity_type entity_name + of_table + ":  " info_msg SKIP.

  IF User_Env[28] BEGINS "y" THEN 
     MESSAGE entity_type entity_name + of_table + ": " info_msg 
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.
          
  RUN adecomm/_setcurs.p ("WAIT").
  diag_errs = true.
  
END.

/*----------------------------------------------------------------
   Procedure:  Open_Stream.

   Description:  
    If the user chose to have the errors displayed to a file, open and 
    create the file.  The file will be the same name as the .df file with
    a .e extension.  
----------------------------------------------------------------*/

PROCEDURE Open_Stream:

  DEFINE VARIABLE suffix_pos AS INTEGER NO-UNDO.
  DEFINE VARIABLE prefix_pos AS INTEGER NO-UNDO.
  DEFINE VARIABLE found      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE name_length AS INTEGER NO-UNDO.

  ASSIGN suffix_pos = INDEX(user_env[2], ".DF")
         prefix_pos = suffix_pos
         name_length = 0.       
  DO WHILE NOT found:
         name_length = name_length + 1.
         prefix_pos = prefix_pos - 1.
       IF prefix_pos = 0 THEN
            found = yes.
       ELSE
            found = (IF SUBSTRING(user_env[2], prefix_pos, 1, "CHARACTER") = "/" OR
                    SUBSTRING(user_env[2], prefix_pos, 1, "CHARACTER") = "~\" THEN yes
                 ELSE no).
   END.
    
   ASSIGN fil-e = SUBSTRING(user_env[2], prefix_pos + 1, name_length - 1) + ".e".
   ASSIGN fil-e = LC(fil-e).
   OUTPUT STREAM loaderrs TO VALUE(fil-e).
 END. 

