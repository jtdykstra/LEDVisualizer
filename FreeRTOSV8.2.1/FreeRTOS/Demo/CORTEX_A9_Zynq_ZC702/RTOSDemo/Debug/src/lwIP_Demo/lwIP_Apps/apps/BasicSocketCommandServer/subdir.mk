################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/lwIP_Demo/lwIP_Apps/apps/BasicSocketCommandServer/BasicSocketCommandServer.c 

OBJS += \
./src/lwIP_Demo/lwIP_Apps/apps/BasicSocketCommandServer/BasicSocketCommandServer.o 

C_DEPS += \
./src/lwIP_Demo/lwIP_Apps/apps/BasicSocketCommandServer/BasicSocketCommandServer.d 


# Each subdirectory must supply rules for building sources it contributes
src/lwIP_Demo/lwIP_Apps/apps/BasicSocketCommandServer/%.o: ../src/lwIP_Demo/lwIP_Apps/apps/BasicSocketCommandServer/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/lwIP_Demo/lwIP_port/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/lwIP_Demo/lwIP_port/netif" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Source/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Source/portable/GCC/ARM_CA9" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/include/ipv4" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/Full_Demo" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS-Plus/Source/FreeRTOS-Plus-CLI" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src" -c -fmessage-length=0 -Wextra -ffunction-sections -fdata-sections -I/home/pukken/Documents/Backups/FinalProject_preip2/project_1/project_1.sdk/RTOSDemo_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


