const pool = require("../config/database");

async function findAll({ search = "", minPrice, maxPrice } = {}) {
  const conditions = ["is_active = 1"];
  const values = [];

  if (search) {
    conditions.push("(name LIKE ? OR description LIKE ? OR brand LIKE ?)");
    const term = `%${search}%`;
    values.push(term, term, term);
  }
  if (minPrice !== undefined) {
    conditions.push("price >= ?");
    values.push(minPrice);
  }
  if (maxPrice !== undefined) {
    conditions.push("price <= ?");
    values.push(maxPrice);
  }

  const [rows] = await pool.execute(
    `SELECT id, name, slug, brand, description, image_url, price, motor_watts, range_km, weight_kg
     FROM scooters WHERE ${conditions.join(" AND ")} ORDER BY id ASC`,
    values
  );
  return rows;
}

module.exports = { findAll };
