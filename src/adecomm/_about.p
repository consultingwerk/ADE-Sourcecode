/*********************************************************************
* Copyright (C) 2000-2001 by Progress Software Corporation ("PSC"),  *
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
/*
Procedure:    adecomm/_about.p
Author:       R. Ryan
Created:      1/95
Purpose:      re-written by Bob Ryan 1/95 to look better under 3-D
              and provide some Windows environment info
*/

&SCOPED-DEFINE FRAME-NAME  Dialog-1

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  &SCOPED-DEFINE StartRow 6
  &SCOPED-DEFINE StartCol 4
  &SCOPED-DEFINE OKBtnRow 8.5
&ELSE
  &SCOPED-DEFINE StartRow 5
  &SCOPED-DEFINE StartCol 11.57
  &SCOPED-DEFINE OKBtnRow 7.5
&ENDIF

{adecomm/adestds.i}

DEFINE INPUT PARAMETER pTitle AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pIcon  AS CHARACTER NO-UNDO.

DEFINE VARIABLE result       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE AboutText1   AS CHARACTER FORMAT "x(50)" NO-UNDO.
DEFINE VARIABLE AboutText2   AS CHARACTER FORMAT "x(50)" NO-UNDO.
DEFINE VARIABLE Label1       AS CHARACTER FORMAT "x(50)" VIEW-AS TEXT.
DEFINE VARIABLE Label2       AS CHARACTER FORMAT "x(50)" VIEW-AS TEXT.
DEFINE VARIABLE DBEtestvalue AS CHARACTER NO-UNDO.
DEFINE VARIABLE ProName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE ABLic        AS INTEGER   NO-UNDO.
DEFINE VARIABLE ABTools      AS CHARACTER NO-UNDO.
DEFINE VARIABLE Workshop-only AS LOGICAL  NO-UNDO.

DEFINE VARIABLE majorversion  AS INTEGER   NO-UNDO.
DEFINE VARIABLE minorversion  AS CHARACTER NO-UNDO.
DEFINE VARIABLE dot           AS INTEGER   NO-UNDO.
DEFINE VARIABLE patchlevel    AS CHARACTER NO-UNDO.
DEFINE VARIABLE POSSEVersion  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTextFile     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCommercialVer   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLine         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lICF          AS LOGICAL    NO-UNDO.


DEFINE IMAGE AboutImage &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                           SIZE-PIXELS 32 BY 32.
                         &ELSE
                           SIZE-PIXELS 42 BY 42.
                         &ENDIF

DEFINE RECTANGLE TopLine    
  EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL SIZE 50 BY .08.
DEFINE RECTANGLE BottomLine LIKE TopLine.
DEFINE RECTANGLE ContainerRectangle
  EDGE-PIXELS 2 SIZE-PIXELS 40 BY 40 BGCOLOR 8.

DEFINE BUTTON BtnOK AUTO-END-KEY
  LABEL "OK":l SIZE 10 BY 1.

DEFINE FRAME Dialog-1
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  ContainerRectangle AT ROW 1.5 COLUMNS 3
  AboutImage AT ROW 1.67 COLUMNS 3.57
  AboutText1 NO-LABELS AT ROW 1.75 COLUMNS {&StartCol}
             VIEW-AS EDITOR SIZE 50 BY 6 NO-BOX
  SKIP
  AboutText2 NO-LABELS AT {&StartCol}
             VIEW-AS EDITOR SIZE 50 BY 5 SCROLLBAR-VERTICAL
  SKIP(1)
  TopLine AT 11 SKIP(0.5)
  Label1 AT {&StartCol} NO-LABELS SKIP(.15)
  Label2 AT {&StartCol} NO-LABELS SKIP(0.5)
  BottomLine AT 11 SKIP(1)
  BtnOK AT 27 SKIP(1)
  WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
  SIDE-LABELS NO-UNDERLINE SCROLLABLE DEFAULT-BUTTON BtnOK.
&ELSE
  ContainerRectangle AT ROW 1.5 COLUMNS 3
  AboutText1 NO-LABELS AT ROW 1.75 COLUMNS {&StartCol}
             VIEW-AS EDITOR SIZE 50 BY 6
  SKIP
  AboutText2 NO-LABELS AT {&StartCol}
             VIEW-AS EDITOR SIZE 50 BY 5 SCROLLBAR-VERTICAL
  SKIP
  TopLine AT 11     SKIP
  BottomLine AT 11  SKIP(1)
  BtnOK AT 27       SKIP
  WITH VIEW-AS DIALOG-BOX SIDE-LABELS DEFAULT-BUTTON BtnOK.
&ENDIF

 
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT EQ ? THEN
  FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} 
  APPLY "END-ERROR":u TO SELF.

/*---------------------------------------------------------------------------*/
main-block:
DO ON ERROR   UNDO main-block, LEAVE main-block
   ON END-KEY UNDO main-block, LEAVE main-block:

  /* general assignments... */
  ASSIGN
    FRAME {&FRAME-NAME}:THREE-D = SESSION:THREE-D
    FRAME {&FRAME-NAME}:TITLE   = "About " + pTitle
    BtnOK:WIDTH                 = IF SESSION:WINDOW-SYSTEM = "TTY":u THEN 
                                    4 ELSE 14
    BtnOK:HEIGHT                = IF SESSION:WINDOW-SYSTEM = "TTY":u THEN 
                                    1 ELSE 1.14
    BtnOK:X                     = (FRAME {&FRAME-NAME}:WIDTH-PIXELS / 2) 
                                - (BtnOK:WIDTH-PIXELS / 2).

  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    ASSIGN
      AboutImage:AUTO-RESIZE = TRUE
      result                 = AboutImage:LOAD-IMAGE(pIcon).

    /* Check for WebSpeed Workshop */
    RUN adeshar/_ablic.p (INPUT NO /* ShowMsgs */ , OUTPUT ABLic, OUTPUT ABTools).
    IF ABLic = 2 THEN Workshop-Only = TRUE.
    ELSE Workshop-Only = FALSE.
  &ENDIF 

 RUN GetPatchLevel(OUTPUT patchLevel). /* Read patch level from version file */

 IF Workshop-Only THEN
 DO:
   ASSIGN dot          = INDEX(PROVERSION,".":U)
          majorversion = INT(SUBSTRING(PROVERSION,1,(dot - 1)))
          minorversion = SUBSTRING(PROVERSION,(dot + 1))
          ProName      = "WebSpeed Workshop ":U + 
            STRING(majorversion - 6) + ".":U + minorversion + patchLevel.
 END.
 ELSE
 DO:
 /* Are we running with DBE PROGRESS or not? Test the LENGTH of a value 
   * that is double byte in all 4 languages.  If the RAW LENGTH equals the 
   * character LENGTH, then either the core is not DBE, or the character 
   * set is not one of the 4...
   */
  ASSIGN
    DBEtestvalue = CHR(224) + CHR(164)

    ProName      = IF ( OPSYS <> "WIN32" OR SESSION:DISPLAY-TYPE <> "TTY" OR SESSION:BATCH)
                      AND LENGTH(DBEtestvalue,"CHARACTER":u) <>
                          LENGTH(DBEtestvalue,"RAW":u) THEN
                     "DBE PROGRESS ":u + pTitle
                   ELSE
                     "PROGRESS ":u + pTitle.
  END.
  
  /* Read the commercial version from the "version" text file */
  /* This is going to pick up either Dynamics or DLC version  */
  ASSIGN 
      cTextFile = SEARCH("version":U)
      cCommercialVer = "".
  IF cTextFile <> "" AND ctextFile <> ? THEN DO:
      INPUT FROM VALUE(cTextFile) NO-ECHO.
      REPEAT:
          IMPORT UNFORMATTED cLine.
          ASSIGN cCommercialVer = cCommercialVer + cLine + CHR(10).
      END.
      INPUT CLOSE.
  END.

  /* If this is MS-WINDOWS, go out and make some WIN API calls */
  IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":u THEN
    RUN adecomm/_winsys.p (OUTPUT Label1, OUTPUT Label2).
  ELSE
    ASSIGN
      Label1 = "Use the ""showcfg"" utility at the operating " +
               "system prompt for licensing information.".
  
  RUN Realize.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

HIDE FRAME Dialog-1.

RETURN.

/*---------------------------------------------------------------------------*/
PROCEDURE Realize:
    
DO WITH FRAME {&FRAME-NAME}:
  AboutText1 =
    ProName + CHR(10) +

    (IF Workshop-Only
     THEN pTitle + " (Build: ":U + PROVERSION + patchLevel + ")":U 
     ELSE (IF INTEGER(ENTRY(1,PROVERSION,".")) > 9 THEN "Release ":U ELSE "Version ":U) + PROVERSION + patchLevel
    ) + CHR(10) + CHR(10) +
    (IF cCommercialVer <> "" AND cCommercialVer <> ?
     THEN cCommercialVer + CHR(10) 
     ELSE ""
    ) +
    (IF POSSEVersion <> "" AND POSSEVersion <> ? 
     THEN ("POSSE Version ":U + POSSEVersion + CHR(10) ) 
     ELSE ""
    )  + 
    "Copyright (c) 1984-" + STRING(YEAR(TODAY)) + " Progress Software Corp." + CHR(10) +
    "All rights reserved" + CHR(10).

  IF NOT SESSION:WINDOW-SYSTEM BEGINS "TTY":u THEN
      AboutText2 = 
        "Raster Imaging Technology copyrighted by Snowbound Software 1993-2000. " +
        "Raster imaging technology by SnowboundSoftware.com. " +
         CHR(10) + CHR(10) +
        "© 1988-2003 SlickEdit Inc.  All rights reserved.  CONFIDENTIAL AND " +
        "PROPRIETARY.  SLICKEDIT and VISUAL SLICKEDIT are trademarks of " +
        "SlickEdit Inc.  The VISUAL SLICKEDIT software product and related " +
        "copyrights and trademarks are under license from SlickEdit Inc." +
         CHR(10) + CHR(10).

  AboutText2 = AboutText2 +
        "International Classes for Unicode:" + CHR(10) + 
        "Copyright © 1999, International Business Machines Corporation and " +
        "others. All rights reserved. " +
         CHR(10) + CHR(10) +
        "DataDirect Drivers:" + CHR(10) +
        "Portions of this software are copyrighted by DataDirect Technologies, " +
        "1991-2002. " +
         CHR(10) + CHR(10) +
        "JAVA Runtime & JDK:" + CHR(10) +
        "This product includes code licensed from RSA Security, Inc. " +
        "Some portions licensed from IBM are available at " +
        "http://oss.software.ibm.com/icu4j/ " +
         CHR(10) + CHR(10) +
        "HTTP package from W3C Consortium:" + CHR(10) +
        "This product includes software developed by the World Wide Web " +
        "Consortium. " +
        "Copyright C 1994-2002 World Wide Web Consortium, (Massachusetts " +
        "Institute of Technology, Institut National de Recherche en " +
        "Informatique et en Automatique, Keio University), " +
        "http://www.w3.org/Consortium/Legal/. All rights reserved. " +
      CHR(10) + CHR(10).
  
AboutText2 = AboutText2 + 'HTTP Client:'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'GNU LESSER GENERAL PUBLIC LICENSE'.
AboutText2 = AboutText2 + 'Version 2.1, February 1999'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'Copyright (C) 1991, 1999 Free Software Foundation, Inc. 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA'.
AboutText2 = AboutText2 + ' '.
AboutText2 = AboutText2 + 'Everyone is permitted to copy and distribute verbatim copies of this license document, but changing it is not allowed.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '[This is the first released version of the Lesser GPL.  It also counts as the successor of the GNU Library Public License, version 2, hence the version number 2.1.]'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'Preamble'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'The licenses for most software are designed to take away your freedom to share and change it.  By contrast, the GNU General Public Licenses are intended to guarantee your freedom to share and change free software--to make sure the software is free for all its users.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'This license, the Lesser General Public License, applies to some specially designated software packages--typically libraries--of the Free Software Foundation and other authors who decide to use it.  You can use it too, but we suggest you first think carefully about whether this license or the ordinary General Public License is the better strategy to use in any particular case, based on the explanations below.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'When we speak of free software, we are referring to freedom of use, not price.  Our General Public Licenses are designed to make sure that you have the freedom to distribute copies of free software (and charge for this service if you wish); that you receive source code or can get it if you want it; that you can change the software and use pieces of it in new free programs; and that you are informed that you can do these things.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'To protect your rights, we need to make restrictions that forbid distributors to deny you these rights or to ask you to surrender these rights.  These restrictions translate to certain responsibilities for you if you distribute copies of the library or if you modify it.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'For example, if you distribute copies of the library, whether gratis or for a fee, you must give the recipients all the rights that we gave you.  You must make sure that they, too, receive or can get the source code.  If you link other code with the library, you must provide complete object files to the recipients, so that they can relink them with the library after making changes to the library and recompiling it.  And you must show them these terms so they know their rights.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'We protect your rights with a two-step method: (1) we copyright the library, and (2) we offer you this license, which gives you legal permission to copy, distribute and/or modify the library.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'To protect each distributor, we want to make it very clear that there is no warranty for the free library.  Also, if the library is modified by someone else and passed on, the recipients should know that what they have is not the original version, so that the original author''s reputation will not be affected by problems that might be introduced by others.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'Finally, software patents pose a constant threat to the existence of any free program.  We wish to make sure that a company cannot effectively restrict the users of a free program by obtaining a restrictive license from a patent holder.  Therefore, we insist that any patent license obtained for a version of the library must be consistent with the full freedom of use specified in this license.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'Most GNU software, including some libraries, is covered by the ordinary GNU General Public License.  This license, the GNU Lesser General Public License, applies to certain designated libraries, and is quite different from the ordinary General Public License.  We use this license for certain libraries in order to permit linking those libraries into non-free programs.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'When a program is linked with a library, whether statically or using a shared library, the combination of the two is legally speaking a combined work, a derivative of the original library.  The ordinary General Public License therefore permits such linking only if the entire combination fits its criteria of freedom.  The Lesser General Public License permits more lax criteria for linking other code with the library.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'We call this license the "Lesser" General Public License because it does Less to protect the user''s freedom than the ordinary General Public License.  It also provides other free software developers Less of an advantage over competing non-free programs.  These disadvantages are the reason we use the ordinary General Public License for many libraries.  However, the Lesser license provides advantages in certain special circumstances.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'For example, on rare occasions, there may be a special need to encourage the widest possible use of a certain library, so that it becomes a de-facto standard.  To achieve this, non-free programs must be allowed to use the library.  A more frequent case is that a free library does the same job as widely used non-free libraries.  In this case, there is little to gain by limiting the free library to free software only, so we use the Lesser General Public License.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'In other cases, permission to use a particular library in non-free programs enables a greater number of people to use a large body of free software.  For example, permission to use the GNU C Library in non-free programs enables many more people to use the whole GNU operating system, as well as its variant, the GNU/Linux operating system.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'Although the Lesser General Public License is Less protective of the users'' freedom, it does ensure that the user of a program that is linked with the Library has the freedom and the wherewithal to run that program using a modified version of the Library.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'The precise terms and conditions for copying, distribution and modification follow.  Pay close attention to the difference between a "work based on the library" and a "work that uses the library".  The former contains code derived from the library, whereas the latter must be combined with the library in order to run.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'GNU LESSER GENERAL PUBLIC LICENSE'.
AboutText2 = AboutText2 + 'TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '0.	This License Agreement applies to any software library or other program, which contains a notice, placed by the copyright holder or other authorized party saying it may be distributed under the terms of this Lesser General Public License (also called "this License").  Each licensee is addressed as "you".'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'A "library" means a collection of software functions and/or data prepared so as to be conveniently linked with application programs (which use some of those functions and data) to form executables.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'The "Library", below, refers to any such software library or work which has been distributed under these terms.  A "work based on the Library" means either the Library or any derivative work under copyright law: that is to say, a work containing the Library or a portion of it, either verbatim or with modifications and/or translated straightforwardly into another language.  (Hereinafter, translation is included without limitation in the term "modification".)'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '"Source code" for a work means the preferred form of the work for making modifications to it.  For a library, complete source code means all the source code for all modules it contains, plus any associated interface definition files, plus the scripts used to control compilation and installation of the library.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'Activities other than copying, distribution and modification are not covered by this License; they are outside its scope.  The act of running a program using the Library is not restricted, and output from such a program is covered only if its contents constitute a work based on the Library (independent of the use of the Library in a tool for writing it).  Whether that is true depends on what the Library does and what the program that uses the Library does.'.
AboutText2 = AboutText2 + '  '.
AboutText2 = AboutText2 + '1.	You may copy and distribute verbatim copies of the Library''s complete source code as you receive it, in any medium, provided that you conspicuously and appropriately publish on each copy an appropriate copyright notice and disclaimer of warranty; keep intact all the notices that refer to this License and to the absence of any warranty; and distribute a copy of this License along with the Library.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'You may charge a fee for the physical act of transferring a copy, and you may at your option offer warranty protection in exchange for a fee.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '2.	You may modify your copy or copies of the Library or any portion of it, thus forming a work based on the Library, and copy and distribute such modifications or work under the terms of Section 1 above, provided that you also meet all of these conditions:'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'a)	The modified work must itself be a software library.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'b)	You must cause the files modified to carry prominent notices stating that you changed the files and the date of any change.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'c)	You must cause the whole of the work to be licensed at no charge to all third parties under the terms of this License.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'd)	If a facility in the modified Library refers to a function or a table of data to be supplied by an application program that uses the facility, other than as an argument passed when the facility is invoked, then you must make a good faith effort to ensure that, in the event an application does not supply such function or table, the facility still operates, and performs whatever part of its purpose remains meaningful.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '(For example, a function in a library to compute square roots has a purpose that is entirely well-defined independent of the application.  Therefore, Subsection 2d requires that any application-supplied function or table used by this function must be optional: if the application does not supply it, the square root function must still compute square roots.)'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'These requirements apply to the modified work as a whole.  If identifiable sections of that work are not derived from the Library, and can be reasonably considered independent and separate works in themselves, then this License, and its terms, do not apply to those sections when you distribute them as separate works.  But when you distribute the same sections as part of a whole which is a work based on the Library, the distribution of the whole must be on the terms of this License, whose permissions for other licensees extend to the entire whole, and thus to each and every part regardless of who wrote it.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'Thus, it is not the intent of this section to claim rights or contest your rights to work written entirely by you; rather, the intent is to exercise the right to control the distribution of derivative or collective works based on the Library.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'In addition, mere aggregation of another work not based on the Library with the Library (or with a work based on the Library) on a volume of a storage or distribution medium does not bring the other work under the scope of this License.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '3.	You may opt to apply the terms of the ordinary GNU General Public License instead of this License to a given copy of the Library.  To do this, you must alter all the notices that refer to this License, so that they refer to the ordinary GNU General Public License, version 2, instead of to this License.  (If a newer version than version 2 of the ordinary GNU General Public License has appeared, then you can specify that version instead if you wish.)  Do not make any other change in these notices.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'Once this change is made in a given copy, it is irreversible for that copy, so the ordinary GNU General Public License applies to all subsequent copies and derivative works made from that copy.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'This option is useful when you wish to copy part of the code of the Library into a program that is not a library.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '4.	You may copy and distribute the Library (or a portion or derivative of it, under Section 2) in object code or executable form under the terms of Sections 1 and 2 above provided that you accompany it with the complete corresponding machine-readable source code, which must be distributed under the terms of Sections 1 and 2 above on a medium customarily used for software interchange.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'If distribution of object code is made by offering access to copy from a designated place, then offering equivalent access to copy the source code from the same place satisfies the requirement to distribute the source code, even though third parties are not compelled to copy the source along with the object code.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '5.	A program that contains no derivative of any portion of the Library, but is designed to work with the Library by being compiled or linked with it, is called a "work that uses the Library".  Such a work, in isolation, is not a derivative work of the Library, and therefore falls outside the scope of this License.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'However, linking a "work that uses the Library" with the Library creates an executable that is a derivative of the Library (because it contains portions of the Library), rather than a "work that uses the library".  The executable is therefore covered by this License.'.
AboutText2 = AboutText2 + 'Section 6 states terms for distribution of such executables.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'When a "work that uses the Library" uses material from a header file that is part of the Library, the object code for the work may be a derivative work of the Library even though the source code is not.  Whether this is true is especially significant if the work can be linked without the Library, or if the work is itself a library.  The threshold for this to be true is not precisely defined by law.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '  If such an object file uses only numerical parameters, data'.
AboutText2 = AboutText2 + 'structure layouts and accessors, and small macros and small inline'.
AboutText2 = AboutText2 + 'functions (ten lines or less in length), then the use of the object'.
AboutText2 = AboutText2 + 'file is unrestricted, regardless of whether it is legally a derivative'.
AboutText2 = AboutText2 + 'work.  (Executables containing this object code plus portions of the'.
AboutText2 = AboutText2 + 'Library will still fall under Section 6.)'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'Otherwise, if the work is a derivative of the Library, you may distribute the object code for the work under the terms of Section 6.  Any executables containing that work also fall under Section 6, whether or not they are linked directly with the Library itself.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '6.	As an exception to the Sections above, you may also combine or link a "work that uses the Library" with the Library to produce a work containing portions of the Library, and distribute that work under terms of your choice, provided that the terms permit modification of the work for the customer''s own use and reverse engineering for debugging such modifications.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'You must give prominent notice with each copy of the work that the Library is used in it and that the Library and its use are covered by this License.  You must supply a copy of this License.  If the work during execution displays copyright notices, you must include the copyright notice for the Library among them, as well as a reference directing the user to the copy of this License.  Also, you must do one of these things:'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'a)	Accompany the work with the complete corresponding machine-readable source code for the Library including whatever changes were used in the work (which must be distributed under Sections 1 and 2 above); and, if the work is an executable linked with the Library, with the complete machine-readable "work that uses the Library", as object code and/or source code, so that the user can modify the Library and then relink to produce a modified executable containing the modified Library.  (It is understood that the user who changes the contents of definitions files in the Library will not necessarily be able to recompile the application to use the modified definitions.)'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'b)	Use a suitable shared library mechanism for linking with the Library.  A suitable mechanism is one that (1) uses at run time a copy of the library already present on the user''s computer system, rather than copying library functions into the executable, and (2) will operate properly with a modified version of the library, if the user installs one, as long as the modified version is interface-compatible with the version that the work was made with.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'c)	Accompany the work with a written offer, valid for at least three years, to give the same user the materials specified in Subsection 6a, above, for a charge no more than the cost of performing this distribution.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'd)	If distribution of the work is made by offering access to copy from a designated place, offer equivalent access to copy the above specified materials from the same place.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'e)	Verify that the user has already received a copy of these materials or that you have already sent this user a copy.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'For an executable, the required form of the "work that uses the Library" must include any data and utility programs needed for reproducing the executable from it.  However, as a special exception, the materials to be distributed need not include anything that is normally distributed (in either source or binary form) with the major components (compiler, kernel, and so on) of the operating system on which the executable runs, unless that component itself accompanies the executable.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'It may happen that this requirement contradicts the license restrictions of other proprietary libraries that do not normally accompany the operating system.  Such a contradiction means you cannot use both them and the Library together in an executable that you distribute.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '7.	You may place library facilities that are a work based on the Library side-by-side in a single library together with other library facilities not covered by this License, and distribute such a combined library, provided that the separate distribution of the work based on the Library and of the other library facilities is otherwise permitted, and provided that you do these two things:'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'a)	Accompany the combined library with a copy of the same work based on the Library, uncombined with any other library facilities.  This must be distributed under the terms of the Sections above.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'b)	Give prominent notice with the combined library of the fact that part of it is a work based on the Library, and explaining where to find the accompanying uncombined form of the same work.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '8.	You may not copy, modify, sublicense, link with, or distribute the Library except as expressly provided under this License.  Any attempt otherwise to copy, modify, sublicense, link with, or distribute the Library is void, and will automatically terminate your rights under this License.  However, parties who have received copies, or rights, from you under this License will not have their licenses terminated so long as such parties remain in full compliance.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '9.	You are not required to accept this License, since you have not signed it.  However, nothing else grants you permission to modify or distribute the Library or its derivative works.  These actions are prohibited by law if you do not accept this License.  Therefore, by modifying or distributing the Library (or any work based on the Library), you indicate your acceptance of this License to do so, and all its terms and conditions for copying, distributing or modifying the Library or works based on it.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '10.	Each time you redistribute the Library (or any work based on the Library), the recipient automatically receives a license from the original licensor to copy, distribute, link with or modify the Library subject to these terms and conditions.  You may not impose any further restrictions on the recipients'' exercise of the rights granted herein. You are not responsible for enforcing compliance by third parties with this License.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '11.	If, as a consequence of a court judgment or allegation of patent infringement or for any other reason (not limited to patent issues), conditions are imposed on you (whether by court order, agreement or otherwise) that contradict the conditions of this License, they do not excuse you from the conditions of this License.  If you cannot distribute so as to satisfy simultaneously your obligations under this License and any other pertinent obligations, then as a consequence you may not distribute the Library at all.  For example, if a patent license would not permit royalty-free redistribution of the Library by all those who receive copies directly or indirectly through you, then the only way you could satisfy both it and this License would be to refrain entirely from distribution of the Library.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'If any portion of this section is held invalid or unenforceable under any particular circumstance, the balance of the section is intended to apply, and the section as a whole is intended to apply in other circumstances.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'It is not the purpose of this section to induce you to infringe any patents or other property right claims or to contest validity of any such claims; this section has the sole purpose of protecting the integrity of the free software distribution system, which is implemented by public license practices.  Many people have made generous contributions to the wide range of software distributed through that system in reliance on consistent application of that system; it is up to the author/donor to decide if he or she is willing to distribute software through any other system and a licensee cannot impose that choice.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'This section is intended to make thoroughly clear what is believed to be a consequence of the rest of this License.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '12.	If the distribution and/or use of the Library is restricted in certain countries either by patents or by copyrighted interfaces, the original copyright holder who places the Library under this License may add an explicit geographical distribution limitation excluding those countries, so that distribution is permitted only in or among countries not thus excluded.  In such case, this License incorporates the limitation as if written in the body of this License.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '13.	The Free Software Foundation may publish revised and/or new versions of the Lesser General Public License from time to time.  Such new versions will be similar in spirit to the present version, but may differ in detail to address new problems or concerns.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'Each version is given a distinguishing version number.  If the Library specifies a version number of this License which applies to it and "any later version", you have the option of following the terms and conditions either of that version or of any later version published by the Free Software Foundation.  If the Library does not specify a license version number, you may choose any version ever published by the Free Software Foundation.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '14.	If you wish to incorporate parts of the Library into other free programs whose distribution conditions are incompatible with these, write to the author to ask for permission.  For software, which is copyrighted by the Free Software Foundation, write to the Free Software Foundation; we sometimes make exceptions for this.  Our decision will be guided by the two goals of preserving the free status of all derivatives of our free software and of promoting the sharing and reuse of software generally.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'NO WARRANTY'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '15. BECAUSE THE LIBRARY IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY FOR THE LIBRARY, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE LIBRARY "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE'.
AboutText2 = AboutText2 + 'LIBRARY IS WITH YOU.  SHOULD THE LIBRARY PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '16. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR REDISTRIBUTE THE LIBRARY AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE LIBRARY (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE LIBRARY TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'END OF TERMS AND CONDITIONS'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'How to Apply These Terms to Your New Libraries'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'If you develop a new library, and you want it to be of the greatest possible use to the public, we recommend making it free software that everyone can redistribute and change.  You can do so by permitting redistribution under these terms (or, alternatively, under the terms of the ordinary General Public License).'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'To apply these terms, attach the following notices to the library.  It is safest to attach them to the start of each source file to most effectively convey the exclusion of warranty; and each file should have at least the "copyright" line and a pointer to where the full notice is found.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '<one line to give the library''s name and a brief idea of what it does.>'.
AboutText2 = AboutText2 + 'Copyright (C) <year>  <name of author>'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'This library is free software; you can redistribute it and/or modify it under the terms o the GNU Lesser General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more details.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'Also add information on how to contact you by electronic and paper mail.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'You should also get your employer (if you work as a programmer) or your school, if any, to sign a "copyright disclaimer" for the library, if necessary.  Here is a sample; alter the names:'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'Yoyodyne, Inc., hereby disclaims all copyright interest in the library `Frob'' (a library for tweaking knobs) written by James Random Hacker.'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + '<signature of Ty Coon>, 1 April 1990'.
AboutText2 = AboutText2 + 'Ty Coon, President of Vice'.
AboutText2 = AboutText2 + CHR(10) + CHR(10).
AboutText2 = AboutText2 + 'That''s all there is to it!'.

  ASSIGN AboutText1:READ-ONLY = TRUE
         AboutText1:TAB-STOP  = NO   
         AboutText1:SENSITIVE = SESSION:WINDOW-SYSTEM <> "TTY":U
         AboutText2:READ-ONLY = TRUE
         AboutText2:TAB-STOP  = NO   
         AboutText2:SENSITIVE = SESSION:WINDOW-SYSTEM <> "TTY":U
         NO-ERROR.

  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  DISPLAY
    AboutText1
    AboutText2
    Label1 
    Label2 
    WITH FRAME {&FRAME-NAME}.
  &ELSE
  DISPLAY
    AboutText1
    AboutText2
    WITH FRAME {&FRAME-NAME}.
  &ENDIF

  /* Enable everything so we can test some enabled properties */
  ENABLE btnOK WITH FRAME {&FRAME-NAME}.

  IF FRAME {&FRAME-NAME}:THREE-D THEN
    ASSIGN
      ContainerRectangle:HIDDEN = FALSE
      result                    = ContainerRectangle:MOVE-TO-BOTTOM()
      TopLine:EDGE-PIXELS       = 2
      BottomLine:EDGE-PIXELS    = TopLine:EDGE-PIXELS.
  ELSE
    ASSIGN
      ContainerRectangle:HIDDEN = TRUE
      TopLine:EDGE-PIXELS       = 1
      BottomLine:EDGE-PIXELS    = TopLine:EDGE-PIXELS.
END. /* DO WITH FRAME */

END PROCEDURE.
  
PROCEDURE GetPatchLevel:
  /* Reads the Version file to see if there is a patch level */
  DEFINE OUTPUT PARAMETER patchLevel AS CHARACTER NO-UNDO.

  DEFINE VARIABLE i        AS INTEGER             NO-UNDO.
  DEFINE VARIABLE dlcValue AS CHARACTER           NO-UNDO. /* DLC */
  DEFINE VARIABLE inp      AS CHARACTER           NO-UNDO. /* hold 1st line of version file */
    
  IF OPSYS = "Win32":U THEN /* Get DLC from Registry */
    GET-KEY-VALUE SECTION "Startup":U KEY "DLC":U VALUE dlcValue.

  IF (dlcValue = "" OR dlcValue = ?) THEN DO:
    ASSIGN dlcValue = OS-GETENV("DLC":U). /* Get DLC from environment */
      IF (dlcValue = "" OR dlcValue = ?) THEN DO: /* Still nothing? */
        ASSIGN patchLevel = "".
        RETURN.
      END.
  END.
  FILE-INFO:FILE-NAME = dlcValue + "/version":U.
  IF FILE-INFO:FULL-PATHNAME NE ? THEN DO: /* Read the version file */
    INPUT FROM VALUE(FILE-INFO:FULL-PATHNAME).
      IMPORT UNFORMATTED inp. /* Get the first line */
    INPUT CLOSE.
    /* 
     * As of version 9.1D just append everything from the version file
     * after the version from PROVERSION property
     */
    LEVEL:
    DO i = 2 TO NUM-ENTRIES(inp," ":U):
      IF ENTRY(i,inp," ") BEGINS PROVERSION THEN DO:
        ASSIGN patchLevel = REPLACE(ENTRY(i,inp," "),PROVERSION,"").
        LEAVE LEVEL.
      END.
    END.
  END.         
END PROCEDURE.

&UNDEFINE FRAME-NAME

/* _about.p - end of file */






