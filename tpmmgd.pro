# QML targets
tpmmgd.source = qml/tpmmgd
tpmmgd.target = qml
tpmmgd.depends = lib/minmaxgd

# JS dependencies for the Editor
mathjax.source = lib/mathjax/unpacked/
mathjax.target = qml/tpmmgd/Editor/mathjax
ace.source = lib/ace/src-noconflict/
ace.target = qml/tpmmgd/Editor/ace
require.source = lib/require/
require.target = qml/tpmmgd/Editor

# Go!
DEPLOYMENTFOLDERS = tpmmgd mathjax ace require

TEMPLATE = subdirs
SUBDIRS = src lib/minmaxgd

OTHER_FILES += \
    qml/tpmmgd/Editor/math.html \ 
    qml/tpmmgd/Editor/latex.html
