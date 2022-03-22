/* *************************************************************************************************************************
Copyright (c) 2017, 2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : IOModeHelper
    Purpose     : Helper methods for the OpenEdge.Core.IoModeEnum enum
    Author(s)   : pjudge
    Created     : 2017-08-25
    Notes       : * This type is abstract to prevent instantiation
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.IOModeEnum.
using Progress.Lang.ParameterList.
using OpenEdge.Core.StringConstant.

class OpenEdge.Core.IOModeHelper abstract:
    
    /** Returns a formatted string representation of an IoMode, specific to
        the parameter type (ParamList, DYN-CALL etc).
        
        Defaults to a simple stringification of the enum.
        
        @param IOModeEnum The enumeration to format
        @param character The parameter type. Typically a type name (like Progress.Lang.ParameterList);
                         if unknown or empty, the default format is used.
        @return character A formated string value of the enumeration 
        @throws AssertionFailedError Thrown when an invalid enum is passed in */
    method static public character ToString(input pMode as IOModeEnum,
                                            input pParameterType as character):
        define variable mode as character no-undo.
        
        Assert:NotNull(pMode, 'IO Mode').
        
        case pParameterType:
            // Per the doc on SetParameter, only the following are supported
            // "INPUT", "OUTPUT", "INPUT-OUTPUT", "OUTPUT APPEND", "OUTPUT BIND", "INPUT BY-REFERENCE", "OUTPUT BY-REFERENCE", 
            // "INPUT-OUTPUT BY-REFERENCE", and "INPUT BIND". 
            when get-class(ParameterList):TypeName then
                assign mode = substitute('&1&2&3 &4':u,
                                    string(pMode and IOModeEnum:Input),
                                    (if (pMode and IOModeEnum:InputOutput) eq IOModeEnum:InputOutput then '-':u else '':u),
                                    string(pMode and IOModeEnum:Output),
                                    string(pMode and (IOModeEnum:By-Reference or IOModeEnum:Append or IOModeEnum:Bind))).
            otherwise
                assign mode = string(pMode).
        end case.
        
        Assert:NotNull(mode, 'Formatted IO Mode').
        
        // get the whitespace off
        return trim(mode).
    end method.
    
end class.