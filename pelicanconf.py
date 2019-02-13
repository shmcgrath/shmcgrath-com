#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = 'Sarah H. McGrath'
SITENAME = 'Sarah H. McGrath'
SITEURL = ''
TIMEZONE = 'America/New_York'
DEFAULT_LANG = 'en'

THEME = './themes/abby'
THEME_STATIC_DIR = ''
PATH = 'content'

# static paths will be copied without parsing their contents
STATIC_PATHS = ['extra', 'img', 'robots.txt', 'docs']
PAGE_EXCLUDES = ['extra', 'img', 'robots.txt', 'docs']
ARTICLE_EXCLUDES = ['extra', 'img', 'robots.txt', 'docs']

INDEX_SAVE_AS = 'blog/index.html'
ARCHIVES_SAVE_AS = 'archives.html'
TAGS_SAVE_AS = 'tags.html'
AUTHORS_SAVE_AS = ''
CATEGORY_SAVE_AS = ''

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = (('Pelican', 'http://getpelican.com/'),
         ('Python.org', 'http://python.org/'),
         ('Jinja2', 'http://jinja.pocoo.org/'),
         ('You can modify those links in your config file', '#'),)

MENUITEMS = (('Blog', SITEURL + '/' + INDEX_SAVE_AS),)
# Make sure an archive page is created and added

# Social widget
SOCIAL = (('You can add links in your config file', '#'),
          ('Another social link', '#'),)

# Base settings
USE_FOLDER_AS_CATEGORY = False
DEFAULT_PAGINATION = False
DEFAULT_CATEGORY = 'misc'
DISPLAY_CATEGORIES_ON_MENU = False

SLUGIFY_SOURCE = 'basename'
ARTICLE_URL = 'blog/{slug}'
ARTICLE_SAVE_AS = 'blog/{slug}.html'
PAGE_URL = '{slug}'
PAGE_SAVE_AS = '{slug}.html'
# jinja settings
# http://jinja.pocoo.org/docs/dev/api/#jinja2.Environment
# JINJA_ENVIRONMENT = {'trim_blocks': True, 'lstrip_blocks': True}
# JINJA_FILTERS = {}

# Plugins
# Tipue Search
# html_rst_directive This plugin allows you to use HTML tags from within reST documents.
# .. html::
#   (HTML code)
# better_code_samples This plugin wraps all table blocks with a class attribute .codehilitetable in an additional div of class .hilitewrapper. It thus permits to style codeblocks better, especially to make them scrollable.
PLUGIN_PATHS = ['pelican-plugins']
PLUGINS = ['tipue_search']
#PLUGINS = ['tipue_search', 'html_rst_directive', 'better_code_samples']
DIRECT_TEMPLATES = ['index', 'tags', 'archives', 'search']

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True

# Custom Varioables for abby
HAS_RESUME = True
RESUME_PAGE = "Resume"
RESUME_LOCATION = "/docs/SHMcGrathResume.pdf"

ABOUT_SITE = True
