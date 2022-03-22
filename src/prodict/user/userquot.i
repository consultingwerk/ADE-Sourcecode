/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* userquot.i - a portion of a form used by _usrquot.p in two places */

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
&SCOPED-DEFINE SPACER SPACE(.2)
&SCOPED-DEFINE LINEUP 2
&ELSE
&SCOPED-DEFINE SPACER 
&SCOPED-DEFINE LINEUP 4
&ENDIF

l[ 1] AT {&LINEUP} {&SPACER} "to" {&SPACER} u[ 1] SPACE(4)
l[ 2]              {&SPACER} "to" {&SPACER} u[ 2] SPACE(4)
l[ 3]              {&SPACER} "to" {&SPACER} u[ 3] SPACE(4)
l[ 4]              {&SPACER} "to" {&SPACER} u[ 4]
		SKIP({&VM_WID})  
l[ 5] AT {&LINEUP} {&SPACER} "to" {&SPACER} u[ 5] SPACE(4)
l[ 6]              {&SPACER} "to" {&SPACER} u[ 6] SPACE(4)
l[ 7]              {&SPACER} "to" {&SPACER} u[ 7] SPACE(4)
l[ 8]              {&SPACER} "to" {&SPACER} u[ 8]
		SKIP({&VM_WID})  
l[ 9] AT {&LINEUP} {&SPACER} "to" {&SPACER} u[ 9] SPACE(4)
l[10]              {&SPACER} "to" {&SPACER} u[10] SPACE(4)
l[11]              {&SPACER} "to" {&SPACER} u[11] SPACE(4)
l[12]              {&SPACER} "to" {&SPACER} u[12]
		SKIP({&VM_WID})  
l[13] AT {&LINEUP} {&SPACER} "to" {&SPACER} u[13] SPACE(4)
l[14]              {&SPACER} "to" {&SPACER} u[14] SPACE(4)
l[15]              {&SPACER} "to" {&SPACER} u[15] SPACE(4)
l[16]              {&SPACER} "to" {&SPACER} u[16]
		SKIP({&VM_WID}) 
l[17] AT {&LINEUP} {&SPACER} "to" {&SPACER} u[17] SPACE(4)
l[18]              {&SPACER} "to" {&SPACER} u[18] SPACE(4)
l[19]              {&SPACER} "to" {&SPACER} u[19] SPACE(4)
l[20]              {&SPACER} "to" {&SPACER} u[20]
		SKIP({&VM_WID}) 
l[21] AT {&LINEUP} {&SPACER} "to" {&SPACER} u[21] SPACE(4)
l[22]              {&SPACER} "to" {&SPACER} u[22] SPACE(4)
l[23]              {&SPACER} "to" {&SPACER} u[23] SPACE(4)
l[24]              {&SPACER} "to" {&SPACER} u[24]
