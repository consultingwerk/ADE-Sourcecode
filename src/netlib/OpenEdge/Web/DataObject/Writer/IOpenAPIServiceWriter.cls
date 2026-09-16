/**************************************************************************************************************************
Copyright (c) 2026 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
***************************************************************************************************************************/
/*------------------------------------------------------------------------
    File        : IOpenAPIServiceWriter
    Purpose     : Interface for OpenAPI service writers with decorators
    Syntax      :
    Description : Provides minimal, expected properties/methods for use
    Author(s)   : dgrau
    Created     : 2026-01-22
    Notes       : Provides guaranteed methods which should be available
    regardless of the OAS specification to be implemented by a concrete
    class. Allows for applying a decorator pattern for certain actions.
------------------------------------------------------------------------*/

using OpenEdge.Web.DataObject.Writer.IOpenAPIServiceWriter.

interface OpenEdge.Web.DataObject.Writer.IOpenAPIServiceWriter:

    /** The JsonObject instance which will store the catalog data. */
    define public property Value as Progress.Lang.Object no-undo get. set.

    /**
        Initializes the writer and creates the root OpenAPI document structure.
        After creating the structure, applies any user-provided context (version, servers).
      */
    method public void Open( ).

    /**
        Writes service data to the OpenAPI document.

        @param DataObjectService The service to write to the document
      */
    method public void Write(input poData as Progress.Lang.Object extent).

    /**
        Finalizes and closes the writer.
      */
    method public void Close( ).

    /**
        Sets the document API version for the OpenAPI specification.
        Uses decorator API pattern to allow method chaining.

        @param character The API version string (e.g., "1.0.0", "2.1.3")
        @return IOpenAPIServiceWriter Returns this instance for method chaining
      */
    method public IOpenAPIServiceWriter SetDocumentVersion(input pcVersion as character).

    /**
        Sets a direct server configuration to be inserted as the first server entry.
        Uses decorator API pattern to allow method chaining.

        @param character Scheme (http/https), ? or empty to use default
        @param character Hostname, ? or empty to use default
        @param integer Port number, ? or 0 to use default
        @param character Context path, ? or empty to use default
        @param character Base path, ? or empty to use default
        @return IOpenAPIServiceWriter Returns this instance for method chaining
      */
    method public IOpenAPIServiceWriter SetServer(input pcScheme   as character,
                                                  input pcHost     as character,
                                                  input piPort     as integer,
                                                  input pcContext  as character,
                                                  input pcBasePath as character).

    /**
        Enables the inclusion of role requirements in the OpenAPI document.
        By default, role names are not exposed for security reasons.
        Uses decorator API pattern to allow method chaining.

        @return IOpenAPIServiceWriter Returns this instance for method chaining
      */
    method public IOpenAPIServiceWriter IncludeRoleRequirements().

    /**
        Configures HTTP Basic Authentication as the security scheme.
        Uses decorator API pattern to allow method chaining.

        @param character Realm name (e.g., from http.all.realm property)
        @return IOpenAPIServiceWriter Returns this instance for method chaining
      */
    method public IOpenAPIServiceWriter UseBasicAuth(input pcRealm as character).

    /**
        Configures HTTP Basic Authentication as the security scheme with custom description.
        Uses decorator API pattern to allow method chaining.

        @param character Realm name (e.g., from http.all.realm property)
        @param character Custom description for the scheme
        @return IOpenAPIServiceWriter Returns this instance for method chaining
      */
    method public IOpenAPIServiceWriter UseBasicAuth(input pcRealm       as character,
                                                     input pcDescription as character).

    /**
        Configures Bearer token authentication as the security scheme.
        Uses decorator API pattern to allow method chaining.

        @param character Bearer format (e.g., 'JWT', 'Client-Principal', 'SAML')
        @return IOpenAPIServiceWriter Returns this instance for method chaining
      */
    method public IOpenAPIServiceWriter UseBearerAuth(input pcFormat as character).

    /**
        Configures Bearer token authentication as the security scheme with custom description.
        Uses decorator API pattern to allow method chaining.

        @param character Bearer format (e.g., 'JWT', 'Client-Principal', 'SAML')
        @param character Custom description for the scheme
        @return IOpenAPIServiceWriter Returns this instance for method chaining
      */
    method public IOpenAPIServiceWriter UseBearerAuth(input pcFormat      as character,
                                                      input pcDescription as character).

end interface.