TEMPLATE = subdirs
SUBDIRS = sources minmaxgd

sources.subdir = src
sources.depends = minmaxgd
minmaxgd.subdir = lib/minmaxgd
