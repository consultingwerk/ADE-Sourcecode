/* ***********************************************************/
/* Copyright (c) 2014 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : DataAdminJsonUtil
    Purpose     : json tasks separated to be used by both AbstractfilteredContext and
                  DataAdminContext.
                  
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sat Feb 08 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.DataAdmin.Binding.IDataAdminContext from propath.
using OpenEdge.DataAdmin.Error.DataContextError from propath.
using Progress.Json.ObjectModel.JsonArray from propath.
using Progress.Json.ObjectModel.JsonObject from propath.
using Progress.Json.ObjectModel.ObjectModelParser from propath.
using Progress.Lang.*.


class OpenEdge.DataAdmin.Binding.DataAdminJsonUtil: 
      
    /* single table import of delete (flat - no tree)*/
    method public void ImportDelete(pcntxt as IDataAdminContext, pcfile as char):
        define variable json  as JsonObject no-undo.
        define variable array as JsonArray  no-undo.
        json = ReadJsonFile(pcfile).
        do on error undo, leave:
            array = json:GetJsonArray(pcntxt:SerializeName).
            catch e as Progress.Lang.Error :
                /* Ignore 16060, which is thrown if the object is not an array */
                if e:GetMessageNum(1) <> 16060 then
                    undo, throw e.
            end catch.
        end.
        if valid-object(array) then
            DeleteFromJsonArray(pcntxt,array).
        else
            DeleteFromJson(pcntxt,json).
    end method.
    
    method public JsonObject ReadJsonFile (pcFile as char):
        define variable parser as ObjectModelParser no-undo.
        define variable json as JsonObject no-undo.
        parser = new ObjectModelParser().
        return cast(parser:ParseFile(pcfile),JsonObject).
    end method.
    
     /* delete from json array - single key array  */
    method private void DeleteFromJsonArray(pcntxt as IDataAdminContext, parray as JsonArray):
        define variable cKey as character no-undo.
        define variable iKey as integer no-undo.
        define variable i as integer no-undo.
        define variable lOK as logical no-undo.
        
        do i = 1 to parray:Length:
            lok = false.
            do on error undo, throw:
                cKey = parray:GetCharacter(i).
                lok = true.
                catch e as Progress.Lang.Error :
                    /* Ignore 16060, which is thrown if the json is of different type  */
                    if e:GetMessageNum(1) <> 16060 then 
                        undo, throw e.
                end catch.
            end.
            if lok then
            do:
                lOK = pcntxt:Delete(cKey).      
                if not lok then 
                    undo, throw new DataContextError(DeleteFailedMessage(pcntxt,ckey)) .   
            end.
            else do:
                iKey = parray:GetInteger(i).
                lOK = pcntxt:Delete(iKey).    
                if not lok then 
                    undo, throw new DataContextError(DeleteFailedMessage(pcntxt,ikey)) .   
             end.    
        end. 
    end method.
    
    /* delete from json array - single key array  */
    method private void DeleteFromJson(pcntxt as IDataAdminContext, pjson as JsonObject):
        define variable cKey as character no-undo.
        define variable iKey as integer no-undo.
        define variable i as integer no-undo.
        define variable lOK as logical no-undo.
        
        do on error undo, throw:
            cKey = pjson:GetCharacter(pcntxt:SerializeName).
            lok = true.
            catch e as Progress.Lang.Error :
                /* Ignore 16060, which is thrown if the json is of different type  */
                if e:GetMessageNum(1) <> 16060 then 
                    undo, throw e.
            end catch.
        end.
        if lok then
        do:
            lOK = pcntxt:Delete(cKey).      
            if not lok then 
                undo, throw new DataContextError(DeleteFailedMessage(pcntxt,ckey)) .   
        end.
        else do:
            iKey = pjson:GetInteger(pcntxt:SerializeName).
            lOK = pcntxt:Delete(iKey).    
            if not lok then 
                undo, throw new DataContextError(DeleteFailedMessage(pcntxt,ikey)) .   
        end.    
       
    end method.
    
    method private char DeleteFailedMessage(pcntxt as IDataAdminContext, ckey as char):
        return DeleteFailedMessage(pcntxt:Name,quoter(cKey),pcntxt:Find(ckey)).
    end.    
      
    method private char DeleteFailedMessage(pcntxt as IDataAdminContext, ikey as int):
        return DeleteFailedMessage(pcntxt:Name,string(iKey),pcntxt:Find(ikey)).
    end.    
    
    method private char DeleteFailedMessage(pcname as char,ckey as char,pFound as log):
        if not pFound  then 
            return "Delete failed. " + pcname + " " +  ckey  + " was not found.".   
        else
            return "Delete of " + pcname + " " +  ckey  + " failed"  .   
    end.   
end class.