/* ***********************************************************/
/* Copyright (c) 2012 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/

/**
This acts as a wrapper around rest.p to avoid running persistent
procedures from the appserver.
*/

define input parameter cParam as character no-undo.
define output parameter cResult as longchar no-undo.

define variable fAPIhandle as handle no-undo.

run darest/rest.p persistent set fAPIhandle.
run SetUseLongChar in fAPIhandle(true).

run runApi in fAPIhandle (input cParam).

run getOutput in fAPIhandle(output cResult).

finally:
    delete procedure fAPIhandle.
end finally.


