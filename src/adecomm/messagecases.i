/*************************************************************/
/* Copyright (c) 2014 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : messagecases.i
    Purpose     : All message view-as alert-box combinations with optional preprocessors for title and window
    Syntax      :
    Description : 
     Parameters  : preprocessors with variable names
        
                  &MessageField  mandatory
                  &ValueField  mandatory
                  &ErrorClass  Class name and constructor for otherwise error  
                  &TitleField  optional  
                  &HandleField optional 
    Author(s)   : 
    Created     : Tue Nov 25 2014
    Notes       :   
  ----------------------------------------------------------------------*/
 
 &if DEFINED(TitleField) <> 0 &THEN
     &SCOP TitleExp title {&TitleField}
 &ENDIF
 
 &if DEFINED(handlefield) <> 0 &THEN
     &SCOP WindowExp in window  {&HandleField}
 &ENDIF

case ({&TypeField} + "/":u + {&ButtonsField}):
              
    when "ERROR/YES-NO":u then
        message {&MessageField} view-as alert-box error buttons yes-no {&TitleExp} update {&ValueField} {&WindowExp}. 
    when "ERROR/YES-NO-CANCEL":u then
        message {&MessageField} view-as alert-box error buttons yes-no-cancel {&TitleExp} update {&ValueField} {&WindowExp}.
    when "ERROR/OK":u then
        message {&MessageField} view-as alert-box error buttons ok {&TitleExp} update {&ValueField} {&WindowExp}.
    when "ERROR/OK-CANCEL":u then
        message {&MessageField} view-as alert-box error buttons ok-cancel {&TitleExp} update {&ValueField} {&WindowExp}.
    when "ERROR/RETRY-CANCEL":u then
        message {&MessageField} view-as alert-box error buttons retry-cancel {&TitleExp} update {&ValueField} {&WindowExp}.
    
    when "INFORMATION/YES-NO":u then
        message {&MessageField} view-as alert-box information buttons yes-no {&TitleExp} update {&ValueField} {&WindowExp}.    
    when "INFORMATION/YES-NO-CANCEL":u then
        message {&MessageField} view-as alert-box information buttons yes-no-cancel {&TitleExp} update {&ValueField} {&WindowExp}.
    when "INFORMATION/OK":u then
        message {&MessageField} view-as alert-box information buttons ok {&TitleExp} update {&ValueField} {&WindowExp}.
    when "INFORMATION/OK-CANCEL":u then
        message {&MessageField} view-as alert-box information buttons ok-cancel {&TitleExp} update {&ValueField} {&WindowExp}.
    when "INFORMATION/RETRY-CANCEL":u then
        message {&MessageField} view-as alert-box information buttons retry-cancel {&TitleExp} update {&ValueField} {&WindowExp}.
    
    when "MESSAGE/YES-NO":u then
        message {&MessageField} view-as alert-box message buttons yes-no {&TitleExp} update {&ValueField} {&WindowExp}.
    when "MESSAGE/YES-NO-CANCEL":u then
        message {&MessageField} view-as alert-box message buttons yes-no-cancel {&TitleExp} update {&ValueField} {&WindowExp}.
    when "MESSAGE/OK":u then
        message {&MessageField} view-as alert-box message buttons ok {&TitleExp} update {&ValueField} {&WindowExp}.
    when "MESSAGE/OK-CANCEL":u then
        message {&MessageField} view-as alert-box message buttons ok-cancel {&TitleExp} update {&ValueField} {&WindowExp}.
    when "MESSAGE/RETRY-CANCEL":u then
        message {&MessageField} view-as alert-box message buttons retry-cancel {&TitleExp} update {&ValueField} {&WindowExp}.
    
    when "QUESTION/YES-NO":u then
        message {&MessageField} view-as alert-box question buttons yes-no {&TitleExp} update {&ValueField} {&WindowExp}.
    when "QUESTION/YES-NO-CANCEL":u then
        message {&MessageField} view-as alert-box question buttons yes-no-cancel {&TitleExp} update {&ValueField} {&WindowExp}.
    when "QUESTION/OK":u then
        message {&MessageField} view-as alert-box question buttons ok {&TitleExp} update {&ValueField} {&WindowExp}.
    when "QUESTION/OK-CANCEL":u then
        message {&MessageField} view-as alert-box question buttons ok-cancel {&TitleExp} update {&ValueField} {&WindowExp}.
    when "QUESTION/RETRY-CANCEL":u then
        message {&MessageField} view-as alert-box question buttons retry-cancel {&TitleExp} update {&ValueField} {&WindowExp}.
    
    when "WARNING/YES-NO":u then
        message {&MessageField} view-as alert-box warning buttons yes-no {&TitleExp} update {&ValueField} {&WindowExp}.
    when "WARNING/YES-NO-CANCEL":u then
        message {&MessageField} view-as alert-box warning buttons yes-no-cancel {&TitleExp} update {&ValueField} {&WindowExp}.
    when "WARNING/OK":u then
        message {&MessageField} view-as alert-box warning buttons ok {&TitleExp} update {&ValueField} {&WindowExp}.
    when "WARNING/OK-CANCEL":u then
        message {&MessageField} view-as alert-box warning buttons ok-cancel {&TitleExp} update {&ValueField} {&WindowExp}.
    when "WARNING/RETRY-CANCEL":u then
        message {&MessageField} view-as alert-box warning buttons retry-cancel {&TitleExp} update {&ValueField} {&WindowExp}.
    otherwise 
        undo, throw new {&ErrorClass}.
end case.        
        
        