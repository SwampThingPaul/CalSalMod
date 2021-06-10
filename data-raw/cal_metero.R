## Internal Data
## From spreadsheet
library(AnalystHelper)
library(openxlsx)
library(zoo)

cal_metero=openxlsx::read.xlsx("C:/Julian_LaCie/_Github/CRE_Conditions/Data/QiuWan2013_RF_ETData.xlsx")
cal_metero$Date=date.fun(openxlsx::convertToDate(cal_metero$Date))
cal_metero$RF_2d=with(cal_metero,c(NA,rollapply(RF,width=2,function(x)mean(x,na.rm=T))))
cal_metero$RF_2d[1]=0

usethis::use_data(cal_metero,internal=F,overwrite=T)
