/************************************************
Copyright (c)  2013-2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
 /*------------------------------------------------------------------------
    File        : TestInfo
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hgarapat
    Created     : Mon Aug 06 12:55:45 IST 2012
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.ABLUnit.Reflection.AnnotationInfo.
USING OpenEdge.Core.Collections.Array.


CLASS OpenEdge.ABLUnit.Reflection.TestInfo: 
    DEFINE PUBLIC PROPERTY annotations AS Array NO-UNDO GET. 
        PRIVATE SET.
    DEFINE PUBLIC PROPERTY annotationsCount AS INTEGER NO-UNDO GET. 
        PRIVATE SET.
    DEFINE PUBLIC PROPERTY testName AS CHARACTER NO-UNDO GET. 
        PRIVATE SET.
    DEFINE PUBLIC PROPERTY isStatic AS LOGICAL INIT FALSE NO-UNDO GET. SET .
    
    CONSTRUCTOR PUBLIC TestInfo(INPUT annotationInfo AS Array, INPUT annotationsCount AS INTEGER, INPUT testN AS CHARACTER):
        annotations = annotationInfo.    
        THIS-OBJECT:annotationsCount = annotationsCount.           
        testName = testN.
    END CONSTRUCTOR.


    /*------------------------------------------------------------------------------
            Purpose: Returns the method name                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC CHARACTER getTestName( ):
        RETURN testName.          
    END METHOD.

END CLASS.