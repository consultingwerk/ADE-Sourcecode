/*****************************************************************/  
/* Copyright (c) 1984-2005,2008 by Progress Software Corporation */
/*                                                               */
/* All rights reserved.  No part of this program or document     */
/* may be  reproduced in  any form  or by  any means without     */
/* permission in writing from PROGRESS Software Corporation.     */
/*****************************************************************/
/*---------------------------------------------------------------------------------
  File: rygenogtji.i

  Description:  Design Manager: Object Generator: getTableJoins()

  Purpose:      Code from getTableJoins internal procedure; moved into this include
                because of Section Editor limits.

  Parameters:

  History:
  --------
  (v:010000)    Task:              UserRef:    
                Date:   07/15/2003  Author:     Peter Judge

  Update Notes: Created from scratch.

---------------------------------------------------------------------------------*/
    DEFINE VARIABLE iFollow           AS INTEGER        NO-UNDO.
    DEFINE VARIABLE iLoop             AS INTEGER        NO-UNDO.
    DEFINE VARIABLE cQuery            AS CHARACTER      NO-UNDO.
    DEFINE VARIABLE cDescField        AS CHARACTER      NO-UNDO.
    DEFINE VARIABLE cAllFields        AS CHARACTER      NO-UNDO.
                                    
    DEFINE VARIABLE hbmFile           AS WIDGET-HANDLE  NO-UNDO.
    DEFINE VARIABLE hbxField          AS WIDGET-HANDLE  NO-UNDO.
    DEFINE VARIABLE hbxFile           AS WIDGET-HANDLE  NO-UNDO.
    DEFINE VARIABLE hIndex            AS WIDGET-HANDLE  NO-UNDO.
    DEFINE VARIABLE hFile             AS WIDGET-HANDLE  NO-UNDO.
    DEFINE VARIABLE hIndexField       AS WIDGET-HANDLE  NO-UNDO.
    DEFINE VARIABLE hField            AS WIDGET-HANDLE  NO-UNDO.
    DEFINE VARIABLE httRelate         AS WIDGET-HANDLE  NO-UNDO.
    
    DEFINE VARIABLE hMainQuery        AS HANDLE         NO-UNDO.
    DEFINE VARIABLE hIndexQuery       AS HANDLE         NO-UNDO.
    DEFINE VARIABLE hbxFieldQuery     AS HANDLE         NO-UNDO.
    DEFINE VARIABLE hRelateQuery      AS HANDLE         NO-UNDO.
    DEFINE VARIABLE hEntityTable      AS HANDLE         NO-UNDO.
    DEFINE VARIABLE hEntityFieldTable AS HANDLE         NO-UNDO.
    DEFINE VARIABLE hFieldQuery       AS HANDLE         NO-UNDO.

    DEFINE BUFFER bttRelate FOR ttRelate.
    
    CREATE BUFFER hbmFile     FOR TABLE (pcDataBaseName + "._File")  BUFFER-NAME "bmFile".
    CREATE BUFFER hbxField    FOR TABLE (pcDataBaseName + "._Field") BUFFER-NAME "bxField".
    CREATE BUFFER hbxFile     FOR TABLE (pcDataBaseName + "._File")  BUFFER-NAME "bxFile".                            
    CREATE BUFFER hIndex      FOR TABLE (pcDataBaseName + "._Index").
    CREATE BUFFER hFile       FOR TABLE (pcDataBaseName + "._File").
    CREATE BUFFER hIndexField FOR TABLE (pcDataBaseName + "._Index-Field").
    CREATE BUFFER hField      FOR TABLE (pcDataBaseName + "._Field").   
    CREATE BUFFER httRelate   FOR TABLE ("ttRelate").
    
    EMPTY TEMP-TABLE ttRelate.
    
    CREATE QUERY hMainQuery.
    hMainQuery:SET-BUFFERS(hbmFile).
    hMainQuery:QUERY-PREPARE("FOR EACH bmFile WHERE bmFile._File-name = " + QUOTER(pcTableName)).
    hMainQuery:QUERY-OPEN().
    
    hMainQuery:GET-FIRST(NO-LOCK).
    MAIN_BLOCK:
    DO WHILE hbmFile:AVAILABLE:    
        IF INTEGER(DBVERSION(pcDataBaseName)) > 8 AND
          (TRIM(hbmFile:BUFFER-FIELD("_Owner":U):BUFFER-VALUE) <> "PUB" AND TRIM(hbmFile:BUFFER-FIELD("_Owner":U):BUFFER-VALUE) <> "_FOREIGN") THEN
            LEAVE MAIN_BLOCK.  

        CREATE QUERY hIndexQuery.
    
        hIndexQuery:SET-BUFFERS(hIndex,hFile,hIndexField,hField).
        hIndexQuery:QUERY-PREPARE("FOR EACH  " + pcDataBaseName + "._Index " +
                                  "    WHERE " + pcDataBaseName + "._Index._Unique, " +
                                  "    EACH  " + pcDataBaseName + "._File OF " + pcDataBaseName + "._Index " +
                                  "    WHERE " + pcDataBaseName + "._File._File-number > 0," +
                                  "    EACH  " + pcDataBaseName + "._Index-Field OF " + pcDataBaseName + "._Index," +
                                  "    EACH  " + pcDataBaseName + "._Field OF " + pcDataBaseName + "._Index-Field").
        hIndexQuery:QUERY-OPEN().
        
        hIndexQuery:GET-FIRST(NO-LOCK).
        DO WHILE hIndex:AVAILABLE:
            IF hIndexField:BUFFER-FIELD("_Index-seq":U):BUFFER-VALUE = 1 THEN
            DO:
                CREATE QUERY hbxFieldQuery.
                hbxFieldQuery:SET-BUFFERS(hbxField,hbxFile).
                hbxFieldQuery:QUERY-PREPARE("FOR EACH  " + pcDataBaseName + ".bxField " +
                                            "    WHERE " + pcDataBaseName + ".bxField._Field-Name = " + QUOTER(TRIM(hField:BUFFER-FIELD("_Field-Name":U):STRING-VALUE)) +
                                            "    AND   ROWID(" + pcDataBaseName + ".bxField) <> TO-ROWID(" + QUOTER(hField:ROWID) + "), " +
                                            "    EACH  " + pcDataBaseName + ".bxFile OF " + pcDataBaseName + ".bxField").
    
                hbxFieldQuery:QUERY-OPEN().
    
                hbxFieldQuery:GET-FIRST(NO-LOCK).
                DO WHILE hbxField:AVAILABLE:
                    IF hbmFile:BUFFER-FIELD("_File-Name":U):BUFFER-VALUE <> hFile:BUFFER-FIELD("_File-Name":U):BUFFER-VALUE AND 
                       hbmFile:BUFFER-FIELD("_File-Name":U):BUFFER-VALUE <> hbxFile:BUFFER-FIELD("_File-Name":U):BUFFER-VALUE THEN
                    DO:
                        hbxFieldQuery:GET-NEXT(NO-LOCK).
                        NEXT.
                    END.    /* file names same */
    
                    CREATE ttRelate.
                    ASSIGN ttRelate.cOwnerTable   = hbxFile:BUFFER-FIELD("_File-Name":U):BUFFER-VALUE
                           ttRelate.cDataBaseName = pcDataBaseName
                           ttRelate.cRelatedTable = hFile:BUFFER-FIELD("_File-Name":U):BUFFER-VALUE
                           ttRelate.cIndexName    = hIndex:BUFFER-FIELD("_Index-name":U):BUFFER-VALUE.
                    hbxFieldQuery:GET-NEXT(NO-LOCK).
                END.    /* available hbxField */
                hbxFieldQuery:QUERY-CLOSE().
    
                /* Destroy Query */
                DELETE OBJECT hbxFieldQuery NO-ERROR.
                ASSIGN hbxFieldQuery = ?.
            END.    /* index_seq = 1*/
            ELSE
            DO:
                CREATE QUERY hRelateQuery.
                hRelateQuery:SET-BUFFERS(httRelate,hbxFile).
                hRelateQuery:QUERY-PREPARE("FOR EACH  ttRelate " +
                                           "    WHERE ttRelate.cIndexName    = " + QUOTER(hIndex:BUFFER-FIELD("_Index-Name":U):BUFFER-VALUE) +
                                           "    AND   ttRelate.cRelatedTable = " + QUOTER(hFile:BUFFER-FIELD("_File-Name":U):BUFFER-VALUE) + ", " + 
                                           "    EACH  " + pcDataBaseName + ".bxFile " +
                                           "    WHERE " + pcDataBaseName + ".bxFile._File-Name = ttRelate.cOwnerTable").
    
                hRelateQuery:QUERY-OPEN().
    
                hRelateQuery:GET-FIRST(NO-LOCK).
                DO WHILE httRelate:AVAILABLE:
                    hbxField:FIND-FIRST("WHERE STRING(bxField._File-Recid) = " + QUOTER(hbxFile:RECID)
                                        + " AND bxField._Field-name = " + QUOTER(hField:BUFFER-FIELD("_Field-Name":U):BUFFER-VALUE), NO-LOCK) NO-ERROR.
                    IF NOT hbxField:AVAILABLE THEN
                        httRelate:BUFFER-DELETE().
    
                    hRelateQuery:GET-NEXT(NO-LOCK).
                END.    /* available relate buffer */
                hRelateQuery:QUERY-CLOSE().
    
                /* Destroy Query */
                DELETE OBJECT hRelateQuery NO-ERROR.
                ASSIGN hRelateQuery = ?.
            END.    /* index_seq > 1 */
    
            hIndexQuery:GET-NEXT(NO-LOCK).
        END. /* Index Query */
        hIndexQuery:QUERY-CLOSE().
    
        /* Destroy Query */
        DELETE OBJECT hIndexQuery NO-ERROR.
        ASSIGN hIndexQuery = ?.
        
        hMainQuery:GET-NEXT(NO-LOCK).
    END. /* MAIN:Main Query */
    hMainQuery:QUERY-CLOSE().

    /* Destroy Query */
    DELETE OBJECT hMainQuery NO-ERROR.
    ASSIGN hMainQuery = ?.

    FOR EACH ttRelate WHERE
             ttRelate.cOwnerTable = pcTableName
             BY ttRelate.cOwnerTable:
        hbxFile:FIND-FIRST("WHERE bxFile._File-name = '" + ttRelate.cRelatedTable 
                           + IF DBVERSION(pcDatabaseName) <> '8' THEN "' AND (bxFile._Owner = 'PUB' OR bxFile._Owner = '_FOREIGN')" ELSE '', 
                           NO-LOCK) NO-ERROR.
        IF hbxFile:AVAILABLE THEN
        DO:
            hIndex:FIND-FIRST("WHERE STRING(" + pcDataBaseName + "._Index._File-Recid) = " + QUOTER(hbxFile:RECID) + " AND "
                              + pcDataBaseName + "._Index._Index-Name = " + QUOTER(ttRelate.cIndexName) ,NO-LOCK) NO-ERROR.

            IF hIndex:AVAILABLE THEN
            DO:
                CREATE QUERY hIndexQuery.

                hIndexQuery:SET-BUFFERS(hIndexField,hField).
                hIndexQuery:QUERY-PREPARE("FOR EACH  " + pcDataBaseName + "._Index-Field " +
                                          "    WHERE STRING(" + pcDataBaseName + "._Index-Field._Index-Recid) = " + QUOTER(hIndex:RECID) + ", " + 
                                          "    EACH  " + pcDataBaseName + "._Field OF " + pcDataBaseName + "._Index-Field").

                hIndexQuery:QUERY-OPEN().
                hIndexQuery:GET-FIRST(NO-LOCK).
                DO WHILE hIndexField:AVAILABLE:
                    ASSIGN ttRelate.cLinkFieldName = IF ttRelate.cLinkFieldName = "":U THEN hField:BUFFER-FIELD("_Field-name":U):BUFFER-VALUE
                                                     ELSE ttRelate.cLinkFieldName + ",":U + hField:BUFFER-FIELD("_Field-name":U):BUFFER-VALUE.
                    hIndexQuery:GET-NEXT(NO-LOCK).
                END.    /* index query */
                hIndexQuery:QUERY-CLOSE().

                /* Destroy Query */
                DELETE OBJECT hIndexQuery NO-ERROR.
                ASSIGN hIndexQuery = ?.
            END.    /* index is available */
        END.    /* table is avialable */
    END.    /* each ttRelate */

    /* Destroy Buffers */
    DELETE OBJECT hbmFile NO-ERROR.
    DELETE OBJECT hbxField NO-ERROR.
    DELETE OBJECT hbxFile NO-ERROR.
    DELETE OBJECT hIndex NO-ERROR.
    DELETE OBJECT hFile NO-ERROR.
    DELETE OBJECT hIndexField NO-ERROR.
    DELETE OBJECT hField NO-ERROR.
    DELETE OBJECT httRelate:TABLE-HANDLE NO-ERROR.

    ASSIGN httRelate   = ?
           hbmFile     = ?
           hbxField    = ?
           hbxFile     = ?
           hIndex      = ?
           hFile       = ?
           hIndexField = ?
           hField      = ?.

    /* Get rid of unqualified records */
    FOR EACH ttRelate WHERE
             ttRelate.cOwnerTable   <> pcTableName            OR
             ttRelate.cOwnerTable    = ttRelate.cRelatedTable OR
             ttRelate.cLinkFieldName = "":U:
        DELETE ttRelate.
    END.    /* each ttRElate */
    
    /* We need to ensure that the Table Entity exists as an object before we can add a join to it */
    FOR EACH ttRelate EXCLUSIVE-LOCK:
        /* Delete if not in the DB. */
        IF NOT DYNAMIC-FUNCTION("ObjectExists":U IN ghDesignManager, INPUT ttRelate.cRelatedTable) THEN
            DELETE ttRelate.
    END.    /* each related table */

    /* Look for Duplicate foreign keys e.g. warehouse_num and warehouse_obj */
    FOR EACH ttRelate EXCLUSIVE-LOCK:        
        /* Get the handle to the Entiy Table */
        ASSIGN hEntityTable = DYNAMIC-FUNCTION("getEntityCacheBuffer" IN gshGenManager, INPUT "",INPUT ttRelate.cRelatedTable).
        ASSIGN hEntityFieldTable = DYNAMIC-FUNCTION("getEntityFieldCacheBuffer" IN gshGenManager, INPUT "",INPUT ttRelate.cRelatedTable).

        FIND FIRST bttRelate WHERE
                   ROWID(bttRelate) <> ROWID(ttRelate) AND
                   bttRelate.cRelatedTable = ttRelate.cRelatedTable 
                   EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE bttRelate THEN
        DO:
            /* We want to keep an _obj field */
            IF SUBSTRING(bttRelate.cLinkFieldName,LENGTH(bttRelate.cLinkFieldName) - 3,4) <> "_obj":U AND
               SUBSTRING(ttRelate.cLinkFieldName,LENGTH(ttRelate.cLinkFieldName) - 3,4) <> "_obj":U THEN /* No Obj field here */
                DELETE bttRelate.
            ELSE
            DO:
                IF SUBSTRING(bttRelate.cLinkFieldName,LENGTH(bttRelate.cLinkFieldName) - 3,4) <> "_obj":U THEN
                    DELETE bttRelate.
                ELSE
                    DELETE ttRelate.
            END.    /* this is an Obj field */
        END.    /* can find the related table */
    END.    /* each ttRelate */

    ASSIGN pcAddOnQuery    = "":U
           pcDisplayFields = "":U
           pcAddedTables   = "":U
           iFollow         = 0.

    FOR EACH ttRelate:
        IF INDEX(pcAddedTables,ttRelate.cRelatedTable) = 0 THEN
            ASSIGN iFollow = iFollow + 1.
        ELSE
            NEXT.

        IF iFollow > piFollowDepth AND piFollowDepth <> 0 THEN
            LEAVE.
        ASSIGN cQuery = "FIRST ":U
                      + DYNAMIC-FUNCTION("getQualifiedTableName":U IN ghDesignManager, INPUT ttRelate.cDataBaseName, INPUT ttRelate.cRelatedTable)
                      + " WHERE " 
                      + DYNAMIC-FUNCTION("getQualifiedTableName":U IN ghDesignManager, INPUT ttRelate.cDataBaseName, INPUT ttRelate.cRelatedTable)
                      + ".":U + ENTRY(1,ttRelate.cLinkFieldName) + " = ":U
                      + DYNAMIC-FUNCTION("getQualifiedTableName":U IN ghDesignManager, INPUT pcDataBaseName, INPUT pcTableName) 
                      + ".":U + ENTRY(1,ttRelate.cLinkFieldName)
                      + " NO-LOCK ".

        ASSIGN pcAddedTables  = IF pcAddedTables = "":U THEN DYNAMIC-FUNCTION("getQualifiedTableName":U IN ghDesignManager, INPUT ttRelate.cDataBaseName, INPUT ttRelate.cRelatedTable)
                                ELSE pcAddedTables + ",":U
                              + DYNAMIC-FUNCTION("getQualifiedTableName":U IN ghDesignManager, INPUT ttRelate.cDataBaseName, INPUT ttRelate.cRelatedTable)
               pcAddOnQuery   = IF pcAddOnQuery = "":U THEN cQuery ELSE pcAddOnQuery + ", ":U + cQuery
               pcAddTableList = pcAddTableList + (IF NUM-ENTRIES(pcAddTableList) > 0 THEN ",":U ELSE "":U)
                              + ttRelate.cDataBaseName + ".":U + ttRelate.cRelatedTable + " WHERE ":U
                              + pcDataBaseName + ".":U + pcTableName + " ...":U
               pcJoinCode     = pcJoinCode + (IF NUM-ENTRIES(pcJoinCode) > 0 THEN CHR(5) ELSE "":U)
                              + ttRelate.cDataBaseName + ".":U + ttRelate.cRelatedTable + ".":U + ENTRY(1,ttRelate.cLinkFieldName) + " = ":U
                              + pcDataBaseName + ".":U + pcTableName + ".":U + ENTRY(1,ttRelate.cLinkFieldName).

        hEntityTable:FIND-FIRST("WHERE entity_mnemonic_description = " + QUOTER(ttRelate.cRelatedTable), NO-LOCK) NO-ERROR.
        IF hEntityTable:AVAILABLE THEN
        DO:
            IF hEntityTable:BUFFER-FIELD("entity_description_field"):BUFFER-VALUE <> "":U THEN
            DO:
                ASSIGN pcDisplayFields = IF pcDisplayFields = "":U THEN hEntityTable:BUFFER-FIELD("entity_description_field"):BUFFER-VALUE ELSE pcDisplayFields + ";":U + hEntityTable:BUFFER-FIELD("entity_description_field"):BUFFER-VALUE.
                NEXT.   /* each ttRelate ... */
            END.    /* there is an entityi description */
            ELSE 
            DO:
                ASSIGN cDescField = "":U.

                /* Try and find a descriptave field */
                CREATE QUERY hFieldQuery.
                hFieldQuery:ADD-BUFFER(hEntityFieldTable).
                hFieldQuery:QUERY-PREPARE("FOR EACH " + hEntityFieldTable:NAME
                                          + " WHERE entity_mnemonic = " + QUOTER(hEntityTable:BUFFER-FIELD("entity_mnemonic"):BUFFER-VALUE)) NO-ERROR.

                hFieldQuery:QUERY-OPEN().
                hFieldQuery:GET-FIRST().
                DO WHILE hEntityFieldTable:AVAILABLE:
                    IF CAN-DO("*reference,*code,last_name,*tla,*short*,*id,*desc*,first_name,*name*",hEntityFieldTable:BUFFER-FIELD("display_field_name"):BUFFER-VALUE) THEN
                        ASSIGN cDescField = IF cDescField = "":U THEN hEntityFieldTable:BUFFER-FIELD("display_field_name"):BUFFER-VALUE
                                            ELSE cDescField + ",":U + hEntityFieldTable:BUFFER-FIELD("display_field_name"):BUFFER-VALUE.
                    hFieldQuery:GET-NEXT().
                END.    /* available entity field table */
                hFieldQuery:QUERY-CLOSE().

                DELETE OBJECT hFieldQuery NO-ERROR.
                ASSIGN hFieldQuery = ?.
            END. /* Entity Available */

            /* If we could not find one in the list - use the link field */
            IF cDescField = "":U THEN
                ASSIGN cDescField = ttRelate.cLinkFieldName.

            /* Select the best fit */
            IF NUM-ENTRIES(cDescField) > 1 THEN
            DO:
                ASSIGN cAllFields = cDescField.
                
                DO iLoop = 1 TO NUM-ENTRIES(cAllFields):
                    ASSIGN cDescField = ENTRY(iloop,cAllFields).

                    IF CAN-DO("*desc*,first_name,*name*,*short*",cDescField) THEN
                        LEAVE.
                END.    /* loop through all fields */
            END.    /* there is more than one desc field */
            
            /* If we could not find something in the list - use the first one */
            IF NUM-ENTRIES(cDescField) > 1 THEN
                ASSIGN cDescField      = ENTRY(1,cDescField).
            ASSIGN pcDisplayFields = IF pcDisplayFields = "":U THEN cDescField ELSE pcDisplayFields + ";":U + cDescField.
        END.    /* there is an entity table field */
        ELSE
        /* If the entity record does not exist - just reserve the space for it */
            ASSIGN pcDisplayFields = IF pcDisplayFields = "":U THEN ttRelate.cLinkFieldName ELSE pcDisplayFields + ";":U + ttRelate.cLinkFieldName.
    END.    /* each ttRelate */
    /* ---- EOF ---- */
