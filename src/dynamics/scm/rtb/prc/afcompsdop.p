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
/* myh_compsdo.p

   Compile the "*_cl.w" componenet to a SDO autmatically in RTB when 
   compiling the SDO.  Workspace, module, and object compile parameters
   are used and the r-code is moved to the proper directory.

   Author: Gerry Winning
*/

{af/sup/afproducts.i}

DEFINE INPUT  PARAMETER Pcontext  AS CHAR    NO-UNDO.

DEFINE VARIABLE Mparts          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE Mobj-prog       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE Mcomp-params    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE MobjECT-params  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE Mrcode-file     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE Mrcode-file-tmp AS CHARACTER    NO-UNDO.
DEFINE VARIABLE Merror          AS CHARACTER    NO-UNDO.

DEFINE BUFFER BMYHrtb_object    FOR rtb.rtb_object.
DEFINE BUFFER BMYHrtb_ver       FOR rtb.rtb_ver.

{rtb/g/rtbglobl.i}

FIND BMYHrtb_object WHERE RECID(BMYHrtb_object) = INTEGER(Pcontext)
    NO-LOCK NO-ERROR.
FIND BMYHrtb_ver OF BMYHrtb_object NO-LOCK NO-ERROR.

RUN GET_filenames.

IF Mobj-prog <> "" THEN DO:
    RUN GET_compile_params.
    RUN rtb/p/rtb0050.p Mobj-prog Mcomp-params. 
END.

/* Now we follow the RTB standard of moving the r-code if needed */

/* Current r-code file name (it is next to the source file since the ompile
   statment used the "SAVE" option) ---*/
ASSIGN  Mrcode-file-tmp =  ENTRY(1, grtb-wspath) /* root workspace path */
                        + "/"
                        +  REPLACE(Mobj-prog, /* relative path and source */
                                   SUBSTRING(Mobj-prog,
                                             R-INDEX(Mobj-prog, ".":U) + 1), 
                                   "r"). /* change the extention to .r */

/* we have the master object's r-code directory in "Mrcode-file,
   so we can replace the object name with the part object name --- */
ASSIGN Mrcode-file = REPLACE(Mrcode-file,
                             SUBSTRING(Mrcode-file,
                                       R-INDEX(Mrcode-file, "/":U) + 1),
                             SUBSTRING(Mobj-prog,
                                        R-INDEX(mobj-prog, "/":U) + 1)).

/* we have the original object extension and need to replace it with ".r" */
ASSIGN Mrcode-file = ENTRY(1, grtb-wspath) 
                   + "/" 
                   +  REPLACE(Mrcode-file, 
                              SUBSTRING(Mrcode-file,
                                        R-INDEX(Mrcode-file, ".":U) + 1), 
                              "r").

IF mrcode-file <> Mrcode-file-tmp THEN DO:
  {rtb/x/rtb_move.i 
   Mrcode-file-tmp
   Mrcode-file
   "An error occurred during the Copy of r-code." Merror}
END.

/* internal procedures --- */

PROCEDURE get_filenames:

  DEFINE VARIABLE Mparts        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE Mpid          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE Mworking-path AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE Mfile-name    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE mloop         AS INTEGER      NO-UNDO.

  /* --- Get object filename --- */
  RUN rtb/p/rtb_nams.p
     (INPUT Pcontext,
      INPUT "",
      OUTPUT Mparts,
      OUTPUT Merror).

  IF Merror <> "" THEN RETURN.

  ASSIGN Mobj-prog = "".

  /* time to find the other "part" to compile */
  cl-loop:
  DO Mloop = 2 TO NUM-ENTRIES(Mparts):
      ASSIGN Mfile-name = ENTRY(Mloop, Mparts).
      IF SUBSTRING(Mfile-name,R-INDEX(Mfile-name, ".":U) + 1) 
        BEGINS "w" THEN DO:
          ASSIGN Mobj-prog = Mfile-name.
          LEAVE cl-loop.
      END. /* if substring */
      ELSE
          NEXT cl-loop.
   END. /* do mcount = 2 ... */

  RUN rtb/p/rtb_rnam.p /* Get .r file name for the main object */
          (BMYHrtb_object.obj-type,
           BMYHrtb_object.object,
           Mworking-path,
           OUTPUT Mrcode-file).

  RUN rtb/p/rtb_mkpt.p /* OS make directories  */
          (Mrcode-file,
           OUTPUT Merror).

END PROCEDURE. /* get_filenames */

PROCEDURE get_compile_params:

  Mcomp-params =" SAVE".

  /* Add object, workspace module and workspace compile paramters
  ** to the compile parameters.
  */
  RUN rtb/p/rtb0008.p (INPUT  RECID(BMYHrtb_ver),
                       INPUT  ?,      /* no site recid for object params */
                       INPUT  Mcomp-params,
                       INPUT  NO,  /* external compile position */
                       OUTPUT Mobject-params,
                       OUTPUT Merror).
  IF Merror <> "" THEN
    RETURN.
  ELSE
    Mcomp-params = Mcomp-params
                   + (IF LENGTH(Mcomp-params) = 0 THEN " " ELSE "")
                   + Mobject-params.

END PROCEDURE. /* get_compile_params */
