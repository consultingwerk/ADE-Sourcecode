/* *************************************************************************************************************************
Copyright (c) 2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ReadModeEnum
    Purpose     : Enumeration of read-mode for READ-JSON and READ-XML
    Description : 
    Author(s)   : pjudge
    Created     : 2017-05-31
    Notes       : * Based on the ABL documentation 
  ----------------------------------------------------------------------*/
enum OpenEdge.Core.ReadModeEnum :  
    define enum Append  
                Empty   
                Replace 
                Merge
                 
                Default = Merge
                .
end enum.