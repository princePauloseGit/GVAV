codeunit 58103 CommonHelper
{
    var
        rec_EnhanceIntegrationLog: Record EnhancedIntegrationLog;

    procedure GetReportId(ReportIdString: Text) ReportId: Integer;
    var
        NewReportIdString, Where, Which : Text;
    begin
        Where := '=';
        Which := 'Report ';
        NewReportIdString := DelChr(ReportIdString, Where, Which);
        Evaluate(ReportId, NewReportIdString);
    end;

    procedure InsertIntegrationLog(Message: Text[2048]; Severity: Enum EnhIntegrationLogSeverity)
    begin
        rec_EnhanceIntegrationLog.Reset();
        rec_EnhanceIntegrationLog.Init();
        rec_EnhanceIntegrationLog.id := CreateGuid();
        rec_EnhanceIntegrationLog.Message := Message;
        rec_EnhanceIntegrationLog.ExtendedText := CopyStr(GetLastErrorText(), 1, 2048);
        rec_EnhanceIntegrationLog.Severity := Severity;
        rec_EnhanceIntegrationLog.DateTimeOccurred := System.CurrentDateTime;
        //     rec_EnhanceIntegrationLog.RecordType 
        //     rec_EnhanceIntegrationLog.RecordID 
        //     rec_EnhanceIntegrationLog.source 
        rec_EnhanceIntegrationLog.Insert(true);
    end;
}