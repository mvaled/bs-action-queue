module type ActionQueue = {
  let name: string

  type t
  type identifier
  type payload
  type action = unit => promise<payload>

  let make: (~createPromises: bool=?, ~workers: int=?, ~rejectCanceled: bool=?, unit) => t

  let busy: t => bool
  let length: t => int
  let running: t => int

  let append: (t, action, identifier) => option<promise<payload>>
  let prepend: (t, action, identifier) => option<promise<payload>>
  let replace: (t, action, identifier) => option<promise<payload>>
  let clear: t => unit
  let promise: t => promise<payload>

  let then: (t, (payload, identifier) => unit) => unit
  let catch: (t, (payload, identifier) => unit) => unit
  let finally: (t, (payload, identifier) => unit) => unit
  let oncancel: (t, identifier => unit) => unit
}

@doc("Creates a non-concurrent action queue.")
module MakeActionQueue = (
  T: {
    let name: string

    type identifier
    type payload
  },
): (ActionQueue with type identifier = T.identifier and type payload = T.payload) => {
  type t
  let name = T.name

  type identifier = T.identifier
  type payload = T.payload
  type action = unit => promise<payload>
  type options = {createPromises: bool, workers: int, rejectCanceled: bool}

  %%private(@module("@merchise/action-queue") @new external _new: options => t = "ActionQueue")
  let make = (~createPromises: bool=true, ~workers: int=1, ~rejectCanceled: bool=true, ()) =>
    _new({createPromises, workers, rejectCanceled})

  @send external busy: t => bool = "busy"
  @send external length: t => int = "length"
  @send external running: t => int = "running"

  @send external append: (t, action, identifier) => option<promise<payload>> = "append"
  @send external prepend: (t, action, identifier) => option<promise<payload>> = "prepend"
  @send external replace: (t, action, identifier) => option<promise<payload>> = "replace"
  @send external clear: t => unit = "clear"
  @send external promise: t => promise<payload> = "promise"

  @send external then: (t, (payload, identifier) => unit) => unit = "then"
  @send external catch: (t, (payload, identifier) => unit) => unit = "catch"
  @send external finally: (t, (payload, identifier) => unit) => unit = "finally"
  @send external oncancel: (t, identifier => unit) => unit = "oncancel"
}
