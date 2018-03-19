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
using OpenEdge.Core.StringConstant.
using Progress.Lang.Object.

/* Don't have a USING for this class, so that we can avoid conflicts with the STRING() ABL keyword/function
using OpenEdge.Core.String.*/

class OpenEdge.Core.String serializable
        implements ILongcharHolder, ISupportEncoding:
    
    /* Helper/holder for an empty String instance.  */  
    define static private variable moEmptyString as OpenEdge.Core.String no-undo.
    
    // holds the actual value, in UTF-8. UTF-8 can hold pretty much all characters, so let's be smart and use that
    define private variable mUTF8Value as longchar no-undo.
    
    /* Content encoding (eg utf-8) of this string. Defaults to CPINTERNAL if not specified */ 
    define public property Encoding as character no-undo get. set.
    
    /** Contains the actual string value */
    define public property Value as longchar no-undo
        get():
            // always deallocate/reset/clear
            assign this-object:Value = ?.
            
            // no need for changes if we're using UTF-8 as CPINTERNAL
            if get-codepage(mUTF8Value) eq this-object:Encoding then
                return mUTF8Value.
            else
            do:
                fix-codepage(this-object:Value) = this-object:Encoding.
                
                assign this-object:Value = mUTF8Value.
                
                return this-object:Value.
            end.
        end get.
        private set.
    
    /** Returns the size of the contained string, in characters */
    define public property Size as int64 no-undo
        get():
            return length(mUTF8Value).
        end get.
    
    /* Default constructor */
    constructor public String():
        super().
        
        fix-codepage(mUTF8Value) = 'UTF-8':u.
        assign mUTF8Value           = '':u
               this-object:Encoding = session:cpinternal
               .
    end constructor.
    
    /* Constructor 
       
       @param longchar A string value */
    constructor public String(input pcString as longchar):
        this-object().
        
        assign mUTF8Value           = pcString
               this-object:Encoding = get-codepage (pcString)
               .
    end constructor.
    
    /* Constructor 
       
       @param longchar A string value */
    constructor public String(input pcString as char):
        this-object().
        
        assign mUTF8Value = pcString.
    end constructor.
    
    /** Trims whitespace off the contained string */
    method public void Trim():
        /* we can't use the ABL TRIM keyword, since we run into 
           name conflicts, so do a left- and right-trim instead. */
        right-trim(left-trim(mUTF8Value)).
    end method.
    
    /** Trims the specified character off the contained string
        
        @param character The non-null character to trim */
    method public void Trim(input pCharacter as character):
        Assert:NotNull(pCharacter, 'Trim character').
        
        /* we can't use the ABL TRIM keyword, since we run into 
           name conflicts, so do a left- and right-trim instead. */
        right-trim(left-trim(mUTF8Value, pCharacter), pCharacter).
    end method.
    
    /* Returns a single/the same empty/non-null String object.
       
       @return OpenEdge.Core.String An empty string */
    method static public OpenEdge.Core.String Empty ():
        if not valid-object(moEmptyString) then
            assign moEmptyString = new OpenEdge.Core.String().
        
        return moEmptyString.
    end method.
    
    method override public logical Equals(input p0 as Object):
        if type-of(p0, OpenEdge.Core.String) then
            return (mUTF8Value eq cast(p0, OpenEdge.Core.String):mUTF8Value).
        else
            return super:Equals(p0).
    end method.
    
    /** Splits the value of this string into an array based on 
        a specified delimiter
        
        @param character A delimter used to split the string
        @return Array  An array object of strings */
    method public Array Split(input pcDelimiter as character):
        return OpenEdge.Core.String:Split(this-object, pcDelimiter).
    end method.
    
    /** Splits the value of this string into an array based on 
        a default delimiter
        
        @return Array  An array object of strings */
    method public Array Split():
        return OpenEdge.Core.String:Split(this-object).
    end method.
        
    /** Splits the value of this string into an array using
        a default delmiter 
        
        @param OpenEdge.Core.String A value to split
        @return Array  An array object of strings */
    method static public Array Split(input poValue as OpenEdge.Core.String):
        return OpenEdge.Core.String:Split(poValue, ',':u).
    end method.
    
    /** Splits the value of this string into an array using
        a specified delmiter 
        
        @param OpenEdge.Core.String A value to split
        @param character A delimter used to split the string
        @return Array  An array object of strings */
    method static public Array Split(input poValue as OpenEdge.Core.String,
                                     input pcDelimiter as character):
        define variable oArray as Array no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        assign iMax = num-entries(poValue:mUTF8Value, pcDelimiter)
               oArray = new Array(iMax)
               .
        do iLoop = 1 to iMax:
            oArray:SetValue(new OpenEdge.Core.String(entry(iLoop, poValue:mUTF8Value, pcDelimiter)),
                            iLoop).
        end.
        
        return oArray.
    end method.
    
    // Splits: ABL primitives
    
    /** Splits the value of this string into an array using
        a default delmiter 
        
        @param longchar A value to split
        @return character[] An array of strings */
    method static public character extent Split(input pcValue as longchar):
        return OpenEdge.Core.String:Split(pcValue, ',':u).
    end method.
            
    /** Splits the value of this string into an array using
        a specified delimiter 
        
        @param longchar A value to split
        @param character A delimter used to split the string
        @return character[] An array of strings */
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
    /** Joins an array's contents into a delimited string
        
        @param Array An array object containing of OpenEdge.Core.String objects
        @param character The delimiter used to join them
        @return OpenEdge.Core.String A single, delimited string object */
    method static public OpenEdge.Core.String Join(input poValue as Array,
                                                   input pcDelimiter as character):
        Assert:IsType(poValue, get-class(OpenEdge.Core.String)).
        return OpenEdge.Core.String:Join(cast(poValue:ToArray(), OpenEdge.Core.String), pcDelimiter).                    
    end method.
    
    /** Joins an array's contents into a delimited string
        
        @param OpenEdge.Core.String[] An array of OpenEdge.Core.String objects to join
        @param character The delimiter used to join them
        @return OpenEdge.Core.String A single, delimited string object */
    method static public OpenEdge.Core.String Join(input poValue as OpenEdge.Core.String extent,
                                                   input pcDelimiter as character):
        define variable cJoinedString as longchar no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = extent(poValue).
        do iLoop = 1 to iMax:
            if iLoop eq 1 then
                assign cJoinedString = poValue[iLoop]:mUTF8Value.
            else
                assign cJoinedString = cJoinedString + pcDelimiter + poValue[iLoop]:mUTF8Value.
        end.
        
        return new OpenEdge.Core.String(cJoinedString).
    end method.

    /* Join: ABL primitive */
    /** Joins an array's contents into a delimited string
        
        @param character[] An array of character values to join
        @param character The delimiter used to join them
        @return longchar A single, delimited string */
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
    
    /** Returns a string value for this object
       
        @return character A string representation of this object. May be truncated. */
    method override public character ToString():
        define variable cValue as character no-undo.
        
        /* characters are nominally 32k long, but not always in practice. for values that approach
           exceeding 'about 32k' we'll take the first 30000 bytes or so. the entire value is available
           through the :Value property anyway. */
        if this-object:Size ge 30000 then
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
        // no-op allowed on the special Empty string. don't use the Equals() 
        // overload cos it checks values first
        if int64(this-object) eq int64(moEmptyString) then
            return.
        
        assign mUTF8Value = mUTF8Value + pcValue.
    end method.
    
    /* Adds the input string to the end of the current string.
       No validation (for unknowns in particular) is done on either 
       string value.
       
       @param OpenEdge.Core.String A value to append */
    method public void Append(input poValue as OpenEdge.Core.String):
        // no-op allowed on the special Empty string. don't use the Equals() 
        // overload cos it checks values first
        if int64(this-object) eq int64(moEmptyString) then
            return.
        
        assign mUTF8Value = mUTF8Value  + poValue:mUTF8Value . 
    end method.

    /* Adds the input string to the beginning of the current string.
       No validation (for unknowns in particular) is done on either 
       string value.
       
       @param longchar A value to prepend */
    method public void Prepend(input pcValue as longchar):
        // no-op allowed on the special Empty string. don't use the Equals() 
        // overload cos it checks values first
        if int64(this-object) eq int64(moEmptyString) then
            return.
        
        assign mUTF8Value = pcValue + mUTF8Value.
    end method.

    /* Adds the input string to the beginning of the current string.
       No validation (for unknowns in particular) is done on either 
       string value.
       
       @param OpenEdge.Core.String A value to prepend */
    method public void Prepend(input poValue as OpenEdge.Core.String):
        // no-op allowed on the special Empty string. don't use the Equals() 
        // overload cos it checks values first
        if int64(this-object) eq int64(moEmptyString) then
            return.
        
        assign mUTF8Value = poValue:mUTF8Value + mUTF8Value. 
    end method.
    
    /* Indicates whether the string is quoted with either double (") or single (') quotes.
       The first AND last characters must be the same and must either the quote character
       
       @param longchar  A string to check
       @return logical TRUE if the string is non-null and has matching leading and trailing quotes. */    
    method static public logical IsQuoted(input pcValue as longchar):        
        if IsQuoted(pcValue, StringConstant:DOUBLE_QUOTE) then
            return true.
        
        return IsQuoted(pcValue, StringConstant:SINGLE_QUOTE).
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
        return OpenEdge.Core.String:IsNullOrEmpty(this-object:mUTF8Value).
    end method.
    
    /* Indicates whether a string is null or empty: empty having no
       non-whitespace characters
       
       @param longchar The value being checked
       @return logical TRUE if the string is null or empty */
    method static public logical IsNullOrEmpty(input pcValue as longchar):
        define variable iRawLength as int64 no-undo.
        
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

