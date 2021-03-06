# shmcgrath-com
[Pelican](https://blog.getpelican.com/) config file and theme for shmcgrath.com. [The Pelican Docs for the latest stable edition can be found here.](https://docs.getpelican.com/en/stable/)

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

## Sass
Sass is compiled via [libsass build.](https://sass.github.io/libsass-python/sassutils/builder.html)

## Pygments Colorscheme
I am using the [base16-nord](https://github.com/mohd-akram/base16-pygments) colorsheme for code blocks formatted by pygments.

## Evnironment Setup
- create a venv with Python 3 and install requirements.txt
- clone [pelican-plugins](https://github.com/getpelican/pelican-plugins)
- transfer or create secrets.py which should include
    - PROD_URL = ''
    - PROD_DEST_PATH = ''
    - PROD_PORT = 
