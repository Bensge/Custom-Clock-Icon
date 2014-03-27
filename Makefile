ARCHS= armv7 armv7s arm64

include theos/makefiles/common.mk

TARGET=7.0:clang

TWEAK_NAME = CustomClockIcon
CustomClockIcon_FILES = Tweak.xm
CustomClockIcon_FRAMEWORKS = CoreFoundation Foundation UIKit QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
