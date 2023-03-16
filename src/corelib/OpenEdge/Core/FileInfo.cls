/* *************************************************************************************************************************
Copyright (c) 2022 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : FileInfo
    Purpose     : An abstract path - represents a file or a folder
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2022-01-31
    Notes       : * The FILE-INFO system handle is used to determine various attributes
                    about this path.
                  * The path name cannot contain any of the following characters: < > : " | ? * ^
                  * Path always use / as a separator, since the ABL deals with that well on all platforms
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.AssertionFailedError.
using OpenEdge.Core.FileInfo.
using OpenEdge.Core.StringConstant.
USING Progress.Collections.IComparable.

@since(rel='12.6.0').
class OpenEdge.Core.FileInfo
abstract
serializable implements IComparable<FileInfo>:
               
    // On Windows in particular, these characters are illegal in path (file or folder) names
    var private character[8] mIllegalChars = ['<':u,'>':u,':':u,'"':u,'|':u,'?':u,'*':u, '^':u].
    var private integer IDX_LEFT_ANGLE=1, IDX_RIGHT_ANGLE=2, IDX_COLON=3, IDX_DOUBLE_QUOTE=4,
                        IDX_PIPE=5, IDX_QUESTION_MARK=5, IDX_ASTERISK=7, IDX_CARET=8.
                        
    // Indicates what FILE-INFO flag this path is: F(ile) or D(irectory)
    var private serializable character mFileInfoType.

    /* Returns a Windows short name for a path (file or directory). Accessed via the GetShortName() method; this
       forward declaration can be un-preprocessed, since the DLL is only resolved when the procedure is run.
       
       The Ascii version of GetShortPathName should be used and not the Wide, since the W uses UTF-16 which is not
       supported in ABL.
        
       From https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-getshortpathnamea
       DWORD GetShortPathNameA(
        [in]  LPCSTR lpszLongPath,
        [out] LPSTR  lpszShortPath,
        [in]  DWORD  cchBuffer
        ); */
    procedure GetShortPathNameA external 'KERNEL32.DLL':
        define input  parameter lpszLongPath as character.
        define input  parameter lpszShortPath as memptr.
        define input  parameter cchBuffer as long.
        define return parameter len as long.
    end procedure.
    
    /* The complete path name */
    define public property Name as character no-undo
        get.
        protected set.
    
    /* The path's basename, defined as the last /-separated entry */
    define public property Basename as character no-undo
        get.
        protected set.
    
    /* Indicates whether the path exists. Returns TRUE if it exists on disk, and FALSE otherwise.
       Not serializable since the physical file on disk is checked on each call */
    define non-serializable public property Exists as logical no-undo
        get():
            SetFileInfo().
            return this-object:HasAttribute(mFileInfoType).
        end get.
    
    /* Indicates whether the path is writable. Returns TRUE if it exists and is writable, and FALSE otherwise.  */
    define non-serializable public property CanWrite as logical no-undo
        get():
            SetFileInfo().
            return this-object:HasAttribute('W').
        end get.
    
    /* Indicates whether a path with this Name can be read. Returns TRUE if the path exists and can be read, FALSE otherwise.
       Not serializable since the physical file on disk is checked on each call */
    define non-serializable public property CanRead as logical no-undo
        get():
            SetFileInfo().
            return this-object:HasAttribute('R').
        end get.
    
    /* Indicates whether a path with this Name can be created. Returns TRUE if be created, FALSE otherwise */
    define abstract public property CanCreate as logical no-undo
        get.
    
    /* Indicates the creation timestamp */
    define non-serializable public property CreatedAt as datetime-tz no-undo
        get():
            SetFileInfo().
            // use the current timezone
            return add-interval(datetime(file-info:file-create-date), file-info:file-create-time, 'seconds':u).
        end get.
    
    /* Indicates the last-touched timestamp */
    define non-serializable public property LastUpdatedAt as datetime-tz no-undo
        get():
            SetFileInfo().
            // use the current timezone
            return add-interval(datetime(file-info:file-mod-date), file-info:file-mod-time, 'seconds':u).
        end get.
    
    /* TRUE if this is a relative path. FALSE otherwise. A relative path is one that starts with "." or with no "/".
       The exception to this is if the path starts with "[A-Z]:/", which signifies an absolute path on Windows. */
    define public property IsRelativePath as logical no-undo
        get.
        private set.
    
    /* Constructor
       
       @param character A path - not null. Cannot contain any of the following characters: <>:"|?*
       @param character The file-info type: D or F typically */
    constructor protected FileInfo(input pPath as character,
                                   input pType as character):
        this-object(pPath, pType, ?).
    end constructor.
    
    /* Constructor. Sanitises the path - ie replaces illegal characters with the input replacement char(s).
       
       @param character A path - not null, not ".."  Paths may start with "." or ".."
       @param character A/the replacement character that will replace the illegal characters. If ? is passed, no replacements
                        are done, and the path name cannot contain any of the following characters: <>:"|?* */
    constructor protected FileInfo(input pPath as character,
                                   input pType as character,
                                   input pReplacementChar as character):
        var character drive, firstPath.
        var integer entries.
        
        Assert:NotNull(pPath, 'Path name').
        
        // we only work with slashes as path separators
        assign pPath         = replace(trim(pPath), StringConstant:BACKSLASH, '/')
               mFileInfoType = pType
               .
        if pPath eq '..' then
            undo, throw new AssertionFailedError('Path cannot be ".."').
        
        // don't allow illegal characters in the filename
        if not pReplacementChar eq ? then
        do:
            // don't allow replacement with an illegal char
            if StringContainsIllegalCharacters(pReplacementChar) then
                undo, throw new AssertionFailedError(substitute('Replacement string "&1" contains illegal characters', pReplacementChar)).
            
            assign pPath = replace(pPath, mIllegalChars[1], pReplacementChar)
                   pPath = replace(pPath, mIllegalChars[2], pReplacementChar)
                   pPath = replace(pPath, mIllegalChars[3], pReplacementChar)
                   pPath = replace(pPath, mIllegalChars[4], pReplacementChar)
                   pPath = replace(pPath, mIllegalChars[5], pReplacementChar)
                   pPath = replace(pPath, mIllegalChars[6], pReplacementChar)
                   pPath = replace(pPath, mIllegalChars[7], pReplacementChar)
                   pPath = replace(pPath, mIllegalChars[8], pReplacementChar)
                   .
        end.
        
        assign this-object:Name = pPath
               entries          = num-entries(this-object:Name, '/')
               .
        if entries gt 0 then
            assign this-object:Basename = entry(entries, this-object:Name, '/').
        
        // is the path relative?
        // simple relative pathing
        if this-object:Name begins '.'
        or this-object:Name begins '..'
        or this-object:Name eq '':u
        then
            assign this-object:IsRelativePath = true.
        else
        // Covers / or //
        if this-object:Name begins '/':u then
            assign this-object:IsRelativePath = false.
        else
            assign this-object:IsRelativePath = true.
        
        // For Windows-style paths, drives are not relative: c:/
        // This may give a false-negative
        assign firstPath = entry(1, this-object:Name, '/')
               drive     = substring(firstPath, 1, 1)
               .
        // only A-Z allowed.
        if length(firstPath) eq 2
        and drive ge 'A'
        and drive le 'Z'
        and index(firstPath, ':') gt 0
        then
            assign this-object:IsRelativePath = false.
    end constructor.
    
    /* Indicates whether a string has illegal characters anywhere in it.
       
       @param character A string to check
       @return logical TRUE if the string is not-null, and has at least one illegal character in it; FALSE otherwise */
    method private logical StringContainsIllegalCharacters(input pValue as character):
        if pValue eq ? then
            return false.
        
        if index(pValue, mIllegalChars[IDX_ASTERISK]) gt 0
        or index(pValue, mIllegalChars[IDX_CARET]) gt 0
        or index(pValue, mIllegalChars[IDX_COLON]) gt 0
        or index(pValue, mIllegalChars[IDX_DOUBLE_QUOTE]) gt 0
        or index(pValue, mIllegalChars[IDX_LEFT_ANGLE]) gt 0
        or index(pValue, mIllegalChars[IDX_RIGHT_ANGLE]) gt 0
        or index(pValue, mIllegalChars[IDX_PIPE]) gt 0
        or index(pValue, mIllegalChars[IDX_QUESTION_MARK]) gt 0
        then
            return true.
        
        return false.
    end method.
    
    /* Returns a flag indicating whether the path is legal for the current OS.
       
       @return logical TRUE if the path Name contains no illegal characters for the current platform, FALSE otherwise */
    method public logical HasLegalName():
        var integer pos, cnt, loop.
        var character pathEntry, testName.
        
        // on windows we can have C: or D: as the drive (first path-segment)
        if opsys eq 'win32':u then
        do:
            assign pos = index(this-object:Name, '/').
            if pos gt 0 then
            do:
                assign pathEntry = substring(this-object:Name, 1, pos - 1)
                       testName  = substring(this-object:Name, pos + 1)
                       .
                if not length(pathEntry) eq 2 then
                    assign testName = this-object:Name.
                else
                // still check for other illegals
                if index(pathEntry, mIllegalChars[IDX_ASTERISK]) gt 0
                or index(pathEntry, mIllegalChars[IDX_CARET]) gt 0
                // we allow the second character to be : not the first
                or index(pathEntry, mIllegalChars[IDX_COLON]) eq 1
                or index(pathEntry, mIllegalChars[IDX_DOUBLE_QUOTE]) gt 0
                or index(pathEntry, mIllegalChars[IDX_LEFT_ANGLE]) gt 0
                or index(pathEntry, mIllegalChars[IDX_RIGHT_ANGLE]) gt 0
                or index(pathEntry, mIllegalChars[IDX_PIPE]) gt 0
                or index(pathEntry, mIllegalChars[IDX_QUESTION_MARK]) gt 0
                then
                    return false.
            end.
            
            if StringContainsIllegalCharacters(testName) then
                return false.
            
            // Based on https://stackoverflow.com/a/31976060/18177
            assign cnt = num-entries(this-object:Name, '/').
            PATH-LOOP:
            do loop = 1 to cnt:
                assign pathEntry = entry(loop, this-object:Name, '/')
                       pos       = index(pathEntry, '.')
                       .
                // "." and ".." are legal path names
                if pathEntry eq '.'
                or pathEntry eq '..'
                then
                    next PATH-LOOP.
                
                // Names cannot end in a space or dot.
                // We need to double-tilde the dot!
                if pathEntry matches '*~~.'
                or pathEntry matches '* '
                then
                    return false.
                
                // leading "." is allowed
                if pos eq 1 then
                    assign pathEntry = ''.
                else
                if pos gt 0 then
                    assign pathEntry = substring(pathEntry, 1, pos - 1).
                
                if pathEntry eq 'CON'
                or pathEntry eq 'PRN'
                or pathEntry eq 'AUX'
                or pathEntry eq 'NUL'
                or pathEntry eq 'COM1'
                or pathEntry eq 'COM2'
                or pathEntry eq 'COM3'
                or pathEntry eq 'COM4'
                or pathEntry eq 'COM5'
                or pathEntry eq 'COM6'
                or pathEntry eq 'COM7'
                or pathEntry eq 'COM8'
                or pathEntry eq 'COM9'
                or pathEntry eq 'LPT1'
                or pathEntry eq 'LPT2'
                or pathEntry eq 'LPT3'
                or pathEntry eq 'LPT4'
                or pathEntry eq 'LPT5'
                or pathEntry eq 'LPT6'
                or pathEntry eq 'LPT7'
                or pathEntry eq 'LPT8'
                or pathEntry eq 'LPT9'
                then
                    return false.
            end.
        end.    // WINDOWS-specific checks
        
        // Linux doesn't care
        return true.
    end method.
    
    /* Creates the path on disk.
       
       Note that no error is thrown from this method; FALSE is returned instead.
       
       @return logical TRUE if the file was created. FALSE if the file already exists, or if an error wa raised during creation. */
    method abstract public logical Create().
    
    /* Deletes the path on disk.
    
       Note that no error is thrown from this method; FALSE is returned instead.
       
       @return logical TRUE if the path was deleted. FALSE if the path does not exist, or does not have write permissions,
                       or if an error was raised during creation. */
    method abstract public logical Delete().
    
    /** Returns the absolute path. If the path does not exist on this host, or the file on this host is not
        the correct type, the unknown value is returned.
        
        @return character An absolute (file system) representation of this path */
    method public character AbsolutePath():
        var character absPath.
        
        SetFileInfo().
        assign absPath = file-info:full-pathname.
        // Path does not exist
        if absPath eq ?
        // Path exists but is not the expected type
        or index(file-info:file-type, mFileInfoType) eq 0
        then
            return ?.
        
        return replace(absPath, StringConstant:BACKSLASH, '/').
    end method.
    
    method override public logical Equals(input pRef as Progress.Lang.Object):
        if super:Equals(pRef) then
            return true.
        
        // in 12.6 this deals nicely with invalid references
        if not type-of(pRef, FileInfo) then
            return false.
        
        return (this-object:Name eq cast(pRef, FileInfo):Name).
    end method.
    
    method override public character ToString():
        return this-object:Name.
    end method.
    
    /* Sets the FILE-INFO value to represent this path */
    method protected void SetFileInfo():
        assign file-info:file-name = this-object:Name.
    end method.
    
    /* Indicates whether the path has certain characteristics, as per FILE-TYPE
       attributes. See https://docs.progress.com/bundle/abl-reference/page/FILE-TYPE-attribute.html for
       details.
       
       The FILE-INFO handle must be set before calling this method; this is typically done using SetFileInfo().
       
       @param character An attribute value - a single character from the documented values
       @return logical TRUE if the path exists on disk, AND is of the correct type (D or F) AND has the input attribute. FALSE otherwise */
    method protected logical HasAttribute(input pAttribute as character):
        Assert:NotNullOrEmpty(pAttribute, 'Attribute').
        
        if file-info:full-pathname eq ? then
            return false.
        
        // It is of the correct type, and the attribute is set
        if  index(file-info:file-type, mFileInfoType) gt 0
        and index(file-info:file-type, pAttribute) gt 0
        then
            return true.
        
        // ... otherwise not
        return false.
    end method.
    
    /* Returns the Windows short name for this path. The absolute - resolved - path is returned. Backslashes are converted
       to / for the path separator
       
       @return character The short path. On non-Windows, or if an error is encountered, the absolute path is returned. */
    method public character GetShortName():
        var character shortName, path.
        var integer len, maxLen.
        var memptr mShort.
        
        if opsys eq 'WIN32' then
        do:
            // The short name can't be bigger than the full path
            assign path   = replace(this-object:AbsolutePath(), '/', StringConstant:BACKSLASH).
                   maxLen = length(path, 'raw') + 1
                   .
            set-size(mShort) = maxLen.
            
            run GetShortPathNameA(path, mShort, maxLen, output len).
            // if the return value = 0, an error occurred
            if len eq 0 then
                assign shortName = path.
            else
                assign shortName = get-string(mShort, 1).
            
            return replace(shortName, StringConstant:BACKSLASH, '/').
        end.    // WINDOWS
        
        return this-object:AbsolutePath().
        finally:
            set-size(mShort) = 0.
        end finally.
    end method.
    
    /* Comparison method, used by SortedSet's default comparer
        FileInfo is inherited by OpenEdge.Core.File and OpenEdge.Core.Folder, so both object types can be
        passed using FileInfo.
        
        - If the returned value is less than 0 (zero), then the current object sorts before the object passed in.
        - If the returned value equals 0 (zero) , then the current object occupies the same position in the sort order.
        - If the returned value is greater than 0(zero), then the current object sorts after the object passed in.
        - If either object's Value is the unknown value (?), then that sorts high/early/before
        
        @param FileInfo The object to compare to (Can be type File or Folder).
        @return integer  0 = same object
                        +1 = sorts after
                        -1 = sorts before   */
    method public integer CompareTo(input pOther as FileInfo):
        Assert:NotNull(pOther, 'CompareTo object').
        
        if this-object:Name eq pOther:Name then
            return 0.
        else
        // unknown values are not allowed
        if this-object:Name gt pOther:Name
        then
            return +1.
        else
        if this-object:Name lt pOther:Name
        then
            return -1.
        
        // this will raise an error in the Comparer; we should never get here though.
        return ?.
    end method.
    
end class.