/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : TracePolicyEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : dugrau
    Created     : Tue Aug 24 15:36:20 EDT 2021
    Notes       : 
  ----------------------------------------------------------------------*/

@since(rel='12.5.0').
enum OpenEdge.Net.HTTP.Trace.TracePolicyEnum:  
    define enum Allow
                Allow-All 
                Deny
                Deny-All
                .

end enum.