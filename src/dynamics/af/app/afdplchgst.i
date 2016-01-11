/* Copyright (C) 2006 Progress Software Corporation.  All Rights Reserved. */
/*------------------------------------------------------------------------
    File        : afdplchgst.i
    Purpose     : Defines ttChangset table for Deployment Automation

    Author(s)   : pjudge
    Created     : 8/1/2006
    Notes       : Created from scratch
    			  -  Used in af/app/afdeplymtp.p and af/app/gscddxmlp.p
  ----------------------------------------------------------------------*/

/* Stores the changeset between releases */
define temp-table ttReleaseChangeset no-undo
    field DatasetCode            as character
    field EntityMnemonic         as character
    /* KeyField,SecondaryField taken from record version */
    field KeyField               as character
    field KeyFieldValue          as character
    field SecondaryFieldName     as character
    field SecondaryFieldValue    as character
    field Deletion               as logical
    /* The name of the ADO to dump (CreateADOListFile task) */
    field RecordADOFilename      as character
    field DatasetADOFilename     as character
    /* Used to dump ADOs (DumpDataset task)*/
    field DSKeyField             as character
    field DSKeyFieldValue        as character
    /* Additional RYCSO fields */
    field rycso_Class            as character
    field rycso_StaticObject     as logical
    field rycso_DesignObject     as logical
    field rycso_ObjectPath       as character
    index idxEntity
        EntityMnemonic
        KeyFieldValue
    index idxDataset
        DatasetCode.

/* - E - O - F - */