/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* ===========================================================================
   file    : WINFUNC.I
   by      : Jurjen Dijkstra, 1997
             mailto:jurjen.dijkstra@wxs.nl
             http://www.pugcentral.org/api
   purpose : Forward declarations for functions that call API procedures.
             This include file is included in windows.i
   =========================================================================== */

/* prevent multiple inclusion: */
&IF DEFINED(WINFUNC_I)=0 &THEN
&GLOBAL-DEFINE WINFUNC_I

/* start persistent procedure holding the function implementations.
   The forward declarations are needed in winfunc.p, but the
   "run winfunc.p persistent" part must be prevented in winfunc.p : */

DEFINE NEW GLOBAL SHARED VARIABLE hpWinFunc2 AS HANDLE NO-UNDO.
&IF DEFINED(DONTRUN-WINFUNC)=0 &THEN
  IF NOT VALID-HANDLE(hpWinFunc2) THEN RUN af/sup/Winfunc.p PERSISTENT SET hpWinFunc2.
&ELSE
  hpWinFunc2 = this-procedure:handle.
&ENDIF

/* --- the forward declarations : --- */

FUNCTION GetLastError      /* 1:1 implementation of API */
         RETURNS INTEGER   /* = dwErrorID */
         () 
         IN hpWinFunc2.    

FUNCTION GetParent         /* 1:1 implementation of API */
         RETURNS INTEGER   /* = hWnd van parent */
         (input hwnd as INTEGER) 
         IN hpWinFunc2.    

FUNCTION ShowLastError     /* calls GetLastError and views it as alert-box */
         RETURNS INTEGER   /* = dwErrorID */
         () 
         IN hpWinFunc2.    

FUNCTION CreateProcess     /* wrapper for the big API definition */
         RETURNS INTEGER   /* = if success then hProcess else 0  */
         (input CommandLine as CHAR,
          input CurrentDir  as CHAR,
          input wShowWindow as INTEGER) 
         in hpWinFunc2.    

&ENDIF  /* &IF DEFINED(WINFUNC_I)=0 */
