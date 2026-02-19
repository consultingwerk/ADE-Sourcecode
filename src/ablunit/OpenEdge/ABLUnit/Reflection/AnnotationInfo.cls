/************************************************
Copyright (c) 2013-2014,2020,2024 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
   File        : AnnotationInfo
   Purpose     : Stores the information of the Annotation like annotation type and attribute type and values.
   Syntax      : @Test[(attribute=value)]
   Description :
   Author(s)   : hgarapat
   Created     : Tue Jul 03 14:21:46 IST 2012
   Notes       : https://docs.progress.com/bundle/openedge-developer-studio-help/page/ABL-annotation-syntax.html
 ----------------------------------------------------------------------*/
block-level on error undo, throw.

class OpenEdge.ABLUnit.Reflection.AnnotationInfo:

    define public property AnnotationType as character no-undo get.
        private set.

    define public property AttributeName as character no-undo get.
        private set.

    define public property AttributeValue as character no-undo get.
        private set.

    /* Constructor

       @param character The annotation type
       @param character The attribute name
       @param character The attribute value     */
    constructor public AnnotationInfo ( input pType as character,
                                        input pName as character,
                                        input pValue as character ):
        assign 
            this-object:AnnotationType = pType
            this-object:AttributeName  = pName
            this-object:AttributeValue = pValue
            .
    end constructor.

    /* Constructor

       @param character The complete annotation string, from XML-XREF typically */
    constructor public AnnotationInfo (input annotationString as character):
        define variable attribute as character no-undo.

        assign
            annotationString           = trim(annotationString) // Get rid of any leading/trailing spaces: OCTA-22513
            this-object:AnnotationType = trim(entry(1, annotationString, "("))
            .

        // This handles more cases where spaces exist between elements in the string during parsing.
        if num-entries(annotationString, "(") gt 1 then
            assign
                attribute                  = trim(substring(annotationString, index(annotationString, "(") + 1), "()")
                this-object:AttributeName  = if num-entries(attribute, "=") ge 1 then trim(entry(1, attribute, "=")) else ""
                this-object:AttributeValue = if num-entries(attribute, "=") eq 2 then trim(entry(2, attribute, "=")) else ""
                .
        else
            assign
                this-object:AttributeName  = ""
                this-object:AttributeValue = ""
                .
    end constructor.

    // Deprecated in favor of the more accurately named "GetAnnotationType" method.
    @deprecated(since="13.0.0").
    method public character GetAnnotationName ( ):
        return this-object:AnnotationType.
    end method.

    method public character GetAnnotationType ( ):
        return this-object:AnnotationType.
    end method.

    method public character GetAttributeName ( ):
        return this-object:AttributeName.
    end method.

    method public character GetAttributeValue ( ):
        return this-object:AttributeValue.
    end method.

end class.