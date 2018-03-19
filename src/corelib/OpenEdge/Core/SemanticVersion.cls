/* *************************************************************************************************************************
Copyright (c) 2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : SemanticVersion
    Purpose     : A semantic version representation. A semver is 
                    MAJOR.MINOR.PATCH-PRERELEASE+BUILDMETADATA
                  
                  where the prerelease part is optional. 
                  The MAJOR, MINOR and PATCH releases are integer values.
                  The PRERELEASE is a string/character
                  The BUILDMETADATA is a string/characaer
                  The delimiters ("." / "-" / "+") are not stored in the object  
    Author(s)   : pjudge
    Created     : 2017-09-05
    Notes       : * From http://semver.org/spec/v2.0.0.html
                  * Defaults to 1.0.0 with no prerelease or build metadata
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.SemanticVersion.
using Progress.Lang.Object.

class OpenEdge.Core.SemanticVersion serializable:
    /* The major version */
    define public property Major as integer no-undo get. private set.
    
    /* The minor version */
    define public property Minor as integer no-undo get. private set.
    
    /* The patch version */
    define public property Patch as integer no-undo get. private set.
    
    /* The pre-release version. This is dash/"-" prefixed  */
    define public property Prerelease as character no-undo get. private set.

    /* (optional) The buld metadata. This is plus/"+" prefixed */ 
    define public property BuildMetadata as character no-undo get. private set.
    
    /* Default constructor */
    constructor public SemanticVersion():
        this-object(1, 0, 0).
    end method.
    
    /* Constructor
       
       @param integer The major version; must be >= 0
       @param integer The minor version; must be >= 0
       @param integer The patch version; must be >= 0  */
    constructor public SemanticVersion(input pMajor as integer,
                                       input pMinor as integer,
                                       input pPatch as integer):
        this-object(pMajor, pMinor, pPatch, '':u).
    end constructor.
    
    /* Constructor
       
       @param integer The major version; must be >= 0
       @param integer The minor version; must be >= 0
       @param integer The patch version; must be >= 0
       @param character the prelease version; must be non-null */
    constructor public SemanticVersion(input pMajor as integer,
                                       input pMinor as integer,
                                       input pPatch as integer,
                                       input pPreRel as character):
        this-object(pMajor, pMinor, pPatch, '':u, '':u).
    end method.
    
    /* Constructor
       
       @param integer The major version; must be >= 0
       @param integer The minor version; must be >= 0
       @param integer The patch version; must be >= 0
       @param character the prelease version; must be non-null 
       @param character build metadata ; must be non-null */
    constructor public SemanticVersion(input pMajor as integer,
                                       input pMinor as integer,
                                       input pPatch as integer,
                                       input pPreRel as character,
                                       input pBuildMeta as character):
        Assert:IsZeroOrPositive(pMajor, 'Major version').
        Assert:IsZeroOrPositive(pMinor, 'Minor version').
        Assert:IsZeroOrPositive(pPatch, 'Patch version').
        Assert:NotNull(pPreRel, 'Prerelease version').
        Assert:NotNull(pBuildMeta, 'Build metadata').
        
        assign this-object:Major      = pMajor
               this-object:Minor      = pMinor
               this-object:Patch      = pPatch
               this-object:PreRelease = pPreRel
               this-object:BuildMetadata     = pBuildMeta
               .
    end method.
    
    method override public character ToString():
        define variable version as character no-undo.
        
        assign version = substitute('&1.&2.&3':u,
                              Major,
                              Minor,
                              Patch).
        
        if PreRelease ne '':u then
            assign version = substitute('&1-&2':u,
                                version,
                                PreRelease).
        
        if BuildMetadata ne '':u then
            assign version = substitute('&1+&2':u,
                                version,
                                BuildMetadata).
        
        return version.
    end method. 
    
    /* Parses a version string and returns a SemanticVerison object
       
       @param character An appropriately-formatted version string
       @return SemanticVersion A SemanticVersion object */
    method static public SemanticVersion Parse(input pVersion as character):
        define variable chrPos as integer no-undo.
        define variable dotPos as integer no-undo.
        define variable semVer as SemanticVersion no-undo.
        
        Assert:NotNull(pVersion, 'Version string').
        
        // Use a simple default version
        assign semVer = new SemanticVersion(1, 0, 0).
        
        // BUILD METADATA
        assign chrPos = index(pVersion, '+':u). 
        if chrPos gt 0 then
            assign semVer:BuildMetadata = substring(pVersion, chrPos + 1)
                   pVersion             = substring(pVersion, 1, chrPos - 1)
                   .
        // PRERELEASE
        assign chrPos = index(pVersion, '-':u). 
        if chrPos gt 0 then
            assign semVer:PreRelease = substring(pVersion, chrPos + 1)
                   pVersion          = substring(pVersion, 1, chrPos - 1)
                   .
        // MAJOR.MINOR.PATCH
        if num-entries(pVersion, '.':u) ge 1 then
            assign semVer:Major = integer(entry(1, pVersion, '.':u)).
        if num-entries(pVersion, '.':u) ge 2 then
            assign semVer:Minor = integer(entry(2, pVersion, '.':u)).
        if num-entries(pVersion, '.':u) ge 3 then
            assign semVer:Patch = integer(entry(3, pVersion, '.':u)).
        
        return semVer.
    end method.
    
    method override public logical Equals(input pCompare as Object):
        if super:Equals(pCompare) then
            return true.
        // BUILD METADATA is NOT 
        if type-of(pCompare, SemanticVersion) then
            return (    this-object:Major         eq cast(pCompare, SemanticVersion):Major
                    and this-object:Minor         eq cast(pCompare, SemanticVersion):Minor
                    and this-object:Patch         eq cast(pCompare, SemanticVersion):Patch
                    and this-object:PreRelease    eq cast(pCompare, SemanticVersion):PreRelease
                    and this-object:BuildMetadata eq cast(pCompare, SemanticVersion):BuildMetadata ).
        
        return false.
    end method.
    
end class.