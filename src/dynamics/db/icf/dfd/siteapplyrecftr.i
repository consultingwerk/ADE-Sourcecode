/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

  DO TRANSACTION ON ERROR UNDO, RETURN ERROR RETURN-VALUE:
    CREATE {&InputTable}.
    BUFFER-COPY tt_{&InputTable} TO {&InputTable}.
  END.

END PROCEDURE.
