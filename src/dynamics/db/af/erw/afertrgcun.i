/* Generated by ICF ERwin Template */
/* %Parent %VerbPhrase %Child ON CHILD UPDATE SET NULL */
IF NEW %Child OR %ForEachFKAtt( OR ) { %Child.%AttFieldName <> o_%Child.%AttFieldName } THEN
  DO:
    %If(%!=(%Child, %Parent)) {
    IF NOT(CAN-FIND(FIRST %Parent WHERE
        %JoinFKPK(%Child,%Parent," = "," and"))) THEN DO:
        %ForEachFKAtt(".") {
        ASSIGN %If(%==(%Substr(%AttDomain,1,1), s)) {%Child.%AttFieldName = "":U }%If(%==(%Substr(%AttDomain,1,1), d)) {%Child.%AttFieldName = ? }%If(%==(%Substr(%AttDomain,1,1), l)) {%Child.%AttFieldName = ? }%If(%==(%Substr(%AttDomain,1,1), n)) {%Child.%AttFieldName = 0 }%If(%==(%Substr(%AttDomain,1,1), o)) { %Child.%AttFieldName = 0 }}.
    END.
    }
    %If(%==(%Child, %Parent)) {
    IF NOT(CAN-FIND(FIRST lb_table WHERE
        %JoinFKPK(%Child,lb_table," = "," and"))) THEN DO:
        %ForEachFKAtt(".") {
        ASSIGN %If(%==(%Substr(%AttDomain,1,1), s)) {%Child.%AttFieldName = "":U }%If(%==(%Substr(%AttDomain,1,1), d)) {%Child.%AttFieldName = ? }%If(%==(%Substr(%AttDomain,1,1), l)) {%Child.%AttFieldName = ? }%If(%==(%Substr(%AttDomain,1,1), n)) {%Child.%AttFieldName = 0 }%If(%==(%Substr(%AttDomain,1,1), o)) { %Child.%AttFieldName = 0 }}.
    END.
    }
  END.
