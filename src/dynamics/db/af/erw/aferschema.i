%ForEachTable() {%If(%!=(%entityprop("TableFLA"),%entityprop("XYZ"))){
UPDATE TABLE "%tablename"
  TABLE-TRIGGER "CREATE" OVERRIDE PROCEDURE "%DiagramProp(TriggerRel)%entityprop("TableFLA")trigc.p" CRC "?"
  TABLE-TRIGGER "DELETE" OVERRIDE PROCEDURE "%DiagramProp(TriggerRel)%entityprop("TableFLA")trigd.p" CRC "?"
  TABLE-TRIGGER "WRITE" OVERRIDE PROCEDURE "%DiagramProp(TriggerRel)%entityprop("TableFLA")trigw.p" CRC "?"}
%If(%Or(%==(%entityprop("VersionData"),YES),%!=(%entityprop("ReplicateFLA"),%entityprop("XYZ")))){
UPDATE TABLE "%tablename"
  TABLE-TRIGGER "REPLICATION-CREATE" OVERRIDE PROCEDURE "%DiagramProp(TriggerRel)%entityprop("TableFLA")replc.p" CRC "?"
  TABLE-TRIGGER "REPLICATION-DELETE" OVERRIDE PROCEDURE "%DiagramProp(TriggerRel)%entityprop("TableFLA")repld.p" CRC "?"
  TABLE-TRIGGER "REPLICATION-WRITE" OVERRIDE PROCEDURE "%DiagramProp(TriggerRel)%entityprop("TableFLA")replw.p" CRC "?"}
}
%If(%Or(%==(%DiagramProp("DBlogical"),"ICFDB"),%==(%DiagramProp("DBlogical"),"RVDB"))) {
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
%If(%!=(%DiagramProp("DBVersion"),%entityprop("XYZ"))) {
ADD SEQUENCE "seq_%DiagramProp("DBlogical")_DBVersion"
  INITIAL %DiagramProp("DBVersion")
  INCREMENT 1
  CYCLE-ON-LIMIT yes
  MIN-VAL 0
  MAX-VAL %DiagramProp("DBVersion")
}

%File(%DiagramProp("RootDir")db\icf\dfd\%DiagramProp("DBlogical")%DiagramProp("DBVersion")rel.xml) {<?xml version="1.0" encoding="utf-8" ?>
<relationships>
%ForEachTable(){  <table TableName="%TableName" DBName="%DiagramProp("DBlogical")">
%ForEachParentRel() {   <relationship RelDir="PC">
      <relationship_reference>%RelLogProp("RelationshipRef")</relationship_reference>
      <relationship_description>%RelLogProp("RelationshipDesc")</relationship_description>
      <parent_entity>%Parent</parent_entity>
      <ParentDBName>%DiagramProp("DBlogical")</ParentDBName>
      <child_entity>%Child</child_entity>
      <ChildDBName>%DiagramProp("DBlogical")</ChildDBName>
      <primary_relationship>%RelLogProp("PrimaryRelationship")</primary_relationship>
      <identifying_relationship>%If(%RelType = "RT_ID") {YES} %Else {NO}</identifying_relationship>
      <nulls_allowed>%If(%RelIsNonull) {NO} %Else {YES}</nulls_allowed>
      <cardinality>%Cardinality</cardinality>
      <update_parent_allowed>%RelLogProp("UpdateParent")</update_parent_allowed>
      <parent_delete_action>%RelRI(Delete,Parent)</parent_delete_action>
      <parent_insert_action>%RelRI(Insert,Parent)</parent_insert_action>
      <parent_update_action>%RelRI(Update,Parent)</parent_update_action>
      <parent_verb_phrase>%VerbPhrase</parent_verb_phrase>
      <child_delete_action>%RelRI(Delete,Child)</child_delete_action>
      <child_insert_action>%RelRI(Insert,Child)</child_insert_action>
      <child_update_action>%RelRI(Update,Child)</child_update_action>
      <model_external_reference>%RelID</model_external_reference>
      <JoinFields>%JoinFKPK(%Child,%Parent)</JoinFields>
    </relationship>
}
%ForEachChildRel() {   <relationship RelDir="CP">
      <relationship_reference>%RelLogProp("RelationshipRef")</relationship_reference>
      <relationship_description>%RelLogProp("RelationshipDesc")</relationship_description>
      <parent_entity>%Parent</parent_entity>
      <ParentDBName>%DiagramProp("DBlogical")</ParentDBName>
      <child_entity>%Child</child_entity>
      <ChildDBName>%DiagramProp("DBlogical")</ChildDBName>
      <primary_relationship>%RelLogProp("PrimaryRelationship")</primary_relationship>
      <identifying_relationship>%If(%RelType = "RT_ID") {YES} %Else {NO}</identifying_relationship>
      <nulls_allowed>%If(%RelIsNonull) {NO} %Else {YES}</nulls_allowed>
      <cardinality>%Cardinality</cardinality>
      <update_parent_allowed>%RelLogProp("UpdateParent")</update_parent_allowed>
      <parent_delete_action>%RelRI(Delete,Parent)</parent_delete_action>
      <parent_insert_action>%RelRI(Insert,Parent)</parent_insert_action>
      <parent_update_action>%RelRI(Update,Parent)</parent_update_action>
      <child_delete_action>%RelRI(Delete,Child)</child_delete_action>
      <child_insert_action>%RelRI(Insert,Child)</child_insert_action>
      <child_update_action>%RelRI(Update,Child)</child_update_action>
      <child_verb_phrase>%VerbPhrase</child_verb_phrase>
      <model_external_reference>%RelID</model_external_reference>
      <JoinFields>%JoinFKPK(%Child,%Parent)</JoinFields>
    </relationship>
}  </table>
}</relationships>
}
