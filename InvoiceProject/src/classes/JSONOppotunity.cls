/**
 * Created by user on 02-Sep-19.
 */

public with sharing class JSONOppotunity {
    public static void start () {
        List<Opportunity> opportunitiesList = [SELECT Id, Name FROM Opportunity WHERE StageName = 'Closed Won' LIMIT 20];
        String str = JSON.serialize(opportunitiesList);
        System.debug(str);
    }
}