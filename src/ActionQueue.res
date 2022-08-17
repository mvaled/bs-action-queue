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

  @module("action-queue.js") @new external new: unit => t = "ActionQueue"

  @send external busy: t => bool = "busy"
  @send external length: t => int = "length"

  @send external append: (t, action, identifier) => unit = "append"
  @send external prepend: (t, action, identifier) => unit = "prepend"
  @send external replace: (t, action, identifier) => unit = "replace"
  @send external clear: t => unit = "clear"

  @send external then: ((payload, identifier) => unit) => unit = "then"
  @send external catch: ((payload, identifier) => unit) => unit = "catch"
  @send external finally: ((payload, identifier) => unit) => unit = "finally"
  @send external oncancel: (identifier => unit) => unit = "oncancel"
}

module Test = {
  module AQ1 = MakeActionQueue({
    let name = "Anything is possible"
    type payload
    type identifier = string
  })
}
