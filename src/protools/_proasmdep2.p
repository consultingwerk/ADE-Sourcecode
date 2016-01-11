/*************************************************************/
/* Copyright (c) 2008 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/

/*
 * Program: protools/_proasmdep2.p
 * 
 * Lists assembly dependencies for a given list of assemblies.
 * For use by the WebClient Application Assembler (WCAA), 
 * to determine any dependencies in Infragistics controls
 * that need to be included in a deployed WebClient application.
 * 
 * Intended usage:
 *   RUN protools/_proasmdep2.r(infile,outfile).
 * where
 *  infile - file containing the paths of assemblies for which to find any dependencies.
 *          The file *MUST* contain one assembly path per line.
 *  outfile - the file in which to write the list of dependencies.
 *          This file will contain the assembly-qualified name of the each dependent assembly, one per line.
 * 
 * No error messages are returned, as this is intended to be a batch program. 
 * Diagnostic logging is written to the client log file, LOG-MANAGER:LOGFILE-NAME.
 * If there is an invalid path in <infile>, then this file will be skipped, and the rest of the paths loaded.
 * Dependencies are listed only once in the output file.
 */

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

USING System.Reflection.*.
USING System.Collections.*.

DEFINE INPUT  PARAMETER cinfile AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER coutfile AS CHARACTER   NO-UNDO.

/* Contains the list of assembly paths for which to find dependencies */
DEF TEMP-TABLE ttasmpath NO-UNDO
    FIELD casmpath AS CHARACTER FORMAT "x(60)"
    FIELD oasm AS Progress.Lang.Object 
    .

/* Contains the assembly names of dependencies */
DEF TEMP-TABLE ttasmref NO-UNDO
    FIELD casmname AS CHARACTER FORMAT "x(60)"
    INDEX ixasmname casmname.

LOG-MANAGER:WRITE-MESSAGE("Input file " + cinfile).
LOG-MANAGER:WRITE-MESSAGE("Output file " + coutfile).

IF (cinfile = "" OR coutfile = "") THEN
DO:
    LOG-MANAGER:WRITE-MESSAGE("Input or output filename is empty. Aborting.").
    RETURN.
END.
/* verify the infile exists, and is a file */
FILE-INFO:FILE-NAME = cinfile.
IF FILE-INFO:FILE-TYPE = ? OR  index(FILE-INFO:FILE-TYPE,"F") = 0 THEN
DO:
    LOG-MANAGER:WRITE-MESSAGE("Input file does not exist or is not a file. Aborting.").
    RETURN.
END.

LOG-MANAGER:WRITE-MESSAGE("Before LoadFromFile").

/* Load the list of assemblies from the file */
RUN LoadFromFile(cinfile).

LOG-MANAGER:WRITE-MESSAGE("Before LoadList").

/* Load the assemblies into .NET */
RUN LoadList.

LOG-MANAGER:WRITE-MESSAGE("Before WriteToFile").

/* Write the dependencies of the loaded assemblies to the output file */
RUN WriteToFile(coutfile).

LOG-MANAGER:WRITE-MESSAGE("Completed.").
QUIT.

/*
 * Procedure LoadList
 * 
 * Loads the list of assemblies into .NET, by using System.Reflection.
 * If there is an invalid path, skip it, rather than terminate the load.
 * Also loads the names of the dependencies into ttasmref.
 */
PROCEDURE LoadList:

    DEFINE VARIABLE oAssembly AS System.Reflection.Assembly NO-UNDO.
    FOR EACH ttasmpath:
        LOG-MANAGER:WRITE-MESSAGE("About to load " + ttasmpath.casmpath).
        oAssembly = System.Reflection.Assembly:LoadFrom(ttasmpath.casmpath) NO-ERROR.
        /* skip an invalid path that fails to load */
        IF ERROR-STATUS:ERROR THEN 
        do:
            DEFINE VARIABLE i AS INTEGER     NO-UNDO.
            LOG-MANAGER:WRITE-MESSAGE("Failed to load " + ttasmpath.casmpath).
              DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
                  LOG-MANAGER:WRITE-MESSAGE(" " + 
                                            STRING(ERROR-STATUS:GET-NUMBER(i)) + " " + 
                                            ERROR-STATUS:GET-MESSAGE(i)).
              END.
            NEXT.
        END.
        LOG-MANAGER:WRITE-MESSAGE("Loaded " + ttasmpath.casmpath).
        ttasmpath.oasm = oAssembly.
        RUN GetAssemblyRefs(oAssembly).
    END.
END.

/* 
 * Procedure GetAssemblyRefs
 * 
 * Loads the assembly names of dependencies into ttasmref.
 * Needs to be a separate procedure so that oRef can be indeterminant.
 */
PROCEDURE GetAssemblyRefs:
    DEF INPUT PARAMETER oAssembly AS Assembly NO-UNDO.

    DEFINE VARIABLE oRef AS System.Reflection.AssemblyName EXTENT NO-UNDO.
    DEFINE VARIABLE irefmax AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iref AS INTEGER     NO-UNDO.
    DEFINE VARIABLE casmname AS CHARACTER   NO-UNDO.

    oRef = oAssembly:GetReferencedAssemblies().
    irefmax = EXTENT(oRef).
    LOG-MANAGER:WRITE-MESSAGE("Number of dependencies: " + STRING(irefmax)).
    DO iref = 1 TO irefmax:
        casmname = oRef[iref]:FullName.
        LOG-MANAGER:WRITE-MESSAGE("  " + casmname).
        FIND FIRST ttasmref NO-LOCK WHERE
            ttasmref.casmname = casmname NO-ERROR.
        IF NOT AVAILABLE ttasmref THEN
        DO:
            CREATE ttasmref.
            ASSIGN
                ttasmref.casmname = casmname.
        END.
    END.

END.

/*
 * Procedure LoadFromFile
 *
 * Loads the assembly paths from the given file into ttasmname.
 */
PROCEDURE LoadFromFile:
    DEFINE INPUT  PARAMETER cinfile AS CHARACTER   NO-UNDO.
    
    DEFINE VARIABLE casmpath AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cline AS CHARACTER   NO-UNDO.

    INPUT FROM VALUE(cinfile).
    REPEAT:
        IMPORT UNFORMATTED cline.
        LOG-MANAGER:WRITE-MESSAGE("Read :" + cline).
        CREATE ttasmpath.
        ASSIGN ttasmpath.casmpath = cline.
    END.
    INPUT CLOSE.
END.

/*
 * Writes the list of dependencies in ttasmref into the output file, one per line.
 */
PROCEDURE WriteToFile:
    DEFINE INPUT PARAMETER coutfile AS CHARACTER NO-UNDO.

    DEF VARIABLE oAssembly AS Assembly NO-UNDO.

    OUTPUT TO VALUE(coutfile).

    LOG-MANAGER:WRITE-MESSAGE("List of dependencies:").
    FOR EACH ttasmref:
        LOG-MANAGER:WRITE-MESSAGE(" " + ttasmref.casmname).
        PUT UNFORMATTED ttasmref.casmname SKIP.
    END.
    OUTPUT CLOSE.
END.

&ELSE
/* TTY processing */
DEFINE INPUT  PARAMETER cinfile AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER coutfile AS CHARACTER   NO-UNDO.

LOG-MANAGER:WRITE-MESSAGE("This program can be run only from prowin32.exe").

&ENDIF


