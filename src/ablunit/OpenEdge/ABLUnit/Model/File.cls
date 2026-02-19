/************************************************
Copyright (c)  2013-2014,2024 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
   File        : File
   Purpose     :
   Syntax      :
   Description :
   Author(s)   : svutla
   Created     : Thu Oct 31 18:14:59 IST 2013
   Notes       :
 ----------------------------------------------------------------------*/

@deprecated(since="13.0.0").
class OpenEdge.ABLUnit.Model.File:

    define public property fileN as character no-undo get. set.

    /*------------------------------------------------------------------------------
     Purpose: Encapsulates a filename as an object, but really nothing more
     Notes: This is deprecated in favor of the OpenEdge.Core.File object instead
    ------------------------------------------------------------------------------*/
    constructor public File ( input pcFileN as character ):
        super ().
        this-object:fileN = pcFileN.

        message "The class OpenEdge.ABLUnit.Model.File is deprecated in favor of OpenEdge.Core.File".
    end constructor.

end class.