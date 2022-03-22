/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
**********************************************************************

  File: conve4gl.p

  Description: Convert Embedded SpeedScript files to Progress .w procedures

  Input Parameters:       <none>

  Output Parameters:      <none>

  Author:  D.M.Adams
  Updated: 03/01/97 Initial version
           10/06/00 Updated for POSSE
           11/01/00 Updated to create .w's in $POSSE/e4gl for POSSE. (jep)
           11/10/00 Split out samples directory
           09/05/01 Improve the checking for PSC's RDLADE environment. (jep)
           09/27/01 Make e4gl targdir be posseDir for RDLADE and POSSE (jep)
           07/09/02 Added support for Dynamics icf/ry/dhtml files (adams)
----------------------------------------------------------------------------*/

{src/web/method/cgidefs.i NEW}

DEFINE VARIABLE adeDir    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE adeEnv    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE diritem   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dirlist   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE e4glfile  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE fileext   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE htmlfile  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ix        AS INTEGER    NO-UNDO.
DEFINE VARIABLE iy        AS INTEGER    NO-UNDO.
DEFINE VARIABLE nextdir   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE newdir    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE options   AS CHARACTER  NO-UNDO.            
DEFINE VARIABLE posseDir  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE sampleDir AS CHARACTER  NO-UNDO.
DEFINE VARIABLE srcDir    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE subdir    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE targdir   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE webfile   AS CHARACTER  NO-UNDO.
 
/* Define list of directories to process. This is different depending on whether
   processing is for PSC's RDLADE environment or for the POSSE environment. */
ASSIGN
  adeDir    = OS-GETENV("RDLADE":U)
  posseDir  = OS-GETENV("POSSE":U).

/*  Determine if in PSC's RDLADE environment. Both RDLADE and POSSE may be set 
    in such an environment, but RDLADE being set specifies that processing is 
    for RDLADE and not for POSSE. */
ASSIGN
  adeEnv = (adeDir <> ?).

/* Embedded 4GL file processing takes place in $POSSE/e4gl for POSSE and
   $DLC/e4gl for PSC builds. This ensures e4gl processing does not alter
   commercially installed product directories. (jep) */
IF adeEnv THEN
  ASSIGN
    dirlist   = "dynamics/ry/dhtml,webedit,webtools,webutil,workshop,samples/web,samples/web/intranet,samples/web/internet,samples/web/extranet":U
    sampleDir = OS-GETENV("RDLSRC":U) + "/pscade":U
    srcDir    = adeDir
    targdir   = posseDir + "/e4gl":U.
ELSE
  ASSIGN
    dirlist   = "dynamics/ry/dhtml,webedit,webtools,webutil,workshop":U
    srcDir    = posseDir + "/src":U
    targdir   = posseDir + "/e4gl":U.
    
OS-CREATE-DIR VALUE(targdir).

DO ix = 1 TO NUM-ENTRIES(dirlist):
  ASSIGN
    diritem = ENTRY(ix,dirlist)
    nextdir = (IF adeEnv AND dirItem BEGINS "samples":U
               THEN sampleDir ELSE srcDir) + "/":U + diritem.
  
  /* Make sure directory is valid, otherwise INPUT FROM OS-DIR raises error. */
  FILE-INFO:FILE-NAME = nextdir.
  IF FILE-INFO:FULL-PATHNAME = ? THEN NEXT.
  
  INPUT FROM OS-DIR(nextdir).
  REPEAT:
    IMPORT e4glfile.
    fileext = TRIM(ENTRY(NUM-ENTRIES (e4glfile, ".":U), e4glfile, ".":U)).
    
    /* The convention is that .html files are assumed to contain ESS, while 
       .htm files are assumed to be static and do not require compiling. */
    IF fileext = "html":U THEN DO:
      /* Create the target subdirectory tree. */
      newdir = "".
      DO iy = 1 TO NUM-ENTRIES(diritem,"/":U):
        ASSIGN
          newdir = newdir + (IF newdir NE "" THEN "/":U ELSE "")
                   + ENTRY(iy,diritem,"/":U)
          subdir = targdir + "/":U + newdir.
        OS-CREATE-DIR VALUE(subdir).
      END.
      
      ASSIGN
        htmlfile = nextdir + "/":U + e4glfile
        options  = ""
        webfile  = targdir + "/":U + diritem + "/":U +
                   SUBSTRING(e4glfile,1,INDEX(e4glfile,".htm":U) - 1) + ".w":U.
        
      RUN VALUE(srcDir + "/webutil/e4gl-gen.p":U)
        (htmlfile, INPUT-OUTPUT options, INPUT-OUTPUT webfile) NO-ERROR.
    END.
  END.
END.

/* conve4gl.p - end of file */
