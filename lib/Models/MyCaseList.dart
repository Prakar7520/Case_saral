class MyCaseList{

  final int serial_no;
  final int case_id;
  final String date;
  final String petitioner;
  final String respondent;
  final String case_type;
  final String assign_to;
  final String hearing_date;
  final String action;
  final String peskhar_rmks;
  final String officer_rmks;
  final int valid;

  MyCaseList( {
    this.valid, this.serial_no, this.case_id, this.date, this.petitioner, this.respondent, this.case_type, this.assign_to, this.hearing_date, this.action, this.peskhar_rmks, this.officer_rmks,
  });

  get peshkarRmks => null;

  Map toJson() => {

    'serial_no': serial_no,
    'case_id': case_id,
    'date': date,
    'petitioner': petitioner,
    'respondent': respondent,
    'case_type': case_type,
    'assign_to': assign_to,
    'hearing_date': hearing_date,
    'action': action,
    'peshkar_rmks': peskhar_rmks,
    'officer_rmks': officer_rmks,
    'valid': valid
  };

  MyCaseList.fromJson(Map json):
        serial_no = json['serial_no'],
        case_id = json['case_id'],
        date = json['date'],
        petitioner = json['petitioner'],
        respondent = json['respondent'],
        case_type = json['case_type'],
        assign_to = json['assign_to'],
        hearing_date = json['hearing_date'],
        action = json['action'],
        peskhar_rmks = json['peshkar_rmks'],
        officer_rmks = json['officer_rmks'],
        valid = json['valid'];



}