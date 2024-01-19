/************************************************
Copyright (c) 2013-2020, 2022-2023 by Progress Software Corporation. All rights reserved.
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
                  * There are different CompareTo implementations since
                    we can optimise for String objects by looking at the private
                    variable value; for ILongcharHolder we need to get the Value
                    property value.
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.Array.
using OpenEdge.Core.ISupportEncoding.
using OpenEdge.Core.StringConstant.
using Progress.Collections.IComparable.
using Progress.Collections.IHashable.
using Progress.Lang.Object.

/* Don't have a USING for this class, so that we can avoid conflicts with the STRING() ABL keyword/function
using OpenEdge.Core.String.*/

class OpenEdge.Core.String
serializable
implements ILongcharHolder
         , ISupportEncoding
         // Support comparision between either LongcharHolder or other String objects
         , IComparable<ILongcharHolder>
         , IComparable<OpenEdge.Core.String>
         , IHashable
:

    /* Helper/holder for an empty String instance.  */
    define static private variable moEmptyString as OpenEdge.Core.String no-undo.

    /* Helper/holder for an unknown value String instance.  */
    define static private variable mUnknownString as OpenEdge.Core.String no-undo.

    /* Holds the actual value, in UTF-8. UTF-8 can hold pretty much all characters, so let's be smart and use that.
       SERIALIZABLE since this is the actual value 'holder' */
    define private serializable variable mUTF8Value as longchar no-undo.

    /* Content encoding (eg utf-8) of this string. Defaults to CPINTERNAL if not specified */
    define public property Encoding as character no-undo get. set.

    /** Contains the actual string value. Marked as NON-SERIALIZABLE since the actual value is derived,
        and stored in the private mUTF8Value variable */
    define final public non-serializable property Value as longchar no-undo
        get():
            // no need for changes if we're using UTF-8 as CPINTERNAL
            if this-object:Encoding eq 'UTF-8':u then
                return mUTF8Value.
            else
                return codepage-convert(mUTF8Value, this-object:Encoding).
        end get.

    /** Returns the size of the contained string, in characters */
    define final public non-serializable property Size as int64 no-undo
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
               this-object:Encoding = get-codepage(pcString)
               .
    end constructor.

    /* Constructor

       @param longchar A string value */
    constructor public String(input pcString as character):
        this-object().

        assign mUTF8Value = pcString.
    end constructor.

    /** Trims whitespace off the contained string */
    method public void Trim():
        /* we can't use the ABL TRIM keyword, since we run into
           name conflicts, so do a left- and right-trim instead. */
        assign mUTF8Value = right-trim(left-trim(mUTF8Value)).
    end method.

    /** Trims the specified character off the contained string

        @param character The non-null character to trim */
    method public void Trim(input pCharacter as character):
        Assert:NotNull(pCharacter, 'Trim character').

        /* we can't use the ABL TRIM keyword, since we run into
           name conflicts, so do a left- and right-trim instead. */
        assign mUTF8Value = right-trim(left-trim(mUTF8Value, pCharacter), pCharacter).
    end method.

    /* Returns a single/the same empty/non-null String object.

       @return OpenEdge.Core.String An empty string */
    method static public OpenEdge.Core.String Empty ():
        if not valid-object(moEmptyString) then
            assign moEmptyString = new OpenEdge.Core.String().

        return moEmptyString.
    end method.

    /* Returns a single/the same unknown value String object.

       @return OpenEdge.Core.String An empty string */
    method static public OpenEdge.Core.String Unknown():
        if not valid-object(mUnknownString) then
            assign mUnknownString = new OpenEdge.Core.String(StringConstant:UNKNOWN).

        return mUnknownString.
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
        multiple delimiters from the input character extent array.

        @param character[] A character extent that holds multiple delimters used to split the string
        @return Array  An array object of strings */
    method public Array Split(input pcDelimiter as character extent):
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

        If the delimiter does not appear in the string, and the string is not unknown,
        then the array has an extent of 1 and contains the string.

        @param OpenEdge.Core.String A value to split
        @param character A delimter used to split the string
        @return Array  An array object of strings */
    method static public Array Split(input poValue as OpenEdge.Core.String,
                                     input pcDelimiter as character):
        define variable oArray as Array no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.

        Assert:NotNull(pcDelimiter, 'Delimiter').

        assign iMax = num-entries(poValue:mUTF8Value, pcDelimiter).
        if iMax eq ? then
            return oArray.

        assign oArray = new Array(iMax).

        if iMax eq 0 then
            oArray:Add(poValue).

        do iLoop = 1 to iMax:
            oArray:SetValue(new OpenEdge.Core.String(entry(iLoop, poValue:mUTF8Value, pcDelimiter)), iLoop).
        end.

        return oArray.
    end method.

    /** Splits the value of this string object into an array using
        multiple specified delimiters.

        If all the delimiters in the input character extent do not appear in the string, 
        and the string is not unknown, then the returned array has an extent of 1 and 
        contains the String.

        @param OpenEdge.Core.String A value to split
        @param character[] A character extent with mulitple delimiters used to split the string
        @return Array  An array object of strings */
    method static public Array Split(input poValue as OpenEdge.Core.String,
                                     input pcDelimiter as character extent):

        var Array oArray.
        var integer iLoop, iMax, iFound.
        var longchar pcValue.
        
        Assert:NotNull(pcDelimiter, 'Delimiter').
        
        pcValue = poValue:ToString().
        
        // check each delimiter sent in character extent
        LOOPBLK:
        do iLoop = 1 to extent(pcDelimiter):
            if pcDelimiter[iLoop] eq ? then
                next LOOPBLK.
            // If the delimiter is found in the input String replace with unit separator
            if index(pcValue,pcDelimiter[iLoop]) ne 0 then do:
                // StringConstant:US or chr(31) is used as a common delimiter that should not be in the
                // input longchar.
                assign pcValue = replace(pcValue,pcDelimiter[iLoop],StringConstant:US).
            end.
        end.

        // if no delimiter then num-entries = 1, which will return entire string in extent 1.
        iFound = num-entries(pcValue,StringConstant:US).

        // assign the size of the return array based on the num-entries put in iFound
        // and load each piece of the input String into an element of the return Array. 
        assign oArray = new Array(iFound).
        do iLoop = 1 to iFound:
            oArray:SetValue(new OpenEdge.Core.String(entry(iLoop, pcValue, StringConstant:US)), iLoop).
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
        a specified delimiter.

        If the delimiter does not appear in the string, and the string is not unknown,
        then the array has an extent of 1 and contains the string.

        @param longchar A value to split
        @param character A delimter used to split the string
        @return character[] An array of strings */
    method static public character extent Split(input pcValue as longchar,
                                                input pcDelimiter as character):
        define variable cArray as character extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.

        Assert:NotNull(pcDelimiter, 'Delimiter').

        assign iMax = num-entries(pcValue, pcDelimiter).
        if iMax eq ? then
            return cArray.

        if iMax eq 0 then
            {&_proparse_ prolint-nowarn(overflow)}
            assign extent(cArray) = 1
                   // this should only happen of value and delimiter are empty
                   cArray[1]      = pcValue
                   .
        else
            assign extent(cArray) = iMax.
        do iLoop = 1 to iMax:
            assign cArray[iLoop] = entry(iLoop, pcValue, pcDelimiter).
        end.

        return cArray.
    end method.

    /** Splits the value of this string into a character extent using
        multiple specified delimiters.

        If all the delimiters in the input character extent do not appear in the longchar var, 
        and the string is not unknown, then the returned extent/array has an extent of 1 
        and contains the longchar in character[1].

        @param longchar A value to split
        @param character[] A character extent with mulitple delimiters used to split the string
        @return character[] An extent array of longchar values */
    method static public character extent Split(input pcValue as longchar,
                                                input pcDelimiter as character extent):

        var character[] cArray.
        var character cDelim.
        var integer iLoop, iFound.

        Assert:NotNull(pcDelimiter, 'Delimiter').
        
        // check each delimiter sent in character extent
        LOOPBLK:
        do iLoop = 1 to extent(pcDelimiter):
            if pcDelimiter[iLoop] eq ? then
                next LOOPBLK.
            // If the delimiter is found in the input longchar replace with unit separator
            if index(pcValue,pcDelimiter[iLoop]) ne 0 then do:
                // StringConstant:US or chr(31) is used as a common delimiter that should not be in the
                // input longchar.
                assign pcValue = replace(pcValue,pcDelimiter[iLoop],StringConstant:US).
            end.
        end.
        // if no delimiter then num-entries = 1, which will return entire string in extent 1.
        iFound = num-entries(pcValue,StringConstant:US).
        
        // assign the size of the return character extent based on the num-entries put in iFound
        // and load each piece of the input longchar into the return char extents. 
        assign extent(cArray) = iFound.
        do iLoop = 1 to iFound:
            assign cArray[iLoop] = entry(iLoop, pcValue,StringConstant:US).
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
            {&_proparse_ prolint-nowarn(overflow)}
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
        if int64(this-object) eq int64(moEmptyString)
        or int64(this-object) eq int64(mUnknownString)
        then
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
        if int64(this-object) eq int64(moEmptyString)
        or int64(this-object) eq int64(mUnknownString)
        then
            return.

        assign mUTF8Value = mUTF8Value  + poValue:mUTF8Value.
    end method.

    /* Adds the input string to the beginning of the current string.
       No validation (for unknowns in particular) is done on either
       string value.

       @param longchar A value to prepend */
    method public void Prepend(input pcValue as longchar):
        // no-op allowed on the special Empty string. don't use the Equals()
        // overload cos it checks values first
        if int64(this-object) eq int64(moEmptyString)
        or int64(this-object) eq int64(mUnknownString)
        then
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
        if int64(this-object) eq int64(moEmptyString)
        or int64(this-object) eq int64(mUnknownString)
        then
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
    method static public logical IsQuoted (input pcValue as longchar,
                                           input pcQuote as character):
        // left- and right-trim since this class has a Trim() method and we cannot disambiguate
        if pcValue eq ? or length(right-trim(left-trim(pcValue)), 'character':u) lt 2 then
            return false.

        Assert:NotNullOrEmpty(pcQuote, 'Quote character').

        return (index(pcValue, pcQuote)   eq 1 and
                r-index(pcValue, pcQuote) eq length(pcValue, 'character':u)).
    end method.

    method public logical IsNullOrEmpty ( ):
        return OpenEdge.Core.String:IsNullOrEmpty(mUTF8Value).
    end method.

    /* Indicates whether a string is null or empty: empty having no
       non-whitespace characters

       @param longchar The value being checked
       @return logical TRUE if the string is null or empty */
    method static public logical IsNullOrEmpty (input pcValue as longchar):
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

    /* Comparison method, used by SortedSet's default comparer. This method uses the Value property to compare.

       - If the returned value is less than 0 (zero), then the current object sorts before the object passed in.
       - If the returned value equals 0 (zero) , then the current object occupies the same position in the sort order.
       - If the returned value is greater than 0(zero), then the current object sorts after the object passed in.
       - If either object's Value is the unknown value (?), then that sorts high/early/before

       @param ILongcharHolder The object to compare to.
       @return integer  0 = same object
                       +1 = sorts after
                       -1 = sorts before   */
    method public integer CompareTo (input pOther as ILongcharHolder):
        Assert:NotNull(pOther, 'CompareTo object').

        if this-object:Value eq pOther:Value then
            return  0.
        else
        if this-object:Value gt pOther:Value
        or pOther:Value eq ?
        then
            return +1.
        else
        if this-object:Value lt pOther:Value
        or this-object:Value eq ?
        then
            return -1.
    end method.

    /* Comparison method, used by SortedSet's default comparer.

       Due to the ABL's "class private" rules, instances of String can read each others private variables/properties,
       which avoied the Value property getter work.

       - If the returned value is less than 0 (zero), then the current object sorts before the object passed in.
       - If the returned value equals 0 (zero) , then the current object occupies the same position in the sort order.
       - If the returned value is greater than 0(zero), then the current object sorts after the object passed in.
       - If either object's Value is the unknown value (?), then that sorts high/early/before

       @param OpenEdge.Core.String The object to compare to.
       @return integer  0 = same object
                       +1 = sorts after
                       -1 = sorts before   */
    method public integer CompareTo (input pOther as OpenEdge.Core.String):
        Assert:NotNull(pOther, 'CompareTo object').

        if mUTF8Value eq pOther:mUTF8Value then
            return  0.
        else
        if mUTF8Value gt pOther:mUTF8Value
        or pOther:mUTF8Value eq ?
        then
            return +1.
        else
        if mUTF8Value lt pOther:mUTF8Value
        or mUTF8Value eq ?
        then
            return -1.
    end method.

    /* Hashing method for creating a proper index for use with Progress.Collections.HashMap

        @return integer Result of the hash-code method using this object's comparable value(s) */
    method public integer HashCode ( ):
        // In order to create a meaningful hash for an object instance,
        // we should follow suite with how the Equals() logic works.
        // By using the full class name plus the object's comparable value(s)
        // this should be consistent for any instance of this object type.

        // Use the private variable 'mUTF8Value' which is the internal,
        // converted string value.
        // Note: By default hash-code treats values as case-insensitive.
        return hash-code(this-object:GetClass():TypeName, this-object:Encoding, mUTF8Value).
    end method.

end class.

