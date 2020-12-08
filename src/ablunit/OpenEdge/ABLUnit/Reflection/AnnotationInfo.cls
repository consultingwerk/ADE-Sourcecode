/************************************************
Copyright (c)  2013-2014 by Progress Software Corporation. All rights reserved.
*************************************************/
 /*------------------------------------------------------------------------
    File        : AnnotationInfo
    Purpose     : Stores the information of the Annotation like annotation type and attribute type and values. 
    Syntax      : 
    Description : 
    Author(s)   : hgarapat
    Created     : Tue Jul 03 14:21:46 IST 2012
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

CLASS OpenEdge.ABLUnit.Reflection.AnnotationInfo: 

    DEFINE PUBLIC PROPERTY AnnotationType AS CHARACTER NO-UNDO GET. 
        PRIVATE SET.
    DEFINE PUBLIC PROPERTY AttributeName AS CHARACTER NO-UNDO GET. 
        PRIVATE SET.
    DEFINE PUBLIC PROPERTY AttributeValue AS CHARACTER NO-UNDO GET. 
        PRIVATE SET.
    
    CONSTRUCTOR PUBLIC AnnotationInfo (INPUT annotationString AS CHARACTER):
        DEFINE VARIABLE attribute AS CHARACTER NO-UNDO.
        ASSIGN
            AnnotationType = ENTRY(1, annotationString, "(")
            attribute      = TRIM(SUBSTRING(annotationString, LENGTH(AnnotationType) + 1),"()")
            AttributeName  = ENTRY(1, attribute, "=")
            AttributeValue = TRIM(SUBSTRING(attribute, LENGTH(AttributeName) + 2)).
    END CONSTRUCTOR.


    METHOD PUBLIC CHARACTER getAnnotationName(  ):
        RETURN AnnotationType.		
    END METHOD.

    METHOD PUBLIC CHARACTER getAttributeName(  ):
        RETURN AttributeName.            
    END METHOD.

    METHOD PUBLIC CHARACTER getAttributeValue(  ):
        RETURN AttributeValue.        
    END METHOD.	
	
END CLASS.