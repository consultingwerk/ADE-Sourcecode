%ForEachEntity()
{
%If(%Or(%==(%entityprop("VersionData"),YES),%!=(%entityprop("ReplicateFLA"),%entityprop("XYZ")))) {
  %File(%SubjectAreaProp(TriggerDump)%EntityProp(TableFLA)replc.p) {%Include("%DiagramProp("RootDir")db/af/erw/aftemreplc.i")}
  %File(%SubjectAreaProp(TriggerDump)%EntityProp(TableFLA)repld.p) {%Include("%DiagramProp("RootDir")db/af/erw/aftemrepld.i")}
  %File(%SubjectAreaProp(TriggerDump)%EntityProp(TableFLA)replw.p) {%Include("%DiagramProp("RootDir")db/af/erw/aftemreplw.i")}
  }
}
        
