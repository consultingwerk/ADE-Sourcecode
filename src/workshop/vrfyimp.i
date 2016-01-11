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
/* Check if the file is not a Workshop file.                                      */

/* I've modified the behavior of the following code block because it was
 * possible to open an xcoded file in Workshop. The block will not allow the
 * Opening or Importing of a file which is xcoded (First char ASC 17) - (gfs)
 */
IF AbortImport NE yes THEN
DO:
  INPUT STREAM _P_QS FROM VALUE(dot_w_file) {&NO-MAP}.
  READ-VERSION-LINE:
  DO ON ENDKEY UNDO READ-VERSION-LINE, LEAVE READ-VERSION-LINE:
    IMPORT STREAM _P_QS _inp_line NO-ERROR.
  END.
  INPUT STREAM _P_QS CLOSE.
  
  /* Check Workshop/UIB generated files for appropriate version numbers.  The first line should
     be of the form (with Template optional):
        &ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Web-Object [Template]
     or, for v1 files
        &ANALYZE-SUSPEND _VERSION-NUMBER WDT_v1r1 GUI
   */
  IF _inp_line[1] eq "&ANALYZE-SUSPEND":U THEN DO:
    /* This is a structured file. */
    IF LOOKUP("Structured", _P._type-list) eq 0 THEN DO:
      _P._type-list = "Structured" + (IF _P._type-list eq "":U THEN "":U ELSE "," + _P._type-list).
    END.
    IF _inp_line[2] eq "_VERSION-NUMBER" THEN DO:
      /* In all cases check for version compatability (note, check the modified
         _inp_line[3] and not the original file_version.) */
      orig-version-no = _inp_line[3].
      IF orig-version-no NE _VERSION-NO THEN DO:   
        AbortImport = TRUE.
        CASE ENTRY(1, orig-version-no, "r":U):
          WHEN "WDT_v1":U THEN DO:
            /* We can load all V1 revisions */
            AbortImport = FALSE.
          END. 
          WHEN "WDT_v2":U THEN DO:   
            /* Check the revision number. Load any revision number that is
               smaller.  */
            IF INTEGER(ENTRY(2, orig-version-no, "r":U)) <=
               INTEGER(ENTRY(2, _VERSION-NO, "r":U)) THEN AbortImport = FALSE.

            /* Procedure type, and template info, will be stored here. 
               eg. &ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Include Template */
            IF _inp_line[4] ne "":U THEN 
              _P._type = _inp_line[4].  
            IF _inp_line[5] eq "TEMPLATE":U AND p_mode eq "OPEN":U THEN
              _P._template = yes.
          END.  
          OTHERWISE DO:             
            AbortImport = FALSE. /* Load everything else. */
          END.
        END CASE.             
      END. /* Version Mismatch */
    END. /* IF _inp_line[2] eq "_VERSION-NUMBER...*/   
    /* Add error if incompatible versions. */
    IF AbortImport THEN DO:
      RUN Add_Error ("ERROR":U, ?,
          SUBSTITUTE 
          ('Incompatible version number &1 in structured file.', orig-version-no)).
    END.
  END. /* IF...&ANAYLYZE-SUSPEND (UIB or WebSpeed generated file) */
END.

