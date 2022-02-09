/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class dao_Product2 extends sql_Dao {
    public dao_Product2() {
        setSObject(Product2.sObjectType);

        addField(Product2.Id);
        addField(Product2.Name);
    }

    public List<Product2> findAll() {
        return (List<Product2>)getAll();
    }
}