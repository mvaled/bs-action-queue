type t  // The opaque internal state of the ActionQueue object
type action<'a> = () => Js.Promise.t<'a>
type callback<'a> = 'a => unit


@new @module("action-queue") external create: unit => t = "ActionQueue"

@send external promise: t => Js.Promise.t<'a> = "promise"

@send external then: (t, callback<'a>) => unit = "then"
@send external catch: (t, callback<'a>) => unit = "catch"
@send external finally: (t, callback<'a>) => unit = "finally"
@send external oncancel: (t, callback<'a>) => unit = "oncancel"

@send external prepend: (t, action<'a>) => unit = "prepend"
@send external append: (t, action<'a>) => unit = "append"
@send external replace: (t, action<'a>) => unit = "replace"
@send external clear: t => unit = "clear"
