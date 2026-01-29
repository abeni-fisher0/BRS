const express = require("express");
const router = express.Router();
const {
  getStations,
  seedStations,
  unlockDock
} = require("../controllers/stationController");

router.get("/", getStations);
router.post("/seed", seedStations);
router.post("/unlock-dock", unlockDock);

module.exports = router;
