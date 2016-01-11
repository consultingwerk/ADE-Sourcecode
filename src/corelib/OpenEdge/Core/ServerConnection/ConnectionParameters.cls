/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : ConnectionParameters
    Purpose     : Standard Connection Parameters  
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 28 15:07:49 EST 2013
    Notes       : * The Options property contains JSON data.
                    This Json Data is structured as follows:
                        {"option1":"value1", "option2":"value2", ..., "optionN":"valueN"}
                  * The FormatMask property contains a mask to be used together with
                    the ABL SUBSTITUTE function. It can include up to 9 substitutions (&1-&9)
                    and should also include any key/value pair separators (space, usually).
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.ServerConnection.IConnectionParameters.
using OpenEdge.Core.ServerConnection.ConnectionParameters.
using OpenEdge.Core.ServerConnection.FormatMaskEnum.

using OpenEdge.Core.Assert.

using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError. 

class OpenEdge.Core.ServerConnection.ConnectionParameters 
            implements IConnectionParameters: 
    
    /** A set of options for a Server Connection */
    define protected property Options as JsonObject no-undo get. set.
    
    /* Resolved connection parameters. For use where the Options only need to
       be resolved once. */
    define protected property ResolvedOptions as character no-undo get. set.
    
    /** The FormatMask property contains a mask to be used together with
        the ABL SUBSTITUTE function. It can include up to 9 substitutions (&1-&9)
        and should also include any key/value pair separators (space, usually). */    
    define public property FormatMask as FormatMaskEnum no-undo get. private set.
    
    constructor public ConnectionParameters(input pcOptions as character, input poFormatMask as FormatMaskEnum):
        define variable oOptions as JsonObject no-undo.
        define variable oParser as ObjectModelParser no-undo.
        
        if pcOptions eq '' or pcOptions eq ? then
            oOptions = new JsonObject().
        else
        do: 
            oParser = new ObjectModelParser().
            oOptions = cast(oParser:Parse(pcOptions), JsonObject).
        end.
        
        ShadowConstructor(oOptions, FormatMaskEnum:Default).
    end constructor.
    
    constructor public ConnectionParameters(input poOptions as JsonObject, input poFormatMask as FormatMaskEnum):
        ShadowConstructor(poOptions, poFormatMask).
    end constructor.
    
    /** Shadow constructor for this class. Used instead of a real constructor since some transformations
        have to happen before its called, and since a constructor must be invoked first via SUPER or THIS-OBJECT,
        there's no room for those transformations. 
        
        @param JsonObject     The options in JSON form
        @param FormatMaskEnum The Format mask to use for this connection. */
    method private void ShadowConstructor(input poOptions as JsonObject, poFormatMask as FormatMaskEnum):
        Assert:NotNull(poOptions, 'Options').        
        Assert:NotNull(poFormatMask, 'Format Mask').
        
        this-object:FormatMask = poFormatMask.
        this-object:Options = poOptions.
        
        this-object:Initialise().
    end method.
    
    /** Use this method for setting initial or default values, or other similar actions */
    method protected void Initialise():
    end method.
    
    /** Returns the Options as a formatted string for use by the server to connect. 
        This may be the the ABL CONNECT statement or some other parameter.  
                        
        @return character A useable string of connection parameters. */
    method public character GetConnectionString():
        return GetConnectionString(this-object:FormatMask).
    end method.
    
    /** Returns the Options as a formatted string for use by the server to connect. 
        This may be the the ABL CONNECT statement or some other parameter.  
                        
        @param character The format mask to use. Overrides the mask
                         specified by the property.
        @return character A useable string of connection parameters. */
    method public character GetConnectionString(input pcFormatMask as character):
        if this-object:FormatMask:Equals(FormatMaskEnum:Custom) then
            undo, throw new AppError(
                        substitute('&1 uses a Custom format mask, which cannot be overridden',
                            this-object:GetClass():TypeName)
                        , 0).
        
        return ConnectionParameters:GetConnectionString(this-object:Options, pcFormatMask).
    end method.
    
    /** Returns the Options as a formatted string for use by the server to connect. 
        This may be the the ABL CONNECT statement or some other parameter.  
                        
        @param FormatMaskEnum The format mask to use. Overrides the mask
                              specified by the property.
        @return character A useable string of connection parameters. */
    method public character GetConnectionString(input poFormatMask as FormatMaskEnum):
        Assert:NotNull(poFormatMask, 'Format mask').
        
        if this-object:FormatMask:Equals(FormatMaskEnum:Custom) then
            undo, throw new AppError(
                        substitute('&1 uses a Custom format mask, which cannot be overridden',
                            this-object:GetClass():TypeName)
                        , 0).
        
        return GetConnectionString(poFormatMask:ToString()).
    end method.
    
    /** Returns the Options as a formatted string for use by the server to connect. 
        This may be the the ABL CONNECT statement or some other parameter.  
                        
        @param JsonObject Options in JSON format.
        @param character The format mask to use.
        
        @return character A useable string of connection parameters. */
    method static public character GetConnectionString(input poOptions as JsonObject,
                                                       input pcFormatMask as character):
        define variable cConnectionString as character no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cNames as character extent no-undo.
        
        /* Loop through top-level properties and set as values on mask.
           If there are nested JSON values, ignore and pass in as arguments. */
        cNames = poOptions:GetNames().
        iMax = extent(cNames).
        do iLoop = 1 to iMax:
            case poOptions:GetType(cNames[iLoop]):
                when JsonDataType:String then
                    cConnectionString = cConnectionString
                              + substitute(pcFormatMask,
                                           cNames[iLoop],
                                           poOptions:GetCharacter(cNames[iLoop])).
                otherwise
                    cConnectionString = cConnectionString
                              + substitute(pcFormatMask,
                                           cNames[iLoop],
                                           poOptions:GetJsonText(cNames[iLoop])).
            end case.
        end.
        
        return cConnectionString.
    end method.
    
end class.