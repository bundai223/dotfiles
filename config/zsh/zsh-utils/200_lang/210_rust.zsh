function rust_run() {
    rustc $1
    local binary=$(basename $1 .rs)
    ./$binary
}
