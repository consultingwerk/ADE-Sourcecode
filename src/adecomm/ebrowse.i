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
/***************************************************************************
ToolProgName= tools/ebrwedit.p

Parameters:{&File}       = File Name
           {&Frame_Name} = Frame Name
           {&Fields}     = Fields to enable in the frame
           {&SField}     = Field to scroll on - this should go away
           {&Where}      = where clause for find
           {&Lock_Type}  = find lock type

    NOTES:
 The program calling this must also include ebrowse.def

****************************************************************************
\****************************************************************************/

/* add recid to the frame -- this will be a hidden field */
form 
  i_recid no-label at row 1 column 1 with frame {&frame_name}.

on cursor-up of {&sfield} in frame {&frame_name} USING {&file}
do:
  if frame-line({&frame_name}) > 1 then
  do:
    up 1 with frame {&frame_name}.
    apply "entry" to {&SField} in frame {&frame_name}.
  end.

  else  /* we are on the first line */
  if input frame {&frame_name} i_recid > 0 THEN
  do:
    RUN recid{&frame_name}.
    RUN prev{&frame_name}.
    if available({&file}) then
    do:
      scroll down with frame {&frame_name}.
      RUN display{&frame_name}.
      /* I should be able to get rid of the next two lines */
      enable {&sfield} with frame {&frame_name}.
      i_recid:visible in frame {&frame_name} = no.
      apply "entry" to {&SField} in frame {&frame_name}.
    end.
  end.
  return error.
end.

on cursor-down of {&sfield} in frame {&frame_name} USING {&file}
do:
  if frame-line({&frame_name}) < frame-down({&frame_name}) then
  do:
    down 1 with frame {&frame_name}.
    apply "entry" to {&SField} in frame {&frame_name}.
  end.

  else  /* we are on the last line */
  if input frame {&frame_name} i_recid > 0 THEN
  do:
    RUN recid{&frame_name}.  /* find recid */
    RUN next{&frame_name}.  /* find next */
    if available({&file}) then
    do:
      scroll up with frame {&frame_name}.
      RUN display{&frame_name}.
      /* I should be able to get rid of the next two lines */
      enable {&sfield} with frame {&frame_name}.
      i_recid:visible in frame {&frame_name} = no.
      apply "entry" to {&SField} in frame {&frame_name}.
    end.
  end.
  return error.
end.

on page-up of frame {&frame_name} USING {&file}
do:
end.

on page-down of frame {&frame_name} USING {&file}
do:
end.

/* display record */
procedure display{&frame_name} USING {&file}:
  {&DisplaySetUp}
  display {&fields} recid({&file}) @ i_recid with frame {&frame_name}.
end.

/* find next */
procedure next{&frame_name} USING {&file}:
  find next {&file} WHERE {&where} {&lock_type} no-error.
end.

/* find prev */
procedure prev{&frame_name} USING {&file}:
  find prev {&file} WHERE {&where} {&lock_type} no-error.
end.

/* find first */
procedure first{&frame_name} USING {&file}:
  find first {&file} WHERE {&where} {&lock_type} no-error.
end.

/* find by recid */
procedure recid{&frame_name} USING {&file}:
  find {&file} WHERE
    RECID({&file}) = input frame {&frame_name} i_recid {&lock_type}.
end.

/* remove a line from the screen  -- returns with i_recid = removed recid */
procedure del{&frame_name} USING {&file}:
  assign input frame {&frame_name} i_recid.

  scroll from-current up with frame {&frame_name}.

  /* was this the last and only record on the screen */
  if frame-line({&frame_name}) = 1 AND
    input frame {&frame_name} i_recid = 0 then
  do:
    run recid{&frame_name}.
    run prev{&frame_name}.
    if available {&file} then
    run disp{&frame_name}.
  end.
  else  /* find last rec, and display the next -- usually on last line */
  do:
    /* go to the  second to last line last line */
    down FRAME-DOWN({&Frame_Name}) - FRAME-LINE({&Frame_Name}) - 1
      with frame {&Frame_Name}.

    /* go up (if needed) to the last line with a record on it */
    Do while input frame {&frame_name} i_recid = 0 AND
        frame-line({&frame_name}) > 1:
      up 1 with frame {&Frame_name}.
    end.

    /* find this record, and display the next in the next iteration */
    if input frame {&frame_name} i_recid > 0 then
    do:
      run recid{&frame_name}.
      run next{&frame_name}.
      if available {&file} then
      run disp{&frame_name}.
    end.
  end.
    
end.

/* view the frame and enable all iterations */
procedure view{&frame_name} USING {&file}:
  clear frame {&frame_name} all no-pause.
  view frame {&frame_name}.
  activate frame {&frame_name}.
  RUN first{&frame_name}.
  do while available({&file}) AND
      frame-line({&frame_name}) < frame-down({&frame_name}):
    if input frame {&frame_name} i_recid > 0 then
    down 1 with frame {&frame_name}.
    RUN display{&frame_name}.
    enable {&sfield} with frame {&frame_name}.
    i_recid:visible in frame {&frame_name} = no.
    RUN next{&frame_name}.
  end.
end.
