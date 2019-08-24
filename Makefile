FINALPACKAGE = 1

ARCHS = arm64 arm64e

THEOS_DEVICE_IP = 192.168.1.16

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Blanka
Blanka_FILES = Tweak.xm 
Blanka_FRAMEWORKS = Foundation UIKit CoreGraphics
Blanka_LIBRARIES = MobileGestalt
Blanka_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += blanka
include $(THEOS_MAKE_PATH)/aggregate.mk
