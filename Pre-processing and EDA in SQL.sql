select * from machine_downtime;
/*CHECKING FOR DUPLICATES*/
SELECT DISTINCT (`Machine_ID` ) FROM machine_downtime;
SELECT COUNT(*) FROM machine_downtime;

SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`, COUNT(*)
FROM machine_downtime GROUP BY `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime` HAVING COUNT(*)>1;

/* NO DUPLICATES FOUND*/

/*OUTLIER ANALYSIS*/

  SELECT 
(`Hydraulic_Pressure(bar)`- AVG(`Hydraulic_Pressure(bar)`) OVER())/STDDEV(`Hydraulic_Pressure(bar)`) OVER() as ZScore FROM machine_downtime;


/* Outliers within 3*std dev*/
SELECT * FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Hydraulic_Pressure(bar)`- AVG(`Hydraulic_Pressure(bar)`) OVER())/STDDEV(`Hydraulic_Pressure(bar)`) OVER() as ZScore 
FROM machine_downtime) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

SELECT COUNT(*) FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,(`Hydraulic_Pressure(bar)`- AVG(`Hydraulic_Pressure(bar)`) OVER())/STDDEV(`Hydraulic_Pressure(bar)`) OVER() as ZScore FROM machine_downtime) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;



CREATE TABLE ol_hp AS
SELECT * FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,(`Hydraulic_Pressure(bar)`- AVG(`Hydraulic_Pressure(bar)`) OVER())/STDDEV(`Hydraulic_Pressure(bar)`) OVER() as ZScore FROM machine_downtime) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

SELECT COUNT(*) FROM ol_hp;

CREATE TABLE hpf AS
SELECT machine_downtime.*
FROM machine_downtime
LEFT JOIN ol_hp
ON machine_downtime.`Hydraulic_Pressure(bar)` = ol_hp.`Hydraulic_Pressure(bar)`
AND machine_downtime.Machine_ID = ol_hp.Machine_ID
AND machine_downtime.Assembly_Line_No = ol_hp.Assembly_Line_No
WHERE ol_hp.`Hydraulic_Pressure(bar)` IS NULL
OR ol_hp.Machine_ID IS NULL
OR ol_hp.Assembly_Line_No IS NULL;

SELECT COUNT(*) FROM hpf;

-- Outlier Analysis for column Coolant_Pressure(bar)
  SELECT 
(`Coolant_Pressure(bar)`- AVG(`Coolant_Pressure(bar)`) OVER())/STDDEV(`Coolant_Pressure(bar)`) OVER() as ZScore FROM hpf;

/* Outliers within 3*std dev*/
SELECT * FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Coolant_Pressure(bar)`- AVG(`Coolant_Pressure(bar)`) OVER())/STDDEV(`Coolant_Pressure(bar))`) OVER() as ZScore 
FROM hpf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

SELECT COUNT(*) FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,(`Coolant_Pressure(bar)`- AVG(`Coolant_Pressure(bar)`) OVER())/STDDEV(`Coolant_Pressure(bar)`) OVER() as ZScore FROM hpf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

CREATE TABLE ol_cp AS
SELECT * FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,(`Coolant_Pressure(bar)`- AVG(`Coolant_Pressure(bar)`) OVER())/STDDEV(`Coolant_Pressure(bar)`) OVER() as ZScore FROM hpf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

SELECT COUNT(*) FROM ol_cp;

CREATE TABLE cpf AS
SELECT hpf.*
FROM hpf
LEFT JOIN ol_cp
ON hpf.`Coolant_Pressure(bar)` = ol_cp.`Coolant_Pressure(bar)`
AND hpf.Machine_ID = ol_cp.Machine_ID
AND hpf.Assembly_Line_No = ol_cp.Assembly_Line_No
WHERE ol_cp.`Coolant_Pressure(bar)` IS NULL
OR ol_cp.Machine_ID IS NULL
OR ol_cp.Assembly_Line_No IS NULL;

SELECT COUNT(*) FROM cpf;

-- Outlier Analysis for column Air_System_Pressure(bar)
  SELECT 
(`Air_System_Pressure(bar)`- AVG(`Air_System_Pressure(bar)`) OVER())/STDDEV(`Air_System_Pressure(bar)`) OVER() as ZScore FROM cpf;

/* Outliers within 3*std dev*/
SELECT * FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Air_System_Pressure(bar)`- AVG(`Air_System_Pressure(bar)`) OVER())/STDDEV(`Air_System_Pressure(bar)`) OVER() as ZScore 
FROM cpf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

SELECT COUNT(*) FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Air_System_Pressure(bar)`- AVG(`Air_System_Pressure(bar)`) OVER())/STDDEV(`Air_System_Pressure(bar)`) OVER() as ZScore 
FROM cpf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

CREATE TABLE ol_ap AS
SELECT * FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Air_System_Pressure(bar)`- AVG(`Air_System_Pressure(bar)`) OVER())/STDDEV(`Air_System_Pressure(bar)`) OVER() as ZScore 
FROM cpf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

SELECT COUNT(*) FROM ol_ap;

CREATE TABLE apf AS
SELECT cpf.*
FROM cpf
LEFT JOIN ol_ap
ON cpf.`Air_System_Pressure(bar)` = ol_ap.`Air_System_Pressure(bar)`
AND cpf.Machine_ID = ol_ap.Machine_ID
AND cpf.Assembly_Line_No = ol_ap.Assembly_Line_No
WHERE ol_ap.`Air_System_Pressure(bar)` IS NULL
OR ol_ap.Machine_ID IS NULL
OR ol_ap.Assembly_Line_No IS NULL;

SELECT COUNT(*) FROM apf;

-- Outlier Analysis for column Coolant_Temperature
  SELECT 
(`Coolant_Temperature`- AVG(`Coolant_Temperature`) OVER())/STDDEV(`Coolant_Temperature`) OVER() as ZScore FROM apf;

/* Outliers within 3*std dev*/
SELECT * FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Coolant_Temperature`- AVG(`Coolant_Temperature`) OVER())/STDDEV(`Coolant_Temperature`) OVER() as ZScore 
FROM apf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

SELECT COUNT(*) FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Coolant_Temperature`- AVG(`Coolant_Temperature`) OVER())/STDDEV(`Coolant_Temperature`) OVER() as ZScore 
FROM apf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

/* NO OUTLIERS IN THIS COLUMN*/

-- Outlier Analysis for column Hydraulic_Oil_Temperature(Â°C)
  SELECT 
(`Hydraulic_Oil_Temperature(Â°C)`- AVG(`Hydraulic_Oil_Temperature(Â°C)`) OVER())/STDDEV(`Hydraulic_Oil_Temperature(Â°C)`) OVER() as ZScore FROM apf;

/* Outliers within 3*std dev*/
SELECT * FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Hydraulic_Oil_Temperature(Â°C)`- AVG(`Hydraulic_Oil_Temperature(Â°C)`) OVER())/STDDEV(`Hydraulic_Oil_Temperature(Â°C)`) OVER() as ZScore 
FROM apf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

SELECT COUNT(*) FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Hydraulic_Oil_Temperature(Â°C)`- AVG(`Hydraulic_Oil_Temperature(Â°C)`) OVER())/STDDEV(`Hydraulic_Oil_Temperature(Â°C)`) OVER() as ZScore 
FROM apf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

CREATE TABLE ol_hot AS
SELECT * FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Hydraulic_Oil_Temperature(Â°C)`- AVG(`Hydraulic_Oil_Temperature(Â°C)`) OVER())/STDDEV(`Hydraulic_Oil_Temperature(Â°C)`) OVER() as ZScore 
FROM apf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

SELECT COUNT(*) FROM ol_hot;

CREATE TABLE hotf AS
SELECT apf.*
FROM apf
LEFT JOIN ol_hot
ON apf.`Hydraulic_Oil_Temperature(Â°C)` = ol_hot.`Hydraulic_Oil_Temperature(Â°C)`
AND apf.Machine_ID = ol_hot.Machine_ID
AND apf.Assembly_Line_No = ol_hot.Assembly_Line_No
WHERE ol_hot.`Hydraulic_Oil_Temperature(Â°C)` IS NULL
OR ol_hot.Machine_ID IS NULL
OR ol_hot.Assembly_Line_No IS NULL;

SELECT COUNT(*) FROM hotf;

-- Outlier Analysis for column Spindle_Bearing_Temperature(Â°C)
  SELECT 
(`Spindle_Bearing_Temperature(Â°C)`- AVG(`Spindle_Bearing_Temperature(Â°C)`) OVER())/STDDEV(`Spindle_Bearing_Temperature(Â°C)`) OVER() as ZScore FROM hotf;

/* Outliers within 3*std dev*/
SELECT * FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Spindle_Bearing_Temperature(Â°C)`- AVG(`Spindle_Bearing_Temperature(Â°C)`) OVER())/STDDEV(`Spindle_Bearing_Temperature(Â°C)`) OVER() as ZScore 
FROM hotf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

SELECT COUNT(*) FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Spindle_Bearing_Temperature(Â°C)`- AVG(`Spindle_Bearing_Temperature(Â°C)`) OVER())/STDDEV(`Spindle_Bearing_Temperature(Â°C)`) OVER() as ZScore 
FROM hotf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

CREATE TABLE ol_sbt AS
SELECT * FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Spindle_Bearing_Temperature(Â°C)`- AVG(`Spindle_Bearing_Temperature(Â°C)`) OVER())/STDDEV(`Spindle_Bearing_Temperature(Â°C)`) OVER() as ZScore 
FROM hotf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

SELECT COUNT(*) FROM ol_sbt;

CREATE TABLE sbtf AS
SELECT hotf.*
FROM hotf
LEFT JOIN ol_sbt
ON hotf.`Spindle_Bearing_Temperature(Â°C)` = ol_sbt.`Spindle_Bearing_Temperature(Â°C)`
AND hotf.Machine_ID = ol_sbt.Machine_ID
AND hotf.Assembly_Line_No = ol_sbt.Assembly_Line_No
WHERE ol_sbt.`Spindle_Bearing_Temperature(Â°C)` IS NULL
OR ol_sbt.Machine_ID IS NULL
OR ol_sbt.Assembly_Line_No IS NULL;

SELECT COUNT(*) FROM sbtf;

-- Outlier Analysis for column Spindle_Vibration(Âµm)
  SELECT 
(`Spindle_Vibration(Âµm)`- AVG(`Spindle_Vibration(Âµm)`) OVER())/STDDEV(`Spindle_Vibration(Âµm)`) OVER() as ZScore FROM sbtf;

/* Outliers within 3*std dev*/
SELECT * FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Spindle_Vibration(Âµm)`- AVG(`Spindle_Vibration(Âµm)`) OVER())/STDDEV(`Spindle_Vibration(Âµm)`) OVER() as ZScore 
FROM sbtf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

SELECT COUNT(*) FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Spindle_Vibration(Âµm)`- AVG(`Spindle_Vibration(Âµm)`) OVER())/STDDEV(`Spindle_Vibration(Âµm)`) OVER() as ZScore 
FROM sbtf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

CREATE TABLE ol_sv AS
SELECT * FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Spindle_Vibration(Âµm)`- AVG(`Spindle_Vibration(Âµm)`) OVER())/STDDEV(`Spindle_Vibration(Âµm)`) OVER() as ZScore 
FROM sbtf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

SELECT COUNT(*) FROM ol_sv;

CREATE TABLE svf AS
SELECT sbtf.*
FROM sbtf
LEFT JOIN ol_sv
ON sbtf.`Spindle_Vibration(Âµm)` = ol_sv.`Spindle_Vibration(Âµm)`
AND sbtf.Machine_ID = ol_sv.Machine_ID
AND sbtf.Assembly_Line_No = ol_sv.Assembly_Line_No
WHERE ol_sv.`Spindle_Vibration(Âµm)` IS NULL
OR ol_sv.Machine_ID IS NULL
OR ol_sv.Assembly_Line_No IS NULL;

SELECT COUNT(*) FROM svf;

-- Outlier Analysis for column Tool_Vibration(Âµm)
  SELECT 
(`Tool_Vibration(Âµm)`- AVG(`Tool_Vibration(Âµm)`) OVER())/STDDEV(`Tool_Vibration(Âµm)`) OVER() as ZScore FROM svf;

/* Outliers within 3*std dev*/
SELECT * FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Tool_Vibration(Âµm)`- AVG(`Tool_Vibration(Âµm)`) OVER())/STDDEV(`Tool_Vibration(Âµm)`) OVER() as ZScore 
FROM svf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

SELECT COUNT(*) FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Tool_Vibration(Âµm)`- AVG(`Tool_Vibration(Âµm)`) OVER())/STDDEV(`Tool_Vibration(Âµm)`) OVER() as ZScore 
FROM svf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

CREATE TABLE ol_tv AS
SELECT * FROM
(SELECT `Date`,`Machine_ID`,`Assembly_Line_No`,`Hydraulic_Pressure(bar)`,`Coolant_Pressure(bar)`,
`Air_System_Pressure(bar)`,`Coolant_Temperature`,`Hydraulic_Oil_Temperature(Â°C)`,`Spindle_Bearing_Temperature(Â°C)`,
`Spindle_Vibration(Âµm)`,`Tool_Vibration(Âµm)`,`Spindle_Speed(RPM)`,`Voltage(volts)`,`Torque(Nm)`,`Cutting(kN)`,`Downtime`,
(`Tool_Vibration(Âµm)`- AVG(`Tool_Vibration(Âµm)`) OVER())/STDDEV(`Tool_Vibration(Âµm)`) OVER() as ZScore 
FROM svf) AS TABLE2
WHERE Zscore >2.57 or Zscore <-2.57;

SELECT COUNT(*) FROM ol_tv;

CREATE TABLE tvf AS
SELECT svf.*
FROM svf
LEFT JOIN ol_tv
ON svf.`Tool_Vibration(Âµm)` = ol_tv.`Tool_Vibration(Âµm)`
AND svf.Machine_ID = ol_tv.Machine_ID
AND svf.Assembly_Line_No = ol_tv.Assembly_Line_No
WHERE ol_tv.`Tool_Vibration(Âµm)` IS NULL
OR ol_tv.Machine_ID IS NULL
OR ol_tv.Assembly_Line_No IS NULL;

SELECT COUNT(*) FROM tvf;

RENAME TABLE tvf TO df;

/*HANDLING MISSING VALUES*/

SELECT SUM(
IsNull (Machine_ID))
FROM machine_downtime;

SELECT SUM(
IsNull (Assembly_Line_No))
FROM machine_downtime;

 SELECT SUM(
IsNull (`Hydraulic_Pressure(bar)`))
FROM machine_downtime;

SELECT SUM(
IsNull (`Coolant_Pressure(bar)`))
FROM machine_downtime;

SELECT SUM(
IsNull (`Air_System_Pressure(bar)`))
FROM machine_downtime;

SELECT SUM(
IsNull (`Coolant_Temperature`))
FROM machine_downtime;

SELECT SUM(
IsNull (`Hydraulic_Pressure(bar)`))
FROM machine_downtime;

SELECT SUM(
IsNull (`Hydraulic_Oil_Temperature(Â°C)`))
FROM machine_downtime;

SELECT SUM(
IsNull (`Spindle_Bearing_Temperature(Â°C)`))
FROM machine_downtime;

SELECT SUM(
IsNull (`Spindle_Vibration(Âµm)`))
FROM machine_downtime;

SELECT SUM(
IsNull (`Spindle_Speed(RPM)`))
FROM machine_downtime;

SELECT SUM(
IsNull (`Voltage(volts)`))
FROM machine_downtime;

SELECT SUM(
IsNull (`Torque(Nm)`))
FROM machine_downtime;

SELECT SUM(
IsNull (`Cutting(kN)`))
FROM machine_downtime;

SELECT SUM(
IsNull (`Downtime`))
FROM machine_downtime;

-- CONCLUSION : No Missing Values Found

/* EXPLORATORY DATA ANALYSIS*/

SELECT DISTINCT Machine_ID, Downtime, Count(*) from df group by Downtime,Machine_ID;

-- First Moment Decisions
-- Mean

SELECT
  AVG(`Hydraulic_Pressure(bar)`) AS mean_hp,
  AVG(`Coolant_Pressure(bar)`) AS mean_cp,
  AVG(`Air_System_Pressure(bar)`) AS mean_asp,
  AVG(`Coolant_Temperature`) AS mean_ct,
  AVG(`Hydraulic_Oil_Temperature(Â°C)`) AS mean_hot,
  AVG(`Spindle_Bearing_Temperature(Â°C)`) AS mean_sbt,
  AVG(`Spindle_Vibration(Âµm)`) AS mean_sv,
  AVG(`Tool_Vibration(Âµm)`) AS mean_tv,
  AVG(`Spindle_Speed(RPM)`) AS mean_ss,
  AVG(`Voltage(volts)`) AS mean_volt,
  AVG(`Torque(Nm)`) AS mean_torq,
  AVG(`Cutting(kN)`) AS mean_cut
FROM df;

-- Mode
SELECT
  `Hydraulic_Pressure(bar)` AS mode_hp
FROM df
GROUP BY `Hydraulic_Pressure(bar)`
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT
  `Coolant_Pressure(bar)` AS mode_cp
FROM df
GROUP BY `Coolant_Pressure(bar)`
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT
  `Air_System_Pressure(bar)` AS mode_asp
FROM df
GROUP BY `Air_System_Pressure(bar)`
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT
  `Coolant_Temperature` AS mode_ct
FROM df
GROUP BY `Coolant_Temperature`
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT
  `Hydraulic_Oil_Temperature(Â°C)` AS mode_hot
FROM df
GROUP BY `Hydraulic_Oil_Temperature(Â°C)`
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT
  `Spindle_Bearing_Temperature(Â°C)` AS mode_sbt
FROM df
GROUP BY `Coolant_Pressure(bar)`
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT
  `Tool_Vibration(Âµm)` AS mode_tv
FROM df
GROUP BY `Tool_Vibration(Âµm)`
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT
  `Spindle_Speed(RPM)` AS mode_ss
FROM df
GROUP BY `Spindle_Speed(RPM)`
ORDER BY COUNT(*) DESC
LIMIT 1;

-- SECOND MOMENT DECISIONS

SELECT 
    AVG(`Hydraulic_Pressure(bar)`) AS mean_hp,
    STDDEV_POP(`Hydraulic_Pressure(bar)`) AS `std_dev_Hydraulic_Pressure(bar)`,
    MIN(`Hydraulic_Pressure(bar)`) AS `min_Hydraulic_Pressure(bar)`,
    MAX(`Hydraulic_Pressure(bar)`) AS `max_Hydraulic_Pressure(bar)`,
    
    AVG(`Coolant_Pressure(bar)`) AS mean_cp,
    STDDEV_POP(`Coolant_Pressure(bar)`) AS `std_dev_cp`,
    MIN(`Hydraulic_Pressure(bar)`) AS `min_cp`,
    MAX(`Hydraulic_Pressure(bar)`) AS `max_cp`,
    
    AVG(`Air_System_Pressure(bar)`) AS mean_asp,
    STDDEV_POP(`Air_System_Pressure(bar)`) AS `std_dev_asp`,
    MIN(`Air_System_Pressure(bar)`) AS `min_asp`,
    MAX(`Air_System_Pressure(bar)`) AS `max_asp`,
    
    AVG(`Coolant_Temperature`) AS mean_ct,
    STDDEV_POP(`Coolant_Temperature`) AS `std_dev_ct`,
    MIN(`Coolant_Temperature`) AS `min_ct`,
    MAX(`Coolant_Temperature`) AS `max_ct`,
    
    AVG(`Spindle_Bearing_Temperature(Â°C)`) AS mean_sbt,
    STDDEV_POP(`Spindle_Bearing_Temperature(Â°C)`) AS `std_dev_sbt`,
    MIN(`Spindle_Bearing_Temperature(Â°C)`) AS `min_sbt`,
    MAX(`Spindle_Bearing_Temperature(Â°C)`) AS `max_sbt`,
    
    AVG(`Spindle_Vibration(Âµm)`) AS mean_sv,
    STDDEV_POP(`Spindle_Vibration(Âµm)`) AS `std_dev_sv`,
    MIN(`Spindle_Vibration(Âµm)`) AS `min_sv`,
    MAX(`Spindle_Vibration(Âµm)`) AS `max_sv`,
    
    AVG(`Tool_Vibration(Âµm)`) AS mean_tv,
    STDDEV_POP(`Tool_Vibration(Âµm)`) AS `std_dev_tv`,
    MIN(`Tool_Vibration(Âµm)`) AS `min_tv`,
    MAX(`Tool_Vibration(Âµm)`) AS `max_tv`,
    
    AVG(`Spindle_Speed(RPM)`) AS mean_ss,
    STDDEV_POP(`Spindle_Speed(RPM)`) AS `std_dev_ss`,
    MIN(`Spindle_Speed(RPM)`) AS `min_ss`,
    MAX(`Spindle_Speed(RPM)`) AS `max_ss`,
    
    AVG(`Voltage(volts)`) AS mean_volt,
    STDDEV_POP(`Voltage(volts)`) AS `std_dev_volt`,
    MIN(`Voltage(volts)`) AS `min_volt`,
    MAX(`Voltage(volts)`) AS `max_volt`,
    
    AVG(`Torque(Nm)`) AS mean_torq,
    STDDEV_POP(`Torque(Nm)`) AS `std_dev_torq`,
    MIN(`Torque(Nm)`) AS `min_torq`,
    MAX(`Torque(Nm)`) AS `max_torq`,
    
    AVG(`Cutting(kN)`) AS mean_cut,
    STDDEV_POP(`Cutting(kN)`) AS `std_dev_cut`,
    MIN(`Cutting(kN)`) AS `min_cut`,
    MAX(`Cutting(kN)`) AS `max_cut`
    FROM df;
    
    
    
 /* ANALYSIS FOR CAUSE OF FAILURE*/
 
 /*MACHINE-1 : Makino-L1-Unit1-2013*/
 
 -- Pressure Analysis
 
 SELECT
     AVG(`Hydraulic_Pressure(bar)`) AS mean_hp,
  AVG(`Coolant_Pressure(bar)`) AS mean_cp,
  AVG(`Air_System_Pressure(bar)`) AS mean_asp
  FROM df;
 
    SELECT 
AVG(`Hydraulic_Pressure(bar)`) AS Mean_hp_fail, AVG(`Coolant_Pressure(bar)`) AS Mean_cp_fail, AVG(`Air_System_Pressure(bar)`) AS Mean_asp_fail
FROM df
WHERE Machine_ID = 'Makino-L1-Unit1-2013' AND Downtime = 'Machine_Failure';

 SELECT 
AVG(`Hydraulic_Pressure(bar)`) AS Mean_hp_nofail, AVG(`Coolant_Pressure(bar)`) AS Mean_cp_nofail, AVG(`Air_System_Pressure(bar)`) AS Mean_asp_nofail
FROM df
WHERE Machine_ID = 'Makino-L1-Unit1-2013' AND Downtime = 'No_Machine_Failure';


-- Temperature Analysis

SELECT
AVG(`Coolant_Temperature`) AS mean_ct,
  AVG(`Hydraulic_Oil_Temperature(Â°C)`) AS mean_hot,
  AVG(`Spindle_Bearing_Temperature(Â°C)`) AS mean_sbt
  FROM df;
  
SELECT 
AVG(`Coolant_Temperature`) AS Mean_ct_fail, AVG(`Hydraulic_Oil_Temperature(Â°C)`) AS Mean_hot_fail, AVG(`Spindle_Bearing_Temperature(Â°C)`) AS Mean_sbt_fail
FROM df
WHERE Machine_ID = 'Makino-L1-Unit1-2013' AND Downtime = 'Machine_Failure';

SELECT 
AVG(`Coolant_Temperature`) AS Mean_ct_nofail, AVG(`Hydraulic_Oil_Temperature(Â°C)`) AS Mean_hot_nofail, AVG(`Spindle_Bearing_Temperature(Â°C)`) AS Mean_sbt_nofail
FROM df
WHERE Machine_ID = 'Makino-L1-Unit1-2013' AND Downtime = 'No_Machine_Failure';

-- Other Aspects

SELECT
AVG(`Spindle_Vibration(Âµm)`) AS mean_sv,
  AVG(`Tool_Vibration(Âµm)`) AS mean_tv,
  AVG(`Spindle_Speed(RPM)`) AS mean_ss,
  AVG(`Voltage(volts)`) AS mean_volt,
  AVG(`Torque(Nm)`) AS mean_torq,
  AVG(`Cutting(kN)`) AS mean_cut
  FROM df
  WHERE Machine_ID = 'Makino-L1-Unit1-2013';

SELECT 
AVG(`Spindle_Vibration(Âµm)`) AS Mean_sv_fail, AVG(`Spindle_Speed(RPM)`) AS Mean_ss_fail, AVG(`Voltage(volts)`) AS Mean_volt_fail,AVG(`Tool_Vibration(Âµm)`) AS Mean_tv_fail, AVG(`Torque(Nm)`) AS Mean_torq_fail, AVG(`Cutting(kN)`) AS Mean_cut_fail
FROM df
WHERE Machine_ID = 'Makino-L1-Unit1-2013' AND Downtime = 'Machine_Failure';

SELECT 
AVG(`Spindle_Vibration(Âµm)`) AS Mean_sv_nofail, AVG(`Spindle_Speed(RPM)`) AS Mean_ss_nofail, AVG(`Voltage(volts)`) AS Mean_volt_nofail,AVG(`Tool_Vibration(Âµm)`) AS Mean_tv_nofail, AVG(`Torque(Nm)`) AS Mean_torq_nofail, AVG(`Cutting(kN)`) AS Mean_cut_nofail
FROM df
WHERE Machine_ID = 'Makino-L1-Unit1-2013' AND Downtime = 'No_Machine_Failure';

-- INSIGHT : Reasons of failure
-- 1. Low Hydraulic Pressure
-- 2. High Coolant Temperature (over 19.5 units)
-- 3. Decrease in Torque (below 23 Nm)

/*MACHINE-2 : Makino-L2-Unit1-2015*/
 
 -- Pressure Analysis
 
 SELECT
     AVG(`Hydraulic_Pressure(bar)`) AS mean_hp,
  AVG(`Coolant_Pressure(bar)`) AS mean_cp,
  AVG(`Air_System_Pressure(bar)`) AS mean_asp
  FROM df
  WHERE Machine_ID = 'Makino-L2-Unit1-2015';
 
    SELECT 
AVG(`Hydraulic_Pressure(bar)`) AS Mean_hp_fail, AVG(`Coolant_Pressure(bar)`) AS Mean_cp_fail, AVG(`Air_System_Pressure(bar)`) AS Mean_asp_fail
FROM df
WHERE Machine_ID = 'Makino-L2-Unit1-2015' AND Downtime = 'Machine_Failure';

 SELECT 
AVG(`Hydraulic_Pressure(bar)`) AS Mean_hp_nofail, AVG(`Coolant_Pressure(bar)`) AS Mean_cp_nofail, AVG(`Air_System_Pressure(bar)`) AS Mean_asp_nofail
FROM df
WHERE Machine_ID = 'Makino-L2-Unit1-2015' AND Downtime = 'No_Machine_Failure';


-- Temperature Analysis

SELECT
AVG(`Coolant_Temperature`) AS mean_ct,
  AVG(`Hydraulic_Oil_Temperature(Â°C)`) AS mean_hot,
  AVG(`Spindle_Bearing_Temperature(Â°C)`) AS mean_sbt
  FROM df
  WHERE Machine_ID = 'Makino-L2-Unit1-2015';
  
SELECT 
AVG(`Coolant_Temperature`) AS Mean_ct_fail, AVG(`Hydraulic_Oil_Temperature(Â°C)`) AS Mean_hot_fail, AVG(`Spindle_Bearing_Temperature(Â°C)`) AS Mean_sbt_fail
FROM df
WHERE Machine_ID = 'Makino-L2-Unit1-2015' AND Downtime = 'Machine_Failure';

SELECT 
AVG(`Coolant_Temperature`) AS Mean_ct_nofail, AVG(`Hydraulic_Oil_Temperature(Â°C)`) AS Mean_hot_nofail, AVG(`Spindle_Bearing_Temperature(Â°C)`) AS Mean_sbt_nofail
FROM df
WHERE Machine_ID = 'Makino-L2-Unit1-2015' AND Downtime = 'No_Machine_Failure';

-- Other Aspects

SELECT
AVG(`Spindle_Vibration(Âµm)`) AS mean_sv,
  AVG(`Tool_Vibration(Âµm)`) AS mean_tv,
  AVG(`Spindle_Speed(RPM)`) AS mean_ss,
  AVG(`Voltage(volts)`) AS mean_volt,
  AVG(`Torque(Nm)`) AS mean_torq,
  AVG(`Cutting(kN)`) AS mean_cut
  FROM df
  WHERE Machine_ID = 'Makino-L2-Unit1-2015';

SELECT 
AVG(`Spindle_Vibration(Âµm)`) AS Mean_sv_fail, AVG(`Spindle_Speed(RPM)`) AS Mean_ss_fail, AVG(`Voltage(volts)`) AS Mean_volt_fail,AVG(`Tool_Vibration(Âµm)`) AS Mean_tv_fail, AVG(`Torque(Nm)`) AS Mean_torq_fail, AVG(`Cutting(kN)`) AS Mean_cut_fail
FROM df
WHERE Machine_ID = 'Makino-L2-Unit1-2015' AND Downtime = 'Machine_Failure';

SELECT 
AVG(`Spindle_Vibration(Âµm)`) AS Mean_sv_nofail, AVG(`Spindle_Speed(RPM)`) AS Mean_ss_nofail, AVG(`Voltage(volts)`) AS Mean_volt_nofail,AVG(`Tool_Vibration(Âµm)`) AS Mean_tv_nofail, AVG(`Torque(Nm)`) AS Mean_torq_nofail, AVG(`Cutting(kN)`) AS Mean_cut_nofail
FROM df
WHERE Machine_ID = 'Makino-L2-Unit1-2015' AND Downtime = 'No_Machine_Failure';

-- INSIGHT : Reasons of failure
-- 1. Low Hydraulic Pressure
-- 2. High Coolant Temperature (over 18 units)
-- 3. Decrease in Torque (below 23 Nm)

/*MACHINE-2 : Makino-L3-Unit1-2015*/
 
 -- Pressure Analysis
 
 SELECT
     AVG(`Hydraulic_Pressure(bar)`) AS mean_hp,
  AVG(`Coolant_Pressure(bar)`) AS mean_cp,
  AVG(`Air_System_Pressure(bar)`) AS mean_asp
  FROM df
  WHERE Machine_ID = 'Makino-L3-Unit1-2015';
 
    SELECT 
AVG(`Hydraulic_Pressure(bar)`) AS Mean_hp_fail, AVG(`Coolant_Pressure(bar)`) AS Mean_cp_fail, AVG(`Air_System_Pressure(bar)`) AS Mean_asp_fail
FROM df
WHERE Machine_ID = 'Makino-L3-Unit1-2015' AND Downtime = 'Machine_Failure';

 SELECT 
AVG(`Hydraulic_Pressure(bar)`) AS Mean_hp_nofail, AVG(`Coolant_Pressure(bar)`) AS Mean_cp_nofail, AVG(`Air_System_Pressure(bar)`) AS Mean_asp_nofail
FROM df
WHERE Machine_ID = 'Makino-L3-Unit1-2015' AND Downtime = 'No_Machine_Failure';


-- Temperature Analysis

SELECT
AVG(`Coolant_Temperature`) AS mean_ct,
  AVG(`Hydraulic_Oil_Temperature(Â°C)`) AS mean_hot,
  AVG(`Spindle_Bearing_Temperature(Â°C)`) AS mean_sbt
  FROM df
  WHERE Machine_ID = 'Makino-L3-Unit1-2015';
  
SELECT 
AVG(`Coolant_Temperature`) AS Mean_ct_fail, AVG(`Hydraulic_Oil_Temperature(Â°C)`) AS Mean_hot_fail, AVG(`Spindle_Bearing_Temperature(Â°C)`) AS Mean_sbt_fail
FROM df
WHERE Machine_ID = 'Makino-L3-Unit1-2015' AND Downtime = 'Machine_Failure';

SELECT 
AVG(`Coolant_Temperature`) AS Mean_ct_nofail, AVG(`Hydraulic_Oil_Temperature(Â°C)`) AS Mean_hot_nofail, AVG(`Spindle_Bearing_Temperature(Â°C)`) AS Mean_sbt_nofail
FROM df
WHERE Machine_ID = 'Makino-L3-Unit1-2015' AND Downtime = 'No_Machine_Failure';

-- Other Aspects

SELECT
AVG(`Spindle_Vibration(Âµm)`) AS mean_sv,
  AVG(`Tool_Vibration(Âµm)`) AS mean_tv,
  AVG(`Spindle_Speed(RPM)`) AS mean_ss,
  AVG(`Voltage(volts)`) AS mean_volt,
  AVG(`Torque(Nm)`) AS mean_torq,
  AVG(`Cutting(kN)`) AS mean_cut
  FROM df
  WHERE Machine_ID = 'Makino-L3-Unit1-2015';

SELECT 
AVG(`Spindle_Vibration(Âµm)`) AS Mean_sv_fail, AVG(`Spindle_Speed(RPM)`) AS Mean_ss_fail, AVG(`Voltage(volts)`) AS Mean_volt_fail,AVG(`Tool_Vibration(Âµm)`) AS Mean_tv_fail, AVG(`Torque(Nm)`) AS Mean_torq_fail, AVG(`Cutting(kN)`) AS Mean_cut_fail
FROM df
WHERE Machine_ID = 'Makino-L3-Unit1-2015' AND Downtime = 'Machine_Failure';

SELECT 
AVG(`Spindle_Vibration(Âµm)`) AS Mean_sv_nofail, AVG(`Spindle_Speed(RPM)`) AS Mean_ss_nofail, AVG(`Voltage(volts)`) AS Mean_volt_nofail,AVG(`Tool_Vibration(Âµm)`) AS Mean_tv_nofail, AVG(`Torque(Nm)`) AS Mean_torq_nofail, AVG(`Cutting(kN)`) AS Mean_cut_nofail
FROM df
WHERE Machine_ID = 'Makino-L3-Unit1-2015' AND Downtime = 'No_Machine_Failure';

-- INSIGHT : Reasons of failure
-- 1. Low Hydraulic Pressure
-- 2. High Coolant Temperature (over 18 units)
-- 3. Decrease in Torque (below 23.5 Nm)

