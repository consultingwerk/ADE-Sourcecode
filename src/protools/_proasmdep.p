/*************************************************************/
/* Copyright (c) 2008 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/

/*
 * Program: protools/_proasmdep.p
 * 
 * Wrapper for protools/_proasmdep2.p, so we can call it from command line.
 * For use by the WebClient Application Assembler (WCAA), 
 * to determine any dependencies in Infragistics controls
 * that need to be included in a deployed WebClient application.
 * 
 * Intended usage:
 *   prowin32 -p protools/_proasmdep.p -b -param <infile> -icfparam <outfile>
 * where
 *  infile - file containing the paths of assemblies for which to find any dependencies.
 *          The file *MUST* contain one assembly path per line.
 *  outfile - the file in which to write the list of dependencies.
 *          This file will contain the assembly-qualified name of the each dependent assembly, one per line.
 *
 * No error messages are returned, as this is intended to be a batch program.
 * Diagnostic logging is written to the client log file, _proasmdep.log, in the same directory as cinfile.
 */
 
 
DEFINE VARIABLE cinfile AS CHARACTER   NO-UNDO.
DEFINE VARIABLE coutfile AS CHARACTER   NO-UNDO.
DEFINE VARIABLE clogfile AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ipos AS INTEGER     NO-UNDO.

ASSIGN 
     cinfile = SESSION:PARAMETER
     coutfile = SESSION:ICFPARAMETER.
 .
  

/* create ourselves a client log file, so that we can write diagnostics to it. 
 * Put it in the same dir as cinfile, called "_proasmdep.log" 
 */
ipos = R-INDEX(cinfile,"\").
IF (ipos > 0) THEN
    ASSIGN
        clogfile = SUBSTRING(cinfile,1,ipos) + "_proasmdep.log".

/* does our log already exist? */
FILE-INFO:FILE-NAME = clogfile.
IF (FILE-INFO:FILE-TYPE = ? OR INDEX(FILE-INFO:FILE-TYPE,"W") > 0) THEN
DO:
    /* we have  a log file name we can write to */
    ASSIGN 
        LOG-MANAGER:LOGFILE-NAME = clogfile
        LOG-MANAGER:LOG-ENTRY-TYPES = "4GLTRACE:2".
END.

RUN protools/_proasmdep2.r(cinfile,coutfile).

