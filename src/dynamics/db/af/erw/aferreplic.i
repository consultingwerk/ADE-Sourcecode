%ForEachTable()
{
%If(%Or(%==(%entityprop("VersionData"),YES),%!=(%entityprop("ReplicateFLA"),%entityprop("XYZ")))) {
  %File(%DiagramProp(TriggerDump)%EntityProp(TableFLA)replc.p) {%Include("%DiagramProp("RootDir")db/af/erw/aftemreplc.i")}
  %File(%DiagramProp(TriggerDump)%EntityProp(TableFLA)repld.p) {%Include("%DiagramProp("RootDir")db/af/erw/aftemrepld.i")}
  %File(%DiagramProp(TriggerDump)%EntityProp(TableFLA)replw.p) {%Include("%DiagramProp("RootDir")db/af/erw/aftemreplw.i")}
  }
}
        
