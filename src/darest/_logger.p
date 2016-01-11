/* ***********************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/


/*
	this program handles logging for the server process
*/

DEFINE STREAM sLog.
DEFINE VARIABLE LogFile AS CHARACTER NO-UNDO.

FUNCTION log RETURNS CHARACTER
	(INPUT msg AS CHARACTER):
	
	RUN writeLog (msg).
	
END FUNCTION.

PROCEDURE writeLog:
	DEFINE INPUT PARAMETER logNote AS CHARACTER NO-UNDO.
	
	OUTPUT STREAM sLog TO VALUE(LogFile) APPEND.
	PUT STREAM sLog UNFORMATTED "["STRING(TODAY,"99/99/9999") "-" STRING(TIME,"HH:MM:SS") "] " logNote SKIP.
	OUTPUT STREAM sLog CLOSE.	
END.


PROCEDURE SetLogFile:
	DEFINE INPUT PARAMETER lFile AS CHARACTER NO-UNDO.
	LogFile = lFile.
END.

PROCEDURE OpenLogFile:
	OUTPUT STREAM sLog TO VALUE(LogFile).
	OUTPUT STREAM sLog CLOSE.
	RUN writeLog ("Log file opened.").

END.

PROCEDURE CloseLogFile:

	RUN writeLog("Log file closed.").

END.