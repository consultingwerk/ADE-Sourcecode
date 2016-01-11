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
/*--------------------------------------------------------------------------------
  find_p.i -- standard FIND of the _P record to be used by workshop. The values
  of Fields: file-id, filename, and directory are retrieved and copied into 
  char variables having the same preprocessor name as the field. A _p record
  is either found or created for this file. 

  No error is given if the file cannot be found. The user should check in the
  calling program for the existance of an _P when this is dpme/
  --------------------------------------------------------------------------------*/

/* Do we have a context id yet, or is it a particular file. */
RUN GetField  IN web-utilities-hdl ("file-id", OUTPUT {&file-id} ).
IF {&file-id} ne "":U THEN
  FIND _P WHERE RECID (_P) eq INTEGER({&file-id}) NO-ERROR.
  
/* If the current object does not exist, then see if we have the whole path. */
IF NOT AVAILABLE (_P) THEN DO:
  /* Get the name of the directory and filename we are interested in. */
  RUN GetField  IN web-utilities-hdl ("filename",  OUTPUT {&filename}).
  IF {&filename} ne "":U THEN DO:
    /* Get the full pathname and extention. Use Progress portable (unix) slashes. */
    RUN GetField  IN web-utilities-hdl ("directory", OUTPUT {&directory}).
    IF {&directory} ne "":U THEN DO:
      {&directory} = REPLACE({&directory}, '~\':U, '~/':U).
      /* Append a directory delimiter, if necessary. */
      IF SUBSTRING({&directory}, LENGTH({&directory}, "CHARACTER":U), 1, 
                   "CHARACTER":U) ne '~/':U
      THEN {&directory} = {&directory} + '~/':U.
    END.
    FILE-INFO:FILE-NAME = {&directory} + {&filename}.
    
    IF FILE-INFO:FULL-PATHNAME ne ? THEN DO:
      /* Does a _P exist for this file. */
      FIND _P WHERE _P._fullpath eq FILE-INFO:FULL-PATHNAME NO-ERROR.
      IF NOT AVAILABLE (_P) THEN DO:
        /* Create a _P (procedure file record). */ 
        CREATE _P.
        _P._fullpath = FILE-INFO:FULL-PATHNAME.
        /* Set filename to the relative path. */
        RUN webutil/_relname.p (_P._fullpath, "":U, OUTPUT _P._filename).
        /* Figure out the type of this file. */
        RUN webtools/util/_filetyp.p (_P._fullpath, OUTPUT _P._type, OUTPUT _P._type-list).
        IF LOOKUP("Template":U, _P._type-list) > 0 THEN _P._template = yes.
        /* Also store the file extension. */
        RUN adecomm/_osfext.p (_P._fullpath, OUTPUT _P._fileext).
        IF _P._fileext BEGINS ".":U THEN SUBSTRING(_P._fileext, 1, 1, "CHARACTER") = "".
      END. /* IF AVAILABLE _P... */
    END.
  END.  /* IF filename ne ""... */
END. /* IF AVAILABLE (_P)... */

 

