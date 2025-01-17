###############################################################################
###                           Protobuf                                    ###
###############################################################################
ifeq ($(UNAME_OS),Linux)
	PROTOC_ZIP ?= protoc-${PROTOC_VERSION}-linux-$(UNAME_ARCH).zip
endif
ifeq ($(UNAME_OS),Darwin)
	PROTOC_ZIP ?= protoc-${PROTOC_VERSION}-osx-universal_binary.zip
endif

$(AKASH_DEVCACHE):
	@echo "creating .cache dir structure..."
	mkdir -p $@
	mkdir -p $(AKASH_DEVCACHE_BIN)
	mkdir -p $(AKASH_DEVCACHE_BIN)/legacy
	mkdir -p $(AKASH_DEVCACHE_INCLUDE)
	mkdir -p $(AKASH_DEVCACHE_VERSIONS)
	mkdir -p $(AKASH_DEVCACHE_NODE_MODULES)
	mkdir -p $(AKASH_DEVCACHE)/run
cache: $(AKASH_DEVCACHE)

$(BUF_VERSION_FILE): $(AKASH_DEVCACHE)
	@echo "installing buf v$(BUF_VERSION) ..."
	rm -f $(BUF)
	GOBIN=$(AKASH_DEVCACHE_BIN) $(GO) install github.com/bufbuild/buf/cmd/buf@v$(BUF_VERSION)
	rm -rf "$(dir $@)"
	mkdir -p "$(dir $@)"
	touch $@
$(BUF): $(BUF_VERSION_FILE)

$(PROTOC_VERSION_FILE): $(AKASH_DEVCACHE)
	@echo "installing protoc compiler v$(PROTOC_VERSION) ..."
	rm -f $(PROTOC)
	(cd /tmp; \
	curl -sOL "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/${PROTOC_ZIP}"; \
	unzip -oq ${PROTOC_ZIP} -d $(AKASH_DEVCACHE) bin/protoc; \
	unzip -oq ${PROTOC_ZIP} -d $(AKASH_DEVCACHE) 'include/*'; \
	rm -f ${PROTOC_ZIP})
	rm -rf "$(dir $@)"
	mkdir -p "$(dir $@)"
	touch $@
	# TODO https://github.com/akash-network/support/issues/77
	cp -rf $(PROTOC) $(AKASH_DEVCACHE_BIN)/legacy/
$(PROTOC): $(PROTOC_VERSION_FILE)

# TODO https://github.com/akash-network/support/issues/77

$(PROTOC_GEN_GOCOSMOS_VERSION_FILE): $(AKASH_DEVCACHE) modvendor
	@echo "installing protoc-gen-gocosmos $(PROTOC_GEN_GOCOSMOS_VERSION) ..."
	rm -f $(PROTOC_GEN_GOCOSMOS)
	GOBIN=$(AKASH_DEVCACHE_BIN)/legacy $(GO) install $(ROOT_DIR)/vendor/github.com/regen-network/cosmos-proto/protoc-gen-gocosmos
	rm -rf "$(dir $@)"
	mkdir -p "$(dir $@)"
	touch $@
$(PROTOC_GEN_GOCOSMOS): $(PROTOC_GEN_GOCOSMOS_VERSION_FILE)

$(GOGOPROTO_VERSION_FILE): $(AKASH_DEVCACHE)
	@echo "installing gogoproto binaries $(GOGOPROTO_VERSION) ..."
	rm -f $(BUF)
	GOBIN=$(AKASH_DEVCACHE_BIN) make -C vendor/github.com/cosmos/gogoproto install
	rm -rf "$(dir $@)"
	mkdir -p "$(dir $@)"
	touch $@
gogoproto: $(GOGOPROTO_VERSION_FILE)

$(PROTOC_GEN_GO_PULSAR_VERSION_FILE): $(AKASH_DEVCACHE)
	@echo "installing protoc-gen-go-pulsar $(PROTOC_GEN_GO_PULSAR_VERSION) ..."
	rm -f $(PROTOC_GEN_GO_PULSAR)
	GOBIN=$(AKASH_DEVCACHE_BIN) $(GO) install github.com/cosmos/cosmos-proto/cmd/protoc-gen-go-pulsar@$(PROTOC_GEN_GO_PULSAR_VERSION)
	rm -rf "$(dir $@)"
	mkdir -p "$(dir $@)"
	touch $@
$(PROTOC_GEN_GO_PULSAR): $(PROTOC_GEN_GO_PULSAR_VERSION_FILE)

$(PROTOC_GEN_GO_VERSION_FILE): $(AKASH_DEVCACHE)
	@echo "installing protoc-gen-go $(PROTOC_GEN_GO_VERSION) ..."
	rm -f $(PROTOC_GEN_GO)
	GOBIN=$(AKASH_DEVCACHE_BIN) $(GO) install google.golang.org/protobuf/cmd/protoc-gen-go@$(PROTOC_GEN_GO_VERSION)
	rm -rf "$(dir $@)"
	mkdir -p "$(dir $@)"
	touch $@
$(PROTOC_GEN_GO): $(PROTOC_GEN_GO_VERSION_FILE)

$(PROTOC_GEN_GRPC_GATEWAY_VERSION_FILE): $(AKASH_DEVCACHE)
	@echo "Installing protoc-gen-grpc-gateway $(PROTOC_GEN_GRPC_GATEWAY_VERSION) ..."
	rm -f $(PROTOC_GEN_GRPC_GATEWAY)
	GOBIN=$(AKASH_DEVCACHE_BIN) $(GO) install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway@$(PROTOC_GEN_GRPC_GATEWAY_VERSION)
	rm -rf "$(dir $@)"
	mkdir -p "$(dir $@)"
	touch $@
$(PROTOC_GEN_GRPC_GATEWAY): $(PROTOC_GEN_GRPC_GATEWAY_VERSION_FILE)

$(PROTOC_GEN_SWAGGER_VERSION_FILE): $(AKASH_DEVCACHE)
	@echo "Installing protoc-gen-grpc-gateway $(PROTOC_GEN_SWAGGER_VERSION) ..."
	rm -f $(PROTOC_GEN_GRPC_GATEWAY)
	GOBIN=$(AKASH_DEVCACHE_BIN) $(GO) install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger@$(PROTOC_GEN_SWAGGER_VERSION)
	rm -rf "$(dir $@)"
	mkdir -p "$(dir $@)"
	touch $@
$(PROTOC_GEN_SWAGGER): $(PROTOC_GEN_SWAGGER_VERSION_FILE)

$(MODVENDOR_VERSION_FILE): $(AKASH_DEVCACHE)
	@echo "installing modvendor $(MODVENDOR_VERSION) ..."
	rm -f $(MODVENDOR)
	GOBIN=$(AKASH_DEVCACHE_BIN) $(GO) install github.com/goware/modvendor@$(MODVENDOR_VERSION)
	rm -rf "$(dir $@)"
	mkdir -p "$(dir $@)"
	touch $@
$(MODVENDOR): $(MODVENDOR_VERSION_FILE)

$(GIT_CHGLOG_VERSION_FILE): $(AKASH_DEVCACHE)
	@echo "installing git-chglog $(GIT_CHGLOG_VERSION) ..."
	rm -f $(GIT_CHGLOG)
	GOBIN=$(AKASH_DEVCACHE_BIN) go install github.com/git-chglog/git-chglog/cmd/git-chglog@$(GIT_CHGLOG_VERSION)
	rm -rf "$(dir $@)"
	mkdir -p "$(dir $@)"
	touch $@
$(GIT_CHGLOG): $(GIT_CHGLOG_VERSION_FILE)

$(NPM):
ifeq (, $(shell which $(NPM) 2>/dev/null))
	$(error "npm installation required")
endif

$(SWAGGER_COMBINE): $(AKASH_DEVCACHE) $(NPM)
ifeq (, $(shell which swagger-combine 2>/dev/null))
	@echo "Installing swagger-combine..."
	npm install swagger-combine --prefix $(AKASH_DEVCACHE_NODE_MODULES)
	chmod +x $(SWAGGER_COMBINE)
else
	@echo "swagger-combine already installed; skipping..."
endif
