---
title: Making My Website with Pandoc, M4, and Bash
subtitle:
author: Sarah H. McGrath
description:
keywords:
date: 2026-05-30T17:06:24-04:00
date_rfc5322: Sat, 30 May 2026 17:06:24 -0400
date_updated:
date_updated_rfc5322:
date_published:
date_published_rfc5322:
slug: 2026-05-30-making-my-website-with-pandoc-m4-and-bash
in_search_index: true
draft: true

---
- write blogpost about this setup and why

## A Static Development Environment
- pelican
- zola i like it a lot, but if i recall correctly it had some corner cases working against me
- jekyll
- not remembering how to do something or setting up the development enviroment
- i dont blog much if at all, and this stuff rarely changes
- dont want to constantly set up development environments or change structures for static site generators

### The Benefits of a Makefile
- makefile makes a great way to remember what scripts do what and what commands i have available

### Security and Dependencies
- supply chain attacks
- zero maintenance

## I am the Only End User
- why no m4 config file - only variable i need can be done in a makefile
- i dont need a theme/config a lot can be hard coded, im not making bunches of websites
- with a good base template, the varaibles i wanted to change in the configs can just be changed in the base template

## Why I Wrote my Own Search
- pelican plugins and search
- why did i write my own search?
