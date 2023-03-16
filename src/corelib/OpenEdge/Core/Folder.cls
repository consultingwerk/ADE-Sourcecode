/* *************************************************************************************************************************
Copyright (c) 2022 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : Folder
    Purpose     : Represents a folder, which may or not exist
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2022-01-25
    Notes       : * Certain properties are marked NON-SERIALIZABLE since they
                    are read-only and depend on a physical folder being on
                    disk, and we need to check that on each call.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.File.
using OpenEdge.Core.FileInfo.
using OpenEdge.Core.Folder.
using OpenEdge.Core.StringConstant.
using Progress.Collections.IList.
using Progress.Collections.List.

@since(rel='12.6.0').
class OpenEdge.Core.Folder
inherits FileInfo
serializable:
    /* Indicates whether the path is writable. Returns TRUE if it exists, and FALSE otherwise.  */
    define non-serializable override public property CanWrite as logical no-undo
        get():
            var character folder.
            
            SetFileInfo().
            // if it does not exist in any form, check the parents
            if file-info:full-pathname eq ? then
            do:
                FileInfoFindExistingParent(file-info:file-name).
                if not file-info:full-pathname eq ? then
                    return this-object:HasAttribute('W').
                
                // At this point, none of the specified parents exist
                assign folder = file-info:file-name.
                
                // this is relative to something
                if not folder begins '.'
                and not folder begins '/'
                then
                do:
                    // Can we write relative to the current path?
                    assign file-info:file-name = '.'.
                    return this-object:HasAttribute('W').
                end.
                
                // we are trying to create a root folder, and that's a no-go
                return false.
            end.
            
            return this-object:HasAttribute('W').
        end get.
    
    /* Indicates whether a path with this Name can be created. Returns TRUE is it can, FALSE otherwise.
       If the folder exists, FALSE is returned */
    define non-serializable override public property CanCreate as logical no-undo
        get():
            SetFileInfo().
            
            // this folder already exists, either as a file or directory or something else,
            // so we cannot create it
            if not file-info:full-pathname eq ? then
                return false.
            
            // if it does not exist in any form, check the parents
            // we know that this folder does not exist, so we look up
            FileInfoFindExistingParent(file-info:file-name).
            // this will tell us whether we can create a folder under it.
            return this-object:HasAttribute('W').
        end get.
    
    /* A list of the files in this folder. Does not include any "grandchildren".
       Will be unknown if the folder has not been read or had any files added to it yet. */
    define public property Files as IList<File> no-undo
        get.
        private set.
    
    /* A list of the folders in this folder. Does not include any "grandchildren", nor does it include "." and "..".
       Will be unknown if the folder has not been read or had any child folders added to it yet. */
    define public property Folders as IList<Folder> no-undo
        get.
        private set.
    
    /* Constructor.
       
       @param character A folder name. Must have a value (not ?) */
    constructor public Folder(input pFolder as character):
        super(pFolder, 'D', ?).
        
        // if the basename is empty, and the Name is / , then basename should be /
        if this-object:Name eq '/' then
            assign this-object:Basename = this-object:Name.
        
        if this-object:Basename eq ''
        and not this-object:Name eq ''
        then
            assign this-object:Basename = entry(num-entries(this-object:Name, '/') - 1, this-object:Name, '/').
    end constructor.
    
    /* Constructor.
       
       @param character A folder name. Must have a value (not ?)
       @param integer The depth to which to read the folder. See the ReadFolder() method for details. */
    constructor public Folder(input pFolder as character,
                              input pDepth as integer):
        this-object(pFolder).
        ReadFolder(pDepth).
    end constructor.
    
    /* Reads the contents of a folder, to a given depth.
       
       Depth value:
           -n = Don't read this folder, at all
            0 = Read the current folder. Read files and folders, but don't read child folders' contents
            ? = read all the way down. Read all files and child folders
            n = read up to specified depth. At lowest level, read files and child folders, but not folders' contents
       
       @param integer The depth to read to. */
    method public void ReadFolder(input pDepth as integer):
        var character fName, fPath, fCodes.
        var integer newDepth.
        
        if not this-object:Exists then
            return.
        
        // -n = don't read this folder, at all
        if pDepth lt 0 then
            return.
        
        // will return ? if pDepth is ?
        assign newDepth = max(pDepth - 1, 0).
        
        // 0 = don't read the child folders/files
        if pDepth eq 0 then
            assign newDepth = -1.
        
        input from os-dir(this-object:AbsolutePath()) no-echo.
        IMPORT-LOOP:
        repeat:
            import fName fPath fCodes.
            
            if index(fCodes, 'D') gt 0 then
            do:
                // don't keep relative paths
                if fName eq '.'
                or fName eq '..'
                then
                    next IMPORT-LOOP.
                
                if not valid-object(this-object:Folders) then
                    assign this-object:Folders = new List<Folder>().
                
                this-object:Folders:Add(new Folder(fPath, newDepth)).
            end.
            else
            if index(fCodes, 'F') gt 0 then
            do:
                if not valid-object(this-object:Files) then
                    assign this-object:Files = new List<File>().
                
                this-object:Files:Add(new File(fPath)).
            end.
        end.
        
        finally:
            input close.
        end finally.
    end method.
    
    /* Creates this folder, if it does not exist
       
       This method does NOT check whether the folder can be created (via CanCreateFolder), but rather simply tries
       to create the folder, and returns FALSE if it fails.
       
       @return logical TRUE if the Folder was created. FALSE if the Folder already exists, or if an error was raised during creation */
    method override public logical Create():
        var integer loop, cnt.
        var character newfolder, delim.
        
        SetFileInfo().
        if file-info:full-pathname eq ? then
        do:
            if not HasLegalName() then
                return false.
            
            assign cnt = num-entries(this-object:Name, '/').
            do loop = 1 to cnt
            while os-error eq 0:
                assign newfolder += delim + entry(loop, this-object:Name, '/')
                       delim      = '/'
                       .
                os-create-dir value(newfolder).
            end.
            
            return (os-error eq 0).
        end.
        
        return false.
        catch uncaught as Progress.Lang.Error:
            return false.
        end catch.
    end method.
    
    /* Find the first/nearest existing folder for a path. A path may be a folder
       or a file.
       
       @param character A path. */
    method private void FileInfoFindExistingParent(input pPath as character):
        var integer len, pos.
        
        assign len = length(pPath).
        if len gt 1 then
            assign pos = r-index(pPath, '/', len - 1).
        
        do while pos gt 0:
            assign file-info:file-name = substring(pPath, 1, pos - 1)
                   // find the previous /
                   pos                 = r-index(pPath, '/', pos - 1)
                   .
            // return the first parent we find
            if not file-info:full-pathname eq ? then
                return.
        end.
    end method.
    
    /** Returns the absolute path.
        
        If the path does not exist on this host, the unknown value is returned.
        For Windows, any short paths - like C:\PROGRA~1 - are converted into their long paths - C:\Program Files.
        Backslashes are are converted to /
        
        @return character An absolute (file system) representation of this path */
    method override public character AbsolutePath():
        var character absPath = super:AbsolutePath().
        
&IF OPSYS EQ 'WIN32' &THEN
        // use fully-qualified type names so that this code continues to compile on Unix
        // this variable def MUST be inside the preprocessed block
        define variable fsi as System.IO.FileSystemInfo no-undo.
        
        if not absPath eq ? then
            assign fsi     = new System.IO.DirectoryInfo(replace(absPath, '/', StringConstant:BACKSLASH))
                   absPath = replace(fsi:FullName, StringConstant:BACKSLASH, '/')
                   .
&ENDIF
        return absPath.
    end method.
    
    /* Deletes this folder on disk. The folder, its files and any subfolders are deleted.
       
       @return logical TRUE if the folder exists, and has write permissions, and was deleted without any errors.
                       FALSE otherwise */
    method override public logical Delete():
        SetFileInfo().
        if not this-object:HasAttribute('W') then
            return false.
        
        // Deletes the folder and all of its contents, incl children
        os-delete value(this-object:AbsolutePath()) recursive.
        
        return (os-error eq 0).
    end method.
    
    /* Adds a sub-folder to this folder. The 'basename' of the folder is added to this folder.
       The 'basename' is the last path segment.
       If it is blank or / or // an error is thrown
       
       @param Folder The sub folder */
    method public void Add(input pFolder as Folder):
        var integer len = length(this-object:Name).
        var character lastSegment.
        
        Assert:NotNull(pFolder, 'Folder').
        
        assign lastSegment = entry(num-entries(pFolder:Name, '/'), pFolder:Name, '/').
        
        if lastSegment eq ''
        or lastSegment eq '/'
        or lastSegment eq '//'
        then
            undo, throw new AssertionFailedError(substitute('Folder "&1" cannot be added', pFolder:Name)).
        
        if not valid-object(this-object:Folders) then
            assign this-object:Folders = new List<Folder>().
        
        if substring(this-object:Name, len, 1) eq '/' then
            this-object:Folders:Add(new Folder(this-object:Name + lastSegment)).
        else
            this-object:Folders:Add(new Folder(this-object:Name + '/' + lastSegment)).
    end method.
    
    /* Adds a file to this folder.
       
       The input file's basename is used to create a new File instance, that has this folder as
       the folder. So if this folder is "/some/path" , and a file "foo.pdf" is added, then the
       new file has a name of "/some/path/foo.pdf".
       
       Similarly, if a file "bar/baz.png" is added, then the new file has a name of "/some/path/baz.png".
       
       @param File A file to add */
    method public void Add(input pFile as File):
        var integer len = length(this-object:Name).
        
        Assert:NotNull(pFile, 'File').
        
        if not valid-object(this-object:Files) then
            assign this-object:Files = new List<File>().
        
        if substring(this-object:Name, len, 1) eq '/' then
            this-object:Files:Add(new File(this-object:Name + pFile:Basename)).
        else
            this-object:Files:Add(new File(this-object:Name + '/' + pFile:Basename)).
    end method.
    
    /* Set the FILE-INFO FILE-NAME for this Folder. Uses "." if the folder Name is empty. */
    method override protected void SetFileInfo():
        if this-object:Name eq '' then
            assign file-info:file-name = '.'.
        else
            assign file-info:file-name = this-object:Name.
    end method.
    
end class.
