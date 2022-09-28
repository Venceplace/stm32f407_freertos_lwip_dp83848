# gdb
ifdef GCC_PATH
GDB = $(GCC_PATH)/$(PREFIX)gdb
else
GDB = $(PREFIX)gdb
endif

OOCD = openocd
OOCD_INTERFACE = interface/stlink.cfg
#OOCD_INTERFACE = interface/cmsis-dap.cfg
OOCD_TARGET = target/stm32f4x.cfg
OOCDFLAGS = -f $(OOCD_INTERFACE) -f $(OOCD_TARGET)

flash: $(BUILD_DIR)/$(TARGET).hex
	@printf " flash $<\n"
	@$(OOCD) $(OOCDFLAGS) \
		-c "transport select hla_swd" \
		-c init \
		-c "reset halt" \
		-c "flash write_image erase $(CURDIR)/$(BUILD_DIR)/$(TARGET).hex" \
		-c reset \
		-c shutdown

reboot:
	@printf " reboot \n"
	@$(OOCD) $(OOCDFLAGS) -c init -c reset -c shutdown

debug: $(BUILD_DIR)/$(TARGET).elf
	@printf " GDB DEBUG $<\n"
	@$(GDB) -iex 'target extended | $(OOCD) $(OOCDFLAGS) -c "gdb_port pipe"' \
                -iex 'monitor reset halt' -ex 'load' -ex 'break main' -ex 'c' $(BUILD_DIR)/$(TARGET).elf
erase:
	@printf "erase \n"
	@$(OOCD) $(OOCDFLAGS) \
		-c "transport select hla_swd" \
		-c "init"\
		-c "reset halt" \
		-c "stm32f2x mass_earse" \
