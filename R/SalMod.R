#' Salinity model as used by Qiu and Wan (2013)
#'
#' @param Q.total total discharge from freshwater inputs. For Caloosahatchee Estuary this includes tidal basin discharge and
#' @param SITE Current mointoring location with estalished salinity relationships. Sites include S79, BR31, Val-I75 and FtMyers. See Qiu and Qan (2013).
#' @param a.val alpha value model coefficient
#' @param b.val beta value model coefficient
#' @param Q.thres discharge threshold
#'
#' @return modeled salinity based on model coefficients and total freshwater discharge
#' @export
#' @references
#' Qiu C, Wan Y (2013) Time series modeling and prediction of salinity in the Caloosahatchee River Estuary. Water Resources Research 49:5804–5816. doi: 10.1002/wrcr.20415
#'
#' @examples
#' sim.Q=c(500, 1001, 1500, 1998, 2507, 2994, 3498, 4006, 4511, 4991)
#'
#' SalMod(Q.total=sim.Q)


SalMod=function(Q.total,SITE="Val-I75",a.val=NULL,b.val=NULL,Q.thres=NULL){
  # Site specific salinity model constants
  sal.mod.con=data.frame(SiteSalConstant)

  #Making sure correct parameters are entered
  if(is.null(Q.total)==T){
    stop("missing discharge data")
  }
  if(is.null(a.val)==T&is.null(b.val)==T&is.null(Q.thres)==T&is.null(SITE)==T){
    stop("missing site name or salinity model constants. check inputs")
  }else if(!(SITE%in%sal.mod.con$Site)){
    stop("check site name")
  }
  if(sum(is.na(Q.total))>0){
    warning("flow records has one or more NA values.")
  }

  # Model constants if SITE value selected
  if(is.null(a.val)==T&is.null(b.val)==T&is.null(Q.thres)==T){
  a.val=sal.mod.con[match(SITE,sal.mod.con$Site),"a.val"]
  b.val=sal.mod.con[match(SITE,sal.mod.con$Site),"b.val"]
  Q.thres=sal.mod.con[match(SITE,sal.mod.con$Site),"Q.thres"]
  }

  Sal=ifelse(Q.total>Q.thres,0,a.val*exp(b.val*Q.total))
  return(Sal)
}
