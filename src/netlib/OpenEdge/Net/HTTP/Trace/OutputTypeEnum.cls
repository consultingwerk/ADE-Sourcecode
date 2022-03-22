/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : OutputTypeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : dugrau
    Created     : Wed Aug 25 17:52:11 EDT 2021
    Notes       : 
  ----------------------------------------------------------------------*/

@since(rel='12.5.0').
enum OpenEdge.Net.HTTP.Trace.OutputTypeEnum :  
    define enum None
                Proxy 
                Local
                Default=None.

end enum.