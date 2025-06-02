# shmcgrath-com
I have decided to use a combination of Make, M4, multimarkdown, and Bash to generate this blog. I previously used Pelican. I am using GitHub Pages to host it.

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

## Icons
I made my favicon. I want to move it to svg eventually. The SVGs are credited inline via the svg_source tag.

## .htaccess remove html from url

[This link](https://stackoverflow.com/questions/5730092/how-to-remove-html-from-url) was a comment in my .htaccess file and I believe it is where I got the code below from. I am removing it from my .htaccess file as I am moving to GitHub pages. I want to keep it here for future reference if I need it.

```
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^([^\.]+)$ $1.html [NC,L]
# RewriteRule ^(.*)\.html$ /$1 [L,R=301]
```
## TODO
- get cyberdream to a chroma for code highlighting
