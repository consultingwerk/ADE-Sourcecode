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

CLASS OpenEdge.ABLUnit.Model.File: 

    DEFINE PUBLIC PROPERTY fileN AS CHARACTER NO-UNDO GET. SET.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
		
	CONSTRUCTOR PUBLIC File ( INPUT pcFileN AS CHARACTER ):
		SUPER ().
		THIS-OBJECT:fileN = pcFileN.
	END CONSTRUCTOR.

END CLASS.