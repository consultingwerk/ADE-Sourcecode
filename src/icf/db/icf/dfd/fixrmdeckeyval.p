/* this program totally removes given attributes from a repository 
   including its values wherever used -- just assign them in cList */
   
DEFINE VARIABLE cList AS CHARACTER  NO-UNDO.

cList = "CurrentDescValue,CurrentKeyValue".

FOR EACH ryc_attribute WHERE 
    CAN-DO(cList,ryc_attribute.attribute_label):

    FOR EACH ryc_attribute_value OF ryc_attribute:
        DELETE ryc_attribute_value.
    END.

    DELETE ryc_attribute.
END.

/* 
  Below list ado issues and which attributes they delete:
  MAR/13/2003 Issue 9358 - CurrentDescValue,CurrentKeyValue 
*/
