TARGET := iphone:clang

TARGET_SDK_VERSION := 6.1
TARGET_IPHONEOS_DEPLOYMENT_VERSION := 6.1
ARCHS := armv7

include theos/makefiles/common.mk

TWEAK_NAME = QuickAct
QuickAct_FILES = Tweak.xm
QuickAct_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
