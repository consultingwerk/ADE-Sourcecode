/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
 /*------------------------------------------------------------------------
    File        : UriSchemeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 18 13:43:01 EST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

enum OpenEdge.Net.UriSchemeEnum:
    define enum       http  =  0
                      https
                      file
                      ftp.
end enum.
