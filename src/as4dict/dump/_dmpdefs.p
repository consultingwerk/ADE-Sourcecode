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


/*-----------------------------------------------------------------*/
/* as4dict/dump/_dmpdefs.p - Dump Data Definitions for the As/400  */
/*                           Taken from prodict/dump/_dmpdefs      */
/* history:                                                        */
/*   Nhorn   5/01/95   Initial creation from prodict/dump/_dmpdefs */
/*   D. McMann 11/25/97 Added dump of AREA for V9 new meta schema  */
/*   D. McMann 11/09/98 Change Area from 6 to Schema Area          */
/*   D. McMann 06/10/99 Added Stored Procedure Support             */
/*   D. McMann 11/03/99 Decremented max-size so load will be       */
/*                      correct 19991103-015                       */
/*   D. McMann 02/02/00 Changed output of Cycle-OK  20000131-013   */
/*   D. McMann 05/18/00 Added new key work MAX-GLYHPS              */
/*   D. McMann 02/15/01 Added check for AS400 format               */
/*-----------------------------------------------------------------*/       

DEFINE INPUT  PARAMETER pi_method AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pi_filenum AS INTEGER NO-UNDO.

{as4dict/dictvar.i shared }

DEFINE VARIABLE v_ispro AS LOGICAL NO-UNDO.
DEFINE VARIABLE byte1   AS INTEGER NO-UNDO.
DEFINE VARIABLE byte2   AS INTEGER NO-UNDO.
DEFINE VARIABLE vers    AS CHAR    NO-UNDO.

DEFINE SHARED STREAM ddl.
DEFINE SHARED FRAME working.   

/* User_Env[29] - will be equal to "incr" when coming from the incremental
   dump program.  In this case, we don't want to use frame "working",
   because the incremental program has its own frame.  We suppress the
   display commands when User_Env[29] is equal to "Incr".               */

{ as4dict/dump/as4dmpdf.f &FRAME = "working" }

IF pi_method BEGINS "d" and dump_format <> "AS400" THEN DO:
    PUT STREAM ddl UNFORMATTED
      "UPDATE DATABASE """ ? """ " SKIP.
    PUT STREAM ddl UNFORMATTED SKIP(1).
END.

ELSE

IF pi_method BEGINS "s" THEN DO: /*-------------------------*/ /* sequences */
   FOR EACH AS4DICT.P__Seq BY as4dict.P__SEQ._Seq-Name:
     IF TERMINAL <> "" THEN
        DISPLAY as4dict.p__seq._Seq-Name WITH FRAME working.
     PUT STREAM ddl UNFORMATTED "ADD SEQUENCE """ as4dict.P__Seq._Seq-Name """" SKIP.
     PUT STREAM ddl UNFORMATTED "  INITIAL " as4dict.P__Seq._Seq-Init SKIP.
     PUT STREAM ddl UNFORMATTED "  INCREMENT " as4dict.P__Seq._Seq-Incr SKIP.
     PUT STREAM ddl CONTROL "  CYCLE-ON-LIMIT ".
     IF as4dict.p__Seq._Cycle-Ok = "Y" THEN
       EXPORT STREAM ddl "yes".
     ELSE 
       EXPORT STREAM ddl "no".
     IF as4dict.P__Seq._Seq-Min <> ? THEN
       PUT STREAM ddl UNFORMATTED "  MIN-VAL " as4dict.P__Seq._Seq-Min SKIP.
     IF as4dict.P__Seq._Seq-Max <> ? AND as4dict.p__Seq._Seq-Max <> 0 THEN
       PUT STREAM ddl UNFORMATTED "  MAX-VAL " as4dict.P__Seq._Seq-Max SKIP.
     PUT STREAM ddl UNFORMATTED SKIP(1).
   END.
    IF TERMINAL <> "" THEN
      DISPLAY "" @ as4dict.p__seq._Seq-Name WITH FRAME working. 
END.    
ELSE
IF pi_method BEGINS "t" THEN DO: /*----------------------*/ /* table_record */
  FIND as4dict.p__File WHERE as4dict.p__file._File-Number = pi_filenum NO-LOCK NO-ERROR.
  IF NOT AVAILABLE as4dict.p__File THEN DO:
    FIND as4dict.p__Field WHERE as4dict.p__Field._Fld-Number = pi_filenum NO-LOCK NO-ERROR.
    IF AVAILABLE as4dict.p__Field THEN FIND as4dict.p__file 
          where as4dict.p__field._File-Number = as4dict.p__file._File-Number.
  END.
  IF NOT AVAILABLE as4dict.P__File THEN DO:
    FIND as4dict.p__index WHERE as4dict.P__INDEX._Idx-Num = pi_filenum NO-LOCK NO-ERROR.
    IF AVAILABLE as4dict.P__Index THEN FIND as4dict.P__File 
       WHERE as4dict.P__File._File-Number = as4dict.P__Index._File-Number.
  END.
  IF as4dict.P__File._File-Number = pi_filenum THEN DO:
    PUT STREAM ddl UNFORMATTED "ADD TABLE """ as4dict.p__File._File-name """".
    IF dump_format = "AS400" THEN 
      PUT STREAM ddl UNFORMATTED "  TYPE AS400 " SKIP.
    ELSE
      PUT STREAM ddl UNFORMATTED SKIP.
    IF dump_format <> "AS400" THEN
      PUT STREAM ddl UNFORMATTED '  AREA "Schema Area" ' SKIP.  
    IF as4dict.p__File._Can-Create <> '*' AND as4dict.p__file._Can-Create <> '' THEN DO:
      PUT STREAM ddl CONTROL "  CAN-CREATE ".
      EXPORT STREAM ddl as4dict.p__File._Can-Create.
    END.
    IF as4dict.p__File._Can-Delete <> '*' AND as4dict.p__file._Can-Delete <> '' THEN DO:
      PUT STREAM ddl CONTROL "  CAN-DELETE ".
      EXPORT STREAM ddl as4dict.p__File._Can-Delete.
    END.
    IF as4dict.p__File._Can-Read <> '*' AND as4dict.p__file._Can-Read <> '' THEN DO:
      PUT STREAM ddl CONTROL "  CAN-READ ".
      EXPORT STREAM ddl as4dict.p__File._Can-Read.
    END.
    IF as4dict.p__File._Can-Write <> '*' AND as4dict.p__file._Can-Write <> '' THEN DO:
      PUT STREAM ddl CONTROL "  CAN-WRITE ".
      EXPORT STREAM ddl as4dict.p__File._Can-Write.
    END.
    IF as4dict.p__File._Can-Dump <> '*' AND as4dict.p__file._Can-Dump <> '' THEN DO:
      PUT STREAM ddl CONTROL "  CAN-DUMP ".
      EXPORT STREAM ddl as4dict.p__File._Can-Dump.
    END.
    IF as4dict.p__File._Can-Load <> '*' AND as4dict.p__file._Can-Load <> '' THEN DO:
      PUT STREAM ddl CONTROL "  CAN-LOAD ".
      EXPORT STREAM ddl as4dict.p__File._Can-Load.
    END.
    IF as4dict.p__File._File-Label <> ? AND as4dict.p__File._File-Label <> '' THEN DO:
      PUT STREAM ddl CONTROL "  LABEL ".
      EXPORT STREAM ddl as4dict.p__File._File-Label.
    END.
    IF as4dict.p__File._File-Label-SA <> ? AND as4dict.p__File._File-Label-SA <> '' THEN DO:
      PUT STREAM ddl CONTROL "  LABEL-SA ".
      EXPORT STREAM ddl as4dict.p__File._File-Label-SA.
    END.
    IF as4dict.p__File._Desc <> ? AND as4dict.p__File._Desc <> '' THEN DO:
      PUT STREAM ddl CONTROL "  DESCRIPTION ".
      EXPORT STREAM ddl as4dict.p__File._Desc.
    END.
    IF as4dict.p__File._Valexp <> ? AND as4dict.p__File._Valexp <> '' THEN DO:
      PUT STREAM ddl CONTROL "  VALEXP ".
      EXPORT STREAM ddl as4dict.p__File._Valexp.
    END.
    IF as4dict.p__File._Valmsg <> ? AND as4dict.p__File._Valmsg <> '' THEN DO:
      PUT STREAM ddl CONTROL "  VALMSG ".
      EXPORT STREAM ddl as4dict.p__File._Valmsg.
    END.
    IF as4dict.p__File._Valmsg-SA <> ? AND as4dict.p__File._Valmsg-SA <> '' THEN DO:
      PUT STREAM ddl CONTROL "  VALMSG-SA ".
      EXPORT STREAM ddl as4dict.p__File._Valmsg-SA.
    END.
    IF as4dict.p__File._Frozen = "Y" THEN
      PUT STREAM ddl UNFORMATTED "  FROZEN" SKIP.
    IF as4dict.p__File._Hidden = "Y" THEN
      PUT STREAM ddl UNFORMATTED "  HIDDEN" SKIP.
    IF as4dict.p__File._Dump-name <> ? AND as4dict.p__file._dump-name <> '' THEN DO:
      PUT STREAM ddl CONTROL "  DUMP-NAME ".
      EXPORT STREAM ddl as4dict.p__File._Dump-name.
    END.
    IF dump_format = "AS400" THEN DO:
      IF as4dict.p__file._As4-File <> "" THEN
         PUT STREAM ddl UNFORMATTED "  AS400-FILE " as4dict.p__File._As4-File SKIP.         
      /* Don't dump these switches for virtual files, let the load generate the
         default settings */
      IF as4dict.p__file._Fil-Misc2[4] <> "" AND NOT as4dict.p__file._For-Flag < 2 THEN
         PUT STREAM ddl UNFORMATTED "  AS400-FLAGS " as4dict.p__File._Fil-misc2[4] SKIP.     
      IF as4dict.p__File._For-Format <> ? and as4dict.p__file._For-Format <> "" THEN DO:
         PUT STREAM ddl CONTROL "  FORMAT-NAME ".
         EXPORT STREAM ddl as4dict.p__File._For-Format.
      END.
      IF as4dict.p__File._For-Info = "PROCEDURE" THEN 
        PUT STREAM ddl UNFORMATTED "  PROCEDURE " SKIP.        
    END.  /* AS400 FORMAT */
    FOR EACH as4dict.p__trgfl where as4dict.p__trgfl._File-Number = as4dict.p__file._File-number
        NO-LOCK BY _Event:
      PUT STREAM ddl UNFORMATTED
        "  TABLE-TRIGGER """ as4dict.p__trgfl._Event """ "
        (IF as4dict.p__Trgfl._Override = "Y" THEN 'OVERRIDE' ELSE 'NO-OVERRIDE') " "
        "PROCEDURE """ as4dict.p__Trgfl._Proc-Name """ "
        "CRC """ as4dict.p__Trgfl._Trig-CRC """ " SKIP.
    END.
    PUT STREAM ddl UNFORMATTED SKIP(1).
  END.
  FOR EACH as4dict.p__Field WHERE as4dict.p__field._File-Number = as4dict.p__File._File-Number
        NO-LOCK BY _Field-rpos:
    IF as4dict.p__file._File-Number <> pi_filenum AND 
        as4dict.p__Field._Fld-Number <> pi_filenum THEN NEXT.

    /*  Skip AS/400 only fields (Fld-misc2[5] = A                      */
    IF as4dict.p__field._Fld-Misc2[5] = "A" THEN NEXT.
    IF TERMINAL <> "" AND NOT User_Env[29] BEGINS "Incr" THEN
         DISPLAY as4dict.p__field._Field-name with frame working.
    PUT STREAM ddl UNFORMATTED
      "ADD FIELD """ as4dict.p__Field._Field-name """ "
      "OF """ as4dict.p__File._File-name """ "
      "AS " as4dict.p__Field._Data-type " " SKIP.
    IF as4dict.p__Field._Desc <> ? AND as4dict.p__Field._Desc <> '' THEN DO:
      PUT STREAM ddl CONTROL "  DESCRIPTION ".
      EXPORT STREAM ddl as4dict.p__Field._Desc.
    END.
    PUT STREAM ddl CONTROL "  FORMAT ".
    EXPORT STREAM ddl as4dict.p__Field._Format.
    IF as4dict.p__Field._Format-SA <> ? AND as4dict.p__Field._Format-SA <> '' THEN DO:
      PUT STREAM ddl CONTROL "  FORMAT-SA ".
      EXPORT STREAM ddl as4dict.p__Field._Format-SA.
    END.
    PUT STREAM ddl CONTROL "  INITIAL ".
    EXPORT STREAM ddl as4dict.p__Field._Initial.
    IF as4dict.p__Field._Initial-SA <> ? AND as4dict.p__Field._Initial-SA <> '' THEN DO:
      PUT STREAM ddl CONTROL "  INITIAL-SA ".
      EXPORT STREAM ddl as4dict.p__Field._Initial-SA.
    END.
    IF as4dict.p__Field._Label <> ? AND as4dict.p__field._Label <> '' THEN DO:
      PUT STREAM ddl CONTROL "  LABEL ".
      EXPORT STREAM ddl as4dict.p__Field._Label.
    END.
    IF as4dict.p__Field._Label-SA <> ? AND as4dict.p__Field._Label-SA <> '' THEN DO:
      PUT STREAM ddl CONTROL "  LABEL-SA ".
      EXPORT STREAM ddl as4dict.p__Field._Label-SA.
    END.
    IF as4dict.p__Field._View-As <> ? AND as4dict.p__field._View-As <> '' THEN DO:
      PUT STREAM ddl CONTROL "  VIEW-AS ".
      EXPORT STREAM ddl as4dict.p__Field._View-As.
    END.
    IF as4dict.p__Field._Col-label <> ? AND as4dict.p__Field._Col-label <> '' THEN DO:
      PUT STREAM ddl CONTROL "  COLUMN-LABEL ".
      EXPORT STREAM ddl as4dict.p__Field._Col-label.
    END.
    IF as4dict.p__field._Col-label-SA <> ? AND as4dict.p__field._Col-label-SA <> '' THEN DO:
      PUT STREAM ddl CONTROL "  COLUMN-LABEL-SA ".
      EXPORT STREAM ddl as4dict.p__field._Col-label-SA.
    END.
    IF as4dict.p__field._Can-Read <> '*' AND as4dict.p__field._Can-Read <> '' THEN DO:
      PUT STREAM ddl CONTROL "  CAN-READ ".
      EXPORT STREAM ddl as4dict.p__field._Can-Read.
    END.
    IF as4dict.p__field._Can-Write <> '*' AND as4dict.p__field._Can-Write <> '' THEN DO:
      PUT STREAM ddl CONTROL "  CAN-WRITE ".
      EXPORT STREAM ddl as4dict.p__field._Can-Write.
    END.
    IF as4dict.p__field._Valexp <> ? AND as4dict.p__field._Valexp <> '' THEN DO:
      PUT STREAM ddl CONTROL "  VALEXP ".
      EXPORT STREAM ddl as4dict.p__field._Valexp.
    END.
    IF as4dict.p__field._Valmsg <> ? AND as4dict.p__field._Valmsg <> '' THEN DO:
      PUT STREAM ddl CONTROL "  VALMSG ".
      EXPORT STREAM ddl as4dict.p__field._Valmsg.
    END.
    IF as4dict.p__field._Valmsg-SA <> ? AND as4dict.p__field._Valmsg-SA <> '' THEN DO:
      PUT STREAM ddl CONTROL "  VALMSG-SA ".
      EXPORT STREAM ddl as4dict.p__field._Valmsg-SA.
    END.
    IF as4dict.p__field._Help <> ? AND as4dict.p__field._Help <> '' THEN DO:
      PUT STREAM ddl CONTROL "  HELP ".
      EXPORT STREAM ddl as4dict.p__field._Help.
    END.
    IF as4dict.p__field._Help-SA <> ? AND as4dict.p__field._Help-SA <> '' THEN DO:
      PUT STREAM ddl CONTROL "  HELP-SA ".
      EXPORT STREAM ddl as4dict.p__field._Help-SA.
    END.
    IF as4dict.p__field._Extent > 0 THEN
      PUT STREAM ddl UNFORMATTED "  EXTENT " as4dict.p__field._Extent SKIP.
    IF as4dict.p__field._Decimals <> ? AND as4dict.p__field._Decimals <> 0
      AND as4dict.p__field._Data-Type BEGINS "dec" THEN
      PUT STREAM ddl UNFORMATTED "  DECIMALS " as4dict.p__field._Decimals SKIP.
    IF as4dict.p__field._Decimals <> ? AND as4dict.p__field._Decimals <> 0 
      AND as4dict.p__field._Data-Type BEGINS "char" THEN
      PUT STREAM ddl UNFORMATTED "  LENGTH " as4dict.p__field._Decimals SKIP.
    PUT STREAM ddl UNFORMATTED "  ORDER " as4dict.p__field._Order SKIP.
    IF as4dict.p__field._Mandatory = "Y" THEN
      PUT STREAM ddl UNFORMATTED "  MANDATORY" SKIP.
    IF as4dict.p__field._Fld-case = "Y" AND as4dict.p__field._Data-Type BEGINS "char" THEN
      PUT STREAM ddl UNFORMATTED "  CASE-SENSITIVE" SKIP.

/*------   Information dumped for AS400 only  -------*/
    IF dump_format = "AS400" THEN DO:
       IF as4dict.p__Field._Fld-misc1[2] <> 0 THEN DO:
         IF as4dict.p__Field._Fld-misc1[2] = 1 THEN
           PUT STREAM ddl UNFORMATTED "  INPUT " SKIP.
         IF as4dict.p__Field._Fld-misc1[2] = 2 THEN
           PUT STREAM ddl UNFORMATTED "  INPUT/OUTPUT " SKIP.
         IF as4dict.p__Field._Fld-misc1[2] = 3 THEN
           PUT STREAM ddl UNFORMATTED "  OUTPUT " SKIP.
       END.
       IF as4dict.p__Field._Fld-misc2[5] <> ? AND as4dict.p__field._fld-misc2[5] <> '' THEN  
         PUT STREAM ddl UNFORMATTED "  FLD-USAGE-TYPE " as4dict.p__Field._Fld-misc2[5] SKIP.
       IF as4dict.p__Field._Fld-misc2[6] <> ? AND as4dict.p__field._fld-misc2[6] <> "" THEN
         PUT STREAM ddl UNFORMATTED "  DDS-TYPE " as4dict.p__field._fld-misc2[6] SKIP.
       IF as4dict.p__field._Fld-stdtype <> 0 THEN
         PUT STREAM ddl UNFORMATTED "  FLD-STDTYPE " as4dict.p__field._fld-stdtype SKIP.
       IF as4dict.p__field._Fld-stlen <> ? AND as4dict.p__field._fld-stlen <> 0 THEN
         PUT STREAM ddl UNFORMATTED "  FLD-STLEN " as4dict.p__field._Fld-stlen SKIP.
       IF as4dict.p__field._For-Allocated <> ? AND as4dict.p__field._For-Allocated <> 0 THEN
         PUT STREAM ddl UNFORMATTED "  FOREIGN-ALLOCATED " as4dict.p__field._For-Allocated SKIP.
       IF as4dict.p__field._For-Maxsize <> ? AND as4dict.p__field._For-Maxsize <> 0 THEN
         PUT STREAM ddl UNFORMATTED "  FOREIGN-MAXIMUM " (as4dict.p__field._For-Maxsize - 2) SKIP.
       IF as4dict.p__field._For-Name <> ? AND as4dict.p__field._For-Name <> "" THEN 
         PUT STREAM ddl UNFORMATTED "  FOREIGN-NAME " as4dict.p__field._For-Name SKIP.
       IF as4dict.p__field._For-Type <> ? AND as4dict.p__field._For-Type <> "" THEN 
         PUT STREAM ddl UNFORMATTED "  AS400-TYPE " as4dict.p__field._For-Type SKIP.
       IF as4dict.p__Field._Fld-misc1[5] > 0 THEN
         PUT STREAM ddl UNFORMATTED "  MAX-GLYPHS " as4dict.p__Field._Fld-misc1[5] SKIP.
       PUT STREAM ddl UNFORMATTED (if as4dict.p__field._Fld-Misc2[2] = "Y" THEN
             "  NULL-CAPABLE " else "") SKIP.
    END. /* AS400 format dump */

    FOR EACH as4dict.p__trgfd WHERE as4dict.p__trgfd._Fld-Number = as4dict.p__Field._Fld-Number
         AND as4dict.p__trgfd._File-Number = as4dict.p__Field._File-Number
         NO-LOCK BY as4dict.p__Trgfd._Event:
      PUT STREAM ddl UNFORMATTED
        "  FIELD-TRIGGER """ as4dict.p__Trgfd._Event """ "
        (IF as4dict.p__Trgfd._Override = "Y" THEN 'OVERRIDE' ELSE 'NO-OVERRIDE') " "
        "PROCEDURE """ as4dict.p__Trgfd._Proc-Name """ "
        "CRC """ as4dict.p__Trgfd._Trig-CRC """ " SKIP.
    END.
    PUT STREAM ddl UNFORMATTED SKIP(1).
  END.

  IF TERMINAL <> "" AND NOT User_Env[29] BEGINS "incr" THEN
     DISPLAY "" @ as4dict.p__field._Field-name with frame working.

  FOR EACH as4dict.p__Index WHERE as4dict.p__index._File-Number = as4dict.p__file._File-Number
    AND (as4dict.p__File._dft-pk <> "Y" OR 
       as4dict.p__File._Prime-Index <> as4dict.p__Index._Idx-Num) NO-LOCK
    BY STRING(as4dict.p__File._Prime-Index = as4dict.p__Index._Idx-Num, "1/2") +
        as4dict.p__Index._Index-name:
    IF as4dict.p__File._File-Number <> pi_filenum AND 
         as4dict.p__Index._Idx-Num <> pi_filenum THEN NEXT.

    IF TERMINAL <> "" AND NOT User_Env[29] BEGINS "incr" THEN 
        DISPLAY as4dict.p__Index._Index-name with frame working.
    PUT STREAM ddl UNFORMATTED
      "ADD INDEX """ as4dict.p__Index._Index-Name """ "
      "ON """ as4dict.p__File._File-name """ " SKIP.
    PUT STREAM ddl UNFORMATTED '  AREA "Schema Area" ' SKIP.      
    IF as4dict.p__Index._Unique = "Y" THEN
      PUT STREAM ddl UNFORMATTED "  UNIQUE" SKIP.
    IF as4dict.p__Index._Active <> "Y" THEN
      PUT STREAM ddl UNFORMATTED "  INACTIVE" SKIP.
    IF as4dict.p__File._Prime-index = as4dict.p__index._Idx-Num THEN
      PUT STREAM ddl UNFORMATTED "  PRIMARY" SKIP.
    IF as4dict.p__Index._Wordidx = 1 THEN
      PUT STREAM ddl UNFORMATTED "  WORD" SKIP.
    IF as4dict.p__Index._Desc <> ? AND as4dict.p__File._Desc <> '' THEN DO:
      PUT STREAM ddl CONTROL "  DESCRIPTION ".
      EXPORT STREAM ddl as4dict.p__Index._Desc.
    END.
 /*  Dump AS400  */
    IF dump_format = "AS400" THEN DO:
       IF as4dict.p__Index._For-Type <> ? AND 
          as4dict.p__Index._For-Type <> "" THEN
            PUT STREAM ddl UNFORMATTED "  FORMAT-NAME " as4dict.p__Index._For-Type SKIP.
        IF as4dict.p__Index._As4-File <> ? AND 
          as4dict.p__Index._As4-File <> "" THEN
            PUT STREAM ddl UNFORMATTED "  AS400-FILE " as4dict.p__Index._As4-File SKIP.            
       IF as4dict.p__Index._I-misc2[4] <> ? AND 
          as4dict.p__index._I-misc2[4] <> "" THEN 
            PUT STREAM ddl UNFORMATTED "  AS400-FLAGS " as4dict.p__Index._I-misc2[4] SKIP.
    END.  /* End AS400 Format */  
 
    FOR EACH as4dict.p__Idxfd WHERE as4dict.p__idxfd._Idx-Num = as4dict.p__Index._Idx-Num
         AND as4dict.p__Idxfd._file-number = as4dict.p__Index._file-number
            NO-LOCK
       BY as4dict.p__Idxfd._Index-seq:    
        IF as4dict.p__Idxfd._If-misc2[8] = "Y" THEN NEXT.
        FIND as4dict.p__Field 
           WHERE as4dict.p__field._Fld-Number = as4dict.p__idxfd._Fld-Number 
           AND as4dict.p__field._file-Number = as4dict.p__idxfd._file-number NO-LOCK.

        PUT STREAM ddl UNFORMATTED
        "  INDEX-FIELD """ as4dict.p__Field._Field-Name """ "
        (IF as4dict.p__Idxfd._Ascending = "Y" THEN "ASCENDING " ELSE "")
        (IF as4dict.p__Idxfd._Ascending <> "Y" THEN "DESCENDING " ELSE "")
        (IF as4dict.p__Idxfd._Abbreviate = "Y" THEN "ABBREVIATED " ELSE "")
        (IF as4dict.p__Idxfd._Unsorted = "Y" THEN "UNSORTED " ELSE "") SKIP.
     
      END.  /* FOR EACH Idx FD  */
    PUT STREAM ddl UNFORMATTED SKIP(1).
  END.  /* FOR EACH INDEX */

  IF TERMINAL <> "" AND NOT User_Env[29] BEGINS "incr" THEN
     DISPLAY "" @ as4dict.p__Index._Index-name with frame working.
END.  /* FOR EACH TABLE */

RETURN.



