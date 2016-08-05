#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
include Makefile

# Environment
SHELL=cmd.exe
# Adding MPLAB X bin directory to path
PATH:=C:/Program Files/Microchip/MPLABX/mplab_ide/mplab_ide/modules/../../bin/:$(PATH)
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/pic18_template.X.${IMAGE_TYPE}.cof
else
IMAGE_TYPE=production
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/pic18_template.X.${IMAGE_TYPE}.cof
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/configuration_bits.p1 ${OBJECTDIR}/interrupts.p1 ${OBJECTDIR}/main.p1 ${OBJECTDIR}/system.p1 ${OBJECTDIR}/user.p1

# Object Files
OBJECTFILES=${OBJECTDIR}/configuration_bits.p1 ${OBJECTDIR}/interrupts.p1 ${OBJECTDIR}/main.p1 ${OBJECTDIR}/system.p1 ${OBJECTDIR}/user.p1


CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

# Path to java used to run MPLAB X when this makefile was created
MP_JAVA_PATH="C:\Program Files\Java\jre6/bin/"
OS_CURRENT="$(shell uname -s)"
############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
MP_CC="C:\Program Files\HI-TECH Software\PICC-18\PRO\9.66\bin\picc18.exe"
# MP_BC is not defined
MP_AS="C:\Program Files\HI-TECH Software\PICC-18\PRO\9.66\bin\picc18.exe"
MP_LD="C:\Program Files\HI-TECH Software\PICC-18\PRO\9.66\bin\picc18.exe"
MP_AR="C:\Program Files\HI-TECH Software\PICC-18\PRO\9.66\bin\picc18.exe"
DEP_GEN=${MP_JAVA_PATH}java -jar "C:/Program Files/Microchip/MPLABX/mplab_ide/mplab_ide/modules/../../bin/extractobjectdependencies.jar" 
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps
MP_CC_DIR="C:\Program Files\HI-TECH Software\PICC-18\PRO\9.66\bin"
# MP_BC_DIR is not defined
MP_AS_DIR="C:\Program Files\HI-TECH Software\PICC-18\PRO\9.66\bin"
MP_LD_DIR="C:\Program Files\HI-TECH Software\PICC-18\PRO\9.66\bin"
MP_AR_DIR="C:\Program Files\HI-TECH Software\PICC-18\PRO\9.66\bin"
# MP_BC_DIR is not defined

.build-conf:  ${BUILD_SUBPROJECTS}
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/pic18_template.X.${IMAGE_TYPE}.cof

MP_PROCESSOR_OPTION=18F87K22
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/interrupts.p1: interrupts.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	${MP_CC} --pass1 interrupts.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 -D__DEBUG  --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	${MP_CC} --scandep --pass1 interrupts.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 -D__DEBUG  --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	@echo ${OBJECTDIR}/interrupts.p1: > ${OBJECTDIR}/interrupts.p1.d
	@cat ${OBJECTDIR}/interrupts.dep >> ${OBJECTDIR}/interrupts.p1.d
	@${FIXDEPS} "${OBJECTDIR}/interrupts.p1.d" $(SILENT) -ht
	
${OBJECTDIR}/main.p1: main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	${MP_CC} --pass1 main.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 -D__DEBUG  --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	${MP_CC} --scandep --pass1 main.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 -D__DEBUG  --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	@echo ${OBJECTDIR}/main.p1: > ${OBJECTDIR}/main.p1.d
	@cat ${OBJECTDIR}/main.dep >> ${OBJECTDIR}/main.p1.d
	@${FIXDEPS} "${OBJECTDIR}/main.p1.d" $(SILENT) -ht
	
${OBJECTDIR}/system.p1: system.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	${MP_CC} --pass1 system.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 -D__DEBUG  --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	${MP_CC} --scandep --pass1 system.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 -D__DEBUG  --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	@echo ${OBJECTDIR}/system.p1: > ${OBJECTDIR}/system.p1.d
	@cat ${OBJECTDIR}/system.dep >> ${OBJECTDIR}/system.p1.d
	@${FIXDEPS} "${OBJECTDIR}/system.p1.d" $(SILENT) -ht
	
${OBJECTDIR}/configuration_bits.p1: configuration_bits.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	${MP_CC} --pass1 configuration_bits.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 -D__DEBUG  --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	${MP_CC} --scandep --pass1 configuration_bits.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 -D__DEBUG  --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	@echo ${OBJECTDIR}/configuration_bits.p1: > ${OBJECTDIR}/configuration_bits.p1.d
	@cat ${OBJECTDIR}/configuration_bits.dep >> ${OBJECTDIR}/configuration_bits.p1.d
	@${FIXDEPS} "${OBJECTDIR}/configuration_bits.p1.d" $(SILENT) -ht
	
${OBJECTDIR}/user.p1: user.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	${MP_CC} --pass1 user.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 -D__DEBUG  --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	${MP_CC} --scandep --pass1 user.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 -D__DEBUG  --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	@echo ${OBJECTDIR}/user.p1: > ${OBJECTDIR}/user.p1.d
	@cat ${OBJECTDIR}/user.dep >> ${OBJECTDIR}/user.p1.d
	@${FIXDEPS} "${OBJECTDIR}/user.p1.d" $(SILENT) -ht
	
else
${OBJECTDIR}/interrupts.p1: interrupts.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	${MP_CC} --pass1 interrupts.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	${MP_CC} --scandep --pass1 interrupts.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	@echo ${OBJECTDIR}/interrupts.p1: > ${OBJECTDIR}/interrupts.p1.d
	@cat ${OBJECTDIR}/interrupts.dep >> ${OBJECTDIR}/interrupts.p1.d
	@${FIXDEPS} "${OBJECTDIR}/interrupts.p1.d" $(SILENT) -ht
	
${OBJECTDIR}/main.p1: main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	${MP_CC} --pass1 main.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	${MP_CC} --scandep --pass1 main.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	@echo ${OBJECTDIR}/main.p1: > ${OBJECTDIR}/main.p1.d
	@cat ${OBJECTDIR}/main.dep >> ${OBJECTDIR}/main.p1.d
	@${FIXDEPS} "${OBJECTDIR}/main.p1.d" $(SILENT) -ht
	
${OBJECTDIR}/system.p1: system.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	${MP_CC} --pass1 system.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	${MP_CC} --scandep --pass1 system.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	@echo ${OBJECTDIR}/system.p1: > ${OBJECTDIR}/system.p1.d
	@cat ${OBJECTDIR}/system.dep >> ${OBJECTDIR}/system.p1.d
	@${FIXDEPS} "${OBJECTDIR}/system.p1.d" $(SILENT) -ht
	
${OBJECTDIR}/configuration_bits.p1: configuration_bits.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	${MP_CC} --pass1 configuration_bits.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	${MP_CC} --scandep --pass1 configuration_bits.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	@echo ${OBJECTDIR}/configuration_bits.p1: > ${OBJECTDIR}/configuration_bits.p1.d
	@cat ${OBJECTDIR}/configuration_bits.dep >> ${OBJECTDIR}/configuration_bits.p1.d
	@${FIXDEPS} "${OBJECTDIR}/configuration_bits.p1.d" $(SILENT) -ht
	
${OBJECTDIR}/user.p1: user.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR} 
	${MP_CC} --pass1 user.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	${MP_CC} --scandep --pass1 user.c $(MP_EXTRA_CC_PRE) -q --chip=$(MP_PROCESSOR_OPTION) -P  --outdir=${OBJECTDIR} -N31 --warn=0 --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 --cp=16 -Blarge --double=24  --mode=lite -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s"  
	@echo ${OBJECTDIR}/user.p1: > ${OBJECTDIR}/user.p1.d
	@cat ${OBJECTDIR}/user.dep >> ${OBJECTDIR}/user.p1.d
	@${FIXDEPS} "${OBJECTDIR}/user.p1.d" $(SILENT) -ht
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/pic18_template.X.${IMAGE_TYPE}.cof: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE) -odist/${CND_CONF}/${IMAGE_TYPE}/pic18_template.X.${IMAGE_TYPE}.cof -mdist/${CND_CONF}/${IMAGE_TYPE}/pic18_template.X.${IMAGE_TYPE}.map --summary=default,-psect,-class,+mem,-hex --chip=$(MP_PROCESSOR_OPTION) -P --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 -D__DEBUG --debugger=pickit3 -N31 --warn=0 --cp=16 -Blarge --double=24  --mode=lite  --output=default,-inhx032 -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s" ${OBJECTFILES_QUOTED_IF_SPACED}    
	${RM} dist/${CND_CONF}/${IMAGE_TYPE}/pic18_template.X.${IMAGE_TYPE}.hex
else
dist/${CND_CONF}/${IMAGE_TYPE}/pic18_template.X.${IMAGE_TYPE}.cof: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE) -odist/${CND_CONF}/${IMAGE_TYPE}/pic18_template.X.${IMAGE_TYPE}.cof -mdist/${CND_CONF}/${IMAGE_TYPE}/pic18_template.X.${IMAGE_TYPE}.map --summary=default,-psect,-class,+mem,-hex --chip=$(MP_PROCESSOR_OPTION) -P --runtime=default,+clear,+init,-keep,-download,+stackwarn,-config,+clib,-plib --opt=default,+asm,-asmfile,+speed,-space,-9 -N31 --warn=0 --cp=16 -Blarge --double=24  --mode=lite  --output=default,-inhx032 -g --asmlist "--errformat=%%f:%%l: error: %%s" "--msgformat=%%f:%%l: advisory: %%s" "--warnformat=%%f:%%l warning: %%s" ${OBJECTFILES_QUOTED_IF_SPACED}    
endif


# Subprojects
.build-subprojects:

# Clean Targets
.clean-conf:
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(wildcard $(addsuffix .d, ${OBJECTFILES}))
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
