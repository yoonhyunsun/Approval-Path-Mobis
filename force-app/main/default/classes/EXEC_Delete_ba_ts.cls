/**
 * Created by hyodongmin on 2022/08/12.
 */

@IsTest
private class EXEC_Delete_ba_ts {
    @IsTest
    static void testBehavior() {
        System.assertEquals('asdf', new EXEC_Delete_ba('asdf').sObjectName);
        System.assertEquals('asdf2', new EXEC_Delete_ba('asdf2', Date.newInstance(2022, 9, 9)).sObjectName);
        System.assertEquals(Date.newInstance(2022, 9, 9), new EXEC_Delete_ba('asdf2', Date.newInstance(2022, 9, 9)).ifDate);
    }
    @IsTest
    static void testStart() {
        Database.QueryLocator kQueryLocator = new EXEC_Delete_ba('User').start(null);
        // 한 달 전
        Date kDate = Date.today().addMonths(-1);
        // 타임존 반영
        Datetime kDeleteDateTime = Datetime.newInstance(kDate, Time.newInstance(0, 0, 0, 0));
        String kDateString = kDeleteDateTime.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        System.assertEquals('SELECT Id FROM User WHERE CreatedDate < ' + kDateString, kQueryLocator.getQuery());

        kQueryLocator = new EXEC_Delete_ba('User', Date.today().addDays(-10)).start(null);
        // 입력한 날짜
        kDate = Date.today().addDays(-10);
        // 타임존 반영
        kDeleteDateTime = Datetime.newInstance(kDate, Time.newInstance(0, 0, 0, 0));
        kDateString = kDeleteDateTime.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        System.assertEquals('SELECT Id FROM User WHERE CreatedDate < ' + kDateString, kQueryLocator.getQuery());
    }

    @IsTest
    static void testExecute() {
        Account acc = new Account(Name = 'test+');
        insert acc;
        System.assertEquals(1, [SELECT Id FROM Account WHERE Name = 'test+'].size());

        new EXEC_Delete_ba('Account').execute(null, new List<Account>{ acc });

        System.assertEquals(true, [SELECT Id, IsDeleted FROM Account WHERE Name = 'test+' ALL ROWS][0].IsDeleted);
    }

    @IsTest
    static void testExecuteErr() {
        Account acc = new Account(Name = 'test+');
        insert acc;

        new EXEC_Delete_ba('Account').execute(null, new List<Account>{ acc });
        new EXEC_Delete_ba('Account').execute(null, new List<Account>{ acc });

    }

    @IsTest
    static void testFinish() {
        new EXEC_Delete_ba('User').finish(null);
    }

}