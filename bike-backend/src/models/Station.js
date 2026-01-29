const mongoose = require("mongoose");

const dockSchema = new mongoose.Schema({
  qrCode: { type: String, required: true, unique: true },
  dockId: { type: String, required: true },
  bikeId: { type: String, default: null },
  isLocked: { type: Boolean, default: true }
});

const stationSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    lat: { type: Number, required: true },
    lng: { type: Number, required: true },
    capacity: { type: Number, required: true },
    docks: [dockSchema]
  },
  { timestamps: true }
);

module.exports = mongoose.model("Station", stationSchema);
