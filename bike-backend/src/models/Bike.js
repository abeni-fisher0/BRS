const mongoose = require("mongoose");

const bikeSchema = new mongoose.Schema({
  
  isAvailable: { type: Boolean, default: true },
  station: { type: mongoose.Schema.Types.ObjectId, ref: "Station", required: true }
}, { timestamps: true });

module.exports = mongoose.model("Bike", bikeSchema);
