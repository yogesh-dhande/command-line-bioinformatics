<template>
<div>
  <NavBar/> 
  <div id="terminal"></div>
</div>
</template>

<script>
import "xterm/css/xterm.css"
import { Terminal } from "xterm"
import { FitAddon } from "xterm-addon-fit"
import { AttachAddon } from 'xterm-addon-attach'
import axios from 'axios'
import NavBar from "./NavBar.vue"

export default {
  name: 'Terminal',
  components: {
    NavBar
  },
  data() {
    return {
      term: null,
      failures: 0,
      pid: null,
      socket: null
    };
  },

  mounted() {
    console.log("entered");

    this.term = new Terminal({
      rows: 40,
      experimentalCharAtlas: "dynamic"
    });

    const fitAddon = new FitAddon();

    this.term.loadAddon(fitAddon);

    this.term.open(document.getElementById("terminal"));

    fitAddon.fit();
    
    const HOST = `localhost:${ 3000 }`;
    axios.post(`http://${ HOST }/terminals/?cols=${ this.term.cols }&rows=${ this.term.rows }`)
    .then(
      res => {
        console.log(res)
        this.pid = res.data;
        const SOCKET_URL = `ws://${ HOST }/terminals/${this.pid}`;
        console.log(SOCKET_URL)
        this.socket = new WebSocket(SOCKET_URL);
        this.socket.onopen = () => {
          const attachAddon = new AttachAddon(this.socket);
          this.term.loadAddon(attachAddon);
        };
        this.socket.onclose = () => {
          this.term.writeln('Server disconnected!');
        };
        this.socket.onerror = () => {
          this.term.writeln('Server disconnected!');
        };
      })
  }

}
</script>

<style>
</style>
