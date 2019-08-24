SYSROOT = $(THEOS)/sdks/iPhoneOS11.2.sdk
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Blanka
Blanka_FILES = BLKRootListController.m BLKAboutListController.m
Blanka_INSTALL_PATH = /Library/PreferenceBundles
Blanka_FRAMEWORKS = UIKit
Blanka_PRIVATE_FRAMEWORKS = Preferences
Blanka_EXTRA_FRAMEWORKS += CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Blanka.plist$(ECHO_END)
