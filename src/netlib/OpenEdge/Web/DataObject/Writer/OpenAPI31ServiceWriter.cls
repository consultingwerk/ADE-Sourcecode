/* *************************************************************************************************************************
Copyright (c) 2026 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : OpenAPI31ServiceWriter
    Purpose     : Writes a DataObjectService to a OpenApi (Swagger) 3.1 spec
    Syntax      :
    Description :
    Author(s)   : dugrau
    Created     : 2026-01-15
    Notes       : Supported Specification History:
        Builds upon the original OpenAPI 3.0 implementation (see OE.W.DO.Writer.OpenAPI30ServiceWriter.cls)
        Starting Implementation: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.1.2.md
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.SemanticVersion.
using OpenEdge.Web.DataObject.Writer.OpenAPI30ServiceWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Web.DataObject.Writer.OpenAPI31ServiceWriter inherits OpenAPI30ServiceWriter:

    constructor static OpenAPI31ServiceWriter():
        // NOTICE (January 2026): The version MUST be 3.1.1 for use with FastMCP!
        assign OPEN_API_VERSION = new SemanticVersion(3,1,1).
    end constructor.

    /**
     * OpenAPI 3.1.x specific overrides for JSON Schema 2020-12 compliance.
     *
     * Key changes introduced in OpenAPI 3.1.x:
     * - Adopted JSON Schema 2020-12 as the vocabulary for schemas
     * - Removed 'nullable' keyword (nullable is now default behavior)
     * - Removed 'format: binary' in favor of contentEncoding/contentMediaType
     * - Full JSON Schema compatibility (can use any JSON Schema keyword)
     */

    /**
        Overrides 3.0.x behavior to remove explicit nullable property.
        In OpenAPI 3.1.x with JSON Schema 2020-12, all fields are nullable by default
        unless explicitly marked as required in the parent schema's required array.

        @param JsonObject The schema object (no-op in 3.1.x - nullable is default)
      */
    method override protected void AddNullableProperty(input pSchemaObject as JsonObject):
        // OpenAPI 3.1.x change: Do nothing - nullable is default in JSON Schema 2020-12
        // OpenAPI 3.0.x used 'nullable: true', but this is no longer valid in 3.1.x
        // Fields are nullable unless explicitly marked as required
    end method.

    /**
        Overrides 3.0.x behavior for binary field format.
        In OpenAPI 3.1.x with JSON Schema 2020-12, binary data uses contentEncoding
        and contentMediaType instead of the removed 'format: binary'.

        @param JsonObject The schema object to apply format to
        @param character The format value (e.g., 'date', 'int32', 'binary')
      */
    method override protected void ApplyFieldFormat(input pSchemaObject as JsonObject,
                                                    input pFormat       as character):
        // OpenAPI 3.1.x change: JSON Schema 2020-12 removed format: binary
        // Use contentEncoding and contentMediaType instead per the new spec
        if pFormat eq 'binary':u then do:
            pSchemaObject:Add('contentEncoding':u, 'base64':u).
            pSchemaObject:Add('contentMediaType':u, 'application/octet-stream':u).
        end.
        else if pFormat gt '':u then
            pSchemaObject:Add('format':u, pFormat).
    end method.

    /**
        Overrides 3.0.x per-field required marking.
        In OpenAPI 3.1.x with JSON Schema 2020-12, required is expressed as an array
        on the parent items object, not as a boolean on individual field schemas.
        This method is a no-op — required fields are applied by MarkRequiredFields instead.

        @param JsonObject The field schema object (unused in 3.1.x)
      */
    method override protected void MarkRequiredField(input pFieldSchema  as JsonObject,
                                                     input pFieldName    as character,
                                                     input pRequiredFlds as character):
        // OpenAPI 3.1.x change: Do nothing per-field.
        // Required fields are collected and written as an array by MarkRequiredFields.
    end method. // MarkRequiredField

    /**
        Overrides 3.0.x no-op to write a JSON Schema 2020-12 compliant required array.
        Splits pRequiredFlds by comma and adds a 'required' array to the items schema
        containing each unique field's name.

        @param JsonObject The items schema object of the table
        @param character Comma-delimited list of unique (required) field names
      */
    method override protected void MarkRequiredFields(input pItemsSchema  as JsonObject,
                                                      input pRequiredFlds as character):
        define variable requiredArray as JsonArray no-undo.
        define variable iLoop        as integer   no-undo.
        define variable iCount       as integer   no-undo.

        // No fields, no required array needed.
        if (pRequiredFlds gt '':u) ne true then return.

        assign
            requiredArray = new JsonArray()
            iCount        = num-entries(pRequiredFlds)
            .

        do iLoop = 1 to iCount:
            requiredArray:Add(entry(iLoop, pRequiredFlds)).
        end.

        pItemsSchema:Add('required':u, requiredArray).
    end method. // MarkRequiredFields

end class.