load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

dir  = "DATA/"
filename  = "wrfout*"

all_files = systemfunc("ls "+dir+filename)
time      = -1

do i = 0,dimsizes(all_files)-1,1

  fileI = all_files(i)
  fileO = fileI+".nc"
  print(fileI)
  a     = addfile(fileI,"r")
  fileS = addfile(fileO, "c")
;----------------------------------------------------------------------------
; Time
;----------------------------------------------------------------------------
  varN  = "Times"
  var   = wrf_user_getvar(a,varN,time)
  fileS->Times = var
  delete(var)  
;----------------------------------------------------------------------------
; Longitude
;----------------------------------------------------------------------------
  varN  = "lon"
  var   = wrf_user_getvar(a,varN,time)
  var@long_name = "longitude"
  var@units     = "degree east"
  fileS->lon = var
  delete(var)  
;----------------------------------------------------------------------------
; Latitude
;----------------------------------------------------------------------------
  varN  = "lat"
  var   = wrf_user_getvar(a,varN,time)
  var@long_name = "latitude"
  var@units     = "degree north"
  fileS->lat = var
  delete(var)  
;----------------------------------------------------------------------------
; 10m U component of wind on mass points
;----------------------------------------------------------------------------
  varN  = "U10"
  var   = wrf_user_getvar(a,varN,time)
  var@long_name = "U wind at 10m"
  var@units     = "m s-1"
  fileS->u10 = var
  delete(var)
;----------------------------------------------------------------------------
; 10m V component of wind on mass points
;----------------------------------------------------------------------------
  varN  = "V10"
  var   = wrf_user_getvar(a,varN,time)
  var@long_name = "V wind at 10m"
  var@units     = "m s-1"
  fileS->v10 = var
  delete(var)
;----------------------------------------------------------------------------
; Sea Level Pressure
;----------------------------------------------------------------------------
  varN  = "slp"
  var   = wrf_user_getvar(a,varN,time)
  var@long_name = "Sea Level Pressure"
  var@units     = "hPa"
  fileS->slp = var
  delete(var)  
;----------------------------------------------------------------------------
; 2m Temperature
;----------------------------------------------------------------------------
  varN  = "T2"
  var   = wrf_user_getvar(a,varN,time)
  var@long_name = "2m Temperature"
  var@units     = "K"
  fileS->t2 = var
  delete(var)  
;----------------------------------------------------------------------------
; 2m Relative Humidity
;----------------------------------------------------------------------------
  varN  = "rh2"
  var   = wrf_user_getvar(a,varN,time)
  var@long_name = "2m Relative Humidity"
  var@units     = "percentage"
  fileS->rh2 = var
  delete(var)  
;----------------------------------------------------------------------------
; Total Cloud Fraction
;----------------------------------------------------------------------------
  varN  = "CFRACT"
  var   = wrf_user_getvar(a,varN,time)
  var@long_name  = "Total Cloud Fraction"
  var@units      = "nondimesional"
  fileS->tcdc = var
  delete(var)
;----------------------------------------------------------------------------
;  Short Wave Radiation
;----------------------------------------------------------------------------
  varN  = "SWDNB"
  varDN = wrf_user_getvar(a,varN,time)
  varN  = "SWUPB"
  varUP = wrf_user_getvar(a,varN,time)
  var   = varDN-varUP
  var@long_name  = "Short Wave Radiation"
  var@units      = "W m-2"
  fileS->gsw = var
  delete(varDN)
  delete(varUP)
  delete(var)
;----------------------------------------------------------------------------
; Long Wave Radiation
;----------------------------------------------------------------------------
  varN  = "LWDNB"
  varDN = wrf_user_getvar(a,varN,time)
  varN  = "LWUPB"
  varUP = wrf_user_getvar(a,varN,time)
  var   = varDN-varUP
  var@long_name  = "Long Wave Radiation"
  var@units      = "W m-2"
  fileS->glw = var
  delete(varDN)
  delete(varUP)
  delete(var)
;----------------------------------------------------------------------------
; Latent Heat Flux
;----------------------------------------------------------------------------
  varN  = "LH"
  var   = wrf_user_getvar(a,varN,time)
  var@long_name  = "Latent Heat Flux"
  var@units      = "W m-2"
  fileS->lh = var
  delete(var)
;----------------------------------------------------------------------------
; Sensible Heat Flux
;----------------------------------------------------------------------------
  varN  = "HFX"
  var   = wrf_user_getvar(a,varN,time)
  var@long_name  = "Sensible Heat Flux"
  var@units      = "W m-2"
  fileS->hfx = var
  delete(var)
;----------------------------------------------------------------------------
; Moisture Flux at Surface
;----------------------------------------------------------------------------
  varN  = "QFX"
  var   = wrf_user_getvar(a,varN,time)
  var@long_name  = "Moisture Flux at Surface"
  var@units      = "kg m-2 s-1"
  fileS->qfx = var
  delete(var)
;----------------------------------------------------------------------------
; Acculated Total Cumulus Precipation
;----------------------------------------------------------------------------
  varN  = "RAINC"
  var   = wrf_user_getvar(a,varN,time)
  var@long_name  = "Acculated Total Cumulus Precipation"
  var@units      = "mm"
  fileS->RAINC = var
  delete(var)
;----------------------------------------------------------------------------
; Acculated Total Grid Scale Precipation
;----------------------------------------------------------------------------
  varN  = "RAINNC"
  var   = wrf_user_getvar(a,varN,time)
  var@long_name  = "Acculated Total Grid Scale Precipation"
  var@units      = "mm"
  fileS->RAINNC = var
  delete(var)
;----------------------------------------------------------------------------


end do
