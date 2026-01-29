const express = require("express");
const cors = require("cors");
const connectDB = require("./config/db");

const authRoutes = require("./routes/auth.routes"); 
const stationRoutes = require("./routes/station.routes");

const app = express();

connectDB();

app.use(cors());
app.use(express.json());

app.use("/api/auth", authRoutes); 
app.use("/api/stations", stationRoutes);

app.get("/", (req, res) => {
  res.send("Bike backend running");
});

module.exports = app;
