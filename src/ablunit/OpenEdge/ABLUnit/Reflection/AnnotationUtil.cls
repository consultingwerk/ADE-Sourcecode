/************************************************
Copyright (c) 2013-2020 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : AnnotationUtil
    Purpose     : A utility class to work with the annotation collection.
    Syntax      : 
    Description : 
    Author(s)   : psajja
    Created     : Thu Feb 25 19:26:35 IST 2016
    Notes       : 
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING OpenEdge.ABLUnit.Reflection.AnnotationInfo FROM PROPATH.
USING OpenEdge.Core.Collections.Array FROM PROPATH.

CLASS OpenEdge.ABLUnit.Reflection.AnnotationUtil FINAL: 

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
		
	CONSTRUCTOR PRIVATE AnnotationUtil (  ):
		SUPER ().
		
	END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
     Purpose: Given an Array which contains AnnotationInfo objects this method checks whether there
                exists an annotation with 'Ignore'.
     Notes: 
    ------------------------------------------------------------------------------*/

    METHOD PUBLIC STATIC LOGICAL HasIgnoreAnnotation( annotations AS Array ):
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        DEFINE VARIABLE annotation AS AnnotationInfo NO-UNDO.
        
        if valid-object(annotations) then
        DO i=1 TO annotations:Size ON ERROR UNDO, THROW :
            annotation = CAST(annotations:GetValue(i), AnnotationInfo).
            IF annotation NE ? AND annotation:AnnotationType EQ "Ignore"THEN
                RETURN TRUE.
        END.
        
        RETURN FALSE.
    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose: Given an Array which contains AnnotationInfo objects this method  
                returns the expected exception that is configured with test.
     Notes:
    ------------------------------------------------------------------------------*/

    METHOD PUBLIC STATIC CHARACTER GetExpectedExceptionName(annotations AS Array):
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        DEFINE VARIABLE annotation AS AnnotationInfo NO-UNDO.
        
        if valid-object(annotations) then
        DO i=1 TO annotations:Size ON ERROR UNDO, THROW :
            annotation = CAST(annotations:GetValue(i), AnnotationInfo).
            IF annotation NE ? AND annotation:AnnotationType EQ "Test" AND annotation:AttributeName EQ "expected" THEN
                RETURN annotation:AttributeValue.
        END.
        
        RETURN "".
    END METHOD.
    
     /*------------------------------------------------------------------------------
     Purpose: Given an Array which contains AnnotationInfo objects this method  
                checks whether there exists an annotation with the given name.
     Notes:
    ------------------------------------------------------------------------------*/

    METHOD PUBLIC STATIC LOGICAL HasAnnotation(annotations AS Array, annotationName AS CHARACTER):
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        DEFINE VARIABLE annotation AS AnnotationInfo NO-UNDO.
        
        if valid-object(annotations) then
        DO i=1 TO annotations:Size ON ERROR UNDO, THROW :
            annotation = CAST(annotations:GetValue(i), AnnotationInfo).
            IF annotation NE ? AND annotation:AnnotationType EQ annotationName THEN
                RETURN TRUE.
        END.
        
        RETURN FALSE.
    END METHOD.
END CLASS.