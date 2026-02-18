PROJECT_ROOT := $(CURDIR)
BUILD_DIR := $(PROJECT_ROOT)/public
CONTENT_DIR := $(PROJECT_ROOT)/content
DEPLOY_BRANCH := gh-pages
SITE_URL_DEV := http://127.0.0.1:5859
SITE_URL_PROD := https://shmcgrath.com
M4_SITE_URL ?= $(SITE_URL_PROD)
export M4_SITE_URL

ifeq ($(shell uname -s),Darwin)
CLIP := pbcopy
else
CLIP := wl-copy
endif

.PHONY: serve build clean deploy new-post publish-post update-post css-check-prefix

copy-static:
	@mkdir -pv $(BUILD_DIR)
	@cp -r $(PROJECT_ROOT)/static/. $(BUILD_DIR)/
	@mv -f $(BUILD_DIR)/img/favicon.ico $(BUILD_DIR)/favicon.ico
	@rm -f $(BUILD_DIR)/.DS_Store

build-content:
	@./bin/build-content.sh $(CONTENT_DIR) $(BUILD_DIR)

build-error-pages:
	@./bin/build-error-pages.sh $(BUILD_DIR)

generate-indices:
	@./bin/generate-search-index.sh $(CONTENT_DIR) $(BUILD_DIR)
#@./bin/generate-rss.sh $(CONTENT_DIR) $(BUILD_DIR)
#@./bin/generate-sitemap.sh $(CONTENT_DIR) $(BUILD_DIR)

clean:
	@rm -rf $(BUILD_DIR)
	@rm -rf $(PROJECT_ROOT)/tmp

build: clean
	@$(MAKE) copy-static
	@$(MAKE) build-content
	@$(MAKE) build-error-pages
	@$(MAKE) generate-indices

serve:
		@read -p "Rebuild before starting server? (y/n): " answer; \
		case "$$answer" in \
			[yY]) $(MAKE) build M4_SITE_URL=$(SITE_URL_DEV) ;; \
			*) printf "%s\n" "Skipping build..." ;; \
		esac;
		@printf "%s\n" "$(SITE_URL_DEV)" | $(CLIP)
		@python3 -m http.server --bind 127.0.0.1 --directory public 5859

css-check-prefix:
	./bin/css-prefix-check.sh

new-post:
	./bin/post-new.sh $(POST_TITLE)

publish-post:
	./bin/post-publish.sh $(POST_FILE)

update-post:
	./bin/post-update.sh $(POST_FILE)

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
