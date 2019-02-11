import sass
import os
from collections import Mapping
import logging
from logging.config import fileConfig


def compileSass():
    logging.debug('compileSass start')
    cwd = os.getcwd()
    sassdir = cwd + "/themes/abby/sass"
    cssdir = cwd + "/themes/abby/static/css"

    sass.compile(dirname=(sassdir, cssdir), output_style="nested")
    logging.debug('compileSass end')

def main():
    fileConfig('logging_config.ini')
    logging.getLogger(__name__).addHandler(logging.NullHandler())
    logger = logging.getLogger()
    logger = logging.getLogger('shmcgrathcom')
    logging.debug('main called')
    compileSass()
    logging.debug('main finished')

if __name__ == '__main__':
    main()
