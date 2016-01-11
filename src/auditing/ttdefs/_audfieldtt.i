/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
DEFINE TEMP-TABLE ttField NO-UNDO
    FIELD _File-name                    AS CHARACTER FORMAT "X(32)"   LABEL "Table name"
    FIELD _Owner                        AS CHARACTER FORMAT "X(20)"   LABEL "SQL Owner"
    FIELD _Field-name                   AS CHARACTER FORMAT "X(32)"   LABEL 'Field name'
    FIELD _Desc                         AS CHARACTER FORMAT "x(72)"   LABEL 'Description'
    INDEX idxField AS PRIMARY UNIQUE
      _File-name _Owner _Field-name
    .
