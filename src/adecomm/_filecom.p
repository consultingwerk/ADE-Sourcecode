/***********************************************************************
* Copyright (C) 2005-2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                    *
***********************************************************************/
/*----------------------------------------------------------------------------

File: adecomm/_filecom.p

Description:
   This is the file common dialog.  It will provide a common user
   interface for file open, and file save as.

Input/Output Parameters:
   
Author: Warren Bare

Date Created: 03/24/92 
     History:  D. McMann 04/12/00 Added long pathname support

----------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------
Modifications:
  01.25.93  John Palazzo
            Made entire dialog more like MS-Windows Common Get File.
----------------------------------------------------------------------------*/

define input parameter p_Filter as char no-undo.
define input parameter p_Dir as char  no-undo.
define input parameter p_Drive as char no-undo.
define input parameter p_Save_As as log init true no-undo. /* YES = save */
define input parameter p_Title as char no-undo. 
define input parameter p_Options as char no-undo.
define input-output parameter p_File as char.
define output parameter p_Return_Status as logical init no no-undo.

/* ADE Stanards Include */
{ adecomm/adestds.i }
IF NOT initialized_adestds
THEN RUN adecomm/_adeload.p.

/* Help Context */
{ adecomm/commeng.i }


&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
&GLOBAL List_Phrase    single sort size 30 by 8 scrollbar-v
&ELSE
&GLOBAL List_Phrase    single sort size 30 by 6 scrollbar-v
&ENDIF

define var v_PickDir  as char 
    view-as selection-list {&List_Phrase} .
define var v_PickFile as char 
    view-as selection-list {&List_Phrase} .

define var v_Type     as char no-undo.
define var v_InFile   as char no-undo.
define var v_InAttr   as char no-undo.
define var v_TmpDir   as char no-undo.
define var v_TmpFilt  as char no-undo.

define var Help_Context as integer no-undo.
define var File_Name  as char no-undo.
define var t_log      as log  no-undo.
define var Status_Line as char format "x(60)" no-undo.

define button b_ok     label "OK"
    {&STDPH_OKBTN} AUTO-GO.
define button b_cancel label "Cancel"
    {&STDPH_OKBTN} AUTO-ENDKEY.
define button b_help label "&Help"
    {&STDPH_OKBTN}.


/* Dialog Button Box */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE FC_Btn_Box    {&STDPH_OKBOX}.
&ENDIF

/* Dialog Box */    
FORM
    SKIP( {&TFM_WID}  )
  "File Name:" {&AT_OKBOX} VIEW-AS TEXT
    SKIP( {&VM_WID} )
  p_File {&AT_OKBOX}  FORMAT "x({&PATH_WIDG})"
    VIEW-AS FILL-IN SIZE 60 BY 1
    SKIP( {&VM_WIDG} )
  p_Dir {&AT_OKBOX} FORMAT "x({&PATH_WIDG})" NO-LABEL VIEW-AS FILL-IN SIZE 60 BY 1 
    SKIP( {&VM_WIDG} )
  "Files:" {&AT_OKBOX} VIEW-AS TEXT 
  "Directories:" at 33 VIEW-AS TEXT
    SKIP( {&VM_WID} )
  v_PickFile {&AT_OKBOX} v_PickDir
    { adecomm/okform.i
        &BOX    ="FC_Btn_Box"
        &OK     ="b_OK"
        &CANCEL ="b_Cancel"
        &HELP   ="b_Help"
    }
  Status_Line
  with frame filecomm no-label TITLE p_Title overlay
       view-as dialog-box
               DEFAULT-BUTTON b_OK
               CANCEL-BUTTON  b_Cancel.
    { adecomm/okrun.i
        &FRAME  = "FRAME filecomm"
        &BOX    = "FC_Btn_Box"
        &OK     = "b_OK"
        &CANCEL = "b_Cancel"
        &HELP   = "b_Help"
    }



/******************* Trigger Section *******************/
on help of frame filecomm anywhere
  RUN adecomm/_adehelp.p
      ( INPUT "comm" ,
        INPUT "CONTEXT" , INPUT Help_Context , INPUT ? ).

on choose of b_help in frame filecomm
  RUN adecomm/_adehelp.p
      ( INPUT "comm" ,
        INPUT "CONTEXT" , INPUT Help_Context , INPUT ? ).

on window-close of frame filecomm
   OR choose of b_cancel in frame filecomm
do:
  p_File = ?.
  p_Return_Status = NO.
end.

on return,enter of p_File in frame filecomm
do:
  apply "go" to frame filecomm.
  return no-apply.
end.

on go of frame filecomm 
do:
  def var Fullpath as char.
  def var ok_overwrite as logical.
  def var v_dirname as char.
  def var v_basename as char.
  def var cSubDir as char no-undo.
  def var cFile as char no-undo.
  def var cTmp as char no-undo.

  assign v_TmpDir  = p_Dir:SCREEN-VALUE in frame filecomm 
         v_TmpFilt = TRIM( p_File:SCREEN-VALUE in frame filecomm )
         File_Name = TRIM( p_File:SCREEN-VALUE in frame filecomm )
         .

  /* If we drop all the way through, then return status = true and we're out. */

  /* First, check if user entered a file spec to update lists. */
  if ( INDEX( v_TmpFilt , "*" ) > 0 )
  then do:
    /* Check for entry of the form dir/filter. Split out dirname from
       filter and process. */                                   
    run adecomm/_osprefx.p ( input v_TmpFilt , output v_dirname ,
                              output v_basename ).
    if not ( v_TmpFilt begins "*" )
    then do:
      assign file-info:file-name =  v_dirname.

      if ( file-info:full-pathname = ? ) or
         ( index( file-info:file-type , "D" ) = 0 ) or
         ( index(file-info:file-type , "R") = 0 )
      then do:
          message File_Name skip
                  "Path does not exist or cannot be read." SKIP(1)
                  "Please verify that the correct path is given."
                  view-as alert-box warning buttons ok.
          apply "entry" to p_File in frame filecomm.
          return no-apply.
      end.
    end.

    assign
      p_Dir    = if v_TmpFilt begins "*"
                 then v_TmpDir
                 else v_dirname
      v_TmpFilt = SUBSTRING(v_TmpFilt,INDEX(v_TmpFilt,"*":u),-1,"CHARACTER":u)
      p_Filter  = v_TmpFilt
      p_File:SCREEN-VALUE in frame filecomm = p_Filter
    . /* end assign */
    run FillLists.ip.
    apply "entry" to p_File in frame filecomm.
    return no-apply.
  end.

  /* If user entered a dir name, go read it. */
  assign file-info:file-name = File_Name.
  if ( index( file-info:file-type , "D" ) > 0 )
  then do:
    if ( index(file-info:file-type , "R") = 0 )
    then do:
        message File_Name skip
                "Cannot read this directory."
                view-as alert-box warning buttons ok.
        return no-apply.
    end.
    assign p_Dir = file-info:full-pathname 
           p_File:SCREEN-VALUE in frame filecomm = p_Filter
    .
    run FillLists.ip.
    apply "entry" to p_File in frame filecomm.
    return no-apply.
  end.

  /* Otherwise...*/
  /* User entered file name, so try and complete open or save as. */
  do:
      case p_Save_As :
        when NO     /* FILE OPEN */
        then do:

           assign file-info:filename = File_Name.

           /* If these are equal, then user entered a full pathname.
              Else, user entered relative pathname, which we concatenate
              with the current directory in the dialog.
           */
           if ( file-info:filename = file-info:full-pathname )
           then assign Fullpath = file-info:full-pathname.
           else
           do:
             run adecomm/_osfmush.p ( INPUT v_TmpDir  ,
                                      INPUT File_Name ,
                                      OUTPUT Fullpath ).
             assign file-info:file-name = FullPath.
             if file-info:file-name <> ? then
               assign File_Name = FullPath.
           end.
           
           /* Open, but can we find it? */
           if can-do( p_Options , "MUST-EXIST" ) and
              ( file-info:full-pathname = ? ) then
           do:
              message v_TmpFilt SKIP
                "Cannot find this file." SKIP(1)
                "Please verify that the correct path and filename are given."
                view-as alert-box warning buttons ok.
              apply "entry" to p_File in frame filecomm.
              return no-apply.
           end.
           assign p_File:SCREEN-VALUE in frame filecomm = File_Name.
        end.

        when YES    /* FILE SAVE-AS */
        then do: 
          /* Save as, so check if file already exists and warn user. */
          assign file-info:filename = File_Name.
          /* file already exists */
          if ( file-info:full-pathname <> ? )
          then do:

          /* If these are equal, then user entered a full pathname.
             Else, user entered relative pathname, which we concatenate
             with the current directory in the dialog.
          */
          if ( file-info:filename = file-info:full-pathname )
          then assign Fullpath = file-info:full-pathname.
          else
               run adecomm/_osfmush.p
                   ( INPUT v_TmpDir  , 
                     INPUT v_TmpFilt ,
                     OUTPUT Fullpath ).

          assign File_Name = FullPath
                 File-Info:file-name = File_Name.

          if can-do( p_Options , "ASK-OVERWRITE" ) and
              ( file-info:full-pathname <> ? )
           then do:
              assign ok_overwrite = no.
              message File_Name SKIP
                      "This file already exists." SKIP(1)
                      "Replace existing file?"
                       view-as alert-box warning buttons yes-no 
                               update ok_overwrite.
              if ok_overwrite <> true
              then do:
                  apply "entry" to p_File in frame filecomm.
                  return no-apply.
              end.
            end.
          end. /* <> ? */
          else
          /* file doesn't exist on disk yet */
          do:
              /* separate the path from the actual file name */
              run adecomm/_osprefx.p (File_Name, output cSubDir, output cFile).
              
              /* If no path typed in, add selected path and file to create filename */
              if cSubDir eq '':u then
                  run adecomm/_osfmush.p ( v_TmpDir, File_Name, OUTPUT File_Name ).
              else
              /* some path info typed in */
              do: 
                  /* The path from _osprefx has a trailing directory separator.
                     file-info:full-pathname doesn't, so our comparison won't work
                     unless its removed.
                     Also make everything forward slash for ease of comparison. */                 
                  cSubDir = replace(cSubDir, '~\', '/').
                  cSubDir = right-trim(cSubDir, '/').
                  
                  file-information:file-name = cSubDir.
                  cTmp = replace(file-information:full-pathname, '~\', '/').
                  
                  /* If a full path typed in, use that, in the form of File_Name.
                     If not, add relative path to selected path. */
                  if cTmp ne cSubDir then
                      run adecomm/_osfmush.p ( v_TmpDir, File_Name, OUTPUT File_Name ).
              end.    /* some pathing */
          end.    /* file doesn't exist */
           
           assign p_File:SCREEN-VALUE in frame filecomm = File_Name.
        end. /* when YES */

      end case.

  end.

  p_Return_Status = YES.
end.

on value-changed of v_PickFile in frame filecomm
do:
    IF ( v_PickFile:SCREEN-VALUE  = "" ) OR ( v_PickFile:SCREEN-VALUE = ? )
    THEN RETURN NO-APPLY.
    ASSIGN p_File:SCREEN-VALUE = v_PickFile:SCREEN-VALUE.
end.

on default-action of v_PickFile in frame filecomm
do:
  define var Fullpath as char no-undo.

  if v_PickFile:SCREEN-VALUE in frame filecomm = ""
    OR v_PickFile:SCREEN-VALUE in frame filecomm = ? 
    THEN RETURN NO-APPLY.

  assign v_TmpDir  = p_Dir:SCREEN-VALUE in frame filecomm
         File_Name = TRIM( v_PickFile:SCREEN-VALUE in frame filecomm )
         .
  run adecomm/_osfmush.p
      (  v_TmpDir  ,
         File_Name ,
         OUTPUT Fullpath ).
  p_File:SCREEN-VALUE in frame filecomm = Fullpath.
  IF SESSION:WINDOW-SYSTEM = "TTY"
    THEN apply "GO" to frame filecomm.
end.
  
on default-action of v_PickDir in frame filecomm
do:
  if can-do(OS-DRIVES , v_PickDir:SCREEN-VALUE in frame filecomm )
  then do:
    p_Dir = v_PickDir:SCREEN-VALUE .
  end.
  else do: 
    run adecomm/_osfmush.p
         (p_Dir, v_PickDir:SCREEN-VALUE in frame filecomm , 
          OUTPUT p_Dir).
  end.

  ASSIGN FILE-INFO:FILENAME = p_Dir NO-ERROR.
  ASSIGN p_Dir = FILE-INFO:FULL-PATHNAME.

  if p_Dir = ? or p_Dir = "" then return.

  run FillLists.ip.
  if v_PickDir:SENSITIVE in frame filecomm
  then apply "entry" to v_PickDir in frame filecomm.
  
end.

/******************* Internal Procedures ***************/

procedure FillLists.ip:
  /* use a temporary filter with . escaped */
  define var v_TmpFilter as char.
  
  do with frame filecomm:

  v_TmpFilter = TRIM( p_File:SCREEN-VALUE ).
  /* First, check if user entered a file spec to update lists. */
  if ( INDEX( v_TmpFilter , "*" ) > 0 )
  then do:
    assign p_Filter       = v_TmpFilter
           v_TmpFilter    = REPLACE( p_Filter    , "." , "~~." )
    . /* end assign */
  end.
  else assign v_TmpFilter = REPLACE( p_Filter    , "." , "~~." ).
  
  Status_Line:SCREEN-VALUE = "Reading directory...".

  ASSIGN
     v_PickFile:VISIBLE = no
     v_PickDir:VISIBLE = no
     t_log = v_PickDir:DELETE(v_PickDir:LIST-ITEMS )
     t_log = v_PickFile:DELETE(v_PickFile:LIST-ITEMS )
     . /* end assign */

  /* Set dialog current working dir to root (drive:\.) if at drive level. */
  if CAN-DO(OPSYS,"MSDOS,WIN32") and can-do(OS-DRIVES , p_Dir ) then
  do:
    assign p_Dir = p_Dir + "~\".
  end.

  if ( OPSYS = "VMS" ) then
    assign t_log = v_PickDir:ADD-LAST("[.-]").

  input from os-dir(p_Dir).
  repeat:
    import v_InFile ^ v_InAttr.
    
/*    IF v_InFile = "." THEN NEXT. */
    IF INDEX(v_InAttr,"D") > 0 THEN
    DO:
        IF OPSYS = "VMS" THEN
          ASSIGN v_InFile = SUBSTRING(v_InFile,1,INDEX(v_InFile,".":u) - 1, 
                                      "CHARACTER":u)
                 v_InFile = "[." + v_InFile + "]"
          . /* END ASSIGN */
        t_log = v_PickDir:ADD-LAST(v_InFile).
    END.
    ELSE
    IF ( INDEX(v_InAttr , "F") > 0 and  /* Be sure its a file and not X. */
          v_Infile Matches v_TmpFilter ) THEN
    DO:
        ASSIGN t_log = v_PickFile:ADD-LAST(v_InFile).
    END.
  END.

  IF OS-DRIVES <> "" THEN
    ASSIGN t_log = v_PickDir:ADD-LAST( REPLACE(OS-DRIVES, "," , CHR(10)) ).

  /* Assign using no-error in case LIST-ITEMS is ? (empty). Avoids
     Progress list error about invalid arguments in ENTRY.
  */
  t_log = v_PickFile:SCROLL-TO-ITEM( v_PickFile:ENTRY(1) ) no-error.

  t_log = v_PickDir:SCROLL-TO-ITEM( v_PickDir:ENTRY(1) ) no-error.

  ASSIGN v_PickFile:VISIBLE = yes.
  ASSIGN v_PickDir:VISIBLE  = yes.

  display p_Dir.
  assign Status_Line:SCREEN-VALUE = "".
  
  end. /* do with frame filecomm */
END.
/******************* Main Line Code ********************/


if ( p_Title = "" )
then do:
  v_Type  = IF p_Save_As THEN "Save As" ELSE "Open".
  p_Title = v_Type.
end.

if ( p_Filter = "" )
then do:
  p_Filter = if can-do(opsys, "MSDOS,WIN32":u)
             then "*.*"
             else "*".
end.
if ( p_Save_As = NO ) AND ( p_File = "" )
then p_File = p_Filter.

/* If passed an initial-dir, check 1) If its a dir, and 2) can-find. */
if ( p_Dir <> "" )
then do:
  assign file-info:filename = p_Dir
         p_Dir              = file-info:full-pathname.
  if ( index( file-info:file-type , "D" ) = 0 ) /* not a directory */
     or
     ( p_Dir = ? )                              /* not found */
  then p_Dir = "".
end.

if ( p_Dir = "" )
then do:
  /* Initialize dir to root for the current drive. If no drive specified,
     initialize dir to current working dir (.) . */
  p_Dir = IF ( p_Drive <> "" )
          THEN ( p_Drive + "~\" + "." )
          ELSE IF ( OPSYS = "VMS" ) THEN "[]" ELSE "." .
  FILE-INFO:FILENAME = p_Dir.
  p_Dir              = FILE-INFO:FULL-PATHNAME.
end.

/* Assign appropriate Help Context number for Save or Open. */
if p_Save_As
   then assign Help_Context = {&Chr_Save_As_Dlg_Box} .
   else assign Help_Context = {&Chr_Get_File_Dlg_Box} .

/* Change delimiter to non-printable so lists handle commas. */
assign v_PickDir:DELIMITER IN FRAME filecomm = CHR(10)
       v_PickFile:DELIMITER IN FRAME filecomm = CHR(10).

/* Fill the two lists */
run FillLists.ip.

display
  p_File
  with frame filecomm.

do on stop undo, retry on endkey undo, leave:

  if not retry 
  then do:
    set
      p_File
      v_PickFile v_PickDir
      b_ok b_Cancel b_Help {&WHEN_HELP}
      with frame filecomm.
    p_File = TRIM( p_File ).
  end.
  else do:
    p_File = ?.
    p_Return_Status = NO.
  end.
  
end.
