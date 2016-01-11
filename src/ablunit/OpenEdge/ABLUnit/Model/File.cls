/************************************************
Copyright (c)  2013-2014 by Progress Software Corporation. All rights reserved.
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

USING Progress.Lang.*.



CLASS OpenEdge.ABLUnit.Model.File: 
    DEFINE PUBLIC PROPERTY fileN AS CHARACTER NO-UNDO GET. SET.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
		
	CONSTRUCTOR PUBLIC File (  input fileN as CHARACTER):
		SUPER ().
		this-object:fileN = fileN.
	END CONSTRUCTOR.

END CLASS.