/* Copyright (c) 2006 Progress Software Corporation.  All Rights Reserved. */
/*------------------------------------------------------------------------
    File        : afdcusetds.i
    Purpose     : Defines the Setups dataset for the DCU

    Author(s)   : pjudge
    Created     : 8/8/2006
    Notes       : Created from scratch. This dataset cannot be used as-is, 
    			  because of the ttMessg, ttPg, ttDatabs and ttCntrl
    			  temp-tables map to nodes that are named without the 'tt' prefix.
    			  The XML document should be read into a LONGCHAR and the tags 
    			  converted to be prefixed with tt before use. Similarly, if 
    			  being used for writing, the XML document should be written
    			  into a LONGCHAR and transformed there before being output
    			  to file.
    			  
    			  In addition, there's a bug where converting the Control nodes
    			  to ttCntrl nodes causes a GPF.
  ----------------------------------------------------------------------*/
define temp-table Setup no-undo
    field SetupType as character xml-node-type 'Attribute':u
    field ImageLowRes as character
    field ImageHiRes as character
    field IconFile as character
    field StartPage as character
    field SkipButtons as character
    field VersionNo as character
    index idxMain
        SetupType
    .

define temp-table ttMessg no-undo
    field SetupType as character    xml-node-type 'Hidden':u
    
    field MessageCode as character
    field MessageDesc as character
    index idxMain
        SetupType
    .
    
define temp-table RegistryKey no-undo
    field SetupType as character    xml-node-type 'Hidden':u
    
    field KeyName as character
    field KeyValue as character
    field ExpandTokens as logical
    index idxMain
        SetupType
    .
    
define temp-table Path no-undo
    field SetupType as character    xml-node-type 'Hidden':u
    
    field PathName as character    
    field PathValue as character 
    field ExpandTokens as logical
    index idxMain
        SetupType
    .
    
define temp-table ttPg        /* maps to Page */
    field SetupType as character    xml-node-type 'Hidden':u
    
    field Name as character         xml-node-type 'Attribute'
    field PgTtl as character    /* maps to Title */
    field PgGrp as character    /* maps to Group */
    field Proc as character
    index idxMain
        SetupType
    .

define temp-table ttCntrl no-undo /* maps to Control */
    field SetupType as character    xml-node-type 'Hidden':u
    field PageName as character     xml-node-type 'Hidden':u
        
    field Type as character
    field Name as character
    field Panel as logical
    field CLabl as character /* maps to Label */
    field Justify as character
    field StoreTo as character
    field TableVariable as character
    field Hidden as logical
    field DefaultValue as character
    field ExpandTokens as logical
    index idxMain
        SetupType
        PageName
    .
    
define temp-table Action no-undo
    field SetupType as character    xml-node-type 'Hidden':u
    field PageName as character     xml-node-type 'Hidden':u
    field Name as character         xml-node-type 'Hidden':u
    
    field Event as character
    field Action as character
    field ActionParam as character.    
    

define temp-table ttDatabs no-undo
    field SetupType as character    xml-node-type 'Hidden':u
        
    field DbNaam as character            /* maps to DbName */
    field VersionSeq as character
    field MinimumVersion as character
    field ConnectParams as character
    field DbDir as character
    field DbDump as character
    index idxMain
        SetupType
    .
    
define temp-table ttPch no-undo    /* maps to Patch */
    field SetupType as character    xml-node-type 'Hidden':u
    field DbNaam as character           xml-node-type 'Hidden':u
    
    field PatchLevel as character xml-node-type 'Attribute'
    field DbBuild as logical      xml-node-type 'Attribute'
    field NodeURL as character      xml-node-type 'Attribute'
    index idxMain
        SetupType
        DbNaam
    .

define dataset Setups for Setup, ttMessg, RegistryKey, Path, ttPg, ttDatabs, ttPch, ttCntrl, Action
    data-relation dr1 for Setup, ttMessg relation-fields(SetupType,SetupType)  nested
    data-relation dr2 for Setup, RegistryKey relation-fields(SetupType,SetupType) nested
    data-relation dr3 for Setup, Path relation-fields(SetupType,SetupType) nested
    data-relation dr4 for Setup, ttPg relation-fields(SetupType,SetupType) nested
    data-relation dr5 for Setup, ttDatabs relation-fields(SetupType,SetupType) nested
    data-relation dr6 for ttDatabs, ttPch relation-fields(SetupType,SetupType, DbNaam,DbNaam) nested
    data-relation dr7 for ttPg, ttCntrl relation-fields(SetupType,SetupType, Name, PageName) nested
    data-relation dr8 for ttCntrl, Action relation-fields(SetupType,SetupType, PageName,PageName, Name,Name) nested
    .
    
/* - E - O - F - */