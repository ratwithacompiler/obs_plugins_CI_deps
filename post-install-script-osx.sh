#!/bin/bash

mv -vn /usr/local/Cellar/qt/5.10.1 qt_dep

zip -u -4 -r ./archive_osx.zip obs_src
zip -u -4 -r ./archive_osx.zip qt_dep
zip -u -4 -r ./archive_osx.zip osx_deps
