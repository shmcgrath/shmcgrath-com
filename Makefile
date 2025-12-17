PROJECT_ROOT := $(CURDIR)
BUILD_DIR := $(PROJECT_ROOT)/public
CONTENT_DIR := $(PROJECT_ROOT)/content
DEPLOY_BRANCH := gh-pages
ifeq ($(shell uname -s),Darwin)
CLIP := pbcopy
else
CLIP := wl-copy
endif

.PHONY: serve build clean deploy new-post publish-post update-post fuse-update css-check-prefix

copy-static:
	@mkdir -pv $(BUILD_DIR)
	@cp -r static/. $(BUILD_DIR)/
	@rm -f $(BUILD_DIR)/.DS_Store

build-content:
	@./scripts/build-content.sh $(CONTENT_DIR) $(BUILD_DIR)

build-error-pages:
	@./scripts/build-error-pages.sh $(BUILD_DIR)

generate-indices:
	@./scripts/generate-search-index.sh $(CONTENT_DIR) $(BUILD_DIR)
#@./scripts/generate-rss.sh $(CONTENT_DIR) $(BUILD_DIR)
#@./scripts/generate-sitemap.sh $(CONTENT_DIR) $(BUILD_DIR)

clean:
	@rm -rf $(BUILD_DIR)
	@rm -rf $(PROJECT_ROOT)/tmp

build: clean
	@mkdir -pv $(BUILD_DIR)
	@$(MAKE) copy-static
	@$(MAKE) build-content
	@$(MAKE) build-error-pages
	@$(MAKE) generate-indices

serve: build
		@printf "%s\n" "http://127.0.0.1:5859/" | $(CLIP)
		@python3 -m http.server --bind 127.0.0.1 --directory public 5859

css-check-prefix:
	./scripts/css-prefix-check.sh

new-post:
	./scripts/post-new.sh $(POST_TITLE)

publish-post:
	./scripts/post-publish.sh $(POST_FILE)

update-post:
	./scripts/post-update.sh $(POST_FILE)

deploy:
	@$(MAKE) build
	# Add worktree
	rm -rf /tmp/$(DEPLOY_BRANCH)
	git worktree add -B $(DEPLOY_BRANCH) /tmp/$(DEPLOY_BRANCH) origin/$(DEPLOY_BRANCH)

	# Copy files
	rsync -av --delete $(BUILD_DIR)/ /tmp/$(DEPLOY_BRANCH)/

	# Commit and push
	cd /tmp/$(DEPLOY_BRANCH) && \
	git add . && \
	git commit -m "Deploy site" && \
	git push origin $(DEPLOY_BRANCH)

	# Clean up
	git worktree remove /tmp/$(DEPLOY_BRANCH)
	@$(MAKE) clean
