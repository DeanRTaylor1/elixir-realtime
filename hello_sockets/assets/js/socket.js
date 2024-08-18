import { Socket } from "phoenix"

// Create a new Socket instance
const socket = new Socket("/socket")

// Connect to the socket
socket.connect()

// Now that you are connected, you can join channels with a topic.
const channel = socket.channel("ping")
channel.join()
  .receive("ok", resp => { console.log("Joined successfully ping channel", resp) })
  .receive("error", resp => { console.log("Unable to join ping", resp) })

function sendPing() {
  console.log("Sending ping");
  channel.push("ping")
    .receive("ok", (resp) => console.log("Ping reply:", resp.ping))
    .receive("timeout", (resp) => console.error("pong message timeout", resp));
}

channel.push("param_ping", { error: true })
  .receive("error", (resp) => console.error("paaram_ping error:", resp))

channel.push("param_ping", { error: false, arr: [1, 2] })
  .receive("ok", resp => console.log("param_ping ok:", resp))

channel.on("send_ping", (payload) => {
  console.log("ping requested", { payload })
  channel.push("ping")
    .receive("ok", (resp) => console.log("ping:", resp.ping))
})

// Send a ping immediately
sendPing();

// Then send a ping every 1500 ms (1.5 seconds)
// const pingInterval = setInterval(sendPing, 1500);

const authSocket = new Socket("/auth_socket", {
  params: { token: window.authToken }
})

authSocket.onOpen(() => console.log("authSocket connected"))
authSocket.connect()

const recurringChannel = authSocket.channel("recurring")

recurringChannel.on("new_token", (payload) => {
  console.log("new token", { payload })
})

recurringChannel.join()

const dupeChannel = socket.channel("dupe")

dupeChannel.on("number", (payload) => {
  console.log("new number received", { payload })
})

dupeChannel.join()

const authUserChannel = authSocket.channel(`user:${window.userId}`)
authUserChannel.on("push", (payload) => {
  console.log("push received", payload)
})

authUserChannel.on("push_timed", (payload) => {
  console.log("push_timed received", payload)
})

export default socket
