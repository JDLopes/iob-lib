ifneq ($(ASIC),1)
ifeq ($(filter iob_ram_tdp_be, $(HW_MODULES)),)

# Add to modules list
HW_MODULES+=iob_ram_tdp_be

# Submodules
include $(LIB_DIR)/hardware/ram/iob_ram_tdp/hardware.mk

# Sources
VSRC+=$(LIB_DIR)/hardware/ram/iob_ram_tdp_be/iob_ram_tdp_be.v

endif
endif
