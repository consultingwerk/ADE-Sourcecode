/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : TargetTypeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue May 24 11:55:35 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/

enum OpenEdge.Web.DataObject.TargetTypeEnum :  
    define enum Class
                Cls=Class
                
                Procedure
                Proc=Procedure
                
                Void
                File
                Self        // the dataobjecthandler itself
                .
end enum.