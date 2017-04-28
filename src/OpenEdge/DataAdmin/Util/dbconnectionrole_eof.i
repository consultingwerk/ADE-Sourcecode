/************************************************
  Copyright (c) 2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : dbconnectionrole_eof.i
    Purpose     : Common util function s for the dbconnectionrole_*.p utilities
    Author(s)   : pjudge 
    Created     : 2016-05-03
    Notes       :
  ----------------------------------------------------------------------*/

catch poError as Progress.Lang.Error :
    PutMessage(substitute('Caught Progress.Lang.Error: &1', poError:GetClass():TypeName),   
               OpenEdge.Logging.LogLevelEnum:ERROR).
    PutMessage(substitute('Caught Progress.Lang.Error: &1', poError:GetMessage(1)),
               OpenEdge.Logging.LogLevelEnum:ERROR).
    PutMessage(substitute('Caught Progress.Lang.Error: &1', poError:CallStack) + '~n':u,
               OpenEdge.Logging.LogLevelEnum:ERROR).
end catch.
finally:
    PutMessage('OPERATION COMPLETE', 
               OpenEdge.Logging.LogLevelEnum:INFO).
    /* quit so we don't end up in the proc editor */
    quit.
end finally.
/* eof */
