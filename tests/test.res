open Prelude
open Ava

asyncTest("FIFO queue scenario without cancelation", t => {
  module Queue = ActionQueue.MakeActionQueue({
    let name = "Queue"
    type payload = int
    type identifier = unit
  })

  let queue = Queue.make(~rejectCanceled=false, ())

  let _ACTION_TIME = 50
  let _LENGTH = 10 // actions to queue
  let _TOTAL_TIME = _LENGTH * _ACTION_TIME

  let seen = []
  let action = (data, ()) => {
    seen->Js.Array2.push(data)->ignore

    let info = queue->Queue.info
    if info.pending->Array.length > _LENGTH - 2 {
      (info.pending->Array.getUnsafe(0)).cancel()
    }
    Js.Console.log2("Running action", data)
    Promises.ellapsed(_ACTION_TIME)->thenResolve(_ => data)
  }

  queue->Queue.pause
  Promises.make((~resolve, ~reject) => {
    for data in 1 to _LENGTH {
      queue->Queue.append(action(data), ())->ignore
    }

    reject->ignore
    queue->Queue.then(
      (data, _) => {
        t->Assert.isTrue(1 <= data && data <= _LENGTH, ())
        t->Assert.isTrue(data != 2, ()) // cancelled
        if data == _LENGTH {
          resolve()
        }
      },
    )
    queue->Queue.resume
  })
})
