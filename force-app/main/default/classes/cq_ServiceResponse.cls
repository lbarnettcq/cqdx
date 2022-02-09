public inherited sharing class cq_ServiceResponse {
    public cq_ServiceRequest Request { get; set; }
    public cq_RequestStatus Status { get; set; }
    public Exception ThrownException { get; set; }
    public Object Data { get; set; }

    public cq_ServiceResponse(cq_ServiceRequest req) {
        Request = req;
    }

    public cq_ServiceResponse(cq_ServiceRequest req, cq_RequestStatus stat) {
        Request = req;
        Status = stat;
    }

    public cq_ServiceResponse(cq_ServiceRequest req, cq_RequestStatus stat, Exception ex) {
        Request = req;
        Status = stat;
        ThrownException = ex;
    }

    public cq_ServiceResponse(cq_ServiceRequest req, cq_RequestStatus stat, Object dt) {
        Request = req;
        Status = stat;
        Data = dt;
    }
}