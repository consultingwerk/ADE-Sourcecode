#
# Name: fxprg3.awk
# Description: AWK script to read all patch files for a given setup type
# 
# Called from adebuild/pbuildfxprg
##################################################################################

/<Patch / {
  # Line looks like:
  #   <Patch PatchLevel="101001">
  patchlevel=substr($2,13)
  patchlevel=substr(patchlevel,1,length(patchlevel)-2)
  # HACK -- sometime unixes will leave an extra quote
  gsub(/\"/,"",patchlevel)    
  if($1=="<Patch"&&patchlevel!=PATCHLEVEL){exit}
}

/<PatchStage/ {
  # Line looks like:
  #       <PatchStage Stage="PreADOLoad">
  patchstage=substr($2,8)
  patchstage=substr(patchstage,1,length(patchstage)-2)
  # HACK -- sometime unixes will leave an extra quote
  gsub(/\"/,"",patchstage)
}

/<FileType/ {
  filetype=$1
  # Get FileType from XML markup
  # Line looks like:
  #   	<FileType>p</FileType>
  sub("<","",filetype)
  startpos=index(filetype,">")
  filetype=substr(filetype,startpos+1)
  endpos=index(filetype,"<")
  filetype=substr(filetype,1,endpos-1)    
}

/<FileName/ {
  filename=$1
  # Get FileName from XML Markup
  # Line looks like:
  #  	<FileName>db/icf/dfd/move_comments_obj_to_ref.p</FileName>
  sub("<","",filename)
  startpos=index(filename,">")
  filename=substr(filename,startpos+1)
  endpos=index(filename,"<")
  filename=substr(filename,1,endpos-1)
  
  # remove token from filename
  gsub(/#migration_source#/, "", filename)
  # Replace double slashes with single slash. There
  # may be double slashes as the result fo removing a token
  gsub(/\/\//,"\\/",filename)
   
  # store file type/name. we don't care about ADO for compilation
  if(filetype!="ADO"){
    if(patchstage=="PreDelta") {PreDelta[++i,1]=filetype; PreDelta[i,2]=filename}
    if(patchstage=="Delta") {Delta[++j,1]=filetype; Delta[j,2]=filename}
    if(patchstage=="PostDelta") {PostDelta[++k,1]=filetype; PostDelta[k,2]=filename}
    if(patchstage=="PreADOLoad") {PreADOLoad[++l,1]=filetype; PreADOLoad[l,2]=filename}
    if(patchstage=="ADOLoad") {ADOLoad[++m,1]=filetype; ADOLoad[m,2]=filename}
    if(patchstage=="PostADOLoad") {PostADOLoad[++n,1]=filetype; PostADOLoad[n,2]=filename}
  }
}

END { 
  for(h=1;h<=i;h++) {print "PreDelta " PreDelta[h,1] " " PreDelta[h,2]}
  for(h=1;h<=j;h++) {print "Delta " Delta[h,1] " " Delta[h,2]}
  for(h=1;h<=k;h++) {print "PostDelta " PostDelta[h,1] " " PostDelta[h,2]}
  for(h=1;h<=l;h++) {print "PreADOLoad " PreADOLoad[h,1] " " PreADOLoad[h,2]}
  for(h=1;h<=m;h++) {print "ADOLoad " ADOLoad[h,1] " " ADOLoad[h,2]}
  for(h=1;h<=n;h++) {print "PostADOLoad " PostADOLoad[h,1] " " PostADOLoad[h,2]}
}
