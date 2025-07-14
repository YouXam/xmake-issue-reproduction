set -e
rm -rf .xmake build
base_dir=$(dirname $0)
abs_base_dir=$(cd $base_dir; pwd)
cd $abs_base_dir

echo "pwd: $(pwd)"
tree .

xmake run_main a/b/c.cpp # ok
cd a
xmake run_main b/c.cpp # ok
cd $abs_base_dir
xmake run_main a/b/c.cpp # fail