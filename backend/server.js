require("dotenv").config();

const path = require("node:path");
const express = require("express");
const scooterRoutes = require("./routes/scooter.routes");
const healthRoutes = require("./routes/health.routes");
const authRoutes = require("./routes/auth.routes");
const { notFoundHandler, errorHandler } = require("./middleware/error-handler");

const app = express();
const frontendPath = path.resolve(__dirname, "../frontend");
app.disable("x-powered-by");
app.use(express.json({ limit: "100kb" }));
app.use(express.static(frontendPath));
app.use("/api/health", healthRoutes);
app.use("/api/scooters", scooterRoutes);
app.use("/api/auth", authRoutes);
app.use("/api", notFoundHandler);
app.use(errorHandler);

const port = Number(process.env.PORT || 3000);
app.listen(port, () => {
  console.log(`VoltRide disponível em http://localhost:${port}`);
});
