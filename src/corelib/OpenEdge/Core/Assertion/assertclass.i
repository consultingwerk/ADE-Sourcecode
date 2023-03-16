&if 1=0 &then
/************************************************
Copyright (c) 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : OpenEdge/Core/Assertion/assertclass.i
    Purpose     : Include for asserting information about a given class
    Description :
    Author(s)   : dugrau
    Created     : Tue May 3 14:22:42 EDT 2022
    Notes       :
  ----------------------------------------------------------------------*/
&endif

    /** Asserts that the given type is an interface.

        @param Progress.Lang.Class the type to check
        @throws AssertionFailedError Error thrown if the type is not an interface*/
    method public static void IsInterface (input pArgument as Progress.Lang.Class):
        NotUnknown(input pArgument, 'Type').

        if not pArgument:IsInterface() then
            undo, throw new AssertionFailedError(substitute('&1 is not an interface':u, pArgument:TypeName), 0).
    end method. // IsInterface

    /** Asserts that the given type is not an interface.

        @param Progress.Lang.Class the type to check
        @throws AssertionFailedError Error thrown if the type is an interface*/
    method public static void NotInterface (input pArgument as Progress.Lang.Class):
        NotUnknown(input pArgument, 'Type').

        if pArgument:IsInterface() then
            undo, throw new AssertionFailedError(substitute('&1 is an interface':u, pArgument:TypeName), 0).
    end method. // NotInterface


    /** Asserts that the given type is an abstract.

        @param Progress.Lang.Class the type to check
        @throws AssertionFailedError Error thrown if the type is not abstract*/
    method public static void IsAbstract (input pArgument as Progress.Lang.Class):
        NotUnknown(input pArgument, 'Type').

        if not pArgument:IsAbstract() then
            undo, throw new AssertionFailedError(substitute('&1 is not an abstract type':u, pArgument:TypeName), 0).
    end method. // IsAbstract

    /** Asserts that the given type is not an abstract.

        @param Progress.Lang.Class the type to check
        @throws AssertionFailedError Error thrown if the type is abstract*/
    method public static void NotAbstract (input pArgument as Progress.Lang.Class):
        NotUnknown(input pArgument, 'Type').

        if pArgument:IsAbstract() then
            undo, throw new AssertionFailedError(substitute('&1 is an abstract type':u, pArgument:TypeName), 0).
    end method. // NotAbstract


    /** Asserts that the given type is final.

        @param Progress.Lang.Class the type to check
        @throws AssertionFailedError Error thrown if the type is final*/
    method public static void IsFinal (input pArgument as Progress.Lang.Class):
        NotUnknown(input pArgument, 'Type').

        if not pArgument:IsFinal() then
            undo, throw new AssertionFailedError(substitute('&1 is not a final type':u, pArgument:TypeName), 0).
    end method. // IsFinal

    /** Asserts that the given type is not final.

        @param Progress.Lang.Class the type to check
        @throws AssertionFailedError Error thrown if the type is final*/
    method public static void NotFinal (input pArgument as Progress.Lang.Class):
        NotUnknown(input pArgument, 'Type').

        if pArgument:IsFinal() then
            undo, throw new AssertionFailedError(substitute('&1 is a final type':u, pArgument:TypeName), 0).
    end method. // NotFinal


    /** Asserts that a object is valid and of a particular type

        @param Progress.Lang.Object The Object being checked.
        @param Progress.Lang.Class The type the being checked.
        @throws AssertionFailedError Error thrown if the object is not valid and not of particular type.*/
    method public static void IsType (input pArgument as Object, poType as Progress.Lang.Class):
        define variable oDerivedClass as Progress.Lang.Class no-undo.

        NotUnknown(pArgument, 'argument').
        NotUnknown(poType, 'type').

        if type-of(pArgument, Progress.Lang.Class) then
            oDerivedClass = cast(pArgument, Progress.Lang.Class).
        else
            oDerivedClass = pArgument:GetClass().

        if not oDerivedClass:IsA(poType) then
            undo, throw new AssertionFailedError(
                    substitute('Object &1 (of type &2) is not of type &3':u,
                               pArgument:ToString(),
                               oDerivedClass:TypeName,
                               poType:TypeName), 0).
    end method. // IsType

    /** Asserts that a object extent is valid and of a particular type for each array item

        @param Progress.Lang.Object The Object being checked.
        @param Progress.Lang.Class The type the being checked.
        @throws AssertionFailedError Error thrown if the object array is not valid any of the array
            item is not of particular type.*/
    method public static void IsType (input pArgument as Object extent, input poType as Progress.Lang.Class):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.

        if extent(pArgument) eq ? then
            undo, throw new AssertionFailedError('argument cannot be an indeterminate array':u, 0).

        iMax = extent(pArgument).
        do iLoop = 1 to iMax:
            IsType(pArgument[iLoop], poType).
        end.
    end method. // IsType

    /** Asserts that a handle is valid and of a particular datatype

        @param handle The handle being checked.
        @param DataTypeEnum The type the handle/variable being checked should be.
        @param character The name of the variable/handle.
        @throws AssertionFailedError Error thrown if the handle is not valid or not of a particular datatype.*/
    method public static void IsType (input pArgument   as handle,
                                      input poCheckType as DataTypeEnum,
                                      input pcName      as character):
        define variable cCheckType as character no-undo.

        Assert:NotUnknown(pArgument, pcName).
        NotUnknown(poCheckType, 'Check DataType').

        assign cCheckType = DataTypeHelper:GetMask(poCheckType).
        if pArgument:type ne cCheckType then
            undo, throw new AssertionFailedError(substitute('&1 is not of type &2':u, pcName, cCheckType), 0).
    end method. // IsType

    /** Asserts that a handle is valid and of a particular datatype

        @param handle The handle being checked.
        @param DataTypeEnum The type the handle/variable being checked should be.
        @throws AssertionFailedError Error thrown if the handle is not valid or not of a particular datatype*/
    method public static void IsType (input pArgument  as handle, input poCheckType as DataTypeEnum):
        IsType(pArgument, poCheckType, 'argument':u).
    end method. // IsType


    /** Asserts that a object is valid and not of a particular type

        @param Progress.Lang.Object The Object being checked.
        @param Progress.Lang.Class The type the being checked.
        @throws AssertionFailedError Error thrown if the object is not valid and of particular type.*/
    method public static void NotType (input pArgument as Object, input poType as Progress.Lang.Class):
        define variable oDerivedClass as Progress.Lang.Class no-undo.

        NotUnknown(pArgument, 'argument':u).
        NotUnknown(poType, 'type').

        if type-of(pArgument, Progress.Lang.Class) then
            oDerivedClass = cast(pArgument, Progress.Lang.Class).
        else
            oDerivedClass = pArgument:GetClass().

        if oDerivedClass:IsA(poType) then
            undo, throw new AssertionFailedError(
                    substitute('Object &1 (of type &2) is of type &3':u,
                               pArgument:ToString(),
                               oDerivedClass:TypeName,
                               poType:TypeName), 0).
    end method. // NotType

    /** Asserts that a handle is valid and not of a particular datatype

        @param handle The handle being checked.
        @param DataTypeEnum The type the handle/variable being checked should be.
        @param character the identifying name for the AssertionFailedError.
        @throws AssertionFailedError Error thrown if the handle is not valid or of a particular datatype*/
    method public static void NotType (input pArgument   as handle,
                                       input poCheckType as DataTypeEnum,
                                       input pcName      as character):
        define variable cCheckType as character no-undo.

        Assert:NotUnknown(pArgument, pcName).
        NotUnknown(poCheckType, 'Check DataType').

        assign cCheckType = DataTypeHelper:GetMask(poCheckType).
        if pArgument:type eq cCheckType then
            undo, throw new AssertionFailedError(substitute('&1 cannot be of type &2':u, pcName, cCheckType), 0).
    end method. // NotType

    /** Asserts that a handle is valid and not of a particular datatype

        @param handle The handle being checked.
        @param DataTypeEnum The type the handle/variable being checked should be.
        @throws AssertionFailedError Error thrown if the handle is not valid or of a particular datatype*/
    method public static void NotType (input pArgument as handle, input poCheckType as DataTypeEnum):
        NotType(pArgument, poCheckType, 'argument':u).
    end method. // NotType

    /* Asserts that the given object can be serialized.

       @param Obejct The object to check. */
    method public static void IsSerializable (input pArgument as Object):
        define variable oDerivedClass as Progress.Lang.Class no-undo.

        NotUnknown(pArgument, 'argument').

        if type-of(pArgument, Progress.Lang.Class) then
            oDerivedClass = cast(pArgument, Progress.Lang.Class).
        else
            oDerivedClass = pArgument:GetClass().

        if not oDerivedClass:IsSerializable() then
            undo, throw new AssertionFailedError(
                    substitute('Object &1 (of type &2) is not serializable':u,
                               pArgument:ToString(),
                               oDerivedClass:TypeName), 0).
    end method. // IsSerializable

    /* Asserts that the given object cannot be serialized.

       @param Progress.Lang.Object The object to check. */
    method public static void NotSerializable (input pArgument as Object):
        define variable oDerivedClass as Progress.Lang.Class no-undo.

        NotUnknown(pArgument, 'argument').

        if type-of(pArgument, Progress.Lang.Class) then
            oDerivedClass = cast(pArgument, Progress.Lang.Class).
        else
            oDerivedClass = pArgument:GetClass().

        if oDerivedClass:IsSerializable() then
            undo, throw new AssertionFailedError(
                    substitute('Object &1 (of type &2) is serializable':u,
                               pArgument:ToString(),
                               oDerivedClass:TypeName), 0).
    end method. // NotSerializable
