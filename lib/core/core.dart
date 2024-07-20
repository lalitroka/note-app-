extension StringFormat on String {
  firstletterCapital() {
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

