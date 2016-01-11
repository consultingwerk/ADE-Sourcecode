/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 hutegger     94/02/11    changed input-parameter of runload.i to "y"
*/

{ prodict/gate/_gat_md9.i
    &db-type  = "ora"
    &tmp-name = "osh"
    }
/*----------------------------------------------------------------
{ prodict/dictvar.i NEW }
{ prodict/ora/oravar.i }
DEFINE NEW SHARED STREAM   loaderr.
DEFINE NEW SHARED VARIABLE errs   AS INTEGER INITIAL 0 NO-UNDO.
DEFINE NEW SHARED VARIABLE recs   AS INTEGER INITIAL 0. /*UNDO*/
DEFINE NEW SHARED VARIABLE xpos   AS INTEGER INITIAL ? NO-UNDO.
DEFINE NEW SHARED VARIABLE ypos   AS INTEGER INITIAL ? NO-UNDO.
DEFINE            VARIABLE noload AS CHARACTER NO-UNDO.

OUTPUT TO VALUE (osh_dbname + "out.tmp") NO-MAP.

CREATE ALIAS "DICTDB2" FOR DATABASE VALUE(ora_dbname).
FIND DICTDB._Db WHERE DICTDB._Db._Db-name = ora_dbname.

assign noload = "u".
{ prodict/dictgate.i
    &action = "undumpload"
    &dbtype = "_Db._Db-type"
    &dbrec  = "RECID(_Db)"
    &output = "noload"
    }
    
FOR EACH DICTDB._File OF DICTDB._Db
  WHERE NOT DICTDB._File._Hidden
  AND   _file._File-number > 0
  AND   (noload = "" OR NOT CAN-DO(noload,_File._For-type))
  BY DICTDB._File._File-name:

  OUTPUT STREAM loaderr TO VALUE(_Dump-name + ".e") NO-ECHO.
  INPUT FROM VALUE(_Dump-name + ".d") NO-ECHO NO-MAP.
  RUN prodict/misc/_runload.i (INPUT "y") _File-name 0 100 _File-name 0.
  INPUT  CLOSE.
  OUTPUT STREAM loaderr CLOSE.  


END.

OUTPUT CLOSE.

RETURN.
----------------------------------------------------------------*/
