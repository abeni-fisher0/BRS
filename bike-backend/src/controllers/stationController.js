// controllers/stationController.js
const Station = require("../models/Station");
const Ride = require("../models/Ride");

/**
 * GET /api/stations
 * ?search=piassa
 */
exports.getStations = async (req, res) => {
  try {
    const { search } = req.query;

    let query = {};
    if (search) {
      query.name = { $regex: search, $options: "i" };
    }

    const stations = await Station.find(query);
    res.json(stations);
  } catch (err) {
    res.status(500).json({ message: "Failed to fetch stations" });
  }
};

/**
 * POST /api/stations/seed
 */
exports.seedStations = async (req, res) => {
  await Station.deleteMany();

  const stations = [
    {
      name: "Piassa",
      lat: 9.0342,
      lng: 38.7469,
      capacity: 5,
      docks: [
        { dockId: "PIA-1", bikeId: "BIKE-101", isLocked: true },
        { dockId: "PIA-2", bikeId: "BIKE-102", isLocked: true },
        { dockId: "PIA-3", bikeId: null, isLocked: true }
      ]
    },
    {
      name: "4 Kilo",
      lat: 9.0381,
      lng: 38.7612,
      capacity: 4,
      docks: [
        { dockId: "FK-1", bikeId: "BIKE-201", isLocked: true },
        { dockId: "FK-2", bikeId: null, isLocked: true }
      ]
    },
    {
      name: "Mexico Square",
      lat: 9.0126,
      lng: 38.7495,
      capacity: 6,
      docks: [
        { dockId: "MX-1", bikeId: "BIKE-301", isLocked: true },
        { dockId: "MX-2", bikeId: "BIKE-302", isLocked: true },
        { dockId: "MX-3", bikeId: null, isLocked: true }
      ]
    }
  ];

  await Station.insertMany(stations);
  res.json({ message: "Stations seeded successfully" });
};

/**
 * POST /api/stations/unlock-dock
 */
exports.unlockDock = async (req, res) => {
  try {
    const { dockId, userId } = req.body;

    if (!dockId || !userId) {
      return res.status(400).json({ message: "dockId and userId required" });
    }

    const station = await Station.findOne({
      "docks.dockId": dockId
    });

    if (!station) {
      return res.status(404).json({ message: "Dock not found" });
    }

    const dock = station.docks.find(d => d.dockId === dockId);

    if (!dock.bikeId) {
      return res.status(400).json({ message: "No bike in this dock" });
    }

    if (!dock.isLocked) {
      return res.status(400).json({ message: "Dock already unlocked" });
    }

    const ride = await Ride.create({
      user: userId,
      bike: dock.bikeId,
      startStation: station._id,
      cost: 20
    });

    dock.isLocked = false;
    await station.save();

    res.json({
      message: "Bike unlocked",
      rideId: ride._id,
      bikeId: dock.bikeId
    });
  } catch (err) {
    res.status(500).json({ message: "Failed to unlock dock" });
  }
};
