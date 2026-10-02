#!/bin/bash

export COMPSET='HIST_DATM%CRUJRA2024b_CLM60%FATES-NCFB%NORESM_SICE_SOCN_SROF_SGLC_SWAV'
export RES=f09_g17   # "f45_f45_mg37" # ne16pg3_tn14, #, ne30pg3_tn14, f45_f45_mg37, ne16pg3_tn14
export MACH='betzy'
export PROJECT='nn9188k'

export USER='jessica'
export workpath='/cluster/work/users/jessica'

export TAG='noresm-fates_ai4pex_1901-2024_D2'
export CASEROOT=$workpath/AI4PEX_runs
export CIMEROOT=$workpath/noresm-ai4pex/CTSM/cime/scripts

cd ${CIMEROOT}

export CIME_HASH=`git log -n 1 --pretty=%h`
export NorESM_CTSM_HASH=`(cd ../..;git log -n 1 --pretty=%h)`
export FATES_HASH=`(cd src/fates;git log -n 1 --pretty=%h)`
export GIT_HASH=N${NorESM_CTSM_HASH}-F${FATES_HASH}	
export CASE_NAME=${CASEROOT}/${TAG}.`date +"%Y-%m-%d"`


# REMOVE EXISTING CASE DIRECTORY IF PRESENT 
rm -rf ${CASE_NAME}

# CREATE THE CASE
./create_newcase --case=${CASE_NAME} --res=${RES} --compset=${COMPSET} --mach=${MACH} --project=${PROJECT} --run-unsupported --pecount L

cd ${CASE_NAME}

./xmlchange STOP_N=25
./xmlchange STOP_OPTION=nyears
./xmlchange REST_N=25
./xmlchange REST_OPTION=nyears
./xmlchange RESUBMIT=4
./xmlchange DEBUG=FALSE

./xmlchange RUN_STARTDATE=1901-01-01
./xmlchange CLM_ACCELERATED_SPINUP=off
./xmlchange DATM_YR_START=1901
./xmlchange DATM_YR_END=2025
./xmlchange DATM_YR_ALIGN=1901
./xmlchange CLM_CO2_TYPE=diagnostic
./xmlchange DATM_CO2_TSERIES=cmip7_20tr
./xmlchange CCSM_BGC=CO2A
./xmlchange DATM_PRESAERO=hist

# turn on megan
./xmlchange CLM_BLDNML_OPTS="-bgc fates -megan"

./xmlchange --subgroup case.run JOB_WALLCLOCK_TIME=24:00:00
./xmlchange --subgroup case.st_archive JOB_WALLCLOCK_TIME=00:30:00

./xmlchange NTASKS_CPL=1536
./xmlchange NTASKS_ATM=256
./xmlchange NTASKS_LND=1536
./xmlchange ROOTPE_CPL=256
./xmlchange ROOTPE_ATM=0
./xmlchange ROOTPE_LND=256

./xmlchange RUNDIR=${CASE_NAME}/run
./xmlchange EXEROOT=${CASE_NAME}/bld

#./xmlchange BUILD_COMPLETE=TRUE
#./xmlchange EXEROOT=

cat >>  user_nl_clm <<EOF
finidat='/cluster/work/users/jessica/ai4pex_inputs/ihist.f09_g17.ctsm5.4.042_noresm_v3_Trendy26.T26_S3S5_pt1B2.2026-08-25.clm2.r.1901-01-01-00000.nc'
fsurdat='/cluster/work/users/jessica/wiemip_misc/surfdata_0.9x1.25_hist_1850_16pfts_WIEMIP_c260408.nc'
do_transient_lakes=.false.
do_transient_urban=.false.
irrigate=.false.
use_fates_sp=.false.
use_fates_nocomp=.true.
use_fates_fixed_biogeog=.true.
use_fates_luh=.true.
use_fates_potentialveg=.false.
flandusepftdat='/cluster/shared/noresm/inputdata/TRENDY2026/inputs/LU_files/fates_landuse_pft_surfdata_0.9x1.25_c260803.nc'
fluh_timeseries='/cluster/shared/noresm/inputdata/TRENDY2026/inputs/LU_files/LUH3_timeseries_850-2024_surfdata_0.9x1.25_c260803.nc'
hist_empty_htapes=.true.
hist_mfilt = 1,1
hist_nhtfrq = 0, -8760
hist_fincl1='FATES_GPP'
hist_fincl2='FATES_VEGC_SZ', 'FATES_LEAFC_SZPF', 'FATES_STOREC_SZPF', 'FATES_FROOTC_SZPF', 'FATES_REPROC_SZPF',
'FATES_NPLANT_SZ', 'FATES_NOCOMP_PATCHAREA_PF', 'FATES_VEGC_PF', 'FATES_LAI_PF', 'FATES_CROWNAREA_PF', 
'FATES_BASALAREA_SZPF', 'FATES_MEAN_95PCTILE_HEIGHT', 'Z0M', 'FSR', 'FSDS', 
'FATES_STRUCT_ALLOC_USTORY_SZ', 'FATES_STRUCT_ALLOC_CANOPY_SZ', 'FATES_SAPWOOD_ALLOC_USTORY_SZ',
'FATES_SAPWOOD_ALLOC_CANOPY_SZ', 'FATES_BGSTRUCT_ALLOC_SZPF', 'FATES_BGSAPWOOD_ALLOC_SZPF', 
'FATES_AGSTRUCT_ALLOC_SZPF', 'FATES_AGSAPWOOD_ALLOC_SZPF',
'FATES_MORTALITY_CANOPY_SZ', 'FATES_MORTALITY_USTORY_SZ', 'FATES_MORTALITY_BACKGROUND_SZ',
'FATES_MORTALITY_HYDRAULIC_SZ', 'FATES_MORTALITY_CSTARV_SZ', 'FATES_MORTALITY_IMPACT_SZ',
'FATES_MORTALITY_FIRE_SZ', 'FATES_MORTALITY_TERMINATION_SZ', 'FATES_MORTALITY_LOGGING_SZ', 
'FATES_MORTALITY_FREEZING_SZ', 'FATES_MORTALITY_SENESCENCE_SZ', 'FATES_GPP_PF', 'FATES_NPP_PF',
'FCO2', 'FATES_LEAFCTURN_CANOPY_SZ', 'FATES_LEAFCTURN_USTORY_SZ', 'FATES_FROOTCTURN_CANOPY_SZ',
'FATES_FROOTCTURN_USTORY_SZ', 'FATES_STORECTURN_CANOPY_SZ', 'FATES_STORECTURN_USTORY_SZ', 
'FATES_STRUCTCTURN_CANOPY_SZ', 'FATES_STRUCTCTURN_USTORY_SZ', 'FATES_SAPWOODCTURN_CANOPY_SZ', 
'FATES_SAPWOODCTURN_USTORY_SZ'
EOF

cp /cluster/home/jessica/AI4PEX/ai4pex_1901-2025_datm_streams user_nl_datm_streams

./case.setup
./case.build
./case.submit
