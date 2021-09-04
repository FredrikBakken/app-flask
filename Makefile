UK_ROOT ?= $(PWD)/../../unikraft
UK_LIBS ?= $(PWD)/../../libs
LIBS := $(UK_LIBS)/pthread-embedded:$(UK_LIBS)/lwip:$(UK_LIBS)/zlib:$(UK_LIBS)/libuuid:$(UK_LIBS)/newlib:$(UK_LIBS)/python3

all:
	@$(MAKE) -C $(UK_ROOT) A=$(PWD) L=$(LIBS)

$(MAKECMDGOALS):
	@$(MAKE) -C $(UK_ROOT) A=$(PWD) L=$(LIBS) $(MAKECMDGOALS)
