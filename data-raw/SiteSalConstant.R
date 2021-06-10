## Internal Data
## From spreadsheet

SiteSalConstant=data.frame(Site=c("S79","BR31","Val-I75","Bird-IS","FtMyers"),
                DistfromS79=c(0,4.3,7.2,9.2,12.7),
                a.val=c(15.9,17.0,17.5,18.8,23.7),
                b.val=c(-0.00201,-0.00191,-0.00179,-0.00172,-0.00121),
                Q.thres=c(1000,1000,2500,1000,2500),
                Sal_int=c(9.60,19.05,14.50,12.00,24.25))

usethis::use_data(SiteSalConstant,internal=F,overwrite=T)
