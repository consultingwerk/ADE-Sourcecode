/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
{db/icf/dfd/sitedatahdrout.i}

DEFINE VARIABLE cFileName   AS CHARACTER   NO-UNDO.

FIND ttDumpFileLocation 
  WHERE ttDumpFileLocation.cDumpFile = {&OutputFile}
  NO-ERROR.

IF NOT AVAILABLE(ttDumpFileLocation) OR
   ttDumpFileLocation.cDumpFilePath = ? THEN
  RETURN.

OUTPUT TO VALUE(ttDumpFileLocation.cDumpFilePath) APPEND.

FOR EACH {&OutputTable}
  WHERE ({&OutputTable}.{&ObjField} - TRUNCATE({&OutputTable}.{&ObjField},0)= pdSiteNo):
  EXPORT {&OutputTable}.
END.

OUTPUT CLOSE.
