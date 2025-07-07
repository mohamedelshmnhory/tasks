/// timeout request constants
const String commonErrorUnexpectedMessage = 'Something went wrong please try again';
const int timeoutRequestStatusCode = 1000;
const int unAuthorizedStatusCode = 401;
const int badRequestStatusCode = 400;
const int serviceUnavailableStatusCode = 503;

/// app flavors strings
const String testEnvironmentString = 'test';
const String devEnvironmentString = 'dev';
const String stageEnvironmentString = 'stage';

///  IOException request constants
const String commonConnectionFailedMessage = 'Please check your Internet Connection';
const int ioExceptionStatusCode = 900;

///  Format Exception request constants
const String formatExceptionMessage = 'Invalid JSON format.';
const int formatExceptionStatusCode = 0;

/// http client header constants

const String acceptLanguageKey = 'Accept-Language';
const String authorisationKey = 'Authorization';
const String bearerKey = 'Bearer ';
const String contentTypeKey = 'Content-Type';
const String contentTypeValue = 'application/json';
const String contentMultipartTypeValue = 'multipart/form-data';

///countryCode
const String countryCodeKey = "+966";

///error
const String errorMessage = "error";

const String FontFamily = 'montserrat';

///This is the time limit for every api call
const Duration timeOutDuration = Duration(seconds: 20);

///The app base Url should be provided in this value
const String testBaseUrl = 'http://localhost:5067';
const String devBaseUrl = 'http://localhost:5067';
const String stageBaseUrl = 'http://localhost:5067';

const String appStoreLink = '';
const String playStoreLink = '';

// --- Backend Endpoints ---
const String RegisterEndpoint = '/register';
const String LoginEndpoint = '/login';
const String ProfileEndpoint = '/profile'; // GET, PUT
const String ProjectsEndpoint = '/projects'; // GET, POST
const String ProjectByIdEndpoint = '/projects/'; // +{id} GET, PUT, DELETE
const String ProjectTasksEndpoint = '/projects/'; // +{projectId}/tasks GET, POST
const String TaskByIdEndpoint = '/tasks/'; // +{id} GET, PUT, DELETE
const String UsersEndpoint = '/users'; // GET - Get all users
const String ProjectMembersEndpoint = '/projects/'; // +{projectId}/members GET, POST, DELETE

