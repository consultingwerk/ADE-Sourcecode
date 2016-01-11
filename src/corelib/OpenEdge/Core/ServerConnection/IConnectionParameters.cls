/************************************************
Copyright (c)  2013, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : IConnectionParameters
    Purpose     : General conneciton parameter object 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 28 15:07:49 EST 2013
    Notes       : * This class based on the AutoEdge|TheFactory version
  ----------------------------------------------------------------------*/
using OpenEdge.Core.ServerConnection.FormatMaskEnum.

using Progress.Json.ObjectModel.JsonObject.

interface OpenEdge.Core.ServerConnection.IConnectionParameters:
    
    /** The FormatMask property contains a mask to be used together with
        the ABL SUBSTITUTE function. It can include up to 9 substitutions (&1-&9)
        and should also include any key/value pair separators (space, usually). */    
    define public property FormatMask as FormatMaskEnum no-undo get.
    
    /** Returns the Options as a formatted string for use by the server to connect. 
        This may be the the ABL CONNECT statement or some other parameter.  
                        
        @return character A useable string of connection parameters. */
    method public character GetConnectionString().
    
    /** Returns the Options as a formatted string for use by the server to connect. 
        This may be the the ABL CONNECT statement or some other parameter.  
                        
        @param character The format mask to use. Typically overrides the mask
                         specified by the property.
        @return character A useable string of connection parameters. */
    method public character GetConnectionString(input pcFormatMask as character).
    
    /** Returns the Options as a formatted string for use by the server to connect. 
        This may be the the ABL CONNECT statement or some other parameter.  
                        
        @param FormatMaskEnum The format mask to use. Overrides the mask
                              specified by the property.
        @return character A useable string of connection parameters. */
    method public character GetConnectionString(input poFormatMask as FormatMaskEnum).
            
end interface.