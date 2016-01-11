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
    '<SCRIPT LANGUAGE="JavaScript">~n'
    'function mask(InString, Mask) ~{~n'
    '  LenStr = InString.length~; ~n'
    '  LenMsk = Mask.length~; ~n'
    '  if ((LenStr == 0) || (LenMsk == 0))~n'
    '    return(0)~;~n'
    '  if (LenStr > LenMsk)~n'
    '    return(0)~;~n'
    '  TempString = ""~;~n'
    '  for (Count = 0~; Count <= InString.length~; Count++)  ~{ ~n'
    '    StrChar = InString.substring(Count, Count+1)~; ~n'
    '    MskChar = Mask.substring(Count, Count+1)~; ~n'
    '    if (MskChar == "9") ~{ ~n'
    '      if(!isNumberChar(StrChar)) ~n'
    '        return(0)~; ~n'
    '      } ~n'
    '      else if ((MskChar == "A") || (MskChar == "a")) ~{ ~n'
    '        if(!isAlphabeticChar(StrChar)) ~n'
    '          return(0)~; ~n'
    '      } ~n'
    '      else if ((MskChar == "N") || (MskChar == "n"))~{ ~n'
    '        if(!isNumOrChar(StrChar)) ~n'
    '          return(0)~; ~n'
    '      } ~n'
    '      else if ((MskChar == "X") || (MskChar == "x")) ~{ ~n'
    '    } ~n'
    '    else ~{ ~n'
    '      if (MskChar != StrChar)  ~n'
    '        return(0)~; ~n'
    '    } ~n'
    '  } ~n'
    '  for (~; Count <= InString.length~; Count++) ~{ ~n'
    '    MskChar = Mask.substring(Count, Count+1)~; ~n'
    '    if ((MskChar == "X") || (MskChar == "x")) ~{ ~n'
    '      // do nothing.  we can ignore checking if MskChar == x ~n'
    '    } ~n'
    '    else  ~n'
    '      return(0)~; ~n'
    '  } ~n'
    '  return (1)~; ~n'
    '} ~n'.
    
  PUT STREAM webStream UNFORMATTED 
    'function isAlphabeticChar (InString) ~{ ~n'
    '  if(InString.length != 1) ~n'
    '    return (false)~; ~n'
    '  InString  = InString.toLowerCase () ~n'
    '  RefString = "abcdefghijklmnopqrstuvwxyz"~; ~n'
    '  if (RefString.indexOf(InString, 0) == -1) ~n'
    '    return (false)~; ~n'
    '  return (true)~; ~n'
    '} ~n'
    'function isNumberChar (InString) ~{ ~n'
    '  if(InString.length != 1)  ~n'
    '    return (false)~; ~n'
    '  RefString = "1234567890"~; ~n'
    '  if (RefString.indexOf(InString, 0) == -1)  ~n'
    '    return (false)~; ~n'
    '  return (true)~; ~n'
    '} ~n'
    ' ~n'
    'function isNumOrChar (InString) ~{ ~n'
    '  if(InString.length != 1)  ~n'
    '    return (false)~; ~n'
    '  InString  = InString.toLowerCase()~; ~n'
    '  RefString = "1234567890abcdefghijklmnopqrstuvwxyz"~; ~n'
    '  if (RefString.indexOf(InString, 0) == -1)   ~n'
    '    return (false)~; ~n'
    '  return (true)~; ~n'
    '} ~n'
    ' ~n'.
    
  PUT STREAM webStream UNFORMATTED 
    'function expandFormat (InFormat) ~{ ~n'
    '  OutFormat = ""~; ~n'
    '  if(InFormat.length < 1)  ~n'
    '    return (OutFormat)~; ~n'
    '  InFormat  = InFormat.toLowerCase()~; ~n'
    '  RefString = "9anx"~; /* valid format characters */ ~n'
    '  FirstChar = InFormat.charAt(0)~; ~n'
    '  if (RefString.indexOf(FirstChar) == -1) ~{ /* not a format character */ ~n'
    '    return InFormat~; ~n'
    '  } ~n'
    '  /* now check if second is ~'(~' and if there is a ~')~' */ ~n'
    '  StartPos = InFormat.indexOf(~'(~')~; ~n'
    '  StopPos  = InFormat.indexOf(~')~')~; ~n'
    '  if ((StartPos == 1) && (StopPos > 2)) ~{ ~n'
    '    RepeatCount = parseInt(InFormat.substring(StartPos + 1, StopPos))~; ~n'
    '    if (RepeatCount > 256) ~n'
    '      RepeatCount = 256~; ~n'
    '	 while (RepeatCount > 0) ~{ ~n'
    '	   OutFormat = OutFormat + FirstChar~; ~n'
    '	   RepeatCount--~; ~n'
    '	 } ~n'
    '  } ~n'
    '  else ~n'
    '    return InFormat~; ~n'
    '  return OutFormat~; ~n'
    '} ~n'
    ' ~n'
    'function WSTextVerify(field, field_format) ~{ ~n'
    '  // a null string is OK, we do not do mandatory field checking (yet) ~n'
    '  if (field.value == null || field.value == "" || field.value == "<undefined>") ~n'
    '    return~; ~n'
    '  picture = expandFormat(field_format)~; ~n'
    '  if (mask(field.value, picture) == 0) ~{ ~n'
    '    alert(field.value + " does not match pattern for field " + field.name + "::" + picture)~; ~n'
    '    field.focus()~; ~n'
    '  } ~n'
    '} ~n'
    '</SCRIPT> ~n'.
END PROCEDURE. /* web.output*/

/* wsverify.p - end of file */
