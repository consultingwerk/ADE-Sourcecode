/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ISupportLogging
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-11-14
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Logging.ILogWriter.

interface OpenEdge.Logging.ISupportLogging:
    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo get. set.
    
end interface.
