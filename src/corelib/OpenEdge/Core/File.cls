/* *************************************************************************************************************************
Copyright (c) 2021-2022,2024 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : File
    Purpose     : Represents a filename, which may or not exist.
    Author(s)   : pjudge
    Created     : 2021-10-14
    Notes       : * The path elements (name, folder, extension, basename) are immutable once the object has been instantiated.
                  * The file and folder can be created using the CreateFile() and CreateFolder() methods
                  * The file name (incl any folder) cannot contain any of the following characters: < > : " | ? * ^
                  * Certain properties are marked NON-SERIALIZABLE since they
                    are read-only and depend on a physical file being on
                    disk, and we need to check that on each call.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.FileInfo.
using OpenEdge.Core.Folder.
using OpenEdge.Core.StringConstant.

@since(rel='12.5.0').
class OpenEdge.Core.File
inherits FileInfo
serializable:

    // A holder for the folder this file is in
    var serializable private Folder mFolder.

    /* The path of the file. May be blank */
    define non-serializable public property Folder as character no-undo
        get():
            return mFolder:Name.
        end get.

    /* The extension, defined as the last .-separated entry of the basename */
    define public property Extension as character no-undo
        get.
        private set.

    /* Indicates whether the file exists. Returns TRUE if the Folder exists, and is a File */
    define non-serializable public property FileExists as logical no-undo
        get():
            return this-object:Exists.
        end get.

    /* Indicates whether the folder represented by the Folder exists. Returns TRUE if the Folder exists, and is a DIRECTORY */
    define non-serializable public property FolderExists as logical no-undo
        get():
            return mFolder:Exists.
        end get.

    /* Indicates whether the path is writable. Returns TRUE if it exists, and FALSE otherwise.  */
    define non-serializable override public property CanWrite as logical no-undo
        get():
            SetFileInfo().

            // does not exist in any form, so depends on parent folder permissions
            if file-info:full-pathname eq ? then
                return mFolder:CanWrite.
            else
                return super:CanWrite.

            finally:
                RestoreFileInfo().
            end finally.
        end get.

    /* Indicates whether a path with this Name can be created. Returns TRUE is it can, FALSE otherwise.
       If the File exists, FALSE is returned. */
    define non-serializable override public property CanCreate as logical no-undo
        get():
            SetFileInfo().

            // does not exist in any form
            if file-info:full-pathname eq ? then
                // We can create this file if the folder is writable
                // CanCreate returns false if the folder exists, which does not mean that we cannot create this file
                return mFolder:CanWrite.
            else
                // this name already exists, either as a file or directory or something else,
                // so we cannot create it
                return false.

            finally:
                RestoreFileInfo().
            end finally.
        end get.

    define non-serializable public property Size as int64 no-undo
        get():
            SetFileInfo().

            if file-info:full-pathname eq ? then
                return -1.
            else
                return file-info:file-size.

            finally:
                RestoreFileInfo().
            end finally.
        end get.

    /* Constructor

       @param character A file name - not empty, not null. Cannot contain any of the following characters: <>:"|?*  */
    constructor public File(input pFileName as character):
        this-object(pFileName, ?).
    end constructor.

    /* Constructor. Sanitises the filename - ie replaces illegal characters with the input replacement char(s).

       @param character A file name - not empty, not null, not "."
       @param character A/the replacement character that will replace the illegal characters. If ? is passed, no replacements
                        are done, and the file name cannot contain any of the following characters: <>:"|?* */
    constructor public File(input pFileName as character,
                            input pReplacementChar as character):
        var integer pos, len.

        super(pFileName, 'F', pReplacementChar).

        Assert:NotNullOrEmpty(pFileName, 'File name').
        if pFileName eq '.':u then
            undo, throw new AssertionFailedError('File name cannot be "."').

        // split out the extension
        assign pos = r-index(this-object:Basename, '.':u).
        if pos gt 0 then
            assign this-object:Extension = substring(this-object:Basename, pos + 1).

        // if this is a folder - terminated with /, throw an error for a blank filename
        //if substring(this-object:Name, len, 1) eq '/' then
        if this-object:Basename eq '' then
            undo, throw new AssertionFailedError('File name cannot be empty').
        else
        do:
            assign len = length(this-object:Name)
                   pos = r-index(this-object:Name, '/', len - 1)
                   .
            if not pos eq 0 then
                // -1 since we don't want to recurse at all
                assign mFolder = new Folder(substring(pFileName, 1, pos), -1).
            else
                // -1 since we don't want to recurse at all
                assign mFolder = new Folder('':u, -1).
        end.
    end constructor.

    /* Creates this file's Folder

       This method does NOT check whether the folder can be created (via CanCreateFolder), but rather simply tries
       to create the folder tree, and returns FALSE if it fails.

       @return logical TRUE if the Folder was created. FALSE if the Folder already exists, or if an error was raised during creation */
    method public logical CreateFolder():
        return mFolder:Create().
    end method.

    /** Returns a logical value indicating whether the folder can be created.

        If any of the parent folders are not directories or are not writable, then
        return FALSE.

        Otherwise return TRUE.

        @return logical TRUE if the folder can be created, FALSE otherwise */
    method public logical CanCreateFolder():
        return mFolder:CanCreate.
    end method.

    /** Returns a logical value indicating whether the file can be created.

        If the Name already exists (as any type), then FALSE is returned.
        If the Folder exists, and is either a FILE or not writable, then FALSE is returned.
        If the Folder does not exist, then return the value of the CanCreateFolder() method.

        Otherwise return TRUE.

        @return logical TRUE if the file can be created, FALSE otherwise */
    method public logical CanCreateFile():
        return this-object:CanCreate.
    end method.

    /* Indicates whether a file can be written to.

       @return logical TRUE if the file exists and can be written to. FALSE otherwise. */
    method public logical CanReadFile():
        return this-object:CanRead.
    end method.

    /* Indicates whether a file can be written to.

       @return logical TRUE if the file exists and can be written to. FALSE otherwise. */
    method public logical CanWriteToFile():
        return this-object:CanWrite.
    end method.

    /* Indicates whether the file's folder can be written to.

       If none of the folders exist then this method returns TRUE

       @return logical TRUE if the file exists and can be written to. FALSE otherwise. */
    method public logical CanWriteToFolder():
        return mFolder:CanWrite.
    end method.

    /* Indicates whether the file's folder can be written to.

       If none of the folders exist then this method returns TRUE

       @return logical TRUE if the file exists and can be written to. FALSE otherwise. */
    method public logical CanReadFolder():
        return mFolder:CanRead.
    end method.

    /* Creates the path on disk.

       Note that no error is thrown from this method; FALSE is returned instead.

       @return logical TRUE if the file was created. FALSE if the file already exists, or if an error wa raised during creation. */
    method override public logical Create():
        SetFileInfo().

        if file-info:full-pathname eq ? then
        do:
            if not HasLegalName() then
                return false.

            CreateFolder().
            output to value(this-object:Name).
            output close.

            // Reset to recalculate the full path
            SetFileInfo().
            return (not file-info:full-pathname eq ?).
        end.

        return false.

        catch uncaught as Progress.Lang.Error:
            return false.
        end catch.
        finally:
            RestoreFileInfo().
        end finally.
    end method.

    /* Creates an empty file on disk.

       This method does NOT check whether the file can be created (via CanCreateFile), but rather simply tries
       to create the file, and returns FALSE if it fails.

       @return logical TRUE if the file was created. FALSE if the file already exists, or if an error wa raised during creation. */
    method public logical CreateFile():
        return this-object:Create().
    end method.

    /** Returns the absolute path.

        If the path does not exist on this host, the unknown value is returned.
        For Windows, any short paths - like C:\PROGRA~1 - are converted into their long paths - C:\Program Files.
        Backslashes are converted to /

        @return character An absolute (file system) representation of this path */
    method override public character AbsolutePath():
        var character absPath = super:AbsolutePath().

    &IF OPSYS EQ 'WIN32' &THEN
        // use fully-qualified type names so that this code continues to compile on Unix
        // this variable def MUST be inside the preprocessed block
        define variable fsi as System.IO.FileSystemInfo no-undo.

        if not absPath eq ? then
            assign fsi     = new System.IO.FileInfo(replace(absPath, '/', StringConstant:BACKSLASH))
                   absPath = replace(fsi:FullName, StringConstant:BACKSLASH, '/')
                   .
    &ENDIF
        return absPath.
    end method.

    /** Returns the absolute file name of this object, if the file exists. Resolved using FILE-INFO

        @param character An absolute path. If the file does not exist, or cannot be resolved, the unknown value is returned */
    method public character AbsoluteFileName():
        return this-object:AbsolutePath().
    end method.

    /* Deletes the file on disk

       @return logical TRUE if the file exists, and has write permissions, and was deleted without error. FALSE otherwise */
    method public logical DeleteFile():
        return this-object:Delete().
    end method.

    /** Returns the absolute path (folder) of this object, if it exists. Resolved using FILE-INFO.
        This may differ from the folder's AbsolutePath() when the file has a relative path, if the (relative) folder
        appears more than once in PROPATH.

        @param character An absolute path. If the file does not exist, or cannot be resolved, the unknown value is returned */
    method public character AbsoluteFilePath():
        var character absFile = this-object:AbsolutePath().
        var integer pos = r-index(absFile, '/').

        if pos eq ? then
            return ?.
        else
            return substring(absFile, 1, pos - 1).
    end method.

    /* Returns this file's folder as an object representation

       @param Folder The folder instance */
    method public Folder GetFolder():
        return mFolder.
    end method.

    /* Deletes the file on disk

       @return logical TRUE if the file exists, and has write permissions, and was deleted without error. FALSE otherwise */
    method override public logical Delete():
        // this also returns FALSE if the file does not exist
        if not this-object:CanWrite then
            return false.

        os-delete value(this-object:AbsoluteFileName()).

        return (os-error eq 0).
    end method.

end class.