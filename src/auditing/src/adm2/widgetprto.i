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

FUNCTION assignFocusedWidget RETURNS LOGICAL
  ( INPUT pcName AS CHARACTER ) 
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION assignWidgetValue RETURNS LOGICAL
  ( INPUT pcName  AS CHARACTER,
    INPUT pcValue AS CHARACTER ) 
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION assignWidgetValueList RETURNS LOGICAL
  ( INPUT pcNameList  AS CHARACTER,
    INPUT pcValueList AS CHARACTER,
    INPUT pcDelimiter AS CHARACTER ) 
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION blankWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER )  
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION clearWidget RETURNS LOGICAL
    ( INPUT pcNameList AS CHARACTER )
    &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
    &ELSE IN SUPER.
    &ENDIF

FUNCTION disableRadioButton RETURNS LOGICAL
  ( INPUT pcNameList  AS CHARACTER,
    INPUT piButtonNum AS INTEGER ) 
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION disableWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER )
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION enableRadioButton RETURNS LOGICAL
  ( INPUT pcNameList  AS CHARACTER,
    INPUT piButtonNum AS INTEGER ) 
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION enableWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER )
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION formattedWidgetValue RETURNS CHARACTER
  ( INPUT pcName AS CHARACTER ) 
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION formattedWidgetValueList RETURNS CHARACTER
  ( INPUT pcNameList  AS CHARACTER,
    INPUT pcDelimiter AS CHARACTER) 
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION hideWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER ) 
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION highlightWidget RETURNS LOGICAL
  ( INPUT pcNameList      AS CHARACTER, 
    INPUT pcHighlightType AS CHARACTER )
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION resetWidgetValue RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER )
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION toggleWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER )
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION viewWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER )
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION widgetHandle RETURNS HANDLE
  ( INPUT pcName AS CHARACTER ) 
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION widgetLongcharValue RETURNS LONGCHAR
  (INPUT pcName AS CHARACTER ) 
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION widgetIsBlank RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER ) 
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION widgetIsFocused RETURNS LOGICAL
  ( INPUT pcName AS CHARACTER ) 
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION widgetIsModified RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER ) 
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION widgetIsTrue RETURNS LOGICAL
  ( INPUT pcName AS CHARACTER ) 
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION widgetValue RETURNS CHARACTER
  (INPUT pcName AS CHARACTER ) 
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF

FUNCTION widgetValueList RETURNS CHARACTER
  (INPUT pcNameList  AS CHARACTER,
   INPUT pcDelimiter AS CHARACTER ) 
  &IF DEFINED(CustomSuper) &THEN IN TARGET-PROCEDURE.
  &ELSE IN SUPER.
  &ENDIF
