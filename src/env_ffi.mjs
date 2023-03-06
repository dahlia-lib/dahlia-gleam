import {
    Error,
    Ok,
} from "./gleam.mjs";

export function get_env(name) {
    if (typeof process !== 'undefined') {
        // We must be in Node
        var env = process.env[name]
    }
    else if (typeof Deno !== 'undefined') {
        // We must be in Deno
        var env = Deno.env.get(name);
    } else {
        return new Error(undefined)
    }

    if (env === undefined) {
        return new Error(undefined)
    } else {
        return new Ok(env)
    }
}
