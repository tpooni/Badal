USE [WEBWISDOM]
GO
/****** Object:  UserDefinedFunction [dbo].[GetFileName]    Script Date: 12/13/2016 22:41:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetFileName]
 (
  @fullpath nvarchar(max),
  @delimiter nvarchar(100)
 ) RETURNS nvarchar(max)
 AS
 BEGIN

 declare @split as table (
  id int identity(1,1),
  fragment nvarchar(max)
 )
 declare @filename nvarchar(max)
 declare @xml xml

 SET @xml =
  N'<root><r>' +
  REPLACE(@fullpath, @delimiter,'</r><r>') +
  '</r></root>'

 INSERT INTO @split(fragment)
 SELECT 
  r.value('.','nvarchar(max)') as item
 FROM @xml.nodes('//root/r') as records(r)

 SELECT @filename = fragment
 FROM @split
 WHERE id = (SELECT MAX(id) FROM @split)

 RETURN LTRIM(RTRIM(@filename))

 END
GO
/****** Object:  StoredProcedure [dbo].[spDeleteDLPMStoreLink]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeleteDLPMStoreLink]
	@RecID int
AS
BEGIN
	UPDATE tblRentalDLPMStoreLink SET Deleted = 1
	WHERE RecID = @RecID
END
GO
/****** Object:  StoredProcedure [dbo].[spAddUpdateRentalJobNotes]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddUpdateRentalJobNotes]
	@JobNo int,
	@Notes varchar(max)
AS
BEGIN
	IF NOT EXISTS (SELECT JobNo from tblRentalJobNotes where @JobNo=JobNo)
	BEGIN
		INSERT INTO tblRentalJobNotes (JobNo, Notes)
		VALUES(@JobNo, @Notes)
	END
	ELSE
	BEGIN
		UPDATE tblRentalJobNotes SET Notes = @Notes
		WHERE JobNo = @JobNo
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spAddUpdateJobState]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddUpdateJobState]
	@JobNo int,
	@Step int,
	@UserID varchar(20)
AS
BEGIN
	IF EXISTS (SELECT JobNo from tblUserJobState where JobNo = @JobNo AND UserID=@UserID)
	BEGIN
		UPDATE tblUserJobState Set Step=@Step where JobNo = @JobNo AND UserID=@UserID
	END
	ELSE
	BEGIN
		INSERT INTO tblUserJobState(JobNo, UserID, Step)
		VALUES(@JobNo, @UserID, @Step)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[spDisableEnableUserLogin]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDisableEnableUserLogin]
	@LoginID int
AS
	DECLARE @RecCount int

	SELECT @RecCount = count(*) FROM [webpages_Membership] 
	WHERE UserId = @LoginID  AND   IsConfirmed = 1
	
	IF @RecCount > 0
	BEGIN
		UPDATE [webpages_Membership] SET IsConfirmed = 0 WHERE UserId = @LoginID 
	END
	ELSE
	BEGIN
		UPDATE [webpages_Membership] SET IsConfirmed = 1 WHERE UserId = @LoginID 
	END
GO
/****** Object:  StoredProcedure [dbo].[spFindIfPrereqDoneForAFPS]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFindIfPrereqDoneForAFPS]
	@StoreNo char(12),
	@SoftwareID int,
	@FileName varchar(max)
AS
BEGIN

SELECT JI.JobID, P.ProcessStatus, J.NotifyReceived, J.Description, J.MFConversionName, J.SoftwareID, j.processorder, JI.Inputfile, 
dbo.getfilename(InputFile,'\') as FileName, P.processStarted, P.ProcessEnded
FROM sqlclientsro.WISDOM.dbo.tblMFProcess P
LEFT JOIN sqlclientsro.WISDOM.dbo.tblMFJob J ON P.JobID = J.JobId
LEFT JOIN sqlclientsro.WISDOM.dbo.tblMFJobInput JI ON JI.JobID = J.JobID 
LEFT JOIN sqlclientsro.WISDOM.dbo.tblMFProcessedStores PS ON PS.ProcessID = P.ProcessID
WHERE J.softwareid = @SoftwareID And PS.StoreNo = @StoreNo AND P.ProcessEnded > Getdate()-1 AND JI.JobID IN
	(
SELECT JobID from sqlclientsro.WISDOM.dbo.tblmfjob WHERE JobID IN(
SELECT Main.JobID from 
(SELECT dbo.getfilename(InputFile,'\') as FileName, * FROM sqlclientsro.WISDOM.dbo.tblMFjobinput 
where jobid in (SELECT jobid FROM sqlclientsro.WISDOM.dbo.tblmfjob where softwareid = @SoftwareID)) as Main
WHERE Main.FileName not like @FileName ) AND ProcessOrder = 1 AND P.ProcessStatus = 3)  

--	SELECT TOP 1 * from sqlclientsro.WISDOM.dbo.tblMFProcess
--	SELECT TOP 1 * from sqlclientsro.WISDOM.dbo.tblMFJob
--	WHERE ProcessStarted >= Getdate()-30 AND ProcessStatus = 3 AND JOBID IN (
--	SELECT Main.JobID FROM
--	(
--	SELECT JI.JobID, JI.Password, J.NotifyReceived, J.Description, J.MFConversionName, J.SoftwareID, j.processorder, JI.Inputfile, dbo.getfilename(InputFile,'\') as FileName
--	FROM sqlclientsro.WISDOM.dbo.tblMFProcess P
--	LEFT JOIN sqlclientsro.WISDOM.dbo.tblMFJob J ON P.JobID = J.JobId
--	LEFT JOIN sqlclientsro.WISDOM.dbo.tblMFJobInput JI ON JI.JobID = J.JobID 
--	LEFT JOIN sqlclientsro.WISDOM.dbo.tblMFProcessedStores PS ON PS.ProcessID = P.ProcessID
--	WHERE J.softwareid = @SoftwareID And PS.StoreNo = @StoreNo
--	) As Main
--	WHERE Main.FileName like '%SAP_WIS%') 
END
GO
/****** Object:  StoredProcedure [dbo].[spGetJobStep]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetJobStep]
	@JobNo int,
	@UserID varchar(20)
AS
BEGIN
	SELECT Step from tblUserJobState where JobNo = @JobNo AND UserID=@UserID
END
GO
/****** Object:  StoredProcedure [dbo].[spGetJobListForDLPM]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetJobListForDLPM]
	@UserID int
AS
BEGIN

If @UserID = 3 
BEGIN
	SELECT JS.JobNO As [Select], b.[Name] As StoreName, B.StoreNo, JS.JobNo, JS.JobDateTime, JS.OfficeNoOfRecord 
	FROM sqlwhro.WISE.dbo.tblJobSchedule JS
		  LEFT JOIN sqlwhro.WISE.dbo.tblbranch b on b.branchid = JS.branchid
	WHERE   storeNo  IN (SELECT StoreNo COLLATE SQL_Latin1_General_CP1_CI_AS FROM tblrentaldlpmstorelink) 
		AND softwareID = 7880 
		AND js.jobdatetime > GETDATE() - 4 AND  jobdatetime < GETDATE() + 7
		AND JS.jobno NOT in (Select jobno from tblRentalJobStatus)
		AND CHARINDEX('APPAREL', b.[Name]) = 0
		AND JS.JobStatus Not In ('X','Y')
END
ELSE
BEGIN
	SELECT JS.JobNO As [Select], b.[Name] As StoreName, B.StoreNo, JS.JobNo, JS.JobDateTime, JS.OfficeNoOfRecord 
	FROM sqlwhro.WISE.dbo.tblJobSchedule JS
		  LEFT JOIN sqlwhro.WISE.dbo.tblbranch b on b.branchid = JS.branchid
	WHERE   storeNo  IN (SELECT StoreNo COLLATE SQL_Latin1_General_CP1_CI_AS FROM tblrentaldlpmstorelink WHERE userid = @UserID AND Deleted = 0) 
		AND softwareID = 7880 AND js.jobdatetime > GETDATE() - 4 AND  jobdatetime < GETDATE() + 7
		AND JS.jobno NOT in (Select jobno from tblRentalJobStatus)
		AND CHARINDEX('APPAREL', b.[Name]) = 0
		AND JS.JobStatus Not In ('X','Y')
END

END
GO
/****** Object:  StoredProcedure [dbo].[spGetJobListForAdmin]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetJobListForAdmin]
AS
BEGIN
 SELECT JS.JobNo As Job_No, isnull(RJS.Status,0) As Confirmed, b.softwareid As Software_ID, 
		b.includeid As Include_ID, b.[Name] As StoreName, B.StoreNo, JS.JobDateTime,  DLPM.email As Phone_No, UI.UserName As Email, JN.Notes
 FROM sqlwhro.WISE.dbo.tblJobSchedule JS
 LEFT JOIN sqlwhro.WISE.dbo.tblbranch b on b.branchid = JS.branchid
 LEFT JOIN tblRentalJobStatus RJS ON RJS.JobNo = JS.JobNo
 LEFT JOIN tblrentaldlpmstorelink  DLPM ON DLPM.StoreNo COLLATE SQL_Latin1_General_CP1_CI_AS = b.storeno
 LEFT JOIN tblUserInfo UI ON UI.LoginID = DLPM.UserID 
 LEFT JOIN tblRentalJobNotes JN on JN.JobNo = JS.JobNo
 LEFT JOIN webpages_Membership MBRSHP ON MBRSHP.UserID = DLPM.UserID
	WHERE   b.storeNo  IN (SELECT StoreNo COLLATE SQL_Latin1_General_CP1_CI_AS FROM tblrentaldlpmstorelink where deleted=0) 
		AND softwareID = 7880 
		AND DLPM.Deleted = 0
		AND js.jobdatetime > GETDATE() - 4 AND  jobdatetime < GETDATE() + 14
--		AND JS.jobno NOT in (Select jobno from tblRentalJobStatus)
		AND CHARINDEX('APPAREL', b.[Name]) = 0
		AND MBRSHP.IsConfirmed = 1
		AND JS.JobStatus Not In ('X','Y')
END
GO
/****** Object:  StoredProcedure [dbo].[spGetDLPMEmail]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetDLPMEmail]
	@UserID int
AS
BEGIN
	SELECT email As PhoneNo from tblRentalDLPMStoreLink WHERE UserID=@UserID And email is not null
END
GO
/****** Object:  StoredProcedure [dbo].[spValidateUserLogin]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spValidateUserLogin]
	@username varchar(50),
	@password varchar(50)
AS
BEGIN
	Select LoginID from tblLoginInfo where UserName = @username and Password = @password and deleted = 0
END
GO
/****** Object:  StoredProcedure [dbo].[spAddDLPMStoreLink]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddDLPMStoreLink]
	@UserID int,
	@StoreNo char(12),
	@PhoneNo char(12)
AS
BEGIN

	INSERT INTO tblRentalDLPMStoreLink (UserID,StoreNo,email, Deleted,Lastedit,LastEditor)
	VALUES (@UserID, @StoreNo, @PhoneNo , 0, GETDATE(), 'ADMIN')
END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateDLPMStoreLink]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateDLPMStoreLink]
	@RecID int,
	@StoreNo char(12)
AS
BEGIN
	UPDATE tblRentalDLPMStoreLink SET StoreNo = @StoreNo
	WHERE RecID = @RecID
END
GO
/****** Object:  StoredProcedure [dbo].[spRollbackJobConfirmation]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[spGetJobListForAdmin]    Script Date: 07/22/2015 11:53:01 ******/
CREATE PROCEDURE [dbo].[spRollbackJobConfirmation]
	@JobNo int
AS
BEGIN
	Delete  from tblRentalJobStatus WHERE JobNo = @JobNo
END
GO
/****** Object:  StoredProcedure [dbo].[spGetRentalID]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetRentalID]
	@JobNo int
AS
BEGIN
 IF EXISTS (SELECT RentalID from tblRentalJobInfo where JobNo = @JobNo)
	SELECT RentalID from tblRentalJobInfo where JobNo = @JobNo
 ELSE
 BEGIN
    INSERT INTO tblRentalJobInfo (JobNo,JobDateTime,CustNo, OfficeNo, MOR, MOREmail, DateReceived, SoftwareID,SoftwareVer, StoreNo, StoreName)
    (SELECT JS.JobNo, JS.JobDateTime, C.CustNo, B.AssignedOffice, b.Contact, b.Contact, Getdate(), b.SoftwareID, b.SoftwareID, b.StoreNo, B.[Name] 
		FROM sqlwhro.WISE.dbo.tblJobSchedule JS LEFT JOIN sqlwhro.WISE.dbo.tblBranch B on B.Branchid = JS.branchID 
		LEFT JOIN sqlwhro.WISE.dbo.tblCustomer C on C.CustID = b.CustID
     WHERE JobNo = @JobNo)
	SELECT RentalID from tblRentalJobInfo where JobNo = @JobNo
 END
END
GO
/****** Object:  StoredProcedure [dbo].[spGetNextTaskAFPSPosting]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetNextTaskAFPSPosting]
AS
BEGIN
	SELECT SoftwareID, StoreNo, FilePath from tblRentalAFPSPosting where Status = 0 ORDER By RecID
END
GO
/****** Object:  StoredProcedure [dbo].[spGetLoginInfo]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetLoginInfo]
AS
BEGIN
  SELECT UI.LoginID, ui.UserName, WM.Password, WM.CreateDate, wm.ConfirmationToken, WM.IsConfirmed, wm.LastPasswordFailureDate, 
 wm.PasswordChangedDate, wm.PasswordVerificationToken from tblUserInfo UI LEFT JOIN webpages_Membership WM on WM.UserId=UI.LoginID
 ORDER By UI.LoginID
 END
GO
/****** Object:  StoredProcedure [dbo].[spGetListOfUploadedFilesErrors]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetListOfUploadedFilesErrors]
	@RentalID int
AS
BEGIN

SELECT [RentalFileTXID] As [Select]
      ,[TXFileName] As Uploaded_File
      , case
        when [jobNomismatch] = 0 then 'YES'
        when [jobNomismatch] = 1 then 'NO'
        else 'UNDEFINED'
		end AS Valid_Job#
--      ,[jobNomismatch] As Valid_Job#
      , case
        when [invalidfile] = 0 then 'YES'
        when [invalidfile]= 1 then 'NO'
        else 'UNDEFINED'
		end AS Valid_File
--      ,[invalidfile] As Valid_File
  FROM [WEBWISDOM].[dbo].[tblRentalFileInfo]
  WHERE [RentalID] = @RentalID And Deleted = 0 and (JobNoMismatch = 1 Or InvalidFile = 1)
  
END
GO
/****** Object:  StoredProcedure [dbo].[spGetListOfUploadedFiles]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetListOfUploadedFiles]
	@RentalID int
AS
BEGIN

SELECT [RentalFileTXID] As [Select]
      ,[TXFileName] As Uploaded_File
      ,[Lines] As Lines
      ,[Qty] As Qty
      ,[Ext] As Ext
/*      ,[jobNomismatch]
      ,[invalidfile]*/
  FROM [WEBWISDOM].[dbo].[tblRentalFileInfo]
  WHERE [RentalID] = @RentalID And Deleted = 0 and JobNoMismatch = 0 and InvalidFile = 0
  
END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateRentalJobStaus]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateRentalJobStaus]
	@JobNo int,
	@LoginID int
AS
BEGIN
DECLARE @RentalID int
DECLARE @Notify varchar(50)
DECLARE @Subj varchar(50)
	
	SET @Notify = (SELECT UserName from tblUserInfo where LoginID = @LoginID)
	--'tpooni@wisintl.com'
	SET @RentalID = (SELECT RentalID from tblRentalJobInfo where JobNo = @JobNo)

	IF EXISTS (SELECT RentalID from tblRentalTagRange where RentalID = @RentalID)
	BEGIN
		IF NOT EXISTS(SELECT JobNo FRom tblRentalJobStatus WHERE JobNo = @JobNo)
		BEGIN
			INSERT INTO tblRentalJobStatus (JobNo,RentalID,LoginID, [Status],Notify) VALUES (@JobNo,@RentalID, @LoginID, 1,@Notify)
			SET @Subj = CAST(@JobNo AS char(8)) + 'Is Confirmed'
			EXEC msdb..sp_send_dbmail
				@profile_name='SQLSYS',
				@recipients='KMcCutcheon@wisintl.com;toim@wisintl.com',
				@subject=@Subj
			SELECT 1 As RetValue
		END
	END
	ELSE
 		SELECT 0 As RetValue
END
GO
/****** Object:  StoredProcedure [dbo].[spFindIfTagRangeOverlapForEdit]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFindIfTagRangeOverlapForEdit]
	@TagRangeID int,
	@RentalID int,
	@TagValFrom int,
	@TagValTo int,
	@Description varchar(50)
AS
BEGIN
	SELECT * FROM tblRentalTagRange WHERE @TagValFrom BETWEEN TagValFrom and TagValTo AND RentalID = @RentalID And TagRangeID <> @TagRangeID AND Deleted = 0
	UNION
	SELECT * FROM tblRentalTagRange WHERE @TagValTo BETWEEN TagValFrom and TagValTo AND RentalID = @RentalID And TagRangeID <> @TagRangeID  AND Deleted = 0
	UNION
	SELECT * FROM tblRentalTagRange WHERE @Description = Description AND RentalID = @RentalID And TagRangeID <> @TagRangeID  AND Deleted = 0
 END
GO
/****** Object:  StoredProcedure [dbo].[spFindIfTagRangeOverlap]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFindIfTagRangeOverlap]
	@RentalID int,
	@TagValFrom int,
	@TagValTo int,
	@Description varchar(50)
AS
BEGIN
	SELECT * FROM tblRentalTagRange WHERE @TagValFrom BETWEEN TagValFrom and TagValTo AND RentalID = @RentalID AND Deleted = 0
	UNION
	SELECT * FROM tblRentalTagRange WHERE @TagValTo BETWEEN TagValFrom and TagValTo AND RentalID = @RentalID AND Deleted = 0
	UNION
	SELECT * FROM tblRentalTagRange WHERE @Description = Description AND RentalID = @RentalID AND Deleted = 0
 END
GO
/****** Object:  StoredProcedure [dbo].[spFindIfTagRangeExist]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFindIfTagRangeExist]
	@JobNo int
AS
BEGIN
 IF EXISTS (SELECT RentalID from tblRentalJobInfo where JobNo = @JobNo)
	 IF EXISTS (SELECT Tagrangeid from tblRentalTagRange where RentalID = (SELECT RentalID from tblRentalJobInfo where JobNo = @JobNo))
		SELECT 1 As RetValue
	 Else
		SELECT 0 As RetValue
 ELSE
		SELECT 0 As RetValue
 END
GO
/****** Object:  StoredProcedure [dbo].[spEditTagRange]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spEditTagRange]
	@TagRangeID int,
	@TagValFrom int,
	@TagValTo int,
	@Description varchar(20)
AS
BEGIN
	UPDATE tblRentalTagRange
	SET TagValFrom = @TagValFrom,
		TagValTo = @TagValTo,
		Description = @Description
	WHERE TagRangeID = @TagRangeID
END
GO
/****** Object:  StoredProcedure [dbo].[spDeleteTagRange]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeleteTagRange]
	@TagRangeID int
AS
BEGIN
	UPDATE tblRentalTagRange
	SET Deleted = 1
	WHERE TagRangeID = @TagRangeID
END
GO
/****** Object:  StoredProcedure [dbo].[spAddTagRange]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddTagRange]
	@RentalID int,
	@TagValFrom int,
	@TagValTo int,
	@Description varchar(20)
AS
BEGIN
	INSERT INTO tblRentalTagRange(RentalID,TagValFrom,TagValTo,Description,Deleted)
	VALUES(@RentalID,@TagValFrom,@TagValTo,@Description,0)
END
GO
/****** Object:  StoredProcedure [dbo].[spAddRentalFile]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddRentalFile]
	@RentalID int,
	@TXFileName varchar(255),
	@LoginID int,
	@JobNoMismatch bit,
	@InvalidFile bit,
	@Lines bigint,
	@Qty bigint,
	@Ext bigint
AS
BEGIN
	IF NOT EXISTS (SELECT @TXFileName from tblRentalFileInfo where @TXFileName=TXFileName AND RentalID = @RentalID)
	BEGIN
		INSERT INTO tblRentalFileInfo (RentalID, TXFileName, LoginID, JobNoMismatch, InvalidFile, Deleted, Lines, Qty, Ext)
		VALUES(@RentalID, @TXFileName, @LoginID, @JobNoMismatch, @InvalidFile, 0, @Lines, @Qty, @Ext)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[GetTagRangesForAJob]    Script Date: 12/13/2016 22:41:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTagRangesForAJob]
	@JobNo int
AS
BEGIN
	SELECT TagValFrom,TagValTo,[Description] 
	FROM tblRentalTagRange 
	WHERE RentalID = (Select RentalID from tblRentalJobStatus Where JobNo = @JobNo) And Deleted = 0
END
GO
