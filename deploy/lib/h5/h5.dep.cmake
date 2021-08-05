find_package(MPI REQUIRED)

set(HDF5_PREFER_PARALLEL ON)
set(HDF5_NO_FIND_PACKAGE_CONFIG_FILE ON)
find_package(HDF5 REQUIRED COMPONENTS C HL)
set(CMAKE_C_COMPILER ${MPI_C_COMPILER})

if(NOT HDF5_IS_PARALLEL)
  message(FATAL_ERROR "no parallel HDF5")
endif()

set(T hdf)
add_library(${T} INTERFACE IMPORTED)
set_property(TARGET ${T} APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${HDF5_INCLUDE_DIRS})
set_property(TARGET ${T} APPEND PROPERTY
  INTERFACE_LINK_LIBRARIES
  ${HDF5_LIBRARIES}
  ${HDF5_HL_LIBRARIES}
  )

