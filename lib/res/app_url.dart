class AppUrl{
  static const port = '3004';

  static const hostedip = '52.66.145.37';

  static const abiip = '192.168.1.10';

  static var baseUrl = 'http://${hostedip}:${port}';

  static var login = '$baseUrl/rep/login';

  static var getLeaveRequest = '${baseUrl}/manager/getLeaveRequest';

  static var getdoctors = '${baseUrl}/rep/getDr';

  static var add_doctor_rep = '${baseUrl}/rep/add_dr';

  static var delete_doctor = '${baseUrl}/rep/delete_doctor';

  static var manager_registration = '$baseUrl/manager/managerRegister';

  static var get_employee = '$baseUrl/manager/get_Replist';

  static var accept_leave = '$baseUrl/manager/acceptLeave';

  static var get_leaves = '$baseUrl/rep/leaveHistory';

  static var apply_leave = '${baseUrl}/manager/leaveRequest';

  static var add_employee = '${baseUrl}/rep/repRegistration';

  static var single_doctor_details = '$baseUrl/rep/doctorDetail';

  static var single_employee_details = '$baseUrl/rep/singleDetails';

  static var get_expense_request_rep = '$baseUrl/rep/repExpense_list';

  static var get_expense_requests_manager = '$baseUrl/manager/list_expenseRequest';

  static var searchdoctors = '$baseUrl/rep/filter_dr';

  static var totaldoctorscount = '$baseUrl/rep/totalDr';

  static var totalrepcount = '$baseUrl/rep/totalRep';



}