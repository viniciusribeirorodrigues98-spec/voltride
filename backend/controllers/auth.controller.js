function notImplemented(_req, res) {
  res.status(501).json({ error: "Autenticação ainda não implementada." });
}

module.exports = {
  register: notImplemented,
  login: notImplemented,
  logout: notImplemented,
  currentUser: notImplemented
};
