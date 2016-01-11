/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ApplicationPlatformEnum
    Purpose     : Enumeration of Mobile platform types
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu May 15 16:57:57 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

enum OpenEdge.Mobile.ApplicationPlatformEnum: 
    define enum       WindowsPhone
                      Windows8
                      Android
                      IOS.     
end enum.
