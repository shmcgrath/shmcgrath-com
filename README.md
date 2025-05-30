# shmcgrath-com
I use [Zola](https://www.getzola.org/) to build shmcgrath.com, and GitHub Pages to host it. Both the source and resulting website are in this repo.

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

## Icons
The icons were generated from [iconizer](http://iconizer.net) or similar.

## Pygments Colorscheme
I am using the [base16-nord](https://github.com/mohd-akram/base16-pygments) colorsheme for code blocks formatted by pygments.

- create a venv with Python 3 and install requirements.txt
- clone [pelican-plugins](https://github.com/getpelican/pelican-plugins)
- transfer or create secrets.py which should include
    - PROD_URL = ''
    - PROD_DEST_PATH = ''
    - PROD_PORT = 
## .htaccess remove html from url

[This link](https://stackoverflow.com/questions/5730092/how-to-remove-html-from-url) was a comment in my .htaccess file and I believe it is where I got the code below from. I am removing it from my .htaccess file as I am moving to GitHub pages. I want to keep it here for future reference if I need it.

```
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^([^\.]+)$ $1.html [NC,L]
# RewriteRule ^(.*)\.html$ /$1 [L,R=301]
```
