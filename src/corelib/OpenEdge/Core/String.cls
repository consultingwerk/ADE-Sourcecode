/************************************************
Copyright (c) 2013-2017 by Progress Software Corporation. All rights reserved.
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

using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.Array.
using OpenEdge.Core.ISupportEncoding.
using Progress.Lang.Object.

/* Don't have a USING for this class, so that we can avoid conflicts with the STRING() ABL keyword/function
using OpenEdge.Core.String.*/

class OpenEdge.Core.String serializable
        implements ILongcharHolder, ISupportEncoding:
    
    // Helper/holder for an empty String instance  
    define static private variable moEmptyString as OpenEdge.Core.String no-undo.
    
    /* Content encoding (eg utf-8) of this string. Defaults to CPINTERNAL if not specified */ 
    define public property Encoding as character no-undo initial ?
        get():
            if this-object:Encoding eq ? then
                return session:cpinternal.
            
            return this-object:Encoding.
        end get.
        set.
    
    /** Contains the actual string value */
    define public property Value as longchar no-undo get. private set.
    
    /** Returns the size of the contained string, in bytes */
    define public property Size as int64 no-undo
        get():
            return length(this-object:Value, 'raw':u).
        end get.
    
    /* Default constructor */
    constructor public String():
        super().        
    end constructor.
    
    /* Constructor 
       
       @param longchar A string value */
    constructor public String(pcString as longchar):
        super().
        
        assign this-object:Value    = pcString
               this-object:Encoding = get-codepage (pcString).
    end constructor.
    
    /* Constructor 
       
       @param longchar A string value */
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
        
    /* Adds the input string to the end of the current string.
       No validation (for unknowns in particular) is done on either 
       string value.
       
       @param longchar A value to append */
    method public void Append(input pcValue as longchar):
        assign this-object:Value = this-object:Value + pcValue. 
    end method.

    /* Adds the input string to the end of the current string.
       No validation (for unknowns in particular) is done on either 
       string value.
       
       @param OpenEdge.Core.String A value to append */
    method public void Append(input poValue as OpenEdge.Core.String):
        assign this-object:Value = this-object:Value + poValue:Value. 
    end method.

    /* Adds the input string to the beginning of the current string.
       No validation (for unknowns in particular) is done on either 
       string value.
       
       @param longchar A value to prepend */
    method public void Prepend(input pcValue as longchar):
        assign this-object:Value = pcValue + this-object:Value. 
    end method.

    /* Adds the input string to the beginning of the current string.
       No validation (for unknowns in particular) is done on either 
       string value.
       
       @param OpenEdge.Core.String A value to prepend */
    method public void Prepend(input poValue as OpenEdge.Core.String):
        assign this-object:Value = poValue:Value + this-object:Value. 
    end method.
    
    /* Indicates whether the string is quoted with either double (") or single (') quotes.
       The first AND last characters must be the same and must either the quote character
       
       @param longchar  A string to check
       @return logical TRUE if the string is non-null and has matching leading and trailing quotes. */    
    method static public logical IsQuoted(input pcValue as longchar):
        if IsQuoted(pcValue, '~"':u) then
            return true.
        
        return IsQuoted(pcValue, "~'":u).
    end method.
    
    /* Indicates whether the string is quoted with the quote character ,
       The first AND last characters must be the same and be the quote character
       
       @param longchar  A string to check
       @param character The quote character
       @return logical TRUE if the string is non-null and has matching leading and trailing quotes. */    
    method static public logical IsQuoted(input pcValue as longchar,
                                          input pcQuote as character):
        // left- and right-trim since this class has a Trim() method and we cannot disambiguate
        if pcValue eq ? or length(right-trim(left-trim(pcValue)), 'character':u) lt 2 then
            return false.
    
        Assert:NotNullOrEmpty(pcQuote, 'Quote character').
        
        return (index(pcValue, pcQuote)   eq 1 and 
                r-index(pcValue, pcQuote) eq length(pcValue, 'character':u)). 
    end method.
    
    method public logical IsNullOrEmpty():
        return OpenEdge.Core.String:IsNullOrEmpty(this-object:Value).
    end method.
    
    /* Indicates whether a string is null or empty: empty having no
       non-whitespace characters
       
       @param longchar The value being checked
       @return logical TRUE if the string is null or empty */
    method static public logical IsNullOrEmpty(input pcValue as longchar):
        define variable iRawLength as integer no-undo.
        
        if pcValue eq ? then
            return true.
            
        assign iRawLength = length(pcValue, 'raw':u).
        
           /* no characters is pretty empty */
        if iRawLength eq 0 or
           /* TRIM converts everything to cpinternal, which may not be able to 'see' all the characters
              that are in the argument. So, if the lengths differ, then there's something that's not a space
              (strong assumption) and we're OK, Jack.
              If the lengths match, we are ok to convert and we try to trim. */
           (iRawLength eq length(pcValue) and right-trim(left-trim(pcValue)) eq '':u) then
            return true.
            
        return false.            
    end method.
    
end class.
