{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }: 
  let
    system = "aarch64-darwin"; # Change to "x86_64-darwin" for Intel Macs
    pkgs = import nixpkgs { inherit system; };
    langchain_community = pkgs.python312.withPackages (ps: with ps; [
      (ps.buildPythonPackage rec {
        pname = "langchain_community";
        version = "0.3.15";  # Replace with actual version if needed
        src = ps.fetchPypi {
          inherit pname version;
          sha256 = "wv7kag6huUxHW9QmPttT1WFdvjfFJjSAv1XLjkZawjU=";  # Replace with actual hash from PyPI
        };
        nativeBuildInputs = [ pkgs.python312Packages.poetry-core ];
        format = "pyproject";  # Tell Nix to use `pyproject.toml` instead of `setup.py`
        propagatedBuildInputs = [
          pkgs.python312Packages.pyyaml
          pkgs.python312Packages.sqlalchemy
          pkgs.python312Packages.aiohttp
          pkgs.python312Packages.dataclasses-json
          pkgs.python312Packages.httpx-sse
          pkgs.python312Packages.langchain
          pkgs.python312Packages.langchain-core
          pkgs.python312Packages.langsmith
          pkgs.python312Packages.numpy
          pkgs.python312Packages.pydantic-settings
          pkgs.python312Packages.requests
          pkgs.python312Packages.tenacity
        ];
      }) ]);
    pythonEnv = pkgs.python312.withPackages (ps: with ps; [
      langchain
      streamlit
      pdfplumber
      faiss
      pyyaml
      (ps.buildPythonPackage rec {
        pname = "langchain_experimental";
        version = "0.3.4";  # Replace with actual version if needed
        src = ps.fetchPypi {
          inherit pname version;
          sha256 = "k3xCWe5KY5xhjRms8OLFwomO8ScFA0btxWVSWaooGiE=";  # Replace with actual hash from PyPI
        };
        nativeBuildInputs = [ pkgs.python312Packages.poetry-core ];
        format = "pyproject";  # Tell Nix to use `pyproject.toml` instead of `setup.py`
        propagatedBuildInputs = [
          (ps.buildPythonPackage rec {
            pname = "langchain_community";
            version = "0.3.15";  # Replace with actual version if needed
            src = ps.fetchPypi {
              inherit pname version;
              sha256 = "wv7kag6huUxHW9QmPttT1WFdvjfFJjSAv1XLjkZawjU=";  # Replace with actual hash from PyPI
            };
            nativeBuildInputs = [ pkgs.python312Packages.poetry-core ];
            format = "pyproject";  # Tell Nix to use `pyproject.toml` instead of `setup.py`
            propagatedBuildInputs = [
              pkgs.python312Packages.pyyaml
              pkgs.python312Packages.sqlalchemy
              pkgs.python312Packages.aiohttp
              pkgs.python312Packages.dataclasses-json
              pkgs.python312Packages.httpx-sse
              pkgs.python312Packages.langchain
              pkgs.python312Packages.langchain-core
              pkgs.python312Packages.langsmith
              pkgs.python312Packages.numpy
              pkgs.python312Packages.pydantic-settings
              pkgs.python312Packages.requests
              pkgs.python312Packages.tenacity
            ];
          })
          streamlit
          pdfplumber
          #(ps.buildPythonPackage rec {
          #  name = "semantic-chunkers";
          #  pname = "semantic_chunkers";
          #  version = "0.0.10";  # Replace with actual version if needed
          #  src = pkgs.fetchFromGitHub {
          #    inherit pname version;
          #    sha256 = "+sBtVpy14kU52MRKnE8KzKxg2vIp4JVRImpgRAJCpcc=";  # Replace with actual hash from PyPI
          #    owner = "aurelio-labs";
          #    repo = "semantic-chunkers";
          #    tag = "v0.0.10";
          #  };
          #  nativeBuildInputs = [ pkgs.python312Packages.poetry-core ];
          #  format = "pyproject";  # Tell Nix to use `pyproject.toml` instead of `setup.py`
          #  propagatedBuildInputs = [
          ##    pkgs.python312Packages.pyyaml
          ##    pkgs.python312Packages.sqlalchemy
          ##    pkgs.python312Packages.aiohttp
          ##    pkgs.python312Packages.dataclasses-json
          ##    pkgs.python312Packages.httpx-sse
          ##    pkgs.python312Packages.langchain
          ##    pkgs.python312Packages.langchain-core
          ##    pkgs.python312Packages.langsmith
          ##    pkgs.python312Packages.numpy
          ##    pkgs.python312Packages.pydantic-settings
          ##    pkgs.python312Packages.requests
          ##    pkgs.python312Packages.tenacity
          #  ];
          #})
          #"open-text-embeddings"
          faiss
          ollama
          #"prompt_template"
          langchain
          (ps.buildPythonPackage rec {
            pname = "sentence_transformers";
            version = "3.4.1";  # Replace with actual version if needed
            src = ps.fetchPypi {
              inherit pname version;
              sha256 = "aNqldQT/VINA5U/xF72GwdL3hLIeD7JonPMnK4k3sks=";  # Replace with actual hash from PyPI
            };
            nativeBuildInputs = [ pkgs.python312Packages.setuptools ];
            format = "pyproject";  # Tell Nix to use `pyproject.toml` instead of `setup.py`
            propagatedBuildInputs = [
              pkgs.python312Packages.transformers
              pkgs.python312Packages.tqdm
              pkgs.python312Packages.torch
              pkgs.python312Packages.scikit-learn
              pkgs.python312Packages.scipy
              pkgs.python312Packages.huggingface-hub
              pkgs.python312Packages.pillow
            ];
          })
          #"faiss-cpu"
        ];

      })
    ]);
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [ pythonEnv ];
    };

  };
}
