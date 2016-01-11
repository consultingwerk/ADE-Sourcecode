/* Copyright (C) 2006 Progress Software Corporation.  All Rights Reserved. */
/*------------------------------------------------------------------------
    File        : afstpincds.i
    Purpose     : Defines the SetupInclude dataset for Deployment Automation

    Author(s)   : pjudge
    Created     : 8/3/2006
    Notes       : Created from scratch
  ----------------------------------------------------------------------*/
/* SetupInclude dataset used for creating Patch and ADOList files */
define temp-table Patch no-undo
    field PatchLevel    as character    xml-node-type 'Attribute':u
    .

define temp-table PatchStage no-undo
    field PatchLevel    as character    xml-node-type 'Hidden':u
    field Stage         as character    xml-node-type 'Attribute':u
    field Order         as integer      xml-node-type 'Hidden':u
    index idxMain
        PatchLevel
        Order.
        
define temp-table Program no-undo
    field PatchLevel    as character    xml-node-type 'Hidden':u
    field Stage         as character    xml-node-type 'Hidden':u
    field Order         as integer      xml-node-type 'Hidden':u
    
    field FileType           as character
    field FileName           as character
    field Description        as character
    field ReRunnable            as logical        initial Yes
    field NewDB                 as logical        initial No
    field ExistingDB            as logical        initial Yes
    field UpdateMandatory       as logical        initial Yes    
    index idxMain
        PatchLevel
        Stage
        Order.

define dataset SetupInclude for Patch, PatchStage, Program
    data-relation dr1 for Patch, PatchStage relation-fields(PatchLevel,PatchLevel) nested
    data-relation dr2 for PatchStage, Program relation-fields(PatchLevel, PatchLevel, Stage, Stage) nested
    .

/* - E - O - F - */