# project name
project (indicator-kdeconnect)
# the oldest stable cmake version we support
cmake_minimum_required (VERSION 2.6)
# tell cmake where its modules can be found in our project directory
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
# where we install data directory (if we have any)
	set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
# what to call that directory where we install data too
	set (PKGDATADIR "${DATADIR}/indicator-kdeconnect")
	set (RELEASE_NAME "whats up world")
	set (VERSION_INFO "Indicator for KDE Connect daemon")
	set (VERSION "0.1")
# we're about to use pkgconfig to make sure dependencies are installed so let's find pkgconfig first
find_package(PkgConfig)
# now let's actually check for the required dependencies
	pkg_check_modules(DEPS REQUIRED gtk+-3.0 appindicator3-0.1)
add_definitions(${DEPS_CFLAGS})
link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})
# make sure we have vala
find_package(Vala REQUIRED)
# make sure we use vala
include(ValaVersion)
# make sure it's the desired version of vala
	ensure_vala_version("0.20" MINIMUM)
# files we want to compile
include(ValaPrecompile)

#indicator 
set (INDICATOR_EXEC "indicator-kdeconnect")
vala_precompile(INDICATOR_VALA_C ${INDICATOR_EXEC}
		src/main.vala
		src/Device.vala
		src/KDEConnectManager.vala
		src/DeviceIndicator.vala
		PACKAGES
		gtk+-3.0
		appindicator3-0.1
		       )

# tell cmake what to call the executable we just made
add_executable(${INDICATOR_EXEC} ${INDICATOR_VALA_C})
# install the binaries we just made
install (TARGETS ${INDICATOR_EXEC} RUNTIME DESTINATION bin)
# install our .desktop file so the Applications menu will see it
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/indicator-kdeconnect.desktop DESTINATION ${DATADIR}/applications/)

# contractor binary
set (CONTRACTOR_EXEC "kdeconnect-send")
vala_precompile(VALA_C ${CONTRACTOR_EXEC}
		src/contractor/Contractor.vala
		src/Device.vala
		PACKAGES
		gtk+-3.0
)

add_executable(${CONTRACTOR_EXEC} ${VALA_C})
install (TARGETS ${CONTRACTOR_EXEC} RUNTIME DESTINATION bin)
# install .contract file
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/kdeconnect.contract DESTINATION ${DATADIR}/contractor/)
