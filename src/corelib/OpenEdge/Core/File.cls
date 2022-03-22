/* *************************************************************************************************************************
Copyright (c) 2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : File
    Purpose     : Represents a filename, which may or not exist.
    Author(s)   : pjudge
    Created     : 2021-10-14
    Notes       : * The path elements (name, folder, extension, basename) are immutable once the object has been instantiated.
                  * The file and folder can be created using the CreateFile() and CreateFolder() methods
                  * The file name (incl any folder) cannot contain any of the following characters: < > : " | ? * ^
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.File.
using OpenEdge.Core.StringConstant.

@since(rel='12.5.0').
class OpenEdge.Core.File serializable:
    // the path separator used is /, since ABL deals nicely with it
    var private character mPathSeparator = '/':u.
    
    // On Windows in particular, these characters are illegal in file name
    var private character[8] illegalChars = ['<':u,'>':u,':':u,'"':u,'|':u,'?':u,'*':u, '^':u].
    var private integer IDX_LEFT_ANGLE=1, IDX_RIGHT_ANGLE=2, IDX_COLON=3, IDX_DOUBLE_QUOTE=4,
                        IDX_PIPE=5, IDX_QUESTION_MARK=5, IDX_ASTERISK=7, IDX_CARET=8.
    
    /* The file name, including path */
    define public property Name as character no-undo
        get.
        private set.
    
    /* The path of the file.
       
       May be blank; if so, the various Can* methods assume the directory is ".", the
       pwd. The value returned by this property will be blank in that case. */
    define public property Folder as character no-undo
        get.
        private set.
    
    /* The file's basename, defined as the last /-separated entry, including the extension */
    define public property Basename as character no-undo
        get.
        private set.
    
    /* The extension, defined as the last .-separated entry of the basename */
    define public property Extension as character no-undo
        get.
        private set.
    
    /* Indiucates whether the file exists. Returns TRUE if the Folder exists, and is a File */
    define public property FileExists as logical no-undo
        get():
            assign file-info:file-name = this-object:Name.
            // this file exists on disk and it is actually a file
            return (file-info:full-pathname ne ? and index(file-info:file-type, 'F':u) gt 0).
        end get.
    
    /* Indiucates whether the folder represented by the Folder exists. Returns TRUE if the Folder exists, and is a DIRECTORY */
    define public property FolderExists as logical no-undo
        get():
            FileInfoSetToFolder().
            // this file exists on disk and it is actually a file
            return (file-info:full-pathname ne ? and index(file-info:file-type, 'D':u) gt 0).
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
        var integer pos.
        var character firstPath, testName.
        
        Assert:NotNullOrEmpty(pFileName, 'File name').
        if pFileName eq '.':u then
            undo, throw new AssertionFailedError('File name cannot be "."').
        
        // we only work with slashes as path separators
        assign pFileName = replace(pFileName, StringConstant:BACKSLASH, mPathSeparator).
        // don't allow illegal characters in the filename
        if pReplacementChar eq ? then
        do:
            // on windows we can have C: or D: as the drive (first path-segment)
            if opsys eq 'win32':u then
            do:
                assign pos = index(pFileName, mPathSeparator).
                if pos gt 0 then
                do:
                    assign firstPath = substring(pFileName, 1, pos - 1)
                           testName  = substring(pFileName, pos + 1)
                           .
                    if not length(firstPath) eq 2 then
                        assign testName = pFileName.
                    else
                    // still check for other illegals
                    if index(firstPath, illegalChars[IDX_ASTERISK]) gt 0
                    or index(firstPath, illegalChars[IDX_CARET]) gt 0
                    // we allow the second character to be : not the first
                    or index(firstPath, illegalChars[IDX_COLON]) eq 1
                    or index(firstPath, illegalChars[IDX_DOUBLE_QUOTE]) gt 0
                    or index(firstPath, illegalChars[IDX_LEFT_ANGLE]) gt 0
                    or index(firstPath, illegalChars[IDX_RIGHT_ANGLE]) gt 0
                    or index(firstPath, illegalChars[IDX_PIPE]) gt 0
                    or index(firstPath, illegalChars[IDX_QUESTION_MARK]) gt 0
                    then
                        undo, throw new AssertionFailedError(substitute('File name "&1" contains illegal characters', pFileName)).
                end.
            end.    // WINDOWS-specific checks
            else
                assign testName = pFileName.
            
            if ContainsIllegalCharacters(testName) then
                undo, throw new AssertionFailedError(substitute('File name "&1" contains illegal characters', pFileName)).
        end.
        else
        do:
            // don't allow replacement with an illegal char
            if ContainsIllegalCharacters(pReplacementChar) then
                undo, throw new AssertionFailedError(substitute('Replacement string "&1" contains illegal characters', pReplacementChar)).
            
            assign pFileName = replace(pFileName, illegalChars[1], pReplacementChar)
                   pFileName = replace(pFileName, illegalChars[2], pReplacementChar)
                   pFileName = replace(pFileName, illegalChars[3], pReplacementChar)
                   pFileName = replace(pFileName, illegalChars[4], pReplacementChar)
                   pFileName = replace(pFileName, illegalChars[5], pReplacementChar)
                   pFileName = replace(pFileName, illegalChars[6], pReplacementChar)
                   pFileName = replace(pFileName, illegalChars[7], pReplacementChar)
                   pFileName = replace(pFileName, illegalChars[8], pReplacementChar)
                   .
        end.
        
        SplitFileName(pFileName).
    end constructor.
    
    /* Indicates whether a string has illegal characters anywhere in it.
       @param character A string to check
       @return logical TRUE if the string is not-null, and has at least one illegal character in it; FALSE otherwise */
    method private logical ContainsIllegalCharacters(input pValue as character):
        if pValue eq ? then
            return false.
        
        if index(pValue, illegalChars[IDX_ASTERISK]) gt 0
        or index(pValue, illegalChars[IDX_CARET]) gt 0
        or index(pValue, illegalChars[IDX_COLON]) gt 0
        or index(pValue, illegalChars[IDX_DOUBLE_QUOTE]) gt 0
        or index(pValue, illegalChars[IDX_LEFT_ANGLE]) gt 0
        or index(pValue, illegalChars[IDX_RIGHT_ANGLE]) gt 0
        or index(pValue, illegalChars[IDX_PIPE]) gt 0
        or index(pValue, illegalChars[IDX_QUESTION_MARK]) gt 0
        then
            return true.
        
        return false.
    end method.
    
    /** Returns an array of path entries
        
        @return character[] May be indeterminate if the path is empty */
    method public character extent GetSplitPath():
        var character[] split.
        var integer loop, cnt = num-entries(this-object:Folder, mPathSeparator).
        
        // do not check for the num-entries, since '' = 1
        if this-object:Folder eq '':u then
            return split.
        
        // the path always has a trailing /
        assign extent(split) = cnt - 1.
        do loop = 1 to cnt - 1:
            assign split[loop] = entry(loop, this-object:Folder, mPathSeparator).
        end.
        
        return split.
    end method.
    
    /* Splits a /-delimited file name into its component parts
       
       @param character A complete file name */
    method private void SplitFileName(input pFileName as character):
        var integer pos.
        var character filename = entry(num-entries(pFileName, mPathSeparator), pFileName, mPathSeparator).
        
        assign pos                  = r-index(filename, '.':u)
               this-object:Basename = filename
               .
        if pos gt 0 then
            assign this-object:Extension = substring(filename, pos + 1).
        
        assign pos = r-index(pFileName, mPathSeparator).
        if not pos eq 0 then
            assign this-object:Folder = substring(pFileName, 1, pos).
        else
            assign this-object:Folder = '':u.
        
        assign this-object:Name = this-object:Folder + this-object:Basename.
    end method.
    
    /* Creates this file's Folder
        
       This method does NOT check whether the folder can be created (via CanCreateFolder), but rather simply tries
       to create the folder tree, and returns FALSE if it fails.
       
       @return logical TRUE if the Folder was created. FALSE if the Folder already exists, or if an error was raised during creation */
    method public logical CreateFolder():
        var integer loop, cnt.
        var character newfolder, delim.
        
        FileInfoSetToFolder().
        
        if file-info:full-pathname eq ? then
        do:
            assign cnt = num-entries(this-object:Folder, mPathSeparator).
            do loop = 1 to cnt
            while os-error eq 0:
                assign newfolder += delim + entry(loop, this-object:Folder, mPathSeparator)
                       delim      = mPathSeparator
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
    
    /** Returns a logical value indicating whether the folder can be created.
    
        If any of the parent folders are not directories or are not writable, then
        return FALSE.
        
        Otherwise return TRUE.
        
        @return logical TRUE if the folder can be created, FALSE otherwise */
    method public logical CanCreateFolder():
        FileInfoSetToFolder().
        
        // if it does not exist in any form, check the parents
        if file-info:full-pathname eq ? then
        do:
            // we know that this folder does not exist, so we look up
            FileInfoFindExistingParent(file-info:file-name).
            // this will tell us whether we can create a folder under it.
            return FileInfoIsFolderAndWritable().
        end.
        else
            // this folder already exists, either as a file or directory or something else,
            // so we cannot create it
            return false.
    end method.
    
    /** Returns a logical value indicating whether the file can be created.
       
        If the Name already exists (as any type), then FALSE is returned.
        If the Folder exists, and is either a FILE or not writable, then FALSE is returned.
        If the Folder does not exist, then return the value of the CanCreateFolder() method.
        
        Otherwise return TRUE.
        
        @return logical TRUE if the file can be created, FALSE otherwise */
    method public logical CanCreateFile():
        assign file-info:file-name = this-object:Name.
        // does not exist in any form
        if file-info:full-pathname eq ? then
        do:
            FileInfoSetToFolder().
            if file-info:full-pathname eq ? then
                return CanCreateFolder().
            else
                return FileInfoIsFolderAndWritable().
        end.
        else
            // this name already exists, either as a file or directory or something else,
            // so we cannot create it
            return false.
    end method.
    
    /* Set the FILE-INFO FILE-NAME to the folder for this File. Uses "." if the folder is empty. */
    method private void FileInfoSetToFolder():
        if this-object:Folder eq '':u then
            assign file-info:file-name = '.':u.
        else
            assign file-info:file-name = this-object:Folder.
    end method.
    
    /* Checks if the current FILE-INFO is a FILE and has the WRITE flag
       set.
       
       @return logical TRUE if the current file-info is a file, and has the write flag set; FALSE otherwise */
    method private logical FileInfoIsFileAndWritable():
        if file-info:full-pathname eq ? then
            return false.
        
        // It is a file and the Write flag is set, so it is writable
        if  index(file-info:file-type, 'F':u) gt 0
        and index(file-info:file-type, 'W':u) gt 0
        then
            return true.
        
        // ... otherwise not
        return false.
    end method.
    
    /* Checks if the current FILE-INFO is a DIRECTORY and has the WRITE flag
       set.
       
       @return logical TRUE if the current file-info is a directory, and has the write flag set; FALSE otherwise */
    method private logical FileInfoIsFolderAndWritable():
        if file-info:full-pathname eq ? then
            return false.
        
        // It is a Directory and the Write flag is set, so it is writable
        if  index(file-info:file-type, 'D':u) gt 0
        and index(file-info:file-type, 'W':u) gt 0
        then
            return true.
        
        // ... otherwise not
        return false.
    end method.
    
    /* Indicates whether a file can be written to.
       
       @return logical TRUE if the file exists and can be written to. FALSE otherwise. */
    method public logical CanWriteToFile():
        assign file-info:file-name = this-object:Name.
        
        // does not exist in any form, so depends on parent folder permissions
        if file-info:full-pathname eq ? then
            return CanWriteToFolder().
        
        return FileInfoIsFileAndWritable().
    end method.
    
    /* Indicates whether the file's folder can be written to.
       
       If none of the folders exist then this method returns TRUE
       
       @return logical TRUE if the file exists and can be written to. FALSE otherwise. */
    method public logical CanWriteToFolder():
        var character path.
        
        FileInfoSetToFolder().
        
        // if it does not exist in any form, check the parents
        if file-info:full-pathname eq ? then
        do:
            FileInfoFindExistingParent(file-info:file-name).
            if not file-info:full-pathname eq ? then
                return FileInfoIsFolderAndWritable().
            
            // At this point, none of the specified parents exist
            assign path = file-info:file-name.
            
            // this is relative to something
            if not path begins '.':u
            and not path begins '/':u
            then
            do:
                // Can we write relative to the current path?
                assign file-info:file-name = '.':u.
                return FileInfoIsFolderAndWritable().
            end.
            
            // we are trying to create a root folder, and that's a no-go
            return false.
        end.
        
        return FileInfoIsFolderAndWritable().
    end method.
    
    /* Find the first/nearest existing folder for a path. A path may be a folder
       or a file.
       
       @param character A path. */
    method private void FileInfoFindExistingParent(input pPath as character):
        var integer len, pos.
        
        assign len = length(pPath)
               // folder always has trailing /
               pos = r-index(pPath, mPathSeparator, len - 1)
               .
        PATH-LOOP:
        do while pos gt 0:
            assign file-info:file-name = substring(pPath, 1, pos - 1)
                   // find the previous /
                   pos                 = r-index(pPath, mPathSeparator, pos - 1)
                   .
            // return the first parent we find
            if not file-info:full-pathname eq ? then
                return.
        end.
    end method.
    
    /* Creates an empty file on disk.
       
       This method does NOT check whether the file can be created (via CanCreateFile), but rather simply tries
       to create the file, and returns FALSE if it fails.
       
       @return logical TRUE if the file was created. FALSE if the file already exists, or if an error wa raised during creation. */
    method public logical CreateFile():
        assign file-info:file-name = this-object:Name.
        if file-info:full-pathname eq ? then
        do:
            CreateFolder().
            output to value(this-object:Name).
            output close.
            
            // reset to recalculate the full path
            assign file-info:file-name = this-object:Name.
            return (not file-info:full-pathname eq ?).
        end.
        
        return false.
        catch uncaught as Progress.Lang.Error:
            return false.
        end catch.
    end method.
    
    method override public logical Equals(input pObj as Progress.Lang.Object):
        if not valid-object(pObj) then
            return false.
        
        if super:Equals(pObj) then
            return true.
        
        if not type-of(pObj, File) then
            return false.
        
        return (this-object:Name eq cast(pObj, File):Name).
    end method.
    
    /** Returns the absolute file name of this object, if the file exists. Resolved using FILE-INFO
       
        @param character An absolute path. If the file does not exist, or cannot be resolved, the unknown value is returned */
    method public character AbsoluteFileName():
        assign file-info:file-name = this-object:Name.
        
        return file-info:full-pathname.
    end method.
    
    method override public character ToString():
        return this-object:Name.
    end method.
    
end class.