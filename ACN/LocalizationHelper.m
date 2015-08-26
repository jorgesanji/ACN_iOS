//
//  LocalizationHelper.m
//  ACN
//
//  Created by Flamingo Partners on 4/1/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "LocalizationHelper.h"
#import "Localizations_cat.h"
#import "Localizations_en.h"
#import "Utils.h"

@implementation LocalizationHelper

+(NSString *)getPullTextName{
    return [Utils isACN] ?pull_text_cat :pull_text_en;
}

+(NSString *)getReleaseTextName{
    return [Utils isACN] ?release_text_cat :release_text_en;
}

+(NSString *)getLoadingTextName{
    return [Utils isACN] ?loading_text_cat :loading_text_en;
}

+(NSString *)getHomeName{
    return [Utils isACN] ?home_title_cat :home_title_en;
}

+(NSString *)getSearchName{
    return [Utils isACN] ? search_name_category_cat :search_name_category_en;
}

+(NSString *)getLoginName{
    return [Utils isACN] ?login_name_category_cat :login_name_category_en;
}

+(NSString *)getFavouriteName{
    return [Utils isACN] ?favourites_name_category_cat :favourites_name_category_en;
}

+(NSString *)getAboutName{
    return [Utils isACN] ?about_name_category_cat :about_name_category_en;
}

+(NSString *)getPlaceholderName{
    return [Utils isACN] ?placeholder_loging_cat :placeholder_loging_en;
}

+(NSString *)getLoginButtonName{
    return [Utils isACN] ?login_text_button_cat :login_text_button_en;
}

+(NSString *)getNoFavouriteName{
    return [Utils isACN] ?no_starred_cat :no_starred_en;
}

+(NSString *)getPhoneError{
    return [Utils isACN] ?phone_error_cat :phone_error_en;
}

+(NSString *)getPhoneAvailableError{
    return [Utils isACN] ?phone_number_no_available_cat :phone_number_no_available_en;
}

+(NSString *)getOk{
    return [Utils isACN] ?OK_cat :OK_en;
}

+(NSString *)getNetworkTitleError{
    return [Utils isACN] ?network_error_cat :network_error_en;
}

+(NSString *)getNetworkMessageError{
    return [Utils isACN] ? no_internet_connection_available_cat :no_internet_connection_available_en;
}

+(NSString *)getValidationTitle{
    return [Utils isACN] ?validation_code_cat :validation_code_en;
}

+(NSString *)getValidationMessage{
    return [Utils isACN] ?enter_the_code_cat :enter_the_code_en;
}

+(NSString *)getCancel{
    return [Utils isACN] ?cancel_cat :cancel_en;
}

+(NSString *)getValidate{
    return [Utils isACN] ?validate_cat :validate_en;
}

+(NSString *)getDataNoFound{
    return [Utils isACN] ?data_no_found_cat :data_no_found_en;
}

+(NSString *)getLogout{
    return [Utils isACN] ?logout_text_button_cat :logout_text_button_en;
}

+(NSString *)getAbout{
    return [Utils isACN] ?about_cat :cna_about_en;
}

+(NSString *)getNotificationsName{
    return [Utils isACN] ?alert_name_cat :alert_name_en;
}

+(NSString *)getErrorCode{
    return [Utils isACN] ?error_code_cat :error_code_en;
}

+(NSString *)getMostrarAlertas{
    return [Utils isACN]?show_alerts_cat :show_alerts_en;
}

+(NSString *)getEdit{
    return [Utils isACN] ?edit_cat :edit_en;
}

+(NSString *)getUpdate{
    return [Utils isACN] ?update_cat :update_en;
}

+(NSString *)getStart{
    return [Utils isACN] ?start_cat :start_en;
}

@end
