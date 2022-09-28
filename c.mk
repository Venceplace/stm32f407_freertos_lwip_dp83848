USER_C_SOURCES =\
user/retarget_stdio.c \

C_INCLUDES +=\
-Iuser\

OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(USER_C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(USER_C_SOURCES)))

