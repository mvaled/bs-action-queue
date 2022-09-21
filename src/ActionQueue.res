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
  type options = {createPromises: bool}

  %%private(@module("action-queue") @new external _new: options => t = "ActionQueue")
  let make = (~createPromises: bool, ()) => _new({createPromises: createPromises})

  @send external busy: t => bool = "busy"
  @send external length: t => int = "length"

  @send external append: (t, action, identifier) => option<Js.Promise.t<payload>> = "append"
  @send external prepend: (t, action, identifier) => option<Js.Promise.t<payload>> = "prepend"
  @send external replace: (t, action, identifier) => option<Js.Promise.t<payload>> = "replace"
  @send external clear: t => unit = "clear"

  @send external then: (t, (payload, identifier) => unit) => unit = "then"
  @send external catch: (t, (payload, identifier) => unit) => unit = "catch"
  @send external finally: (t, (payload, identifier) => unit) => unit = "finally"
  @send external oncancel: (t, identifier => unit) => unit = "oncancel"
}

module Test = {
  module AQ1 = MakeActionQueue({
    let name = "Anything is possible"
    type payload
    type identifier = string
  })
}
