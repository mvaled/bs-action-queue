@doc("Creates a non-concurrent action queue.")
module MakeActionQueue = (
  T: {
    let name: string

    type identifier
    type payload
  },
) => {
  type t
  let name = T.name

  type identifier = T.identifier
  type payload = T.payload
  type action = unit => Js.Promise.t<payload>
  type options = {createPromises: bool, workers: int, rejectCanceled: bool}

  %%private(@module("@merchise/action-queue") @new external _new: options => t = "ActionQueue")
  let make = (~createPromises: bool=true, ~workers: int=1, ~rejectCanceled: bool=true, ()) =>
    _new({createPromises, workers, rejectCanceled})

  @send external busy: t => bool = "busy"
  @send external length: t => int = "length"
  @send external running: t => int = "running"

  @send external append: (t, action, identifier) => option<Js.Promise.t<payload>> = "append"
  @send external prepend: (t, action, identifier) => option<Js.Promise.t<payload>> = "prepend"
  @send external replace: (t, action, identifier) => option<Js.Promise.t<payload>> = "replace"
  @send external clear: t => unit = "clear"

  @send external then: (t, (payload, identifier) => unit) => unit = "then"
  @send external catch: (t, (payload, identifier) => unit) => unit = "catch"
  @send external finally: (t, (payload, identifier) => unit) => unit = "finally"
  @send external oncancel: (t, identifier => unit) => unit = "oncancel"
}
