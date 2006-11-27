CREATE TABLE REGISTRATION_MASTER(
	SCHOOL_ID		NUMBER NOT NULL,
	REGISTRATION_ID		NUMBER,
	CLASS			VARCHAR2(10) NOT NULL,
	FNAME			VARCHAR2(40) NOT NULL,
	LNAME			VARCHAR2(40) NOT NULL,
	DATE_OF_BIRTH		DATE		NOT NULL,
	SEX			CHAR		NOT NULL,
	NAME_PLAY_SCHOOL	VARCHAR2(100),
	ENROLLED_SINCE		DATE,
	PER_ADD_LINE_1		VARCHAR2(50)	 NOT NULL,
	PER_ADD_LINE_2		VARCHAR2(50),
	PER_ADD_CITY		VARCHAR2(40) NOT NULL,
	PER_ADD_STATE		VARCHAR2(40) NOT NULL,
	PER_ADD_ZIP_CODE	NUMBER(10) NOT NULL,
	TEMP_ADD_LINE_1		VARCHAR2(50),
	TEMP_ADD_LINE_2		VARCHAR2(50),
	TEMP_ADD_CITY		VARCHAR2(40),
	TEMP_ADD_STATE		VARCHAR2(40),
	TEMP_ADD_ZIP_CODE	NUMBER,
	STD			NUMBER		 NOT NULL,
	TELEPHONE		NUMBER		 NOT NULL,
	MOBILE			NUMBER		 NOT NULL,
	EMAIL			VARCHAR2(100)	 NOT NULL,
	RECORD_DATE		DATE DEFAULT SYSDATE
);

CREATE SEQUENCE REGISTRATION_SEQ START WITH 1000 NOCACHE;

ALTER TABLE REGISTRATION_MASTER
ADD(
CONSTRAINT PK_REGISTRATIONID PRIMARY KEY (REGISTRATION_ID)
);

CREATE TABLE PARENT_DETAIL(
	REGISTRATION_ID		NUMBER NOT NULL,
	MOTHER_NAME		VARCHAR2(40) NOT NULL,
	MOTHER_DOB		DATE NOT NULL,
	MOTHER_QUALI		VARCHAR2(100), 
	MOTHER_LAST_INST	VARCHAR2(100),
	MOTHER_OCCUPATION	VARCHAR2(100),
	MOTHER_AREA_INTEREST	VARCHAR2(100),
	MOTHER_ANNUAL_INCOME	NUMBER ,
	MOTHER_ORG_NAME		VARCHAR2(100),
	MOTHER_OFF_ADD		VARCHAR2(100),
	MOTHER_PHONE		NUMBER NOT NULL,
	MOTHER_MOBILE		NUMBER(10),
	MOTHER_EMAIL		VARCHAR2(100),
	FATHER_NAME		VARCHAR2(40) NOT NULL,
	FATHER_DOB		DATE NOT NULL,
	FATHER_QUALI		VARCHAR2(100),
	FATHER_LAST_INST	VARCHAR2(100),
	FATHER_OCCUPATION	VARCHAR2(100),
	FATHER_AREA_INTEREST	VARCHAR2(100),
	FATHER_ANNUAL_INCOME	NUMBER,
	FATHER_ORG_NAME		VARCHAR2(100),
	FATHER_OFF_ADD		VARCHAR2(100),
	FATHER_PHONE		NUMBER NOT NULL,
	FATHER_MOBILE		NUMBER(10),
	FATHER_EMAIL		VARCHAR2(40),
	LIVE_IN			VARCHAR2(40) NOT NULL,
	SIBLINGS_CHILD		NUMBER NOT NULL,
	SCHOOL_APPLIED		VARCHAR2(200),
	JOINING_REASON		VARCHAR2(400),
	RECORD_DATE		DATE DEFAULT SYSDATE
);


ALTER TABLE PARENT_DETAIL
ADD(
	CONSTRAINT FK_REGISTRATION_ID  FOREIGN KEY (REGISTRATION_ID) REFERENCES REGISTRATION_MASTER(REGISTRATION_ID)
);


CREATE TABLE BROCHURE_ORDER(
	ORDER_ID		NUMBER NOT NULL,
	REGISTRATION_ID		NUMBER NOT NULL,
	PRICE			NUMBER NOT NULL,
	STATUS			VARCHAR2(40) NOT NULL,
	UPD_DATE		DATE
);

CREATE SEQUENCE BROCHURE_ORDER_SEQ START WITH 1 NOCACHE;

ALTER TABLE BROCHURE_ORDER
ADD(
CONSTRAINT PK_ORDERID PRIMARY KEY (ORDER_ID)
);

ALTER TABLE BROCHURE_ORDER
ADD(
	CONSTRAINT FK_BROCHURE_REGISTRATION_ID  FOREIGN KEY (REGISTRATION_ID) REFERENCES REGISTRATION_MASTER(REGISTRATION_ID)
);


ALTER TABLE BROCHURE_ORDER ADD LOCALE VARCHAR2(40); 
ALTER TABLE BROCHURE_ORDER ADD TRANSACTION_NUMBER NUMBER;
ALTER TABLE BROCHURE_ORDER ADD ACQUIRER_RESPONSE_CODE VARCHAR2(40);
ALTER TABLE BROCHURE_ORDER ADD QSI_RESP_CODE NUMBER;
ALTER TABLE BROCHURE_ORDER ADD QSI_RESP_CODE_DESC VARCHAR2(100);