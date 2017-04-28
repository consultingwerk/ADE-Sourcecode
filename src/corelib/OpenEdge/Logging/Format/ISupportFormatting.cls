/* *************************************************************************************************************************
Copyright (c) 2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ISupportFormatting
    Purpose     : Indicates that an implementer supports format strings 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2017-02-14
    Notes       : 
  ----------------------------------------------------------------------*/
interface OpenEdge.Logging.Format.ISupportFormatting:
    
    /* Format for the filter. See the TokenResolve class for more */
    define public property Format as character no-undo get. set.
    
end interface.