#
# (C) Copyright 2000
# Wolfgang Denk, DENX Software Engineering, wd@denx.de.
#
# See file CREDITS for list of people who contributed to this
# project.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston,
# MA 02111-1307 USA
#

PLATFORM_RELFLAGS += -fPIC -meabi
PLATFORM_CPPFLAGS += -DCONFIG_4xx -ffixed-r2 -msoft-float

cfg=$(shell grep configs $(OBJTREE)/include/config.h | sed 's/.*<\(configs.*\)>/\1/')
is440:=$(shell grep CONFIG_440 $(TOPDIR)/include/$(cfg))

ifneq (,$(findstring CONFIG_440,$(is440)))
PLATFORM_CPPFLAGS += -Wa,-m440 -mcpu=440
else
PLATFORM_CPPFLAGS += -Wa,-m405 -mcpu=405
endif

# Enable gc-sections to enable generation of smaller images.
# Please note that the linker scripts may need some tweaking with this
# change as well.
PLATFORM_LDFLAGS += --gc-sections --print-gc-sections
PLATFORM_RELFLAGS += -ffunction-sections -fdata-sections

# Use default linker script.  Board port can override in board/*/config.mk
LDSCRIPT := $(SRCTREE)/arch/powerpc/cpu/ppc4xx/u-boot.lds
