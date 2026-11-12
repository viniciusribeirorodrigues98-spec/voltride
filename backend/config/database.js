const mysql = require("mysql2/promise");

const isConfigured = Boolean(
  process.env.DB_HOST &&
  process.env.DB_NAME &&
  process.env.DB_USER &&
  process.env.DB_PASSWORD
);

const pool = isConfigured ? mysql.createPool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT || 3306),
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  waitForConnections: true,
  connectionLimit: Number(process.env.DB_CONNECTION_LIMIT || 10),
  queueLimit: 0,
  decimalNumbers: true
}) : {
  async query() {
    throw new Error("MySQL não configurado. Defina DB_HOST, DB_NAME, DB_USER e DB_PASSWORD.");
  },
  async execute() {
    throw new Error("MySQL não configurado. Defina DB_HOST, DB_NAME, DB_USER e DB_PASSWORD.");
  }
};

pool.isConfigured = isConfigured;

module.exports = pool;
