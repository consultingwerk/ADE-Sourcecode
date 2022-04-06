/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
&if '{&OPSYS}' ne 'Unix' &then
/* =================================================================
   file    : file-api.p
   purpose : some procedures for returning file/dir information
   by      : Jurjen Dijkstra, 1997
             email jurjend@pi.net
             from  http://home.pi.net/~jurjend
   ================================================================= */



/* ================================================================= */
/*               STANDARD WINDOWS DEFINITIONS                        */
/* ================================================================= */

{af/sup/windows.i}
{af/sup/proextra.i}

/* ================================================================= */
/*                 additions to windows.i                            */
/* ================================================================= */


&IF "{&OPSYS}":U="WIN32":U &THEN
   /* 32-bit definitions, Progress 8.2+ */

   &GLOB  MAX_PATH 260
   &GLOB  FIND_DATA-SIZE 4           /* dwFileAttributes       */~
                       + 8           /* ftCreationTime         */~
                       + 8           /* ftLastAccessTime       */~
                       + 8           /* ftLastWriteTime        */~
                       + 4           /* nFileSizeHigh          */~
                       + 4           /* nFileSizeLow           */~
                       + 4           /* dwReserved0            */~
                       + 4           /* dwReserved1            */~
                       + {&MAX_PATH} /* cFileName[MAX_PATH]    */~
                       + 14          /* cAlternateFileName[14] */
&ELSE
   &MESSAGE "Don't know 16-bit definitions for MAX_PATH and FIND_DATA structure"
&ENDIF

&GLOB INVALID_HANDLE_VALUE -1


/* ================================================================= */
/*                 additions to windows.p                            */
/* ================================================================= */


procedure FindFirstFile{&A} external {&KERNEL} :
    define input parameter  lpFileName as char.
    define input parameter  lpFindFileData as memptr.
    define return parameter hSearch as {&INT}.
end procedure.    

procedure FindNextFile{&A} external {&KERNEL} :
    define input parameter  hSearch as {&INT}.
    define input parameter  lpFindFileData as memptr.
    define return parameter found as {&BOOL}.
end procedure.

procedure FindClose external {&kernel} :
    define input parameter hSearch as {&INT}.
end procedure.

procedure FileTimeToLocalFileTime external {&KERNEL} :
  define input parameter lpFileTime as long.  /* pointer */
  define input parameter lpLocalFileTime as long. /* pointer */
end procedure.

procedure FileTimeToDosDateTime external {&KERNEL} :
  define input parameter  lpFileTime as long. /* pointer */
  define output parameter FatDate as short.   /* word */
  define output parameter FatTime as short.   /* word */
end procedure.


/* ================================================================= */
/*                  'high level' procedures                          */
/* ================================================================= */


/* -----------------------------------------------------------------
   procedure FileFind
   purpose   want to know information about one particular file?
             1. call FileFind to obtain a lpFindData structure
             2. call one or more of the FileInfo_xxx procedures
                to get information from the lpFindData structure
   ----------------------------------------------------------------- */

procedure FileFind :
   def input  parameter FileName   as char.
   def output parameter lpFindData as memptr.

   set-size(lpFindData) = {&FIND_DATA-SIZE}.
   def var hSearch as integer.

   run FindFirstFile{&A} (FileName, lpFindData, output hSearch).
   if hSearch<>{&INVALID_HANDLE_VALUE} then
      run FindClose (hSearch).
   else
      set-size(lpFindData)=0.
end procedure.

/* -----------------------------------------------------------------
   procedure FileFindLoop
   purpose   want to scan a directory using wildcards?
             call FileFindLoop; for each found file it will run
             value(ipProcessFindData) in hExtProc. That callback-
             procedure can use the lpFindData structure to decide
             what to do next.
   ----------------------------------------------------------------- */

procedure FileFindLoop :
   def input parameter FileMask          as char.
   def input parameter ipProcessFindData as char.
   def input parameter hExtProc          as handle.

   def var lpFindData as memptr no-undo.
   def var hSearch as integer no-undo.
   def var found as integer no-undo initial 1.

   set-size(lpFindData) = {&FIND_DATA-SIZE}.

   run FindFirstFile{&A} (FileMask, lpFindData, output hSearch).
   if hSearch<>{&INVALID_HANDLE_VALUE} then do:
     do while found<>0 :
        run value(ipProcessFindData) in hExtProc (lpFindData).
        run FindNextFile{&A} (hSearch, lpFindData, output found).
     end.
     run FindClose (hSearch).
   end.

end procedure.


/* ================================================================= */
/* procedures for returning info from the  lpFindData structure:     */
/* ================================================================= */

/* -----------------------------------------------------------------
   procedure FileInfo_Size
   purpose   returns size in bytes of a file.
   ----------------------------------------------------------------- */

procedure FileInfo_Size :
   def input parameter  lpFindData as memptr.
   def output parameter FileSize as integer initial -1.

   if get-size(lpFindData)={&FIND_DATA-SIZE} then
      FileSize = get-long(lpFindData, 33). /* =nFileSizeLow */
end procedure.

/* -----------------------------------------------------------------
   procedure FileInfo_LongName
   purpose   returns long filename
   ----------------------------------------------------------------- */

procedure FileInfo_LongName :
   def input parameter  lpFindData as memptr.
   def output parameter FileName   as char initial "".

   if get-size(lpFindData)={&FIND_DATA-SIZE} then
      FileName = get-string(lpFindData, 45). /* =cFileName */
end procedure.

/* -----------------------------------------------------------------
   procedure FileInfo_ShortName
   purpose   returns short filename. If the Long name is already short,
             ShortName would be empty. But this procedure returns
             LongName if ShortName is empty.
   ----------------------------------------------------------------- */

procedure FileInfo_ShortName :
   def input parameter  lpFindData as memptr.
   def output parameter FileName   as char initial "".

   if get-size(lpFindData)={&FIND_DATA-SIZE} then do:
      FileName = get-string(lpFindData, 45 + {&MAX_PATH}). /* =cAlternateFileName */
      if FileName="" then
         FileName = get-string(lpFindData, 45). /* =cFileName */
   end.
end procedure.

/* -----------------------------------------------------------------
   procedure FileInfo_LastAccess
   purpose   returns date and time when file was last accessed.
             Time can be displayed using string(chTime,"hh:mm").
   ----------------------------------------------------------------- */

procedure FileInfo_LastAccess :
   def input parameter  lpFindData as memptr.
   def output parameter chDate as date.
   def output parameter chTime as integer.

   if get-size(lpFindData)={&FIND_DATA-SIZE} then
   run FileTimeToProgressDateTime(get-pointer-value(lpFindData) + 12, 
                                  output chDate, 
                                  output chTime).

end procedure.

/* -----------------------------------------------------------------
   procedure FileInfo_LastWrite
   purpose   returns date and time when file was last changed.
             Time can be displayed using string(chTime,"hh:mm").
   ----------------------------------------------------------------- */

procedure FileInfo_LastWrite :
   def input parameter  lpFindData as memptr.
   def output parameter chDate as date.
   def output parameter chTime as integer.

   if get-size(lpFindData)={&FIND_DATA-SIZE} then
   run FileTimeToProgressDateTime(get-pointer-value(lpFindData) + 20, 
                                  output chDate, 
                                  output chTime).

end procedure.

/* ================================================================= */
/* private functions, not designed to be called from outside this .p */
/* ================================================================= */

procedure FileTimeToProgressDateTime :

   def input parameter  lpUTC  as integer.
   def output parameter chDate as date.
   def output parameter chTime as integer.

   def var lpLocal   as memptr.
   set-size(lpLocal) = 8.

   def var FatDate as integer.
   def var FatTime as integer.
   run FileTimeToLocalFileTime(lpUTC, get-pointer-value(lpLocal)).
   run FileTimeToDosDateTime(get-pointer-value(lpLocal), 
                             output FatDate, 
                             output FatTime).
   set-size(lpLocal) = 0.

   /* crack FatDate: */
   def var day as integer.
   def var month as integer.
   def var year as integer.
   run Bit_And in hpExtra (FatDate,    31, output day).
   run Bit_And in hpExtra (FatDate,   480, output month).
   run Bit_And in hpExtra (FatDate, 65024, output year).
   month  = month / 32.  /* shr 5 */
   year   = year  / 512 + 1980.
   chDate = date(month,day,year).

   /* crack FatTime: */
   def var hours as integer.
   def var minutes as integer.
   def var seconds as integer.
   run Bit_And in hpExtra (FatTime,    31, output seconds).
   run Bit_And in hpExtra (FatTime,  2016, output minutes).
   run Bit_And in hpExtra (FatTime, 63488, output hours).
   minutes = minutes / 32.
   hours   = hours   / 2048.
   chTime  = seconds * 2 + 60 * (minutes + 60 * hours).

end procedure.
&endif    /* OPSYS <> UNIX */
/* end-of-file */

