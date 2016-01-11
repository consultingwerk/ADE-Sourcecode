/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
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
