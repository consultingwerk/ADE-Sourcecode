/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ElementTypeEnum
    Purpose     : Enumeration of http message elements for mapping parameters
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu May 19 09:41:53 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/

enum OpenEdge.Web.DataObject.ElementTypeEnum :  
    define enum None        = 0
                Path 
                Query
                Qry         = Query
                Header
                Hdr         = Header
                Field       
                Cookie
                StatusCode
                Code        = StatusCode
                StatusReason
                Reason      = StatusReason
                Body
                Request     // the whole request (IWebRequest)
                
                Constant    // a constant value
                .
end enum.