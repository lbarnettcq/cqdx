public without sharing class cq_ExceptionHelper {
    public static String Format(Exception ex) {
        return ex.getTypeName() + '\n'
                + ex.getLineNumber() + '\n'
                + ex.getMessage();
    }

    public static String FormatVerbose(Exception ex) {
        return ex.getTypeName() + '\n'
                + ex.getLineNumber() + '\n'
                + ex.getMessage() + '\n'
                + ex.getStackTraceString();
    }
}