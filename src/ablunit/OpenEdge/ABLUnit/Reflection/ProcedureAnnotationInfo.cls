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

class OpenEdge.ABLUnit.Reflection.ProcedureAnnotationInfo inherits TestAnnotationInfo:

    /* Default constructor */
    constructor public ProcedureAnnotationInfo (  ):
        super ().
    end constructor.

    method public void setBeforeProcedure(input bProc as TestInfo):
        if valid-object(bProc) then
            BeforeAll:Add(bProc).
    end method.

    method public void setAfterProcedure(input aProc as TestInfo):
        if valid-object(aProc) then
            AfterAll:Add(aProc).
    end method.

    method public void setBefore(input beforeProc as TestInfo):
        if valid-object(beforeProc) then
            BeforeEach:Add(beforeProc).
    end method.

    method public void setAfter(input afterProc as TestInfo):
        if valid-object(afterProc) then
            AfterEach:Add(afterProc).
    end method.

    method public void addTestProc(input tProc as TestInfo):
        if valid-object(tProc) then
            Tests:Add(tProc).
    end method.

end class.