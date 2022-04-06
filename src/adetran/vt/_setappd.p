/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Program Name: adetran\vt\_setappd.p
 * Description : Sets kit.xl_project.ApplDirectory to the unzip directory
 *               in a newly unzipped kit.
 * Written on  : 9/22/95
 * Author      : Gerry Seidl
 */
 DEFINE INPUT PARAMETER UNZipDir AS CHARACTER NO-UNDO.

 FIND FIRST kit.xl_project EXCLUSIVE-LOCK.
 ASSIGN kit.xl_project.RootDirectory = UNZipDir.   
 RETURN.
