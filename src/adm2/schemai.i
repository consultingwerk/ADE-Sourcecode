/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
DEFINE TEMP-table ttSchema 
    FIELD sdo_name                      AS CHARACTER
    FIELD column_sequence               AS INTEGER
    FIELD column_name                   AS CHARACTER
    FIELD database_name                 AS CHARACTER
    FIELD table_name                    AS CHARACTER
    FIELD table_sequence                AS INTEGER
    FIELD table_label                   AS CHARACTER
    FIELD field_name                    AS CHARACTER
    FIELD column_DATAtype               AS CHARACTER
    FIELD column_Updatable              AS LOGICAL
    FIELD column_indexed                AS LOGICAL
    FIELD column_case_sensitive         AS LOGICAL
    FIELD column_format                 AS CHARACTER
    FIELD column_label                  AS CHARACTER
    FIELD column_mandatory              AS LOGICAL
    FIELD column_width_chars            AS DECIMAL
    FIELD index_position                AS CHARACTER
    FIELD adm_column                    AS LOGICAL
    FIELD word_index                    AS LOGICAL
    FIELD search_from                   AS CHARACTER
    FIELD search_to                     AS CHARACTER
    FIELD search_contains               AS CHARACTER
    FIELD search_matches                AS CHARACTER
    FIELD calculated_field              AS LOGICAL
    FIELD sdo_handle                    AS HANDLE
    FIELD sdo_order                     AS INTEGER
    INDEX primidx IS UNIQUE PRIMARY sdo_name column_sequence
    INDEX key2 column_sequence
    INDEX key3 column_name
    INDEX key4 calculated_field
    INDEX idx_handle
        sdo_handle
    .
