/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* af/sup2/afcheckerr.i - to check for errors and handle them. */
&IF DEFINED(display-error) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&display-error}
  &SCOPED-DEFINE display-error {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(message-type) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&message-type}
  &SCOPED-DEFINE message-type {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(define-only) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&define-only}
  &SCOPED-DEFINE define-only {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(errors-not-zero) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&errors-not-zero}
  &SCOPED-DEFINE errors-not-zero {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(ignore-errorlist) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&ignore-errorlist}
  &SCOPED-DEFINE ignore-errorlist {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(default-answer) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&default-answer}
  &SCOPED-DEFINE default-answer {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(message-buttons) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&message-buttons}
  &SCOPED-DEFINE message-buttons {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(button-default) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&button-default}
  &SCOPED-DEFINE button-default {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(button-cancel) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&button-cancel}
  &SCOPED-DEFINE button-cancel {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(message-title) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&message-title}
  &SCOPED-DEFINE message-title {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(message-datatype) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&message-datatype}
  &SCOPED-DEFINE message-datatype {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(message-format) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&message-format}
  &SCOPED-DEFINE message-format {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(display-empty) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&display-empty}
  &SCOPED-DEFINE display-empty {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(NO-RETURN) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&NO-RETURN}
  &SCOPED-DEFINE NO-RETURN {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(return-error) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&return-error}
  &SCOPED-DEFINE return-error {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(return-only) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&return-only}
  &SCOPED-DEFINE return-only {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF

{checkerr.i}
