const Ride = require("../models/Ride");
const Bike = require("../models/Bike");
const User = require("../models/User");

//first payment
exports.startRide = async (req, res) => {
  try {
    const { bikeQr, endStationId, distance } = req.body;

    const user = await User.findById(req.user.id);
    if (user.activeRide)
      return res.status(400).json({ message: "User already has an active ride" });

    const bike = await Bike.findOne({ qrCode: bikeQr, isAvailable: true });
    if (!bike)
      return res.status(404).json({ message: "Bike not available" });

    // Calculate cost
    const RATE_PER_KM = 5; //Made this up
    const cost = distance * RATE_PER_KM;

    // OPTIONAL wallet check
    if (user.wallet < cost)
      return res.status(400).json({ message: "Insufficient balance" });

    // Deduct payment upfront
    user.wallet -= cost;

    const ride = await Ride.create({
      user: user._id,
      bike: bike._id,
      startStation: bike.station,
      endStation: endStationId,
      distance,
      cost,
      status: "active"
    });

    // Update states
    bike.isAvailable = false;
    user.activeRide = ride._id;

    await bike.save();
    await user.save();

    res.status(201).json({
      message: "Payment successful, bike unlocked 🚲",
      ride
    });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};
