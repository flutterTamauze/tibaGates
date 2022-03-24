abstract class PublicHolidaysRepo{
  Future<dynamic> getPublicHolidays();
  Future<dynamic> updatePublicHolidays(int id, String startDate, String endDate, String description);
  Future<dynamic> addPublicHolidays(String startDate, String endDate, String description);
  Future<dynamic> deleteHoliday(int holidayId);

}