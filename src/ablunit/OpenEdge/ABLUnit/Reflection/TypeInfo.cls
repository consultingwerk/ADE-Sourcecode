/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/ 
 /*------------------------------------------------------------------------
    File        : TypeInfo
    Purpose     : Used for Class/Procedure as a container of class annotation info and the methods/procedures info
    Syntax      : 
    Description : 
    Author(s)   : svutla
    Created     : Tue Nov 12 12:00:10 IST 2013
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.ABLUnit.Reflection.ClassInfo.
USING OpenEdge.Core.Collections.Array.

CLASS OpenEdge.ABLUnit.Reflection.TypeInfo: 
    
    DEFINE PUBLIC PROPERTY classInfo AS ClassInfo  NO-UNDO GET. SET.
    DEFINE PUBLIC PROPERTY methods AS Array NO-UNDO GET. SET.
    DEFINE PUBLIC PROPERTY methodsCount AS INTEGER INIT 0 NO-UNDO GET. SET .

END CLASS.