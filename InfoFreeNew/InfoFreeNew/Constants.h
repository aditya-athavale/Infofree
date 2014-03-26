//
//  Constants.h
//  InfoFree
//
//  Created by Aditya Athvale on 25/02/14.
//  Copyright (c) 2014 Aditya Athavale. All rights reserved.
//

#ifndef InfoFree_Constants_h
#define InfoFree_Constants_h


#pragma mark- Prospect URLS

#define PROSPECTS_URL @"http://localhost:8080/slmRest/prospects/getAllProspectDetails/%@/%d/%d/name/asc"

#define PROSPECT_DETAILS_URL @"http://localhost:8080/slmRest/prospects/getSingleProspectDetails/%@"

#define ADD_PROSPECTS_URL @"http://localhost:8080/slmRest/prospects/add"

#define DELETE_PROSPECT_URL @"http://localhost:8080/slmRest/prospects/deleteProspect/userId=%@&prospectIds=%@&isActive=%@"

#define EDIT_PROSPECT_DETAILS @"http://localhost:8080/slmRest/prospects/updateProspectField/userId=%@&prospectId=%@&newValue=%@&fieldName=%@"

#pragma mark - Prospect Contact Details

#define EDIT_PROSPECT_CONTACT_DETAILS @"http://localhost:8080/slmRest/prospects/updateContactField/userId=%@&prospectId=%@&contactId=%@&newValue=%@&fieldName=%@"

#pragma mark - Prospect Business Details

#define EDIT_PROSPECT_BUSINESS_DETAILS @"http://localhost:8080/slmRest/prospects/updateBusinessDetailField/userId=%@&prospectId=%@&businessId=%@&newValue=%@&fieldName=%@"

#pragma mark- Prospect Additional Info

#define EDIT_PROSPECT_ADDITIONALINFO_DETAILS @"http://localhost:8080/slmRest/prospects/updateProspectAdditionalInformationField/userId=%@&prospectId=%@&prospectAdditionalInfoId=%@&newValue=%@&fieldName=%@"

#define ADD_ADDITIONAL_INFO @"http://localhost:8080/slmRest/prospects/addAdditionalInfoToProspect"


#pragma mark- Appointments

#define FETCH_APPOINTMENTS_URL @"http://localhost:8080/slmRest/calendar/fetchAppointments/%@"

#define ADD_APPOINTMENT_URL @"http://localhost:8080/slmRest/calendar/addAppointment"

#define DELETE_APPOINTMENT_URL @"http://localhost:8080/slmRest/calendar/deleteAppointment"

#pragma mark - Tasks

#define FETCH_TASKS_URL @"http://localhost:8080/slmRest/calendar/fetchTasks/%@/%d"

#define ADD_TASK_URL @"http://localhost:8080/slmRest/calendar/addTask"

#define MARK_TASK_AS_COMPLETE_URL @"http://localhost:8080/slmRest/calendar/markTaskAsComplete/%@"

#define MARK_TASK_AS_UNCOMPLETE_URL @"http://localhost:8080/slmRest/calendar/markTaskAsUnComplete/%@"

#define DELETE_TASK_URL @"http://localhost:8080/slmRest/calendar/deleteTask/%@"

#endif
