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
/*------------------------------------------------------------------------
     File  : fetchrowobject.i
             logic for server fetch and clean up of RowObject TTs from SDO 
             containers 
Parameters : &TTHandle      - TT table-handle name without the number suffix 
             &NumTTs        - Number of TTHandles (output parameters of this)
                              MAX 64      
             &Container     - character var with physical name of the container 
             &ContextString - character var for output of context
             &Messages      - character var for output of message
             
             createObjects      - IP in container for create of SDOs 
             createParams       - optional params for create IP
             initializeObjects  - IP in container for initialize 
             initializeParams   - optional params for create 
             fetchData          - IP in container for fetch/openquery SDOs 
             fetchParams        - params for fetchdata
             
      Notes: Included by fetchdata.p, fetchrows.p fetchcontaineddata.p and 
             fetchcontainedrows.p                                
------------------------------------------------------------------------*/
DEFINE VARIABLE iSDOLoop   AS INTEGER    NO-UNDO.
DEFINE VARIABLE hSDOHandle AS HANDLE     NO-UNDO.
DEFINE VARIABLE lStatic    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cSDOList   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTempTable AS HANDLE     NO-UNDO.

DO ON STOP UNDO, LEAVE:   
  RUN VALUE({&Container}) PERSISTENT SET hContainer NO-ERROR.   
END.

IF NOT VALID-HANDLE(hContainer) THEN
DO:
  {&Messages} = ERROR-STATUS:GET-MESSAGE(1).
  RETURN.
END.

&IF "{&objectName}":U <> "":U &THEN
  {set LogicalObjectName {&objectName} hContainer}.
&ENDIF

RUN {&createObjects} IN hContainer 
                     &IF "{&createParams}":U  <> "":U &THEN
                  ({&createParams})
                     &ENDIF
                  .

cSDOList = DYNAMIC-FUNCTION('getContainedDataObjects':U IN hContainer).

/* Loop through and create the external TT for the objects that can 
   either are dynamic or can benefit from a dynamic TT on fetch */
DO iSDOLoop = 1 TO NUM-ENTRIES(cSDOList):
  hSDOHandle = WIDGET-HANDLE(ENTRY(iSDOLoop,cSDOList)).
  {get UseStaticOnFetch lStatic hSDOHandle}.
  IF NOT lStatic THEN
  DO:
    /* We create in the this procedure's scope as we otherwise may risk that it 
       is created in the container's widget pool */ 
    CREATE TEMP-TABLE hTempTable. 
    {set RowObjectTable hTempTable hSDOHandle}.
    CASE iSDOLoop:
      &IF {&NumTTs} >= 1  &THEN WHEN 1 THEN {&TThandle}1  = hTempTable. &ENDIF
      &IF {&NumTTs} >= 2  &THEN WHEN 2 THEN {&TThandle}2  = hTempTable. &ENDIF
      &IF {&NumTTs} >= 3  &THEN WHEN 3 THEN {&TThandle}3  = hTempTable. &ENDIF
      &IF {&NumTTs} >= 4  &THEN WHEN 4 THEN {&TThandle}4  = hTempTable. &ENDIF
      &IF {&NumTTs} >= 5  &THEN WHEN 5 THEN {&TThandle}5  = hTempTable. &ENDIF
      &IF {&NumTTs} >= 6  &THEN WHEN 6 THEN {&TThandle}6  = hTempTable. &ENDIF
      &IF {&NumTTs} >= 7  &THEN WHEN 7 THEN {&TThandle}7  = hTempTable. &ENDIF
      &IF {&NumTTs} >= 8  &THEN WHEN 8 THEN {&TThandle}8  = hTempTable. &ENDIF
      &IF {&NumTTs} >= 9  &THEN WHEN 9 THEN {&TThandle}9  = hTempTable. &ENDIF
      &IF {&NumTTs} >= 10 &THEN WHEN 10 THEN {&TThandle}10 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 11 &THEN WHEN 11 THEN {&TThandle}11 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 12 &THEN WHEN 12 THEN {&TThandle}12 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 13 &THEN WHEN 13 THEN {&TThandle}13 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 14 &THEN WHEN 14 THEN {&TThandle}14 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 15 &THEN WHEN 15 THEN {&TThandle}15 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 16 &THEN WHEN 16 THEN {&TThandle}16 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 17 &THEN WHEN 17 THEN {&TThandle}17 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 18 &THEN WHEN 18 THEN {&TThandle}18 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 19 &THEN WHEN 19 THEN {&TThandle}19 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 20 &THEN WHEN 20 THEN {&TThandle}20 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 21 &THEN WHEN 21 THEN {&TThandle}21 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 22 &THEN WHEN 22 THEN {&TThandle}22 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 23 &THEN WHEN 23 THEN {&TThandle}23 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 24 &THEN WHEN 24 THEN {&TThandle}24 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 25 &THEN WHEN 25 THEN {&TThandle}25 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 26 &THEN WHEN 26 THEN {&TThandle}26 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 27 &THEN WHEN 27 THEN {&TThandle}27 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 28 &THEN WHEN 28 THEN {&TThandle}28 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 29 &THEN WHEN 29 THEN {&TThandle}29 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 30 &THEN WHEN 30 THEN {&TThandle}30 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 31 &THEN WHEN 31 THEN {&TThandle}31 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 32 &THEN WHEN 32 THEN {&TThandle}32 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 33 &THEN WHEN 33 THEN {&TThandle}33 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 34 &THEN WHEN 34 THEN {&TThandle}34 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 35 &THEN WHEN 35 THEN {&TThandle}35 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 36 &THEN WHEN 36 THEN {&TThandle}36 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 37 &THEN WHEN 37 THEN {&TThandle}37 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 38 &THEN WHEN 38 THEN {&TThandle}38 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 39 &THEN WHEN 39 THEN {&TThandle}39 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 40 &THEN WHEN 40 THEN {&TThandle}40 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 41 &THEN WHEN 41 THEN {&TThandle}41 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 42 &THEN WHEN 42 THEN {&TThandle}42 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 43 &THEN WHEN 43 THEN {&TThandle}43 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 44 &THEN WHEN 44 THEN {&TThandle}44 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 45 &THEN WHEN 45 THEN {&TThandle}45 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 46 &THEN WHEN 46 THEN {&TThandle}46 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 47 &THEN WHEN 47 THEN {&TThandle}47 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 48 &THEN WHEN 48 THEN {&TThandle}48 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 49 &THEN WHEN 49 THEN {&TThandle}49 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 50 &THEN WHEN 50 THEN {&TThandle}50 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 51 &THEN WHEN 51 THEN {&TThandle}51 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 52 &THEN WHEN 52 THEN {&TThandle}52 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 53 &THEN WHEN 53 THEN {&TThandle}53 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 54 &THEN WHEN 54 THEN {&TThandle}54 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 55 &THEN WHEN 55 THEN {&TThandle}55 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 56 &THEN WHEN 56 THEN {&TThandle}56 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 57 &THEN WHEN 57 THEN {&TThandle}57 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 58 &THEN WHEN 58 THEN {&TThandle}58 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 59 &THEN WHEN 59 THEN {&TThandle}59 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 60 &THEN WHEN 60 THEN {&TThandle}60 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 61 &THEN WHEN 61 THEN {&TThandle}61 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 62 &THEN WHEN 62 THEN {&TThandle}62 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 63 &THEN WHEN 63 THEN {&TThandle}63 = hTempTable. &ENDIF
      &IF {&NumTTs} >= 64 &THEN WHEN 64 THEN {&TThandle}64 = hTempTable. &ENDIF
    END CASE.
  END.
  hTempTable = ?. 
END.

RUN {&initializeObject} IN hContainer 
                        &IF "{&initializeParams}":U  <> "":U &THEN
                     ({&initializeParams})
                        &ENDIF
                     .

RUN {&fetchData} IN hContainer ({&fetchParams}).

/* Defines the case statement to fetch the rowObject  */ 
&SCOPED-DEFINE fetchTT &IF {&NumTTs} >= ~{&num~} &THEN~
 WHEN ~{&num~} THEN RUN fetchRowObjectTable IN hSDOHandle( OUTPUT TABLE-HANDLE {&TTHandle}~{&num~}).~
 &ENDIF

DO iSDOLoop = 1 TO NUM-ENTRIES(cSDOList):
  hSDOHandle = WIDGET-HANDLE(ENTRY(iSDOLoop,cSDOList)).
  {get UseStaticOnFetch lStatic hSDOHandle}.
  IF lStatic THEN
  DO:
   CASE iSDOLoop:
      &SCOPED-DEFINE num 1
      {&fetchTT} 
      &SCOPED-DEFINE num 2
      {&fetchTT} 
      &SCOPED-DEFINE num 3
      {&fetchTT} 
      &SCOPED-DEFINE num 4
      {&fetchTT} 
      &SCOPED-DEFINE num 5
      {&fetchTT} 
      &SCOPED-DEFINE num 6
      {&fetchTT} 
      &SCOPED-DEFINE num 7
      {&fetchTT} 
      &SCOPED-DEFINE num 8
      {&fetchTT} 
      &SCOPED-DEFINE num 9
      {&fetchTT} 
      &SCOPED-DEFINE num 10
      {&fetchTT} 
      &SCOPED-DEFINE num 11
      {&fetchTT} 
      &SCOPED-DEFINE num 12
      {&fetchTT} 
      &SCOPED-DEFINE num 13
      {&fetchTT} 
      &SCOPED-DEFINE num 14
      {&fetchTT} 
      &SCOPED-DEFINE num 15
      {&fetchTT} 
      &SCOPED-DEFINE num 16
      {&fetchTT} 
      &SCOPED-DEFINE num 17
      {&fetchTT} 
      &SCOPED-DEFINE num 18
      {&fetchTT} 
      &SCOPED-DEFINE num 19
      {&fetchTT} 
      &SCOPED-DEFINE num 20
      {&fetchTT} 
      &SCOPED-DEFINE num 21
      {&fetchTT} 
      &SCOPED-DEFINE num 21
      {&fetchTT} 
      &SCOPED-DEFINE num 22
      {&fetchTT} 
      &SCOPED-DEFINE num 23
      {&fetchTT} 
      &SCOPED-DEFINE num 24
      {&fetchTT} 
      &SCOPED-DEFINE num 25
      {&fetchTT} 
      &SCOPED-DEFINE num 26
      {&fetchTT} 
      &SCOPED-DEFINE num 27
      {&fetchTT} 
      &SCOPED-DEFINE num 28
      {&fetchTT} 
      &SCOPED-DEFINE num 29
      {&fetchTT} 
      &SCOPED-DEFINE num 30
      {&fetchTT} 
      &SCOPED-DEFINE num 31
      {&fetchTT} 
      &SCOPED-DEFINE num 31
      {&fetchTT} 
      &SCOPED-DEFINE num 32
      {&fetchTT} 
      &SCOPED-DEFINE num 33
      {&fetchTT} 
      &SCOPED-DEFINE num 34
      {&fetchTT} 
      &SCOPED-DEFINE num 35
      {&fetchTT} 
      &SCOPED-DEFINE num 36
      {&fetchTT} 
      &SCOPED-DEFINE num 37
      {&fetchTT} 
      &SCOPED-DEFINE num 38
      {&fetchTT} 
      &SCOPED-DEFINE num 39
      {&fetchTT} 
      &SCOPED-DEFINE num 40
      {&fetchTT} 
      &SCOPED-DEFINE num 41
      {&fetchTT} 
      &SCOPED-DEFINE num 42
      {&fetchTT} 
      &SCOPED-DEFINE num 43
      {&fetchTT} 
      &SCOPED-DEFINE num 44
      {&fetchTT} 
      &SCOPED-DEFINE num 45
      {&fetchTT} 
      &SCOPED-DEFINE num 46
      {&fetchTT} 
      &SCOPED-DEFINE num 47
      {&fetchTT} 
      &SCOPED-DEFINE num 48
      {&fetchTT} 
      &SCOPED-DEFINE num 49
      {&fetchTT} 
      &SCOPED-DEFINE num 50
      {&fetchTT} 
      &SCOPED-DEFINE num 51
      {&fetchTT} 
      &SCOPED-DEFINE num 52
      {&fetchTT} 
      &SCOPED-DEFINE num 53
      {&fetchTT} 
      &SCOPED-DEFINE num 54
      {&fetchTT} 
      &SCOPED-DEFINE num 55
      {&fetchTT} 
      &SCOPED-DEFINE num 56
      {&fetchTT} 
      &SCOPED-DEFINE num 57
      {&fetchTT} 
      &SCOPED-DEFINE num 58
      {&fetchTT}         
      &SCOPED-DEFINE num 59
      {&fetchTT} 
      &SCOPED-DEFINE num 60
      {&fetchTT} 
      &SCOPED-DEFINE num 61
      {&fetchTT} 
      &SCOPED-DEFINE num 62
      {&fetchTT} 
      &SCOPED-DEFINE num 63
      {&fetchTT} 
      &SCOPED-DEFINE num 64
      {&fetchTT} 
    END CASE.
  END.
END.

&UNDEFINE fetchTT
&UNDEFINE num

IF {fn anyMessage hContainer} THEN
  {&Messages} = {fn fetchMessages hContainer}.

RUN getContextAndDestroy IN hContainer (OUTPUT {&ContextString}).
       
&IF {&NumTTs} >= 1  &THEN DELETE OBJECT {&TThandle}1  NO-ERROR. &ENDIF
&IF {&NumTTs} >= 2  &THEN DELETE OBJECT {&TThandle}2  NO-ERROR. &ENDIF
&IF {&NumTTs} >= 3  &THEN DELETE OBJECT {&TThandle}3  NO-ERROR. &ENDIF
&IF {&NumTTs} >= 4  &THEN DELETE OBJECT {&TThandle}4  NO-ERROR. &ENDIF
&IF {&NumTTs} >= 5  &THEN DELETE OBJECT {&TThandle}5  NO-ERROR. &ENDIF
&IF {&NumTTs} >= 6  &THEN DELETE OBJECT {&TThandle}6  NO-ERROR. &ENDIF
&IF {&NumTTs} >= 7  &THEN DELETE OBJECT {&TThandle}7  NO-ERROR. &ENDIF
&IF {&NumTTs} >= 8  &THEN DELETE OBJECT {&TThandle}8  NO-ERROR. &ENDIF
&IF {&NumTTs} >= 9  &THEN DELETE OBJECT {&TThandle}9  NO-ERROR. &ENDIF
&IF {&NumTTs} >= 10 &THEN DELETE OBJECT {&TThandle}10 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 11 &THEN DELETE OBJECT {&TThandle}11 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 12 &THEN DELETE OBJECT {&TThandle}12 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 13 &THEN DELETE OBJECT {&TThandle}13 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 14 &THEN DELETE OBJECT {&TThandle}14 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 15 &THEN DELETE OBJECT {&TThandle}15 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 16 &THEN DELETE OBJECT {&TThandle}16 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 17 &THEN DELETE OBJECT {&TThandle}17 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 18 &THEN DELETE OBJECT {&TThandle}18 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 19 &THEN DELETE OBJECT {&TThandle}19 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 20 &THEN DELETE OBJECT {&TThandle}20 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 21 &THEN DELETE OBJECT {&TThandle}21 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 22 &THEN DELETE OBJECT {&TThandle}22 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 23 &THEN DELETE OBJECT {&TThandle}23 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 24 &THEN DELETE OBJECT {&TThandle}24 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 25 &THEN DELETE OBJECT {&TThandle}25 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 26 &THEN DELETE OBJECT {&TThandle}26 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 27 &THEN DELETE OBJECT {&TThandle}27 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 28 &THEN DELETE OBJECT {&TThandle}28 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 29 &THEN DELETE OBJECT {&TThandle}29 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 30 &THEN DELETE OBJECT {&TThandle}30 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 31 &THEN DELETE OBJECT {&TThandle}31 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 32 &THEN DELETE OBJECT {&TThandle}32 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 33 &THEN DELETE OBJECT {&TThandle}33 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 34 &THEN DELETE OBJECT {&TThandle}34 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 35 &THEN DELETE OBJECT {&TThandle}35 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 36 &THEN DELETE OBJECT {&TThandle}36 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 37 &THEN DELETE OBJECT {&TThandle}37 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 38 &THEN DELETE OBJECT {&TThandle}38 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 39 &THEN DELETE OBJECT {&TThandle}39 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 40 &THEN DELETE OBJECT {&TThandle}40 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 41 &THEN DELETE OBJECT {&TThandle}41 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 42 &THEN DELETE OBJECT {&TThandle}42 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 43 &THEN DELETE OBJECT {&TThandle}43 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 44 &THEN DELETE OBJECT {&TThandle}44 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 45 &THEN DELETE OBJECT {&TThandle}45 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 46 &THEN DELETE OBJECT {&TThandle}46 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 47 &THEN DELETE OBJECT {&TThandle}47 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 48 &THEN DELETE OBJECT {&TThandle}48 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 49 &THEN DELETE OBJECT {&TThandle}49 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 50 &THEN DELETE OBJECT {&TThandle}50 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 51 &THEN DELETE OBJECT {&TThandle}51 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 52 &THEN DELETE OBJECT {&TThandle}52 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 53 &THEN DELETE OBJECT {&TThandle}53 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 54 &THEN DELETE OBJECT {&TThandle}54 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 55 &THEN DELETE OBJECT {&TThandle}55 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 56 &THEN DELETE OBJECT {&TThandle}56 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 57 &THEN DELETE OBJECT {&TThandle}57 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 58 &THEN DELETE OBJECT {&TThandle}58 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 59 &THEN DELETE OBJECT {&TThandle}59 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 60 &THEN DELETE OBJECT {&TThandle}60 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 61 &THEN DELETE OBJECT {&TThandle}61 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 62 &THEN DELETE OBJECT {&TThandle}62 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 63 &THEN DELETE OBJECT {&TThandle}63 NO-ERROR. &ENDIF
&IF {&NumTTs} >= 64 &THEN DELETE OBJECT {&TThandle}64 NO-ERROR. &ENDIF
 
