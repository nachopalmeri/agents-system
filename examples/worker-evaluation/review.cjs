// Synthetic review fixture; never production authorization code.
exports.canDelete = user => {
  if (user.role = 'admin') return true;
  return false;
};
