import { Router } from 'express'

const router = Router()
type User = {
  name: string
  id: number
}
type Task = {
  taskId: string
  userId: number
}

const defaultState = {
  calledMeeting: false,
  started: false,
  imposterWon: false,
  crewmateWon: false,
  dead: [] as User[],
  tasks: [] as Task[],
  online: [] as User[],
  betrayers: [] as User[],
}
let state: typeof defaultState = JSON.parse(JSON.stringify(defaultState))

// path is /helloWorld/hello
router.get('/reset', (req, res) => {
  state = JSON.parse(JSON.stringify(defaultState))
  res.send({ success: true })
})

router.get('/callMeeting', (req, res) => {
  state.calledMeeting = true
  res.send({ success: true })
})
router.get('/kill', (req, res) => {
  // convert body to json
  console.log(req.body)
  state.dead.push(req.body)
  res.send({ success: true })
})
router.post('/task', (req, res) => {
  state.dead.push(req.body)
  if (state.tasks.length === (state.online.length - 1) * 2) {
    state.crewmateWon = true
  }
  if (state.dead.length === state.online.length - 2) {
    state.imposterWon = true
  }
  res.send({ success: true })
})
router.post('/join', (req, res) => {
  const name = req.body.name;
  // random 4 digit number
  const id = Math.floor(Math.random() * 100000)
  const user = {
    name,
    id: id,
  };
  state.online.push(user)
  console.log(user);
  res.send(user)
})
router.post('/start', (req, res) => {
  const onlineLength = state.online.length
  const randomIndex = Math.floor(Math.random() * onlineLength)
  const x = state.online[randomIndex]
  state.betrayers.push(x)
  state.started = true;
  res.send({ success: true })
})

router.get('/state', (req, res) => {
  res.send(state)
})

export default router
