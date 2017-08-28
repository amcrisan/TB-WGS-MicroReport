library(brew)
library(knitr)

makeReport<-function(pInfo=NULL){
  id<-pInfo$ID
  #copy the very original template
  file.copy("./reportTemplate/sweaveTB-WGS-Micro-Report.Rnw",
            paste0("./output/",id,"_testReport",".Rnw", collapse =""),overwrite = TRUE)
  
  #environment variables magically get passed when compiled
  Sweave2knitr(paste0("./output/",id,"_testReport",".Rnw", collapse =""),
               paste0("./output/",id,"_testReport",".Rnw"))
  knit2pdf(paste0("./output/",id,"_testReport",".Rnw", collapse =""),
           compiler = 'xelatex')
  
  #moving and getting rid of extra files (just keep the pdf)
  file.remove(paste(paste0(id,"_testReport",collapse=""),c(".log",".tex",".aux"),sep=""))
  file.rename(from=paste0(id,"_testReport.pdf",collapse=""), 
              to=paste0("./output/",id,"_testReport.pdf",collapse=""))
  file.remove(paste0("./output/",id,"_testReport",".Rnw"))
}

#testing it out

patDat<-read.csv(file="./data/patientMetaData.csv",header=T,stringsAsFactors = F)

for(i in 1:nrow(patDat)){
  makeReport(pInfo=patDat[i,])
}
