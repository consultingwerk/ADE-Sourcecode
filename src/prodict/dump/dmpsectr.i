/*************************************************************/  
/* Copyright (c) 1984-2005,2007 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/* dmpsectr.i

Author: Kenneth S. McIntosh

Created: April 28, 2005

Purpose:
    dumps trailer information for secure dump utility

Preconditions:    
    needs the stream to be open, and all data to be output
    
Text Parameters:
    &trailer-info   Formatted PUT UNFORMATTED statement to execute
    &seek-stream    "<stream-name>"        or "OUTPUT"
    &stream         "stream <stream-name>" or ""
    &data-end
    
Included in:
  prodict/dump/_dmpsec.p    
  
History:
   fernando   06/20/07  Support for large files
  
*/
/*------------------ begin Trailer-INFO ------------------*/

  PUT {&stream} UNFORMATTED "." SKIP.
  
  {&data-end} = SEEK({&seek-stream}).
  
  PUT {&stream} UNFORMATTED "PSC" SKIP.
  
  {&trailer-info}
  
  PUT {&stream} UNFORMATTED
    "." SKIP .

  /* location of trailer */
  IF {&data-end} > 9999999999 THEN
      PUT {&stream} UNFORMATTED STRING({&data-end}) SKIP.
  ELSE
      PUT {&stream} UNFORMATTED STRING({&data-end},"9999999999") SKIP.

/*------------------ end   Trailer-INFO ------------------*/
