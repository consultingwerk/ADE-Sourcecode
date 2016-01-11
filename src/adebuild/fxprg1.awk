#
# Name: fxprg1.awk
# Description: AWK script to retrieve session types, setup types, setup type files 
#			   and migration sources from an icfsetup.xml file
# 
# Called from adebuild/pbuildfxprg
##################################################################################
/<session/ {
  if(substr($1,1,8)=="<session") {
    if(length($2)>0){
      sesstype=substr($2,14)
      sesstype=substr(sesstype,1,length(sesstype) - 2)
      if(sesstype!=""){session[++i]=sesstype}
    }
  }
}

/<migration_source_branch>/ {
  sourcebranch[i]=$1
  # Get migration_source_branch from XML Markup
  # Line looks like:
  #    		<migration_source_branch>D21</migration_source_branch>
  sub("<","",sourcebranch[i])
  startpos=index(sourcebranch[i],">")
  sourcebranch[i]=substr(sourcebranch[i],startpos+1)
  endpos=index(sourcebranch[i],"<")
  sourcebranch[i]=substr(sourcebranch[i],1,endpos-1)
}

/<setup_type>/ {
  setuptype[i]=$1
  # Get setup_type from XML Markup
  # Line looks like:
  #          <setup_type>ProgressSetup</setup_type>
  sub("<","",setuptype[i])
  startpos=index(setuptype[i],">")
  setuptype[i]=substr(setuptype[i],startpos+1)
  endpos=index(setuptype[i],"<")
  setuptype[i]=substr(setuptype[i],1,endpos-1)
}

/<setup_type_file>/ {
  setuptypefile[i]=$1
  # Get setup_type_file from XML Markup
  # Line looks like:  
  #         <setup_type_file>db/icf/dfd/setup101A.xml</setup_type_file>
  sub("<","",setuptypefile[i])
  startpos=index(setuptypefile[i],">")
  setuptypefile[i]=substr(setuptypefile[i],startpos+1)
  endpos=index(setuptypefile[i],"<")
  setuptypefile[i]=substr(setuptypefile[i],1,endpos-1)
}

END {
  j=1
  while (i>0&&j<=i) {
    if(sourcebranch[j]==""){sourcebranch[j]="NONE"}
    if(setuptype[j]==""){setuptype[j]="NONE"}
    if(setuptypefile[j]==""){setuptypefile[j]="NONE"}
    if(session[j]==""){session[j]="NONE"}
    print session[j] " " setuptype[j] " " setuptypefile[j] " " sourcebranch[j]
    j++
   }
}