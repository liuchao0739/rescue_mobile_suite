/// SOS event status values aligned with platform API.
enum SosStatus {
  created('CREATED'),
  confirmed('CONFIRMED'),
  dispatching('DISPATCHING'),
  onTheWay('ON_THE_WAY'),
  arrived('ARRIVED'),
  completed('COMPLETED'),
  cancelled('CANCELLED'),
  escalated('ESCALATED');

  const SosStatus(this.value);
  final String value;
}
