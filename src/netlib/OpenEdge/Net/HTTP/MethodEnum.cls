/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : MethodEnum
    Purpose     : Generic HTTP methods. Based on W3C lib and HTTP spec.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Feb 11 09:18:45 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

enum OpenEdge.Net.HTTP.MethodEnum:
    define enum         INVALID = -1
                        GET 
                        
                        HEAD 
                        POST 
                        PUT 
                        PATCH 
                        DELETE 
                        TRACE 
                        OPTIONS 
                        LINK 
                        UNLINK
                    
                        /* WebDAV Methods */
                        LOCK
                        UNLOCK
                    
                        PROPFIND
                        PROPPATCH
                        MKCOL
                        COPY
                        MOVE
                    
                        /* Extension methods */
                        EXT_0
                        EXT_1
                        EXT_2
                        EXT_3
                        EXT_4
                        EXT_5
                        EXT_6
                        .
end enum.
