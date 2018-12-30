# Project vars
PROJECT_DIR := Projeto/
PROJECT_TITLE := DiagnosticoDeSaude


# Directories vars
BIN_DIR := $(PROJECT_DIR)/bin/
OBJ_DIR := $(PROJECT_DIR)/obj/

RELEASE_DIR := $(BIN_DIR)/Release/
DEBUG_DIR := $(BIN_DIR)/Debug/

RELEASES_DIR := $(PWD)/releases/

# NuGet vars
NUGET_PACKAGES_DIR := $(PWD)/packages/

# Tools vars
MDTOOL := mdtool

# Version vars
BIN_NAME := Projeto.exe
VERSION  := 1.0.0
CODENAME := baby


# Compress vars
TARGET_ZIP := $(PROJECT_TITLE)-$(VERSION).zip


# DotEnvironment vars
DOTENV := .env

BUILD_DIR := $(PWD)/build

.PHONY : build-release build-debug zip-release clean

restore-packages: DiagnosticoSaude.sln
	nuget restore .

define build
	$(MDTOOL) build -t:Build -c:${1}
endef

build-release: $(PROJECT_DIR) restore-packages
	$(call build,Release)

build-debug: $(PROJECT_DIR) restore-packages
	$(call build,Debug)

release: $(RELEASE-DIR)
	mono $(RELEASE_DIR)/$(BIN_NAME)

debug: $(DEBUG_DIR)
	mono $(DEBUG_DIR)/$(BIN_NAME)

zip-release: build-release
	mkdir -p $(BUILD_DIR); \
	mkdir -p $(RELEASES_DIR); \
	cp $(RELEASE_DIR)/*.* $(BUILD_DIR) ; \
	cd $(BUILD_DIR) ; \
	zip  $(TARGET_ZIP) *.* ;\
	mv $(TARGET_ZIP) $(RELEASES_DIR)

clean:
	rm -rf $(BUILD_DIR)
	$(MDTOOL) build -t:Clean