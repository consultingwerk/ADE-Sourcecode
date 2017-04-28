/************************************************
Copyright (c)  2014-2017 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : UrlEncodingTypeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jun 03 17:01:20 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

enum OpenEdge.Net.UriEncodingTypeEnum:
    define enum Default = 0
                Scheme
                Host
                Path
                Query
                Fragment
                Cookie
                .
end enum.
