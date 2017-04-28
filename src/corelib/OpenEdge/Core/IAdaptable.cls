/************************************************
Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : IAdaptable
    Purpose     : General interface for allowing classes to provide adapters
                  via the Adapter design pattern https://en.wikipedia.org/wiki/Adapter_pattern  
    Author(s)   : pjudge
    Created     : 2016-10-12
    Notes       : 
  ----------------------------------------------------------------------*/
interface OpenEdge.Core.IAdaptable:
    
    /* Returns an adapter for this message 
       
       @param P.L.Class The type we want to adapt to
       @return P.L.Object The adapter. SHOULD be of the type specified by the input argument */
    method public Progress.Lang.Object GetAdapter(input poAdaptTo as class Progress.Lang.Class).
    
end interface.