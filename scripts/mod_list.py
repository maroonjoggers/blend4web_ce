#!/usr/bin/env python3

import os, sys

from os.path import join

ROOT_DIR = ".."
SRC_DIR = "src"

IGNORE_MODULES = ["shader_texts.js", "begin.js", "end.js"]
FIRST_MODULES = ["b4w.js"]
LAST_MODULES = ["ns_compat.js"]


def help():
    print("Usage: mod_list.py [prefix]")

def gen_module_list(prefix, src_dir):
    modules = []
    last_mods = []
    first_mods = []

    for root, dirs, files in os.walk(src_dir):
        files.sort()

        for file in files:
            ext = os.path.splitext(file)[1]

            if ext == ".js" and file not in IGNORE_MODULES:
                path = join(root, file)

                if prefix:
                    file_path = prefix + os.path.relpath(path, src_dir)
                else:
                    file_path = os.path.relpath(path, os.path.curdir)

                if file in LAST_MODULES:
                    last_mods.append(file_path)
                    continue

                if file in FIRST_MODULES:
                    first_mods.append(file_path)
                    continue

                modules.append(file_path)

    first_mods.extend(modules)
    first_mods.extend(last_mods)

    return first_mods

def gen_code(modules):
    lines = []

    for mod in modules:
        lines.append("<script type=\"text/javascript\" src=\""+mod+"\"></script>")

    return "\n".join(lines)

if __name__ == "__main__":
    args = sys.argv[1:]

    if len(args) > 1:
        help()
        sys.exit(1)

    prefix = ""

    if len(args) > 0:
        prefix = args[0]

    sdk_root_dir = join(os.path.abspath(os.path.dirname(__file__)), ROOT_DIR)
    src_dir = join(sdk_root_dir, SRC_DIR)
    mods = gen_module_list(prefix, src_dir)

    print(gen_code(mods))
