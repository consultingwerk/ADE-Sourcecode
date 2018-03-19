/* *************************************************************************************************************************
Copyright (c) 2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
        ablType
        arg
        attr
        catalog
        contentType
        entity
        errorEnvelope
        extent
        fields
        file
        function
        indexes
        ioMode
        msgElem
        name
        options
        operations
        primary
        requestEnvelope
        responseEnvelope
        schemas        
        serializeHidden
        serializeName
        services
        statusCode
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