USE [EBOARDING_DELHI]
GO
/****** Object:  StoredProcedure [dbo].[GetMagneticDetailsDFMD]    Script Date: 16-10-2024 21:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetMagneticDetailsDFMD] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS identity_column,* from EGATESTAB(NOLOCK) where MAKE='MAGNETIC' and IsActive='True'
	and isnull(GATENO,'')<>'FC'
	--And EGATEIP <> '10.68.95.168' and isnull(EGATE_MAINLOCATION,'') <> 'T1 SHA'

	--update EGATESTAB set CURRENTSTATUS='NO'


	--select * from EGATESTAB
END
GO
/****** Object:  StoredProcedure [dbo].[GetSHALastUpdTimeDFMD]    Script Date: 16-10-2024 21:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetSHALastUpdTimeDFMD]

AS

BEGIN

   
    DECLARE @TIMEDIFF INT;

    DECLARE @LATESTREC VARCHAR(50);

    DECLARE @STATUS VARCHAR(15);
 
    SELECT TOP 1 @LATESTREC = REC_CREATED_TIME
    FROM EGATEPAXTAB WITH (NOLOCK)
	WHERE GATEIP IN (SELECT EGATEIP FROM EGATESTAB(NOLOCK) WHERE MAKE = 'MAGNETIC' AND IsActive = 'TRUE' AND isnull(GATENO,'')<>'FC')

    ORDER BY REC_CREATED_TIME DESC;
 
    SET @TIMEDIFF = DATEDIFF(SECOND, @LATESTREC, GETDATE());
 
    IF (@TIMEDIFF > 90 or @LATESTREC is  null)

        SET @STATUS = 'FAIL';

    ELSE

        SET @STATUS = 'PASS';
 
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS identity_column, @LATESTREC AS Latest_Record, @STATUS AS Status;

END

GO
/****** Object:  StoredProcedure [dbo].[usp_DigiFlyDashValidateUser_DFMD]    Script Date: 16-10-2024 21:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[usp_DigiFlyDashValidateUser_DFMD]
    @username VARCHAR(50),
    @password VARCHAR(30),
	@token VARCHAR(max)
   
AS
BEGIN
    DECLARE @isloggedin INT;
	DECLARE @iserrorcode INT
	DECLARE @errorMsgVal VARCHAR(100)
	declare @usernameValidate VARCHAR(50)
	DECLARE @auth varchar(10)


    IF EXISTS (
        SELECT 1
        FROM DigiFlyUsers (NOLOCK)
        WHERE loginId = @username AND password = @password AND isActive = '1'
    )
    BEGIN
       

  
      
            SET @iserrorcode = 0;
			SET @errorMsgVal = 'SUCCESSFULLY LOGGED IN'
			SET @auth = 'True'
			 SELECT @usernameValidate = USERNAME FROM DigiFlyUsers  where loginId = @username
			    update DigiFlyUsers set  token = @token where loginId = @username and 
				password = @password
			--set @out = 0
       
        
    END
    ELSE 
    BEGIN
        SET @iserrorcode = 1;
		
		SET @errorMsgVal = 'INCORRECT CREDENTIALS'
		set @auth = 'False'
    END

	SELECT @iserrorcode AS errorcode, @errorMsgVal as Value ,@token as token , @auth as auth 
	
END
GO
/****** Object:  StoredProcedure [dbo].[usp_FetchFRSPassengerMonitor_DFMD]    Script Date: 16-10-2024 21:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_FetchFRSPassengerMonitor_DFMD] (
    @Date varchar(20),
    @FLNO varchar(10) ,
    @PNL VARCHAR(50)
)
AS
BEGIN
    DECLARE @SelectStatement NVARCHAR(MAX)
    SET @SelectStatement = '
        SELECT
			PNR AS PNR,
            EB_FLNO1 as FLNO,
            SEQNO AS SEQNO,
            PAXNAME AS PAXNAME,
            SEATNO AS SEATNO,
            IIF(WS_REQUEST IS NULL,''AVAILABLE'',''NOT AVAILABLE'') AS WS_REQUEST,
            WS_RESP,
            PAXUNIQUEID AS UNIQUEID,
            FACEID,
            REGNCHANNEL,
            REC_CREATED_TIME,
			NULL AS SHARETIME
        FROM
            FRSREGISTRATIONTAB(NOLOCK)
        WHERE
            BPFLIGHTDATE = @Date'

    IF @FLNO IS NOT NULL
    BEGIN
        SET @SelectStatement = @SelectStatement + ' AND ((FRSREGISTRATIONTAB.EB_FLNO1 = @FLNO) or (FRSREGISTRATIONTAB.EB_FLNO2 = @FLNO)) '
    END

    IF @PNL IS NOT NULL
    BEGIN
        SET @SelectStatement = @SelectStatement + ' AND PNR = @PNL'
    END

    DECLARE @SelectStatement2 NVARCHAR(MAX)
    SET @SelectStatement2 = '
        SELECT
			SUBSTRING(QRCODEID,7,6) AS PNR,
            EB_FLNO2 AS FLNO,
            SEQNO,
			NULL AS PAXNAME,
			NULL AS SEATNO,
			NULL AS WS_REQUEST,
			NULL AS WS_RESP,
            QRCODEID AS UNIQUEID, 
			NULL AS FACEID,
            REGNCHANNEL,
            REC_CREATED_TIME,
			sharetime AS SHARETIME
        FROM
            FRSREGISTRATIONDETAILS(NOLOCK)
        WHERE
            BPFLIGHTDATE = @Date '

    IF @FLNO IS NOT NULL
    BEGIN
        SET @SelectStatement2 = @SelectStatement2 + ' AND FRSREGISTRATIONDETAILS.EB_FLNO2 = @FLNO '
    END

    IF @PNL IS NOT NULL
    BEGIN
        SET @SelectStatement2 = @SelectStatement2 + ' AND SUBSTRING(QRCODEID,7,6) = @PNL'
    END

    DECLARE @FinalSelectStatement NVARCHAR(MAX)
    SET @FinalSelectStatement = '(' + @SelectStatement + ') UNION ALL (' + @SelectStatement2 + ')'

    EXEC sp_executesql @FinalSelectStatement, N'@Date varchar(20), @FLNO varchar(10), @PNL VARCHAR(50)', @Date, @FLNO, @PNL
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getBarcodeScanstabDMonitor_DFMD]    Script Date: 16-10-2024 21:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_getBarcodeScanstabDMonitor_DFMD]
@paxPnr varchar(50)
AS
BEGIN
SELECT  ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS identity_column,* FROM BARCODESCANSTAB WHERE Barcode LIKE CONCAT('%',
@paxPnr, '%');
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetFlightFeedUpdatedTime_DFMD]    Script Date: 16-10-2024 21:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_GetFlightFeedUpdatedTime_DFMD]
@result VARCHAR(50) output 
AS
begin
select @result = CAST(MAX(CASE 
WHEN MODIFIEDTIME > ENTRYTIME THEN MODIFIEDTIME
ELSE ENTRYTIME
END
) as varchar) from DEPARTURES
end
GO
/****** Object:  StoredProcedure [dbo].[usp_GetFlightsByFlightNo_DFMD]    Script Date: 16-10-2024 21:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[usp_GetFlightsByFlightNo_DFMD]
    @flno VARCHAR(255),
	@flDate VARCHAR(255)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM DEPARTURES WHERE ((FLNO = @flno) or (EB_FLNO1 = @flno) or (EB_FLNO2 = @flno)) AND FLIGHT_DATE = @flDate)
    BEGIN
        SELECT
		ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS identity_column,
	        FLNO,
		    STOD,
		    FLTI,
		    TERMINAL,
		    DES3,
		    ETDI,
		    REMP,
		    GATE1,
		    FLIGHT_DATE,
		    ENTRYTIME,
		    MODIFIEDTIME,
		    GATE_OPEN_TIME,
		    GATE_CLOSE_TIME
        FROM 
            DEPARTURES (NOLOCK)
        WHERE 
          ( (FLNO = @flno) or (EB_FLNO1 = @flno) or (EB_FLNO2 = @flno))
	        AND FLIGHT_DATE = @flDate
        ORDER BY STOD
    END
    ELSE
    BEGIN
        -- If flight not found in DEPARTURES, search from finaldeparturestab
        SELECT
		ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS identity_column,
            FLNO,
            STOD,
            FLTI,
            TERMINAL,
            DES3,
            ETDI,
            REMP,
            GATE1,
            FLIGHT_DATE,
            ENTRYTIME,
            MODIFIEDTIME,
            GATE_OPEN_TIME,
            GATE_CLOSE_TIME
        FROM 
            FINALDEPARTURES(NOLOCK)
        WHERE 
           ((FLNO = @flno) or (EB_FLNO1 = @flno) or (EB_FLNO2 = @flno))
            AND FLIGHT_DATE = @flDate
        ORDER BY STOD
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_getFRSScanstabDMonitor_DFMD]    Script Date: 16-10-2024 21:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_getFRSScanstabDMonitor_DFMD]
@paxPnr varchar(50)
AS
BEGIN
SELECT  ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS identity_column,* FROM FRSSCANSTAB WHERE Barcode LIKE CONCAT('%',
@paxPnr, '%');
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetPassengersByPNRMonitor_DFMD]    Script Date: 16-10-2024 21:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetPassengersByPNRMonitor_DFMD]
    @pnr VARCHAR(255),
	@flDate VARCHAR(255)
AS
BEGIN

    IF EXISTS (SELECT 1 FROM PaxDetailsTab WHERE PNR = @pnr AND BPDATE = @flDate)
    BEGIN
	 
        SELECT
	        PNR,
		    FLNO,
            LTRIM(STR(SEQNO)) AS SEQNO, 
            PAXNAME, 
            SEATNO, 
            FLIGHTTIME,
		    DESTINATION,
		    TRMLENT_CHANNEL,
		    TRMLENTSCANTIME,
		    TRMLENT_SOURCE,
		    SHA_ENTRY_TIME,
		    SHA_SOURCE,
		    PRESHA_SCANTIME,
		    PRESHA_SOURCE,
		    BRD_ENTRY_TIME,
		    BRD_SOURCE
        FROM 
            PaxDetailsTab (NOLOCK)
        WHERE 
            PNR = @pnr
	        AND BPDATE = @flDate
        ORDER BY SEQNO
    END
    ELSE
    BEGIN
        -- If not found in PaxDetailsTab, search in finalpaxdetailstab
        SELECT
            PNR,
		    FLNO,
            LTRIM(STR(SEQNO)) AS SEQNO, 
            PAXNAME, 
            SEATNO, 
            FLIGHTTIME,
		    DESTINATION,
		    TRMLENT_CHANNEL,
		    TRMLENTSCANTIME,
		    TRMLENT_SOURCE,
		    SHA_ENTRY_TIME,
		    SHA_SOURCE,
		    PRESHA_SCANTIME,
		    PRESHA_SOURCE,
		    BRD_ENTRY_TIME,
		    BRD_SOURCE
        FROM 
            finalpaxdetailstab (NOLOCK)
        WHERE 
            PNR = @pnr
            AND BPDATE = @flDate
        ORDER BY SEQNO
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_GetPnlDetails_DFMD]    Script Date: 16-10-2024 21:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetPnlDetails_DFMD]
(
    @PNR VARCHAR(20),
	@flDate VARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT 1 FROM PNLTab WHERE PNL_PNR = @PNR and CAST(PNL_FLIGHTDATE AS DATE) = @flDate)
    BEGIN
        SELECT 
		ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS identity_column,
		PNL_FLNO, PNL_FLIGHTDATE, PAXNAME, PNL_PNR, ORIGIN, DESTINATION, SEATNO, SEQNO, entrytime, PAXTYPE, PAXCURRENTSTATUS, LastUpdatedTime
        FROM PNLTab (NOLOCK)
        WHERE PNL_PNR = @PNR AND CAST(PNL_FLIGHTDATE AS DATE) = @flDate;
    END
    ELSE
    BEGIN
        -- If not found in PNLTab, search in finalPnlTab
        SELECT 
		ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS identity_column,
		PNL_FLNO, PNL_FLIGHTDATE, PAXNAME, PNL_PNR, ORIGIN, DESTINATION, SEATNO, SEQNO, entrytime, PAXTYPE, PAXCURRENTSTATUS, LastUpdatedTime
        FROM finalPnlTab (NOLOCK)
        WHERE PNL_PNR = @PNR AND CAST(PNL_FLIGHTDATE AS DATE) = @flDate;
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_getServiceDetails_DFMD]    Script Date: 16-10-2024 21:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getServiceDetails_DFMD]
@generalServiceName varchar(100)
AS  
BEGIN  
SET NOCOUNT ON  
IF EXISTS (SELECT *  from
	  SERVICEDETAILS(nolock)  where generalServiceName = @generalServiceName
	  and isActive = '1' )
BEGIN
select [IP_ADDRESS] as Serverip
      ,[DISPLAY_SERVICE_NAME] as servicename
	  ,[portno] as portno
	  , '0' as errorcode
	  from
	  SERVICEDETAILS(nolock)  where generalServiceName = @generalServiceName
	  and isActive = '1'

	  END
	  ELSE
	  BEGIN
	  select TOP(1) '0.0.0.1' as Serverip
      ,'NA' as servicename
	  ,'0' as portno
	  , '1' as errorcode
	  from
	  SERVICEDETAILS(nolock)  
	  
	  END
 end
GO
/****** Object:  StoredProcedure [dbo].[usp_GetSFTPFileUpdatedTime_DFMD]    Script Date: 16-10-2024 21:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_GetSFTPFileUpdatedTime_DFMD]
@result datetime output 
as
begin
select @result = Value  from APPCONFIG WHERE Name in ('FLIGHT_FEED_FILE_UPDATED_TIME')
end
GO
/****** Object:  StoredProcedure [dbo].[usp_GetTokenAuthentication_DFMD]    Script Date: 16-10-2024 21:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[usp_GetTokenAuthentication_DFMD]
@token varchar(max)
as
begin
IF EXISTS (SELECT 1 FROM DigiFlyUsers where token = @token)
begin
print(@token)
SELECT @token as token, 'True'as auth from DigiFlyUsers where token = @token
end
else 
begin
select @token as token, 'False' as auth 
end
end



GO
/****** Object:  StoredProcedure [dbo].[usp_MissedFlightCountDFMD]    Script Date: 16-10-2024 21:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MissedFlightCountDFMD]     
  
AS    
BEGIN    
SET NOCOUNT ON;    

DECLARE @ThresholdValue INT = 5; -- Threshold value

CREATE TABLE #MissedFlightSummary (
    AirlineCode VARCHAR(2),
    MissedFlightCount INT,
    Status VARCHAR(10)
)

;WITH PNL_CTE AS (    
    SELECT 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS identity_column,
        D.EB_FLNO1,
        REMP,
        ISNULL(d.ETDI, d.STOD) FLIGHTTIME,
        GETDATE() PRESENTTIME,
        MAX(p.LastUpdatedTime) PNLlastRefreshTime,
        DATEDIFF(MINUTE, MAX(p.LastUpdatedTime), GETDATE()) diffinMins,
        FLTI,
        DES3 AS Destination,
        VIA1 AS VIA 
    FROM 
        DEPARTURES(nolock) D    
    LEFT OUTER JOIN 
        PNLTAB p(nolock) ON d.EB_FLNO1=p.EB_FLNO1     
    WHERE 
        DATEDIFF(HOUR, GETDATE(), ISNULL(d.ETDI, d.STOD)) < 8     
        AND LEFT(D.EB_FLNO1,2) IN (SELECT AIRLINE FROM ACTIVEAIRLINES(nolock))     
        AND isnull(REMP,'') NOT IN ('CNL','NOP','DEP','AIB','GCL','CXX')     
        AND AIRB IS  NULL  
    GROUP BY 
        D.EB_FLNO1, ISNULL(d.ETDI, d.STOD), REMP, FLTI, DES3, VIA1  
)    
INSERT INTO #MissedFlightSummary (AirlineCode, MissedFlightCount, Status)
SELECT 
    LEFT(PNL_CTE.EB_FLNO1, 2) AS AirlineCode,
    COUNT(*) AS MissedFlightCount,
    CASE 
        WHEN COUNT(*) > @ThresholdValue THEN 'FAIL'
        ELSE 'PASS'
    END AS Status
FROM 
    PNL_CTE 
WHERE 
    (diffinMins IS NULL OR diffinMins > 10)
GROUP BY 
    LEFT(PNL_CTE.EB_FLNO1, 2)

SELECT * FROM #MissedFlightSummary

DROP TABLE #MissedFlightSummary

END
GO
/****** Object:  StoredProcedure [dbo].[usp_MissingFlightsDFMD]    Script Date: 16-10-2024 21:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_MissingFlightsDFMD]
AS    
BEGIN    
SET NOCOUNT ON;    
WITH PNL_CTE    
AS (    
   select ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS identity_column,
   D.EB_FLNO1,REMP,ISNULL(d.ETDI,d.STOD) FLIGHTTIME,GETDATE() PRESENTTIME,max(p.LastUpdatedTime) PNLlastRefreshTime,
   datediff(MINUTE,max(p.LastUpdatedTime),GETDATE()) diffinMins, FLTI, DES3 as Destination, VIA1 AS VIA from DEPARTURES(nolock) D    
left outer join PNLTAB p(nolock) on d.EB_FLNO1=p.EB_FLNO1     
where datediff(hour,getdate(),ISNULL(d.ETDI,d.STOD)) < 8     
and LEFT(D.EB_FLNO1,2) IN (SELECT AIRLINE FROM ACTIVEAIRLINES(nolock))     
AND isnull(REMP,'') NOT IN ('CNL','NOP','DEP','AIB','GCL','CXX')     
AND AIRB IS  NULL  
--and ISNULL(d.ETDI,d.STOD) > dateadd(minute,-10,getdate())  
group by D.EB_FLNO1,ISNULL(d.ETDI,d.STOD),REMP,FLTI,DES3,VIA1  
   )   
SELECT *  
FROM PNL_CTE WHERE (diffinMins IS NULL OR diffinMins > 10)    
ORDER BY FLIGHTTIME      
END
GO
/****** Object:  StoredProcedure [dbo].[usp_MonitorDYDataShare_HYD]    Script Date: 16-10-2024 21:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_MonitorDYDataShare_HYD]
as
begin
set NoCount ON
select max(REC_CREATED_TIME) LastTransactionTime,datediff(MINUTE,max(REC_CREATED_TIME),getdate()) diffInMins 
from FRSREGISTRATIONTAB(nolock)
end
GO
/****** Object:  StoredProcedure [dbo].[usp_PNLServiceStatusDFMD]    Script Date: 16-10-2024 21:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PNLServiceStatusDFMD]     
  
AS  

BEGIN  
SET NOCOUNT ON;  
declare @FlightCode varchar(2)
declare @9idiffinmins INT = 0
declare @aidiffinmins INT = 0
declare @6ediffinmins int = 0
declare @ixdiffinmins int = 0
declare @qpdiffinmins int = 0
declare @ukdiffinmins int = 0
declare @sgdiffinmins int = 0
declare @i5diffinmins int = 0
    -- Insert statements for procedure here    

Declare @statusData TABLE(
FLNO varchar(10),
REMP VARCHAR(10),
FLIGHTTIME datetime,
PRESENTTIME datetime,
PNLlastRefreshTime datetime,
diffinMins INT,
FLTI varchar(10),
DES3 VARCHAR(10),
VIA VARCHAR(10)
);
INSERT INTO @statusData(FLNO, REMP, FLIGHTTIME, PRESENTTIME,PNLlastRefreshTime,diffinMins,FLTI,DES3,VIA)  select D.EB_FLNO1,REMP,ISNULL(d.ETDI,d.STOD) FLIGHTTIME,GETDATE() PRESENTTIME,
   max(ISNULL(p.LastUpdatedTime,P.entrytime)) PNLlastRefreshTime,
   datediff(MINUTE,max(p.LastUpdatedTime),GETDATE()) diffinMins, FLTI, DES3 as Destination, VIA1 AS VIA from DEPARTURES(nolock) D    
left outer join PNLTAB p(nolock) on d.EB_FLNO1=p.EB_FLNO1     
where datediff(hour,getdate(),ISNULL(d.ETDI,d.STOD)) < 8     
and LEFT(D.EB_FLNO1,2) IN (SELECT AIRLINE FROM ACTIVEAIRLINES(nolock))     
AND ISNULL(REMP,'') NOT IN ('CNL','NOP','DEP','AIB','GCL','CXX')     
--AND AIRB IS  NULL  and ISNULL(d.ETDI,d.STOD) > dateadd(minute,-10,getdate())  
group by D.EB_FLNO1,ISNULL(d.ETDI,d.STOD),REMP,FLTI,DES3,VIA1  

--SELECT * FROM @statusData

declare @resultTab TABLE(
airline varchar(2),
lastupdatedtime varchar(50),
status varchar(10)
);
insert into @resultTab (airline, lastupdatedtime, status)
select LEFT(FLNO, 2),cast(MAX(PNLlastRefreshTime) as varchar),
case
when count(*) > 5  then 'FAIL'
ELSE 'PASS'
END AS STATUS
from @statusData where (diffinMins > 10 or diffinMins is null)
group by LEFT(FLNO, 2)

--select * from @resultTab


DECLARE cursor_flight CURSOR FOR
SELECT AIRLINE
    FROM [EBOARDING_DELHI].[dbo].[ACTIVEAIRLINES]
    WHERE AIRLINE NOT IN (select airline from @resultTab) and Airline not in ('G8') ;
	 OPEN cursor_flight;
    FETCH NEXT FROM cursor_flight INTO @FlightCode;

    WHILE @@FETCH_STATUS = 0
    BEGIN
	insert into @resultTab (airline, lastupdatedtime, status)
	select LEFT(FLNO, 2),cast(MAX(PNLlastRefreshTime) as varchar),
 'PASS' as STATUS
from @statusData
where LEFT(FLNO, 2) = @FlightCode
group by LEFT(FLNO, 2)
end
    CLOSE cursor_flight;
    DEALLOCATE cursor_flight;

	select ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS identity_column,* from @resultTab

END
GO
