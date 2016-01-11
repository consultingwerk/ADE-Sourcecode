/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ISupportInitialize
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jan 28 22:55:39 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
interface OpenEdge.Core.ISupportInitialize:  

    /* Initializer/Startup */
    method public void Initialize().
    
    /* Destroy/Shutdown/Anti-Initializer */
    method public void Destroy().
  
end interface.