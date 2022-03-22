/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : PolicyTypeEnum
    Purpose     : Enumerates trace policies
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Tue Aug 24 16:47:44 EDT 2021
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

@since(rel='12.5.0').
enum OpenEdge.Net.HTTP.Trace.PolicyTypeEnum:
    define enum Allow-All
                AllowAll = Allow-All
                Deny-All
                DenyAll = Deny-All
                .
end enum.