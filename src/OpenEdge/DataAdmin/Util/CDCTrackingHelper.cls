/*************************************************************/
/* Copyright (c) 2017 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/ 

/*------------------------------------------------------------------------ 
    File        : CDCTrackingHelper
    Purpose     : Provides convenience methods for accessing data in a  
                  _Cdc-Change-Tracking record and its related change table
                  records. 
    Syntax      :
    Description :
    Authors     :
    Notes       : An ETL program can create an instance of CDCTrackingHelper 
                  for the source table being processed. The ETL program 
                  creates a CDCTrackingHelper object for a 
                  _Cdc-Change-Tracking buffer, then iterates through the 
                  _Cdc-Change-Tracking records using this buffer. The ETL 
                  program can then use the convenience methods in the 
                  CDCTrackingHelper object to access the record currently 
                  in the buffer.
  ----------------------------------------------------------------------*/

/* NOTES:
 * In order for this to be r-code, there are no static references to 
 * database tables. All database access is done through dynamic code.
 * It supports connecting to multiple databases. 
 * */

USING Progress.Lang.AppError.
USING OpenEdge.DataAdmin.Util.CDCOperation.

block-level on error undo, throw.

CLASS OpenEdge.DataAdmin.Util.CDCTrackingHelper:

    DEFINE PRIVATE VARIABLE mcDbName AS CHARACTER NO-UNDO.
    DEFINE PRIVATE VARIABLE mcTblName AS CHARACTER   NO-UNDO.
    DEFINE PRIVATE VARIABLE mcOwner AS CHARACTER   NO-UNDO.
    DEFINE PRIVATE VARIABLE mhtrkbuf AS HANDLE NO-UNDO.
    DEFINE PRIVATE VARIABLE mhchgtt AS HANDLE NO-UNDO.

    DEFINE PRIVATE VARIABLE mifirstusrpos AS INTEGER NO-UNDO.
    DEFINE PRIVATE VARIABLE mcchgtbl AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE PRIVATE VARIABLE minumflds AS INTEGER NO-UNDO.
    DEFINE PRIVATE VARIABLE mrlasttrkrecid AS RECID NO-UNDO.
    DEFINE PRIVATE VARIABLE mlsqlchgtbl AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE PRIVATE VARIABLE mllevelzero AS LOGICAL INITIAL NO NO-UNDO.

    /** Table number of the source table, for querying _Cdc-Change-Tracking._Source-Table-Number */
    DEFINE PUBLIC PROPERTY SourceTableNumber AS INTEGER GET. PRIVATE SET.

    DEFINE PRIVATE TEMP-TABLE ttpolfld NO-UNDO
        FIELD cfldname AS CHARACTER
        FIELD ifldpos AS INTEGER
        INDEX ixpolfld cfldname
        INDEX ixpolpos ifldpos.
        
    /** Creates a new CDCTrackingHelper object for the given source table in 
        the given schema, in the database associated with the ChangeTrackingHandle.
        @param character The name of the source table.
        @param character The Owner (schema) of the source table, allowing users to identify SQL source tables.
        @param handle A handle to a _Cdc-Change-Tracking buffer, which the ETLprogram will use to set up a custom query on the _Cdc-Change-Tracking table. */
    CONSTRUCTOR PUBLIC CDCTrackingHelper(
        INPUT pcSourceTableName AS CHARACTER,
        INPUT pcTableOwner AS CHARACTER,
        INPUT phChangeTrackingBuffer AS HANDLE):

        /* Validate input buffer. Validation of other parms is done in cachePolicy */
        OpenEdge.Core.Assert:NotNull(phChangeTrackingBuffer, 'Change tracking buffer':U).
        /* Ensure this is a buffer for the _Cdc-Change-Tracking table */
        IF (phChangeTrackingBuffer:TYPE <> "BUFFER":U) THEN
            RETURN ERROR NEW Progress.Lang.AppError(SUBSTITUTE("Handle is a &1 HANDLE, not a BUFFER HANDLE":U, phChangeTrackingBuffer:TYPE), 0).
        IF (phChangeTrackingBuffer:TABLE <> "_Cdc-Change-Tracking":U) THEN
            RETURN ERROR NEW Progress.Lang.AppError(SUBSTITUTE("Buffer is for table &1, not _Cdc-Change-Tracking":U, phChangeTrackingBuffer:TABLE-HANDLE:NAME ), 0).
        /* Ensure this is a database table */
        IF (phChangeTrackingBuffer:DBNAME = "PROGRESST":U) THEN
            RETURN ERROR NEW Progress.Lang.AppError("Buffer is for a temp-table, not a database table":U, 0).
        
        ASSIGN
            mcDbName = phChangeTrackingBuffer:DBNAME
            mcOwner = pcTableOwner
            mcTblName = pcSourceTableName
            mhtrkbuf = phChangeTrackingBuffer.
          
        cachePolicy().
    END CONSTRUCTOR.

    /** Creates a new CDCTrackingHelper object for the given source table in 
        the PUB schema, in the database associated with the ChangeTrackingHandle.
        @param character The name of the source table.
        @param handle A handle to a _Cdc-Change-Tracking buffer, which the ETLprogram will use to set up a custom query on the _Cdc-Change-Tracking table. */
    CONSTRUCTOR PUBLIC CDCTrackingHelper(
        INPUT pcSourceTableName AS CHARACTER,
        INPUT phChangeTrackingBuffer AS HANDLE):
        THIS-OBJECT(pcSourceTableName, "PUB":U, phChangeTrackingBuffer).
    END.

    /** Cleans up resources used by the CDCTrackingHelper */
    DESTRUCTOR PUBLIC CDCTrackingHelper():
        IF VALID-OBJECT(mhchgtt) THEN
            DELETE OBJECT mhchgtt.
    END.

    METHOD PRIVATE  VOID cachePolicy():
        DEFINE VARIABLE ifirstusrpos AS INTEGER     NO-UNDO.
        DEFINE VARIABLE ifldpos AS INTEGER     NO-UNDO.
        DEFINE VARIABLE hdbbuf AS HANDLE      NO-UNDO.
        DEFINE VARIABLE htblbuf AS HANDLE      NO-UNDO.
        DEFINE VARIABLE hfldbuf AS HANDLE      NO-UNDO.
        DEFINE VARIABLE hfilebuf AS HANDLE      NO-UNDO.
        DEFINE VARIABLE hfieldbuf AS HANDLE      NO-UNDO.
        DEFINE VARIABLE hfieldqry AS HANDLE      NO-UNDO.
        DEFINE VARIABLE cchgtblname AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE cchgtblown AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE rdbrecid AS RECID       NO-UNDO.
        DEFINE VARIABLE rfilerecid AS RECID       NO-UNDO.
        DEFINE VARIABLE cdatatype AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE iextent AS INTEGER     NO-UNDO.
        
        /* get the recid for the first _Db row in the 
         * requested database. The _File index uses this */
        CREATE BUFFER hdbbuf FOR TABLE (mcdbname + "._Db":U).
        hdbbuf:FIND-FIRST("WHERE TRUE":U, NO-LOCK) NO-ERROR.
        IF (NOT hdbbuf:AVAILABLE) THEN
        DO:
            DELETE OBJECT hdbbuf.
            RETURN ERROR NEW Progress.Lang.AppError(SUBSTITUTE("Database &1 does not have a _Db record":U, mcdbname), 0).
        END.
        rdbrecid = hdbbuf:RECID.
        DELETE OBJECT hdbbuf.

        /* get the table number of the given table */
        CREATE BUFFER hfilebuf FOR TABLE (mcdbname + "._File":U).
        hfilebuf:FIND-FIRST(
            SUBSTITUTE("WHERE _File-Name = &1 AND _Owner = &2 AND _Db-Recid = &3":U,
                       QUOTER(mcTblName), QUOTER(mcOwner), STRING(rdbrecid)), NO-LOCK) NO-ERROR.
        IF (NOT hfilebuf:AVAILABLE) THEN
        DO:
            DELETE OBJECT hfilebuf.
            RETURN ERROR NEW Progress.Lang.AppError(
                SUBSTITUTE("Table &1.&2 not found":U, mcOwner, mcTblName), 0).
        END.
        ASSIGN 
            rfilerecid = hfilebuf:RECID
            SourceTableNumber = hfilebuf::_File-Number.
        DELETE OBJECT hfilebuf.

        /* Get the first current policy for the table.
         * We should not get a pending policy */
        CREATE BUFFER htblbuf FOR TABLE (mcdbname + "._Cdc-Table-Policy":U).           
        htblbuf:FIND-FIRST(
            SUBSTITUTE("where _Source-File-Recid = &1 and _Policy-Instance < 2":U, 
                        STRING(rfilerecid)), NO-LOCK) NO-ERROR.
        IF (NOT htblbuf:AVAILABLE) THEN
        DO:
            DELETE OBJECT htblbuf.
            RETURN ERROR NEW Progress.Lang.AppError(
                SUBSTITUTE("Current policy for table number &1 does not exist":U, STRING(SourceTableNumber)), 0).
        END.
        
        mllevelzero = (IF htblbuf::_Level > 0 THEN NO ELSE YES).

        /* Get the change table if _Level > 0 */
        if (NOT mllevelzero) THEN
        DO:
            /* Get the _File for the change table */
            CREATE BUFFER hfilebuf FOR TABLE (mcDbName + "._File":U).
            ASSIGN
                cchgtblname = htblbuf::_Change-Tablename
                cchgtblown  = htblbuf::_Change-Table-Owner.
            hfilebuf:FIND-FIRST(
                SUBSTITUTE("WHERE _File-name = &1 AND _Owner = &2 AND _Db-recid = &3":U,
                           QUOTER(cchgtblname), QUOTER(cchgtblown), STRING(rdbrecid)), NO-LOCK) NO-ERROR.
            IF (NOT hfilebuf:AVAILABLE) THEN
            DO:
                DELETE OBJECT hfilebuf.
                DELETE OBJECT htblbuf.
                RETURN ERROR NEW Progress.Lang.AppError(
                    SUBSTITUTE("_File does not exist for change table &1.&2":U, cchgtblname, cchgtblown), 0).
            END.
            /* we cannot use a change table from a SQL schema. 
             * However, we can still use this CDCTrackingHelper with 
             * _Cdc-Change-Tracking, so it is not an error yet to have 
             * a SQL change table */
            IF cchgtblown <> "PUB":U THEN 
                mlsqlchgtbl = TRUE.

            CREATE TEMP-TABLE mhchgtt.
            ASSIGN
                mcchgtbl = cchgtblname
                mifirstusrpos = htblbuf::_First-User-Field
                minumflds = hfilebuf::_numfld
                rfilerecid = hfilebuf:RECID.
            CREATE BUFFER hfieldbuf FOR TABLE (mcdbname + "._Field":U).
            CREATE QUERY hfieldqry.
            hfieldqry:ADD-BUFFER(hfieldbuf).
            hfieldqry:QUERY-PREPARE(
                SUBSTITUTE(
                    "FOR EACH _Field NO-LOCK WHERE _Field._File-recid = &1 BY _Field-Physpos":U, 
                    STRING(rfilerecid))).
            hfieldqry:QUERY-OPEN().
            DO WHILE (NOT hfieldqry:QUERY-OFF-END):
                hfieldqry:GET-NEXT().
                IF (hfieldqry:QUERY-OFF-END) THEN
                    LEAVE.
                ifldpos = hfieldbuf::_Field-Physpos.
                IF (ifldpos < mifirstusrpos) THEN NEXT.
                CREATE ttpolfld.
                ASSIGN 
                    ttpolfld.cfldname = hfieldbuf::_Field-name
                    /* relative physpos number */
                    ttpolfld.ifldpos = ifldpos - mifirstusrpos + 1.
                ASSIGN 
                    cdatatype = hfieldbuf::_data-type
                    iextent = hfieldbuf::_extent.
                mhchgtt:ADD-NEW-FIELD(
                    ttpolfld.cfldname,
                    cdatatype,
                    iextent) NO-ERROR.
                /* If this was a non-ABL datatype, then we silently skip the error.
                 * The field just won't appear in the buffer for the change table */
            END.
            hfieldqry:QUERY-CLOSE().
            mhchgtt:TEMP-TABLE-PREPARE(mcchgtbl).
            DELETE OBJECT hfieldqry.
            DELETE OBJECT hfieldbuf.
            DELETE OBJECT hfilebuf.
        END.
          
        DELETE OBJECT htblbuf.
    END.

    /** Returns an EXTENT of the field names of fields which were flagged as
        changed in the _Cdc-Change-Tracking record's _Change-FieldMap. 
        If there are no changed fields (this is a level 0 CDC policy), 
        an indeterminate array is returned */
    METHOD PUBLIC  CHARACTER EXTENT GetChangedFields():
        DEFINE VARIABLE ilen AS INTEGER     NO-UNDO.
        DEFINE VARIABLE ibytectr AS INTEGER     NO-UNDO.
        DEFINE VARIABLE ibitctr AS INTEGER     NO-UNDO.
        DEFINE VARIABLE ibyte AS INTEGER     NO-UNDO.
        DEFINE VARIABLE ibitnum AS INTEGER     NO-UNDO.
        DEFINE VARIABLE ibit AS INTEGER     NO-UNDO.
        DEFINE VARIABLE ifldctr AS INTEGER     NO-UNDO.
        DEFINE VARIABLE ifndctr AS INTEGER     NO-UNDO.
        DEFINE VARIABLE clist AS CHARACTER NO-UNDO.
        DEFINE VARIABLE lfound AS LOGICAL INITIAL FALSE    NO-UNDO.
        DEFINE VARIABLE rbitmap AS RAW       NO-UNDO.
        DEFINE VARIABLE inumchg AS INTEGER     NO-UNDO.
        DEFINE VARIABLE cret AS CHARACTER EXTENT  NO-UNDO.

        rbitmap = mhtrkbuf::_Change-Fieldmap.

        /* get the length of the raw in bytes */
        ilen = LENGTH(rbitmap).

        /* iterate though each byte of the bitmap */
        DO ibytectr = 1 TO ilen:
            /* get the byte */
            ASSIGN 
                ibyte = GET-BYTE(rbitmap,ibytectr)
                ibitnum = 1.
            /* iterate over the bits in the byte */
            DO ibitctr = 1 TO 8:
                /* move to the next field */
                ifldctr = ifldctr + 1.
                /* get the bit reflecting this field */
                ibit = GET-BITS(ibyte, ibitctr, 1).
                /* if the bit was set, add it to the list */
                IF (ibit > 0) THEN
                DO:
                    FIND FIRST ttpolfld WHERE 
                        ttpolfld.ifldpos = ifldctr.
                    ASSIGN 
                        clist = clist + ttpolfld.cfldname + ",":U
                        inumchg = inumchg + 1.
                END.
            END.
        END.
        IF (inumchg > 0) THEN
        DO:
            EXTENT(cret) = inumchg.
            DO ifldctr = 1 TO inumchg:
                cret[ifldctr] = ENTRY(ifldctr, clist).
            END.
        END.
        RETURN cret.
    END METHOD.

    /** Returns TRUE if the given fieldname was changed
        in the record currently in the _Cdc-Change-Tracking buffer,
        according to the _Change-FieldMap.     
        If the field does not exist in the change table,
        an AppError is thrown.   
        @param character The name of the field to query */
    METHOD PUBLIC  LOGICAL FieldChanged(
        INPUT ccolname AS CHARACTER):

        DEFINE VARIABLE ipos AS INTEGER     NO-UNDO.
        DEFINE VARIABLE rbitmap AS RAW         NO-UNDO.
        DEFINE VARIABLE lret AS LOGICAL NO-UNDO.
        
        /* Field changes not marked in level 0 policy */
        IF (mllevelzero) THEN
            RETURN ERROR NEW Progress.Lang.AppError("No field changes recorded in level 0 policy":U, 0).

        rbitmap = mhtrkbuf::_Change-Fieldmap.

        FIND FIRST ttpolfld WHERE 
            ttpolfld.cfldname = ccolname NO-ERROR.
        IF NOT AVAILABLE ttpolfld THEN
            RETURN ERROR NEW Progress.Lang.AppError(
                SUBSTITUTE("&1 is not a column in &2":U, ccolname, mcchgtbl), 0).
        lret = ChangeBitSet(rbitmap, ttpolfld.ifldpos).
        RETURN lret.
    END METHOD.

    METHOD PRIVATE  LOGICAL ChangeBitSet(INPUT rbitmap AS RAW, INPUT ipos AS INTEGER):
        DEFINE VARIABLE ilen AS INTEGER     NO-UNDO.
        DEFINE VARIABLE ival AS INTEGER     NO-UNDO.
        DEFINE VARIABLE ictr AS INTEGER     NO-UNDO.
        DEFINE VARIABLE ibyte AS INTEGER     NO-UNDO.
        DEFINE VARIABLE ibitnum AS INTEGER     NO-UNDO.
        DEFINE VARIABLE ibit AS INTEGER     NO-UNDO.
        DEFINE VARIABLE iret AS INTEGER     NO-UNDO.
    
        /* ipos should have been normalised to user field offset */

        /* get the length of the raw in bytes */
        ilen = LENGTH(rbitmap).
    
        /* which byte do we want? which bit do we want?
         * ABL rounds, so we have to eliminate remainders */
        ASSIGN 
            ibitnum = ipos MOD 8
            ibyte = (ipos  - ibitnum) / 8.
        /* is the position too long? */
        IF ( ibyte >= ilen) THEN
        DO:
            RETURN ERROR NEW Progress.Lang.AppError("Requested column does not exist in bitmap":U, 0).
        END.

        /* get the value of the byte */
        ival = GET-BYTE(rbitmap,ibyte + 1).
        /* get the bit of the byte */
        ibit = GET-BITS(ival,ibitnum,1).
        RETURN (ibit > 0).
    END METHOD.

    /** Returns a CDCOperation enum value for the operation
        in the record currently in the _Cdc-Change-Tracking buffer. 
        This method provides Enums for all possible _Operation values.
        Frequent _Operation values for CREATE, UPDATE and DELETE
        have separate methods to provide faster evaluation. */
    METHOD PUBLIC CDCOperation GetOperation():
        RETURN CDCOperation:GetEnum(mhtrkbuf::_Operation).
    END.

    /** Returns a buffer handle for a dynamic temp-table that matches
        the definition of the change table for a given source table
        (without the meta-fields). 
        This is a convenience method for users to obtain a buffer 
        match the change table for use with the FetchChangeRecord() methods.
        Multiple calls to this method will return the same buffer handle.
        The temp-table is created dynamically inside the CDCTrackingHelper 
        object. It is deleted when the CDCTrackingHelper object is detroyed. */
    METHOD PUBLIC HANDLE CreateChangeBuffer():
        IF VALID-HANDLE(mhchgtt) THEN
            RETURN mhchgtt:DEFAULT-BUFFER-HANDLE.
        ELSE 
            /* return an invalid handle */
            RETURN mhchgtt.
    END.

    /** Returns TRUE if the change details were split between two records, 
        and FALSE otherwise. 
        This method looks for change table rows that match the current 
        _Cdc-Change-Tracking record, using the _Operation from the 
        _Cdc-Change-Tracking record. If there is more than one change table 
        record, this means the change details were split between two change 
        table records.
        In the case of a level 3 CDC policy, there may be two change records
        for a _Cdc-Change_Tracking record, a BEFORE record and an AFTER record.
        This method returns whether the AFTER record was split. 
        If no change table record exists that matched the _Cdc-Change-Tracking 
        record, this method will return FALSE. 
        Note that for some CDC operations, there are no change table records, 
        so callers should be careful to call this only when necessary, 
        and/or check for a FALSE return value.
        This method is provided so that an ETL program can choose not to call 
        FetchChangeRecord() if the change table record is not split. 
        Instead, the ETL program can choose to perform the FIND directly on 
        the change table. Direct ABL access is faster than calling a method to 
        potentially rejoin a record if there is no need. */
    METHOD PUBLIC LOGICAL IsRecordSplit():
        DEFINE VARIABLE ioper AS INTEGER     NO-UNDO.
        DEFINE VARIABLE lret AS LOGICAL     NO-UNDO.
        
        ioper = mhtrkbuf::_Operation.

        lret = InternalIsRecordSplit(ioper).
        RETURN lret.
    END.

    /** Returns TRUE if the change details were split between two records, 
        and FALSE otherwise. 
        This method is similar to the IsRecordSplit() method, but this 
        overload can loko for change table records where the _Operation
        reflects a BEFORE record.
        In the case of a Level 3 CDC policy, there are two change tracking 
        records for a _Cdc-Change-Tracking update record, a BEFORE and an
        AFTER record. If the input parameter is TRUE, this method returns 
        whether the BEFORE record was split. If the input parameter is FALSE, 
        this method returns whether the AFTER row was split.
        If no change table row exists that matches the _Cdc-Change-Tracking 
        record, this method will return FALSE.
        Note that for some CDC operations, there are no change table records, 
        so users should be careful to call this only when necessary, 
        and/or check for a FALSE return value.
        @param logical If the operation is an update, then retrieve the BEFORE record */
    METHOD PUBLIC LOGICAL IsRecordSplit(
        INPUT lBefore AS LOGICAL):
        DEFINE VARIABLE ioper AS INTEGER     NO-UNDO.
        DEFINE VARIABLE lret AS LOGICAL     NO-UNDO.
    
        ioper = (IF lbefore THEN 
                     INTEGER(CDCOperation:BeforeUpdate) ELSE 
                     mhtrkbuf::_Operation).
        lret = InternalIsRecordSplit(ioper).
        RETURN lret.
    END.

    METHOD PRIVATE LOGICAL InternalIsRecordSplit(
        INPUT iOperation AS INTEGER):
        
        /* NOTE: Using an INTEGER parameter for the operation in this 
         * internal method. The public API never receives a CDCOperation.
         * The operation value is either the INTEGER value of 
         * CDCOperation:BeforeUpdate, or the INTEGER value extracted from 
         * the _Cdc-Change-Tracking record. The value is then used as an 
         * INTEGER when building a query. The conversion from an INTEGER
         * to a CDCOperation Enum just so it can be converted back to an 
         * INTEGER is unnecessary processing. There is little advantage of 
         * type safety if this stays an internal routine. */

        DEFINE VARIABLE hbuf AS HANDLE      NO-UNDO.
        DEFINE VARIABLE hqry AS HANDLE      NO-UNDO.
        DEFINE VARIABLE cqry AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE icontpos AS INTEGER     NO-UNDO.

        IF NOT VALID-HANDLE(mhchgtt) THEN
            RETURN ERROR NEW Progress.Lang.AppError("No change table exists for CDC policy":U, 0).
        IF mlsqlchgtbl THEN
            RETURN ERROR NEW Progress.Lang.AppError("Change table is a SQL table and cannot be queried from ABL":U, 0).
        
        CREATE BUFFER hbuf FOR TABLE mcchgtbl.
        CREATE QUERY hqry.
        hqry:ADD-BUFFER(hbuf).
        cqry = 
            SUBSTITUTE("FOR EACH &1 WHERE &2._Change-Sequence = &3 AND &4._Operation = &5":U,
                mcchgtbl, mcchgtbl, STRING(mhtrkbuf::_Change-Sequence), mcchgtbl, STRING(iOperation) ).
        hqry:QUERY-PREPARE(cqry).
        hqry:QUERY-OPEN().
        hqry:GET-NEXT(). 
        /* there might be no change row for the operation.
         * if not, return error */
        IF (hqry:QUERY-OFF-END) THEN
        DO:
            DELETE OBJECT hqry.
            DELETE OBJECT hbuf.
            RETURN ERROR NEW AppError(
                SUBSTITUTE("Change table record not found for _Change-Sequence &1 _Operation &1":U,
                    STRING(mhtrkbuf::_Change-Sequence), 
                    STRING(iOperation)), 0).
        END.
        /* we have the first row. */
        icontpos = hbuf::_Continuation-Position.
        DELETE OBJECT hqry.
        DELETE OBJECT hbuf.
        RETURN NOT (icontpos = 0).
    END.

    /** Fetches change table records that match the current 
        _Cdc-Change-Tracking record, with the same _Operation. It copies 
        the fields from the change table row into the buffer passed, 
        based on the field names. The passed buffer should be from a 
        table with a similar schema to the schema of the change table 
        (without the meta-fields).
        There are between 0 and 2 change table records for each 
        _Cdc-Change-Tracking/_Operation combination. Typically there are
        0 or 1; 2 is the case of a split record. In the case of a split
        record, this method copies the change data from both change
        table records into the input buffer. If no change table record is 
        found, this method throws an AppError.
        Note that for some CDC operations, there are no change table 
        records, so users should be careful to call this only when 
        necessary, and/or catch and handle AppErrors appropriately.
        In the case of an UPDATE _Cdc-Change-Tracking record, this method 
        returns the data from the AFTER change table record.
        @param handle Handle to a buffer of a table into which to write the field from the change table record */
    METHOD PUBLIC VOID FetchChangeRecord(
        INPUT phChangeBuffer AS HANDLE):
        DEFINE VARIABLE ioper AS INTEGER     NO-UNDO.
        
        /* Validate hChangeBuffer */
        OpenEdge.Core.Assert:NotNull(phChangeBuffer, 'Change buffer':U).

        ioper = mhtrkbuf::_Operation.
        InternalFetchChangeRecord(phChangeBuffer, ioper).
    END.

    /** This method is similar to FetchChangeRecord(hbuf), but this 
        overload can look for change table records where the 
        _Operation reflects a BEFORE record. 
        In the case of a Level 3 CDC policy, there are two change 
        tracking records for a _Cdc-Change-Tracking UPDATE record, 
        a BEFORE and an AFTER record. If the input parameter is TRUE, 
        this method copies the BEFORE record. If the input parameter is 
        FALSE, this method copies the AFTER record. If no change table 
        record is found, this method throws an AppError. 
        Note that for some CDC operations, there are no change table records, 
        so users should be careful to call this only when necessary, 
        and/or catch and handle AppErrors appropriately.
        @param handle Handle to a buffer of a table into which to write the field from the change table record 
        @param logical If the operation is an update, then retrieve the BEFORE record */
    METHOD PUBLIC VOID FetchChangeRecord(
        INPUT phChangeBuffer AS HANDLE,
        INPUT plBefore AS LOGICAL):        
        DEFINE VARIABLE ioper AS INTEGER     NO-UNDO.

        /* Validate hChangeBuffer */
        OpenEdge.Core.Assert:NotNull(phChangeBuffer, 'Change buffer':U).

        ioper = (IF plbefore THEN 
                     INTEGER(CDCOperation:BeforeUpdate) ELSE 
                     mhtrkbuf::_Operation).
        InternalFetchChangeRecord(phChangeBuffer, ioper).
    END.

    METHOD PRIVATE VOID InternalFetchChangeRecord(
        INPUT hchgrow AS HANDLE,
        INPUT iOperation AS INTEGER):

        /* NOTE: Using an INTEGER parameter for the operation in this 
         * internal method. The public API never receives a CDCOperation.
         * The operation value is either the INTEGER value of 
         * CDCOperation:BeforeUpdate, or the INTEGER value extracted from 
         * the _Cdc-Change-Tracking record. The value is then used as an 
         * INTEGER when building a query. The conversion from an INTEGER
         * to a CDCOperation Enum just so it can be converted back to an 
         * INTEGER is unnecessary processing. There is little advantage of 
         * type safety if this stays an internal routine. */

        DEFINE VARIABLE hqry AS HANDLE      NO-UNDO.
        DEFINE VARIABLE hbuf AS HANDLE      NO-UNDO.
        DEFINE VARIABLE hsrcfld AS HANDLE      NO-UNDO.
        DEFINE VARIABLE hchgfld AS HANDLE      NO-UNDO.
        DEFINE VARIABLE cchgtbl AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE ilastpos AS INTEGER     NO-UNDO.
        DEFINE VARIABLE iendpos AS INTEGER     NO-UNDO.
        DEFINE VARIABLE cqry AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE icurpos AS INTEGER     NO-UNDO.
        DEFINE VARIABLE cpairs AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE ifragment AS INTEGER     NO-UNDO.
        DEFINE VARIABLE iarrayidx AS INTEGER     NO-UNDO.
        DEFINE VARIABLE cchrval AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE cexcl AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE iextent AS INTEGER     NO-UNDO.
        DEFINE VARIABLE cfldname AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE ifldctr AS INTEGER     NO-UNDO.
        DEFINE VARIABLE iarrctr AS INTEGER     NO-UNDO.
        DEFINE VARIABLE rraw AS RAW NO-UNDO.

        IF NOT VALID-HANDLE(mhchgtt) THEN
            RETURN ERROR NEW Progress.Lang.AppError("No change table exists for CDC policy":U, 0).
        IF mlsqlchgtbl THEN
            RETURN ERROR NEW Progress.Lang.AppError("Change table is a SQL table and cannot be queried from ABL":U, 0).
            
        CREATE BUFFER hbuf FOR TABLE mcchgtbl.
        CREATE QUERY hqry.
        hqry:ADD-BUFFER(hbuf).
        cqry = 
            SUBSTITUTE("FOR EACH &1 WHERE &2._Change-Sequence = &3 AND &4._Operation = &5":U,
                mcchgtbl, mcchgtbl, STRING(mhtrkbuf::_Change-Sequence), mcchgtbl, STRING(iOperation)).
        hqry:QUERY-PREPARE(cqry).
        hqry:QUERY-OPEN().
        hqry:GET-NEXT(). 
        /* there might be no change row for the operation.
         * if not, return error */
        IF (hqry:QUERY-OFF-END) THEN
        DO:
            DELETE OBJECT hqry.
            DELETE OBJECT hbuf.
            RETURN ERROR NEW AppError(
                SUBSTITUTE(
                    "Change table record not found for _Change-Sequence &1 _Operation &2":U,
                    STRING(mhtrkbuf::_Change-Sequence), 
                    STRING(iOperation)), 0).
        END.
        /* we have the first row. */
        ilastpos = hbuf::_Continuation-Position.
        /* copy it to the output buffer */
        hchgrow:BUFFER-COPY(hbuf).

        IF ilastpos = 0 THEN
        DO:
            /* we have only one row, return it */
            DELETE OBJECT hqry.
            DELETE OBJECT hbuf.
            RETURN.
        END.
        
        /* There is more than one row. 
         * Iterate through the fields written to the second row, 
         * copying them a field at a time to the output buffer. 
         * Interpreting values in first record: 
         * _Continuation-Position is the last completely written field
         * _Fragment = 1 indicates whether a field or array element is split
         * _ArrayIndex indicates the last competely written array element.
         * The possibilities are:
         * no field split                            : fragment 0, arrayidx 0
         * field split                               : fragment 1, arrayidx 0
         * array split, element split, element > 1   : fragment 1, arrayidx > 0
         * array split, element split, element 1     : fragment 1, arrayidx 0
         * array split, array boundary, element > 1  : fragment 0, arrayidx > 0
         * array split, array boundary, element 1    : fragment 0, arrayidx 1
         * When re-assembling the row, you have to be aware of whether the 
         * field after _Continuation-Position is an EXTENT or not.
         * _Fragment = 1 and _ArrayIndex = 0 is true for both a split field
         * and a split first element of an array.
         * A note on _Continuation-Position: It reflects the physpos of the 
         * the last fully written field. physpos numbers start at 2, not 1. 
         * Values for BUFFER-FIELD start at 1. So if _Continuation-Position
         * is 4, this means BUFFER-FIELD(3) was completely written.
         * The next field we want to work on is BUFFER-FIELD(4). 
         * We can avoid a lot of unnecessary +1 and -1 by treating 
         * _Continuation-Position as the next BUFFER-FIELD to copy.
         */
        ifragment = hbuf::_Fragment.
        iarrayidx = hbuf::_ArrayIndex.

        /* get the next record */
        hqry:GET-NEXT().
        IF (hqry:QUERY-OFF-END) THEN
        DO:
            /* Second row is not available, someone possibly delete it.
             * just return what we have */
            DELETE OBJECT hqry.
            DELETE OBJECT hbuf.
            /* TOD: should this be an error? */
            RETURN .
        END.

        /* if there is a fragmented field or a split in an array, 
         * copy what there is of the existing field/array */
        IF (ifragment > 0 OR iarrayidx > 0) THEN
        DO:
            /* append the rest of the field from the second record */
            /* get the name of the change table field */
            hsrcfld = hbuf:BUFFER-FIELD(ilastpos).
            cfldname = hsrcfld:NAME.
            /* get the field handle of the output buffer of 
             * the same name, if it exists */
            hchgfld = hchgrow:BUFFER-FIELD(cfldname) NO-ERROR.
            /* if the output field exists, append the value. */
            IF VALID-HANDLE(hchgfld) THEN
            DO:
                /* is the next field to be written an EXTENT? */
                IF (hsrcfld:EXTENT > 0) THEN
                DO:
                    /* This is a split array.
                     * iarrayidx is the last fully written element.
                     * We have to copy the remaining elements */
                    iarrayidx = iarrayidx + 1.
                    IF (ifragment > 0) THEN
                    DO:
                        /* this array element was split, append value */
                        IF (hchgfld:DATA-TYPE = "RAW") THEN
                        DO:
                            rraw = hchgfld:BUFFER-VALUE(iarrayidx).
                            PUT-BYTES(rraw,LENGTH(rraw) + 1) = hsrcfld:BUFFER-VALUE(iarrayidx).
                            hchgfld:BUFFER-VALUE(iarrayidx) = rraw.
                        END.
                        ELSE
                        hchgfld:BUFFER-VALUE(iarrayidx) = hchgfld:BUFFER-VALUE(iarrayidx) + 
                            hsrcfld:BUFFER-VALUE(iarrayidx).
                        iarrayidx = iarrayidx + 1.
                    END.
                    /* copy the rest of the elements from the array */
                    iextent = hsrcfld:EXTENT.
                    DO iarrctr = iarrayidx TO iextent:
                        hchgfld:BUFFER-VALUE(iarrctr) = hsrcfld:BUFFER-VALUE(iarrctr).
                    END.
                END.
                ELSE 
                DO:
                    IF (hchgfld:DATA-TYPE = "RAW") THEN
                    DO:
                        rraw = hchgfld:BUFFER-VALUE.
                        PUT-BYTES(rraw,LENGTH(rraw) + 1) = hsrcfld:BUFFER-VALUE.
                        hchgfld:BUFFER-VALUE = rraw.
                    END.
                    ELSE
                    hchgfld:BUFFER-VALUE = hchgfld:BUFFER-VALUE + 
                        hsrcfld:BUFFER-VALUE.
                END.
            END.
            /* move onto the next field */
            ilastpos = ilastpos + 1.
        END.
        
        /* iterate through the remaining fields, 
         * copying them to the output buffer */
        iendpos = hbuf::_Continuation-Position - 1.
        DO ifldctr = ilastpos TO iendpos:
            /* get the name of the change table field */
            hsrcfld = hbuf:BUFFER-FIELD(ilastpos).
            cfldname = hsrcfld:NAME.
            /* get the field handle of the temp-table of 
             * the same name, if it exists */
            hchgfld = hchgrow:BUFFER-FIELD(cfldname) NO-ERROR.
            /* if the temp-table field exists, copy the value. */
            IF VALID-HANDLE(hchgfld) THEN
            DO:
                iextent = hsrcfld:EXTENT.
                IF (iextent > 0) THEN
                DO iarrctr = 1 to iextent:
                    hchgfld:BUFFER-VALUE(iarrctr) = hsrcfld:BUFFER-VALUE(iarrctr).
                END.
                ELSE
                    hchgfld:BUFFER-VALUE = hbuf:BUFFER-FIELD(ifldctr):BUFFER-VALUE.
            END.
        END.
        
        DELETE OBJECT hqry.
        DELETE OBJECT hbuf.

        RETURN .
    END.

    /** Returns whether the _Cdc-Change-Tracking record reflects an UPDATE
        operation. This method is provided as a an alternative to the 
        GetOperation method(), as an UPDATE operation is a frequent 
        operation in a change table.
        */
    METHOD PUBLIC LOGICAL IsUpdate():
        RETURN (mhtrkbuf::_Operation = INTEGER(CDCOperation:AfterUpdate)).
    END.

    /** Returns whether the _Cdc-Change-Tracking record reflects a CREATE
        operation. This method is provided as a an alternative to the 
        GetOperation method(), as a CREATE operation is a frequent 
        operation in a change table.
        */
    METHOD PUBLIC LOGICAL IsCreate():
        RETURN (mhtrkbuf::_Operation = INTEGER(CDCOperation:Create)).
    END.

    /** Returns whether the _Cdc-Change-Tracking record reflects a DELETE
        operation. This method is provided as a an alternative to the 
        GetOperation method(), as a DELETE operation is a frequent 
        operation in a change table.
        */
    METHOD PUBLIC LOGICAL IsDelete():
        RETURN (mhtrkbuf::_Operation = INTEGER(CDCOperation:Delete)).
    END.

    /** Deletes the _Cdc-Change-Tracking record currently in the buffer, 
        along with any related change table records. This is a convenience 
        method to allow users to purge the change tracking record and the 
        change table records for the current _Cdc-Change-Tracking record. 
        This helps to ensure the referential integrity between the 
        _Cdc-Change-Tracking and change table records in one convenient 
        method.
        The caller must have a started a transaction to call this method.
        No AppError is thrown if there are change table records for the 
        _Cdc-Change-Tracking record, because the ETL program has most likely 
        dealt with any discrepancy, and now just wants to purge the data. */
    METHOD PUBLIC  VOID DeleteChangeTrackingRecord():

        DEFINE VARIABLE hqry AS HANDLE      NO-UNDO.
        DEFINE VARIABLE hbuf AS HANDLE      NO-UNDO.
        DEFINE VARIABLE cqry AS CHARACTER   NO-UNDO.

        DO TRANSACTION:
            /* delete the change table rows for this _Cdc-Change-Tracking row */
            IF (mcchgtbl <> ?) THEN
            DO:
                IF mlsqlchgtbl THEN
                    RETURN ERROR NEW Progress.Lang.AppError("Change table is a SQL table and records cannot be deleted from ABL":U, 0).
                CREATE BUFFER hbuf FOR TABLE mcchgtbl. 
                CREATE QUERY hqry.
                hqry:ADD-BUFFER(hbuf).
                cqry = 
                    SUBSTITUTE(
                        "FOR EACH &1 WHERE &2._Change-Sequence = &3":U, 
                        mcchgtbl, mcchgtbl, STRING(mhtrkbuf::_Change-Sequence)).
                hqry:QUERY-PREPARE(cqry).
                hqry:QUERY-OPEN().
                DO WHILE (NOT hqry:QUERY-OFF-END):
                    hqry:GET-NEXT(EXCLUSIVE-LOCK, NO-WAIT).
                    /* TODO: handle NO-WAIT situations */
                    IF (hqry:QUERY-OFF-END) THEN LEAVE.
                    hbuf:BUFFER-DELETE().
                END.
                DELETE OBJECT hqry.
                DELETE OBJECT hbuf.
            END.  /* Delete change table rows */
            /* delete the _Cdc-Change-Tracking row.
             * The caller must have locked the row for this to complete. */
            mhtrkbuf:BUFFER-DELETE().
        END.
        FINALLY:
            IF VALID-OBJECT(hqry) THEN 
                DELETE OBJECT hqry.
            IF VALID-OBJECT(hbuf) THEN
                DELETE OBJECT hbuf.
        END FINALLY.
    END.

END CLASS.
