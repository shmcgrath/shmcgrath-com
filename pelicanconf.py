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
PLUGIN_PATHS = ['pelican-plugins']
PLUGINS = ['tipue_search', 'summary']
DIRECT_TEMPLATES = ['index', 'tags', 'archives', 'search']

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True

# Custom Varioables for abby
HAS_RESUME = True
RESUME_PAGE = "Resume"
RESUME_LOCATION = "/docs/SHMcGrathResume.pdf"
SITE_DESCRIPTION = "Sarah H. McGrath's website."
# The revised meta tag records the last update done to the site.
# Format: YYYY-MM-DD
# SITE_REVISED = ""
# variables for including Metadata
META_BING = False
META_FACEBOOK = False
META_GOOGLE = False
META_PINTEREST = False
META_TWITTER = False

# social icons variables and definitions
# for red icons, set color to "r"; for blue icons set color to "b"
SOCIAL_ICONS = True
SOCIAL_ICONS_COLOR = "r"
SOCIAL_ICONS_GITHUB = True
SOCIAL_ICONS_GITHUB_USER = "shmcgrath"
SOCIAL_ICONS_LINKEDIN = True
SOCIAL_ICONS_LINKEDIN_URL = "mcgrathsh"
SOCIAL_ICONS_MAILTO = True
SOCIAL_ICONS_MAILTO_ADDRESS = "sarah@shmcgrath.com"
SOCIAL_ICONS_TWITTER = True
SOCIAL_ICONS_TWITTER_USER = "mcgrath_sh"
SOCIAL_ICONS_REDDIT = True
SOCIAL_ICONS_REDDIT_USER = "shmcg"
SOCIAL_ICONS_PDF_RESUME = True
SOCIAL_ICONS_FEED_ATOM = True

# variables defining Metadata
META_GENERATOR = "Pelican v.4.0.1"

ABOUT_SITE = True

# Pygments
PYGMENTS_RST_OPTIONS =  {'linenos': 'table'}
