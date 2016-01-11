/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : TransferEncodingEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 17 12:40:47 EST 2014
    Notes       : * Via http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.6 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

enum OpenEdge.Net.HTTP.TransferEncodingEnum:
    define enum       None      = 0
                      Chunked
                      Identity
                      Gzip
                      X-Gzip = Gzip
                      Compress
                      Deflate
                      .
end enum.
