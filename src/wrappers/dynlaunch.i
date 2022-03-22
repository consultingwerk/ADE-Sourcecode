/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*--------------------------------------------------------------------------
  File: dynlaunch.i

  Description: Run business logic using Dyn Call Wrapper include

  Purpose:     This include will be used to run business logic on the Appserver.  It uses the dynamic call wrapper
               functionality to build the call on the Appserver, invoke the call, and return the results.

  Parameters: {&PLIP}            Physical procedure (PLIP) name, e.g. 'ac/app/actaxplipp.p', or a manager name
              {&IProc}           Internal procedure name, e.g. 'calculateTax'
              {&Partition}       Appserver partition, Astra = default, e.g. 'Astra'
              {&Define-only}     YES = define the variables you need but take no other action                                 
              {&mode1} - {&mode64}          Parameter 1 -> 64 mode : INPUT INPUT-OUTPUT or OUTPUT
              {&parm1} - {&parm64}          The name of the variable or field storing parameter 1 -> 64.
                                            When passing constants, put in single quotes, example 'Pass this string in'.
              {&dataType1} - {&dataType64}  The data type for parameter 1 -> 64 : BUFFER,TABLE-HANDLE,CHARACTER,DECIMAL etc...
              {&clearHandle1} - {....64}    Only applies to BUFFERs and TABLE-HANDLEs.  DELETEs the TABLE-HANDLE or BUFFER
                                            after the call has been completed...does a DELETE OBJECT...
                            
   RULES:
   1. Required logical arguments must be passed in unquoted as YES or NO. Other text
      arguments must be single quoted literals, e.g. 'text' or unquoted variables, 
      and if the literals require spaces, they should be double quoted then single
      quoted, e.g. "'text'".
   2. If the OnApp parameter is not NO, then a partition may be specified and will be connected
      if not already connected. If no partition is specified it will default to the 'Astra'
      Appserver partition and will run on the gshAstraAppserver handle.
   3. When using the dynamic call wrapper, specify your parameters as follows:
      &mode1 = INPUT  &parm1 = cCharVarName &dataType1 = CHARACTER
      &mode2 = OUTPUT &parm2 = hTableHandle &dataType2 = TABLE-HANDLE etc.
  
   Following use of the include file, the following variable values will be defined and available:
   lRunErrorStatus        Stored value of the ERROR-STATUS:ERROR after running an IP } needed when
   cRunReturnValue        Stored value of the RETURN-VALUE after running an IP       } AutoKill is YES

  History:
  --------
  Created: 22/07/2002     Neil Bell (MIP)
           Create dynlaunch.i include to cater for dynamic call wrapper calls.

---------------------------------------------------------------------------*/
&IF DEFINED(define-only) = 0 &THEN 
    &SCOPED-DEFINE define-only FALSE 
&ENDIF
&IF DEFINED(Partition) = 0 &THEN
    &SCOPED-DEFINE Partition 'Astra'  /* Default to Astra Appserver partition */
&ENDIF
&IF DEFINED(compileStaticCall) = 0 &THEN
    &SCOPED-DEFINE compileStaticCall YES
&ENDIF
&IF DEFINED(autokill) = 0 &THEN
    &SCOPED-DEFINE callParams S
&ELSE
    &IF {&autokill} &THEN
        &SCOPED-DEFINE callParams SK
    &ELSE
        &SCOPED-DEFINE callParams S
    &ENDIF
&ENDIF

&IF {&define-only} &THEN
    {launch.i &define-only = YES}

    &IF DEFINED(dynlaunch-variables) = 0 &THEN     /* Define dynlaunch.i variables */
    DEFINE VARIABLE hTableHandles     AS HANDLE     NO-UNDO EXTENT 64. /* Used when passing TABLE-HANDLEs across the Appserver */
    DEFINE VARIABLE iHandleCnt        AS INTEGER    NO-UNDO.
    DEFINE VARIABLE hAppserver        AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cTrackTableExtent AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hStaticTTHandle   AS HANDLE     NO-UNDO. /* Not used for Appserver calls, it's faster to pass the TABLE-HANDLE. */
    DEFINE VARIABLE hParameterTable   AS HANDLE     NO-UNDO. /* The TABLE-HANDLE to the temp-table storing the parameters */
    {
     src/adm2/calltables.i &PARAM-TABLE-TYPE = "1"
                           &PARAM-TABLE-NAME = "ttSeqType"
    }
    &GLOBAL-DEFINE dynlaunch-variables
    &ENDIF
&ELSE
    &IF DEFINED(dynlaunch-variables) = 0 &THEN 
    &MESSAGE The variables needed for dynlaunch.i need to be defined in your definitions section. &Define-Only = YES. 
    &ENDIF
    
    &GLOBAL-DEFINE displayPLIP  {&PLIP} 
    &GLOBAL-DEFINE displayIProc {&IProc}
    &GLOBAL-DEFINE PList

    /* Make sure we've got the requested Appserver handle */    
    &IF {&Partition} = "" OR {&Partition} = "Astra" &THEN
    ASSIGN hAppserver = gshAstraAppserver.
    &ELSE
    RUN appServerConnect(INPUT  {&Partition}, 
                         INPUT  "":U,
                         INPUT  "":U, 
                         OUTPUT hAppserver).
    &ENDIF

  &IF {&compileStaticCall} = YES &THEN
    IF SESSION <> hAppserver 
    THEN DO:
  &ENDIF
        EMPTY TEMP-TABLE ttSeqType.
        ASSIGN iHandleCnt = 1.

        &IF "{&parm1}"  <> "" &THEN {launchParam.i &param-name = {&parm1}  &param-type = {&dataType1}  &mode = {&mode1}  &order = 1  &clearHandle = '{&clearHandle1}'  &nextparam = {&parm2}}  &ENDIF
        &IF "{&parm2}"  <> "" &THEN {launchParam.i &param-name = {&parm2}  &param-type = {&dataType2}  &mode = {&mode2}  &order = 2  &clearHandle = '{&clearHandle2}'  &nextparam = {&parm3}}  &ENDIF
        &IF "{&parm3}"  <> "" &THEN {launchParam.i &param-name = {&parm3}  &param-type = {&dataType3}  &mode = {&mode3}  &order = 3  &clearHandle = '{&clearHandle3}'  &nextparam = {&parm4}}  &ENDIF
        &IF "{&parm4}"  <> "" &THEN {launchParam.i &param-name = {&parm4}  &param-type = {&dataType4}  &mode = {&mode4}  &order = 4  &clearHandle = '{&clearHandle4}'  &nextparam = {&parm5}}  &ENDIF
        &IF "{&parm5}"  <> "" &THEN {launchParam.i &param-name = {&parm5}  &param-type = {&dataType5}  &mode = {&mode5}  &order = 5  &clearHandle = '{&clearHandle5}'  &nextparam = {&parm6}}  &ENDIF
        &IF "{&parm6}"  <> "" &THEN {launchParam.i &param-name = {&parm6}  &param-type = {&dataType6}  &mode = {&mode6}  &order = 6  &clearHandle = '{&clearHandle6}'  &nextparam = {&parm7}}  &ENDIF
        &IF "{&parm7}"  <> "" &THEN {launchParam.i &param-name = {&parm7}  &param-type = {&dataType7}  &mode = {&mode7}  &order = 7  &clearHandle = '{&clearHandle7}'  &nextparam = {&parm8}}  &ENDIF
        &IF "{&parm8}"  <> "" &THEN {launchParam.i &param-name = {&parm8}  &param-type = {&dataType8}  &mode = {&mode8}  &order = 8  &clearHandle = '{&clearHandle8}'  &nextparam = {&parm9}}  &ENDIF
        &IF "{&parm9}"  <> "" &THEN {launchParam.i &param-name = {&parm9}  &param-type = {&dataType9}  &mode = {&mode9}  &order = 9  &clearHandle = '{&clearHandle9}'  &nextparam = {&parm10}} &ENDIF
        &IF "{&parm10}" <> "" &THEN {launchParam.i &param-name = {&parm10} &param-type = {&dataType10} &mode = {&mode10} &order = 10 &clearHandle = '{&clearHandle10}' &nextparam = {&parm11}} &ENDIF
        &IF "{&parm11}" <> "" &THEN {launchParam.i &param-name = {&parm11} &param-type = {&dataType11} &mode = {&mode11} &order = 11 &clearHandle = '{&clearHandle11}' &nextparam = {&parm12}} &ENDIF
        &IF "{&parm12}" <> "" &THEN {launchParam.i &param-name = {&parm12} &param-type = {&dataType12} &mode = {&mode12} &order = 12 &clearHandle = '{&clearHandle12}' &nextparam = {&parm13}} &ENDIF
        &IF "{&parm13}" <> "" &THEN {launchParam.i &param-name = {&parm13} &param-type = {&dataType13} &mode = {&mode13} &order = 13 &clearHandle = '{&clearHandle13}' &nextparam = {&parm14}} &ENDIF
        &IF "{&parm14}" <> "" &THEN {launchParam.i &param-name = {&parm14} &param-type = {&dataType14} &mode = {&mode14} &order = 14 &clearHandle = '{&clearHandle14}' &nextparam = {&parm15}} &ENDIF
        &IF "{&parm15}" <> "" &THEN {launchParam.i &param-name = {&parm15} &param-type = {&dataType15} &mode = {&mode15} &order = 15 &clearHandle = '{&clearHandle15}' &nextparam = {&parm16}} &ENDIF
        &IF "{&parm16}" <> "" &THEN {launchParam.i &param-name = {&parm16} &param-type = {&dataType16} &mode = {&mode16} &order = 16 &clearHandle = '{&clearHandle16}' &nextparam = {&parm17}} &ENDIF
        &IF "{&parm17}" <> "" &THEN {launchParam.i &param-name = {&parm17} &param-type = {&dataType17} &mode = {&mode17} &order = 17 &clearHandle = '{&clearHandle17}' &nextparam = {&parm18}} &ENDIF
        &IF "{&parm18}" <> "" &THEN {launchParam.i &param-name = {&parm18} &param-type = {&dataType18} &mode = {&mode18} &order = 18 &clearHandle = '{&clearHandle18}' &nextparam = {&parm19}} &ENDIF
        &IF "{&parm19}" <> "" &THEN {launchParam.i &param-name = {&parm19} &param-type = {&dataType19} &mode = {&mode19} &order = 19 &clearHandle = '{&clearHandle19}' &nextparam = {&parm20}} &ENDIF
        &IF "{&parm20}" <> "" &THEN {launchParam.i &param-name = {&parm20} &param-type = {&dataType20} &mode = {&mode20} &order = 20 &clearHandle = '{&clearHandle20}' &nextparam = {&parm21}} &ENDIF
        &IF "{&parm21}" <> "" &THEN {launchParam.i &param-name = {&parm21} &param-type = {&dataType21} &mode = {&mode21} &order = 21 &clearHandle = '{&clearHandle21}' &nextparam = {&parm22}} &ENDIF
        &IF "{&parm22}" <> "" &THEN {launchParam.i &param-name = {&parm22} &param-type = {&dataType22} &mode = {&mode22} &order = 22 &clearHandle = '{&clearHandle22}' &nextparam = {&parm23}} &ENDIF
        &IF "{&parm23}" <> "" &THEN {launchParam.i &param-name = {&parm23} &param-type = {&dataType23} &mode = {&mode23} &order = 23 &clearHandle = '{&clearHandle23}' &nextparam = {&parm24}} &ENDIF
        &IF "{&parm24}" <> "" &THEN {launchParam.i &param-name = {&parm24} &param-type = {&dataType24} &mode = {&mode24} &order = 24 &clearHandle = '{&clearHandle24}' &nextparam = {&parm25}} &ENDIF
        &IF "{&parm25}" <> "" &THEN {launchParam.i &param-name = {&parm25} &param-type = {&dataType25} &mode = {&mode25} &order = 25 &clearHandle = '{&clearHandle25}' &nextparam = {&parm26}} &ENDIF
        &IF "{&parm26}" <> "" &THEN {launchParam.i &param-name = {&parm26} &param-type = {&dataType26} &mode = {&mode26} &order = 26 &clearHandle = '{&clearHandle26}' &nextparam = {&parm27}} &ENDIF
        &IF "{&parm27}" <> "" &THEN {launchParam.i &param-name = {&parm27} &param-type = {&dataType27} &mode = {&mode27} &order = 27 &clearHandle = '{&clearHandle27}' &nextparam = {&parm28}} &ENDIF
        &IF "{&parm28}" <> "" &THEN {launchParam.i &param-name = {&parm28} &param-type = {&dataType28} &mode = {&mode28} &order = 28 &clearHandle = '{&clearHandle28}' &nextparam = {&parm29}} &ENDIF
        &IF "{&parm29}" <> "" &THEN {launchParam.i &param-name = {&parm29} &param-type = {&dataType29} &mode = {&mode29} &order = 29 &clearHandle = '{&clearHandle29}' &nextparam = {&parm30}} &ENDIF
        &IF "{&parm30}" <> "" &THEN {launchParam.i &param-name = {&parm30} &param-type = {&dataType30} &mode = {&mode30} &order = 30 &clearHandle = '{&clearHandle30}' &nextparam = {&parm31}} &ENDIF
        &IF "{&parm31}" <> "" &THEN {launchParam.i &param-name = {&parm31} &param-type = {&dataType31} &mode = {&mode31} &order = 31 &clearHandle = '{&clearHandle31}' &nextparam = {&parm32}} &ENDIF
        &IF "{&parm32}" <> "" &THEN {launchParam.i &param-name = {&parm32} &param-type = {&dataType32} &mode = {&mode32} &order = 32 &clearHandle = '{&clearHandle32}' &nextparam = {&parm33}} &ENDIF    
        &IF "{&parm33}" <> "" &THEN {launchParam.i &param-name = {&parm33} &param-type = {&dataType33} &mode = {&mode33} &order = 33 &clearHandle = '{&clearHandle33}' &nextparam = {&parm34}} &ENDIF
        &IF "{&parm34}" <> "" &THEN {launchParam.i &param-name = {&parm34} &param-type = {&dataType34} &mode = {&mode34} &order = 34 &clearHandle = '{&clearHandle34}' &nextparam = {&parm35}} &ENDIF
        &IF "{&parm35}" <> "" &THEN {launchParam.i &param-name = {&parm35} &param-type = {&dataType35} &mode = {&mode35} &order = 35 &clearHandle = '{&clearHandle35}' &nextparam = {&parm36}} &ENDIF
        &IF "{&parm36}" <> "" &THEN {launchParam.i &param-name = {&parm36} &param-type = {&dataType36} &mode = {&mode36} &order = 36 &clearHandle = '{&clearHandle36}' &nextparam = {&parm37}} &ENDIF
        &IF "{&parm37}" <> "" &THEN {launchParam.i &param-name = {&parm37} &param-type = {&dataType37} &mode = {&mode37} &order = 37 &clearHandle = '{&clearHandle37}' &nextparam = {&parm38}} &ENDIF
        &IF "{&parm38}" <> "" &THEN {launchParam.i &param-name = {&parm38} &param-type = {&dataType38} &mode = {&mode38} &order = 38 &clearHandle = '{&clearHandle38}' &nextparam = {&parm39}} &ENDIF
        &IF "{&parm39}" <> "" &THEN {launchParam.i &param-name = {&parm39} &param-type = {&dataType39} &mode = {&mode39} &order = 39 &clearHandle = '{&clearHandle39}' &nextparam = {&parm40}} &ENDIF
        &IF "{&parm40}" <> "" &THEN {launchParam.i &param-name = {&parm40} &param-type = {&dataType40} &mode = {&mode40} &order = 40 &clearHandle = '{&clearHandle40}' &nextparam = {&parm41}} &ENDIF
        &IF "{&parm41}" <> "" &THEN {launchParam.i &param-name = {&parm41} &param-type = {&dataType41} &mode = {&mode41} &order = 41 &clearHandle = '{&clearHandle41}' &nextparam = {&parm42}} &ENDIF
        &IF "{&parm42}" <> "" &THEN {launchParam.i &param-name = {&parm42} &param-type = {&dataType42} &mode = {&mode42} &order = 42 &clearHandle = '{&clearHandle42}' &nextparam = {&parm43}} &ENDIF
        &IF "{&parm43}" <> "" &THEN {launchParam.i &param-name = {&parm43} &param-type = {&dataType43} &mode = {&mode43} &order = 43 &clearHandle = '{&clearHandle43}' &nextparam = {&parm44}} &ENDIF
        &IF "{&parm44}" <> "" &THEN {launchParam.i &param-name = {&parm44} &param-type = {&dataType44} &mode = {&mode44} &order = 44 &clearHandle = '{&clearHandle44}' &nextparam = {&parm45}} &ENDIF
        &IF "{&parm45}" <> "" &THEN {launchParam.i &param-name = {&parm45} &param-type = {&dataType45} &mode = {&mode45} &order = 45 &clearHandle = '{&clearHandle45}' &nextparam = {&parm46}} &ENDIF
        &IF "{&parm46}" <> "" &THEN {launchParam.i &param-name = {&parm46} &param-type = {&dataType46} &mode = {&mode46} &order = 46 &clearHandle = '{&clearHandle46}' &nextparam = {&parm47}} &ENDIF
        &IF "{&parm47}" <> "" &THEN {launchParam.i &param-name = {&parm47} &param-type = {&dataType47} &mode = {&mode47} &order = 47 &clearHandle = '{&clearHandle47}' &nextparam = {&parm48}} &ENDIF
        &IF "{&parm48}" <> "" &THEN {launchParam.i &param-name = {&parm48} &param-type = {&dataType48} &mode = {&mode48} &order = 48 &clearHandle = '{&clearHandle48}' &nextparam = {&parm49}} &ENDIF
        &IF "{&parm49}" <> "" &THEN {launchParam.i &param-name = {&parm49} &param-type = {&dataType49} &mode = {&mode49} &order = 49 &clearHandle = '{&clearHandle49}' &nextparam = {&parm50}} &ENDIF
        &IF "{&parm50}" <> "" &THEN {launchParam.i &param-name = {&parm50} &param-type = {&dataType50} &mode = {&mode50} &order = 50 &clearHandle = '{&clearHandle50}' &nextparam = {&parm51}} &ENDIF
        &IF "{&parm51}" <> "" &THEN {launchParam.i &param-name = {&parm51} &param-type = {&dataType51} &mode = {&mode51} &order = 51 &clearHandle = '{&clearHandle51}' &nextparam = {&parm52}} &ENDIF
        &IF "{&parm52}" <> "" &THEN {launchParam.i &param-name = {&parm52} &param-type = {&dataType52} &mode = {&mode52} &order = 52 &clearHandle = '{&clearHandle52}' &nextparam = {&parm53}} &ENDIF
        &IF "{&parm53}" <> "" &THEN {launchParam.i &param-name = {&parm53} &param-type = {&dataType53} &mode = {&mode53} &order = 53 &clearHandle = '{&clearHandle53}' &nextparam = {&parm54}} &ENDIF
        &IF "{&parm54}" <> "" &THEN {launchParam.i &param-name = {&parm54} &param-type = {&dataType54} &mode = {&mode54} &order = 54 &clearHandle = '{&clearHandle54}' &nextparam = {&parm55}} &ENDIF
        &IF "{&parm55}" <> "" &THEN {launchParam.i &param-name = {&parm55} &param-type = {&dataType55} &mode = {&mode55} &order = 55 &clearHandle = '{&clearHandle55}' &nextparam = {&parm56}} &ENDIF
        &IF "{&parm56}" <> "" &THEN {launchParam.i &param-name = {&parm56} &param-type = {&dataType56} &mode = {&mode56} &order = 56 &clearHandle = '{&clearHandle56}' &nextparam = {&parm57}} &ENDIF
        &IF "{&parm57}" <> "" &THEN {launchParam.i &param-name = {&parm57} &param-type = {&dataType57} &mode = {&mode57} &order = 57 &clearHandle = '{&clearHandle57}' &nextparam = {&parm58}} &ENDIF
        &IF "{&parm58}" <> "" &THEN {launchParam.i &param-name = {&parm58} &param-type = {&dataType58} &mode = {&mode58} &order = 58 &clearHandle = '{&clearHandle58}' &nextparam = {&parm59}} &ENDIF
        &IF "{&parm59}" <> "" &THEN {launchParam.i &param-name = {&parm59} &param-type = {&dataType59} &mode = {&mode59} &order = 59 &clearHandle = '{&clearHandle59}' &nextparam = {&parm60}} &ENDIF
        &IF "{&parm60}" <> "" &THEN {launchParam.i &param-name = {&parm60} &param-type = {&dataType60} &mode = {&mode60} &order = 60 &clearHandle = '{&clearHandle60}' &nextparam = {&parm61}} &ENDIF
        &IF "{&parm61}" <> "" &THEN {launchParam.i &param-name = {&parm61} &param-type = {&dataType61} &mode = {&mode61} &order = 61 &clearHandle = '{&clearHandle61}' &nextparam = {&parm62}} &ENDIF
        &IF "{&parm62}" <> "" &THEN {launchParam.i &param-name = {&parm62} &param-type = {&dataType62} &mode = {&mode62} &order = 62 &clearHandle = '{&clearHandle62}' &nextparam = {&parm63}} &ENDIF
        &IF "{&parm63}" <> "" &THEN {launchParam.i &param-name = {&parm63} &param-type = {&dataType63} &mode = {&mode63} &order = 63 &clearHandle = '{&clearHandle63}' &nextparam = {&parm64}} &ENDIF
        &IF "{&parm64}" <> "" &THEN {launchParam.i &param-name = {&parm64} &param-type = {&dataType64} &mode = {&mode64} &order = 64 &clearHandle = '{&clearHandle64}' &nextparam = }          &ENDIF
        
        ASSIGN hParameterTable = TEMP-TABLE ttSeqType:HANDLE
               cRunReturnValue = "":U.

        DO ON STOP UNDO, LEAVE:
        &IF DEFINED(tablesInCall) = 0 &THEN /* This preprocessor will have been defined in launchParam.i */        
        /* We're not passing temp-tables, so use calltable.p */
        RUN adm2/calltable.p ON hAppserver ({&iProc},
                                            {&PLIP},
                                            "{&callParams}":U,
                                            INPUT-OUTPUT hStaticTTHandle, /* This handle will be ? and is not used */
                                            INPUT-OUTPUT TABLE-HANDLE hParameterTable) NO-ERROR.
        &ELSE
        /* We are passing temp-tables, so use calltablett.p */
        RUN adm2/calltablett.p ON gshAstraAppserver ({&iProc},
                                                     {&PLIP},
                                                     INPUT "{&callParams}":U,
                                                     INPUT-OUTPUT hStaticTTHandle,
                                                     INPUT-OUTPUT TABLE-HANDLE hParameterTable,
                                                     "", /* TABLE-HANDLEs not to delete on the Appserver */
                                                     {src/adm2/callttparam.i &ARRAYFIELD = "hTableHandles"}  /* The actual array of table handles */ 
                                                    ) NO-ERROR.
        &ENDIF
        
        END.

        /* If the error status was set, but no RETURN-VALUE, set it */    
        ASSIGN lRunErrorStatus = ERROR-STATUS:ERROR.
        
        IF  RETURN-VALUE <> "":U
        AND RETURN-VALUE <> ? THEN
            ASSIGN cRunReturnValue = RETURN-VALUE.
        ELSE
            IF lRunErrorStatus = YES THEN
                ASSIGN cRunReturnValue = "An error occured while running procedure {&iProc} in procedure {&PLIP}.".

        IF  cRunReturnValue <> "":U
        AND cRunReturnValue <> ? 
        THEN DO:
            ASSIGN cRunReturnValue = REPLACE(cRunReturnValue, "RETURN-VALUE=":U, "":U). /* The dynamic call wrapper adds RETURN-VALUE= before the RETURN-VALUE, remove it */
            RUN setReturnValue IN gshSessionManager(INPUT cRunReturnValue).
        END.

        /* The &assignValuesBackFromTT preprocessor is built in launchParam.i, it builds the FINDs *
         * and ASSIGNs necessary to assign the values from the temp-table back to the parameters.  */

        IF NOT lRunErrorStatus /* Only if no error */
        THEN DO:
            {&assignValuesBackFromTT}
        END.

        /* Delete the used temp-tables from memory */
        
        EMPTY TEMP-TABLE ttSeqType NO-ERROR.
        DELETE OBJECT hParameterTable NO-ERROR.
        ASSIGN hParameterTable = ? NO-ERROR.

        &IF DEFINED(tablesInCall) <> 0 &THEN /* This preprocessor will have been defined in launchParam.i */        
        /* For this call, run through all the TABLE-HANDLEs stored in our extent handle.                          *
         * - If the user has specified that the table needs to be deleted, delete it.                             *
         * - If we have a TABLE-HANDLE in one of the extents that the user did not originally specify, delete it. *
         * - Clear all extents (set the TABLE-HANDLE to ?)                                                        */

        DO iHandleCnt = 1 TO 64:
            IF VALID-HANDLE(hTableHandles[iHandleCnt]) 
            THEN DO:
                IF NUM-ENTRIES(cTrackTableExtent, "|":U) >= iHandleCnt * 3
                THEN DO:
                    IF ENTRY(iHandleCnt * 3, cTrackTableExtent, "|":U) = "YES":U THEN /* User has asked to delete the TABLE-HANDLE */
                        DELETE OBJECT hTableHandles[iHandleCnt] NO-ERROR.
                END.
                ELSE
                    DELETE OBJECT hTableHandles[iHandleCnt] NO-ERROR. /* This isn't one of the user's TABLE-HANDLEs, delete it */
            END.
            ASSIGN hTableHandles[iHandleCnt] = ? NO-ERROR.
        END.
        ASSIGN cTrackTableExtent = "":U.
        &ENDIF
  &IF {&compileStaticCall} = YES &THEN
    END.
    ELSE DO:        
        /* For performance reasons, do not make a dynamic call if not running Appserver, it's much more expensive */
       &IF "{&PList}" <> "" &THEN 
       &GLOBAL-DEFINE PList ({&PList})
       &ELSE
       &UNDEFINE PList
       &ENDIF
        {
         launch.i &PLIP      = {&PLIP}
                  &iProc     = {&IProc}
                  &Partition = {&Partition}
                  &autoKill  = YES
        }
    END.
  &ENDIF
&ENDIF

&IF DEFINED(define-only) <> 0 &THEN &UNDEFINE define-only &ENDIF
&IF DEFINED(Partition) <> 0 &THEN &UNDEFINE Partition &ENDIF
&IF DEFINED(assignValuesBackFromTT) <> 0 &THEN &UNDEFINE assignValuesBackFromTT &ENDIF
&IF DEFINED(tablesInCall) <> 0 &THEN &UNDEFINE tablesInCall &ENDIF
&IF DEFINED(PLIP) <> 0 &THEN &UNDEFINE PLIP &ENDIF
&IF DEFINED(IProc) <> 0 &THEN &UNDEFINE IProc &ENDIF
&IF DEFINED(PList) <> 0 &THEN &UNDEFINE PList &ENDIF
&IF DEFINED(compileStaticCall) <> 0 &THEN &UNDEFINE compileStaticCall &ENDIF
