/************************************************
Copyright (c)  2013, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : String
    Purpose     : Primitive class for character/longchar variables
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Aug 11 13:08:46 EDT 2009
    Notes       : * Named 'String' because of keyword/namespace conflicts with
                    ABL Primitive 'character'. There's no built-in class for this.
                  * Initial requirement for collections; having a class for the
                    primitive value means that we don't have to distinguish between
                    primitives and types, which makes the code more readable.
                  * This class based on the AutoEdge|TheFactory version 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.Collections.Array.
using OpenEdge.Core.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

/* Don't have a USING for this class, so that we can avoid conflicts with the STRING() ABL keyword/function
using OpenEdge.Core.String.*/

class OpenEdge.Core.String serializable:
    define static private variable moEmptyString as OpenEdge.Core.String no-undo.
    
    /** Contains the actual string value */
    define public property Value as longchar no-undo get. private set.
    
    /** Returns the size of the contained string, in bytes */
    define public property Size as int64 no-undo
        get():
            return length(this-object:Value, 'raw':u).
        end get.
    
    constructor public String():
        super().        
    end constructor.

    constructor public String(pcString as longchar):
        super().
        assign this-object:Value = pcString.
    end constructor.
    
    constructor public String(pcString as char):
        super().
        assign this-object:Value = pcString.
    end constructor.
    
    method public void Trim():
        /* we can't use the ABL TRIM keyword, since we run into 
           name conflicts, so do a left- and right-trim instead. */
        right-trim(left-trim(this-object:Value)).
    end method.
    
    method static public OpenEdge.Core.String Empty ():
        if not valid-object(moEmptyString) then
            assign moEmptyString = new OpenEdge.Core.String('':u).
        
        return moEmptyString.
    end method.
    
    method override public logical Equals(input p0 as Object):
        if type-of(p0, OpenEdge.Core.String) then
            return (this-object:Value eq cast(p0, OpenEdge.Core.String):Value).
        else
            return super:Equals(p0).    
    end method.
    
    /* Splits: OE.Core.String */
    method public Array Split(input pcDelimiter as character):
        return OpenEdge.Core.String:Split(this-object, pcDelimiter).
    end method.
    
    method public Array Split():
        return OpenEdge.Core.String:Split(this-object).
    end method.
        
    method static public Array Split(input poValue as OpenEdge.Core.String):
        return OpenEdge.Core.String:Split(poValue, ',':u).
    end method.
        
    method static public Array Split(input poValue as OpenEdge.Core.String,
                                     input pcDelimiter as character):
        define variable oArray as Array no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        assign iMax = num-entries(poValue:Value, pcDelimiter)
               oArray = new Array(iMax).
        
        do iLoop = 1 to iMax:
            oArray:Add(new OpenEdge.Core.String(entry(iLoop, poValue:Value, pcDelimiter))).
        end. 
        
        return oArray.
    end method.

    /* Splits: ABL primitives */        
    method static public character extent Split(input pcValue as longchar):
        return OpenEdge.Core.String:Split(pcValue, ',':u).
    end method.
            
    method static public character extent Split(input pcValue as longchar,
                                                input pcDelimiter as character):
        define variable cArray as character extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        assign iMax = num-entries(pcValue, pcDelimiter)
               extent(cArray) = iMax.
        
        do iLoop = 1 to iMax:
            assign cArray[iLoop] = entry(iLoop, pcValue, pcDelimiter).
        end. 
        
        return cArray.
    end method.

    /* Join: OE.Core.String */
    method static public OpenEdge.Core.String Join(input poValue as Array,
                                                   input pcDelimiter as character):
        Assert:IsType(poValue, get-class(OpenEdge.Core.String)).
        return OpenEdge.Core.String:Join(cast(poValue:ToArray(),OpenEdge.Core.String), pcDelimiter).                    
    end method.
    
    method static public OpenEdge.Core.String Join(input poValue as OpenEdge.Core.String extent,
                                                   input pcDelimiter as character):
        define variable cJoinedString as longchar no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = extent(poValue).
        do iLoop = 1 to iMax:
            if iLoop eq 1 then
                assign cJoinedString = poValue[iLoop]:Value.
            else
                assign cJoinedString = cJoinedString + pcDelimiter + poValue[iLoop]:Value.
        end.
        
        return new OpenEdge.Core.String(cJoinedString).
    end method.

    /* Join: ABL primitive */
    method static public longchar Join(input pcValue as character extent,
                                       input pcDelimiter as character):
        define variable cJoinedString as longchar no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.

        iMax = extent(pcValue).
        do iLoop = 1 to iMax:
            if iLoop eq 1 then
                assign cJoinedString = pcValue[iLoop].
            else
                assign cJoinedString = cJoinedString + pcDelimiter + pcValue[iLoop].
        end.

        return cJoinedString.
    end method.
    
    method override public character ToString():
        define variable cValue as character no-undo.
        define variable iLength as integer no-undo.

        assign iLength = length(this-object:Value, 'raw':u).
        /* characters are nominally 32k long, but not always in practice. for values that approach
           exceeding 'about 32k' we'll take the first 30000 bytes or so. the entire value is available
           through the :Value property anyway. */
        if iLength ge 30000 then
            assign cValue = substring(this-object:Value, 1, 29985) + ' <<...MORE...>>':u.
        else
            assign cValue = this-object:Value.

        return cValue.
    end method.
    
    method public void Append(input pcValue as longchar):
        assign this-object:Value = this-object:Value + pcValue. 
    end method.

    method public void Append(input poValue as OpenEdge.Core.String):
        assign this-object:Value = this-object:Value + poValue:Value. 
    end method.
    
end class.
