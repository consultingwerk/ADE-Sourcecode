/* Copyright © 2006-2011 OE Hive and contributors. 
   All project and contributed content is copyright by its respective owners. 
   All rights reserved.
*/
/*------------------------------------------------------------------------
    File        : _getshortpathname.p
    Purpose     : Return win32 short path name

    Syntax      :

    Description : 

    Author(s)   : From www.oehive.org. jurjen 
    Created     : Fri Jul 15 16:11:22 EDT 2011
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

/* ***************************  Definitions  ************************** */

define input  parameter pLongName  as character no-undo. 
define output parameter pShortName as character no-undo.
 
procedure GetShortPathNameA external "kernel32.dll" :
  define input  parameter  lpszLongPath  as character.
  define output parameter  lpszShortPath as character.
  define input  parameter  cchBuffer     as LONG.
  define return parameter  ReturnValue   as LONG.
end procedure.
 
define variable iReturnValue as integer no-undo.
define variable iShortsize as integer init 256 no-undo. 
 
pShortName = fill("-", 256).
 
run GetShortPathNameA (plongname,
                       output pShortName,
                       length(pShortName),
                       output iReturnValue).
 
if iReturnValue > iShortsize then 
    undo, throw new Progress.Lang.AppError("Buffer too short to handle " + string(iReturnValue),?).
else 
if iReturnValue = 0 then 
    undo, throw new Progress.Lang.AppError("File  " + pLongName + " was not found.",?).
else 
/*   shortname = ENTRY(1, shortname, CHR(0)).*/
    pShortname = substring(pShortname, 1, iReturnvalue).
   
   