/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : MessageElement
    Purpose     : Represents a single HTTP message element. Used to transform data to and fro
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-04-30
    Notes       : 
            OperationParameter
                define public property InputElement  as MessageElement extent no-undo get. private set.
                define public property OutputElement as MessageElement extent no-undo get. private set.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.IOModeEnum.
using OpenEdge.Web.DataObject.ElementTypeEnum.

class OpenEdge.Web.DataObject.MessageElement serializable:
    /* (mandatory) The http/message element type */
    define public property ElementType as ElementTypeEnum no-undo get. private set.
    
    /* (mandatory) The name of the element */
    define public property ElementName as character no-undo get. private set.
    
    /* (mandatory) The IO mode name of the element. */
    define public property IoMode as IOModeEnum no-undo get. private set.
    
    /* (optional) The field name or the indexer of the element in the OperationParam's ABLType.
       Only used for arrays, where the ABLRef contains a positive integer value, and for
       classes, where the property contains a property name */
    define public property ABLReference as character no-undo get. set. 
    
    /* Constructor
       
       @param ElementTypeEnum The HTTP message element from which to read or write a value
       @param character The name of the element. Only BODY elements may be null/empty; all others MUST have a name
       @param IOModeEnum The IO mode of the message element */
    constructor public MessageElement(input pType as ElementTypeEnum,
                                      input pName as character,
                                      input pIoMode as IOModeEnum):
        Assert:NotNull(pIoMode, 'Element IO mode').
        Assert:NotNull(pType, 'Element type').
        
        case pType:
            when ElementTypeEnum:None or
            when ElementTypeEnum:Body or
            when ElementTypeEnum:HeaderSet or
            when ElementTypeEnum:QueryMap then
                /*NO-OP*/ .
            
            otherwise
                Assert:NotNullOrEmpty(pName, 'Element name').
        end case.
        
        assign this-object:ElementType  = pType
               this-object:ElementName  = pName
               this-object:IoMode       = pIoMode
               this-object:ABLReference = ?
               .
    end constructor.
    
    method override public character ToString():
        return substitute('&1 &2 &3':u,
                    this-object:IoMode:ToString(),
                    this-object:ElementType:ToString(),
                    this-object:ElementName             ).
    end method.
end class.