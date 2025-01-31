{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, substituteAll
, pythonOlder
, geos
, pytestCheckHook
, cython
, numpy
}:

buildPythonPackage rec {
  pname = "Shapely";
  version = "1.8.1.post1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-k/8G/wX74r6EO5PHsa2CkuVuZlugG0cI91rop1eXLp8=";
  };

  nativeBuildInputs = [
    geos # for geos-config
    cython
  ];

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # Environment variable used in shapely/_buildcfg.py
  GEOS_LIBRARY_PATH = "${geos}/lib/libgeos_c${stdenv.hostPlatform.extensions.sharedLibrary}";

  patches = [
    # Patch to search form GOES .so/.dylib files in a Nix-aware way
    (substituteAll {
      src = ./library-paths.patch;
      libgeos_c = GEOS_LIBRARY_PATH;
      libc = lib.optionalString (!stdenv.isDarwin) "${stdenv.cc.libc}/lib/libc${stdenv.hostPlatform.extensions.sharedLibrary}.6";
    })
 ];

  preCheck = ''
    rm -r shapely # prevent import of local shapely
  '';

  disabledTests = [
    "test_collection"
  ];

  pythonImportsCheck = [ "shapely" ];

  meta = with lib; {
    description = "Geometric objects, predicates, and operations";
    homepage = "https://pypi.python.org/pypi/Shapely/";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ knedlsepp ];
  };
}
