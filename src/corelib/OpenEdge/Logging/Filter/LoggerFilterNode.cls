/************************************************
Copyright (c) 2016, 2019 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : LoggerFilterNode
    Purpose     : A node on the logging message filter chain
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-11-16
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Filter.LoggerFilterNode.

class OpenEdge.Logging.Filter.LoggerFilterNode : 
    define public property Next as class LoggerFilterNode no-undo get. set.
    define public property Data as class ILoggerFilter no-undo get. set.
    
    constructor public LoggerFilterNode(input poData as class ILoggerFilter):
        this-object:Data = poData.
    end constructor.
end class.
