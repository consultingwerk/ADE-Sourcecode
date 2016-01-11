POSSE Application Compiler README

OVERVIEW

The POSSE Application Compiler - "pbuild" - is used to compile
Progress 4GL code into either graphical or character UI mode
r-code procedure libraries.  By default, all 4GL code is compiled
from the POSSE source repository into a UI-specific subdirectory in
the POSSE root directory as defined by $POSSE.  It can also be run
against one or more specific components.


MINIMUM RUNTIME REQUIREMENTS

- Any supported Progress 9.1C platform (Windows or Unix).
- Progress ProVision v9.1C with latest patch (Windows).
- Progress 4GL Development System v9.1C with latest patch (Unix).
- On Windows, you must have a Unix shell environment such as
  Cygwin or MKS Toolkit installed.
- The environment variable $DLC must be defined, and point to the
  directory where Progress 9.1C is installed.
- The environment variable $POSSE must be defined, and point to the
  POSSE root directory where the src subdirectory exists.

COMMAND SYNTAX

pbuild [uimode=<gui|tty>] [apps="app1 app2 ... appn"]

  uimode=gui creates graphical user interface r-code (Windows only, default)
  uimode=tty creates character user interface r-code (Unix default)

  component-list is an optional space-separated list of POSSE component
  subdirectories to compile.  The default is to compile all applicable
  components for either tty or gui user interface r-code.

EXAMPLES 

  pbuild

  This command compiles all POSSE code into r-code and/or procedure
  libraries for the platform-default user interface mode (gui on
  Windows, tty on Unix).

  pbuild uimode=tty apps=prodict

  This command compiles the POSSE data dictionary component "prodict"
  in character mode.

NOTES

  On Windows, the typical installation of ProVision does not install the
  character mode client.  You must run install with custom or complete
  to compile character mode applications on windows.

