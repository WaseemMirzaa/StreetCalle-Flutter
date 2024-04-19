enum UserType { client, vendor, employee }

enum VendorType { none, individual, agency }

enum PermissionResponse { granted, denied, canceled }

enum FoodType { none, western, italian, chinese }

enum SubscriptionType { none, individual, agency }

enum BottomNavPosition { home, menu, profile, settings }

// enum IndivisualPlan { ind_one_month, ind_one_year }
enum IndivisualPlan { ind_starter_v1, ind_growth_v1 }

enum IndivisualPlanRevenueCat { ind_starter_v1, ind_growth_v1 }

enum AgencyPlan {
  new_agency_starter_v1,
  new_agency_growth_v1,
  intermediate_agency_starter_v1,
  intermediate_agency_growth_v1,
  establish_agency_starter_v1,
  establish_agency_growth_v1
}