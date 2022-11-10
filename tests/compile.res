module AQ1 = ActionQueue.MakeActionQueue({
  let name = "Anything is possible"
  type payload
  type identifier = string
})
let queue = AQ1.make()
let queue = AQ1.make(~workers=1, ())
let queue = AQ1.make(~createPromises=false, ())
let queue = AQ1.make(~rejectCanceled=false, ())
