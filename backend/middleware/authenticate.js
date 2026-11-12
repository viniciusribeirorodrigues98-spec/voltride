function authenticate(_req, res, next) {
  const error = new Error("Autenticação ainda não configurada.");
  error.status = 501;
  next(error);
}

function requireRole(role) {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({ error: "Autenticação necessária." });
    }
    if (req.user.role !== role) {
      return res.status(403).json({ error: "Permissão insuficiente." });
    }
    next();
  };
}

module.exports = { authenticate, requireRole };
