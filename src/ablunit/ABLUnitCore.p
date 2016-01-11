
/*------------------------------------------------------------------------
    File        : ABLUnitCore
    
    Purpose     : Driver program which accepts the testcases, test suites 
                  and test directory as input in the following format
                  
                  Format:
                      prowin32 -p ABLUnitCore.p -param TestClass.cls
                      prowin32 -p ABLUnitCore.p -param TestClass.cls#TestM1 (for running a particular method inside a testclass)
                      prowin32 -p ABLUnitCore.p -param TestProcedure.p
                      prowin32 -p ABLUnitCore.p -param TestProcedure.p#TestP1 (for running a particular internal procedure inside a testprocedure)
                      prowin32 -p ABLUnitCore.p -param <Full Path of TestFolder>
    Syntax      :
        
    Description : Driver program which accepts the testcases, test suites 
                  and test directory as input
                  
    Author(s)   : hgarapat
    
    Created     : Wed Jun 27 12:08:26 IST 2012
    Notes       :
  ----------------------------------------------------------------------*/
  
routine-level on error undo, throw.

using OpenEdge.ABLUnit.Runner.ABLRunner.

/* ***************************  Definitions  ************************** */
define variable cmdLineInput as character no-undo.
define variable testCase as character no-undo.
define variable i as integer no-undo.
define variable testCasesCount as integer no-undo.
define variable testMethodsCount as integer no-undo.
define variable ablRunner as OpenEdge.ABLUnit.Runner.ABLRunner no-undo.

/* ***************************  Main Block  *************************** */
cmdLineInput = session:parameter.
testCasesCount = num-entries(cmdLineInput, ",").

do i = 1 to testCasesCount:
    testCase = entry (i, cmdLineInput, ",").
    testMethodsCount =  num-entries (testCase, "#").
    if not (testMethodsCount = 2 or  testMethodsCount = 1 )then do: 
        message "Not according to the input format." view-as alert-box.
        return error.
        end.
    ablRunner = new OpenEdge.ABLUnit.Runner.ABLRunner().
    ablRunner:RunTest(testCase, testMethodsCount).    
end.    
