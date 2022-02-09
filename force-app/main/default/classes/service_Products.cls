/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class service_Products extends service_Base {
    public override void process(service_Request request, service_Response response) {
        switch on (String)request.Parameters.get('action') {
            when 'getList' {
                getList(request, response);
            }
        }
    }

    public void getList(service_Request request, service_Response response) {       
        dao_Product2 daoProduct2 = new dao_Product2();     
        response.Parameters.put('list', daoProduct2.findAll());
    }
}