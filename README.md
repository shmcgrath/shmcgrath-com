# shmcgrath-com
I have decided to use a combination of [Make](https://www.gnu.org/software/make/), [M4](https://www.gnu.org/software/m4/m4.html), [Pandoc](https://pandoc.org), and Bash to generate this blog. I previously used Pelican. I am using GitHub Pages to host it.

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
    - handle mono-fonts for code
    - change font back to arial and then codeblocks
- pick a yellow
