USE CyberSecurityDB;
GO

IF OBJECT_ID('NetworkTraffic', 'U') IS NOT NULL 
    DROP TABLE NetworkTraffic;
GO

CREATE TABLE NetworkTraffic (
    Destination_Port INT,
    Flow_Duration BIGINT,
    Total_Fwd_Packets INT,
    Total_Backward_Packets INT,
    Total_Length_of_Fwd_Packets BIGINT,
    Total_Length_of_Bwd_Packets BIGINT,
    Flow_Bytes_per_s FLOAT,
    Flow_Packets_per_s FLOAT,
    FIN_Flag_Count INT,
    SYN_Flag_Count INT,
    ACK_Flag_Count INT,
    Label VARCHAR(50)
);
GO

BULK INSERT NetworkTraffic
FROM 'C:\Users\HP\Downloads\cleaned_ddos_traffic.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

USE CyberSecurityDB;
GO

-- 1. Check Total Count (Normal Traffic vs DDoS Attack)
SELECT Label, COUNT(*) AS Total_Logs
FROM NetworkTraffic
GROUP BY Label;

-- 2. Attack Targets (Kaun se ports par DDoS ho raha hai?)
SELECT Destination_Port, COUNT(*) AS Attack_Count
FROM NetworkTraffic
WHERE Label = 'DDoS'
GROUP BY Destination_Port
ORDER BY Attack_Count DESC;

-- 3. Traffic Flow Rate Comparison
SELECT Label, 
       AVG(Flow_Duration) AS Avg_Duration, 
       AVG(Flow_Packets_per_s) AS Avg_Packets_Per_Sec,
       AVG(Flow_Bytes_per_s) AS Avg_Bytes_Per_Sec
FROM NetworkTraffic
GROUP BY Label;

