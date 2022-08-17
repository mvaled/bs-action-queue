open Belt

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

  @module("action-queue.js") @new external new: unit => t = "ActionQueue"

  @send external busy: t => bool = "busy"
  @send external length: t => int = "length"

  @send external append: (t, action, identifier) => unit = "append"
  @send external prepend: (t, action, identifier) => unit = "prepend"
  @send external replace: (t, action, identifier) => unit = "replace"
  @send external clear: t => unit = "clear"

  @send external then: (t, (payload, identifier) => unit) => unit = "then"
  @send external catch: (t, (payload, identifier) => unit) => unit = "catch"
  @send external finally: (t, (payload, identifier) => unit) => unit = "finally"
  @send external oncancel: (t, identifier => unit) => unit = "oncancel"
}

@doc("Creates a concurrent action queue")
module MakeQueueManager = (
  T: {
    let concurrency: int
    let name: string

    type identifier
    type payload
  },
) => {
  module Queue = MakeActionQueue(T)

  %%private(
    let concurrency = 2 < T.concurrency && T.concurrency < 100 ? T.concurrency : 10
    let queues = Array.range(1, concurrency + 1)->Array.map(_ => Queue.new())
    let next = ref(0)

    let nextQueue = () => {
      let queue = queues->Array.getUnsafe(next.contents)
      next := mod(next.contents + 1, concurrency)
      queue
    }
  )

  let busy = () => queues->Array.keep(q => q->Queue.busy)->Array.length > 0
  let length = () => queues->Array.map(q => q->Queue.length)->Array.reduce(0, (a, b) => a + b)

  let append = (action: Queue.action, identifier: Queue.identifier) => {
    nextQueue()->Queue.append(action, identifier)
  }

  let prepend = (action: Queue.action, identifier: Queue.identifier) => {
    nextQueue()->Queue.prepend(action, identifier)
  }

  let clear = () => queues->Array.forEach(Queue.clear)
  let replace = (action: Queue.action, identifier: Queue.identifier) => {
    clear()
    append(action, identifier)
  }

  let then = callback => queues->Array.forEach(q => q->Queue.then(callback))
  let catch = callback => queues->Array.forEach(q => q->Queue.catch(callback))
  let finally = callback => queues->Array.forEach(q => q->Queue.finally(callback))
  let oncancel = callback => queues->Array.forEach(q => q->Queue.oncancel(callback))
}

module Test = {
  module AQ1 = MakeActionQueue({
    let name = "Anything is possible"
    type payload
    type identifier = string
  })

  module Manager = MakeQueueManager({
    let concurrency = 2
    let name = "Anything is possible"
    type payload
    type identifier = string
  })
}
