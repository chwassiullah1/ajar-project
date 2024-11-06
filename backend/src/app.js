import express from 'express';
import cors from 'cors'
import http from 'http'
import 'dotenv/config'
import { SERVER_PORT, SERVER_HOST } from './utils/constant.js';
import routes from "./routes/index.js"
import { deleteExpiredTokens } from '../db/triggers/trigger.js';
// import { Server } from 'socket.io';

const app = express()
const server = http.createServer(app)
// const io = new Server(server);

app.use(cors())
app.use(express.static("public"))
app.use(express.json());
app.use('/api',routes)


server.listen(SERVER_PORT,SERVER_HOST,() =>
{ 
    console.log(`Server is running on http://${SERVER_HOST}:${SERVER_PORT}`)
})

