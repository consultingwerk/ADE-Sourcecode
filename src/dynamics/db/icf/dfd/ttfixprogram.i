/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
DEFINE TEMP-TABLE ttFixProgram NO-UNDO
  FIELD iProgNo   AS INTEGER
  FIELD cProgName AS CHARACTER
  FIELD cFullProgPath AS CHARACTER
  INDEX pudx IS UNIQUE PRIMARY
    iProgNo
  INDEX udx IS UNIQUE
    cProgName
  .
