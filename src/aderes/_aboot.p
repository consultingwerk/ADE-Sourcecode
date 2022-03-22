/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _aboot.p - build initialization
 */

{ aderes/s-system.i }
{ aderes/a-define.i }
{ aderes/j-define.i }

DEFINE OUTPUT PARAMETER qbf-s AS LOGICAL NO-UNDO. 

DEFINE VARIABLE qbf-a       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE msg         AS CHARACTER NO-UNDO.
DEFINE VARIABLE dName       AS CHARACTER NO-UNDO.
DEFINE VARIABLE fName       AS CHARACTER NO-UNDO.
DEFINE VARIABLE old-threed  AS LOGICAL   NO-UNDO.

/* This will hide the logo!
HIDE ALL NO-PAUSE.
*/

ASSIGN old-threed = SESSION:THREE-D.
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
SESSION:THREE-D = TRUE.
&ENDIF
RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"question":u,"yes-no":u,
  SUBSTITUTE("The configuration file &1 was not found for the database &2.  Do you want to create the query configuration file?",
  qbf-qcfile + {&qcExt},DBNAME)).
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
SESSION:THREE-D = old-threed.
&ENDIF

IF NOT qbf-a THEN RETURN.

/* Make sure that watch cursor is on */
RUN adecomm/_setcurs.p ("WAIT":u).

/*
 * Display our corporate image in this case. RESULTS, at this time, is not
 * intended to be resold by APs to do "out of the box" work. If a AP ships
 * a fully deployed RESULTS app then that will include a configuration file.
 * Since building a configuration is "out of the box" then use our Corporate 
 * image.
 */

/*RUN aderes/u-logo.p. /* display product logo */*/
RUN aderes/j-find.p. /* find implied OF table relationships */
RUN aderes/s-boot.p. /* read in results.l, initialize other variables */

/*
 * Create the default for the basename of the fastload file. Its defaults to
 * the same name as the basename of the qc file. We just want to be sure
 * its unique enough to avoid most accidental confilicts of names if
 * VARS put multiple databases in the same directory. The qcfile name is
 * the logical dbname of the first attached database. qbf-dbs is a sorted
 * list of the databases attached, so don't use that as the basis for the
 * names of the other files.
 */

RUN adecomm/_osprefx.p (qbf-qcfile,OUTPUT dName,OUTPUT fName).

ASSIGN
  qbf-fastload      = dName + SUBSTRING(fName,1,-1,"FIXED":u)
  _adminFeatureFile = qbf-fastload + "f.p":u
  qbf-s             = TRUE
  _newConfig        = TRUE
  _configDirty      = TRUE
.

RETURN.

/* _aboot.p - end of file */

