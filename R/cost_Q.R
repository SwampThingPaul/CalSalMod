#' Coastal Rainfall-Runoff discharge model (LinRes)
#'
#' Tidal Basin rainfall-runoff model as presented by Wan and Konyha (2015)
#'
#' @param RF_2d 2-day moving average rainfall value for the Caloosahatchee Tidal Basin (current forecast models use SFWMD NEXRAD values)
#' @param ETPI Regional evapotranspiration potential value for the (current forecast models use SFWMD DBKEY OH520)
#' @param RootStor Capacity of root zone storage (i.e. maximum root zone storage). Default is 1 inch.
#' @param Kc ET crop correction coefficient. Default is 1.
#' @param Z1.Smax Capacity of subsurface (Zone 1) drainage storage. Default is 1 inch.
#' @param Z1.StoreCef Storage coefficient of subsurface (Zone 1) drainage reservoir Default is 150.
#' @param BasinArea Area of tidal basin. Caloosahatchee tidal basin area is 251,583 acres.
#' @param Z2.Smax Capacity of surface (Zone 2) drainage storage. Default is 1 inch.
#' @param Z2.StoreCef Storage coefficient of surface (Zone 2) drainage reservoir Default is 100.
#' @param Z3.Smax Capacity of direct (Zone 3) drainage storage. Default is 2.2 inch.
#' @param Z3.StoreCef Storage coefficient of direct (Zone 3) drainage reservoir Default is 12.
#' @param open.water.area area of open water to estimate direct rainfall contribution.
#'
#' @return a vector of daily discharge values in cubic feet per second
#' @export
#' @references
#' Wan Y, Konyha K (2015) A simple hydrologic model for rapid prediction of runoff from ungauged coastal catchments. Journal of Hydrology 528:571–583. doi: 10.1016/j.jhydrol.2015.06.047
#'
#' @examples
#' data(cal_metero)
#' with(cal_metero,cost_Q(RF_2d,ETPI))

cost_Q=function(RF_2d,ETPI,RootStor=1,Kc=1,Z1.Smax=1,Z1.StoreCef=150,
         BasinArea=251583,Z2.Smax=1,Z2.StoreCef=100,Z3.Smax=2.2,
         Z3.StoreCef=12,open.water.area=0){
  # Root Zone Storage
  RootZoneStore=NA
  for(i in 1:length(RF_2d)){
    if(i==1){RootZoneStore[i]=min(c(max(c(0,RF_2d[i]-ETPI[i]+0),na.rm=T),RootStor),na.rm=T)}else{
      RootZoneStore[i]=min(c(max(c(0,RF_2d[i]-ETPI[i]+RootZoneStore[i-1]),na.rm=T),RootStor),na.rm=T)
    }
  }

  # Actual Evapotranspiration?
  AET=NA
  for(i in 1:length(RF_2d)){
    if(i==1){AET[i]=ETPI[i]-max(c(0,-(RF_2d[i]-ETPI[i]+0)),na.rm=T)}else{
      AET[i]=ETPI[i]-max(c(0,-(RF_2d[i]-ETPI[i]+RootZoneStore[i-1])),na.rm=T)
    }
  }

  # Zone 1
  excess123=NA
  for(i in 1:length(RF_2d)){
    if(i==1){excess123[i]=max(c(0,(RF_2d[i]-ETPI[i]*0)-RootStor))}else{
      excess123[i]=max(c(0,(RF_2d[i]-ETPI[i]*Kc+RootZoneStore[i-1])-RootStor))
    }
  }

  store.Z1=0
  out.Z1=0
  for(i in 1:length(RF_2d)){
    if(i==1){
      Z1.store.i=1
      out.Z1.i=0
      store.Z1[i]=min(c(max(c(0,excess123[i]+Z1.store.i-out.Z1[1]),na.rm=T),Z1.Smax))
      out.Z1[i]=store.Z1[i]*(1-exp(-1/Z1.StoreCef))
    }else{
      store.Z1[i]=min(c(max(c(0,excess123[i]+store.Z1[i-1]-out.Z1[i-1]),na.rm=T),Z1.Smax))
      out.Z1[i]=store.Z1[i]*(1-exp(-1/Z1.StoreCef))
    }
  }
  out.Z1.afd=out.Z1/12*BasinArea

  # Zone 2
  excess23=NA
  for(i in 1:length(RF_2d)){
    if(i==1){excess23[i]=excess123[i]+((1-store.Z1[i])-0)}else{
      excess23[i]=excess123[i]+((store.Z1[i-1]-store.Z1[i])-out.Z1[i-1])
    }
  }

  store.Z2=0
  out.Z2=0
  for(i in 1:length(RF_2d)){
    if(i==1){
      Z2.store.i=1
      out.Z2.i=0
      store.Z2[i]=min(c(max(c(0,excess23[i]+Z2.store.i-out.Z2[1]),na.rm=T),Z2.Smax))
      out.Z2[i]=store.Z2[i]*(1-exp(-1/Z2.StoreCef))
    }else{
      store.Z2[i]=min(c(max(c(0,excess23[i]+store.Z2[i-1]-out.Z2[i-1]),na.rm=T),Z2.Smax))
      out.Z2[i]=store.Z2[i]*(1-exp(-1/Z2.StoreCef))
    }
  }
  out.Z2.afd=out.Z2/12*BasinArea

  # Zone 3
  excess3=NA
  for(i in 1:length(RF_2d)){
    if(i==1){excess3[i]=excess23[i]+((1-store.Z2[i])-0)}else{
      excess3[i]=excess23[i]+((store.Z2[i-1]-store.Z2[i])-out.Z2[i-1])
    }
  }

  store.Z3=0
  out.Z3=0
  for(i in 1:length(RF_2d)){
    if(i==1){
      Z3.store.i=0.2
      out.Z3.i=0
      store.Z3[i]=min(c(max(c(0,excess3[i]+Z3.store.i-out.Z3[1]),na.rm=T),Z3.Smax))
      out.Z3[i]=store.Z3[i]*(1-exp(-1/Z3.StoreCef))
    }else{
      store.Z3[i]=min(c(max(c(0,excess3[i]+store.Z3[i-1]-out.Z3[i-1]),na.rm=T),Z3.Smax))
      out.Z3[i]=store.Z3[i]*(1-exp(-1/Z3.StoreCef))
    }
  }
  out.Z3.afd=out.Z3/12*BasinArea

  direct.RF=(RF_2d-0*ETPI)/12*open.water.area

  BasinQ=out.Z1.afd+out.Z2.afd+out.Z3.afd+direct.RF

  return(BasinQ)
}
