/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/* CNTRAPI.I                            */
/* Created 3/20/95.                     */
/*                                      */

/* This file creates Progress definitions for the UIB support functions */
/* in CNTR.DLL.                                                         */

/**
 ** These are the possible return values of these functions
 **
 
CNTR_SUCCESS            0       Function completed succesfully
CNTR_UNKNOWN_FAILURE    1       Function failed for an unknown reason
CNTR_BAD_HANDLE         2       A handle passed in was bad
CNTR_BUFFER_TOO_SMALL   3       The buffer passed in was too small
CNTR_MEM_ALLOC_FAILURE  4       The function could not allocate memory it needed
CNTR_BAD_EVENT          5       The event number passed in is not legal
CNTR_BAD_PROP           6       The property passed in is not legal
CNTR_CANNOT_DO_NOW      7       The function is blocked.  Try again later.
CNTR_BAD_DATAFILE       8       The datafile contained unexpected data
CNTR_BAD_FILENAME       9       The provided filename wasn't valid
CNTR_BAD_TYPE           10      The type of property wasn't correct
CNTR_DLL_INIT_ERROR     11      DLL wasn't initialized

**
**/

&GLOBAL-DEFINE BlockSize 4096

PROCEDURE CntrRegisterLib EXTERNAL "CNTR.DLL":U :
    DEFINE INPUT PARAMETER pszFileName as CHARACTER NO-UNDO.
    DEFINE RETURN PARAMETER uResult as SHORT NO-UNDO.    
END.
/*
// INPUTS:
//              pszFileName             Name of VBX/OCX file
// RETURNS:
//              If successful, returns CNTR_SUCCESS
// PURPOSE:
//              Adds the controls in the specified file to the collection of available
//              (i.e. registered) controls.
*/



PROCEDURE CntrUnRegisterLib EXTERNAL "CNTR.DLL":U :
    DEFINE INPUT PARAMETER pszFileName as CHARACTER NO-UNDO.
    DEFINE RETURN PARAMETER uResult as SHORT NO-UNDO.    
END.
/*
// INPUTS:
//              pszFileName             Name of VBX/OCX file
// RETURNS:
//              If successful, returns CNTR_SUCCESS
// PURPOSE:
//              Removes the controls in the specified file to the collection of available
//              (i.e. registered) controls if possible.  If an control is instantiated,
//              then this call will fail.
*/

PROCEDURE CntrGetControlNames EXTERNAL "CNTR.DLL":U  :
    DEFINE INPUT PARAMETER pszBuffer as MEMPTR NO-UNDO.
    DEFINE INPUT PARAMETER uBufLen as SHORT NO-UNDO.
    DEFINE RETURN PARAMETER uResult as SHORT NO-UNDO.    
END.
/*
// INPUTS:
//              pszBuffer       Pointer to buffer to write string to
//              uBufLen         Size of passed in buffer
// RETURNS:
//              If successful CNTR_SUCCESS is returned and an <LF> delimited string 
//              of the names of the registered controls to pszBuffer is written to pszBuffer.
//              A control becomes registered upon CntrCreateControl() and CntrRegisterLib()
//
//              If there are no models, a null string is provided (as opposed to a NULL ptr)
//              and the function is considered a success.
//
// PURPOSE:
//              Get the names of the registered controls 
*/

PROCEDURE CntrGetEventList EXTERNAL "CNTR.DLL":U :
    DEFINE INPUT PARAMETER hWnd as SHORT NO-UNDO.
    DEFINE INPUT PARAMETER pszBuffer as MEMPTR NO-UNDO.
    DEFINE INPUT PARAMETER uBufLen as SHORT NO-UNDO.
    DEFINE RETURN PARAMETER uResult as SHORT NO-UNDO.    
END.
/*
// INPUTS:
//              hWidget         The control to get the events of
//              pszBuffer       Pointer to buffer to write string to
//              uBufLen         Size of passed in buffer
// RETURNS:             
//              If successful CNTR_SUCCESS is returned and an <LF> delimited string 
//              of the follwoing format is written to pszBuffer.
//                      "Event1<LF>Event2..."
//                      There is no final <LF>
// PURPOSE:
//              To get a list of the names of the events the specified VBX can generate.
*/

PROCEDURE CntrGetEventInfo EXTERNAL "CNTR.DLL":U  :
    DEFINE INPUT PARAMETER hWnd as SHORT NO-UNDO.
    DEFINE INPUT PARAMETER pszEventName as CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pszBuffer as MEMPTR NO-UNDO.
    DEFINE INPUT PARAMETER uBufLen as SHORT NO-UNDO.
    DEFINE RETURN PARAMETER uResult as SHORT NO-UNDO.    
END.
/*
// INPUTS:
//              hWidget         The control to get the event info from
//              nEventNum       The index in the event array returned by CntrGetEventList()
//              pszBuffer       Pointer to buffer to write string to
//              uBufLen         Size of passed in buffer
// RETURNS:
//              If successful CNTR_SUCCESS is returned and an <LF> delimited string 
//              of the argument names and their types is written to pszBuffer in 
//              the following format:
//                      "Name1<LF>T<LF>Name2<LF>T..."
//                      'T' is a character declaring the type of the property
//                      The Types are:
//                              S = string
//                              I = integer
//                              D = decimal
//
//              There is no final <LF>
//
// PURPOSE:
//              Get the argument names and types for an event so that you can construct
//              an event handler in the 4GL.
*/

PROCEDURE CntrGetPropertyList EXTERNAL "CNTR.DLL":U  :
    DEFINE INPUT PARAMETER hWidget as SHORT NO-UNDO.
    DEFINE INPUT PARAMETER pszBuffer as MEMPTR NO-UNDO.
    DEFINE INPUT PARAMETER uBufLen as SHORT NO-UNDO.
    DEFINE RETURN PARAMETER uResult as SHORT NO-UNDO.    
END.
/*
// INPUTS:
//              hWidget         The control to get the properties from
//              pszBuffer       Pointer to buffer to write string to
//              uBufLen         Size of passed in buffer
// RETURNS:
//              If successful CNTR_SUCCESS is returned and an <LF> delimited string 
//              of the following format is written to pszBuffer:
//                      "Prop1<LF>T<LF>Prop<LF>T..."
//                      There is no final LF
//                      'T' is a character declaring the type of the property
//                      The Types are:
//                              S = string
//                              I = integer
//                              D = decimal
//                              P = picture
//                              B = binary
//
//              NOTE: Properties of Unknown type, and properties without names (0 length)
//                        are NOT included in the list.
//
// PURPOSE:
//              To get a list of the names and types of properties of a control.  Only
//              valid run time settable properties are returned
*/

/*
PROCEDURE CntrCopyControl EXTERNAL "CNTR.DLL":U :
    DEFINE INPUT PARAMETER hSrcWidget as SHORT NO-UNDO.
    DEFINE INPUT PARAMETER hDestWidget as SHORT NO-UNDO.
    DEFINE INPUT PARAMETER pszName as CHARACTER NO-UNDO.
    DEFINE RETURN PARAMETER uResult as SHORT NO-UNDO.    
END.
*/
/*
// INPUTS:
//              hSrcWidget              Control that is to be copied (has a VBX)
//              hDestWidget             Container that will contain the VBX copy 
//              pszName                 Name to give to copy of the control
// RETURNS:
//              If successful, returns CNTR_SUCCESS
// PURPOSE:
//              Duplicates an instantiated control.  The new control is exactly the same except
//              for the name.
*/

PROCEDURE CntrSaveControl EXTERNAL "CNTR.DLL":U :
    DEFINE INPUT PARAMETER hWidget as SHORT NO-UNDO.
    DEFINE INPUT PARAMETER pszFileName as CHARACTER NO-UNDO.
    DEFINE RETURN PARAMETER uResult as SHORT NO-UNDO.    
END.
/*
// INPUTS:
//              hWidget                 The HWND of the widget that contains the control whose state
//                                              is to be saved
//              pszFilename             Name of file to save data to
// RETURNS:
//              Was the function successful?
// PURPOSE:
//              Writes binary data necessary to instantiate a control in its current state.
//              It uses the VBX's name property for a key to later retrieve the data.  
//
//              NOTE: If there is already an entry with that name, it will be overwritten, 
//              thus it is important to make sure controls have unique names.
*/

PROCEDURE CntrRestoreControl EXTERNAL "CNTR.DLL":U :
    DEFINE INPUT PARAMETER hWidget as SHORT NO-UNDO.
    DEFINE INPUT PARAMETER pszFileName as CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pszKey as CHARACTER NO-UNDO.
    DEFINE RETURN PARAMETER uResult as SHORT NO-UNDO.
END.
/*
// INPUTS:
//      hWidget         The HWND of the widget that will contain the control to restore
//      pszFilename     Name of file to read data from
//      pszKey          Name of key in file to look up to get the control's data
// RETURNS:
//      Was the function successful?
// PURPOSE:
//      Reads binary data necessary to instantiate a control from a previous state,
//      and instantiates it in that state.  
*/

PROCEDURE CntrCreatePropSheet EXTERNAL "CNTR.DLL":U :
    DEFINE INPUT PARAMETER hParent as SHORT NO-UNDO.
    DEFINE INPUT PARAMETER nLeft as SHORT NO-UNDO.
    DEFINE INPUT PARAMETER nTop as SHORT NO-UNDO.
    DEFINE INPUT PARAMETER nWidth as SHORT NO-UNDO.
    DEFINE INPUT PARAMETER nHeight as SHORT NO-UNDO.
    DEFINE RETURN PARAMETER uResult as SHORT NO-UNDO.
END.
/*
// INPUTS:
//      hParent         Handle to window that is to be parent to the property sheet
//		nLeft			Where the left of the window should be (in screen coords)
//		nTop			Where the top of the window should be (in screen coords)
//		nWidth			How wide should the window be (in pixels)
//		nHeight			How tall should the window be (in pixels)
// RETURNS:
//		CNTR_SUCCESS		If successful
//		CNTR_BAD_HANDLE		if hParent is invalid
//		CNTR_UNKNOWN_FAILURE something bad happened.
// PURPOSE:
//		Puts up a property sheet.  The window comes up "blank."  Use CntrSetPropSheet()
//		to get it to display info about a VBX.
*/

PROCEDURE CntrSetPropSheet EXTERNAL "CNTR.DLL":U :
    DEFINE INPUT PARAMETER hWidget as SHORT NO-UNDO.
    DEFINE RETURN PARAMETER uResult as SHORT NO-UNDO.
END.
/*
// INPUTS:
//		hWidget			Handle to the container widget containing a VBX
//	RETURNS:
//		CNTR_SUCCESS		If successful
//		CNTR_BAD_HANDLE		If the widget handle is invalid or no
//							VBX is contained.
//	PURPOSE:
//		This function causes the property sheet to display the properties of the 
//		specified controls.  Any edits made are immediately reflected in the 
//		control.  There is no undo. 
*/

PROCEDURE CntrDestroyPropSheet EXTERNAL "CNTR.DLL":U :
    DEFINE RETURN PARAMETER uResult as SHORT NO-UNDO.
END.
/*
// INPUTS:
//		None
//	RETURNS:
//		CNTR_SUCCESS		If successful
//	PURPOSE:
//		A programatic way to destroy the property sheet.  If the
//		prop sheet is not already created, this function does nothing.
*/

PROCEDURE CntrGetPaletteBitmap EXTERNAL "CNTR.DLL":U :
    DEFINE INPUT  PARAMETER pszModelName AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pszFileName  AS CHARACTER NO-UNDO.
    DEFINE RETURN PARAMETER uResult      AS SHORT     NO-UNDO.
END.
/*
// INPUTS:
//		pszModelName   The VBX Model 
//      pszFileName    The filename in which to dump the bmp into
//	RETURNS:
//		CNTR_SUCCESS		If successful
//	PURPOSE:
//		Dump a model's palette bitmap into a file.
*/

PROCEDURE CntrSetDesignMode EXTERNAL "CNTR.DLL":U :
    DEFINE INPUT  PARAMETER bDesignMode AS SHORT NO-UNDO.
    DEFINE RETURN PARAMETER uResult     AS SHORT NO-UNDO.
END.
/*
// INPUTS:			   TRUE to enter design mode 
// RETURNS:
//		CNTR_SUCCESS		If successful
//	PURPOSE:
//		Put the VBX world into design or run mode.
*/

PROCEDURE CntrGetMode EXTERNAL "CNTR.DLL":U :
    DEFINE OUTPUT PARAMETER mode    AS MEMPTR NO-UNDO.
    DEFINE RETURN PARAMETER uResult AS SHORT  NO-UNDO.
END.
/*
// INPUTS: None 
// RETURNS:
//      mode
//		CNTR_SUCCESS		If successful
//	PURPOSE:
//		Tells what mode wer'e in D for Design, R for Run.
*/


PROCEDURE CntrIsInvisibleAtRuntime EXTERNAL "CNTR.DLL":U :
    DEFINE INPUT  PARAMETER hWidget     as SHORT NO-UNDO.    
    DEFINE INPUT  PARAMETER pbInvisible AS MEMPTR NO-UNDO.
    DEFINE RETURN PARAMETER uResult     as SHORT NO-UNDO.

END.
/*
// INPUTS:
//		hWidget			Handle to the container widget containing a VBX
//	RETURNS:
//      pbInvisble          True if the control should be invisible
//		CNTR_SUCCESS		If successful
//		CNTR_BAD_HANDLE		If the widget handle is invalid or no
//							VBX is contained. 
// RETURNS:
//      mode
//		CNTR_SUCCESS		If successful
//	PURPOSE:
//		
*/

PROCEDURE CntrIsControlChanged EXTERNAL "CNTR.DLL":U :
    DEFINE INPUT  PARAMETER hWidget     as SHORT NO-UNDO.    
    DEFINE INPUT  PARAMETER pbChanged   AS MEMPTR NO-UNDO.
    DEFINE RETURN PARAMETER uResult     as SHORT NO-UNDO.

END.
/*
// INPUTS:
//		hWidget			Handle to the container widget containing a VBX
//	RETURNS:
//      pbInvisble          True if the control is dirty
//		CNTR_SUCCESS		If successful
//		CNTR_BAD_HANDLE		If the widget handle is invalid or no
//							VBX is contained. 
// RETURNS:
//      mode
//		CNTR_SUCCESS		If successful
//	PURPOSE:
//		
*/
PROCEDURE CntrIsPropSheetUp EXTERNAL "CNTR.DLL":U :   
    DEFINE INPUT  PARAMETER pbProVisible AS MEMPTR NO-UNDO.
    DEFINE RETURN PARAMETER uResult     as SHORT NO-UNDO.

END.
/*
// INPUTS:
//	RETURNS:
//      pbInvisble          True if the prop sheet is visible
//		CNTR_SUCCESS		If successful
//		CNTR_BAD_HANDLE		If the widget handle is invalid or no
//							VBX is contained. 
// RETURNS:
//      mode
//		CNTR_SUCCESS		If successful
//	PURPOSE:
//		
*/

PROCEDURE CntrSaveControlKeepState EXTERNAL "CNTR.DLL":U :   
    DEFINE INPUT  PARAMETER hWidget     as SHORT     NO-UNDO.
    DEFINE INPUT  PARAMETER pszFileName as CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER bKeppState  as SHORT     NO-UNDO.
    DEFINE RETURN PARAMETER uResult     as SHORT     NO-UNDO.

END.

/* End of File */
