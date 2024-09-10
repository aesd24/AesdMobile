
class TimeAgo {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime notificationDate = DateTime.parse(dateString);

    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? 'Il y\'à une semaine' : 'Semaine passé';
    } else if (difference.inDays >= 2) {
      return 'Il y à ${difference.inDays} jours';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? 'Il y à un jour' : 'Hier';
    } else if (difference.inHours >= 2) {
      return 'Il y à ${difference.inHours} heures';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? 'Il y à une heure' : 'Il y à une heure';
    } else if (difference.inMinutes >= 2) {
      return 'Il y à ${difference.inMinutes} minutes';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? 'Il y à une minute' : 'Il y à une minute';
    } else if (difference.inSeconds >= 3) {
      return 'Il y à ${difference.inSeconds} secondes';
    } else {
      return 'Maintenant';
    }
  }
}
