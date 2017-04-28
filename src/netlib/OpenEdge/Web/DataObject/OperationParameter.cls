/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : OperationParameter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu May 19 09:36:26 EDT 2016
    Notes       : * IOModeEnum should only be INPUT, OUTPUT, INPUT-OUTPUT, RETURN
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.IOModeEnum.
using OpenEdge.Web.DataObject.ElementTypeEnum.
using OpenEdge.Web.DataObject.OperationArgument.
using OpenEdge.Web.DataObject.MappedOperation.

class OpenEdge.Web.DataObject.OperationParameter:
    /* (mandatory) The IO mode of this parameter */
    define public property IOMode as IOModeEnum no-undo get. private set.
    
    /* (mandatory) The http/message element type */
    define public property InputElementType as ElementTypeEnum extent no-undo get. set.
    
    /* (optional, depends on type) The name of the element */
    define public property InputElementName as character extent no-undo get. set.

    /* (mandatory) The http/message element type */
    define public property OutputElementType as ElementTypeEnum extent no-undo get. set.
    
    /* (optional, depends on type) The name of the element */
    define public property OutputElementName as character extent no-undo get. set.
    
    /* (optional) Name of the ABL paramater - usually for info */
    define public property ABLName as character no-undo get. set.

    /* (mandatory) Name of the ABL datatype parameter */
    define public property ABLType as character no-undo get. private set.
    
    /* Constructor
       
       @param IOModeEnum (mandatory) The IO mode of this parameter
       @param ElementTypeEnum  (mandatory) The http/message element type
       @param character  (optional, depends on type) The name of the http message element
       @param character (mandatory) The ABL data type
       @param character (optional) The ABL name of the parameter, mainly for info */
    constructor public OperationParameter(input poIOMode as IOModeEnum,
                                          input pcABLType as character,
                                          input pcABLName as character):
        Assert:NotNull(poIOMode, 'IO Mode').
        Assert:NotNull(pcABLName, 'ABL name').
        Assert:NotNullOrEmpty(pcABLType, 'ABL type').
        
        assign this-object:IOMode         = poIOMode
               this-object:ABLName        = pcABLName
               this-object:ABLType        = pcABLType
               .
    end constructor.
    
end class.