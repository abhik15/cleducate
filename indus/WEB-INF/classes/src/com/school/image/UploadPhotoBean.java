package com.school.image;

import java.io.IOException;
import java.sql.*;
import com.cl.sql.PoolManager;
import java.util.Stack;
import javax.servlet.ServletException;
import oracle.jdbc.*;
import oracle.ord.im.OrdHttpUploadFile;
import oracle.ord.im.OrdImage;

public class UploadPhotoBean
{	
	private static final String EMPTY_IMAGE = "ordsys.ordimage.init()";
    private Connection conn;
    private OraclePreparedStatement stmt;
    private OracleResultSet rset;
	OrdImage image;
	OrdImage thumb;
	int schoolId;
	int schoolEnrollId;
	private String errmsg;
	PoolManager poolManager;

	OrdImage studentImage;
	OrdImage studentThumb;
	OrdImage fatherImage;
	OrdImage fatherThumb;
	OrdImage motherImage;
	OrdImage motherThumb;
	OrdImage guardianImage;
	OrdImage guardianThumb;
	OrdImage authorizedImage;
	OrdImage authorizedThumb;


	public boolean selectStudentPhoto(int schoolId,int schoolEnrollId)throws SQLException
    {
        try
		{
			poolManager=PoolManager.getInstance();
			conn=poolManager.getConnection("erp");

			if(conn == null) throw new SQLException("Connection is null");
		    stmt = (OraclePreparedStatement)conn.prepareStatement("SELECT SCHOOL_ID,SCHOOL_ENROLL_ID,STUDENT_IMAGE,STUDENT_THUMB,FATHER_IMAGE,FATHER_THUMB,MOTHER_IMAGE,MOTHER_THUMB,GUARDIAN_IMAGE,GUARDIAN_THUMB,AUTHORIZED_IMAGE,AUTHORIZED_THUMB FROM ERP.STUDENT_PHOTO WHERE SCHOOL_ID=? AND SCHOOL_ENROLL_ID=?");
			stmt.setInt(1, schoolId);
			stmt.setInt(2, schoolEnrollId);
		    rset = (OracleResultSet)stmt.executeQuery();
			if(rset.next())
			{
		        schoolId = rset.getInt(1);
			    schoolEnrollId = rset.getInt(2);
				studentImage = (OrdImage)rset.getORAData(3, OrdImage.getORADataFactory());
	            studentThumb = (OrdImage)rset.getORAData(4, OrdImage.getORADataFactory());
				fatherImage = (OrdImage)rset.getORAData(5, OrdImage.getORADataFactory());
			    fatherThumb = (OrdImage)rset.getORAData(6, OrdImage.getORADataFactory());
				motherImage = (OrdImage)rset.getORAData(7, OrdImage.getORADataFactory());
	            motherThumb = (OrdImage)rset.getORAData(8, OrdImage.getORADataFactory());
				guardianImage = (OrdImage)rset.getORAData(9, OrdImage.getORADataFactory());
			    guardianThumb = (OrdImage)rset.getORAData(10, OrdImage.getORADataFactory());
				authorizedImage = (OrdImage)rset.getORAData(11, OrdImage.getORADataFactory());
	            authorizedThumb = (OrdImage)rset.getORAData(12, OrdImage.getORADataFactory());
				return true;
			}
			else
			{
				stmt = (OraclePreparedStatement)conn.prepareStatement("SELECT * FROM STUDENT_NO_PHOTO");
				rset = (OracleResultSet)stmt.executeQuery();
				rset.next();
				studentImage = (OrdImage)rset.getORAData(1, OrdImage.getORADataFactory());
	            studentThumb = (OrdImage)rset.getORAData(2, OrdImage.getORADataFactory());
				fatherImage = (OrdImage)rset.getORAData(3, OrdImage.getORADataFactory());
			    fatherThumb = (OrdImage)rset.getORAData(4, OrdImage.getORADataFactory());
				motherImage = (OrdImage)rset.getORAData(5, OrdImage.getORADataFactory());
	            motherThumb = (OrdImage)rset.getORAData(6, OrdImage.getORADataFactory());
				guardianImage = (OrdImage)rset.getORAData(7, OrdImage.getORADataFactory());
			    guardianThumb = (OrdImage)rset.getORAData(8, OrdImage.getORADataFactory());
				authorizedImage = (OrdImage)rset.getORAData(9, OrdImage.getORADataFactory());
	            authorizedThumb = (OrdImage)rset.getORAData(10, OrdImage.getORADataFactory());
				return true;
			}
		}
		catch(Exception ex)
		{
			System.out.println("Exception is "+ ex);
			return false;
		}
		finally
		{
			poolManager.freeConnection("erp",conn);
			try{rset.close();}catch(Exception ex){}
			try{stmt.close();}catch(Exception ex){}
		}
		
    }

	public void insertNewPhoto(OrdHttpUploadFile ordhttpuploadfile, String imageField, int schoolEnrollId, int schoolId) throws SQLException, ServletException, IOException
    {
		OraclePreparedStatement oraclepreparedstatement= null;
		try
		{
			poolManager=PoolManager.getInstance();
			conn=poolManager.getConnection("erp");

		   //Checking Existing Photo
			PreparedStatement st = conn.prepareStatement("SELECT COUNT(*) FROM STUDENT_PHOTO WHERE SCHOOL_ENROLL_ID =? ");
			st.setInt(1, schoolEnrollId);
			ResultSet rs = st.executeQuery();
			rs.next();
			int recFound = rs.getInt(1);
			rs.close();
			st.close();

			if(recFound == 0)
			{
		// Insert New Photo
				oraclepreparedstatement = 	(OraclePreparedStatement)conn.prepareStatement("INSERT INTO STUDENT_PHOTO(SCHOOL_ID, SCHOOL_ENROLL_ID," +imageField+"_IMAGE,"+imageField+"_THUMB)  VALUES (?,?,ordsys.ordimage.init(),ordsys.ordimage.init())");
			    oraclepreparedstatement.setInt(1, schoolId);
				oraclepreparedstatement.setInt(2, schoolEnrollId);
			    oraclepreparedstatement.executeUpdate();
			    oraclepreparedstatement.close();
			}
			else
			{
				oraclepreparedstatement = (OraclePreparedStatement)conn.prepareStatement("UPDATE STUDENT_PHOTO SET " + imageField + "_IMAGE=ordsys.ordimage.init()," + imageField + "_THUMB=ordsys.ordimage.init() WHERE SCHOOL_ID=? AND SCHOOL_ENROLL_ID=?");
			    oraclepreparedstatement.setInt(1, schoolId);
				oraclepreparedstatement.setInt(2, schoolEnrollId);
			    oraclepreparedstatement.executeUpdate();
				oraclepreparedstatement.close();
			}

		//Inserting Actual Photo
	        oraclepreparedstatement = (OraclePreparedStatement)conn.prepareStatement("SELECT "+imageField+"_IMAGE,"+imageField+"_THUMB FROM STUDENT_PHOTO WHERE SCHOOL_ID=? AND SCHOOL_ENROLL_ID=? FOR UPDATE");
		    oraclepreparedstatement.setInt(1, schoolId);
			oraclepreparedstatement.setInt(2, schoolEnrollId);
			OracleResultSet oracleresultset = (OracleResultSet)oraclepreparedstatement.executeQuery();
	        if(!oracleresultset.next())
		        throw new ServletException("new row not found in table");
			image = (OrdImage)oracleresultset.getORAData(1, OrdImage.getORADataFactory());
	        thumb = (OrdImage)oracleresultset.getORAData(2, OrdImage.getORADataFactory());
	        oracleresultset.close();
		    oraclepreparedstatement.close();
			ordhttpuploadfile.loadImage(image);

			int width=image.getWidth();
			int height=image.getHeight();
			int thumbheight=0;
			int thumbwidth=0;
			if(width >= 300)
			{
				thumbheight=height/5;
				thumbwidth=width/5;
			}
			else
			{
				if(width >= 200 )
				{
					thumbheight=height/4;
					thumbwidth=width/4;
				}
				else
				{
					if(width >= 120)
					{					
						thumbheight=height/3;
						thumbwidth=width/3;
					}
					else
					{
						thumbheight = height/2;
						thumbwidth = width/2;
					}
				}
			}
			if(height > 450 || width > 450)
			{
				errmsg = "Image height and width should not exceed then 350 and 450";
				conn.rollback();
			}
			else
			{
				try
				{
//               empImage.process("fileFormat=" + getPreferredFormat(empImage.getContentFormat()));
				   image.processCopy("maxScale="+width+" "+height+" fileFormat=jfif",image);
	            }
		        catch(SQLException sqlexception) { }
				try
				{
					image.processCopy("maxScale="+thumbwidth+" "+thumbheight+" fileFormat=jfif", thumb);
		        }
			    catch(SQLException sqlexception1)
				{
					thumb.deleteContent();
					thumb.setContentLength(0);
			    } 			
				oraclepreparedstatement = (OraclePreparedStatement)conn.prepareStatement("UPDATE STUDENT_PHOTO SET "+imageField+"_IMAGE = ? , "+imageField+"_THUMB = ? WHERE SCHOOL_ID=? AND SCHOOL_ENROLL_ID=?");
		        oraclepreparedstatement.setORAData(1, image);
			    oraclepreparedstatement.setORAData(2, thumb);
				oraclepreparedstatement.setInt(3, schoolId);
				oraclepreparedstatement.setInt(4, schoolEnrollId);
			    oraclepreparedstatement.execute();
				oraclepreparedstatement.close();
				conn.commit();
			}
		}
		catch(Exception ex)
		{
			System.out.println("Exception is "+ ex);
		}
		finally
		{
			poolManager.freeConnection("erp",conn);
			try{stmt.close();}catch(Exception ex){}
		}


    }

	private String getPreferredFormat(String s)
    {
        int i;
        for(i = 0; Character.isDigit(s.charAt(i)); i++);
        if(i > 0 && Integer.parseInt(s.substring(0, i)) > 8)
            return "JFIF";
        else
            return "GIFF";
    }

	 public static final String escapeHtmlString(String s)
    {
        StringBuffer stringbuffer = new StringBuffer();
        for(int i = 0; i < s.length(); i++)
        {
            char c = s.charAt(i);
            switch(c)
            {
            case 60: // '<'
                stringbuffer.append("&lt;");
                break;

            case 62: // '>'
                stringbuffer.append("&gt;");
                break;

            case 38: // '&'
                stringbuffer.append("&amp;");
                break;

            case 34: // '"'
                stringbuffer.append("&quot;");
                break;

            case 32: // ' '
                stringbuffer.append("&nbsp;");
                break;

            default:
                stringbuffer.append(c);
                break;
            }
        }

        return stringbuffer.toString();
    }

	//	Student
	public OrdImage getStudentImage()
    {
        return studentImage;
    }
    public OrdImage getStudentThumb()
    {
        return studentThumb;
    }

	//	Father
	public OrdImage getFatherImage()
    {
        return fatherImage;
    }
    public OrdImage getFatherThumb()
    {
        return fatherThumb;
    }
	
	//	Mother
	public OrdImage getMotherImage()
    {
        return motherImage;
    }
    public OrdImage getMotherThumb()
    {
        return motherThumb;
    }
	
	//	Guardian
	public OrdImage getGuardianImage()
    {
        return guardianImage;
    }
    public OrdImage getGuardianThumb()
    {
        return guardianThumb;
    }
	
	//	Authorized
	public OrdImage getAuthorizedImage()
    {
        return authorizedImage;
    }
    public OrdImage getAuthorizedThumb()
    {
        return authorizedThumb;
    }
	
	public int getSchoolEnrollId()
    {
        return schoolEnrollId;
    }

	public void setSchoolEnrollId(int schoolEnrollId)
    {
        this.schoolEnrollId = schoolEnrollId;
    }
	public void setSchoolId(int schoolId)
    {
        this.schoolId = schoolId;
    }
	public void setErrorMsg(String value)
	{
		errmsg = value;
	}
	public String getErrorMsg()
	{
		return errmsg;
	}

}


