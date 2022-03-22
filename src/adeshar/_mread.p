/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 *  _mread.p
 *
 *    Read and recreate a menu structure described in fileName.
 *
 *  Input Parameter
 *
 *    fileName - The complete name of the .mnu file. This routine expects
 *               that the file exists and is ready to be used.
 *
 *
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i }

define input parameter appId        as character no-undo.
define input parameter fileName     as character no-undo.

define variable token     as character no-undo.
define variable equalSign as character no-undo.
define variable args      as character no-undo extent 12.
define variable itsName   as character no-undo.
define variable i         as integer   no-undo.
define variable handle    as widget    no-undo.
define variable s         as logical   no-undo.

define stream   mStream.

input stream  mStream from value(fileName) no-echo.
repeat:

    /* 
     * Reset the tokens
     */

    assign
        token = ""
        args  = ""
    .

    import stream mStream token equalSign args.

    /*
     * Ignore any comments we find and then break the token apart. It
     * contains 2 parts, the type and then a name.
     */

    if token = "#" then next.

/*    message "token " token skip
            "arg1  " args[1] skip
            "arg2  " args[2] skip
            "arg3  " args[3] skip
            "arg4  " args[4] skip
            "arg5  " args[5] skip
            "arg6  " args[6] skip
            "arg7  " args[7] skip
            "arg8  " args[8] skip
            "arg9  " args[9] skip
    view-as alert-box error buttons ok.*/

    /*
     * There are tokens and then there are compound tokens. Split the compound
     * tokens apart.
     */

    i = index(token, ".":u).

    if i > 1 then do:

        assign
            itsName = SUBSTRING(token,i + 1,-1,"CHARACTER":u).
            token   = SUBSTRING(token,1,i - 1,"CHARACTER":u)
        .
    end.

    case token:

    when {&tbItemType}:u then do:

             run {&mdir}/_maddt.p(appId,
                                  itsName,
                                  args[1], 
                                  args[2],
                                  args[3],
                                  args[4],
                                  args[5],
                                  args[6],
                                  int(args[7]),
                                  int(args[8]),
                                  int(args[9]),
                                  int(args[10]),
                                  token,
                                  if args[11] = "T" then true else false,
                                  args[12],
                                  output s).

    end.
    when {&mnuFeatureType}:u then do:

         run {&mdir}/_maddf.p(appId, 
                              itsName,
                              args[5],
                              args[1],
                              args[2],
                              args[3],
                              args[6],
                              args[7],
                              args[8],
                              args[9],
                              if args[4] = "T" then true else false,
                              args[10],
                              args[11],
                              output s).

         end.

    when {&mnuMenuType}:u then do:

         run {&mdir}/_maddm.p(appId, itsName, args[1], args[2], output s).

         end.

    when {&mnuSubMenuType}:u or
    when {&mnuItemType}:u    or
    when {&mnuToggleType}:u  then do:

         run {&mdir}/_maddi.p(appId, itsName,
                                     args[1],
                                     args[2],
                                     token,
                                     if args[3] = "T" then true else false,
                                     args[4],
                                     output s).

         end.

    when {&mnuSepType}:u then do:

        run {&mdir}/_msepnm.p(appId, output itsName).
        run {&mdir}/_maddi.p(appId, {&mnuSepFeature},
                                    args[1],
                                    itsName,
                                    {&mnuSepType},
                                    FALSE,
                                    "",
                                    output s).
         end.

    end.
    
end.

input stream mStream close.

/*
 * All the records have been created. Now instantiate the toolbar and menus
 */

run {&mdir}/_mupdatm.p(appId).
run {&mdir}/_mupdatt.p(appId).

/* _mread.p -  end of file */
