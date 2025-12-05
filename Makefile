PROJECT_ROOT := $(CURDIR)
BUILD_DIR := $(PROJECT_ROOT)/public
CONTENT_DIR := $(PROJECT_ROOT)/content
DEPLOY_BRANCH := gh-pages

.PHONY: serve build clean deploy new-post publish-post update-post fuse-update css-check-prefix css-minify html postprocess-awk

build-pages:
	./scripts/build-pages.sh $(CONTENT_DIR) $(BUILD_DIR)

build-posts:
	./scripts/build-posts.sh $(CONTENT_DIR) $(BUILD_DIR)

build-error-pages:
	./scripts/build-error-pages.sh $(BUILD_DIR)

postprocess-awk:
	./scripts/postprocess-awk-html.sh $(FILE)

clean:
	@rm -rf $(BUILD_DIR)

serve: build
	@printf "http://127.0.0.1:5859/\n" | pbcopy
	@python3 -m http.server --bind 127.0.0.1 --directory public 5859

build: clean
	@mkdir -pv $(BUILD_DIR)
	@cp -r static/. $(BUILD_DIR)/
	$(MAKE) build-pages
	$(MAKE) build-posts
	$(MAKE) build-error-pages

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
