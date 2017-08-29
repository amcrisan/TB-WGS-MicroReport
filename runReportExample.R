library(knitr)
library(dplyr)
library(ape) #needed in sweave doc
library(ggtree) #needed in sweave doc

options(warn=-1)

makeReport<-function(pInfo=NULL,drugDat = NULL){
  id<-pInfo$ID
  #copy the very original template
  con<-file.copy("./reportTemplate/sweaveTB-WGS-Micro-Report.Rnw",
            paste0("./output/",id,"_testReport",".Rnw", collapse =""),overwrite = TRUE)
  
  #environment variables magically get passed when compiled
  Sweave2knitr(paste0("./output/",id,"_testReport",".Rnw", collapse =""),
               paste0("./output/",id,"_testReport",".Rnw"))
  con<-knit2pdf(paste0("./output/",id,"_testReport",".Rnw", collapse =""),
           compiler = 'xelatex',quiet = T)
  #moving and getting rid of extra files (just keep the pdf)
  file.remove(paste(paste0(id,"_testReport",collapse=""),c(".log",".tex",".aux"),sep=""))
  file.rename(from=paste0(id,"_testReport.pdf",collapse=""), 
              to=paste0("./output/",id,"_testReport.pdf",collapse=""))
  file.remove(paste0("./output/",id,"_testReport",".Rnw"))
}

# Testing it out with some data
patDat<-read.csv(file="./data/patientMetaData.csv",header=T,stringsAsFactors = F)

#Note, not tidy data, which is being converted into a tiday format
patDrugResistData<-read.csv(file = "./data/patientDrugSusceptibilityData.csv",header=T,stringsAsFactors = F)

#Not sure how different groups will handle the cluster data, I've just opted to do something
#Simple and random that illustrates that point. I will assume the phylogeny information comes
#from some other place. Everything is generated in the sweave template as a random tree

#Generating the reports
for(i in 1:nrow(patDat)){
  pInfo = patDat[i,]
  makeReport(pInfo,filter(patDrugResistData,ID == pInfo$ID))
}
