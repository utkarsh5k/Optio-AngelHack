		
--database

drop database safelocality;
create database safelocality;

use safelocality;

--User table

CREATE TABLE `User` (
`UserId` BIGINT NULL AUTO_INCREMENT,
`UserName` VARCHAR(255) NULL,
`FirstName` VARCHAR(255) NULL,
`LastName` VARCHAR(255) NULL,
`Useremail` VARCHAR(255) NULL,
`UserPassword` VARCHAR(255) NULL,
PRIMARY KEY (`UserId`));

--select database


--User storedprocedure

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_createUser`(
    IN p_name VARCHAR(255),
    IN p_firstname VARCHAR(255),
    IN p_lastname   VARCHAR(255), 
    IN p_email VARCHAR(255),
    IN p_password VARCHAR(255)
)
BEGIN
    if ( select exists (select 1 from User where Useremail = p_email) ) THEN

        select 'User Exists !!';

    ELSE

        insert into User
        (
            UserName,
            FirstName,
            LastName,
            Useremail,
            UserPassword
        )
        values
        (
            p_name,
            p_firstname,
            p_lastname,
            p_email,
            p_password
        );

    END IF;
END$$
DELIMITER ;

--Validate Sign in
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_validateLogin`(
IN p_useremail VARCHAR(255)
)
BEGIN
    select * from User where Useremail = p_useremail;
END$$
DELIMITER;

--Coordinates Table

CREATE TABLE Coordinates(
    Loc_id BIGINT NULL AUTO_INCREMENT,
    Loc_name VARCHAR(255),
    Loc_lat Float,
    Loc_long Float,
    PRIMARY KEY (`Loc_id`)
);

CREATE TABLE LifeStyle(
    UserId BIGINT NULL,
    Loc_id BIGINT NULL,
    Water INT NULL,
    Electricity  INT NULL,
    Network_Availability  INT NULL,
    Cleanliness  INT NULL,
    Green_space  INT NULL,
    Local_Entertainment  INT NULL,
    NightLife INT NULL,
    Repairmen_avail  INT NULL,
    Education  INT NULL,
    Neighbourhood INT NULL,
    PRIMARY KEY(`UserId`),
    FOREIGN KEY(UserId) REFERENCES User(UserId),
    FOREIGN KEY(Loc_id) REFERENCES Coordinates(Loc_id)
);

CREATE TABLE Security(
    UserId BIGINT NULL,
    Loc_id BIGINT NULL,
    Theft BIGINT NULL,
    Violence BIGINT NULL,
    Harassment BIGINT NULL,
    PRIMARY KEY(`UserId`),
    FOREIGN KEY(UserId) REFERENCES User(UserId),
    FOREIGN KEY(Loc_id) REFERENCES Coordinates(Loc_id)  
);

--addStats PROCEDURE Lifestyle

DROP procedure IF EXISTS `sp_addStats`;
DELIMITER $$
CREATE PROCEDURE `sp_addStats`(
    IN p_userid INT,
    IN p_locid INT,
    IN p_water INT,
    IN p_electricty INT,
    IN p_network_availability INT,
    IN p_cleanliness INT,
    IN p_greenspace INT,
    IN p_local_Entertainment INT,
    IN p_nightlife INT,
    IN p_repairmen_avail INT,
    IN p_education INT,
    IN p_neighbourhood INT
)
BEGIN
    insert into LifeStyle (
        UserId,
        Loc_id,
        Water,
        Electricity,
        Network_Availability,
        Cleanliness,
        Green_space,
        Local_Entertainment,
        NightLife,
        Repairmen_avail,
        Education,
        Neighbourhood
    )
    values
    (
        p_userid,
        p_locid,
        p_water,
        p_electricty,
        p_network_availability,
        p_cleanliness,
        p_greenspace,
        p_local_Entertainment,
        p_nightlife,
        p_repairmen_avail,
        p_education,
        p_neighbourhood
    );
END$$

DELIMITER ;
;

--addStats Security PROCEDURE
DROP procedure IF EXISTS `sp_addStats_sec`;
DELIMITER $$
CREATE PROCEDURE `sp_addStats_sec`(
    IN p_userid INT,
    IN p_locid INT,
    IN p_theft INT,
    IN p_violence INT,
    IN p_harassment INT
)
BEGIN
    insert into safelocality(
        UserId,
        Loc_id,
        Theft,
        Violence,
        Harassment
        )
    values
    (
        p_userid,
        p_locid,
        p_theft,
        p_violence,
        p_harassment
    );
END$$
DELIMITER ;
;

--add Location 
DELIMITER $$
DROP procedure IF EXISTS `sp_addLoc`;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addLoc`(
    IN p_locname VARCHAR(255),
    IN p_lat  Float,
    IN p_lon  Float
)
BEGIN

        insert into Coordinates
        (
            Loc_name,
            Loc_lat,
            Loc_long
        )
        values
        (
            p_locname,
            p_lat,
            p_lon
        );
END$$
DELIMITER ;
 
--Insert commands
Insert into LifeStyle values(6,2,8,5,7,9,4,3,7,8,5,10);
Insert into Security values(4,2,2,8,5);
Insert into Security values(6,3,6,5,9);
Insert into Security values(7,1,8,7,10);
Insert into Security values(10,2,6,8,5);
Insert into Security values(11,3,5,7,10);
