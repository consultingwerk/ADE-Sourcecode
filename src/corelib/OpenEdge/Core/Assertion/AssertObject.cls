/************************************************
Copyright (c)  2014, 2016, 2020 by Progress Software Corporation. All rights reserved.
*************************************************/ 
 /*------------------------------------------------------------------------
    File        : AssertObject
    Purpose     : Assertions specific to Object(s) 
    Syntax      : 
    Description : 
    Author(s)   : psajja
    Created     : Tue Dec 16 12:28:50 IST 2014
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.AssertionFailedError.
using Progress.Lang.Object.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Core.Assertion.AssertObject.

class OpenEdge.Core.Assertion.AssertObject: 

    /** Asserts that two objects are equal.
        
        @param a expected value Object
        @param b the value of Object being expected
        @throws AssertionFailedError Error thrown if they are not equal*/
    method public static void Equals(input a as Object, input b as Object):
        Assert:NotNull(a).
        if not a:Equals(b) then
            return error new AssertionFailedError(substitute("Expected: &1 but was: &2", string(a), string(b)), 0).
    end method.
    
    /** Asserts that two objects are not equal.
        
        @param a expected value Object
        @param b the value of Object being expected
        @throws AssertionFailedError Error thrown if they are equal*/
    method public static void NotEqual(input a as Object, input b as Object):
        Assert:NotNull(a).
        if a:Equals(b) then
            return error new AssertionFailedError(substitute('&1 and &2 are equal', a:ToString(), string(b)), 0).
    end method.
    
    /** Asserts that the object is not null.
        
        @param poArgument the Object to check
        @param pcName the identifying name for the AssertionFailedError
        @throws AssertionFailedError Error thrown if Object is null*/
    method public static void NotNull(input poArgument as Object , pcName as char):
        if not valid-object(poArgument) then
            undo, throw new AssertionFailedError(substitute('&1 cannot be null', pcName), 0).
    end method.

    /** Asserts that the object is not null.
        
        @param poArgument the Object to check
        @throws AssertionFailedError Error thrown if Object is null*/
    method public static void NotNull(input poArgument as Object):
        NotNull(poArgument, "argument").
    end method.
    
    /** Asserts that the object is null.
        
        @param poArgument the Object to check
        @param pcName the identifying name for the AssertionFailedError
        @throws AssertionFailedError Error thrown if Object is not null*/
    method public static void IsNull(input poArgument as Object , input pcName as character):
        if valid-object(poArgument) then
            undo, throw new AssertionFailedError(substitute('&1 must be null', pcName), 0).
    end method.

    /** Asserts that the object is null.
        
        @param poArgument the Object to check
        @throws AssertionFailedError Error thrown if Object is not null*/
    method public static void IsNull(input poArgument as Object):
        IsNull(poArgument, "argument").
    end method.
    
    /** Asserts that the object array is not null.
        
        @param poArgument the Object array to check
        @param pcName the identifying name for the AssertionFailedError
        @throws AssertionFailedError Error thrown if Object is null*/
    method public static void NotNull(input poArgument as Object extent, pcName as char):
        if extent(poArgument) eq ? then
            undo, throw new AssertionFailedError(substitute('&1 cannot be null', pcName), 0).
    end method.

    /** Asserts that the object array is not null.
        
        @param poArgument the Object array to check
        @throws AssertionFailedError Error thrown if Object is null*/
    method public static void NotNull(input poArgument as Object extent):
        NotNull(poArgument, "argument").
    end method.
    
    /** Asserts that the object array is null.
        
        @param poArgument the Object array to check
        @param pcName the identifying name for the AssertionFailedError
        @throws AssertionFailedError Error thrown if Object is not null*/
    method public static void IsNull(input poArgument as Object extent, pcName as char):
        if extent(poArgument) ne ? then
            undo, throw new AssertionFailedError(substitute('&1 must be null', pcName), 0).
    end method.
    
    /** Asserts that the object array is null.
        
        @param poArgument the Object array to check
        @throws AssertionFailedError Error thrown if Object is not null*/
    method public static void IsNull(input poArgument as Object extent):
        IsNull(poArgument, "argument").
    end method.
    
    /** Asserts that the given collection is not null or empty.
        
        @param poArgument the ICollection object to check
        @param pcName the identifying name for the AssertionFailedError
        @throws AssertionFailedError Error thrown if the collection object is null or empty*/
    method public static void NotNullOrEmpty(input poArgument as ICollection, pcName as char):
        Assert:NotNull(input poArgument, input pcName).

        if poArgument:Size eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty: collection must have at least one entry', pcName), 0).
    end method.

    /** Asserts that the given collection is not null or empty.
        
        @param poArgument the ICollection object to check
        @throws AssertionFailedError Error thrown if the collection object is null or empty*/
    method public static void NotNullOrEmpty(input poArgument as ICollection):
        NotNullOrEmpty(poArgument, "argument").
    end method.
    
    /** Asserts that the given map is not null or empty.
        
        @param poArgument the IMap object to check
        @param pcName the identifying name for the AssertionFailedError
        @throws AssertionFailedError Error thrown if the map object is null or empty*/
    method public static void NotNullOrEmpty(input poArgument as IMap, pcName as char):
        Assert:NotNull(input poArgument, input pcName).

        if poArgument:Size eq 0 then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty: map must have at least one entry', pcName), 0).
    end method.

    /** Asserts that the given map is not null or empty.
        
        @param poArgument the IMap object to check
        @throws AssertionFailedError Error thrown if the map object is null or empty*/
    method public static void NotNullOrEmpty(input poArgument as IMap):
        NotNullOrEmpty(poArgument, "argument").
    end method.
    
    /** Asserts that the given object array is not null or empty.
        
        @param poArgument the Object array to check
        @param pcName the identifying name for the AssertionFailedError
        @throws AssertionFailedError Error thrown if the object array is null or empty*/
    method public static void NotNullOrEmpty(input poArgument as Object extent, pcName as char):
        Assert:NotNull(input poArgument, pcName).

        if not valid-object(poArgument[1]) then
            undo, throw new AssertionFailedError(substitute('&1 cannot be empty: array must have at least one valid extent', pcName), 0).
    end method.

    /** Asserts that the given object array is not null or empty.
        
        @param poArgument the Object array to check
        @throws AssertionFailedError Error thrown if the object array is null or empty*/
    method public static void NotNullOrEmpty(input poArgument as Object extent):
        NotNullOrEmpty(poArgument, "argument").
    end method.
    
    /** Asserts that the given type is an interface.
        
        @param poArgument the type to check
        @throws AssertionFailedError Error thrown if the type is not an interface*/
    method public static void IsInterface(input poArgument as Progress.Lang.Class):
        Assert:NotNull(input poArgument, 'Type').
        if not poArgument:IsInterface() then
            undo, throw new AssertionFailedError(substitute('&1 is not an interface', poArgument:TypeName), 0).
    end method.
    
    /** Asserts that the given type is not an interface.
        
        @param poArgument the type to check
        @throws AssertionFailedError Error thrown if the type is an interface*/
    method public static void NotInterface(input poArgument as Progress.Lang.Class):
        Assert:NotNull(input poArgument, 'Type').
        if poArgument:IsInterface() then
            undo, throw new AssertionFailedError(substitute('&1 is an interface', poArgument:TypeName), 0).
    end method.

    /** Asserts that the given type is an abstract.
        
        @param poArgument the type to check
        @throws AssertionFailedError Error thrown if the type is not abstract*/
    method public static void IsAbstract(input poArgument as Progress.Lang.Class):
        Assert:NotNull(input poArgument, 'Type').
        if not poArgument:IsAbstract() then
            undo, throw new AssertionFailedError(substitute('&1 is not an abstract type', poArgument:TypeName), 0).        
    end method.

    /** Asserts that the given type is not an abstract.
        
        @param poArgument the type to check
        @throws AssertionFailedError Error thrown if the type is abstract*/
    method public static void NotAbstract(input poArgument as Progress.Lang.Class):
        Assert:NotNull(input poArgument, 'Type').
        if poArgument:IsAbstract() then
            undo, throw new AssertionFailedError(substitute('&1 is an abstract type', poArgument:TypeName), 0).        
    end method.

    /** Asserts that the given type is final.
        
        @param poArgument the type to check
        @throws AssertionFailedError Error thrown if the type is final*/
    method public static void IsFinal(input poArgument as Progress.Lang.Class):
        Assert:NotNull(input poArgument, 'Type').
        if not poArgument:IsFinal() then
            undo, throw new AssertionFailedError(substitute('&1 is not a final type', poArgument:TypeName), 0).
    end method.

    /** Asserts that the given type is not final.
        
        @param poArgument the type to check
        @throws AssertionFailedError Error thrown if the type is final*/
    method public static void NotFinal(input poArgument as Progress.Lang.Class):
        Assert:NotNull(input poArgument, 'Type').
        if poArgument:IsFinal() then
            undo, throw new AssertionFailedError(substitute('&1 is a final type', poArgument:TypeName), 0).                        
    end method.
    
    /** Asserts that a object extent is valid and of a particular type for each array item
        
        @param poArgument The Object being checked.
        @param poType The type the being checked.
        @throws AssertionFailedError Error thrown if the object array is not valid any of the array 
            item is not of particular type.*/
    method public static void IsType(input poArgument as Object extent, poType as Progress.Lang.Class):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        if extent(poArgument) eq ? then
            undo, throw new AssertionFailedError('argument cannot be an indeterminate array', 0).
        
        iMax = extent(poArgument).
        do iLoop = 1 to iMax:
            Assert:IsType(poArgument[iLoop], poType).
        end.
    end method.

    /** Asserts that a object is valid and of a particular type
        
        @param poArgument The Object being checked.
        @param poType The type the being checked.
        @throws AssertionFailedError Error thrown if the object is not valid and not of particular type.*/
    method public static void IsType(input poArgument as Object, poType as Progress.Lang.Class):
        define variable oDerivedClass as Progress.Lang.Class no-undo.
        
        Assert:NotNull(poArgument, 'argument').
        Assert:NotNull(poType, 'type').
        
        if type-of(poArgument, Progress.Lang.Class) then 
            oDerivedClass = cast(poArgument, Progress.Lang.Class).
        else
            oDerivedClass = poArgument:GetClass().
        
        if not oDerivedClass:IsA(poType) then
            undo, throw new AssertionFailedError(
                    substitute('Object &1 (of type &2) is not of type &3',
                        poArgument:ToString(),
                        oDerivedClass:TypeName,
                        poType:TypeName), 0).
    end method.
    
    /** Asserts that a object is valid and not of a particular type
        
        @param poArgument The Object being checked.
        @param poType The type the being checked.
        @throws AssertionFailedError Error thrown if the object is not valid and of particular type.*/
    method public static void NotType(input poArgument as Object, poType as Progress.Lang.Class):
        define variable oDerivedClass as Progress.Lang.Class no-undo.
        
        Assert:NotNull(poArgument, 'argument').
        Assert:NotNull(poType, 'type').
        
        if type-of(poArgument, Progress.Lang.Class) then 
            oDerivedClass = cast(poArgument, Progress.Lang.Class).
        else
            oDerivedClass = poArgument:GetClass().
        
        if oDerivedClass:IsA(poType) then
            undo, throw new AssertionFailedError(
                    substitute('Object &1 (of type &2) is of type &3',
                        poArgument:ToString(),
                        oDerivedClass:TypeName,
                        poType:TypeName), 0).
    end method.
    
    /** Asserts that a handle is valid and of a particular datatype
        
        @param phArgument The handle being checked.
        @param poCheckType The type the handle/variable being checked should be.
        @param pcName The name of the variable/handle.   
        @throws AssertionFailedError Error thrown if the handle is not valid or not of a particular datatype.*/
    method public static void IsType(input phArgument as handle,
                                     input poCheckType as DataTypeEnum,
                                     input pcName as character):
        define variable cCheckType as character no-undo.
        
        Assert:NotNull(phArgument, pcName).
        Assert:NotNull(poCheckType, 'Check DataType').
        
        assign cCheckType = DataTypeHelper:GetMask(poCheckType).
        if phArgument:type ne cCheckType then
            undo, throw new AssertionFailedError(substitute('&1 is not of type &2', pcName, cCheckType), 0).        
    end method.

    /** Asserts that a handle is valid and of a particular datatype
        
        @param phArgument The handle being checked.
        @param poCheckType The type the handle/variable being checked should be.
        @throws AssertionFailedError Error thrown if the handle is not valid or not of a particular datatype*/
    method public static void IsType(input phArgument as handle,
                                     input poCheckType as DataTypeEnum):
        IsType(phArgument, poCheckType, "argument").
    end method.
    
    /** Asserts that a handle is valid and not of a particular datatype
        
        @param phArgument The handle being checked.
        @param poCheckType The type the handle/variable being checked should be.
        @param pcName the identifying name for the AssertionFailedError.
        @throws AssertionFailedError Error thrown if the handle is not valid or of a particular datatype*/
    method public static void NotType(input phArgument as handle,
                                      input poCheckType as DataTypeEnum,
                                      input pcName as character):
        define variable cCheckType as character no-undo.
        
        Assert:NotNull(phArgument, pcName).
        Assert:NotNull(poCheckType, 'Check DataType').
        
        assign cCheckType = DataTypeHelper:GetMask(poCheckType).
        if phArgument:type eq cCheckType then
            undo, throw new AssertionFailedError(substitute('&1 cannot be of type &2', pcName, cCheckType), 0).
    end method.

    /** Asserts that a handle is valid and not of a particular datatype
        
        @param phArgument The handle being checked.
        @param poCheckType The type the handle/variable being checked should be.
        @throws AssertionFailedError Error thrown if the handle is not valid or of a particular datatype*/
    method public static void NotType(input phArgument as handle,
                                             input poCheckType as DataTypeEnum):
        NotType(phArgument, poCheckType, "argument").
    end method.

    /** Asserts that the given object array has indeterninate extent.
        
        @param poArgument the Object array to check
        @param pcName the identifying name for the AssertionFailedError
        @throws AssertionFailedError Error thrown if the object array extent is determinate*/
    method public static void IsIndeterminateArray(input poArgument as Object extent,
                                                           input pcName as character):
        if extent(poArgument) ne ? then
            undo, throw new AssertionFailedError(substitute('&1 array must be indeterminate', pcName), 0).
    end method.

    /** Asserts that the given object array has indeterninate extent.
        
        @param poArgument the Object array to check
        @throws AssertionFailedError Error thrown if the object array extent is determinate*/
    method public static void IsIndeterminateArray(input poArgument as Object extent):
        IsIndeterminateArray(poArgument, "argument").
    end method.
    
    /** Asserts that the given object array has deterninate extent.
        
        @param poArgument the Object array to check
        @param pcName the identifying name for the AssertionFailedError
        @throws AssertionFailedError Error thrown if the object array extent is not determinate*/
    method public static void HasDeterminateExtent(input poArgument as Object extent,
                                                           input pcName as character):
        if extent(poArgument) eq ? then
            undo, throw new AssertionFailedError(substitute('&1 array cannot be indeterminate', pcName), 0).
    end method.
    
    /** Asserts that the given object array has deterninate extent.
        
        @param poArgument the Object array to check
        @throws AssertionFailedError Error thrown if the object array extent is not determinate*/
    method public static void HasDeterminateExtent(input poArgument as Object extent):
        HasDeterminateExtent(poArgument, "argument").
    end method.
    
    /* Asserts that the given object can be serialized.
       
       @param Obejct The object to check. */
    method public static void IsSerializable(input poArgument as Object):
        define variable oDerivedClass as Progress.Lang.Class no-undo.
        
        Assert:NotNull(poArgument, 'argument').
        
        if type-of(poArgument, Progress.Lang.Class) then 
            oDerivedClass = cast(poArgument, Progress.Lang.Class).
        else
            oDerivedClass = poArgument:GetClass().
        
        if not oDerivedClass:IsSerializable() then
            undo, throw new AssertionFailedError(
                    substitute('Object &1 (of type &2) is not serializable',
                        poArgument:ToString(),
                        oDerivedClass:TypeName), 0).
    end method.
    
    /* Asserts that the given object cannot be serialized.
       
       @param Obejct The object to check. */
    method public static void NotSerializable(input poArgument as Object):
        define variable oDerivedClass as Progress.Lang.Class no-undo.
        
        Assert:NotNull(poArgument, 'argument').
        
        if type-of(poArgument, Progress.Lang.Class) then 
            oDerivedClass = cast(poArgument, Progress.Lang.Class).
        else
            oDerivedClass = poArgument:GetClass().
        
        if oDerivedClass:IsSerializable() then
            undo, throw new AssertionFailedError(
                    substitute('Object &1 (of type &2) is serializable',
                        poArgument:ToString(),
                        oDerivedClass:TypeName), 0).
    end method.    
end class.