/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*--------------------------------------------------------------------------
  File: launchparam.i

  Description:  Dyn Call Parameter create for launch.i

  Purpose:      When running the dynamic call from dynlaunch.i, this include file will assign the
                parameter values into the temp-table required for the dynamic call.  When the
                call is finished, it will generate the code to assign the parameter values from the
                returned values stored in the temp-table.

  Parameters:   <none>

  History:
  --------
  Created: 22/07/2002     Neil Bell (MIP)
           Create dynlaunch.i include to cater for dynamic call wrapper calls.

---------------------------------------------------------------------------*/
&IF "{&param-type}" = "&mode" &THEN 
/* This is how &param-type is going to end up if it hasn't been defined */
&MESSAGE launch.i - For procedure call {&displayIProc} in {&displayPLIP}, parameter number {&order}, you have not specified the &dataType preprocessor.  Please fix.
&ENDIF

&IF "{&mode}" = "" &THEN
&MESSAGE launch.i - For procedure call {&displayIProc} in {&displayPLIP}, parameter number {&order}, you have not specified the &mode preprocessor.  Please fix.
&ENDIF

&IF {&clearHandle} <> 'YES' &THEN 
&SCOPED-DEFINE clearHandle 'NO'
&ENDIF

/* We need a parameter list for launch.i, build it.  Reason being that if not running Appserver, we'll use the standard call, for max performance */
&IF     "{&param-type}" = "TABLE-HANDLE" &THEN &GLOBAL-DEFINE Plist {&Plist} {&mode} TABLE-HANDLE {&param-name}
&ELSEIF "{&param-type}" = "BUFFER"       &THEN &GLOBAL-DEFINE Plist {&Plist} BUFFER {&param-name}
&ELSE                                          &GLOBAL-DEFINE Plist {&Plist} {&mode} {&param-name}
&ENDIF

&IF "{&nextparam}" <> "" &THEN
/* We don't want a comma at the end of our parameter list, include it if not the last parameter */
&GLOBAL-DEFINE Plist {&Plist} ,
&ENDIF

/* Create the parameter temp-table record */
CREATE ttSeqType.
ASSIGN ttSeqType.iParamNo      = {&order}
       ttSeqType.cParamName    = &IF     "{&param-type}" = "TABLE-HANDLE" &THEN "T:":U + STRING(iHandleCnt, "99":U) 
                                 &ELSEIF "{&param-type}" = "BUFFER"       &THEN "B:":U + STRING(iHandleCnt, "99":U)
                                 &ELSE   "{&param-name}":U
                                 &ENDIF
       ttSeqType.cDataType     = "{&param-type}":U
       ttSeqType.cIOMode       = "{&mode}":U.

&IF "{&param-type}" = "TABLE-HANDLE" OR "{&param-type}" = "BUFFER" &THEN
    ASSIGN hTableHandles[iHandleCnt] = {&param-name}
           cTrackTableExtent         = cTrackTableExtent + "{&param-name}|":U + STRING(iHandleCnt) + "|":U + {&clearHandle} + "|":U /* We need to keep track of which extent stores which TABLE-HANDLE, and which TABLE-HANDLE need to be cleared */
           iHandleCnt                = iHandleCnt + 1.

    /* When we assign the TABLE-HANDLE back, we're going to search for the param name in the list, the next entry contains the extent it's been stored in */
    &GLOBAL-DEFINE assignTTtoParm ASSIGN {&param-name} = hTableHandles[INTEGER(ENTRY(LOOKUP("{&param-name}":U, cTrackTableExtent, "|":U) + 1, cTrackTableExtent, "|":U))].
    &GLOBAL-DEFINE tablesInCall YES
&ELSE
    /* For input and input-output parameters, assign the input value.  Build the string to assign them back as well (used for &assignValuesBackFromTT) */
    &IF     "{&param-type}" = "CHARACTER" &THEN ASSIGN ttSeqType.cCharacter = {&param-name}.
    &GLOBAL-DEFINE assignTTtoParm ASSIGN {&param-name} = ttSeqType.cCharacter.
    &ELSEIF "{&param-type}" = "DECIMAL"   &THEN ASSIGN ttSeqType.dDecimal   = {&param-name}.
    &GLOBAL-DEFINE assignTTtoParm ASSIGN {&param-name} = ttSeqType.dDecimal.                  
    &ELSEIF "{&param-type}" = "DATE"      &THEN ASSIGN ttSeqType.tDate      = {&param-name}.
    &GLOBAL-DEFINE assignTTtoParm ASSIGN {&param-name} = ttSeqType.tDate.                      
    &ELSEIF "{&param-type}" = "INTEGER"   &THEN ASSIGN ttSeqType.iInteger   = {&param-name}.
    &GLOBAL-DEFINE assignTTtoParm ASSIGN {&param-name} = ttSeqType.iInteger.                          
    &ELSEIF "{&param-type}" = "DATETIME"   &THEN ASSIGN ttSeqType.dtDateTime   = {&param-name}.
    &GLOBAL-DEFINE assignTTtoParm ASSIGN {&param-name} = ttSeqType.dtDateTime.                          
    &ELSEIF "{&param-type}" = "DATETIME-TZ"   &THEN ASSIGN ttSeqType.dzDateTime   = {&param-name}.
    &GLOBAL-DEFINE assignTTtoParm ASSIGN {&param-name} = ttSeqType.dzDateTime.  
    &ELSEIF "{&param-type}" = "RAW"   &THEN ASSIGN ttSeqType.rRaw   = {&param-name}.
    &GLOBAL-DEFINE assignTTtoParm ASSIGN {&param-name} = ttSeqType.rRaw.
    &ELSEIF "{&param-type}" = "ROWID"   &THEN ASSIGN ttSeqType.rRowid   = {&param-name}.
    &GLOBAL-DEFINE assignTTtoParm ASSIGN {&param-name} = ttSeqType.rRowid.  
    &ELSEIF "{&param-type}" = "HANDLE"    &THEN ASSIGN ttSeqType.hHandle    = {&param-name}.
    &GLOBAL-DEFINE assignTTtoParm ASSIGN {&param-name} = ttSeqType.hHandle.                      
    &ELSE ASSIGN ttSeqType.lLogical = {&param-name}.
    &GLOBAL-DEFINE assignTTtoParm ASSIGN {&param-name} = ttSeqType.lLogical.
    &ENDIF
&ENDIF

&IF "{&mode}" = "OUTPUT" OR "{&mode}" = "INPUT-OUTPUT" &THEN
/* Build the string to assign the value stored in the temp-table back to the variables.     *
 * In dynlaunch.i, we can just put {&assignValuesBackFromTT}, and all the finds and assigns *
 * will be included correctly.                                                              */
&GLOBAL-DEFINE assignValuesBackFromTT {&assignValuesBackFromTT} FIND ttSeqType WHERE ttSeqType.iParamNo = {&order}. {&assignTTtoParm}
&ENDIF

&UNDEFINE assignTTtoParm
