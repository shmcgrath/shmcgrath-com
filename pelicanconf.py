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
STATIC_PATHS = [
    'extra'
    ]
PAGE_EXCLUDES = ['extra']
ARTICLE_EXCLUDES = ['extra']

INDEX_SAVE_AS = 'blog.html'

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

# Social widget
SOCIAL = (('You can add links in your config file', '#'),
          ('Another social link', '#'),)

# Base settings
USE_FOLDER_AS_CATEGORY = False
DEFAULT_PAGINATION = False
DEFAULT_CATEGORY = 'misc'

# jinja settings
# http://jinja.pocoo.org/docs/dev/api/#jinja2.Environment
# JINJA_ENVIRONMENT = {'trim_blocks': True, 'lstrip_blocks': True}
# JINJA_FILTERS = {}

# Plugins
# Tipuse Search
PLUGIN_PATHS = ['pelican-plugins']
PLUGINS = ['tipue_search']
DIRECT_TEMPLATES = ['index', 'tags', 'categories', 'authors', 'archives', 'search']

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True
