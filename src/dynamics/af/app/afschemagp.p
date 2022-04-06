/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
{src/adm2/schemai.i}


DEFINE INPUT PARAMETER cDatabaseName AS CHARACTER.                                 
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttSchema.

DEFINE VARIABLE iIndexNumber AS INTEGER NO-UNDO.
DEFINE VARIABLE iIndexFieldNumber AS INTEGER NO-UNDO.

FOR EACH ttSchema WHERE ttSchema.DATABASE_name = "":

    FIND db_metaschema._file NO-LOCK
        WHERE db_metaschema._file._file-name = ttSchema.TABLE_name
        NO-ERROR.

    IF AVAILABLE db_metaschema._file THEN
    DO:
        ttSchema.DATABASE_name = cDatabaseName.
        ttSchema.TABLE_label = db_metaschema._file._file-label.
        iIndexNumber = 0.
        FOR EACH db_metaschema._index OF db_metaschema._file:
            iIndexNumber = iIndexNumber + 1.
            iIndexFieldNumber = 0.
            FOR EACH db_metaschema._index-field OF db_metaschema._index,
                FIRST db_metaschema._field OF db_metaschema._index-field:

                iIndexFieldNumber = iIndexFieldNumber + 1.
                IF db_metaschema._field._field-name = ttSchema.FIELD_name THEN
                DO:
                    ttSchema.column_indexed = YES. 

                    ttSchema.index_position = ttSchema.index_position +
                                              (IF ttSchema.index_position = "":U THEN "":U ELSE ",":U) +
                                              STRING(iIndexNumber) + "." + STRING(iIndexFieldNumber).
                    IF db_metaschema._index._wordidx <> ? THEN ttSchema.word_index = TRUE.
                END.

            END.
        END.

        /* check for calculated fields */
        IF NOT CAN-FIND(FIRST db_metaschema._field OF db_metaschema._file
                        WHERE db_metaschema._field._field-name = ttSchema.FIELD_name) THEN
          ASSIGN 
            ttSchema.calculated_field = YES.
        ELSE
          ASSIGN 
            ttSchema.calculated_field = NO.
    END.

END.
