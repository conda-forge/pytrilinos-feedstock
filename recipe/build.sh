mkdir -p build
cd build

if [ $(uname) == Darwin ]; then
    export CXXFLAGS="-stdlib=libc++"
fi

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
  -D Trilinos_ENABLE_RTOp:BOOL=OFF \
  -D Trilinos_ENABLE_Sacado:BOOL=OFF \
  -D Trilinos_ENABLE_MiniTensor:BOOL=OFF \
  -D Trilinos_ENABLE_Epetra:BOOL=OFF \
  -D Trilinos_ENABLE_Zoltan:BOOL=OFF \
  -D Trilinos_ENABLE_Shards:BOOL=OFF \
  -D Trilinos_ENABLE_GlobiPack:BOOL=OFF \
  -D Trilinos_ENABLE_Triutils:BOOL=OFF \
  -D Trilinos_ENABLE_Tpetra:BOOL=OFF \
  -D Trilinos_ENABLE_EpetraExt:BOOL=OFF \
  -D Trilinos_ENABLE_Domi:BOOL=OFF \
  -D Trilinos_ENABLE_Thyra:BOOL=OFF \
  -D Trilinos_ENABLE_Xpetra:BOOL=OFF \
  -D Trilinos_ENABLE_Isorropia:BOOL=OFF \
  -D Trilinos_ENABLE_Pliris:BOOL=OFF \
  -D Trilinos_ENABLE_AztecOO:BOOL=OFF \
  -D Trilinos_ENABLE_Galeri:BOOL=OFF \
  -D Trilinos_ENABLE_Amesos:BOOL=OFF \
  -D Trilinos_ENABLE_Pamgen:BOOL=OFF \
  -D Trilinos_ENABLE_Zoltan2:BOOL=OFF \
  -D Trilinos_ENABLE_Ifpack:BOOL=OFF \
  -D Trilinos_ENABLE_Komplex:BOOL=OFF \
  -D Trilinos_ENABLE_ML:BOOL=OFF \
  -D Trilinos_ENABLE_Belos:BOOL=OFF \
  -D Trilinos_ENABLE_ShyLU:BOOL=OFF \
  -D Trilinos_ENABLE_Amesos2:BOOL=OFF \
  -D Trilinos_ENABLE_Komplex:BOOL=OFF \
  -D Trilinos_ENABLE_Anasazi:BOOL=OFF \
  -D Trilinos_ENABLE_Ifpack2:BOOL=OFF \
  -D Ifpack2_ENABLE_TEST:BOOL=OFF \
  -D Trilinos_ENABLE_Stratimikos:BOOL=OFF \
  -D Trilinos_ENABLE_FEI:BOOL=OFF \
  -D Trilinos_ENABLE_Teko:BOOL=OFF \
  -D Trilinos_ENABLE_Intrepid:BOOL=OFF \
  -D Trilinos_ENABLE_STK:BOOL=OFF \
  -D Trilinos_ENABLE_Phalanx:BOOL=OFF \
  -D Trilinos_ENABLE_NOX:BOOL=OFF \
  -D NOX_ENABLE_LOCA:BOOL=OFF \
  -D Trilinos_ENABLE_MueLu:BOOL=OFF \
  -D Trilinos_ENABLE_Rythmos:BOOL=OFF \
  -D Trilinos_ENABLE_Stokhos:BOOL=OFF \
  -D Trilinos_ENABLE_ROL:BOOL=OFF \
  -D Trilinos_ENABLE_Piro:BOOL=OFF \
  -D Trilinos_ENABLE_TrilinosCouplings:BOOL=OFF \
  -D Trilinos_ENABLE_Pike:BOOL=OFF \
  -D Trilinos_ENABLE_PyTrilinos:BOOL=ON \
  -D PyTrilinos_ENABLE_TESTS:BOOL=ON \
  -D PyTrilinos_ENABLE_EXAMPLES:BOOL=ON \
  -D PyTrilinos_INSTALL_PREFIX:PATH=$PREFIX \
  $SRC_DIR

make -j $CPU_COUNT

# ctest --output-on-failure

make install
