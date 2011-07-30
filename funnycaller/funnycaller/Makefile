include theos/makefiles/common.mk

BUNDLE_NAME = funnycaller
funnycaller_FILES = funnycaller.mm
funnycaller_INSTALL_PATH = /Library/PreferenceBundles
funnycaller_FRAMEWORKS = UIKit
funnycaller_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/funnycaller.plist$(ECHO_END)
