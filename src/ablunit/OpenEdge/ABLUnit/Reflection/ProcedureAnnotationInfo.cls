/************************************************
Copyright (c) 2013-2017, 2019-2020 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
   File        : ProcedureAnnotationInfo
   Purpose     : Stores the information related to the Before, Setup, Test, TearDown, After annotations in
                 the test procedure. 
   Syntax      : 
   Description : 
   Author(s)   : hgarapat
   Created     : Tue Jul 24 11:36:16 IST 2012
   Notes       : * The TestProcedure class contains the code to run the test and lifecycle methods
 ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.ABLUnit.Reflection.TestAnnotationInfo.
using OpenEdge.ABLUnit.Reflection.TestInfo.
using OpenEdge.Core.Collections.Array.

CLASS OpenEdge.ABLUnit.Reflection.ProcedureAnnotationInfo inherits TestAnnotationInfo: 
    /* Default constructor */
    CONSTRUCTOR PUBLIC ProcedureAnnotationInfo (  ):
        SUPER ().
    END CONSTRUCTOR.
    
    METHOD PUBLIC VOID setBeforeProcedure(INPUT bProc AS TestInfo):
        if valid-object(bProc) then
            BeforeAll:Add(bProc).
    END METHOD.
    
    METHOD PUBLIC VOID setAfterProcedure(INPUT aProc AS TestInfo):
        if valid-object(aProc) then
            AfterAll:Add(aProc).
    END METHOD.
    
    METHOD PUBLIC VOID setBefore(INPUT beforeProc AS TestInfo):
        if valid-object(beforeProc) then
            BeforeEach:Add(beforeProc).
    END METHOD.
    
    METHOD PUBLIC VOID setAfter(INPUT afterProc AS TestInfo):
        if valid-object(afterProc) then
            AfterEach:Add(afterProc).
    END METHOD.
    
    METHOD PUBLIC VOID addTestProc(INPUT tProc AS TestInfo):
        if valid-object(tProc) then
            Tests:Add(tProc).
    END METHOD.
    
END CLASS.