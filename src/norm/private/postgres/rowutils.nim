## Procs to convert `Model <../../model.html#Model>`_ instances to ``ndb.postgres.Row`` instances and back.

import std/options

import ndb/postgres

import dbtypes
import ../dot
import ../../model
import ../../pragmas

when (NimMajor, NimMinor) <= (1, 6):
  import ../../pragmasutils
else:
  import std/macros

proc fromRowPos[T: Model](obj: var T, row: Row, pos: var Natural, skip = false) =
  ##[ Convert ``ndb.sqlite.Row`` instance into `Model`_ instance, from a given position.

  This is a helper proc to convert to `Model`_ instances that have fields of the same type.
  ]##

  for fld, val in obj[].fieldPairs:
    if val.isModel:                                 ## If we're dealing with a ``Model`` field
      if val.model.isSome:                          ## and it's either a ``some Model`` or ``Model``
        var subMod = get val.model                  ## then we try to populate it with the next ``row`` values.

        if row[pos].kind == dvkNull:                ## If we have a ``NULL`` at this point, we return an empty ``Model``:
          when val is Option:                       ## ``val`` is guaranteed to be either ``Model`` or an ``Option[Model]`` at this point,
            when get(val) is Model:                 ## and the fact that we got a ``NULL`` tells us it's an ``Option[Model]``,
              val = none typeof(subMod)             ## so we return a ``none Model``.

          inc pos
          subMod.fromRowPos(row, pos, skip = true)  ## Then we skip all the ``row`` values that should've gone into this submodel.

        else:                                       ## If ``row[pos]`` is not a ``NULL``,
          inc pos                                   ##
          subMod.fromRowPos(row, pos)               ## we actually populate the submodel.

      else:                                         ## If the field is a ``none Model``,
        inc pos                                     ## don't bother trying to populate it at all.

    elif not skip:                                  ## If we're dealing with an "ordinary" field,
      val = row[pos].to(typeof(val))                ## just convert it.
      inc pos

    else:
      inc pos

proc fromRow*[T: Model](obj: var T, row: Row) =
  ##[ Populate `Model`_ instance from ``ndb.postgres.Row`` instance.

  Nested `Model`_ fields are populated from the same ``ndb.postgres.Row`` instance.
  ]##

  var pos: Natural = 0
  obj.fromRowPos(row, pos)

proc toRow*[T: Model](obj: T, force = false): Row =
  ##[ Convert `Model`_ instance into ``ndb.postgres.Row`` instance.

  If ``force`` is ``true``, fields with `ro <../../pragmas.html#ro.t>`_ pragma are not skipped.
  ]##

  for fld, val in obj[].fieldPairs:
    if force or not (obj.dot(fld).hasCustomPragma(ro) or obj.dot(fld).hasCustomPragma(readOnly)):
      result.add dbValue(val)

