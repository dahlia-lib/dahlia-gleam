pub fn get_env(name: String) -> Result(String, Nil) {
  get_env_inner(name)
}

if erlang {
  import gleam/erlang/os

  fn get_env_inner(name: String) {
    os.get_env(name)
  }
}

if javascript {
  external fn get_env_inner(name: String) -> Result(String, Nil) =
    "../env_ffi.mjs" "get_env"
}
