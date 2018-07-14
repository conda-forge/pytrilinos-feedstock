mkdir -p build
cd build

REMOVE="-Wl,-rpath,${PREFIX}/lib"
export LDFLAGS=${LDFLAGS//$REMOVE}

if [ $(uname) == Darwin ]; then
    export CXXFLAGS="$CXXFLAGS -stdlib=libc++"
fi

# export MPI_FLAGS="--allow-run-as-root"
# if [ $(uname) == Linux ]; then
#     export MPI_FLAGS="$MPI_FLAGS;-mca;plm;isolated"
# fi

export HYDRA_LAUNCHER=fork
export OMPI_MCA_plm=isolated
export OMPI_MCA_btl_vader_single_copy_mechanism=none
export OMPI_MCA_rmaps_base_oversubscribe=yes

cmake \
  -D CMAKE_BUILD_TYPE:STRING=RELEASE \
  -D CMAKE_INSTALL_PREFIX:PATH=$PREFIX \
  -D BUILD_SHARED_LIBS:BOOL=ON \
  -D TPL_ENABLE_MPI:BOOL=ON \
  -D MPI_BASE_DIR:PATH=$PREFIX \
  -D MPI_EXEC:FILEPATH=$PREFIX/bin/mpiexec \
  -D MPI_EXEC_PRE_NUMPROCS_FLAGS:STRING="$MPI_FLAGS" \
  -D PYTHON_EXECUTABLE:FILEPATH=$PYTHON \
  -D SWIG_EXECUTABLE:FILEPATH=$PREFIX/bin/swig \
  -D DOXYGEN_EXECUTABLE:FILEPATH=$PREFIX/bin/doxygen \
  -D Trilinos_ENABLE_Fortran:BOOL=OFF \
  -D Trilinos_ENABLE_ALL_PACKAGES:BOOL=OFF \
  -D Trilinos_ENABLE_ALL_OPTIONAL_PACKAGES:BOOL=OFF \
  -D Trilinos_ENABLE_TESTS:BOOL=OFF \
  -D Trilinos_ENABLE_EXAMPLES:BOOL=OFF \
  -D Trilinos_ENABLE_Teuchos:BOOL=ON \
  -D Trilinos_ENABLE_Epetra:BOOL=ON \
  -D Trilinos_ENABLE_Triutils:BOOL=ON \
  -D Trilinos_ENABLE_Tpetra:BOOL=ON \
  -D Trilinos_ENABLE_EpetraExt:BOOL=ON \
  -D Trilinos_ENABLE_Domi:BOOL=ON \
  -D Trilinos_ENABLE_Isorropia:BOOL=ON \
  -D Trilinos_ENABLE_Pliris:BOOL=ON \
  -D Trilinos_ENABLE_AztecOO:BOOL=ON \
  -D Trilinos_ENABLE_Galeri:BOOL=ON \
  -D Trilinos_ENABLE_Amesos:BOOL=ON \
  -D Trilinos_ENABLE_Ifpack:BOOL=ON \
  -D Trilinos_ENABLE_ML:BOOL=ON \
  -D Trilinos_ENABLE_Komplex:BOOL=ON \
  -D Trilinos_ENABLE_Anasazi:BOOL=ON \
  -D Trilinos_ENABLE_NOX:BOOL=ON \
  -D NOX_ENABLE_LOCA:BOOL=ON \
  -D Trilinos_ENABLE_PyTrilinos:BOOL=ON \
  $SRC_DIR

make -j $CPU_COUNT
$PYTHON packages/PyTrilinos/util/configFix.py
ctest --output-on-failure
make install
