param(
  $axmol_src = $null,
  $wasm_artifact_dir = $null,
  $min_doc_ver = '2.5'
)
if ($wasm_artifact_dir) {
  $wasm_artifact_dir = (Resolve-Path $wasm_artifact_dir).Path
}

function mkdirs([string]$path) {
  if (!(Test-Path $path)) {
    New-Item $path -ItemType Directory 1>$null
  }
}

$site_dist = Join-Path $PSScriptRoot 'dist/'
mkdirs $site_dist

# step.1 build main site
Copy-Item (Join-Path $PSScriptRoot 'index.html') $site_dist
Copy-Item (Join-Path $PSScriptRoot 'favicon.ico') $site_dist
Copy-Item (Join-Path $PSScriptRoot 'assets') $site_dist -Recurse -Force
Copy-Item (Join-Path $PSScriptRoot 'sponsor') $site_dist -Recurse -Force

# step.2 build docs to main site manual
if ($axmol_src) {
  $build_docs_script = Join-Path $axmol_src 'tools/cmdline/plugins/build-docs.ps1'
  &$build_docs_script $site_dist -min_ver $min_doc_ver
}

# step.3 build wasm preview site
if ($wasm_artifact_dir) {
  Copy-Item $(Join-Path $PSScriptRoot 'wasm') $site_dist -Recurse -Force

  # add headers config for wasm pthread support, current netlify support
  # github pages not support configure custom headers
  Copy-Item $(Join-Path $PSScriptRoot '_headers') $site_dist
  $site_wasm_dir = Join-Path $site_dist 'wasm/'
  function copy_tree_if($source, $dest) {
    if (Test-Path $source) {
      Copy-Item $source $dest -Container -Recurse
    }
  }

  $cpp_tests_dir = $(Join-Path $wasm_artifact_dir 'cpp-tests')
  if (!(Test-Path $cpp_tests_dir -PathType Container)) {
    throw "Missing wasm cpp-tests, caused by last wasm ci build fail."
  }
  copy_tree_if $cpp_tests_dir $site_wasm_dir
  copy_tree_if $(Join-Path $wasm_artifact_dir 'fairygui-tests') $site_wasm_dir
}
