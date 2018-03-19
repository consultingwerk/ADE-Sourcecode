/* *************************************************************************************************************************
Copyright (c) 2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : ServiceOptions
    Purpose     : A ser of service-level options
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2017-08-22
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

class OpenEdge.Web.DataObject.ServiceOptions:
    
    /* Default constructor */
    constructor public ServiceOptions():
        super().
    end constructor. 
    
end class.