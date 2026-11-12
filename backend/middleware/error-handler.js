function notFoundHandler(_req, res) {
  res.status(404).json({ error: "Recurso não encontrado." });
}

function errorHandler(error, _req, res, _next) {
  console.error(error);
  const status = Number.isInteger(error.status) && error.status >= 400 && error.status < 600 ? error.status : 500;
  res.status(status).json({
    error: status === 500 ? "Ocorreu um erro interno." : error.message
  });
}

module.exports = { notFoundHandler, errorHandler };
