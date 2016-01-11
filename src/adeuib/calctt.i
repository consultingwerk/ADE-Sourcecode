DEFINE TEMP-TABLE ttCalcField
    FIELD tName          AS CHARACTER LABEL 'Object filename'
    FIELD tDesc          AS CHARACTER LABEL 'Object description'
    FIELD tProductModule AS CHARACTER LABEL 'Product module code'
    FIELD tEntity        AS CHARACTER LABEL 'Entity'
    FIELD tInstanceName  AS CHARACTER LABEL 'Entity instance name'
    FIELD tDataType      AS CHARACTER
    FIELD tLabel         AS CHARACTER
    FIELD tFormat        AS CHARACTER
    FIELD tHelp          AS CHARACTER
    FIELD tColumnLabel   AS CHARACTER
    INDEX idxEntity
      tEntity
      tName.
