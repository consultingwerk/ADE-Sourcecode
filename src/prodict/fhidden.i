/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/


/**************************************************************************
    Procedure:  _fhidden.i

    Purpose:    Defines a 'static' variable which determines whether or
                not hidden tables are shown in the DD or Admin tool. The
                DD/Admin reports will use this value when they run.
                
    Syntax :    {prodict/_fhidden.i}

    Parameters: None

    Description:
    Notes  :
    Authors: Gerry Seidl
    Date   : 05/31/95
**************************************************************************/

DEFINE NEW GLOBAL SHARED VARIABLE fhidden AS LOGICAL NO-UNDO INITIAL NO.
