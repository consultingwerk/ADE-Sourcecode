/************************************************
Copyright (c) 2013-2014, 2020 by Progress Software Corporation. All rights reserved.
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
block-level on error undo, throw.

CLASS OpenEdge.ABLUnit.Reflection.AnnotationInfo: 

    DEFINE PUBLIC PROPERTY AnnotationType AS CHARACTER NO-UNDO GET. 
        PRIVATE SET.
    DEFINE PUBLIC PROPERTY AttributeName AS CHARACTER NO-UNDO GET. 
        PRIVATE SET.
    DEFINE PUBLIC PROPERTY AttributeValue AS CHARACTER NO-UNDO GET. 
        PRIVATE SET.
    
    /* Constructor 
       
       @param character The annotation type
       @param character The attribute name
       @param character The attribute value     */
    constructor public AnnotationInfo (input pType as character,
                                       input pName as character,
                                       input pValue as character):
        assign this-object:AnnotationType = pType
               this-object:AttributeName  = pName
               this-object:AttributeValue = pValue
               .
    end constructor.
    
    /* Constructor
       
       @param character The complete annotation string, from XML-XREF typically */
    CONSTRUCTOR PUBLIC AnnotationInfo (INPUT annotationString AS CHARACTER):
        DEFINE VARIABLE attribute AS CHARACTER NO-UNDO.
        ASSIGN
            annotationString = trim(annotationString)   // get rid of any leading/trailing spaces: OCTA-22513
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