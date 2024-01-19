/* *************************************************************************************************************************
Copyright (c) 2017-2018, 2021-2023 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
using Progress.Collections.IComparable.
using Progress.Collections.IHashable.
using Progress.Lang.Object.

class OpenEdge.Core.SemanticVersion
serializable
implements IComparable<SemanticVersion>
         , IHashable:
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
        this-object(0, 0, 0).
    end constructor.
    
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
        this-object(pMajor, pMinor, pPatch, pPreRel, '':u).
    end constructor.
    
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
        
        assign this-object:Major         = pMajor
               this-object:Minor         = pMinor
               this-object:Patch         = pPatch
               this-object:PreRelease    = pPreRel
               this-object:BuildMetadata = pBuildMeta
               .
    end constructor.
    
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
        define variable semVer as SemanticVersion no-undo.
        
        Assert:NotNull(pVersion, 'Version string').
        
        // Use a simple default version
        assign semVer = new SemanticVersion(0, 0, 0).
        if pVersion eq '':u then
            return semVer.
        
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
            return true. // Objects are the same per original equality check.

        // If comparing against another SemanticVersion then we should check each property.
        if type-of(pCompare, SemanticVersion) then
            return (    this-object:Major         eq cast(pCompare, SemanticVersion):Major
                    and this-object:Minor         eq cast(pCompare, SemanticVersion):Minor
                    and this-object:Patch         eq cast(pCompare, SemanticVersion):Patch
                    and this-object:PreRelease    eq cast(pCompare, SemanticVersion):PreRelease
                    and this-object:BuildMetadata eq cast(pCompare, SemanticVersion):BuildMetadata ).
        
        return false.
    end method.

    /* Comparison method, used by SortedSet's default comparer
        - used specs from https://semver.org/spec/v2.0.0.html to do compare
          - per the spec, "Build metadata MUST be ignored when determining version precedence. Thus two versions 
                           that differ only in the build metadata, have the same precedence.", so it just
                           sorts mormally.
                           
        - If the returned value is less than 0 (zero), then the current object sorts before the object passed in.
        - If the returned value equals 0 (zero) , then the current object occupies the same position in the sort order.
        - If the returned value is greater than 0(zero), then the current object sorts after the object passed in.
        - If either object's Value is the unknown value (?), then that sorts high/early/before
        
        @param SemanticVersion The object to compare to.
        @return integer  0 = same object
                        +1 = sorts after
                        -1 = sorts before   */
    method public integer CompareTo(input pOther as SemanticVersion):
        Assert:NotNull(pOther, 'CompareTo object').
        
        if this-object:Major         eq pOther:Major and
           this-object:Minor         eq pOther:Minor and
           this-object:Patch         eq pOther:Patch and
           this-object:Prerelease    eq pOther:Prerelease and
           this-object:BuildMetadata eq pOther:BuildMetadata
        then
            return 0.

        // Check Major Version
        if this-object:Major gt pOther:Major
        then
            return +1.
        else
        if this-object:Major lt pOther:Major
        then
            return -1.
               
        // Check Minor Version
        if this-object:Minor gt pOther:Minor
        then
            return +1.
        else        
        if this-object:Minor lt pOther:Minor
        then
            return -1.
            
        // Check Patch Version
        if this-object:Patch gt pOther:Patch
        then
            return +1.
        else        
        if this-object:Patch lt pOther:Patch
        then
            return -1.

        // Check Prerelease Version.  If Prerelease version has a value
        // it should sort before an empty value since releases for customers
        // have no Prerelease value.  https://semver.org/spec/v2.0.0.html explains
        // prerelease precedence.
        if this-object:Prerelease gt "" and
           pOther:Prerelease eq ""
        then
            // We want a prerelease value to go before blank
            return -1.
        else
        if this-object:Prerelease eq "" and
           pOther:Prerelease gt ""
        then
            // We want a blank value to go after prerelease value
            return +1.
        
        // Sort by Prerelease when both values are present
        if this-object:Prerelease gt pOther:Prerelease
        then
            return +1.
        else        
        if this-object:Prerelease lt pOther:Prerelease
        then
            return -1.
        
        //  Normal Sort by BuildMetadata
        if this-object:BuildMetadata gt pOther:BuildMetadata
        then
            return +1.
        else        
            return -1.
            
        // this will raise an error in the Comparer; we should never get here though.
        return ?.
    end method.

    /* Hashing method for creating a proper index for use with Progress.Collections.HashMap

        @return integer Result of the hash-code method using this object's comparable value(s) */
    method public integer HashCode ( ):
        // In order to create a meaningful hash for an object instance,
        // we should follow suite with how the Equals() logic works.
        // By using the full class name plus the object's comparable value(s)
        // this should be consistent for any instance of this object type.

        // In limited testing, performance of hash-code({individual properties})
        // appears to be faster than hash-code(this-object:ToString())
        if this-object:BuildMetadata ne '':u then
            return hash-code(this-object:GetClass():TypeName, this-object:Major, this-object:Minor, this-object:Patch, this-object:PreRelease, this-object:BuildMetadata).
        
        if this-object:PreRelease ne '':u then
            return hash-code(this-object:GetClass():TypeName, this-object:Major, this-object:Minor, this-object:Patch, this-object:PreRelease).
            
        return hash-code(this-object:GetClass():TypeName, this-object:Major, this-object:Minor, this-object:Patch).
    end method. 
    
end class.