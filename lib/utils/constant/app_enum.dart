enum UserType { client, vendor, employee }

enum VendorType { none, individual, agency }

enum PermissionResponse { granted, denied, canceled }

enum FoodType { none, western, italian, chinese }

enum SubscriptionType { none, individual, agency }

enum BottomNavPosition { home, menu, profile, settings }

// ind_one_month = 'price_1OXJ05Jv1vWNPW79LdUrSUDC'
// ind_one_year = 'price_1OXJ4MJv1vWNPW79bZcYaM23'
//
// new_agency_starter = 'price_1OZ59YJv1vWNPW790s9scYqs'
// new_agency_growth = 'price_1OZ5CkJv1vWNPW79WYs5FWP9'
//
// establish_agency_starter = 'price_1OZ5DpJv1vWNPW79WRhJksKK'
// establish_agency_growth = 'price_1OZ5F4Jv1vWNPW79x4ZRPD9N'

enum IndivisualPlan { ind_one_month, ind_one_year }
enum AgencyPlan { new_agency_starter, new_agency_growth, establish_agency_starter, establish_agency_growth }