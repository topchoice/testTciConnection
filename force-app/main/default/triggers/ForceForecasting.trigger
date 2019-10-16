trigger ForceForecasting on User (before insert) {

    for (User myUser: Trigger.new) {
        myUser.ForecastEnabled = true;
    }
    
}