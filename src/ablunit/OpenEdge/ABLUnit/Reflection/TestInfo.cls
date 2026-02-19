/************************************************
Copyright (c) 2013-2014, 2020 by Progress Software Corporation. All rights reserved.
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
block-level on error undo, throw.

using OpenEdge.Core.Collections.Array.

class OpenEdge.ABLUnit.Reflection.TestInfo:

    define public property annotations as Array no-undo get.
        private set.
    define public property annotationsCount as integer no-undo get.
        private set.
    define public property testName as character no-undo get.
        private set.
    define public property isStatic as logical init false no-undo get. set .

    constructor public TestInfo(input poAnnotationInfo as Array, input piAnnotationsCount as integer, input pcTestN as character):
        annotations = poAnnotationInfo.
        this-object:annotationsCount = piAnnotationsCount.
        testName = pcTestN.
    end constructor.


    /*------------------------------------------------------------------------------
            Purpose: Returns the method name
            Notes:
    ------------------------------------------------------------------------------*/
    method public character getTestName( ):
        return testName.
    end method.

end class.