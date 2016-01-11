/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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
