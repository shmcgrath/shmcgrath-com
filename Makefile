ZOLA ?= zola
PROJECT_ROOT := $(CURDIR)
BUILD_DIR := public
DEPLOY_BRANCH := gh-pages
LOCAL_IP := ipconfig getifaddr en0

.PHONY: serve build clean deploy new-post publish-post update-post fuse-update css-check-prefix css-minify

serve:
	$(ZOLA) serve

serve-lan:
	$(ZOLA) serve --interface 0.0.0.0 --base-url $(LOCAL_IP)

build:
	#$(MAKE) css-minify
	$(ZOLA) build
	@rm $(PROJECT_ROOT)/$(BUILD_DIR)/404.html

clean:
	rm -rf $(BUILD_DIR)

css-minify:
	./scripts/css-minify.sh

css-check-prefix:
	./scripts/css-prefix-check.sh

new-post:
	./scripts/post-new.sh $(POST_TITLE)

publish-post:
	./scripts/post-publish.sh $(POST_FILE)

update-post:
	./scripts/post-update.sh $(POST_FILE)

fuse-update:
	$(PROJECT_ROOT)/scripts/fuse-update.sh $(PROJECT_ROOT)

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

