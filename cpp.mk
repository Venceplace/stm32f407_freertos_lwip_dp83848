# C++ sourcesModules_Init(MODULES_INIT_STATE);
CXX_SOURCES =\
user/tools/shell/apps/freertos_cmd.cpp\
user/tools/shell/apps/sys_cmd.cpp\
user/apps/version/version.cpp\
user/tools/common/crc16.cpp\
user/tools/common/local_tick.cpp\
user/tools/ros/ros_lib/duration.cpp\
user/tools/ros/ros_lib/time.cpp\
user/tools/ros/ros_ulog/ros_ulog.cpp\
user/apps/ros/ros_nodes.cpp\
user/apps/ros/ros_statistics.cpp\
user/apps/ros/ros_task.cpp\
user/apps/ros/app/ros_uptime_version.cpp\
user/apps/ros/app/ros_reset_controller_node.cpp\
user/apps/ros/app/ros_ulog_node.cpp\
user/tools/shell/apps/ros_cmd.cpp\
user/apps/ros/app/ros_rfid_node.cpp\
user/apps/rfid/rfid_rs485.cpp\
user/apps/motor/driver/canopen_sdo.cpp\
user/apps/motor/config/pv/config_local_od.cpp\
user/apps/motor/config/pv/config_remote_pdo.cpp\
user/apps/motor/config/pv/config_remote_mode.cpp\
user/apps/ros/app/ros_current_torque_node.cpp\
user/apps/ros/app/ros_motor_node.cpp\
user/apps/motor/app/motor_clear_warn.cpp\
user/apps/motor/canopen_app.cpp\
user/apps/motor/canopen_sdo_app.cpp\
user/apps/motor/app/motor_app.cpp\
user/apps/motor/app/move_app.cpp\
user/apps/ros/app/ros_thermo_node.cpp\
user/apps/motor/app/cmd_timeout_mechanism.cpp\
user/apps/ros/diag/ros_diag_init_node.cpp\
user/apps/ros/diag/ros_diag_motor_node.cpp\
user/apps/ros/diag/ros_diag_ros_node.cpp\
user/apps/ros/app/ros_buzzer_node.cpp\
user/apps/ros/app/ros_led_node.cpp\
user/apps/ros/app/ros_camera_power_node.cpp\
user/apps/ros/app/ros_move_trigger_node.cpp\
user/apps/ros/app/ros_canopen_sdo_node.cpp\
user/apps/wireless_charging/wireless_charging.cpp\
user/apps/ros/app/ros_wireless_charging_node.cpp\
user/apps/ros/app/ros_external_encoder_node.cpp\
user/apps/restore_nx_power/restore_nx_power.cpp\

# g++
ifdef GCC_PATH
CXX = $(GCC_PATH)/$(PREFIX)g++
else
CXX = $(PREFIX)g++
endif

# C++ defines
CXX_DEFS = $(C_DEFS)

# C++ includes
CXX_INCLUDES = $(C_INCLUDES) \

# compile g++ flags
CXXFLAGS = -lstdc++ $(MCU) $(CXX_DEFS) $(CXX_INCLUDES) $(OPT) -Wall -fno-rtti -fno-exceptions -fverbose-asm -fdata-sections -ffunction-sections -fpermissive -Wa,-ahlms=$(BUILD_DIR)/$(notdir $(<:.cpp=.lst))

ifeq ($(DEBUG), 1)
CXXFLAGS += -g -gdwarf-2
endif

CXXFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"

# list of c++ objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(CXX_SOURCES:.cpp=.o)))
vpath %.cpp $(sort $(dir $(CXX_SOURCES)))

$(BUILD_DIR)/%.o: %.cpp Makefile | $(BUILD_DIR)
	@echo "CXX    $(notdir $@)"
	@$(CXX) -c $(CXXFLAGS) $< -o $@
