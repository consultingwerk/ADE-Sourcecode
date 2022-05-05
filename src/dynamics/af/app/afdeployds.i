/* Copyright (c) 2006 Progress Software Corporation.  All Rights Reserved. */
/*------------------------------------------------------------------------
    File        : afdeployds.i
    Purpose     : Defines the Deployment dataset for Deployment Automation

    Author(s)   : pjudge
    Created     : 8/3/2006
    Notes       : Created from scratch
  ----------------------------------------------------------------------*/
/* Top- and task-level temp-tables */
define temp-table TaskOrder no-undo
    field ReleaseVersion  as character    initial ?
    field TaskCategory    as character /* Package, Build */
    field TaskName        as character
    field TaskOrder       as integer
    field TaskAPI         as character    /*defaults to TaskName, unused */
    index idxMain
        ReleaseVersion
        TaskCategory
        TaskOrder.

define temp-table Deployment no-undo
    field Enabled            as logical
    field Encoding           as character    initial ?
    field DeploymentRoot     as character
    field ReleaseVersion     as character
    field PreviousRelease    as character
    index idxMain as primary
        ReleaseVersion
    .

define temp-table Task no-undo
    field ReleaseVersion        as character    xml-node-type 'Hidden':u
    field TaskId                as integer      /*xml-node-type 'Attribute':u*/
    field Enabled               as logical      initial True
    field DeploymentType        as character    initial 'All':u
    
    field Name                  as character
    index idxMain as primary /*unique causes gpf*/
        TaskId
    index idxParent
        ReleaseVersion
    .
        
define temp-table Logging    no-undo
    field ReleaseVersion    as character    xml-node-type 'Hidden':u
    field Enabled           as logical
    field LogLevel          as character    initial 'Warning':u
    field LogFile           as character
    field LogAppend         as logical      initial no
    field LogLevelEnum      as integer
    field LogCategory       as character    initial '*':u
    index idxParent
        ReleaseVersion.

define temp-table ApiOverride no-undo
    field ReleaseVersion    as character    xml-node-type 'Hidden':u
    field TaskName          as character
    field ApiFile           as character
    field ApiMethod         as character
    field Enabled           as logical        initial yes
    index idxParent
        ReleaseVersion
    .
                
/** Task Temp-Tables **/
/* This table defines the changeset actions to take */
define temp-table Changeset no-undo
    field TaskId            as integer      xml-node-type 'Hidden':u
    field ReleaseVersion    as character    xml-node-type 'Hidden':u
    
    field CreateReleaseVersion as logical initial No
    field ResetDataModified    as logical initial No
    index idxParent
        ReleaseVersion
        TaskId
    .    
    
define temp-table DumpData no-undo
    field TaskId            as integer      xml-node-type 'Hidden':u
    field ReleaseVersion    as character    xml-node-type 'Hidden':u
    
    field Target            as character
    field LobDir            as character
    field Filename          as character
    field Db                as character
    field Encoding          as character    initial ?
    field CharacterMapping  as character    initial 'NO-MAP':u
    index idxParent
        ReleaseVersion
        TaskId
    .

define temp-table DumpDefinition no-undo
    field TaskId            as integer      xml-node-type 'Hidden':u
    field ReleaseVersion    as character    xml-node-type 'Hidden':u
    
    field Db                as character
    field Filename          as character
    field Encoding          as character    initial ?
    field Target            as character
    field RcodePosition     as logical      initial Yes
    index idxParent
        ReleaseVersion
        TaskId
    .
    
define temp-table DumpSeqValue no-undo
    field TaskId            as integer      xml-node-type 'Hidden':u
    field ReleaseVersion    as character    xml-node-type 'Hidden':u
    
    field Db                as character
    field Encoding          as character    initial ?
    field Target            as character
    index idxParent
        ReleaseVersion
        TaskId
    .
        
define temp-table ExportReleaseVersion no-undo
    field TaskId                as integer      xml-node-type 'Hidden':u
    field ReleaseVersion        as character    xml-node-type 'Hidden':u
    
    field GenerateVersionData   as logical
    field GeneratePatchField    as logical
    field PatchFileName         as character    /* # */
    field GenerateADO           as logical
    field GenerateFullDataset   as logical
    field PatchLevel            as character    /* # */
    field AdoListingFile        as character    /* # */
    field Target                as character
    field DefaultTarget         as character
    field ResetDataModified     as logical    initial yes
    index idxParent
        ReleaseVersion
        TaskId
    .
    
define temp-table DumpIncrementalDefs no-undo
    field TaskId            as integer      xml-node-type 'Hidden':u
    field ReleaseVersion    as character    xml-node-type 'Hidden':u
    
    field SourceDb          as character
    field TargetDb          as character
    field Encoding          as character    initial ?
    field IndexMode         as character    initial 'Inactive':u
    field TargetDirectory   as character    /* # */
    field TargetFile        as character    initial 'delta.df':u
    field RenameFile        as character
    index idxParent
        ReleaseVersion
        TaskId
    .

define temp-table DumpClassCache no-undo
    field TaskId                as integer      xml-node-type 'Hidden':u
    field ReleaseVersion        as character    xml-node-type 'Hidden':u
    
    field Name                  as character
    field Target                as character
    index idxParent
        ReleaseVersion
        TaskId
    .
    
define temp-table DumpEntityCache no-undo
    field TaskId            as integer      xml-node-type 'Hidden':u
    field ReleaseVersion    as character    xml-node-type 'Hidden':u
    
    field LanguageList      as character
    field Target            as character    
    index idxParent
        ReleaseVersion
        TaskId
    .    
    
define temp-table Generate4GLObjects no-undo
    field TaskId                        as integer      xml-node-type 'Hidden':u
    field ReleaseVersion                as character    xml-node-type 'Hidden':u
    
    field Target                        as character    /* # */
    field ResultCodeList                as character
    field CompileEnabled                as logical        initial No
    field CompileMD5                    as logical        initial No
    field CompileMinSize                as logical        initial No
    field CompileTarget                 as character    /* # */
    field LanguageList                  as character
    field IncludeContainedInstances     as logical        initial Yes
    field SuperProcedureLocation        as character      initial 'Constructor':u
    field IncludeViewersForDatafields   as logical        initial No        
    field ThinRendering                 as logical        initial Yes
    field PluginProcedure               as character      initial 'ry/app/rygen4glhp.p':u
    index idxParent
        ReleaseVersion
        TaskId
    .
    
define temp-table BuildStaticCode no-undo
    field TaskId              as integer      xml-node-type 'Hidden':u
    field ReleaseVersion      as character    xml-node-type 'Hidden':u
    
    field RemoveRcode         as logical        initial Yes
    field XrefAppend          as logical        initial No
    field XrefFile            as character      initial ?
    field XrefEnable          as logical        initial No
    field CompileSubDir       as logical        initial Yes
    field CompileMinSize      as logical        initial No
    field CompileMD5          as logical        initial No
    field SaveInto            as character    /* # */
    field StreamIO            as logical        initial No
    field DebugListingEnable  as logical        initial No
    field DebugListFile       as character      initial ?
    field ListingAppend       as logical        initial No
    field ListingFile         as character      initial ?
    field ListingPageWidth    as integer        initial 80
    field ListingPageSize     as integer        initial 60
    Field EncryptEnable       as logical        initial No
    field EncryptKey          as character
    field ListingEnable       as logical        initial No
    field DefaultFileMask     as character      initial '*.p,*.w,*.cls':u
    field SaveRCode           as logical        initial Yes
    
    field StringXrefEnable    as character      initial No
    field StringXrefFile      as character      initial ?
    field StringXrefAppend    as logical        initial No
    
    field Languages           as character      initial ?
    field TextSegmentGrowthFactor as decimal    initial ?
    field PreProcessEnable    as logical        initial No
    field PreProcessDir       as character      initial ?    /* # */
    index idxParent
        ReleaseVersion
        TaskId
    .
    
define temp-table BuildLibrary no-undo
    field TaskId                as integer      xml-node-type 'Hidden':u
    field ReleaseVersion        as character    xml-node-type 'Hidden':u
    
    field Name                  as character
    field Target                as character    /* # */
    field FileMask              as character    initial '*.r':u    /* intiial filemask */
    field Recurse               as logical      initial No
    field PathType              as character    initial 'Rel':u
    field Encoding              as character    initial ?        
    index idxParent
        ReleaseVersion
        TaskId
    .

define temp-table DeployStaticCode no-undo
    field TaskId                as integer      xml-node-type 'Hidden':u
    field ReleaseVersion        as character    xml-node-type 'Hidden':u
    
    field SiteType              as character
    field WriteListing          as logical
    field WriteListingOnly      as logical
    field ListingFile           as character
    field Target                as character    /* # */
    field DynamicsRoot          as character    /* # */
    index idxParent
        ReleaseVersion
        TaskId
    .

define temp-table BuildPackage no-undo
    field TaskId              as integer      xml-node-type 'Hidden':u
    field ReleaseVersion      as character    xml-node-type 'Hidden':u
    
    field Target              as character
    index idxParent
        ReleaseVersion
        TaskId
    .    
    
define temp-table DumpDataset no-undo
    field TaskId                as integer      xml-node-type 'Hidden':u
    field ReleaseVersion        as character    xml-node-type 'Hidden':u
    
    field DeployDeletions       as logical    initial no
    field DeployAllModified     as logical    initial no
    field RemoveDeletions       as logical    initial no
    field ResetDataModified     as logical    initial no
    field Target                as character
    field DefaultTarget         as character
    field DeployByDate          as logical    initial no
    field DeployFullDataset     as logical    initial yes
    index idxParent
        ReleaseVersion
        TaskId
    .

define temp-table CreatePatchFile no-undo
    field TaskId                as integer      xml-node-type 'Hidden':u
    field ReleaseVersion        as character    xml-node-type 'Hidden':u
        
    field Target                as character    /* # */    
    field Encoding              as character    initial ?
    field PatchLevel            as character
    index idxParent
        ReleaseVersion
        TaskId    
    .

define temp-table CreateADOListFile no-undo
    field TaskId                as integer      xml-node-type 'Hidden':u
    field ReleaseVersion        as character    xml-node-type 'Hidden':u
    
    field Target                as character    /* # */    
    field Encoding              as character    initial ?
    field PatchLevel            as character
    index idxParent
        ReleaseVersion
        TaskId    
    .
    
define temp-table UpdateDCU no-undo
    field TaskId            as integer      xml-node-type 'Hidden':u
    field ReleaseVersion    as character    xml-node-type 'Hidden':u
    field DeploymentType    as character    initial 'All':u

    field SetupTypeName     as character
    field SetupTypeFile     as character
    field PatchLevel        as character
    field Encoding          as character    initial ?
    index idxParent
        ReleaseVersion
        TaskId
    .        

/** Task modifier temp-tables **/
define temp-table DcuPatch no-undo
    field ReleaseVersion    as character    xml-node-type 'Hidden':u
    field TaskId            as integer      xml-node-type 'Hidden':u
    
    field Db                as character
    field Action            as character      initial 'Add':u
    field DbBuild           as logical        initial No    
    field NodeURL           as character
    index idxParent
        ReleaseVersion
        TaskId
    .

define temp-table PatchProgram no-undo
    field TaskId                as integer      xml-node-type 'Hidden':u
    field ReleaseVersion        as character    xml-node-type 'Hidden':u
    
    field Stage                 as character
    field FileType              as character
    field FileName              as character
    field Description           as character
    field ReRunnable            as logical        initial Yes
    field NewDB                 as logical        initial No
    field ExistingDB            as logical        initial Yes
    field UpdateMandatory       as logical        initial Yes
    field Order                 as integer
    index idxParent
        ReleaseVersion
        TaskId
    .
    
define temp-table ADODataset no-undo
    field ReleaseVersion        as character    xml-node-type 'Hidden':u
    field TaskId                as integer      xml-node-type 'Hidden':u
    field Enabled               as logical

    field DatasetCode         as character
    field FilePerRecord       as logical    initial ?
    field FileName            as character  initial ?
    index idxParent
        ReleaseVersion
        TaskId
    .
        
define temp-table ADORecordset no-undo
    field DeploymentType        as character    initial 'All':u
    field ReleaseVersion        as character    xml-node-type 'Hidden':u
    field TaskId                as integer      xml-node-type 'Hidden':u
    
    field DatasetCode           as character
    field KeyValue              as character    initial '#All#':u
    field FileName              as character    initial ?
    index idxParent
        ReleaseVersion
        TaskId
    index idxDataset
        DatasetCode
    .
    
define temp-table DateRange no-undo
    field ReleaseVersion  as character    xml-node-type 'Hidden':u
    field TaskId          as integer      xml-node-type 'Hidden':u
    field DeploymentType  as character    initial 'All':u
    
    field StartDate       as date    initial today
    field EndDate         as date    initial today
    index idxParent
        ReleaseVersion
        TaskId        
    .

define temp-table Objects no-undo
    field ReleaseVersion  as character    xml-node-type 'Hidden':u
    field TaskId          as integer      xml-node-type 'Hidden':u
    field DeploymentType  as character    initial 'All':u
    
    field Name            as character    
    index idxParent
        ReleaseVersion
        TaskId        
    .
    
define temp-table ProductModule no-undo
    field ReleaseVersion as character    xml-node-type 'Hidden':u
    field TaskId         as integer      xml-node-type 'Hidden':u
    field DeploymentType as character    initial 'All':u
    
    field Name           as character
    index idxParent
        ReleaseVersion
        TaskId
    .    


define temp-table Queries no-undo
    field ReleaseVersion    as character    xml-node-type 'Hidden':u
    field TaskId            as integer      xml-node-type 'Hidden':u
    field DeploymentType    as character    initial 'All':u
    
    field PrepareString     as character
    field BufferList        as character
    index idxParent
        ReleaseVersion
        TaskId
    .

define temp-table ObjectType no-undo
    field ReleaseVersion    as character    xml-node-type 'Hidden':u
    field TaskId            as integer      xml-node-type 'Hidden':u
    field DeploymentType    as character    initial 'All':u
    
    field Name              as character
    index idxParent
        ReleaseVersion
        TaskId
    .
    
define temp-table Entity no-undo
    field ReleaseVersion  as character    xml-node-type 'Hidden':u
    field TaskId          as integer      xml-node-type 'Hidden':u
    field DeploymentType  as character    initial 'All':u
    
    field Name        as character
    index idxParent
        ReleaseVersion
        TaskId
    .

define temp-table Commands no-undo
    field ReleaseVersion  as character    xml-node-type 'Hidden':u
    field TaskId          as integer      xml-node-type 'Hidden':u
    
    field Cmd             as character
    field ParameterList   as character
    field Modifier        as character
    index idxParent
        ReleaseVersion
        TaskId        
    .

define temp-table SourceLocation no-undo
    field ReleaseVersion  as character    xml-node-type 'Hidden':u
    field TaskId          as integer      xml-node-type 'Hidden':u
    field DeploymentType  as character    initial 'All':u
    
    field Location        as character    /* # */
    field SaveInto        as character    /* # */
    field FileMask        as character
    index idxParent
        ReleaseVersion
        TaskId
    .

define dataset dsDeployment for Deployment, Task, Generate4glObjects, Queries, ApiOverride, Objects, Logging, DumpData, DumpDefinition,
                                DumpSeqValue, ExportReleaseVersion, DumpDataset, DumpIncrementalDefs, DumpClassCache, DumpEntityCache,
                                Entity, ObjectType, ProductModule, BuildStaticCode, SourceLocation, BuildLibrary, DeployStaticCode,
                                BuildPackage, Commands, DateRange, ADODataset, ADORecordset, CreatePatchFile, PatchProgram, 
                                CreateADOListFile, UpdateDCU, DCUPatch, Changeset
         
    data-relation dr01 for Deployment, Task relation-fields (ReleaseVersion, ReleaseVersion) nested
    data-relation dr02 for Deployment, Logging relation-fields (ReleaseVersion, ReleaseVersion) nested
    data-relation dr24 for Deployment, ApiOverride relation-fields (ReleaseVersion, ReleaseVersion) nested
    
    data-relation dr03 for Task, DumpData relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr04 for Task, DumpDefinition relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr05 for Task, DumpSeqValue relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr06 for Task, ExportReleaseVersion relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr07 for Task, DumpDataset relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr08 for Task, Entity relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr09 for Task, DumpIncrementalDefs relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr10 for Task, DumpClassCache relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr11 for Task, ObjectType relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr12 for Task, DumpEntityCache relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr13 for Task, Generate4GLObjects relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr14 for Task, Queries relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr15 for Task, Objects relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr16 for Task, ProductModule relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr17 for Task, BuildStaticCode relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr18 for Task, SourceLocation relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr19 for Task, BuildLibrary relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr20 for Task, DeployStaticCode relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr21 for Task, BuildPackage relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr22 for Task, Commands relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr23 for Task, UpdateDCU relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr25 for Task, DateRange relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr26 for Task, ADODataset relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr27 for Task, ADORecordset relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr28 for Task, DCUPatch relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr29 for Task, CreatePatchFile relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested        
    data-relation dr30 for Task, PatchProgram relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    data-relation dr31 for Task, Changeset relation-fields (TaskId, TaskId, ReleaseVersion, ReleaseVersion) nested
    .

/* - E - O - F - */