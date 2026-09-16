/* *************************************************************************************************************************
Copyright (c) 2026 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : OpenAPI32ServiceWriter
    Purpose     : Writes a DataObjectService to a OpenApi (Swagger) 3.2 spec
    Syntax      :
    Description :
    Author(s)   : dugrau
    Created     : 2026-01-15
    Notes       : Supported Specification History:
        Builds upon the original OpenAPI 3.0 implementation (see OE.W.DO.Writer.OpenAPI30ServiceWriter.cls)
        Continues updates from the OpenAPI 3.1 implementation (see OE.W.DO.Writer.OpenAPI31ServiceWriter.cls)
        Starting Implementation: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.2.0.md
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.SemanticVersion.
using OpenEdge.Web.DataObject.Writer.OpenAPI31ServiceWriter.

class OpenEdge.Web.DataObject.Writer.OpenAPI32ServiceWriter inherits OpenAPI31ServiceWriter:

    constructor static OpenAPI32ServiceWriter():
        // NOTICE (January 2026): This version IS NOT officially supported by FastMCP!
        assign OPEN_API_VERSION = new SemanticVersion(3,2,0).
    end constructor.

    /**
     * OpenAPI 3.2.x inherits from 3.1.x implementation.
     *
     * OpenAPI 3.2.0 maintains the same JSON Schema 2020-12 compliance as 3.1.x,
     * so all schema handling behaviors (nullable, binary format, etc.) are inherited
     * from the parent OpenAPI31ServiceWriter class without modification.
     *
     * This class exists primarily to:
     * - Set the correct OpenAPI version number (3.2.0)
     * - Provide a foundation for any future 3.2.x-specific features
     * - Maintain clear separation between specification versions
     *
     * If OpenAPI 3.2.x introduces schema changes beyond 3.1.x, method overrides
     * can be added here. Currently, no additional overrides are needed as the
     * JSON Schema vocabulary remains unchanged from 3.1.x.
     */

end class.