# Package

version       = "2.6.1"
author        = "Constantine Molchanov"
description   = "Nim ORM for SQLite and PostgreSQL."
license       = "MIT"
srcDir        = "src"
skipDirs      = @["tests", "htmldocs"]


# Dependencies

requires "nim >= 1.4.0"
when NimMajor >= 1 and NimMinor >= 9:
  requires "https://github.com/PhilippMDoerner/ndb.nim#eb7ef4c"
else:
  requires "ndb >= 0.19.9"

task test, "Run tests":
  exec "testament all"

task book, "Generate book":
  rmDir "docs"
  exec "nimble install -y nimib nimibook@#280a626a902745b378cc2186374f14c904c9a606"
  exec "nim r -d:release nbook.nim update"
  exec "nim r -d:release nbook.nim build"
  cpFile("CNAME", "docs/CNAME")

task docs, "Generate docs":
  rmDir "docs/apidocs"
  exec "nimble doc --outdir:docs/apidocs --project --index:on src/norm"

