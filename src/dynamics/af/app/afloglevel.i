/* Copyright (C) 2006 Progress Software Corporation.  All Rights Reserved. */
/*------------------------------------------------------------------------
    File        : afloglevel.i
    Purpose     : Dumps sequence values for a 

    Author(s)   : pjudge
    Created     : 8/1/2006
    Notes       : Created from scratch
  ----------------------------------------------------------------------*/
&global-define LOG-LEVEL-FATAL          1
&global-define LOG-LEVEL-CRITICAL       2
&global-define LOG-LEVEL-WARNING        4
&global-define LOG-LEVEL-MESSAGE        8
&global-define LOG-LEVEL-INFO           16
&global-define LOG-LEVEL-DEBUG          32

/* Used to convert the LogLevel from the config XML file into */
&global-define LOG-LEVEL-ENUM FATAL,{&LOG-LEVEL-FATAL},CRITICAL,{&LOG-LEVEL-CRITICAL},WARNING,{&LOG-LEVEL-WARNING},~
                              MESSAGE,{&LOG-LEVEL-MESSAGE},INFO,{&LOG-LEVEL-INFO},DEBUG,{&LOG-LEVEL-DEBUG}  