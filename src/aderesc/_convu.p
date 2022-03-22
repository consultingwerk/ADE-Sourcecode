/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 *  _convu.p
 *
 *    Converts the users of a particular RESULTS application. This
 *    involves finding all the user's queries and converting each one.
 */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i NEW }
{ aderes/s-define.i NEW }
{ aderes/a-define.i NEW }
{ aderes/e-define.i NEW }
{ aderes/l-define.i NEW }
{ aderes/r-define.i NEW }
{ aderes/i-define.i NEW }
{ aderes/j-define.i NEW }
{ aderes/y-define.i NEW }
{ aderes/s-output.i NEW }
{ aderes/t-define.i NEW }
{ aderes/s-menu.i NEW }
{ aderes/fbdefine.i NEW }
{ adeshar/_mnudefs.i NEW }
{ aderes/_fdefs.i }
{ adecomm/adestds.i }
{ aderes/_alayout.i }
{ aderes/reshlp.i }

&SCOPED-DEFINE FRAME-NAME convu

DEFINE SHARED VARIABLE initDb AS LOGICAL NO-UNDO.

DEFINE VARIABLE choice    AS CHARACTER NO-UNDO.  
DEFINE VARIABLE oldDir    AS CHARACTER NO-UNDO. /* old QD file directory */
DEFINE VARIABLE oldName   AS CHARACTER NO-UNDO. /* old QD filename */
DEFINE VARIABLE oldQD     AS CHARACTER NO-UNDO. /* old QD full path */
DEFINE VARIABLE qbf-c     AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-d     AS CHARACTER NO-UNDO. /* query directory list */
DEFINE VARIABLE qbf-i     AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j     AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-o     AS CHARACTER NO-UNDO. /* output directory list */
DEFINE VARIABLE qbf-s     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE newDir    AS CHARACTER NO-UNDO. /* new QD file directory */
DEFINE VARIABLE newName   AS CHARACTER NO-UNDO. /* new QD filename */
DEFINE VARIABLE newQD     AS CHARACTER NO-UNDO. /* new QD full path */
DEFINE VARIABLE oldpath   AS CHARACTER NO-UNDO.
DEFINE VARIABLE writeWhat AS CHARACTER NO-UNDO.

DEFINE BUTTON qbf-ad   LABEL "&Add"    SIZE 12 BY 1.
DEFINE BUTTON qbf-rm   LABEL "&Remove" SIZE 12 BY 1.

DEFINE            STREAM oldQd.
DEFINE NEW SHARED STREAM userLog.

{ aderes/_asbar.i }

DEFINE BUTTON fileBut LABEL "F&ile..."
  SIZE {&ADM_W_BUTTON} BY {&ADM_H_BUTTON}.

FORM
  SKIP({&TFM_WID})

  oldQD COLON 22 FORMAT "X(128)":u LABEL "&Query Directory File"
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&ADM_H_BUTTON}

  fileBut
  SKIP({&VM_WID})
    
  newDir COLON 22 FORMAT "X(128)":u LABEL "&Output Directory"
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&ADM_H_BUTTON}
  SKIP(.5)
    
  "Query &Directory Files To Convert:" AT 2 VIEW-AS TEXT
  SKIP({&VM_WID})
  
  qbf-d AT 2 NO-LABEL
    VIEW-AS SELECTION-LIST MULTIPLE INNER-CHARS 45 INNER-LINES 6
    SCROLLBAR-V SCROLLBAR-H FONT 0

  qbf-ad AT ROW-OF qbf-d COLUMN-OF qbf-d
  
  qbf-rm AT ROW-OF qbf-d + 1 COLUMN-OF qbf-ad
  SKIP(2.5)

  {adecomm/okform.i 
    &BOX    = rect_btns
    &STATUS = NO
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  WITH FRAME {&FRAME-NAME}
  VIEW-AS DIALOG-BOX SIDE-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  TITLE "Convert Query Directory".
  
/*--------------------------- Trigger Block ----------------------------*/

ON CHOOSE OF fileBut IN FRAME {&FRAME-NAME} DO:
  RUN adecomm/_getfile.p (?,"TTYRESULTSQD":u,"","Query Directory File":u,
                         "OPEN":u,INPUT-OUTPUT qbf-c,OUTPUT qbf-s).

  IF qbf-c > "" THEN
    oldQD:SCREEN-VALUE = qbf-c.
END.

ON ALT-D OF FRAME {&FRAME-NAME}
  APPLY "ENTRY":u TO qbf-d IN FRAME {&FRAME-NAME}.
  
ON CHOOSE OF qbf-ad IN FRAME {&FRAME-NAME} DO:
  ASSIGN
    oldQD  = oldQD:SCREEN-VALUE 
    newDir = newDir:SCREEN-VALUE
    .
    
  /* Does user query directory file exist? File may not have extension. */
  IF SUBSTRING(oldQD,LENGTH(oldQD,"CHARACTER":u) - 2,-1,
               "CHARACTER":u) <> ".qd":u THEN
    oldQD = oldQD + ".qd":u.

  IF SEARCH(oldQD) = ? THEN DO:
    MESSAGE "The query directory file" oldQD SKIP "could not be found." SKIP
      VIEW-AS ALERT-BOX ERROR.

    RETURN NO-APPLY.
  END.
  ELSE
    oldQD = SEARCH(oldQD).

  RUN adecomm/_osprefx.p (oldQD,OUTPUT oldDir,OUTPUT oldName).

  /* check for valid output directory */
  IF newDir > "" THEN DO:
    OS-CREATE-DIR VALUE(newDir).
  
    IF OS-ERROR > 0 THEN DO:
      RUN adecomm/_oserr.p (OUTPUT qbf-c).
      MESSAGE "SYSTEM ERROR #" + STRING(OS-ERROR) + ":":u SKIP
        qbf-c + ".":u SKIP
        "Output directory is invalid."
        VIEW-AS ALERT-BOX ERROR.            
      RETURN NO-APPLY.
    END.

    IF NOT CAN-DO("~\~/":u,
      SUBSTRING(newDir,LENGTH(newDir,"CHARACTER":u),1,"CHARACTER":u)) THEN
      newDir = newDir 
             + (IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u THEN "~\":u ELSE "~/":u).
  END.
  ELSE
    newDir = oldDir.

  /* Does query directory already exist in the list? */
  qbf-i = qbf-d:LOOKUP(oldQD) IN FRAME {&FRAME-NAME}.
  
  IF qbf-i = 0 THEN DO:
  
    /* See if query directory file already exists */
    ASSIGN
      newName = oldName + "7":u
      qbf-c   = SEARCH(newDir + newName).
    IF qbf-c <> ? THEN DO:
      MESSAGE CAPS(qbf-c) SKIP 
        "This file already exists." SKIP(1)
        "Replace existing file?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        TITLE "Convert " + newName UPDATE qbf-s.

      IF NOT qbf-s THEN RETURN NO-APPLY.
    END.

    ASSIGN
      qbf-s              = qbf-d:ADD-LAST(oldQD) IN FRAME {&FRAME-NAME}
      qbf-d              = qbf-d:LIST-ITEMS IN FRAME {&FRAME-NAME}
      qbf-o              = qbf-o
                         + (IF NUM-ENTRIES(qbf-d) = 1 THEN "" ELSE ",":u)
                         + newDir
      qbf-d:SCREEN-VALUE = ""
      qbf-d:SCREEN-VALUE = ENTRY(NUM-ENTRIES(qbf-d),qbf-d) 
      .
  END.
END.
  
ON CHOOSE OF qbf-rm IN FRAME {&FRAME-NAME} DO:
  IF qbf-d:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ? THEN 
    RETURN NO-APPLY.
    
  qbf-c = qbf-d:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  DO qbf-i = 1 TO NUM-ENTRIES(qbf-c):
    ASSIGN
      choice             = ENTRY(qbf-i,qbf-c)
      qbf-j              = qbf-d:LOOKUP(choice) IN FRAME {&FRAME-NAME}
      qbf-s              = qbf-d:DELETE(choice) IN FRAME {&FRAME-NAME}
      
      /* reset output directory list */
      ENTRY(qbf-j,qbf-o) = ""
      qbf-o              = REPLACE(qbf-o,",,":u,",":u)
      qbf-o              = TRIM(qbf-o,",":u)
      .
  END.
  
  ASSIGN
    qbf-d              = qbf-d:LIST-ITEMS IN FRAME {&FRAME-NAME}
    qbf-d:SCREEN-VALUE = qbf-d
    .
END.
  
ON GO OF FRAME {&FRAME-NAME} DO:
  qbf-d = qbf-d:LIST-ITEMS IN FRAME {&FRAME-NAME}.

  RUN adecomm/_setcurs.p ("WAIT":u).

  DO qbf-i = 1 TO NUM-ENTRIES(qbf-d):
    ASSIGN
      choice = ENTRY(qbf-i,qbf-d)
      newDir = ENTRY(qbf-i,qbf-o)
      .
    
    RUN adecomm/_osprefx.p (choice,OUTPUT oldDir,OUTPUT newName).
    newName = newName + "7":u.

    RUN convUserQd (choice,oldDir,newDir,newName).
  END.

  RUN adecomm/_setcurs.p ("").
END.

/*----------------------------- Main Block ------------------------------*/
{ aderes/_arest.i 
  &FRAME-NAME = {&FRAME-NAME}
  &HELP-NO    = {&Convert_Query_Dir_Dlg_Box}
}

/* Runtime layout */
ASSIGN
  qbf-d:WIDTH = oldQD:COL + oldQD:WIDTH - qbf-d:COL
  qbf-ad:ROW  = qbf-d:ROW
  qbf-ad:COL  = qbf-d:COL + qbf-d:WIDTH + 1
  qbf-rm:ROW  = qbf-ad:ROW + 1 + {&VM_WID}
  qbf-rm:COL  = qbf-ad:COL
  .
  
/* Runtime layout for the Sullivan bar */
{adecomm/okrun.i 
  &FRAME = "FRAME {&FRAME-NAME}"
  &BOX   = rect_btns
  &OK    = qbf-ok
  &HELP  = qbf-help}

FRAME {&FRAME-NAME}:HIDDEN = TRUE.

/* Initialize the GUI RESULTS variables that are done at run time */
RUN aderes/_asetvar.p.

/* Initialize database structures, if they haven't been done already. */
IF qbf-rel-tbl# = 0 THEN DO:
  RUN aderes/j-init.p (?).
  initDb = TRUE.
END.

ENABLE oldQD fileBut newDir qbf-d qbf-ad qbf-rm qbf-ok qbf-ee qbf-help
  WITH FRAME {&FRAME-NAME}.

FRAME {&FRAME-NAME}:HIDDEN = FALSE.

DO TRANSACTION ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

/*----------------------------------------------------------------------*/
PROCEDURE convUserQd:
  DEFINE INPUT PARAMETER oldQD   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER oldDir  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER newDir  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER newName AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE logName   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE newFile   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE queNumber AS INTEGER   NO-UNDO.
  DEFINE VARIABLE token     AS CHARACTER NO-UNDO EXTENT 3.

  /* Open up the qd file, read it line by line. For each line, go to the
   * definition file and convert it.  If we are writing to another 
   * directory, replace the path of the new .qd7 file we are creating.
   */
  ASSIGN
    qbf-dir-ent# = 0
    qbf-dir-ent  = ""
    qbf-dir-dbs  = ""
    qbf-qdfile   = newDir + newName
    logName      = SUBSTRING(qbf-qdfile,1,R-INDEX(qbf-qdfile,".":u) - 1,
                             "CHARACTER":u) 
                 + ".qcl":u
                 
    /* reset PROPATH to QD directory */
    oldpath      = PROPATH
    PROPATH      = oldDir + ",":u + PROPATH
    .

  INPUT STREAM oldQd FROM VALUE(oldQD) NO-ECHO.
  OUTPUT STREAM userLog TO VALUE(logName) NO-ECHO.

  PUT STREAM userLog UNFORMATTED
    SKIP 'Convert: ' oldQD
    SKIP 'Date:    ' TODAY STRING(TIME,"HH:MM:SS AM":u) SKIP(2).

  REPEAT:
    token = "".

    IMPORT STREAM oldQd token.

    IF token[1] = "~/*":u OR token[1] = "*~/":u THEN NEXT.

    IF token[1] = "config=":u THEN DO:
      IF token[2] <> "directory":u THEN DO:
        INPUT STREAM oldQd CLOSE.
        PROPATH = oldpath.
        RETURN.
      END.
      NEXT.
    END.

    PUT STREAM userLog UNFORMATTED
      token[1] ' ':u token[2] ' ':u token[3].

    IF token[1] = "version=":u THEN
      PUT STREAM userLog UNFORMATTED
        SKIP '    was changed to version ' qbf-vers '.':u SKIP(1).

    ELSE DO:
      DEFINE VARIABLE numLoc   AS INTEGER NO-UNDO.
      DEFINE VARIABLE fileType AS CHARACTER NO-UNDO.
      DEFINE VARIABLE fileBody AS CHARACTER NO-UNDO.

      /* Something that has to be saved. Find a file name for it */
      ASSIGN
        qbf-dir-ent# = qbf-dir-ent# + 1
        qbf-c        = "junk":u
        .

      /* First we must find an open slot. */
      REPEAT WHILE qbf-c <> ?:
        ASSIGN
          queNumber = queNumber + 1
          newFile   = newDir + "que":u + STRING(queNumber,"99999":u) + ".p":u
          qbf-c     = SEARCH(newFile)
         .
      END.
      
      /* Start with a clean slate */
      RUN aderes/s-zap.p (TRUE).

      IF token[1] BEGINS "export":u THEN
        ASSIGN
          numLoc   = 7
          fileBody = "exp":u
          fileType = "e":u
          .
      ELSE IF token[1] BEGINS "report":u THEN
        ASSIGN
          numLoc   = 7
          fileBody = "rep":u
          fileType = "r":u
          .
      ELSE IF token[1] BEGINS "label":u THEN
        ASSIGN
          numLoc   = 6
          fileBody = "lbl":u
          fileType = "l":u
          .

      qbf-c = SUBSTRING(token[1],numLoc,INDEX(token[1],"=":u) - numLoc,
                        "CHARACTER":u).

      /* convert query file */
      RUN aderesc/_read.p (oldDir + fileBody 
                         + STRING(INTEGER(qbf-c),"99999":u) + ".p":u,fileBody, 
                           OUTPUT writeWhat).

      ASSIGN
        qbf-module                = fileType
        qbf-dir-ent[qbf-dir-ent#] = token[2]
        qbf-dir-dbs[qbf-dir-ent#] = token[3]
        qbf-dir-num[qbf-dir-ent#] = queNumber
        .
  
      IF writeWhat = ".p":u THEN DO:
        PUT STREAM userLog UNFORMATTED
          SKIP '    was converted and added to ' qbf-qdfile
          SKIP '    query directory as ' newFile '.':u SKIP(1).

        /*RUN aderes/s-level.p.  Why is this needed? -dma */
        RUN aderes/s-write.p (newFile,"s":u).
      END.
    END.
  END. /* REPEAT: */
  
  INPUT  STREAM oldQd   CLOSE.
  OUTPUT STREAM userLog CLOSE.

  /* write new QD7 file */
  RUN aderes/i-write.p (?).
  
  PROPATH = oldpath.
END PROCEDURE.

/* _convu.p - end of file */

