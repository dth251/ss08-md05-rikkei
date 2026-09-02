# Sử dụng image Alpine Node.js lightweight
FROM node:18-alpine

WORKDIR /app

# Tạo ứng dụng payment-service đơn giản
RUN echo 'const http = require("http"); \
const server = http.createServer((req, res) => { \
  res.writeHead(200, { "Content-Type": "application/json" }); \
  res.end(JSON.stringify({ service: "payment-service", version: "1.0.0", status: "OK" })); \
}); \
server.listen(3000, () => console.log("Payment service running on port 3000"));' > server.js

EXPOSE 3000

CMD ["node", "server.js"]
