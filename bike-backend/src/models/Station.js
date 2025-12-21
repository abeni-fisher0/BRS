const mongoose = require("mongoose");

const stationSchema = new mongoose.Schema({
  name: { type: String, required: true },
  lat: { type: Number, required: true },
  lng: { type: Number, required: true },
  capacity: { type: Number, required: true }
}, { timestamps: true });

module.exports = mongoose.model("Station", stationSchema);
