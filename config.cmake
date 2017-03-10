#find_library is inducing errors in mingw and debian stretch, so we just hope gmp is installed and reachable...
set(GMP_INCLUDE_DIR "" CACHE PATH "INCLUDE DIRECTORY FOR GMP")
set(GMP_LIBRARY_CXX "gmpxx" CACHE STRING "GMP C++ LIBRARY")
set(GMP_LIBRARY_C   "gmp" CACHE STRING "GMP C   LIBRARY")
