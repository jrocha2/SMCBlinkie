// Javascript file to update database from a source outside the SMCBlinkie app

var rootRef = new Firebase("https://smcblinkie.firebaseio.com/");

// Pass in an list of email addresses
function setAdmins(emails) {
    rootRef.child("Admins").set(emails);
}

// Pass in Hours of Operation in the form of a dictionary
// i.e. {"Monday-Friday" : "12:00am - 2:00am", "Saturday-Sunday" : "12:00am - 4:00am"} 
function setHours(hours) {
    rootRef.child("Hours").set(hours);
}

// Pass in a string with an announcement
function setInfo(info) {
    rootRef.child("Info").set(info);
}
