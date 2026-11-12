const express = require("express");
const { listScooters } = require("../controllers/scooter.controller");

const router = express.Router();
router.get("/", listScooters);

module.exports = router;
