// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css"
// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import socket from "./user_socket"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
// console.log(10);
// let btn = document.createElement("button");
// btn.innerHTML = "click me";
// document.body.appendChild(btn);
// var phoenix = require("phoenix");
// var socket1 = new phoenix.Socket("/socket", {})

function new_channel(player, screen_name) {
    return socket.channel("game:" + player, {screen_name: screen_name});
}

function join(channel) {
    channel.join()
        .receive("ok", response => {
            console.log("Joined successfully!", response)
        })
        .receive("error", response => {
            console.log("Unable to join", response)
        })
}

const btn = document.getElementById("myBtn");
btn.addEventListener('click', create_game, false);

function doClick() {
    console.log("Halo");
}

function new_game(channel) {
    channel.push("new_game")
        .receive("ok", response => {
            console.log("New Game!", response)
        })
        .receive("error", response => {
            console.log("Unable to start a new game.", response)
        })
}

function create_game() {
    game_channel = new_channel("adam", "adam");
    join(game_channel);
    new_game(game_channel);
}

function add_player(channel, player) {
    channel.push("add_player", player)
        .receive("error", response => {
            console.log("Unable to add new player: " + player, response)
        })
}

function position_ships(channel, player, ship, row, col) {
    var params = {"player": player, "ship": ship, "row": row, "col": col}
    channel.push("position_ship", params)
        .receive("ok", response => {
            console.log("Ship positioned!", response);
        })
        .receive("error", response => {
            console.log("Unable to position ship.", response);
        })
}

function set_ships(channel, player) {
    channel.push("set_ships", player)
        .receive("ok", response => {
            console.log("Here is the board:");
            console.dir(response.board);
        })
        .receive(":error", response => {
            console.log("Unable to set ships", response)
        })
}
/* <section class="boards">
  <script> */

  
//   </script>
// </section>