/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------
  wsverify.p 
  
  Author: Tim Bemis - 1/20/97

  Description:  The purpose of this procedure is output some JavaScript 
                functions which will perform some level of TEXT field 
                input format masking, that is modeled on the way the 
                PROGRESS 4gl does it.
--------------------------------------------------------------------*/

&SCOPED-DEFINE NEWLINE CHR(10)
&SCOPED-DEFINE TAB CHR(9)

DEFINE SHARED STREAM   webStream.
DEFINE SHARED VARIABLE web-utilities-hdl AS HANDLE NO-UNDO.

PROCEDURE web.output:
  DEFINE INPUT PARAMETER hWid      AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER fieldDef  AS CHARACTER  NO-UNDO.

  IF INDEX(fieldDef,"<!--WSVERIFY":U) = 0 THEN /* some error, get out! */
	RETURN.

  PUT STREAM webStream UNFORMATTED 
    '<SCRIPT LANGUAGE="JavaScript">~n':U
    'function mask(InString, Mask) ~{~n':U
    '  LenStr = InString.length~; ~n':U
    '  LenMsk = Mask.length~; ~n':U
    '  if ((LenStr == 0) || (LenMsk == 0))~n':U
    '    return(0)~;~n':U
    '  if (LenStr > LenMsk)~n':U
    '    return(0)~;~n':U
    '  TempString = ""~;~n':U
    '  for (Count = 0~; Count <= InString.length~; Count++)  ~{ ~n':U
    '    StrChar = InString.substring(Count, Count+1)~; ~n':U
    '    MskChar = Mask.substring(Count, Count+1)~; ~n':U
    '    if (MskChar == "9") ~{ ~n':U
    '      if(!isNumberChar(StrChar)) ~n':U
    '        return(0)~; ~n':U
    '      } ~n':U
    '      else if ((MskChar == "A") || (MskChar == "a")) ~{ ~n':U
    '        if(!isAlphabeticChar(StrChar)) ~n':U
    '          return(0)~; ~n':U
    '      } ~n':U
    '      else if ((MskChar == "N") || (MskChar == "n"))~{ ~n':U
    '        if(!isNumOrChar(StrChar)) ~n':U
    '          return(0)~; ~n':U
    '      } ~n':U
    '      else if ((MskChar == "X") || (MskChar == "x")) ~{ ~n':U
    '    } ~n':U
    '    else ~{ ~n':U
    '      if (MskChar != StrChar)  ~n':U
    '        return(0)~; ~n':U
    '    } ~n':U
    '  } ~n':U
    '  for (~; Count <= InString.length~; Count++) ~{ ~n':U
    '    MskChar = Mask.substring(Count, Count+1)~; ~n':U
    '    if ((MskChar == "X") || (MskChar == "x")) ~{ ~n':U
    '      // do nothing.  we can ignore checking if MskChar == x ~n'
    '    } ~n':U
    '    else  ~n':U
    '      return(0)~; ~n':U
    '  } ~n':U
    '  return (1)~; ~n':U
    '} ~n':U.
    
  PUT STREAM webStream UNFORMATTED 
    'function isAlphabeticChar (InString) ~{ ~n':U
    '  if(InString.length != 1) ~n':U
    '    return (false)~; ~n':U
    '  InString  = InString.toLowerCase () ~n':U
    '  RefString = "abcdefghijklmnopqrstuvwxyz"~; ~n':U
    '  if (RefString.indexOf(InString, 0) == -1) ~n':U
    '    return (false)~; ~n':U
    '  return (true)~; ~n':U
    '} ~n':U
    'function isNumberChar (InString) ~{ ~n':U
    '  if(InString.length != 1)  ~n':U
    '    return (false)~; ~n':U
    '  RefString = "1234567890"~; ~n':U
    '  if (RefString.indexOf(InString, 0) == -1)  ~n':U
    '    return (false)~; ~n':U
    '  return (true)~; ~n':U
    '} ~n':U
    ' ~n':U
    'function isNumOrChar (InString) ~{ ~n':U
    '  if(InString.length != 1)  ~n':U
    '    return (false)~; ~n':U
    '  InString  = InString.toLowerCase()~; ~n':U
    '  RefString = "1234567890abcdefghijklmnopqrstuvwxyz"~; ~n':U
    '  if (RefString.indexOf(InString, 0) == -1)   ~n':U
    '    return (false)~; ~n':U
    '  return (true)~; ~n':U
    '} ~n':U
    ' ~n':U.
    
  PUT STREAM webStream UNFORMATTED 
    'function expandFormat (InFormat) ~{ ~n':U
    '  OutFormat = ""~; ~n':U
    '  if(InFormat.length < 1)  ~n':U
    '    return (OutFormat)~; ~n':U
    '  InFormat  = InFormat.toLowerCase()~; ~n':U
    '  RefString = "9anx"~; /* valid format characters */ ~n':U
    '  FirstChar = InFormat.charAt(0)~; ~n':U
    '  if (RefString.indexOf(FirstChar) == -1) ~{ /* not a format character */ ~n':U
    '    return InFormat~; ~n':U
    '  } ~n':U
    '  /* now check if second is ~'(~' and if there is a ~')~' */ ~n':U
    '  StartPos = InFormat.indexOf(~'(~')~; ~n':U
    '  StopPos  = InFormat.indexOf(~')~')~; ~n':U
    '  if ((StartPos == 1) && (StopPos > 2)) ~{ ~n':U
    '    RepeatCount = parseInt(InFormat.substring(StartPos + 1, StopPos))~; ~n':U
    '    if (RepeatCount > 256) ~n':U
    '      RepeatCount = 256~; ~n':U
    '	 while (RepeatCount > 0) ~{ ~n':U
    '	   OutFormat = OutFormat + FirstChar~; ~n':U
    '	   RepeatCount--~; ~n':U
    '	 } ~n':U
    '  } ~n':U
    '  else ~n':U
    '    return InFormat~; ~n':U
    '  return OutFormat~; ~n':U
    '} ~n':U
    ' ~n':U
    'function WSTextVerify(field, field_format) ~{ ~n':U
    '  // a null string is OK, we do not do mandatory field checking (yet) ~n':U
    '  if (field.value == null || field.value == "" || field.value == "<undefined>") ~n':U
    '    return~; ~n':U
    '  picture = expandFormat(field_format)~; ~n':U
    '  if (mask(field.value, picture) == 0) ~{ ~n':U
    '    alert(field.value + " does not match pattern for field " + field.name + "::" + picture)~; ~n':U
    '    field.focus()~; ~n':U
    '  } ~n':U
    '} ~n':U
    '</SCRIPT> ~n':U.
END PROCEDURE. /* web.output*/

/* wsverify.p - end of file */
