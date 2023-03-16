/************************************************
Copyright (c) 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : OsErrorEnum
    Purpose     : Enumeration of OS-ERROR values
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2022-03-01
    Notes       : * Based on the documentation at https://docs.progress.com/bundle/openedge-abl-reference-122/page/OS-ERROR-function.html
  ----------------------------------------------------------------------*/

enum OpenEdge.Core.OsErrorEnum :
    define enum NoError                 = 0
                
                NotOwner                = 1
                NoSuchFileOrDirectory   = 2
                InterruptedSystemCall   = 3
                IOError                 = 4
                BadFileNumber           = 5
                NoMoreProcesses         = 6
                NotEnoughCoreMemory     = 7
                PermissionDenied        = 8
                BadAddress              = 9
                FileExists              = 10
                NoSuchDevice            = 11
                NotADirectory           = 12
                IsADirectory            = 13
                FileTableOverflow       = 14
                TooManyOpenFiles        = 15
                FileTooLarge            = 16
                NoSpaceLeftOnDevice     = 17
                DirectoryNotEmpty       = 18
                
                UnmappedError           = 999
                
                Default                 = UnmappedError
                .
end enum.