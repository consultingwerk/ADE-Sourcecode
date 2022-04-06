/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* dirlist.p - displays a list of the files in a directory */

def var dirname as character.
def var dirname2 as character.
def var i as integer.
def var dosort as logical.

hide all.

dirloop:
repeat:

    if lookup(opsys, "MSDOS,OS2,WIN32") > 0 then do:

        dosort = no.
        update
            skip(1)
            dirname label "Directory" format "x(50)" colon 15
            "(Blank to list the current working directory)" colon 15
            skip(1)
            dosort  label "Sort Entries?" colon 15
            "(Requires that the DOS/OS2 SORT command be accessible)" colon 15

            with frame din side-labels attr-space centered
                title "  Enter the Directory to be Listed  ".

        dirname2 = caps(dirname).
        repeat: /* convert slashes to backslashes in directory specification */
            i = index(dirname2,"/").
            if i = 0 then leave.
            dirname2 = substr(dirname2,1,i - 1) + "~\" + substr(dirname2,i + 1).
        end.
        if dosort and lookup(opsys, "MSDOS,OS2,WIN32") > 0 then
            os-command dir value(dirname2) | sort.
        else if lookup(opsys, "MSDOS,OS2,WIN32") > 0 then
            os-command dir value(dirname2) /w /p.
    end.
    else
    if opsys = "UNIX" or opsys = "VMS" or opsys = "BTOS" then do:
        update
            skip(1)
            dirname label "Directory" format "x(50)" colon 15
            "(Blank to list the current working directory)" colon 15
            skip(1)
            with frame uin side-labels attr-space centered
                title "  Enter the Directory to be Listed  ".
       if opsys = "UNIX" then unix ls  value(dirname).
       if opsys = "VMS"  then vms  dir value(dirname).
       if opsys = "BTOS" then do:
           if length(dirname) > 0 then do:
               if substring(dirname,length(dirname),1) = ">" then
                  dirname = dirname + "*".
           end.
           btos [sys]<sys>files.run files value(dirname).

       end.
    end.
    else MESSAGE OPSYS + " is an unsupported operating system.".

end.
