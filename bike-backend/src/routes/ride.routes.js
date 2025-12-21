const router = require("express").Router();
const auth = require("../middleware/auth.middleware");
const { startRide, endRide } = require("../controllers/ride.controller");

router.post("/start", auth, startRide);

router.post("/end", auth, endRide);

module.exports = router;
