import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          "title": " Harkat",
          "app_salogon": "",
          "online_driver": "Online",
          "offline_driver": "Offline",
          "new_order": "New Order",
          "acceptbtn": "Accept",
          "rejectbtn": "Reject",
          "drawer_submit_money": "Submit Money",
          "continue_as_driver_btn": 'CONTINUE AS DRIVER',
          "make_delivery_btn": 'MAKE DELIVERY ORDER',
          "location_service_enable_btn": "Enable Service",
          "location_service_enable_lbl": "Enable Service",
          "location_service_permission_lbl": "Request Permission",
          "location_service_permission_btn": "Request Permission",
          "logout_lbl": "Logout",
          "language": "English",
          "startbtn": "Start",
          "pick_orderbtn": "Pick Up",
          "drop_orderbtn": "Drop Order",
          "contact_lbl": "Contact US",
          "orders_lbl": "Orders",
          "order_end_lbl": "Complete",
          "address_from": "From",
          "address_to": "To",
          "email_lbl": "Email",
          "email_placeholder": "Enter your email",
          "password_lbl": "Password",
          "password_placeholder": "Enter your password",
          "login_btn": "Continue",
          "login_page_heading": "Welcome Back",
          "login_page_description": "Sign in with email and password",
          "email_password_not_match": "Email or password not mached",
          "forget_password": "Foreget Password",
          "rest_password_btn": "Continue",
          "reset_password_page_heading": "Reset Password",
          "reset_password_description": "Use email address to reset password",
          "reset_email_sent": "Email for reset of password sent",
          "reset_email_not_found":
              "Email address not assoicated with any account",
          "changepassword_page_heading": "Change Password",
          "changepassword_page_description":
              "Change password by entering new and older password",
          "old_password_lbl": "Old password",
          "old_password_placeholder": "Please enter old password",
          "new_password_lbl": "New Password",
          "new_password_placeholder": "Please enter new password",
          "changepassword_btn": "Change Password",
          "change_password_lbl": "Change Password",
          "suggestion_page_heading": "Suggestion/Complaint",
          "suggestion_page_description":
              "You can give suggestions or complaint about system",
          "suggestion_type_lbl": "Select Type",
          "suggestion_suggestion": "Suggesstion",
          "suggestion_complaint": "Complaint",
          "suggestion_drawer": "Suggestion/Complaint",
          "suggestion_lbl": "Description",
          "suggestion_description_lbl": "Description",
          "suggestion_description_placeholder": "Please enter description",
          "suggestion_btn": "Submit",
          "earning_current_balance": "Current Balance",
          "earning_withdraw": "Withdraw",
          "signup_page_heading": "Signup",
          "signup_page_description":
              "Signup as customer using email and password",
          "signup_name_field": "Name",
          "signup_name_field_placeholder": "Please enter name",
          "signup_retype_password_lbl": "Retype Password",
          "signup_retype_password_placeholder": "Please re-type your password",
          "signup_contact_field": "Contact",
          "signup_contact_place_holder": "Please enter contact",
          "signup_address_field": "Address",
          "signup_address_placeholder": "Please enter address",
          "signup_btn": "Continue",
          "signup_already_account": "Already have account?",
          "signup_emirate_field": "Emirate ID",
          "signup_emirate_field_placeholder": "Please enter emirate id",
          "signup_emirate_field_empty": "Please enter emirate id",
          "submit_money_screen_appbar": "Submit Money",
          "submit_money_screen_amount_field_label": "Amount",
          "submit_money_screen_date_field_label": "Date Time",
          "submit_money_screen_submit_btn": "Submit",
          "submit_money_screen_submit_success": "Cash Submitted Successfully",
        },
        'ar_AE': {
          "title": " حرکت",
          "app_salogon": "",
          "online_driver": "متصل",
          "offline_driver": "غير متصل",
          "new_order": "طلب جديد",
          "acceptbtn": "قبول",
          "rejectbtn": "رفض",
          "contact_lbl": "رقم حركات",
          "drawer_submit_money": "إرسال الأموال",
          "continue_as_driver_btn": 'استمر كسائق',
          "make_delivery_btn": 'تقديم طلب التسليم',
          "location_service_enable_lbl": "خدمة الموقع معطلة",
          "location_service_enable_btn": "تمكين الخدمة",
          "location_service_permission_lbl": "تم تعطيل إذن الموقع",
          "location_service_permission_btn": "طلب إذن",
          "logout_lbl": "تسجيل خروج",
          "language": "عربی",
          "startbtn": "بداية",
          "pick_orderbtn": "امسك",
          "drop_orderbtn": "طلب الإسقاط",
          "orders_lbl": "الطلب",
          "order_end_lbl": "النهاية",
          "address_from": "من العنوان",
          "address_to": "إلى عنوان",
          "email_lbl": "البريد الإلكتروني",
          "email_placeholder": "أدخل بريدك الإلكتروني",
          "password_lbl": "كلمه السر",
          "password_placeholder": "ادخل رقمك السري",
          "login_btn": "استمر",
          "login_page_heading": "مرحبا بعودتك",
          "login_page_description":
              "تسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور",
          "email_password_not_match":
              "البريد الإلكتروني أو كلمة المرور غير متطابقتين",
          "forget_password": "نسيت كلمة المرور",
          "rest_password_btn": "استمر",
          "reset_password_page_heading": "إعادة تعيين كلمة المرور",
          "reset_password_description":
              "استخدم عنوان البريد الإلكتروني لإعادة تعيين كلمة المرور",
          "reset_email_sent": "تم إرسال بريد إلكتروني لإعادة تعيين كلمة المرور",
          "reset_email_not_found": "عنوان البريد الإلكتروني غير مرتبط بأي حساب",
          "changepassword_page_heading": "تغيير كلمة المرور",
          "changepassword_page_description":
              "قم بتغيير كلمة المرور عن طريق إدخال كلمة مرور جديدة وأقدم",
          "old_password_lbl": "كلمة المرور القديمة",
          "old_password_placeholder": "الرجاء إدخال كلمة المرور القديمة",
          "new_password_lbl": "كلمة مرور جديدة",
          "new_password_placeholder": "الرجاء إدخال كلمة المرور الجديدة",
          "changepassword_btn": "تغيير كلمة المرور",
          "change_password_lbl": "تغيير كلمة المرور",
          "suggestion_drawer": "اقتراح/شكوى",
          "suggestion_lbl": "اقتراح",
          "suggestion_page_heading": "اقتراح/شكوى",
          "suggestion_page_description":
              "يمكنك تقديم اقتراحات أو شكوى حول النظام",
          "suggestion_type_lbl": "اختر صنف",
          "suggestion_suggestion": "اقتراح",
          "suggestion_complaint": "شكوى",
          "suggestion_description_lbl": "وصف",
          "suggestion_description_placeholder": "الرجاء إدخال الوصف",
          "suggestion_btn": "إرسال",
          "earning_current_balance": "الرصيد الحالي",
          "earning_withdraw": "انسحب",
          "signup_page_heading": "سجل",
          "signup_page_description":
              "سجل كعميل باستخدام البريد الإلكتروني وكلمة المرور",
          "signup_name_field": "اسم",
          "signup_name_field_placeholder": "الرجاء إدخال الاسم",
          "signup_retype_password_lbl": "أعد إدخال كلمة السر",
          "signup_retype_password_placeholder":
              "الرجاء إعادة كتابة كلمة المرور الخاصة بك",
          "signup_contact_field": "اتصل",
          "signup_contact_place_holder": "الرجاء إدخال جهة الاتصال",
          "signup_address_field": "عنوان",
          "signup_address_placeholder": "الرجاء إدخال العنوان",
          "signup_btn": "استمر",
          "signup_already_account": "لديك حساب بالفعل؟",
          "signup_emirate_field": "هوية الإمارة",
          "signup_emirate_field_placeholder": "الرجاء إدخال معرف الإمارة",
          "signup_emirate_field_empty": "الرجاء إدخال معرف الإمارة",
          "submit_money_screen_appbar": "إرسال الأموال",
          "submit_money_screen_amount_field_label": "كمية",
          "submit_money_screen_date_field_label": "تاريخ الوقت",
          "submit_money_screen_submit_btn": "إرسال",
          "submit_money_screen_submit_success": "تم إرسال النقد بنجاح",
        }
      };
}
