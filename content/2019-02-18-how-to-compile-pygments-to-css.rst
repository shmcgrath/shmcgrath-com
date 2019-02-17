##############################
How to Compile Pygments to CSS
##############################

:title: How to Compile Pygments to CSS
:author: Sarah H. McGrath
:tags: python, pelican, pygments
:category: blog
:status: draft
:date: 2019-02-19 00:16
:modified: 2019-02-19 00:16

I was looking for a straightforward way to compile pygments .py files into CSS. This is what I found.

.. PELICAN_END_SUMMARY

.. code-block:: python3

   def zettel(args, now):
       print("called zettel")
       datestr = f"{now:%Y-%m-%d %H:%M}"
       zetName = getName(args)
       zetTags = getTags(args)
       zetText = zettelText(zetName, datestr, zetTags)

