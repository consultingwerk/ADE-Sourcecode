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

/*****************************************************************************

File: _compile.p
Description:
   This is the program that actually loops through all of the files to
   compile and calls a program to compile them.  Most of the parameters
   for the compile have already been incorporated into the temporary
   compile program (passed in as s_procname).

Author: Warren Bare

Date Created: 03/24/92 
 Last change:  WLB  20 Jul 93   10:15 am
*****************************************************************************/
&GLOBAL-DEFINE WIN95-BTN YES
/* ADE Internationalization Standards Include. */
{ adecomm/adeintl.i }
{ adecomm/adestds.i }

/* Application Compiler Shared Vars, etc.. */
{ adecomp/compvars.i }

define var v_LookFor     as char no-undo.  /* this is s_fspec */
define var v_curfile     as char no-undo.  /* current file to compile */
define var v_fullpath    as char no-undo.  /* current dir to compile in */
define var v_relpath     as char no-undo.  /* path (if any) before fspec */
define var v_newfspec    as char no-undo.  /* path to recurse down to */
define var v_savefspec   as char no-undo.  /* original fspec */
define var v_justfile    as char no-undo.  /* just file name part of spec */
define var v_MatchSpec   as char no-undo.  /* JustFile used for MATCHES */
define var v_rname       as char no-undo.  /* .r name */
define var v_StopCompile as logi init false no-undo.  /* cancel compile */
define var v_SeekPos     as inte no-undo.  /* output seek pos before compile */
define var v_InAttr      as char no-undo.
define var dir_name      as char.          /* Used for SAVE INTO checking. */

define var t_int         as int no-undo.
define var t_char        as char no-undo.
define var t_log         as log no-undo.

DEFINE VAR v_rname_saved LIKE v_rname.     /* to save original .r file name before transition */
DEFINE VAR cFullPathName AS CHAR NO-UNDO.  /* to save .r file full path and standardize it to Unix type 
                                              replace "\" with "/" for correct comparison */

define stream in_Dir.

/********************** Triggers *********************/
On choose of b_CompileCancel in frame EditorDisplay
  ASSIGN
    s_CompCount = -1
    v_StopCompile = yes.

/******************* In Line Code ********************/

/* get relpath from fspec */
run adecomm/_osprefx.p (s_fspec, output v_relpath, output v_justfile).
/* Escape . in spec so MATCHES will not match it to one char */
v_MatchSpec = REPLACE(v_JustFile,".","~~.").

/* put relpath on dir */
run adecomm/_osfmush.p (s_propathdir, v_relpath, output v_fullpath).

INPUT STREAM in_Dir FROM OS-DIR(v_fullpath).

if s_logfile > "" then
  OUTPUT TO VALUE(s_logfile) APPEND KEEP-MESSAGES {&NO-MAP}.

/* Because of UNIX editor widget problem, must insert EOL here. */
if opsys = "UNIX":u then
  assign t_log = v_EditorOut:INSERT-STRING(CHR(10)) in frame EditorDisplay.

/* Create the intro compile message */
t_char = string(time,"HH:MM:SS") + " Looking for " + s_fspec +
  (if s_propathdir > "" then " in " + s_Propathdir ELSE "") + chr(10).
put unformatted t_char.

assign t_log = v_EditorOut:INSERT-STRING(t_char) in frame EditorDisplay.

/*
** loop through all the files matching this spec and add them to the
** compile program if they are supposed to be compiled.
*/
REPEAT:
  import STREAM in_Dir
    v_CurFile ^ v_InAttr.

  PROCESS EVENTS.
  if v_StopCompile THEN LEAVE.

  IF INDEX(v_InAttr,"F") = 0 OR NOT v_CurFile MATCHES v_MatchSpec 
  THEN NEXT.

  /* put the relative path back on the current file name */
  run adecomm/_osfmush.p (v_relpath, v_Curfile, output v_Curfile).

  /*
  *  if we have to remove .r, or only compile with no .r, then
  *  check to see if one is out there.
  */
  IF s_rmoldr OR s_ifnor THEN
  DO:
    /* set .r name by replacing existing extention if there is one */
    IF R-INDEX(v_curfile, ".") > 0 THEN
    v_rname = substr(v_curfile,1, R-INDEX(v_curfile, ".") - 1) + ".r".
    ELSE
    v_rname = v_curfile + ".r".

    /* Append the filename to the save into dir (if specified) and search it. */
    IF ( s_saveinto <> "" ) THEN
    DO:
        /* Extract the basename of the r-code file. This trims off any paths
           specified for the source file so we can cleanly search for the
           .r file in the SAVE INTO directory.
        */
        ASSIGN v_rname_saved = v_rname.
        RUN adecomm/_osprefx.p (INPUT v_rname, OUTPUT dir_name, OUTPUT v_rname).
        
        ASSIGN FILE-INFO:FILE-NAME = v_rname_saved
               cFullPathName       = FILE-INFO:FULL-PATHNAME.
        
        /* Change backslash to forward slash for UNIX compatibility. */
        ASSIGN v_rname_saved = REPLACE(v_rname_saved, "~\":U, "/":U).
        ASSIGN cFullPathName = REPLACE(cFullPathName, "~\":U, "/":U).
        
        IF v_rname_saved = cFullPathName THEN
          RUN adecomm/_osfmush.p (INPUT s_saveinto, INPUT v_rname, OUTPUT v_rname).
        ELSE
          RUN adecomm/_osfmush.p (INPUT s_saveinto, INPUT v_rname_saved, OUTPUT v_rname).
    END.
    /* If no save into, remove .r only from where the new .r file will be saved. */
    ELSE
    DO:
        /* Extract the basename of the r-code file. Use it to determine the
           full-pathname of the .r file to remove. This way we only delete
           .r files from where the new .r file will be saved. 96-08-12-030 */
        RUN adecomm/_osprefx.p (INPUT v_rname, OUTPUT dir_name, OUTPUT v_rname).
	IF ( OPSYS = "VMS" ) THEN
	    IF dir_name = "" THEN dir_name = "[]".
	ELSE
        IF dir_name = "" THEN dir_name = ".".
        ASSIGN FILE-INFO:FILE-NAME = dir_name.
        IF FILE-INFO:FULL-PATHNAME <> ? THEN
            ASSIGN dir_name = FILE-INFO:FULL-PATHNAME.
        RUN adecomm/_osfmush.p (INPUT dir_name, INPUT v_rname, OUTPUT v_rname).
    END.
    
    ASSIGN v_RName = SEARCH(v_RName).

    IF s_ifnor AND v_RName <> ? THEN NEXT.

    /* Is there a .r out there that we want to remove? */
    IF s_rmoldr AND v_RName <> ? THEN OS-DELETE VALUE( v_rname ) .
  END.

  s_CompCount = s_CompCount + 1.
  put unformatted "Compiling "  v_curfile skip.
  t_log = v_EditorOut:INSERT-STRING("Compiling " + v_curfile +
                                    chr(10))in frame EditorDisplay.
  
  /* save the output pos in case we need to come back and read the msgs */
  v_SeekPos = SEEK(OUTPUT).

  /* do the compile */
  IF s_encrkey > "" THEN
     RUN CompEncrypt.
  ELSE
     RUN CompNoEncrypt.

  /* If there are no compiler error messages and warnings, don't
     bother displaying the messages. */
  IF (NOT COMPILER:ERROR AND NOT COMPILER:WARNING) THEN NEXT.
  
  /* If user did not specify a log file, then don't read messages either. */
  IF s_logfile = "" OR s_logfile = ? THEN NEXT.
  
  OUTPUT CLOSE.
  INPUT FROM VALUE (s_logfile) NO-ECHO {&NO-MAP}.
  SEEK INPUT TO v_SeekPos.
  REPEAT:
    t_char = "".
    IMPORT UNFORMATTED t_char.
    t_log = v_EditorOut:INSERT-STRING(t_char + chr(10))
      in frame EditorDisplay.
  END.
  INPUT CLOSE.
  if (s_logfile > "") then
    OUTPUT TO VALUE(s_logfile) APPEND KEEP-MESSAGES {&NO-MAP}.

END.  /* end of each file loop */

INPUT STREAM in_Dir CLOSE.
OUTPUT CLOSE.

/* Should we recurse down into subdirectories of a directory?
   Note: Regardless of the "Look in Sub" settings, we search sub-dirs
   only if the File Spec is for a directory.  Never for a file. */

ASSIGN FILE-INFO:FILENAME = v_fullpath.
IF ( s_subdirs = NO ) OR 
   ( INDEX( FILE-INFO:FILE-TYPE , "D" ) = 0 ) OR
   ( FILE-INFO:FULL-PATHNAME = ?)
THEN RETURN.

/* The fspec gets trashed in the recursion, so save it. */
v_savefspec = s_fspec.
INPUT STREAM in_Dir FROM OS-DIR(v_fullpath).

REPEAT:
  import STREAM in_Dir v_CurFile ^ v_InAttr.
  PROCESS EVENTS.
  if v_StopCompile THEN LEAVE.
      
  IF INDEX(v_InAttr,"D") = 0 OR v_CurFile = "." OR v_CurFile = ".." THEN NEXT.

  /* If VMS, handle *.DIR case. */
  IF ( OPSYS = "VMS":U ) AND v_Curfile matches "*.DIR" THEN
	v_Curfile = "[." + substr(v_Curfile,1,length(v_Curfile) - 4) + "]".

  /* put the relative path back on the current file name */
  run adecomm/_osfmush.p (v_relpath, v_Curfile, output v_Curfile).

  /* add fspec to new dir */
  run adecomm/_osfmush.p (v_CurFile, v_justfile, output v_newfspec).

  /* recurse for compile in this new dir */
  s_fspec = v_newfspec.
  run adecomp/_compile.p.
  IF s_CompCount = -1 THEN LEAVE.
END. /* end of repeat */

INPUT STREAM in_Dir CLOSE.
s_fspec = v_savefspec.


PROCEDURE CompEncrypt.
    CASE s_v6frame :
        WHEN "No" OR WHEN "Box" THEN
            COMPILE VALUE(v_curfile)
                XCODE s_encrkey
                SAVE = s_saver INTO VALUE(s_saveinto)
                LANGUAGES (VALUE(s_languages))
                V6FRAME   = (s_v6frame <> "NO")
                MIN-SIZE  = s_minsize
                STREAM-IO = s_stream_io
                &IF {&CompileOn91C} &THEN
                GENERATE-MD5 = s_gen_md5
                &ENDIF
                .
        WHEN "Reverse Video" THEN
            COMPILE VALUE(v_curfile)
                XCODE s_encrkey
                SAVE = s_saver INTO VALUE(s_saveinto)
                LANGUAGES (VALUE(s_languages))
                V6FRAME USE-REVVIDEO
                MIN-SIZE  = s_minsize
                STREAM-IO = s_stream_io
                &IF {&CompileOn91C} &THEN
                GENERATE-MD5 = s_gen_md5
                &ENDIF
                .
        WHEN "Underline" THEN
            COMPILE VALUE(v_curfile)
                XCODE s_encrkey
                SAVE = s_saver INTO VALUE(s_saveinto)
                LANGUAGES (VALUE(s_languages))
                V6FRAME USE-UNDERLINE
                MIN-SIZE  = s_minsize
                STREAM-IO = s_stream_io
                &IF {&CompileOn91C} &THEN
                GENERATE-MD5 = s_gen_md5
                &ENDIF
                .
        OTHERWISE /* Invalid value, use same compile as "No"/"Box". */
            COMPILE VALUE(v_curfile)
                XCODE s_encrkey
                SAVE = s_saver INTO VALUE(s_saveinto)
                LANGUAGES (VALUE(s_languages))
                V6FRAME   = (s_v6frame <> "NO")
                MIN-SIZE  = s_minsize
                STREAM-IO = s_stream_io
                &IF {&CompileOn91C} &THEN
                GENERATE-MD5 = s_gen_md5
                &ENDIF
                .
    END CASE.
END PROCEDURE.

PROCEDURE CompNoEncrypt.
    CASE s_v6frame :
        WHEN "No" OR WHEN "Box" THEN
            COMPILE VALUE(v_curfile)
                SAVE = s_saver INTO VALUE(s_saveinto)
                LISTING VALUE(s_listing)
                   APPEND PAGE-SIZE s_lplen PAGE-WIDTH s_lpwid
                XREF VALUE(s_xref) APPEND 
                LANGUAGES (VALUE(s_languages))
                DEBUG-LIST VALUE(s_debuglist)
                V6FRAME   = (s_v6frame <> "NO")
                MIN-SIZE  = s_minsize
                STREAM-IO = s_stream_io
                &IF {&CompileOn91C} &THEN
                GENERATE-MD5 = s_gen_md5
                &ENDIF
                .
        WHEN "Reverse Video" THEN
            COMPILE VALUE(v_curfile)
                SAVE = s_saver INTO VALUE(s_saveinto)
                LISTING VALUE(s_listing)
                   APPEND PAGE-SIZE s_lplen PAGE-WIDTH s_lpwid
                XREF VALUE(s_xref) APPEND 
                LANGUAGES (VALUE(s_languages))
                DEBUG-LIST VALUE(s_debuglist)
                V6FRAME USE-REVVIDEO
                MIN-SIZE  = s_minsize
                STREAM-IO = s_stream_io
                &IF {&CompileOn91C} &THEN
                GENERATE-MD5 = s_gen_md5
                &ENDIF
                .
        WHEN "Underline" THEN
            COMPILE VALUE(v_curfile)
                SAVE = s_saver INTO VALUE(s_saveinto)
                LISTING VALUE(s_listing)
                   APPEND PAGE-SIZE s_lplen PAGE-WIDTH s_lpwid
                XREF VALUE(s_xref) APPEND 
                LANGUAGES (VALUE(s_languages))
                DEBUG-LIST VALUE(s_debuglist)
                V6FRAME USE-UNDERLINE
                MIN-SIZE  = s_minsize
                STREAM-IO = s_stream_io
                &IF {&CompileOn91C} &THEN
                GENERATE-MD5 = s_gen_md5
                &ENDIF
                .
        OTHERWISE /* Invalid value, use same compile as "No"/"Box". */
            COMPILE VALUE(v_curfile)
                SAVE = s_saver INTO VALUE(s_saveinto)
                LISTING VALUE(s_listing)
                   APPEND PAGE-SIZE s_lplen PAGE-WIDTH s_lpwid
                XREF VALUE(s_xref) APPEND
                LANGUAGES (VALUE(s_languages))
                DEBUG-LIST VALUE(s_debuglist)
                V6FRAME   = (s_v6frame <> "NO")
                MIN-SIZE  = s_minsize
                STREAM-IO = s_stream_io
                &IF {&CompileOn91C} &THEN
                GENERATE-MD5 = s_gen_md5
                &ENDIF
                .
    END CASE.
END PROCEDURE.

