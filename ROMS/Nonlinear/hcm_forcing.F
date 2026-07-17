#include "cppdefs.h"
      MODULE hcm_forc_mod

#if defined HCM_COUPLING
#    ifndef HCM_CLIM_SPIN 
      implicit none
!
      PRIVATE
      PUBLIC  :: hcm_forcing
!
      CONTAINS
!
!***********************************************************************      
      SUBROUTINE hcm_forcing(ng)
!***********************************************************************
!             
      USE mod_param
      USE mod_scalars
      USE mod_grid
      USE mod_parallel
      USE mod_forces
      USE mod_ocean
      USE mod_stepping
      USE dateclock_mod,        ONLY : time_string
!
!  Imported variable declarations.
!
      integer, intent(in) :: ng
!
!  Local variable declarations.
!       
      integer :: tile
      integer :: Ntiles

!--MPI-related parameters--
      integer :: num
      integer :: len_buffer,request,ierr
      integer,dimension(mpi_status_size) :: rstatus
      real(r8),allocatable,dimension(:) ::send_buffer
      real(r8),allocatable,dimension(:) ::recv_buffer
 
#     ifdef HCM_INITIAL_KICK
      real(r8):: lonr, latr
      real(r8):: cffX, cffY, cffL
#     endif
      real(r8):: cffT
      real(r8):: sstC, sstM
      real(r8):: cffM, cffR

      integer :: i, j
      integer :: LBi,UBi,LBj,UBj,dim1,dim2
      integer :: ILB,IUB,JLB,JUB
      integer :: IstrR, IendR, JstrR, JendR

      real(r8),allocatable,dimension(:,:) :: sstA

#ifdef HCM_AI_COUPLING
      real(r8):: COUPnum
      real(r8):: AI_NUM
      logical :: AI_FINISH
      integer :: tagLON,tagLAT,tagSSTA
      character (len=22) :: fileT
      character (len=:),allocatable :: fileN
      real(r8),allocatable,dimension(:,:) :: lonM, latM
      real(r8),allocatable,dimension(:,:) :: AIDT
#endif

#ifdef HCM_WIND_STRESS
#  ifdef HCM_AI_WIND
      integer :: tagU,tagV,tagUc,tagVc,tagUa,tagVa
#  else
      integer :: tagUw, tagVw
      integer :: tagUwN,tagVwN
      real(r8):: cffU1, cffU2, cffU3, cffU4, cffU5
      real(r8):: cffV1, cffV2, cffV3, cffV4, cffV5
      real(r8):: cffU1N,cffU2N,cffU3N,cffU4N,cffU5N
      real(r8):: cffV1N,cffV2N,cffV3N,cffV4N,cffV5N
#  endif
      real(r8),allocatable,dimension(:,:) :: sustr, svstr
      real(r8),allocatable,dimension(:,:) :: sustrC, svstrC
      real(r8),allocatable,dimension(:,:) :: sustrA, svstrA
#endif

#ifdef HCM_EMINP_FORCE
#  ifdef HCM_AI_FWF
      integer :: tagW,tagWc,tagWa
#  else
      integer :: tagWw
      integer :: tagWwN
      real(r8):: cffW1, cffW2, cffW3, cffW4, cffW5
      real(r8):: cffW1N,cffW2N,cffW3N,cffW4N,cffW5N
#  endif
      real(r8),allocatable,dimension(:,:) :: fwf, fwfC, fwfA
#endif

#ifdef TIW_COUPLING
      real(r8):: cffTIW
#  ifdef HCM_AI_TIW
      integer :: tagSSTH,tagTIWu,tagTIWv
      real(r8),allocatable,dimension(:,:) :: sstH
#  else
      integer :: tagTIWw
      integer :: tagTIWwN
      real(r8):: cffTIW01, cffTIW02, cffTIW03, cffTIW04, cffTIW05
      real(r8):: cffTIW06, cffTIW07, cffTIW08, cffTIW09, cffTIW10
      real(r8):: cffTIW01N,cffTIW02N,cffTIW03N,cffTIW04N,cffTIW05N
      real(r8):: cffTIW06N,cffTIW07N,cffTIW08N,cffTIW09N,cffTIW10N
#  endif
      real(r8),allocatable,dimension(:,:) :: sustrTIW, svstrTIW
#endif

      Ntiles=NtileI(ng)*NtileJ(ng)-1

#ifdef HCM_AI_COUPLING
      tagLON =101000
      tagLAT =102000
      tagSSTA=103000
#endif

#ifdef HCM_WIND_STRESS
#  ifdef HCM_AI_WIND
      tagU =111000
      tagV =112000
      tagUc=113000
      tagVc=114000
      tagUa=115000
      tagVa=116000
#  else
      tagUw =111
      tagVw =112
      tagUwN=113
      tagVwN=114
#  endif
#endif

#ifdef HCM_EMINP_FORCE
#  ifdef HCM_AI_FWF
      tagW =121000
      tagWc=122000
      tagWa=123000
#  else
      tagWw =121
      tagWwN=122
#  endif
#endif

#ifdef TIW_COUPLING
#  ifdef HCM_AI_TIW
      tagSSTH=131000
      tagTIWu=132000
      tagTIWu=133000
#  else
      tagTIWw =131
      tagTIWwN=132
#  endif
#endif

!
!  Lower and upper bounds for nontiled (global values) boundary arrays.
!
      tile=-1                           ! for global values
      ILB=BOUNDS(ng)%LBi(tile)
      IUB=BOUNDS(ng)%UBi(tile)
      JLB=BOUNDS(ng)%LBj(tile)
      JUB=BOUNDS(ng)%UBj(tile)

      allocate(sstA(ILB:IUB,JLB:JUB))
#ifdef HCM_AI_COUPLING
      allocate(lonM(ILB:IUB,JLB:JUB))
      allocate(latM(ILB:IUB,JLB:JUB))
      allocate(AIDT(ILB:IUB,JLB:JUB))
#endif
#ifdef HCM_WIND_STRESS
      allocate(sustr(ILB:IUB,JLB:JUB))
      allocate(svstr(ILB:IUB,JLB:JUB))
      allocate(sustrC(ILB:IUB,JLB:JUB))
      allocate(svstrC(ILB:IUB,JLB:JUB))
      allocate(sustrA(ILB:IUB,JLB:JUB))
      allocate(svstrA(ILB:IUB,JLB:JUB))
#endif        
#ifdef HCM_EMINP_FORCE
      allocate(fwf(ILB:IUB,JLB:JUB))
      allocate(fwfC(ILB:IUB,JLB:JUB))
      allocate(fwfA(ILB:IUB,JLB:JUB))
#endif  
#ifdef TIW_COUPLING
#  ifdef HCM_AI_TIW
      allocate(sstH(ILB:IUB,JLB:JUB))
#  endif
      allocate(sustrTIW(ILB:IUB,JLB:JUB))
      allocate(svstrTIW(ILB:IUB,JLB:JUB))
#endif  


!-----------------------------------------------------------------------
! SEND To MPI if MyRank/=MyMaster
!-----------------------------------------------------------------------
      if (MyRank/=MyMaster) then
       !WRITE (*,*) ' MyRank/=MyMaster '
        tile=MyRank
        LBi=BOUNDS(ng) % LBi(tile)
        UBi=BOUNDS(ng) % UBi(tile)
        LBj=BOUNDS(ng) % LBj(tile)
        UBj=BOUNDS(ng) % UBj(tile)
        IstrR=LBi+NghostPoints
        IendR=UBi-NghostPoints
        JstrR=LBj+NghostPoints
        JendR=UBj-NghostPoints
        if (LBi<NghostPoints) then
        IstrR=LBi
        endif
        if (UBi>Lm(ng)) then
        IendR=UBi
        endif
        if (LBj<NghostPoints) then
        JstrR=LBj
        endif
        if (UBj>=Mm(ng)) then
        JendR=UBj
        endif
!-----------------------------------------------------------------------
!beg weight
#ifdef HCM_WIND_STRESS
#  ifndef HCM_AI_WIND
        cffU1=0.0_r8
        cffU2=0.0_r8
        cffU3=0.0_r8
        cffU4=0.0_r8
        cffU5=0.0_r8
        cffV1=0.0_r8
        cffV2=0.0_r8
        cffV3=0.0_r8
        cffV4=0.0_r8
        cffV5=0.0_r8
#  endif
#endif
#ifdef HCM_EMINP_FORCE
#  ifndef HCM_AI_FWF
        cffW1=0.0_r8
        cffW2=0.0_r8
        cffW3=0.0_r8
        cffW4=0.0_r8
        cffW5=0.0_r8
#  endif
#endif
#ifdef TIW_COUPLING
#  ifndef HCM_AI_TIW
        cffTIW01=0.0_r8
        cffTIW02=0.0_r8
        cffTIW03=0.0_r8
        cffTIW04=0.0_r8
        cffTIW05=0.0_r8
        cffTIW06=0.0_r8
        cffTIW07=0.0_r8
        cffTIW08=0.0_r8
        cffTIW09=0.0_r8
        cffTIW10=0.0_r8
#  endif
#endif
        DO j=JstrR,JendR
          DO i=IstrR,IendR
            sstC=FORCES(ng)%sstC(i,j)
#    ifdef HCM_SST_FILTER
            sstM=FORCES(ng)%sstA(i,j)
#    else
            sstM=OCEAN(ng)%t(i,j,N(ng),nrhs(ng),itemp)-sstC
#    endif
#    ifdef HCM_INITIAL_KICK
            lonr=GRID(ng)%lonr(i,j)
            latr=GRID(ng)%latr(i,j)
            IF (tdays(ng).gt.hcm_kick_date(ng)-1.0_r8                   &
     &    .and. tdays(ng).lt.hcm_kick_date(ng)+hcm_kick_time(ng)) THEN
              cffX=lonr-hcm_kick_locx(ng)
              cffY=latr-hcm_kick_locy(ng)
              cffX=cffX/hcm_kick_lenx(ng)
              cffY=cffY/hcm_kick_leny(ng)
              cffL=EXP(-cffX*cffX)*EXP(-cffY*cffY)
              cffT=cffL*hcm_kick_temp(ng)
            ELSE
              cffT=sstM
            ENDIF
#    else
            cffT=sstM
#    endif
#    ifdef WET_DRY
            cffT=cffT*GRID(ng)%rmask_wet(i,j)
#    endif
#    ifdef MASKING
            cffT=cffT*GRID(ng)%rmask(i,j)
#    endif
            sstA(i,j)=cffT
#ifdef HCM_AI_COUPLING
            lonM(i,j)=GRID(ng)%lonr(i,j)
            latM(i,j)=GRID(ng)%latr(i,j)
#endif
#ifdef HCM_WIND_STRESS
#  ifdef HCM_AI_WIND
            sustrC(i,j)=FORCES(ng)%sustrC(i,j)
            svstrC(i,j)=FORCES(ng)%svstrC(i,j)
#  else
            cffU1=cffU1+cffT*FORCES(ng)%dudtW1(i,j)
            cffU2=cffU2+cffT*FORCES(ng)%dudtW2(i,j)
            cffU3=cffU3+cffT*FORCES(ng)%dudtW3(i,j)
            cffU4=cffU4+cffT*FORCES(ng)%dudtW4(i,j)
            cffU5=cffU5+cffT*FORCES(ng)%dudtW5(i,j)
            cffV1=cffV1+cffT*FORCES(ng)%dvdtW1(i,j)
            cffV2=cffV2+cffT*FORCES(ng)%dvdtW2(i,j)
            cffV3=cffV3+cffT*FORCES(ng)%dvdtW3(i,j)
            cffV4=cffV4+cffT*FORCES(ng)%dvdtW4(i,j)
            cffV5=cffV5+cffT*FORCES(ng)%dvdtW5(i,j)
#  endif
#endif
#ifdef HCM_EMINP_FORCE
#  ifdef HCM_AI_FWF
            fwfC(i,j)=FORCES(ng)%rainC(i,j)
#  else
            cffW1=cffW1+cffT*FORCES(ng)%dwdtW1(i,j)
            cffW2=cffW2+cffT*FORCES(ng)%dwdtW2(i,j)
            cffW3=cffW3+cffT*FORCES(ng)%dwdtW3(i,j)
            cffW4=cffW4+cffT*FORCES(ng)%dwdtW4(i,j)
            cffW5=cffW5+cffT*FORCES(ng)%dwdtW5(i,j)
#  endif
#endif
#ifdef TIW_COUPLING
            cffTIW=FORCES(ng)%sstH(i,j)
#  ifdef WET_DRY
            cffTIW=cffTIW*GRID(ng)%rmask_wet(i,j)
#  endif
#  ifdef MASKING
            cffTIW=cffTIW*GRID(ng)%rmask(i,j)
#  endif
#  ifdef HCM_AI_TIW
            sstH(i,j)=cffTIW
#  else
            cffTIW01=cffTIW01+cffTIW*FORCES(ng)%tiwT01(i,j)
            cffTIW02=cffTIW02+cffTIW*FORCES(ng)%tiwT02(i,j)
            cffTIW03=cffTIW03+cffTIW*FORCES(ng)%tiwT03(i,j)
            cffTIW04=cffTIW04+cffTIW*FORCES(ng)%tiwT04(i,j)
            cffTIW05=cffTIW05+cffTIW*FORCES(ng)%tiwT05(i,j)
            cffTIW06=cffTIW06+cffTIW*FORCES(ng)%tiwT06(i,j)
            cffTIW07=cffTIW07+cffTIW*FORCES(ng)%tiwT07(i,j)
            cffTIW08=cffTIW08+cffTIW*FORCES(ng)%tiwT08(i,j)
            cffTIW09=cffTIW09+cffTIW*FORCES(ng)%tiwT09(i,j)
            cffTIW10=cffTIW10+cffTIW*FORCES(ng)%tiwT10(i,j)
#  endif
#endif
          ENDDO
        ENDDO

#ifndef HCM_SST_FILTER
        FORCES(ng)%sstA(LBi:UBi,LBj:UBj)=sstA(LBi:UBi,LBj:UBj)
#endif

#ifdef HCM_AI_COUPLING
        dim1=IendR-IstrR+1
        dim2=JendR-JstrR+1

        len_buffer=dim1*dim2
        allocate(send_buffer(len_buffer))
        send_buffer(len_buffer)=0.0
        send_buffer=reshape(lonM(IstrR:IendR,JstrR:JendR),(/dim1*dim2/))
        do num=1,dim2
          call mpi_isend(send_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,0,tagLON+num,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
        enddo
        deallocate(send_buffer)

        len_buffer=dim1*dim2
        allocate(send_buffer(len_buffer))
        send_buffer(len_buffer)=0.0
        send_buffer=reshape(latM(IstrR:IendR,JstrR:JendR),(/dim1*dim2/))
        do num=1,dim2
          call mpi_isend(send_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,0,tagLAT+num,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
        enddo
        deallocate(send_buffer)

        len_buffer=dim1*dim2
        allocate(send_buffer(len_buffer))
        send_buffer(len_buffer)=0.0
        send_buffer=reshape(sstA(IstrR:IendR,JstrR:JendR),(/dim1*dim2/))
        do num=1,dim2
          call mpi_isend(send_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,0,tagSSTA+num,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
        enddo
        deallocate(send_buffer)
#endif

#ifdef HCM_WIND_STRESS
#  ifdef HCM_AI_WIND
        len_buffer=dim1*dim2
        allocate(send_buffer(len_buffer))
        send_buffer(len_buffer)=0.0
        send_buffer=reshape(sustrC(IstrR:IendR,JstrR:JendR),(/dim1*dim2/))
        do num=1,dim2
          call mpi_isend(send_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,0,tagUc+num,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
        enddo
        deallocate(send_buffer)

        len_buffer=dim1*dim2
        allocate(send_buffer(len_buffer))
        send_buffer(len_buffer)=0.0
        send_buffer=reshape(svstrC(IstrR:IendR,JstrR:JendR),(/dim1*dim2/))
        do num=1,dim2
          call mpi_isend(send_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,0,tagVc+num,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
        enddo
        deallocate(send_buffer)
#  else
        len_buffer=5
        allocate(send_buffer(len_buffer))
        send_buffer(1)=cffU1
        send_buffer(2)=cffU2
        send_buffer(3)=cffU3
        send_buffer(4)=cffU4
        send_buffer(5)=cffU5
        call mpi_isend(send_buffer,len_buffer,MPI_REAL8,0,tagUw,MPI_COMM_WORLD,request,ierr)
        call mpi_wait(request,rstatus,ierr)
        deallocate(send_buffer)

        len_buffer=5
        allocate(send_buffer(len_buffer))
        send_buffer(1)=cffV1
        send_buffer(2)=cffV2
        send_buffer(3)=cffV3
        send_buffer(4)=cffV4
        send_buffer(5)=cffV5
        call mpi_isend(send_buffer,len_buffer,MPI_REAL8,0,tagVw,MPI_COMM_WORLD,request,ierr)
        call mpi_wait(request,rstatus,ierr)
        deallocate(send_buffer)
#  endif
#endif
#ifdef HCM_EMINP_FORCE
#  ifdef HCM_AI_FWF
        len_buffer=dim1*dim2
        allocate(send_buffer(len_buffer))
        send_buffer(len_buffer)=0.0
        send_buffer=reshape(fwfC(IstrR:IendR,JstrR:JendR),(/dim1*dim2/))
        do num=1,dim2
          call mpi_isend(send_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,0,tagWc+num,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
        enddo
        deallocate(send_buffer)
#  else
        len_buffer=5
        allocate(send_buffer(len_buffer))
        send_buffer(1)=cffW1
        send_buffer(2)=cffW2
        send_buffer(3)=cffW3
        send_buffer(4)=cffW4
        send_buffer(5)=cffW5
        call mpi_isend(send_buffer,len_buffer,MPI_REAL8,0,tagWw,MPI_COMM_WORLD,request,ierr)
        call mpi_wait(request,rstatus,ierr)
        deallocate(send_buffer)
#  endif
#endif
#ifdef TIW_COUPLING
#  ifdef HCM_AI_TIW
        len_buffer=dim1*dim2
        allocate(send_buffer(len_buffer))
        send_buffer(len_buffer)=0.0
        send_buffer=reshape(sstH(IstrR:IendR,JstrR:JendR),(/dim1*dim2/))
        do num=1,dim2
          call mpi_isend(send_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,0,tagSSTH+num,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
        enddo
        deallocate(send_buffer)
#  else
        len_buffer=10
        allocate(send_buffer(len_buffer))
        send_buffer(1)=cffTIW01
        send_buffer(2)=cffTIW02
        send_buffer(3)=cffTIW03
        send_buffer(4)=cffTIW04
        send_buffer(5)=cffTIW05
        send_buffer(6)=cffTIW06
        send_buffer(7)=cffTIW07
        send_buffer(8)=cffTIW08
        send_buffer(9)=cffTIW09
        send_buffer(10)=cffTIW10
        call mpi_isend(send_buffer,len_buffer,MPI_REAL8,0,tagTIWw,MPI_COMM_WORLD,request,ierr)
        call mpi_wait(request,rstatus,ierr)
        deallocate(send_buffer)
#  endif
#endif

!-----------------------------------------------------------------------
        call  mpi_barrier(MPI_COMM_WORLD, ierr)
!-----------------------------------------------------------------------
! END MyRank/=MyMaster
      endif




!-----------------------------------------------------------------------
! RECEIVE From MPI if MyRank==MyMaster
!-----------------------------------------------------------------------
      if (MyRank==MyMaster) then
       !WRITE (*,*) ' MyRank==MyMaster '
        LBi=BOUNDS(ng) % LBi(MyRank)
        UBi=BOUNDS(ng) % UBi(MyRank)
        LBj=BOUNDS(ng) % LBj(MyRank)
        UBj=BOUNDS(ng) % UBj(MyRank)
        IstrR=LBi+NghostPoints
        IendR=UBi-NghostPoints
        JstrR=LBj+NghostPoints
        JendR=UBj-NghostPoints
        if (LBi<NghostPoints) then
        IstrR=LBi
        endif
        if (UBi>Lm(ng)) then
        IendR=UBi
        endif
        if (LBj<NghostPoints) then
        JstrR=LBj
        endif
        if (UBj>=Mm(ng)) then
        JendR=UBj
        endif
!-----------------------------------------------------------------------
!beg weight for dudt 
#ifdef HCM_WIND_STRESS
#  ifndef HCM_AI_WIND
        cffU1=0.0_r8
        cffU2=0.0_r8
        cffU3=0.0_r8
        cffU4=0.0_r8
        cffU5=0.0_r8
        cffV1=0.0_r8
        cffV2=0.0_r8
        cffV3=0.0_r8
        cffV4=0.0_r8
        cffV5=0.0_r8
#  endif
#endif
#ifdef HCM_EMINP_FORCE
#  ifndef HCM_AI_FWF
        cffW1=0.0_r8
        cffW2=0.0_r8
        cffW3=0.0_r8
        cffW4=0.0_r8
        cffW5=0.0_r8
#  endif
#endif
#ifdef TIW_COUPLING
#  ifndef HCM_AI_TIW
        cffTIW01=0.0_r8
        cffTIW02=0.0_r8
        cffTIW03=0.0_r8
        cffTIW04=0.0_r8
        cffTIW05=0.0_r8
        cffTIW06=0.0_r8
        cffTIW07=0.0_r8
        cffTIW08=0.0_r8
        cffTIW09=0.0_r8
        cffTIW10=0.0_r8
#  endif
#endif
        DO j=JstrR,JendR
          DO i=IstrR,IendR
            sstC=FORCES(ng)%sstC(i,j)
#    ifdef HCM_SST_FILTER
            sstM=FORCES(ng)%sstA(i,j)
#    else
            sstM=OCEAN(ng)%t(i,j,N(ng),nrhs(ng),itemp)-sstC
#    endif
#    ifdef HCM_INITIAL_KICK
            lonr=GRID(ng)%lonr(i,j)
            latr=GRID(ng)%latr(i,j)
            IF (tdays(ng).gt.hcm_kick_date(ng)-1.0_r8                   &
     &    .and. tdays(ng).lt.hcm_kick_date(ng)+hcm_kick_time(ng)) THEN
              cffX=lonr-hcm_kick_locx(ng)
              cffY=latr-hcm_kick_locy(ng)
              cffX=cffX/hcm_kick_lenx(ng)
              cffY=cffY/hcm_kick_leny(ng)
              cffL=EXP(-cffX*cffX)*EXP(-cffY*cffY)
              cffT=cffL*hcm_kick_temp(ng)
            ELSE
              cffT=sstM
            ENDIF
#    else
            cffT=sstM
#    endif
#    ifdef WET_DRY
            cffT=cffT*GRID(ng)%rmask_wet(i,j)
#    endif
#    ifdef MASKING
            cffT=cffT*GRID(ng)%rmask(i,j)
#    endif
            sstA(i,j)=cffT
#ifdef HCM_AI_COUPLING
            lonM(i,j)=GRID(ng)%lonr(i,j)
            latM(i,j)=GRID(ng)%latr(i,j)
#endif
#ifdef HCM_WIND_STRESS
#  ifdef HCM_AI_WIND
            sustrC(i,j)=FORCES(ng)%sustrC(i,j)
            svstrC(i,j)=FORCES(ng)%svstrC(i,j)
#  else
            cffU1=cffU1+cffT*FORCES(ng)%dudtW1(i,j)
            cffU2=cffU2+cffT*FORCES(ng)%dudtW2(i,j)
            cffU3=cffU3+cffT*FORCES(ng)%dudtW3(i,j)
            cffU4=cffU4+cffT*FORCES(ng)%dudtW4(i,j)
            cffU5=cffU5+cffT*FORCES(ng)%dudtW5(i,j)
            cffV1=cffV1+cffT*FORCES(ng)%dvdtW1(i,j)
            cffV2=cffV2+cffT*FORCES(ng)%dvdtW2(i,j)
            cffV3=cffV3+cffT*FORCES(ng)%dvdtW3(i,j)
            cffV4=cffV4+cffT*FORCES(ng)%dvdtW4(i,j)
            cffV5=cffV5+cffT*FORCES(ng)%dvdtW5(i,j)
#  endif
#endif
#ifdef HCM_EMINP_FORCE
#  ifdef HCM_AI_FWF
            fwfC(i,j)=FORCES(ng)%rainC(i,j)
#  else
            cffW1=cffW1+cffT*FORCES(ng)%dwdtW1(i,j)
            cffW2=cffW2+cffT*FORCES(ng)%dwdtW2(i,j)
            cffW3=cffW3+cffT*FORCES(ng)%dwdtW3(i,j)
            cffW4=cffW4+cffT*FORCES(ng)%dwdtW4(i,j)
            cffW5=cffW5+cffT*FORCES(ng)%dwdtW5(i,j)
#  endif
#endif
#ifdef TIW_COUPLING
            cffTIW=FORCES(ng)%sstH(i,j)
#  ifdef WET_DRY
            cffTIW=cffTIW*GRID(ng)%rmask_wet(i,j)
#  endif
#  ifdef MASKING
            cffTIW=cffTIW*GRID(ng)%rmask(i,j)
#  endif
#  ifdef HCM_AI_TIW
            sstH(i,j)=cffTIW
#  else
            cffTIW01=cffTIW01+cffTIW*FORCES(ng)%tiwT01(i,j)
            cffTIW02=cffTIW02+cffTIW*FORCES(ng)%tiwT02(i,j)
            cffTIW03=cffTIW03+cffTIW*FORCES(ng)%tiwT03(i,j)
            cffTIW04=cffTIW04+cffTIW*FORCES(ng)%tiwT04(i,j)
            cffTIW05=cffTIW05+cffTIW*FORCES(ng)%tiwT05(i,j)
            cffTIW06=cffTIW06+cffTIW*FORCES(ng)%tiwT06(i,j)
            cffTIW07=cffTIW07+cffTIW*FORCES(ng)%tiwT07(i,j)
            cffTIW08=cffTIW08+cffTIW*FORCES(ng)%tiwT08(i,j)
            cffTIW09=cffTIW09+cffTIW*FORCES(ng)%tiwT09(i,j)
            cffTIW10=cffTIW10+cffTIW*FORCES(ng)%tiwT10(i,j)
#  endif
#endif
          ENDDO
        ENDDO

#    ifndef HCM_SST_FILTER
        FORCES(ng)%sstA(LBi:UBi,LBj:UBj)=sstA(LBi:UBi,LBj:UBj)
#    endif

!-----------------------------------------------------------------------
        call  mpi_barrier(MPI_COMM_WORLD, ierr)
!-----------------------------------------------------------------------

        do tile=1,Ntiles
#ifdef HCM_AI_COUPLING
          LBi=BOUNDS(ng) % LBi(tile)
          UBi=BOUNDS(ng) % UBi(tile)
          LBj=BOUNDS(ng) % LBj(tile)
          UBj=BOUNDS(ng) % UBj(tile)
          IstrR=LBi+NghostPoints
          IendR=UBi-NghostPoints
          JstrR=LBj+NghostPoints
          JendR=UBj-NghostPoints
          if (LBi<NghostPoints) then
          IstrR=LBi
          endif
          if (UBi>Lm(ng)) then
          IendR=UBi
          endif
          if (LBj<NghostPoints) then
          JstrR=LBj
          endif
          if (UBj>=Mm(ng)) then
          JendR=UBj
          endif
          dim1=IendR-IstrR+1
          dim2=JendR-JstrR+1

          len_buffer=dim1*dim2
          allocate(recv_buffer(len_buffer))
          recv_buffer(len_buffer)=0.0
          do num=1,dim2
            call mpi_irecv(recv_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,tile,tagLON+num,MPI_COMM_WORLD,request,ierr)
            call mpi_wait(request,rstatus,ierr)
          enddo
          lonM(IstrR:IendR,JstrR:JendR)=reshape(recv_buffer,(/dim1,dim2/))
          deallocate(recv_buffer)

          len_buffer=dim1*dim2
          allocate(recv_buffer(len_buffer))
          recv_buffer(len_buffer)=0.0
          do num=1,dim2
            call mpi_irecv(recv_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,tile,tagLAT+num,MPI_COMM_WORLD,request,ierr)
            call mpi_wait(request,rstatus,ierr)
          enddo
          latM(IstrR:IendR,JstrR:JendR)=reshape(recv_buffer,(/dim1,dim2/))
          deallocate(recv_buffer)

          len_buffer=dim1*dim2
          allocate(recv_buffer(len_buffer))
          recv_buffer(len_buffer)=0.0
          do num=1,dim2
            call mpi_irecv(recv_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,tile,tagSSTA+num,MPI_COMM_WORLD,request,ierr)
            call mpi_wait(request,rstatus,ierr)
          enddo
          sstA(IstrR:IendR,JstrR:JendR)=reshape(recv_buffer,(/dim1,dim2/))
          deallocate(recv_buffer)
#endif
#ifdef HCM_WIND_STRESS
#  ifdef HCM_AI_WIND
          len_buffer=dim1*dim2
          allocate(recv_buffer(len_buffer))
          recv_buffer(len_buffer)=0.0
          do num=1,dim2
            call mpi_irecv(recv_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,tile,tagUc+num,MPI_COMM_WORLD,request,ierr)
            call mpi_wait(request,rstatus,ierr)
          enddo
          sustrC(IstrR:IendR,JstrR:JendR)=reshape(recv_buffer,(/dim1,dim2/))
          deallocate(recv_buffer)

          len_buffer=dim1*dim2
          allocate(recv_buffer(len_buffer))
          recv_buffer(len_buffer)=0.0
          do num=1,dim2
            call mpi_irecv(recv_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,tile,tagVc+num,MPI_COMM_WORLD,request,ierr)
            call mpi_wait(request,rstatus,ierr)
          enddo
          svstrC(IstrR:IendR,JstrR:JendR)=reshape(recv_buffer,(/dim1,dim2/))
          deallocate(recv_buffer)
#  else
          len_buffer=5
          allocate(recv_buffer(len_buffer))
          recv_buffer(len_buffer)=0.0
          call mpi_irecv(recv_buffer,len_buffer,MPI_REAL8,tile,tagUw,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
          cffU1=cffU1+recv_buffer(1)
          cffU2=cffU2+recv_buffer(2)
          cffU3=cffU3+recv_buffer(3)
          cffU4=cffU4+recv_buffer(4)
          cffU5=cffU5+recv_buffer(5)
          deallocate(recv_buffer)

          len_buffer=5
          allocate(recv_buffer(len_buffer))
          recv_buffer(len_buffer)=0.0
          call mpi_irecv(recv_buffer,len_buffer,MPI_REAL8,tile,tagVw,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
          cffV1=cffV1+recv_buffer(1)
          cffV2=cffV2+recv_buffer(2)
          cffV3=cffV3+recv_buffer(3)
          cffV4=cffV4+recv_buffer(4)
          cffV5=cffV5+recv_buffer(5)
          deallocate(recv_buffer)
#  endif
#endif
#ifdef HCM_EMINP_FORCE
#  ifdef HCM_AI_FWF
          len_buffer=dim1*dim2
          allocate(recv_buffer(len_buffer))
          recv_buffer(len_buffer)=0.0
          do num=1,dim2
            call mpi_irecv(recv_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,tile,tagWc+num,MPI_COMM_WORLD,request,ierr)
            call mpi_wait(request,rstatus,ierr)
          enddo
          fwfC(IstrR:IendR,JstrR:JendR)=reshape(recv_buffer,(/dim1,dim2/))
          deallocate(recv_buffer)
#  else
          len_buffer=5
          allocate(recv_buffer(len_buffer))
          recv_buffer(len_buffer)=0.0
          call mpi_irecv(recv_buffer,len_buffer,MPI_REAL8,tile,tagWw,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
          cffW1=cffW1+recv_buffer(1)
          cffW2=cffW2+recv_buffer(2)
          cffW3=cffW3+recv_buffer(3)
          cffW4=cffW4+recv_buffer(4)
          cffW5=cffW5+recv_buffer(5)
          deallocate(recv_buffer)
#  endif
#endif
#ifdef TIW_COUPLING
#  ifdef HCM_AI_TIW
          len_buffer=dim1*dim2
          allocate(recv_buffer(len_buffer))
          recv_buffer(len_buffer)=0.0
          do num=1,dim2
            call mpi_irecv(recv_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,tile,tagSSTH+num,MPI_COMM_WORLD,request,ierr)
            call mpi_wait(request,rstatus,ierr)
          enddo
          sstH(IstrR:IendR,JstrR:JendR)=reshape(recv_buffer,(/dim1,dim2/))
          deallocate(recv_buffer)
#  else
          len_buffer=10
          allocate(recv_buffer(len_buffer))
          recv_buffer(len_buffer)=0.0
          call mpi_irecv(recv_buffer,len_buffer,MPI_REAL8,tile,tagTIWw,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
          cffTIW01=cffTIW01+recv_buffer(1)
          cffTIW02=cffTIW02+recv_buffer(2)
          cffTIW03=cffTIW03+recv_buffer(3)
          cffTIW04=cffTIW04+recv_buffer(4)
          cffTIW05=cffTIW05+recv_buffer(5)
          cffTIW06=cffTIW06+recv_buffer(6)
          cffTIW07=cffTIW07+recv_buffer(7)
          cffTIW08=cffTIW08+recv_buffer(8)
          cffTIW09=cffTIW09+recv_buffer(9)
          cffTIW10=cffTIW10+recv_buffer(10)
          deallocate(recv_buffer)
#  endif
#endif
        enddo

! END MyRank==MyMaster
      endif
!-----------------------------------------------------------------------




! Calculate HCM forcing and scatter to different ranks
      if (MyRank==MyMaster) then
        LBi=BOUNDS(ng) % LBi(MyRank)
        UBi=BOUNDS(ng) % UBi(MyRank)
        LBj=BOUNDS(ng) % LBj(MyRank)
        UBj=BOUNDS(ng) % UBj(MyRank)
!=======================================================================
        IF (MOD(time(ng),hcm_coup_time(ng)).eq.0) THEN
          WRITE (*,*) ' Hybrid Coupled Model (HCM) coupling '
#ifdef HCM_AI_COUPLING
          COUPnum=time(ng)/hcm_coup_time(ng)
          CALL time_string (time(ng),fileT)
          OPEN  (1101,file='./COUP/COUPnum.txt')
          WRITE (1101,*) COUPnum
          CLOSE (1101)
          OPEN  (1102,file='./COUP/LON_'//fileT//'.txt')
          WRITE (1102,"(F15.6)") lonM
          CLOSE (1102)
          OPEN  (1103,file='./COUP/LAT_'//fileT//'.txt')
          WRITE (1103,"(F15.6)") latM
          CLOSE (1103)
          OPEN  (1104,file='./COUP/SSTA_'//fileT//'.txt')
          WRITE (1104,"(F15.6)") sstA
          CLOSE (1104)
#  ifdef HCM_AI_TIW
          OPEN  (1105,file='./COUP/SSTH_'//fileT//'.txt')
          WRITE (1105,"(F15.6)") sstH
          CLOSE (1105)
#  endif
          OPEN  (1199,file='./COUP/TIME_'//fileT//'.txt')
          WRITE (1199,*) time(ng)
          CLOSE (1199)
#endif
#ifdef HCM_WIND_STRESS
#  ifndef HCM_AI_WIND
          OPEN  (1201,file='./Build/hcm_dudt_weight.dat')
          WRITE (1201,*) cffU1, cffU2, cffU3, cffU4, cffU5
          CLOSE (1201)
          WRITE (*,*) ' HCM weights for U wind stress'
          WRITE (*,*) ' Mod 1:', cffU1, ' Mod 2:', cffU2
          WRITE (*,*) ' Mod 3:', cffU3, ' Mod 4:', cffU4
          WRITE (*,*) ' Mod 5:', cffU5
          cffU1N=cffU1
          cffU2N=cffU2
          cffU3N=cffU3
          cffU4N=cffU4
          cffU5N=cffU5

          OPEN  (1202,file='./Build/hcm_dvdt_weight.dat')
          WRITE (1202,*) cffV1, cffV2, cffV3, cffV4, cffV5
          CLOSE (1202)
          WRITE (*,*) ' HCM weights for V wind stress'
          WRITE (*,*) ' Mod 1:', cffV1, ' Mod 2:', cffV2
          WRITE (*,*) ' Mod 3:', cffV3, ' Mod 4:', cffV4
          WRITE (*,*) ' Mod 5:', cffV5
          cffV1N=cffV1
          cffV2N=cffV2
          cffV3N=cffV3
          cffV4N=cffV4
          cffV5N=cffV5
#  endif
#endif
#ifdef HCM_EMINP_FORCE
#  ifndef HCM_AI_FWF
          OPEN  (1203,file='./Build/hcm_dwdt_weight.dat')
          WRITE (1203,*) cffW1, cffW2, cffW3, cffW4, cffW5
          CLOSE (1203)
          WRITE (*,*) ' HCM weights for fresh water flux (E-P)'
          WRITE (*,*) ' Mod 1:', cffW1, ' Mod 2:', cffW2
          WRITE (*,*) ' Mod 3:', cffW3, ' Mod 4:', cffW4
          WRITE (*,*) ' Mod 5:', cffW5
          cffW1N=cffW1
          cffW2N=cffW2
          cffW3N=cffW3
          cffW4N=cffW4
          cffW5N=cffW5
#  endif
#endif
#ifdef TIW_COUPLING
#  ifndef HCM_AI_TIW
          OPEN  (1204,file='./Build/hcm_tiw_weight.dat')
          WRITE (1204,*) cffTIW01, cffTIW02, cffTIW03, cffTIW04, cffTIW05,  &
     &                   cffTIW06, cffTIW07, cffTIW08, cffTIW09, cffTIW10
          CLOSE (1204)
          WRITE (*,*) ' HCM weights for TIW wind stress'
          WRITE (*,*) ' Mod  1:', cffTIW01, ' Mod  2:', cffTIW02
          WRITE (*,*) ' Mod  3:', cffTIW03, ' Mod  4:', cffTIW04
          WRITE (*,*) ' Mod  5:', cffTIW05, ' Mod  6:', cffTIW06
          WRITE (*,*) ' Mod  7:', cffTIW07, ' Mod  8:', cffTIW08
          WRITE (*,*) ' Mod  9:', cffTIW09, ' Mod 10:', cffTIW10
          cffTIW01N=cffTIW01
          cffTIW02N=cffTIW02
          cffTIW03N=cffTIW03
          cffTIW04N=cffTIW04
          cffTIW05N=cffTIW05
          cffTIW06N=cffTIW06
          cffTIW07N=cffTIW07
          cffTIW08N=cffTIW08
          cffTIW09N=cffTIW09
          cffTIW10N=cffTIW10
#  endif
#endif
        ELSE
#ifdef HCM_AI_COUPLING
          OPEN  (1101,file='./COUP/COUPnum.txt')
          READ (1101,*) COUPnum
          CLOSE (1101)
          CALL time_string (hcm_coup_time(ng)*COUPnum,fileT)
#endif
#ifdef HCM_WIND_STRESS
#  ifndef HCM_AI_WIND
          cffU1N=0.0_r8
          cffU2N=0.0_r8
          cffU3N=0.0_r8
          cffU4N=0.0_r8
          cffU5N=0.0_r8
          OPEN  (2101,file='./Build/hcm_dudt_weight.dat')
          READ  (2101,*) cffU1N, cffU2N, cffU3N, cffU4N, cffU5N
          CLOSE (2101)

          cffV1N=0.0_r8
          cffV2N=0.0_r8
          cffV3N=0.0_r8
          cffV4N=0.0_r8
          cffV5N=0.0_r8
          OPEN  (2102,file='./Build/hcm_dvdt_weight.dat')
          READ  (2102,*) cffV1N, cffV2N, cffV3N, cffV4N, cffV5N
          CLOSE (2102)
#  endif
#endif
#ifdef HCM_EMINP_FORCE
#  ifndef HCM_AI_FWF
          cffW1N=0.0_r8
          cffW2N=0.0_r8
          cffW3N=0.0_r8
          cffW4N=0.0_r8
          cffW5N=0.0_r8
          OPEN  (2103,file='./Build/hcm_dwdt_weight.dat')
          READ  (2103,*) cffW1N, cffW2N, cffW3N, cffW4N, cffW5N
          CLOSE (2103)
#  endif
#endif
#ifdef TIW_COUPLING
#  ifndef HCM_AI_TIW
          cffTIW01N=0.0_r8
          cffTIW02N=0.0_r8
          cffTIW03N=0.0_r8
          cffTIW04N=0.0_r8
          cffTIW05N=0.0_r8
          cffTIW06N=0.0_r8
          cffTIW07N=0.0_r8
          cffTIW08N=0.0_r8
          cffTIW09N=0.0_r8
          cffTIW10N=0.0_r8
          OPEN  (2104,file='./Build/hcm_tiw_weight.dat')
          READ  (2104,*) cffTIW01N,cffTIW02N,cffTIW03N,cffTIW04N,cffTIW05N, &
     &                   cffTIW06N,cffTIW07N,cffTIW08N,cffTIW09N,cffTIW10N
          CLOSE (2104)
#  endif
#endif
        ENDIF
!-----------------------------------------------------------------------
#ifdef HCM_AI_COUPLING
        AI_NUM=1.0_r8
        inquire(file='./COUP/FINISH_'//fileT//'.txt',exist=AI_FINISH)
        DO WHILE (AI_FINISH == 0)
        inquire(file='./COUP/FINISH_'//fileT//'.txt',exist=AI_FINISH)
        AI_NUM=AI_NUM+1.0_r8
        ENDDO

#  ifdef HCM_AI_WIND
        fileN='./COUP/sustrA_'//fileT//'.txt'
        WRITE(*,*) ' Load Data From: ',fileN
        OPEN  (3101,file=fileN)
        do j=JLB,JUB
          do i=ILB,IUB
          AIDT(i,j)=0.0_r8
          READ(3101,"(F15.6)") AIDT(i,j)
          enddo
        enddo
        CLOSE (3101)
        do i=ILB+1,IUB
          do j=JLB,JUB
          cffM=AIDT(i-1,j)
          cffR=AIDT(i,j)
          sustrA(i,j)=0.5_r8*(cffM+cffR)
          sustr(i,j)=sustrC(i,j)+sustrA(i,j)
          sustr(i,j)=sustr(i,j)/rho0
          enddo
        enddo

        fileN='./COUP/svstrA_'//fileT//'.txt'
        WRITE(*,*) ' Load Data From: ',fileN
        OPEN  (3102,file=fileN)
        do j=JLB,JUB
          do i=ILB,IUB
          AIDT(i,j)=0.0_r8
          READ(3102,"(F15.6)") AIDT(i,j)
          enddo
        enddo
        CLOSE (3102)
        do i=ILB,IUB
          do j=JLB+1,JUB
          cffM=AIDT(i,j-1)
          cffR=AIDT(i,j)
          svstrA(i,j)=0.5_r8*(cffM+cffR)
          svstr(i,j)=svstrC(i,j)+svstrA(i,j)
          svstr(i,j)=svstr(i,j)/rho0
          enddo
        enddo
#  endif

#  ifdef HCM_AI_FWF
        fileN='./COUP/FWFA_'//fileT//'.txt'
        WRITE(*,*) ' Load Data From: ',fileN
        OPEN  (3103,file=fileN)
        do j=JLB,JUB
          do i=ILB,IUB
          AIDT(i,j)=0.0_r8
          READ(3103,"(F15.6)") AIDT(i,j)
          enddo
        enddo
        CLOSE (3103)
        do i=ILB,IUB
          do j=JLB,JUB
          fwfA(i,j)=AIDT(i,j)
          fwf(i,j)=fwfC(i,j)+fwfA(i,j)
          enddo
        enddo
#  endif

#  ifdef HCM_AI_TIW
        fileN='./COUP/sustrTIW_'//fileT//'.txt'
        WRITE(*,*) ' Load Data From: ',fileN
        OPEN  (3104,file=fileN)
        do j=JLB,JUB
          do i=ILB,IUB
          AIDT(i,j)=0.0_r8
          READ(3104,"(F15.6)") AIDT(i,j)
          enddo
        enddo
        CLOSE (3104)
        do i=ILB+1,IUB
          do j=JLB,JUB
          cffM=AIDT(i-1,j)
          cffR=AIDT(i,j)
          sustrTIW(i,j)=0.5_r8*(cffM+cffR)
          enddo
        enddo

        fileN='./COUP/svstrTIW_'//fileT//'.txt'
        WRITE(*,*) ' Load Data From: ',fileN
        OPEN  (3105,file=fileN)
        do j=JLB,JUB
          do i=ILB,IUB
          AIDT(i,j)=0.0_r8
          READ(3105,"(F15.6)") AIDT(i,j)
          enddo
        enddo
        CLOSE (3105)
        do i=ILB,IUB
          do j=JLB+1,JUB
          cffM=AIDT(i,j-1)
          cffR=AIDT(i,j)
          svstrTIW(i,j)=0.5_r8*(cffM+cffR)
          enddo
        enddo
#  endif

#endif
!-----------------------------------------------------------------------

        do tile=1,Ntiles
#ifdef HCM_AI_COUPLING
          LBi=BOUNDS(ng) % LBi(tile)
          UBi=BOUNDS(ng) % UBi(tile)
          LBj=BOUNDS(ng) % LBj(tile)
          UBj=BOUNDS(ng) % UBj(tile)
          dim1=UBi-LBi+1
          dim2=UBj-LBj+1
#endif
#ifdef HCM_WIND_STRESS
#  ifdef HCM_AI_WIND
          len_buffer=dim1*dim2
          allocate(send_buffer(len_buffer))
          send_buffer(len_buffer)=0.0
          send_buffer=reshape(sustr(LBi:UBi,LBj:UBj),(/len_buffer/))
          do num=1,dim2
            call mpi_isend(send_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,tile,tagU+num,MPI_COMM_WORLD,request,ierr)
            call mpi_wait(request,rstatus,ierr)
          enddo
          deallocate(send_buffer)

          len_buffer=dim1*dim2
          allocate(send_buffer(len_buffer))
          send_buffer(len_buffer)=0.0
          send_buffer=reshape(svstr(LBi:UBi,LBj:UBj),(/len_buffer/))
          do num=1,dim2
            call mpi_isend(send_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,tile,tagV+num,MPI_COMM_WORLD,request,ierr)
            call mpi_wait(request,rstatus,ierr)
          enddo
          deallocate(send_buffer)

          len_buffer=dim1*dim2
          allocate(send_buffer(len_buffer))
          send_buffer(len_buffer)=0.0
          send_buffer=reshape(sustrA(LBi:UBi,LBj:UBj),(/len_buffer/))
          do num=1,dim2
            call mpi_isend(send_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,tile,tagUa+num,MPI_COMM_WORLD,request,ierr)
            call mpi_wait(request,rstatus,ierr)
          enddo
          deallocate(send_buffer)

          len_buffer=dim1*dim2
          allocate(send_buffer(len_buffer))
          send_buffer(len_buffer)=0.0
          send_buffer=reshape(svstrA(LBi:UBi,LBj:UBj),(/len_buffer/))
          do num=1,dim2
            call mpi_isend(send_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,tile,tagVa+num,MPI_COMM_WORLD,request,ierr)
            call mpi_wait(request,rstatus,ierr)
          enddo
          deallocate(send_buffer)
#  else
          len_buffer=5
          allocate(send_buffer(len_buffer))
          send_buffer(1)=cffU1N
          send_buffer(2)=cffU2N
          send_buffer(3)=cffU3N
          send_buffer(4)=cffU4N
          send_buffer(5)=cffU5N
          call mpi_isend(send_buffer,len_buffer,MPI_REAL8,tile,tagUwN,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
          deallocate(send_buffer)

          len_buffer=5
          allocate(send_buffer(len_buffer))
          send_buffer(1)=cffV1N
          send_buffer(2)=cffV2N
          send_buffer(3)=cffV3N
          send_buffer(4)=cffV4N
          send_buffer(5)=cffV5N
          call mpi_isend(send_buffer,len_buffer,MPI_REAL8,tile,tagVwN,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
          deallocate(send_buffer)
#  endif
#endif
#ifdef HCM_EMINP_FORCE
#  ifdef HCM_AI_FWF
          len_buffer=dim1*dim2
          allocate(send_buffer(len_buffer))
          send_buffer(len_buffer)=0.0
          send_buffer=reshape(fwf(LBi:UBi,LBj:UBj),(/len_buffer/))
          do num=1,dim2
            call mpi_isend(send_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,tile,tagW+num,MPI_COMM_WORLD,request,ierr)
            call mpi_wait(request,rstatus,ierr)
          enddo
          deallocate(send_buffer)

          len_buffer=dim1*dim2
          allocate(send_buffer(len_buffer))
          send_buffer(len_buffer)=0.0
          send_buffer=reshape(fwfA(LBi:UBi,LBj:UBj),(/len_buffer/))
          do num=1,dim2
            call mpi_isend(send_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,tile,tagWa+num,MPI_COMM_WORLD,request,ierr)
            call mpi_wait(request,rstatus,ierr)
          enddo
          deallocate(send_buffer)
#  else
          len_buffer=5
          allocate(send_buffer(len_buffer))
          send_buffer(1)=cffW1N
          send_buffer(2)=cffW2N
          send_buffer(3)=cffW3N
          send_buffer(4)=cffW4N
          send_buffer(5)=cffW5N
          call mpi_isend(send_buffer,len_buffer,MPI_REAL8,tile,tagWwN,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
          deallocate(send_buffer)
#  endif
#endif
#ifdef TIW_COUPLING
#  ifdef HCM_AI_TIW
          len_buffer=dim1*dim2
          allocate(send_buffer(len_buffer))
          send_buffer(len_buffer)=0.0
          send_buffer=reshape(sustrTIW(LBi:UBi,LBj:UBj),(/len_buffer/))
          do num=1,dim2
            call mpi_isend(send_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,tile,tagTIWu+num,MPI_COMM_WORLD,request,ierr)
            call mpi_wait(request,rstatus,ierr)
          enddo
          deallocate(send_buffer)

          allocate(send_buffer(len_buffer))
          send_buffer(len_buffer)=0.0
          send_buffer=reshape(svstrTIW(LBi:UBi,LBj:UBj),(/len_buffer/))
          do num=1,dim2
            call mpi_isend(send_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,tile,tagTIWv+num,MPI_COMM_WORLD,request,ierr)
            call mpi_wait(request,rstatus,ierr)
          enddo
          deallocate(send_buffer)
#  else
          len_buffer=10
          allocate(send_buffer(len_buffer))
          send_buffer(1)=cffTIW01N
          send_buffer(2)=cffTIW02N
          send_buffer(3)=cffTIW03N
          send_buffer(4)=cffTIW04N
          send_buffer(5)=cffTIW05N
          send_buffer(6)=cffTIW06N
          send_buffer(7)=cffTIW07N
          send_buffer(8)=cffTIW08N
          send_buffer(9)=cffTIW09N
          send_buffer(10)=cffTIW10N
          call mpi_isend(send_buffer,len_buffer,MPI_REAL8,tile,tagTIWwN,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
          deallocate(send_buffer)
#  endif
#endif
        enddo
!-----------------------------------------------------------------------
        call  mpi_barrier(MPI_COMM_WORLD, ierr)
!-----------------------------------------------------------------------
#ifdef HCM_WIND_STRESS
#  ifndef HCM_AI_WIND
        do i=ILB+1,IUB
          do j=JLB,JUB
            cffM=cffU1N*FORCES(ng)%dudtM1(i-1,j)                        &
     &          +cffU2N*FORCES(ng)%dudtM2(i-1,j)                        &
     &          +cffU3N*FORCES(ng)%dudtM3(i-1,j)                        &
     &          +cffU4N*FORCES(ng)%dudtM4(i-1,j)                        &
     &          +cffU5N*FORCES(ng)%dudtM5(i-1,j)
            cffR=cffU1N*FORCES(ng)%dudtM1(i,j)                          &
     &          +cffU2N*FORCES(ng)%dudtM2(i,j)                          &
     &          +cffU3N*FORCES(ng)%dudtM3(i,j)                          &
     &          +cffU4N*FORCES(ng)%dudtM4(i,j)                          &
     &          +cffU5N*FORCES(ng)%dudtM5(i,j)
          sustrA(i,j)=0.5_r8*hcm_alpha_tau(ng)*(cffM+cffR)
          sustrC(i,j)=FORCES(ng)%sustrC(i,j)
          sustr(i,j)=sustrC(i,j)+sustrA(i,j)
          sustr(i,j)=sustr(i,j)/rho0
          enddo
        enddo
        do i=ILB,IUB
          do j=JLB+1,JUB
            cffM=cffV1N*FORCES(ng)%dvdtM1(i,j-1)                        &
     &          +cffV2N*FORCES(ng)%dvdtM2(i,j-1)                        &
     &          +cffV3N*FORCES(ng)%dvdtM3(i,j-1)                        &
     &          +cffV4N*FORCES(ng)%dvdtM4(i,j-1)                        &
     &          +cffV5N*FORCES(ng)%dvdtM5(i,j-1)
            cffR=cffV1N*FORCES(ng)%dvdtM1(i,j)                          &
     &          +cffV2N*FORCES(ng)%dvdtM2(i,j)                          &
     &          +cffV3N*FORCES(ng)%dvdtM3(i,j)                          &
     &          +cffV4N*FORCES(ng)%dvdtM4(i,j)                          &
     &          +cffV5N*FORCES(ng)%dvdtM5(i,j)
          svstrA(i,j)=0.5_r8*hcm_alpha_tau(ng)*(cffM+cffR)
          svstrC(i,j)=FORCES(ng)%svstrC(i,j)
          svstr(i,j)=svstrC(i,j)+svstrA(i,j)
          svstr(i,j)=svstr(i,j)/rho0
          enddo
        enddo
#  endif
        FORCES(ng)%sustrA(LBi:UBi,LBj:UBj)=sustrA(LBi:UBi,LBj:UBj)
        FORCES(ng)%svstrA(LBi:UBi,LBj:UBj)=svstrA(LBi:UBi,LBj:UBj)
        FORCES(ng)%sustr(LBi:UBi,LBj:UBj)=sustr(LBi:UBi,LBj:UBj)
        FORCES(ng)%svstr(LBi:UBi,LBj:UBj)=svstr(LBi:UBi,LBj:UBj)
#endif
#ifdef HCM_EMINP_FORCE
#  ifndef HCM_AI_FWF
        do i=ILB,IUB
          do j=JLB,JUB
            cffR=cffW1N*FORCES(ng)%dwdtM1(i,j)                          &
     &          +cffW2N*FORCES(ng)%dwdtM2(i,j)                          &
     &          +cffW3N*FORCES(ng)%dwdtM3(i,j)                          &
     &          +cffW4N*FORCES(ng)%dwdtM4(i,j)                          &
     &          +cffW5N*FORCES(ng)%dwdtM5(i,j)
          fwfA(i,j)=hcm_alpha_fwf(ng)*cffR
          fwfC(i,j)=FORCES(ng)%rainC(i,j)
          fwf(i,j)=fwfC(i,j)+fwfA(i,j)
          enddo
        enddo
#  endif
        FORCES(ng)%rainA(LBi:UBi,LBj:UBj)=fwfA(LBi:UBi,LBj:UBj)
#    ifdef HCM_BULK_FLUX
        FORCES(ng)%PWF(LBi:UBi,LBj:UBj)=fwf(LBi:UBi,LBj:UBj)*rhow
#    endif
#endif
#ifdef TIW_COUPLING
#  ifndef HCM_AI_TIW
        do i=ILB+1,IUB
          do j=JLB,JUB
            cffM=cffTIW01N*FORCES(ng)%tiwU01(i-1,j)                     &
     &          +cffTIW02N*FORCES(ng)%tiwU02(i-1,j)                     &
     &          +cffTIW03N*FORCES(ng)%tiwU03(i-1,j)                     &
     &          +cffTIW04N*FORCES(ng)%tiwU04(i-1,j)                     &
     &          +cffTIW05N*FORCES(ng)%tiwU05(i-1,j)                     &
     &          +cffTIW06N*FORCES(ng)%tiwU06(i-1,j)                     &
     &          +cffTIW07N*FORCES(ng)%tiwU07(i-1,j)                     &
     &          +cffTIW08N*FORCES(ng)%tiwU08(i-1,j)                     &
     &          +cffTIW09N*FORCES(ng)%tiwU09(i-1,j)                     &
     &          +cffTIW10N*FORCES(ng)%tiwU10(i-1,j)
            cffR=cffTIW01N*FORCES(ng)%tiwU01(i,j)                       &
     &          +cffTIW02N*FORCES(ng)%tiwU02(i,j)                       &
     &          +cffTIW03N*FORCES(ng)%tiwU03(i,j)                       &
     &          +cffTIW04N*FORCES(ng)%tiwU04(i,j)                       &
     &          +cffTIW05N*FORCES(ng)%tiwU05(i,j)                       &
     &          +cffTIW06N*FORCES(ng)%tiwU06(i,j)                       &
     &          +cffTIW07N*FORCES(ng)%tiwU07(i,j)                       &
     &          +cffTIW08N*FORCES(ng)%tiwU08(i,j)                       &
     &          +cffTIW09N*FORCES(ng)%tiwU09(i,j)                       &
     &          +cffTIW10N*FORCES(ng)%tiwU10(i,j)
          sustrTIW(i,j)=0.5_r8*hcm_alpha_tiw(ng)*(cffM+cffR)
          enddo
        enddo
        do i=ILB,IUB
          do j=JLB+1,JUB
            cffM=cffTIW01N*FORCES(ng)%tiwV01(i,j-1)                     &
     &          +cffTIW02N*FORCES(ng)%tiwV02(i,j-1)                     &
     &          +cffTIW03N*FORCES(ng)%tiwV03(i,j-1)                     &
     &          +cffTIW04N*FORCES(ng)%tiwV04(i,j-1)                     &
     &          +cffTIW05N*FORCES(ng)%tiwV05(i,j-1)                     &
     &          +cffTIW06N*FORCES(ng)%tiwV06(i,j-1)                     &
     &          +cffTIW07N*FORCES(ng)%tiwV07(i,j-1)                     &
     &          +cffTIW08N*FORCES(ng)%tiwV08(i,j-1)                     &
     &          +cffTIW09N*FORCES(ng)%tiwV09(i,j-1)                     &
     &          +cffTIW10N*FORCES(ng)%tiwV10(i,j-1)
            cffR=cffTIW01N*FORCES(ng)%tiwV01(i,j)                       &
     &          +cffTIW02N*FORCES(ng)%tiwV02(i,j)                       &
     &          +cffTIW03N*FORCES(ng)%tiwV03(i,j)                       &
     &          +cffTIW04N*FORCES(ng)%tiwV04(i,j)                       &
     &          +cffTIW05N*FORCES(ng)%tiwV05(i,j)                       &
     &          +cffTIW06N*FORCES(ng)%tiwV06(i,j)                       &
     &          +cffTIW07N*FORCES(ng)%tiwV07(i,j)                       &
     &          +cffTIW08N*FORCES(ng)%tiwV08(i,j)                       &
     &          +cffTIW09N*FORCES(ng)%tiwV09(i,j)                       &
     &          +cffTIW10N*FORCES(ng)%tiwV10(i,j)
          svstrTIW(i,j)=0.5_r8*hcm_alpha_tiw(ng)*(cffM+cffR)
          enddo
        enddo
#  endif
        FORCES(ng)%sustrTIW(LBi:UBi,LBj:UBj)=sustrTIW(LBi:UBi,LBj:UBj)
        FORCES(ng)%svstrTIW(LBi:UBi,LBj:UBj)=svstrTIW(LBi:UBi,LBj:UBj)
#endif

! END MyRank==MyMaster
      endif
!-----------------------------------------------------------------------



!=======================================================================
      if (MyRank/=MyMaster) then
        LBi=BOUNDS(ng) % LBi(MyRank)
        UBi=BOUNDS(ng) % UBi(MyRank)
        LBj=BOUNDS(ng) % LBj(MyRank)
        UBj=BOUNDS(ng) % UBj(MyRank)
#ifdef HCM_AI_COUPLING
        dim1=UBi-LBi+1
        dim2=UBj-LBj+1
#endif
#ifdef HCM_WIND_STRESS
#  ifndef HCM_AI_WIND
        cffU1N=0.0_r8
        cffU2N=0.0_r8
        cffU3N=0.0_r8
        cffU4N=0.0_r8
        cffU5N=0.0_r8
        cffV1N=0.0_r8
        cffV2N=0.0_r8
        cffV3N=0.0_r8
        cffV4N=0.0_r8
        cffV5N=0.0_r8
#  endif
#endif
#ifdef HCM_EMINP_FORCE
#  ifndef HCM_AI_FWF
        cffW1N=0.0_r8
        cffW2N=0.0_r8
        cffW3N=0.0_r8
        cffW4N=0.0_r8
        cffW5N=0.0_r8
#  endif
#endif
#ifdef TIW_COUPLING
#  ifndef HCM_AI_TIW
        cffTIW01N=0.0_r8
        cffTIW02N=0.0_r8
        cffTIW03N=0.0_r8
        cffTIW04N=0.0_r8
        cffTIW05N=0.0_r8
        cffTIW06N=0.0_r8
        cffTIW07N=0.0_r8
        cffTIW08N=0.0_r8
        cffTIW09N=0.0_r8
        cffTIW10N=0.0_r8
#  endif
#endif

!-----------------------------------------------------------------------
        call  mpi_barrier(MPI_COMM_WORLD, ierr)
!-----------------------------------------------------------------------

#ifdef HCM_WIND_STRESS
#  ifdef HCM_AI_WIND
        len_buffer=dim1*dim2
        allocate(recv_buffer(len_buffer))
        recv_buffer(len_buffer)=0.0_r8
        do num=1,dim2
          call mpi_irecv(recv_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,MyMaster,tagU+num,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
        enddo
        sustr(LBi:UBi,LBj:UBj)=reshape(recv_buffer,(/dim1,dim2/))
        deallocate(recv_buffer)

        len_buffer=dim1*dim2
        allocate(recv_buffer(len_buffer))
        recv_buffer(len_buffer)=0.0_r8
        do num=1,dim2
          call mpi_irecv(recv_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,MyMaster,tagV+num,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
        enddo
        svstr(LBi:UBi,LBj:UBj)=reshape(recv_buffer,(/dim1,dim2/))
        deallocate(recv_buffer)

        len_buffer=dim1*dim2
        allocate(recv_buffer(len_buffer))
        recv_buffer(len_buffer)=0.0_r8
        do num=1,dim2
          call mpi_irecv(recv_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,MyMaster,tagUa+num,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
        enddo
        sustrA(LBi:UBi,LBj:UBj)=reshape(recv_buffer,(/dim1,dim2/))
        deallocate(recv_buffer)

        len_buffer=dim1*dim2
        allocate(recv_buffer(len_buffer))
        recv_buffer(len_buffer)=0.0_r8
        do num=1,dim2
          call mpi_irecv(recv_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,MyMaster,tagVa+num,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
        enddo
        svstrA(LBi:UBi,LBj:UBj)=reshape(recv_buffer,(/dim1,dim2/))
        deallocate(recv_buffer)
#  else
        len_buffer=5
        allocate(recv_buffer(len_buffer))
        recv_buffer(len_buffer)=0.0
        call mpi_irecv(recv_buffer,len_buffer,MPI_REAL8,0,tagUwN,MPI_COMM_WORLD,request,ierr)
        call mpi_wait(request,rstatus,ierr)
        cffU1N=recv_buffer(1)
        cffU2N=recv_buffer(2)
        cffU3N=recv_buffer(3)
        cffU4N=recv_buffer(4)
        cffU5N=recv_buffer(5)
        deallocate(recv_buffer)

        len_buffer=5
        allocate(recv_buffer(len_buffer))
        recv_buffer(len_buffer)=0.0
        call mpi_irecv(recv_buffer,len_buffer,MPI_REAL8,0,tagVwN,MPI_COMM_WORLD,request,ierr)
        call mpi_wait(request,rstatus,ierr)
        cffV1N=recv_buffer(1)
        cffV2N=recv_buffer(2)
        cffV3N=recv_buffer(3)
        cffV4N=recv_buffer(4)
        cffV5N=recv_buffer(5)
        deallocate(recv_buffer)
#  endif
#endif
#ifdef HCM_EMINP_FORCE
#  ifdef HCM_AI_FWF
        len_buffer=dim1*dim2
        allocate(recv_buffer(len_buffer))
        recv_buffer(len_buffer)=0.0_r8
        do num=1,dim2
          call mpi_irecv(recv_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,MyMaster,tagW+num,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
        enddo
        fwf(LBi:UBi,LBj:UBj)=reshape(recv_buffer,(/dim1,dim2/))
        deallocate(recv_buffer)

        len_buffer=dim1*dim2
        allocate(recv_buffer(len_buffer))
        recv_buffer(len_buffer)=0.0_r8
        do num=1,dim2
          call mpi_irecv(recv_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,MyMaster,tagWa+num,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
        enddo
        fwfA(LBi:UBi,LBj:UBj)=reshape(recv_buffer,(/dim1,dim2/))
        deallocate(recv_buffer)
#  else
        len_buffer=5
        allocate(recv_buffer(len_buffer))
        recv_buffer(len_buffer)=0.0
        call mpi_irecv(recv_buffer,len_buffer,MPI_REAL8,0,tagWwN,MPI_COMM_WORLD,request,ierr)
        call mpi_wait(request,rstatus,ierr)
        cffW1N=recv_buffer(1)
        cffW2N=recv_buffer(2)
        cffW3N=recv_buffer(3)
        cffW4N=recv_buffer(4)
        cffW5N=recv_buffer(5)
        deallocate(recv_buffer)
#  endif
#endif
#ifdef TIW_COUPLING
#  ifdef HCM_AI_TIW
        len_buffer=dim1*dim2
        allocate(recv_buffer(len_buffer))
        recv_buffer(len_buffer)=0.0_r8
        do num=1,dim2
          call mpi_irecv(recv_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,MyMaster,tagTIWu+num,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
        enddo
        sustrTIW(LBi:UBi,LBj:UBj)=reshape(recv_buffer,(/dim1,dim2/))
        deallocate(recv_buffer)

        len_buffer=dim1*dim2
        allocate(recv_buffer(len_buffer))
        recv_buffer(len_buffer)=0.0_r8
        do num=1,dim2
          call mpi_irecv(recv_buffer((num-1)*dim1+1:num*dim1),dim1,MPI_REAL8,MyMaster,tagTIWv+num,MPI_COMM_WORLD,request,ierr)
          call mpi_wait(request,rstatus,ierr)
        enddo
        svstrTIW(LBi:UBi,LBj:UBj)=reshape(recv_buffer,(/dim1,dim2/))
        deallocate(recv_buffer)
#  else
        len_buffer=10
        allocate(recv_buffer(len_buffer))
        recv_buffer(len_buffer)=0.0
        call mpi_irecv(recv_buffer,len_buffer,MPI_REAL8,0,tagTIWwN,MPI_COMM_WORLD,request,ierr)
        call mpi_wait(request,rstatus,ierr)
        cffTIW01N=recv_buffer(1)
        cffTIW02N=recv_buffer(2)
        cffTIW03N=recv_buffer(3)
        cffTIW04N=recv_buffer(4)
        cffTIW05N=recv_buffer(5)
        cffTIW06N=recv_buffer(6)
        cffTIW07N=recv_buffer(7)
        cffTIW08N=recv_buffer(8)
        cffTIW09N=recv_buffer(9)
        cffTIW10N=recv_buffer(10)
        deallocate(recv_buffer)
#  endif
#endif
!-----------------------------------------------------------------------
#ifdef HCM_WIND_STRESS
#  ifndef HCM_AI_WIND
        do i=ILB+1,IUB
          do j=JLB,JUB
            cffM=cffU1N*FORCES(ng)%dudtM1(i-1,j)                        &
     &          +cffU2N*FORCES(ng)%dudtM2(i-1,j)                        &
     &          +cffU3N*FORCES(ng)%dudtM3(i-1,j)                        &
     &          +cffU4N*FORCES(ng)%dudtM4(i-1,j)                        &
     &          +cffU5N*FORCES(ng)%dudtM5(i-1,j)
            cffR=cffU1N*FORCES(ng)%dudtM1(i,j)                          &
     &          +cffU2N*FORCES(ng)%dudtM2(i,j)                          &
     &          +cffU3N*FORCES(ng)%dudtM3(i,j)                          &
     &          +cffU4N*FORCES(ng)%dudtM4(i,j)                          &
     &          +cffU5N*FORCES(ng)%dudtM5(i,j)
          sustrA(i,j)=0.5_r8*hcm_alpha_tau(ng)*(cffM+cffR)
          sustrC(i,j)=FORCES(ng)%sustrC(i,j)
          sustr(i,j)=sustrC(i,j)+sustrA(i,j)
          sustr(i,j)=sustr(i,j)/rho0
          enddo
        enddo
        do i=ILB,IUB
          do j=JLB+1,JUB
            cffM=cffV1N*FORCES(ng)%dvdtM1(i,j-1)                        &
     &          +cffV2N*FORCES(ng)%dvdtM2(i,j-1)                        &
     &          +cffV3N*FORCES(ng)%dvdtM3(i,j-1)                        &
     &          +cffV4N*FORCES(ng)%dvdtM4(i,j-1)                        &
     &          +cffV5N*FORCES(ng)%dvdtM5(i,j-1)
            cffR=cffV1N*FORCES(ng)%dvdtM1(i,j)                          &
     &          +cffV2N*FORCES(ng)%dvdtM2(i,j)                          &
     &          +cffV3N*FORCES(ng)%dvdtM3(i,j)                          &
     &          +cffV4N*FORCES(ng)%dvdtM4(i,j)                          &
     &          +cffV5N*FORCES(ng)%dvdtM5(i,j)
          svstrA(i,j)=0.5_r8*hcm_alpha_tau(ng)*(cffM+cffR)
          svstrC(i,j)=FORCES(ng)%svstrC(i,j)
          svstr(i,j)=svstrC(i,j)+svstrA(i,j)
          svstr(i,j)=svstr(i,j)/rho0
          enddo
        enddo
#  endif
        FORCES(ng)%sustrA(LBi:UBi,LBj:UBj)=sustrA(LBi:UBi,LBj:UBj)
        FORCES(ng)%svstrA(LBi:UBi,LBj:UBj)=svstrA(LBi:UBi,LBj:UBj)
        FORCES(ng)%sustr(LBi:UBi,LBj:UBj)=sustr(LBi:UBi,LBj:UBj)
        FORCES(ng)%svstr(LBi:UBi,LBj:UBj)=svstr(LBi:UBi,LBj:UBj)
#endif
#ifdef HCM_EMINP_FORCE
#  ifndef HCM_AI_FWF
        do i=ILB,IUB
          do j=JLB,JUB
            cffR=cffW1N*FORCES(ng)%dwdtM1(i,j)                          &
     &          +cffW2N*FORCES(ng)%dwdtM2(i,j)                          &
     &          +cffW3N*FORCES(ng)%dwdtM3(i,j)                          &
     &          +cffW4N*FORCES(ng)%dwdtM4(i,j)                          &
     &          +cffW5N*FORCES(ng)%dwdtM5(i,j)
          fwfA(i,j)=hcm_alpha_fwf(ng)*cffR
          fwfC(i,j)=FORCES(ng)%rainC(i,j)
          fwf(i,j)=fwfC(i,j)+fwfA(i,j)
          enddo
        enddo
#  endif
        FORCES(ng)%rainA(LBi:UBi,LBj:UBj)=fwfA(LBi:UBi,LBj:UBj)
#    ifdef HCM_BULK_FLUX
        FORCES(ng)%PWF(LBi:UBi,LBj:UBj)=fwf(LBi:UBi,LBj:UBj)*rhow
#    endif
#endif
#ifdef TIW_COUPLING
#  ifndef HCM_AI_TIW
        do i=ILB+1,IUB
          do j=JLB,JUB
            cffM=cffTIW01N*FORCES(ng)%tiwU01(i-1,j)                     &
     &          +cffTIW02N*FORCES(ng)%tiwU02(i-1,j)                     &
     &          +cffTIW03N*FORCES(ng)%tiwU03(i-1,j)                     &
     &          +cffTIW04N*FORCES(ng)%tiwU04(i-1,j)                     &
     &          +cffTIW05N*FORCES(ng)%tiwU05(i-1,j)                     &
     &          +cffTIW06N*FORCES(ng)%tiwU06(i-1,j)                     &
     &          +cffTIW07N*FORCES(ng)%tiwU07(i-1,j)                     &
     &          +cffTIW08N*FORCES(ng)%tiwU08(i-1,j)                     &
     &          +cffTIW09N*FORCES(ng)%tiwU09(i-1,j)                     &
     &          +cffTIW10N*FORCES(ng)%tiwU10(i-1,j)
            cffR=cffTIW01N*FORCES(ng)%tiwU01(i,j)                       &
     &          +cffTIW02N*FORCES(ng)%tiwU02(i,j)                       &
     &          +cffTIW03N*FORCES(ng)%tiwU03(i,j)                       &
     &          +cffTIW04N*FORCES(ng)%tiwU04(i,j)                       &
     &          +cffTIW05N*FORCES(ng)%tiwU05(i,j)                       &
     &          +cffTIW06N*FORCES(ng)%tiwU06(i,j)                       &
     &          +cffTIW07N*FORCES(ng)%tiwU07(i,j)                       &
     &          +cffTIW08N*FORCES(ng)%tiwU08(i,j)                       &
     &          +cffTIW09N*FORCES(ng)%tiwU09(i,j)                       &
     &          +cffTIW10N*FORCES(ng)%tiwU10(i,j)
          sustrTIW(i,j)=0.5_r8*hcm_alpha_tiw(ng)*(cffM+cffR)
          enddo
        enddo
        do i=ILB,IUB
          do j=JLB+1,JUB
            cffM=cffTIW01N*FORCES(ng)%tiwV01(i,j-1)                     &
     &          +cffTIW02N*FORCES(ng)%tiwV02(i,j-1)                     &
     &          +cffTIW03N*FORCES(ng)%tiwV03(i,j-1)                     &
     &          +cffTIW04N*FORCES(ng)%tiwV04(i,j-1)                     &
     &          +cffTIW05N*FORCES(ng)%tiwV05(i,j-1)                     &
     &          +cffTIW06N*FORCES(ng)%tiwV06(i,j-1)                     &
     &          +cffTIW07N*FORCES(ng)%tiwV07(i,j-1)                     &
     &          +cffTIW08N*FORCES(ng)%tiwV08(i,j-1)                     &
     &          +cffTIW09N*FORCES(ng)%tiwV09(i,j-1)                     &
     &          +cffTIW10N*FORCES(ng)%tiwV10(i,j-1)
            cffR=cffTIW01N*FORCES(ng)%tiwV01(i,j)                       &
     &          +cffTIW02N*FORCES(ng)%tiwV02(i,j)                       &
     &          +cffTIW03N*FORCES(ng)%tiwV03(i,j)                       &
     &          +cffTIW04N*FORCES(ng)%tiwV04(i,j)                       &
     &          +cffTIW05N*FORCES(ng)%tiwV05(i,j)                       &
     &          +cffTIW06N*FORCES(ng)%tiwV06(i,j)                       &
     &          +cffTIW07N*FORCES(ng)%tiwV07(i,j)                       &
     &          +cffTIW08N*FORCES(ng)%tiwV08(i,j)                       &
     &          +cffTIW09N*FORCES(ng)%tiwV09(i,j)                       &
     &          +cffTIW10N*FORCES(ng)%tiwV10(i,j)
          svstrTIW(i,j)=0.5_r8*hcm_alpha_tiw(ng)*(cffM+cffR)
          enddo
        enddo
#  endif
        FORCES(ng)%sustrTIW(LBi:UBi,LBj:UBj)=sustrTIW(LBi:UBi,LBj:UBj)
        FORCES(ng)%svstrTIW(LBi:UBi,LBj:UBj)=svstrTIW(LBi:UBi,LBj:UBj)
#endif




      endif
!-----------------------------------------------------------------------
!


      END SUBROUTINE hcm_forcing
#    endif
#endif

      END MODULE hcm_forc_mod
