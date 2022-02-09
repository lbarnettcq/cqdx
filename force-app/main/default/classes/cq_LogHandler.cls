/**
 * Logging class, controlled by CQ_Logger_Config custom setting
 */
public without sharing class cq_LogHandler {
    public Boolean Buffer { get; set; }
    public Boolean DisableDebug { get; set; }
    public Boolean DisableInfo { get; set; }
    public Boolean DisableFine { get; set; }
    private List<LogEntry> entries = new List<LogEntry>();
    private static cq_LogHandler m_instance = null;

    private cq_LogHandler() {
        CQ_Logger_Config__c config = CQ_Logger_Config__c.getInstance();
        if (config != null) {
            Buffer = config.Buffer_Logs__c;
            DisableDebug = config.Debug_Log_Disabled__c;
            DisableInfo = config.Info_Logging_Disabled__c;
            DisableFine = config.Fine_Logging_Disabled__c;
            return;
        }
        Buffer = false;
        DisableDebug = false;
        DisableInfo = false;
        DisableFine = false;
    }

    /**
     * Provides a SINGLETON instance of the cq_LogHandler class
     */
    public static cq_LogHandler Instance {
        get {
            if (m_instance == null) {
                m_instance = new cq_LogHandler();
            }
            return m_instance;
        }
    }

    /**
     * Creates a log entry for submitted LoggingLevel and Message
     * @param   level   System.LoggingLevel   The log level to submit
     * @param   message   String   The log message to include
     */
    public void Log(System.LoggingLevel level, String message) {
        if (level == System.LoggingLevel.DEBUG && DisableDebug) { return; }
        if (level == System.LoggingLevel.INFO && DisableInfo) { return; }
        if (level == System.LoggingLevel.FINE && DisableFine) { return; }
        addLog(level, message);
    }

    /**
     * Creates a ERROR log entry
     * @param   ex   Exception   The log message to include
     */
    public void Error(Exception ex) {
        addLog(System.LoggingLevel.ERROR, cq_ExceptionHelper.FormatVerbose(ex));
    }

    /**
     * Creates a ERROR log entry
     * @param   message   String   The log message to include
     */
    public void Error(String message) {
        addLog(System.LoggingLevel.ERROR, message);
    }

    /**
     * Creates a DEBUG log entry
     * @param   message   String   The log message to include
     */
    public void Debug(String message) {
        if (DisableDebug) { return; }
        addLog(System.LoggingLevel.DEBUG, message);
    }

    /**
     * Creates a FINE log entry
     * @param   message   String   The log message to include
     */
    public void Warning(String message) {
        if (DisableFine) { return; }
        addLog(System.LoggingLevel.FINE, message);
    }

    /**
     * Creates a FINE log entry
     * @param   message   String   The log message to include
     */
    public void Fine(String message) {
        if (DisableFine) { return; }
        addLog(System.LoggingLevel.FINE, message);
    }

    /**
     * Creates a INFO log entry
     * @param   message   String   The log message to include
     */
    public void Info(String message) {
        if (DisableInfo) { return; }
        addLog(System.LoggingLevel.INFO, message);
    }

    private void addLog(System.LoggingLevel level, String message) {
        LogEntry entry = new LogEntry(level, message);
        entries.add(entry);
        if (Buffer) { return; }
        CommitLogs();
    }

    /**
     * Commits all buffered Log entries
     */
    public void CommitLogs() {
        for (LogEntry entry : entries) {
            System.debug(entry.level, entry.message);
        }
        entries = new List<LogEntry>();
    }

    private class LogEntry {
        public System.LoggingLevel level { get; set; }
        public String message { get; set; }

        public LogEntry(System.LoggingLevel severity, String entry) {
            level = severity;
            message = entry;
        }
    }
}