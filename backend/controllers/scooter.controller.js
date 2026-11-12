const scooterModel = require("../models/scooter.model");

async function listScooters(req, res, next) {
  try {
    const { search = "", minPrice, maxPrice } = req.query;
    const parsedMin = minPrice === undefined ? undefined : Number(minPrice);
    const parsedMax = maxPrice === undefined ? undefined : Number(maxPrice);

    if (search.length > 100) {
      return res.status(400).json({ error: "A pesquisa não pode exceder 100 caracteres." });
    }
    if ((parsedMin !== undefined && (!Number.isFinite(parsedMin) || parsedMin < 0)) ||
        (parsedMax !== undefined && (!Number.isFinite(parsedMax) || parsedMax < 0))) {
      return res.status(400).json({ error: "Os limites de preço devem ser números não negativos." });
    }

    try {
      const data = await scooterModel.findAll({ search, minPrice: parsedMin, maxPrice: parsedMax });
      return res.json({ data });
    } catch (dbError) {
      if (String(dbError.message).includes("MySQL não configurado")) {
        return res.json({ data: [] });
      }
      throw dbError;
    }
  } catch (error) {
    next(error);
  }
}

module.exports = { listScooters };
