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

block-level on error undo, throw.

using OpenEdge.ABLUnit.Reflection.AnnotationInfo from propath.
using OpenEdge.Core.Collections.Array from propath.

class OpenEdge.ABLUnit.Reflection.AnnotationUtil final:

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    constructor private AnnotationUtil ( ):
        super ().
    end constructor.

    /*------------------------------------------------------------------------------
     Purpose: Given an Array which contains AnnotationInfo objects this method checks whether there
                exists an annotation with 'Ignore'.
     Notes:
    ------------------------------------------------------------------------------*/
    method public static logical HasIgnoreAnnotation ( annotations as Array ):
        define variable i  as             integer no-undo.
        define variable annotation as AnnotationInfo no-undo.

        if valid-object(annotations) then
        do i=1 to annotations:Size on error undo, throw :
            annotation = cast(annotations:GetValue(i), AnnotationInfo).
            if annotation ne ? and annotation:AnnotationType eq "Ignore" then
                return true.
        end.

        return false.
    end method.

    /*------------------------------------------------------------------------------
     Purpose: Given an Array which contains AnnotationInfo objects this method
                returns the expected exception that is configured with test.
     Notes:
    ------------------------------------------------------------------------------*/
    method public static character GetExpectedExceptionName ( annotations as Array ):
        define variable i  as             integer no-undo.
        define variable annotation as AnnotationInfo no-undo.

        if valid-object(annotations) then
        do i=1 to annotations:Size on error undo, throw :
            annotation = cast(annotations:GetValue(i), AnnotationInfo).
            if annotation ne ? and annotation:AnnotationType eq "Test" and annotation:AttributeName eq "expected" then
                return annotation:AttributeValue.
        end.

        return "".
    end method.

    /*------------------------------------------------------------------------------
    Purpose: Given an Array which contains AnnotationInfo objects this method
               checks whether there exists an annotation with the given name.
    Notes:
   ------------------------------------------------------------------------------*/
    method public static logical HasAnnotation ( annotations as Array, annotationName as character ):
        define variable i          as integer no-undo.
        define variable annotation as AnnotationInfo no-undo.

        if valid-object(annotations) then
        do i=1 to annotations:Size on error undo, throw :
            annotation = cast(annotations:GetValue(i), AnnotationInfo).
            if annotation ne ? and annotation:AnnotationType eq annotationName then
                return true.
        end.

        return false.
    end method.

end class.