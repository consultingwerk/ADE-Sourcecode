 
 /*------------------------------------------------------------------------
    File        : TestInfo
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hgarapat
    Created     : Mon Aug 06 12:55:45 IST 2012
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.



class OpenEdge.ABLUnit.Reflection.TestInfo: 
    define public property annotations as OpenEdge.ABLUnit.Reflection.AnnotationInfo no-undo get. 
        private set.
    define public property testName as character no-undo get. 
        private set.
    
    constructor public TestInfo(input annotationInfo as OpenEdge.ABLUnit.Reflection.AnnotationInfo, input testN as character):
        annotations = annotationInfo.               
        testName = testN.
    end constructor.

    /*------------------------------------------------------------------------------
            Purpose: Returns the annotation name of this method                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public character getAnnotationName( ):
        return annotations:getAnnotationName().         
    end method.

    /*------------------------------------------------------------------------------
            Purpose: Returns the attribute value of the annotation, if any                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public character getAttributeValue( ):
        return annotations:getAttributeValue().            
    end method.
    
    /*------------------------------------------------------------------------------
            Purpose: Returns the attribute name in the annotation, if any                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public character getAttributeName( ):
        return annotations:getAttributeName().            
    end method.

    /*------------------------------------------------------------------------------
            Purpose: Returns the method name                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public character getTestName( ):
        return testName.          
    end method.

end class.