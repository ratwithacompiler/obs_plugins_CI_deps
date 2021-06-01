# obs_ci_setup

creates azure artifacts containing all needed OBS plugin build dependencies

MacOS Archive
* OBS 27.0.0 source code
* build of it 
* extracted OBS Qt and mac dependencies 
  * QT_VERSION="5.15.2" MACOS_DEPS_VERSION="2021-03-25"

to be used as single base dependency directly on azure for CI builds of the OBS plugins without too much waste every time

