/**
 * Created by hyodongmin on 2022/08/17.
 */

@IsTest
private class TestUtil_ts {

    @IsTest
    static void testSleep() {
        Long startTime = Datetime.now().getTime();
        TestUtil.sleep(2000);

        System.assertEquals(true, Datetime.now().getTime() - startTime >= 2000);
    }

    @IsTest
    static void testValueOf() {
        Map<String, Object> kMap1 = new Map<String, Object>{ 'value' => '1' };
        System.assertEquals('1', TestUtil.valueOf(kMap1, 'value'));

        List<String> kStrList = new List<String>{ 'a', 'b' };
        kMap1.put('arr', kStrList);

        Map<String, Object> kMap2 = new Map<String, Object>{ 'map1' => kMap1 };

        System.assertEquals('1', TestUtil.valueOf(kMap2, 'map1.value'));

        Map<String, Object> kMap3 = new Map<String, Object>{ 'map2' => kMap2 };
        System.assertEquals('a', ((List<String>) TestUtil.valueOf(kMap3, 'map2.map1.arr'))[0]);
        System.assertEquals('b', ((List<String>) TestUtil.valueOf(kMap3, 'map2.map1.arr'))[1]);
    }

    @IsTest
    static void testTreatField() {
        User item = new User();
        item = (User) TestUtil.treatField(item, 'Name', 'name--');

        System.assertEquals('name--', item.Name);
    }


    @IsTest
    static void testTreatFields() {
        User item = new User();
        item = (User) TestUtil.treatFields(item, new List<Object>{ 'Name', 'name--2', 'Id', '01p9D000002SD9m' });

        System.assertEquals('name--2', item.Name);
        System.assertEquals('01p9D000002SD9m', item.Id);
    }

    @IsTest
    static void testRewriteSubQuery() {
        List<User> users = new List<User>();
        users.add((User) TestUtil.treatFields(new User(), new List<Object>{ 'Name', 'name--3' }));
        users.add((User) TestUtil.treatFields(new User(), new List<Object>{ 'Name', 'name--33' }));

        Map<String, Object> kResultMap = (Map<String, Object>) TestUtil.rewriteSubQuery(users);
        System.assertEquals(2, kResultMap.get('totalSize'));
        System.assertEquals(true, kResultMap.get('done'));
        System.assertEquals(2, ((List<Object>) kResultMap.get('records')).size());
        System.assertEquals('name--3', ((User) ((List<Object>) kResultMap.get('records'))[0]).Name);
        System.assertEquals('name--33', ((User) ((List<Object>) kResultMap.get('records'))[1]).Name);
    }
}