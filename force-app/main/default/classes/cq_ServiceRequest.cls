public inherited sharing class cq_ServiceRequest {
    public String Name { get; set; }
    public String Action { get; set; }
    public Map<String, Object> Parameters { get; set; }

    public cq_ServiceRequest() { }

    public cq_ServiceRequest(String name, String action) {
        this.Name = name;
        this.Action = action;
        this.Parameters = new Map<String, Object>();
    }

    public cq_ServiceRequest(String name, String action, Map<String, Object> params) {
        this.Name = name;
        this.Action = action;
        this.Parameters = params;
        if (params != null) return;
        this.Parameters = new Map<String, Object>();
    }

    public cq_ServiceRequest WithParam(String key, Object value) {
        if (Parameters == null) { Parameters = new Map<String, Object>(); }
        Parameters.put(key, value);
        return this;
    }
}