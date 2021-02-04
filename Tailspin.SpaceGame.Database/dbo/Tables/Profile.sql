
CREATE TABLE [dbo].[Profiles] (
    [id]                INT           NOT NULL,
    [userName]          INT           NOT NULL,
    [avatarUrl]         NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);
