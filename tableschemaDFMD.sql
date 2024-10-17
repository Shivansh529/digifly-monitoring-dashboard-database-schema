USE [EBOARDING_DELHI]
GO
/****** Object:  Table [dbo].[DigiFlyUsers]    Script Date: 17-10-2024 13:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DigiFlyUsers](
	[s_no] [int] IDENTITY(1,1) NOT NULL,
	[loginId] [varchar](255) NOT NULL,
	[password] [varchar](255) NOT NULL,
	[department] [varchar](255) NULL,
	[isActive] [tinyint] NULL,
	[isloggedin] [tinyint] NULL,
	[activatedDate] [datetime2](7) NULL,
	[deActivatedDate] [datetime2](7) NULL,
	[deActivatedReason] [varchar](255) NULL,
	[username] [varchar](50) NULL,
	[token] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[s_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SERVICECONFIG]    Script Date: 17-10-2024 13:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SERVICECONFIG](
	[AIRLINE] [varchar](2) NULL,
	[SERVICETYPE] [varchar](50) NULL,
	[SERVICENAME] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SERVICEDETAILS]    Script Date: 17-10-2024 13:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SERVICEDETAILS](
	[IP_ADDRESS] [varchar](20) NULL,
	[DISPLAY_SERVICE_NAME] [varchar](50) NULL,
	[isActive] [varchar](10) NULL,
	[REC_CREATED_TIME] [datetime] NULL,
	[generalServiceName] [varchar](50) NULL,
	[portno] [varchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[servicerestartlog]    Script Date: 17-10-2024 13:01:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[servicerestartlog](
	[slno] [int] IDENTITY(1,1) NOT NULL,
	[windows_service_Name] [varchar](100) NULL,
	[request] [varchar](max) NULL,
	[response] [varchar](max) NULL,
	[REC_CREATED_TIME] [datetime] NULL,
	[execution_username] [varchar](100) NULL,
	[errorcode] [varchar](10) NULL,
	[remarks] [varchar](max) NULL,
	[httpstatuscode] [varchar](10) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[DigiFlyUsers] ON 
GO
INSERT [dbo].[DigiFlyUsers] ([s_no], [loginId], [password], [department], [isActive], [isloggedin], [activatedDate], [deActivatedDate], [deActivatedReason], [username], [token]) VALUES (1, N'kashishbhasin', N'a2FzaGlzaGJoYXNpbg==', N'IT', 1, 1, CAST(N'2024-05-28T16:36:21.4800000' AS DateTime2), NULL, NULL, N'bro', N'2E16BC913CAD6FE56B323C04086B372223A0CF6BB70A7E03E9B63CFC0F0187EE1395508F31AA633B8F64A43FE624EE42BE408B9CABD02034794B7AE5339E0E9F')
GO
INSERT [dbo].[DigiFlyUsers] ([s_no], [loginId], [password], [department], [isActive], [isloggedin], [activatedDate], [deActivatedDate], [deActivatedReason], [username], [token]) VALUES (2, N'ankit', N'YW5raXQ=', N'HR', 1, 0, CAST(N'2024-05-28T16:36:21.4800000' AS DateTime2), NULL, NULL, N'bro', NULL)
GO
SET IDENTITY_INSERT [dbo].[DigiFlyUsers] OFF
GO
INSERT [dbo].[SERVICEDETAILS] ([IP_ADDRESS], [DISPLAY_SERVICE_NAME], [isActive], [REC_CREATED_TIME], [generalServiceName], [portno]) VALUES (N'10.248.16.10', N'PNL_SERVICE_9I', N'1', CAST(N'2024-10-08T17:32:02.800' AS DateTime), N'AllianceAir_Pnl_Service', N'8080')
GO
INSERT [dbo].[SERVICEDETAILS] ([IP_ADDRESS], [DISPLAY_SERVICE_NAME], [isActive], [REC_CREATED_TIME], [generalServiceName], [portno]) VALUES (N'10.248.16.10', N'PNL_SERVICE_AI', N'1', CAST(N'2024-10-08T17:32:02.800' AS DateTime), N'AirIndia_Pnl_Service', N'8080')
GO
INSERT [dbo].[SERVICEDETAILS] ([IP_ADDRESS], [DISPLAY_SERVICE_NAME], [isActive], [REC_CREATED_TIME], [generalServiceName], [portno]) VALUES (N'10.248.16.10', N'PNL_SERVICE_I5', N'1', CAST(N'2024-10-08T17:32:02.800' AS DateTime), N'AirAsia_Pnl_Service', N'8080')
GO
INSERT [dbo].[SERVICEDETAILS] ([IP_ADDRESS], [DISPLAY_SERVICE_NAME], [isActive], [REC_CREATED_TIME], [generalServiceName], [portno]) VALUES (N'10.248.16.10', N'PNL_SERVICE_QP', N'1', CAST(N'2024-10-08T17:32:02.800' AS DateTime), N'Akasa_Pnl_Service', N'8080')
GO
INSERT [dbo].[SERVICEDETAILS] ([IP_ADDRESS], [DISPLAY_SERVICE_NAME], [isActive], [REC_CREATED_TIME], [generalServiceName], [portno]) VALUES (N'10.24.158.30', N'DIALMagneticOpsV2', N'1', CAST(N'2024-10-09T10:51:00.757' AS DateTime), N'NonDy_Sha_MagneticGates', N'8080')
GO
INSERT [dbo].[SERVICEDETAILS] ([IP_ADDRESS], [DISPLAY_SERVICE_NAME], [isActive], [REC_CREATED_TIME], [generalServiceName], [portno]) VALUES (N'10.24.158.30', N'BusGateServices', N'1', CAST(N'2024-10-09T10:51:00.757' AS DateTime), N'BusGateService', N'8080')
GO
INSERT [dbo].[SERVICEDETAILS] ([IP_ADDRESS], [DISPLAY_SERVICE_NAME], [isActive], [REC_CREATED_TIME], [generalServiceName], [portno]) VALUES (N'10.248.16.12', N'DIGIYATRA_MQ_LISTNER_V4', N'1', CAST(N'2024-10-09T10:51:00.757' AS DateTime), N'DigiYatra_Listner', N'8080')
GO
INSERT [dbo].[SERVICEDETAILS] ([IP_ADDRESS], [DISPLAY_SERVICE_NAME], [isActive], [REC_CREATED_TIME], [generalServiceName], [portno]) VALUES (N'10.248.16.10', N'PNL_SERVICE_SG', N'1', CAST(N'2024-10-08T17:32:02.800' AS DateTime), N'Spicejet_Pnl_Service', N'8080')
GO
INSERT [dbo].[SERVICEDETAILS] ([IP_ADDRESS], [DISPLAY_SERVICE_NAME], [isActive], [REC_CREATED_TIME], [generalServiceName], [portno]) VALUES (N'10.248.16.10', N'PNL_SERVICE_UK', N'1', CAST(N'2024-10-08T17:32:02.800' AS DateTime), N'Vistara_Pnl_Service', N'8080')
GO
INSERT [dbo].[SERVICEDETAILS] ([IP_ADDRESS], [DISPLAY_SERVICE_NAME], [isActive], [REC_CREATED_TIME], [generalServiceName], [portno]) VALUES (N'10.248.16.11', N'PNL_SERVICE_6E', N'1', CAST(N'2024-10-08T17:36:36.380' AS DateTime), N'Indigo_Pnl_Service', N'8080')
GO
INSERT [dbo].[SERVICEDETAILS] ([IP_ADDRESS], [DISPLAY_SERVICE_NAME], [isActive], [REC_CREATED_TIME], [generalServiceName], [portno]) VALUES (N'10.248.16.11', N'PNL_IX', N'1', CAST(N'2024-10-08T17:36:36.380' AS DateTime), N'AirIndiaExpress_Pnl_Service', N'8080')
GO
SET IDENTITY_INSERT [dbo].[servicerestartlog] ON 
GO
INSERT [dbo].[servicerestartlog] ([slno], [windows_service_Name], [request], [response], [REC_CREATED_TIME], [execution_username], [errorcode], [remarks], [httpstatuscode]) VALUES (7, N'PNL_SERVICE_9I', N'ServiceRequest [serviceName=PNL_SERVICE_9I, command=stop]', N'ServiceResponse [errorCode=1, remarks=Connectivity issue obtained]', CAST(N'2024-10-17T12:57:53.100' AS DateTime), N'Amar', N'1', N'Connectivity issue obtained', N'404')
GO
INSERT [dbo].[servicerestartlog] ([slno], [windows_service_Name], [request], [response], [REC_CREATED_TIME], [execution_username], [errorcode], [remarks], [httpstatuscode]) VALUES (2, N'PNL_SERVICE_9I', N'ServiceRequest [serviceName=PNL_SERVICE_9I, command=stop]', N'ServiceResponse [errorCode=1, remarks=Connectivity issue obtained]', CAST(N'2024-10-11T16:06:38.283' AS DateTime), N'Amar', N'1', N'Connectivity issue obtained', N'')
GO
INSERT [dbo].[servicerestartlog] ([slno], [windows_service_Name], [request], [response], [REC_CREATED_TIME], [execution_username], [errorcode], [remarks], [httpstatuscode]) VALUES (3, N'PNL_SERVICE_9I', N'ServiceRequest [serviceName=PNL_SERVICE_9I, command=stop]', N'ServiceResponse [errorCode=1, remarks=Connectivity issue obtained]', CAST(N'2024-10-11T16:10:01.470' AS DateTime), N'Amar', N'1', N'Connectivity issue obtained', N'')
GO
INSERT [dbo].[servicerestartlog] ([slno], [windows_service_Name], [request], [response], [REC_CREATED_TIME], [execution_username], [errorcode], [remarks], [httpstatuscode]) VALUES (4, N'PNL_SERVICE_9I', N'ServiceRequest [serviceName=PNL_SERVICE_9I, command=stop]', N'ServiceResponse [errorCode=1, remarks=Connectivity issue obtained]', CAST(N'2024-10-11T16:16:14.013' AS DateTime), N'Amar', N'1', N'Connectivity issue obtained', N'404')
GO
INSERT [dbo].[servicerestartlog] ([slno], [windows_service_Name], [request], [response], [REC_CREATED_TIME], [execution_username], [errorcode], [remarks], [httpstatuscode]) VALUES (5, N'PNL_SERVICE_9I', N'ServiceRequest [serviceName=PNL_SERVICE_9I, command=stop]', N'ServiceResponse [errorCode=1, remarks=Connectivity issue obtained]', CAST(N'2024-10-11T16:18:48.060' AS DateTime), N'Amar', N'1', N'Connectivity issue obtained', N'404')
GO
INSERT [dbo].[servicerestartlog] ([slno], [windows_service_Name], [request], [response], [REC_CREATED_TIME], [execution_username], [errorcode], [remarks], [httpstatuscode]) VALUES (6, N'PNL_SERVICE_9I', N'ServiceRequest [serviceName=PNL_SERVICE_9I, command=stop]', N'ServiceResponse [errorCode=1, remarks=Connectivity issue obtained]', CAST(N'2024-10-11T16:43:39.500' AS DateTime), N'Amar', N'1', N'Connectivity issue obtained', N'404')
GO
SET IDENTITY_INSERT [dbo].[servicerestartlog] OFF
GO
ALTER TABLE [dbo].[DigiFlyUsers] ADD  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[DigiFlyUsers] ADD  DEFAULT ((0)) FOR [isloggedin]
GO
ALTER TABLE [dbo].[DigiFlyUsers] ADD  DEFAULT (getdate()) FOR [activatedDate]
GO
