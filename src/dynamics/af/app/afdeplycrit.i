/* Copyright (C) 2006 Progress Software Corporation.  All Rights Reserved. */
/*------------------------------------------------------------------------
    File        : afdeplycrit.i
    Purpose     : Defines ttCriteria table for Deployment Automation

    Author(s)   : pjudge
    Created     : 8/1/2006
    Notes       : Created from scratch
    			  -  Used in af/app/afdeplymtp.p 
  ----------------------------------------------------------------------*/

/* Used to pass parameters to Generate4GLObjects for instance,
   where there are a multitude of criteria (object type, object etc).
   Could be used elsewhere.   
 */
define temp-table ttCriteria no-undo
    field Type         as character     /* object, objecttype, productmodule, source, ... */
    field Primary      as character
    field Secondary    as character
    field Tertiary     as character
    index idxType
        Type
        Primary.
            
/* - E - O - F - */