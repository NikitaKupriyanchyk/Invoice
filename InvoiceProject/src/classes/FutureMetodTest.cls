public class FutureMetodTest {
    
    @Future
    public static void metodTest(String name){
      Account acc = [SELECT	Id, Name FROM Account WHERE Name = :name LIMIT 1];
        acc.Name = acc.Name + 'acc';
        upsert acc;
        
        
    }

}