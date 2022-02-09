/**
 * Provides a strongly-typed method of adding ORDER BY statements to generated SOQL
 */
public without sharing class cq_OrderBy implements cq_iOrderBy {
    @TestVisible private static final String ORDER_ASC = ' ASC';
    @TestVisible private static final String ORDER_DESC = ' DESC';

    private String m_cq_OrderBy { get; set; }
    
    /**
     * Execute generation of the ORDER BY statement as a String
     * @return      String
     */
    public String ForSoql() {
        return m_cq_OrderBy;
    }

    /**
     * Generates ORDER BY ASC
     * @param   field   Schema.SObjectField   The field to sort by
     * @return      A new instance of cq_OrderBy
     */
    public static cq_OrderBy Ascending(Schema.SObjectField field) {
        return new cq_OrderBy(field, ORDER_ASC);
    }

    /**
     * Generates ORDER BY DESC
     * @param   field   Schema.SObjectField   The field to sort by
     * @return      A new instance of cq_OrderBy
     */
    public static cq_OrderBy Descending(Schema.SObjectField field) {
        return new cq_OrderBy(field, ORDER_DESC);
    }

    private cq_OrderBy(Schema.SObjectField field, String direction) {
        m_cq_OrderBy = cq_SchemaHelper.GetDescribe(field).getName() + direction;
    }
}