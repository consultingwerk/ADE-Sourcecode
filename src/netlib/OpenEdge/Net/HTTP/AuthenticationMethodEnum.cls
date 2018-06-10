/************************************************
Copyright (c) 2014, 2015, 2017 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : AuthenticationMethodEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Apr 07 13:39:27 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

enum OpenEdge.Net.HTTP.AuthenticationMethodEnum: 
    define enum       None   = 0 
                      Basic
                      Digest
                      Form
                      Other
                      Bearer
                      .
end enum.
