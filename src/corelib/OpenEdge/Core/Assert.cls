/************************************************
Copyright (c) 2013-2020 by Progress Software Corporation 
and/or one of its subsidiaries or affiliates. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : Assert
    Purpose     : General assertions of truth. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 03 10:08:57 EST 2010
    Notes       : * This version based on the AutoEdge|TheFactory version 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertArray.
using OpenEdge.Core.Assertion.AssertObject.
using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.DataTypeEnum.
using Progress.Lang.Object.

class OpenEdge.Core.Assert:
    
    method public static void Equals(input a as Object, input b as Object):
        AssertObject:Equals(a, b).
    end method.
    
    method public static void Equals(input a as rowid, input b as rowid):
        define variable failMessage as character no-undo.
        if not a = b then
        do:
            failMessage = substitute("Expected: &1 but was: &2", a, b).
            return error new AssertionFailedError(failMessage, 0).
        end.        
    end method.
    
    method public static void Equals(input a as recid, input b as recid):
        define variable failMessage as character no-undo.
        if not a = b then
        do:
            failMessage = substitute("Expected: &1 but was: &2", a, b).
            return error new AssertionFailedError(failMessage, 0).
        end.        
    end method.
    
    method public static void Equals(input a as handle, input b as handle):
        define variable failMessage as character no-undo.
        if not a = b then
        do:
            failMessage = substitute("Expected: &1 but was: &2", a, b).
            return error new AssertionFailedError(failMessage, 0).
        end.        
    end method.
    
    method public static void Equals(input a as longchar, input b as longchar):
        define variable failMessage as character no-undo.
        if not a = b then
        do:
            failMessage = substitute("Expected: &1 but was: &2", a, b).
            return error new AssertionFailedError(failMessage, 0).
        end.        
    end method.
    
    method public static void Equals(input a as decimal, input b as decimal):
        define variable failMessage as character no-undo.
        if not a = b then
        do:
            failMessage = substitute("Expected: &1 but was: &2", a, b).
            return error new AssertionFailedError(failMessage, 0).
        end.        
    end method.
    
    method public static void Equals(input a as int64, input b as int64):
        define variable failMessage as character no-undo.
        if not a = b then
        do:
            failMessage = substitute("Expected: &1 but was: &2", a, b).
            return error new AssertionFailedError(failMessage, 0).
        end.        
    end method.
    
    method public static void Equals(input a as integer, input b as integer):
        define variable failMessage as character no-undo.
        if not a = b then
        do:
            failMessage = substitute("Expected: &1 but was: &2", a, b).
            return error new AssertionFailedError(failMessage, 0).
        end.
    end method.

    method public static void Equals(input a as character, input b as character):
        define variable failMessage as character no-undo.
        if not a = b then
        do:
            failMessage = substitute("Expected: &1 but was: &2", a, b).
            return error new AssertionFailedError(failMessage, 0).
        end.
    end method.

    method public static void Equals(input a as date, input b as date):
        if not a eq b then
            return error new AssertionFailedError(
                            substitute("Expected: &1 but was: &2", a, b), 
                                0).
    end method.

    method public static void Equals(input a as datetime, input b as datetime):
        if not a eq b then
            return error new AssertionFailedError(
                            substitute("Expected: &1 but was: &2", a, b), 
                                0).
    end method.

    method public static void Equals(input a as datetime-tz, input b as datetime-tz):
        if not a eq b then
            return error new AssertionFailedError(
                            substitute("Expected: &1 but was: &2", a, b), 
                                0).
    end method.
    
    method public static void Equals(input a as logical, input b as logical):
        if not a eq b then
            return error new AssertionFailedError(
                            substitute("Expected: &1 but was: &2", a, b), 
                                0).
    end method.
    
    method public static void NotEqual(input a as character, input b as character):
        if a eq b then
            return error new AssertionFailedError(substitute('&1 and &2 are equal', a, b), 0).
    end method.

    method public static void NotEqual(input a as decimal, input b as decimal):
        if a eq b then
            return error new AssertionFailedError(substitute('&1 and &2 are equal', a, b), 0).
    end method.

    method public static void NotEqual(input a as handle, input b as handle):
        if a eq b then
            return error new AssertionFailedError(substitute('&1 and &2 are equal', a, b), 0).
    end method.

    method public static void NotEqual(input a as int64, input b as int64):
        if a eq b then
            return error new AssertionFailedError(substitute('&1 and &2 are equal', a, b), 0).
    end method.

    method public static void NotEqual(input a as integer, input b as integer):
        if a eq b then
            return error new AssertionFailedError(substitute('&1 and &2 are equal', a, b), 0).
    end method.

    method public static void NotEqual(input a as longchar, input b as longchar):
        if a eq b then
            return error new AssertionFailedError(substitute('&1 and &2 are equal', a, b), 0).
    end method.

    method public static void NotEqual(input a as Object, input b as Object):
        AssertObject:NotEqual(a, b).
    end method.

    method public static void NotEqual(input a as recid, input b as recid):
        if a eq b then
            return error new AssertionFailedError(substitute('&1 and &2 are equal', a, b), 0).
    end method.

    method public static void NotEqual(input a as rowid, input b as rowid):
        if a eq b then
            return error new AssertionFailedError(substitute('&1 and &2 are equal', a, b), 0).
    end method.

    method public static void IsTrue(input a as logical):
        if not (a eq true) then
            return error new AssertionFailedError(substitute("Expected: TRUE but was: &1", a), 0).
    end method.

   method public static void IsFalse(input a as logical):
        if not (a eq false) then
            return error new AssertionFailedError(substitute("Expected: FALSE but was: &1", a), 0).
    end method.

    method public static void NotNull(input poArgument as Object , pcName as char):
        AssertObject:NotNull(poArgument, pcName).
    end method.

    method public static void NotNull(input poArgument as Object):
        NotNull(poArgument, "argument").
    end method.
    
    method public static void IsNull(input poArgument as Object , input pcName as character):
        AssertObject:IsNull(poArgument, pcName).
    end method.

    method public static void IsNull(input poArgument as Object):
        IsNull(poArgument, "argument").
    end method.
    
    method public static void NotNull(input poArgument as Object extent, pcName as char):
        AssertObject:NotNull(poArgument, pcName).
    end method.

    method public static void NotNull(input poArgument as Object extent):
        NotNull(poArgument, "argument").
    end method.
    
    method public static void IsNull(input poArgument as Object extent, pcName as char):
        AssertObject:IsNull(poArgument, pcName).
    end method.
    
    method public static void IsNull(input poArgument as Object extent):
        IsNull(poArgument, "argument").
    end method.
    
    method public static void NotNull(pcArgument as character, pcName as character):
        if pcArgument eq ? then 
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown', pcName), 0).
    end method.

    method public static void NotNull(pcArgument as character):
        NotNull(pcArgument, "argument").
    end method.

    method public static void NotNull(prArgument as raw, pcName as character):
        if prArgument eq ? then 
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown', pcName), 0).
    end method.

    method public static void NotNull(prArgument as raw):
        NotNull(prArgument, 'argument').
    end method.

    method public static void IsNull(prArgument as raw, pcName as character):
        if prArgument ne ? then 
            undo, throw new AssertionFailedError(substitute('&1 must be unknown', pcName), 0).
    end method.

    method public static void IsNull(prArgument as raw):
        IsNull(prArgument, 'argument').
    end method.
    
    method public static void IsNull(input pcArgument as character, input pcName as character):
        if pcArgument ne ? then 
            undo, throw new AssertionFailedError(substitute('&1 must be unknown', pcName), 0).
    end method.
    
    method public static void IsNull(input pcArgument as character):
        IsNull(pcArgument, "argument").
    end method.
    
    method public static void IsNull(input pcArgument as longchar, input pcName as character):
        if pcArgument ne ? then 
            undo, throw new AssertionFailedError(substitute('&1 must be unknown', pcName), 0).
    end method.
    
    method public static void IsNull(input pcArgument as longchar):
        IsNull(pcArgument, "argument").
    end method.
    
    method public static void NotNull(pcArgument as longchar, pcName as character):
        if pcArgument eq ? then
            undo, throw new AssertionFailedError(substitute('&1 cannot be unknown', pcName), 0).
    end method.

    method public static void NotNull(pcArgument as longchar):
        NotNull(pcArgument, "argument").
    end method.
    
    method public static void NotNullOrEmpty(input poArgument as ICollection, pcName as char):
        AssertObject:NotNullOrEmpty(poArgument, pcName).
    end method.

    method public static void NotNullOrEmpty(input poArgument as ICollection):
        NotNullOrEmpty(poArgument, "argument").
    end method.
    
    method public static void IsEmpty(input phArgument as handle, pcName as character):
        Assert:NotNull(phArgument, pcName).

        phArgument:find-first() no-error.
        Assert:NotAvailable(phArgument, pcName).
    end method.

    method public static void IsEmpty(input phArgument as handle):
        IsEmpty(phArgument, "argument").
    end method.
    
    method public static void NotEmpty(input phArgument as handle, pcName as character):
        Assert:NotNull(phArgument, pcName).

        phArgument:find-first() no-error.
        Assert:IsAvailable(phArgument, pcName).
    end method.

    /* Validates that the argument is empy (blank)
       @param character The value to check
       @throws AssertionFailedError */
    method public static void IsEmpty(input pcArgument as character):
        IsEmpty(pcArgument, "argument").
    end method.
    
    /* Validates that the argument is empy (blank)
       
       @param character The value to check
       @param character The name of the argument (for errors)
       @throws AssertionFailedError */
    method public static void IsEmpty(input pcArgument as longchar, input pcName as character):
        define variable iRawLength as int64 no-undo.
        
        Assert:NotNull(pcArgument, pcName).
        /* number of bytes in the argument */
        assign iRawLength = length(pcArgument, 'raw':u).
        
           /* no characters is pretty empty */
        if iRawLength gt 0 or
           /* TRIM converts everything to cpinternal, which may not be able to 'see' all the characters
              that are in the argument. So, if the lengths differ, then there's something that's not a space
              (strong assumption) and we're OK, Jack.
              If the lengths match, we are ok to convert and we try to trim. */
           (iRawLength eq length(pcArgument) and trim(pcArgument) ne '':u) then
            undo, throw new AssertionFailedError(substitute('&1 must be empty', pcName), 0).
    end method.
    
    method public static void NotEmpty(input phArgument as handle):
        NotEmpty(phArgument, "argument").
    end method.
    
    method public static void NotNullOrEmpty(input poArgument as IMap, pcName as char):
        AssertObject:NotNullOrEmpty(poArgument, pcName).
    end method.

    method public static void NotNullOrEmpty(input poArgument as IMap):
        NotNullOrEmpty(poArgument, "argument").
    end method.
    
    method public static void NotNullOrEmpty(input poArgument as Object extent, pcName as char):
        AssertObject:NotNullOrEmpty(poArgument, pcName).
    end method.

    method public static void NotNullOrEmpty(input poArgument as Object extent):
        NotNullOrEmpty(poArgument, "argument").
    end method.
    
    method public static void NotNullOrEmpty(pcArgument as character, pcName as character):
       IF pcArgument EQ ?
       THEN
         UNDO, THROW NEW AssertionFailedError(SUBSTITUTE('&1 cannot be null',pcName),0).
    
        // TRIM will strip off spaces etc. Since this is a character parameter, it's already in
        // CPINTERNAL and so doesn't suffer from the issues described in NotEmpty(longchar, char). 
        if trim(pcArgument) eq '':u then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty', pcName),0).
    end method.
    
    method public static void NotNullOrEmpty(pcArgument as character):
        NotNullOrEmpty(pcArgument, "argument").
    end method.
    
    method public static void NotNullOrEmpty(input pcArgument as character extent, pcName as character):
        define variable cLongCharArg as longchar no-undo.

        if extent(pcArgument) eq ? then
            undo, throw new AssertionFailedError(substitute('&1 cannot be null', pcName), 0).
    end method.

    method public static void NotNullOrEmpty(input pcArgument as character extent):
        NotNullOrEmpty(pcArgument, "argument").
    end method.

    method public static void NotNull(input pcArgument as character extent, pcName as character):
        define variable cLongCharArg as longchar no-undo.
        
        if extent(pcArgument) eq ? then
            undo, throw new AssertionFailedError(substitute('&1 cannot be null', pcName), 0).
        
        if pcArgument[1] eq ? then
            undo, throw new AssertionFailedError(substitute('&1 cannot be null', pcName), 0).
    end method.
    
    method public static void NotNull(input pcArgument as character extent):
        NotNull(pcArgument, "argument").
    end method.
    
    method public static void NotEmpty(pcArgument as longchar, pcName as character):
        define variable iRawLength as int64 no-undo.
        
        /* number of bytes in the argument */
        assign iRawLength = length(pcArgument, 'raw':u).
        
           /* no characters is pretty empty */
        if iRawLength eq 0 or
           /* TRIM converts everything to cpinternal, which may not be able to 'see' all the characters
              that are in the argument. So, if the lengths differ, then there's something that's not a space
              (strong assumption) and we're OK, Jack.
              If the lengths match, we are ok to convert and we try to trim. */
           (iRawLength eq length(pcArgument) and trim(pcArgument) eq '':u) then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty', pcName), 0).
    end method.

    method public static void NotEmpty(pcArgument as longchar):
        NotEmpty(pcArgument, "argument").
    end method.
    
    method public static void NotNullOrEmpty(pcArgument as longchar, pcName as character):
        Assert:NotNull(pcArgument, pcName).
        Assert:NotEmpty(pcArgument, pcName).
    end method.

    method public static void NotNullOrEmpty(pcArgument as longchar):
        NotNullOrEmpty(pcArgument, "argument").
    end method.
    
    method public static void NonZero(piArgument as integer, pcName as character):
        if piArgument eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be zero', pcName), 0).
    end method.

    method public static void NonZero(piArgument as integer):
        NonZero(piArgument, "argument").
    end method.
    
    method public static void NonZero(piArgument as int64, pcName as character):
        if piArgument eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be zero', pcName), 0).
    end method.
    
    method public static void NonZero(piArgument as int64):
        NonZero(piArgument, "argument").
    end method.
    
    method public static void NonZero(piArgument as integer extent, pcName as character):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.

        AssertArray:HasDeterminateExtent(piArgument, pcName).
        iMax = extent(piArgument).
        do iLoop = 1 to iMax:
            Assert:NonZero(piArgument[iLoop], substitute('Extent &2 of &1', pcName, iLoop)).
        end.
    end method.

    method public static void NonZero(piArgument as integer extent):
        NonZero(piArgument, "argument").
    end method.
    
    method public static void NonZero(piArgument as int64 extent, pcName as character):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.

        AssertArray:HasDeterminateExtent(piArgument, pcName).
        iMax = extent(piArgument).
        do iLoop = 1 to iMax:
            Assert:NonZero(piArgument[iLoop], substitute('Extent &2 of &1', pcName, iLoop)).
        end.
    end method.

    method public static void NonZero(piArgument as int64 extent):
        NonZero(piArgument, "argument").
    end method.
    
    method public static void NonZero(piArgument as decimal, pcName as character):
        if piArgument eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be zero', pcName), 0).
    end method.

    method public static void NonZero(piArgument as decimal):
        NonZero(piArgument, "argument").
    end method.
    
    method public static void IsInterface(input poArgument as Progress.Lang.Class):
        AssertObject:IsInterface(poArgument).
    end method.

    method public static void NotInterface(input poArgument as Progress.Lang.Class):
        AssertObject:NotInterface(poArgument).
    end method.

    method public static void IsAbstract(input poArgument as Progress.Lang.Class):
         AssertObject:IsAbstract(poArgument).        
    end method.

    method public static void NotAbstract(input poArgument as Progress.Lang.Class):
        AssertObject:NotAbstract(poArgument).      
    end method.
        
    method public static void IsFinal(input poArgument as Progress.Lang.Class):
        AssertObject:IsFinal(poArgument). 
    end method.
    
    method public static void NotFinal(input poArgument as Progress.Lang.Class):
        AssertObject:NotFinal(poArgument).                       
    end method.
    
    method public static void IsType(input poArgument as Object extent, poType as Progress.Lang.Class):
        AssertObject:IsType(poArgument, poType).
    end method.
    
    method public static void IsType(input poArgument as Object, poType as Progress.Lang.Class):
        AssertObject:IsType(poArgument, poType).
    end method.
    
    method public static void NotType(input poArgument as Object, poType as Progress.Lang.Class):
        AssertObject:NotType(poArgument, poType).
    end method.
    
    /** Asserts that a handle is valid.
        
        @param handle The handle being checked.
        @param character The name of the handle/variable being checked. */
    method public static void NotNull(input phArgument as handle, input pcName as character):
        if not valid-handle(phArgument) then
            undo, throw new AssertionFailedError(substitute('&1 cannot be null', pcName), 0).
    end method.

    method public static void NotNull(input phArgument as handle):
        NotNull(phArgument, "argument").
    end method.
    
    /** Asserts that a handle is valid and of a particular datatype
        
        @param handle The handle being checked.
        @param DataTypeEnum The type the handle/variable being checked should be.
        @param character The name of the variable/handle.   */
    method public static void IsType(input phArgument as handle,
                                     input poCheckType as DataTypeEnum,
                                     input pcName as character):
        AssertObject:IsType(phArgument, poCheckType, pcName).        
    end method.

    method public static void IsType(input phArgument as handle,
                                     input poCheckType as DataTypeEnum):
        IsType(phArgument, poCheckType, "argument").
    end method.
    
    /** Asserts that a handle is valid and not of a particular datatype
        
        @param handle The handle being checked.
        @param DataTypeEnum The type the handle/variable being checked should be.
        @param character The name of the variable/handle.   */
    method public static void NotType(input phArgument as handle,
                                             input poCheckType as DataTypeEnum,
                                             input pcName as character):
        AssertObject:NotType(phArgument, poCheckType, pcName).
    end method.

    method public static void NotType(input phArgument as handle,
                                             input poCheckType as DataTypeEnum):
        NotType(phArgument, poCheckType, "argument").
    end method.
        
    method public static void IsNull(input phArgument as handle, input pcName as character):
        if valid-handle(phArgument) then
            undo, throw new AssertionFailedError(substitute('&1 must be null', pcName), 0).
    end method.
    
    method public static void IsNull(input phArgument as handle):
        IsNull(phArgument, "argument").
    end method.
    
    method public static void HasDeterminateExtent(input pcArgument as character extent,
                                                           input pcName as character):
        AssertArray:HasDeterminateExtent(pcArgument, pcName).
    end method.
    
    method public static void HasDeterminateExtent(input pcArgument as character extent):
        AssertArray:HasDeterminateExtent(pcArgument, "argument").
    end method.
    
    method public static void IsIndeterminateArray(input pcArgument as character extent,
                                                           input pcName as character):
        AssertArray:IsIndeterminateArray(pcArgument, pcName).
    end method.
    
    method public static void IsIndeterminateArray(input pcArgument as character extent):
        AssertArray:IsIndeterminateArray(pcArgument, "argument").
    end method.

    method public static void IsIndeterminateArray(input poArgument as Object extent,
                                                           input pcName as character):
        AssertArray:IsIndeterminateArray(poArgument, pcName).
    end method.
    
    method public static void HasDeterminateExtent(input poArgument as Object extent,
                                                           input pcName as character):
        AssertArray:HasDeterminateExtent(poArgument, pcName).
    end method.
    
    method public static void HasDeterminateExtent(input piArgument as integer extent,
                                                           input pcName as character):
        AssertArray:HasDeterminateExtent(piArgument, pcName).
    end method.

    method public static void HasDeterminateExtent(input piArgument as integer extent):
        AssertArray:HasDeterminateExtent(piArgument, "argument").
    end method.
    
    method public static void IsIndeterminateArray(input piArgument as integer extent,
                                                           input pcName as character):
        AssertArray:IsIndeterminateArray(piArgument, pcName).
    end method.

    method public static void IsIndeterminateArray(input piArgument as integer extent):
        AssertArray:IsIndeterminateArray(piArgument, "argument").
    end method.
    
    method public static void HasDeterminateExtent(input piArgument as int64 extent,
                                                           input pcName as character):
        AssertArray:HasDeterminateExtent(piArgument, pcName).
    end method.

    method public static void HasDeterminateExtent(input piArgument as int64 extent):
        AssertArray:HasDeterminateExtent(piArgument, "argument").
    end method.
    
    method public static void IsIndeterminateArray(input piArgument as int64 extent,
                                                           input pcName as character):
        AssertArray:IsIndeterminateArray(piArgument, pcName).
    end method.

    method public static void IsIndeterminateArray(input piArgument as int64 extent):
        AssertArray:IsIndeterminateArray(piArgument, "argument").
    end method.
    
    method public static void IsAvailable(input phArgument as handle,
                                          input pcName as character):
        Assert:NotNull(phArgument, pcName).
        
        if not phArgument:available then
            undo, throw new AssertionFailedError(substitute('record in buffer &1 is not available', pcName), 0).
    end method.

    method public static void IsAvailable(input phArgument as handle):
        IsAvailable(phArgument, "argument").
    end method.
       
    method public static void NotAvailable(input phArgument as handle,
                                           input pcName as character):
        Assert:NotNull(phArgument, pcName).

        if phArgument:available then
            undo, throw new AssertionFailedError(substitute('record in buffer &1 is available', pcName), 0).
    end method.

    method public static void NotAvailable(input phArgument as handle):
        NotAvailable(phArgument, "argument").
    end method.
    
    method public static void IsInteger(input pcArgument as character,
                                        input pcName as character):
        define variable iCheckVal as integer no-undo.

        iCheckVal = int(pcArgument) no-error.
        if error-status:error then
            undo, throw new AssertionFailedError(substitute('&1 is not an integer value', pcName), 0).
    end method.

    method public static void IsInteger(input pcArgument as character):
        IsInteger(pcArgument, "argument").
    end method.
    
    method public static void IsDecimal(input pcArgument as character,
                                        input pcName as character):
        define variable iCheckVal as integer no-undo.

        iCheckVal = decimal(pcArgument) no-error.
        if error-status:error then
            undo, throw new AssertionFailedError(substitute('&1 is not a decimal value', pcName), 0).
    end method.
    
    method public static void IsDecimal(input pcArgument as character):
        IsDecimal(pcArgument, "argument").
    end method.
        
    method public static void IsInt64(input pcArgument as character,
                                      input pcName as character):
        define variable iCheckVal as integer no-undo.

        iCheckVal = int64 (pcArgument) no-error.
        if error-status:error then
            undo, throw new AssertionFailedError(substitute('&1 is not an int64 value', pcName), 0).
    end method.

    method public static void IsInt64(input pcArgument as character):
       IsInt64(pcArgument, "argument").
    end method.
        
    method public static void IsTrue(input plArgument as logical,
                                     input pcName as character):
        /* deliberate not true */
        if not (plArgument eq true) then
            undo, throw new AssertionFailedError(substitute('&1 is not true', pcName), 0).
    end method.

    method public static void IsFalse(input plArgument as logical,
                                      input pcName as character):
        /* deliberate not false */
        if not (plArgument eq false) then
            undo, throw new AssertionFailedError(substitute('&1 is not false', pcName), 0).
    end method.
   
    method public static void IsUnknown(input plArgument as logical,
                                        input pcName as character):
        /* deliberate not ? */
        if not (plArgument eq ?) then
            undo, throw new AssertionFailedError(substitute('&1 is unknown', pcName), 0).
    end method.

    method public static void IsUnknown(input plArgument as logical):
       IsUnknown(plArgument, "argument").
    end method.
    
    method public static void NotTrue(input plArgument as logical,
                                      input pcName as character):
        if plArgument eq true then
            undo, throw new AssertionFailedError(substitute('&1 is true', pcName), 0).
    end method.

    method public static void NotTrue(input plArgument as logical):
        NotTrue(plArgument, "argument").
    end method.
    
    method public static void NotFalse(input plArgument as logical,
                                               input pcName as character):
        if plArgument eq false then
            undo, throw new AssertionFailedError(substitute('&1 is false', pcName), 0).
    end method.

    method public static void NotFalse(input plArgument as logical):
        NotFalse(plArgument, "argument").
    end method.
    
    method public static void NotUnknown(input plArgument as logical,
                                                 input pcName as character):
        if plArgument eq ? then
            undo, throw new AssertionFailedError(substitute('&1 is unknown', pcName), 0).
    end method.
    
    method public static void NotUnknown(input plArgument as logical):
        NotUnknown(plArgument, "argument").
    end method.
    
    method public static void NotNull(piArgument as integer, pcName as character):
        if piArgument eq ? then
            undo, throw new AssertionFailedError(substitute('&1 cannot be null', pcName), 0).
    end method.
    
    method public static void NotNull(piArgument as integer):
        NotNull(piArgument, "argument").
    end method.
    
    method public static void NotNull(input ptArgument as date, pcName as character):
        if ptArgument eq ? then
            undo, throw new AssertionFailedError(substitute('&1 cannot be null', pcName), 0).
    end method.

    method public static void NotNull(input ptArgument as date):
        NotNull(ptArgument, "argument").
    end method.
    
    method public static void NotNull(input ptArgument as datetime, pcName as character):
        if ptArgument eq ? then
            undo, throw new AssertionFailedError(substitute('&1 cannot be null', pcName), 0).
    end method.

    method public static void NotNull(input ptArgument as datetime):
        NotNull(ptArgument, "argument").
    end method.
    
    method public static void NotNull(input ptArgument as datetime-tz, pcName as character):
        if ptArgument eq ? then
            undo, throw new AssertionFailedError(substitute('&1 cannot be null', pcName), 0).
    end method.

    method public static void NotNull(input ptArgument as datetime-tz):
        NotNull(ptArgument, "argument").
    end method.
    
    method public static void IsNull(piArgument as integer, pcName as character):
        if piArgument ne ? then
            undo, throw new AssertionFailedError(substitute('&1 must be null', pcName), 0).
    end method.

    method public static void IsNull(piArgument as integer):
         IsNull(piArgument, "argument").
    end method.
        
    method public static void NotNull(piArgument as int64, pcName as character):
        if piArgument eq ? then
            undo, throw new AssertionFailedError(substitute('&1 cannot be null', pcName), 0).
    end method.

    method public static void NotNull(piArgument as int64):
        NotNull(piArgument, "argument").
    end method.
    
    method public static void IsNull(piArgument as int64, pcName as character):
        if piArgument ne ? then
            undo, throw new AssertionFailedError(substitute('&1 must be null', pcName), 0).
    end method.
    
    method public static void IsNull(piArgument as int64):
        IsNull(piArgument, "argument").
    end method.
        
    method public static void NotZero(piArgument as decimal, pcName as character):
        if piArgument eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be zero', pcName), 0).
    end method.

    method public static void NotZero(piArgument as decimal):
       NotZero(piArgument, "argument").
    end method.
    
    method public static void NotNull(pdArgument as decimal, pcName as character):
        if pdArgument eq ? then
            undo, throw new AssertionFailedError(substitute('&1 cannot be null', pcName), 0).
    end method.

    method public static void NotNull(pdArgument as decimal):
        NotNull(pdArgument, "argument").
    end method.
    
    method public static void IsNull(pdArgument as decimal, pcName as character):
        if pdArgument ne ? then
            undo, throw new AssertionFailedError(substitute('&1 must be null', pcName), 0).
    end method.

    method public static void IsNull(pdArgument as decimal):
        IsNull(pdArgument, "argument").
    end method.
    
    method public static void NotNullOrZero(piArgument as integer, pcName as character):
        Assert:NotNull(piArgument, pcName).
        Assert:NotZero(piArgument, pcName).
    end method.

    method public static void NotNullOrZero(piArgument as integer):
        NotNullOrZero(piArgument, "argument").
    end method.
    
    method public static void NotZero(piArgument as integer, pcName as character):
        if piArgument eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be zero', pcName), 0).
    end method.

    method public static void NotZero(piArgument as integer):
        NotZero(piArgument, "argument").
    end method.
    
    method public static void IsZero(piArgument as integer, pcName as character):
        if piArgument ne 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be zero', pcName), 0).
    end method.

    method public static void IsZero(piArgument as integer):
        IsZero(piArgument, "argument").
    end method.
        
    method public static void IsNegative(piArgument as integer, pcName as character):
        NotNull(piArgument, pcName).
        if piArgument ge 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be negative', pcName), 0).
    end method.

    method public static void IsNegative(piArgument as integer):
        IsNegative(piArgument, "argument").
    end method.
        
    method public static void IsPositive(piArgument as integer, pcName as character):
        NotNull(piArgument, pcName).
        if piArgument le 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be positive', pcName), 0).
    end method.

    method public static void IsPositive(piArgument as integer):
       IsPositive(piArgument, "argument").
    end method.
    
    method public static void IsZeroOrNegative(piArgument as integer, pcName as character):
        NotNull(piArgument, pcName).
        if piArgument gt 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be zero or negative', pcName), 0).
    end method.
    
    method public static void IsZeroOrNegative(piArgument as integer):
        IsZeroOrNegative(piArgument, "argument").
    end method.
    
    method public static void IsZeroOrPositive(piArgument as integer, pcName as character):
        NotNull(piArgument, pcName).
        if piArgument lt 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be zero or positive', pcName), 0).
    end method.

    method public static void IsZeroOrPositive(piArgument as integer):
        IsZeroOrPositive(piArgument, "argument").
    end method.
        
    method public static void NotZero(piArgument as int64, pcName as character):
        if piArgument eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be zero', pcName), 0).
    end method.

    method public static void NotZero(piArgument as int64):
        NotZero(piArgument, "argument").
    end method.
        
    method public static void IsZero(piArgument as int64, pcName as character):
        NotNull(piArgument, pcName).
        if piArgument ne 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be zero', pcName), 0).
    end method.

    method public static void IsZero(piArgument as int64):
        IsZero(piArgument, "argument").
    end method.
        
    method public static void IsNegative(piArgument as int64, pcName as character):
        NotNull(piArgument, pcName).
        if piArgument ge 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be negative', pcName), 0).
    end method.

    method public static void IsNegative(piArgument as int64):
        IsNegative(piArgument, "argument").
    end method.
        
    method public static void IsPositive(piArgument as int64, pcName as character):
        NotNull(piArgument, pcName).
        if piArgument le 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be positive', pcName), 0).
    end method.

    method public static void IsPositive(piArgument as int64):
        IsPositive(piArgument, "argument").
    end method.
    
    method public static void IsZeroOrNegative(piArgument as int64, pcName as character):
        NotNull(piArgument, pcName).
        if piArgument gt 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be zero or negative', pcName), 0).
    end method.

    method public static void IsZeroOrNegative(piArgument as int64):
        IsZeroOrNegative(piArgument, "argument").
    end method.
        
    method public static void IsZeroOrPositive(piArgument as int64, pcName as character):
        NotNull(piArgument, pcName).
        if piArgument lt 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be zero or positive', pcName), 0).
    end method.    

    method public static void IsZeroOrPositive(piArgument as int64):
        IsZeroOrPositive(piArgument, "argument").
    end method.    
    
    method public static void IsZero(pdArgument as decimal, pcName as character):
        if pdArgument ne 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be zero', pcName), 0).
    end method.

    method public static void IsZero(pdArgument as decimal):
        IsZero(pdArgument, "argument").
    end method.
    
    method public static void IsNegative(pdArgument as decimal, pcName as character):
        NotNull(pdArgument, pcName).
        if pdArgument ge 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be negative', pcName), 0).
    end method.
    
    method public static void IsNegative(pdArgument as decimal):
        IsNegative(pdArgument, "argument").
    end method.
    
    method public static void IsPositive(pdArgument as decimal, pcName as character):
        NotNull(pdArgument, pcName).
        if pdArgument le 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be positive', pcName), 0).
    end method.

    method public static void IsPositive(pdArgument as decimal):
        IsPositive(pdArgument, "argument").
    end method.
    
    method public static void IsZeroOrNegative(pdArgument as decimal, pcName as character):
        NotNull(pdArgument, pcName).
        if pdArgument gt 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be zero or negative', pcName), 0).
    end method.
    
    method public static void IsZeroOrNegative(pdArgument as decimal):
        IsZeroOrNegative(pdArgument, "argument").
    end method.
    
    method public static void IsZeroOrPositive(pdArgument as decimal, pcName as character):
        NotNull(pdArgument, pcName).
        if pdArgument lt 0 then
            undo, throw new AssertionFailedError(substitute('&1 must be zero or positive', pcName), 0).
    end method.    

    method public static void IsZeroOrPositive(pdArgument as decimal):
        IsZeroOrPositive(pdArgument, "argument").
    end method.
    
    /* Asserts that the input value can be converted to a logical value 
    
       @param character A character expression to evaluate
       @param character The format mask for the logical value 
       @param character The name of the argument
       @throws AssertionFailedError */
    method public static void IsLogical(input pcValue as character, 
                                        input pcMask as character,
                                        input pcName as character):
        define variable lValue as logical no-undo.
        
        NotNullOrEmpty(pcMask, 'Format mask').
        
        assign lValue = logical(pcValue, pcMask) no-error.
        if error-status:error then
            undo, throw new AssertionFailedError(
                                    substitute('&1 does not evaluate to a logical value with mask &2',
                                        pcName,
                                        pcMask),
                                    0).
    end method.

    /* Asserts that the input value can be converted to a logical value with the
       default/built-in format mask (see doc) 
    
       @param character A character expression to evaluate
       @throws AssertionFailedError */
    method public static void IsLogical(input pcValue as character):
        IsLogical(pcValue, 'arg').
    end method.
    
    /* Asserts that the input value can be converted to a logical value with the
       default/built-in format mask (see doc) 
    
       @param character A character expression to evaluate
       @param character The name of the argument
       @throws AssertionFailedError */
    method public static void IsLogical(input pcValue as character, 
                                        input pcName as character):
        define variable lValue as logical no-undo.
        
        assign lValue = logical(pcValue) no-error.
        if error-status:error then
            undo, throw new AssertionFailedError(
                                    substitute('&1 does not evaluate to a logical value',
                                        pcName),
                                    0).
    end method.
    
    /** Raises an AssertionFailedError.
        
        @param mesg the message to be used for the AssertionFailedError
        @throws AssertionFailedError Error thrown */
    method public static void RaiseError(mesg as character):
        NotNull(mesg).
        return error new AssertionFailedError(mesg, 0).
    end method.
    
    /* Asserts that the input value is in the provided list
       
       @param character  The value to check
       @param longchar  A comma-separated list to check against
       @param character The name of the argument */
    method static public void IsIn(input pValue as character,
                                   input pList as longchar,
                                   input pName as character):
        IsIn(pValue, pList, ',':u, pName).
    end method.
    
    /* Asserts that the input value is in the provided list
       
       @param character  The value to check
       @param longchar  A delimited-separated list to check against
       @param character The delimiter character
       @param character The name of the argument */
    method static public void IsIn(input pValue as character,
                                   input pList as longchar,
                                   input pDelim as character,
                                   input pName as character):
        define variable idx as integer no-undo.
        
        NotEqual(pValue, pDelim).
        
        assign idx = lookup(pValue, pList, pDelim).
        if    idx eq 0      // value not in list
           or idx eq ?      // value or list are ?
        then
            undo, throw new AssertionFailedError(
                                    substitute('&1 ("&2") is not in the list: &3',
                                               pName,
                                               pValue,
                                               pList ),
                                    0).
    end method.

    /* Asserts that the input value is NOT in the provided list
       
       @param character  The value to check
       @param longchar  A COMMA-separated list to check against
       @param character The name of the argument */
    method static public void NotIn(input pValue as character,
                                    input pList as longchar,
                                    input pName as character):
        NotIn(pValue, pList, ',':u, pName). 
    end method.
    
    /* Asserts that the input value is NOT in the provided list
       
       @param character  The value to check
       @param longchar  A delimited-separated list to check against
       @param character The delimiter character
       @param character The name of the argument */
    method static public void NotIn(input pValue as character,
                                    input pList as longchar,
                                    input pDelim as character,
                                    input pName as character):
        // if the list is empty/null then nothing can be in it
        if    pList eq ?
           or pList eq '':u
        then
            return.
        
        NotEqual(pValue, pDelim).
        
        // covers positive values (is a valid value, not in the list) and ? (unknown value)
        if not lookup(pValue, pList, pDelim) eq 0 then
            undo, throw new AssertionFailedError(
                                    substitute('&1 ("&2") is in the list: &3',
                                               pName,
                                               pValue,
                                               pList ),
                                    0).
    end method.
    
end class.
