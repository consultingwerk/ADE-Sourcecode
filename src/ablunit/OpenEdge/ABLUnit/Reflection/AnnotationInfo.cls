 
 /*------------------------------------------------------------------------
    File        : AnnotationInfo
    Purpose     : Stores the information of the Annotation like annotation type and attribute type and values. 
    Syntax      : 
    Description : 
    Author(s)   : hgarapat
    Created     : Tue Jul 03 14:21:46 IST 2012
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.



class OpenEdge.ABLUnit.Reflection.AnnotationInfo: 

    define public property AnnotationType as character no-undo get. 
        private set.
    define public property AttributeName as character no-undo get. 
        private set.
    define public property AttributeValue as character no-undo get. 
        private set.
    
    constructor public AnnotationInfo (input annotationString as character):
        define variable attribute as character no-undo.
        assign
            AnnotationType = entry(1, annotationString, "(")
            attribute      = trim(substring(annotationString, length(AnnotationType) + 1),"()")
            AttributeName  = entry(1, attribute, "=")
            AttributeValue = substring(attribute, length(AttributeName) + 2).
    end constructor.


    method public character getAnnotationName(  ):
        return AnnotationType.		
    end method.

    method public character getAttributeName(  ):
        return AttributeName.            
    end method.

    method public character getAttributeValue(  ):
        return AttributeValue.        
    end method.	
	
end class.