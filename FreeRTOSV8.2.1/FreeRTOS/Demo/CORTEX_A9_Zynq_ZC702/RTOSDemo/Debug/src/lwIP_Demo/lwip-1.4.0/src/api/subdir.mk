################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/api/api_lib.c \
/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/api/api_msg.c \
/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/api/err.c \
/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/api/netbuf.c \
/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/api/netdb.c \
/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/api/netifapi.c \
/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/api/sockets.c \
/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/api/tcpip.c 

OBJS += \
./src/lwIP_Demo/lwip-1.4.0/src/api/api_lib.o \
./src/lwIP_Demo/lwip-1.4.0/src/api/api_msg.o \
./src/lwIP_Demo/lwip-1.4.0/src/api/err.o \
./src/lwIP_Demo/lwip-1.4.0/src/api/netbuf.o \
./src/lwIP_Demo/lwip-1.4.0/src/api/netdb.o \
./src/lwIP_Demo/lwip-1.4.0/src/api/netifapi.o \
./src/lwIP_Demo/lwip-1.4.0/src/api/sockets.o \
./src/lwIP_Demo/lwip-1.4.0/src/api/tcpip.o 

C_DEPS += \
./src/lwIP_Demo/lwip-1.4.0/src/api/api_lib.d \
./src/lwIP_Demo/lwip-1.4.0/src/api/api_msg.d \
./src/lwIP_Demo/lwip-1.4.0/src/api/err.d \
./src/lwIP_Demo/lwip-1.4.0/src/api/netbuf.d \
./src/lwIP_Demo/lwip-1.4.0/src/api/netdb.d \
./src/lwIP_Demo/lwip-1.4.0/src/api/netifapi.d \
./src/lwIP_Demo/lwip-1.4.0/src/api/sockets.d \
./src/lwIP_Demo/lwip-1.4.0/src/api/tcpip.d 


# Each subdirectory must supply rules for building sources it contributes
src/lwIP_Demo/lwip-1.4.0/src/api/api_lib.o: /home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/api/api_lib.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/lwIP_Demo/lwIP_port/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/lwIP_Demo/lwIP_port/netif" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Source/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Source/portable/GCC/ARM_CA9" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/include/ipv4" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/Full_Demo" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS-Plus/Source/FreeRTOS-Plus-CLI" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src" -c -fmessage-length=0 -Wextra -ffunction-sections -fdata-sections -I/home/pukken/Documents/Backups/FinalProject_preip2/project_1/project_1.sdk/RTOSDemo_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/lwIP_Demo/lwip-1.4.0/src/api/api_msg.o: /home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/api/api_msg.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/lwIP_Demo/lwIP_port/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/lwIP_Demo/lwIP_port/netif" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Source/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Source/portable/GCC/ARM_CA9" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/include/ipv4" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/Full_Demo" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS-Plus/Source/FreeRTOS-Plus-CLI" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src" -c -fmessage-length=0 -Wextra -ffunction-sections -fdata-sections -I/home/pukken/Documents/Backups/FinalProject_preip2/project_1/project_1.sdk/RTOSDemo_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/lwIP_Demo/lwip-1.4.0/src/api/err.o: /home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/api/err.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/lwIP_Demo/lwIP_port/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/lwIP_Demo/lwIP_port/netif" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Source/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Source/portable/GCC/ARM_CA9" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/include/ipv4" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/Full_Demo" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS-Plus/Source/FreeRTOS-Plus-CLI" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src" -c -fmessage-length=0 -Wextra -ffunction-sections -fdata-sections -I/home/pukken/Documents/Backups/FinalProject_preip2/project_1/project_1.sdk/RTOSDemo_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/lwIP_Demo/lwip-1.4.0/src/api/netbuf.o: /home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/api/netbuf.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/lwIP_Demo/lwIP_port/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/lwIP_Demo/lwIP_port/netif" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Source/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Source/portable/GCC/ARM_CA9" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/include/ipv4" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/Full_Demo" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS-Plus/Source/FreeRTOS-Plus-CLI" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src" -c -fmessage-length=0 -Wextra -ffunction-sections -fdata-sections -I/home/pukken/Documents/Backups/FinalProject_preip2/project_1/project_1.sdk/RTOSDemo_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/lwIP_Demo/lwip-1.4.0/src/api/netdb.o: /home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/api/netdb.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/lwIP_Demo/lwIP_port/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/lwIP_Demo/lwIP_port/netif" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Source/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Source/portable/GCC/ARM_CA9" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/include/ipv4" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/Full_Demo" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS-Plus/Source/FreeRTOS-Plus-CLI" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src" -c -fmessage-length=0 -Wextra -ffunction-sections -fdata-sections -I/home/pukken/Documents/Backups/FinalProject_preip2/project_1/project_1.sdk/RTOSDemo_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/lwIP_Demo/lwip-1.4.0/src/api/netifapi.o: /home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/api/netifapi.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/lwIP_Demo/lwIP_port/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/lwIP_Demo/lwIP_port/netif" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Source/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Source/portable/GCC/ARM_CA9" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/include/ipv4" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/Full_Demo" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS-Plus/Source/FreeRTOS-Plus-CLI" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src" -c -fmessage-length=0 -Wextra -ffunction-sections -fdata-sections -I/home/pukken/Documents/Backups/FinalProject_preip2/project_1/project_1.sdk/RTOSDemo_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/lwIP_Demo/lwip-1.4.0/src/api/sockets.o: /home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/api/sockets.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/lwIP_Demo/lwIP_port/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/lwIP_Demo/lwIP_port/netif" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Source/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Source/portable/GCC/ARM_CA9" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/include/ipv4" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/Full_Demo" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS-Plus/Source/FreeRTOS-Plus-CLI" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src" -c -fmessage-length=0 -Wextra -ffunction-sections -fdata-sections -I/home/pukken/Documents/Backups/FinalProject_preip2/project_1/project_1.sdk/RTOSDemo_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/lwIP_Demo/lwip-1.4.0/src/api/tcpip.o: /home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/api/tcpip.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM gcc compiler'
	arm-xilinx-eabi-gcc -Wall -O0 -g3 -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/lwIP_Demo/lwIP_port/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/lwIP_Demo/lwIP_port/netif" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Source/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Source/portable/GCC/ARM_CA9" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/include/ipv4" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/ethernet/lwip-1.4.0/src/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src/Full_Demo" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS-Plus/Source/FreeRTOS-Plus-CLI" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/Common/include" -I"/home/pukken/Documents/Backups/FinalProject_preip2/FreeRTOSV8.2.1/FreeRTOS/Demo/CORTEX_A9_Zynq_ZC702/RTOSDemo/src" -c -fmessage-length=0 -Wextra -ffunction-sections -fdata-sections -I/home/pukken/Documents/Backups/FinalProject_preip2/project_1/project_1.sdk/RTOSDemo_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


