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
