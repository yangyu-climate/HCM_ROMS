/*
 * ** svn $Id: sandy.h 25 2007-04-09 23:43:58Z jcwarner $
 * *******************************************************************************
 * ** Copyright (c) 2002-2007 The ROMS/TOMS Group                               **
 * **   Licensed under a MIT/X style license                                    **
 * **   See License_ROMS.txt                                                    **
 * *******************************************************************************
 * **
 * ** Application flag:   HCM
 * */

#define ROMS_MODEL

#define HCM_COUPLING
#undef TIW_COUPLING
#undef HCM_SST_FILTER
#define HCM_CLIM_SPIN

#ifdef TIW_COUPLING  
#  define HCM_COUPLING
#  define HCM_SST_FILTER
#endif

#ifdef HCM_COUPLING  
#  ifndef HCM_CLIM_SPIN
#    define HCM_INITIAL_KICK
#    define HCM_WIND_STRESS
#    define HCM_EMINP_FORCE
#  endif
#  ifdef HCM_SST_FILTER
#    undef HCM_ROSSBY_FILTER
#    undef HCM_LOESS_FILTER
#    define HCM_RUNNING_FILTER
#    undef SSTA_FILTER_OPT1
#    undef SSTA_FILTER_OPT2
#  endif
#  define HCM_BULK_FLUX
#  define HCM_BULK_EVAP
#  define HCM_AVG_OUTPUT
#  define HCM_QCK_OUTPUT
#  define HCM_DIA_OUTPUT
#endif

#undef ROMS_CNOP
#ifdef ROMS_CNOP
#  define ADM_DRIVER
#  define TANGENT
#  define FORWARD_READ
#  define FORWARD_WRITE
#  define FORWARD_MIXCING
#  define FORWARD_RHS
#  define OUT_DOUBLE
#endif


#undef NESTING
#undef WRF_MODEL
#undef SWAN_MODEL
#undef WW3_MODEL

#ifdef NESTING
#  undef ONE_WAY
#  undef NESTING_DEBUG
#  define NO_CORRECT_TRACER
#  define TIME_INTERP_FLUX
#endif

#define MCT_LIB
#if defined ROMS_MODEL && defined WRF_MODEL
#  define MCT_INTERP_OC2AT
#endif
#if defined WRF_MODEL && (defined SWAN_MODEL || defined WW3_MODEL)
#  define MCT_INTERP_WV2AT
#endif
#if defined ROMS_MODEL && (defined SWAN_MODEL || defined WW3_MODEL)
#  define MCT_INTERP_OC2WV
#endif
#if defined WRF_MODEL && (defined SWAN_MODEL || defined WW3_MODEL)
#  define DRAGLIM_DAVIS
#  define COARE_TAYLOR_YELLAND
#endif

#ifdef ROMS_MODEL
/* Physics + numerics */
#  define UV_ADV
#  define UV_COR
#  undef UV_COR_NT

/* Grid and Initial */
#  define MASKING
#  undef WET_DRY

#  define SOLVE3D
#  define AVERAGES
#  define CURVGRID
#  define NONLIN_EOS
#  define SALINITY
#  define DJ_GRADPS

#  define UV_SMAGORINSKY
#  define UV_VIS2
#  define MIX_S_UV
#  define VISC_GRID

#  define TS_SMAGORINSKY
#  define TS_DIF2
#  define MIX_GEO_TS
#  define DIFF_GRID

#  ifdef SOLVE3D
#    define ANA_BTFLUX
#    define ANA_BSFLUX
#  else
#    define ANA_SMFLUX
#  endif

/* Forcing */
#  ifdef WRF_MODEL
#    define ATM2OCN_FLUXES
#  endif

#  define SOLAR_SOURCE
#  define WTYPE_GRID
#  undef LIMIT_STFLX_WARMING
#  define LIMIT_STFLX_COOLING
#  undef QCORRECTION
#  undef SCORRECTION

/* wave */
#  undef SSW_BBL              /* Sherwood et al. BBL closure */

#  ifdef SSW_BBL
#    define SSW_CALC_ZNOT     /* Computing bottom roughness internally */
#    undef SSW_LOGINT         /* Logarithmic interpolation of (Ur,Vr) */
#    define SSW_CALC_UB       /* Computing bottom orbital velocity internally */
#    undef SSW_FORM_DRAG_COR  /* Activate form drag coefficient */
#    undef SSW_ZOBIO          /* Biogenic bedform roughness from ripples */
#    undef SSW_ZOBL           /* Bedload roughness for ripples */
#    undef SSW_ZORIP          /* Bedform roughness from ripples */
#  else
#    define UV_QDRAG
#  endif

/* Turbulence closure */
#  undef MY25_MIXING
#  undef GLS_MIXING
#  define LMD_MIXING
#  define AKLIMIT

#  define SPLINES_SWITCH
#  ifdef SPLINES_SWITCH
#    define SPLINES_VDIFF
#    define SPLINES_VVISC
#  endif

#  ifdef AKLIMIT
#    define LIMIT_VDIFF
#    define LIMIT_VVISC
#  endif

#  ifdef MY25_MIXING
#    define KANTHA_CLAYSON
#    define N2S2_HORAVG
#    define RI_SPLINES
#  endif
#  ifdef GLS_MIXING
#    define KANTHA_CLAYSON
#    define N2S2_HORAVG
#    define RI_SPLINES
#    define CRAIG_BANNER
#    define CHARNOK
#  endif
#  ifdef LMD_MIXING
#    define RI_SPLINES
#    define LMD_RIMIX
#    define LMD_DDMIX
#    define LMD_CONVEC
#    define LMD_SKPP
#    define LMD_BKPP
#endif

/*Tidal Forcing*/
#  undef TIDAL
#  ifdef TIDAL
#    define SSH_TIDES
#    define UV_TIDES
#    define RAMP_TIDES
#    define ADD_FSOBC
#    define ADD_M2OBC
#  endif

#  define RADIATION_2D

/* Input & Output */
#  undef PERFECT_RESTART
#  define RST_SINGLE
#  define DIAGNOSTICS_UV
#  define DIAGNOSTICS_TS

/* ice */
#  undef ICE_MODEL

#  ifdef ICE_MODEL
#    define OUTFLOW_MASK
#    define FASTICE_CLIMATOLOGY
#    define ICE_THERMO
#    define ICE_MK
#    undef ICE_ALB_EC92
#    undef ICE_SMOOTH
#    define ICE_MOMENTUM
#    define ICE_MOM_BULK
#    define ICE_EVP
#    define ICE_ADVECT
#    define ICE_SMOLAR
#    define ICE_UPWIND
#    define ICE_BULK_FLUXES
#    undef ANA_AIOBC
#    undef ANA_HIOBC
#    undef ANA_HSNOBC
#  endif

/* biology */
#  define BIOLOGY

#  ifdef BIOLOGY
#    undef BIO_FENNEL
#    define BIO_UMAINE
#  endif
#  ifdef BIO_FENNEL
#    define CARBON
#    define OXYGEN
#    define DENITRIFICATION
#    define BIO_SEDIMENT
#    undef DIAGNOSTICS_BIO
#    define OCMIP_OXYGEN_SC
#    define TALK_NONCONSERV
#    define ANA_SPFLUX
#    define ANA_BPFLUX
#  endif
/* UMAINE 31 */
#  ifdef BIO_UMAINE
#    define CARBON
#    define OXYGEN
#    define TALK_NONCONSERV
#    define SINK_OP1
#    undef SINK_OP2
#    undef DIAGNOSTICS_BIO
#    define ANA_SPFLUX
#    define ANA_BPFLUX
#    define BIO_SOLAR
#    define BIO_SOLAR_CHLA
#    define IRON_LIMIT
#    define IRON_RELAX
#    define IRON_NUDG
#  endif

/* sediment */
#  undef SEDIMENT

#  ifdef SEDIMENT
#    undef ANA_SEDIMENT
#    define SUSPLOAD
#    undef BEDLOAD_MPM
#    undef BEDLOAD_SOULSBY
#    define ANA_SPFLUX 
#    define ANA_BPFLUX
#    define RIVER_SEDIMENT
#  endif

/* floats */
#  undef FLOATS

#  ifdef FLOATS
#    define FLOATS_STICKY
#    define FLOATS_VWALK
#  endif

/* passive tracers */
#  undef T_PASSIVE

#  ifdef T_PASSIVE
#    define AGE_MEAN
#    define TRC_PSOURCE
#    define ANA_SPFLUX
#    define ANA_BPFLUX
#  endif


#endif
