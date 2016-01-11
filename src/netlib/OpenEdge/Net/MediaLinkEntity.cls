/* ***********************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
 *************************************************/ 
/*------------------------------------------------------------------------
    File        : MediaLinkEntity
    Purpose     : Contains links to a media resource, but not the resource itself.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Aug 28 08:58:19 EDT 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.SerializationFormatEnum.
using OpenEdge.Net.MediaLinkEntity.
using OpenEdge.Net.URI.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.

class OpenEdge.Net.MediaLinkEntity serializable:
    /* (optional) The URL (relative or whole) where a Media Resource can be read. */    
    define public property ReadUrl as character no-undo
        get.
        set (input pcReadUrl as character):
            Assert:NotNull(pcReadUrl, 'Media resource read URL').
            assign this-object:ReadUrl = pcReadUrl.
        end set.
    
    /* (optional) The URL (relative or whole) where a Media Resource can be edited (CUD). */
    define public property EditUrl as character no-undo
        get.
        set (input pcEditUrl as character):
            Assert:NotNull(pcEditUrl, 'Media resource edit URL').
            assign this-object:EditUrl = pcEditUrl.
        end set.
    
    /* (optional) A human-readable name for the resource (eg a file name) */
    define public property ResourceName as character no-undo
        get.
        set (input pcResourceName as character):
            Assert:NotNull(pcResourceName, 'Media resource name').
            assign this-object:ResourceName = pcResourceName.
        end set.
    
    /* Constructor.
        
        @param character The read/src (relative) URL for the media resource */
    constructor MediaLinkEntity(input pcReadUrl as character):
        this-object().
        
        assign this-object:ReadUrl = pcReadUrl.
    end method.
    
    /* Constructor.
    
        @param character The read/src (relative) URL for the media resource 
        @param character The edit (relative) URL for the media resource */
    constructor MediaLinkEntity(input pcReadUrl as character,
                                input pcEditUrl as character):
        this-object(pcReadUrl).
        assign this-object:EditUrl = pcEditUrl. 
    end constructor.
        
    /* Constructor.
    
        @param URI The read/src URL for the media resource */
    constructor MediaLinkEntity(input poReadUrl as URI):
        this-object().
        
        Assert:NotNull(poReadUrl, 'Read URI').
        
        assign this-object:ReadUrl = poReadUrl:ToString().
    end method.

    /* Constructor.
    
        @param URI The read/src URL for the media resource 
        @param URI The edit URL for the media resource */
    constructor MediaLinkEntity(input poReadUrl as URI,
                                input poEditUrl as URI):
        this-object(poReadUrl).
        
        Assert:NotNull(poEditUrl, 'Edit URI').
        assign this-object:EditUrl = poEditUrl:ToString().
    end method.

    /* Default constructor. */
    constructor MediaLinkEntity():
    end constructor.
        
    /* Deserializes a MLE into a real object
        
        @param longchar The serialized MLE
        @param SerializationFormatEnum The format in which the MLE is serialized. 
        @return MediaLinkEntity A newly-created MLE */
    method static public MediaLinkEntity Deserialize (input pcMLE as longchar,
                                                      input poSerializedAs as SerializationFormatEnum):
        define variable oMLE as MediaLinkEntity no-undo.
        
        Assert:NotNull(poSerializedAs, 'MLE serialization type').
        Assert:NotNullorEmpty(pcMLE, 'Serialized MLE').
        
        case poSerializedAs:
            when SerializationFormatEnum:Json then
            do:
                define variable oJsonMLE as JsonObject no-undo.
                
                oJsonMLE = cast(new ObjectModelParser():Parse(pcMLE), JsonObject).
                
                assign oMLE = new MediaLinkEntity().
                if oJsonMLE:Has('src':u) then
                do:                
                    assign oMLE:ReadUrl = oJsonMLE:GetCharacter('src':u).

                    if oJsonMLE:Has('name':u) then
                        assign oMLE:ResourceName = oJsonMLE:GetCharacter('name':u).
                end.
                
                if oJsonMLE:Has('edit-media':u) then
                    assign oMLE:EditUrl = oJsonMLE:GetCharacter('edit-media':u).                     
            end.    /* JSON */
            otherwise
                return error new AppError(substitute('Unsupported MLE serialization type &1', string(poSerializedAs))
                                    , 0).
        end case.
        
        return oMLE.
    end method.
    
    /* Serializes a MLE to character. A MLE must have at least a ReadUrl OR an 
       EditUrl in order to be serialised.
       
        @param MediaLinkEntitySerializationTypeEnum How to serialize
        @return longchar The serialized values */
    method public longchar Serialize (input poSerializedAs as SerializationFormatEnum):
        define variable cMLE as longchar no-undo.
        define variable oMLE as JsonObject no-undo.
        
        Assert:NotNull(poSerializedAs, 'MLE serialization type').
        
        /* Cannot have both ReadlUrl and EditURl be empty. Must have ONE */
        if this-object:ReadUrl eq '':u and this-object:EditUrl eq '':u then
            return error new AppError('Either a ReadUrl or EditUrl must be specified', 0).
        
        case poSerializedAs:
            when SerializationFormatEnum:JSON or
            when SerializationFormatEnum:QuotedJSON then
            do:
                assign oMLE = new JsonObject().
                if this-object:ReadUrl ne '':u then
                do:
                    oMLE:Add('src':u, this-object:ReadUrl).
                    if this-object:ResourceName ne '':u then
                        oMLE:Add('name':u, this-object:ResourceName).
                end.
                
                if this-object:EditUrl ne '':u then
                    oMLE:Add('edit-media':u, this-object:EditUrl).
                    
                /* make sure. by spec JSON is utf-8 */
                fix-codepage(cMLE) ='utf-8':u.
                
                assign cMLE = oMLE:GetJsonText().
                
                if poSerializedAs eq SerializationFormatEnum:QuotedJSON then
                    assign cMLE = quoter(cMLE). 
            end.    /*JSON variants */
            otherwise
                return error new AppError(substitute('Unsupported MLE serialization type &1', string(poSerializedAs))
                                    , 0).
        end case.
        
        return cMLE.
    end method.
    
end class.