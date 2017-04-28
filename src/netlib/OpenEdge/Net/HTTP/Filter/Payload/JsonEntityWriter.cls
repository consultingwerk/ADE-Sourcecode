/************************************************
Copyright (c)  2015-2016 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : JsonEntityWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : - Write() operations are destructive (they replace the existing
                    Entity).
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Memptr.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.
using Progress.Lang.Object.
using Progress.Json.ObjectModel.JsonObject.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.String.
using OpenEdge.Core.WidgetHandle.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Reflect.DataType.

class OpenEdge.Net.HTTP.Filter.Payload.JsonEntityWriter inherits MessageWriter:
    define private variable moParser as ObjectModelParser no-undo.
    
    constructor public JsonEntityWriter():
        super(get-class(JsonConstruct)).
    end constructor. 

	method override public void Open():	   
	    super:Open().
	     
	    assign moParser = new ObjectModelParser().
	end method.
	
    method override public void Close():
        super:Close().
        
        assign moParser = ?.
    end method.
	
    method private void WriteError(input poError as Progress.Lang.Error):
        define variable oResponse as JsonObject no-undo.
        define variable oError as JsonObject no-undo.
        define variable oErrorList as JsonArray no-undo.
        define variable iLoop as integer no-undo.
        define variable cRetVal as character no-undo.
        define variable iMax as integer no-undo.
        define variable oProp as Progress.Reflect.Property no-undo.
        define variable oInner as Progress.Lang.Error no-undo.

        Assert:NotNull(poError, 'Error').
        
        /* build the current error */
         assign oResponse  = new JsonObject()
               oErrorList = new JsonArray()
               iMax       = poError:NumMessages
               .
        if type-of(poError, AppError) then
            oResponse:Add('_retVal':u, cast(poError, AppError):ReturnValue).
        
        oResponse:Add('_errors':u, oErrorList).
        do iLoop = 1 to iMax:
            assign oError = new JsonObject().
            oErrorList:Add(oError).
            
            oError:Add('_errorMsg':u, poError:GetMessage(iLoop)).
            oError:Add('_errorNum':u, poError:GetMessageNum(iLoop)).
        end.
        
        case true:
            // single error? add an simple JSON object
            when not valid-object(this-object:Entity) then
                assign this-object:Entity = oResponse.
            
            // if there's already an array, add to it                
            when type-of(this-object:Entity, JsonArray) then
                cast(this-object:Entity, JsonArray):Add(oResponse).
            
            // if there's a single json object, switch to an array
            when type-of(this-object:Entity, JsonObject) then
            do:
                assign oErrorList = new JsonArray().
                oErrorList:Add(cast(this-object:Entity, JsonObject)).
                oErrorList:Add(oResponse).
                
                assign this-object:Entity = oErrorList.
            end.
        end case.
        
        if session:debug-alert then
            oResponse:Add('_type':u, poError:GetClass():TypeName).
            
        if poError:CallStack ne ? then
        do:
            assign oErrorList = new JsonArray()
                   iMax       = num-entries(poError:CallStack, '~n':u)
                   .
            oResponse:Add('_stack':u, oErrorList).
            do iLoop = 1 to iMax:
                oErrorList:Add(entry(iLoop, poError:CallStack, '~n':u)).
            end.
        end.
        
        assign oProp = poError:GetClass():GetProperty('InnerError':u).
        if valid-object(oProp) and
           oProp:DataType eq DataType:Object and
           Progress.Lang.Class:GetClass(oProp:DataTypeName):IsA(get-class(Progress.Lang.Error)) then
        do:           
            assign oInner = oProp:Get(poError).
            if valid-object(oInner) then
                this-object:WriteError(oInner).
        end.
    end method.
	
    method override public int64 Write(input poData as Object):
        define variable oBody as class Memptr no-undo.
        
        Assert:NotNull(poData).
        
        case true:
            when type-of(poData, Progress.Lang.Error) then
            do:
                WriteError(cast(poData, Progress.Lang.Error)).
                return 0.
            end.
        
            when type-of(poData, Memptr) then
                assign oBody = cast(poData, Memptr).
            
            when type-of(poData, JsonConstruct) then
            do:
                assign this-object:Entity = poData.
                return 0.
            end.
                
            when type-of(poData, ByteBucket) then
                assign oBody = cast(poData, ByteBucket):GetBytes().
            
            when type-of(poData, String) then
                return this-object:Write(cast(poData, String):Value).

            when type-of(poData, WidgetHandle) then
                return this-object:WriteHandle(cast(poData, WidgetHandle):Value).
            
            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                            , 0).
        end case.
        
        if oBody:Size eq 0 then
            assign this-object:Entity = new JsonObject().
        else
            assign this-object:Entity = cast(moParser:Parse(oBody:Value) , JsonConstruct).
        
        return oBody:Size.               
    end method.

	method override public int64 Write(input pcData as longchar):
	    define variable iBytesWritten as integer no-undo.
	    
	    assign iBytesWritten = length(pcData, 'raw':u).
	    
	    Assert:IsZeroOrPositive(iBytesWritten, 'Data').

        if iBytesWritten eq 0 then
            assign this-object:Entity = new JsonObject().
        else
    	    assign this-object:Entity = cast(moParser:Parse(pcData), JsonConstruct).
	    
	    return iBytesWritten.
	end method.

	method override public int64 Write( input pmData as memptr):
        define variable iBytesWritten as integer no-undo.

	    assign iBytesWritten = get-size(pmData).
	    Assert:IsZeroOrPositive(iBytesWritten, 'Data size').
	    
        if iBytesWritten eq 0 then
            assign this-object:Entity = new JsonObject().
        else
	       assign this-object:Entity = cast(moParser:Parse(pmData), JsonConstruct).
        
        return iBytesWritten.
	end method.
	
    /** Write data to/from the message

        @param handle Data to write */
    method public int64 WriteHandle(input phData as handle):
        return this-object:Write(phData).
    end method.
    
    /** Write data to/from the message

        @param handle Data to write */
    method override public int64 Write(input phData as handle):
        define variable lOk as logical no-undo.
        define variable oData as JsonObject no-undo.
        
        Assert:NotNull(phData, 'Data').
        
        case phData:type:
            when DataTypeHelper:GetMask(DataTypeEnum:Buffer) or
            when DataTypeHelper:GetMask(DataTypeEnum:TempTable) or
            when DataTypeHelper:GetMask(DataTypeEnum:Dataset) then
                assign oData = new JsonObject()
                       this-object:Entity = oData
                       lOk = oData:Read(phData)
                       .
                       
            /* this should cater for WEB-CONTEXT and that only. */
            when 'pseudo-widget':u then            
                if lookup('HTML-CHARSET':u, list-query-attrs(phData)) gt 0 then
                    assign this-object:Entity = cast(moParser:Parse(phData), JsonConstruct).
        end case.
        
        return ?.
    end method.

    /** Write data to/from the message

        @param character Data to write */
    method override public int64 Write(input pcData as character):
        define variable iBytesWritten as integer no-undo.
        
        assign iBytesWritten = length(pcData, 'raw':u).
        
        Assert:IsZeroOrPositive(iBytesWritten, 'Data').

        if iBytesWritten eq 0 then
            assign this-object:Entity = new JsonObject().
        else
            assign this-object:Entity = cast(moParser:Parse(pcData), JsonConstruct).
        
        return iBytesWritten.
    end method.    
	
end class.