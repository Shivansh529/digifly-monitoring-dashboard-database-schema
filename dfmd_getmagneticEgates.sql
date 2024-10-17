USE [EBOARDING_DELHI]
GO
/****** Object:  StoredProcedure [dbo].[DFMD_GetMagneticEgates]    Script Date: 17-10-2024 12:34:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[DFMD_GetMagneticEgates]
AS
BEGIN
    SELECT EGATE_TERMINAL, LEFT(EGATE_SUBLOCATION, 5) AS ZONE, CURRENTSTATUS, EGATEIP, EGATE_MAINLOCATION AS Location
    FROM EGATESTAB (NOLOCK)
    WHERE MAKE = 'MAGNETIC'
	  AND IsActive = 1
      AND ISFRS = 0
      AND EGATE_TERMINAL <> 'T1'
	UNION ALL
	SELECT EGATE_TERMINAL,EGATE_MAINLOCATION AS ZONE, CURRENTSTATUS, EGATEIP, EGATE_SUBLOCATION as Location
    FROM EGATESTAB (NOLOCK)
    WHERE MAKE = 'EASIER'
	  AND IsActive = 1
      AND ISFRS = 0
      AND EGATE_TERMINAL = 'T1'
	ORDER BY EGATE_TERMINAL, ZONE
END;
 