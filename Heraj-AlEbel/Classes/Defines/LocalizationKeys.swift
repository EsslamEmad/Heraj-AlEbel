//
//  LocalizationKeys.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 4/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import Foundation

struct Localization {
    
    //MARK: - Error Messages -
    struct Error {
        static var GeneralError: String { return "خطأ" }
    }
    
    //MARK: - General -
    struct General {
        static var AppName: String { return "حراج الإبل" }
        static var OkActionTitle: String { return "حسنا" }
        static var YesActionTitle: String { return "نعم" }
        static var NoActionTitle: String { return "لا" }
        static var SRTitle: String { return "ريال" }
        static var doneTitle: String {return "تم"}
        static var cancelTitle: String { return "إلغاء"}
        static var editTitle: String { return "تعديل"}
        static var deleteTitle: String { return "حذف"}
    }
    
    //MARK: - Login -
    struct Login {
        
        static var PasswordPlaceholder: String { return "كلمة المرور".localized() }
        static var LoginButtonTitle: String { return "تسجيل الدخول".localized() }
        static var ForgotPasswordButtonTitle: String { return "إضغط هنا".localized() }
        static var ForgotPasswordLabelTitle: String { return "نسيت كلمة المرور؟".localized() }
        static var RegisterButtonTitle: String { return "حساب جديد".localized() }
        static var InvalidCredentialsMessage: String { return "من فضلك أدخل البيانات بشكل صحيح".localized() }
        static var enterYourEmailTitle: String { return "أدخل اسم المستخدم او رقم الجوال".localized()}
        static var emailTitle: String{ return "اسم المستخدم او رقم الجوال".localized()}
    }
    
    //MARK: - Registeration -
    struct Registeration {
        static var NamePlaceholder: String { return "الإسم".localized() }
        
        static var PhonePlaceholder: String { return "رقم الجوال".localized() }
        static var EmailPlaceholder: String { return "البريد الإلكتروني".localized() }
        static var PasswordPlaceholder: String { return "كلمة المرور".localized() }
        static var RepeatedPasswordPlaceholder: String { return "تأكيد كلمة المرور".localized() }
        static var RegisterButtonTitle: String { return "تسجيل حساب جديد".localized() }
        static var EditProfileButtonTitle: String { return "تعديل".localized() }
        static var ClickHereLabelTitle: String { return "إضغط هنا".localized() }
        static var UploadPhotoLabelTitle: String { return "لإضافة صورة شخصية جديدة".localized() }
        static var UploadAnotherPhotoLabelTitle: String { return "لإضافة صورة شخصية أخرى".localized() }
        static var FillAllFieldsMessage: String { return "من فضلك أدخل جميع البيانات.".localized() }
        static var PasswordsDontMatchMessage: String { return "كلمة المرور غير متطابقة.".localized() }
        static var ChoosePhotoMessage: String { return "اختر الصورة الشخصية.".localized() }
    }
    
   
    
    //MARK: - SideMenu
    struct SideMenu {
        static var ProfileLabelText: String { return "SideMenuProfileLabelText".localized() }
        static var OrdersLabelText: String { return "SideMenuOrdersLabelText".localized() }
        static var FavoritesLabelText: String { return "SideMenuFavoritesLabelText".localized() }
        static var NotificationsLabelText: String { return "SideMenuNotificationsLabelText".localized() }
        static var AboutUsLabelText: String { return "SideMenuAboutUsLabelText".localized() }
        static var ContactUsLabelText: String { return "SideMenuContactUsLabelText".localized() }
        static var ChangeLanguageLabelText: String { return "SideMenuChangeLanguageLabelText".localized() }
        static var PrefrencesLabelText: String { return "SideMenuPrefrencesLabelText".localized() }
        static var LogoutLabelText: String { return "SideMenuLogoutLabelText".localized() }
        static var SignInButtonTitle: String { return "SideMenuSignInButtonTitle".localized() }
        static var RechargeWalletLabelTitle: String { return "SideMenuRechargeWalletLabelTitle".localized() }
    }
    
    //MARK: - Contact Us -
    struct ContactUs {
        static var ScreenTitle: String { return "ContactUsScreenTitle".localized() }
        static var SubjectPlaceholder: String { return "ContactUsSubjectPlaceholder".localized() }
        static var MessageText: String { return "ContactUsMessageText".localized() }
        static var SendButtonTitle: String { return "ContactUsSendButtonTitle".localized() }
        static var FillAllFieldsMessage: String { return "ContactUsFillAllFieldsMessage".localized() }
    }
    
    //MARK: - Home -
    struct Home {
        static var ScreenTitle: String { return "HomeScreenTitle".localized() }
    }
    
    //MARK: - Ads
    struct Ads {
        static var ScreenTitle: String {return "الإعلانات"}
        static var watchAllButtonTitle: String { return "شاهد الكل"}
    }
    
    //MARK:- Categories
    struct Categories{
        static var ScreenTitle: String { return "الأقسام"}
        static var general: String{ return "عام"}
        static var latestProducts: String{ return "آخر الإعلانات المضافة"}
        static var mazayen: String{ return "المزاين"}
        static var hagn: String{ return "الهجن"}
        static var zabh: String{ return "الذبح"}
        static var others: String{ return "أخرى"}

    }
    
    // MARK: - Notifications -
    struct Notifications {
        static var ScreenTitle: String { return "NotificationsScreenTitle".localized() }
    }
    
    // MARK: - Favorites -
    struct Favorites {
        static var ScreenTitle: String { return "FavoritesScreenTitle".localized() }
    }
    
    
    // MARK: - Chat -
    struct Chat {
        static var InputTextViewPlaceholder: String { return "ChatInputTextViewPlaceholder".localized() }
    }
    
    
    
    // MARK: - Profile -
    struct Profile {
        static var WalletBalanceLabel: String { return "ProfileWalletLabelTitle".localized() }
        static var TotalPaidReceiptsLabel: String { return "ProfileTotalPaidReceiptsLabelTitle".localized() }
        static var NumberOfOrdersLable: String { return "ProfileNumberOfOrdersLabelTitle".localized() }
        static var EditProfileLabel: String { return "ProfileEditProfileLabelTitle".localized() }
        static var MyAddressesLabel: String { return "ProfileMyAddressesLabelTitle".localized() }
        static var DeleteLabel: String { return "ProfileDeleteLabelTitle".localized() }
    }
    
   

}
