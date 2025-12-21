const mongoose = require("mongoose");

const rideSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  bike: { type: mongoose.Schema.Types.ObjectId, ref: "Bike", required: true },
  startStation: { type: mongoose.Schema.Types.ObjectId, ref: "Station", required: true },
  endStation: { type: mongoose.Schema.Types.ObjectId, ref: "Station", default: null },
  startTime: { type: Date, default: Date.now },
  endTime: { type: Date, default: null },
  distance: { type: Number, default: 0 }, // predicted or calculated
  cost: { type: Number, required: true }, // calculated upfront
  status: { type: String, enum: ["pending", "active", "completed"], default: "pending" }
}, { timestamps: true });

module.exports = mongoose.model("Ride", rideSchema);
