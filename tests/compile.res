module AQ1 = ActionQueue.MakeActionQueue({
  let name = "Anything is possible"
  type payload
  type identifier = string
})

@@warning("-32")
let queue = AQ1.make()
let queue = AQ1.make(~workers=1, ())
let queue = AQ1.make(~createPromises=false, ())
let queue = AQ1.make(~rejectCanceled=false, ())

queue->AQ1.promise->ignore
queue->AQ1.clear->ignore
