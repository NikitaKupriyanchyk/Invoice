/**
 * Created by user on 06-Sep-19.
 */

global class Bach  implements Database.Batchable<sObject>{

        public String query = 'SELECT Id,Name FROM Account WHERE LastModifiedDate = TODAY';




    global Iterable<sObject> start(Database.BatchableContext param1) {

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext param1, List<Account> param2) {

        List<Account> accList = new List<Account>();

        for (Account acc :param2){
            accList.add(acc);
        }
        update accList;
    }

    global void finish(Database.BatchableContext param1) {
    }


}