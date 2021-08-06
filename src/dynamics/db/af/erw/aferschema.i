%ForEachEntity() {%If(%!=(%entityprop("TableFLA"),%entityprop("XYZ"))){
UPDATE TABLE "%tablename"
  TABLE-TRIGGER "CREATE" OVERRIDE PROCEDURE "%SubjectAreaProp(TriggerRel)%entityprop("TableFLA")trigc.p" CRC "?"
  TABLE-TRIGGER "DELETE" OVERRIDE PROCEDURE "%SubjectAreaProp(TriggerRel)%entityprop("TableFLA")trigd.p" CRC "?"
  TABLE-TRIGGER "WRITE" OVERRIDE PROCEDURE "%SubjectAreaProp(TriggerRel)%entityprop("TableFLA")trigw.p" CRC "?"}
%If(%Or(%==(%entityprop("VersionData"),YES),%!=(%entityprop("ReplicateFLA"),%entityprop("XYZ")))){
UPDATE TABLE "%tablename"
  TABLE-TRIGGER "REPLICATION-CREATE" OVERRIDE PROCEDURE "%SubjectAreaProp(TriggerRel)%entityprop("TableFLA")replc.p" CRC "?"
  TABLE-TRIGGER "REPLICATION-DELETE" OVERRIDE PROCEDURE "%SubjectAreaProp(TriggerRel)%entityprop("TableFLA")repld.p" CRC "?"
  TABLE-TRIGGER "REPLICATION-WRITE" OVERRIDE PROCEDURE "%SubjectAreaProp(TriggerRel)%entityprop("TableFLA")replw.p" CRC "?"}
%Decl(lv_order,0)
%ForEachAtt()
{
  %=(lv_order,%+(%:lv_order,10))
  UPDATE FIELD %AttFieldName OF %tablename  ORDER %:lv_order
}
}
%If(%Or(%==(%subjectareaprop("DBlogical"),"ICFDB"),%==(%subjectareaprop("DBlogical"),"RVDB"))) {
ADD SEQUENCE "seq_obj1"
  INITIAL 0
  INCREMENT 1
  CYCLE-ON-LIMIT yes
  MIN-VAL 0
  MAX-VAL 999999999

ADD SEQUENCE "seq_obj2"
  INITIAL 0
  INCREMENT 1
  CYCLE-ON-LIMIT yes
  MIN-VAL 0
  MAX-VAL 999999999

ADD SEQUENCE "seq_site_reverse"
  INITIAL 0
  INCREMENT 1
  CYCLE-ON-LIMIT yes
  MIN-VAL 0
  MAX-VAL 999999999

ADD SEQUENCE "seq_site_division"
  INITIAL 0
  INCREMENT 1
  CYCLE-ON-LIMIT yes
  MIN-VAL 0
  MAX-VAL 999999999

ADD SEQUENCE "seq_session_id"
  INITIAL 1
  INCREMENT 1
  CYCLE-ON-LIMIT yes
  MIN-VAL 1
  MAX-VAL 999999999
}
