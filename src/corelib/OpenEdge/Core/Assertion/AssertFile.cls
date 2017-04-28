/************************************************
Copyright (c)  2014, 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
 /*------------------------------------------------------------------------
    File        : AssertFile
    Purpose     : Assertions specific to files 
    Syntax      : 
    Description : 
    Author(s)   : psajja
    Created     : Tue Dec 16 11:25:36 IST 2014
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.Assert.

class OpenEdge.Core.Assertion.AssertFile: 

    /** Asserts that a file has exists.
        
        @param character The name of the directory being checked
        @throws AssertionFailedError Error thrown if the file does not exist */
    method public static void DirectoryExists(input pcName as character):
        Assert:NotNullOrEmpty(pcName).
        assign file-info:file-name = pcName.
        if file-info:file-type eq ? or (not file-info:file-type begins 'D':u) then
            undo, throw new AssertionFailedError(substitute('Directory &1 must exist', pcName), 0).
    end method.

    /** Asserts that a file has exists.
        
        @param character The name of the file being checked
        @throws AssertionFailedError Error thrown if the file does not exist */
    method public static void FileExists(fileName as character):
        Assert:NotNullOrEmpty(fileName).
        file-info:file-name = fileName.
        if file-info:file-type = ? or (not file-info:file-type begins "F") then
            undo, throw new AssertionFailedError(substitute('File &1 must exist.', fileName), 0).
    end method.
    
    /** Asserts that a file has exists in propath.
        
        @param character The name of the file being checked
        @throws AssertionFailedError Error thrown if the file does not exist */
    method public static void FileInPropath(fileName as character):
        Assert:NotNullOrEmpty(fileName).
        if search(fileName) eq ? then
            undo, throw new AssertionFailedError(substitute('File &1 must exist in propath.', fileName), 0).
    end method.
end class.