import http from "http";

const PORT = 1337;
const server = http.createServer(function (req, res) {
  res.setHeader("Content-Type", "application/json; charset=utf-8");
  res.end(JSON.stringify({ message: "Hello World" }));
});

server.listen(PORT, () =>
  console.log(`Node.js web server at port ${PORT} is running..`)
);
