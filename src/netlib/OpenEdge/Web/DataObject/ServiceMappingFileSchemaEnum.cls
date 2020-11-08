/* *************************************************************************************************************************
Copyright (c) 2017-2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ServiceMappingFileSchemaEnum
    Purpose     : Enumeration of the JSON object property names used
                  by the Data Object Handler for its mapping file (.GEN and .MAP)
    Author(s)   : pjudge
    Created     : 2017-08-16
    Notes       : * this is effectively a private enum for the ServiceRegistryLoader class
  ----------------------------------------------------------------------*/
enum OpenEdge.Web.DataObject.ServiceMappingFileSchemaEnum:
    define enum
        ablName
        ablRef
        ablType
        accessControl
        active
        arg
        argumentWriters
        attr
        caseSensitive
        catalog
        childTable
        childField
        contentType
        cookies
        entity
        errorEnvelope
        extent
        fields
        file
        function
        headers
        indexes
        ioMode
        msgElem
        name
        nested
        options
        operations
        parentTable
        parentField
        primary
        recursive
        reposition
        requestEnvelope
        responseEnvelope
        relations
        schemas
        serializeHidden
        serializeName
        services
        statusCode
        tables
        timeout
        trackChanges
        type
        typeof
        unique
        version
        void
        word
        writeBI
        .
end enum.