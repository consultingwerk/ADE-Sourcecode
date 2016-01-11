/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* odb_fld - field editor for Odbc files */

/*
dfields is NOT AVAILABLE to create, otherwise contains record to
UPDATE (you ain't spoz'ta CREATE with ODBC files).

When you come into this routine, the field name is already set on the
form.

  _File._For-name      = Foreign file name
  _File._For-owner     = Foreign file owner
  _File._For-type      = Foreign file type (TABLE, VIEW, STABLE).
  _Field._Fld-stoff    = Field relative position in record.
  _Field._Fld-stdtype  = Foreign field datatype.
  _Field._For-name     = Foreign field name.
  _Field._For-retrieve  = ? or 0 if field should be retrieved from Odbc,
                         1 if not (large objects ...)
  _Field._For-type     = Foreign field datatype name.
  _Index._For-name     = Foreign index name.

  -----Odbc-----  ---Progress--- (detailed, up-to-date list see
  Data Type  dtype  Data Type                              _odb_typ.p)
  --------- ------  ---------
  CHAR       35	    CHAR
  NUMERIC    136    DECIMAL
  DECIMAL    236    DECIMAL
  INTEGER    33     INTEGER
  SMALLINT   32     INTEGER
  FLOAT      34     DECIMAL
  REAL       48     DECIMAL
  DOUBLE     134    DECIMAL
  VARCHAR    36     CHAR
  DATE       43     DATE
  TIME      143     CHAR
  TIMESTAMP  44     CHAR
  LONGVARCHAR 37    CHAR
  VARBINARY  39     CHAR
  BINARY     38     CHAR
  LONGVARBINARY 40  CHAR
  BIGINT     234    DECIMAL
  TINYINT    31     INTEGER
  BIT        41     LOGICAL
HISTORY:
    96/04   hutegger    restricted update of _fld-stoff to only BUFFERs 
                        that got created on the PROGRES side
!!!!!!!NOTE: this program is not yet suitable for adding fields!!!!!!!!

*/

DEFINE INPUT  PARAMETER ronly   AS CHARACTER             NO-UNDO.
DEFINE INPUT  PARAMETER junk2   AS RECID                 NO-UNDO.
DEFINE OUTPUT PARAMETER changed AS LOGICAL INITIAL FALSE NO-UNDO.

DEFINE SHARED BUFFER dfields FOR DICTDB._Field.
DEFINE VARIABLE answer          AS LOGICAL               NO-UNDO.
DEFINE VARIABLE c               AS CHARACTER             NO-UNDO.
DEFINE VARIABLE edbtyp          AS CHARACTER NO-UNDO. /* db-type external format */
DEFINE VARIABLE edbtyp1         AS CHARACTER NO-UNDO. /* label name */
DEFINE VARIABLE edbtyp2         AS CHARACTER NO-UNDO. /* label type */
DEFINE VARIABLE gat_typ         AS CHARACTER             NO-UNDO.
DEFINE VARIABLE i               AS INTEGER               NO-UNDO.
DEFINE VARIABLE inindex         AS LOGICAL               NO-UNDO.
DEFINE VARIABLE inview          AS LOGICAL               NO-UNDO.
DEFINE VARIABLE j               AS INTEGER               NO-UNDO.
define variable l_dt-new        as character             NO-UNDO.
define variable l_dt-old        as character             NO-UNDO.
define variable l_for-type      as character             no-undo.
define variable l_format        as character             NO-UNDO.
define variable l_init          as character             NO-UNDO.
define variable l_length        as integer               NO-UNDO.
define variable l_lcl-bffr      as logical               NO-UNDO.
DEFINE VARIABLE odb_type        AS CHARACTER             NO-UNDO.
DEFINE VARIABLE odb_type_ix     AS INTEGER               NO-UNDO.
DEFINE VARIABLE pro_format      AS CHARACTER             NO-UNDO.
DEFINE VARIABLE pro_type        AS CHARACTER             NO-UNDO.
DEFINE VARIABLE retriev         AS LOGICAL               NO-UNDO.

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userpik.i NEW }

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 10 NO-UNDO INITIAL [
  /* 1*/ "This field is used in a View or Index - cannot delete.",
  /* 2*/ "This field is used in a View - cannot rename.",
  /* 3*/ "Are you sure that you want to delete the field named",
  /* 4*/ "Cannot create &1 fields.  Must create on &1 side and",
  /* 5*/ "use ~"Update &1 definition~" to bring definition over.",
  /* 6*/ "You must enter a field name here.", /* reserved */
  /* 7*/ "This is not an equivalent &PRO_DISPLAY_NAME} datatype for the &1 datatype",
  /* 8*/ "Attempt to add with same name as existing field -switching to MODIFY",
  /* 9*/ "Invalid &1 datatype.",
  /*10*/ "Offset allready used by other field."
].

FORM
  dfields._Field-name   LABEL "  Field-Name" FORMAT "x(32)"
    VALIDATE(KEYWORD(dfields._Field-name) = ?,
      "This name conflicts with a &PRO_DISPLAY_NAME} reserved keyword.") SPACE
  dfields._Data-type    LABEL    "Data-Type" FORMAT "x(9)"  SKIP

  edbtyp1            NO-LABEL AT  2          FORMAT "x(12)" SPACE
  dfields._For-name  NO-LABEL                FORMAT "x(30)" SPACE
  edbtyp2            NO-LABEL                FORMAT "x(12)" SPACE
  dfields._For-type  NO-LABEL                FORMAT "x(12)" SKIP

  dfields._Format       LABEL "      Format" FORMAT "x(30)" SPACE(4)
  dfields._Fld-stoff    LABEL     "Position" FORMAT ">>>9" SKIP

  dfields._Label        LABEL "       Label" FORMAT "x(30)" SPACE(4)
  dfields._Decimals     LABEL     "   Scale" FORMAT ">>>>9" "(Decimals)" SKIP

  dfields._Col-label    LABEL "Column-label" FORMAT "x(30)" SPACE(4)
  dfields._Order        LABEL     "   Order" FORMAT ">>>>9"
  /* dfields._For-retrieve  * /
  retriev              LABEL     "Retrieve ?" FORMAT "y/n"*/ SKIP

  dfields._Initial      LABEL "     Initial" FORMAT "x(30)" SPACE(4)
  dfields._Mandatory    LABEL     "Not Null" FORMAT "yes/no"
  dfields._Extent       LABEL     "  Extent" FORMAT ">>>>9" SKIP

  dfields._Valexp       LABEL   "Valexp"     VIEW-AS EDITOR
      	       	     	      	       	     INNER-CHARS 63 INNER-LINES 4
      	       	     	      	       	     BUFFER-LINES 4 SKIP
  dfields._Valmsg       LABEL "Valmsg"       FORMAT "x(63)" SKIP
  dfields._Help         LABEL "  Help"       FORMAT "x(63)" SKIP
  dfields._Desc         LABEL "  Desc"       FORMAT "x(70)" SKIP
  HEADER ""
  WITH FRAME odb_fld NO-BOX ATTR-SPACE OVERLAY SIDE-LABELS
  ROW (SCREEN-LINES - 19) COLUMN 1.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

/*----------------------- Internal Procedures -------------------------*/

/*----------------------------- Triggers ------------------------------*/

on leave of dfields._fld-stoff in frame odb_fld do:

  define variable l_fld-stoff as integer.

  assign
    l_fld-stoff  = input frame odb_fld dfields._fld-stoff.

  if can-find(first DICTDB._Field
    where DICTDB._Field._file-recid = drec_file
    and   RECID(DICTDB._Field) <> RECID(dfields)
    and   DICTDB._FIeld._fld-stoff = l_fld-stoff
    no-lock)
   then do:  /* wrong offset */
    message new_lang[10] view-as alert-box.
    RETURN NO-APPLY.
    end.     /* wrong offset */

  end.   /* on leave of dfields._fld-stoff  trigger */


/*---- LEAVE of foreign type field---- */
on leave of dfields._For-type in frame odb_fld do:

  assign
    l_for-type  = input frame odb_fld dfields._For-type
    odb_type_ix = LOOKUP(l_for-type, user_env[12]).

  if  odb_type_ix = 0
   or odb_type_ix = ?
   then do:  /* invalid foreign type */
    message new_lang[9] view-as alert-box.
    RETURN NO-APPLY.
    end.     /* invalid foreign type */

  repeat while num-entries(user_env[12]) >= odb_type_ix
   and   ENTRY(odb_type_ix,user_env[12])  = l_for-type:
    assign 
      pro_type    = pro_type    + "," + ENTRY(odb_type_ix, user_env[15])
      pro_format  = pro_format  + "|" + ENTRY(odb_type_ix, user_env[17],"|")
      odb_type_ix = odb_type_ix + 1.
    end.

  assign
    pro_type    = substring(pro_type,2,-1,"character")
    pro_format  = substring(pro_format,2,-1,"character")
    odb_type_ix = LOOKUP(l_for-type, user_env[12])
    l_format    = ENTRY(odb_type_ix, user_env[17],"|")
    l_dt-new    = ENTRY(odb_type_ix, user_env[15])
    dfields._fld-stdtype = INTEGER(ENTRY(odb_type_ix, user_env[14]))
    dfields._Data-type   = l_dt-new
    .

    if l_format = "?"
     then assign
      l_format = ( if l_dt-new = "decimal"
                     then "#"
                     else substring(l_dt-new,1,1,"character")
                 ).
                          
    case l_format:
      when "c" then assign l_format = "x(8)".
      when "d" then assign l_format = "99/99/99".
      when "i" then assign l_format = "->>,>>>,>>>9".
      when "#" then assign l_format = "->>,>>>,>>>9.99".
      when "l" then assign l_format = "yes/no".
      end case.

    DISPLAY 
      l_dt-new @ dfields._Data-type
      l_format @ dfields._Format
      WITH FRAME odb_fld.
  end.   /* on leave of dfields._For-type  trigger */


/*---- GET or HELP of foreign type field---- */
ON GET,HELP OF dfields._For-type IN FRAME odb_fld DO:

  RUN "prodict/user/_usrpick.p".

  IF pik_first <> ? THEN DO:
    /* Show the gateway data type they chose */
    DISPLAY
      pik_first @ dfields._For-type
      WITH FRAME odb_fld.

    /* Show the corresponding progress type */
    assign
      l_for-type  = pik_first
      odb_type_ix = LOOKUP(l_for-type, user_env[12]).
    assign
      l_format    = ENTRY(odb_type_ix, user_env[17],"|")
      l_dt-new    = ENTRY(odb_type_ix, user_env[15]).

    if l_format = "?"
     then assign
      l_format = ( if l_dt-new = "decimal"
                     then "#"
                     else substring(l_dt-new,1,1,"character")
                 ).
                          
    case l_format:
      when "c" then assign l_format = "x(8)".
      when "d" then assign l_format = "99/99/99".
      when "i" then assign l_format = "->>,>>>,>>>9".
      when "#" then assign l_format = "->>,>>>,>>>9.99".
      when "l" then assign l_format = "yes/no".
      end case.

    DISPLAY 
      l_dt-new @ dfields._Data-type
      l_format @ dfields._Format
      WITH FRAME odb_fld.

  END.
END.

/*----- Any ASCII key in foreign type field -----*/
ON ANY-PRINTABLE OF dfields._For-type IN FRAME odb_fld DO:
  /* blank out the pro type if they change the gate type */
  IF dfields._Data-type:SCREEN-VALUE IN FRAME odb_fld <> "" THEN 
    DISPLAY "" @ dfields._Data-type WITH FRAME odb_fld.
END.


/*---- LEAVE of data-type field---- */
on leave of dfields._data-type in frame odb_fld do:

  define variable l_type-match as logical no-undo.

  assign
    l_dt-new    = input frame odb_fld dfields._Data-type
    l_for-type  = input frame odb_fld dfields._For-type
    l_init      = input frame odb_fld dfields._Initial
    odb_type_ix = LOOKUP(l_for-type, user_env[12])
    l_type-match = false.

  repeat while ENTRY(odb_type_ix,user_env[12])  = l_for-type
    and l_type-match = false:
    assign 
      l_type-match = ( ENTRY(odb_type_ix,user_env[15]) = l_dt-new )
      odb_type_ix  = odb_type_ix + 1 - integer(l_type-match)
      .
    end.

  if l_type-match = false
   then do:  /* not a correct match */
    message new_lang[7] view-as alert-box.
    RETURN NO-APPLY.
    end.     /* not a correct match */

  if  ( l_dt-new = "character" and l_dt-old <> "character" )
   or ( l_dt-new = "date"      and l_dt-old <> "date"      )
   or ( l_dt-new = "logical"   and l_dt-old <> "logical"   )
   or ( can-do("integer,decimal",l_dt-new) 
                and not can-do("integer,decimal",l_dt-old) )
   then do:  /* change format and ev. initial */
    if   l_dt-new   = "character"
     and l_for-type = "timestamp"
     then assign l_format = "x(26)".
     else do:  /* any other dt-new/for-type combination */
      assign
        l_format    = ENTRY(odb_type_ix, user_env[17], "|")
        l_length    = ( if  l_length  = ?
                         or l_length <= 0
                            then 8
                            else l_length
                      ).
      if l_format = "?"
       then assign
        l_format = ( if l_dt-new = "decimal"
                       then "#"
                       else substring(l_dt-new,1,1,"character")
                   ).
                          
      case l_format:
        when    "c" then assign l_format = "x(" + string(l_length) + ")".
        when    "d" then assign l_format = ( if l_length = 8
                                                then "99/99/99"
                                                else "99/99/9999"
                                           ).
        when    "i" 
        or when "#" then assign l_format = fill("9",l_length).
        when    "l" then assign l_format = "yes/no".
        end case.
      end.     /* any other dt-new/for-type combination */

    display
      l_format @ dfields._Format
      WITH FRAME odb_fld.

    if   l_init      <> ""
     and l_init      <> ?
     and ( l_dt-new  <> "character"
        or l_for-type = "timestamp"
         )
     then do:  /* change initial-value */
      assign
        l_init = ( if l_dt-new = "logical"
                     then "no"
                     else ?
                 ).
      display
        l_init @ dfields._Initial
        WITH FRAME odb_fld.
      end.     /* change initial-value */

    end.     /* change format, length and ev. initial */

  end.   /* on leave of dfields._data-type */

/*---------------------------- Main Code ------------------------------*/

ASSIGN
  edbtyp      = {adecomm/ds_type.i
                  &direction = "itoe"
                  &from-type = "user_dbtype"
                  }
  new_lang[4] = SUBSTITUTE(new_lang[4],edbtyp)
  new_lang[5] = SUBSTITUTE(new_lang[5],edbtyp)
  new_lang[7] = SUBSTITUTE(new_lang[7],edbtyp)
  new_lang[9] = SUBSTITUTE(new_lang[9],edbtyp)
  edbtyp1     = SUBSTRING(edbtyp,1,6,"character")
  edbtyp1     = FILL(" ",6 - LENGTH(edbtyp1,"character")) + edbtyp1
  edbtyp2     = edbtyp1 + "-Type:"
  edbtyp1     = edbtyp1 + "-Name:".

ASSIGN
  c = ?
  i = ?.
RUN "prodict/odb/_odb_typ.p"
  (INPUT-OUTPUT i,INPUT-OUTPUT i,INPUT-OUTPUT c,INPUT-OUTPUT c,OUTPUT c).

/**/
ASSIGN
  pik_column = 40
  pik_down   = 0
  pik_hide   = TRUE
  pik_init   = ""
  pik_list   = ""
  pik_multi  = FALSE
  pik_number = FALSE
  pik_row    = 3
  pik_skip   = FALSE
  pik_title  = ""
  pik_wide   = FALSE.

j = 1.
DO i = 1 TO NUM-ENTRIES(user_env[12]) - 1:
  /* There are some multiple entries in the table with the same foreign
     type but different progress types.  They are always contiguous.
     Only show the first one.
  */
  IF i = 1 OR ENTRY(i, user_env[12]) <> ENTRY(i - 1, user_env[12]) THEN DO:
    pik_list[j] = ENTRY(i,user_env[12]).
    j = j + 1.
  END.
END.
pik_count = j - 1.
/**/

if available dfields
 then do:
  assign
    odb_type_ix = LOOKUP(dfields._For-type, user_env[12]).
  repeat while num-entries(user_env[12]) <= odb_type_ix
    and ENTRY(odb_type_ix,user_env[12])   = dfields._For-type:
    assign 
      odb_type    = odb_type    + "," + ENTRY(odb_type_ix, user_env[12])
      pro_type    = pro_type    + "," + ENTRY(odb_type_ix, user_env[15])
      pro_format  = pro_format  + "|" + ENTRY(odb_type_ix, user_env[17],"|")
      odb_type_ix = odb_type_ix + 1.
    end.
  assign 
    odb_type    = substring(odb_type,2,-1,"character")
    pro_type    = substring(pro_type,2,-1,"character")
    pro_format  = substring(pro_format,2,-1,"character").
  end.

 else do:
  CLEAR FRAME odb_fld NO-PAUSE.
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    PROMPT-FOR _Field-name WITH FRAME odb_fld.
    IF INPUT FRAME odb_fld _Field-name = "" 
     THEN DO:
      MESSAGE new_lang[6] view-as alert-box. /* nothing entered! */
      UNDO,RETRY.
      END.
    END.
  IF KEYFUNCTION(LASTKEY) = "END-ERROR"
   then do:
    HIDE FRAME odb_fld NO-PAUSE.
    RETURN.
    END.
  FIND FIRST dfields WHERE dfields._File-recid = drec_file
    AND dfields._field-name = INPUT FRAME odb_fld _Field-name NO-ERROR.
  IF AVAILABLE dfields
   then MESSAGE new_lang[8] view-as alert-box.
  ELSE DO:
    CREATE dfields.
    ASSIGN
        dfields._File-recid = drec_file
        dfields._For-type   = ?
        dfields._Fld-case   = TRUE
        dfields._Field-name = INPUT FRAME odb_fld _Field-name.
    end.
  end.

ASSIGN
  inindex    = CAN-FIND(FIRST DICTDB._Index-field OF dfields)
  inview     = CAN-FIND(FIRST DICTDB._View-ref
               WHERE DICTDB._View-ref._Ref-Table = user_filename
               AND DICTDB._View-ref._Base-Col = dfields._Field-name)
  l_lcl-bffr = ( can-find (first DICTDB._File
                    where RECID(DICTDB._File)    = drec_file
                    and   DICTDB._File._for-name = "NONAME"
                    and   DICTDB._File._for-type = "BUFFER"
                    no-lock) )
  l_length   = ( if can-do(
    "char,longvarbinary,time,timestamp,longvarchar,binary,varbinary,varchar"
                         ,dfields._for-type) 
                then dfields._Fld-misc1[3]
               else if dfields._Fld-misc1[4] = 2
                then dfields._Fld-misc1[1] * 0.30103
                else dfields._Fld-misc1[1]
             ).

/*retriev = (NOT dfields._For-retrieve = 1).*/
DISPLAY
  edbtyp1 edbtyp2
  dfields._Field-name
  dfields._Data-type
  dfields._For-name
  dfields._For-type
/*  retriev */
  dfields._Format
  dfields._Label
  dfields._Col-label
  dfields._Initial
  dfields._Fld-stoff
  dfields._Decimals WHEN dfields._Data-type = "DECIMAL"
  dfields._Order
  dfields._Mandatory
  dfields._Extent
  dfields._Valexp
  dfields._Valmsg
  dfields._Help
  dfields._Desc
  WITH FRAME odb_fld.

IF ronly = "r/o"
 THEN DO:
  { prodict/user/userpaus.i }
  HIDE FRAME odb_fld NO-PAUSE.
  RETURN.
  end.

IF NOT NEW dfields
 THEN NEXT-PROMPT dfields._Format WITH FRAME odb_fld.

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  FIND _File WHERE RECID(_File) = drec_file.
  if NEW dfields
   then do:
    SET
      dfields._For-type when NEW dfields
      dfields._Fld-stoff WHEN l_Lcl-bffr
      dfields._For-name when NEW dfields
      WITH FRAME odb_fld.
    NEXT-PROMPT dfields._Format WITH FRAME odb_fld.
    end.
   else NEXT-PROMPT dfields._Data-type WITH FRAME odb_fld.
  assign l_dt-old = dfields._Data-type.
  SET
    dfields._Field-name
    dfields._For-name when NEW dfields
    dfields._For-type when NEW dfields
    dfields._Data-type 
    dfields._Format
    dfields._Label
    dfields._Col-label
    dfields._Initial
    dfields._Fld-stoff WHEN l_Lcl-bffr
    dfields._Decimals WHEN dfields._Data-type = "DECIMAL"
    dfields._Order
    /* Suppress update of retrieve until implemented in Progress */
  /* retriev
    dfields._For-retrieve = IF retriev THEN ? ELSE 1 */
    dfields._Mandatory when NEW dfields
    dfields._Extent when NEW dfields
    dfields._Valexp
    dfields._Valmsg
    dfields._Help
    dfields._Desc
    WITH FRAME odb_fld.
    
  IF dfields._Field-name ENTERED AND NOT NEW dfields AND inview
   THEN DO:
    MESSAGE new_lang[2] view-as alert-box. /* sorry, used in view */
    UNDO,RETRY.
    end.

  ASSIGN
    dfields._Valexp = (IF TRIM(dfields._Valexp) = "" 
      	       	     	 THEN ? 
      	       	     	 ELSE TRIM(dfields._Valexp)).
  changed = TRUE.
  end.

HIDE FRAME odb_fld NO-PAUSE.

IF KEYFUNCTION(LASTKEY) = "END-ERROR"
 THEN DO:
  IF NEW dfields
   then DELETE dfields.
  ELSE
    UNDO,RETURN.
  end.

RETURN.
