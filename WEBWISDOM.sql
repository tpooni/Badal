USE [WEBWISDOM]
GO
/****** Object:  Table [dbo].[tblRentalDLPMStoreLink]    Script Date: 12/12/2016 23:34:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRentalDLPMStoreLink](
	[RecID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[StoreNo] [char](12) NOT NULL,
	[email] [varchar](50) NULL,
	[Deleted] [bit] NOT NULL,
	[Lastedit] [smalldatetime] NOT NULL,
	[LastEditor] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblRentalDLPMStoreLink] PRIMARY KEY CLUSTERED 
(
	[RecID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRentalAFPSPosting]    Script Date: 12/12/2016 23:34:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRentalAFPSPosting](
	[RecID] [int] IDENTITY(1,1) NOT NULL,
	[RentalID] [int] NOT NULL,
	[SoftwareID] [int] NOT NULL,
	[StoreNo] [varchar](12) NOT NULL,
	[FilePath] [varchar](max) NOT NULL,
	[Status] [int] NOT NULL,
 CONSTRAINT [PK_tblRentalAFPSPosting] PRIMARY KEY CLUSTERED 
(
	[RecID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblLoginInfo]    Script Date: 12/12/2016 23:34:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblLoginInfo](
	[LoginID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[Deleted] [bit] NOT NULL,
	[LastEdit] [smalldatetime] NOT NULL,
	[LastEditor] [varchar](50) NULL,
 CONSTRAINT [PK_tblLoginInfo] PRIMARY KEY CLUSTERED 
(
	[LoginID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRentalJobStatus]    Script Date: 12/12/2016 23:34:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblRentalJobStatus](
	[RecID] [int] IDENTITY(1,1) NOT NULL,
	[RentalID] [int] NOT NULL,
	[LoginID] [int] NULL,
	[JobNo] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[Notify] [nchar](50) NOT NULL,
 CONSTRAINT [PK_tblRentalJobStatus] PRIMARY KEY CLUSTERED 
(
	[RecID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblRentalJobNotes]    Script Date: 12/12/2016 23:34:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRentalJobNotes](
	[RecID] [int] IDENTITY(1,1) NOT NULL,
	[JobNo] [int] NOT NULL,
	[Notes] [varchar](max) NOT NULL,
 CONSTRAINT [PK_tblRentalJobNotes] PRIMARY KEY CLUSTERED 
(
	[RecID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRentalJobInfo]    Script Date: 12/12/2016 23:34:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRentalJobInfo](
	[RentalID] [int] IDENTITY(1,1) NOT NULL,
	[JobNo] [int] NOT NULL,
	[JobDateTime] [smalldatetime] NOT NULL,
	[DateReceived] [smalldatetime] NOT NULL,
	[CustNo] [char](8) NOT NULL,
	[OfficeNo] [char](4) NOT NULL,
	[MOR] [varchar](30) NOT NULL,
	[MOREmail] [varchar](50) NOT NULL,
	[SoftwareID] [bigint] NOT NULL,
	[SoftwareVer] [bigint] NOT NULL,
	[StoreNo] [varchar](12) NOT NULL,
	[StoreName] [varchar](40) NOT NULL,
 CONSTRAINT [PK_tblRentalJobInfo] PRIMARY KEY CLUSTERED 
(
	[RentalID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[webpages_Roles]    Script Date: 12/12/2016 23:34:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[webpages_Roles](
	[RoleId] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](256) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[RoleName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[webpages_OAuthMembership]    Script Date: 12/12/2016 23:34:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[webpages_OAuthMembership](
	[Provider] [nvarchar](30) NOT NULL,
	[ProviderUserId] [nvarchar](100) NOT NULL,
	[UserId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Provider] ASC,
	[ProviderUserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[webpages_Membership]    Script Date: 12/12/2016 23:34:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[webpages_Membership](
	[UserId] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[ConfirmationToken] [nvarchar](128) NULL,
	[IsConfirmed] [bit] NULL,
	[LastPasswordFailureDate] [datetime] NULL,
	[PasswordFailuresSinceLastSuccess] [int] NOT NULL,
	[Password] [nvarchar](128) NOT NULL,
	[PasswordChangedDate] [datetime] NULL,
	[PasswordSalt] [nvarchar](128) NOT NULL,
	[PasswordVerificationToken] [nvarchar](128) NULL,
	[PasswordVerificationTokenExpirationDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUserJobState]    Script Date: 12/12/2016 23:34:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserJobState](
	[RecID] [int] IDENTITY(1,1) NOT NULL,
	[JobNo] [int] NOT NULL,
	[UserID] [nvarchar](50) NOT NULL,
	[Step] [int] NOT NULL,
 CONSTRAINT [PK_tblUserJobState] PRIMARY KEY CLUSTERED 
(
	[RecID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUserInfo]    Script Date: 12/12/2016 23:34:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserInfo](
	[LoginID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](56) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[LoginID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblStatusInfo]    Script Date: 12/12/2016 23:34:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblStatusInfo](
	[Staus] [int] NOT NULL,
	[StatusName] [varchar](50) NOT NULL,
	[LastEdit] [smalldatetime] NOT NULL,
	[LastEditor] [varchar](50) NULL,
 CONSTRAINT [PK_tblStatusInfo] PRIMARY KEY CLUSTERED 
(
	[Staus] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[webpages_UsersInRoles]    Script Date: 12/12/2016 23:34:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[webpages_UsersInRoles](
	[UserId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblRentalTagRange]    Script Date: 12/12/2016 23:34:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRentalTagRange](
	[TagRangeID] [int] IDENTITY(1,1) NOT NULL,
	[RentalID] [int] NOT NULL,
	[TagValFrom] [int] NOT NULL,
	[TagValTo] [int] NOT NULL,
	[GroupRangeID] [int] NULL,
	[Name] [varchar](50) NULL,
	[Description] [varchar](50) NULL,
	[Seq] [int] NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_tblRentalTagRange] PRIMARY KEY CLUSTERED 
(
	[TagRangeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRentalFileInfo]    Script Date: 12/12/2016 23:34:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRentalFileInfo](
	[RentalFileTXID] [int] IDENTITY(1,1) NOT NULL,
	[RentalID] [int] NOT NULL,
	[TXFileName] [varchar](max) NOT NULL,
	[LoginID] [int] NOT NULL,
	[JobNoMismatch] [bit] NOT NULL,
	[InvalidFile] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Lines] [bigint] NULL,
	[Qty] [bigint] NULL,
	[Ext] [bigint] NULL,
 CONSTRAINT [PK_tblRentalFileInfo] PRIMARY KEY CLUSTERED 
(
	[RentalFileTXID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblJobStatus]    Script Date: 12/12/2016 23:34:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblJobStatus](
	[JobStatusID] [int] IDENTITY(1,1) NOT NULL,
	[RentalID] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[LastUpdated] [smalldatetime] NOT NULL,
	[LastEditor] [varchar](50) NULL,
 CONSTRAINT [PK_tblJobStatus] PRIMARY KEY CLUSTERED 
(
	[JobStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Default [DF_tblLoginInfo_LastEdit]    Script Date: 12/12/2016 23:34:25 ******/
ALTER TABLE [dbo].[tblLoginInfo] ADD  CONSTRAINT [DF_tblLoginInfo_LastEdit]  DEFAULT (getdate()) FOR [LastEdit]
GO
/****** Object:  Default [DF__webpages___IsCon__71D1E811]    Script Date: 12/12/2016 23:34:25 ******/
ALTER TABLE [dbo].[webpages_Membership] ADD  DEFAULT ((0)) FOR [IsConfirmed]
GO
/****** Object:  Default [DF__webpages___Passw__72C60C4A]    Script Date: 12/12/2016 23:34:25 ******/
ALTER TABLE [dbo].[webpages_Membership] ADD  DEFAULT ((0)) FOR [PasswordFailuresSinceLastSuccess]
GO
/****** Object:  ForeignKey [FK_tblJobStatus_tblRentalJobInfo]    Script Date: 12/12/2016 23:34:25 ******/
ALTER TABLE [dbo].[tblJobStatus]  WITH CHECK ADD  CONSTRAINT [FK_tblJobStatus_tblRentalJobInfo] FOREIGN KEY([RentalID])
REFERENCES [dbo].[tblRentalJobInfo] ([RentalID])
GO
ALTER TABLE [dbo].[tblJobStatus] CHECK CONSTRAINT [FK_tblJobStatus_tblRentalJobInfo]
GO
/****** Object:  ForeignKey [FK_tblJobStatus_tblStatusInfo]    Script Date: 12/12/2016 23:34:25 ******/
ALTER TABLE [dbo].[tblJobStatus]  WITH CHECK ADD  CONSTRAINT [FK_tblJobStatus_tblStatusInfo] FOREIGN KEY([Status])
REFERENCES [dbo].[tblStatusInfo] ([Staus])
GO
ALTER TABLE [dbo].[tblJobStatus] CHECK CONSTRAINT [FK_tblJobStatus_tblStatusInfo]
GO
/****** Object:  ForeignKey [FK_tblRentalFileInfo_tblRentalFileInfo]    Script Date: 12/12/2016 23:34:25 ******/
ALTER TABLE [dbo].[tblRentalFileInfo]  WITH CHECK ADD  CONSTRAINT [FK_tblRentalFileInfo_tblRentalFileInfo] FOREIGN KEY([RentalFileTXID])
REFERENCES [dbo].[tblRentalFileInfo] ([RentalFileTXID])
GO
ALTER TABLE [dbo].[tblRentalFileInfo] CHECK CONSTRAINT [FK_tblRentalFileInfo_tblRentalFileInfo]
GO
/****** Object:  ForeignKey [FK_tblRentalFileInfo_tblRentalJobInfo]    Script Date: 12/12/2016 23:34:25 ******/
ALTER TABLE [dbo].[tblRentalFileInfo]  WITH CHECK ADD  CONSTRAINT [FK_tblRentalFileInfo_tblRentalJobInfo] FOREIGN KEY([RentalID])
REFERENCES [dbo].[tblRentalJobInfo] ([RentalID])
GO
ALTER TABLE [dbo].[tblRentalFileInfo] CHECK CONSTRAINT [FK_tblRentalFileInfo_tblRentalJobInfo]
GO
/****** Object:  ForeignKey [FK_tblRentalTagRange_tblRentalJobInfo]    Script Date: 12/12/2016 23:34:25 ******/
ALTER TABLE [dbo].[tblRentalTagRange]  WITH CHECK ADD  CONSTRAINT [FK_tblRentalTagRange_tblRentalJobInfo] FOREIGN KEY([RentalID])
REFERENCES [dbo].[tblRentalJobInfo] ([RentalID])
GO
ALTER TABLE [dbo].[tblRentalTagRange] CHECK CONSTRAINT [FK_tblRentalTagRange_tblRentalJobInfo]
GO
/****** Object:  ForeignKey [FK_tblRentalTagRange_tblRentalTagRange]    Script Date: 12/12/2016 23:34:25 ******/
ALTER TABLE [dbo].[tblRentalTagRange]  WITH CHECK ADD  CONSTRAINT [FK_tblRentalTagRange_tblRentalTagRange] FOREIGN KEY([TagRangeID])
REFERENCES [dbo].[tblRentalTagRange] ([TagRangeID])
GO
ALTER TABLE [dbo].[tblRentalTagRange] CHECK CONSTRAINT [FK_tblRentalTagRange_tblRentalTagRange]
GO
/****** Object:  ForeignKey [fk_RoleId]    Script Date: 12/12/2016 23:34:25 ******/
ALTER TABLE [dbo].[webpages_UsersInRoles]  WITH CHECK ADD  CONSTRAINT [fk_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[webpages_Roles] ([RoleId])
GO
ALTER TABLE [dbo].[webpages_UsersInRoles] CHECK CONSTRAINT [fk_RoleId]
GO
/****** Object:  ForeignKey [fk_UserId]    Script Date: 12/12/2016 23:34:25 ******/
ALTER TABLE [dbo].[webpages_UsersInRoles]  WITH CHECK ADD  CONSTRAINT [fk_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[tblLoginInfo] ([LoginID])
GO
ALTER TABLE [dbo].[webpages_UsersInRoles] CHECK CONSTRAINT [fk_UserId]
GO
