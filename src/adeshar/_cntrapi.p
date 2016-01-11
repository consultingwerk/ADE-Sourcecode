/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _cntrapi.p

Description:
    Contains the PROGRESS interfaces to VBX DLL support. This procedure will
    call details from the caller.

Input Parameters:
    <None>

Output Parameters:
   <None>

Author: D. Lee

The only function found in cntrapi.i that is not in this .p file is
the function to set design mode. That is in its own .p file. The reason is 
that function is the keystone to the requirements that make VBXs usable
in the UIB. If an end user found out about the function, the end user could
try to set the mode at innapropriate times. And since this
.p file is run persistent, and Progress provides tools to see which
stuff is persistent, the user could find out about how to set design
mode.


Date Created:  1995
Date Modified:  

---------------------------------------------------------------------------- */

/*
 * This capability does not exist outside of MS-WINDOWS
 */
 
{adecomm/_adetool.i} /* flag this as an ADE tool procedure */
{adeshar/cntrapi.i}

/*
 * GetControlsOfLib
 *
 *    Gets the controls from a given library. It will be
 *    returned in a chr(10) separated list.
 */
 
procedure GetControlsOfLib.
define input  parameter fullDllName as character no-undo.
define output parameter controlList as character no-undo.
define output parameter s           as integer   no-undo initial 0.

    define variable dllName   as character no-undo.
    define variable dllPath   as character no-undo.
    define variable i         as integer   no-undo.
    define variable temp      as character no-undo.
    define variable lookAhead as character no-undo initial "":U.

    /* Should be converted to test for platfrom support of VBX or OCX.
       -jep 01/30/96 */
    IF OPSYS <> "MSDOS" THEN RETURN.

    /*
     * The DLL only returns the name of the file. Make sure that
     * we have removed the path from the filename.
     */
         
    run adecomm/_osprefx.p(fullDllName, output dllPath, output dllName).
    run ControlRegisterLibrary(dllName, output s).

    /*
     * Some of the errors aren't so fatal, so ignore.
     */
       
    if not ((s = 0) or (s = 1)) then return.

    run ControlGetNames(output temp, output s).
    
    if s <> 0 then return.
    
    /*
     * The VBX system returns all registered controls, regradless
     * of the library. Remove any controls that don't belong
     * to fullDllName.
     */
           
    do i = 1 to (num-entries(temp, chr(10))) by 2:
    
        if entry(i + 1, temp, chr(10)) = dllName then do:
            assign
                controlList = controlList + lookAhead + entry(i, temp, chr(10))
                lookAhead   = chr(10).
        end.    
    end.
end procedure.

/*
 * The following procedures perform the "atomic" operations that hide the
 * nitty details of getting stuff out of the DLL
 */

/*
 * ControlRegisterLibrary
 *
 *  Registers a control into the VBX world.
 *
 *  Returns 0 if all goes. Refer to cntrapi.i for list of error codes.
 */
  
procedure ControlRegisterLibrary.
define input  parameter libraryName as character no-undo.
define output parameter s           as integer   no-undo.

    /* Should be converted to test for platfrom support of VBX or OCX.
       -jep 01/30/96 */
    IF OPSYS <> "MSDOS" THEN RETURN.

    run CntrRegisterLib(libraryName, output s).
end procedure.

/*
 * ControlUnRegisterLibrary
 *
 *  UnRegisters a control into the VBX world.
 *
 *  Returns 0 if all goes. Refer to cntrapi.i for list of error codes.
 */
  
procedure ControlUnRegisterLibrary.
define input  parameter libraryName as character no-undo.
define output parameter s           as integer   no-undo.

    /* Should be converted to test for platfrom support of VBX or OCX.
       -jep 01/30/96 */
    IF OPSYS <> "MSDOS" THEN RETURN.

    run CntrUnRegisterLib(libraryName, output s).

end procedure. 

/*
 * ControlGetNames
 *
 *  Gets the list of controls that are currently registered.
 *  The list is a <LF> separated list of control<LF>dll-name pairs
 *
 *  Returns 0 if all goes. Refer to cntrapi.i for list of error codes.
 */
  
procedure ControlGetNames.
define output parameter controlList as character no-undo.
define output parameter s           as integer   no-undo.

    /* Should be converted to test for platfrom support of VBX or OCX.
       -jep 01/30/96 */
    IF OPSYS <> "MSDOS" THEN RETURN.

    define variable theList as memptr no-undo.

    set-size(theList) = {&BlockSize}.   
    run CntrGetControlNames(theList, {&BlockSize}, output s). 
    
    /*
     * Transfer the information into PROGRESS "safe" variable.
     */
     
    controlList = get-string(theList, 1).
    
    /*
     * Free up the space
     */
    set-size(theList) = 0.

end procedure.

/*
 * ControlGetProperties
 *
 *    Given a container/control, return the property list
 *    and types. The format of the list is
 *
 *       "propName <LF> type <LF> propName <LF> type ..."
 */

procedure ControlGetProperties.
define input  parameter h            as widget    no-undo.
define output parameter propertyList as character no-undo.
define output parameter s            as integer   no-undo.

    /* Should be converted to test for platfrom support of VBX or OCX.
       -jep 01/30/96 */
    IF OPSYS <> "MSDOS" THEN RETURN.

    define variable theList as memptr no-undo.
            
    set-size(theList) = {&BlockSize}.   
    run CntrGetPropertyList(h:HWND, theList, {&BlockSize}, output s). 
    
    /*
     * Transfer the information into PROGRESS "safe" variable.
     */
     
    propertyList = get-string(theList, 1).
    
    /*
     * Free up the space
     */
    set-size(theList) = 0.

end procedure.

/*
 * ControlGetEvents
 *
 *    Given a container/control, return the event list
 *    and types. The format of the list is
 *
 *       "eventName <LF> eventName ..."
 */

procedure ControlGetEvents.
define input  parameter h         as widget    no-undo.
define output parameter eventList as character no-undo.
define output parameter s         as integer   no-undo.

    /* Should be converted to test for platfrom support of VBX or OCX.
       -jep 01/30/96 */
    IF OPSYS <> "MSDOS" THEN RETURN.

    define variable theList as memptr no-undo.
            
    set-size(theList) = {&BlockSize}.   
    run CntrGetEventList(h:HWND, theList, {&BlockSize}, output s). 
    
    /*
     * Transfer the information into PROGRESS "safe" variable.
     */
     
    eventList = get-string(theList, 1).
    
    /*
     * Free up the space
     */
    set-size(theList) = 0.
    
end procedure.

/*
 * ControlGetEventInfo
 *
 *    Gets the parameters of an event in the form
 *
 *       "name <LF> type ..."
 */

procedure ControlGetEventInfo.
define input  parameter h        as widget    no-undo.
define input  parameter event	 as character no-undo.
define output parameter infoList as character no-undo.
define output parameter s        as integer   no-undo.

    /* Should be converted to test for platfrom support of VBX or OCX.
       -jep 01/30/96 */
    IF OPSYS <> "MSDOS" THEN RETURN.

    define variable theList as memptr no-undo.

    set-size(theList) = {&BlockSize}.   
    run CntrGetEventInfo(h:HWND, event,
                                 theList,
                                 {&BlockSize},
                                 output s). 
    
    /*
     * Transfer the information into PROGRESS "safe" variable.
     */
     
    infoList = get-string(theList, 1).
    
    /*
     * Free up the space
     */
    set-size(theList) = 0.
    
end procedure.

/*
 * ControlSaveControl
 *
 *    Serializes the VBX control into the named file
 *
 */

procedure ControlSaveControl.
define input  parameter h        as widget    no-undo.
define input  parameter fileName as character no-undo.
define output parameter s        as integer   no-undo initial -1.

  /* Should be converted to test for platfrom support of VBX or OCX.
     -jep 01/30/96 */
  IF OPSYS <> "MSDOS" THEN RETURN.

  if not valid-handle(h) then return.
  if fileName = ? or length(fileName) = 0 then return.

  assign s = 0. 
  run CntrSaveControl(h:HWND, fileName, output s). 
        
end procedure.


/*
 * ControlSaveControlKeepState
 *
 *    Serializes the VBX control into the named file, but
 *    keeps the state of the dirty bit
 *
 */

procedure ControlSaveControlKeepState.
define input  parameter h        as widget    no-undo.
define input  parameter fileName as character no-undo.
define output parameter s        as integer   no-undo initial -1.

  /* Should be converted to test for platfrom support of VBX or OCX.
     -jep 01/30/96 */
  IF OPSYS <> "MSDOS" THEN RETURN.

  if not valid-handle(h) then return.
  if fileName = ? or length(fileName) = 0 then return.

  assign s = 0. 
  run CntrSaveControlKeepState(h:HWND, fileName, 1, output s). 
        
end procedure.


/*
 * ControlCopyControl
 *
 *   Copies the internal data structures of one control into
 *   another control
 *
 */

procedure ControlCopyControl.
define input  parameter sourceHandle as widget    no-undo.
define input  parameter destHandle   as widget    no-undo.
define input  parameter destName     as character no-undo.
define output parameter s            as integer   no-undo initial -1.

    /* Should be converted to test for platfrom support of VBX or OCX.
       -jep 01/30/96 */
    IF OPSYS <> "MSDOS" THEN RETURN.

    if not valid-handle(sourceHandle) then return.
    if not valid-handle(destHandle) then return.
    if destName = ? or length(destName) = 0 then return.

    assign s = 0. 
    run CntrCopyControl(sourceHandle:HWND, 
                        destHandle:HWND,
                        destName,
                        output s). 
        
end procedure.

/*
 * ControlCreatePropertySheet
 *
 *   Creates a property sheet
 *
 */

procedure ControlCreatePropertySheet.
define input  parameter parentHandle as widget  no-undo.
define input  parameter nLeft        as integer no-undo.
define input  parameter nTop         as integer no-undo.
define input  parameter nWidth       as integer no-undo.
define input  parameter nHeight      as integer no-undo.
define output parameter s            as integer no-undo initial -1.

    /* Should be converted to test for platfrom support of VBX or OCX.
       -jep 01/30/96 */
    IF OPSYS <> "MSDOS" THEN RETURN.
    if not valid-handle(parentHandle) then return.

    assign s = 0. 
    run CntrCreatePropSheet(parentHandle:HWND, 
                            nLeft,
                            nTop,
                            nWidth,
                            nHeight,
                            output s). 
        
end.

/*
 * ControlSetPropertySheet
 *
 *   Edits the VBX attributes of the VBX attached
 *   to the control-container widget.
 *
 */

procedure ControlSetPropertySheet.
define input  parameter h as widget  no-undo.
define output parameter s as integer no-undo initial -1.

    /* Should be converted to test for platfrom support of VBX or OCX.
       -jep 01/30/96 */
    IF OPSYS <> "MSDOS" THEN RETURN.

    if not valid-handle(h) then return.

    assign s = 0. 
    run CntrSetPropSheet(h:HWND, output s). 

end procedure.

/*
 * ControlSetPropertySheet
 *
 *   Edits the VBX attributes of the VBX attached
 *   to the control-container widget.
 *
 */

procedure ControlUnsetPropertySheet.
define output parameter s as integer no-undo initial -1.
 
    /* Should be converted to test for platfrom support of VBX or OCX.
       -jep 01/30/96 */
    IF OPSYS <> "MSDOS" THEN RETURN.

    run CntrSetPropSheet(0, output s). 
        
end procedure.

/*
 * ControlDestroyPropertySheet
 *
 *   Destroys the property sheet.
 *
 */

procedure ControlDestroyPropertySheet.
define output parameter s as integer no-undo initial -1.

 
    /* Should be converted to test for platfrom support of VBX or OCX.
       -jep 01/30/96 */
    IF OPSYS <> "MSDOS" THEN RETURN.

    run CntrDestroyPropSheet(output s). 
        
end procedure.

/*
 * ControlGetPaletteBitmap
 *
 *   Dumps the palette icon into the named file
 */

procedure ControlGetPaletteBitmap.
define input  parameter vbxType as character no-undo.
define input  parameter bmpName as character no-undo.
define output parameter s       as integer   no-undo.

    /* Should be converted to test for platfrom support of VBX or OCX.
       -jep 01/30/96 */
    IF OPSYS <> "MSDOS" THEN RETURN.

    run CntrGetPaletteBitmap(vbxType,
                             bmpName,
                             output s). 
        
end procedure. 

/*
 * ControlGetDesignMode
 *
 *   Get the design mode state.
 *   1 for DESIGN, 0 for RUN
 */
procedure ControlGetDesignMode.
define output parameter dMode as integer no-undo initial 0.
define output parameter s     as integer no-undo.

define variable theList as memptr    no-undo.
define variable mode    as character no-undo.

    /* Should be converted to test for platfrom support of VBX or OCX.
       -jep 01/30/96 */
    IF OPSYS <> "MSDOS" THEN RETURN.

    assign set-size(theList) = {&BlockSize}.
    run CntrGetMode(output theList, output s).     
    
    /*
     * Transfer the information into PROGRESS "safe" variable.
     */
    assign mode = get-string(theList, 1).
    
    if mode = "D" then assign dMode = 1.	
    
    /*
     * Free up the space
     */
    assign set-size(theList) = 0.
    
end procedure. 


/*
 * ControlIsInvisibleAtRuntime
 *
 *    Given a container/control, return the if the VBX control
 *    is designed to be invisible at runtime
 */

procedure ControlIsInvisibleAtRuntime.
define input  parameter h           as widget  no-undo.
define output parameter isInvisible as logical no-undo initial false.
define output parameter s           as integer no-undo initial -1.

define variable theBool  as memptr  no-undo.
define variable bVisible as integer no-undo.
    

    /* Should be converted to test for platfrom support of VBX or OCX.
       -jep 01/30/96 */
    IF OPSYS <> "MSDOS" THEN RETURN.

    if not valid-handle(h) then return.
    
    assign
        s = 0        
        set-size(theBool) = 2
    .   
    run CntrIsInvisibleAtRuntime(h:HWND, theBool, output s). 
    
    if s <> 0 then return.
    
    /*
     * Transfer the information into PROGRESS "safe" variable.
     */
     
    bVisible = get-short(theBool, 1).
    
    if bVisible = 1 then isInvisible = true.
    /*
     * Free up the space
     */
    set-size(theBool) = 0.
    
end procedure.

/*
 * ControlIsControlChanged
 *
 *    Given a container/control, return the if the VBX control
 *    is dirty
 */

procedure ControlIsControlChanged.
define input  parameter h         as widget  no-undo.
define output parameter isChanged as logical no-undo initial false.
define output parameter s         as integer no-undo initial -1.

define variable theBool  as memptr  no-undo.
define variable bChanged as integer no-undo.
    

    /* Should be converted to test for platfrom support of VBX or OCX.
       -jep 01/30/96 */
    IF OPSYS <> "MSDOS" THEN RETURN.

    if not valid-handle(h) then return.
    
    assign
        s = 0        
        set-size(theBool) = 2
    .   
    run CntrIsControlChanged(h:HWND, theBool, output s). 
    
    if s <> 0 then return.
    
    /*
     * Transfer the information into PROGRESS "safe" variable.
     */
     
    bChanged = get-short(theBool, 1).
    
    if bChanged = 1 then isChanged = true.
    /*
     * Free up the space
     */
    set-size(theBool) = 0.
    
end procedure.

/*
 * ControlIsPropSheetUP
 *
 *   Is the property sheet visible
 */

procedure ControlIsPropSheetUp.
define output parameter isUp as logical no-undo initial false.
define output parameter s    as integer no-undo initial -1.

define variable theBool  as memptr  no-undo.
define variable bVisible as integer no-undo.
        

    /* Should be converted to test for platfrom support of VBX or OCX.
       -jep 01/30/96 */
    IF OPSYS <> "MSDOS" THEN RETURN.

    assign
        s = 0        
        set-size(theBool) = 2
    .   
    run CntrIsPropSheetUp(theBool, output s). 
    
    if s <> 0 then return.
    
    /*
     * Transfer the information into PROGRESS "safe" variable.
     */
     
    bVisible = get-short(theBool, 1).
    
    if bVisible = 1 then isUp = true.
    /*
     * Free up the space
     */
    set-size(theBool) = 0.
    
end procedure.
