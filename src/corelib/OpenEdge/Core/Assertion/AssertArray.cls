/************************************************
Copyright (c) 2014-2017 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : AssertArray
    Purpose     : Assertions of truth for various arrays
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2017-02-01
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.Assertion.AssertObject.
using OpenEdge.Core.Assert.

block-level on error undo, throw.

class OpenEdge.Core.Assertion.AssertArray: 
    
    method public static void Equals(input pSource as character extent, 
                                     input pTarget as character extent):
        define variable srcSize as integer no-undo.
        define variable tgtSize as integer no-undo.
        define variable loop as integer no-undo.
        
        assign srcSize = extent(pSource)
               tgtSize = extent(pTarget).
        if    (srcSize eq ? and tgtSize ne ?) 
           or srcSize ne tgtSize then
            undo, throw new AssertionFailedError(substitute('Arrays are different sizes (source=&1; target=&2)', srcSize, tgtSize), 0). 
        
        do loop = 1 to srcSize:
            Assert:Equals(pSource[loop], pTarget[loop]). 
        end.
        catch e as Progress.Lang.Error:
            undo, throw new AssertionFailedError(substitute('Array value differ for index &1', loop), 0).
        end catch.
    end method.
    
    method public static void Equals(input pSource as longchar extent, 
                                     input pTarget as longchar extent):
        define variable srcSize as integer no-undo.
        define variable tgtSize as integer no-undo.
        define variable loop as integer no-undo.
        
        assign srcSize = extent(pSource)
               tgtSize = extent(pTarget).
        if (srcSize eq ? and tgtSize ne ?) or
           srcSize ne tgtSize then
            undo, throw new AssertionFailedError(substitute('Arrays are different sizes (source=&1; target=&2)', srcSize, tgtSize), 0). 
        
        do loop = 1 to srcSize:
            Assert:Equals(pSource[loop], pTarget[loop]). 
        end.
        catch e as Progress.Lang.Error:
            undo, throw new AssertionFailedError(substitute('Array value differ for index &1', loop), 0).
        end catch.
    end method.
    
    method public static void Equals(input pSource as integer extent, 
                                     input pTarget as integer extent):
        define variable srcSize as integer no-undo.
        define variable tgtSize as integer no-undo.
        define variable loop as integer no-undo.
        
        assign srcSize = extent(pSource)
               tgtSize = extent(pTarget).
        if (srcSize eq ? and tgtSize ne ?) or
           srcSize ne tgtSize then
            undo, throw new AssertionFailedError(substitute('Arrays are different sizes (source=&1; target=&2)', srcSize, tgtSize),  0).
        
        do loop = 1 to srcSize:
            Assert:Equals(pSource[loop], pTarget[loop]). 
        end.
        catch e as Progress.Lang.Error:
            undo, throw new AssertionFailedError(substitute('Array value differ for index &1', loop), 0).
        end catch.
    end method.
    
    method public static void Equals(input pSource as int64 extent, 
                                     input pTarget as int64 extent):
        define variable srcSize as integer no-undo.
        define variable tgtSize as integer no-undo.
        define variable loop as integer no-undo.
        
        assign srcSize = extent(pSource)
               tgtSize = extent(pTarget).
        if (srcSize eq ? and tgtSize ne ?) or
           srcSize ne tgtSize then
            undo, throw new AssertionFailedError(substitute('Arrays are different sizes (source=&1; target=&2)', srcSize, tgtSize),  0). 
        
        do loop = 1 to srcSize:
            Assert:Equals(pSource[loop], pTarget[loop]). 
        end.
        catch e as Progress.Lang.Error:
            undo, throw new AssertionFailedError(substitute('Array value differ for index &1', loop), 0).
        end catch.
    end method.

    method public static void Equals(input pSource as decimal extent, 
                                     input pTarget as decimal extent):
        define variable srcSize as integer no-undo.
        define variable tgtSize as integer no-undo.
        define variable loop as integer no-undo.
        
        assign srcSize = extent(pSource)
               tgtSize = extent(pTarget).
        if (srcSize eq ? and tgtSize ne ?) or
           srcSize ne tgtSize then
            undo, throw new AssertionFailedError(substitute('Arrays are different sizes (source=&1; target=&2)', srcSize, tgtSize),  0). 
        
        do loop = 1 to srcSize:
            Assert:Equals(pSource[loop], pTarget[loop]). 
        end.
        catch e as Progress.Lang.Error:
            undo, throw new AssertionFailedError(substitute('Array value differ for index &1', loop), 0).
        end catch.
    end method.
    
    method public static void Equals(input pSource as date extent, 
                                     input pTarget as date extent):
        define variable srcSize as integer no-undo.
        define variable tgtSize as integer no-undo.
        define variable loop as integer no-undo.
        
        assign srcSize = extent(pSource)
               tgtSize = extent(pTarget).
        if (srcSize eq ? and tgtSize ne ?) or
           srcSize ne tgtSize then
            undo, throw new AssertionFailedError(substitute('Arrays are different sizes (source=&1; target=&2)', srcSize, tgtSize),  0). 
        
        do loop = 1 to srcSize:
            Assert:Equals(pSource[loop], pTarget[loop]). 
        end.
        catch e as Progress.Lang.Error:
            undo, throw new AssertionFailedError(substitute('Array value differ for index &1', loop), 0).
        end catch.
    end method.
    
    method public static void Equals(input pSource as datetime extent, 
                                     input pTarget as datetime extent):
        define variable srcSize as integer no-undo.
        define variable tgtSize as integer no-undo.
        define variable loop as integer no-undo.
        
        assign srcSize = extent(pSource)
               tgtSize = extent(pTarget).
        if (srcSize eq ? and tgtSize ne ?) or
           srcSize ne tgtSize then
            undo, throw new AssertionFailedError(substitute('Arrays are different sizes (source=&1; target=&2)', srcSize, tgtSize),  0). 
        
        do loop = 1 to srcSize:
            Assert:Equals(pSource[loop], pTarget[loop]). 
        end.
        catch e as Progress.Lang.Error:
            undo, throw new AssertionFailedError(substitute('Array value differ for index &1', loop), 0).
        end catch.
    end method.

    method public static void Equals(input pSource as datetime-tz extent, 
                                     input pTarget as datetime-tz extent):
        define variable srcSize as integer no-undo.
        define variable tgtSize as integer no-undo.
        define variable loop as integer no-undo.
        
        assign srcSize = extent(pSource)
               tgtSize = extent(pTarget).
        if (srcSize eq ? and tgtSize ne ?) or
           srcSize ne tgtSize then
            undo, throw new AssertionFailedError(substitute('Arrays are different sizes (source=&1; target=&2)', srcSize, tgtSize),  0). 
        
        do loop = 1 to srcSize:
            Assert:Equals(pSource[loop], pTarget[loop]). 
        end.
        catch e as Progress.Lang.Error:
            undo, throw new AssertionFailedError(substitute('Array value differ for index &1', loop), 0).
        end catch.
    end method.
    
    method public static void Equals(input pSource as logical extent, 
                                     input pTarget as logical extent):
        define variable srcSize as integer no-undo.
        define variable tgtSize as integer no-undo.
        define variable loop as integer no-undo.
        
        assign srcSize = extent(pSource)
               tgtSize = extent(pTarget).
        if (srcSize eq ? and tgtSize ne ?) or
           srcSize ne tgtSize then
            undo, throw new AssertionFailedError(substitute('Arrays are different sizes (source=&1; target=&2)', srcSize, tgtSize),  0). 
        
        do loop = 1 to srcSize:
            Assert:Equals(pSource[loop], pTarget[loop]). 
        end.
        catch e as Progress.Lang.Error:
            undo, throw new AssertionFailedError(substitute('Array value differ for index &1', loop), 0).
        end catch.
    end method.
    
    method public static void Equals(input pSource as handle extent, 
                                     input pTarget as handle extent):
        define variable srcSize as integer no-undo.
        define variable tgtSize as integer no-undo.
        define variable loop as integer no-undo.
        
        assign srcSize = extent(pSource)
               tgtSize = extent(pTarget).
        if (srcSize eq ? and tgtSize ne ?) or
           srcSize ne tgtSize then
            undo, throw new AssertionFailedError(substitute('Arrays are different sizes (source=&1; target=&2)', srcSize, tgtSize),  0). 
        
        do loop = 1 to srcSize:
            Assert:Equals(pSource[loop], pTarget[loop]). 
        end.
        catch e as Progress.Lang.Error:
            undo, throw new AssertionFailedError(substitute('Array value differ for index &1', loop), 0).
        end catch.
    end method.

    method public static void Equals(input pSource as Progress.Lang.Object extent, 
                                     input pTarget as Progress.Lang.Object extent):
        define variable srcSize as integer no-undo.
        define variable tgtSize as integer no-undo.
        define variable loop as integer no-undo.
        
        assign srcSize = extent(pSource)
               tgtSize = extent(pTarget).
        if (srcSize eq ? and tgtSize ne ?) or
           srcSize ne tgtSize then
            undo, throw new AssertionFailedError(substitute('Arrays are different sizes (source=&1; target=&2)', srcSize, tgtSize),  0). 
        
        do loop = 1 to srcSize:
            Assert:Equals(pSource[loop], pTarget[loop]). 
        end.
    end method.

    method public static void Equals(input pSource as recid extent, 
                                     input pTarget as recid extent):
        define variable srcSize as integer no-undo.
        define variable tgtSize as integer no-undo.
        define variable loop as integer no-undo.
        
        assign srcSize = extent(pSource)
               tgtSize = extent(pTarget).
        if (srcSize eq ? and tgtSize ne ?) or
           srcSize ne tgtSize then
            undo, throw new AssertionFailedError(substitute('Arrays are different sizes (source=&1; target=&2)', srcSize, tgtSize),  0). 
        
        do loop = 1 to srcSize:
            Assert:Equals(pSource[loop], pTarget[loop]). 
        end.
        catch e as Progress.Lang.Error:
            undo, throw new AssertionFailedError(substitute('Array value differ for index &1', loop), 0).
        end catch.
    end method.

    method public static void Equals(input pSource as rowid extent, 
                                     input pTarget as rowid extent):
        define variable srcSize as integer no-undo.
        define variable tgtSize as integer no-undo.
        define variable loop as integer no-undo.
        
        assign srcSize = extent(pSource)
               tgtSize = extent(pTarget).
        if (srcSize eq ? and tgtSize ne ?) or
           srcSize ne tgtSize then
            undo, throw new AssertionFailedError(substitute('Arrays are different sizes (source=&1; target=&2)', srcSize, tgtSize),  0). 
        
        do loop = 1 to srcSize:
            Assert:Equals(pSource[loop], pTarget[loop]). 
        end.
        catch e as Progress.Lang.Error:
            undo, throw new AssertionFailedError(substitute('Array value differ for index &1', loop), 0).
        end catch.
    end method.
    
    method public static void HasDeterminateExtent(input pcArgument as character extent,
                                                           input pcName as character):
        if extent(pcArgument) eq ? then
            undo, throw new AssertionFailedError(substitute('&1 array cannot be indeterminate', pcName), 0).
    end method.
    
    method public static void HasDeterminateExtent(input pcArgument as character extent):
        HasDeterminateExtent(pcArgument, "argument").
    end method.
    
    method public static void IsIndeterminateArray(input pcArgument as character extent,
                                                           input pcName as character):
        if extent(pcArgument) ne ? then
            undo, throw new AssertionFailedError(substitute('&1 array must be indeterminate', pcName), 0).
    end method.
    
    method public static void IsIndeterminateArray(input pcArgument as character extent):
        IsIndeterminateArray(pcArgument, "argument").
    end method.

    method public static void IsIndeterminateArray(input poArgument as Object extent,
                                                   input pcName as character):
        AssertObject:IsIndeterminateArray(poArgument, pcName).
    end method.
    
    method public static void HasDeterminateExtent(input poArgument as Object extent,
                                                           input pcName as character):
        AssertObject:HasDeterminateExtent(poArgument, pcName).
    end method.
    
    method public static void HasDeterminateExtent(input piArgument as integer extent,
                                                           input pcName as character):
        if extent(piArgument) eq ? then
            undo, throw new AssertionFailedError(substitute('&1 array cannot be indeterminate', pcName), 0).
    end method.

    method public static void HasDeterminateExtent(input piArgument as integer extent):
        HasDeterminateExtent(piArgument, "argument").
    end method.
    
    method public static void IsIndeterminateArray(input piArgument as integer extent,
                                                           input pcName as character):
        if extent(piArgument) ne ? then
            undo, throw new AssertionFailedError(substitute('&1 array must be indeterminate', pcName), 0).
    end method.

    method public static void IsIndeterminateArray(input piArgument as integer extent):
        IsIndeterminateArray(piArgument, "argument").
    end method.
    
    method public static void HasDeterminateExtent(input piArgument as int64 extent,
                                                           input pcName as character):
        if extent(piArgument) eq ? then
            undo, throw new AssertionFailedError(substitute('&1 array cannot be indeterminate', pcName), 0).
    end method.

    method public static void HasDeterminateExtent(input piArgument as int64 extent):
        HasDeterminateExtent(piArgument, "argument").
    end method.
    
    method public static void IsIndeterminateArray(input piArgument as int64 extent,
                                                           input pcName as character):
        if extent(piArgument) ne ? then 
            undo, throw new AssertionFailedError(substitute('&1 array must be indeterminate', pcName), 0).
    end method.

    method public static void IsIndeterminateArray(input piArgument as int64 extent):
        IsIndeterminateArray(piArgument, "argument").
    end method.
        

end class.