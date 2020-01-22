# Package

version       = "1.0.17"
author        = "Constantine Molchanov"
description   = "Nim ORM for SQLite and PostgreSQL."
license       = "MIT"
srcDir        = "src"
skipDirs      = @["tests", "htmldocs"]


# Dependencies

requires "nim >= 1.0.0", "ndb >= 0.19.8"

task apidoc, "Generate API docs":
  --outdir:"htmldocs/api"
  --git.url: https://github.com/moigagoo/orm/
  --git.commit: develop
  --project
  --index:on

  setCommand "doc", "src/norm"

task idx, "Generate index":
  selfExec "buildIndex --out:htmldocs/api/theindex.html htmldocs/api"

task docs, "Generate docs":
  rmDir "htmldocs"
  exec "nimble apidoc"
  exec "nimble idx"
  selfExec "rst2html --out:htmldocs/index.html README.rst"
