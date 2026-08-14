export VERSION := `cat version`

all: dep patch

dep:
    git submodule update --init --recursive
    git submodule update --force --remote
    git submodule foreach -q --recursive 'git reset --hard && git checkout ${VERSION}'

[working-directory('harbor')]
patch:
    git apply -v ../patches/{{ VERSION }}.patch

[working-directory('harbor')]
reset:
    git add .
    git reset --hard
