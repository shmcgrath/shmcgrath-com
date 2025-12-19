# shmcgrath-com
I have decided to use a combination of [Make](https://www.gnu.org/software/make/), [M4](https://www.gnu.org/software/m4/m4.html), [Pandoc](https://pandoc.org), [jq](https://github.com/jqlang/jq), and Bash to generate this blog. I previously used Pelican. I am using GitHub Pages to host it.

## Color Palette
I am using color combination number 12 from [ColorClaim by Tobias van Schneider](https://www.vanschneider.com/colors). In addition, I use the grayscale from [base16](http://chriskempson.com/projects/base16/).

### Blue
- Hex: #0BBCD6
- RGB: rgb(11, 188, 214)
- HSL: hsl(188, 90%, 44%)

### Red
- Hex: #E6625E
- RGB: rgb(230, 98, 94)
- HSL: hsl(2, 73%, 64%)

## Dark/Light Toggle
The dark//light toggle was inspired by [Light/Dark Theme Toggle using CSS and Javascript](https://codepen.io/Umer_Farooq/pen/eYJgKGN) by Umer Farooq on CodePen.

Note: to change the light/dark toggle icon color, search ".theme-toggle-icon" in main.css


## Icons
I made my favicon. I want to move it to svg eventually. The SVGs are credited inline via the svg_source tag.

Note: to change the social icons color, search ".socialIcon" in main.css.

## Search

Search is powered by [fuse.js](https://www.fusejs.io/).

## .htaccess remove html from url

[This link](https://stackoverflow.com/questions/5730092/how-to-remove-html-from-url) was a comment in my .htaccess file and I believe it is where I got the code below from. I am removing it from my .htaccess file as I am moving to GitHub pages. I want to keep it here for future reference if I need it.

``` shell
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^([^\.]+)$ $1.html [NC,L]
# RewriteRule ^(.*)\.html$ /$1 [L,R=301]
```
## pandoc notes
To print the default HTML template to ./pandoc-default.html:
``` bash
pandoc --print-default-template=html5 >> pandoc-default.html
```

To print the "styles.html" included in the default template to ./pandoc-styles.html:
``` bash
pandoc --print-default-data-file=templates/styles.html >> pandoc-styles.html
```

To list the code highlighting styles:
``` bash
pandoc --list-highlight-styles
```

To print one of the highlighting styles to ./{{style}}.css:
``` bash
pandoc --print-highlight-style {{style}} >> {{style}}.css
```

- [pandoc metadata information](https://gist.github.com/shorodilov/3d52206ea64bea4aae4fc8c19a88a2d1)

## Useful Resources and Code
- [How to build a great search box by Sam Dutton](https://medium.com/@samdutton/how-to-build-a-great-search-box-2b9a6d1dce0d)
- [Responsive search input by Sam Dutton](https://codepen.io/samdutton/pen/djrVVd)

## Notes to Self
Some pages have date_edited vs date_updated. date_updated is always equal to date_edited. I used date_edited on a couple of pages (blog and search) where I didn't want the date_updated rendering in the page.html template. This let me maintain fewer templates.

### Head Meta Tags I Did Not Use
``` html
<!-- Bing -->
<!-- These are used for address recognition purpose. These are supported by Bing but not Google. -->
<meta name="geo.placename" content="Place Name">
<meta name="”geo.position" content="latitude; longitude">
<meta name="”geo.region" content="Country Subdivision Code">
```

## TODO
- set up last revised date to change html, possibly with current date, too (m4 again?)
- get cyberdream to a  for code highlighting from pandoc
- navigation html
- code css for each type of post and fix light theme (text seems too black?)
- set up templates for pages, errors, blog posts, and blog archive/index
- flesh out build-posts script
- add to build-pages script to generate blog index
- do i split out template processing to a different script then pandoc everything?
- any additional m4 processing on base (make build-base) possibly current date and year?
- rss or atom feed script
- sitemap script
- add twitter, facebook, etc metadata
- for each page and post: <link rel="canonical" href="https://www.example.com/preferred-page" />
- cleanup steps: delete tmp and also delete public once it is pushed to github
- make sure everything has tabs not spaces
- learn shellcheck and do that for the bash
- implement fuse.js search
- script to generate json for fuse.js
- script to remove any inline css from pandoc code highlighting? is there a way to stop pandoc generating this?
    - <link rel="stylesheet" href="/css/syntax.css">
    - --css=style.css also have --standalone flag
- list of metatags: https://dev.to/electrondome/are-meta-tags-still-relevant-in-2025-3l70
- https://sluggenius.com/blog/meta-tags-optimization
- robots.txt in 2025
    - https://www.amitk.io/robots-txt-in-2025/
    - https://thetexttool.com/blog/robots-txt-best-practices-2025
- write blogpost about this setup and why
    - pelican
    - zola i like it a lot, but if i recall correctly it had some corner cases working against me
    - jekyll
    - not remembering how to do something or setting up the development enviroment
    - i dont blog much if at all, and this stuff rarely changes
    - dont want to constantly set up development environments or change structures for static site generators
    - pelican plugins and search
    - i dont need a theme/config a lot can be hard coded, im not making bunches of websites
    - with a good base template, the varaibles i wanted to change in the configs can just be changed in the base template
    - super useful: https://medium.com/@samdutton/how-to-build-a-great-search-box-2b9a6d1dce0d
    - why did i write my own search?
- handle mono-fonts for code
- change font back to arial and then codeblocks
- pick a yellow
- datetime html: https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/time
- https://www.w3.org/WAI/tutorials/forms/labels/#using-aria-label aria labels
- fix button bezel/outline on search button
- custom css for resume and script that into the header -- maybe via pandoc variables?
- current year with datetime vs div
- make date and get date to clipboard
- make fuse update rely on a config file and maybe use a pinned version in the header via M4?
- make the search results much better adn include a link? and matbe the matching part?
- convert datetime between formats or just ignore the <time> tag?
- css replace shmred and shmblue with shmprimary shmsecondary and make sure shmaccent is easy to change
- add shmlinks color too?
- clean up base.html and possibly break into more M4 templates
- maybe have xml generated again and nest ifs, not sure. search index isn't relevant for that
- create and update blog scrips for additional date formats
- custom search vs fuse?
- change all css and html to kebab case
- [ARIA and other best practices](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA)
- [meta element reference including theme](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/meta)
- add tag page and list of posts by tags (maybe make blog page by year then by tag? all in one page?)
    - Blog
        - Posts by Year
            - 2025
            - 2016
        - Tag List
- when clicking on a tag in a tag list, you then get taken to a new page where the tag is listed, so would need a hidden /tags/tag page - look at errors for generating it
- css for <mark>
- add the summary/description to search
- css static prefix research again?
- svg sheet and pull them in?
- https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@media/prefers-color-scheme - prefers-color-scheme for me
- templates in js https://www.youtube.com/watch?v=HgNDii20FG4
- fix outline colors when you tab through things?
- favicon in svg format - how?
- can i use partial or standalone for pandoc to get html for the articles much easier?
- look into [autoprefixer and the cli for it](https://github.com/postcss/autoprefixer)
- [media queries and responsive design](https://www.w3schools.com/css/css_rwd_mediaqueries.asp)
- [using media queries - mdn](https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Media_queries/Using)
- [20 New CSS Features You Need](https://www.youtube.com/watch?v=VA975GOUFmM)
- [Website Accessibility](https://www.youtube.com/watch?v=FTdyf6t9PoA)
- [CSS Wireframe](https://www.tutorialpedia.org/blog/html-css-wireframe/)
- should h1 etc be in header or main
- section in main vs div in main
- add description to pages like about, resume, etc for the header
- look into opengraph protocol for head tags
- find out how to make paragraphs breathe more on article, cannnot seem to fix the line spacing at all, everything is too close together
- try purple accent for both light and dark
### Head Meta Tags I Need to Implement
- [article meta add to M4_ADDITIONAL_META>](https://zhead.dev/meta/article-published_time)
``` html
<meta name="article:published_time" content="{{ article.modified.isoformat() }}">
<meta name="article:modified_time" content="{{ article.date.isoformat() }}">
<meta name="keywords" content="{{article.tags}}">
<meta name="medium" content="article">
<meta name="news_keywords" content="{{article.tags}}">
```
``` html
<!-- twitter/x -->
<meta name="twitter:app:id:googleplay" content="">
<meta name="twitter:app:id:iphone" content="">
<meta name="twitter:app:name:googleplay" content="">
<meta name="twitter:app:name:iphone" content="">
<meta name="twitter:app:url:googleplay" content="">
<meta name="twitter:app:url:iphone" content="">
<meta name="twitter:card" content="">
<meta name="twitter:creator" content="">
<meta name="twitter:description" content="">
<meta name="twitter:image" content="">
<meta name="twitter:site" content="">
<meta name="twitter:title" content="">
<meta name="twitter:url" content="">
<!-- facebook/meta -->
<meta property="fb:app_id" content="">
<meta property="fb:pages" content="">
<meta property="og:description" content="">
<meta property="og:image" content="">
<meta property="og:image:height" content="">
<meta property="og:image:width" content="">
<meta property="og:site_name" content="">
<meta property="og:title" content="">
<meta property="og:type" content="article">
<meta property="og:url" content="">
<!-- Pinterest -->
<meta name="pinterest:description" content="">
<meta name="pinterest:media" content="">
<meta name="pinterest:url" content="">
```
