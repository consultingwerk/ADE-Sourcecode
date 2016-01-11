/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
DEFINE TEMP-TABLE ttFile NO-UNDO
    FIELD _db-name                      AS CHARACTER FORMAT "X(72)"   LABEL 'Database'
    FIELD _File-name                    AS CHARACTER FORMAT "X(32)"   LABEL 'Table name'
    FIELD _Owner                        AS CHARACTER FORMAT "X(32)"   LABEL 'Owner'
    FIELD _hidden                       AS LOGICAL  
    INDEX idxDatabaseTable AS PRIMARY UNIQUE
      _db-name _File-name _Owner
    .
